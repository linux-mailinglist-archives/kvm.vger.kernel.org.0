Return-Path: <kvm+bounces-29678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7E79AF541
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 328CDB227B1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA64219480;
	Thu, 24 Oct 2024 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mnOiTk4f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBBC218D7D
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808365; cv=fail; b=Jpgr2zrqINKPZAa4KQMaZxv2pQp5QimNyVJl7/E70iqVeGOy7P1lT6G+qTRvbICUTrVe04Lg+lAc/4yuHiK6YRuqLAEKueiLMJbppqAO7fpfFsCLstB7M1ApE2vv1rZzNUSWOrrNwded6Mg2SF56pfqWyXnibZ4ggP/P3N4MrYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808365; c=relaxed/simple;
	bh=+8aA0tOmGAApGC/nYBLsE6gErh49BkCjP5Q4N8kTRGo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpkbOAPY0dCMSqbDU+n8OpW6AHiLnfJa8lAWOJ/HOREzgRSAsHZKldy+YoWSkPtfdVMvfk28insy4zMlM0/aYvv/ML/NcotcKYVrN574xo4fqZ9gXybLhwWYws9oHXn360kGysL+PGM/zHO1WNEjm8QB0glzj2FHuh9td+3dtUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mnOiTk4f; arc=fail smtp.client-ip=40.107.101.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXwVInD2J0Y5AuVQcSjFeQqQZ2Hzh/6SstzmUOC1nWapk7g1YjXqz2gh+FsGvC6zgOZtym5FiX1NxmMXdW1Oy3wqDZ+Lf+dratV1SdNMum38KhxfA2ZYgi5Ri8ZIOiA2XHJMwKI1i3MpSg05or8OEJJY7Lq00YGsk0UHgGOxXbt7EQyZHMZpZKtHf8KhFkqUQPaMnUEBk7kvxHrBbu5CUBRpskUtMXg7fvUNKjiWuLH/FyF1qJKfteAFD7J97x0e4zkkDJYTBBPdHiRup2iD1rKubgE4foHqBJwU78HqAbSp8bytuUDwVlyhjTkFRjbLWl6xmEcJzd9MotLa535M1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SC5ieKJRPIibYIsk8+PDlwLCXhwPUcg4QmSo0r2BD0=;
 b=J0wBin5XtgZjCRzBzt3ku9JTcs19Br+av81Nfz0xSRTYnZJEcjyiataiIjXORj86S6rw7VzszzRY3Q8LcAkc1UScXJWHY7+wQsR2MSrktpdDOi2euyzAXl3J/K1HEtWgYwJRvDl/roVBhQ/a7e/1g9jsw+c16qJssSzMUTllFICcL/RuFMI9JjVGRAJdEYNNN0lxlD8/I7qHvZbvNXXdfb4lTmbe7aIBvreuoR+LAz0EEkHV2kqBSG6n26rzBSQpYtBrgmDaIOze+7DRbR84d1uZDsu+Vs3DzwOpIoYIdT9ntkcCfwm0KbEI6LVNkt5uONL1ykUrPohXsD8tNacoYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SC5ieKJRPIibYIsk8+PDlwLCXhwPUcg4QmSo0r2BD0=;
 b=mnOiTk4fWbE5g1ZgoM4yv/QJwyjxFqlMYke3UYDLrp2LtnuEZ0qeEbjWWfLHfj3RVaEoHd6h0G/YXK5RtS30mnVTgnlCUnUYNvLaPohQ4Am1dFI04qxyRu27SnPX7bbGqs1XRPugZz0bRaP7mvMQB2Fs6AUZoZIHxPAYx47N3qs=
Received: from MN2PR13CA0036.namprd13.prod.outlook.com (2603:10b6:208:160::49)
 by MW3PR12MB4475.namprd12.prod.outlook.com (2603:10b6:303:55::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Thu, 24 Oct
 2024 22:19:20 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:208:160:cafe::77) by MN2PR13CA0036.outlook.office365.com
 (2603:10b6:208:160::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.8 via Frontend
 Transport; Thu, 24 Oct 2024 22:19:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:19:19 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:19:19 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 7/7] target/i386: Add support for EPYC-Turin model
Date: Thu, 24 Oct 2024 17:18:25 -0500
Message-ID: <be03f724136345f27d43f3d49f6154b239c06628.1729807947.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1729807947.git.babu.moger@amd.com>
References: <cover.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|MW3PR12MB4475:EE_
X-MS-Office365-Filtering-Correlation-Id: 259b5d2e-c705-46a4-1314-08dcf479e7fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2Ocxaoa/Yc3oecUgSbN324OrxawjtB52CYd9iTbimOu3XIu/Z7zAGwGFnMSA?=
 =?us-ascii?Q?Rn9xJ48C0xUtBe9EWHIxLVGVlsPFokZT6+Het5bt0sTvvp0YiRD2nB5zEitT?=
 =?us-ascii?Q?bf6Z2fG7BijsOYRy/iHjVwYOllQG2BDhQIUaLAuhby7wCZyupgMT642pEKCV?=
 =?us-ascii?Q?BDGHnB4sBgoPmYl5sIs1qMSXphFZ5pc6JfkYT2tCnA0RbVDl8Ji0KiCOJ/gr?=
 =?us-ascii?Q?xhyqcjEUULo4lg/vLrhztANmGRZPGPmiEF+bVtKPVzBIIV5adSDhZrJxSh/q?=
 =?us-ascii?Q?fTsidpyrN0PMZ89NS3qqFMacRyFguKIZm7Pvx01CucLlXhXVHbn/d69tqwBN?=
 =?us-ascii?Q?FwNLvJb0zwqcDkBYsSTn3qRSr3pn9o7mZaaKMEB3PWsgxaMarUBfltRuJDrx?=
 =?us-ascii?Q?MTKKcAyYhuPcdleZAzXzu+pA57J8VsfxBPwIuB/hr5jPCa1A45MdkSmh+TyA?=
 =?us-ascii?Q?bOHtKq/CqjHHd8wCqabS6zcB8I8j49x19V9QWks2qfg+uSrbRVYZgEDBKOPd?=
 =?us-ascii?Q?tbz4bx+SsOGdXNXV3rvBjVFVX9gdr7aVZfb1HI2KoP/VY0GK/qbVD3Bm/YlU?=
 =?us-ascii?Q?K9QVVdxx20z48eDqzjNjLOY0slTlhwDudmET3qxDHwqaXjhCL2AslPiplTm6?=
 =?us-ascii?Q?42W8rDFL19z0QCxOinaQVa8RxU8fFKhQTV0A/Gnx/4ozjYeW8RGi9ftNLpdw?=
 =?us-ascii?Q?ga+4aXNU2vht05K7G++aT13txwGdlMBIPPbByu2H0Z/LwOrJizr3ISNCEvgn?=
 =?us-ascii?Q?LiSaeV1xjRgLDb/BbnVVJLDc8sZc7KQyG4BjFNhZ75N4fzHcU7nFaLMlFV63?=
 =?us-ascii?Q?+25X2TeixeIbRXdrOtlxBFKWwduE5NFtkNgM415Fk8/bP1zznR78aFaBDYK+?=
 =?us-ascii?Q?9AW7dP/31l9wX3Nd/nJpAesGF6ryR/17Dtpq4eW48BEoV6d0SHiKlE0pXcG2?=
 =?us-ascii?Q?a80lIZmuDkWyKmYq9uLxtnGK5doAfZK/b++5SxPuEXpOpnJAmXFXEHujZr4M?=
 =?us-ascii?Q?4w/l8cuUDlqMq0Cyja68OuWkVlTOPSan8ZCKwsd33sTH294cXOfbfOTftRcE?=
 =?us-ascii?Q?Ij+YL5odzJ+CE7qi1UrqQL2i0zfsOe1YXJrKPMwNiuiQqDxBxWfoBlIPiiGL?=
 =?us-ascii?Q?0n9udCO7CGzkGUr2ZhvPNnkSmxL5KaUEBsl6KO2mnT2uLyvY2qF5WCyab8f7?=
 =?us-ascii?Q?mqoJ9GkaJCUum/nlV5kn2qN9eV13JVvIIupW14ok1vCmXexBJTKtuJ5TuevP?=
 =?us-ascii?Q?jnBb5t0WPRstsAyvsrEhDME1YCERqJkJ2Yb954NsYxQB3RgSHs6S14TKEA3t?=
 =?us-ascii?Q?mSk6rE+jEm6IupMlUlTEfKXSTMJH/BuyKx0Bz8u4dzXRIwv1LIbUN5WG6OQR?=
 =?us-ascii?Q?zJfqPANN/FIp23GgJE0GUXr0efBe+WTG8QI1AuR/xCa2zwDjEyZnKLgxENRO?=
 =?us-ascii?Q?B5/ELbbvVkU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:19:19.9354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 259b5d2e-c705-46a4-1314-08dcf479e7fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4475

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
eraps               : Enhanced Return Address Predictor Security
rapsize             : Return Address Predictor size. RapSize x 8 is the
                      minimum number of CALL instructions software needs
                      to execute to flush the RAP

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v3: Removed Zhao's Reviewed-by as the patch has changed,
    Added sbpb, ibpb-brtype, srso-user-kernel-no, eraps, rapsize

v2: Fixed minor typo.
    Added Zhao's Reviewed-by.
---
 target/i386/cpu.c | 136 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5bfa07adbf..eb49650450 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2411,6 +2411,60 @@ static const CPUCaches epyc_genoa_cache_info = {
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
@@ -5329,6 +5383,88 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
+            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
+            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
+            CPUID_8000_0021_EAX_AUTO_IBRS |
+            CPUID_8000_0021_EAX_ERAPS | CPUID_8000_0021_EAX_SBPB |
+            CPUID_8000_0021_EAX_IBPB_BRTYPE |
+            CPUID_8000_0021_EAX_SRSO_USER_KERNEL_NO,
+        .features[FEAT_8000_0021_EBX] =
+            CPUID_8000_0021_EBX_RAPSIZE,
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


