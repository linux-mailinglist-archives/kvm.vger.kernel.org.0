Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F534BE825
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380287AbiBUQXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380267AbiBUQX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E407F275F4
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KhaAC9O/5C59/coRNji/kl3043mlJPSeKxmER3DOQQ=;
        b=RqxoeCgTAkkpBPRRUeaMKU9r5VnPo7dCnvpWDd1/jw0ofCAzPZaDNKrDJDNqjm69H3lFLe
        rdHg4TauTP8v9icioebDbPAPZXe4KGbt0ecTyBZp6sWjKmCl/IYU+ZfmvPYi07IZBG1WLT
        1igNgqBZWO+fj7dvM94EpfiSjCp1+y0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-s4R2jZkeO6WtRfA3T5yB2Q-1; Mon, 21 Feb 2022 11:22:56 -0500
X-MC-Unique: s4R2jZkeO6WtRfA3T5yB2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9DDF2F4A;
        Mon, 21 Feb 2022 16:22:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BF5584A0E;
        Mon, 21 Feb 2022 16:22:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 22/25] KVM: x86/mmu: replace root_level with cpu_mode.base.level
Date:   Mon, 21 Feb 2022 11:22:40 -0500
Message-Id: <20220221162243.683208-23-pbonzini@redhat.com>
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

Remove another duplicate field of struct kvm_mmu.  This time it's
the root level for page table walking; the separate field is
always initialized as cpu_mode.base.level, so its users can look
up the CPU mode directly instead.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 18 +++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81897aa4e669..ec89b1a488c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -431,7 +431,6 @@ struct kvm_mmu {
 	struct kvm_mmu_root_info root;
 	union kvm_mmu_paging_mode cpu_mode;
 	union kvm_mmu_page_role root_role;
-	u8 root_level;
 	bool direct_map;
 	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c33879f23e94..0c88d4206715 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2130,7 +2130,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->level = vcpu->arch.mmu->root_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
-	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
+	    vcpu->arch.mmu->cpu_mode.base.level < PT64_ROOT_4LEVEL &&
 	    !vcpu->arch.mmu->direct_map)
 		iterator->level = PT32E_ROOT_LEVEL;
 
@@ -3440,7 +3440,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * On SVM, reading PDPTRs might access guest memory, which might fault
 	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
 	 */
-	if (mmu->root_level == PT32E_ROOT_LEVEL) {
+	if (mmu->cpu_mode.base.level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			pdptrs[i] = mmu->get_pdptr(vcpu, i);
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
@@ -3464,7 +3464,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * Do we shadow a long mode page table? If so we need to
 	 * write-protect the guests page table root.
 	 */
-	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (mmu->cpu_mode.base.level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      mmu->root_role.level, false);
 		mmu->root.hpa = root;
@@ -3503,7 +3503,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-		if (mmu->root_level == PT32E_ROOT_LEVEL) {
+		if (mmu->cpu_mode.base.level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
 				mmu->pae_root[i] = INVALID_PAE_ROOT;
 				continue;
@@ -3545,7 +3545,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
+	if (mmu->direct_map || mmu->cpu_mode.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
@@ -3642,7 +3642,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (vcpu->arch.mmu->cpu_mode.base.level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root.hpa;
 		sp = to_shadow_page(root);
 
@@ -4348,7 +4348,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
-				context->root_level, is_efer_nx(context),
+				context->cpu_mode.base.level, is_efer_nx(context),
 				guest_can_use_gbpages(vcpu),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
@@ -4752,7 +4752,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cp
 	context->get_guest_pgd = kvm_get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = cpu_mode.base.level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4782,7 +4781,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = cpu_mode.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
 	reset_shadow_zero_bits_mask(vcpu, context);
@@ -4874,7 +4872,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
 		context->invlpg = ept_invlpg;
-		context->root_level = level;
 		context->direct_map = false;
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -4909,7 +4906,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode
 	g_context->get_guest_pgd     = kvm_get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
-	g_context->root_level        = new_mode.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7c0fa115bd56..bdfd38b0f8e6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -361,7 +361,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
-	walker->level = mmu->root_level;
+	walker->level = mmu->cpu_mode.base.level;
 	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
@@ -656,7 +656,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
-	top_level = vcpu->arch.mmu->root_level;
+	top_level = vcpu->arch.mmu->cpu_mode.base.level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
 	/*
-- 
2.31.1


