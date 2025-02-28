Return-Path: <kvm+bounces-39760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B573FA4A125
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60E3C3BCCC6
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F202702BF;
	Fri, 28 Feb 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="morb66GO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA42702A5
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740766079; cv=fail; b=LQn22IOJFssCTNBriVwVKs1WplhNWa0lcdw26lR6tBQSlgSLGRKHjop8INGQkh2qBsuKm4ICDCOANueUt93PjShIzbet1zikSCsJC+6Bszszp19/Dv143SwdX5sUpRhteJXt4cd+oRn5DX1+MJenPyZrQNtuPzm+Lp5mDUyG+Ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740766079; c=relaxed/simple;
	bh=BMBxm58PMUKOE4BsRDWpc9XDl2VUy95oV4RzZpO0is4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnnGGOrgr5TfQuL1Y9Qrcl8RyJcvDR2+z0OFTp1yLZZbIuHYPHjgu8NKvaIs4N/DI3vzBfSropXgjTS0XbOqkYGIwUIA6/6MPtvw2G5nQhrHoV6T0TP2069Lo1ej+EcrZeRKSmNWkpW0mqPPNiZiDn5OVkTlDGjG1oHmapYQA2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=morb66GO; arc=fail smtp.client-ip=40.107.101.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=if43fOTNEU9thHkeCwIZNv9ATIT0Y76cTWrbp2mRNkEn4F6p8ZHv21GbdyGpyTIWYP5XdAmLRiaF2gHVkPQMIYXYCTT+6tcOMZA6YqmDtXEFzKEEUjj0LZEhDtz7m+ll6ipe31WmQIG4nYcBD9f9e6fbwdg8QJhSHgl24qDXK8wuHLsv6UgAIap93oJQ3VMGzXKErADCshdOInwT1dF9kLnsOcCj8BxICMYXZ7MXtM0JN6QHW6M/FsvmaG7KrTu56OZLXJmb/AOxxHoLYPoaZkf/b4Aj9/a8QJi0AQETqNUQa6+pQyCaucv0zxex1+3iw6evP4smQ8gGzzrh3d9i4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpHTQFBSlcBx0vaqV0qTiPHgAgB1EQIBkdtWUxW2+Ug=;
 b=UVQTsk3tiUzfKaQfHZmDMhgqFlHad0830fZ4k8CZ8Z3DxIcIduPXVkW+C40KyO3UBpXTOsxfM6TgAxjBgKN41OSnzpPUcbI8My8K1QwD7v7rwTNS0HHT2fqq6OtYN/RDk0f1Tjj+IwpACdibETAOvcyVAKKfYszuTe7FXwD8PFH56lMOw5SW0bFQsc8erk+/mAZF+WZ+2PayLo9zN642jhtpqfwLnZxnfjyLK2PrRSKzx1tdcECEULSjxfX7lWdwVnVQHf3ww3u53aAPF/TAXptfpZthNOCh+qDL8248rfXcxr5LspT5aZsSlx10fIi0/yzy3vA0fmH8EuhGhUF9ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpHTQFBSlcBx0vaqV0qTiPHgAgB1EQIBkdtWUxW2+Ug=;
 b=morb66GOy7k7Vdj+bRLCfrOJCzyKlQJp8BWKZUVhSva046BRDy94z2ThCBpVjFnPCk3cxO8bvtNvMtqrdPcNSKYai2/19GiuSIXxDcQiIhxNZYZ9gkZavR5vSA/nlf9RyS3+onUvBlT+yUkVqLAwY1KtxkHyGXjkjtV5SMxjn+Y=
Received: from BY5PR04CA0024.namprd04.prod.outlook.com (2603:10b6:a03:1d0::34)
 by PH8PR12MB7232.namprd12.prod.outlook.com (2603:10b6:510:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Fri, 28 Feb
 2025 18:07:52 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::a3) by BY5PR04CA0024.outlook.office365.com
 (2603:10b6:a03:1d0::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 18:07:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 18:07:52 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 12:07:50 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v6 5/6] target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and SVM feature bits
Date: Fri, 28 Feb 2025 12:07:05 -0600
Message-ID: <6be1c5cbe1717d9d62b30db49fcb480f1e8f9d33.1740766026.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|PH8PR12MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ff6538-24c3-4e11-de79-08dd5822d16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HJtSgmYBBYXc8wPLTlW1LnMDgH2ImYYrDE8wLyFwOUDqZzJjoxjz8XuJONuF?=
 =?us-ascii?Q?MzaVLlXUQPSNuAwMC+6GSaGdYc0XJ6/eTSv55etV0u5Pr29yjrqHAD7Cyruu?=
 =?us-ascii?Q?qXN9RY3ZMtFnzU5pqSFS+dfMH5/UizGGgBKRxv7H1um3jKrEuBqNAoILEB9y?=
 =?us-ascii?Q?sIxbmSSshv2NU/xts/MiNOALv+d78/f3iPP8tX6y0CWq1xd9K/OzWFzL2wYp?=
 =?us-ascii?Q?0bIjogDdFyLE3Rdj1cAqZVPuOnQ3Us4ylI30EoM51cpOF7ngneIj35vLjWKV?=
 =?us-ascii?Q?WpnnJoZTvvwAD5hh77FdT0MstVF5b16O57AeXOvcA4tAzlWN50Hhmdq3i65E?=
 =?us-ascii?Q?tjyP0JVL6zMLdArxewtKmXxOvIrB2zjj3hxuPRn++E5GpRYEvqdfuw18J7kl?=
 =?us-ascii?Q?f/q+5vn1JTp3eBlPAzx86k/WHgf2SmqwBfLvUhYC8jI9w9O9Z3WvoLmM9S+Z?=
 =?us-ascii?Q?X7PbAKvWOTsSDzVsutLBQ6ubATwo/2QfoXc54bsnAWvKxZapBeKHbRbLtme5?=
 =?us-ascii?Q?3cXnpbN+v0o8bVq0VAum2gnOJx+uE2x5IVLNXfykb456PescqKmpCDHLaeKZ?=
 =?us-ascii?Q?Wk56jFm1K5wwyDMLcCc9igdRZiRMql9TjiMhtDqGo7RG/LD5ZylcRM0LTX6r?=
 =?us-ascii?Q?Ub9uRovSK1R0AAHPDvxKKp/m+ZhN0q8j1k9wsjHRWjMxzmMNijs5RAT8cUKE?=
 =?us-ascii?Q?AfehwjW4ONROCciQo1JZQhHi0Rk85iPHSOK8Ub5i5E1G0zitRBmh8AkNjvmZ?=
 =?us-ascii?Q?CKFkXb1X55QzkMxnkmf8wBfqJtD74UphH7jRUA67WkErnSiBIB/q6fWGtXhU?=
 =?us-ascii?Q?MaT2KuYScsvxQWVYl3duz6GOlfh0A4zml5kgvh6IiFuRGTS14x7cWnK+yNSa?=
 =?us-ascii?Q?Yktm1fOnB4lXpfyRElNLYoTELFnugutSDMrNkvjng2ffxyEIJJgTljfy1oFK?=
 =?us-ascii?Q?5cGfKmFqrpEkDZTLHmJWCTFFdzsu6Yxv7oQrrgc9L3njOW63+eHUuLcB6VRY?=
 =?us-ascii?Q?zx5ftfdgEJABvWRycNGveuHYjfGTaumSf8jFUNZSgSem1Fod/HaoSdosVIwh?=
 =?us-ascii?Q?GVzh6s1rdhadVUBp/MInQmeQ7nSUPOgGbq5n80JPsofYj7MopFXpvRRxpjsG?=
 =?us-ascii?Q?B/kX7Y+kdsRvgg/VeW1rIMUkgK1ErHDXpediP/V8xCzzqWnMeKoXBTXXZQUx?=
 =?us-ascii?Q?aRgwF+EHLq+S3ZV+GYiK0cGNwF4ilyYw2xP5f0FOTpMn24TcQpftB9OyYtpb?=
 =?us-ascii?Q?Wwj5L9TAGqABUdaUddhcOf9qefju4Ens1JtJ5jEzY/rp5388ps8DJRxfrhx0?=
 =?us-ascii?Q?ZwJxxTqInc/Q45lwAXpB3fYWQSXGhNczZWCH55hiPRxV3kExo5rfOrlHguO/?=
 =?us-ascii?Q?vZfmMYsNohKmWrnPD009TOIVwQUkh9SeeviGpd07RSJtrRo9PvKX10KQN75+?=
 =?us-ascii?Q?z8BgLrc6hWSJwhuN7Jll9294ARuqTRG1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 18:07:52.0490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ff6538-24c3-4e11-de79-08dd5822d16a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7232

Found that some of the cache properties are not set correctly for EPYC models.
l1d_cache.no_invd_sharing should not be true.
l1i_cache.no_invd_sharing should not be true.

L2.self_init should be true.
L2.inclusive should be true.

L3.inclusive should not be true.
L3.no_invd_sharing should be true.

Fix these cache properties.

Also add the missing RAS and SVM features bits on AMD EPYC-Genoa model.
The SVM feature bits are used in nested guests.

perfmon-v2     : Allow guests to make use of the PerfMonV2 features.
succor         : Software uncorrectable error containment and recovery capability.
overflow-recov : MCA overflow recovery support.
lbrv           : LBR virtualization
tsc-scale      : MSR based TSC rate control
vmcb-clean     : VMCB clean bits
flushbyasid    : Flush by ASID
pause-filter   : Pause intercept filter
pfthreshold    : PAUSE filter threshold
v-vmsave-vmload: Virtualized VMLOAD and VMSAVE
vgif           : Virtualized GIF
fs-gs-base-ns  : WRMSR to {FS,GS,KERNEL_GS}_BASE is non-serializing

The feature details are available in APM listed below [1].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7a5c5da0f1..b9109b7e79 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2612,6 +2612,59 @@ static const CPUCaches epyc_genoa_cache_info = {
     },
 };
 
+static const CPUCaches epyc_genoa_v2_cache_info = {
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
+        .size = 1 * MiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 2048,
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
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -5713,6 +5766,31 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x80000022,
         .model_id = "AMD EPYC-Genoa Processor",
         .cache_info = &epyc_genoa_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
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
+                    { "fs-gs-base-ns", "on" },
+                    { "perfmon-v2", "on" },
+                    { "model-id",
+                      "AMD EPYC-Genoa-v2 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_genoa_v2_cache_info
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.34.1


