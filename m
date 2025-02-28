Return-Path: <kvm+bounces-39758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 640EFA4A123
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B3021899AD4
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B9526F444;
	Fri, 28 Feb 2025 18:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mBSTiMuU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E601A2554
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740766063; cv=fail; b=ogw9cJco/TsbAX09qysyEbKnUbjm8ZwQKpmBoWvm3n5JAQ9a5s/8VQLzX2K8HRPyqWIfbjrESouhTqvLjzO+NV7h1BcSUGbe0KJkggELiEl4dNVj4fRDwd9YQ7hDTTdZQz8aMtDKdmw7mtr1UU3P1m3/Fhru0dch794KnHRoz1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740766063; c=relaxed/simple;
	bh=W7esGflT4tNEiVnmmZrXwOVD6zeY23euq0oZPV4PsUs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OT4UB0/wi1ywfb7jV8pPhXb/ebpYwkVYVTzgvJN1Q1K4UPJ0CeCmdruVy2zEp8WNXRFteAOVOP2q7JxzRmwknR2AcgVPpdvv/83uDroKxPPjJPUn8+aztlk3txO+8IPYo7EaXFTI52Kn7Ih8N8XkAqo6Wk+Y/ihophDyNMRYmyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mBSTiMuU; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=shdFDGgjBXkjR7op+WV59SECAfuenrX/clvqhOmn6FCfxhbQ0aS2TxtFSGnaWH5zMpaMiQkbuxaeSRmscy++x2fs1TGu9mGybITyt8hJ0xvaG7+a461V6UkO/VVigIs0vdZ1V48zdh9rBo8AB5PSWNAzIHEF9AAEW8+j+4xQib1UEppBkPOD2sDoxOMD1CtldgOUnZ/DSDm9g+iX+ej6Ge1DzD6zLnc7Zw2ObN8/q82ZHtdohBS8rFCtjdvZhkVNRzRMdPCDGFSkqolVUtoM68RvI5GrzZWf5wlhUfrdGC5sMogxbmZMrf0lop/KLbhogDoczp6o53S3dUeStz+dLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYxwmqX6ky61U1XG+7TT/rmSPx0hSfYAV2hfrt46OU8=;
 b=aMLfet1SB2aQnQqZjNfKBcup6Xa/qPVdmjK1dbxNVOjH+J3osjzTBy//61pbhfBq2NxFaSdPmO4PsVz7Mr7PGH4BwUho4TF/iPTyNb60GfFOciL9+9PNEblUJt/1dCxhTqaQfkJy2HjGPNf5OChqNeFmVZ5xEu/qFYkDftjsAhagNr/Hz0cWJmWlVQbbpGk7IPQuQTfvU2q1Ch8FwHfAk+bMEQzf+h5TGUajtaRxlN4BQEQWrVyNysoPDr0y3og36VL0v0HP/nJal0KcYqnImMGuw3eR/UlXi4E/+4rJ3OJblmRNdlgMFvDbfyuqLohiFm9/t8hBQsdyoqBfsFshbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYxwmqX6ky61U1XG+7TT/rmSPx0hSfYAV2hfrt46OU8=;
 b=mBSTiMuUNVFy3sm9Btudzdo0JtRpyAyi7YnfUNcHBVlQqwfQAXEpNLegJmjLzxwVxuWy+TUS1XVp8OY8HGdCsXDWbUmpZTpfONk6QYBXZDhZJqW8r7fc9a9maVb8r7qUJDni4w03mP4ulYSp3qlCjvxcFtoxZlTh1KEwSj8gWaU=
Received: from CY5PR13CA0044.namprd13.prod.outlook.com (2603:10b6:930:11::14)
 by PH0PR12MB8775.namprd12.prod.outlook.com (2603:10b6:510:28e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Fri, 28 Feb
 2025 18:07:37 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:930:11:cafe::82) by CY5PR13CA0044.outlook.office365.com
 (2603:10b6:930:11::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.9 via Frontend Transport; Fri,
 28 Feb 2025 18:07:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 18:07:36 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 12:07:35 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v6 3/6] target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM feature bits
Date: Fri, 28 Feb 2025 12:07:03 -0600
Message-ID: <7ab1807506c87d54242044e68aa20c82d7fd3561.1740766026.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740766026.git.babu.moger@amd.com>
References: <cover.1740766026.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|PH0PR12MB8775:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c9c54f-894d-4165-acfd-08dd5822c84e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D3xjdrmOy1J41MWtS031hajEfpLC2tkmlTu4gLqcbechEHe/3CWbJm/seH6Z?=
 =?us-ascii?Q?myPdmHnu+iaNPdTP5aJeGjSY6gN+r25eiRDvxwZfiwfChHfkFIAAtKGxg83d?=
 =?us-ascii?Q?HJCwVZgzYgGMLk4aCIlEbJ313NnJMN1Vv1MJQyJ+rhm/9g/9b9dnoLgAjaJO?=
 =?us-ascii?Q?mI1AMaDqldGzC1k1QbgUqdHlaJ+vVi+DJnmgfNwZXPAiqFJbDpat4WUQOgyA?=
 =?us-ascii?Q?pS2pdaQx62XxbRdFsLBj9WI0VbbOVQV2r0EeJH1M9KADBMVH8+svZySpYlbi?=
 =?us-ascii?Q?vpMefYUiOVM1zlKFzS32P/7KunsHHBbZ8f6fdApk8Grnpb2yuiEZ4ilhWd5T?=
 =?us-ascii?Q?7V9rFvsP8A48VHJ0GzzoV+yIEK899CW6IiMH8FMz60IffGZjAXdHg1tsRoDR?=
 =?us-ascii?Q?6uyqodm/3Iz63fk54fzf9BlEl9HPvSpuJdWsle8FR7Q+C6JzNktQ4XCI6CYd?=
 =?us-ascii?Q?vtnxHf8xQRbUTgxX1FC4/MWg26/LJGZQwZaJ2WUuuisYOnRLRYLm/hnk4bEl?=
 =?us-ascii?Q?3FOw+p7yA5I+0JcCwYtTrLBXYU7XA0dmfDPMw6uzexk5twz7WkzroZV3z5Oq?=
 =?us-ascii?Q?XUrhzORxrTJzE65sUn8UnchPuUWbxYzdR/XbOlmeNkgTQsD/tnCUmiQb9xyG?=
 =?us-ascii?Q?joc+3s6+c+pNlQY43c4wTyXFlsf1HFN9Qg6YlPFeqMrrnLdr2HdTD78oiRU9?=
 =?us-ascii?Q?qNarUKzoUpIpUoq9Kkw+dBUrUeFbA6mHCILmAlCf0PQvdIfdIEEm5FKSqYqu?=
 =?us-ascii?Q?DDCcLVrymHlfxXpLBaYn6wYiCuM66D5UDCt4P0aRkLYZvQVzFCi0orbRe1rv?=
 =?us-ascii?Q?S9sKMoN4gJYBQfsEd42VLzykJjDFjxgJyp+yKaa7a5CHjQ+KMHxdpGXrTGb4?=
 =?us-ascii?Q?Z5Ap/xgTtGPmsm8HVzZIxC6ql4vcC2RZ8cHqRQQPKvPlR6OOArxe39rqF3ub?=
 =?us-ascii?Q?91l43rETPLF5Vz+5iGmC/7oAEht7Xs1vVkDmaCKYAlOYEAYCVJ8HtWRFlFgE?=
 =?us-ascii?Q?Mi0tj63LrsZW8beDcLVKW6tgqu+dC2FhSTa+mj3gDBgtU1yRgNmkh2abAwLh?=
 =?us-ascii?Q?zhvMc8/2NdAuYZG8FkiCaTuXlSHVkN2DASLiFygV+UV7Jlk4CNgSt+dk1FC7?=
 =?us-ascii?Q?qp+T8XlaesPqqn0sb/dZwtb7QnbyOgV+TomrxzR7tUP0X7iz/g/cfgNxHOar?=
 =?us-ascii?Q?VRn3Y+40J6FdSh2hEqz2LEFd9xcy0VgvI8O8L7qiyAbXwOrqOqo5cvkvxA+0?=
 =?us-ascii?Q?i7yMmbV8VFUrwNk4US9LeZh61rmSDrXnn7SHfYiNyDiUUGamdQBTRZRRRe9h?=
 =?us-ascii?Q?JRHkGIpV6BPtHSsWdNCAQpoZ/II/t4NAlSJaunMM7bCgMlUSFFVIujVxGK/d?=
 =?us-ascii?Q?wXARmaVS2eYvtvTIT39S6yZIjkUDPRp3di1jSDLo7nf/9W3UL9mGMsVFw3zY?=
 =?us-ascii?Q?JSHWp67o9B6ta52LH7YDq//AD8k07TYB4DXtey7BIDdRO3bcZRePtbmSI1Lg?=
 =?us-ascii?Q?tOCrq4frJ1cHA10=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 18:07:36.7647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c9c54f-894d-4165-acfd-08dd5822c84e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8775

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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index be8dcf9739..a5427620d0 100644
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


