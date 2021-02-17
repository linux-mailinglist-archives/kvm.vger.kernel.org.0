Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6169C31DE2B
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhBQRac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 12:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhBQRaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 12:30:30 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F28BC061574
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:29:50 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d13so7784125plg.0
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 09:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LfC994+VdXOQvCvXIS28RgeAE0JKfwsj7yHp42+2dB4=;
        b=NwZ7WW5fJDdkYcjGdM+at8BoNVtemf2RuTxH8f31wEaoo0wu++7FnTTVFxLc4E23y8
         wo8Yzhi/5QT1Nc+Mxvf+nyC7KQAbGtirGgQMCqP1vPxtJn0OcpO0Fy9JK9Aj8fFtaCCT
         Jzy8Jyw2mze4/jt1Ad9Pb15yY8lwNtLVbY2wPxXe+tLJgmdBFXjpOu3uwpZoG8DIq65K
         zEmRJnpbBcQZqN2KP/I8t0/6GlPI86iL3kgTI8ISXkKGtcxzpdzeixaGTGtykJEenvpb
         AoWzo/NLfRUuwLAb5IRHLj03R5leCws7KG0s/3culLWektghnn/wI+aqPLMeC5FIkgW2
         xMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LfC994+VdXOQvCvXIS28RgeAE0JKfwsj7yHp42+2dB4=;
        b=TxD6oDktiIgdyMtICucmVM6fgG4K4h6aWhE20RPAlQU6WO3Ycn2JpeYSAoqVyyyC+U
         M78cNFUhZ1j9llCp5n4k1mjoYXwPSPb01ymdrJy9GzO8V5w70yNLDpD1LcgdM8a72GM2
         gQbY5oNAUytmw40mI1muIKEFvnNqnT/c0EreEMJhP0V9Z6BYYjT4ha0qroiu8s/uqh9w
         R1ay/aQ8CZYlQdp4Qfs+u+oK4cWnbQckhp97BX/XS1GocmLpFRMToUN5i2y83qjsL4gz
         Q2VZ+UW6VoPoRB2FqLsdP5UqiIwE5e3VoNXPS8t3iER9j0iilQxXKSYzSkOIGEVuQlfR
         e40A==
X-Gm-Message-State: AOAM532lweQ03IdC9i3oBmdJFrESVzDsBRZjkhonOLTgAzpkkONmpe0G
        YJdCHG3ZSqXoAqRhIDPZGXw0aA==
X-Google-Smtp-Source: ABdhPJxrhCZCogiYruFh+JkUGOouFGuW/3JBAXAvoR5H/+XJXZNcITcQpw3UYcslH1KcVK1+8EErmg==
X-Received: by 2002:a17:903:230b:b029:dd:7cf1:8c33 with SMTP id d11-20020a170903230bb02900dd7cf18c33mr110882plh.31.1613582989259;
        Wed, 17 Feb 2021 09:29:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id y22sm3116778pgh.19.2021.02.17.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 09:29:48 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:29:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/7] KVM: nVMX: move inject_page_fault tweak to
 .complete_mmu_init
Message-ID: <YC1ShhSZ+6ST63nZ@google.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
 <20210217145718.1217358-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217145718.1217358-5-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021, Maxim Levitsky wrote:
> This fixes a (mostly theoretical) bug which can happen if ept=0
> on host and we run a nested guest which triggers a mmu context
> reset while running nested.
> In this case the .inject_page_fault callback will be lost.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 +-------
>  arch/x86/kvm/vmx/nested.h | 1 +
>  arch/x86/kvm/vmx/vmx.c    | 5 ++++-
>  3 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0b6dab6915a3..f9de729dbea6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -419,7 +419,7 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
>  }
>  
>  
> -static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
> +void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
>  		struct x86_exception *fault)
>  {
>  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> @@ -2620,9 +2620,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
>  	}
>  
> -	if (!enable_ept)
> -		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
> -
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
>  	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
>  				     vmcs12->guest_ia32_perf_global_ctrl)))
> @@ -4224,9 +4221,6 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
>  		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
>  
> -	if (!enable_ept)
> -		vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;

Oof, please explicitly call out these types of side effects in the changelog,
it took me a while to piece together that this can be dropped because a MMU
reset is guaranteed and is also guaranteed to restore inject_page_fault.

I would even go so far as to say this particular line of code should be removed
in a separate commit.  Unless I'm overlooking something, this code is
effectively a nop, which means it doesn't need to be removed to make the bug fix
functionally correct.

All that being said, I'm pretty we can eliminate setting inject_page_fault
dynamically.  I think that would yield more maintainable code.  Following these
flows is a nightmare.  The change itself will be scarier, but I'm pretty sure
the end result will be a lot cleaner.

And I believe there's also a second bug that would be fixed by such an approach.
Doesn't vmx_inject_page_fault_nested() need to be used for the nested_mmu when
ept=1?  E.g. if the emulator injects a #PF to L2, L1 should still be able to
intercept the #PF even if L1 is using EPT.  This likely hasn't been noticed
because hypervisors typically don't intercept #PF when EPT is enabled.

Something like this (very incomplete):

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30e9b0cb9abd..f957514a4d65 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4497,7 +4497,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
        context->direct_map = true;
        context->get_guest_pgd = get_cr3;
        context->get_pdptr = kvm_pdptr_read;
-       context->inject_page_fault = kvm_inject_page_fault;

        if (!is_paging(vcpu)) {
                context->nx = false;
@@ -4687,7 +4686,6 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)

        context->get_guest_pgd     = get_cr3;
        context->get_pdptr         = kvm_pdptr_read;
-       context->inject_page_fault = kvm_inject_page_fault;
 }

 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
@@ -4701,7 +4699,6 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
        g_context->mmu_role.as_u64 = new_role.as_u64;
        g_context->get_guest_pgd     = get_cr3;
        g_context->get_pdptr         = kvm_pdptr_read;
-       g_context->inject_page_fault = kvm_inject_page_fault;

        /*
         * L2 page tables are never shadowed, so there is no need to sync
@@ -5272,6 +5269,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
        if (ret)
                goto fail_allocate_root;

+       static_call(kvm_x86_mmu_create)(vcpu);
+
        return ret;
  fail_allocate_root:
        free_mmu_pages(&vcpu->arch.guest_mmu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a63da447ede9..aa6c48295117 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -425,15 +425,14 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 }


-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
+static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
                struct x86_exception *fault)
 {
        struct vmcs12 *vmcs12 = get_vmcs12(vcpu);

-       WARN_ON(!is_guest_mode(vcpu));
-
-       if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
-               !to_vmx(vcpu)->nested.nested_run_pending) {
+       if (guest_mode(vcpu) &&
+           nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
+           !to_vmx(vcpu)->nested.nested_run_pending) {
                vmcs12->vm_exit_intr_error_code = fault->error_code;
                nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
                                  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
@@ -2594,9 +2593,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
                vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
        }

-       if (!enable_ept)
-               vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
        if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
            WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
                                     vmcs12->guest_ia32_perf_global_ctrl)))
@@ -4198,9 +4194,6 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
        if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
                nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);

-       if (!enable_ept)
-               vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
-
        nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);

        vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1204e5f0fe67..0e5ee22eea77 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3081,6 +3081,13 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
        vmx->emulation_required = emulation_required(vcpu);
 }

+static void vmx_mmu_create(struct kvm_vcpu *vcpu)
+{
+       vcpu->arch.root_mmu.inject_page_fault = vmx_inject_page_fault;
+       vcpu->arch.guest_mmu.inject_page_fault = nested_ept_inject_page_fault;
+       vcpu->arch.nested_mmu.inject_page_fault = vmx_inject_page_fault;
+}
+
 static int vmx_get_max_tdp_level(void)
 {
        if (cpu_has_vmx_ept_5levels())
@@ -7721,6 +7728,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {

        .write_l1_tsc_offset = vmx_write_l1_tsc_offset,

+       .mmu_create = vmx_mmu_create,
        .load_mmu_pgd = vmx_load_mmu_pgd,

        .check_intercept = vmx_check_intercept,

> -
>  	nested_vmx_transition_tlb_flush(vcpu, vmcs12, false);
>  
>  	vmcs_write32(GUEST_SYSENTER_CS, vmcs12->host_ia32_sysenter_cs);
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index 197148d76b8f..2ab279744d38 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -36,6 +36,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
>  void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
>  bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
>  				 int size);
> +void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,struct x86_exception *fault);
>  
>  static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bf6ef674d688..c43324df4877 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3254,7 +3254,10 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  
>  static void vmx_complete_mmu_init(struct kvm_vcpu *vcpu)
>  {
> -
> +	if (!enable_ept && is_guest_mode(vcpu)) {
> +		WARN_ON(mmu_is_nested(vcpu));
> +		vcpu->arch.mmu->inject_page_fault = vmx_inject_page_fault_nested;
> +	}
>  }
>  
>  static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> -- 
> 2.26.2
> 
