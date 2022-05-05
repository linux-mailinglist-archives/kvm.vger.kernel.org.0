Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526FB51C76F
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiEESWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383245AbiEESTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DBF15837;
        Thu,  5 May 2022 11:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774562; x=1683310562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ahkXmwLQ9uVoNjJiiXbRcJvEeFXcAtRP+bydslkMsvQ=;
  b=oGdf90iWZ2Qn8A0RY1sPI2YQwEFLuNdaL3MHUZkfZSQXWE6/GfMxKr+P
   uleAex/ZiPHOCiMzNGXRIiEQ/Rps7tAwCYKYZDupi8aopvbJcAFjCOwIl
   L3dFzwuEC2aTopYm199Na5PjalKLiMefArHsoqPs7hbEYNKg7T59t/zT3
   viV2xt9LXkc2m7SmN8xxgsH/Qi3aaph4nWWBGMEjnlCHGVJ1jjOlH1Mxj
   umQcRfzo1LaHdu3q3H6buVHYwJcoksbRO47y98HlT49UqDQwHEtK7F8OF
   4fFrybUXMVlpfB+y89G71UFJeImZkP8fg1Qs6n8dB36+4um9LVBUri5mb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742039"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742039"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:47 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083317"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 050/104] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
Date:   Thu,  5 May 2022 11:14:44 -0700
Message-Id: <9be9dc86983ab1ffdc679c1ab5de025d1487dc40.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
aren't supported for private GFNs (yet) with the first generation of TDX.
Silently return on unsupported TDX KVM MMU operations.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 74 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  3 ++
 3 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index affbfe895dab..1c4884220660 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
+#include "mmu.h"
 
 #include "mmu.h"
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ae2ee7cc948a..2aa2cb8a9b05 100644
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
@@ -1377,7 +1379,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
 
 static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
+						   tdp_handler_t handler,
+						   bool only_shared)
 {
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
@@ -1388,9 +1391,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
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
@@ -1434,7 +1451,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
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
@@ -1445,7 +1467,7 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, false);
 }
 
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1490,8 +1512,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
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
@@ -1545,6 +1570,14 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 
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
@@ -1809,6 +1842,14 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 
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
@@ -1875,6 +1916,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
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
@@ -1928,6 +1976,13 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
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
@@ -1981,6 +2036,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
index 8e6d54faa7ba..77a9403bdd02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12181,6 +12181,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
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

