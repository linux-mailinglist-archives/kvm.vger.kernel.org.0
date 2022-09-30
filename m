Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DCC5F089B
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbiI3KVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiI3KTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:08 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167FB188BE9;
        Fri, 30 Sep 2022 03:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533146; x=1696069146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OnPzfJJFwhJZoW4FbnFPyVFYaq7RNXfLquHtT83+l1M=;
  b=jQv0rJi8297tGxV2Qkn0hnKljdl7R490rF6jvqRoUHqn75CLbP3NXNnm
   fK5uGt+8ilUc/qqVE1VBRYarXfw3Lji8tQriO7epbutc3CU3RFdgR7Z4s
   O+MwomWSsyc2fdVziKeVCHk/pKKTzMy45oZfCfE2xCUVFaErpniWPxR0S
   bZMwxCdB0g6WH/HOUHE34Y0uGRAw+uICPqrTpPqn0iqoR7HWyW9ZxkKae
   9ZXaYKrCkbsvYRuMOoaC4xtmTv6ZaYWDr0jFR/aROHodRHytaV7nKj5S6
   aT0/K8jeDe2o7m0isXJglFJ4e6LjIiSfJyO45LUiILbp1G7gLQZ9rfnHK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870105"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870105"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807646"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807646"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 045/105] KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
Date:   Fri, 30 Sep 2022 03:17:39 -0700
Message-Id: <fea12fb09707268f0bda41f6e9752a4cd6b7d02a.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX supports only write-back(WB) memory type for private memory
architecturally so that (virtualized) memory type change doesn't make sense
for private memory.  Also currently, page migration isn't supported for TDX
yet. (TDX architecturally supports page migration. it's KVM and kernel
implementation issue.)

Regarding memory type change (mtrr virtualization and lapic page mapping
change), pages are zapped by kvm_zap_gfn_range().  On the next KVM page
fault, the SPTE entry with a new memory type for the page is populated.
Regarding page migration, pages are zapped by the mmu notifier. On the next
KVM page fault, the new migrated page is populated.  Don't zap private
pages on unmapping for those two cases.

When deleting/moving a KVM memory slot, zap private pages. Typically
tearing down VM.  Don't invalidate private page tables. i.e. zap only leaf
SPTEs for KVM mmu that has a shared bit mask. The existing
kvm_tdp_mmu_invalidate_all_roots() depends on role.invalid with read-lock
of mmu_lock so that other vcpu can operate on KVM mmu concurrently.  It
marks the root page table invalid and zaps SPTEs of the root page
tables. The TDX module doesn't allow to unlink a protected root page table
from the hardware and then allocate a new one for it. i.e. replacing a
protected root page table.  Instead, zap only leaf SPTEs for KVM mmu with a
shared bit mask set.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 58 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 24 ++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++--
 3 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b38d9f4c457..84a08aa180b7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1578,7 +1578,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
-		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
+		/*
+		 * kvm_unmap_gfn_range() is called via mmu notifier.
+		 * For now page migration for private page isn't supported yet,
+		 * don't zap private pages.
+		 */
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, false);
 
 	return flush;
 }
@@ -6057,11 +6062,48 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
+static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	bool flush = false;
+
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+	 * case scenario we'll have unused shadow pages lying around until they
+	 * are recycled due to age or when the VM is destroyed.
+	 */
+	if (is_tdp_mmu_enabled(kvm)) {
+		struct kvm_gfn_range range = {
+		      .slot = slot,
+		      .start = slot->base_gfn,
+		      .end = slot->base_gfn + slot->npages,
+		      .may_block = false,
+		};
+
+		/*
+		 * this handles both private gfn and shared gfn.
+		 * All private page should be zapped on memslot deletion.
+		 */
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush, true);
+	} else {
+		flush = slot_handle_level(kvm, slot, __kvm_zap_rmap, PG_LEVEL_4K,
+					  KVM_MAX_HUGEPAGE_LEVEL, true);
+	}
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	write_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (kvm_gfn_shared_mask(kvm))
+		kvm_mmu_zap_memslot(kvm, slot);
+	else
+		kvm_mmu_zap_all_fast(kvm);
 }
 
 int kvm_mmu_init_vm(struct kvm *kvm)
@@ -6164,8 +6206,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+			/*
+			 * zap_private = true. Zap both private/shared pages.
+			 *
+			 * kvm_zap_gfn_range() is used when PAT memory type was
+			 * changed.  Later on the next kvm page fault, populate
+			 * it with updated spte entry.
+			 * Because only WB is supported for private pages, don't
+			 * care of private pages.
+			 */
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+						      gfn_end, true, flush,
+						      true);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9327a77d7434..542643b43162 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -937,7 +937,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * operation can cause a soft lockup.
  */
 static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+			      gfn_t start, gfn_t end, bool can_yield, bool flush,
+			      bool zap_private)
 {
 	struct tdp_iter iter;
 
@@ -945,6 +946,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	WARN_ON_ONCE(zap_private && !is_private_sp(root));
+	if (!zap_private && is_private_sp(root))
+		return false;
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -977,12 +982,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool can_yield, bool flush)
+			   bool can_yield, bool flush, bool zap_private)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush,
+					  zap_private && is_private_sp(root));
 
 	return flush;
 }
@@ -1042,6 +1048,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		/*
+		 * Skip private root since private page table
+		 * is only torn down when VM is destroyed.
+		 */
+		if (is_private_sp(root))
+			continue;
 		if (!root->role.invalid &&
 		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
 			root->role.invalid = true;
@@ -1233,11 +1245,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
-				 bool flush)
+				 bool flush, bool zap_private)
 {
 	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+				     range->end, range->may_block, flush,
+				     zap_private);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c163f7cc23ca..c98c7df449a8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -16,7 +16,8 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+			   gfn_t end, bool can_yield, bool flush,
+			   bool zap_private);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
@@ -25,7 +26,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
-				 bool flush);
+				 bool flush, bool zap_private);
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-- 
2.25.1

