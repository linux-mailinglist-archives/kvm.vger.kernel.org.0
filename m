Return-Path: <kvm+bounces-37526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65279A2B23D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 926C13A4CE0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C641A705C;
	Thu,  6 Feb 2025 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lgaRqJ9K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042D19ABD4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870141; cv=fail; b=IxocjXlKAbjDq3xs4cxNKzp10OVQkjB9i+EOH03Hau1oR3oS1pd5LPOh7m4MO3EMcbPD9wiTeyadwNkkUC+72RKvbvYBAEdPAyyPa0QMCMQ4/kGI+RU2shymRoaoBdd9gvpy/m/h7qOyS1nAqdsWfYg56fudbKVImT5pfzzm+s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870141; c=relaxed/simple;
	bh=kJ0YbHO7p9wOcjYU6GDlHaQARwAxXagdhxJUMW1g0/Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+asrSNCL2s83pDE0b8sBGo90A2Y4/MmPduJasLITQDBONP2toSoVktZoNzdx2pAUB8mmQoGNXA6D5fcf+a6Z16lJLKZQjFVoBDQBvekIpiEkVQtmLbFoLd9ji1uOk7n43wQ3uDmBX0RBpJrL4UTtT2+n1k35ZmeKfe5dIVwuKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lgaRqJ9K; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZBOS87oXBl1Oe/eroByCCynlc0M8C7ms3EjC+HaOXyr20IAOthKlp6YEnRFoZznF5kRv0jWXFM2KA+5t9cY5M0HhptQQo4L57B93zYEguKzE3x6pGL+twSTDVlxUDBuF0YhYZB9Xwh2PAvbc/NLyQUii7u68jka5GAw0qJ9tQZuQTsm8K5XOyFmlP70HflcgZm09+tFBx8Qhew69YP/9f26cqjfIFpWt4Pdc1rxuixsIYkx11l1HiotM9fNoDc6aVZQydDL2Nj49jS35dJa7LTReFpOE50lG+9wFpJ0ZKSyLJDI4ZCnAzVMr6KJuKTxvHS849eELf4Qae96AGiMmQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enr+DHDvQqAFRHWpl+NJ7W+NDyzzeyjea5PAjr3elMY=;
 b=EmYJEOAAhZEDta8I8pXYRTKj/aHkZQSTDq6GbAZNOw/yi/NgukT+PDjeapUy+3FExT3faBXcbx45G4/agSS+VTcCa78RREuzDFKu8AuazUKDx9DxEfQCXxYwcvYN5U3h7YulXO5PPbXegx+eZr34BIyVGd4xP3eiavsPnlpdbi01lvSJIz5MlOwmFzjvHvNmQ+fzCzjjuVB7/iQr+NL+s12TwH61P088hfZzyp6z1Yq0ma4DXdcvfphHfDObGNZYOja8C+BzlrWJMSPAGK2REvRt2zRELD7Q+v72XAX245MDINecZfAx0FSGxdBE+UgpRMGRBaV87V0DSiP9LwaIVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enr+DHDvQqAFRHWpl+NJ7W+NDyzzeyjea5PAjr3elMY=;
 b=lgaRqJ9KyAG2PsKyMrBEAzBBc4Hh9LeqmJeNgtTRuFm6DPXJoLKy2KvVxvYDMSiTtj/NKyaM98ZkgE2hsJj9RGzIrltK5jcTneXM8DFU+hB/vkowxlnHObxgOOuXTq5Xe4E2eRvZM4BfGQqZe49ASJ8Jy7vt2sr4yP3PV0UWViI=
Received: from CH2PR05CA0048.namprd05.prod.outlook.com (2603:10b6:610:38::25)
 by PH7PR12MB8154.namprd12.prod.outlook.com (2603:10b6:510:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Thu, 6 Feb
 2025 19:28:54 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:38:cafe::d0) by CH2PR05CA0048.outlook.office365.com
 (2603:10b6:610:38::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Thu,
 6 Feb 2025 19:28:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Thu, 6 Feb 2025 19:28:54 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 13:28:52 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v5 1/6] target/i386: Update EPYC CPU model for Cache property, RAS, SVM feature bits
Date: Thu, 6 Feb 2025 13:28:34 -0600
Message-ID: <c777bf763a636c8922164a174685b4f03864452f.1738869208.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|PH7PR12MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: a444005d-e31d-4484-9560-08dd46e47e9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ukFxP/oiLw4uGNWGeWLwaSyi85sWHD0iEnpy6hiacBTWDMUUsJdgpsQiqoJb?=
 =?us-ascii?Q?hQ0C43+QuknAAzzuZPJchTjt0CGrPI4IBgUSkqCZJgRKgqSq35mw0Ck+XUEk?=
 =?us-ascii?Q?YcmpAZBhiq78lmbzSTLq5vGBYZrBYzUgbgnXnlaD5CnMVeUSJ7RBoFCJFatY?=
 =?us-ascii?Q?zx1byeokqD+NnF9S3KsojaLAvS6dOlCbAsscebLrPlG12i6Yrq+QT+4F7d+I?=
 =?us-ascii?Q?dWHHxPrU9w1TYo724bEmuf72zRLm7exUjH7XcK0ebsSjTKucmonjmfTmKUyT?=
 =?us-ascii?Q?HyDsxAsfEjip1dKCAV86Qc2x0kScQ2On+1APYBT4jfsKDXLBsmrxK9vdn0dZ?=
 =?us-ascii?Q?0pQ8jEHHQUhPvHLduki3TJWN6a6aHxbRtHkjBGXr2fgBFu03Kj2eSPShKCS/?=
 =?us-ascii?Q?MvofRVGGU4xTZ59m0gFBZ35zOE3IH2IMTykQ4vn7xkttcjto5YGvkJco/bvT?=
 =?us-ascii?Q?BPWDHH/FVxxoy7u3YfthoFEYbqIFHCBfF3ujDo45HOKDkliu2LidDaewGRMp?=
 =?us-ascii?Q?jR1qGYOV0VYOGB8Xf55jg7dVU44uqLy/u90iQl4DCnzG5NfIjypyk62Gk+0N?=
 =?us-ascii?Q?l0NtEp/GmZJ+82G+iUkydEUyUV35cTgma5tuAtAq4j43QxvI9UyF1cuJvePb?=
 =?us-ascii?Q?b0fCHf/nUQO0V2JOdKagmgUX7mAwA8idCtEz6aPbYcrcWIiGPbSjfN2rr7mL?=
 =?us-ascii?Q?Vg4XqxEmXRK+UGs+/SCpaFYzZuvNBiIFFtQ3qvGUiTmP3MnXFG2HxVfJate7?=
 =?us-ascii?Q?/bzj2+9Fbq+0dS/7GLkDHVi3c71Hb/P40JOZ8vSWa+3JyBB4+1zMtpPmtWrN?=
 =?us-ascii?Q?8exUfeVfnOjgE9Bkukkw6xTibhCibQ1C/86M4xGQuv7UeoYx6aWfck8f+U7M?=
 =?us-ascii?Q?b3b86vkuLrK2Gn16KPWg96wMnMJLK/R2y6YL2uO4D570iABXjd1D7za2jPOV?=
 =?us-ascii?Q?aL18WlwQf0d281+iMYKbgA/r5KWU4DcBoJReUpUMwWKHB7dyHbim2sGupI3j?=
 =?us-ascii?Q?28SN4CmjnCLyq6WVljhg/0iTfcbXIaX55KX7mbsLkwlBjbUWOZ+/wfOBX8jQ?=
 =?us-ascii?Q?vLnPoKFE1MkSZIQ/LeN2zNzhiM0Eu5BbsoJy9jiarhZV6KF42t5DVxLRjsim?=
 =?us-ascii?Q?6gl0uVqX5yRuQxtvElIaQ39B9+es67eedxpWwb2CmjxcOVLOs5jNYZ5Xwz8C?=
 =?us-ascii?Q?GDPyoM2DFv56W2D4eltYXjasWGvlnDTwKxYcELfNZs2PY2Nex/SiIgFzZOr7?=
 =?us-ascii?Q?SYHD+Y80eeB12RoYnRHffJn+4VZMcLm8XXtYMmq179CQTqhcoI6kL488oKZP?=
 =?us-ascii?Q?yb2L6XLJVpSAbl2o2ofsb3RrPP4wXPwXcnxEAqf167xUlV08HoNKHXAEwO76?=
 =?us-ascii?Q?sCNAFZAHxPc9XMjosgk0zwerkdUKx6Xb3LuGuVlRbNG998jwRkWnEBxI3+B5?=
 =?us-ascii?Q?Ff+y82ySinmAsvdmoMzwKEn0UxeicT+0hioCped0NmYLJhRiLtfZRqou/Tz2?=
 =?us-ascii?Q?UX8lVTLrkQXUuKI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 19:28:54.6245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a444005d-e31d-4484-9560-08dd46e47e9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8154

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
---
 target/i386/cpu.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b5dd60d281..94292bfaa2 100644
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
+        .self_init = 1,
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


