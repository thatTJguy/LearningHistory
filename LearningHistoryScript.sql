--Script for LearningHistory Project DB

/* USE master;
GO
--DELETE DB IF EXISTS -- COMMENT OUT IF YOU DO NOT WANT TO REMOVE DB
IF	DB_ID('LearningHistory') IS NOT NULL
BEGIN
	ALTER DATABASE LearningHistory SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE LearningHistory;
END;
GO */

CREATE DATABASE LearningHistory;
GO

USE LearningHistory;
GO

BEGIN TRANSACTION;
GO

CREATE SCHEMA REF;
GO

-- Reference SubjectSoftware
CREATE	TABLE REF.SubjectSoftware
(
	SubjectSoftware NVARCHAR(50) NOT NULL 
		PRIMARY KEY
);
INSERT INTO	REF.SubjectSoftware(SubjectSoftware)
VALUES
	('None'), ('Excel'), ('SSMS'), ('MySQL'), ('BigQuery'), ('Oracle'), ('Visio')
	, ('Power BI'), ('Tableau'), ('SSRS'), ('Visual Studio Code'), ('PyCharm'), ('Atom')
	, ('Jira'), ('Rstudio'), ('QuickBooks'), ('Microsoft Project'), ('Google Sheets'), ('Google BigQuery');

-- Reference SubjectCategory
CREATE TABLE REF.SubjectCategory
(
	SubjectCategory NVARCHAR(50) NOT NULL 
		PRIMARY KEY
);
INSERT INTO	REF.SubjectCategory(SubjectCategory)
VALUES
	('Spreadsheet Management'), ('Data Visualization'), ('Project Management'), ('SQL')
	, ('Data Analytics'), ('Data Management'), ('Data Science'), ('Data Engineering'), ('HRM');

-- Reference SubjectName
CREATE TABLE REF.SubjectName
(
	SubjectName NVARCHAR(50) NOT NULL 
		PRIMARY KEY
);
INSERT INTO	REF.SubjectName(SubjectName)
VALUES
	('SSRS'), ('IT Infrastructure Library'), ('Google Sheets'), ('Excel'), ('SQL'), ('Power BI'), ('Tableau'), ('Scrum'), ('Agile'), ('HR'), ('Onboarding'), ('Visio')
	, ('C++'), ('Python'), ('R'), ('Instructional Design'), ('Payroll'), ('SQL Server'), ('Microsoft Project'), ('Programming');

-- Subject (Unique makeup of the 3 referenced columns) (referenced columns must come from available rows in reference table)
CREATE	TABLE DIMSubject
(
	SubjectID		INT 		NOT NULL
		PRIMARY KEY,
	SubjectName		NVARCHAR(50)	NOT NULL
		REFERENCES REF.SubjectName(SubjectName),
	SubjectCategory		NVARCHAR(50)	NOT NULL
		REFERENCES REF.SubjectCategory(SubjectCategory),
	SubjectSoftware		NVARCHAR(50)	NOT NULL
		REFERENCES REF.SubjectSoftware(SubjectSoftware)
);
-- I will likely not use SubjectName and SubjectSoftware on the same visual without filtering (will play around with it of course)
INSERT INTO	DIMSubject (SubjectID, SubjectName, SubjectCategory, SubjectSoftware)
VALUES
(1, 'Instructional Design', 'HRM', 'None'),
(2, 'Agile', 'Project Management', 'None'),
(3, 'HR', 'HRM', 'None'),
(4, 'Payroll', 'HRM', 'QuickBooks'),
(5, 'Onboarding', 'HRM', 'None'),
(6, 'SQL Server', 'SQL', 'SSMS'),
(7, 'SSRS', 'Data Visualization', 'SSRS'),
(8, 'Power BI', 'Data Visualization', 'Power BI'),
(9, 'Visio', 'Project Management', 'Visio'),
(10, 'Power BI', 'Data Analytics', 'Power BI'),
(11, 'Excel', 'Spreadsheet Management', 'Excel'),
(12, 'Microsoft Project', 'Project Management', 'Microsoft Project'),
(13, 'Excel', 'Data Visualization', 'Excel'),
(14, 'Scrum', 'Project Management', 'None'),
(15, 'Python', 'Data Science', 'PyCharm'),
(16, 'Agile', 'Project Management', 'Jira'),
(17, 'Agile', 'Project Management', 'None'),
(18, 'R', 'Data Analytics', 'Rstudio'),
(19, 'SQL Server', 'Data Analytics', 'SSMS'),
(20, 'Tableau', 'Data Visualization', 'Tableau'),
(21, 'Google Sheets', 'Spreadsheet Management', 'Google Sheets'),
(22, 'Google BigQuery', 'SQL', 'Google BigQuery'),
(23, 'IT Infrastructure Library', 'Project Management', 'None'),
(24, 'C++', 'Programming', 'Atom');

-- Instructor table with 2-column constraint
CREATE	TABLE DIMInstructor
(
	InstructorID		INT		NOT NULL 
		PRIMARY KEY,
	InstructorName		NVARCHAR(80)	NOT NULL,
	InstructorCompany	NVARCHAR(50)	NOT NULL,
	CONSTRAINT UCInstructor UNIQUE (InstructorName, InstructorCompany)
);
INSERT INTO	DIMInstructor (InstructorID, InstructorName, InstructorCompany)
VALUES
(1, 'Tony', 'Google'),
(2, 'Microsoft', 'Microsoft'),
(3, 'Wade Fagen-Ulmschneider', 'University of Illinois (UIUC)'),
(4, 'Garrick Chow', 'LinkedIn Learning'),
(5, 'Doug Rose', 'Doug Enterprises, LLC'),
(6, 'Kelley O Connell', 'Leading Advantage, Inc'),
(7, 'Joanne Simon-Walters', 'Simplesense'),
(8, 'Bonnie Biafore', 'Montevista Solutions, Inc'),
(9, 'Jeff Toister', 'Toister Performance Solutions, Inc'),
(10, 'Adam Wilbert', 'CartoGaia'),
(11, 'Gini von Courter', 'TRIAD Consulting'),
(12, 'David Rivers', 'David Rivers Training & Consulting Corp'),
(13, 'Dennis Taylor', 'Taylor Associates'),
(14, 'Helen Wall', 'Rice University'),
(15, 'John David Ariansen', 'Madecraft'),
(16, 'Jennifer McBee', 'Independent Contractor'),
(17, 'Curt Frye', 'Microsoft'),
(18, 'Joshua Rischin', 'Axium Solutions'),
(19, 'Joseph Schmuller', 'University of North Florida'),
(20, 'Atlassian University', 'Atlassian University'),
(21, 'Josh Bersin', 'Bersin by Deloitte'),
(22, 'Bill Weinman', 'The BearHeart Group'),
(23, 'Ami Levin', 'Pluralsight'),
(24, 'Emma Saunders', 'Swiss Re'),
(25, 'Oz du Soleil', 'DataScopic'),
(26, 'Rishie', 'Google'),
(27, 'Ximena', 'Google'),
(28, 'Sally', 'Google'),
(29, 'Hallie', 'Google'),
(30, 'Ayanna', 'Google'),
(31, 'Kevin', 'Google'),
(32, 'Carrie', 'Google'),
(33, 'Angela Wick', 'BA-Cube.com'),
(34, 'David Pultorak', 'Pultorak & Associates')
;


-- LearningPlatform - connects 1-many to both fact tables
CREATE	TABLE DIMLearningPlatform
(
	LearningPlatformID NVARCHAR (2) NOT NULL PRIMARY KEY
	, LearningPlatformName NVARCHAR (70) NOT NULL
);
INSERT INTO	DIMLearningPlatform (LearningPlatformID, LearningPlatformName)
VALUES
('LL', 'LinkedIn Learning'),
('Co', 'Coursera'),
('NA', 'Not Applicable') 
;


-- LearningPathInfo FACT table
CREATE	TABLE FACTLearningPathInfo 
(
	LearningPathInfoID INT NOT NULL PRIMARY KEY
	, LearningPathName NVARCHAR (70) NOT NULL
	, CourseCount INT NOT NULL
	, ProCert NCHAR (1) NOT NULL
	CHECK (ProCert IN ('Y', 'N'))
	, LearningPathDurationMinutes INT NOT NULL
	, LearningPlatformID NVARCHAR (2) NOT NULL 
	FOREIGN KEY REFERENCES DIMLearningPlatform(LearningPlatformID)
);
INSERT INTO	FACTLearningPathInfo (LearningPathInfoID, LearningPathName, CourseCount, ProCert, LearningPathDurationMinutes, LearningPlatformID)
VALUES
(0, 'None', 0, 'N', 0, 'NA'),
(1, 'Master Microsoft Power BI', 6, 'N', 899, 'LL'),
(2, 'Master Microsoft Excel', 8, 'N', 1500, 'LL'),
(3, 'Master Agile Software Development', 33, 'N', 2580, 'LL'),
(4, 'Become a Data Analyst', 13, 'N', 2400, 'LL'),
(5, 'Become an Agile Project Manager', 9, 'N', 634, 'LL'),
(6, 'Google Data Analytics Specialization', 8, 'Y', 11280, 'Co'),
(7, 'Master Dashboards and Data Viz in Power BI', 4, 'N', 663, 'LL'),
(8, 'Microsoft Azure Data Engineering Associate (DP-203)', 10, 'Y', 7020, 'Co'),
(9, 'Master SQL Development', 5, 'N', 604, 'LL'),
(10, 'Accelerated Computer Science Fundamentals Specialization', 3, 'N', 3660, 'Co');

-- DIMLearningPath-- 1 to 1 from FACTLearningPathInfo 
CREATE TABLE DIMLearningPath
(
	LearningPathID INT NOT NULL PRIMARY KEY,
	LearningPathInfoID INT NOT NULL
	FOREIGN KEY REFERENCES FACTLearningPathInfo(LearningPathInfoID)
);
INSERT INTO	DIMLearningPath (LearningPathID, LearningPathInfoID)
VALUES
(0,0),
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

-- Main FACT table
CREATE	TABLE FACTCourses
(
	CourseID			INT			NOT NULL
	PRIMARY KEY
	, CourseName			NVARCHAR(100)		NOT NULL
	, DateCompleted			DATE			NOT NULL
	, SubjectID			INT		NOT NULL
	, LearningPathID		INT			NOT NULL
	FOREIGN KEY REFERENCES DIMLearningPath(LearningPathID)
	, LearningPlatformID 	NVARCHAR(2)			NOT NULL
	FOREIGN KEY REFERENCES DIMLearningPlatform(LearningPlatformID)
	, InstructorID			INT			NOT NULL
	FOREIGN KEY REFERENCES DIMInstructor(InstructorID)
	, CourseDurationMinutes 	INT			NOT NULL
	, MyTimeEstMultiplier 		DECIMAL(2,1)		NOT NULL
);
INSERT INTO	FACTCourses (CourseID, CourseName, DateCompleted, SubjectID, LearningPathID, LearningPlatformID, InstructorID, CourseDurationMinutes, MyTimeEstMultiplier)
VALUES
  
(1, 'Foundations: Data, Data, Everywhere', CAST('2021-09-17' AS DATE), 21, 6, 'Co', 1, 1320, 0.6),
(2, 'Ask Questions to Make Data-Driven Decisions', CAST('2022-03-22' AS DATE), 21, 6, 'Co', 27, 1260, 0.8),
(3, 'Prepare Data for Exploration', CAST('2022-04-01' AS DATE), 22, 6, 'Co', 29, 1500, 0.8),
(4, 'Process Data from Dirty to Clean', CAST('2022-04-09' AS DATE), 22, 6, 'Co', 28, 1440, 0.8),
(5, 'Analyze Data to Answer Questions', CAST('2022-04-13' AS DATE), 22, 6, 'Co', 30, 1560, 0.8),
(6, 'Share Data Through the Art of Visualization', CAST('2022-04-24' AS DATE), 20, 6, 'Co', 31, 1440, 1.0),
(7, 'Data Analysis with R Programming', CAST('2022-05-06' AS DATE), 18, 6, 'Co', 32, 2220, 1.0),
(8, 'Google Data Analytics Capstone: Complete a Case Study', CAST('2022-06-30' AS DATE), 19, 6, 'Co', 26, 540, 1.0),
(9, 'Instructional Design: Creating Video Training', CAST('2020-11-07' AS DATE), 1, 0, 'LL', 4, 71, 1.0),
(10, 'Agile Foundations', CAST('2021-07-13' AS DATE), 2, 3, 'LL', 5, 95, 1.0),
(11, 'Transitioning from Waterfall to Agile Project Management', CAST('2021-07-15' AS DATE), 2, 3, 'LL', 6, 40, 1.0),
(12, 'Certification Prep: SHRM-CP', CAST('2022-10-30' AS DATE), 3, 0, 'LL', 7, 152, 1.0),
(13, 'QuickBooks Payroll Essential Training', CAST('2022-04-15' AS DATE), 4, 0, 'LL', 8, 85, 1.0),
(14, 'Human Resources: Running Company Onboarding', CAST('2022-04-04' AS DATE), 5, 0, 'LL', 9, 42, 1.0),
(15, 'Microsoft SQL Server 2019 Essential Training', CAST('2022-05-20' AS DATE), 6, 0, 'LL', 10, 264, 1.2),
(16, 'SQL Server: Reporting Services', CAST('2022-05-25' AS DATE), 7, 0, 'LL', 10, 210, 1.2),
(17, 'Querying Microsoft SQL Server 2019', CAST('2022-05-22' AS DATE), 6, 0, 'LL', 10, 161, 1.4),
(18, 'Power BI Essential Training', CAST('2022-07-11' AS DATE), 10, 0, 'LL', 11, 204, 1.0),
(19, 'Implementing a Data Warehouse SQL Server 2019', CAST('2022-08-20' AS DATE), 6, 0, 'LL', 10, 127, 1.2),
(20, 'Visio 2019 Essential Training', CAST('2022-09-12' AS DATE), 9, 0, 'LL', 12, 82, 1.0),
(21, 'Advanced Microsoft Power BI', CAST('2022-10-02' AS DATE), 10, 1, 'LL', 14, 193, 2.0),
(22, 'Excel Essential Training (Office 365/Microsoft 365)', CAST('2022-10-02' AS DATE), 11, 2, 'LL', 13, 137, 1.0),
(23, 'Learning Microsoft Project', CAST('2022-09-11' AS DATE), 12, 0, 'LL', 8, 55, 1.0),
(24, 'Power BI Data Modeling with DAX', CAST('2022-08-04' AS DATE), 10, 1, 'LL', 11, 82, 1.7),
(25, 'Power BI Data Methods', CAST('2022-08-09' AS DATE), 10, 1, 'LL', 14, 236, 1.4),
(26, 'Power BI Dataflows Essential Training', CAST('2022-08-10' AS DATE), 10, 1, 'LL', 14, 88, 1.3),
(27, 'Power BI Top Skills', CAST('2022-08-18' AS DATE), 10, 1, 'LL', 15, 60, 1.0),
(28, 'Power BI: Integrating AI and Machine Learning', CAST('2022-10-18' AS DATE), 10, 1, 'LL', 14, 238, 2.2),
(29, 'Cert Prep: Excel Expert - Microsoft Office Specialist for Office 2019 and Office 365', CAST('2022-06-29' AS DATE), 11, 2, 'LL', 16, 283, 1.0),
(30, 'Excel: PivotTables in Depth', CAST('2022-08-11' AS DATE), 11, 2, 'LL', 17, 230, 1.0),
(31, 'Cert Prep: Excel Associate - Microsoft Office Specialist for Office 2019 and Office 365', CAST('2022-10-20' AS DATE), 11, 2, 'LL', 16, 214, 0.8),
(32, 'Power BI: Dashboards for Beginners', CAST('2022-10-24' AS DATE), 8, 7, 'LL', 18, 33, 0.7),
(33, 'Power BI Data Visualization and Dashboard Tips, Tricks, & Techniques', CAST('2022-10-24' AS DATE), 8, 7, 'LL', 24, 119, 1.0),
(34, 'Excel: Advanced Formulas and Functions', CAST('2022-01-31' AS DATE), 11, 2, 'LL', 13, 287, 2.5),
(35, 'Excel Statistics Essential Training: 1', CAST('2022-10-19' AS DATE), 11, 4, 'LL', 19, 217, 1.2),
(36, 'Excel: Creating a Basic Dashboard', CAST('2022-10-17' AS DATE), 13, 2, 'LL', 17, 66, 0.5),
(37, 'Cert Prep: Scrum Master', CAST('2022-10-15' AS DATE), 14, 3, 'LL', 6, 86, 1.2),
(38, 'People Analytics', CAST('2022-02-18' AS DATE), 3, 0, 'LL', 21, 35, 1.0),
(39, 'Python Essential Training', CAST('2022-10-31' AS DATE), 15, 0, 'LL', 22, 277, 1.5),
(40, 'Excel: Advanced Formatting Techniques', CAST('2022-10-31' AS DATE), 13, 2, 'LL', 25, 162, 0.9),
(41, 'Advanced SQL: Logical Query Processing, Part 1', CAST('2022-10-30' AS DATE), 6, 9, 'LL', 23, 98, 1.2),
(42, 'Agile Project Management with Jira Cloud: 1 Projects, Boards, and Issues', CAST('2022-10-27' AS DATE), 16, 0, 'LL', 20, 73, 1.0),
(43, 'Object-Oriented Data Structures in C++', CAST('2022-07-25' AS DATE), 17, 10, 'Co', 3, 1260, 1.0),
(44, 'Excel: Charts in Depth', CAST('2022-11-01' AS DATE), 13, 2, 'LL', 13, 165, 1.0),
(45, 'Agile Requirements Foundations', CAST('2022-11-01' AS DATE), 2, 3, 'LL', 33, 103, 1.2),
(46, 'Learning ITIL', CAST('2022-11-03' AS DATE), 23, 0, 'LL', 34, 79, 1.3),
(47, 'Data Dashboards in Power BI', CAST('2022-11-07' AS DATE), 8, 7, 'LL', 14, 292, 1.1);

COMMIT TRANSACTION;
