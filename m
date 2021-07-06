Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046263BD8CC
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhGFOrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhGFOrb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAANL4ig1HFdU+pXl5/Z5A9qLIXjsKRkhJhRaPBHzvA=;
        b=Zo4HWaIBiLYRGZGB14J+8ar2zVQirS0gJGbCvt4U2q43c65dxMttCZwRFx89wAM/Qb2sz+
        TvPKARDXcwYE+oQSlA/9V+SfTy2vf4RZv/3lIqZHdQHlr1PLY54OfB3QMdIAZxxa5To9Bt
        HLOk5m1gmrHbB4Gu7eEXTqMVaAOCVdQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-9E7XSTP0NMuzu5xE7N0Erg-1; Tue, 06 Jul 2021 10:44:50 -0400
X-MC-Unique: 9E7XSTP0NMuzu5xE7N0Erg-1
Received: by mail-wr1-f70.google.com with SMTP id y5-20020adfe6c50000b02901258bf1d760so7242286wrm.14
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAANL4ig1HFdU+pXl5/Z5A9qLIXjsKRkhJhRaPBHzvA=;
        b=mGbi5sk6ZQRPWMFn8DJFQpusqh7Jf+w1nAAGVVXBoI0W91r4TdIRsrRPzDheSmsAkH
         g5K4LZvqYeu7sY8dVejNJyaCTboMzdDQcLC4RLhTPH+7X3rDD6NEPP2+kbp6Pe4qoH33
         wg2SRGRQbxdLs4aB9dYqOJI0IZRsS78+G4SYsPfKpv+4l0+WqQVVO8dlaF6VKCR0Tdbl
         psu539pEKGwSMLkQyHFZdaXICvrQzwqBoZfkNmwjt6QpgHzG/1V68cNunAUGKBFBrmJa
         rBbgRtx46Uo8mPp49hCILl7y9KrRbqEFx1FdnbCHK6F0EG6df/HNt36fsT0mvQuDROJO
         Kglg==
X-Gm-Message-State: AOAM531L+54mUL76/iGfqtBaqPwDMFdgEQC7YPIHxJfFouNzfTMrgEhS
        C9HMM2Y7FMHAbTYiSewRSEnUMWLcNnWDHJQxJ43cQY84WLL6+Q0ql4bUHMCShVaY2znSzl0F1Ia
        72soU8iGCJqfA
X-Received: by 2002:a05:600c:ad3:: with SMTP id c19mr21226885wmr.69.1625582689519;
        Tue, 06 Jul 2021 07:44:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0IeWtlA758g39xd1jxRJjtpW/ewYlmZtgGi39cOuioAM+potjWdZNbp6tHpknbjVwPqzAaw==
X-Received: by 2002:a05:600c:ad3:: with SMTP id c19mr21226860wmr.69.1625582689359;
        Tue, 06 Jul 2021 07:44:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z4sm15796600wrp.46.2021.07.06.07.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:44:48 -0700 (PDT)
Subject: Re: [RFC PATCH v2 57/69] KVM: VMX: Move register caching logic to
 common code
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <088bc637ef2c0f40f33a3f7c6a8ed0ed844ad111.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ba82dedb-9193-2497-b35d-4978af302c5e@redhat.com>
Date:   Tue, 6 Jul 2021 16:44:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <088bc637ef2c0f40f33a3f7c6a8ed0ed844ad111.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Move the guts of vmx_cache_reg() to vt_cache_reg() in preparation for
> reusing the bulk of the code for TDX, which can access guest state for
> debug TDs.
> 
> Use kvm_x86_ops.cache_reg() in ept_update_paging_mode_cr0() rather than
> trying to expose vt_cache_reg() to vmx.c, even though it means taking a
> retpoline.  The code runs if and only if EPT is enabled but unrestricted
> guest.  Only one generation of CPU, Nehalem, supports EPT but not
> unrestricted guest, and disabling unrestricted guest without also
> disabling EPT is, to put it bluntly, dumb.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 37 +++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.c  | 42 +----------------------------------------
>   2 files changed, 37 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 0d8d2a0a2979..b619615f77de 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -341,7 +341,42 @@ static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>   
>   static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>   {
> -	vmx_cache_reg(vcpu, reg);
> +	unsigned long guest_owned_bits;
> +
> +	kvm_register_mark_available(vcpu, reg);
> +
> +	switch (reg) {
> +	case VCPU_REGS_RSP:
> +		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
> +		break;
> +	case VCPU_REGS_RIP:
> +		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
> +		break;
> +	case VCPU_EXREG_PDPTR:
> +		if (enable_ept)
> +			ept_save_pdptrs(vcpu);
> +		break;
> +	case VCPU_EXREG_CR0:
> +		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
> +
> +		vcpu->arch.cr0 &= ~guest_owned_bits;
> +		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
> +		break;
> +	case VCPU_EXREG_CR3:
> +		if (is_unrestricted_guest(vcpu) ||
> +		    (enable_ept && is_paging(vcpu)))
> +			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> +		break;
> +	case VCPU_EXREG_CR4:
> +		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
> +
> +		vcpu->arch.cr4 &= ~guest_owned_bits;
> +		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
> +		break;
> +	default:
> +		KVM_BUG_ON(1, vcpu->kvm);
> +		break;
> +	}
>   }
>   
>   static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e315a46d1566..3c3bfc80d2bb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2326,46 +2326,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	return ret;
>   }
>   
> -static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> -{
> -	unsigned long guest_owned_bits;
> -
> -	kvm_register_mark_available(vcpu, reg);
> -
> -	switch (reg) {
> -	case VCPU_REGS_RSP:
> -		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
> -		break;
> -	case VCPU_REGS_RIP:
> -		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
> -		break;
> -	case VCPU_EXREG_PDPTR:
> -		if (enable_ept)
> -			ept_save_pdptrs(vcpu);
> -		break;
> -	case VCPU_EXREG_CR0:
> -		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
> -
> -		vcpu->arch.cr0 &= ~guest_owned_bits;
> -		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
> -		break;
> -	case VCPU_EXREG_CR3:
> -		if (is_unrestricted_guest(vcpu) ||
> -		    (enable_ept && is_paging(vcpu)))
> -			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -		break;
> -	case VCPU_EXREG_CR4:
> -		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
> -
> -		vcpu->arch.cr4 &= ~guest_owned_bits;
> -		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
> -		break;
> -	default:
> -		KVM_BUG_ON(1, vcpu->kvm);
> -		break;
> -	}
> -}
> -
>   static __init int vmx_disabled_by_bios(void)
>   {
>   	return !boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
> @@ -3066,7 +3026,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
>   	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
> +		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
>   	if (!(cr0 & X86_CR0_PG)) {
>   		/* From paging/starting to nonpaging */
>   		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
> 

This shows the problem with #including vmx.c.  You should have a .h file 
for both vmx.h and main.h (e.g. kvm_intel.h), so that here you can just 
use vt_cache_reg.

Paolo

