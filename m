Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A387762638
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjGYWUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbjGYWT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:19:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FFA449A;
        Tue, 25 Jul 2023 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323395; x=1721859395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dgcv4d08IZHY00QcJwZ7RSp4KjvPFjj7y6USyEPdrVI=;
  b=eKgdxHWSOKeZStDheKHZgQsat5N3bW6fxEVYXFnMD3HqbpeaQLZJTrw0
   qM/JxE8Ibs8VoJKtwRaJslRLo+EQRIrAq7hGgPuuNHItV2m/Cn8q84Of2
   s2CFYPDPUPEzHi7rVOpmwCksxKq7ZBJzOi4bYE3yvkh4dtEVI9tpv1X8I
   SCZ5HNaLtfk7p7PA+KKXmxUSuvRLuvqMhl2IusKRnrVWdSKLs4FGCkBXJ
   UMtnOgJj/ijyrqoBxfF3rFvsZczUk4wu2do0jXslczT4kcyCsNXww2FWr
   DoxN52Y4+yxiLsSzOrxPpAhFTWZ6IQpf6sRsREsOqu+e5Y1A98bWBVMoD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863269"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863269"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938930"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938930"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:37 -0700
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
Subject: [PATCH v15 044/115] KVM: x86/tdp_mmu: Don't zap private pages for unsupported cases
Date:   Tue, 25 Jul 2023 15:13:55 -0700
Message-Id: <835d544fc82d1776c9c623cb6c52336d46955cb8.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index f30d62362667..513083a14552 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6311,7 +6311,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
 	if (tdp_mmu_enabled)
-		kvm_tdp_mmu_invalidate_all_roots(kvm);
+		kvm_tdp_mmu_invalidate_all_roots(kvm, true);
 
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
@@ -6344,11 +6344,57 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
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
@@ -6456,8 +6502,18 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
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
index 8ca547987238..643c7c65456c 100644
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

