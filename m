Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3E7142E3
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjE2EZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjE2EZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FF11BD9;
        Sun, 28 May 2023 21:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334180; x=1716870180;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L//Kn7APpYFCMmcvImTyReVnT1uCMdny9QItxo5ej/Q=;
  b=l5GSMydPXjV3lW98bu1f2j4HVTc7EorZ1tFdrwgBOfNYcwtudBkCV48x
   3p5uBHDd5+FdM8KjYJTBfmIDTfrLXzU2uh9QREGufcrD71DSrQccYT5PD
   KMh9BjBHqNDGD297nGCP/EROGdZlNSpUnNSkTPZyISzlYZdK/0a7T5UEY
   N9DRmBgXBv88TpoYupiToQbMVmjC/ufJlzGifVbloLu9L5sBppMoSRip2
   8mj0GLCxib0HXz7tDcmL/fUV/jnT6sF+FdRayW/eQC99Nu33XyiUNhbC3
   kIy+GoXMdvuvhV4QuNG8KtNdh31KFXVFJjcSOwtUGRXOh16Y93n3csQmV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334965977"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334965977"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784305"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784305"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 044/113] KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
Date:   Sun, 28 May 2023 21:19:26 -0700
Message-Id: <3180edac74ddc33bf1aa380a1350eb229c36b020.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c     | 83 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |  7 ++--
 3 files changed, 103 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7caf915a5623..b588424e8e32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1615,8 +1615,28 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
-	if (tdp_mmu_enabled)
-		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
+	if (tdp_mmu_enabled) {
+		bool zap_private;
+
+		if (range->flags & KVM_GFN_RANGE_FLAGS_GMEM) {
+			WARN_ON_ONCE(!kvm_slot_can_be_private(range->slot));
+			/*
+			 * For private slot, the callback is triggered
+			 * via PUNCH_HOLE (fallocate(PUNCH_HOLE) or truncate).
+			 * private-shared conversion is done by
+			 * KVM_SET_MEMORY_ATTRIBUTES.
+			 */
+			zap_private = true;
+		} else if (range->flags & KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR)
+			zap_private = !(range->attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE);
+		else
+			/*
+			 * For now private pages are pinned during VM's life
+			 * time.
+			 */
+			zap_private = false;
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, zap_private);
+	}
 
 	return flush;
 }
@@ -6258,7 +6278,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
 	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+		kvm_tdp_mmu_invalidate_all_roots(kvm, true);
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
@@ -6291,11 +6311,54 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
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
+	if (tdp_mmu_enabled) {
+		struct kvm_gfn_range range = {
+		      .slot = slot,
+		      .start = slot->base_gfn,
+		      .end = slot->base_gfn + slot->npages,
+		      .may_block = true,
+		};
+
+		/*
+		 * this handles both private gfn and shared gfn.
+		 * All private page should be zapped on memslot deletion.
+		 */
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush, true);
+	} else {
+		/* TDX supports only TDP-MMU case. */
+		WARN_ON_ONCE(1);
+		flush = true;
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
+		/*
+		 * Secure-EPT requires to release PTs from the leaf.  The
+		 * optimization to zap root PT first with child PT doesn't
+		 * work.
+		 */
+		kvm_mmu_zap_memslot(kvm, slot);
+	else
+		kvm_mmu_zap_all_fast(kvm);
 }
 
 int kvm_mmu_init_vm(struct kvm *kvm)
@@ -6403,8 +6466,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (tdp_mmu_enabled) {
 		for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++)
+			/*
+			 * zap_private = true. Zap both private/shared pages.
+			 *
+			 * kvm_zap_gfn_range() is used when MTRR or PAT memory
+			 * type was changed.  Later on the next kvm page fault,
+			 * populate it with updated spte entry.
+			 * Because only WB is supported for private pages, don't
+			 * care of private pages.
+			 */
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+						      gfn_end, true, flush,
+						      false);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cfe8a24b62f8..fb3e47293ffa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -45,7 +45,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
 	 * ultimately frees all roots.
 	 */
-	kvm_tdp_mmu_invalidate_all_roots(kvm);
+	kvm_tdp_mmu_invalidate_all_roots(kvm, false);
 
 	/*
 	 * Destroying a workqueue also first flushes the workqueue, i.e. no
@@ -828,7 +828,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * operation can cause a soft lockup.
  */
 static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+			      gfn_t start, gfn_t end, bool can_yield, bool flush,
+			      bool zap_private)
 {
 	struct tdp_iter iter;
 
@@ -836,6 +837,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	WARN_ON_ONCE(zap_private && !is_private_sp(root));
+	if (!zap_private && is_private_sp(root))
+		return false;
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -868,12 +873,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -921,7 +927,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, the asynchronous worker is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_get_vcpu_root_hpa().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
 {
 	struct kvm_mmu_page *root;
 
@@ -949,6 +955,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		/*
+		 * Skip private root since private page table
+		 * is only torn down when VM is destroyed.
+		 */
+		if (skip_private && is_private_sp(root))
+			continue;
 		if (!root->role.invalid) {
 			root->role.invalid = true;
 			tdp_mmu_schedule_zap_root(kvm, root);
@@ -1133,11 +1145,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
index 0a63b1afabd3..c98be3b7af19 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -21,16 +21,17 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+			   gfn_t end, bool can_yield, bool flush,
+			   bool zap_private);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
-				 bool flush);
+				 bool flush, bool zap_private);
 bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-- 
2.25.1

