Return-Path: <kvm+bounces-19500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D377F905BC0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84891C23CC9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF187823AC;
	Wed, 12 Jun 2024 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BTncFy1k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937201EB2A
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219582; cv=fail; b=hxhANu8X5vRvmWZlldiGbzWOIeyUk4N5iiZrX1VZ/9SBHG9rXuoMIGkvxr83NYGArhqsvTdX5inARDWf+9s0SDuZ/sS6cl7AwTxoj5W6q+ZQLHxVplxf+RmAX+68lMZZTquSFOSSvmvQyZmpijW71iqg1IJDeifQ/i6ByTuE/NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219582; c=relaxed/simple;
	bh=7GJWf/T0F06B8MgEo+eyKo7sMoo1qf1boxv1Md3RgoM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDT548xisriA5kIopuJ8SJgGQINHLHZL7VWXnzSENG8w7jN9bOoO4Nyrp79BPc8vKl4xxE4MocLsbx/TCgBY0WS5UNFXtGEXoxu/F/kBBZWkSq4FMhq4bAy9bHRebpPNJqYqGD468WmOy5RHNoxSIXRY9ZLoE2po9uLcMVrhIPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BTncFy1k; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUVC3NReFhp8tIS+AGoO+qTfThD+XarPzUCaTC1zY6uRkgVRStUfMfW19yz0v3D0I+cy++hvAlidL4adI5LUCL1qxhn16cA2YIK99ZVGr7a3gQ3Li4ozw2nuTvwj2g0JurmzCXzf2qYwmbKyzmbXeEe9/NCKDic67g2tGO9Ort14HhKMOsi60KPygBj0PidW1gAb+REb7u/Lyr9ZxVJf7EA8z59rD6tuW13OmczuIZTrvqmx5g4HWVkNkEZApflRu9V/Zd5tKKsTi5PXqkvZXHIAm4ciaJa2UhmsrDyuJ5RFPySJxChjW1g5FyXXLE0QVYcZP3B8OdyI3L/SeGk7Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMEBSVDfPiiXsHfeeec81CbtjVfzIq+u7pQe6G8F65w=;
 b=iaExNUtn4Ydiauy7tsN5SG9BAyhA5vUDoOmei+h2seMey0UGv4edqnViBSB/tUHDciJ3zUservxp5nEK9MXWIKghaX1vwCOdq8QfdNV3svUQ7bcm4GfMmu6eg46LJfo10vPTkjWQMVT7qmvviORL4Ob/oqmsohCNF40T7ZbT5iK6fCDD7PqFWZ0xVT6xPrqSR4KXblaq66AuPQTA2DLeAg5XF+O5llkWGMN0zA7Y07ClKdHML8I/q7MX56MyGRMW0SxA46bpExHYVES1TXv+kUsPwBfNQM8QHiuj6XT5TaIS8wlvnIusjOYduMioj99236FrUZnoytVIK6EwhZScoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMEBSVDfPiiXsHfeeec81CbtjVfzIq+u7pQe6G8F65w=;
 b=BTncFy1kikiWDbw38zuWfh4PdMgWgPaCbmV+onYh5ILNzbF6kh/K6E4f/WioH1APlAMC7/MdB2ZopaXqUFf5nkQVmShDb3D8W1e4nK74rJBo236sKS16mteWpcBhHdVj/xUQl8lG5qvW5CXBgMW5byLfPW9FRv4fHzTeNPRqcIk=
Received: from MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15) by
 DS0PR12MB9448.namprd12.prod.outlook.com (2603:10b6:8:1bb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.37; Wed, 12 Jun 2024 19:12:55 +0000
Received: from SJ1PEPF00002314.namprd03.prod.outlook.com
 (2603:10b6:907:0:cafe::9d) by MW2PR16CA0002.outlook.office365.com
 (2603:10b6:907::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21 via Frontend
 Transport; Wed, 12 Jun 2024 19:12:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002314.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 12 Jun 2024 19:12:54 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 12 Jun
 2024 14:12:53 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <babu.moger@amd.com>, <kvm@vger.kernel.org>
Subject: [PATCH 4/4] i386/cpu: Add support for EPYC-Turin model
Date: Wed, 12 Jun 2024 14:12:20 -0500
Message-ID: <a4d4eaafb69d855a5c5d7dec98be68b3e948cefb.1718218999.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1718218999.git.babu.moger@amd.com>
References: <cover.1718218999.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002314:EE_|DS0PR12MB9448:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8a6be7-c680-406f-73d7-08dc8b13aa25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230034|376008|1800799018|82310400020|36860700007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F6IhFukOuaatMWnbAs2URVpHZVH2wUZOmNzio1uLjuFRw0kut5MeXp/7Ma+K?=
 =?us-ascii?Q?JAofXM00oIhHuq5gtiE8YaaBeXZDQAp/VNpWfTkVhgfV1r7anXbHMuBGNmA2?=
 =?us-ascii?Q?Ty1r+nN5oOkSge9suPtUOJ3KMiyIRQJEcgD/1zf4Jd3u2aybmlI3Cfi4i8IE?=
 =?us-ascii?Q?CG2tAYGrOqrr4GYlSIplqCKL+O45s8JovH3rDM4YUzoVewlchiVZvvh3lnir?=
 =?us-ascii?Q?47LtwjV8LLMMto0UXwvnztw8vXRKzG++1at5lAtBoYD/SSDg0q+Q6Lv6Q1Kp?=
 =?us-ascii?Q?LQJ9kE5BhxuUlxgpZykl/tBoqct5+uBbhRmyGC3Kpc3PnlryXm1V+9VrQZuv?=
 =?us-ascii?Q?IZ8TXI53VTDzQEjAie+1ye/teYbMrPn4tBuM6rlzkWMUGnzqJIMlfU5D+dR8?=
 =?us-ascii?Q?JovjFljaKpso5paeOz/gyrgaHcLBaqSGFk9sDK9KPc0GyOlZRCIni77iLWpC?=
 =?us-ascii?Q?bSeIBrmpNwwBkKXepfaclNDsU71/fSVy/9EeUUovpE3NbnV+GoCZCmH0EVs2?=
 =?us-ascii?Q?pPMozk8YT68gUppoXzaKBL3NHUB8qOYt6ngP670E82FdPWlrXjm6jpgfAIwS?=
 =?us-ascii?Q?drskEVZSnPfCE8T1vP4RriYspPXu9rOjN8Kyrbz0cSSA5urMBTSj1eBGKn/b?=
 =?us-ascii?Q?tahkMYxu8DtSAQWk7QwI20d2Gm/iAOw+wdGweD5U9QDFVpPU/fKQfs56en8b?=
 =?us-ascii?Q?CxRnZep8gPkxQR0CecoGr+wuLc1DJudI3cI2kZK11UhKYBZAPNgw9x37Ools?=
 =?us-ascii?Q?RPMQLdX30t3CHnfv1SRkFN66UMedo2BpZzEjJ20APaxs5z4GwlGtCY8ySrHn?=
 =?us-ascii?Q?9qfh3cM+qhtNR4+Wy1hAVkPpj1HZS++MFKFiYwfJzTeRlWjY3jJOwmKysm4J?=
 =?us-ascii?Q?DgP+zyVrP2Ejhm85G7lE3kmb7EgUW0nwYjCbSfTzr1UUrMIX18BqvY56HvzY?=
 =?us-ascii?Q?HGyxaeCDLF03ksizLj91ioQ30dFJ2111br9tnulFAbHyOQvlm7+HiFMr7vZc?=
 =?us-ascii?Q?TOznWYHT/OVTHvDnblA7o5waARHtz8sAWQL/qnD3WFoiH+fdGg4zj2rX/1TL?=
 =?us-ascii?Q?EL4Zg+EvUwJKeY2yeqsyRkLKj7l682wYTACEl9E1USRHtN6JfYwAs3M5OMl8?=
 =?us-ascii?Q?37zTu/7qkRobp9d85F+CE7Gs/2W6yMIsH4aLU7Kx94AISXNsjNFkmUrQjJtd?=
 =?us-ascii?Q?OOJpT6jcE0kp5l5xeLqt2diCoVpE9jZK6XtfPdfkn7gubKyvSxQUCLj53stZ?=
 =?us-ascii?Q?vqVCL2z2yDq0gcDa9bp1psFGR8g24jl9zwevxOX7CPuvKoIdC744cSvAV+v7?=
 =?us-ascii?Q?vK9tocyB+uzAMEdvvbPDHJslOVvyP+juhmgEc2LZF38dpn6qNbMhE8xTwm1X?=
 =?us-ascii?Q?xTfcBbOYvqTMq6kBkRpB+M5nPCR2xvCPNvDMbqcVykjHnpUORA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230034)(376008)(1800799018)(82310400020)(36860700007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 19:12:54.7019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8a6be7-c680-406f-73d7-08dc8b13aa25
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002314.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9448

Adds the support for AMD EPYC zen 5 processors(EPYC-Turin).

Adds the following new feature bits on top of the feature bits from
the previous generation EPYC models.

movdiri            : Move Doubleword as Direct Store Instruction
movdir64b          : Move 64 Bytes as Direct Store Instruction
avx512-vp2intersect: AVX512 Vector Pair Intersection to a Pair
                     of Mask Register
avx-vnni           : AVX VNNI Instruction

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 131 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 64e6dc62e2..213b5f12f0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2370,6 +2370,60 @@ static const CPUCaches epyc_genoa_cache_info = {
     },
 };
 
+static const CPUCaches epyc_turin_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 48 * KiB,
+        .line_size = 64,
+        .associativity = 12,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+        .share_level = CPU_TOPO_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 1 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+        .share_level = CPU_TOPO_LEVEL_CORE,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 32 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 32768,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+        .share_level = CPU_TOPO_LEVEL_DIE,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -5288,6 +5342,83 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             { /* end of list */ }
         }
     },
+    {
+        .name = "EPYC-Turin",
+        .level = 0xd,
+        .vendor = CPUID_VENDOR_AMD,
+        .family = 26,
+        .model = 0,
+        .stepping = 0,
+        .features[FEAT_1_ECX] =
+            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
+            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
+            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
+            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
+            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
+            CPUID_EXT_SSE3,
+        .features[FEAT_1_EDX] =
+            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX | CPUID_CLFLUSH |
+            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA | CPUID_PGE |
+            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 | CPUID_MCE |
+            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
+            CPUID_VME | CPUID_FP87,
+        .features[FEAT_6_EAX] =
+            CPUID_6_EAX_ARAT,
+        .features[FEAT_7_0_EBX] =
+            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 | CPUID_7_0_EBX_AVX2 |
+            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 | CPUID_7_0_EBX_ERMS |
+            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
+            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED | CPUID_7_0_EBX_ADX |
+            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
+            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
+            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
+            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
+        .features[FEAT_7_0_ECX] =
+            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP | CPUID_7_0_ECX_PKU |
+            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
+            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
+            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
+            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
+            CPUID_7_0_ECX_RDPID | CPUID_7_0_ECX_MOVDIRI |
+            CPUID_7_0_ECX_MOVDIR64B,
+        .features[FEAT_7_0_EDX] =
+            CPUID_7_0_EDX_FSRM | CPUID_7_0_EDX_AVX512_VP2INTERSECT,
+        .features[FEAT_7_1_EAX] =
+            CPUID_7_1_EAX_AVX_VNNI | CPUID_7_1_EAX_AVX512_BF16,
+        .features[FEAT_8000_0001_ECX] =
+            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
+            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
+            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
+            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
+        .features[FEAT_8000_0001_EDX] =
+            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
+            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
+            CPUID_EXT2_SYSCALL,
+        .features[FEAT_8000_0007_EBX] =
+            CPUID_8000_0007_EBX_OVERFLOW_RECOV | CPUID_8000_0007_EBX_SUCCOR,
+        .features[FEAT_8000_0008_EBX] =
+            CPUID_8000_0008_EBX_CLZERO | CPUID_8000_0008_EBX_XSAVEERPTR |
+            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
+            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
+            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
+            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
+        .features[FEAT_8000_0021_EAX] =
+            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
+            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
+            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
+            CPUID_8000_0021_EAX_AUTO_IBRS,
+        .features[FEAT_8000_0022_EAX] =
+            CPUID_8000_0022_EAX_PERFMON_V2,
+        .features[FEAT_XSAVE] =
+            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
+            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
+        .features[FEAT_SVM] =
+            CPUID_SVM_NPT | CPUID_SVM_NRIPSAVE | CPUID_SVM_VNMI |
+            CPUID_SVM_SVME_ADDR_CHK,
+        .xlevel = 0x80000022,
+        .model_id = "AMD EPYC-Turin Processor",
+        .cache_info = &epyc_turin_cache_info,
+    },
 };
 
 /*
-- 
2.34.1


