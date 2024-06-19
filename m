Return-Path: <kvm+bounces-20029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D217E90F928
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D2A0B2469D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516D41849C0;
	Wed, 19 Jun 2024 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jpx26d+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555B71684B3;
	Wed, 19 Jun 2024 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836594; cv=none; b=QbpR7X39PzyVHOqXzPZZI71DNj5sV2TIz0GGSEY5M59fSViK1tGMWQ+Z4ecHEV66oc7pbgRR9djmyB3tNMmyWUjCMnK85PbrGQ3XhpsmRN7n4FxX/utoOWUVCH0dv7u+EBH9dxZ8D2E7axE2tYr/j76nQhEQfghKmN2pTmNhbz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836594; c=relaxed/simple;
	bh=KEDYj2OULOJrYGGvHQmadnjT7J7sjw+V/dL18dAbNNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1APRdbmTSbADaTdZmEEHizLZOKFvECk9hVhtO5QpmCU0hO1jfy3qlwQ8dMVUq2bPKW+e1Vtm/rhJvqNATuuUlq9i3/cRGYYBXFnngdmdWik1CgZ7i/DSsAB0kq1l9RLPO7AK/pVnVz/0SPaZJtpG83v1+6KEGMay025luidtWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jpx26d+R; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836592; x=1750372592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KEDYj2OULOJrYGGvHQmadnjT7J7sjw+V/dL18dAbNNQ=;
  b=Jpx26d+R5ngLY9i1zcON4K+Y3mzXggEqhRklJG2UZP/WZ4/bLHNvoN8o
   0PcUShcli/qxh2Vgma7CmjMcYtcuqbPksvyNzhwNkoAB/ezozTIZV60pE
   ZmlavHpOn8XXeZksqGy6XRkSA9hlk5FB7uZ7Mm2ri5ffDafLrE3j4iZs4
   TyXRomM0uWylIHSrh/LKYwZyD+AiBFaubXTmd7QElj3pJ60i0qVpDwDQx
   DDFYD2gXUSPuAW3QpOwkbcow9exwQkf7Rh6PoQyu5OMWIS68S3UTz3bG/
   0jbrXU3GqnCVLfo2PmcTGBaOeIhdJeB1EHnxGwDVjHstot27asx6Cy6n6
   g==;
X-CSE-ConnectionGUID: HHDaUNk/SEep6NPU62LWRg==
X-CSE-MsgGUID: rZNyV+mRQ5WJRDV/FVEfTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931985"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931985"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
X-CSE-ConnectionGUID: Z85og9utRaWnfEfMX4rbIA==
X-CSE-MsgGUID: vlqbtrHbRqu2Q3F6bQP2fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793363"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:23 -0700
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
Subject: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
Date: Wed, 19 Jun 2024 15:36:10 -0700
Message-Id: <20240619223614.290657-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
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
kvm_mmu_alloc_private_spt().

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
TDX MMU Prep v3:
 - Remove handle_changed_spte() changes
 - Drop kvm_on_mirror()/kvm_on_direct(), open code (Paolo)
 - Rename tdp_mmu_get_fault_root_type() -> tdp_mmu_get_root_for_fault()  (Paolo)
 - Use fault->addr (in helper) to determine direct vs mirror root (Paolo)
 - Rename process -> filter (Paolo)

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
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              |  7 ++++++
 arch/x86/kvm/mmu/mmu.c          | 11 ++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 ++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      | 43 ++++++++++++++++++++++++++++++---
 5 files changed, 84 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e07eff06a58..d67e88a69fc4 100644
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
index 63179a4fba7b..7b12ba761c51 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -328,4 +328,11 @@ static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
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
index e9c1783a8743..287dcc2685e4 100644
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
index 2200bdc7681f..a0010c62425f 100644
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
+		role.is_mirror = 1;
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
@@ -1113,8 +1125,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1152,13 +1164,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
@@ -1813,7 +1830,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	/* Fast pf is not supported for mirrored roots  */
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, KVM_DIRECT_ROOTS);
 	struct tdp_iter iter;
 	tdp_ptep_t sptep = NULL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index b887c225ff24..2903f03a34be 100644
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


