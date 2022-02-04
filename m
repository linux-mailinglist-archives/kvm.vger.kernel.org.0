Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85B4A98C4
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358957AbiBDL6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:58:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358720AbiBDL5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWySmgXD0THqSjFsrBr0x42/E6z0T7ApfXzZ7tuhiKQ=;
        b=CT6wLoKRW7Yv6s90TVzXyKZa37twVYb+kOI7T712TlUDndh/f/CNTY0HyLhxXJ4rdBaKfb
        zaZKVDL0EXgAtKXNib215cfKFdztVl3C5suSVEuftTPMt9lzTlV/vjTH9eTmpVpNd6BvGr
        N/pKwPyqSdUjylpT9qBV48aZ4NWSEc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-fG1B0xU_MRSbsTm2xZOd6Q-1; Fri, 04 Feb 2022 06:57:39 -0500
X-MC-Unique: fG1B0xU_MRSbsTm2xZOd6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 015F683DD22;
        Fri,  4 Feb 2022 11:57:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89A567CAD8;
        Fri,  4 Feb 2022 11:57:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 22/23] KVM: MMU: use cpu_role for root_level
Date:   Fri,  4 Feb 2022 06:57:17 -0500
Message-Id: <20220204115718.14934-23-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove another duplicate field of struct kvm_mmu.  This time it's
the root level for page table walking; we were already initializing
it mostly as cpu_role.base.level, but the field still existed;
remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 22 +++++++++-------------
 arch/x86/kvm/mmu/mmu_audit.c    |  6 +++---
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 4 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 867fc82f1de5..c86a2beee92a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -432,7 +432,6 @@ struct kvm_mmu {
 	gpa_t root_pgd;
 	union kvm_mmu_role cpu_role;
 	union kvm_mmu_page_role mmu_role;
-	u8 root_level;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4d1fa87718f8..5a6541d6a424 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2146,7 +2146,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->level = vcpu->arch.mmu->mmu_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
-	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
+	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
 	    !vcpu->arch.mmu->direct_map)
 		iterator->level = PT32E_ROOT_LEVEL;
 
@@ -3255,7 +3255,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	if (free_active_root) {
 		if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
-		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
+		    (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
@@ -3453,7 +3453,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * On SVM, reading PDPTRs might access guest memory, which might fault
 	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
 	 */
-	if (mmu->root_level == PT32E_ROOT_LEVEL) {
+	if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			pdptrs[i] = mmu->get_pdptr(vcpu, i);
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
@@ -3477,7 +3477,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * Do we shadow a long mode page table? If so we need to
 	 * write-protect the guests page table root.
 	 */
-	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      mmu->mmu_role.level, false);
 		mmu->root_hpa = root;
@@ -3516,7 +3516,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-		if (mmu->root_level == PT32E_ROOT_LEVEL) {
+		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
 				mmu->pae_root[i] = INVALID_PAE_ROOT;
 				continue;
@@ -3558,7 +3558,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
+	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->mmu_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
@@ -3655,7 +3655,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root_hpa;
 		sp = to_shadow_page(root);
 
@@ -4146,7 +4146,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 * later if necessary.
 	 */
 	if (mmu->mmu_role.level >= PT64_ROOT_4LEVEL &&
-	    mmu->root_level >= PT64_ROOT_4LEVEL)
+	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL)
 		return cached_root_available(vcpu, new_pgd, new_role);
 
 	return false;
@@ -4335,7 +4335,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
-				context->root_level, is_efer_nx(context),
+				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use_gbpages(vcpu),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
@@ -4739,7 +4739,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = cpu_role.base.level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4769,7 +4768,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = cpu_role.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
 }
@@ -4854,7 +4852,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
 		context->invlpg = ept_invlpg;
-		context->root_level = level;
 		context->direct_map = false;
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -4889,7 +4886,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role new_ro
 	g_context->get_guest_pgd     = get_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
-	g_context->root_level        = new_role.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index f31fdb874f1f..eb9c59fcb957 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -59,11 +59,11 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
 		return;
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root_hpa;
 
 		sp = to_shadow_page(root);
-		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
+		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->cpu_role.base.level);
 		return;
 	}
 
@@ -119,7 +119,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
 		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
-			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
+			     "ent %llxn", vcpu->arch.mmu->cpu_role.base.level, pfn,
 			     hpa, *sptep);
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 847c4339e4d9..dd0b6f83171f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -361,7 +361,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
-	walker->level = mmu->root_level;
+	walker->level = mmu->cpu_role.base.level;
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
@@ -656,7 +656,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
-	top_level = vcpu->arch.mmu->root_level;
+	top_level = vcpu->arch.mmu->cpu_role.base.level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
 	/*
-- 
2.31.1


