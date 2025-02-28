Return-Path: <kvm+bounces-39756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9522FA4A121
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8073B9CF5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462112702BF;
	Fri, 28 Feb 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V9XzMuHj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1641A2554
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740766047; cv=fail; b=cK2r3vNR7/Q0GBrDbDSFJhsbf7+uT16K3cLiXpJNsh+lUB2linKRNzSotJKMqxhwg46idkdkJCY2x/K1nX2fr3zjb+HFlNI58WL9OdYUo4oaBAn/WV0/oSf36DMOdAITvQ+iiw4dDOshyTajTw1397IDHBUd6imStbCwpnuf4RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740766047; c=relaxed/simple;
	bh=R8m38/2DhwmnzhpnuBu+5eBZkklYnlBplJxuXkYbv7A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTOBnRfEJDLLCGzmtdopTI3MzPBSrgg2s+vQGFevBLb5EQJG7d7+S5mB7Hsg/twRCQlBeT4zv0z78zurMJ4NalSL6zD7hs6L5avri+++dht3sqKS3FPVfNOM7tLwNlJnZSbYVYY9O/dxGj353Pg9Zo1fq2EO6icE17QQn0QPKv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V9XzMuHj; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkLi4u+7k7FLBhehrr7Y/7Lk3+VHCrZ3GIjLFrevVashLBvDhTcQyTWlMkjeBi0J+OGAV/XOQc5QJ6UJ1yZhaLtdsIY4wrynSCZQlKvuIUvw6sZvpxQP+1ZEhdBCDvZkw+VL9q5ueBAsmAthTwyVKA7RFdavk61yZzK9KosNUbJKrws4YBNekTmE2zzUgFjoi8/aGPMnK9VnUKTDkwx6hsUq06zwKopooANVp9JaZpA3BbW7RoghL4tAqu3sdjAPa3q6A277xAFnKOZXORJCBFIa9ueLriS2Yf93oCkcyCZj2zIk5XbO4TlLHX90i1fjCe/JemYtTbvHRBf9tDeQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWn12FJGh/GHZYdIwhvqHLwqDpV8jfI8J1LlIkT28s0=;
 b=CHwn94C+AA36KwuMI9dUROj3skPtLoDViyeKuIBcnIfHDpHp3Zf+wYHfrTWWcvjDECre+Vgs3/k5Clw3WyjZduZbsHP3RD1l+QCWbTNoeuKYmNpWs1rpdH1VGSMWoWKorkey9XOvaEPx9LY1Awhqi6sNJRs1Q0Ibd64D/3AOLtXivZV7+KJjCK0N1nH5ldBkj8tzLFw7UEGZkTGD3Vh382Jv7wPErBK6rG8hcs7uhGbIbn5fxypmHZc0Uf5x9PnPdl9QP7Uszk48iA24SOSU5gi3j13ZUv44NJoLmUwFMULrf66De8g6NRahlfFFedcLe4o5apzQpCxNcg04xnWhQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWn12FJGh/GHZYdIwhvqHLwqDpV8jfI8J1LlIkT28s0=;
 b=V9XzMuHjw+AYC1uZWx/ubLTqvNHBJQRRM3dLZ4aP5Y2pxw34JZAMhrrLAO3BnqhrzSZacuBmY9r4/i55bsPv0Vo3wWNgWtBkfwn0IAxX/P5UGls7CaSCnwLrSsP5BzU5Lz88+wSftUFKip8o9kmZVA69Wr7JyyaHUZ9POnh7aX0=
Received: from CYXPR03CA0034.namprd03.prod.outlook.com (2603:10b6:930:d2::9)
 by DM4PR12MB6471.namprd12.prod.outlook.com (2603:10b6:8:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Fri, 28 Feb
 2025 18:07:21 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:930:d2:cafe::6c) by CYXPR03CA0034.outlook.office365.com
 (2603:10b6:930:d2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Fri,
 28 Feb 2025 18:07:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 18:07:21 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 12:07:20 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v6 1/6] target/i386: Update EPYC CPU model for Cache property, RAS, SVM feature bits
Date: Fri, 28 Feb 2025 12:07:01 -0600
Message-ID: <8ecfd8751d58811b18fd918a6d13e859217156d4.1740766026.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|DM4PR12MB6471:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1e641c-a97f-4c3f-9689-08dd5822bf2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rjbpuf/LTvXdQbaoP/hNPrW4ctJMcv//7aa/f8/rz9Y0bIvUZhP2CsdIvy/+?=
 =?us-ascii?Q?Fh7zjGg5sf0ggMkUtqILZftSPMXjiVF+5BiHmDpI70jCUH+kRL7rQmPKjAsx?=
 =?us-ascii?Q?0pYf59rN0gE4arJ3Cq4A3vV2BQVQNBRhUMMiQb+VTmO+/OpmHwckwkfQcTHO?=
 =?us-ascii?Q?9B8D5GZ1fRl2LauJxFBAcEevkVgxzRL5wjhFTnS1jAzpDyog07u6PwQ/8Y8c?=
 =?us-ascii?Q?6WoFyOS4KVJkkcr/CnpCo4jSRL+fD2AhiIkHsSEWJarBGW8GXX90Dhn8LwG/?=
 =?us-ascii?Q?uDPpQ/+UCoObMMy+9c5D5sNKZPpvG6vsYn4464HDvdlkn1gUe2upxSSmXFpU?=
 =?us-ascii?Q?LfrT+/+0JQi6aG3Y0SpCJsH6AxCQ0QpLsBQP6KPyecJ/9o38ZQ/wceVo7AJD?=
 =?us-ascii?Q?0nF2VGvfEJpy6czArMJSG42plWamYBPKXoFEnmnQvDYByuQSmKo1buPIYBhA?=
 =?us-ascii?Q?MKfUM7H5Mvk9/V/UNRlYJpCcIs+d/ZuAcEEN/4P7DCJt1xbeCOf6/qa+OO2A?=
 =?us-ascii?Q?cIeHKBjtap8Nhf6XfAxkL+eaikM/vAUWE4WboFpDOS33llroO1ZSRkWxb65T?=
 =?us-ascii?Q?sTgO6rOY2j5ySpCDM6Gp271uSYsy032jryehEtyYZNOgZN20ElgleyLGcb9R?=
 =?us-ascii?Q?zB5bcNwCaYNjHlt3JRdbChJAaXtNsWjnRUwweewtCmn4HF80ORzz9LqGsw9X?=
 =?us-ascii?Q?DD0PYiquF6a+HoczUt+5ICByvYF47L5Fjs2pzHnVGnLh4bcIrMiFubgXewyJ?=
 =?us-ascii?Q?Lh1zdFxrLXlZzvRJNNheyS5HzKCAYh/ZI5CFpcMzTGBEV8bQp/sm2bOBTS7h?=
 =?us-ascii?Q?Qqz38W+DfcnFPF1HhEQMMjOw+MIQuxZYExeETFBlfJBzmDfmjhY1ZATHKK8/?=
 =?us-ascii?Q?j0rg1rIHwICcEiqi+VxixD60KurzMLaoNWFLSwMF/72oRsSWmZ7br/qZKRhS?=
 =?us-ascii?Q?o9Q7p/xG21q0ys9Zj1DPE5NQMJZB9ZpbY/eujnk2SDtBi8FVUDYp0KEgOhuk?=
 =?us-ascii?Q?fHv6DfNcDlF6cThbvxK/7/XwYoxji9g7LKna6tK09f5T+0GjxdA4rrZq7oIc?=
 =?us-ascii?Q?UlvW/0oFXQ399kHUuHAPwTWSGkCU5nO2cjD8F5MiTTmO5oHZHELpmrX6Gs7A?=
 =?us-ascii?Q?U1xeK6+amOsF6vBZsL2WhIyFAPq8R3rMFXGeelznebKS0q9+NSEhDdbOawmz?=
 =?us-ascii?Q?niqZvl2TjTpUqU/bBnw2orJ2Yo0TsxiNKBvzo52E5NhYvA7U4PoW2yoesz09?=
 =?us-ascii?Q?z5a+DDvr3LCT5LpJp2xMyYu9HQBL99Rd8bd7vlzpKH+Qe/cZJYq7fW2U7FFs?=
 =?us-ascii?Q?6R3tDgJLRm0caB0BJa0LyjZcf63a7Qw/4h2TjL/vLt+AhZonRbcdBoD2TDyW?=
 =?us-ascii?Q?s8Glhbbj5ChufHX11rxKW934S4g5YLoi0eAs6HqCQMGJQx1UcL3FWeHxyFG2?=
 =?us-ascii?Q?+T0raE5HBu3Bpsxej8UGPcVBw3/Epyhrt5iSQBCq3LDilDIzxf53ivi7zAj3?=
 =?us-ascii?Q?oMVGlXgoMyDmQV8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 18:07:21.4418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1e641c-a97f-4c3f-9689-08dd5822bf2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6471

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
index 72ab147e85..7908b90b77 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2180,6 +2180,60 @@ static CPUCaches epyc_v4_cache_info = {
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
@@ -5207,6 +5261,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


