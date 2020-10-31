Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858492A17FF
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 14:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgJaNyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 09:54:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727679AbgJaNyy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 09:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604152492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acvOMl8A2yF1lo53E2BeyOXqnsCqIbQUDjczLPpsU8s=;
        b=BQquafB63MrG8WGETpMM1/EYKJspQduOpMPcaHjFAy778b8kKA29ie23GCHuolWyjXpGkz
        WveXpUMW2yLpt0JYsMIMuRMyuXvnG8vgcBd7vbaay9Zl2+5QSMsM7P1JAgTOSRjmyg6PYY
        m0OWXyTPjAtfBNAs1RZt6+sOcObm3Hk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-jnO0IFCoMZOMCG63iBOkVA-1; Sat, 31 Oct 2020 09:54:50 -0400
X-MC-Unique: jnO0IFCoMZOMCG63iBOkVA-1
Received: by mail-wm1-f70.google.com with SMTP id o19so2117303wme.2
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 06:54:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=acvOMl8A2yF1lo53E2BeyOXqnsCqIbQUDjczLPpsU8s=;
        b=uDLOJ5xmnxvM18/j7Pa9a0IYrdklJ42tOcSyPA4CiP57XeGczcrx1+MlfSNYrK75F+
         aB4DVwFuXB+PPTJya8HTEfy75NQWhmcyyRlV+udChIoqsB2P6ytRDLOuBL2ZQWc17BHm
         7o2XQu50t1yIqo/vXflCanjInL7i4JVgcq1uF5uhRj+jTOkeKJ5xfwzFSSpMuuN1It8A
         SJKUFxvgRk8x0S4di8pd6JygeHobeFAiClkpmtbsx1rL0FmD6TMabyyb7zz1bt7dcEHC
         xfrO5Jg+JRC/Pap9X93wCkraMmmJTkwqL01tV9q9cdyL548w3TovLwtSldIgSEJT+h3/
         hlSw==
X-Gm-Message-State: AOAM5313OVgTeNv2vuSqXSnYztlVgQmZBNryRoQVZ31ejvaZr5Kv/zcT
        tOi6yFd2+qquV0YMBlPtW0ttEqxoRRrMijPvZI8P4tp+BOqr4yXfPhE1mhrMZvChX7bSR3ltV9W
        LQ9GTj0KRrQiQ
X-Received: by 2002:a1c:2d5:: with SMTP id 204mr1968963wmc.181.1604152489005;
        Sat, 31 Oct 2020 06:54:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6lK0pWqaCciELzuEafOp0xTQILnLMclDUWLFriA2LdUs8MF8wjPqNaDY9HDB/jHlo8LBB5Q==
X-Received: by 2002:a1c:2d5:: with SMTP id 204mr1968947wmc.181.1604152488767;
        Sat, 31 Oct 2020 06:54:48 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id y2sm14816105wrh.0.2020.10.31.06.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 06:54:47 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Sink cpuid update into vendor-specific set_cr4
 functions
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Abhiroop Dabral <adabral@paloaltonetworks.com>,
        Ricardo Koller <ricarkol@google.com>,
        Peter Shier <pshier@google.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>,
        Dexuan Cui <dexuan.cui@intel.com>,
        Huaitong Han <huaitong.han@intel.com>
References: <20201029170648.483210-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <32c28bcf-285c-757f-8155-e2c6b81a947f@redhat.com>
Date:   Sat, 31 Oct 2020 14:54:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029170648.483210-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/20 18:06, Jim Mattson wrote:
> On emulated VM-entry and VM-exit, update the CPUID bits that reflect
> CR4.OSXSAVE and CR4.PKE.
> 
> This fixes a bug where the CPUID bits could continue to reflect L2 CR4
> values after emulated VM-exit to L1. It also fixes a related bug where
> the CPUID bits could continue to reflect L1 CR4 values after emulated
> VM-entry to L2. The latter bug is mainly relevant to SVM, wherein
> CPUID is not a required intercept. However, it could also be relevant
> to VMX, because the code to conditionally update these CPUID bits
> assumes that the guest CPUID and the guest CR4 are always in sync.
> 
> Fixes: 8eb3f87d903168 ("KVM: nVMX: fix guest CR4 loading when emulating L2 to L1 exit")
> Fixes: 2acf923e38fb6a ("KVM: VMX: Enable XSAVE/XRSTOR for guest")
> Fixes: b9baba86148904 ("KVM, pkeys: expose CPUID/CR4 to guest")
> Reported-by: Abhiroop Dabral <adabral@paloaltonetworks.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Cc: Haozhong Zhang <haozhong.zhang@intel.com>
> Cc: Dexuan Cui <dexuan.cui@intel.com>
> Cc: Huaitong Han <huaitong.han@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 1 +
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  arch/x86/kvm/vmx/vmx.c | 5 +++++
>  arch/x86/kvm/x86.c     | 8 --------
>  4 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 06a278b3701d..661732be33f5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -139,6 +139,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  					   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  
>  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2f32fd09e259..78163e345e84 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1699,6 +1699,10 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	cr4 |= host_cr4_mce;
>  	to_svm(vcpu)->vmcb->save.cr4 = cr4;
>  	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
> +
> +	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> +		kvm_update_cpuid_runtime(vcpu);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d14c94d0aff1..bd2cb47f113b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3095,6 +3095,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
> +	unsigned long old_cr4 = vcpu->arch.cr4;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	/*
>  	 * Pass through host's Machine Check Enable value to hw_cr4, which
> @@ -3166,6 +3167,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  
>  	vmcs_writel(CR4_READ_SHADOW, cr4);
>  	vmcs_writel(GUEST_CR4, hw_cr4);
> +
> +	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> +		kvm_update_cpuid_runtime(vcpu);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 397f599b20e5..e95c333724c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1014,9 +1014,6 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
>  		kvm_mmu_reset_context(vcpu);
>  
> -	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
> -		kvm_update_cpuid_runtime(vcpu);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_cr4);
> @@ -9522,7 +9519,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  {
>  	struct msr_data apic_base_msr;
>  	int mmu_reset_needed = 0;
> -	int cpuid_update_needed = 0;
>  	int pending_vec, max_bits, idx;
>  	struct desc_ptr dt;
>  	int ret = -EINVAL;
> @@ -9557,11 +9553,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	vcpu->arch.cr0 = sregs->cr0;
>  
>  	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
> -	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
> -				(X86_CR4_OSXSAVE | X86_CR4_PKE));
>  	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
> -	if (cpuid_update_needed)
> -		kvm_update_cpuid_runtime(vcpu);
>  
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  	if (is_pae_paging(vcpu)) {
> 

Queued, thanks.

Paolo

