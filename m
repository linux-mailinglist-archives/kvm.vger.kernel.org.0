Return-Path: <kvm+bounces-45977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26EACAB0433
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 833F0160C65
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5AF28C2AB;
	Thu,  8 May 2025 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0xalJGKN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9895428B3FF
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734315; cv=fail; b=u2kjMdmA3uJJsNa1ZEiD5zvFcuzsZPm3IPkUUyQEZOwnVAvnGnwjexk4ttbsTUUsEwynzkUs45j4ycbGlCHxM5/bdZCheHmIeEILMhHDGaSHCvaGAd61kI1L0uAG64ZrquKH9+LYCo18YKBHJUYriPy2xWquzJhYBX/2FZAnc2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734315; c=relaxed/simple;
	bh=0R7elXTgW6mNZucjbacojHnrz1dGommtRKUwpi525aw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQm4vNRWFAvDexdaIeYY89A7k0hTKbRYPBKwiG/X9J8byZJmlYb9fju3K0sEn1i5GBhl8bBnngq/gWCbKpnRy+/J8d0MQPD9Nr7y8WEdoOuQ2vCAkzo9V/NvQq4pQGfu3ZJz75WcmI/XRP4WxFC9GsG+mqj/t3elcPhz/YHISAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0xalJGKN; arc=fail smtp.client-ip=40.107.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkyCOeXub+7no4MdJXg6wpkE2a8DKmj6dnOEFAPaKZYnxx+OpnIVQFlFifX13C+3x5tRmcnKVHmDt30a8TucXAXvojSmKiFVLNqMpt8fg1bXYCjs0DLCRkNopKDP82VRi3KNJvs6oyePPGrXdtoSww8p10JyHAzDXPFCTT7SHXxVt2lkkx3+f4lNauDVm42DsP9YLggKhCID6TLjGBd4dkoqZbXZqAOs4o38Y6HFjoNqd028ELYrcBH2uFH+TioXScVa10TN/YKekHFDMBscY9U6iBdjzegNaOrLWjYwAa73QQojfYfGW7tPOy+UoccRE5Oe3Ot9Bz52XccOaQr4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBkyQbWGS1rOzbCfTb1RSolUrIxAL1Mzx38rYLBwqAc=;
 b=oQSrKRTwvkaEiOqo2fe01Jxdl24YQBRWvv5AynnAehanzkM5xT2nk/VPeacjL/P4yzTt3NENxutFqg1b0PX4ZEH7vlUeWNrBSvm0cZMZbf3vTd2p2EcGNrTeD5jSJ1vcS9sH20zyw84TqDbvC0enrxwPySdAZpHO7tECp+yezx3IIVpLwaLoDYgPfrI5OuWykE3rvxgEdTbIL+/DvQNnkh85QqNv3rsNRLz7lN9+VsgVpT3BEcQ3WsTh4Jkv0+W7St8HHU6zGiUnhfE6b4OHdOlXETZdX2J5hPScg/Cuq5yquorPDoAMURgpwlVKaQKz/uirPK17GiP7dK/14Mz2cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBkyQbWGS1rOzbCfTb1RSolUrIxAL1Mzx38rYLBwqAc=;
 b=0xalJGKNvD0IMiDHCwirayPHA976IgR3SKzwbeJwW/sgYvar5Ad1EOAZRbkXuyBDNnHjKz+HQH4bjZQ0vOksAgsrTO67vdLUq9updA040EObJV0tjnryJbKlVNe409iXdMpqpkBkJ0zXUuHylZyFgtOvULdthD2MxcJCwBqfdWQ=
Received: from CH0PR04CA0085.namprd04.prod.outlook.com (2603:10b6:610:74::30)
 by BL1PR12MB5921.namprd12.prod.outlook.com (2603:10b6:208:398::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.20; Thu, 8 May
 2025 19:58:25 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::41) by CH0PR04CA0085.outlook.office365.com
 (2603:10b6:610:74::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.30 via Frontend Transport; Thu,
 8 May 2025 19:58:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:24 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:23 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 2/6] target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 8 May 2025 14:58:00 -0500
Message-ID: <8265af72057b84c99ac3a02a5487e32759cc69b1.1746734284.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|BL1PR12MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 294f6df0-dbba-4aba-cfe2-08dd8e6ab13e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2OKHwIzjMetkF9Xz8kWT9kYHVzZAAJSEqZcrKnXTB+dbS+xWsFVAdkC4Ht92?=
 =?us-ascii?Q?c8BlC42agS1iJBBcOn207C1j1nW6qbqiqwA3eyLZtFbBSQwlZumUQJy9+43H?=
 =?us-ascii?Q?LMpjm1EOwk5bMpKLzQsWXIj76TIImLwxzqbB8gS+d10/Ko9LReWTd8yGqZZ0?=
 =?us-ascii?Q?mGEmCuyvUyoaF6Q3Ulnn3X3WLIKlBFqvM4AsPbW2YiIXbZ3Sc+7uQmzVFjcp?=
 =?us-ascii?Q?JqwiqmE0VfknJIM8E0eRG3SGPXFPLvqwyk4SsYFe7ycLzwqz6WPZcUgQSOBZ?=
 =?us-ascii?Q?oXNPdEoMbycRO3uEmfoGjYNb5EMhqU7Rg6Pm/jukw06/7SQjLKwQmCxLTt4v?=
 =?us-ascii?Q?XqUOM6dObyLC6t9k2QrVzgLKHbrW6IO/bCoT/AqACdKiDAThLtdw/As4k1zE?=
 =?us-ascii?Q?dBfSHzYVZvMGpSPwPKFfJwLHqkMtBCRz0X32Vv6pDzXaR2JkLsYBXMfffBcF?=
 =?us-ascii?Q?rdSoDLZNFybKvEvqbGqlezG9/gFiODgZNNC4htskEmupb0f41F1JiQPEXYbI?=
 =?us-ascii?Q?OhOTclF51VRW5Tgo5in6PTip/M2sGWVJa6Q2TjRwV1IaigAQBFVDAR8ElojF?=
 =?us-ascii?Q?K0VGWm/sMGv9OPUfbAWJQWtQmCMmmXLBTrvYPwQ2dO6ATUM60r7M63rt+DJ1?=
 =?us-ascii?Q?/Ejh1zWqChxC6RvxuAurz7wSezVB1NSlCi1h/Hsl0RPn7p810dmWC474hfB8?=
 =?us-ascii?Q?6s+ioovZPIXyMgsKb1aUV+dnIt+uYFyMzWyTf6d07OYwa9CppgOx/m2bRmbR?=
 =?us-ascii?Q?PfCuYwkH5nxVMubOAYKzdG2WpJ6khyl0o0Rm1tVZDslVROu4GP24u06Tuj9j?=
 =?us-ascii?Q?pssba09Rjn+fL1ecVw/1ce9HeXv136GiZw6EtpjIH+VZc0cz/BEsQruQhEWd?=
 =?us-ascii?Q?5hl4DFT5UHPdVqahWo//ci2mAz4sCZ3fGJlgiKJ53zlGROJWc+goHXUUR0bL?=
 =?us-ascii?Q?LSyuZqD7kOzxc+b9sJ8UXJISJOkMoQRc+6ScB72QLdIdQjwivRvKvnlGnRgf?=
 =?us-ascii?Q?ovaUiC8zp0ucKPsOTIt5l+ToHabyY3lTDc50onfVymn0MyqM3Ihgwt5ORR61?=
 =?us-ascii?Q?EVZxD3nwHm3ST3x5q2l9IEVi1yF7bnb/YGHwtwj7R8EZJje5cWOYpL/H00y8?=
 =?us-ascii?Q?o09gRMWaemKv5LOqfApdd4JIr9BuSwNPgMj/iSAWCfa85GA6KYPMMIsrj2oI?=
 =?us-ascii?Q?WicqCi+LUq/0v5BSCUEw6w6dq1hsRnqH/wBP6y2qQy0FMaz/If7koZyB9hST?=
 =?us-ascii?Q?6yVZ2aYZmtIn4a9uk9riJDkZZZ4guFPMaoNJCP9oN2bQl8baE8sY15fJf3Fo?=
 =?us-ascii?Q?tSa3nPBS0RV0BULF4csgnbaEeyF1mnYoWN95tHnn94NxKGI8nIUx+3H79iid?=
 =?us-ascii?Q?lv4gvehYwPuXZnTW23Xsd+Uoo4A1BIGrF3jrw1kdiusACuHjUs2wcGc7KcCG?=
 =?us-ascii?Q?SczzOAD4lBuAqrzb4EBQWNdAumWYy9uuimAw+6Bwc/1D+rU0TjEJed7rzmxr?=
 =?us-ascii?Q?l0jlL9TOD+mDmhsxlf6KQo8JTcTe+qlG/lWd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:24.7086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 294f6df0-dbba-4aba-cfe2-08dd8e6ab13e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5921

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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 49d3ae8aac..3f64293ba5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2347,6 +2347,60 @@ static const CPUCaches epyc_rome_v3_cache_info = {
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
@@ -5423,6 +5477,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


