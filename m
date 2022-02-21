Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA504BDE40
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380301AbiBUQXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380217AbiBUQXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9073427161
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgC7K68EGURf/5nseSGFk+gLjMEs+In6PNVCqkhk4fs=;
        b=GTHlIOOLzJU2LuGgAB5hrhgVcRfSQGLK0w3mPV+FnUoqf9lafCxven22PhaMUi8KlpY7wP
        t7dqZwZtrtosts9xJO412ytGSGeAvj1unRrLHkt9aXNMdvOXbNffVivy/Ksye+tFBmYoPb
        Hx/qtG8rck8Boe93o6NuBBGzlSrhqqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-mIOYH9jIOYSOB1LiQNxKzw-1; Mon, 21 Feb 2022 11:22:49 -0500
X-MC-Unique: mIOYH9jIOYSOB1LiQNxKzw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C44E801B0F;
        Mon, 21 Feb 2022 16:22:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C375D77468;
        Mon, 21 Feb 2022 16:22:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Date:   Mon, 21 Feb 2022 11:22:26 -0500
Message-Id: <20220221162243.683208-9-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the state of the processor registers that govern page walk into
a new field of struct kvm_mmu.  This is a more natural representation
than having it *mostly* in mmu_role but not exclusively; the delta
right now is represented in other fields, such as root_level.

The nested MMU now has only the CPU mode; and in fact the new function
kvm_calc_cpu_mode is analogous to the previous kvm_calc_nested_mmu_role,
except that it has role.base.direct equal to CR0.PG.  It is not clear
what the code meant by "setting role.base.direct to true to detect bogus
usage of the nested MMU".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/mmu/mmu.c          | 107 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
 3 files changed, 68 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92855d3984a7..cc268116eb3f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -433,6 +433,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
+	union kvm_mmu_role cpu_mode;
 	union kvm_mmu_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7c835253a330..1af898f0cf87 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -221,7 +221,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
 static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
-	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
+	return !!(mmu->cpu_mode. base_or_ext . reg##_##name);	\
 }
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
 BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
@@ -4680,6 +4680,39 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
+static union kvm_mmu_role
+kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
+{
+	union kvm_mmu_role role = {0};
+
+	role.base.access = ACC_ALL;
+	role.base.smm = is_smm(vcpu);
+	role.base.guest_mode = is_guest_mode(vcpu);
+	role.base.direct = !____is_cr0_pg(regs);
+	if (!role.base.direct) {
+		role.base.efer_nx = ____is_efer_nx(regs);
+		role.base.cr0_wp = ____is_cr0_wp(regs);
+		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
+		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
+		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
+		role.base.level = role_regs_to_root_level(regs);
+
+		role.ext.cr0_pg = 1;
+		role.ext.cr4_pae = ____is_cr4_pae(regs);
+		role.ext.cr4_smep = ____is_cr4_smep(regs);
+		role.ext.cr4_smap = ____is_cr4_smap(regs);
+		role.ext.cr4_pse = ____is_cr4_pse(regs);
+
+		/* PKEY and LA57 are active iff long mode is active. */
+		role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
+		role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		role.ext.efer_lma = ____is_efer_lma(regs);
+	}
+
+	role.ext.valid = 1;
+	return role;
+}
+
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 						   const struct kvm_mmu_role_regs *regs)
 {
@@ -4739,13 +4772,16 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
+	union kvm_mmu_role mmu_role =
 		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
 
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
+	    mmu_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->mmu_role.as_u64 = new_role.as_u64;
+	context->cpu_mode.as_u64 = cpu_mode.as_u64;
+	context->mmu_role.as_u64 = mmu_role.as_u64;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
@@ -4800,13 +4836,15 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    const struct kvm_mmu_role_regs *regs,
-				    union kvm_mmu_role new_role)
+				    union kvm_mmu_role cpu_mode,
+				    union kvm_mmu_role mmu_role)
 {
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
+	    mmu_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->mmu_role.as_u64 = new_role.as_u64;
+	context->cpu_mode.as_u64 = cpu_mode.as_u64;
+	context->mmu_role.as_u64 = mmu_role.as_u64;
 
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
@@ -4814,10 +4852,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = role_regs_to_root_level(regs);
+	context->root_level = cpu_mode.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = new_role.base.level;
+	context->shadow_root_level = mmu_role.base.level;
 
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4826,10 +4864,11 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
+	union kvm_mmu_role mmu_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
 
-	shadow_mmu_init_context(vcpu, context, regs, new_role);
+	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
 }
 
 static union kvm_mmu_role
@@ -4854,11 +4893,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
-	union kvm_mmu_role new_role;
+	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
+	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
 
-	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
-
-	shadow_mmu_init_context(vcpu, context, &regs, new_role);
+	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
@@ -4881,7 +4919,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.guest_mode = true;
 	role.base.access = ACC_ALL;
 
-	/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
 	role.ext.valid = 1;
@@ -4895,12 +4932,14 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
-	union kvm_mmu_role new_role =
+	union kvm_mmu_role new_mode =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64) {
-		context->mmu_role.as_u64 = new_role.as_u64;
+	if (new_mode.as_u64 != context->cpu_mode.as_u64) {
+		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
+		context->cpu_mode.as_u64 = new_mode.as_u64;
+		context->mmu_role.as_u64 = new_mode.as_u64;
 
 		context->shadow_root_level = level;
 
@@ -4933,36 +4972,19 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 	context->inject_page_fault = kvm_inject_page_fault_shadow;
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
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
+	union kvm_mmu_role new_mode = kvm_calc_cpu_mode(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
-	if (new_role.as_u64 == g_context->mmu_role.as_u64)
+	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
 		return;
 
-	g_context->mmu_role.as_u64 = new_role.as_u64;
+	g_context->cpu_mode.as_u64   = new_mode.as_u64;
 	g_context->get_guest_pgd     = kvm_get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
-	g_context->root_level        = new_role.base.level;
+	g_context->root_level        = new_mode.base.level;
 
 	/*
 	 * L2 page tables are never shadowed, so there is no need to sync
@@ -5020,6 +5042,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.root_mmu.cpu_mode.ext.valid = 0;
+	vcpu->arch.guest_mmu.cpu_mode.ext.valid = 0;
+	vcpu->arch.nested_mmu.cpu_mode.ext.valid = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d1d17d28e81b..e1c2ecb4ddee 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -323,7 +323,7 @@ static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
 	 * is not reserved and does not indicate a large page at this level,
 	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
 	 */
-	gpte &= level - (PT32_ROOT_LEVEL + mmu->mmu_role.ext.cr4_pse);
+	gpte &= level - (PT32_ROOT_LEVEL + mmu->cpu_mode.ext.cr4_pse);
 #endif
 	/*
 	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
-- 
2.31.1


