Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03B44D22FC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 21:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbiCHU7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 15:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbiCHU7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 15:59:49 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301DD37018
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 12:58:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 9so193061pll.6
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 12:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4IJlKs/eE7gOdCe8Uo/1nseLilbVaX3nge4KCMKFs8Y=;
        b=N0+jpquqL/hxyaQ0I1FgFKidEJ2yASLqYqJ0hc5KUR9wg1RNj7O+QVffH++TpA9fjH
         B6pJ866PkdsaWGmVFr1uyE+A1Oa0cYGdbNfy3cj8f2UurWk2TD/FCFm3J22/A9TZWOw4
         aMgUlSSgTPD7e7k+yzLS7wEHykfmENrFPUirljCd/jbS3bSZ1nFUxvb2HuqNaczvTzYR
         1yVvrkp+8xtuZ9wiViDuGcqgyabMmzoKZUcp2VxJ6tQhq9E08f5QcsoO4JoLL143Xnd2
         WbyGml8Bs4YTU1l26Kb4zsZCnIZ3MTGsfEacsqsosOXMKsUD4N237QkKZDXvtLROcEkX
         ywsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4IJlKs/eE7gOdCe8Uo/1nseLilbVaX3nge4KCMKFs8Y=;
        b=gXziY/Ap6EjiZwpxgfuFXABLgKiARoHRSJXChaSenbN9ktMq3INgtHkktoUDXCCF9f
         +xpxsrhDoByExxlyxTLuzgibEK5eVooSBb51Ti4dh3T0/ANsocCAufuj34DEIi8hODDT
         w7e39ulz67ixxZ83/qLWLdf8V6875pRiuC0RJJUIgSH3lb6rDmG1+sBLTThefn/zsXLI
         m8uItS9wrXfMw/qZ0seAhW9IlmupxG2TtgVLsV2vpV02h8xHDqmICFBrZXCYjjfxi7fa
         KQj5AZCOktvN7jjyF34sIjZhDHOdH4WpLhdiCmX6Cb3xLQ2/DmmBTDZtOLIUKzS5398o
         v5lg==
X-Gm-Message-State: AOAM533L/f0PYNDWSHoTiZhTPmYn09wcr4wcM2Bs6hn0xhRUtaa7lH9b
        72NHD75pA/wcvQKzXOqAiCPpIQ==
X-Google-Smtp-Source: ABdhPJxGbK1SRRxGSOI4FdNaDa7/E8DXoy3todVz0eyJ4jsqnLgHBN0UoUeyS60nfAIgbqNGcg7brg==
X-Received: by 2002:a17:90b:3b46:b0:1bf:b1f:588f with SMTP id ot6-20020a17090b3b4600b001bf0b1f588fmr6768417pjb.182.1646773131400;
        Tue, 08 Mar 2022 12:58:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm22364255pfh.143.2022.03.08.12.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:58:50 -0800 (PST)
Date:   Tue, 8 Mar 2022 20:58:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 24/25] KVM: x86/mmu: initialize constant-value fields
 just once
Message-ID: <YifDh5E63lAkJraV@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-25-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-25-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
>  
> +	vcpu->arch.root_mmu.get_guest_pgd = kvm_get_guest_cr3;
> +	vcpu->arch.root_mmu.get_pdptr = kvm_pdptr_read;
> +
> +	if (tdp_enabled) {

Putting all this code is in a separate helper reduces line-lengths via early
returns.  And it'll allow us to do the same for the nested specific MMUs if we
ever get smart and move "nested" to x86.c (preferably as enable_nested or
nested_enabled).

> +		vcpu->arch.root_mmu.inject_page_fault = kvm_inject_page_fault;
> +		vcpu->arch.root_mmu.page_fault = kvm_tdp_page_fault;
> +		vcpu->arch.root_mmu.sync_page = nonpaging_sync_page;
> +		vcpu->arch.root_mmu.invlpg = NULL;
> +		reset_tdp_shadow_zero_bits_mask(&vcpu->arch.root_mmu);
> +
> +		vcpu->arch.guest_mmu.get_guest_pgd = kvm_x86_ops.nested_ops->get_nested_pgd;
> +		vcpu->arch.guest_mmu.get_pdptr = kvm_x86_ops.nested_ops->get_nested_pdptr;
> +		vcpu->arch.guest_mmu.inject_page_fault = kvm_x86_ops.nested_ops->inject_nested_tdp_vmexit;

Using nested_ops is clever, but IMO unnecessary, especially since we can go even
further by adding a nEPT specific hook to initialize its constant shadow paging
stuff.

Here's what I had written spliced in with your code.  Compile tested only for
this version.


From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 21 Feb 2022 11:22:42 -0500
Subject: [PATCH] KVM: x86/mmu: initialize constant-value fields just once

The get_guest_pgd, get_pdptr and inject_page_fault pointers are constant
for all three of root_mmu, guest_mmu and nested_mmu.  The guest_mmu
function pointers depend on the processor vendor, but are otherwise
constant.

Opportunistically stop initializing get_pdptr for nested EPT, since it
does not have PDPTRs.

Opportunistically change kvm_mmu_create() to return '0' unconditionally
in its happy path to make it obvious that it's a happy path.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h        |  1 +
 arch/x86/kvm/mmu/mmu.c    | 85 ++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/nested.c | 15 +++++--
 arch/x86/kvm/svm/svm.c    |  3 ++
 arch/x86/kvm/svm/svm.h    |  1 +
 arch/x86/kvm/vmx/nested.c | 13 ++++--
 arch/x86/kvm/vmx/nested.h |  1 +
 arch/x86/kvm/vmx/vmx.c    |  3 ++
 8 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9517e56a0da1..bd2a6e20307c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -71,6 +71,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
+void kvm_init_shadow_ept_mmu_constants(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     int huge_page_level, bool accessed_dirty,
 			     gpa_t new_eptp);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c388add95cb..db2d88c59198 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4778,12 +4778,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,

 	context->cpu_mode.as_u64 = cpu_mode.as_u64;
 	context->root_role.word = root_role.word;
-	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = nonpaging_sync_page;
-	context->invlpg = NULL;
-	context->get_guest_pgd = kvm_get_guest_cr3;
-	context->get_pdptr = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;

 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4793,7 +4787,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 		context->gva_to_gpa = paging32_gva_to_gpa;

 	reset_guest_paging_metadata(vcpu, context);
-	reset_tdp_shadow_zero_bits_mask(context);
 }

 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
@@ -4818,8 +4811,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	reset_shadow_zero_bits_mask(vcpu, context);
 }

-static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				union kvm_mmu_paging_mode cpu_mode)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
+			     union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_page_role root_role;
@@ -4891,6 +4884,17 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	return role;
 }

+void kvm_init_shadow_ept_mmu_constants(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *guest_mmu = &vcpu->arch.guest_mmu;
+
+	guest_mmu->page_fault = ept_page_fault;
+	guest_mmu->gva_to_gpa = ept_gva_to_gpa;
+	guest_mmu->sync_page  = ept_sync_page;
+	guest_mmu->invlpg     = ept_invlpg;
+}
+EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu_constants);
+
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     int huge_page_level, bool accessed_dirty,
 			     gpa_t new_eptp)
@@ -4912,7 +4916,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->invlpg = ept_invlpg;

 		update_permission_bitmask(context, true);
-		context->pkru_mask = 0;
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
@@ -4921,18 +4924,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);

-static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
-			     union kvm_mmu_paging_mode cpu_mode)
-{
-	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-
-	kvm_init_shadow_mmu(vcpu, cpu_mode);
-
-	context->get_guest_pgd	   = kvm_get_guest_cr3;
-	context->get_pdptr         = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
-}
-
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 				union kvm_mmu_paging_mode new_mode)
 {
@@ -4941,16 +4932,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
 		return;

-	g_context->cpu_mode.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = kvm_get_guest_cr3;
-	g_context->get_pdptr         = kvm_pdptr_read;
-	g_context->inject_page_fault = kvm_inject_page_fault;
-
-	/*
-	 * L2 page tables are never shadowed, so there is no need to sync
-	 * SPTEs.
-	 */
-	g_context->invlpg            = NULL;
+	g_context->cpu_mode.as_u64 = new_mode.as_u64;

 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -5499,6 +5481,40 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	free_page((unsigned long)mmu->pml5_root);
 }

+static void kvm_init_mmu_constants(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *nested_mmu = &vcpu->arch.nested_mmu;
+	struct kvm_mmu *root_mmu = &vcpu->arch.root_mmu;
+
+	root_mmu->get_guest_pgd	    = kvm_get_guest_cr3;
+	root_mmu->get_pdptr	    = kvm_pdptr_read;
+	root_mmu->inject_page_fault = kvm_inject_page_fault;
+
+	/*
+	 * When shadowing IA32 page tables, all other callbacks various based
+	 * on paging mode, and the guest+nested MMUs are unused.
+	 */
+	if (!tdp_enabled)
+		return;
+
+	root_mmu->page_fault = kvm_tdp_page_fault;
+	root_mmu->sync_page  = nonpaging_sync_page;
+	root_mmu->invlpg     = NULL;
+	reset_tdp_shadow_zero_bits_mask(&vcpu->arch.root_mmu);
+
+	/*
+	 * Nested TDP MMU callbacks that are constant are vendor specific due
+	 * to the vast differences between EPT and NPT.  NPT in particular is
+	 * nasty because L1 may use 32-bit and/or 64-bit paging.
+	 */
+	nested_mmu->get_guest_pgd     = kvm_get_guest_cr3;
+	nested_mmu->get_pdptr         = kvm_pdptr_read;
+	nested_mmu->inject_page_fault = kvm_inject_page_fault;
+
+	/* L2 page tables are never shadowed, there's no need to sync SPTEs. */
+	nested_mmu->invlpg            = NULL;
+}
+
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 {
 	struct page *page;
@@ -5575,7 +5591,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	if (ret)
 		goto fail_allocate_root;

-	return ret;
+	kvm_init_mmu_constants(vcpu);
+
+	return 0;
+
  fail_allocate_root:
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	return ret;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd942c719cf6..c58c9d876a6c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -96,6 +96,15 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 	return svm->nested.ctl.nested_cr3;
 }

+void nested_svm_init_mmu_constants(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *guest_mmu = &vcpu->arch.guest_mmu;
+
+	guest_mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
+	guest_mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
+	guest_mmu->inject_page_fault = nested_svm_inject_npf_exit;
+}
+
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -112,10 +121,8 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
 				svm->vmcb01.ptr->save.efer,
 				svm->nested.ctl.nested_cr3);
-	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
-	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
-	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
+
+	vcpu->arch.walk_mmu = &vcpu->arch.nested_mmu;
 }

 static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a8ee949b2403..db62b3e88317 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1228,6 +1228,9 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)

 	svm->guest_state_loaded = false;

+	if (npt_enabled && nested)
+		nested_svm_init_mmu_constants(vcpu);
+
 	return 0;

 error_free_vmsa_page:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e45b5645d5e0..99c5a57ab5dd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -564,6 +564,7 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
+void nested_svm_init_mmu_constants(struct kvm_vcpu *vcpu);

 extern struct kvm_x86_nested_ops svm_nested_ops;

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cc4c74339d35..385f60305555 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -407,15 +407,22 @@ static void nested_ept_new_eptp(struct kvm_vcpu *vcpu)
 				nested_ept_get_eptp(vcpu));
 }

+void nested_ept_init_mmu_constants(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *mmu = &vcpu->arch.guest_mmu;
+
+	mmu->get_guest_pgd	= nested_ept_get_eptp;
+	mmu->inject_page_fault	= nested_ept_inject_page_fault;
+
+	kvm_init_shadow_ept_mmu_constants(vcpu);
+}
+
 static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 {
 	WARN_ON(mmu_is_nested(vcpu));

 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
 	nested_ept_new_eptp(vcpu);
-	vcpu->arch.mmu->get_guest_pgd     = nested_ept_get_eptp;
-	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
-	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;

 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..78e6d9ba5839 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -37,6 +37,7 @@ void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
+void nested_ept_init_mmu_constants(struct kvm_vcpu *vcpu);

 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40e015e9b260..04edb8a761a8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7081,6 +7081,9 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 			goto free_vmcs;
 	}

+	if (enable_ept && nested)
+		nested_ept_init_mmu_constants(vcpu);
+
 	return 0;

 free_vmcs:

base-commit: 94fd8078bd4f838cf9ced265e6ac4237cbcba7a1
--

