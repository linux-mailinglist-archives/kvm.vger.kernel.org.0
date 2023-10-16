Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAF57CAEBC
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjJPQQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjJPQQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:16:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DCCEE;
        Mon, 16 Oct 2023 09:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473003; x=1729009003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HCMpUPX9OCfJodRrsqwU0MyqIGPNhZJjeS07xlq3hqQ=;
  b=Tg5ZfUVFgeqY0pJCUBa3OhmZs8L5rPMiRld9L9m2qgekW3T6RdJcr5WD
   wbvki6zm/3xHmzIaR+GXZqK0hwn5xKnrze46rgl/oonmyQ+uvXHA2XNPn
   Sn/FNPjgUcGpayxYLqRRgQVBUswXi0foB2OCM/klsG/HZBoJdsAA7zVJt
   4ugHPJd9JJxIfevGEl57acFp5Gpnrc+VbC3fkOuCzOFUr2q7Y18K4qzK9
   jPywqEvC3BCterWfEZo8CZOCvp3TXxK6LVR11y5uro8ndHFFJD2NCkEKt
   ENhSa9oW32q42ptR/Nxkl70B/QbhjHaEum+/iRi57QrujT8xqBHVSWNXq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921749"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921749"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448107"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448107"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:41 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v16 044/116] KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
Date:   Mon, 16 Oct 2023 09:13:56 -0700
Message-Id: <00736b99035f4a84e5bc94ee414c97610fc963ab.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 arch/x86/kvm/mmu/mmu.c     | 62 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h |  5 +--
 3 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6636be590583..4b58205b2d82 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6256,7 +6256,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
 	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+		kvm_tdp_mmu_invalidate_all_roots(kvm, true);
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
@@ -6385,8 +6385,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
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
@@ -6833,10 +6843,56 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_mmu_zap_all(kvm);
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
+
+		      /*
+		       * This handles both private gfn and shared gfn.
+		       * All private page should be zapped on memslot deletion.
+		       */
+		      .only_private = true,
+		      .only_shared = true,
+		};
+
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
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
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
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
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 583888bbb87d..d76c1ad44638 100644
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
@@ -831,7 +831,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * operation can cause a soft lockup.
  */
 static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+			      gfn_t start, gfn_t end, bool can_yield, bool flush,
+			      bool zap_private)
 {
 	struct tdp_iter iter;
 
@@ -839,6 +840,10 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	WARN_ON_ONCE(zap_private && !is_private_sp(root));
+	if (!zap_private && is_private_sp(root))
+		return false;
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -871,12 +876,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -924,7 +930,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
  * Note, the asynchronous worker is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_get_vcpu_root_hpa().
  */
-void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm, bool skip_private)
 {
 	struct kvm_mmu_page *root;
 
@@ -952,6 +958,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
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
@@ -1136,11 +1148,24 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
+	bool zap_private = false;
+
+	if (kvm_gfn_shared_mask(kvm)) {
+		if (!range->only_private && !range->only_shared)
+			/* attributes change */
+			zap_private = !(range->arg.attributes &
+					KVM_MEMORY_ATTRIBUTE_PRIVATE);
+		else
+			zap_private = range->only_private;
+	}
+
 	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+				     range->end, range->may_block, flush,
+				     zap_private);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..3df604352648 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -21,10 +21,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
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
-- 
2.25.1

