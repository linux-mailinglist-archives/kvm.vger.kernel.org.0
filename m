Return-Path: <kvm+bounces-49346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E09FAD7FD7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A79811897B80
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE84A1E485;
	Fri, 13 Jun 2025 00:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d1z7xF8e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2089.outbound.protection.outlook.com [40.107.96.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259711BFE00;
	Fri, 13 Jun 2025 00:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776148; cv=fail; b=d4BATk66rXrtAIgpyhK2NznziLhaXBNBlQ8sGXIwRUPUg/NQvGS81rF9eucSsLsG//avtAVnzNdH4mvTP/F2gfLGP6QF/ZVudaI3JVH4ao5CakjQwxAOQdbZg/aAxycuYUgMaRziH8z4/tvpClSQ7p9Zl7Mat9lk52Xh9IcUmWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776148; c=relaxed/simple;
	bh=+TTeox9mmq2ceHjzv7Orpn1tb7hFcgvrqk1Qowiaq/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U8srXt0SIAJuhPFqi4M2/qfBOxzRtedsbeQB1GNDZJFWF0Efl6HxsO2yxx8fqErZR3hO9JA88SnNRBevCUmLWv5jc3QuyV78gx6P5nRs67ZplwP9T1xoi12IDaJBb1oSmBwpSgTzewBs9LSRyPan7zw5RLXibtom7b5/1WqjwEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d1z7xF8e; arc=fail smtp.client-ip=40.107.96.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/D9oAcqTqMjeWMxmTxgLXEWgkvXjMN19DD7s9A1XTRVu2qCcGRVQhHaUPhwiyIJQpoXoVtpSurys/CxyGqGe2UMk8pYDwKB5tL3c8oWjdFWPXIH7edvLT6NJArq+XuFxkzRbrZq90du+2jxPfAxIpN/UYkD5MYADHxea+Y1OCFqPmHT7YrhdxQ6wZgVRI96XxA7sPXe9kxBoqftdyR4twMdm7NGHXFHLYeZyahFS6GvqkvCuiGQEVWlC0DAwc0jEhh19zvpfYg41suVf+eACs4WbbeD+iYN4Rax2HIrqgGoB/umOedtX5jA7alGizMOpiTHW7PX22zSr4zr+lP/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTIYLqnHflBJ4kcesaFIiAy5hujCp3BRjYbJNtqNmxc=;
 b=x+4rgtMZXaU2Vntk8m2/gR5vs1iYXn1euki4S9MHsqmLyxwmcD0nGWifKsaMkxALwcVYOH8fTot+ZxgEZZI3apY/iNa5lca6F4ZWfmW50upjpaT/J+x/R8+XlCXjUUJaeqwDKkuU+Gxz8IsFOEwLSWbauktm9bxy4JRlK4EuyLdCwF8nKmWFOH3mJgR+Ak1hLggg2zOkkcAsFslq8yQC4jDB6Rfct8AqNfSgI0Ay+BgjXnK4ala2/hOGBuoZli+bI17ANAgn/84tWddZKW2gLwzI6NXIjldo47/RQT+Hj+9XRePd6+fNIkeHmrAPqXrgFQE+wedxL6UCswacl8ygkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTIYLqnHflBJ4kcesaFIiAy5hujCp3BRjYbJNtqNmxc=;
 b=d1z7xF8e3HjxLrtS125t24nspXxP54QDxO/uD3aXxtsly/F7aDCHR4QihFM/zp4E0FkxbSu03YE6z3gWBQ5MZIqDUeu9JchAhZQLM2+iuQ1wb7uh17gCv/DKY3AUe4pbTBs1VL/8DTRz3cUc2PPCJdawK7B4ngk/GbZoSdTaiL4=
Received: from SJ0PR03CA0275.namprd03.prod.outlook.com (2603:10b6:a03:39e::10)
 by MW5PR12MB5681.namprd12.prod.outlook.com (2603:10b6:303:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Fri, 13 Jun
 2025 00:55:41 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::f2) by SJ0PR03CA0275.outlook.office365.com
 (2603:10b6:a03:39e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Fri,
 13 Jun 2025 00:55:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:55:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:55:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
Date: Thu, 12 Jun 2025 19:53:56 -0500
Message-ID: <20250613005400.3694904-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613005400.3694904-1-michael.roth@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|MW5PR12MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 3189f3cd-f622-4993-751d-08ddaa15052c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XkVb9sVT4WcZe0rydRo3wDqZCA/rPFyVYv7JGsIgLVoQARNep+3e1Twglrsx?=
 =?us-ascii?Q?8RCFQSTxKKQjpcN/ONkj/tb/+z+fKXcX882S3Ums+yAqggqPI/56Q8jvyv/e?=
 =?us-ascii?Q?ntTw/4N9NuiE1GZSQlC73W6oA3Xebq1jZiU5rNcpjtZkGlYNimAvT2++xemo?=
 =?us-ascii?Q?5XOWqh8gweKvbT3dVs4oIFisgJS3PhKi+v2EPoypfNIUvHHzTXbh6tvoDwJI?=
 =?us-ascii?Q?eGmyREkjMj1dQw5AGI6wlLtzWxvX8HQiVNJ+mZUiV5GzIc6VcPp4u02zTYz7?=
 =?us-ascii?Q?kRbIJdp9SCVv1VkYTuz2z28L7o8fkJVxzjAhHqXcpP3e8mIsjhEoF7oiFdWt?=
 =?us-ascii?Q?JjQVsKjdYC62m3p1maQPaW+x4FLXUHyk3JCqwM3/upDJ1ONjOnwTocA361vo?=
 =?us-ascii?Q?2C7G40JHfe77eoGy1R0h7NHWw28O2kPxfWWE5WOYyqlRxmLLkxcBqDrOf+vJ?=
 =?us-ascii?Q?rNXpGKCibOAlPXHSKztiQwCXGEPvhTKtwiGlU+EBfUtrDztchpdHl2i2C7Il?=
 =?us-ascii?Q?TEr5YCN4IdLs1gfsT9HlJ+Mb2PE06KvcHDvq8Gdr5ic6utQj/ifOzn3y3WDJ?=
 =?us-ascii?Q?5XnLHsTlgcK3+zL3KqoQr9X3ZCwYkkkwFaa7k3o4BVXcBSlc3VN6CdioWrqN?=
 =?us-ascii?Q?bG9vSL85muTuIHgMbrlgG9Th8BICDqmcmjLMA354rzyuGfXVCfNkJvJPQMfB?=
 =?us-ascii?Q?5xkbkMEGhj+y7Kzd3cRz3Ulj7gBUjMMuX+4R0anZXIkwpNTfuSh41V4MO+q1?=
 =?us-ascii?Q?e1pVih4sWWZTG4o9cxIpQer5hsbZybLBiCaysf9N4Le9gom8pX/O1bZVSsFO?=
 =?us-ascii?Q?jMv0PCkoEBuPbgiflLh3nnLl+YIKrJkKZZ+SQD4FCMtkdRS+OthwCO9TELuN?=
 =?us-ascii?Q?1xsSutFPs7VMeDF7Ut47smrJKrwjNgbYKA0/q/ybL0gwtfB5KwtDtbGg7TIY?=
 =?us-ascii?Q?gGMtmOxJ/b0IOi/s7yI1eI7/z7n23/e6icuaziNexaCxPDB0ipsvmrUgsd/Y?=
 =?us-ascii?Q?1A6/So/CWVqA0Rc3wByrut1iyiIiX5Q6fG2lEa+pHLJPosC585isXkz14VKw?=
 =?us-ascii?Q?X4Ub0hKOY/PLq+YcOgiLTF4Mn5jqYoR+3UdTiRRfsynT9/bNI2iZfc7f+Upu?=
 =?us-ascii?Q?ucTAi6+v7473KIwfoGtLJgGrvq3dETocnz+bNZroPB+EfBkXRW3qns9bhzML?=
 =?us-ascii?Q?DKzbMN+cHYRVdx8mPU5WVhQ4s9H9YpGWpylDHGA4sAHsXWRzuCjL55nNeqXA?=
 =?us-ascii?Q?0F2QTR6fxa+mP3er8GYg7BGqjvzacubk1lsh0bKDP2aYmkY2rdutckwAfjt/?=
 =?us-ascii?Q?lJuhAPbSHh0RuNAaO1hGyNKmM18PcJo1BN49Qi73TmOWopGldpAXvfe6IKvC?=
 =?us-ascii?Q?BYfz9X2gINiOXldzZNmIETPpVGhbLaUN+1ERACDcLq5vx2OEANi/Sc1xUXUs?=
 =?us-ascii?Q?z3BRL6NkDCHiNRml1/CUnuSDm8h5ExV892mPPSMAXO5rj8rn6cx63fh4Ch8+?=
 =?us-ascii?Q?OlLYjeCpN9UqS39toSCKW20yt1WwJSNn6t9S?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:55:41.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3189f3cd-f622-4993-751d-08ddaa15052c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5681

guest_memfd currently uses the folio uptodate flag to track:

  1) whether or not a page had been cleared before initial usage
  2) whether or not the architecture hooks have been issued to put the
     page in a private state as defined by the architecture

In practice, 2) is only actually being tracked for SEV-SNP VMs, and
there do not seem to be any plans/reasons that would suggest this will
change in the future, so this additional tracking/complexity is not
really providing any general benefit to guest_memfd users. Future plans
around in-place conversion and hugepage support, where the per-folio
uptodate flag is planned to be used purely to track the initial clearing
of folios, whereas conversion operations could trigger multiple
transitions between 'prepared' and 'unprepared' and thus need separate
tracking, will make the burden of tracking this information within
guest_memfd even more complex, since preparation generally happens
during fault time, on the "read-side" of any global locks that might
protect state tracked by guest_memfd, and so may require more complex
locking schemes to allow for concurrent handling of page faults for
multiple vCPUs where the "preparedness" state tracked by guest_memfd
might need to be updated as part of handling the fault.

Instead of keeping this current/future complexity within guest_memfd for
what is essentially just SEV-SNP, just drop the tracking for 2) and have
the arch-specific preparation hooks get triggered unconditionally on
every fault so the arch-specific hooks can check the preparation state
directly and decide whether or not a folio still needs additional
preparation. In the case of SEV-SNP, the preparation state is already
checked again via the preparation hooks to avoid double-preparation, so
nothing extra needs to be done to update the handling of things there.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 35f94a288e52..cc93c502b5d8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 	return 0;
 }
 
-static inline void kvm_gmem_mark_prepared(struct folio *folio)
-{
-	folio_mark_uptodate(folio);
-}
-
 /*
  * Process @folio, which contains @gfn, so that the guest can use it.
  * The folio must be locked and the gfn must be contained in @slot.
@@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
-	int r;
-
-	nr_pages = folio_nr_pages(folio);
-	for (i = 0; i < nr_pages; i++)
-		clear_highpage(folio_page(folio, i));
 
 	/*
 	 * Preparing huge folios should always be safe, since it should
@@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
 	index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
-	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
-	if (!r)
-		kvm_gmem_mark_prepared(folio);
 
-	return r;
+	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
 static int __kvm_gmem_filemap_add_folio(struct address_space *mapping,
@@ -808,7 +794,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
 
 	if (!folio_test_uptodate(folio)) {
 		clear_highpage(folio_page(folio, 0));
-		kvm_gmem_mark_prepared(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
@@ -1306,7 +1292,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					struct kvm_memory_slot *slot,
 					pgoff_t index, kvm_pfn_t *pfn,
-					bool *is_prepared, int *max_order)
+					int *max_order)
 {
 	struct file *gmem_file = READ_ONCE(slot->gmem.file);
 	struct kvm_gmem *gmem = file->private_data;
@@ -1337,7 +1323,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (max_order)
 		*max_order = 0;
 
-	*is_prepared = folio_test_uptodate(folio);
 	return folio;
 }
 
@@ -1348,7 +1333,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct file *file = kvm_gmem_get_file(slot);
 	struct folio *folio;
-	bool is_prepared = false;
 	int r = 0;
 
 	if (!file)
@@ -1356,14 +1340,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
 
-	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
+	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out;
 	}
 
-	if (!is_prepared)
-		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (!folio_test_uptodate(folio)) {
+		unsigned long i, nr_pages = folio_nr_pages(folio);
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+		folio_mark_uptodate(folio);
+	}
+
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -1420,7 +1411,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		bool is_prepared = false;
 		kvm_pfn_t pfn;
 
 		if (signal_pending(current)) {
@@ -1428,19 +1418,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
 		}
 
-		if (is_prepared) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ret = -EEXIST;
-			break;
-		}
-
 		folio_unlock(folio);
 		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
 			(npages - i) < (1 << max_order));
@@ -1457,7 +1440,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 		if (!ret)
-			kvm_gmem_mark_prepared(folio);
+			folio_mark_uptodate(folio);
 
 put_folio_and_exit:
 		folio_put(folio);
-- 
2.25.1


