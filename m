Return-Path: <kvm+bounces-18446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 824178D543E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C76A1F23669
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F3E199EB4;
	Thu, 30 May 2024 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WkVzODD5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A71862B5;
	Thu, 30 May 2024 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103259; cv=none; b=YHrsegXP1T97BqbgiYm1jgOjhKwyCTwt+81dLVQEDNG6Lx+F++CksfyM+NTNZ89z0Lebx/0P2WrMlUhtwtAN3cRKoiXw9ZK8YJpL09jISeQRJJAjHmdZeYZE1tfs1ZH1i0kZ5zHXvMR/kqujoSoFJniqk1AivBFWPc9ekpXoCHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103259; c=relaxed/simple;
	bh=Lv4l9P1oCXjBGLsY5OqfylrtJeoqBud7VcK3VJTxJ9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+UI2KuIgBYC9FGrFJOTiP6E11K/nMRSSdTmJMHFniMM+rB09T5KFlzqWzEqzM/bgqq0We0TugMM9lgy8AkLNPGusJJawn2Mvm7ISW8zH0DLPTU23rFd26xg1FkEfBb+ouM8HWOdGsv24AHQs2RRJp1MqK6vW+TKB3gioJpiU6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WkVzODD5; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717103258; x=1748639258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lv4l9P1oCXjBGLsY5OqfylrtJeoqBud7VcK3VJTxJ9c=;
  b=WkVzODD5rTUT6kRYqKLuB0s+HlVErrYOHxpEIoiEbjtNXOX+P1u8LnII
   heDQALLRGBb3pAVHMCwdg69qXFGYmLgzi88TIR+9bVXlEx3KTF62Yxgnd
   6SMCet52I1bQgtAWrCWQd9Mg38m7eRTCbKlfPF3cEUC9wnQ+0NhvaO1Cp
   6vMmTQwm2AeVYncXTvZMXqHgCAuxLvNTsLFhXLIfoNSJTgqbFWbjcjBzc
   P5rr39wObI0/5aDQUAgd2NfJ7Lb2yGjYtIvYhOUh9yL0GYUayAAovtPYL
   ZarquklGmoXwCeOdvxD3sAjmgR2oVPP6yX9/ROroGiUc8k0PMlHelyLym
   A==;
X-CSE-ConnectionGUID: nbOjL4RJSh2fGD9PG01rVw==
X-CSE-MsgGUID: EZ657hovSoKsd3HuNASfZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31117124"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31117124"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:37 -0700
X-CSE-ConnectionGUID: IskyWzmhRQe9hvzCe6QMRw==
X-CSE-MsgGUID: jONWCw7YRUSXpkwc4PLv5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="35874444"
Received: from hding1-mobl.ccr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.19.65])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:07:37 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
Date: Thu, 30 May 2024 14:07:08 -0700
Message-Id: <20240530210714.364118-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add the ability for the TDP MMU to maintain a mirror of a separate mapping.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly though calls into a
protected runtime environment called the TDX module, where the shared half
is managed within KVM in normal page tables.

In order to handle both shared and private memory, KVM needs to learn to
handle faults and other operations on the correct root for the operation.
KVM could learn the concept of private roots, and operate on them by
calling out to operations that call into the TDX module. But there are two
problems with that:
1. Calls into the TDX module are relatively slow compared to the simple
   accesses required to read a PTE managed directly by KVM.
2. Other Coco technologies deal with private memory completely differently
   and it will make the code confusing when being read from their
   perspective. Special operations added for TDX that set private or zap
   private memory will have nothing to do with these other private memory
   technologies. (SEV, etc).

To handle these, instead teach the TDP MMU about a new concept "mirror
roots". Such roots maintain page tables that are not actually mapped,
and are just used to traverse quickly to determine if the mid level page
tables need to be installed. When the memory be mirrored needs to actually
be changed, calls can be made to via x86_ops.

  private KVM page fault   |
      |                    |
      V                    |
 private GPA               |     CPU protected EPTP
      |                    |           |
      V                    |           V
 mirror PT root            |     private PT root
      |                    |           |
      V                    |           V
   mirror PT   --hook to propagate-->private PT
      |                    |           |
      \--------------------+------\    |
                           |      |    |
                           |      V    V
                           |    private guest page
                           |
                           |
     non-encrypted memory  |    encrypted memory
                           |

Leave calling out to actually update the private page tables that are being
mirrored for later changes. Just implement the handling of MMU operations
on to mirrored roots.

In order to direct operations to correct root, add root types
KVM_DIRECT_ROOTS and KVM_MIRROR_ROOTS. Tie the usage of mirrored/direct roots
to operations targeting private/shared memory by adding kvm_on_mirror() and
kvm_on_direct() helpers in mmu.h.

Cleanup the mirror root in kvm_mmu_destroy() instead of the normal place
in kvm_mmu_free_roots(), because the private root that is being cannot be
be rebuilt like a normal root. It needs to persist for the lifetime of the
VM.

The TDX module will also need to be provided with page tables to use for
the actual mapping being mirrored by the mirrored page tables. Allocate
these in the mapping path using the recently added
kvm_mmu_alloc_private_spt().

Update handle_changed_spte() to take a role. Use this for a KVM_BUG_ON().

Don't support 2M page for now. This is avoided by forcing 4k pages in the
fault. Add a KVM_BUG_ON() to verify.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v2:
 - Rename private->mirror
 - Split apart from "KVM: x86/tdp_mmu: Support TDX private mapping for TDP
   MMU"
 - Update log
 - Sprinkle a few comments
 - Use kvm_on_*() helpers to direct iterator to proper root
 - Drop BUGGY_KVM_ROOTS because the translation between the process enum
   is no longer automatic, and the warn already happens elsewhere.

TDX MMU Prep:
 - Remove unnecessary gfn, access twist in
   tdp_mmu_map_handle_target_level(). (Chao Gao)
 - Open code call to kvm_mmu_alloc_private_spt() instead oCf doing it in
   tdp_mmu_alloc_sp()
 - Update comment in set_private_spte_present() (Yan)
 - Open code call to kvm_mmu_init_private_spt() (Yan)
 - Add comments on TDX MMU hooks (Yan)
 - Fix various whitespace alignment (Yan)
 - Remove pointless warnings and conditionals in
   handle_removed_private_spte() (Yan)
 - Remove redundant lockdep assert in tdp_mmu_set_spte() (Yan)
 - Remove incorrect comment in handle_changed_spte() (Yan)
 - Remove unneeded kvm_pfn_to_refcounted_page() and
   is_error_noslot_pfn() check in kvm_tdp_mmu_map() (Yan)
 - Do kvm_gfn_for_root() branchless (Rick)
 - Update kvm_tdp_mmu_alloc_root() callers to not check error code (Rick)
 - Add comment for stripping shared bit for fault.gfn (Chao)

v19:
- drop CONFIG_KVM_MMU_PRIVATE

v18:
- Rename freezed => frozen

v14 -> v15:
- Refined is_private condition check in kvm_tdp_mmu_map().
  Add kvm_gfn_shared_mask() check.
- catch up for struct kvm_range change
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              | 16 ++++++++
 arch/x86/kvm/mmu/mmu.c          | 11 +++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 70 ++++++++++++++++++++++++---------
 arch/x86/kvm/mmu/tdp_mmu.h      | 39 ++++++++++++++++--
 5 files changed, 115 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9af963ab897..d4446dde0ace 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -470,6 +470,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t mirror_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f0713b6e4ee5..006f06463a27 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -328,4 +328,20 @@ static inline gfn_t kvm_gfn_direct_mask(const struct kvm *kvm)
 {
 	return kvm->arch.gfn_direct_mask;
 }
+
+static inline bool kvm_on_mirror(const struct kvm *kvm, enum kvm_process process)
+{
+	if (!kvm_has_mirrored_tdp(kvm))
+		return false;
+
+	return process & KVM_PROCESS_PRIVATE;
+}
+
+static inline bool kvm_on_direct(const struct kvm *kvm, enum kvm_process process)
+{
+	if (!kvm_has_mirrored_tdp(kvm))
+		return true;
+
+	return process & KVM_PROCESS_SHARED;
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 12178945922f..01fb918612ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	if (tdp_mmu_enabled) {
-		kvm_tdp_mmu_alloc_root(vcpu);
+		if (kvm_has_mirrored_tdp(vcpu->kvm))
+			kvm_tdp_mmu_alloc_root(vcpu, true);
+		kvm_tdp_mmu_alloc_root(vcpu, false);
 		return 0;
 	}
 
@@ -6245,6 +6247,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->mirror_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7220,6 +7223,12 @@ int kvm_mmu_vendor_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
+	if (tdp_mmu_enabled) {
+		read_lock(&vcpu->kvm->mmu_lock);
+		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->mirror_root_hpa,
+				   NULL);
+		read_unlock(&vcpu->kvm->mmu_lock);
+	}
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5e8f652cd8b1..0fc168a3fff1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -95,10 +95,18 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
 			       enum kvm_tdp_mmu_root_types types)
 {
+	if (WARN_ON_ONCE(!(types & (KVM_DIRECT_ROOTS | KVM_MIRROR_ROOTS))))
+		return false;
+
 	if ((types & KVM_VALID_ROOTS) && root->role.invalid)
 		return false;
 
-	return true;
+	if ((types & KVM_DIRECT_ROOTS) && !is_mirror_sp(root))
+		return true;
+	if ((types & KVM_MIRROR_ROOTS) && is_mirror_sp(root))
+		return true;
+
+	return false;
 }
 
 /*
@@ -233,7 +241,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -241,6 +249,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
+	if (mirror)
+		kvm_mmu_page_role_set_mirrored(&role);
+
 	/*
 	 * Check for an existing root before acquiring the pages lock to avoid
 	 * unnecessary serialization if multiple vCPUs are loading a new root.
@@ -292,13 +303,17 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	 * and actually consuming the root if it's invalidated after dropping
 	 * mmu_lock, and the root can't be freed as this vCPU holds a reference.
 	 */
-	mmu->root.hpa = __pa(root->spt);
-	mmu->root.pgd = 0;
+	if (mirror) {
+		mmu->mirror_root_hpa = __pa(root->spt);
+	} else {
+		mmu->root.hpa = __pa(root->spt);
+		mmu->root.pgd = 0;
+	}
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -425,7 +440,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 							  REMOVED_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+				    old_spte, REMOVED_SPTE, sp->role, shared);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -438,7 +453,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
- * @level: the level of the PT the SPTE is part of in the paging structure
+ * @role: the role of the PT the SPTE is part of in the paging structure
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
@@ -448,9 +463,11 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * and fast_pf_fix_direct_spte()).
  */
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared)
 {
+	bool is_mirror = kvm_mmu_page_role_is_mirror(role);
+	int level = role.level;
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
@@ -531,8 +548,11 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * pages are kernel allocations and should never be migrated.
 	 */
 	if (was_present && !was_leaf &&
-	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
+		KVM_BUG_ON(is_mirror !=
+			   is_mirror_sptep(spte_to_child_pt(old_spte, level)), kvm);
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+	}
 
 	if (was_leaf && is_accessed_spte(old_spte) &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
@@ -585,6 +605,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter,
 					  u64 new_spte)
 {
+	u64 *sptep = rcu_dereference(iter->sptep);
 	int ret;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
@@ -594,7 +615,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		return ret;
 
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+			    new_spte, sptep_to_sp(sptep)->role, true);
 
 	return 0;
 }
@@ -602,6 +623,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter)
 {
+	union kvm_mmu_page_role role;
 	int ret;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
@@ -628,6 +650,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 */
 	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
+	role = sptep_to_sp(iter->sptep)->role;
 	/*
 	 * Process the zapped SPTE after flushing TLBs, and after replacing
 	 * REMOVED_SPTE with 0. This minimizes the amount of time vCPUs are
@@ -635,7 +658,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * SPTEs.
 	 */
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    0, iter->level, true);
+			    SHADOW_NONPRESENT_VALUE, role, true);
 
 	return 0;
 }
@@ -657,6 +680,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			    u64 old_spte, u64 new_spte, gfn_t gfn, int level)
 {
+	union kvm_mmu_page_role role;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -670,7 +695,9 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	role = sptep_to_sp(sptep)->role;
+	role.level = level;
+	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
 	return old_spte;
 }
 
@@ -1114,7 +1141,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	enum kvm_tdp_mmu_root_types root_type = tdp_mmu_get_fault_root_type(kvm, fault);
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, root_type);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1151,13 +1179,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
+		if (is_mirror_sp(sp))
+			kvm_mmu_alloc_mirrored_spt(vcpu, sp);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte))
+		if (is_shadow_present_pte(iter.old_spte)) {
+			/* Don't support large page for mirrored roots (TDX) */
+			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		else
+		} else {
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+		}
 
 		/*
 		 * Force the guest to retry if installing an upper level SPTE
@@ -1812,7 +1845,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	/* Fast pf is not supported for mirrored roots  */
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, KVM_DIRECT_ROOTS);
 	struct tdp_iter iter;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index e7055a5333a8..934269b82f20 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
@@ -21,11 +21,44 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 enum kvm_tdp_mmu_root_types {
 	KVM_VALID_ROOTS = BIT(0),
+	KVM_DIRECT_ROOTS = BIT(1),
+	KVM_MIRROR_ROOTS = BIT(2),
 
-	KVM_ANY_ROOTS = 0,
-	KVM_ANY_VALID_ROOTS = KVM_VALID_ROOTS,
+	KVM_ANY_ROOTS = KVM_DIRECT_ROOTS | KVM_MIRROR_ROOTS,
+	KVM_ANY_VALID_ROOTS = KVM_DIRECT_ROOTS | KVM_MIRROR_ROOTS | KVM_VALID_ROOTS,
 };
 
+static inline enum kvm_tdp_mmu_root_types kvm_process_to_root_types(struct kvm *kvm,
+							     enum kvm_process process)
+{
+	enum kvm_tdp_mmu_root_types ret = 0;
+
+	WARN_ON_ONCE(process == BUGGY_KVM_INVALIDATION);
+
+	if (kvm_on_mirror(kvm, process))
+		ret |= KVM_MIRROR_ROOTS;
+
+	if (kvm_on_direct(kvm, process))
+		ret |= KVM_DIRECT_ROOTS;
+
+	return ret;
+}
+
+static inline enum kvm_tdp_mmu_root_types tdp_mmu_get_fault_root_type(struct kvm *kvm,
+								      struct kvm_page_fault *fault)
+{
+	if (fault->is_private)
+		return kvm_process_to_root_types(kvm, KVM_PROCESS_PRIVATE);
+	return KVM_DIRECT_ROOTS;
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu, enum kvm_tdp_mmu_root_types type)
+{
+	if (type == KVM_MIRROR_ROOTS)
+		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
+	return root_to_sp(vcpu->arch.mmu->root.hpa);
+}
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.34.1


