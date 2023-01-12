Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA13667B88
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbjALQn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240217AbjALQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D301C418;
        Thu, 12 Jan 2023 08:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541244; x=1705077244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S9SyEWSJ4ZkEAtNXQ/HVVGZdwK+hB36nEqe56IT6PPI=;
  b=Mu5B1ot5+SRmDVXECh/5wBMDhq7azyNkmZV+/Hy0N9EQJi3V6PSuoFxM
   E76Wf9xzvaBCOpTokmOJkDAkFfXZ5wiUDhuFiwBO4FGVw4HvS/YIsmY+f
   WOZym2ROidMaCO6hFGITGMXILPfwzoWUewsayBInCLtcCYwjtdMbF0EU5
   SecfZXxravv4EgnL6YjYdiZEKYHvyo1L+R4FPnf8odkQBGraAznF38BqY
   ZtbgLXGkCVkOPkioi0aLl7js3/+XfZmLdX/2yliGJB1S4Vi7wN1EMjwRK
   +/jEvWQGbFhfzXH7B3uxAFd7cJQSRA6ayA2YYqd3NCa2wqW94GAUd1/Yp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811894"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811894"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151808"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151808"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 050/113] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
Date:   Thu, 12 Jan 2023 08:31:58 -0800
Message-Id: <7a0fb2a0dddc87fb8d34d5af8fc73b288dbcc63c.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c     |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c         |  3 +++
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 484e615196aa..ad0482a101a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6635,6 +6635,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		sp = sptep_to_sp(sptep);
 
+		/* Private page dirty logging is not supported yet. */
+		KVM_BUG_ON(is_private_sptep(sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5ce0328c71df..69e202bd1897 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1478,7 +1478,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
 
 static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
+						   tdp_handler_t handler,
+						   bool only_shared)
 {
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
@@ -1489,9 +1490,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
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
@@ -1535,7 +1550,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
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
@@ -1546,7 +1566,8 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	/* The first TDX generation doesn't support A bit. */
+	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, true);
 }
 
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1591,8 +1612,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
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
@@ -1974,6 +1998,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
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
@@ -2093,6 +2124,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
index 5b4d5f8128a5..c4579e696d39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12526,6 +12526,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
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

