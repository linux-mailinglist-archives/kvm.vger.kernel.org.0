Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B7E500751
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbiDNHnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiDNHme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0991A56C0F
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPd6WmAB+t2TGwAjwqQzAiGdMhNaFBOyw9AqxFcIvt8=;
        b=EarYv3dB9Q3n67H8xVCi/KCGIXW90B3lTiGMz3JhMT+82DH9eOY9z8ONDcjhR0v+PzfoaL
        TCgUATHjZKhwF8UPmCGuQC4+4F+kUd5NvlyH+GsuBNyCH5omW8VpJRVs/rk0ErUvbYvYq0
        JmI0T+g51OufjwhsZU7m6/d6m7twyLk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-LZ3vH8V9OuKXva30gQ1-KQ-1; Thu, 14 Apr 2022 03:40:05 -0400
X-MC-Unique: LZ3vH8V9OuKXva30gQ1-KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99004296A61A;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C6FF7B47;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 21/22] KVM: x86/mmu: replace root_level with cpu_role.base.level
Date:   Thu, 14 Apr 2022 03:39:59 -0400
Message-Id: <20220414074000.31438-22-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove another duplicate field of struct kvm_mmu.  This time it's
the root level for page table walking; the separate field is
always initialized as cpu_role.base.level, so its users can look
up the CPU mode directly instead.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 18 +++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 11055a213a1b..3e3fcffe1b88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -436,7 +436,6 @@ struct kvm_mmu {
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
-	u8 root_level;
 	bool direct_map;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54cc033e0646..507fcf3a5080 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2132,7 +2132,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 	iterator->level = vcpu->arch.mmu->root_role.level;
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
-	    vcpu->arch.mmu->root_level < PT64_ROOT_4LEVEL &&
+	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
 	    !vcpu->arch.mmu->direct_map)
 		iterator->level = PT32E_ROOT_LEVEL;
 
@@ -3448,7 +3448,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * On SVM, reading PDPTRs might access guest memory, which might fault
 	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
 	 */
-	if (mmu->root_level == PT32E_ROOT_LEVEL) {
+	if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
 			pdptrs[i] = mmu->get_pdptr(vcpu, i);
 			if (!(pdptrs[i] & PT_PRESENT_MASK))
@@ -3472,7 +3472,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * Do we shadow a long mode page table? If so we need to
 	 * write-protect the guests page table root.
 	 */
-	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      mmu->root_role.level, false);
 		mmu->root.hpa = root;
@@ -3511,7 +3511,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-		if (mmu->root_level == PT32E_ROOT_LEVEL) {
+		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
 			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
 				mmu->pae_root[i] = INVALID_PAE_ROOT;
 				continue;
@@ -3553,7 +3553,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
+	if (mmu->direct_map || mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
 
@@ -3658,7 +3658,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 
 	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
+	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
 		hpa_t root = vcpu->arch.mmu->root.hpa;
 		sp = to_shadow_page(root);
 
@@ -4374,7 +4374,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
-				context->root_level, is_efer_nx(context),
+				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use_gbpages(vcpu),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
@@ -4782,7 +4782,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = cpu_role.base.level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4812,7 +4811,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = cpu_role.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
 	reset_shadow_zero_bits_mask(vcpu, context);
@@ -4909,7 +4907,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->gva_to_gpa = ept_gva_to_gpa;
 		context->sync_page = ept_sync_page;
 		context->invlpg = ept_invlpg;
-		context->root_level = level;
 		context->direct_map = false;
 		update_permission_bitmask(context, true);
 		context->pkru_mask = 0;
@@ -4945,7 +4942,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	g_context->get_guest_pgd     = get_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
-	g_context->root_level        = new_mode.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 24157f637bd7..66f1acf153c4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -319,7 +319,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
-	walker->level = mmu->root_level;
+	walker->level = mmu->cpu_role.base.level;
 	pte           = mmu->get_guest_pgd(vcpu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
@@ -621,7 +621,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
-	top_level = vcpu->arch.mmu->root_level;
+	top_level = vcpu->arch.mmu->cpu_role.base.level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
 	/*
-- 
2.31.1


