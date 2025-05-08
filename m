Return-Path: <kvm+bounces-45978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A987AB0435
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 522611BA38EB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F29A28C2D0;
	Thu,  8 May 2025 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mQePt3tR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CB3289823
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734318; cv=fail; b=LDM7pi9ZBgWGS1Gub2BEsVhXnHK70naM0G2plEx7yFK3J2DpNTetrDlEBLWyaipl+IEDP97VThCL4ppmaGS5o2jflP9kEf1HbxNBdDyCbSijNZJ/jL4CCTorsS3/h/B3TVH/iMacnA84zTB6ereAws0+OYNz31rqYHpBgEmR994=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734318; c=relaxed/simple;
	bh=Hyot4VbiREVrFJN6QNpI4P6ouQZd/eZUkXkOHIPiYcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBEmCsHK844BChujhHBAsRiBOg+jeaQqYU2/OqmapSbIKztfOenLtlYVo3MLrDyxOQyidzf6Y4jP0s+E2AAexBoKxSufqRUOdL8poXfuj0XOTMrbjQGBsye5Sa1eRfp0F6LpbawkrG7A/+FQ0I30EkGItsNaqafLN1wdpe7ZrME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mQePt3tR; arc=fail smtp.client-ip=40.107.92.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AScB582NQujBg32Tf4zwXIVB77QlVga2pUmfd/3Y/YXj8P/WxFBTx6j+5i3yvpJjhBrNHExzGxt9lTB3yZGADphhtfimUZ1a5msqqUYi9m9d+SD96i+CpV5LEcjl5pYjx250Rkmaf9DQEGH/4s34RlBNRy95B9RybVo+gWa7s8StcZLxCgCfsENAUcYf+/rm0JU+56Onmqlx+THzD2eSMLzuDE+YXBfVED0S6IDNQy80wHXWnoYAOVMb8pj4KN/+msNT8pk5gZC1+F2s6V8P+Ndh4nIm3Kl1SwlAtE8qGxii82NrZzqsaIyPAk9Ftf2WvRyIqXTxmLprbujsZhTdfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqPYp98UxfMtFEp54S2MVquuA/wiSUBjLKO0pbiDGDo=;
 b=PFVj7Ukx1aG8waYERqjndimgHmrLk9YUAtRklVt+xHwCSuLG5k4JT5FQh7xMZOTNieQI9mHOq7Vxrte91uE4GlRztLxT5dpm2BSXG6TcNPnpf1l8Rhcmrpl5RwY3cw3b5FguMF+KX8DRPHy/KJgF54QZY2sJ8eYxl9r+9KpFkGPePvfVTbGjIIwu8MZaF8WmCf6e0HZqJnd3ywiqB5B7xKVBC195o+pDkIYIrYR7Uk3aKI6XYCYkLcO8FYVL9nc8L9lMHKAQcmsW6KTeTjwar1XXwmAEJNOQd3fJ01feLt4fQ0Y9dnhgvszMCkCQcw390jGgeE/XbEvOzuhozeXr4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqPYp98UxfMtFEp54S2MVquuA/wiSUBjLKO0pbiDGDo=;
 b=mQePt3tRUn6pop4ASlzRxWI6/2sVp8uO1QkFgr2CL4GTaI5i9tw5ctaDOUbpZFO2mSTMLlWcYW5ws15bRsxqUKO+IvJ4Xzx4ok44NWSEUhCOv7pCFD4Mr/jGcaXoFDRT6Y3inPEtj2QasjvNuzXx45118jEhW3P1SGMyTEbv9Bg=
Received: from CH2PR10CA0007.namprd10.prod.outlook.com (2603:10b6:610:4c::17)
 by SA3PR12MB9199.namprd12.prod.outlook.com (2603:10b6:806:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 19:58:32 +0000
Received: from DS3PEPF000099DA.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::c8) by CH2PR10CA0007.outlook.office365.com
 (2603:10b6:610:4c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.33 via Frontend Transport; Thu,
 8 May 2025 19:58:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DA.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:30 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 3/6] target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 8 May 2025 14:58:01 -0500
Message-ID: <c619c0e09a9d5d496819ed48d69181d65f416891.1746734284.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DA:EE_|SA3PR12MB9199:EE_
X-MS-Office365-Filtering-Correlation-Id: cabd7076-3088-4d42-2141-08dd8e6ab570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XxUQ/6sJOqBoPznCC0PUkss0bp/SFIWQfkNYPTHMGL1/8lf2aSg8aM7rKWjh?=
 =?us-ascii?Q?fAfWGiGjuSOoB7ZTuEoEmR8EQJwCKwo9BF0cJC86n0UiC3xRHCyUjC1movJT?=
 =?us-ascii?Q?oa1vPiP4PdSgxdFVMXZfvXxg9PrAtjsGVFQtq4U5yMNE2blf2G6q+ZOkz7he?=
 =?us-ascii?Q?k4d6+vNsMqHJOCUTawU5GEvxkndRiapxLqpKmN76EBKQJcuV1u+JeeQJskl3?=
 =?us-ascii?Q?lvbsxC2B7q2xH0leGtFMpyVyV6pPhz11RPmQrj8yBA7PxEc1CpqQ7QY3iM09?=
 =?us-ascii?Q?Xbw3uEl/whbXRZOrK23UeNXzGoRyRPIVWGx4GMMvZmN8EqFhOgLzxy8cg48V?=
 =?us-ascii?Q?d4RHz/smQijHBCT/pvBboE+/2uWadWQzKpQeIYv6HQ4PVHHf1I6Lo9drjYUq?=
 =?us-ascii?Q?BeY0xglMnQdL9j/55c8YYbLfBfkgfHV/IaiPE27uDWsHshkO346SoWiyJP6K?=
 =?us-ascii?Q?aAFrOXHq517TSZNlNYo56M2hGpBcsYtlYjj0YtmKNF5Lf7RC7dMkM4n+GZw/?=
 =?us-ascii?Q?KBVt8KIFeehaYtP0BYXvadcIjZhXOr8ECEs5c5B3tZKGUafku4LFNsqu1Nwl?=
 =?us-ascii?Q?ZbhNvKQ/0PWb9b3RVDIfzXhLJ+K2P9A03SlqVj7bUtrr5jpgz40xIEjfULJJ?=
 =?us-ascii?Q?T5qZ4WOwg5x59NL5BaNSagLjsdtOhJ7NirEzwqCaOnvMxFzrKD+ERghLhVY8?=
 =?us-ascii?Q?ha7CzFnPk5jT40TM/ZcDjxhUnQNlHC4IExK+C7DpNaYFBwobMET45L7wmKBa?=
 =?us-ascii?Q?jLMC7qiQGp0cBQelslXIAqjhvsC+buy37nTvhkdGtjH5w0uCM/mG6APRRgx4?=
 =?us-ascii?Q?ZqZpazzqU22qs6XJK7tWV/P3mlpkx6Zr7KRftpT3eFsU015CK3eFHeOrrKMD?=
 =?us-ascii?Q?1d5rQ3rrKgiA4/izLEmmvhJ0pw5iNGDBRwjGj+bpdtmqRa3E7/ZagHZJqrZy?=
 =?us-ascii?Q?gNCHqB9G5rEZPFyDSCUpW44iLAzznXzKov1/IsLhleOb0AeWiS2t/65ZJYJX?=
 =?us-ascii?Q?T+8TUzpYgfC7q+WSikMiL6kAVP9ySv9aCD7rE1O4ibk0fPhREmrtA43ZuTHV?=
 =?us-ascii?Q?5rVO7fLSJQeeOQ8jOgD5lGo1FJ62Lm2w7DZO6nNXMSNNewBx7C7uhftrRU+h?=
 =?us-ascii?Q?RAXIAyacUr/W5kZ1b+E/BFcAur7td6MHCmpHn1+bC9diGXi+6oUgMVtoqMs8?=
 =?us-ascii?Q?y3PSSrJZuzfrhmCTBVlJPY3IXYMm08/BBHbQtCn6447Ot1EM7f/KzIFjIFD4?=
 =?us-ascii?Q?izGaSs4XaFndoBuraRN+z0UW6TkuwuVkic8XCu2nAMjFRYTrrX711ELrgHUP?=
 =?us-ascii?Q?+uBklfr07hWRnIOz0O+mkyDAIgP6ma7/v+71ljSl9fPhGsTiyT45HawseWAS?=
 =?us-ascii?Q?obzp3qgwHEGGAEF0kjZ2D7854jIHowk6E/32X/f6lOo05b+M9E1sSvoKGM7z?=
 =?us-ascii?Q?fK/b2V0yQVScBWzuJcNUDBbbhcQw3YC2sNbb19JCOskrgGosJ6d5L4yh2n05?=
 =?us-ascii?Q?0hYwBPq0UE2S/L1ysx2MzLMBMjsnPpGShx7V?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:31.7375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cabd7076-3088-4d42-2141-08dd8e6ab570
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9199

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
index 3f64293ba5..98fad3a2f9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2509,6 +2509,60 @@ static const CPUCaches epyc_milan_v2_cache_info = {
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
@@ -5571,6 +5625,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


