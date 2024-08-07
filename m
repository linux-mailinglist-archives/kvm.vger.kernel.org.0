Return-Path: <kvm+bounces-23584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FDB94B2E7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DA23B21D47
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED7A155300;
	Wed,  7 Aug 2024 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sf3e0laY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6760112FF7B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 22:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068985; cv=fail; b=CNO6mASd8aRlTXEyQVWxtxglRFyqOIYylKiLV04s1cO+ixhrMgDOXR1ulk0pakXOErSJ3uuktZ+S1kuyjLJt8O+b2zbipIzkaxavreM9WdK9/RSIsmjzKJurWJip2HM9kY0CO5tsKNeyjjGcKTQ4ScUV/yQMOCu/rgp9LZA9nII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068985; c=relaxed/simple;
	bh=Fw9KVUBdGvsbEi8IcokP7GQKo0NzD2nk0LJXJF+JiLs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xg/2270Ex7oxoHVtVJsEhS+U5YG/o0S8tpF7fopVuscwk5bJCO3d0PDnLZfBFA4BmnDfnJOmkKUv/UsuKTye7ZEODo4ZUMzfIMUOWYTR+SnNU50MUjPsR53rL0gKCPHXVHV6p3a5ssmTWxdfneSyjFYjwED+8G5DdyFLhZMZpkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sf3e0laY; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2SsSXXeWzPIdnJfrEQnZnZsXg8YLc88maSYB7SzFHUGZr5dPzbs9nm1qHhA6e0CrJH+qszP77vUzNyDHGkhWUh8f4HYE6thj9XpI580Ox6zgA6z6KN0Tv0mRF+GXqxbv2S6G1wAJUqWysWJQZNsUsWIwMMQIMAI604ZanctZpdXI2S0YpYy0z856lSP7dnmNWIKwXK0d3T3sTH+ei7KGqCxuxrrqF4UWTbxzJSex/vsayEIl7GEdOi177sUuz56QqZA9dcPqYn+imb42xMM2dz2t8grgHa3l0n9GfpsJ1MrtqOs57jyf9bPoHHTPqjEm6EOgyv3B+HX0vYU4PQb8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qU01wNr2K0GjJI3XmGsd5NMH67il5Lz5Cf7NsaqNyAA=;
 b=tYpvWHd1+RDdxJaHOrBGSl8bGdxUDKGII0Fz70UX0O6v21oywny0yQJatzmM/rFx2LRTF2O73H98H1bWATQ6Ek6LQ4414swZubuQxyq4dszMgJE24VZKTDVW7wpj2KFqQ2kJuHgK8fQ/FAUXt9IarP++KmxysD3M6+p9I7CE6WRd85vv4N5coodqIp7knc/2mD7N6LnOVCGxjiTO2lS9r58JJ+Xot5lZeAraWAG0u6BT/LhEqj0JjohUS8rhQ3WsakQkpPGMV4V+vPfLNGw2S4J7Z5FsWuxo9GuSrwrleqUSw2r/skX9UAFa55LvTZHDimyeuEwv2Tr22nQPRmUWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qU01wNr2K0GjJI3XmGsd5NMH67il5Lz5Cf7NsaqNyAA=;
 b=Sf3e0laYTD7PQc5UEcrYX3CFY4w1tw4DK/yLaLzYeVibnEqV26RsoEzMxzP7Jt92hNNUsV30vNwpVBtMDJGRH7BPc1DbPdHHS7rwT/fcDnEPs9xMZJVdFZUjY4Ia5Q3mnFX8VTnVWnrdKx642CyfFpeK9QXiGZxyZk372YEe3k4=
Received: from CH0PR03CA0336.namprd03.prod.outlook.com (2603:10b6:610:11a::8)
 by SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Wed, 7 Aug
 2024 22:16:20 +0000
Received: from CH2PEPF00000145.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::99) by CH0PR03CA0336.outlook.office365.com
 (2603:10b6:610:11a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29 via Frontend
 Transport; Wed, 7 Aug 2024 22:16:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000145.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 22:16:20 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 7 Aug
 2024 17:16:19 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <babu.moger@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 4/4] i386/cpu: Add support for EPYC-Turin model
Date: Wed, 7 Aug 2024 17:15:46 -0500
Message-ID: <5dfba6e394efd09ad397ebf812757235ddac84f9.1723068946.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1723068946.git.babu.moger@amd.com>
References: <cover.1723068946.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000145:EE_|SJ1PR12MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 31760b82-927c-48f6-3db0-08dcb72e909b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0kAlC5kjiOH8In0KDAZ87gBkzUpGbQMKlrbuiOuUgxPHx/pja2FtAsAqJ1nv?=
 =?us-ascii?Q?EOXfyi/Eh24e7oDt+x63ILBeY3EnMt/0aYGCL3kznBvYH9/pvhnHBo3lOneH?=
 =?us-ascii?Q?Xol0s/2fTuFqeNAG/J8GM4uC3E9bvpd8slM7QqP02+zLDeQ/vkWupJVTXg6c?=
 =?us-ascii?Q?qW6G6s6YcdO4fdOa1c4MjlobRwZzXQbfNqpkUDktRkFhQx/0yXhHx9fAwleJ?=
 =?us-ascii?Q?ge59qBHjiC391Asxo/FnW8JjjyCSZevo6eCVILshD5CeTJkhLYdpA3Qy2cZN?=
 =?us-ascii?Q?1QoG3up8gTbM08BfB0IroXsb4v8riE5Fnk87tyfWORS8xZF8QciSlvHfy5L+?=
 =?us-ascii?Q?eKUZx4CtQY4Y5vWBaoOIJUbpAYlSreXFgNuD3fe07Tc/rUTqzagMlI03nAa4?=
 =?us-ascii?Q?an4H1Lypk+wISdFpbsJGrSDfd8SOzENq2M7xI0gar2a9s38pFYYLaRvpFljN?=
 =?us-ascii?Q?cew32UrkI7dQxZMTfmpwfixLp/2spFIaUUAk4QG04aS5QanEZeKIxOAJJLGv?=
 =?us-ascii?Q?zZgSUc5i71rzMSFQwlW8fnKPqFbB0/zpbDZvW31ehOPYMl68HFbugB/6fHIc?=
 =?us-ascii?Q?yTzKChJnGdFUSzUVOStUe4ooc+CCz/HmzEUDAbW1PZhJ4H2ia9RZYEo86sYv?=
 =?us-ascii?Q?vfjI3Gba5LlpBXQT8GIU9/xo1XTr3KGglPjCCfilaeWQpoB5dhddab3cRbjq?=
 =?us-ascii?Q?pGK99cl5OTPXYdk2JxLS2v4G0Ox30Dyc6pLYv3GH+4ts56y9jUVqHIslh7dm?=
 =?us-ascii?Q?i5asf0WddbeR+7gC4ogPClNReR7p5KMqwnRkMNWq2b1AlO/INVz1FyKbPasn?=
 =?us-ascii?Q?KqWkdJojQY84ng3vr38YFyD5RpIeTCbyAy7tSAXkExkXdK+f+BtfTIM/5fwX?=
 =?us-ascii?Q?CLDYRMXxeJOPoUUWIqUX/LXgbAhNGVRhsmLh5/Z4SwjPAn2yQp2/QVJC2KaQ?=
 =?us-ascii?Q?ONIEKZSdC5BpfzDNdFlmPuwz+GozWY4PO1NxMVX/+ANZtJKfXN9vQIJOzBvA?=
 =?us-ascii?Q?cqM46GAuTuwa3S1He6nSjQF1pKdT+yxK9nazrg3MahBu2mzI/UFubIJJkxsD?=
 =?us-ascii?Q?Et1lHIO7KTNTDm7umzAzdQk1VJvnHsoSGZE2VvbM6hXvBDyWbFJ6Dktpyl0j?=
 =?us-ascii?Q?rC3aLuBDG/EkRIkc577rfpBB6dQ+CT7PJFo+x4j21wWJRfn9a4ZXLwVfiz4Q?=
 =?us-ascii?Q?wR88huqswidClyTIpVPYkTE6pwqhmwMQQPGXsSl03jhjEU3ysCL+dYwjgGsD?=
 =?us-ascii?Q?JYVwLpgSTPLReaXMpWiYQEYH0DGMpBGqux/vqXZPGaIWyOH8YuMqeX/TqLt3?=
 =?us-ascii?Q?UzGz/vKLGDkGLGG4oqm9kWFvtSEobcxZhku+H1KhvLC5tqU7Mvnf+EEGhtF+?=
 =?us-ascii?Q?X8Jy1RfLzDuoC6Z0k80fYJjiqo/xFLwzqs9Jb8tgjn5GxhYIy1qBtAcdLLuP?=
 =?us-ascii?Q?IV24gSysF0ap6xTj5SfY7jTS0zv7aZsF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:16:20.1301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31760b82-927c-48f6-3db0-08dcb72e909b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000145.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074

Add the support for AMD EPYC zen 5 processors(EPYC-Turin).

Add the following new feature bits on top of the feature bits from
the previous generation EPYC models.

movdiri            : Move Doubleword as Direct Store Instruction
movdir64b          : Move 64 Bytes as Direct Store Instruction
avx512-vp2intersect: AVX512 Vector Pair Intersection to a Pair
                     of Mask Register
avx-vnni           : AVX VNNI Instruction

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
v2: Fixed minor typo.
    Added Zhao's Reviewed-by.
---
 target/i386/cpu.c | 131 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d88a2e0e4c..2e1d6d957c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2399,6 +2399,60 @@ static const CPUCaches epyc_genoa_cache_info = {
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
@@ -5317,6 +5371,83 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


