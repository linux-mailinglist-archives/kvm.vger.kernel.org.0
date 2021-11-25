Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E130745D1D9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhKYA0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:16279 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353142AbhKYAYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432280"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432280"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:29 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042422"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:29 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 57/59] KVM, x86/mmu: Support TDX private mapping for TDP MMU
Date:   Wed, 24 Nov 2021 16:20:40 -0800
Message-Id: <33b07a16fb55fbd68c411bdfdc4889880464ad5e.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@intel.com>

Frame in TDX private mapping support to support running TD with TDP MMU.

Similar to legacy MMU, use private mapping related kvm_x86_ops hooks in
__handle_changed_spte()/handle_removed_tdp_mmu_page() to support
creating/removing private mapping.  And support temporarily blocking
private mapping upon receiving MMU notifier and later on unblocking it
upon EPT violation, rather than completely removing the private page,
because currently page migration for private page is not supported,
therefore the page cannot be really removed from TD upon MMU notifier.

Similar to legacy MMU, zap aliasing mapping (truly remove the page)
upon EPT violation.  And only leaf page is zapped, but not intermediate
page tables.

Support 4K page only at this stage.  2M page support can be done in
future patches.

A key change to TDP MMU to support TD guest is, the read_lock() is
changed to write_lock() for page fault on private GPA in
direct_page_fault(), while for fault on shared GPA, read_lock() is
still used.  This is because for TD guest, at given time for given GFN,
only one type of mapping (either private, or shared) can be valid, but
not both, otherwise it may cause machine check and data lose.  As a
result, aliasing mapping is zapped in TDP MMU fault handler.  In this
case, running multiple fault threads with both private and shared
address concurrently may end up with having both private and shared
mapping for given GPN.  Consider below case: vcpu 0 is accessing using
private GPA, and vcpu 1 is accessing the shared GPA (i.e. right after
MAP_GPA).

	vcpu 0 				vcpu 1

  (fault with private GPA)	(fault with shared GPA)
	zap shared mapping
				zap private mapping
				setup shared mapping
	setup private mapping

This may end up with having both private and shared mappings.  Perhaps
it is arguable whether above case is valid, but for security, just don't
allow running multiple fault threads concurrently.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c      |  63 ++++-
 arch/x86/kvm/mmu/spte.h     |  20 +-
 arch/x86/kvm/mmu/tdp_iter.h |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c  | 544 ++++++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h  |  15 +-
 5 files changed, 567 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f8109002da0d..1e13949ac62a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3692,7 +3692,11 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		if (gfn_shared && !VALID_PAGE(mmu->private_root_hpa)) {
+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
+			mmu->private_root_hpa = root;
+		}
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
 		mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		if (gfn_shared && !VALID_PAGE(vcpu->arch.mmu->private_root_hpa)) {
@@ -4348,7 +4352,33 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	r = RET_PF_RETRY;
 
-	if (is_tdp_mmu_fault)
+	/*
+	 * Unfortunately, when running TD, TDP MMU cannot always run multiple
+	 * fault threads concurrently.  TDX has two page tables supporting
+	 * private and shared mapping simultaneously, but at given time, only
+	 * one mapping can be valid for given GFN, otherwise it may cause
+	 * machine check and data lose.  Therefore, TDP MMU fault handler zaps
+	 * aliasing mapping.
+	 *
+	 * Running fault threads for both private and shared GPA concurrently
+	 * can potentially end up with having both private and shared mapping
+	 * for one GPA.  For instance, vcpu 0 is accessing using private GPA,
+	 * and vcpu 1 is accessing using shared GPA (i.e. right after MAP_GPA):
+	 *
+	 *		vcpu 0				vcpu 1
+	 *	(fault with private GPA)	(fault with shared GPA)
+	 *
+	 *	zap shared mapping
+	 *					zap priavte mapping
+	 *					setup shared mapping
+	 *	setup private mapping
+	 *
+	 * This can be prevented by only allowing one type of fault (private
+	 * or shared) to run concurrently.  Choose to let private fault to run
+	 * concurrently, because for TD, most pages should be private.
+	 */
+	if (is_tdp_mmu_fault && kvm_is_private_gfn(vcpu->kvm,
+				fault->addr >> PAGE_SHIFT))
 		read_lock(&vcpu->kvm->mmu_lock);
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -4365,7 +4395,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		r = __direct_map(vcpu, fault);
 
 out_unlock:
-	if (is_tdp_mmu_fault)
+	if (is_tdp_mmu_fault && kvm_is_private_gfn(vcpu->kvm,
+				fault->addr >> PAGE_SHIFT))
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
@@ -6057,6 +6088,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	write_unlock(&kvm->mmu_lock);
 
+	/*
+	 * For now private root is never invalidate during VM is running,
+	 * so this can only happen for shared roots.
+	 */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
@@ -6162,7 +6197,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
+							  gfn_end, flush,
+							  false);
 	}
 
 	if (flush)
@@ -6195,6 +6231,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
+	/*
+	 * For now this can only happen for non-TD VM, because TD private
+	 * mapping doesn't support write protection.  kvm_tdp_mmu_wrprot_slot()
+	 * will give a WARN() if it hits for TD.
+	 */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
@@ -6277,6 +6318,11 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
+	/*
+	 * This should only be reachable in case of log-dirty, wihch TD private
+	 * mapping doesn't support so far.  kvm_tdp_mmu_zap_collapsible_sptes()
+	 * internally gives a WARN() when it hits.
+	 */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
@@ -6316,6 +6362,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
+	/* See comments in kvm_mmu_slot_remove_write_access() */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
@@ -6350,8 +6397,12 @@ static void __kvm_mmu_zap_all(struct kvm *kvm, struct list_head *mmu_pages)
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
+	if (is_tdp_mmu_enabled(kvm)) {
+		bool zap_private =
+			(mmu_pages == &kvm->arch.private_mmu_pages) ?
+			true : false;
+		kvm_tdp_mmu_zap_all(kvm, zap_private);
+	}
 
 	write_unlock(&kvm->mmu_lock);
 }
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 43f0d2a773f7..3108d46e0dd3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -173,7 +173,9 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * If a thread running without exclusive control of the MMU lock must perform a
  * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
  * non-present intermediate value. Other threads which encounter this value
- * should not modify the SPTE.
+ * should not modify the SPTE.  When TDX is enabled, shadow_init_value, which
+ * is "suppress #VE" bit set, is also set to removed SPTE, because TDX module
+ * always enables "EPT violation #VE".
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
@@ -183,12 +185,24 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define REMOVED_SPTE	0x5a0ULL
 
-/* Removed SPTEs must not be misconstrued as shadow present PTEs. */
+/*
+ * Removed SPTEs must not be misconstrued as shadow present PTEs, and
+ * temporarily blocked private PTEs.
+ */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(REMOVED_SPTE & SPTE_PRIVATE_ZAPPED));
+
+/*
+ * See above comment around REMOVED_SPTE.  SHADOW_REMOVED_SPTE is the actual
+ * intermediate value set to the removed SPET.  When TDX is enabled, it sets
+ * the "suppress #VE" bit, otherwise it's REMOVED_SPTE.
+ */
+extern u64 __read_mostly shadow_init_value;
+#define SHADOW_REMOVED_SPTE	(shadow_init_value | REMOVED_SPTE)
 
 static inline bool is_removed_spte(u64 spte)
 {
-	return spte == REMOVED_SPTE;
+	return spte == SHADOW_REMOVED_SPTE;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1748b988d3a..52089728d583 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -28,7 +28,7 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (stolen bits included) mapped by the current SPTE */
 	gfn_t gfn;
 	/* The level of the root page given to the iterator */
 	int root_level;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a54c3491af42..69c71e696510 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -53,6 +53,11 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
+static gfn_t tdp_iter_gfn_unalias(struct kvm *kvm, struct tdp_iter *iter)
+{
+	return iter->gfn & ~kvm_gfn_stolen_mask(kvm);
+}
+
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared);
@@ -158,7 +163,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		} else
 
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
-						   int level)
+						   int level, bool private)
 {
 	union kvm_mmu_page_role role;
 
@@ -168,12 +173,13 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 	role.gpte_is_8_bytes = true;
 	role.access = ACC_ALL;
 	role.ad_disabled = !shadow_accessed_mask;
+	role.private = private;
 
 	return role;
 }
 
 static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					       int level)
+					       int level, bool private)
 {
 	struct kvm_mmu_page *sp;
 
@@ -181,7 +187,18 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role.word = page_role_for_level(vcpu, level).word;
+	/*
+	 * Unlike kvm_mmu_link_private_sp(), which is used by legacy MMU,
+	 * allocate private_sp here since __handle_changed_spte() takes
+	 * 'kvm' as parameter rather than 'vcpu'.
+	 */
+	if (private) {
+		sp->private_sp =
+			kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_sp_cache);
+		WARN_ON_ONCE(!sp->private_sp);
+	}
+
+	sp->role.word = page_role_for_level(vcpu, level, private).word;
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
@@ -190,7 +207,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return sp;
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
+						      bool private)
 {
 	union kvm_mmu_page_role role;
 	struct kvm *kvm = vcpu->kvm;
@@ -198,7 +216,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
+	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level,
+			private);
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
@@ -207,7 +226,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level,
+			private);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -215,12 +235,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 out:
-	return __pa(root->spt);
+	return root;
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
+{
+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				tdp_ptep_t sptep, u64 old_spte,
+				u64 new_spte, int level, bool shared);
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
@@ -239,6 +264,14 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool pfn_changed;
 	struct kvm_memory_slot *slot;
 
+	/*
+	 * TDX doesn't support live migration.  Never mark private page as
+	 * dirty in log-dirty bitmap, since it's not possible for userspace
+	 * hypervisor to live migrate private page anyway.
+	 */
+	if (kvm_is_private_gfn(kvm, gfn))
+		return;
+
 	if (level > PG_LEVEL_4K)
 		return;
 
@@ -246,7 +279,9 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
-		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
+		/* For memory slot operations, use GFN without aliasing */
+		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id),
+				gfn & ~kvm_gfn_stolen_mask(kvm));
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
 }
@@ -298,6 +333,7 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * handle_removed_tdp_mmu_page - handle a pt removed from the TDP structure
  *
  * @kvm: kvm instance
+ * @parent_sptep: pointer to the parent SPTE which points to the @pt.
  * @pt: the page removed from the paging structure
  * @shared: This operation may not be running under the exclusive use
  *	    of the MMU lock and the operation must synchronize with other
@@ -311,9 +347,11 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * this thread will be responsible for ensuring the page is freed. Hence the
  * early rcu_dereferences in the function.
  */
-static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
-					bool shared)
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t parent_sptep,
+					tdp_ptep_t pt, bool shared)
 {
+	struct kvm_mmu_page *parent_sp =
+		sptep_to_sp(rcu_dereference(parent_sptep));
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
 	gfn_t base_gfn = sp->gfn;
@@ -322,6 +360,8 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 	gfn_t gfn;
 	int i;
 
+	WARN_ON(!is_private_sp(parent_sp) != !is_private_sp(sp));
+
 	trace_kvm_mmu_prepare_zap_page(sp);
 
 	tdp_mmu_unlink_page(kvm, sp, shared);
@@ -340,7 +380,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			 * value to the removed SPTE value.
 			 */
 			for (;;) {
-				old_child_spte = xchg(sptep, REMOVED_SPTE);
+				old_child_spte = xchg(sptep, SHADOW_REMOVED_SPTE);
 				if (!is_removed_spte(old_child_spte))
 					break;
 				cpu_relax();
@@ -356,7 +396,8 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			 * unreachable.
 			 */
 			old_child_spte = READ_ONCE(*sptep);
-			if (!is_shadow_present_pte(old_child_spte))
+			if (!is_shadow_present_pte(old_child_spte) &&
+					!is_zapped_private_pte(old_child_spte))
 				continue;
 
 			/*
@@ -367,13 +408,35 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			 * the two branches consistent and simplifies
 			 * the function.
 			 */
-			WRITE_ONCE(*sptep, REMOVED_SPTE);
+			WRITE_ONCE(*sptep, SHADOW_REMOVED_SPTE);
 		}
-		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_child_spte, REMOVED_SPTE, level,
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn, sptep,
+				    old_child_spte, SHADOW_REMOVED_SPTE, level,
 				    shared);
 	}
 
+	if (sp->private_sp) {
+
+		/*
+		 * Currently prviate page table (not the leaf page) can only be
+		 * zapped when VM is being destroyed, because currently
+		 * kvm_x86_ops->free_private_sp() can only be called after TD
+		 * has been torn down (after tdx_vm_teardown()).  To make sure
+		 * this code path can only be reached when the whole page table
+		 * is being torn down when TD is being destroyed, zapping
+		 * aliasing only zaps the leaf pages, but not the intermediate
+		 * page tables.
+		 */
+		WARN_ON(!is_private_sp(sp));
+		/*
+		 * The level used in kvm_x86_ops->free_private_sp() doesn't
+		 * matter since PG_LEVEL_4K is always used internally.
+		 */
+		if (!static_call(kvm_x86_free_private_sp)(kvm, sp->gfn,
+				sp->role.level + 1, sp->private_sp))
+			free_page((unsigned long)sp->private_sp);
+	}
+
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
 					   KVM_PAGES_PER_HPAGE(level + 1));
 
@@ -384,6 +447,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
  * __handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
+ * @sptep: the pointer to the SEPT being modified
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
@@ -396,19 +460,23 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+				  tdp_ptep_t sptep, u64 old_spte,
+				  u64 new_spte, int level, bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_zapped_private = is_zapped_private_pte(old_spte);
+	bool is_private = is_private_spte(sptep);
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
 	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
 
+	WARN_ON(was_zapped_private && !is_private);
+
 	/*
 	 * If this warning were to trigger it would indicate that there was a
 	 * missing MMU notifier or a race with some notifier handler.
@@ -437,6 +505,29 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
+	/*
+	 * Handle special case of old_spte being temporarily blocked private
+	 * SPTE.  There are two cases: 1) Need to restore the original mapping
+	 * (unblock) when guest accesses the private page; 2) Need to truly
+	 * zap the SPTE because of zapping aliasing in fault handler, or when
+	 * VM is being destroyed.
+	 *
+	 * Do this before handling "!was_present && !is_present" case below,
+	 * because blocked private SPTE is also non-present.
+	 */
+	if (was_zapped_private) {
+		if (is_present)
+			static_call(kvm_x86_unzap_private_spte)(kvm, gfn,
+					level);
+		else
+			static_call(kvm_x86_drop_private_spte)(kvm, gfn,
+					level, spte_to_pfn(old_spte));
+
+		/* Temporarily blocked private SPTE can only be leaf. */
+		WARN_ON(!is_last_spte(old_spte, level));
+		return;
+	}
+
 	/*
 	 * The only times a SPTE should be changed from a non-present to
 	 * non-present state is when an MMIO entry is installed/modified/
@@ -469,20 +560,64 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
 
+	/*
+	 * Special handling for the private mapping.  We are either
+	 * setting up new mapping at middle level page table, or leaf,
+	 * or tearing down existing mapping.
+	 */
+	if (is_private) {
+		if (is_present) {
+			/*
+			 * Use different call to either set up middle level
+			 * private page table, or leaf.
+			 */
+			if (is_leaf)
+				static_call(kvm_x86_set_private_spte)(kvm, gfn,
+						level, spte_to_pfn(new_spte));
+			else {
+				kvm_pfn_t pfn = spte_to_pfn(new_spte);
+				struct page *page = pfn_to_page(pfn);
+				struct kvm_mmu_page *sp =
+					(struct kvm_mmu_page *)page_private(page);
+
+				WARN_ON(!sp->private_sp);
+				WARN_ON((sp->role.level + 1) != level);
+
+				static_call(kvm_x86_link_private_sp)(kvm, gfn,
+						level, sp->private_sp);
+			}
+		} else if (was_leaf) {
+			/*
+			 * Zap private leaf SPTE.  Zapping private table is done
+			 * below in handle_removed_tdp_mmu_page().
+			 */
+			static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
+			/*
+			 * TDX requires TLB tracking before dropping private
+			 * page.  Do it here, although it is also done later.
+			 */
+			kvm_flush_remote_tlbs_with_address(kvm, gfn,
+					KVM_PAGES_PER_HPAGE(level));
+
+			static_call(kvm_x86_drop_private_spte)(kvm, gfn, level,
+					spte_to_pfn(old_spte));
+		}
+	}
+
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
-		handle_removed_tdp_mmu_page(kvm,
+		handle_removed_tdp_mmu_page(kvm, sptep,
 				spte_to_child_pt(old_spte, level), shared);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				tdp_ptep_t sptep, u64 old_spte, u64 new_spte,
+				int level, bool shared)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
+	__handle_changed_spte(kvm, as_id, gfn, sptep, old_spte, new_spte, level,
 			      shared);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
@@ -521,8 +656,8 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->sptep,
+			      iter->old_spte, new_spte, iter->level, true);
 	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
 	return true;
@@ -537,7 +672,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, SHADOW_REMOVED_SPTE))
 		return false;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
@@ -550,8 +685,16 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * special removed SPTE value. No bookkeeping is needed
 	 * here since the SPTE is going from non-present
 	 * to non-present.
+	 *
+	 * Set non-present value to shadow_init_value, rather than 0.
+	 * It is because when TDX is enabled, TDX module always
+	 * enables "EPT-violation #VE", so KVM needs to set
+	 * "suppress #VE" bit in EPT table entries, in order to get
+	 * real EPT violation, rather than TDVMCALL.  KVM sets
+	 * shadow_init_value (which sets "suppress #VE" bit) so it
+	 * can be set when EPT table entries are zapped.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), shadow_init_value);
 
 	return true;
 }
@@ -590,8 +733,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->sptep,
+			      iter->old_spte, new_spte, iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
@@ -621,19 +764,55 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
+static inline bool tdp_mmu_zap_spte_flush_excl_or_shared(struct kvm *kvm,
+							 struct tdp_iter *iter,
+							 bool shared)
+{
+	if (!shared) {
+		/* See tdp_mmu_zap_spte_atomic() for shadow_init_value */
+		tdp_mmu_set_spte(kvm, iter, shadow_init_value);
+		kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
+				KVM_PAGES_PER_HPAGE(iter->level));
+		return true;
+	}
+
+	/* tdp_mmu_zap_spte_atomic() does TLB flush internally */
+	return tdp_mmu_zap_spte_atomic(kvm, iter);
+}
+
+static inline bool tdp_mmu_set_spte_excl_or_shared(struct kvm *kvm,
+						   struct tdp_iter *iter,
+						   u64 new_spte,
+						   bool shared)
+{
+	if (!shared) {
+		tdp_mmu_set_spte(kvm, iter, new_spte);
+		return true;
+	}
+
+	return tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
+}
+
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+/*
+ * Note temporarily blocked private SPTE is consider as valid leaf,
+ * although !is_shadow_present_pte() returns true for it, since the
+ * target page (which the mapping maps to ) is still there.
+ */
 #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
 	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
-		if (!is_shadow_present_pte(_iter.old_spte) ||		\
+		if ((!is_shadow_present_pte(_iter.old_spte) &&		\
+			!is_zapped_private_pte(_iter.old_spte)) ||	\
 		    !is_last_spte(_iter.old_spte, _iter.level))		\
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
-			 _mmu->shadow_root_level, _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
+	for_each_tdp_pte(_iter,						\
+		__va((_private) ? _mmu->private_root_hpa : _mmu->root_hpa),	\
+		 _mmu->shadow_root_level, _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -719,6 +898,15 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	 */
 	end = min(end, max_gfn_host);
 
+	/*
+	 * Extend [start, end) to include GFN shared bit when TDX is enabled,
+	 * and for shared mapping range.
+	 */
+	if (kvm->arch.gfn_shared_mask && !is_private_sp(root)) {
+		start |= kvm->arch.gfn_shared_mask;
+		end |= kvm->arch.gfn_shared_mask;
+	}
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -732,7 +920,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		/*
+		 * Skip non-present SPTE, with exception of temporarily
+		 * blocked private SPTE, which also needs to be zapped.
+		 */
+		if (!is_shadow_present_pte(iter.old_spte) &&
+				!is_zapped_private_pte(iter.old_spte))
 			continue;
 
 		/*
@@ -747,7 +940,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared) {
-			tdp_mmu_set_spte(kvm, &iter, 0);
+			/* see comments in tdp_mmu_zap_spte_atomic() */
+			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
 			flush = true;
 		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
@@ -770,24 +964,30 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * MMU lock.
  */
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush)
+				 gfn_t end, bool can_yield, bool flush,
+				 bool zap_private)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false) {
+		/* Skip private page table if not requested */
+		if (!zap_private && is_private_sp(root))
+			continue;
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
 				      false);
+	}
 
 	return flush;
 }
 
-void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+void kvm_tdp_mmu_zap_all(struct kvm *kvm, bool zap_private)
 {
 	bool flush = false;
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush,
+				zap_private);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
@@ -838,6 +1038,13 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 	while (root) {
 		next_root = next_invalidated_root(kvm, root);
 
+		/*
+		 * Private table is only torn down when VM is destroyed.
+		 * It is a bug to zap private table here.
+		 */
+		if (WARN_ON(is_private_sp(root)))
+			goto out;
+
 		rcu_read_unlock();
 
 		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
@@ -852,7 +1059,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_lock();
 	}
-
+out:
 	rcu_read_unlock();
 
 	if (flush)
@@ -884,9 +1091,16 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		/*
+		 * Skip private root since private page table
+		 * is only torn down when VM is destroyed.
+		 */
+		if (is_private_sp(root))
+			continue;
 		if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
 			root->role.invalid = true;
+	}
 }
 
 /*
@@ -895,24 +1109,36 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
  */
 static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 					  struct kvm_page_fault *fault,
-					  struct tdp_iter *iter)
+					  struct tdp_iter *iter,
+					  bool shared)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(iter->sptep));
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
+	unsigned long pte_access = ACC_ALL;
 
 	WARN_ON(sp->role.level != fault->goal_level);
+
+	/* TDX shared GPAs are no executable, enforce this for the SDV. */
+	if (vcpu->kvm->arch.gfn_shared_mask &&
+			!kvm_is_private_gfn(vcpu->kvm, iter->gfn))
+		pte_access &= ~ACC_EXEC_MASK;
+
 	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+		new_spte = make_mmio_spte(vcpu,
+				tdp_iter_gfn_unalias(vcpu->kvm, iter),
+				pte_access);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
+				tdp_iter_gfn_unalias(vcpu->kvm, iter),
+				fault->pfn, iter->old_spte, fault->prefetch,
+				true, fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+	else if (!tdp_mmu_set_spte_excl_or_shared(vcpu->kvm, iter,
+				new_spte, shared))
 		return RET_PF_RETRY;
 
 	/*
@@ -945,6 +1171,53 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void tdp_mmu_zap_alias_spte(struct kvm_vcpu *vcpu, gfn_t gfn_alias,
+		bool shared)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	bool is_private = kvm_is_private_gfn(vcpu->kvm, gfn_alias);
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, gfn_alias, gfn_alias + 1) {
+retry:
+		/*
+		 * Skip non-present SPTEs, except zapped (temporarily
+		 * blocked) private SPTE, because it needs to be truly
+		 * zapped too (note is_shadow_present_pte() also returns
+		 * false for zapped private SPTE).
+		 */
+		if (!is_shadow_present_pte(iter.old_spte) &&
+				!is_zapped_private_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * Only zap leaf for aliasing mapping, because there's
+		 * no need to zap page table too.  And currently
+		 * tdx_sept_free_private_sp() cannot be called when TD
+		 * is still running, so cannot really zap private page
+		 * table now.
+		 */
+		if (!is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		/*
+		 * Large page is not supported by TDP MMU for TDX now.
+		 * TODO: large page support.
+		 */
+		WARN_ON(iter.level != PG_LEVEL_4K);
+
+		if (!tdp_mmu_zap_spte_flush_excl_or_shared(vcpu->kvm, &iter,
+					shared)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
+	}
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -956,6 +1229,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
+	gfn_t raw_gfn;
+	bool is_private;
+	bool shared;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -964,7 +1240,26 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	raw_gfn = fault->addr >> PAGE_SHIFT;
+	is_private = kvm_is_private_gfn(vcpu->kvm, raw_gfn);
+
+	if (is_error_noslot_pfn(fault->pfn) ||
+			kvm_is_reserved_pfn(fault->pfn)) {
+		if (is_private) {
+			rcu_read_unlock();
+			return -EFAULT;
+		}
+	} else if (vcpu->kvm->arch.gfn_shared_mask) {
+		gfn_t gfn_alias = raw_gfn ^ vcpu->kvm->arch.gfn_shared_mask;
+		/*
+		 * At given time, for one GPA, only one mapping can be valid
+		 * (either private, or shared).  Zap aliasing mapping to make
+		 * sure of it.  Also see comment in direct_page_fault().
+		 */
+		tdp_mmu_zap_alias_spte(vcpu, gfn_alias, shared);
+	}
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
@@ -978,8 +1273,15 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    is_large_pte(iter.old_spte)) {
-			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
+			if (!tdp_mmu_zap_spte_flush_excl_or_shared(vcpu->kvm,
+						&iter, shared))
 				break;
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			WARN_ON(is_private_spte(&iter.old_spte));
+
 
 			/*
 			 * The iter must explicitly re-read the spte here
@@ -990,6 +1292,15 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+
+			/*
+			 * TODO: large page support.
+			 * Not expecting blocked private SPTE points to a
+			 * large page now.
+			 */
+			WARN_ON(is_zapped_private_pte(iter.old_spte) &&
+					is_large_pte(iter.old_spte));
+
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -998,13 +1309,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
+			sp = alloc_tdp_mmu_page(vcpu,
+					tdp_iter_gfn_unalias(vcpu->kvm, &iter),
+					iter.level - 1, is_private);
 			child_pt = sp->spt;
 
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
+			if (tdp_mmu_set_spte_excl_or_shared(vcpu->kvm, &iter,
+						new_spte, shared)) {
 				tdp_mmu_link_page(vcpu->kvm, sp,
 						  fault->huge_page_disallowed &&
 						  fault->req_level >= iter.level);
@@ -1022,20 +1336,27 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
+	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter, shared);
 	rcu_read_unlock();
 
 	return ret;
 }
 
+static bool block_private_gfn_range(struct kvm *kvm,
+				    struct kvm_gfn_range *range);
+
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
-		flush |= zap_gfn_range(kvm, root, range->start, range->end,
+	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		if (is_private_sp(root))
+			flush |= block_private_gfn_range(kvm, range);
+		else
+			flush |= zap_gfn_range(kvm, root, range->start, range->end,
 				       range->may_block, flush, false);
+	}
 
 	return flush;
 }
@@ -1058,6 +1379,15 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		if (kvm->arch.gfn_shared_mask && !is_private_sp(root)) {
+			range->start |= kvm->arch.gfn_shared_mask;
+			range->end |= kvm->arch.gfn_shared_mask;
+		}
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
 	}
@@ -1067,6 +1397,31 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	return ret;
 }
 
+static bool block_private_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    struct kvm_gfn_range *range)
+{
+	u64 new_spte;
+
+	if (WARN_ON(!is_private_spte(iter->sptep)))
+		return false;
+
+	new_spte = SPTE_PRIVATE_ZAPPED |
+		(spte_to_pfn(iter->old_spte) << PAGE_SHIFT) |
+		is_large_pte(iter->old_spte) ? PT_PAGE_SIZE_MASK : 0;
+
+	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+
+	static_call(kvm_x86_zap_private_spte)(kvm, iter->gfn, iter->level);
+
+	return true;
+}
+
+static bool block_private_gfn_range(struct kvm *kvm,
+				    struct kvm_gfn_range *range)
+{
+	return kvm_tdp_mmu_handle_gfn(kvm, range, block_private_spte);
+}
+
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
@@ -1080,6 +1435,15 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -1124,6 +1488,13 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -1175,6 +1546,14 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	/*
+	 * First TDX generation doesn't support write protecting private
+	 * mappings, since there's no secure EPT API to support it.  It
+	 * is a bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return spte_set;
+
 	rcu_read_lock();
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
@@ -1241,6 +1620,14 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  It is a
+	 * bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return spte_set;
+
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
@@ -1288,6 +1675,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	bool spte_set = false;
 
+	/* See comment in caller */
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
@@ -1310,6 +1698,14 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 	struct tdp_iter iter;
 	u64 new_spte;
 
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  It is a
+	 * bug to reach here for TDX guest.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return;
+
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
@@ -1318,10 +1714,10 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 			break;
 
 		if (iter.level > PG_LEVEL_4K ||
-		    !(mask & (1UL << (iter.gfn - gfn))))
+		    !(mask & (1UL << (tdp_iter_gfn_unalias(kvm, &iter) - gfn))))
 			continue;
 
-		mask &= ~(1UL << (iter.gfn - gfn));
+		mask &= ~(1UL << (tdp_iter_gfn_unalias(kvm, &iter) - gfn));
 
 		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
 			if (is_writable_pte(iter.old_spte))
@@ -1374,6 +1770,14 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 	struct tdp_iter iter;
 	kvm_pfn_t pfn;
 
+	/*
+	 * This should only be reachable in case of log-dirty, which TD
+	 * private mapping doesn't support so far.  Give a WARN() if it
+	 * hits private mapping.
+	 */
+	if (WARN_ON(is_private_sp(root)))
+		return flush;
+
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
@@ -1389,8 +1793,9 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 
 		pfn = spte_to_pfn(iter.old_spte);
 		if (kvm_is_reserved_pfn(pfn) ||
-		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
-							    pfn, PG_LEVEL_NUM))
+		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot,
+			    tdp_iter_gfn_unalias(kvm, &iter), pfn,
+			    PG_LEVEL_NUM))
 			continue;
 
 		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
@@ -1419,6 +1824,7 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 
+	/* See comment in caller */
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
@@ -1441,6 +1847,14 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
@@ -1496,10 +1910,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
+	bool is_private = kvm_is_private_gfn(vcpu->kvm, gfn);
 
 	*root_level = vcpu->arch.mmu->shadow_root_level;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	if (WARN_ON(is_private))
+		return leaf;
+
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1525,12 +1943,16 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
+	bool is_private = kvm_is_private_gfn(vcpu->kvm, gfn);
+
+	if (is_private)
+		goto out;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-
+out:
 	/*
 	 * Perform the rcu_dereference to get the raw spte pointer value since
 	 * we are passing it up to fast_page_fault, which is shared with the
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..0a975d30909e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,7 +5,7 @@
 
 #include <linux/kvm_host.h>
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
@@ -20,11 +20,14 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+				 gfn_t end, bool can_yield, bool flush,
+				 bool zap_private);
 static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush)
+					     gfn_t start, gfn_t end, bool flush,
+					     bool zap_private)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
+			zap_private);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -41,10 +44,10 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false);
+					   sp->gfn, end, false, false, false);
 }
 
-void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+void kvm_tdp_mmu_zap_all(struct kvm *kvm, bool zap_private);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
-- 
2.25.1

