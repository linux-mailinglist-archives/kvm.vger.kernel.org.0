Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4734BE202
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380353AbiBUQXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380266AbiBUQX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3EAF27170
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R0A3zguA6WQgIcTBIC07MyIgv+7xo6imyD0/mQM+TIw=;
        b=PjDNY+HAq5i9JbKlcFDG65cSHpBot21MkNaE9fff1K4YqQFatWKmcpL0MP1jr59kIPllF2
        SGbqQla4WCwDIy0L3jwPJDdmvOak7ovOn6/Hak/LerDoo9qMjUELz4ekJFbVjDFGJFY+1V
        oNJaAXWc3dG40oL+uNEXlMFi+sbDzGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-QrveasqgO3iegvZSII8QFw-1; Mon, 21 Feb 2022 11:22:56 -0500
X-MC-Unique: QrveasqgO3iegvZSII8QFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ED9B801B0B;
        Mon, 21 Feb 2022 16:22:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8D4B84A0E;
        Mon, 21 Feb 2022 16:22:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 21/25] KVM: x86/mmu: replace shadow_root_level with root_role.level
Date:   Mon, 21 Feb 2022 11:22:39 -0500
Message-Id: <20220221162243.683208-22-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

root_role.level is always the same value as shadow_level:

- it's kvm_mmu_get_tdp_level(vcpu) when going through init_kvm_tdp_mmu

- it's the level argument when going through kvm_init_shadow_ept_mmu

- it's assigned directly from new_role.base.level when going
  through shadow_mmu_init_context

Remove the duplication and get the level directly from the role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 33 ++++++++++++++-------------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b8b115b2038f..81897aa4e669 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -432,7 +432,6 @@ struct kvm_mmu {
 	union kvm_mmu_paging_mode cpu_mode;
 	union kvm_mmu_page_role root_role;
 	u8 root_level;
-	u8 shadow_root_level;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6ee4436e46f1..596ac2d424fc 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -113,7 +113,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 		return;
 
 	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
-					  vcpu->arch.mmu->shadow_root_level);
+					  vcpu->arch.mmu->root_role.level);
 }
 
 extern unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a7028c2ae5c7..c33879f23e94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2127,7 +2127,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 {
 	iterator->addr = addr;
 	iterator->shadow_addr = root;
-	iterator->level = vcpu->arch.mmu->shadow_root_level;
+	iterator->level = vcpu->arch.mmu->root_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
@@ -3316,7 +3316,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u8 shadow_root_level = mmu->shadow_root_level;
+	u8 shadow_root_level = mmu->root_role.level;
 	hpa_t root;
 	unsigned i;
 	int r;
@@ -3466,7 +3466,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 */
 	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->shadow_root_level, false);
+				      mmu->root_role.level, false);
 		mmu->root.hpa = root;
 		goto set_root_pgd;
 	}
@@ -3482,7 +3482,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		if (WARN_ON_ONCE(!mmu->pml4_root)) {
@@ -3491,7 +3491,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
 
-		if (mmu->shadow_root_level == PT64_ROOT_5LEVEL) {
+		if (mmu->root_role.level == PT64_ROOT_5LEVEL) {
 			if (WARN_ON_ONCE(!mmu->pml5_root)) {
 				r = -EIO;
 				goto out_unlock;
@@ -3516,9 +3516,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
-	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
+	if (mmu->root_role.level == PT64_ROOT_5LEVEL)
 		mmu->root.hpa = __pa(mmu->pml5_root);
-	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	else if (mmu->root_role.level == PT64_ROOT_4LEVEL)
 		mmu->root.hpa = __pa(mmu->pml4_root);
 	else
 		mmu->root.hpa = __pa(mmu->pae_root);
@@ -3534,7 +3534,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
+	bool need_pml5 = mmu->root_role.level > PT64_ROOT_4LEVEL;
 	u64 *pml5_root = NULL;
 	u64 *pml4_root = NULL;
 	u64 *pae_root;
@@ -3546,7 +3546,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
 	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
-	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
+	    mmu->root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
 	/*
@@ -4420,18 +4420,18 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-	WARN_ON_ONCE(context->shadow_root_level < PT32E_ROOT_LEVEL);
+	WARN_ON_ONCE(context->root_role.level < PT32E_ROOT_LEVEL);
 
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-				context->shadow_root_level,
+				context->root_role.level,
 				context->root_role.efer_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = context->root_role.level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
@@ -4458,7 +4458,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					context->root_role.level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else
@@ -4469,7 +4469,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = context->root_role.level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
@@ -4748,7 +4748,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cp
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = kvm_get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -4786,8 +4785,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	context->root_level = cpu_mode.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = root_role.level;
-
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
@@ -4873,8 +4870,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->cpu_mode.as_u64 = new_mode.as_u64;
 		context->root_role.word = new_mode.base.word;
 
-		context->shadow_root_level = level;
-
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c18ad86c9a82..ab8c09db4c19 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1697,7 +1697,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->shadow_root_level;
+	*root_level = vcpu->arch.mmu->root_role.level;
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa841..d169221d9305 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3863,7 +3863,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		hv_track_root_tdp(vcpu, root_hpa);
 
 		cr3 = vcpu->arch.cr3;
-	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+	} else if (vcpu->arch.mmu->root_role.level >= PT64_ROOT_4LEVEL) {
 		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
 		/* PCID in the guest should be impossible with a 32-bit MMU. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b183dfc41d74..00a79b82fa46 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2960,7 +2960,7 @@ static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 
 	if (enable_ept)
 		ept_sync_context(construct_eptp(vcpu, root_hpa,
-						mmu->shadow_root_level));
+						mmu->root_role.level));
 	else
 		vpid_sync_context(vmx_get_current_vpid(vcpu));
 }
-- 
2.31.1


