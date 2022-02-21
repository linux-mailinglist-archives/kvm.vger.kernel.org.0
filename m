Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF00A4BE662
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380403AbiBUQYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:24:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380250AbiBUQXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C625227179
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IUGtxyA5ludofXybBUQiGOW3vId5hlEWaEIO/yvZvr4=;
        b=Kyea1dTynhkPUD3lz3In9LPaS7J80TbHUU6btMKD1P6ZRjf8eZ5hO3v5MvBHX2tttcJ787
        Ner/pasx1UZZc6DaCmbXqcM8E7Kwq9bR86GPFR/AKgHMYb+IRikodzGw898uroqik9syWW
        xPRYCwGKNLRNJFcEjRcoUMjyPdlWwOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-83_FbTQBNNWR8bS-rEWcKQ-1; Mon, 21 Feb 2022 11:22:53 -0500
X-MC-Unique: 83_FbTQBNNWR8bS-rEWcKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3BAC1006AA6;
        Mon, 21 Feb 2022 16:22:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85BB178AA5;
        Mon, 21 Feb 2022 16:22:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 15/25] KVM: x86/mmu: remove extended bits from mmu_role, rename field
Date:   Mon, 21 Feb 2022 11:22:33 -0500
Message-Id: <20220221162243.683208-16-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_role represents the role of the root of the page tables.
It does not need any extended bits, as those govern only KVM's
page table walking; the is_* functions used for page table
walking always use the CPU mode.

ext.valid is not present anymore in the MMU role, but an
all-zero MMU role is impossible because the level field is
never zero in the MMU role.  So just zap the whole mmu_role
in order to force invalidation after CPUID is updated.

While making this change, which requires touching almost every
occurrence of "mmu_role", rename it to "root_role".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 72 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 4 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 996cf9b14f5e..b7d7c4f31730 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -434,7 +434,7 @@ struct kvm_mmu {
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_mmu_role cpu_mode;
-	union kvm_mmu_role mmu_role;
+	union kvm_mmu_page_role root_role;
 	u8 root_level;
 	u8 shadow_root_level;
 	bool direct_map;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bbb5f50d3dcc..35907badb6ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -193,7 +193,7 @@ struct kvm_mmu_role_regs {
 
 /*
  * Yes, lot's of underscores.  They're a hint that you probably shouldn't be
- * reading from the role_regs.  Once the mmu_role is constructed, it becomes
+ * reading from the role_regs.  Once the root_role is constructed, it becomes
  * the single source of truth for the MMU's state.
  */
 #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
@@ -2029,7 +2029,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	role = vcpu->arch.mmu->mmu_role.base;
+	role = vcpu->arch.mmu->root_role;
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
@@ -3265,7 +3265,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	 * This should not be called while L2 is active, L2 can't invalidate
 	 * _only_ its own roots, e.g. INVVPID unconditionally exits.
 	 */
-	WARN_ON_ONCE(mmu->mmu_role.base.guest_mode);
+	WARN_ON_ONCE(mmu->root_role.guest_mode);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		root_hpa = mmu->prev_roots[i].hpa;
@@ -4158,7 +4158,7 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	union kvm_mmu_page_role new_role = mmu->mmu_role.base;
+	union kvm_mmu_page_role new_role = mmu->root_role;
 
 	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
 		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
@@ -4417,7 +4417,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->shadow_root_level,
-				context->mmu_role.base.efer_nx,
+				context->root_role.efer_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
@@ -4710,22 +4710,21 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 	return max_tdp_level;
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_mmu_role cpu_mode)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_mmu_page_role role = {0};
 
-	role.base.access = ACC_ALL;
-	role.base.cr0_wp = true;
-	role.base.efer_nx = true;
-	role.base.smm = cpu_mode.base.smm;
-	role.base.guest_mode = cpu_mode.base.guest_mode;
-	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-	role.base.direct = true;
-	role.base.has_4_byte_gpte = false;
-	role.ext.valid = true;
+	role.access = ACC_ALL;
+	role.cr0_wp = true;
+	role.efer_nx = true;
+	role.smm = cpu_mode.base.smm;
+	role.guest_mode = cpu_mode.base.guest_mode;
+	role.ad_disabled = (shadow_accessed_mask == 0);
+	role.level = kvm_mmu_get_tdp_level(vcpu);
+	role.direct = true;
+	role.has_4_byte_gpte = false;
 
 	return role;
 }
@@ -4735,14 +4734,14 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
-	union kvm_mmu_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
+	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
-	    mmu_role.as_u64 == context->mmu_role.as_u64)
+	    root_role.word == context->root_role.word)
 		return;
 
 	context->cpu_mode.as_u64 = cpu_mode.as_u64;
-	context->mmu_role.as_u64 = mmu_role.as_u64;
+	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
@@ -4764,7 +4763,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				   union kvm_mmu_role role)
 {
@@ -4785,19 +4784,19 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	 * MMU contexts.
 	 */
 	role.base.efer_nx = true;
-	return role;
+	return role.base;
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 				    union kvm_mmu_role cpu_mode,
-				    union kvm_mmu_role mmu_role)
+				    union kvm_mmu_page_role root_role)
 {
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
-	    mmu_role.as_u64 == context->mmu_role.as_u64)
+	    root_role.word == context->root_role.word)
 		return;
 
 	context->cpu_mode.as_u64 = cpu_mode.as_u64;
-	context->mmu_role.as_u64 = mmu_role.as_u64;
+	context->root_role.word = root_role.word;
 
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
@@ -4808,7 +4807,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	context->root_level = cpu_mode.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = mmu_role.base.level;
+	context->shadow_root_level = root_role.level;
 
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4818,19 +4817,18 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
-	union kvm_mmu_role mmu_role =
+	union kvm_mmu_page_role root_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
 
-	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
+	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   union kvm_mmu_role role)
 {
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-
-	return role;
+	return role.base;
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -4843,9 +4841,9 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
-	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
+	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
 
-	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
+	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
@@ -4888,7 +4886,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	if (new_mode.as_u64 != context->cpu_mode.as_u64) {
 		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 		context->cpu_mode.as_u64 = new_mode.as_u64;
-		context->mmu_role.as_u64 = new_mode.as_u64;
+		context->root_role.word = new_mode.base.word;
 
 		context->shadow_root_level = level;
 
@@ -4987,9 +4985,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * problem is swept under the rug; KVM's CPUID API is horrific and
 	 * it's all but impossible to solve it without introducing a new API.
 	 */
-	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
-	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
-	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.root_mmu.root_role.word = 0;
+	vcpu->arch.guest_mmu.root_role.word = 0;
+	vcpu->arch.nested_mmu.root_role.word = 0;
 	vcpu->arch.root_mmu.cpu_mode.ext.valid = 0;
 	vcpu->arch.guest_mmu.cpu_mode.ext.valid = 0;
 	vcpu->arch.nested_mmu.cpu_mode.ext.valid = 0;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 64b6f76641f0..7c0fa115bd56 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1023,7 +1023,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
+	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
 	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
@@ -1051,7 +1051,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 * reserved bits checks will be wrong, etc...
 	 */
 	if (WARN_ON_ONCE(sp->role.direct ||
-			 (sp->role.word ^ mmu_role.word) & ~sync_role_ign.word))
+			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
 		return -1;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index debf08212f12..c18ad86c9a82 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -209,7 +209,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->mmu_role.base;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
-- 
2.31.1


