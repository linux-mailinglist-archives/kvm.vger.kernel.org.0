Return-Path: <kvm+bounces-31887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9759C9350
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 21:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 359EAB260C9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDA1BE4E;
	Thu, 14 Nov 2024 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AaHz6oBG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB25136327
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 20:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731616619; cv=fail; b=entDnLxSiAvRkWYMRXFPQTrrTQB3g0LM7QC9O1yEdvpUEURM0/0Un4K1s7EeHa/J0H+f78Xo4AbnvGMi5RG0cCWVgKpPKjNPG8396aok9wMQYdSOD53n+gaZGu0dPM0NVs4kHMf+KdN4h5pGbV14n2Jrcj8f2GTjZfCm8UqCzKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731616619; c=relaxed/simple;
	bh=A+5I07D6AdmJNMdCN0ic/ta2KkF1sSoa31N0mkjuJsg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2tDZd4r9spIY0trHBrM2sjYcNxsBT3jLzEjnCjMLk3jIvzLlFtI6owUizem1n4Iab2um0ChxSeXJIjM3ahcHxHo5tHDdtVzpjo6/oJKzBRzEgF1ulspt/uc7hZNQjvdOEmRMvtSETZcfRHsUu6zLuwueby1EisI8pWZLk0SUgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AaHz6oBG; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bgnmpJmGKheasmfu+ibQBMx16kUEUsfZlouvkmWNF+W8SdfWsrq/wzRdIKkJIB9h3MAdB7frmZwJWbTJkFOxcIBMPmBf01ZGzLLAT11xyN13LYR/mstn0omqKTO1XOZp+TumPJxCs1WeXUU3k3OftrT2bYYFNuX5gxLSgq3FkgoGfgOxNXU0bLki6Lmg15zb2DjXWKAy+vndve9KriC59YrY911OCBNBuIWLuAiR8gXyyrGBD+1CC/HM4kKjWuvGnd3qK0Rbit+9bIpobXMe5Ohzn+6zXNXUFPRSbLiwv+jNmr34bHh6Gn3Kj0CRGdb75njfSsb95jV7qUyDy9N59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1qCFo5HHGmXv0An1bPJ0Zv90ocVHv2NL/5ezb5QsDs=;
 b=QNtYCtHENQD/3Jx1+2T6a2ZBFgOxJwzRId4eRIpn8VVVdqqQY0xrd3+hBiiqDnnf42CeOWAA3kZ/Sjao7WiO8Pm3GxJjbl9T03RPAX0ArOOkfR3htgM5/fDGa6VB3xfUfa3SHmJ4PsuDObxqtUVSpuqlrx1mb5uj1tplHfcad3Lo7baq2Es7hdyGvOmclo9qQLDMrwrQOD96wITX4hpyIfyzJYEJyhw1ceZnwa8pXIavn536TyMWsevMUzpHNp0iMRv62f1PUMMjD0qpGLq6p9YkAjJA/TD9QMzziYvai4hCb9t5vERvE4JM2r5FY457720vHFQRbPNQ5BnxhQ1JGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1qCFo5HHGmXv0An1bPJ0Zv90ocVHv2NL/5ezb5QsDs=;
 b=AaHz6oBGt4LTE0muJXrImcm9NNebU4l7xnMe7+0GFWH41SSSqWrLPzTylcGkE+gPtHM6mq3aFFRX+sttWYacQ1bWiA/urk7AbUXB9hJYQ4FvQof/KU9E7xHVzmvGsWIJeitqq+tj7cJmEw6BHiT/Jfwm7D0LZzW8VsFE0ySrmHw=
Received: from BN1PR10CA0006.namprd10.prod.outlook.com (2603:10b6:408:e0::11)
 by IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Thu, 14 Nov
 2024 20:36:52 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:e0:cafe::f6) by BN1PR10CA0006.outlook.office365.com
 (2603:10b6:408:e0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Thu, 14 Nov 2024 20:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8182.1 via Frontend Transport; Thu, 14 Nov 2024 20:36:52 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Nov
 2024 14:36:51 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <davydov-max@yandex-team.ru>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 2/5] target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 14 Nov 2024 14:36:29 -0600
Message-ID: <3ef7eb6664c816cbdfcaf561da567e7d0f43e5d0.1731616198.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|IA0PR12MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: f0e905a6-231f-4c65-ba2a-08dd04ec1236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4CFqdI57kH2b+zUbicCfcfBvkn+6lHwtY83w5STO/mon/cxuMdqynctTjTvz?=
 =?us-ascii?Q?dwlIu7ysF2RuH4GFvJnGcZkcMJL+tLFTjQF0pGe00yhEkE9U8njvf5ow6pYk?=
 =?us-ascii?Q?7/TvRzebLgow8sf50r1KYfhtQZo49XfgInPSntT+PdOU3VO8YGLwKKYTU/me?=
 =?us-ascii?Q?Axvl6TUHJJr0mRyr3UQ2oSDrxRTR/CoDyQpMOQPbcB/tO2qHPyGGwi1FdqF3?=
 =?us-ascii?Q?5s1e07I4HJYuQkYCHcbL7nPH/K/rpT5gwVAMQDF9D02j0y83ZL1cNgrINMMr?=
 =?us-ascii?Q?syXP9JbE0d/TIcVkzfvV0mbtMjC/otCEmgtU9lEPihhdnTJqV2EjggJVK8m3?=
 =?us-ascii?Q?eogJjRNHmYjjCB6MxADN8lcJmkLh5eFfEG9GG60r8GK6kJahQSMB6rkcILaF?=
 =?us-ascii?Q?76rvnz9CDlF4pdIQ/cktFNePcDoJ3OU7VsFkk7ebqiM26y9m8tLZvyUYigXU?=
 =?us-ascii?Q?7yiacuoNyxuHGMkw/ckMkXQ63UpI6w5kinz5fYGO2cGCmzN7WQax0irKri0F?=
 =?us-ascii?Q?ZTIMDn6AEY6jTvfE6gr0mGn2A8lEdRZ2XEzwJDKdlHkW46ZqdCB1dCzSEy0/?=
 =?us-ascii?Q?njGol+U6Lbt8vrpUXxhUVS6VEgwnwm593jBehcBxK0nUWnkvnY5h1Ff6mQO6?=
 =?us-ascii?Q?8Ifmj6FiYn7sj2jQpYq7iyRqabJ1UW+XqQ7OIH+ZT4oIrcurM90wf1TU1sRs?=
 =?us-ascii?Q?OiV2RULSfs5tRqLJJTt0pUJVKIQRZrqDl0Mykb6yfBDhUYemgKMQvm4khiqg?=
 =?us-ascii?Q?tlFkADOw3jwhs0A1dKA6kWXmY0/CBXhGGgGirnt8R8mvgEiU/zXoeEFykk7N?=
 =?us-ascii?Q?9JCTRapSTRDi62BNQCUkNBSSrgfIIGFfQ14UsjEmqU3c7Qj1g/Koazg9Xfs9?=
 =?us-ascii?Q?1QzD0tVjfPfnEFAdqFkko9rNV0eyf3WH00PCxUpl/guSCb+spmHFw9QabW46?=
 =?us-ascii?Q?HRC0tGstPOZXCfCZWoWarWydPvdRwZzwFLOglpKaaD5f47JHAsnfMBimpJpm?=
 =?us-ascii?Q?SLNhDbSNqsoiU+/dzxxJnLA5BA8c7tJVN7sm6RzT/SIBV+tjFu7ihyZCXxZP?=
 =?us-ascii?Q?Te41unfszvynXp0QtckRmXii/MvwavbJ0GZhGFGqUGLgm08ej2eJ52bGXYVc?=
 =?us-ascii?Q?u+WglNpCYR+MdtSj8mw9f1Y0HieTaq+KqJrnSL2uxDbU2CxUmNKFqEs8BZZK?=
 =?us-ascii?Q?iMNigKVGq53Mich3CVmKxhpIKU5eNTsiWjKBt+zWaziUlfNvR1MUMFsqthFw?=
 =?us-ascii?Q?CLMYSgFtzyAbjldpEAPet05QIxcwiS5tINiX1uMi5IZmrGSPc5JkTVtORums?=
 =?us-ascii?Q?0m/QP1JgqnKzDO8GE3T4HiSW6PR94a9TKhA2BWvgUWEkmSihDp2F+RcvOCLp?=
 =?us-ascii?Q?rkgAOyiWh+PmMjdMc5RdG0JM1WNjfpy0lJU98pb7977Ltm0NTw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 20:36:52.0148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e905a6-231f-4c65-ba2a-08dd04ec1236
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7555

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
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index a632c8030c..c21b232e75 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2343,6 +2343,60 @@ static const CPUCaches epyc_rome_v3_cache_info = {
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
@@ -5264,6 +5318,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


