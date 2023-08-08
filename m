Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F277470F
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjHHTJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 15:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjHHTId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 15:08:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9E2D6284;
        Tue,  8 Aug 2023 09:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691512237; x=1723048237;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=K1GJsw8lgF1tjIRVOFaimnhAkcSgXQtHjuv5CgZrIAk=;
  b=L85yKn0veHzlCxtgvqDywAwLbtM0gGcMUJlyOdRZb/DrNGO0DgL5SGVn
   2KGCi4lSLoODHbxrTg00VakA8EKJs8aXkN7stg6F/qAFEvZz7YyPuOPfL
   QShE/NjV0bRILAteBMWULQfMdgihgkYwN9TthZ27XzTXeoiJsOmxEtQe5
   5f0leygAZNRFB7UUmtXOWbcn53y17m0E4lfu8YFlMSExqYl4sAxX9RF8D
   zmN3/5D5faxddFUq8yoBTd8DRbHmkADyty0n4c7cMaC8F84IJUzZTaxWW
   C5cgF6h75qmK0eakRLlvSAcT8ifszFgcLHJoLr194T7qgm/ujZaYr5A+4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="401711470"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="401711470"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:45:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="1061918389"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="1061918389"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 00:43:51 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages for NUMA migration
Date:   Tue,  8 Aug 2023 15:17:02 +0800
Message-Id: <20230808071702.20269-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230808071329.19995-1-yan.y.zhao@intel.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip zapping pages that're exclusive anonymas and maybe-dma-pinned in TDP
MMU if it's for NUMA migration purpose to save unnecessary zaps and TLB
shootdowns.

For NUMA balancing, change_pmd_range() will send .invalidate_range_start()
and .invalidate_range_end() pair unconditionally before setting a huge PMD
or PTE to be PROT_NONE.

No matter whether PROT_NONE is set under change_pmd_range(), NUMA migration
will eventually reject migrating of exclusive anonymas and maybe_dma_pinned
pages in later try_to_migrate_one() phase and restoring the affected huge
PMD or PTE.

Therefore, if KVM can detect those kind of pages in the zap phase, zap and
TLB shootdowns caused by this kind of protection can be avoided.

Corner cases like below are still fine.
1. Auto NUMA balancing selects a PMD range to set PROT_NONE in
   change_pmd_range().
2. A page is maybe-dma-pinned at the time of sending
   .invalidate_range_start() with event type MMU_NOTIFY_PROTECTION_VMA.
    ==> so it's not zapped in KVM's secondary MMU.
3. The page is unpinned after sending .invalidate_range_start(), therefore
   is not maybe-dma-pinned and set to PROT_NONE in primary MMU.
4. For some reason, page fault is triggered in primary MMU and the page
   will be found to be suitable for NUMA migration.
5. try_to_migrate_one() will send .invalidate_range_start() notification
   with event type MMU_NOTIFY_CLEAR to KVM, and ===>
   KVM will zap the pages in secondary MMU.
6. The old page will be replaced by a new page in primary MMU.

If step 4 does not happen, though KVM will keep accessing a page that
might not be on the best NUMA node, it can be fixed by a next round of
step 1 in Auto NUMA balancing as change_pmd_range() will send mmu
notification without checking PROT_NONE is set or not.

Currently in this patch, for NUMA migration protection purpose, only
exclusive anonymous maybe-dma-pinned pages are skipped.
Can later include other type of pages, e.g., is_zone_device_page() or
PageKsm() if necessary.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 26 ++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |  4 ++--
 include/linux/kvm_host.h   |  1 +
 virt/kvm/kvm_main.c        |  5 +++++
 5 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d72f2b20f430..9dccc25b1389 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6307,8 +6307,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start, gfn_end,
+						      true, flush, false);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6250bd3d20c1..17762b5a2b98 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -838,7 +838,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * operation can cause a soft lockup.
  */
 static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+			      gfn_t start, gfn_t end, bool can_yield, bool flush,
+			      bool skip_pinned)
 {
 	struct tdp_iter iter;
 
@@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (skip_pinned) {
+			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
+			struct page *page = kvm_pfn_to_refcounted_page(pfn);
+			struct folio *folio;
+
+			if (!page)
+				continue;
+
+			folio = page_folio(page);
+
+			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
+			    folio_maybe_dma_pinned(folio))
+				continue;
+		}
+
 		tdp_mmu_iter_set_spte(kvm, &iter, 0);
 		flush = true;
 	}
@@ -878,12 +894,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool can_yield, bool flush)
+			   bool can_yield, bool flush, bool skip_pinned)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush,
+					  skip_pinned);
 
 	return flush;
 }
@@ -1147,7 +1164,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
 	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+				     range->end, range->may_block, flush,
+				     range->skip_pinned);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..2a9de44bc5c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,8 +20,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool can_yield, bool flush, bool skip_pinned);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9125d0ab642d..f883d6b59545 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,6 +266,7 @@ struct kvm_gfn_range {
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	bool may_block;
+	bool skip_pinned;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f84ef9399aee..1202c1daa568 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -532,6 +532,7 @@ struct kvm_hva_range {
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
+	bool skip_pinned;
 };
 
 /*
@@ -595,6 +596,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg = range->arg;
 			gfn_range.may_block = range->may_block;
+			gfn_range.skip_pinned = range->skip_pinned;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -754,6 +756,9 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.on_unlock	= kvm_arch_guest_memory_reclaimed,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
+		.skip_pinned	= test_bit(MMF_HAS_PINNED, &range->mm->flags) &&
+				  (range->event == MMU_NOTIFY_PROTECTION_VMA) &&
+				  (range->flags & MMU_NOTIFIER_RANGE_NUMA),
 	};
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
-- 
2.17.1

