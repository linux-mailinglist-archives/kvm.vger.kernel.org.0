Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325F94BE2D0
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380369AbiBUQX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380271AbiBUQX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8154F27B04
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FeFhJdHXOlsdXfhmOYeTe++C7zpCQT2snbYmjw3XDxQ=;
        b=S/khDaC6pgAXYfQinI6BkilW31mhDOUT6fTKo1Dgzgkm4/OVTxQl4WXVWKBxJGIHJ+6DKA
        CXERXmjH4BON5lR6y8gOB5OGXgBHc3hZrWM9vjJkepJGNFRu4R9LqjQ3QKMiugq0nI1llj
        wD7LyJN8TJVJ3cK2iPfcsx0Lis3hsHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-om55HxEBP1aVmQnKxcqC9Q-1; Mon, 21 Feb 2022 11:22:58 -0500
X-MC-Unique: om55HxEBP1aVmQnKxcqC9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5140B1091DA1;
        Mon, 21 Feb 2022 16:22:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E69E384A0E;
        Mon, 21 Feb 2022 16:22:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 25/25] KVM: x86/mmu: extract initialization of the page walking data
Date:   Mon, 21 Feb 2022 11:22:43 -0500
Message-Id: <20220221162243.683208-26-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_mmu consists logically of two parts: a page walker that
operates based on the CPU mode, and the shadow page table builder
that operates based on the MMU role; the latter does not exist
on vcpu->arch.nested_mmu.

The callbacks are also logically separated; of those that are not
constant, gva_to_gpa belongs to the page walker and everything else
belongs to the shadow page table builder.  This is visible in the
duplicated code to initialize gva_to_gpa in *_init_context (for
shadow paging and nested NPT), in init_kvm_tdp_mmu (for non-nested
TDP), and in init_kvm_nested_mmu.  The guest paging metadata also
belongs to the page walker and is duplicated in the same way.

Extract this duplicated code to a new function.  The new function
is basically the same as init_kvm_nested_mmu, since the nested MMU
has only the page walker part.  The only difference is that it
uses the CPU mode rather than the VCPU directly, which is more
in line with the rest of the MMU code.

Shadow EPT does not use the new function, since it has its own
gva_to_gpa callback and a different set of reserved bits.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 87 ++++++++++++++----------------------------
 1 file changed, 28 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 27cb6ba5a3b0..659f014190d2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4070,7 +4070,6 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
 }
@@ -4651,7 +4650,6 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 static void paging64_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging64_page_fault;
-	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
 }
@@ -4659,7 +4657,6 @@ static void paging64_init_context(struct kvm_mmu *context)
 static void paging32_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging32_page_fault;
-	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
 }
@@ -4700,6 +4697,24 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 	return role;
 }
 
+static void kvm_vcpu_init_walker(struct kvm_vcpu *vcpu,
+				 struct kvm_mmu *mmu,
+				 union kvm_mmu_paging_mode new_mode)
+{
+	if (new_mode.as_u64 == mmu->cpu_mode.as_u64)
+		return;
+
+	mmu->cpu_mode.as_u64 = new_mode.as_u64;
+	if (!is_cr0_pg(mmu))
+		mmu->gva_to_gpa = nonpaging_gva_to_gpa;
+	else if (is_cr4_pae(mmu))
+		mmu->gva_to_gpa = paging64_gva_to_gpa;
+	else
+		mmu->gva_to_gpa = paging32_gva_to_gpa;
+
+	reset_guest_paging_metadata(vcpu, mmu);
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
@@ -4735,36 +4750,17 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 
-	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
-	    root_role.word == context->root_role.word)
-		return;
-
-	context->cpu_mode.as_u64 = cpu_mode.as_u64;
-	context->root_role.word = root_role.word;
-
-	if (!is_cr0_pg(context))
-		context->gva_to_gpa = nonpaging_gva_to_gpa;
-	else if (is_cr4_pae(context))
-		context->gva_to_gpa = paging64_gva_to_gpa;
-	else
-		context->gva_to_gpa = paging32_gva_to_gpa;
-
-	reset_guest_paging_metadata(vcpu, context);
+	context->root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    union kvm_mmu_paging_mode cpu_mode,
 				    union kvm_mmu_page_role root_role)
 {
-	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
-	    root_role.word == context->root_role.word)
+	if (root_role.word == context->root_role.word)
 		return;
 
-	context->cpu_mode.as_u64 = cpu_mode.as_u64;
 	context->root_role.word = root_role.word;
-
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
 	else if (is_cr4_pae(context))
@@ -4772,7 +4768,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	else
 		paging32_init_context(context);
 
-	reset_guest_paging_metadata(vcpu, context);
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
@@ -4795,8 +4790,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 	 * MMU contexts.
 	 */
 	root_role.efer_nx = true;
-
-	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
+	shadow_mmu_init_context(vcpu, context, root_role);
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -4811,10 +4805,12 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
 	union kvm_mmu_page_role root_role;
 
+	kvm_vcpu_init_walker(vcpu, context, cpu_mode);
+
 	root_role = cpu_mode.base;
 	root_role.level = kvm_mmu_get_tdp_level(vcpu);
 
-	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
+	shadow_mmu_init_context(vcpu, context, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
@@ -4873,43 +4869,16 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode new_mode)
-{
-	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
-
-	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
-		return;
-
-	g_context->cpu_mode.as_u64 = new_mode.as_u64;
-
-	/*
-	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
-	 * L1's nested page tables (e.g. EPT12). The nested translation
-	 * of l2_gva to l1_gpa is done by arch.nested_mmu.gva_to_gpa using
-	 * L2's page tables as the first level of translation and L1's
-	 * nested page tables as the second level of translation. Basically
-	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
-	 */
-	if (!is_paging(vcpu))
-		g_context->gva_to_gpa = nonpaging_gva_to_gpa;
-	else if (is_long_mode(vcpu))
-		g_context->gva_to_gpa = paging64_gva_to_gpa;
-	else if (is_pae(vcpu))
-		g_context->gva_to_gpa = paging64_gva_to_gpa;
-	else
-		g_context->gva_to_gpa = paging32_gva_to_gpa;
-
-	reset_guest_paging_metadata(vcpu, g_context);
-}
-
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
 
+	kvm_vcpu_init_walker(vcpu, vcpu->arch.walk_mmu, cpu_mode);
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu, cpu_mode);
-	else if (tdp_enabled)
+		return;
+
+	if (tdp_enabled)
 		init_kvm_tdp_mmu(vcpu, cpu_mode);
 	else
 		init_kvm_softmmu(vcpu, cpu_mode);
-- 
2.31.1

