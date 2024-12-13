Return-Path: <kvm+bounces-33778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C40AD9F1703
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2BE61606C6
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA8F1F6692;
	Fri, 13 Dec 2024 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5dGpcrK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DBF1F5408
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 19:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734119859; cv=none; b=Sg9sUB5ZGmZOtL8yt8L5zxizpUJtOO85cfvXntMHpoJ4Yf6hhVL4WhOT0LKwtt99wjaX6SwMgNCDHlLJsPhJESDNxwZsU9R5nR/qdYpMMiAYbqF14RYdOcDbVHXbjjInQ83e8NGstJlcFy8loFjudrg3NuHixZjRpGgJiiPxyrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734119859; c=relaxed/simple;
	bh=dqrcWNy7Gp8YC+OPGX53ld+k1FgAsC4ymw4Nf3/hFBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqWxG3Y/hAXgdweLVBJUb2mxT3a4m22vih4qeiuDiRZfCayXiKVO1sNXpCqXPNsM6GwcJeMH51Oof55NRlCPzeIK3j7GR+ktuAK2VVMg/KlPrw5bE9uC0+vcQjEovH+pKf2hYLopk1HRW26AI+7Qd9rv5fbxFVuknAf1fQ6+BWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U5dGpcrK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734119855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Sjg1JQiM+ox4tv8uLB7gxE4UZxxVy2WgFqBNERNrSs=;
	b=U5dGpcrKhdvnHu3kt/PnYA5LA6J/t+UPFAHdqvP9duFF1cILtXxdfag9LfGws5JyvHcXbm
	BoMUvipimB/3k886QU/NO+UcIGv/XISf5dMjg8RM7u4v8c5S4nHNROY+sS7g+cWOXjYt7p
	GkmcTpJT9fXmLAaJLHQvXS8D/ust/fo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-OYyeI7O7N76B_ohU0ICZxA-1; Fri,
 13 Dec 2024 14:57:30 -0500
X-MC-Unique: OYyeI7O7N76B_ohU0ICZxA-1
X-Mimecast-MFC-AGG-ID: OYyeI7O7N76B_ohU0ICZxA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9B1E195608A;
	Fri, 13 Dec 2024 19:57:28 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CABB01956086;
	Fri, 13 Dec 2024 19:57:27 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: yan.y.zhao@intel.com,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 12/18] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
Date: Fri, 13 Dec 2024 14:57:05 -0500
Message-ID: <20241213195711.316050-13-pbonzini@redhat.com>
In-Reply-To: <20241213195711.316050-1-pbonzini@redhat.com>
References: <20241213195711.316050-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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
Message-ID: <20240718211230.1492011-13-rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.h              | 16 ++++++++++++
 arch/x86/kvm/mmu/mmu.c          | 12 ++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 31 ++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      | 43 ++++++++++++++++++++++++++++++---
 5 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 95f2b0890a58..dc8e4460a4bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -458,6 +458,7 @@ struct kvm_mmu {
 	int (*sync_spte)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp, int i);
 	struct kvm_mmu_root_info root;
+	hpa_t mirror_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 091002975374..d1775a38ffd3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -104,6 +104,15 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
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
 
@@ -297,4 +306,11 @@ static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
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
index 9b6c28b30298..4594fbdd0dcc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3676,7 +3676,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	if (tdp_mmu_enabled) {
-		kvm_tdp_mmu_alloc_root(vcpu);
+		if (kvm_has_mirrored_tdp(vcpu->kvm) &&
+		    !VALID_PAGE(mmu->mirror_root_hpa))
+			kvm_tdp_mmu_alloc_root(vcpu, true);
+		kvm_tdp_mmu_alloc_root(vcpu, false);
 		return 0;
 	}
 
@@ -6293,6 +6296,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->mirror_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -7241,6 +7245,12 @@ int kvm_mmu_vendor_module_init(void)
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
index 297d05e5a4cd..d17a3cf1596d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -101,7 +101,9 @@ static bool tdp_mmu_root_match(struct kvm_mmu_page *root,
 	if (root->role.invalid && !(types & KVM_INVALID_ROOTS))
 		return false;
 
-	return true;
+	if (likely(!is_mirror_sp(root)))
+		return types & KVM_DIRECT_ROOTS;
+	return types & KVM_MIRROR_ROOTS;
 }
 
 /*
@@ -236,7 +238,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
 }
 
-void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
+void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role role = mmu->root_role;
@@ -244,6 +246,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
+	if (mirror)
+		role.is_mirror = true;
+
 	/*
 	 * Check for an existing root before acquiring the pages lock to avoid
 	 * unnecessary serialization if multiple vCPUs are loading a new root.
@@ -295,8 +300,12 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
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
@@ -1078,8 +1087,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1117,13 +1126,18 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
@@ -1768,7 +1782,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
-	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
+	/* Fast pf is not supported for mirrored roots  */
+	struct kvm_mmu_page *root = tdp_mmu_get_root(vcpu, KVM_DIRECT_ROOTS);
 	struct tdp_iter iter;
 	tdp_ptep_t sptep = NULL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index a2028d036c0c..9887441cd703 100644
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
2.43.5



