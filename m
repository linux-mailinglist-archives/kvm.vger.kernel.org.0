Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134A04AC853
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbiBGSL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240766AbiBGSGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:06:34 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC6CC0401D9
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:06:33 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id e6so14327316pfc.7
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hy3GpyVEw/60S++NaKaGr5bmqwbdP+JQuuWqdHW03Jc=;
        b=RQQsMOX37GnaDc3n36M3KMaCaFQ/XgqN0RD0xaMxohN0J9IYNAYTn3MzlPp2+TibyF
         w3ljBPlMx71uFj5wDLdXcAZaRG9Pmp6q18ZClzgGdobKy1hxZVO6xTmagZkZ9Elf0Cvw
         JUODXdELTF2T/bWf9KqA2HobTQbsgwVtsATkgXundUnJBk+bwkBgBZ6RNaav3TLkEcNT
         R96zijXpWeDnf6aNyyIkXA0s2jY0EKBSeD34xn01Gpdv4nkFZdtg1uj768IXasaK/fvg
         n1rSADchR/hz1FJZqGbsO3SIqUmAAgGE67DXBfHGeeX2ndn2Vz2oKI495dibQ2ESMXnx
         eTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hy3GpyVEw/60S++NaKaGr5bmqwbdP+JQuuWqdHW03Jc=;
        b=igBaX95T+gX8EIR/CaEfuYnxc8zmKXWqn4J41cPxj0zqX1hru5kdO8o60m9mVkZlwU
         rhT7et1qTdFyldvV5JEYizhvaUZryIIekZ+9J9p97w5U6Ed033tr4vjFuJ/LSWo/aFtN
         C6eWHvOBfzVK+dZHyyfqTAcY8AUjlMF70ZrSAI2Kfs3rLmaHgR7Qy7rTh9KZTBhaILaZ
         zzY7hJd7C5BNFDTUOT3KbG/DCRnzBEqQBQ1mXgODy0SLajnawqzwTaaFCFB+thKKDLez
         5fFDyqqr7ZjGulGGDOxQjA98AjBkmxm5QloD9oih+8qL0XKJ+sYKugn08qMYIC3YDD7N
         JxsQ==
X-Gm-Message-State: AOAM5302NoPXoXQ5l+vHHV4F7TnFaQtubZ4BJY1d92c/fPzZr9RbMAD2
        bULQI8CNI001iMaudB3zTPgLFA==
X-Google-Smtp-Source: ABdhPJzbNhmO/mE35rw+BM9GP8joClxHSvbbD+hXsinH7fwQ1DlW0/gwkYYqrZUBut0gafuBZQM8uA==
X-Received: by 2002:a65:4547:: with SMTP id x7mr457760pgr.467.1644257193213;
        Mon, 07 Feb 2022 10:06:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h6sm12755243pfc.35.2022.02.07.10.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:06:32 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:06:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 4/7] KVM: nVMX: Add a quirk for KVM tweaks to VMX
 control MSRs
Message-ID: <YgFfpTk/woy75TVj@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204204705.3538240-5-oupton@google.com>
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

On Fri, Feb 04, 2022, Oliver Upton wrote:
> KVM really has no business messing with the vCPU state. Nonetheless, it
> has become ABI for KVM to adjust certain bits of the VMX entry/exit
> control MSRs depending on the guest CPUID. Namely, the bits associated
> with the IA32_PERF_GLOBAL_CTRL and IA32_BNDCFGS MSRs were conditionally
> enabled if the guest CPUID allows for it.
> 
> Allow userspace to opt-out of changes to VMX control MSRs by adding a
> new KVM quirk.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 11 ++++++-----
>  arch/x86/kvm/vmx/vmx.c          |  3 +++
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index bf6e96011dfe..acbab6a97fae 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -428,11 +428,12 @@ struct kvm_sync_regs {
>  	struct kvm_vcpu_events events;
>  };
>  
> -#define KVM_X86_QUIRK_LINT0_REENABLED	   (1 << 0)
> -#define KVM_X86_QUIRK_CD_NW_CLEARED	   (1 << 1)
> -#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
> -#define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
> -#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
> +#define KVM_X86_QUIRK_LINT0_REENABLED		(1 << 0)
> +#define KVM_X86_QUIRK_CD_NW_CLEARED		(1 << 1)
> +#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE		(1 << 2)
> +#define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
> +#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
> +#define KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS	(1 << 5)

I'd prefer we include msr_ia32_feature_control_valid_bits in this quirk, it should
be relatively easy to do since most of the modifications stem from
vmx_vcpu_after_set_cpuid().  vmx_setup_mce() is a bit odd, but IMO it's worth
excising as much crud as we can.

>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 395787b7e7ac..60b1b76782e1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7231,6 +7231,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
> +		return;


Probably worth calling out that nested_vmx_cr_fixed1_bits_update() is intentionally
exempt from this "rule":

	case MSR_IA32_VMX_CR0_FIXED1:
	case MSR_IA32_VMX_CR4_FIXED1:
		/*
		 * These MSRs are generated based on the vCPU's CPUID, so we
		 * do not support restoring them directly.
		 */
		return -EINVAL;

> +
>  	if (kvm_mpx_supported()) {
>  		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
>  
> -- 
> 2.35.0.263.gb82422642f-goog
> 
