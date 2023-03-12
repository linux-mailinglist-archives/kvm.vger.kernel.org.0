Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D676B64A5
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCLKA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjCLKA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28628527F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615175; x=1710151175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hlM3aVOVTQDVpNj7fX2SPhRMDqzjfyw+Zs/99kXGok8=;
  b=BVBnC5zjdlYFvMbhP+SXIKSMrXrUl0eLrtOayuxLDPXQtNHwNRb7Ceub
   z1pcm3ElZlQcoqEkH3OdXYEtsDBbtPjv4uJtlXBgBgKzvdOKDBGI8PRZh
   JAyF/DgxIx0DnBiGvcQuTdcm4UV1dxAo0JqYgJEj1jYRxRv3AZpysk6B8
   aKsEhtZXsCv0Ox6Luzl65duxsxp4NuyQaVC/KEGdo81OSmvJJ2pQz85S/
   ejZA1tRq3kY6ZwHeY4ja7IW7tAIqYA9PqKl3mzviV9qWkW1HB7QconVS0
   IAPmI1Tv6IOm8iXumeAJ+2+MUGuyFUGtW+Y8/BOkhrRW2guoFVrFKaPmt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344749"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344749"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627485"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627485"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:20 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-7 01/12] pkvm: x86: Introduce pkvm_pgtable_annotate
Date:   Mon, 13 Mar 2023 02:04:04 +0800
Message-Id: <20230312180415.1778669-2-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180415.1778669-1-jason.cj.chen@intel.com>
References: <20230312180415.1778669-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

To protect guest memory, pKVM needs a mechanism to record page's
ownership. This will help memory ownership's transition among
different entities - host, guests and pKVM hypervisor.

Host EPT page-table is a good place to record the page's ownership, as
by default, host VM owns almost all the memory resource, so it shall
have almost all memory mapping in its EPT page-table. And host VM will
manage these memory resource by allocating to different guests, so host
VM knows each page's exact owner.

pKVM uses the ignored bits([12,31]) of invalid mappings in the host EPT
page entry to store the unique identifier of the page owner. Choose to
use these 20 bits is trying to avoid to conflict with low 12 pte prot
bits.

Introduce pkvm_pgtable_annotate to help set ownership id in the pgtable
PTE, it re-uses most of the map() logic, but ends up creating invalid
mapping with 'annotation' instead. This impacts how pKVM do refcount as
it now need to count invalid mappings when they are used for ownership
tracking.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c | 78 +++++++++++++++++++++++------
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h |  2 +
 2 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
index 54107d4685ed..95aef57d8ed7 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.c
@@ -20,6 +20,7 @@ struct pgt_walk_data {
 
 struct pkvm_pgtable_map_data {
 	unsigned long phys;
+	u64 annotation;
 	u64 prot;
 	int pgsz_mask;
 };
@@ -35,6 +36,21 @@ struct pkvm_pgtable_lookup_data {
 	int level;
 };
 
+static bool pkvm_phys_is_valid(u64 phys)
+{
+	return phys != INVALID_ADDR;
+}
+
+static bool pgtable_pte_is_counted(u64 pte)
+{
+	/*
+	 * Due to we use the invalid pte to record the page ownership,
+	 * the refcount tracks both valid and invalid pte if the pte is
+	 * not 0.
+	 */
+	return !!pte;
+}
+
 static bool leaf_mapping_valid(struct pkvm_pgtable_ops *pgt_ops,
 			       unsigned long vaddr,
 			       unsigned long vaddr_end,
@@ -64,7 +80,7 @@ static bool leaf_mapping_allowed(struct pkvm_pgtable_ops *pgt_ops,
 {
 	unsigned long page_size = pgt_ops->pgt_level_to_size(level);
 
-	if (!IS_ALIGNED(phys, page_size))
+	if (pkvm_phys_is_valid(phys) && !IS_ALIGNED(phys, page_size))
 		return false;
 
 	return leaf_mapping_valid(pgt_ops, vaddr, vaddr_end, pgsz_mask, level);
@@ -97,7 +113,7 @@ static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
 {
 	struct pkvm_pgtable_ops *pgt_ops = pgt->pgt_ops;
 	struct pkvm_mm_ops *mm_ops = pgt->mm_ops;
-	u64 new;
+	u64 old = *(u64 *)ptep, new;
 
 	if (!leaf_mapping_allowed(pgt_ops, vaddr, vaddr_end,
 				 data->phys, data->pgsz_mask, level)) {
@@ -105,20 +121,28 @@ static int pgtable_map_try_leaf(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		return (level == PG_LEVEL_4K ? -EINVAL : -E2BIG);
 	}
 
-	new = data->phys | data->prot;
-	if (level != PG_LEVEL_4K)
-		pgt_ops->pgt_entry_mkhuge(&new);
+	if (pkvm_phys_is_valid(data->phys)) {
+		new = data->phys | data->prot;
+		if (level != PG_LEVEL_4K)
+			pgt_ops->pgt_entry_mkhuge(&new);
+	} else {
+		new = data->annotation;
+	}
 
-	if (pgt_ops->pgt_entry_present(ptep)) {
-		pgt_ops->pgt_set_entry(ptep, 0);
-		flush_data->flushtlb |= true;
+	if (pgtable_pte_is_counted(old)) {
+		if (pgt_ops->pgt_entry_present(ptep)) {
+			pgt_ops->pgt_set_entry(ptep, 0);
+			flush_data->flushtlb |= true;
+		}
 		mm_ops->put_page(ptep);
 	}
 
-	mm_ops->get_page(ptep);
-	pgt_ops->pgt_set_entry(ptep, new);
+	if (pgtable_pte_is_counted(new))
+		mm_ops->get_page(ptep);
 
-	data->phys += page_level_size(level);
+	pgt_ops->pgt_set_entry(ptep, new);
+	if (pkvm_phys_is_valid(data->phys))
+		data->phys += page_level_size(level);
 
 	return 0;
 }
@@ -489,12 +513,13 @@ int pkvm_pgtable_init(struct pkvm_pgtable *pgt,
 	return 0;
 }
 
-int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
-		     unsigned long phys_start, unsigned long size,
-		     int pgsz_mask, u64 prot)
+static int __pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		     unsigned long phys, unsigned long size,
+		     int pgsz_mask, u64 prot, u64 annotation)
 {
 	struct pkvm_pgtable_map_data data = {
-		.phys = ALIGN_DOWN(phys_start, PAGE_SIZE),
+		.phys = phys,
+		.annotation = annotation,
 		.prot = prot,
 		.pgsz_mask = pgsz_mask ? pgt->allowed_pgsz & pgsz_mask :
 					 pgt->allowed_pgsz,
@@ -508,6 +533,14 @@ int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 	return pgtable_walk(pgt, vaddr_start, size, &walker);
 }
 
+int pkvm_pgtable_map(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
+		     unsigned long phys_start, unsigned long size,
+		     int pgsz_mask, u64 prot)
+{
+	return __pkvm_pgtable_map(pgt, vaddr_start, ALIGN_DOWN(phys_start, PAGE_SIZE),
+				  size, pgsz_mask, prot, 0);
+}
+
 int pkvm_pgtable_unmap(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 		       unsigned long size)
 {
@@ -585,3 +618,18 @@ void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt)
 	virt_root = pgt->mm_ops->phys_to_virt(pgt->root_pa);
 	pgt->mm_ops->put_page(virt_root);
 }
+
+/*
+ * pkvm_pgtable_annotate() - Unmap and annotate pages to track ownership.
+ * @annotation:		The value stored in the invalid pte.
+ * 			@annotation[2:0] must be 0.
+ */
+int pkvm_pgtable_annotate(struct pkvm_pgtable *pgt, unsigned long addr,
+			  unsigned long size, u64 annotation)
+{
+	if (pgt->pgt_ops->pgt_entry_present(&annotation))
+		return -EINVAL;
+
+	return __pkvm_pgtable_map(pgt, addr, INVALID_ADDR, size,
+			1 << PG_LEVEL_4K, 0, annotation);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
index 61ee00ee07af..cb6645e96409 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pgtable.h
@@ -80,4 +80,6 @@ int pkvm_pgtable_unmap_safe(struct pkvm_pgtable *pgt, unsigned long vaddr_start,
 void pkvm_pgtable_lookup(struct pkvm_pgtable *pgt, unsigned long vaddr,
 		unsigned long *pphys, u64 *pprot, int *plevel);
 void pkvm_pgtable_destroy(struct pkvm_pgtable *pgt);
+int pkvm_pgtable_annotate(struct pkvm_pgtable *pgt, unsigned long addr,
+			  unsigned long size, u64 annotation);
 #endif
-- 
2.25.1

