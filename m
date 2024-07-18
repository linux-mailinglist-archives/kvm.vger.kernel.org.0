Return-Path: <kvm+bounces-21895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81167935309
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36FFF282DA4
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC16149C7A;
	Thu, 18 Jul 2024 21:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnNkOmgq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322D214884F;
	Thu, 18 Jul 2024 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337175; cv=none; b=iZrvAjII5XzNKmO0h/LI21r0aenayRGU86XW4LIYctgIiKgrpy+6SbLOU1SR5axpgE13ydNn/ueIxWY4WVrTyxir8eIgUd7F+jkSMdjvcxdjFXz800bKLGFH1U1LHXFoc0bF9Qv5nKoymLydZRk4U0m/soCVzc6TLazrkTohBjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337175; c=relaxed/simple;
	bh=oN/6G2YjqIL0Q1hGMug5N8fuxYVefiTEs3HboNcccPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IBqkuTmreMZEFVpYUTONzlPEjC2iHnsdPAAkdBup8r6w4yi1Q2AyyYB92i7H7Yoen5sdtGyK0MKNl1rQ8rRj38PlPrspk8Ul/n3W+jiKwKxUDDwqmLskEVYnlalEeN6dETvj2iUSJMomuG2FQCDCUd2th0gPRgHRszlrRh+msZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnNkOmgq; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337173; x=1752873173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oN/6G2YjqIL0Q1hGMug5N8fuxYVefiTEs3HboNcccPg=;
  b=WnNkOmgqYgajFJpC6f6DfeYHpOjOIJWjBhMUZoE3iMsC7EEYYd3Qo8id
   lMr0pUyjGncHd8Iu6+W6HnKxb9nbyhY1g/ScwlKVUDVVvXxWco8QeXRUW
   +tpeHCrTd9Vk7cPwi8DiYajXurQkB8vlO65DV14AhSQzpWN3u6jh/VSnJ
   9URh9BXpbz+gf3YsAUVrv8LK4iuyNtse3jt8FBf+n9V/n/oVO/au34FOE
   YZFFwguBsQ53SEoOq/Q+773FFrcYNIcYy8vqIl7VZbmRutonunUVUVDuk
   ageOp77UEFVdKMZhPLOZZ80zMVuL788ybejO8rYiBkmS5AiqW4GOnsZoj
   g==;
X-CSE-ConnectionGUID: FqJERYKqSaS011oEuBfeFA==
X-CSE-MsgGUID: +UbttxdkRJq3i0HHPF/nww==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697445"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697445"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:48 -0700
X-CSE-ConnectionGUID: te1hf0gLSrqBt8QQtON4sw==
X-CSE-MsgGUID: A3/MeiVoR1iGVJPR+MLh0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760411"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:48 -0700
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
Subject: [PATCH v4 12/18] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
Date: Thu, 18 Jul 2024 14:12:24 -0700
Message-Id: <20240718211230.1492011-13-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add the ability for the TDP MMU to maintain a mirror of a separate
mapping.

Like other Coco technologies, TDX has the concept of private and shared
memory. For TDX the private and shared mappings are managed on separate
EPT roots. The private half is managed indirectly through calls into a
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
 mirror PT root            |     external PT root
      |                    |           |
      V                    |           V
   mirror PT   --hook to propagate-->external PT
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
KVM_DIRECT_ROOTS and KVM_MIRROR_ROOTS. Tie the usage of mirrored/direct
roots to private/shared with conditionals. It could also be implemented by
making the kvm_tdp_mmu_root_types and kvm_gfn_range_filter enum bits line
up such that conversion could be a direct assignment with a case. Don't do
this because the mapping of private to mirrored is confusing enough. So it
is worth not hiding the logic in type casting.

Cleanup the mirror root in kvm_mmu_destroy() instead of the normal place
in kvm_mmu_free_roots(), because the private root that is being cannot be
rebuilt like a normal root. It needs to persist for the lifetime of the VM.

The TDX module will also need to be provided with page tables to use for
the actual mapping being mirrored by the mirrored page tables. Allocate
these in the mapping path using the recently added
kvm_mmu_alloc_external_spt().

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
v4:
 - Use true instead of 1 when setting role.is_mirror (Binbin)
 - Handle case of invalid direct root, but valid mirror root (Yan)
 - Log typos

v3:
 - Change subject from "Make mmu notifier callbacks to check
   kvm_process" to "Propagate attr_filter to MMU notifier callbacks"
   (Paolo)
 - Remove no longer used for_each_tdp_mmu_root() (Binbin)

v2:
 - Use newly added kvm_process_to_root_types()
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              | 16 ++++++++++++
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 ++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      | 43 ++++++++++++++++++++++++++++++---
 5 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1730f94c9742..b142ef6e6676 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,6 +460,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t mirror_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 63179a4fba7b..4f6c86294f05 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -128,6 +128,15 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Checking root.hpa is sufficient even when KVM has mirror root.
+	 * We can have either:
+	 * (1) mirror_root_hpa = INVALID_PAGE, root.hpa = INVALID_PAGE
+	 * (2) mirror_root_hpa = root,         root.hpa = INVALID_PAGE
+	 * (3) mirror_root_hpa = root1,        root.hpa = root2
+	 * We don't ever have:
+	 *     mirror_root_hpa = INVALID_PAGE, root.hpa = root
+	 */
 	if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
 		return 0;
 
@@ -328,4 +337,11 @@ static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
 {
 	return kvm->arch.gfn_direct_bits;
 }
+
+static inline bool kvm_is_addr_direct(struct kvm *kvm, gpa_t gpa)
+{
+	gpa_t gpa_direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(kvm));
+
+	return !gpa_direct_bits || (gpa & gpa_direct_bits);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2f7f372a4bfe..2c73360533c2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3704,7 +3704,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	if (tdp_mmu_enabled) {
-		kvm_tdp_mmu_alloc_root(vcpu);
+		if (kvm_has_mirrored_tdp(vcpu->kvm) &&
+		    !VALID_PAGE(mmu->mirror_root_hpa))
+			kvm_tdp_mmu_alloc_root(vcpu, true);
+		kvm_tdp_mmu_alloc_root(vcpu, false);
 		return 0;
 	}
 
@@ -6290,6 +6293,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->mirror_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7265,6 +7269,12 @@ int kvm_mmu_vendor_module_init(void)
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
index 19bd891702a9..5af7355ef015 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -95,10 +95,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
 			       enum kvm_tdp_mmu_root_types types)
 {
+	if (WARN_ON_ONCE(!(types & KVM_VALID_ROOTS)))
+		return false;
+
 	if (root->role.invalid)
 		return types & KVM_INVALID_ROOTS;
+	if (likely(!is_mirror_sp(root)))
+		return types & KVM_DIRECT_ROOTS;
 
-	return true;
+	return types & KVM_MIRROR_ROOTS;
 }
 
 /*
@@ -233,7 +238,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -241,6 +246,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
+	if (mirror)
+		role.is_mirror = true;
+
 	/*
 	 * Check for an existing root before acquiring the pages lock to avoid
 	 * unnecessary serialization if multiple vCPUs are loading a new root.
@@ -292,8 +300,12 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
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
@@ -1117,8 +1129,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1156,13 +1168,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
+		if (is_mirror_sp(sp))
+			kvm_mmu_alloc_external_spt(vcpu, sp);
 
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
@@ -1817,7 +1834,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	/* Fast pf is not supported for mirrored roots  */
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, KVM_DIRECT_ROOTS);
 	struct tdp_iter iter;
 	tdp_ptep_t sptep = NULL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 8980c869e39c..5b607adca680 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,7 +10,7 @@
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
@@ -21,11 +21,48 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 enum kvm_tdp_mmu_root_types {
 	KVM_INVALID_ROOTS = BIT(0),
-
-	KVM_VALID_ROOTS = BIT(1),
+	KVM_DIRECT_ROOTS = BIT(1),
+	KVM_MIRROR_ROOTS = BIT(2),
+	KVM_VALID_ROOTS = KVM_DIRECT_ROOTS | KVM_MIRROR_ROOTS,
 	KVM_ALL_ROOTS = KVM_VALID_ROOTS | KVM_INVALID_ROOTS,
 };
 
+static inline enum kvm_tdp_mmu_root_types kvm_gfn_range_filter_to_root_types(struct kvm *kvm,
+							     enum kvm_gfn_range_filter process)
+{
+	enum kvm_tdp_mmu_root_types ret = 0;
+
+	if (!kvm_has_mirrored_tdp(kvm))
+		return KVM_DIRECT_ROOTS;
+
+	if (process & KVM_FILTER_PRIVATE)
+		ret |= KVM_MIRROR_ROOTS;
+	if (process & KVM_FILTER_SHARED)
+		ret |= KVM_DIRECT_ROOTS;
+
+	WARN_ON_ONCE(!ret);
+
+	return ret;
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct kvm_vcpu *vcpu,
+							      struct kvm_page_fault *fault)
+{
+	if (unlikely(!kvm_is_addr_direct(vcpu->kvm, fault->addr)))
+		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
+
+	return root_to_sp(vcpu->arch.mmu->root.hpa);
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
+						    enum kvm_tdp_mmu_root_types type)
+{
+	if (unlikely(type == KVM_MIRROR_ROOTS))
+		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
+
+	return root_to_sp(vcpu->arch.mmu->root.hpa);
+}
+
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
-- 
2.34.1


