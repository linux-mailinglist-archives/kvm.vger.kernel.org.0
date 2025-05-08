Return-Path: <kvm+bounces-45981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BE5AB0438
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF79B2799E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9FF28C016;
	Thu,  8 May 2025 19:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u60nmxWT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2329428B7E4
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734341; cv=fail; b=deHhip2RUJT31ipQzDSNOay7OCN9oFzAp5szvpjA0XObwl5w4LqmRxtuQkbGP/AxsgHZNXIch3Bm8YrdHdoNxDnR20kr8w1RJPNUQf9MCPCg2rYSJs4wY9QqPr5djwE0VcmxI496Mbr2h3OhZxHrNeXfPFdZJ6fDVYE2XeSeCPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734341; c=relaxed/simple;
	bh=Yz2ky7QirLIGtiKWH4znhwZ4MM21E2IlOLe7QDugkHQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k4rOMdVupqz8OUmYkMdFYDMlH5MOEl+h6Tt2mo31C04gONjNNC0tvv/zJXCU/fFRft3cL7howyK0Obx8MfKcOg5GBNYq/sZIKXBOTRIqTcpMhp/C2Oa/QbXU8e2Z2pP5SryOX6JpufKd8jFJRCJr2Sa6RFBbVrcBaLsCcXHaH/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u60nmxWT; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLff2rpQUXnexMo+XV2nWjwpA5ngGeH+oY24ZCx8uzMf/dk0OCeUrpko1ll/03AJ3Cm9o1bD1qXTy1+t1A81lpitBwcZEiBZw1fc0voBTFkBIyTZ8m2BU85FMy+nt6PAjXUzwEjzVd8eqplocrKmrrrB2bOXLSV5nxV6jb9Cg1CkoXymJwsXpirINoWbtxt/PoToAesUMthsRHs9mlc73whlTO6wjfZo6W1iyD9ZSu6oVApKdep3VMntC/vbHCQDZhdG6s59YJ7dRb2jGUGIXDf+K1oehSgv19QJk8n5mU4OsuLH0Ir5pcwMzuKrHg4pY2ov+0o85z1FemNgV6vUhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=41IEIOonr00t9tKq8Q/ps1IFkC084n+ebs4kMCQIdis=;
 b=VkIesmP8CfR7OK/kVwdH3caOqjtLMFYLFV/kHQO/84htbbdN+3pb6PVSmCsmn1uP4nUrhoXjdbAfBD5BuoSLW0aoWO5dgy97osXxIxXP2zpVpsPWIdqEie5lr/Ek2Xk2z9x/3JmdibGz9tIxGY3rrleTgXY1AXS4SPwHC+0dW3P3G/TY+g0SQS5AQ+J0+hd+PDuwMzbEBghdZws7RTEKj+1aQ22731HA3Rl4n+Af0U3h+6N5EuCKC/G0MMn4nFhmPAwrzoDR0P0ouGs50x7+K0COs/vTgB2o6enJz73fAaNwJJYTqlPkC8Qxfbufoz7XuRqGNNG1pmiX019bypqlkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=41IEIOonr00t9tKq8Q/ps1IFkC084n+ebs4kMCQIdis=;
 b=u60nmxWTS0udAsRRPf/w2axX2JPhUzqBi6PzBBzImmrMN+0/JTpFXWBXrTrgUc5q4f63UtO9iOP3QnRuCawqJ2GBEb0xkFb3eAUzn5UMTM7pZTWj6WU51QOwHEP+qJdkN3aztjZls6sQvHClZYp9i8cV4V10hHD+ayldxjei4kU=
Received: from CH2PR10CA0012.namprd10.prod.outlook.com (2603:10b6:610:4c::22)
 by CY5PR12MB6621.namprd12.prod.outlook.com (2603:10b6:930:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 19:58:53 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::81) by CH2PR10CA0012.outlook.office365.com
 (2603:10b6:610:4c::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.32 via Frontend Transport; Thu,
 8 May 2025 19:58:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:52 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:52 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 6/6] target/i386: Add support for EPYC-Turin model
Date: Thu, 8 May 2025 14:58:04 -0500
Message-ID: <b4fa7708a0e1453d2e9b8ec3dc881feb92eeca0b.1746734284.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1746734284.git.babu.moger@amd.com>
References: <cover.1746734284.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|CY5PR12MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: bbef7564-ee75-495a-900e-08dd8e6ac1fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QFdd3X3skPyAB++YiRlcGhGRiWcH0CZyerK8nkuyeg7Dt+oyrkq//VdPcMf4?=
 =?us-ascii?Q?fsm4ZuBjNBzCbwDq5RtejJ6hQ5hT2kalHdgNg5Dxj97Wc/+GkyiIr+Ohu7EJ?=
 =?us-ascii?Q?G89fTw2yNce9J47UbIg9mY4BsopkQRfIK0Qn6h/x6D46V9sdxmoZW6yDcKwV?=
 =?us-ascii?Q?1l6599ZCRFf3oFq8sQrgMEPsxATwink19fjX1sfxR3UF2E+iGURLTJfGSP14?=
 =?us-ascii?Q?8DNOCa73rvaxod8Flnh/yZIU5sSjDK+xTHIEGpKKNBs1xzfPzSoq1a/X04Ry?=
 =?us-ascii?Q?JbdbRWJ/7e5JeFpl5Q7x+hbYVZorRlFnXYL53AsBJ+eCrlsT1APBiPY+V3aS?=
 =?us-ascii?Q?4t9LgkxPLteMG5bcR4GysXyDzk4mz9hgpD9tMd5nEQgcVC8GvF1vORIb+JCj?=
 =?us-ascii?Q?Lek39Q80lnWAzMHQbCXZ3tXwroZ7iW497Sb+eBN38wVNcvJEOImF9ys5XHL0?=
 =?us-ascii?Q?ix4l2saCEWS5216hT4QQPuHAa2n2aFAQqfzGnfET/MDUw2up0XjUd0aj8Ynt?=
 =?us-ascii?Q?dOG+H5pezXaIJ2mzjuYeVpbrG0+gcA+Xr1jZ2sVjO97ZliEnNjDFwVdfY9Kn?=
 =?us-ascii?Q?51xBAmskMSuw547e82KUaYXOQWsR5anj4T+eaHlvcTDe78I/mlviiA0Oy1Hy?=
 =?us-ascii?Q?uVr+F6/EyN90Zw8W/mRfgkJYsMQcYWvIHyRG47MHWHdF8gKGktgpiBuOn0qu?=
 =?us-ascii?Q?dWYb5LZa+v84FRmHjvsy+Q4kR6dV6fNck+Kn7pjC+lDyDsYxUKYTesFuxo8w?=
 =?us-ascii?Q?3HQv3wK9Q/4VffpcetGwqCgrlOGRVZx0BT3SFoD13b6e2DG1EpckFSSur21e?=
 =?us-ascii?Q?fH1ltdnYiOwliPjVutvDn7Bl0miY4VNI7PLpGLVx9JCaHtgnj92v24zvKzb+?=
 =?us-ascii?Q?o6uV5sgO/rDcmE0uZUn/CzKWKICZLzTG9FnUkyH8rt8Q8EinxIsc3sxxAEOZ?=
 =?us-ascii?Q?QqoOZI4pKbFIXJTO8M7WCppYSw/ZrgTySKaYCQGAwl3J3CPJ/UVa5Ot8U/rD?=
 =?us-ascii?Q?OPRarQmOfDXBDfuC45R/1qkrluNXObqEQIAc3wo+8Tk+QZ1hsfnbZ2hxKWax?=
 =?us-ascii?Q?E6gBEWtlFi21lWxuxnZN0EAR1MQFd5876/+1wCTJ5bj+U1V6hwq/Z/L8lUSm?=
 =?us-ascii?Q?7WCvse3H9UdqdfBHmlhck2LPFFObherTFEomtrRuOt82a5QSz3EsiCCty8vT?=
 =?us-ascii?Q?vVmLGtj/Vb2fm7CQwRj0VDAVogrE+IQRyC2/CpQZ4xOGVJ0nZ0rAfKlrpAeu?=
 =?us-ascii?Q?QtjLi8HAP524oGgRAmDxCjZ/87KmW4KkPMwO+aTeGw5AkETEk/Q075gF0f5q?=
 =?us-ascii?Q?vTCMxJnmvEZH1vSAcxwRBTyrqrnKYxYIQy/CHJc445BYovFkgrsJh54qYZF6?=
 =?us-ascii?Q?NMckrDQW4UWxF7ODTqTYnxPtwUDI8tV+OXZiba/27zNpOYmEor3kAIbH8n8V?=
 =?us-ascii?Q?vDcguSAf4xliNakNOuaxoxflYS3Mqm2HscZdsGrIMMfm0aE5EkTwB+37HCBD?=
 =?us-ascii?Q?EVnxiB1D/dysApNCOhiJppgRmABGiMd5OOvFP6U20YiN8uWZUD8m+VLZMw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:52.7787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbef7564-ee75-495a-900e-08dd8e6ac1fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6621

Add the support for AMD EPYC zen 5 processors (EPYC-Turin).

Add the following new feature bits on top of the feature bits from
the previous generation EPYC models.

movdiri             : Move Doubleword as Direct Store Instruction
movdir64b           : Move 64 Bytes as Direct Store Instruction
avx512-vp2intersect : AVX512 Vector Pair Intersection to a Pair
                      of Mask Register
avx-vnni            : AVX VNNI Instruction
prefetchi           : Indicates support for IC prefetch
sbpb                : Selective Branch Predictor Barrier
ibpb-brtype         : IBPB includes branch type prediction flushing
srso-user-kernel-no : Not vulnerable to SRSO at the user-kernel boundary

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 8384ad6eff..247dcdbc34 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2670,6 +2670,61 @@ static const CPUCaches epyc_genoa_v2_cache_info = {
         .share_level = CPU_TOPOLOGY_LEVEL_DIE,
     },
 };
+
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
+        .self_init = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
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
+        .self_init = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
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
+        .self_init = true,
+        .inclusive = true,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
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
+        .no_invd_sharing = true,
+        .complex_indexing = false,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -5933,6 +5988,89 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
+            CPUID_8000_0021_EAX_NO_NESTED_DATA_BP |
+            CPUID_8000_0021_EAX_FS_GS_BASE_NS |
+            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
+            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
+            CPUID_8000_0021_EAX_AUTO_IBRS | CPUID_8000_0021_EAX_PREFETCHI |
+            CPUID_8000_0021_EAX_SBPB | CPUID_8000_0021_EAX_IBPB_BRTYPE |
+            CPUID_8000_0021_EAX_SRSO_USER_KERNEL_NO,
+        .features[FEAT_8000_0022_EAX] =
+            CPUID_8000_0022_EAX_PERFMON_V2,
+        .features[FEAT_XSAVE] =
+            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
+            CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
+        .features[FEAT_SVM] =
+            CPUID_SVM_NPT | CPUID_SVM_LBRV | CPUID_SVM_NRIPSAVE |
+            CPUID_SVM_TSCSCALE | CPUID_SVM_VMCBCLEAN | CPUID_SVM_FLUSHASID |
+            CPUID_SVM_PAUSEFILTER | CPUID_SVM_PFTHRESHOLD |
+            CPUID_SVM_V_VMSAVE_VMLOAD | CPUID_SVM_VGIF |
+            CPUID_SVM_VNMI | CPUID_SVM_SVME_ADDR_CHK,
+        .xlevel = 0x80000022,
+        .model_id = "AMD EPYC-Turin Processor",
+        .cache_info = &epyc_turin_cache_info,
+    },
 };
 
 /*
-- 
2.34.1


