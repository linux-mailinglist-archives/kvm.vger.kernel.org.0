Return-Path: <kvm+bounces-67484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AA572D065DF
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:49:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21BF53042294
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A2433D50E;
	Thu,  8 Jan 2026 21:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PxLNoxra"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010068.outbound.protection.outlook.com [40.93.198.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE312322B69;
	Thu,  8 Jan 2026 21:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908901; cv=fail; b=FwA5Ou3Xr+MmEG/xrKxjF3Fa1xS40gVKD2bZD0ufjorhidFRjtP7QfdS/64pNVsZr0mZ+Hyp+2pqRe0r52/cHlw/Mm5WGtHo4H3wUdvp5468zDjnvdAZeoarVuEep3BVgQFMzJkZf3YdwlXctaxdTjK0EHL2Sw+evT2vpA0i87s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908901; c=relaxed/simple;
	bh=OEvM6qbTylvo50D11P9SeLADcnjizH78GnvWG2itMWQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oouuMarOMA1OKi3FA+FHE1KCWUPKCJo8f/YULu9XvfAU3Wp3NCP8/qw8vpYH/HBAvCYb1QzXRUXGlHQ2PbcsrLJwq/afSkHak4QadGLH1tSDZLER10QLjbRqQIDIhpUuYLI4u5QeUSxNdC8xi5kjCbIk/EWSjhAv2WQOO2t1T5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PxLNoxra; arc=fail smtp.client-ip=40.93.198.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rBgX839IlHB9yBjf64g550St9F/Vgd4gaoyInwkWr7FYy5W2Q1G6px68p+tmCSoqfVTjTG/SYL7+zXHqPcuhGIsUELyGJKwi72mocv1M+dUEnptDP4kI75+vGzEbah1Ad7e4nNOhyQkMgagGTIPmKX94OfjT/AEfAuYiblCTyFBYFYFv9jKskn7WPGeetdkOZogqxWyN5JqFKOwReAzvt7NrDrBIYjBSTQIh2z7J/zOSV03fXWpuQU9yBhvwoWTc/rnRFHFBhsqPIYx02J8eUk3sCVKAaJCFNnW3sZH0HAbozZgazNqsZsDC0SvPt3thSkeDee85G/4tbQNkCBBp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+T3vQgOwfoAwYq9ThP4FF0wIPJyST2c7qW9it038Dg=;
 b=FHeoecIy9QZJJtTOQLCFYwcM/4j4YN3dX4vB1mMwnT3Rf0pceizG0sBfZTd7zKsQoRbYLTmFzv3YgOwDnOYMd85u8N+M/Wf1GExqfHMQKIiyoziwV5RdpgIpUviLSLWPgL0ZHLLfUwTKdRSwNW0aR7jUmTeUyfUtp00UCscooCODGB+mIyB1aXJW5/e1wZrCNwfcvD0ELrx3Uhj4Tc3KfvhYlSQkRDd5aY5S4ksJt7adZbY4guJhtcmrXRDHExKhe2Ngvh0YdffTMeIobxUeZtY1VDn917zwY6FCrmhJQN9fNFXIaijbLmqL7rAAEv0C2ELtmGzUzT8rD0txq040uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+T3vQgOwfoAwYq9ThP4FF0wIPJyST2c7qW9it038Dg=;
 b=PxLNoxrajcJw+gIqtOEcDNKC3zIwGZvOBONR4AqX3K338+Fv+INA88Uo9To0nmLUs0Zr48Enmx3SHJ9/lQbRO6XelZrXBvbFPCHWtUnh8QNXIhonGNSvOA1pTgEakZdnf2tzebESPxvBSv1OsrjwrvjexkjoCnk7bzKr7EmlGmA=
Received: from BY5PR17CA0028.namprd17.prod.outlook.com (2603:10b6:a03:1b8::41)
 by LV8PR12MB9716.namprd12.prod.outlook.com (2603:10b6:408:2a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 21:48:12 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::23) by BY5PR17CA0028.outlook.office365.com
 (2603:10b6:a03:1b8::41) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:48:11 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:48:11 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
Date: Thu, 8 Jan 2026 15:46:18 -0600
Message-ID: <20260108214622.1084057-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|LV8PR12MB9716:EE_
X-MS-Office365-Filtering-Correlation-Id: e2514335-6005-4ec2-55ba-08de4eff9e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZGabLIezJ9pzEb5WHRtijdCukgGTUp60nNPqL7iipGCMBLyvNPr7rvgy2Hv0?=
 =?us-ascii?Q?O+MxO73qZQa7CEKJs+v45gH+Z9JZXy2yKsQ6lx/vlVXn04IsmbXFmnoLHGYV?=
 =?us-ascii?Q?TAwXK83gu31P84fmydGloR8WLVkaklUo8jPMTtOHzQ76KpzyYw/8FzjX8n+y?=
 =?us-ascii?Q?Noc3FMIyNqtS6/K2hacbdEMPmD3OcVwoxw5dFiDwCkQ8YYMp2qKmlg/onzHl?=
 =?us-ascii?Q?MRUl8d7YKcudXpOiRM65PW3Y5XN9wO/7oAr/KSmMvFSACxNgsHiwcvmRL8lI?=
 =?us-ascii?Q?vliLMlXgq4fJKuTvvBekLm13t5kF9LwNfkxUSA93nyJMEzvz17UxzOeRQdIX?=
 =?us-ascii?Q?rsZGQx3XJiHM7PdnTSR8Y0+ldvz51QccPZqwrznQrLkE48Z0nSAMCyFOdVhw?=
 =?us-ascii?Q?4OY1dj8Go64/jAGQHzspr7DDQ6q4xxaqUXmhCm//3YvE+rVlpHaSb/7AC0kw?=
 =?us-ascii?Q?gq2oHxaQihWNPDct6FYEOePBsBtbKnD3Bni9Q0fjtrYK2/k8mPs63SoSrSEy?=
 =?us-ascii?Q?yNHmGXXPJDiI1M2DoyBamTg+K99boEFesDLPaat8kZYY9983s4g/3EOeARGI?=
 =?us-ascii?Q?2Yk78Do3Q39x5izoo6Lc8FT3+5A1dUqf2DojLsloiTCrN1PMW7fBBAbszbbi?=
 =?us-ascii?Q?qen6KuTbM9hHVnZ+fcpuoRsh+8MZXKL1OarNLEmv6qK9xVfDjo9HVRDt6VjU?=
 =?us-ascii?Q?PeSECGYor7qmhUErNrPA66XvCPtG+5suVRBBXClk49AOo7ZVbfZyd8hX4BWW?=
 =?us-ascii?Q?fZJBV9LARWzmM15uDql1OVK4TPk3xAbBWjfhTpbPWXIhGXe3Y7GQ3Y97QZhU?=
 =?us-ascii?Q?Z29LuLtDNDKF5gYIvV3IKNyRElmYoWTFEX/CFDYFx6vbOOPTFoKRUKq6g1r3?=
 =?us-ascii?Q?MYMOdhVX5CQ0AQRuTqtMZJptpf42c0R2nedRyDRGzLeB/hO5R5vFYhK1H6HG?=
 =?us-ascii?Q?fDBYX+rTxRg+Zh4/jrdj9gSnFeQlNsY+sYGzKgaLn0eaEQpm+8ghuWeGL870?=
 =?us-ascii?Q?xDuoSmFq8noacjKnTwGT7J+zyuVgXWs2dnscv0zvtSFdrsYB0FmVmeCZgA7A?=
 =?us-ascii?Q?u5H3Q/JSohnapDVPCUej1WP7jZgBRx4BHbFXK1KmDwmquSc4v7DMFXfG1vjO?=
 =?us-ascii?Q?unFwBhJclpXCvfdDylLQBewS7RzNIipi2sj3ekLYXenhxcExnus4RldRnZxm?=
 =?us-ascii?Q?4EpoEIvh0+VHGaZOho/yFHsRvMSWzAvCwAu+xXpbWi2NWwKsPQcTLEVggqrm?=
 =?us-ascii?Q?v0upZDCB69YniW0fHi2ZdeCCt5ucg9ADGEDOhQ5FPASFYLUGHnOJthIN16yR?=
 =?us-ascii?Q?/08Q60pOxxlNu7u/PMjKwGd+NbAyKMyr+1wxIllCgPh7ph4+EsYcF7ITe4je?=
 =?us-ascii?Q?vXtTw9kMG8FuO61BzHJswFn/6V2wzrbsABqbeH3rREEerb9ms8d9CJVdD5qc?=
 =?us-ascii?Q?oqZhzGcy5vDF6q/4oGA5XMz3K/3DdiRJuS+MimmUPGGPIFzkByzSGiwWd5+T?=
 =?us-ascii?Q?TAylrkKr7yBOOLGKjHhBsPpPe7cudAol54/ZhVsJswjuQiQ8A+QYDWzc1uXq?=
 =?us-ascii?Q?shV7+vt/voVwe3j6HR8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:48:11.4748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2514335-6005-4ec2-55ba-08de4eff9e77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9716

kvm_gmem_populate(), and the associated post-populate callbacks, have
some limited support for dealing with guests backed by hugepages by
passing the order information along to each post-populate callback and
iterating through the pages passed to kvm_gmem_populate() in
hugepage-chunks.

However, guest_memfd doesn't yet support hugepages, and in most cases
additional changes in the kvm_gmem_populate() path would also be needed
to actually allow for this functionality.

This makes the existing code unecessarily complex, and makes changes
difficult to work through upstream due to theoretical impacts on
hugepage support that can't be considered properly without an actual
hugepage implementation to reference. So for now, remove what's there
so changes for things like in-place conversion can be
implemented/reviewed more efficiently.

Suggested-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 94 ++++++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.c   |  2 +-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/guest_memfd.c   | 30 +++++++------
 4 files changed, 56 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 261d9ef8631b..a70bd3f19e29 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2267,67 +2267,53 @@ struct sev_gmem_populate_args {
 	int fw_error;
 };
 
-static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
-				  void __user *src, int order, void *opaque)
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  void __user *src, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct sev_data_snp_launch_update fw_args = {0};
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
-	int n_private = 0, ret, i;
-	int npages = (1 << order);
-	gfn_t gfn;
+	bool assigned = false;
+	int level;
+	int ret;
 
 	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
 		return -EINVAL;
 
-	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
-		struct sev_data_snp_launch_update fw_args = {0};
-		bool assigned = false;
-		int level;
-
-		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
-		if (ret || assigned) {
-			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
-				 __func__, gfn, ret, assigned);
-			ret = ret ? -EINVAL : -EEXIST;
-			goto err;
-		}
+	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
+	if (ret || assigned) {
+		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+			 __func__, gfn, ret, assigned);
+		ret = ret ? -EINVAL : -EEXIST;
+		goto out;
+	}
 
-		if (src) {
-			void *vaddr = kmap_local_pfn(pfn + i);
+	if (src) {
+		void *vaddr = kmap_local_pfn(pfn);
 
-			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
-				kunmap_local(vaddr);
-				ret = -EFAULT;
-				goto err;
-			}
+		if (copy_from_user(vaddr, src, PAGE_SIZE)) {
 			kunmap_local(vaddr);
+			ret = -EFAULT;
+			goto out;
 		}
-
-		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
-				       sev_get_asid(kvm), true);
-		if (ret)
-			goto err;
-
-		n_private++;
-
-		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
-		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
-		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
-		fw_args.page_type = sev_populate_args->type;
-
-		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
-				      &fw_args, &sev_populate_args->fw_error);
-		if (ret)
-			goto fw_err;
+		kunmap_local(vaddr);
 	}
 
-	return 0;
+	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+			       sev_get_asid(kvm), true);
+	if (ret)
+		goto out;
+
+	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+	fw_args.address = __sme_set(pfn_to_hpa(pfn));
+	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+	fw_args.page_type = sev_populate_args->type;
 
-fw_err:
+	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+			      &fw_args, &sev_populate_args->fw_error);
 	/*
 	 * If the firmware command failed handle the reclaim and cleanup of that
-	 * PFN specially vs. prior pages which can be cleaned up below without
-	 * needing to reclaim in advance.
+	 * PFN before reporting an error.
 	 *
 	 * Additionally, when invalid CPUID function entries are detected,
 	 * firmware writes the expected values into the page and leaves it
@@ -2337,26 +2323,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	 * information to provide information on which CPUID leaves/fields
 	 * failed CPUID validation.
 	 */
-	if (!snp_page_reclaim(kvm, pfn + i) &&
+	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn + i);
+		void *vaddr = kmap_local_pfn(pfn);
 
-		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
+		if (copy_to_user(src, vaddr, PAGE_SIZE))
 			pr_debug("Failed to write CPUID page back to userspace\n");
 
 		kunmap_local(vaddr);
 	}
 
-	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
-	n_private--;
-
-err:
-	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
-		 __func__, ret, sev_populate_args->fw_error, n_private);
-	for (i = 0; i < n_private; i++)
-		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
-
+out:
+	pr_debug("%s: exiting with return code %d (fw_error %d)\n",
+		 __func__, ret, sev_populate_args->fw_error);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..4fb042ce8ed1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,7 +3118,7 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+				  void __user *src, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..1d0cee72e560 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, int order, void *opaque);
+				    void __user *src, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..9dafa44838fe 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
+	/*
+	 * External interfaces like kvm_gmem_get_pfn() support dealing
+	 * with hugepages to a degree, but internally, guest_memfd currently
+	 * assumes that all folios are order-0 and handling would need
+	 * to be updated for anything otherwise (e.g. page-clearing
+	 * operations).
+	 */
+	WARN_ON_ONCE(folio_order(folio));
+
 	return folio;
 }
 
@@ -829,7 +838,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	struct kvm_memory_slot *slot;
 	void __user *p;
 
-	int ret = 0, max_order;
+	int ret = 0;
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -848,7 +857,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	filemap_invalidate_lock(file->f_mapping);
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
-	for (i = 0; i < npages; i += (1 << max_order)) {
+	for (i = 0; i < npages; i++) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
@@ -860,7 +869,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
@@ -874,20 +883,15 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		}
 
 		folio_unlock(folio);
-		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
-		}
+		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
+			goto put_folio_and_exit;
 
 		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
+		ret = post_populate(kvm, gfn, pfn, p, opaque);
 		if (!ret)
 			kvm_gmem_mark_prepared(folio);
 
-- 
2.25.1


