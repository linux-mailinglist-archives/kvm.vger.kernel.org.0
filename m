Return-Path: <kvm+bounces-31890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AB99C9353
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 21:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D71E5286953
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799E11AC8A6;
	Thu, 14 Nov 2024 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VvFSZDn2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1063719A2B0
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 20:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731616640; cv=fail; b=dBrh8lHp6zfQSLQ4DX8NLWL5WCPNOhwNpTQjKi+vgY2qmf69pgGjmQp0ca0a5n2NO6YN5GBdytYLHUroCoQtQYQmft+iBFrtcLvnfO4HorbL8cBA8+BVv+Dx3U7QNlNofvBFdM4UyAEF3wd4by/QAr1LglWMF8RzK+w3BhBKE0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731616640; c=relaxed/simple;
	bh=yZf7Rg9hTbH1ss28xZm/yCKehzZIvqDZu6lyqFEOmiw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REUgf2rXcLB6qL0iehHTs9/c0ASG7BMu/qXC6rKB8FiOYc7jOV93pxlBhi2U2iDmlhvKxJd2hCmBDcYTWEGPFPjH1L/D5jXOEXhrA0b98XxAhyjYEFwkAXjOn02xZNc9fVrLkz5x1Ahu8wHJHCfekWFXrQcuOjIOqEnNysz30i8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VvFSZDn2; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XiWf4/ZP8c3jDBuxGS3AzJLz6350gvuiEWw6I7YvCoPuzMt39r5fUGUtK8BmVseU2yWjEiPoXz8UKqInSFdWyf7Hna5adA8ZQ2NVA/7cV+m13GdU7V91S0ky0shwPRjBLu8j/JpjPDaDyMBBcHlJbT6JjoqAeHn5meAWDIeYPotou0YiMXJuY3r+DwxVZrtRpXouIp+NArK8Eh/yHS2cXAZBME36tqWesXXq7u8ZRlt/ZND2KK0XybPd3dW/KJtDYrRJ88IBRST7n8Sz5nAejhDXJgORlcVdrZQDNC3oqFxF4CLbbtu/6BiwqnKd8yrjJYvSOSIYb0KDfX/HOlEKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAS2GIiFdwPhEw47XkJUVk4kdgQ5vv57fwT8KP/qQcs=;
 b=tPQv029k41UKHNrJ+EyToaKF5c82GzMDs6iJGUmyK2+zotpZ6j/Gv+POftJI4tw9D6oo1PeFSh7wqZ4Pcu0A17S9LiERlkik77g2tO6OCU7kVe5T+stZ+xXm3DeMHjuXexkUp2idAAxgmtMU+MMlkZuwlPYB4E0eMi33up9GMSbPPjV1PC4sOYyZL03VHKJCIQxIqAntz9yRnNvcaOrIQAad5KwpBl1ORqzYBynxYQYDT/HW09toe6ZjJQlnHboFUg9WvAW7fCSMy1yoYiy/NtpOEsOWesS537yhBQCaGQZzFRuzU7AFKbPRz/qVgnPKCgoXAjaVPEdgo3hBbdOaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAS2GIiFdwPhEw47XkJUVk4kdgQ5vv57fwT8KP/qQcs=;
 b=VvFSZDn26nxu+6LQgEBK8scc/Z7JUYqB9D7MNX8oe1lVG+gzvOefikeFQjLQsxsPkmd76N6+O/yBYwkqWyGxQLFV3XwtH4jtwIGWadvI5Jaiheu+0ozfoJULeh7PSx7mMf5ZrfpxANHifL9GBE9uzntUqyKhyBNOOZHHUsa8ADU=
Received: from BL1PR13CA0174.namprd13.prod.outlook.com (2603:10b6:208:2bd::29)
 by CY8PR12MB7538.namprd12.prod.outlook.com (2603:10b6:930:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Thu, 14 Nov
 2024 20:37:13 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:208:2bd:cafe::e8) by BL1PR13CA0174.outlook.office365.com
 (2603:10b6:208:2bd::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Thu, 14 Nov 2024 20:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8182.1 via Frontend Transport; Thu, 14 Nov 2024 20:37:12 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Nov
 2024 14:37:12 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <davydov-max@yandex-team.ru>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 5/5] target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and SVM feature bits
Date: Thu, 14 Nov 2024 14:36:32 -0600
Message-ID: <e8b7c6a7c9b8cbcb3c614c8bcf76a124f262b047.1731616198.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|CY8PR12MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: d846ff2d-2d50-416f-ec89-08dd04ec1e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EDPrg/2EeTDoIw0ZmDAkAEp97z0j4PYYLTNzwVsPhAygPs25h4D/8ocJyFfl?=
 =?us-ascii?Q?CGXDFecM96wTLrvEiIKYZT6ZXTcZsm2JvkkBEjoaNFPhRDrvaV5yalUkdF/i?=
 =?us-ascii?Q?i6fHQjSMtGX5dVfHYZEEH/JichES+fUAs41n4ei0uUV87p2hhR+zGcusUekS?=
 =?us-ascii?Q?CjkWN+dgEub0N2t44GZtBkn71Fwx3RkLkmpC1zvxFG428AH0VI/WPOBdEqky?=
 =?us-ascii?Q?yZMV0AIQFpyR2HyRdfAnVxZ2i2YzA5QN40vvrHXHF6WqanVS291rqshjQ89O?=
 =?us-ascii?Q?jTNoYf/ezmFOaCoXedIaoSw//p5dRLvdeb+mg07NSGIcl+0vcI1OzVniHXGX?=
 =?us-ascii?Q?tPHszQFNnfUaDNY28UiJ0OfeGmyHCtfl4PUbviUuUDgPKQXdYAb255fxvpqs?=
 =?us-ascii?Q?pKB4hJtKOxGPJAa+c6l7nLsQE2XTKo4bpdsq6390qni7QfHXHqa41ardEa0U?=
 =?us-ascii?Q?PWrGx554uidoHDD40a1cUDHR9siyLSc3LbigExai+QEnvodu5uUM/WhrcDcR?=
 =?us-ascii?Q?47dCQeP7WYkYiFSngQevAlODZp9deCM1f2tKrM3mko6WWtgcZ1BW5Pmm3QVn?=
 =?us-ascii?Q?tNP6V9+v+u7BLHpuTxTTUw3XI5t8UfjQoOdxU3I9c3aNaVVvugwMqm1P6Fci?=
 =?us-ascii?Q?NMXQRUtZtBb7QvGSOtBsjt9OtEMylVai+m5bu+NdUmV0LoUSKDqvEeyK7l6B?=
 =?us-ascii?Q?fA9yBWHppRReksyrQgkalm/enmTtO3hQIdu/UMiRtKwnKXYZPX4Ac8txDci3?=
 =?us-ascii?Q?Xevd3EzR3sUe+1LoRMGsQTYd8dgA+xEvvd+Fq7CkHx4yKQHBxb13c9Ivs7D1?=
 =?us-ascii?Q?XoU2HADPQBrDD5NRPRwZ5V+f0aZC75mKV9ZuHoA/8zs0Xx3ffM5gqq9s01lU?=
 =?us-ascii?Q?S8RRu8pbe1C64+X63yB7gXWSmBnQuY2UhUSGuTv17G1TP5n0TCddny5BXG9m?=
 =?us-ascii?Q?1cG3TN4boG+wieV9vthrNjZ1RedC9SbEwv7mb3OFMbJSV7JgD2aVhI4aBoWH?=
 =?us-ascii?Q?QwzVea2/2tOyHO1HLdiuBYj53fVQhlQqE5QrxptJVVnRGcqqdjMaRFEZxCQu?=
 =?us-ascii?Q?Jt4/ex6IG+rjTSTnLcvNL27QL0gMQtpgJNEB4XDszMgkXayqfVGjG/ozsHB/?=
 =?us-ascii?Q?FA/ksJ0zQee1ss9Nn9/ST6p71CpqDgHd18S0SnzOCUz/sTK3pNW8ZV3n+XOS?=
 =?us-ascii?Q?gkhXeGwWGZSHepCYNYn6Ra3r7hefdITLGDH6h4+X6Sf0IKI6QQd6DwaNsKPi?=
 =?us-ascii?Q?uX7h1jsWJEiwa2b1W95urkW91Baqd0Du/C3c05dgf5oviPOxfwVJWeceZT8B?=
 =?us-ascii?Q?E8R85UBnURhODmvJGE2wSKue27TwKZmJS8iDk+Y8mnEuJ5iwnGiHdVWtPqZG?=
 =?us-ascii?Q?zEt58ZX4q9BF1B8jNMJ5kwygsfuc8dB6VV3bIPbtWFxHktTX3w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 20:37:12.6566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d846ff2d-2d50-416f-ec89-08dd04ec1e83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7538

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
---
 target/i386/cpu.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 107ecd2bde..1d241fcd13 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2613,6 +2613,59 @@ static const CPUCaches epyc_genoa_cache_info = {
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
@@ -5559,6 +5612,31 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


