Return-Path: <kvm+bounces-48832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4609EAD4174
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A07417C484
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2831247294;
	Tue, 10 Jun 2025 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cewzaJ5S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A068245028;
	Tue, 10 Jun 2025 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578442; cv=fail; b=dOUXCbrKZg4ThHoZ10j6X3AR0QTKOeAqqTLwa78FMAI4dVPGAy5iXVgRFYkjubgQhOfzqIrlNKhdLrpAPDetecln4BeA7Nvg4abmnjFrG6hF49TywopUqJVSisam0ilux+6pUUBaiRo+OMVWZ2Kgn93ZVTBHlE9GOnHpwdb914I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578442; c=relaxed/simple;
	bh=OS+1F7+813CldFbQDj8JCzJP1WORriiP3QQoaJbhJp4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3S+2HSeNkBjVU4zKzBuq1jgbJR9cw1Q4U8n3b05VzuMKViZhnTzmpW8/SaLoEv6+7JGpCJ6fDwKXZiTgYXB8QFwJANHhdMyrVKRdlhGTXCXU6K3UEfZouh+gq8yh1x0sWFSZYzUrwf6gFGLe4f1Uc9f2NOk7IPZxvxpg7ZVMDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cewzaJ5S; arc=fail smtp.client-ip=40.107.237.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JWXX/OO9ep/Fb0Hu+bLMSip1heg00sQ1Mwq3ZO6It660HPSX7i8J/hLuhGoFnWgAhTpqfyWticNKwWE7ou8lcHQcBdwJdmEtc2TW5G7HJAesl4/kaNjVMyHmk12EhWh1uvx4pPAn4u+dW2MD9cOkyIo1fd5Mv7p6iIi6HIN27nL0yyArk/ICAXZQfvxt8IsmAYWFB8JIDQqPOZmcxhtEAgy2/O6/697MPpKX30mVIl06ytD6cXqkHyBuKoZBtJ/3VN2vICxOPKElNt2rib0qgKmJE3yfT716n/uW2ifC4XEB2TCsLW5E3Zc/GhqN1Q+tLDHPqDidiq8vYeR2ZiIumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFakHNpI5ttrTrk+OVjQxrIVaLiDpysc0qqSYWtSmeI=;
 b=ozLHXjzF772DWtPqwb8TcZKz/ZnpCh6htkqLupYhLwfulGkLtEr8DOzyA8UT9Xf4OT71tZ4PXFu0hIhZXguqCwo8weavNjvZ48GKR1IEaJXerZfrsHU0HKCrOALZiN6fRapBZpEfhUqzYGk0Ye9xcgaOEItIafVsREJ2bG/haViIcEtl49/ENoW6Am5ByBEwH4Hu9StL+H5zRKWTxddWEA086/pGKLEQgp7mPHrIVdJaoe+Nu7+DuD6RDFngc0xoZr4azclAFngyaTIfOxJMdYvg5a5eoZh2pptojVuC9n++LI0xArlnTrcMTQiVmH3cyKvgzz30MaibKWKN21/jRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFakHNpI5ttrTrk+OVjQxrIVaLiDpysc0qqSYWtSmeI=;
 b=cewzaJ5Syd/NL0n0Mn7QXoQeeRhyyD6QMWp6e1qoMhlp7UqVJTccefsjuF2eR3FW1zauFNk8O2L7dGgtdmmWTKIMM9uwmy8FPZsfqC9p2lhN5e1EqpPefOvyF8HEf36rh3hhVwgVgaofEWJThqT2I4SXd9GxkSdTn9VWr6J1MjM=
Received: from BL1PR13CA0420.namprd13.prod.outlook.com (2603:10b6:208:2c2::35)
 by DS4PR12MB9586.namprd12.prod.outlook.com (2603:10b6:8:27e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:00:34 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::81) by BL1PR13CA0420.outlook.office365.com
 (2603:10b6:208:2c2::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.17 via Frontend Transport; Tue,
 10 Jun 2025 18:00:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:00:34 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:00:26 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 16/37] x86/apic: Rename 'reg_off' to 'reg'
Date: Tue, 10 Jun 2025 23:24:03 +0530
Message-ID: <20250610175424.209796-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|DS4PR12MB9586:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6a3e49-bea2-4d59-b2bd-08dda848b29c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DacfypBBrw35iMMwuR9KFBmD+3weG7soD+sp72H/JsVtRCMgQgfzWGgJXGkb?=
 =?us-ascii?Q?t/XI5G8E83L6PfJa/5cl5w1gxu+PGvRcz/OTDRf91B/IR2RaCrm35P6vGE0j?=
 =?us-ascii?Q?wungbThMm6FSHVWNlbPh4OIyLO/esvTjI+GnuATN+e+tOnE1YZtH2jD8slzp?=
 =?us-ascii?Q?aI6TFU356cWM8xfmg9Qsn7als/2xOsiBxRMNVwAM6zxG5HY95dMNLJLsciaN?=
 =?us-ascii?Q?3MBaSb04sEJH9QxLxUD482aVQspfj/hTm86EYMxWbx9O6QPIFq+4jdp20IZ5?=
 =?us-ascii?Q?9DF+TCJOdSQSt6ZcWLCNTjngFMhZ0y4Lg0/MPmMhVYuWkJ3FXyw3n8Qiv/aC?=
 =?us-ascii?Q?MOvPtuyWCB4GrVxq4ZQCLFTgTLZ2GwhrbDXdYx6mA8EOAM9kM9v8alsPiAJg?=
 =?us-ascii?Q?aZ9oaNrzslby+NBlMuBpnIFKNIYtpHmGMh9knlafkMisAFSr2kzpyiC/1Q9n?=
 =?us-ascii?Q?ovVZ2cJxBFHVneQ6uAmXm1LEcXvNvwE3LcWJXa9CSnSVUUaOYFW80iUJgj4W?=
 =?us-ascii?Q?CeLrWRiMDZet9oA4KQ4YDq6IClc17VP39EDoHEao+RWj/XF5xOLwyVNW3XEO?=
 =?us-ascii?Q?IeSAlRgNpi2V3ZzysBvFt12UaUXHMysuERtGXkZj8ZZOgpWhTBNfHOaD8KiF?=
 =?us-ascii?Q?9xA4bkXV84YKTdz6ZRQgfU55nDi5VRcVl79MXVCcM4akPG7XuXaDNR62PL2x?=
 =?us-ascii?Q?N2n/iEmyDUWA3vM+EJh2MX+TwlMyppUj8X+e+w+ywPN1knqe3veLQ5nkEWsP?=
 =?us-ascii?Q?rzHc6y6U5+/vHWsaQTvEin3LRaUyngyMJytGVDOEeMbE74UvAzHtBkBRl8cN?=
 =?us-ascii?Q?RCVE5jxCka6uTE7Pyikx++wcsZJr6ouScaKegOdeKarGj6s2I92M/hUkYs2q?=
 =?us-ascii?Q?bmRUTVecDSGaBfA566tXwJMCgj/h1XHr5ZW8/owimf95bMF7bLkZOvXk3GSD?=
 =?us-ascii?Q?KWZjo+9u/9mowKsysZFSfdnLpufAafhvbUw2cFa8a0UTlRMyvPYl0b+EPgqV?=
 =?us-ascii?Q?UR+2WjgjbIBjc8VKteD5I7lXNHXHTxkz0MA1kvbuyW8yhfYF237sZtJ2Ce9G?=
 =?us-ascii?Q?hB7eQN6uXPZ1MjYe2GPO5Q7AoH28EI+Byf7Bdmc7C5H86cvYqeeEPqlMmX85?=
 =?us-ascii?Q?l6fiFAmjaanHAdIic8+l10X7IEPKBKF4ox5cGYp3o9gffkNWTH5S5THU+4cY?=
 =?us-ascii?Q?lswgZ6ZBCkcMekJXyUAMe2wGmPT8pk+e7vdunj9bRxDRlRn6iyK07y6FRdH5?=
 =?us-ascii?Q?xZcOYTp6noYd3+qY3XBSKSijb5xJd1tuuZ6iltVQJ0vTkh4+YpdXzrBks+iR?=
 =?us-ascii?Q?ymdHzQydDQi56NxuAShhaPyHpVL2UDDD5CSibN5J25INHn/sA6xch/B4b4Im?=
 =?us-ascii?Q?dSNu1jJaqYGmt4Y9PXEPm5IHDywiyjoelNWfOpzlE2WmcSFUXoHWgOQrcMzM?=
 =?us-ascii?Q?mtVp2T3kUDEO6R/YwZSeMOhbrlH869YgQOB1oAtXj7CVm0xCkmm/DHS7eOa+?=
 =?us-ascii?Q?THzOCVaG08GMSCk/yX44ucRTz246vaqiBBT4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:00:34.3764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6a3e49-bea2-4d59-b2bd-08dda848b29c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9586

Rename the 'reg_off' parameter of apic_{set|get}_reg() to 'reg' to
match other usages in apic.h.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
---
Changes since v6:

 - Added Tianyu's Reviewed-by.

 arch/x86/include/asm/apic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 34e9b43d8940..07ba4935e873 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,14 +525,14 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
-static inline u32 apic_get_reg(void *regs, int reg_off)
+static inline u32 apic_get_reg(void *regs, int reg)
 {
-	return *((u32 *) (regs + reg_off));
+	return *((u32 *) (regs + reg));
 }
 
-static inline void apic_set_reg(void *regs, int reg_off, u32 val)
+static inline void apic_set_reg(void *regs, int reg, u32 val)
 {
-	*((u32 *) (regs + reg_off)) = val;
+	*((u32 *) (regs + reg)) = val;
 }
 
 static __always_inline u64 apic_get_reg64(void *regs, int reg)
-- 
2.34.1


