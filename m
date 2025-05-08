Return-Path: <kvm+bounces-45976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA38AB0431
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E35FFA0088E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735BF28BA91;
	Thu,  8 May 2025 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WZ2Uz9zt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC83E288C23
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734307; cv=fail; b=rrlTFKvzqTzXKsCR7CfF9bitgloNtHpAKWRBlrl8tHlTLcRQ7Nc4DUkytjBhfG4oV3VpuF243wBf/kJkBUBYXO2ZGVfPNEJUklZfR27kpNUPhgPW83a/6t3jVIqwQzmIug7gY/rtQ62Je8sDocgtJRGE7lIe5KCNFWBrvMaKeLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734307; c=relaxed/simple;
	bh=/t4xd8cGuhx1KwCyW52XjR2TB40zd5JDCT60pkm33rk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoPPZ5qGJqyLnTeRbjz34NKPfpgRfuEt3kW6ELaGpr483oETZICgVvtaOMwkuKPTOeg6vVGt5QYfT9JIhTQQXqYwG2VgEve4vYQDz3y4T/PBJ+Rre/HWgZCN4gWGRkTbM5dzWl+6Q1/fiptd6qh0jRqNa1y/+5PwvyEwF76kSEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WZ2Uz9zt; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CshZ9QxBsKXJrZsUtEQ0XkTeIDwoshs4U5XWAB5/rAJjHlKjtoWvV6SJGsYyPGeFQO4lJztbk5UtMrYPNv+k5YFgO2PcYGltwtsBVLQgiCE3uITLVBzGwaUWBsc6E77+AMuIeCSkSatOMnxg5TSsu5PMXKzdwEcJrLh8CX7JTgm3X6eePvvyc4KnMjtAJZ+f2ZE9mqornGtqr9jReaq5ZhbtgDkQQK3CqWYzcZuBV9OGSqYCkLEDsicA+eIztTXIedwnyUQImEhAbA4Gq83mIcfxB5a8Bc/sKokaIUTCD7mMBuLsIZlBiFqTghiym3+H+fmvF4UPBHrYTQ0XnTaQNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28XVI3MvKz6Uje75BfTagEnGU1nb1TBSS6AcascaVo8=;
 b=eVcatrzqeEb0SoOp3t/7ZjjYzR+9qmcftR5xnp8GoiA37f4qEcUyPP8w/tps4cQyWXsy9xJedkoQkhPYjfTecK/3WoryJSwfE4F+TlzZgy5c/PFEVNmBXIBE/gZqO1znoAhocDeEJdCooBcD43fPxQIiPacIuNNe9LElzfCsohmvBZ2KxEWNKkmIVFgMsiFgwByseVSVWfzQUc7C7+PnMV/3LOtHCqArWN91zucxpm/u4jLfW6hxMvL0Oq1dKGI8UEtJE+NUFZD95UAZrqG1uGtPlXw8no+YBx4SwoeFA8VK1GgYaS412T/VFYf8gANuInxuA/7TMn1b13DMAEjykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28XVI3MvKz6Uje75BfTagEnGU1nb1TBSS6AcascaVo8=;
 b=WZ2Uz9ztoYci12p7MYrAtfCdTxREz+1xA9V9UI5lcq50V4dUlp7FIE3dx50dv92Ow+7pxfZbav4fDnkag87fzWiGABTYkuJLGAhSlPhcxKwfzJk2RkGVEWv7j5uYO1NU1GXdIBF2pNYLYBWTkDuXCokq4TMKF7B7e5ZH3vtWr9M=
Received: from DM5PR07CA0098.namprd07.prod.outlook.com (2603:10b6:4:ae::27) by
 MW4PR12MB6998.namprd12.prod.outlook.com (2603:10b6:303:20a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Thu, 8 May
 2025 19:58:18 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:4:ae:cafe::3c) by DM5PR07CA0098.outlook.office365.com
 (2603:10b6:4:ae::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.32 via Frontend Transport; Thu,
 8 May 2025 19:58:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:18 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:16 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 1/6] target/i386: Update EPYC CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 8 May 2025 14:57:59 -0500
Message-ID: <515941861700d7066186c9600bc5d96a1741ef0c.1746734284.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|MW4PR12MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: f36f8fa7-1e6c-4439-26af-08dd8e6aad77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FLk2NMHsWYT/B5IZ4VRQfPxEe/lfk0RzALSYTMzsqZ4yRppjYJ8Zbu+VOfpk?=
 =?us-ascii?Q?wll/vXD09FMU3NC2ZPyohy0XfHDbMkr0c70rHWpmk/4u5f3kZA1Evm8u+SRR?=
 =?us-ascii?Q?oIQO7B5frdXmYoEMosbW205KivgTw8SrrthF0/tHzNe/JkS3Ao3jXnDMwIrA?=
 =?us-ascii?Q?HOnZyrTUA5dtwhNh/5jgOMGu1asYeongj7LfyCbPFUvCt93HMIIQVecaKLDv?=
 =?us-ascii?Q?+nZw88vCh0oxPOTk6Cxv0ETsHAB5ahyi4CK3tzskHnF453dZ/58PuI1NS8lY?=
 =?us-ascii?Q?7uIk1ungXwNZCmtN8bcGamsYm6MZfh7PkC0KmLnF02+BARXnLNAPunjeskSI?=
 =?us-ascii?Q?IUo+GjTO+QCnxhYb/XIqfe7C6CO80eqXZV28iEhP2IUDfywnGoEF0HYGyqS4?=
 =?us-ascii?Q?srOvqqKOAHFI6o/eYOmvMYypfLjul8cQ+YL3Rqsz+umdWSWn08uRbEIQ1Z+T?=
 =?us-ascii?Q?WESyPGE+ebY4sSjEB+hXWSF7ZIl2gzElK1FdGIlkfUSXU0xhuRYCcAM3bhKQ?=
 =?us-ascii?Q?0fhpOvLfyU28Z7WOq78F1bgu7N5RBlIiNalOaSv0AbC258MwesueJWohtCKs?=
 =?us-ascii?Q?AnHtbRKH3X9r6RXLdcHSmc84l+1L5u9muW9gbM2WrdyuNTyk9BLyVFjHmV/8?=
 =?us-ascii?Q?l5jGjcQShygFaVqyrjs/EZybU65PCqmLA+YidUb49hs5gZUYJi7bERxKIj5r?=
 =?us-ascii?Q?TmohcRSmFpGsodMea23RCdHlIo+r+XoEhSlXNysSGOWi6XoROVyIPHOw+MIC?=
 =?us-ascii?Q?JHq+R/1oosM6YSfpbFGxRhH9T+g0XmUFfyZKp7hc11LP1n6uSogshd/ur+M5?=
 =?us-ascii?Q?q7kh5+NiPZctQoSHMhueEs0SiEkXbKjBgLUjVl6uOANEcpBnjnTDlPGAytpH?=
 =?us-ascii?Q?Z11rY+jFmR/lLcpgzYOea2WLGaQeEglf9WBhnp3TIV09jvX6c1SOSAb7wZDn?=
 =?us-ascii?Q?tCbIITlGRQ4rjCF2nAl3ku2oPqON+t9upDgzj4Js+eF58mkiOz9tLu5UuA+R?=
 =?us-ascii?Q?Hc16hQOce+L1RaKE9e5D9AGHd6G61WTeDGoxSoHQvVA9p6icjk25qEWRm6q8?=
 =?us-ascii?Q?O6BedYKF4SbOSP8X0q0PXHLENdGfkYX/dFNa9eESXZ0OR+I1cQ9i1mDqNZ8M?=
 =?us-ascii?Q?Ue0MlhljBrw8k6bvg+STW10IQq9DZYhTl+bwNk2ePvHlGS3KiLBzBQWwbn2R?=
 =?us-ascii?Q?I/os6nOLlK8BoImxbl8Gdp3P24JeUupWnGe6bIKNnjUbND/nEjt4WKCPP/Fo?=
 =?us-ascii?Q?NCU/KNbq+X9sldAbmHQcxKFV2Qm85Na2ZD4/r3IPETgaF4rjE4vXeoNL/n9W?=
 =?us-ascii?Q?VT5jMsXpwjYvCfCyl9oVp97xzelmMfDJVXhPe+IZ0ndUyPaFgICYjjPXkjri?=
 =?us-ascii?Q?E6G2b4XRBdPwaRLja1WHYRpFZuMr8jH5BmUWso8AaY9dNwJrIWqCrtNrvqV7?=
 =?us-ascii?Q?0LFdfRJ2y+qy1fCMYAjoAdjWV2Wssuw7xk3TUqEkGxWd9fTZ1NttOSguDx47?=
 =?us-ascii?Q?a0TNJdniPgb+Jp++O5t5okFfKlQLCb9CufkB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:18.3603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f36f8fa7-1e6c-4439-26af-08dd8e6aad77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6998

Found that some of the cache properties are not set correctly for EPYC models.

l1d_cache.no_invd_sharing should not be true.
l1i_cache.no_invd_sharing should not be true.

L2.self_init should be true.
L2.inclusive should be true.

L3.inclusive should not be true.
L3.no_invd_sharing should be true.

Fix the cache properties.

Also add the missing RAS and SVM features bits on AMD
EPYC CPU models. The SVM feature bits are used in nested guests.

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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6f21d5ed22..49d3ae8aac 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2185,6 +2185,60 @@ static CPUCaches epyc_v4_cache_info = {
     },
 };
 
+static CPUCaches epyc_v5_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
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
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 64 * KiB,
+        .line_size = 64,
+        .associativity = 4,
+        .partitions = 1,
+        .sets = 256,
+        .lines_per_tag = 1,
+        .self_init = true,
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
+        .size = 8 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 8192,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .no_invd_sharing = true,
+        .complex_indexing = false,
+        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
+    },
+};
+
 static const CPUCaches epyc_rome_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -5212,6 +5266,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_v4_cache_info
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
+                      "AMD EPYC-v5 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_v5_cache_info
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1


