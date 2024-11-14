Return-Path: <kvm+bounces-31888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B689C9351
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 21:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C1321F22EE0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB111AD418;
	Thu, 14 Nov 2024 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nfHKm2z4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FAD136327
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 20:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731616623; cv=fail; b=FgqgxnFZnW3Zy/1u4/Q0A4U925JrsdHs2iKQH/N8zk2w5wLA+dPEcYFstp+mOqlU5GsREOsXAPtpkbKK9cqXpIbTt8YOyhEhgeVMRGFz2ZDs1mLwJmfSf5URdtRPS9dGyVOI0tc4lfUiqQHZlfI5rQ2hToIbSn1NXnwE5fWobXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731616623; c=relaxed/simple;
	bh=jpEaRo0lpsS3d1+GOWUKSMtr+1hVxVJu+vmBVm+SKTI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEYrxhXZZYgwundfX9QC8PqAkU+Cx86Sd5wB965MQzO06x6uydsI43zwgFoRGYgKFFDHtjjdnqzrgz/edCPgLz1zhqgWFoAOdzFwQRcywWTR4GYWXRlWsKLW4hluH3TFigRhaRZSJabuNqv0i7QTfVBPCGpk/l1TCQmQIlUdDR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nfHKm2z4; arc=fail smtp.client-ip=40.107.212.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJbiAadD1YgxpfN904GHsb8O4iHjB2sVd9J4FeklsTuN0mX3elGBn2Ln0Jt1FiUN8J5DkspN5WEc76KpnQD7ytjshqXK/k/5ToaaixwMv5cCd++UH728MbhY2QYg74apj9ZMLJz8hTX3ml9sCML49kyvY4JkmsUzmDL7nHqkm+vIBlzMwc0KWMRyxHAYmsFX3nI/kq6R575dQd263q1R3KvH1ORheryNbVLce5CgPkYqrQ5T0rnY2Jjk6XKCp8hPD8wFbiqHtCKe6xpyqAK/jldvQ017TmiosBa18Sy9//lYThWCYu0GibtO69CrysR4hypgWzEIT1nf+dKiT7Hr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEcinZ9flLyZTr//gLMdTQcANxNQX3YMcAMHPxvaAMc=;
 b=NAoLgiIDOYxgfVNkVI78P/5mxusAl1a5SJTm8B2dn/DN8QsdKvTSxYX5eudlns5tdInvWpmB/78+r+N8NZUpjBcWWvhPQiQMvDB/cA0BmAacb4scTRwR8G9peIDSXT+OCswza112G/d8hLFF9s0yEJ7lnxcpVc1kSxwqWKii5HCvpYy59LhGdwFjzRUJPnPvnH2nqopIGjvDokozIHvFzo4U2Pz+FAGnUVAJp5ctFiSwHz9qxVUzqv3CXXpOPb7gbls2mYXVexTYnoINCyCBP4UZR7en9g1UHEIlIzPv87O8ia2IfxTn4dbcLgns1kkR7lB9xu/a/rn6j0mEydetDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEcinZ9flLyZTr//gLMdTQcANxNQX3YMcAMHPxvaAMc=;
 b=nfHKm2z4qUtlURLubE0VT6b1eNjRWuAG6EYmgZgdVPvYxecLRh0SN6irFFIPpAuhkBl6SfAXdnffcYjQBI5ec9K4RK1/PPj4oy+RR0T7m2QkFmP1YQaJ5Pwu3dyNomUzKg8tda+2/jSydNxR8o7dB1yS2kMj6X7lPN9VyyVNG8g=
Received: from BL1PR13CA0161.namprd13.prod.outlook.com (2603:10b6:208:2bd::16)
 by MN2PR12MB4286.namprd12.prod.outlook.com (2603:10b6:208:199::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Thu, 14 Nov
 2024 20:36:59 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:208:2bd:cafe::53) by BL1PR13CA0161.outlook.office365.com
 (2603:10b6:208:2bd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18 via Frontend
 Transport; Thu, 14 Nov 2024 20:36:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8182.1 via Frontend Transport; Thu, 14 Nov 2024 20:36:58 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Nov
 2024 14:36:58 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <davydov-max@yandex-team.ru>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 3/5] target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 14 Nov 2024 14:36:30 -0600
Message-ID: <dd94f3911697dde1cb17a9ac959ef4e972556611.1731616198.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1731616198.git.babu.moger@amd.com>
References: <cover.1731616198.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|MN2PR12MB4286:EE_
X-MS-Office365-Filtering-Correlation-Id: fb7adeea-09f5-479e-9778-08dd04ec164d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JjX3zUVbWIjy7bNGa1MuLChMJ1yF7gm+/5TiG3oyKiAPm+EKcVwM9oYudLfQ?=
 =?us-ascii?Q?V0mJyASaInBI+YNMNJRyjKVEYVcnxSoD8tMj65DxZesNaoa3/JaSypN8VR/B?=
 =?us-ascii?Q?r7B1wG5UbdgHGeM4dWVXLbHOf+qkLi79fWgOGKf6EijpigPq9JtLJ9pWJvMo?=
 =?us-ascii?Q?Kg1hXn0LBg+hr+tIHdYaGgm56bt/BaC98cne832BczYFK1BFbgWnWEcFBdcW?=
 =?us-ascii?Q?aqy14hYbqrKlXWnhsETYYR1R6w4EI8KO0VGvpknb3tUDST/bosutITlALunV?=
 =?us-ascii?Q?foZoOoHaBdGkk9X+oVfNk55KSix25sYkysWYIIW6dGt6lydyrT2pQqI1Xqqt?=
 =?us-ascii?Q?k/56v5SsvKt3lHFl1e2aGepYvv6D1saznniW30gNq3yt7xb7bTqH4yXaddds?=
 =?us-ascii?Q?n4HPwgn4a5Th5uTHv6MK+zDqfBft1c3zW2C4x6lAwJ/PYJJqzUmNJCUVwQV3?=
 =?us-ascii?Q?R9/rypkEVUVpjMeVG7ZJa4sk1M7vmL26HPnH0ovLVjmHSAbl/mrA4GzEJw9J?=
 =?us-ascii?Q?cF8FkO+Hx82zLcIJ6NOBorxEZRd5kt8/Aie4csGUs8Rk6uy2Lr9d8h1XB7Lf?=
 =?us-ascii?Q?P+qaGy47Xc+NZu18B6lWGJA3NxeCO3wKlX31QruDLzFOrHtlP7DPvjoMn5B7?=
 =?us-ascii?Q?6fK4K2tm8UHnFrA3D4vMt+4ZJw/iOYzt9ZLZO3/0teavgWRb9s9M8AvJvoys?=
 =?us-ascii?Q?It3Vfu6kmK8PyqeJuB+E51OYLdqn7FsqnIWD+otUsKQD1urIltMFCO2Vl1cT?=
 =?us-ascii?Q?1IMO2VVNUxc0POT0ezVfJeMJm/Kf9HBRW3gZYqde+TZtrmTzJVtdlOLIbv1N?=
 =?us-ascii?Q?B6vXm++HKwC0NwbUxP4mzYCYjGhKDPliG4vaKBUMGfKgaWYAHOHWZSXbZzHP?=
 =?us-ascii?Q?pWgdTFm09fVDMibrRX0AaQ/+bIqOFiAB1Nmq8TVuWEYKTV8OYP0Eo4WvttHD?=
 =?us-ascii?Q?EOLIqQpmpQuXrFbMCYO3nO/1cKadtH19TQMMj7Ik+92YUFaKkXgBtweo2BQc?=
 =?us-ascii?Q?aOFEObJB+GIHUmrh699WUIub5R1BN77kQerHUs4rKfaT1C8nOOGy9Z1IXDIr?=
 =?us-ascii?Q?Djpk6NsIkSAmjDxOsM3xqN7iXrv/6lXnT2iz/LbVO/Nk0/NLyK+m5hVZ4lhR?=
 =?us-ascii?Q?xqH5kQ+HVGvvtdHWNfMRz3TnDolA5bI6+P/PNvuPyYeWlac0zSv9hcwMzwZc?=
 =?us-ascii?Q?nXwXyaA8S1Cq20HjiCyHfBme/cg4p/L3Sokbg8xXmdZ6TQligG54vduD2tQ7?=
 =?us-ascii?Q?wfgryj30/x0sco9/QsS2ViIoGNR+nelp4+C6mROhwT2vXksPtz9BO8kWxZvY?=
 =?us-ascii?Q?FW3Ve0FuMPPe5El9bGXanQHw8oGXwQLGoR0scfCaCYNtIBqVP0MnfrTAuK86?=
 =?us-ascii?Q?HcRBKbIA9u72AjboQNP3UDObtLmp5E9hvsih+GgwnhAwrRTLaQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 20:36:58.8785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7adeea-09f5-479e-9778-08dd04ec164d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4286

Found that some of the cache properties are not set correctly for EPYC models.
l1d_cache.no_invd_sharing should not be true.
l1i_cache.no_invd_sharing should not be true.

L2.self_init should be true.
L2.inclusive should be true.

L3.inclusive should not be true.
L3.no_invd_sharing should be true.

Fix these cache properties.

Also add the missing RAS and SVM features bits on AMD EPYC-Milan model.
The SVM feature bits are used in nested guests.

succor          : Software uncorrectable error containment and recovery capability.
overflow-recov  : MCA overflow recovery support.
lbrv            : LBR virtualization
tsc-scale       : MSR based TSC rate control
vmcb-clean      : VMCB clean bits
flushbyasid     : Flush by ASID
pause-filter    : Pause intercept filter
pfthreshold     : PAUSE filter threshold
v-vmsave-vmload : Virtualized VMLOAD and VMSAVE
vgif            : Virtualized GIF

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c21b232e75..4a4e9b81d8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2505,6 +2505,60 @@ static const CPUCaches epyc_milan_v2_cache_info = {
     },
 };
 
+static const CPUCaches epyc_milan_v3_cache_info = {
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
 static const CPUCaches epyc_genoa_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -5412,6 +5466,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_milan_v2_cache_info
             },
+            {
+                .version = 3,
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
+                      "AMD EPYC-Milan-v3 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_milan_v3_cache_info
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1


