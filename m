Return-Path: <kvm+bounces-38355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED4CA38003
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 407313B33EE
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FE5215F4B;
	Mon, 17 Feb 2025 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uGsK4AY3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2800119E7FA
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787783; cv=fail; b=r3edpAHJAerDq7qPlDEy7yxBb2PA/aMCiXKOl4mAGvJ1oqJYyYRME00fTlsUMt7cIdbTFxxdV0fuCPigOyvLVdHMRuWEmsvYqlBM37obZH7dNqngUxOB/K4NnXrXEwN/39OevPjrL0SiBfkwzcXZbNK/XcvOVz+oJSvGhDbQvMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787783; c=relaxed/simple;
	bh=j2qjQb3iQXJX6W5prS/VKCV3GbtwzCOKSOTega3zcJY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qTZNiq8T+YD+QgRgi46ZoRl2HSJ0JZsVFWkxLOjoDgCBdjiaw7yrvgFQW1HNDZTjom3hwSUQ7LZSBRj0Xm6i7faRitLw9jaR2A8AIRPrw6e/g5xDLXUZwfPqGRiMGdc5GLcgkKQSB7YkZg0JNmpAIr7HxUzIV0ErqxOMxlqU7mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uGsK4AY3; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0zrJNTnXfKoIDKngqCJqLl+ngJKVlJkacWujHpiEcOOfCJuwAR+yxGsuqEDUWuJA/hdSnI6p/aTEb9AfwPHtDs/vB5VuIlHMassOq4gDrGPepY8dJi5l/aKVYZzXLZ6wvd4Ra39yxN6fYod4u2VHD26tx+lowRSZUF7n9IwlMbE4itVTtciOalCTRW0+2HAVWcUrrgMkhE7uAVopQzlOPFsyXT2XaMRYDfrfAFMuFdCDxXZHXwZxLvkbD0BAnDNATbqGIR+yR8dIH0Pji5w/gMvHaCbuFjdTONvwpiMzWBvaHzAYRxtUeHE0geIcWDMG4F9GVdTxuEhTUXWn2IBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vd5GErn9lxl10TuPur7D/9TVtBaeaqHRdXKWkxYHm1A=;
 b=XVtEL0KbN3Hbk5sCsBUDxTbXUsdZsVn4UnshTBq7f5UtGQIJindSFSceFFdsVZBrJfxzh6xidhHov1W5gtFNPJqi93LDUk+quo2P8NGAN8pxAfGyJHX9uF1Yh00UJMUdtWQ/UwvPeu1384xUmvErDceqd7cEpBRuy3r1dOW1/9SEWAVAScnUhgWQnvfYfRzgO/ZqgRfyvxp7XLd4B+OZxamJ+v4V+pHA7LGCN4Am/9lA7z6JqnAbgxMOFNh8QtmfIzUQWmi0Q8uXIRshpXob7JFSmoFziX2mO9PXevvBrTPjfb2NCFj/gZtF7+lqf5ADZ3rHtBL46wb+LAOnJIdZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vd5GErn9lxl10TuPur7D/9TVtBaeaqHRdXKWkxYHm1A=;
 b=uGsK4AY3nO+yLqhmkSNwICNUYshSP95jGptWA9C+skxw6WzW4YpMDIEqr3Eb4VCENIWWXC4RCAFBNb1hclAKniKG203RN/8OOMQK8SwyShxW+y0JIzXcX7jcy/Fr/Ud69Hu5cmhjFaKQBp3tEw3TSv8IfpqKgrIzoGr9iBtxuhM=
Received: from DM6PR08CA0002.namprd08.prod.outlook.com (2603:10b6:5:80::15) by
 DS0PR12MB9324.namprd12.prod.outlook.com (2603:10b6:8:1b6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.19; Mon, 17 Feb 2025 10:22:57 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:5:80:cafe::83) by DM6PR08CA0002.outlook.office365.com
 (2603:10b6:5:80::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.17 via Frontend Transport; Mon,
 17 Feb 2025 10:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:22:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:22:54 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 1/5] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 17 Feb 2025 15:52:33 +0530
Message-ID: <20250217102237.16434-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250217102237.16434-1-nikunj@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|DS0PR12MB9324:EE_
X-MS-Office365-Filtering-Correlation-Id: c67bb982-5ce4-4b9f-c41e-08dd4f3d0c4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t/i4j7YQ4CLze21iBBjjNGPYjjClnY0HjMEaSAoEvo/pMtvhIwchkIG6ZDea?=
 =?us-ascii?Q?YOFsLgrwTnsLeC052D837DRjHmUWNSiy7VcPtzn+OJzYkyeUYmrgrUUQde4D?=
 =?us-ascii?Q?23n2QlNUSa+kPbhhpVoRsxRPk2YL7eISapJzRLzhhl2//4FlH72dFBOJsfn8?=
 =?us-ascii?Q?cG8MxiG4GVdWvd20LBdD/n/O8Do1LDfNnENWu0tgrpsAZpqK/6U8ab7/vBKR?=
 =?us-ascii?Q?ebeCBTotRQh2Ug8E6DgSP9A1llvK3XDQdcaX03udmx+lbOVsvv3ORKl6HXM8?=
 =?us-ascii?Q?LjGfoj8CQYMZtnWJ1BZY/9qnp2kD5jHybE2NQdGIcwn8PpoLl1bdD+2KXkrw?=
 =?us-ascii?Q?P345Rsl9GdgQ2a4xTO6cwdpgzAim3gB2i2xoeSXCbHOdpShC/URp89hlBv3v?=
 =?us-ascii?Q?0zcJXzOY3T9OXOtZLIXtpUy7f/6cNA/E53g5OFFBTc0LR4Mk1INuo38zwq0s?=
 =?us-ascii?Q?+mvE2bKKaXzR7HC7hBVsxRTG5u159C04EuHF/33hl9bF6apbchBZzL6OeCzS?=
 =?us-ascii?Q?LSw6F6eDe0Qqd+xP0oL2iBAa+B6IiRw/6SzVITuKhPHPW5TvH+waeuyj6QVb?=
 =?us-ascii?Q?viEwTrIsLkMnRz8i1DGdILMOp8aEIX3bIU2o707/EZvvzPCzSu33Mjhtd7gT?=
 =?us-ascii?Q?JRTjGoBeq1mjAvJAXcwz2RJWtTCxZWdImz191ZLl6CCCqxveabYioYk61IaM?=
 =?us-ascii?Q?PmJ3x8n/YbdmymNcj7MDVHc/o2Vhnlsd/dFahZIUMxLNRLSnb1fxI2zl0iVq?=
 =?us-ascii?Q?mbo3FEs0jLNBiyDB5F8H/qwUnECKEBRo36flEBCoV/L110bRRsun2+wyPwEQ?=
 =?us-ascii?Q?Ju4dnDDXc8QYc6DJQRBZQjR2wZAONFuGSY8+LCra1yXhHJuKfm5gNAWGZ2Vv?=
 =?us-ascii?Q?FRteXfJ4S5bx37gImgAZbMmASUyQKnBF/zVt3Y2ifLeF/NNKxYnBCAKSzEcS?=
 =?us-ascii?Q?AQtNGwsbZwqQACBKIeZDxYppccKko+2LTK2+lLtBCK+/KAaptYSQyCLkWHzr?=
 =?us-ascii?Q?vkNjqVlHUqpdFt85godcwVa0I13gjsSCp1rQG1GNG8ZHCqC7MnOpV/vNEYA3?=
 =?us-ascii?Q?yPyEulOz23s0oe2701lyA2X9CxyZL5HiVFnbZzrC+b0330du+VDfuV7GQG34?=
 =?us-ascii?Q?wlnJfloEA1frrk02mSHcLIIL5gr3KH/Dnoohx9EYamHR9+Dwp3fsaX+zPClL?=
 =?us-ascii?Q?zPRmRrDz+kHJw3VbG9tlk9yIiwui0LTF8W9oNJp9DO6sJzaJbX2jVfkFjd0c?=
 =?us-ascii?Q?tyA+VUYPadtfNZ4fQCkaMcfUWt7GZGaOGuxCr7BPXY1+YArkGYUtOhFTiY/2?=
 =?us-ascii?Q?mGbYRliuPJZE1wpWYxJ0sfFlR/5H1wkJKLrFYi1fesoKfSOem9kP4psb/e4L?=
 =?us-ascii?Q?cC9hkeepoXfkg5BDY/rMyuNtrEPcsRhypXaD1p5BSGYspHZWTthLh5vFJAjw?=
 =?us-ascii?Q?EDMtjKFJYGSLohUbAe6I3K90K/2y1K6xvDVlGPSoiBuBSlmVivfdMJlxzzQD?=
 =?us-ascii?Q?vvX/4rRBLk7Rt28=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:22:57.3210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c67bb982-5ce4-4b9f-c41e-08dd4f3d0c4a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9324

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116b..921ed26b0be7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


