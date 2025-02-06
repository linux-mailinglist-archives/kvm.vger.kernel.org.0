Return-Path: <kvm+bounces-37531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CABACA2B242
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9C5F188A89F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A63F1A727D;
	Thu,  6 Feb 2025 19:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="InPXSdOq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128B19ABD4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870180; cv=fail; b=kiA3hko2BG9sd0dqBAplZTptT7W5S3kIL4T1AnFPJDPOeu4+f4xBlmOlUP8NCNqOLdfS9x5M/0IV4AmArmrlOQw+RTpIWWnnvq7ZTF0nx43rcBv11zphoRPULl8maCu5LAtwCsCryRy09Ts6YBnN1hU4Ci9la07crhrJOLSA8aY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870180; c=relaxed/simple;
	bh=RRuq4B5bclg8rZnJoUZ1DphA1jZLKfODKIHXyaiD7ow=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjSfk6ovq1y++FBT8QfNO9A5EeK3d0+QNzwcZB/Kc5vRu4BJBjtAyp2fbjiLmzkZkqsFhQCSFPc9Yj7R9qhfFMdiphrkc/R4j1ZjYT5NY4nBfjifIA6PY3gomfdf3d4OkRh1uQZN4RzeOG1r/qZ4IWLeerEDjT2Ib5+TTayZJtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=InPXSdOq; arc=fail smtp.client-ip=40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMV8Jo9Y8WRV7X3lYC/PgAeYhsyiV1nQo/3YJqT/Q+msgez9Kd28usTW20/kdYtYSpTrbgxE92FIp54tMu0yU0QFQyoWYpv1U+eeckBPruXCWggDXoKRtSLBEoi1KQOLE7jjNeV4qFI35kQOTvb1oJ8oqKLwhDAoaoxuF4BzM2Q6PltzV+cxvLck7rVsOv8E3ouQiwx+vPGplrfUalBSwHWrS83lg6rGN7DBY8BHi4CeYRxEMJGu7mILm9mN8vO5VIJ77cldVlI9Id6+nQRI3yeteGxZR9+gL1ivoOfg+SU9N6qswLMZPJWNvpAV5BWImllBuf0NpiB3fywOPvlMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8/ulyUwvMT+V7DcOpwjeSCd+V/e90Ifqtp7UD4a/6M=;
 b=de3Rjj9KAAhgrtZe0JzYWzNFgGocd25/Zt+4m6KS/aG6ny36zyGSvb6bq9khtfXJBqmXcTMHVC15K1XdZtagMbNeMbQM5LKKA5BG3/k8SW5xb8eQTYEdKhviSvOAFKD5Q0Q0XEQgj6qY+usw3qawXBLoDF+YWKTMIHmRAdOdkivxioU22B5p7NlhpolCVk79wQMbyDRg9Dmk3GzKnbVpJAx4kSjizfdKsC4OF1NxE4pxB/J2cUkGXDffOna+mSnUbA4cv+ihBRr1OLEkchEfLDPyT3m0T8ELnmVLVNKaYJ4UcxTMVx6ycScgrbD2KIzni0f/bd/M+rRJ8bV6SoyGAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8/ulyUwvMT+V7DcOpwjeSCd+V/e90Ifqtp7UD4a/6M=;
 b=InPXSdOqc46vAphgT7BV9NzQJ450SY2si2m212Yf7Fnx3VzeRNq6IhUZZyVOgE2o55MeK+SZWQ68GaSuqf90bdvla8JKWgSJC+slGT7XvmKlgTc/4n/hK0eKV1VisD98lkxyJUF25uef6K2e+/StzbkotwmnLzGfS5q8Fsdc5cY=
Received: from CH0PR03CA0371.namprd03.prod.outlook.com (2603:10b6:610:119::19)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 6 Feb
 2025 19:29:31 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:119:cafe::28) by CH0PR03CA0371.outlook.office365.com
 (2603:10b6:610:119::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.28 via Frontend Transport; Thu,
 6 Feb 2025 19:29:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Thu, 6 Feb 2025 19:29:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 13:29:30 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v5 6/6] target/i386: Add support for EPYC-Turin model
Date: Thu, 6 Feb 2025 13:28:39 -0600
Message-ID: <3d918a6327885d867f89aa2ae4b4a19f0d5fb074.1738869208.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738869208.git.babu.moger@amd.com>
References: <cover.1738869208.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|LV2PR12MB5797:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4e86cf-d82d-4f15-3edf-08dd46e494ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jIp+G9z1uE33de0I2zIDFU81pOsIcoaXh5n/9PGv7Jacv+RMfx++ZEhmOZ2z?=
 =?us-ascii?Q?8fTZtSyMXgPBgzbdfAjLSCduPh3Iww33s80WsWA5CHyC8lsJoZaDL/25n3W3?=
 =?us-ascii?Q?au5ASfxAFrmjrbI2WtE11XtFOHyGhl1ZZxqUNW2agZNwr6xqu4wPxqwYegV8?=
 =?us-ascii?Q?oZ5uZf6tp1zVR8WLzRS1Zf+1/o67qJWYhRMi/pgki/exHnqDdJclYUgHZcio?=
 =?us-ascii?Q?pPr34XJ/4lSgpzDPuug2aRjZABmvr++3/p1MKdmnAeBh9eW5B7qeLlCSLur7?=
 =?us-ascii?Q?CXP4DwdRjcUeLG8RSwLLZgjFzYpTWBQrEyMj/WaOj6IvNSSzhtHmR3oYNj4q?=
 =?us-ascii?Q?QO7tthi3Kuqs0FjqVZ0MVVfE6Ow8bjKyCEmdKl5BLStHJ/qThdOhGEG97vR3?=
 =?us-ascii?Q?M5Yyhiw/b2lxFNQmNyT4Nh7F1JNPd1NApmZQZP/7LgLI8Xr7yDwfZ4E4H+3u?=
 =?us-ascii?Q?4xV3mXTcyGjh8JfGYr+GrMz1kPQd2lSpGJKvT2fuokI6QPobszI9pK3fSdgD?=
 =?us-ascii?Q?ZtsrQjqbVM1mWC6IUWMOBWZvQ5CQ/GrTIYrKsH2QWvHA9Xtos3m7nYbMrAht?=
 =?us-ascii?Q?eWhJ9/pdl8Y7kf8OZrFMwXUGqjVSuNR0/J1UUNvCm7bDrIFLv/RAFkwj9Wes?=
 =?us-ascii?Q?prwLdVZ2FbRtKThyBvZDQLGNm0CbN5Sm5hfbxlAFUIMGQ7R8yf4kbI7BW/Xz?=
 =?us-ascii?Q?2KccwjsA5eXtRbQ2OD0fQv/UZSgNNRJn+wL+QOPx4djE2+Mo+eivW+jIX6qG?=
 =?us-ascii?Q?IwWmDhsa07VQFYKn74V0X0ZQOxIWKaIAhzbFqYrLJaT9Qa/jnRratDI3qQj+?=
 =?us-ascii?Q?MNXVbwoqIK/o33Xi+7cPnT9NoQc2L6Uzn31ToMz3aq7IMeHFoYrK0Y+ILbA5?=
 =?us-ascii?Q?7fbKh7aLs6g21G9j5xBrxmt0Eo3jyP9AmaBUBWlPTB9nCNzSsoIZ9EdDDESs?=
 =?us-ascii?Q?FKRwPErV2gYjVzvSz+UsRmF/oN+QrzSfhV0IpMGAW8IADxEMD8bH/jaF7psi?=
 =?us-ascii?Q?b4c7top7PHlBec1q5C25M62g2pYBIktsrL1+ijNCO6FIWfLzNMNIfLLJlbVi?=
 =?us-ascii?Q?Aq24Ly2xIExiZezkrkkPULiwe6064AVuLlwUBP3Pd1g34zpMpaaYMfrEkbjR?=
 =?us-ascii?Q?EMC/pUoFRs3i9clMw/Gu4Rc+eopYp8kJWu04sMCuvKiR+y8PwnxkAJCpOITm?=
 =?us-ascii?Q?U2k/Vso6eYYPjttlQ1dhGqwgXKlEB9emblgYEmN/NxwU7cH4anaxtUWakGDX?=
 =?us-ascii?Q?NUaDsdJaxswFJQQUgULf1FGrrSqmu9ehw5n6CpQELuRTkA5RfPWZ7iZA9fAr?=
 =?us-ascii?Q?TuGamtf4flc6WHnAPFMnv2S5c8q5lCfOQmZoRvhRSlkUL2vaLgXh+WGNRvY8?=
 =?us-ascii?Q?SuFkpy/6AUq4kF3VTQfPR+Md8hYWlc75+Dtz25nLRThbvBXJxV5yqqhKGaL6?=
 =?us-ascii?Q?pYZmyX41vyXqptYO+D/d7PBDB9w3yTY6xPGIlsuwFyVdBwoik7tCNVQiCjpN?=
 =?us-ascii?Q?KdRh+tFFzi+zLNQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 19:29:31.6566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4e86cf-d82d-4f15-3edf-08dd46e494ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

Add the support for AMD EPYC zen 5 processors (EPYC-Turin).

Add the following new feature bits on top of the feature bits from
the previous generation EPYC models.

movdiri             : Move Doubleword as Direct Store Instruction
movdir64b           : Move 64 Bytes as Direct Store Instruction
avx512-vp2intersect : AVX512 Vector Pair Intersection to a Pair
                      of Mask Register
avx-vnni            : AVX VNNI Instruction
sbpb                : Selective Branch Predictor Barrier
ibpb-brtype         : IBPB includes branch type prediction flushing
srso-user-kernel-no : Not vulnerable to SRSO at the user-kernel boundary

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3b6a630b65..b0ab493cd6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2665,6 +2665,61 @@ static const CPUCaches epyc_genoa_v2_cache_info = {
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
+        .self_init = 1,
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
+        .self_init = 1,
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
@@ -5792,6 +5847,89 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
+            CPUID_8000_0021_EAX_AUTO_IBRS | CPUID_8000_0021_EAX_SBPB |
+            CPUID_8000_0021_EAX_IBPB_BRTYPE |
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


