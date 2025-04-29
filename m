Return-Path: <kvm+bounces-44708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F910AA032A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 292787B3826
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E061D29DB61;
	Tue, 29 Apr 2025 06:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HCRZ6gdA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944CC27CB0D;
	Tue, 29 Apr 2025 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907519; cv=fail; b=EdRYWeIs6uqJr/uJNGAp2C74sjmSLYyybJmaE8Ywjqltvhqw89yKXzULPzdLxGnyrUFV6x+UJtLDdwe2DSZ8uguv1NvnO4lJO+vQPyoQ09EpqHd5FOKeAPu1IltyjOWriYgq/sveAeNtLkz3Xgg4hAt3FThRDsLSCPsgWa3xhlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907519; c=relaxed/simple;
	bh=xjko/FTzFuviV9UTBy5BL79v8mB3wi9jZXj57smE8w4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzpMZ3HAwkpH5PmAdQLnM3MbA0oDvlpwCu1RrkPzxg3fk5C2JS4rDGeIOfdRm7pgaG0Lo0ViniTuPJD3QmLEHIMa0BFr0Bq8HEZttRHMMWz6eEGJOZUeSNIEKnYiSN6XPwdq99BrdZQ3dJnqmpGTiKnVyYCYEUABJq76WYGsexw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HCRZ6gdA; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0kSeJ1PbbpWQYymlrTIc9rD+Mn9WhP6PHhoqLsi2tA510f9mWC4FmlzGLBa7ZWBlblGqNLzurTBFSfJz3QHml+/zq4Bxk5oahLawxa8wuu/Zn1M+0LI1QiEsrU7nMLsFrtYLNWkwLoqiRlD6evSGsduTPtOPdsDXzOWi4EQWWHhhL2D61CSyFg8cSPxdW+mXfTcNeDtsPmUF9M7irc3xny51YbuaN6Y1ljzAHpVdkDcGrqMcQPMuI3ZR7zENVPh6ZH1srtw3OUMDLmdBDOp3thXqM4SuhSRc9ZUeuhvKSVhtp0Vhbpd7i4MGTpGc1fKqF+Ha0kHTZUS0mZxHpRt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcXKAWMRCNpxrJVxK7t7TP9oh5AhMPrkXgfznXTW+0U=;
 b=ajvtzqW+W6S3TheKm4ksf1P1tk9l8ohw4M0W0I44yloc6kAYJFBRcIrhXmGCzsnvL15rOZWQm/jfq4UH32AXDsmYKNfT5jjWjKOcreOfpHVkYNB/A2mckxyNBG6hZ6nCFMwKBxPxOkNzX2I9mhkYn5uLXEhofo908yByCCzRd/sZpMGoKAavM4DC3c8JGYQl26Pav1IbGA+8RVa6Ir50MAwMLrN+YN+NfWfiUAufqjLEdcRImUO4lmqOUd0ZyPR0+n8C6xSdKjIwz2asvuJX8uIVaKeoKJW1hwfP6s1a1fZeJHDjI2yjXUg9ewM/dktgImaMhCa5N9hBjpAk9Gjl2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcXKAWMRCNpxrJVxK7t7TP9oh5AhMPrkXgfznXTW+0U=;
 b=HCRZ6gdA3cVxT7Tt1ZQql/y/z4UecUyYM7T8zKVnACs4PL4FFojkrtXmjm5QBSWer1UUE29yBxNme8o5gUeStShVSjyXGFSH90g3kUgLs9Ttpf+g7DhLHfwy5teSJvnnBI3I0mPWfwO3U2lMkZZGx1SUiCO7WedSc8kYktvjRLk=
Received: from CH2PR20CA0027.namprd20.prod.outlook.com (2603:10b6:610:58::37)
 by BL4PR12MB9536.namprd12.prod.outlook.com (2603:10b6:208:590::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:18:34 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::e0) by CH2PR20CA0027.outlook.office365.com
 (2603:10b6:610:58::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.37 via Frontend Transport; Tue,
 29 Apr 2025 06:18:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:18:34 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:18:26 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 20/20] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Tue, 29 Apr 2025 11:40:04 +0530
Message-ID: <20250429061004.205839-21-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|BL4PR12MB9536:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dea360a-8d3d-43eb-b977-08dd86e5abef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0lLmx0G4fNkGL0/twz0M390FzPTiM6L4GVlQ2ZkI7PrMI8h9p0hjcuuwV2Z?=
 =?us-ascii?Q?QPn+ySxmzv7SwQ8YBN6ZYE60gByHTOLLm/0clVbJ4aphQyKVin98r5K/d1eL?=
 =?us-ascii?Q?8tGCZSz1aEcxq5ZJdIU9SUDsr8rMfgrx206G1POA62S2grj/61y2mkdIToeO?=
 =?us-ascii?Q?YcrXkeQ4TyH12Jm/YPU1/9e8weYb+RCXQ4Jat1GHLigeBv/QEgY89CCy9cv2?=
 =?us-ascii?Q?hOMyaW2Z0zhQtvyppX77FfBBZRL7D68KxBNfko0QAS4JzXMr2G5NFqjx+zaw?=
 =?us-ascii?Q?KqC0olRz2Jby3l76mEXgZeH8GrDh7TIaZyEcj7b+Bj4m+Mg5hxqt4AnztENh?=
 =?us-ascii?Q?BzxxTZwN9MN4Jlg9rqdH+ebk9BZlHiaMBfpkhap0PeqMjE81Td38TjNrDhh7?=
 =?us-ascii?Q?acYCL5XwoI/qbvfznW7ooL1qGm9oN98ZTZbDaJIrv3TziG0WKKlsO5cPDojC?=
 =?us-ascii?Q?HS+4fCRt7hKx/PRVCQLL26rBgsPn4D7+vpNH5K8K45jOYmZwQZoofAVWW7mJ?=
 =?us-ascii?Q?5KpkcLxOmPkR9MuxZ7Li7Afqnj4B3xXKg99B6KwS3JAJGMcV+oFkOzga2W26?=
 =?us-ascii?Q?PPdC9Lw2WRrCUswV64xHDrFq6WFbjZECQByxpnSDXsxe7amkPpQ7nWBAfUEq?=
 =?us-ascii?Q?Q619Nsvhkm9cKuYPWheuIxa1DfVNagh+Eui09fbP7TCzQ8ZXdH+6x+aNrZYg?=
 =?us-ascii?Q?13MN0FBN3kqUS7nn/xZdqseIYXV/IdMY5RqvvQ4CFw1gO4nTyYyAVSLGg/WA?=
 =?us-ascii?Q?IiTFm6dPPTzNVKTjIgzkfw0NJ6Y/mAxq/gi/iFUbxmb+XS6RVG8/8K2mhhIN?=
 =?us-ascii?Q?hafIWijWNnRnCuRunlWQGiiG+EYTluzUjCqExIFlO0WT8bpzJRxMCQp9d4ki?=
 =?us-ascii?Q?T4lDaEZt4bbC5T7ovmWdIIgIvUF9wjQuubdKrmUaf44m3MZR4E8i57hM49K1?=
 =?us-ascii?Q?CX3UOLQZ2Od/vjHmJXLywG8FfQsc0bjbNT8B67JRk6A5MdCNl/xDSCVIiHnZ?=
 =?us-ascii?Q?bfVKamduJUrMNnHws8+SVni7JSwslllioi/tjWGu8M4yTjymrZtXA4lLZk3H?=
 =?us-ascii?Q?up2257BX2BG/J1KxatoMaOEAjws2Q6Ya1UGvsUW679TnmM146GzTK2FX06WZ?=
 =?us-ascii?Q?t5ATGJewCD/pKf6IQg+sDVLbteXYsD5j0SW84wHuPPMd7+MLsmEm/HwcwiiV?=
 =?us-ascii?Q?3Fg7bJJldn2QdnqXBF9nDMojs5Lqf2RK6Rd2kthue5d6SvG0/dcwoX6qdg+e?=
 =?us-ascii?Q?pgi7/MrKEMhrS4qs2B4lRrdWzSne+0LV4S2LMW1UmmNmhzhcnlg9hWPbNct2?=
 =?us-ascii?Q?KxWX28uG6V4wFfqsvWZovMsz0YzkPxpY7gDY/tA54bIugPi7Fp8dX4RilqOr?=
 =?us-ascii?Q?mzHGCQ83hfrSokk7+7t1KmBICLDzHN+I5THETPOUNyOyyDWvv2c2vsnSPqgM?=
 =?us-ascii?Q?IVyw7OQe1xq3k7U/60iVgtqUedXMtvk/paLxlFllvwD5zY3CWUe1EthcArRX?=
 =?us-ascii?Q?uP9lkQ/iTJ4XjMYIqZTI6IKOWfwbpTTzoTtC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:18:34.5888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dea360a-8d3d-43eb-b977-08dd86e5abef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9536

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 795c1bd74141..e53d3562d02c 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -367,13 +367,20 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


