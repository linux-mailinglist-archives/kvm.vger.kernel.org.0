Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F8E55C6B3
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbiF0V5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241504AbiF0Vz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:29 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80AE7648;
        Mon, 27 Jun 2022 14:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366900; x=1687902900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=14QOnIxl2cgdc6VY4ZAfgo2s1nj4iuizTBsbDRbO23s=;
  b=hPs7f5kJ7V8DuZ+g9aq5hla8Mz3XzkcpGdUmqhXjOs3jmDUARpgJUrN5
   1t/2mpvx/HTYaeYHfMPFbM3i3by2gz+jkZjGQ+B3ZV+So4O1AYIw8lctf
   vc7786N0ZdCKlTUA00SgixsWDbqyjPk67xIB41czfFeoh5brsso5jr9PX
   e7Lzv7zwp4ViuC6ei+SuNKhtPGNOmydq2pAUnQut6FI+/1p9QeWRjImpW
   UQQNr7Sdga6KhLNzAReSY2z9lsKA+3HICgdPnn7Gc6Ge4zNFM/sal914/
   tk/o7BCs0T+KANjhSWhXb4LrW2G2fUPlAStjmRG/xPNy9YoYvhO99XavI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609572"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609572"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863595"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 049/102] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
Date:   Mon, 27 Jun 2022 14:53:41 -0700
Message-Id: <8d2266b3e10156ec10daa5ba9cd1bd2adce887a7.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some KVM MMU operations (dirty page logging, page migration, aging page)
aren't supported for private GFNs (yet) with the first generation of TDX.
Silently return on unsupported TDX KVM MMU operations.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 74 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c         |  3 ++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 12f75e60a254..fef6246086a8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -387,6 +387,8 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
+		/* For memory slot operations, use GFN without aliasing */
+		gfn = gfn & ~kvm_gfn_shared_mask(kvm);
 		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
@@ -1398,7 +1400,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
 
 static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
+						   tdp_handler_t handler,
+						   bool only_shared)
 {
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
@@ -1409,9 +1412,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		gfn_t start;
+		gfn_t end;
+
+		if (only_shared && is_private_sp(root))
+			continue;
+
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		start = kvm_gfn_for_root(kvm, root, range->start);
+		end = kvm_gfn_for_root(kvm, root, range->end);
+
+		tdp_root_for_each_leaf_pte(iter, root, start, end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1455,7 +1472,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
+	/*
+	 * First TDX generation doesn't support clearing A bit for private
+	 * mapping, since there's no secure EPT API to support it.  However
+	 * it's a legitimate request for TDX guest.
+	 */
+	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range, true);
 }
 
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1466,7 +1488,7 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, false);
 }
 
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1511,8 +1533,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 * No need to handle the remote TLB flush under RCU protection, the
 	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
 	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
+	 *
+	 * .change_pte() callback should not happen for private page, because
+	 * for now TDX private pages are pinned during VM's life time.
 	 */
-	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
+	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn, true);
 }
 
 /*
@@ -1566,6 +1591,14 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
+	/*
+	 * Because first TDX generation doesn't support write protecting private
+	 * mappings and kvm_arch_dirty_log_supported(kvm) = false, it's a bug
+	 * to reach here for guest TD.
+	 */
+	if (WARN_ON(!kvm_arch_dirty_log_supported(kvm)))
+		return false;
+
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
@@ -1830,6 +1863,14 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  It is a
+	 * bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(!kvm_arch_dirty_log_supported(kvm)))
+		return false;
+
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
@@ -1896,6 +1937,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  For now silently
+	 * ignore KVM_CLEAR_DIRTY_LOG.
+	 */
+	if (!kvm_arch_dirty_log_supported(kvm))
+		return;
 	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
@@ -1975,6 +2023,13 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
+	/*
+	 * This should only be reachable when diryt-log is supported. It's a
+	 * bug to reach here.
+	 */
+	if (WARN_ON(!kvm_arch_dirty_log_supported(kvm)))
+		return;
+
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		zap_collapsible_spte_range(kvm, root, slot);
 }
@@ -2028,6 +2083,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	bool spte_set = false;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	/*
+	 * First TDX generation doesn't support write protecting private
+	 * mappings, silently ignore the request.  KVM_GET_DIRTY_LOG etc
+	 * can reach here, no warning.
+	 */
+	if (!kvm_arch_dirty_log_supported(kvm))
+		return false;
+
 	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcd1f5e2ba05..8f57dfb2a8c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12243,6 +12243,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	if (!kvm_arch_dirty_log_supported(kvm) && log_dirty_pages)
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
-- 
2.25.1

