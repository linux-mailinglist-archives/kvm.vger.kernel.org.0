Return-Path: <kvm+bounces-3002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2336F7FF955
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47A0FB211D1
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162EF58AAF;
	Thu, 30 Nov 2023 18:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nhtFn9ND"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84410D0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:28:54 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d1ed4b268dso22673437b3.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701368934; x=1701973734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KCojnrKVSnfIdikNRS9eQkGQb5+JqWZFSYvF9pyN2fg=;
        b=nhtFn9NDaNPt0A1+m+fE56vnx1mbADePWNqZ9blJ/+GV4jGh2fsC2SN+uOGIGv9kE2
         FG66Nmk2jt2cIwPCVkdaveLgoqscdfsRQRN51I8JYbQErMXxdImFGKtQF8PBc4uTxxkh
         vHoiYrKDL4zgHPiVUem9dpXEuuaMsOi/sBXZkMcC79B7ql2QdeRHvB3NnS4CPxF5Fa0C
         omSukJBxBsa1BdsRsxNTZypLIY4BNLnhsdoHRrchEtfVzf1iVipEWKqca/3Ukst0s0rx
         o+Y3EFmnktINvfemJQpV61jW28/tMD+flPbdJB/tuLUm+aXutvH3MR1POBudsidZVNY6
         /v1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701368934; x=1701973734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCojnrKVSnfIdikNRS9eQkGQb5+JqWZFSYvF9pyN2fg=;
        b=B8YASZrtSazSUmxWtQi549X5URZuWzDoW9uQjn/SSvAC8/iuK8tgTy7MXBI0kHAcTC
         Z9dLejx6x8+4BHH0BalwYnrhPavqcAN3GZ3u9N5wGFbGCE2IE+S//oDd/0L8XG1rQJ1e
         YX4xnPrwsNKBdZ2brpCoVjMzCITBCxcdJ3kqVGgeDhiGDLjFXjY+qCx5p4nrO1zwhWjI
         0dvUmva2mvPHLj1TSKVxDgrQ9CPPlmZwcudzTEe9CLqFx+lTKzhOJtUsmE3Mi2Vs1POA
         R5XgmAwehIaWmYABMsqye5e+KYFzxAfr/Pg5ySWpsUv11XoE0Y8ocJWKF1XidIQb3sV0
         5s0g==
X-Gm-Message-State: AOJu0YxVLq22+dfcJteA1ZVQ8uBK00fDyLCOI1QzBA8bfrDGCOOjDR23
	vAumrPOVUQQBfqeiDzsf4WDdrNnqaso=
X-Google-Smtp-Source: AGHT+IENTQ6puxM9lq8+5c9/fGwa/0WLqvX9/pdkv4tQrl3DVzSCYKkQNeWrlJXE6OVBjygmscKR2M9Z2T4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a3e6:0:b0:db4:5d34:fa5 with SMTP id
 e93-20020a25a3e6000000b00db45d340fa5mr708485ybi.0.1701368934202; Thu, 30 Nov
 2023 10:28:54 -0800 (PST)
Date: Thu, 30 Nov 2023 10:28:52 -0800
In-Reply-To: <87y1efmg28.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com> <20231025152406.1879274-11-vkuznets@redhat.com>
 <ZWfl3ahamXPPoIGB@google.com> <87y1efmg28.fsf@redhat.com>
Message-ID: <ZWjUZPXCF2U9azWT@google.com>
Subject: Re: [PATCH 10/14] KVM: x86: Make Hyper-V emulation optional
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> ...
> 
> >
> >>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> >>  {
> >> @@ -3552,11 +3563,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >>  	if (!nested_vmx_check_permission(vcpu))
> >>  		return 1;
> >>  
> >> +#ifdef CONFIG_KVM_HYPERV
> >>  	evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
> >>  	if (evmptrld_status == EVMPTRLD_ERROR) {
> >>  		kvm_queue_exception(vcpu, UD_VECTOR);
> >>  		return 1;
> >>  	}
> >> +#endif
> >>  
> >>  	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
> >
> > This fails to build with CONFIG_KVM_HYPERV=n && CONFIG_KVM_WERROR=y:
> >
> > arch/x86/kvm/vmx/nested.c:3577:9: error: variable 'evmptrld_status' is uninitialized when used here [-Werror,-Wuninitialized]
> >         if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
> >                ^~~~~~~~~~~~~~~
> >
> > Sadly, simply wrapping with an #ifdef also fails because then evmptrld_status
> > becomes unused.  I'd really prefer to avoid having to tag it __maybe_unused, and
> > adding more #ifdef would also be ugly.  Any ideas?
> 
> A couple,
> 
> - we can try putting all eVMPTR logic under 'if (1)' just to create a
>   block where we can define evmptrld_status. Not sure this is nicer than
>   another #ifdef wrapping evmptrld_status and I'm not sure what to do
>   with kvm_pmu_trigger_event() -- can it just go above
>   nested_vmx_handle_enlightened_vmptrld()?
> 
> - we can add a helper, e.g. 'evmptr_is_vmfail()' and make it just return
>   'false' when !CONFIG_KVM_HYPERV.
> 
> - rewrite this as a switch to avoid the need for having the local
>   variable, (untested)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c5ec0ef51ff7..b26ce7d596e9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3553,22 +3553,23 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>         enum nvmx_vmentry_status status;
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         u32 interrupt_shadow = vmx_get_interrupt_shadow(vcpu);
> -       enum nested_evmptrld_status evmptrld_status;
>  
>         if (!nested_vmx_check_permission(vcpu))
>                 return 1;
>  
> -       evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
> -       if (evmptrld_status == EVMPTRLD_ERROR) {
> +       switch (nested_vmx_handle_enlightened_vmptrld(vcpu, launch)) {
> +       case EVMPTRLD_ERROR:
>                 kvm_queue_exception(vcpu, UD_VECTOR);
>                 return 1;
> +       case EVMPTRLD_VMFAIL:
> +               trace_kvm_nested_vmenter_failed("evmptrld_status", 0);
> +               return nested_vmx_failInvalid(vcpu);
> +       default:
> +               break;
>         }
>  
>         kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>  
> -       if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
> -               return nested_vmx_failInvalid(vcpu);
> -
>         if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
>                vmx->nested.current_vmptr == INVALID_GPA))
>                 return nested_vmx_failInvalid(vcpu);
> 
> Unfortunately, I had to open code CC() ;-(
> 
> Or maybe just another "#ifdef" is not so ugly after all? :-)

Ah, just have nested_vmx_handle_enlightened_vmptrld() return EVMPTRLD_DISABLED
for its "stub", e.g. with some otehr tangentially de-stubbing:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4777d867419c..5a27a2ebbb32 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2000,6 +2000,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
        struct kvm_vcpu *vcpu, bool from_launch)
 {
+#ifdef CONFIG_KVM_HYPERV
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        bool evmcs_gpa_changed = false;
        u64 evmcs_gpa;
@@ -2081,11 +2082,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
        }
 
        return EVMPTRLD_SUCCEEDED;
+#else
+       return EVMPTRLD_DISABLED;
+#endif
 }
-#else /* CONFIG_KVM_HYPERV */
-static inline void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields) {}
-static inline void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx) {}
-#endif /* CONFIG_KVM_HYPERV */
 
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
 {
@@ -3191,8 +3191,6 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 
        return true;
 }
-#else
-static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu) { return true; }
 #endif
 
 static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
@@ -3285,6 +3283,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_HYPERV
        /*
         * Note: nested_get_evmcs_page() also updates 'vp_assist_page' copy
         * in 'struct kvm_vcpu_hv' in case eVMCS is in use, this is mandatory
@@ -3301,7 +3300,7 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 
                return false;
        }
-
+#endif
        if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
                return false;
 
@@ -3564,7 +3563,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
        if (!nested_vmx_check_permission(vcpu))
                return 1;
 
-#ifdef CONFIG_KVM_HYPERV
        evmptrld_status = nested_vmx_handle_enlightened_vmptrld(vcpu, launch);
        if (evmptrld_status == EVMPTRLD_ERROR) {
                kvm_queue_exception(vcpu, UD_VECTOR);
@@ -4743,6 +4741,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
        WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
        if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
+#ifdef CONFIG_KVM_HYPERV
                /*
                 * KVM_REQ_GET_NESTED_STATE_PAGES is also used to map
                 * Enlightened VMCS after migration and we still need to
@@ -4750,6 +4749,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
                 * the first L2 run.
                 */
                (void)nested_get_evmcs_page(vcpu);
+#endif
        }
 
        /* Service pending TLB flush requests for L2 before switching to L1. */

