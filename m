Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121AF500754
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbiDNHn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240472AbiDNHmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC30156C04
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=40lIAGSpAB/FfFBfKetPwwW4R/AL1PekHYbsZB51kfo=;
        b=KNPJ4fYTWDo0iY/pwIl8e5meq6DHSaNJau6/dtl1DxD8gkxTTc+kCVWrbINnq/cX/S2LN8
        bc4G76N6CPIx+U0jvWNnTqz+VXC1jI8CoLz3IFPWSMPf+0n+GeD6QZk2Dw8r9PxYoAu3Qx
        fbwfLyU362WrjZFNZ15eUa2PN6uDH0U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-cWhFOQjyMhyKYnWMjX0BOw-1; Thu, 14 Apr 2022 03:40:02 -0400
X-MC-Unique: cWhFOQjyMhyKYnWMjX0BOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DB461C06915;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F64C40D1DB;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 07/22] KVM: x86/mmu: split cpu_role from mmu_role
Date:   Thu, 14 Apr 2022 03:39:45 -0400
Message-Id: <20220414074000.31438-8-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

Snapshot the state of the processor registers that govern page walk into
a new field of struct kvm_mmu.  This is a more natural representation
than having it *mostly* in mmu_role but not exclusively; the delta
right now is represented in other fields, such as root_level.

The nested MMU now has only the CPU role; and in fact the new function
kvm_calc_cpu_role is analogous to the previous kvm_calc_nested_mmu_role,
except that it has role.base.direct equal to !CR0.PG.  For a walk-only
MMU, "direct" has no meaning, but we set it to !CR0.PG so that
role.ext.cr0_pg can go away in a future patch.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/mmu/mmu.c          | 109 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
 3 files changed, 70 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e46bd289e5df..50edf52a3ef6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -438,6 +438,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
+	union kvm_mmu_role cpu_role;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7f156da3ca93..0f8c4d8f2081 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -222,7 +222,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
 static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
-	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
+	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
 }
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
 BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
@@ -4705,6 +4705,41 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
+static union kvm_mmu_role
+kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
+{
+	union kvm_mmu_role role = {0};
+
+	role.base.access = ACC_ALL;
+	role.base.smm = is_smm(vcpu);
+	role.base.guest_mode = is_guest_mode(vcpu);
+	role.ext.valid = 1;
+
+	if (!____is_cr0_pg(regs)) {
+		role.base.direct = 1;
+		return role;
+	}
+
+	role.base.efer_nx = ____is_efer_nx(regs);
+	role.base.cr0_wp = ____is_cr0_wp(regs);
+	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
+	role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
+	role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
+	role.base.level = role_regs_to_root_level(regs);
+
+	role.ext.cr0_pg = 1;
+	role.ext.cr4_pae = ____is_cr4_pae(regs);
+	role.ext.cr4_smep = ____is_cr4_smep(regs);
+	role.ext.cr4_smap = ____is_cr4_smap(regs);
+	role.ext.cr4_pse = ____is_cr4_pse(regs);
+
+	/* PKEY and LA57 are active iff long mode is active. */
+	role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
+	role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+	role.ext.efer_lma = ____is_efer_lma(regs);
+	return role;
+}
+
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 						   const struct kvm_mmu_role_regs *regs)
 {
@@ -4764,13 +4799,16 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_mmu_role mmu_role =
 		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
 
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
+	    mmu_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->mmu_role.as_u64 = new_role.as_u64;
+	context->cpu_role.as_u64 = cpu_role.as_u64;
+	context->mmu_role.as_u64 = mmu_role.as_u64;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
@@ -4825,13 +4863,15 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    const struct kvm_mmu_role_regs *regs,
-				    union kvm_mmu_role new_role)
+				    union kvm_mmu_role cpu_role,
+				    union kvm_mmu_role mmu_role)
 {
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
+	    mmu_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->mmu_role.as_u64 = new_role.as_u64;
+	context->cpu_role.as_u64 = cpu_role.as_u64;
+	context->mmu_role.as_u64 = mmu_role.as_u64;
 
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
@@ -4839,10 +4879,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = role_regs_to_root_level(regs);
+	context->root_level = cpu_role.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = new_role.base.level;
+	context->shadow_root_level = mmu_role.base.level;
 
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4851,10 +4891,11 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_mmu_role mmu_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
 
-	shadow_mmu_init_context(vcpu, context, regs, new_role);
+	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 }
 
 static union kvm_mmu_role
@@ -4879,11 +4920,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
-	union kvm_mmu_role new_role;
-
-	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
+	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
 
-	shadow_mmu_init_context(vcpu, context, &regs, new_role);
+	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
@@ -4906,7 +4946,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.guest_mode = true;
 	role.base.access = ACC_ALL;
 
-	/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
 	role.ext.valid = 1;
@@ -4920,12 +4959,14 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role new_mode =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64) {
-		context->mmu_role.as_u64 = new_role.as_u64;
+	if (new_mode.as_u64 != context->cpu_role.as_u64) {
+		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
+		context->cpu_role.as_u64 = new_mode.as_u64;
+		context->mmu_role.as_u64 = new_mode.as_u64;
 
 		context->shadow_root_level = level;
 
@@ -4958,37 +4999,20 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 	context->inject_page_fault = kvm_inject_page_fault;
 }
 
-static union kvm_mmu_role
-kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
-{
-	union kvm_mmu_role role;
-
-	role = kvm_calc_shadow_root_page_role_common(vcpu, regs);
-
-	/*
-	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
-	 * shadow pages of their own and so "direct" has no meaning.   Set it
-	 * to "true" to try to detect bogus usage of the nested MMU.
-	 */
-	role.base.direct = true;
-	role.base.level = role_regs_to_root_level(regs);
-	return role;
-}
-
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
+	union kvm_mmu_role new_mode = kvm_calc_cpu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
-	if (new_role.as_u64 == g_context->mmu_role.as_u64)
+	if (new_mode.as_u64 == g_context->cpu_role.as_u64)
 		return;
 
-	g_context->mmu_role.as_u64 = new_role.as_u64;
+	g_context->cpu_role.as_u64   = new_mode.as_u64;
 	g_context->get_guest_pgd     = get_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
-	g_context->root_level        = new_role.base.level;
+	g_context->root_level        = new_mode.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
@@ -5046,6 +5070,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.root_mmu.cpu_role.ext.valid = 0;
+	vcpu->arch.guest_mmu.cpu_role.ext.valid = 0;
+	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 07a7832f96cb..56544c542d05 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -281,7 +281,7 @@ static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
 	 * is not reserved and does not indicate a large page at this level,
 	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
 	 */
-	gpte &= level - (PT32_ROOT_LEVEL + mmu->mmu_role.ext.cr4_pse);
+	gpte &= level - (PT32_ROOT_LEVEL + mmu->cpu_role.ext.cr4_pse);
 #endif
 	/*
 	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
-- 
2.31.1


