Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D44500745
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbiDNHnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240498AbiDNHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A77BD57147
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0BwCNQ8VtdLWkqO+3jKpyvN6wYwYXqjBMFCI2If12kA=;
        b=hdDL94D1BcepCrYoSgaYxM7Ym8pPx034FnOAT6NR2KqrXrq47IemD4QEPd0ZAWdYz7C+Mj
        UH3fwPD13R+/6mce8P+PanZa1j2AtR0BYCnVWDFdA9Nkcgqo0EtASiaVilPW6/0AJHjfZ2
        YodQDTVBxe5dAKI/JTOXT9AkylB7z1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-4u_Zl_UaPt-_9mYhdrnRLg-1; Thu, 14 Apr 2022 03:40:05 -0400
X-MC-Unique: 4u_Zl_UaPt-_9mYhdrnRLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE4FF804191;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A148B7AC3;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 22/22] KVM: x86/mmu: replace direct_map with root_role.direct
Date:   Thu, 14 Apr 2022 03:40:00 -0400
Message-Id: <20220414074000.31438-23-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

direct_map is always equal to the direct field of the root page's role:

- for shadow paging, direct_map is true if CR0.PG=0 and root_role.direct is
copied from cpu_role.base.direct

- for TDP, it is always true and root_role.direct is also always true

- for shadow TDP, it is always false and root_role.direct is also always
false

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 27 ++++++++++++---------------
 arch/x86/kvm/x86.c              | 12 ++++++------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e3fcffe1b88..2c20f715f009 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -436,7 +436,6 @@ struct kvm_mmu {
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
-	bool direct_map;
 
 	/*
 	* The pkru_mask indicates if protection key checks are needed.  It
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 507fcf3a5080..69a30d6d1e2b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2028,7 +2028,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     int direct,
 					     unsigned int access)
 {
-	bool direct_mmu = vcpu->arch.mmu->direct_map;
+	bool direct_mmu = vcpu->arch.mmu->root_role.direct;
 	union kvm_mmu_page_role role;
 	struct hlist_head *sp_list;
 	unsigned quadrant;
@@ -2133,7 +2133,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->direct_map)
+	    !vcpu->arch.mmu->root_role.direct)
 		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
@@ -2515,7 +2515,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->root_role.direct)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
@@ -3553,7 +3553,8 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
+	if (mmu->root_role.direct ||
+	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
@@ -3650,7 +3651,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->root_role.direct)
 		return;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
@@ -3880,7 +3881,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->direct_map;
+	arch.direct_map = vcpu->arch.mmu->root_role.direct;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
@@ -4098,7 +4099,6 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->direct_map = true;
 }
 
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
@@ -4680,7 +4680,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->direct_map = false;
 }
 
 static void paging32_init_context(struct kvm_mmu *context)
@@ -4689,7 +4688,6 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->direct_map = false;
 }
 
 static union kvm_cpu_role
@@ -4778,7 +4776,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
-	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
@@ -4907,7 +4904,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
 		context->invlpg = ept_invlpg;
-		context->direct_map = false;
+
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
@@ -5023,13 +5020,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	if (vcpu->arch.mmu->direct_map)
+	if (vcpu->arch.mmu->root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
@@ -5286,7 +5283,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-	bool direct = vcpu->arch.mmu->direct_map;
+	bool direct = vcpu->arch.mmu->root_role.direct;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
@@ -5317,7 +5314,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	 * paging in both guests. If true, we simply unprotect the page
 	 * and resume the guest.
 	 */
-	if (vcpu->arch.mmu->direct_map &&
+	if (vcpu->arch.mmu->root_role.direct &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9866853ca320..ab336f7c82e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8101,7 +8101,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
-	if (!vcpu->arch.mmu->direct_map) {
+	if (!vcpu->arch.mmu->root_role.direct) {
 		/*
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
@@ -8134,7 +8134,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_release_pfn_clean(pfn);
 
 	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->direct_map) {
+	if (vcpu->arch.mmu->root_role.direct) {
 		unsigned int indirect_shadow_pages;
 
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -8202,7 +8202,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
-	if (!vcpu->arch.mmu->direct_map)
+	if (!vcpu->arch.mmu->root_role.direct)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
@@ -8482,7 +8482,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->direct_map) {
+		if (vcpu->arch.mmu->root_role.direct) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
@@ -12360,7 +12360,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if ((vcpu->arch.mmu->direct_map != work->arch.direct_map) ||
+	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
 	      work->wakeup_all)
 		return;
 
@@ -12368,7 +12368,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
-	if (!vcpu->arch.mmu->direct_map &&
+	if (!vcpu->arch.mmu->root_role.direct &&
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-- 
2.31.1

