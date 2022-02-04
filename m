Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C24A98C3
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358977AbiBDL6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:58:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358724AbiBDL5n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sArPDuM16yDbcx1bDIyT7nyZtdEl0hoR3jX/2tqV6pM=;
        b=hjLFnGCLHVuLRRcZhoaGRzowTHonBjn90K+JtBoUsE+etQz7RQ6eCpSDPHYVbPxXAxcwsk
        1L9d0lLl/Tn7lHM5zRAxPPNcO5JpnCYgcjXjm/Ge4zmoepnwvtXdL21zxd5M7GGjBgox2R
        d5RsXk8w3onRemWm2FmE+0uCwQ7FJPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-cy8ZjzniPEy0wBs-N2eeZg-1; Fri, 04 Feb 2022 06:57:39 -0500
X-MC-Unique: cy8ZjzniPEy0wBs-N2eeZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88FD81015DA2;
        Fri,  4 Feb 2022 11:57:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C8277CAEF;
        Fri,  4 Feb 2022 11:57:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 23/23] KVM: MMU: replace direct_map with mmu_role.direct
Date:   Fri,  4 Feb 2022 06:57:18 -0500
Message-Id: <20220204115718.14934-24-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

direct_map is always equal to the role's direct field:

- for shadow paging, direct_map is true if CR0.PG=0 and mmu_role.direct is
copied from cpu_role.base.direct

- for TDP, it is always true and mmu_role.direct is also always true

- for shadow EPT, it is always false and mmu_role.direct is also always
false

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++----------------
 arch/x86/kvm/x86.c              | 12 ++++++------
 4 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c86a2beee92a..647b3f6d02d0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -432,7 +432,6 @@ struct kvm_mmu {
 	gpa_t root_pgd;
 	union kvm_mmu_role cpu_role;
 	union kvm_mmu_page_role mmu_role;
-	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a6541d6a424..ce55fad99671 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2045,7 +2045,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
+	bool direct_mmu = vcpu->arch.mmu->mmu_role.direct;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2147,7 +2147,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->direct_map)
+	    !vcpu->arch.mmu->mmu_role.direct)
 		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
@@ -2523,7 +2523,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->mmu_role.direct)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
@@ -3255,7 +3255,8 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	if (free_active_root) {
 		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
-		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
+		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
+		     mmu->mmu_role.direct)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
@@ -3558,7 +3559,8 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
+	if (mmu->mmu_role.direct ||
+	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
@@ -3647,7 +3649,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->mmu_role.direct)
 		return;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
@@ -3872,7 +3874,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->direct_map;
+	arch.direct_map = vcpu->arch.mmu->mmu_role.direct;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
@@ -4090,7 +4092,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->direct_map = true;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -4641,7 +4642,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->direct_map = false;
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
@@ -4650,7 +4650,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->direct_map = false;
 }
 
 static union kvm_mmu_role
@@ -4735,7 +4734,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -4852,7 +4850,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
 		context->invlpg = ept_invlpg;
-		context->direct_map = false;
+
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
@@ -4967,13 +4965,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->mmu_role.direct);
 	if (r)
 		goto out;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->mmu_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
@@ -5176,7 +5174,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-	bool direct = vcpu->arch.mmu->direct_map;
+	bool direct = vcpu->arch.mmu->mmu_role.direct;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
@@ -5207,7 +5205,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	 * paging in both guests. If true, we simply unprotect the page
 	 * and resume the guest.
 	 */
-	if (vcpu->arch.mmu->direct_map &&
+	if (vcpu->arch.mmu->mmu_role.direct &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 657aa646871e..b910fa34e57e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7978,7 +7978,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
-	if (!vcpu->arch.mmu->direct_map) {
+	if (!vcpu->arch.mmu->mmu_role.direct) {
 		/*
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
@@ -8011,7 +8011,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_release_pfn_clean(pfn);
 
 	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->direct_map) {
+	if (vcpu->arch.mmu->mmu_role.direct) {
 		unsigned int indirect_shadow_pages;
 
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -8079,7 +8079,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
-	if (!vcpu->arch.mmu->direct_map)
+	if (!vcpu->arch.mmu->mmu_role.direct)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
@@ -8359,7 +8359,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->direct_map) {
+		if (vcpu->arch.mmu->mmu_role.direct) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
@@ -12196,7 +12196,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if ((vcpu->arch.mmu->direct_map != work->arch.direct_map) ||
+	if ((vcpu->arch.mmu->mmu_role.direct != work->arch.direct_map) ||
 	      work->wakeup_all)
 		return;
 
@@ -12204,7 +12204,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
-	if (!vcpu->arch.mmu->direct_map &&
+	if (!vcpu->arch.mmu->mmu_role.direct &&
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-- 
2.31.1

