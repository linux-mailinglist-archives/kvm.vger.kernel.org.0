Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8AE58BDA5
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbiHGWJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241871AbiHGWHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE392BC1E;
        Sun,  7 Aug 2022 15:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909798; x=1691445798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qYyHwcTBR4q5WsEdgocOzyn9rT/KpftF0vuTsNx8Dvo=;
  b=TT30TBXMMTXZTdrZ8CVhumxF0M8/8IEkvH/0rOaHWNqb5nt6vLcdMWDd
   oy3ARvVVKzCsZX8BvVOHaZsHavzcEiPonj/F09wtf2vIgj5qfL6+Y0+bU
   vPiy1r+pk1tAqcWoC/DX598Ayy5afw22g5Mx1NKtpYLcRKxu+Ypl0/O5l
   zZOko48BU7LEsw29rRE1C4ujBq7/ApSKjicckMFa1J8X3oa6V02+59NLa
   a4ca9GzRLBrxEtXnSLLVkDu0MbhmgHDJ3Q75+eCgVsVTrdu47yIrT45FD
   UD7ova99aXjOb2ESoWX+hnnyc4gOLXRbmKck8Zjra+j5JDdskpmCP8qn2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224142"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224142"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682595"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 047/103] KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
Date:   Sun,  7 Aug 2022 15:01:32 -0700
Message-Id: <6e445e10fc341aa547695df81f52ff6f27a95ace.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/mmu/mmu.c     |  3 ++
 arch/x86/kvm/mmu/tdp_mmu.c | 73 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c         |  3 ++
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index af5746bcf767..d4cf185ba8c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6566,6 +6566,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 		pfn = spte_to_pfn(*sptep);
 
+		/* Private page dirty logging is not supported yet. */
+		KVM_BUG_ON(is_private_sptep(sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 59fe111e742a..9bf977b925f0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1398,7 +1398,8 @@ typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
 
 static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 						   struct kvm_gfn_range *range,
-						   tdp_handler_t handler)
+						   tdp_handler_t handler,
+						   bool only_shared)
 {
 	struct kvm_mmu_page *root;
 	struct tdp_iter iter;
@@ -1409,9 +1410,23 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
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
@@ -1455,7 +1470,12 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 
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
@@ -1466,7 +1486,8 @@ static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
+	/* The first TDX generation doesn't support A bit. */
+	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn, true);
 }
 
 static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
@@ -1511,8 +1532,11 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
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
@@ -1566,6 +1590,14 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 
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
@@ -1832,6 +1864,14 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 
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
@@ -1898,6 +1938,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
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
@@ -1964,6 +2011,13 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
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
@@ -2017,6 +2071,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
index 972262ddda5d..577f426ceb14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12434,6 +12434,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
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

