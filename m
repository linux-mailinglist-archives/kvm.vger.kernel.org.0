Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673434A98BF
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358858AbiBDL55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358690AbiBDL5k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYRG8JlQ0s5Ybgj55U9BkAxflxr/b4DfF/gBfKvQtJ8=;
        b=XI0boke8puRoFHF3uwzc+WzvqSLya0tDrXydpgXW0u9O5L7AM4cuERH51fP81n/Jy1Sdl3
        73XIDypRDUuTOUifrJ+iI7N9wG/6AMP4eDFJRZXdW0xFx3RVE6+UXuoQSMS3h3G5ymP3Kz
        3e3va2/82tYyyjoqvywHg8H1tzUeBSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-JO849tj3PW-eilvJ1qxS-w-1; Fri, 04 Feb 2022 06:57:38 -0500
X-MC-Unique: JO849tj3PW-eilvJ1qxS-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EC4D1015DA0;
        Fri,  4 Feb 2022 11:57:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E861C7CAF6;
        Fri,  4 Feb 2022 11:57:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 21/23] KVM: MMU: store shadow_root_level into mmu_role
Date:   Fri,  4 Feb 2022 06:57:16 -0500
Message-Id: <20220204115718.14934-22-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_role.level is always the same value as shadow_level:

- kvm_mmu_get_tdp_level(vcpu) when going through init_kvm_tdp_mmu

- the level argument when going through kvm_init_shadow_ept_mmu

- it's assigned directly from new_role.base.level when going
  through shadow_mmu_init_context

Remove the duplication and get the level directly from the role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0085c54786c..867fc82f1de5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -433,7 +433,6 @@ struct kvm_mmu {
 	union kvm_mmu_role cpu_role;
 	union kvm_mmu_page_role mmu_role;
 	u8 root_level;
-	u8 shadow_root_level;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 51faa2c76ca5..43b99308cb0e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -112,7 +112,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 		return;
 
 	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
-					  vcpu->arch.mmu->shadow_root_level);
+					  vcpu->arch.mmu->mmu_role.level);
 }
 
 struct kvm_page_fault {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f9d876ce429..4d1fa87718f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2143,7 +2143,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 {
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
-	iterator->level = vcpu->arch.mmu->shadow_root_level;
+	iterator->level = vcpu->arch.mmu->mmu_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
@@ -3254,7 +3254,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
+		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else if (mmu->pae_root) {
@@ -3329,7 +3329,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u8 shadow_root_level = mmu->shadow_root_level;
+	u8 shadow_root_level = mmu->mmu_role.level;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3479,7 +3479,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->shadow_root_level, false);
+				      mmu->mmu_role.level, false);
 		mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
@@ -3495,7 +3495,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
@@ -3504,7 +3504,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
 
-		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
+		if (mmu->mmu_role.level == PT64_ROOT_5LEVEL) {
 			if (WARN_ON_ONCE(!mmu->pml5_root)) {
 				r = -EIO;
 				goto out_unlock;
@@ -3529,9 +3529,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
+	if (mmu->mmu_role.level == PT64_ROOT_5LEVEL)
 		mmu->root_hpa = __pa(mmu->pml5_root);
-	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	else if (mmu->mmu_role.level == PT64_ROOT_4LEVEL)
 		mmu->root_hpa = __pa(mmu->pml4_root);
 	else
 		mmu->root_hpa = __pa(mmu->pae_root);
@@ -3547,7 +3547,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
+	bool need_pml5 = mmu->mmu_role.level > PT64_ROOT_4LEVEL;
 	u64 *pml5_root = NULL;
 	u64 *pml4_root = NULL;
 	u64 *pae_root;
@@ -3559,7 +3559,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
 	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
-	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
+	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
 	/*
@@ -4145,7 +4145,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
 	 * later if necessary.
 	 */
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
+	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
 	    mmu->root_level >= PT64_ROOT_4LEVEL)
 		return cached_root_available(vcpu, new_pgd, new_role);
 
@@ -4408,17 +4408,17 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-	WARN_ON_ONCE(context->shadow_root_level < PT32E_ROOT_LEVEL);
+	WARN_ON_ONCE(context->mmu_role.level < PT32E_ROOT_LEVEL);
 
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-				context->shadow_root_level, uses_nx,
+				context->mmu_role.level, uses_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = context->mmu_role.level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
@@ -4445,7 +4445,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					context->mmu_role.level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else
@@ -4456,7 +4456,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = context->mmu_role.level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
@@ -4735,7 +4735,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -4773,7 +4772,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	context->root_level = cpu_role.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = mmu_role.level;
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
@@ -4852,8 +4850,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->cpu_role.as_u64 = new_role.as_u64;
 		context->mmu_role.word = new_role.base.word;
 
-		context->shadow_root_level = level;
-
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dd4c78833016..9fb6d983bae9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1697,7 +1697,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->shadow_root_level;
+	*root_level = vcpu->arch.mmu->mmu_role.level;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7b5345a66117..5a1d552b535b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3815,7 +3815,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		hv_track_root_tdp(vcpu, root_hpa);
 
 		cr3 = vcpu->arch.cr3;
-	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+	} else if (vcpu->arch.mmu->mmu_role.level >= PT64_ROOT_4LEVEL) {
 		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
 		/* PCID in the guest should be impossible with a 32-bit MMU. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8ac5a6fa7720..5e2c865a04ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2965,7 +2965,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 
 	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
-						mmu->shadow_root_level));
+						mmu->mmu_role.level));
 	else
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
-- 
2.31.1


