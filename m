Return-Path: <kvm+bounces-37528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B390CA2B23F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EADB73A50BC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CAB1A7253;
	Thu,  6 Feb 2025 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TdqYViX8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAFF1A5BA2
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870155; cv=fail; b=tIwjkdwsPmHnDuE2fhU3H31bK066Bzh6i6Hj26Fy2P6KMD5RoDUHKiYje1kKs7O9iVFzQ1tA4elWg5bHoU4MtgT+9kje+uL5i7UIQm1isheb9l5HXyflwxUyhuZUXAMNH5wpqybD5mCtcrs6yIfIvKNyQy4gN/z1zh4tmJqJDGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870155; c=relaxed/simple;
	bh=3+0GKwrcZGmeMhi/y2oIKvXUDrNTZDkMiJy6VU6h/6Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1qY+pUvQfPSR5WnK5RKzBGIQTFVquTUXYkRgI1VjZf0MB75THYh+ldj+zQaMMikt8Xa8lcxk9v4Xz6yGs+DCWPYtntCfKcckRss+yRbxq0oCbeYypr6oLdWqoBd0OSVkY3ZGX0Ezus09i10B8PrOxguQFM8b17iz8rq+kB9SJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TdqYViX8; arc=fail smtp.client-ip=40.107.96.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRNI6cGA2DchHiQ86+PjcKTH9sfoPIWpoGMT1ZP16KQbzWa/JHTiFhczN0RRhnrdaejQmg2gjFheusjA5/4rJj9xa2bg7SIZhWHIlNFcsXfxHZODjwS4C4+ptdGvSZmz8k6Pg75NJNfaKAVoArwWPI87AswDMOwePGeeW2r6odzKJHSRST8orzwmtBmCQPueW7r7ZiROh5WkleevlNJaozJZZ7oO1ANqiCQuFhQhGxp98L36Mn0SPNkNp/F7erQHXieXjg2k2j0BkPU8X/cWXdzLUJlKAbRs5X+nxonGbUUA5T1YJYSAowWDn6Zd+2W842k2ORZ3lMA35AC4DK6kfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=exPQAD3Kzo188Jk8F/8dIfvNzt6mI7GaFTZDUhL2jNI=;
 b=P2bg3/uKC6qlTSjb3Sflzon+std09+Nkn2VzHs5tsoRaoaDmx7CW0cWv9UxNqUTtGN+FyVh/PeCLOZbdO7exz9Ja9R7bwso5Z5xKGv1pwEjwcbDbCvFnHBsZUnOJLBBS8NUcd5OU/p5uurgfLfKAzuOhw7QhkcpKIgJxYjbod9t26rRAGTytLe5KcYwX12Fvyddz+6w4kgVkNoR1A0cc6oGx+Z92yw1u8me5d6s6TuDZCKOns73XK8caNUXslcds7wWjsKUUzmdg8GsbcOkOaA7MQrvGgH1dYp/XWLR6NkBFGVFJHpFoe6t7kihBQso3uDEqrlbgpjxdnmW9LXPrXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exPQAD3Kzo188Jk8F/8dIfvNzt6mI7GaFTZDUhL2jNI=;
 b=TdqYViX8M5ZGBBIKuOAusfv3c8DIPSjvmN7EKnu2nCScVVlzO+M1kzYNokTRcxswU689i8jTPmrMyl+2oMAYEteS36I3H1c8ElIwljEQT2VAwb6kpYRy+onSomQ5MV4f0BlpAgh/G2BMppj2EIRBt1gI57BwDocP7vphig65dIA=
Received: from CH0PR03CA0389.namprd03.prod.outlook.com (2603:10b6:610:119::28)
 by IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Thu, 6 Feb
 2025 19:29:09 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:119:cafe::19) by CH0PR03CA0389.outlook.office365.com
 (2603:10b6:610:119::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.28 via Frontend Transport; Thu,
 6 Feb 2025 19:29:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Thu, 6 Feb 2025 19:29:08 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 13:29:07 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v5 3/6] target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 6 Feb 2025 13:28:36 -0600
Message-ID: <e1aeb2a8d03cd47da7b9684183df06ec73136f87.1738869208.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 04332c21-43ce-4f2c-06b0-08dd46e48725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WUtz1TDqT0Xu3+viOn1ZQuRlx2l3isEddgnIWkQuDiKN3mRHNmKFHxlmVjcS?=
 =?us-ascii?Q?CvOPnP9sJlml1RNe+BFE4nxuW+QUQe+vPE9RblZzVPPLoHJLfPlKqHoML/qb?=
 =?us-ascii?Q?DwMcdgMDc4qaMRsP6UO4jyQwqiiMiXnu1au9lP1i3yvQoObGT20IRbTW9ztJ?=
 =?us-ascii?Q?aRGDpUdc2PJ7EYQXagfZio+qOkJ8+FT5bzTx4A01p7ewoq+dL8YXhs/+hNxf?=
 =?us-ascii?Q?OK92L/EG3zaQQVa1Hlak/IKC0gwQi8Wmd4fvSwwHUn0PVAs8rub6hYq9fvW8?=
 =?us-ascii?Q?jibdGDmQ91KqmU3K/FMP+3FbbKajW6PAsnYdm6j5T/fWQluhaK0MDYNGsF7J?=
 =?us-ascii?Q?LVj0sBl4C+BaQUZsiBOGKaE8q0F6rMW/KQxML2VuRfkHSkMyWsVA0kE7xEAI?=
 =?us-ascii?Q?51m1t4wHldtazUwLN43NZMWIu94si/H+0BWzl5TDhJ1qD2fr8uVRm9kVp6by?=
 =?us-ascii?Q?0X1UIi1tHEF3c7IYzQyWqcJaC2JuEaLSpFxifs4JvEFNs/0TMrHwzFMwuCC/?=
 =?us-ascii?Q?AD5eUiI7xbf4+fPgfyJYnkv9ueA+aDiphQtgRZymgv0dTmQlkzMHmv7E2Zv0?=
 =?us-ascii?Q?SKuN5iQrZKqFmX3PQtZqRPa4Xoki8Wkyj0p0KJ5Ap5GFHjITCC2Urxs3gIUU?=
 =?us-ascii?Q?Yr7Vtd4P0xzg3ZFZtqiDYP1xBgOCyfoHHfJT6gBy8UC7cvVru5eIZ4eABLiS?=
 =?us-ascii?Q?mcVMi47+bMUyo/xqP73dlX5qAdoQYR2odLTyJuoX1WyEH/qdt+0RnSnAh8YI?=
 =?us-ascii?Q?JJL5JvL8PpyR8fVF3bhijLUSpyJ8wve2c2f2pNUKvDcXzEb2yWK5y2FPmbOD?=
 =?us-ascii?Q?3wwo28wI3/MrFjuWKXQNRZYIMlskGD46GZmgdIze3sJtVe5x5Zg6H7GPDRbu?=
 =?us-ascii?Q?r0KqViYrQTgNYk5u4ZeEzOf0Fa74vgxhvEVUY8N6aCY4+ww0ICCraeT7Tcqt?=
 =?us-ascii?Q?9oy2AYQ1evZ3Idqm9ViAeuX6S145QmQXs32nESrZSM//qeFzu3HujrSY3NSS?=
 =?us-ascii?Q?b9nAsE8XkFDEaU5GiUmNmSMfUpmAqGQD9CsN2lwmCWvc6jW9SGoh78hGr4xu?=
 =?us-ascii?Q?Eoc2cvrkC4quq6NGkSw9YCfib7ItjBWZ/zF2mFpQa3/23vRktaEkMf402nd9?=
 =?us-ascii?Q?OWV0TgojGYIXAKtr9ahLDmWYtRZozyAc0A4ateQjjCDbnOOYKZuTfTIykhbW?=
 =?us-ascii?Q?gpmqnlIFZM8ldkmO1gqDK036Rp7yNgl5C0Em55bgQ2IBKM41/Sx8gh8dMG+6?=
 =?us-ascii?Q?omxoqXFx1RLm6c2q5zPJptXaveIghA9dC8OPqY5y7twUyHoAEMcxVML/h+xp?=
 =?us-ascii?Q?wH6AHTN0DXuEPl5oQsiAd7mD84YIPMUUnfoAz0QYGPATu0YLX7HU7Uetqmg+?=
 =?us-ascii?Q?EwXHC3BW4XvZPXmpYD7ALGedyEoNMUzJ6o5zs+dE5xRJfo+UwoZ7BlkPT+F2?=
 =?us-ascii?Q?86HiAxvNk0I+NgOQeXVchTgbJgGRjOBk/ZbdGY6rg6IL+PdwbyNHOgr9zdlf?=
 =?us-ascii?Q?ZsOYw4V8BakExME=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 19:29:08.9535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04332c21-43ce-4f2c-06b0-08dd46e48725
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724

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
Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e2c3c797ed..7d18557877 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2504,6 +2504,60 @@ static const CPUCaches epyc_milan_v2_cache_info = {
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
@@ -5566,6 +5620,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


