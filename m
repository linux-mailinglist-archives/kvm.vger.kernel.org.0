Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DBD4CDE83
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiCDUKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCDUH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:59 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E535D23F3E9;
        Fri,  4 Mar 2022 12:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424149; x=1677960149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bRkGh1W9Kz+bZwuFaqcQBr6/+4CajNo1l6HXrc+ge2A=;
  b=TKPym8cmrjesUdEhDYLhVoKEFL8drSe7ja031CO4Q61RoNBBsw4vPuEh
   EXbk5LfFrA6kSehir4xSLXFRflnBOmSYYqdiNUoFw/glMzR4fuS78Hh6N
   SM/HfGgu+I3ZTJDp1FkU/XRUEe4N+amgyHYVKIqU2blloTnbf6qPycNqL
   MGwHUV3PgFNeDxvhc3q/d9YSHfZENHI/xXeeKSPW9Uaoyik5OPgSP4x7M
   Mg0gYta8QvFqcrt0xdzl3e+AeT3SoTxypWxXFTFiFcqRrh+zEshYoSsmu
   kOmGUfTGVxnTUcWAKLZNsD2SuJJQHwn9ysVSjKKK3ocMlRFKDU18gY4gJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983521"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:25 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344372"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 049/104] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
Date:   Fri,  4 Mar 2022 11:49:05 -0800
Message-Id: <8907eadab058300fa6ba7943036ad638b41ee0ef.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some KVM MMU operations (dirty page logging, page migration, aging page)
aren't supported for private GFNs (yet).  Silently return on unsupported
TDX KVM MMU operations.

For dirty logging, aging page, the GFN should be recorded with un-aliased
GFN.  Insert GFN un-aliasing where necessary.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 100 +++++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index acba2590b51e..1949f81027a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -257,11 +257,20 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 }
 
 static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
+					  bool private_spte,
 					  u64 old_spte, u64 new_spte, int level)
 {
 	bool pfn_changed;
 	struct kvm_memory_slot *slot;
 
+	/*
+	 * TDX doesn't support live migration.  Never mark private page as
+	 * dirty in log-dirty bitmap, since it's not possible for userspace
+	 * hypervisor to live migrate private page anyway.
+	 */
+	if (private_spte)
+		return;
+
 	if (level > PG_LEVEL_4K)
 		return;
 
@@ -269,6 +278,8 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
+		/* For memory slot operations, use GFN without aliasing */
+		gfn = kvm_gfn_unalias(kvm, gfn);
 		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
@@ -547,7 +558,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	__handle_changed_spte(kvm, as_id, gfn, private_spte,
 			old_spte, new_spte, level, shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
-	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+	handle_changed_spte_dirty_log(kvm, as_id, gfn, private_spte, old_spte,
 				      new_spte, level);
 }
 
@@ -678,6 +689,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 					      iter->level);
 	if (record_dirty_log)
 		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
+					      is_private_spte(iter->sptep),
 					      iter->old_spte, new_spte,
 					      iter->level);
 }
@@ -1215,7 +1227,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		gfn_t start;
+		gfn_t end;
+
+		if (is_private_sp(root)) {
+			start = kvm_gfn_private(kvm, range->start);
+			end = kvm_gfn_private(kvm, range->end);
+		} else {
+			start = kvm_gfn_shared(kvm, range->start);
+			end = kvm_gfn_shared(kvm, range->end);
+		}
+
+		tdp_root_for_each_leaf_pte(iter, root, start, end)
 			ret |= handler(kvm, &iter, range);
 	}
 
@@ -1237,6 +1265,15 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 	if (!is_accessed_spte(iter->old_spte))
 		return false;
 
+	/*
+	 * First TDX generation doesn't support clearing A bit for private
+	 * mapping, since there's no secure EPT API to support it.  However
+	 * it's a legitimate request for TDX guest, so just return w/o a
+	 * WARN().
+	 */
+	if (is_private_spte(iter->sptep))
+		return false;
+
 	new_spte = iter->old_spte;
 
 	if (spte_ad_enabled(new_spte)) {
@@ -1281,6 +1318,13 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	/* Huge pages aren't expected to be modified without first being zapped. */
 	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
 
+	/*
+	 * .change_pte() callback should not happen for private page, because
+	 * for now TDX private pages are pinned during VM's life time.
+	 */
+	if (WARN_ON(is_private_spte(iter->sptep)))
+		return false;
+
 	if (iter->level != PG_LEVEL_4K ||
 	    !is_shadow_present_pte(iter->old_spte))
 		return false;
@@ -1332,6 +1376,16 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	/*
+	 * First TDX generation doesn't support write protecting private
+	 * mappings, since there's no secure EPT API to support it.  It
+	 * is a bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return spte_set;
+	start = kvm_gfn_shared(kvm, start);
+	end = kvm_gfn_shared(kvm, end);
+
 	rcu_read_lock();
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
@@ -1398,6 +1452,16 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  It is a
+	 * bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return spte_set;
+	start = kvm_gfn_shared(kvm, start);
+	end = kvm_gfn_shared(kvm, end);
+
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
@@ -1467,6 +1531,15 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 	struct tdp_iter iter;
 	u64 new_spte;
 
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  It is a
+	 * bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return;
+	gfn = kvm_gfn_shared(kvm, gfn);
+
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
@@ -1530,6 +1603,16 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	struct tdp_iter iter;
 	kvm_pfn_t pfn;
 
+	/*
+	 * This should only be reachable in case of log-dirty, which TD
+	 * private mapping doesn't support so far.  Give a WARN() if it
+	 * hits private mapping.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return;
+	start = kvm_gfn_shared(kvm, start);
+	end = kvm_gfn_shared(kvm, end);
+
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
@@ -1543,8 +1626,9 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		pfn = spte_to_pfn(iter.old_spte);
 		if (kvm_is_reserved_pfn(pfn) ||
-		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
-							    pfn, PG_LEVEL_NUM))
+		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot,
+			    tdp_iter_gfn_unalias(kvm, &iter), pfn,
+			    PG_LEVEL_NUM))
 			continue;
 
 		/* Note, a successful atomic zap also does a remote TLB flush. */
@@ -1590,6 +1674,14 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
+	/*
+	 * First TDX generation doesn't support write protecting private
+	 * mappings, since there's no secure EPT API to support it.  It
+	 * is a bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return spte_set;
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-- 
2.25.1

