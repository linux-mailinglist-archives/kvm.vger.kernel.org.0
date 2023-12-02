Return-Path: <kvm+bounces-3241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F61801BF4
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 599841F2116D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E82D14F9D;
	Sat,  2 Dec 2023 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrkZhbct"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C23197;
	Sat,  2 Dec 2023 01:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511017; x=1733047017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=eYf3VU1p/NWLVybSdv7z8At46N23CSKFjZR1lIqKJ0M=;
  b=lrkZhbctPs/Ty3TBP1+Y1Vu4oBa0MtvbSE/rv3zULvFGOJAf3bkKvEY7
   I4s0r1RUqgvIBFT93l+I9OyfmAN8ZtgApGj1tNGjwgyLDRVtga49B9Ko6
   lJSyyAwNlMhbuNFcmQjO9OGesp8Uyf5pUNQWclApZi/QeBE6ng+xpS3Y0
   OGsiAH78TGqSq4pmJ/97jiuWxqTtWhfERCcHmigXEVPIgM5D4AO+1HGD9
   59yyROnQgSSwWgE7pVn5AM/4WA5IJfpKigaPFQYSEslgzIHyCv8JAdryC
   m7dXJADNfjiF0EZ76vCmtvhFY6XtCeX9433ch+YKCTTVpRsAfbGJZ77hr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="457913578"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="457913578"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:56:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="840460888"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="840460888"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:56:52 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 25/42] KVM: x86/mmu: Abstract "struct kvm_mmu_common" from "struct kvm_mmu"
Date: Sat,  2 Dec 2023 17:27:58 +0800
Message-Id: <20231202092758.14978-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Abstract "struct kvm_mmu_common" and move 3 common fields "root, root_role,
shadow_zero_check" from "struct kvm_mmu" to "struct kvm_mmu_common".

"struct kvm_mmu_common" is a preparation for later patches to introduce
"struct kvm_exported_tdp_mmu" which is used by KVM to export TDP.

Opportunistically, a new param "struct kvm_mmu_common *mmu_common" is added
to make_spte(), so that is_rsvd_spte() in make_spte() can use
&mmu_common->shadow_zero_check directly without asking it from vcpu.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  22 +++--
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          | 168 ++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   9 +-
 arch/x86/kvm/mmu/spte.c         |   7 +-
 arch/x86/kvm/mmu/spte.h         |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  13 +--
 arch/x86/kvm/svm/svm.c          |   2 +-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/x86.c              |   8 +-
 12 files changed, 127 insertions(+), 119 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e3..16e01eee34a99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -437,12 +437,25 @@ struct kvm_mmu_root_info {
 struct kvm_mmu_page;
 struct kvm_page_fault;
 
+struct kvm_mmu_common {
+	struct kvm_mmu_root_info root;
+	union kvm_mmu_page_role root_role;
+
+	/*
+	 * check zero bits on shadow page table entries, these
+	 * bits include not only hardware reserved bits but also
+	 * the bits spte never used.
+	 */
+	struct rsvd_bits_validate shadow_zero_check;
+};
+
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
  * and 2-level 32-bit).  The kvm_mmu structure abstracts the details of the
  * current mmu mode.
  */
 struct kvm_mmu {
+	struct kvm_mmu_common common;
 	unsigned long (*get_guest_pgd)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
 	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -453,9 +466,7 @@ struct kvm_mmu {
 			    struct x86_exception *exception);
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
-	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
-	union kvm_mmu_page_role root_role;
 
 	/*
 	* The pkru_mask indicates if protection key checks are needed.  It
@@ -478,13 +489,6 @@ struct kvm_mmu {
 	u64 *pml4_root;
 	u64 *pml5_root;
 
-	/*
-	 * check zero bits on shadow page table entries, these
-	 * bits include not only hardware reserved bits but also
-	 * the bits spte never used.
-	 */
-	struct rsvd_bits_validate shadow_zero_check;
-
 	struct rsvd_bits_validate guest_rsvd_check;
 
 	u64 pdptrs[4]; /* pae */
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bb8c86eefac04..e9631cc23a594 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -126,7 +126,7 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
-	if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
+	if (likely(vcpu->arch.mmu->common.root.hpa != INVALID_PAGE))
 		return 0;
 
 	return kvm_mmu_load(vcpu);
@@ -148,13 +148,13 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
-	u64 root_hpa = vcpu->arch.mmu->root.hpa;
+	u64 root_hpa = vcpu->arch.mmu->common.root.hpa;
 
 	if (!VALID_PAGE(root_hpa))
 		return;
 
 	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
-					  vcpu->arch.mmu->root_role.level);
+					  vcpu->arch.mmu->common.root_role.level);
 }
 
 static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69af78e508197..cfeb066f38687 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -643,7 +643,7 @@ static bool mmu_spte_age(u64 *sptep)
 
 static inline bool is_tdp_mmu_active(struct kvm_vcpu *vcpu)
 {
-	return tdp_mmu_enabled && vcpu->arch.mmu->root_role.direct;
+	return tdp_mmu_enabled && vcpu->arch.mmu->common.root_role.direct;
 }
 
 static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
@@ -1911,7 +1911,7 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
 
 static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
+	union kvm_mmu_page_role root_role = vcpu->arch.mmu->common.root_role;
 
 	/*
 	 * Ignore various flags when verifying that it's safe to sync a shadow
@@ -2363,11 +2363,11 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 {
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
-	iterator->level = vcpu->arch.mmu->root_role.level;
+	iterator->level = vcpu->arch.mmu->common.root_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->root_role.direct)
+	    !vcpu->arch.mmu->common.root_role.direct)
 		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
@@ -2375,7 +2375,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 		 * prev_root is currently only used for 64-bit hosts. So only
 		 * the active root_hpa is valid here.
 		 */
-		BUG_ON(root != vcpu->arch.mmu->root.hpa);
+		BUG_ON(root != vcpu->arch.mmu->common.root.hpa);
 
 		iterator->shadow_addr
 			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
@@ -2389,7 +2389,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
 			     struct kvm_vcpu *vcpu, u64 addr)
 {
-	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root.hpa,
+	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->common.root.hpa,
 				    addr);
 }
 
@@ -2771,7 +2771,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->common.root_role.direct)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
@@ -2939,7 +2939,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
+	wrprot = make_spte(vcpu, &vcpu->arch.mmu->common,
+			   sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
 			   true, host_writable, &spte);
 
 	if (*sptep == spte) {
@@ -3577,7 +3578,7 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 
 	/* Before acquiring the MMU lock, see if we need to do any real work. */
 	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT)
-		&& VALID_PAGE(mmu->root.hpa);
+		&& VALID_PAGE(mmu->common.root.hpa);
 
 	if (!free_active_root) {
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
@@ -3597,10 +3598,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (kvm_mmu_is_dummy_root(mmu->root.hpa)) {
+		if (kvm_mmu_is_dummy_root(mmu->common.root.hpa)) {
 			/* Nothing to cleanup for dummy roots. */
-		} else if (root_to_sp(mmu->root.hpa)) {
-			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
+		} else if (root_to_sp(mmu->common.root.hpa)) {
+			mmu_free_root_page(kvm, &mmu->common.root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
 				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
@@ -3611,8 +3612,8 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 				mmu->pae_root[i] = INVALID_PAE_ROOT;
 			}
 		}
-		mmu->root.hpa = INVALID_PAGE;
-		mmu->root.pgd = 0;
+		mmu->common.root.hpa = INVALID_PAGE;
+		mmu->common.root.pgd = 0;
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
@@ -3631,7 +3632,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	 * This should not be called while L2 is active, L2 can't invalidate
 	 * _only_ its own roots, e.g. INVVPID unconditionally exits.
 	 */
-	WARN_ON_ONCE(mmu->root_role.guest_mode);
+	WARN_ON_ONCE(mmu->common.root_role.guest_mode);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		root_hpa = mmu->prev_roots[i].hpa;
@@ -3650,7 +3651,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
 static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 			    u8 level)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->common.root_role;
 	struct kvm_mmu_page *sp;
 
 	role.level = level;
@@ -3668,7 +3669,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u8 shadow_root_level = mmu->root_role.level;
+	u8 shadow_root_level = mmu->common.root_role.level;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3680,10 +3681,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 	if (tdp_mmu_enabled) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
-		mmu->root.hpa = root;
+		mmu->common.root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
-		mmu->root.hpa = root;
+		mmu->common.root.hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
 			r = -EIO;
@@ -3698,7 +3699,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_value;
 		}
-		mmu->root.hpa = __pa(mmu->pae_root);
+		mmu->common.root.hpa = __pa(mmu->pae_root);
 	} else {
 		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
 		r = -EIO;
@@ -3706,7 +3707,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	}
 
 	/* root.pgd is ignored for direct MMUs. */
-	mmu->root.pgd = 0;
+	mmu->common.root.pgd = 0;
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 	return r;
@@ -3785,7 +3786,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
-		mmu->root.hpa = kvm_mmu_get_dummy_root();
+		mmu->common.root.hpa = kvm_mmu_get_dummy_root();
 		return 0;
 	}
 
@@ -3819,8 +3820,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->root_role.level);
-		mmu->root.hpa = root;
+				      mmu->common.root_role.level);
+		mmu->common.root.hpa = root;
 		goto set_root_pgd;
 	}
 
@@ -3835,7 +3836,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_value;
-	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
+	if (mmu->common.root_role.level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
@@ -3844,7 +3845,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
 
-		if (mmu->root_role.level == PT64_ROOT_5LEVEL) {
+		if (mmu->common.root_role.level == PT64_ROOT_5LEVEL) {
 			if (WARN_ON_ONCE(!mmu->pml5_root)) {
 				r = -EIO;
 				goto out_unlock;
@@ -3876,15 +3877,15 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-	if (mmu->root_role.level == PT64_ROOT_5LEVEL)
-		mmu->root.hpa = __pa(mmu->pml5_root);
-	else if (mmu->root_role.level == PT64_ROOT_4LEVEL)
-		mmu->root.hpa = __pa(mmu->pml4_root);
+	if (mmu->common.root_role.level == PT64_ROOT_5LEVEL)
+		mmu->common.root.hpa = __pa(mmu->pml5_root);
+	else if (mmu->common.root_role.level == PT64_ROOT_4LEVEL)
+		mmu->common.root.hpa = __pa(mmu->pml4_root);
 	else
-		mmu->root.hpa = __pa(mmu->pae_root);
+		mmu->common.root.hpa = __pa(mmu->pae_root);
 
 set_root_pgd:
-	mmu->root.pgd = root_pgd;
+	mmu->common.root.pgd = root_pgd;
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
 
@@ -3894,7 +3895,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->root_role.level > PT64_ROOT_4LEVEL;
+	bool need_pml5 = mmu->common.root_role.level > PT64_ROOT_4LEVEL;
 	u64 *pml5_root = NULL;
 	u64 *pml4_root = NULL;
 	u64 *pae_root;
@@ -3905,9 +3906,9 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->root_role.direct ||
+	if (mmu->common.root_role.direct ||
 	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
-	    mmu->root_role.level < PT64_ROOT_4LEVEL)
+	    mmu->common.root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
 	/*
@@ -4003,16 +4004,16 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->common.root_role.direct)
 		return;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
+	if (!VALID_PAGE(vcpu->arch.mmu->common.root.hpa))
 		return;
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
 	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root.hpa;
+		hpa_t root = vcpu->arch.mmu->common.root.hpa;
 
 		if (!is_unsync_root(root))
 			return;
@@ -4134,7 +4135,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	if (!is_shadow_present_pte(sptes[leaf]))
 		leaf++;
 
-	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
+	rsvd_check = &vcpu->arch.mmu->common.shadow_zero_check;
 
 	for (level = root; level >= leaf; level--)
 		reserved |= is_rsvd_spte(rsvd_check, sptes[level], level);
@@ -4233,7 +4234,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->root_role.direct;
+	arch.direct_map = vcpu->arch.mmu->common.root_role.direct;
 	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
@@ -4244,7 +4245,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
+	if ((vcpu->arch.mmu->common.root_role.direct != work->arch.direct_map) ||
 	      work->wakeup_all)
 		return;
 
@@ -4252,7 +4253,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
-	if (!vcpu->arch.mmu->root_role.direct &&
+	if (!vcpu->arch.mmu->common.root_role.direct &&
 	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
@@ -4348,7 +4349,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
+	struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->common.root.hpa);
 
 	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
 	if (sp && is_obsolete_sp(vcpu->kvm, sp))
@@ -4374,7 +4375,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	int r;
 
 	/* Dummy roots are used only for shadowing bad guest roots. */
-	if (WARN_ON_ONCE(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa)))
+	if (WARN_ON_ONCE(kvm_mmu_is_dummy_root(vcpu->arch.mmu->common.root.hpa)))
 		return RET_PF_RETRY;
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -4555,9 +4556,9 @@ static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 /*
  * Find out if a previously cached root matching the new pgd/role is available,
  * and insert the current root as the MRU in the cache.
- * If a matching root is found, it is assigned to kvm_mmu->root and
+ * If a matching root is found, it is assigned to kvm_mmu->common.root and
  * true is returned.
- * If no match is found, kvm_mmu->root is left invalid, the LRU root is
+ * If no match is found, kvm_mmu->common.root is left invalid, the LRU root is
  * evicted to make room for the current root, and false is returned.
  */
 static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *mmu,
@@ -4566,7 +4567,7 @@ static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *m
 {
 	uint i;
 
-	if (is_root_usable(&mmu->root, new_pgd, new_role))
+	if (is_root_usable(&mmu->common.root, new_pgd, new_role))
 		return true;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
@@ -4578,8 +4579,8 @@ static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *m
 		 *   2   C 0 1 3
 		 *   3   C 0 1 2   (on exit from the loop)
 		 */
-		swap(mmu->root, mmu->prev_roots[i]);
-		if (is_root_usable(&mmu->root, new_pgd, new_role))
+		swap(mmu->common.root, mmu->prev_roots[i]);
+		if (is_root_usable(&mmu->common.root, new_pgd, new_role))
 			return true;
 	}
 
@@ -4589,10 +4590,11 @@ static bool cached_root_find_and_keep_current(struct kvm *kvm, struct kvm_mmu *m
 
 /*
  * Find out if a previously cached root matching the new pgd/role is available.
- * On entry, mmu->root is invalid.
- * If a matching root is found, it is assigned to kvm_mmu->root, the LRU entry
- * of the cache becomes invalid, and true is returned.
- * If no match is found, kvm_mmu->root is left invalid and false is returned.
+ * On entry, mmu->common.root is invalid.
+ * If a matching root is found, it is assigned to kvm_mmu->common.root, the LRU
+ * entry of the cache becomes invalid, and true is returned.
+ * If no match is found, kvm_mmu->common.root is left invalid and false is
+ * returned.
  */
 static bool cached_root_find_without_current(struct kvm *kvm, struct kvm_mmu *mmu,
 					     gpa_t new_pgd,
@@ -4607,7 +4609,7 @@ static bool cached_root_find_without_current(struct kvm *kvm, struct kvm_mmu *mm
 	return false;
 
 hit:
-	swap(mmu->root, mmu->prev_roots[i]);
+	swap(mmu->common.root, mmu->prev_roots[i]);
 	/* Bubble up the remaining roots.  */
 	for (; i < KVM_MMU_NUM_PREV_ROOTS - 1; i++)
 		mmu->prev_roots[i] = mmu->prev_roots[i + 1];
@@ -4622,10 +4624,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 	 * Limit reuse to 64-bit hosts+VMs without "special" roots in order to
 	 * avoid having to deal with PDPTEs and other complexities.
 	 */
-	if (VALID_PAGE(mmu->root.hpa) && !root_to_sp(mmu->root.hpa))
+	if (VALID_PAGE(mmu->common.root.hpa) && !root_to_sp(mmu->common.root.hpa))
 		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);
 
-	if (VALID_PAGE(mmu->root.hpa))
+	if (VALID_PAGE(mmu->common.root.hpa))
 		return cached_root_find_and_keep_current(kvm, mmu, new_pgd, new_role);
 	else
 		return cached_root_find_without_current(kvm, mmu, new_pgd, new_role);
@@ -4634,7 +4636,7 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	union kvm_mmu_page_role new_role = mmu->root_role;
+	union kvm_mmu_page_role new_role = mmu->common.root_role;
 
 	/*
 	 * Return immediately if no usable root was found, kvm_mmu_reload()
@@ -4669,7 +4671,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * count. Otherwise, clear the write flooding count.
 	 */
 	if (!new_role.direct) {
-		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
+		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->common.root.hpa);
 
 		if (!WARN_ON_ONCE(!sp))
 			__clear_sp_write_flooding_count(sp);
@@ -4863,7 +4865,7 @@ static inline u64 reserved_hpa_bits(void)
  * follow the features in guest.
  */
 static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-					struct kvm_mmu *context)
+					struct kvm_mmu_common *context)
 {
 	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
 	bool is_amd = true;
@@ -4909,7 +4911,7 @@ static inline bool boot_cpu_is_amd(void)
  * the direct page table on host, use as much mmu features as
  * possible, however, kvm currently does not do execution-protection.
  */
-static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
+static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu_common *context)
 {
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
@@ -4947,7 +4949,7 @@ static void reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
  * is the shadow page table for intel nested guest.
  */
 static void
-reset_ept_shadow_zero_bits_mask(struct kvm_mmu *context, bool execonly)
+reset_ept_shadow_zero_bits_mask(struct kvm_mmu_common *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
 				    reserved_hpa_bits(), execonly,
@@ -5223,11 +5225,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
-	    root_role.word == context->root_role.word)
+	    root_role.word == context->common.root_role.word)
 		return;
 
 	context->cpu_role.as_u64 = cpu_role.as_u64;
-	context->root_role.word = root_role.word;
+	context->common.root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_spte = NULL;
 	context->get_guest_pgd = get_guest_cr3;
@@ -5242,7 +5244,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 		context->gva_to_gpa = paging32_gva_to_gpa;
 
 	reset_guest_paging_metadata(vcpu, context);
-	reset_tdp_shadow_zero_bits_mask(context);
+	reset_tdp_shadow_zero_bits_mask(&context->common);
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
@@ -5250,11 +5252,11 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 				    union kvm_mmu_page_role root_role)
 {
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
-	    root_role.word == context->root_role.word)
+	    root_role.word == context->common.root_role.word)
 		return;
 
 	context->cpu_role.as_u64 = cpu_role.as_u64;
-	context->root_role.word = root_role.word;
+	context->common.root_role.word = root_role.word;
 
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
@@ -5264,7 +5266,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging32_init_context(context);
 
 	reset_guest_paging_metadata(vcpu, context);
-	reset_shadow_zero_bits_mask(vcpu, context);
+	reset_shadow_zero_bits_mask(vcpu, &context->common);
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
@@ -5356,7 +5358,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	if (new_mode.as_u64 != context->cpu_role.as_u64) {
 		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 		context->cpu_role.as_u64 = new_mode.as_u64;
-		context->root_role.word = new_mode.base.word;
+		context->common.root_role.word = new_mode.base.word;
 
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
@@ -5365,7 +5367,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
-		reset_ept_shadow_zero_bits_mask(context, execonly);
+		reset_ept_shadow_zero_bits_mask(&context->common, execonly);
 	}
 
 	kvm_mmu_new_pgd(vcpu, new_eptp);
@@ -5451,9 +5453,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * that problem is swept under the rug; KVM's CPUID API is horrific and
 	 * it's all but impossible to solve it without introducing a new API.
 	 */
-	vcpu->arch.root_mmu.root_role.word = 0;
-	vcpu->arch.guest_mmu.root_role.word = 0;
-	vcpu->arch.nested_mmu.root_role.word = 0;
+	vcpu->arch.root_mmu.common.root_role.word = 0;
+	vcpu->arch.guest_mmu.common.root_role.word = 0;
+	vcpu->arch.nested_mmu.common.root_role.word = 0;
 	vcpu->arch.root_mmu.cpu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.cpu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
@@ -5477,13 +5479,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->common.root_role.direct);
 	if (r)
 		goto out;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->common.root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
@@ -5511,9 +5513,9 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 
 	kvm_mmu_free_roots(kvm, &vcpu->arch.root_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON_ONCE(VALID_PAGE(vcpu->arch.root_mmu.root.hpa));
+	WARN_ON_ONCE(VALID_PAGE(vcpu->arch.root_mmu.common.root.hpa));
 	kvm_mmu_free_roots(kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
-	WARN_ON_ONCE(VALID_PAGE(vcpu->arch.guest_mmu.root.hpa));
+	WARN_ON_ONCE(VALID_PAGE(vcpu->arch.guest_mmu.common.root.hpa));
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 }
 
@@ -5549,7 +5551,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	unsigned long roots_to_free = 0;
 	int i;
 
-	if (is_obsolete_root(kvm, mmu->root.hpa))
+	if (is_obsolete_root(kvm, mmu->common.root.hpa))
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
@@ -5719,7 +5721,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-	bool direct = vcpu->arch.mmu->root_role.direct;
+	bool direct = vcpu->arch.mmu->common.root_role.direct;
 
 	/*
 	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
@@ -5732,7 +5734,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
 		error_code &= ~PFERR_IMPLICIT_ACCESS;
 
-	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
+	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->common.root.hpa)))
 		return RET_PF_RETRY;
 
 	r = RET_PF_INVALID;
@@ -5762,7 +5764,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	 * paging in both guests. If true, we simply unprotect the page
 	 * and resume the guest.
 	 */
-	if (vcpu->arch.mmu->root_role.direct &&
+	if (vcpu->arch.mmu->common.root_role.direct &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
@@ -5844,7 +5846,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		return;
 
 	if (roots & KVM_MMU_ROOT_CURRENT)
-		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
+		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->common.root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
@@ -5990,8 +5992,8 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	struct page *page;
 	int i;
 
-	mmu->root.hpa = INVALID_PAGE;
-	mmu->root.pgd = 0;
+	mmu->common.root.hpa = INVALID_PAGE;
+	mmu->common.root.pgd = 0;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index decc1f1536694..7699596308386 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -299,7 +299,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	};
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct) {
+	if (vcpu->arch.mmu->common.root_role.direct) {
 		fault.gfn = fault.addr >> PAGE_SHIFT;
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f672..84509af0d7f9d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -648,7 +648,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (FNAME(gpte_changed)(vcpu, gw, top_level))
 		goto out_gpte_changed;
 
-	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
+	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->common.root.hpa)))
 		goto out_gpte_changed;
 
 	/*
@@ -657,7 +657,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * loading a dummy root and handling the resulting page fault, e.g. if
 	 * userspace create a memslot in the interim.
 	 */
-	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa))) {
+	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->common.root.hpa))) {
 		kvm_make_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu);
 		goto out_gpte_changed;
 	}
@@ -960,9 +960,8 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	spte = *sptep;
 	host_writable = spte & shadow_host_writable_mask;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	make_spte(vcpu, sp, slot, pte_access, gfn,
-		  spte_to_pfn(spte), spte, true, false,
-		  host_writable, &spte);
+	make_spte(vcpu, &vcpu->arch.mmu->common, sp, slot, pte_access,
+		  gfn, spte_to_pfn(spte), spte, true, false, host_writable, &spte);
 
 	return mmu_spte_update(sptep, spte);
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 179156cd995df..9060a56e45569 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -137,7 +137,8 @@ bool spte_has_volatile_bits(u64 spte)
 	return false;
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool make_spte(struct kvm_vcpu *vcpu,
+	       struct kvm_mmu_common *mmu_common, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
@@ -237,9 +238,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (prefetch)
 		spte = mark_spte_for_access_track(spte);
 
-	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
+	WARN_ONCE(is_rsvd_spte(&mmu_common->shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
-		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
+		  get_rsvd_bits(&mmu_common->shadow_zero_check, spte, level));
 
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index b88b686a4ecbc..8f747268a4874 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -530,7 +530,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 
 bool spte_has_volatile_bits(u64 spte);
 
-bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool make_spte(struct kvm_vcpu *vcpu,
+	       struct kvm_mmu_common *mmu_common, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2fa..6657685a28709 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -219,7 +219,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->common.root_role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
@@ -640,7 +640,7 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, root_to_sp(_mmu->root.hpa), _start, _end)
+	for_each_tdp_pte(_iter, root_to_sp(_mmu->common.root.hpa), _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -964,9 +964,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+		wrprot = make_spte(vcpu, &vcpu->arch.mmu->common, sp, fault->slot,
+				   ACC_ALL, iter->gfn, fault->pfn, iter->old_spte,
+				   fault->prefetch, true, fault->map_writable,
+				   &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1769,7 +1770,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
+	*root_level = vcpu->arch.mmu->common.root_role.level;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7121463123584..4941f53234a00 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3900,7 +3900,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
-	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+	hpa_t root_tdp = vcpu->arch.mmu->common.root.hpa;
 
 	/*
 	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff78..43451fca00605 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5720,7 +5720,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 		roots_to_free = 0;
-		if (nested_ept_root_matches(mmu->root.hpa, mmu->root.pgd,
+		if (nested_ept_root_matches(mmu->common.root.hpa, mmu->common.root.pgd,
 					    operand.eptp))
 			roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1f..1cc717a718e9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3190,7 +3190,7 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 root_hpa = mmu->root.hpa;
+	u64 root_hpa = mmu->common.root.hpa;
 
 	/* No flush required if the current context is invalid. */
 	if (!VALID_PAGE(root_hpa))
@@ -3198,7 +3198,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 
 	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
-						mmu->root_role.level));
+						mmu->common.root_role.level));
 	else
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f11..9ac8682c70ae7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8688,7 +8688,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct) {
+	if (!vcpu->arch.mmu->common.root_role.direct) {
 		/*
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
@@ -8721,7 +8721,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_release_pfn_clean(pfn);
 
 	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->root_role.direct) {
+	if (vcpu->arch.mmu->common.root_role.direct) {
 		unsigned int indirect_shadow_pages;
 
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -8789,7 +8789,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
-	if (!vcpu->arch.mmu->root_role.direct)
+	if (!vcpu->arch.mmu->common.root_role.direct)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
@@ -9089,7 +9089,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->root_role.direct) {
+		if (vcpu->arch.mmu->common.root_role.direct) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
-- 
2.17.1


