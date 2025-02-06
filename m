Return-Path: <kvm+bounces-37527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF12EA2B23E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:29:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A41FC188A7B7
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ECE51A727D;
	Thu,  6 Feb 2025 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pudBIbNd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BEA1A5B96
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870148; cv=fail; b=tajbW5TzRgA5JTJDBXUei1HgX/Hw/rXbBWb1ERvxwKj43oJXaywNFuFfYMbLSNm2a/oGBMyN3SQdk130uAFJz9IobE/Bie7KG4nNjg38COXBpViFRcZs4vuEh0CFGYuTDSImse8+tx7e5ETdwi5/nHcOYcuSmo7TWKgFm/aVkBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870148; c=relaxed/simple;
	bh=GKOMXiEyDec7b1irHvrChAs7CuVxF67PLvz3/mzd5Vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8j7xpIvg9NEPdUNLOBwYW8K36IlxeFtb6g1TEQ9lNSe1VmfA8PXG4e62nbPUWjvbSU6RzPiD62oRbNvjxRDR+s3M1TVWQ8ujSvxXlIvDVVGxQiLVjP4FpWpjCJCd9un+TNL06PLxNvnsSIA2HCHTYOK88MikzYbvjNng5gSkyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pudBIbNd; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKMWsvO+yk2ZSdVXYcnv8RMPWmnkWpwTnlGbW5lbhCr+6aNiHaCJeqwChR6XVUOfCcdDXraa0k84JlfkQo/ViE12TEBIxr9V0MEkNa38mGZPvrtrM/0XhjVsh+Sy9+a1tvuXWvoWLnjyC0SJhoDncUssqQ/Uvwg+UTK7nx/x6ayJ+CiSFxB0EF5M4YW2jX9QjIVxS3vdRa80U7QokFEiT/dkVKWJNq/Ywg7Gs4rJmlbdCNDP8moyktXXpweKv+XsoD6Eg9LpYtRImrVD3WJ62luGoOeHfnjdUHmMNkGGGWcV4O4IrubaWfmcwhY5FDeor7yP/bVzg8TvOkf1hHDEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ga/T1i8IQJItMYvM8ZplQ8QieS1uvKo9NsII9ZUje0M=;
 b=MOa2W8IVWSbkPfXKPU55Nrv7L9b2A+75epjqVY7U+v7NpFVwc0ZRolrU4Sz+99WWakqPgYVi8z3d3ol5rjlOR8Wj//S8qV6kHO5b9ZWxKCo4GLn9Kt/kaf94kBVvvh2uYv9TJKOSL0HWl7S5ddtuA+Z5eUykwsgRhYQ13opIWQPnlXtONnokjY5G4/31s4Nqt4OfNG7MOpBcKXTRRvuVHKngmZYEJ+ogmfpsf7Kr2gpMAr3mLcWYHBnq2H8Uel0lBGuV0rHWDFxw48i1wPY/GZu5P8zcN0wBF+9iupbRpBTBLyAfTn5QN6O8Ehn2gOqgqUDJxLdKqau/6vIngGrd7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ga/T1i8IQJItMYvM8ZplQ8QieS1uvKo9NsII9ZUje0M=;
 b=pudBIbNduJzW69OeY8oErq7Ng3PwmOoWSx+rxnitIxKAgS+08Kf0SXAqrzy6aZqqGQDDBqFuKpY107LHG5+BB68p1O8+1Aj+7iCkglcF5oHhJFSGIJe6vbLMMxM5natWErIKD48bJQ7yVZ7kwwx7cnYVOvkZqUK0PUJLzPal2nI=
Received: from CH2PR05CA0048.namprd05.prod.outlook.com (2603:10b6:610:38::25)
 by CY8PR12MB7612.namprd12.prod.outlook.com (2603:10b6:930:9c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Thu, 6 Feb
 2025 19:29:04 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:38:cafe::5e) by CH2PR05CA0048.outlook.office365.com
 (2603:10b6:610:38::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Thu,
 6 Feb 2025 19:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Thu, 6 Feb 2025 19:29:04 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 13:29:00 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v5 2/6] target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 6 Feb 2025 13:28:35 -0600
Message-ID: <8e40e18b433d2d152433724a15bddcacdecbf154.1738869208.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|CY8PR12MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bf16c0-f9f4-4745-3c7d-08dd46e48438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?snHrAFgU8ozjXtNkKEUy9kt3iYNe3UABpRdHVO0lJMS2QCjY+5o1zi1DbSs2?=
 =?us-ascii?Q?JHnOBI6yyzDH3Uf7FI1zWXe7vg8zO6bsFHyoku0sgDt3XhXRA30+46g+76qA?=
 =?us-ascii?Q?aKoZLyUtCzIfxjWr1+MIpHa8B3lAsMPNYfWINY/tpdeI2iHYEGDQUCLIP6qU?=
 =?us-ascii?Q?dP3J+qCI8e9N4C14tZW77QTN2FhF3o5R5RFnd9dBu1M2EUi62AGseL+Dn4n1?=
 =?us-ascii?Q?de4LoKG7ApCRIGUE99ZYuWdZO7IuQaUwOyag6boRtwp6KKRtakEd60kOhNlG?=
 =?us-ascii?Q?K5LdFvhuD2aWCskTGotWMhUrar2YqDr8LbHUV5HGVy2lmrTXMpdF1NXXG8mf?=
 =?us-ascii?Q?Fxs3CYWwjGQLgzwnrMT+8fpmGuMTNLUw+UJQWaV/bHwTwgVPX/BwR3wPVDHO?=
 =?us-ascii?Q?UJfOStoq3OGlRpebifhPUS/3SrOw1HFXu4RAEx3/zVdNLxjmZi6y/4v8L1q0?=
 =?us-ascii?Q?8Yei5JT2Lwip/MHcedbIIIpgoups/Fm+afmsItarkG+ykd0vAIR130Od3LoK?=
 =?us-ascii?Q?FhSOTSHFaBqx6d/L0oxKPlQ9X3rKMYUA1Vb7FdD9R8pd6hmY6pNgnZBz7iBE?=
 =?us-ascii?Q?ogWrkEtAm2+AgGOhpc97o3I6c+vOVTzXwBotP/GLjhlWRPJnxuwRTBeBk6Hf?=
 =?us-ascii?Q?iN3vRzF4eJ3lT88+sLh2CXrlRI1lNrL4KTt3WrK2MuLdbYqRkTbg/LupbsOX?=
 =?us-ascii?Q?FzGkjlL69Ty++1G8tFLqusTLB2+r/nM5TaIuqU7HmX6dJg9yKR0L8b8javTG?=
 =?us-ascii?Q?VxVEaXF7uQRjid/2rhwQ3d0ANQehJZZtkU8K2reSnlYozrZYFkTjjoVoBh+R?=
 =?us-ascii?Q?jgQzaYsE0sAA7ku6a7APkF6lm7XQdVpgeqhzrh4JA5GmTOPjSshEWIa9XTMw?=
 =?us-ascii?Q?hJMVSso5j6Wkh4MRXAGaPs6zrTRD3mtlUe+OS7WBk4/uuyzXPWB82b8+CkZB?=
 =?us-ascii?Q?tU0640aztScHQXtziUzNkDA3dtiXiKx66XejQ0MUh67/hhfhsncxlhPW/m64?=
 =?us-ascii?Q?e+1c8710W2d2x8xDLOA/uhVNaZXlpgSQi5dTDbPK6YBw/rqMzSi04+LC2Hrl?=
 =?us-ascii?Q?jb2OYBp74nsYLKoSVy47L1CuP2u2eWyc6LvaHGWlocEkGBOa9VSkLChWygZz?=
 =?us-ascii?Q?dcQYEAy4kGjB+YjnYkuBieeAn/x1bAQmv1aW4+iAEF1ttkeeNWBXwQziZVwg?=
 =?us-ascii?Q?KJWx1iuxGM9NQoXnCxhsR9iN1tTQLqXxU3mQNJ/elYAaUaeBmQVV0N0cHGM9?=
 =?us-ascii?Q?MAKT6S5YAlqE8L560srZC2Q6av3BHm9SbPQyP6+Vq6gWgVw6L4VTBYEMxVek?=
 =?us-ascii?Q?upBQe8ROC/TN8yVFHvFXTaYgPbrKqfo5TyD/cyFy1noouFymfZn8B8wrOvOB?=
 =?us-ascii?Q?Wm7bQwlzUAmjmsF/V0t8c5NuYhM9r5aQ8OK/VhavL9eNgQfxrIJ+8QukVauG?=
 =?us-ascii?Q?xDXSi2WMHzwYzV8+m920EYU2LPS2mztm9bu0gIe0x+xhJhCwjiCCjnnkFkl9?=
 =?us-ascii?Q?v94vs4ILYdYAerc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 19:29:04.0463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bf16c0-f9f4-4745-3c7d-08dd46e48438
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7612

Found that some of the cache properties are not set correctly for EPYC models.

l1d_cache.no_invd_sharing should not be true.
l1i_cache.no_invd_sharing should not be true.

L2.self_init should be true.
L2.inclusive should be true.

L3.inclusive should not be true.
L3.no_invd_sharing should be true.

Fix these cache properties.

Also add the missing RAS and SVM features bits on AMD EPYC-Rome. The SVM
feature bits are used in nested guests.

succor		: Software uncorrectable error containment and recovery capability.
overflow-recov	: MCA overflow recovery support.
lbrv		: LBR virtualization
tsc-scale	: MSR based TSC rate control
vmcb-clean	: VMCB clean bits
flushbyasid	: Flush by ASID
pause-filter	: Pause intercept filter
pfthreshold	: PAUSE filter threshold
v-vmsave-vmload	: Virtualized VMLOAD and VMSAVE
vgif		: Virtualized GIF

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 94292bfaa2..e2c3c797ed 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2342,6 +2342,60 @@ static const CPUCaches epyc_rome_v3_cache_info = {
     },
 };
 
+static const CPUCaches epyc_rome_v5_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
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
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
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
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 16384,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .no_invd_sharing = true,
+        .complex_indexing = false,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
+};
+
 static const CPUCaches epyc_milan_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -5418,6 +5472,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 },
             },
+            {
+                .version = 5,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "lbrv", "on" },
+                    { "tsc-scale", "on" },
+                    { "vmcb-clean", "on" },
+                    { "flushbyasid", "on" },
+                    { "pause-filter", "on" },
+                    { "pfthreshold", "on" },
+                    { "v-vmsave-vmload", "on" },
+                    { "vgif", "on" },
+                    { "model-id",
+                      "AMD EPYC-Rome-v5 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_rome_v5_cache_info
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1


