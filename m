Return-Path: <kvm+bounces-67486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF81D065FA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB8BD305E3F3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C6F33D50C;
	Thu,  8 Jan 2026 21:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vSP8M0Y2"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745241F9F7A;
	Thu,  8 Jan 2026 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908937; cv=fail; b=JyorzypSSP7lTs7Vm/XNEjFWdUr7SQalcqT3d9na2H9zv4AOZOt3Qrs19H606FEhOLI4YdM0yqRqJlAwMlLZv32D+rsrav+FpO2Ezo+dXjsRrNjveKlznTLBF59ZY8vmehQzCqdtZf6BpB9oLPFTgG2LxzXh8yEiBp1INiOHugU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908937; c=relaxed/simple;
	bh=XWUMsPgQOfgRx95TtdPvULUniOSybX/fL+ys3DPkeGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbykEwKKx1684JnlgcWCt/Gx87MCLPg0GDj1EtMnxASFLQ9CHKgm5COgUzvF5vaGdDFYakWPT4WpVgKi93hU3A2T1GEITPgskMtiv3B2VO9SOId5orcU3poDQl12jO9l38JgGo0d+MO0sTeqabbQYojnRY87p92MNJidhxcpdUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vSP8M0Y2; arc=fail smtp.client-ip=52.101.61.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFC8bC/+69UpGfFt7TH+JqbeAyh0KnEJzSV7eUC/L+vpGb6bt6fYWJFcEXxmudnr9/PxBGksaNhlPym9zRxUh16I7Bd7kbeIIMrYAafV47/bOtNDKvZG6HhuAgcbicbciEQma94lr+XRE2xpsIhXrFad5n9pkZ31C0p9tbvleaLZCccbnwPHudo/w41yxocdy0trZJsduxQ88uolXuPAslqfV9ykihCeHFtaLo7k3pTY1GdnMxiB/HazD2AfDD2wmIghiT9F7RV/GAKmxEOz9E1oXaxHU01bnCogaqql29l04vwgW1rOYTYD5YCx82mMDCA4aDP9AXgF3bEniQlrjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T6S2bnfs9WvvEfWZmJfQLL0w0M0Psm/uI4p6BSOG8/E=;
 b=HNWg/2qVmVWGX2A2l6Cn+Y+ZR00imYIuBeGobzr17RtyNNp+Lvqjjk7MLrvmX/L5YZHJB69fVqnSw6WSSTCJoRtAhlvahsP2lByRlNkOgwwE9hel7n6jVWngRhBv5HN1Emr0Cpy47DDWrxMW5DE/yPx83mMKdeaQtg/Gqh62TiAhxlbbf6La/DE7jv/Blg1IQ1kqSJzbLT7QTQV+mFa5WHxrdmx3mWhD5lJ9ETO8rA41QtYVmWMbsKZBfiyoEBhiorp7JUZetnaBKvBXm10ccvpCyHaHqqHuPsvobt22YtVaaKdGN/ltNgBinc4mLPHDBXFOFf1v00OMFwpNQOTBOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6S2bnfs9WvvEfWZmJfQLL0w0M0Psm/uI4p6BSOG8/E=;
 b=vSP8M0Y2FIIZyaNLQ5YaXhXlnUPDVLUIJF1wflBu6liq/XOAgPjU3jPw4rnZwwONo7tUVJxH1yK0iTukvB8+gtolUFd4xo/uKDT19Q8EMA/UiXZIf/EawvyNYK+EwlJ+0X9ASvRbMBwFtSIAMvmh465PgL4pP8QzxjNASdaWu0E=
Received: from MW4PR04CA0379.namprd04.prod.outlook.com (2603:10b6:303:81::24)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 21:48:53 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:303:81:cafe::f) by MW4PR04CA0379.outlook.office365.com
 (2603:10b6:303:81::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:48:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:48:53 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:48:52 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
Date: Thu, 8 Jan 2026 15:46:20 -0600
Message-ID: <20260108214622.1084057-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 2747046a-d6e2-4d32-e667-08de4effb743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B/tIsMYIRe7MhKrwpHwkwuXbyp4MbYzmFbXKc78nSb9dEgPo8lrKCJ8dOzl2?=
 =?us-ascii?Q?V/TV4+vGyRmRzRdLnuzxJZhWzRLxS0Hl00nGizWhjyekJXJYjRTnHplY2tMf?=
 =?us-ascii?Q?vAZfu1JZ50CPBXxDfi7V2KqMnt402bfnTw0H5Is5jErunKL9sPgQXJBB5KrY?=
 =?us-ascii?Q?O3+vcjhNABFi4aR0bGcHFI2+qxapnYPFuJFMn78FBHEC0tAGw0rGp4Cxq8qM?=
 =?us-ascii?Q?+/zDOY1G9HkbBOqm116QmVyVp5dl+mwqDnhHJlfmHWeT5Z+sKu/8WcY+yA1Q?=
 =?us-ascii?Q?ICExICD0pe3YEjiR3FpKczMl2f+fQ/bD1XIqdn+ioXl6F6nAdjBunr00PyRe?=
 =?us-ascii?Q?pRijoisINIA0/u6v07SZFw9LuShNxFCdrslWltO7gXODBhaYhbYqBGN2O3b5?=
 =?us-ascii?Q?/BTvuijuAJZ1jqkB6UtIy9AMxkbqpC3ilSL85kQNnJ6xYWVkyncELSMMJrZ2?=
 =?us-ascii?Q?lA5BqorMHjJYH/rP+GsHvkPq+432BWZqmC1Nrif0AmgpNRGi0V59B7G8AVtH?=
 =?us-ascii?Q?HXuDTM9Rr2X3luiO62O2VOZAQVr9seZdi44iYbzK3qU8x8PnG0Zcc9MsrTEv?=
 =?us-ascii?Q?6Dkgx+z8sbR296fPLq1EtLz8G0PKEIZl4dMeGM/NeJDf4EzcfkS9ZtCR57iq?=
 =?us-ascii?Q?ImRP+cAYENISw31vAOudAr4IyAiVmY4vnLdHP343z6F+qiTCl44drnG41MyH?=
 =?us-ascii?Q?D4/PSsApozyO4NyAbsIkegsiqzf1zoS4liyI3C/TIj/dsYKsxgd93ptf3wZB?=
 =?us-ascii?Q?kmmOTtdMFOQex3ee83nNSRk+3PablpyEtkU8GYQwGRi9vdaVNKH55n27JtPO?=
 =?us-ascii?Q?VXJwy96mIwkpua0Ja3BdO16FikkxGMOlsf8GZkUu4LtylbxrXyCY5jM2ffSI?=
 =?us-ascii?Q?7UEJagaauy1DMOBockooU1X2YM5/4KE2gFTGi1UAHfpupKM2V3LllxY5gK5w?=
 =?us-ascii?Q?7L3CsGG9FS3eF4QiI482rhHQxChYne67tfEh6o/s1DwlanlAAlETaU95lJys?=
 =?us-ascii?Q?yRQmqPY8dQIrq8H+LvFq4ySadWcEsz9Pfu8x9WIrfVt3YlvsTSZi6PfIynCL?=
 =?us-ascii?Q?MSpC/FDK97XRrMhqrldJ03UAOz2nP4sA6k8eU3cBdyhMSJmdngfgJ57llj6U?=
 =?us-ascii?Q?tQmcfud4iTLuHtmiyIqWJ7wRcARqRiACcmVne/38h01cj9KDo6JuxvCPHCvj?=
 =?us-ascii?Q?qJUXYf8i9lXhl+XCJH1Zvmq+fRN9xc03JyqyLpHfvZ0zHWOsdHhPRRfYXm78?=
 =?us-ascii?Q?NCyxl/QiNY8P1mWCyUfJ631TEePAKFWC+devuAvWTaBSuoXWhebaY9XGeDfL?=
 =?us-ascii?Q?SB04KfaGhwOUJ126iZTU7CxQoUMyeWi6efKS5lrkXo21Jcv4vscn37ih0tkP?=
 =?us-ascii?Q?49Ps0VGHifliaSkf8rqAk0VuPVGaB4g40+3rKvAFDBxaGn9hagjivLHp8E+s?=
 =?us-ascii?Q?JZurim8VPcXlw+2YP5Pp7tIw8kZJ1xN5J1nnjafOIq/2tEDHaL+mNtZdEmvx?=
 =?us-ascii?Q?GcIGsL6sNOPUABQm36Ane9yFCJDjGQAHkb6W+9L9trkWdEhBAftvhtorbR9j?=
 =?us-ascii?Q?r3dMZRdhQoE/z92wlso=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:48:53.0157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2747046a-d6e2-4d32-e667-08de4effb743
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911

In the past, KVM_SEV_SNP_LAUNCH_UPDATE accepted a non-page-aligned
'uaddr' parameter to copy data from, but continuing to support this with
new functionality like in-place conversion and hugepages in the pipeline
has proven to be more trouble than it is worth, since there are no known
users that have been identified who use a non-page-aligned 'uaddr'
parameter.

Rather than locking guest_memfd into continuing to support this, go
ahead and document page-alignment as a requirement and begin enforcing
this in the handling function.

Reviewed-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
 arch/x86/kvm/svm/sev.c                               | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..5a88d0197cb3 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -523,7 +523,7 @@ Returns: 0 on success, < 0 on error, -EAGAIN if caller should retry
 
         struct kvm_sev_snp_launch_update {
                 __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
-                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u64 uaddr;            /* 4k-aligned address of data to be loaded/encrypted. */
                 __u64 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
                 __u8 type;              /* The type of the guest pages being initialized. */
                 __u8 pad0;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a70bd3f19e29..b4409bc652d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2367,6 +2367,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
 		return -EINVAL;
 
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	if (!PAGE_ALIGNED(src))
+		return -EINVAL;
+
 	npages = params.len / PAGE_SIZE;
 
 	/*
@@ -2398,7 +2403,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
 
 	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
-- 
2.25.1


