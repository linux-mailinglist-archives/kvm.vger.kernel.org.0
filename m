Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB67480E18
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 01:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237903AbhL2AJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 19:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbhL2AJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 19:09:50 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF36C061401
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 16:09:49 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso13676196pjc.0
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 16:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=en4uwBpfxshlbd0J3vDYBdTuG7ndyKaVxa4yk8IJ1nk=;
        b=Ycu8UcGr3lpr+egvBaijGFacvpu8dnqelsOpJHXYxusoev1aF9czdXGov3CWe6Qy6u
         VQSb79DxSR/SStHKmtkSwiPhXI8S9fqppp7kQkDF81IxnrtQrXaSsdgImllXWl3npaqk
         GKTGr1ZZImgD7Imdl6N+V7U8fyRAxt3STOOoEBADh4zAQYN271w02FdQiapCaeLolONo
         AZrb0Hk9lvZtf9Ca0yq7NITuiVaEuCpIwCdtA54+lZ5c7KaUs5sRgtLq7dGrHOPJjLU/
         jBOIe1ecnXmtDXNYcrW1AEsIKm7cfwFOr7SxNk0GUPfmy6UlKfbL7oCocZkP3xMD/bCG
         BkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=en4uwBpfxshlbd0J3vDYBdTuG7ndyKaVxa4yk8IJ1nk=;
        b=UnpDBykOhQsxzD1FPciGcnOpAb13TBZLbpgSlmD6m1FzADu+qgLNCRVLvYrA/OmsmY
         GTDTesNl7mD6XaOm4tblMn7DLAk4+JiG0n5jNo4WSeGS8oINQqTzpzGZGIngX8wnf/2M
         70OQu+lo0vtOi6ljnc00YWt2BFYE7R8cKIjq4/b+uXv/IJJRWF0itXmzPGLMrLUXWCKr
         ztpObKBcbPhc6V04FnPeRZop812utyPn/n90DUyqd/zJIws/jcyXSF6zc2jq/FcQP9TD
         tlYCJILEK0e7HI4U3lzfXgijwp+avp3zBxs7a9PVWXZWbe+IfSf6gZU6GCskCVeQ20F5
         BRkQ==
X-Gm-Message-State: AOAM533b7KSbN4vLTfbzNcnFmxilEh3+EY3YSIp793qy+D6igv18O5O4
        gztjn08LcnAqh8DknQdkZUxrNw==
X-Google-Smtp-Source: ABdhPJyPCmlYsUh6cyS3BHMVbhiypz9th66jTdJPaMTpIuDmPJELXTPeRa8VRF4guixCsrGzvvXZxA==
X-Received: by 2002:a17:90a:a786:: with SMTP id f6mr29364098pjq.158.1640736588736;
        Tue, 28 Dec 2021 16:09:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o11sm22529170pfu.150.2021.12.28.16.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 16:09:48 -0800 (PST)
Date:   Wed, 29 Dec 2021 00:09:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com, corbet@lwn.net,
        shuah@kernel.org, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, guang.zeng@intel.com,
        wei.w.wang@intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v3 13/22] kvm: x86: Intercept #NM for saving IA32_XFD_ERR
Message-ID: <YcunSb52LlGKT7dC@google.com>
References: <20211222124052.644626-1-jing2.liu@intel.com>
 <20211222124052.644626-14-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222124052.644626-14-jing2.liu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021, Jing Liu wrote:
> Guest IA32_XFD_ERR is generally modified in two places:
> 
>   - Set by CPU when #NM is triggered;
>   - Cleared by guest in its #NM handler;
> 
> Intercept #NM for the first case, if guest writes XFD as nonzero for
> the first time which indicates guest is possible to use XFD generating
> the exception. #NM is rare if the guest doesn't use dynamic features.
> Otherwise, there is at most one exception per guest task given a
> dynamic feature.
> 
> Save the current XFD_ERR value to the guest_fpu container in the #NM
> VM-exit handler. This must be done with interrupt/preemption disabled,

Assuming my below understanding is correct, drop the "preemption" bit, it's
misleading.

> otherwise the unsaved MSR value may be clobbered by host operations.
> 
> Inject a virtual #NM to the guest after saving the MSR value.
> 
> Restore the host value (always ZERO outside of the host #NM
> handler) before enabling preemption.

AIUI, changelog is wrong, code is right.  This must be done before _IRQs_ are
enabled, same as handling TIF_NEED_FPU_LOAD. 

> Restore the guest value from the guest_fpu container right before
> entering the guest (with preemption disabled).

Same complaint about preemption.

> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/vmcs.h         |  5 +++++
>  arch/x86/kvm/vmx/vmx.c          | 22 +++++++++++++++++++++-
>  arch/x86/kvm/x86.c              |  6 ++++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 555f4de47ef2..f7a661f35d1a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -640,6 +640,7 @@ struct kvm_vcpu_arch {
>  	u64 smi_count;
>  	bool tpr_access_reporting;
>  	bool xsaves_enabled;
> +	bool trap_nm;
>  	u64 ia32_xss;
>  	u64 microcode_version;
>  	u64 arch_capabilities;

...

> @@ -763,6 +764,9 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
>  		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, match);
>  	}
>  
> +	if (vcpu->arch.trap_nm)
> +		eb |= (1u << NM_VECTOR);
> +
>  	vmcs_write32(EXCEPTION_BITMAP, eb);
>  }
>  
> @@ -1960,6 +1964,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KERNEL_GS_BASE:
>  		vmx_write_guest_kernel_gs_base(vmx, data);
>  		break;
> +	case MSR_IA32_XFD:
> +		ret = kvm_set_msr_common(vcpu, msr_info);
> +		if (!ret && data) {
> +			vcpu->arch.trap_nm = true;
> +			vmx_update_exception_bitmap(vcpu);

This is wrong, it fails to clear vcpu->arch.trap_nm and update the bitmap if the
MSR is cleared.

But why even bother with an extra flag?  Can't vmx_update_exception_bitmap() get
the guest's MSR_IA32_XFD value and intercept #NM accordingly?  Then you could
even handle this fully in kvm_set_msr_common(), e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c9606380bca..c6c936d2b298 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3704,6 +3704,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                        return 1;

                fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
+               /* Blah blah blah blah */
+               static_call(kvm_x86_update_exception_bitmap)(vcpu);
                break;
        case MSR_IA32_XFD_ERR:
                if (!msr_info->host_initiated &&

> +		}
> +		break;
>  #endif
>  	case MSR_IA32_SYSENTER_CS:
>  		if (is_guest_mode(vcpu))
> @@ -4746,7 +4757,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	vect_info = vmx->idt_vectoring_info;
>  	intr_info = vmx_get_intr_info(vcpu);
>  
> -	if (is_machine_check(intr_info) || is_nmi(intr_info))
> +	if (is_machine_check(intr_info) || is_nmi(intr_info) || is_nm(intr_info))
>  		return 1; /* handled by handle_exception_nmi_irqoff() */
>  
>  	if (is_invalid_opcode(intr_info))
> @@ -6350,6 +6361,12 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
>  	kvm_after_interrupt(vcpu);
>  }
>  
> +static void handle_exception_nm(struct kvm_vcpu *vcpu)

This needs a different name, it's waaaay too close to the base handle_exception_nmi(),
which runs with IRQs _on_.  And please add "_irqoff" at the end.  Maybe handle_nm_fault_irqoff()?

> +{
> +	rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> +	kvm_queue_exception(vcpu, NM_VECTOR);
> +}
> +
>  static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  {
>  	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
> @@ -6358,6 +6375,9 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
>  	/* if exit due to PF check for async PF */
>  	if (is_page_fault(intr_info))
>  		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
> +	/* if exit due to NM, handle before preemptions are enabled */
> +	else if (is_nm(intr_info))

Same naming complaint about this helper, it looks like an is_nmi() typo.  is_nm_fault()?

> +		handle_exception_nm(&vmx->vcpu);
>  	/* Handle machine checks before interrupts are enabled */
>  	else if (is_machine_check(intr_info))
>  		kvm_machine_check();
