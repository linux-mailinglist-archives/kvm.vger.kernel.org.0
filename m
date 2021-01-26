Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E530473D
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389892AbhAZRHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 12:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405781AbhAZQdE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 11:33:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611678697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2Y2CW5pjrTFlbr8X4jblLq+HUbom2Mq//dMTHDECc4=;
        b=G1kElh2ViZR4Go6CInLb1NKXE/tlBwekhKQcySHCqbEw+Z6GBapxJXELZFiqgK8eQgoHAL
        nG7ghaQ3ZHjIgnpPgkg+uuqfSsAWunojFz8fHkXPAr+01nYSYDOec92xKcDSSZquojCCLK
        SPw7oe6Qz0c39Gd95DkVvjpdxI2yuyU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-SoRhWuqOP_-uy63K7UM9Lw-1; Tue, 26 Jan 2021 11:31:35 -0500
X-MC-Unique: SoRhWuqOP_-uy63K7UM9Lw-1
Received: by mail-ej1-f72.google.com with SMTP id dc21so5140047ejb.19
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:31:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2Y2CW5pjrTFlbr8X4jblLq+HUbom2Mq//dMTHDECc4=;
        b=bxWwHMnXxl1EUD+IPlNZCINKpYj8NSZXP+cd/nfMvZ3LCom/EXdzIIXSFOhZnYF2jO
         FBNANIAMbSLvnZ5EmjtODIQoXgN7HNFd5N+K71TBaOx6VN/lxQMKy8oo74KDpsF5H44y
         YC2TAsr3aJLndfo7BGbKTm543WzogSNwMZS2JS2FsEnh83R7QiikKVZqyxrdZdc3SSt5
         lhWFUT1Edzui4q/utouMNwPImayFDUpC5crgVJMTbE2NznTrW4J0o5VMjAzuq+oBMRf9
         Vqby+6rlEhnyQrabqcAR+7CTJHjkwsR4i1C6MlXG7iura1QVEm2/A/c05DBGcFimRpo8
         rYfw==
X-Gm-Message-State: AOAM5302fLDXrNSErT1ISKmRBJNg68mHYvL6dStuU1fAoy7+QiVWVP1k
        bT26HDb52/C5lzHHfwlhof2/GU8N3L0Ar6ac8z0SkVAQihgUnua0Dwc/ZQghO2qPzpcIJE5MSUY
        SzxgMrYwu/D2b
X-Received: by 2002:a05:6402:18f:: with SMTP id r15mr5431819edv.53.1611678694420;
        Tue, 26 Jan 2021 08:31:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDEiGhXDOZ0je0P9Euzn3jEWrj0fTIiNEG/VxaB9/orPDlLcBP1w6rnV42V12/9yYMlN4/YA==
X-Received: by 2002:a05:6402:18f:: with SMTP id r15mr5431795edv.53.1611678694193;
        Tue, 26 Jan 2021 08:31:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m26sm9947142ejr.54.2021.01.26.08.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:31:33 -0800 (PST)
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108064924.1677-1-chenyi.qiang@intel.com>
 <20210108064924.1677-2-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RESEND PATCH 1/2] KVM: X86: Add support for the emulation of
 DR6_BUS_LOCK bit
Message-ID: <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
Date:   Tue, 26 Jan 2021 17:31:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108064924.1677-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 07:49, Chenyi Qiang wrote:
> To avoid breaking the CPUs without bus lock detection, activate the
> DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.
> 
> The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
> register. The processor clears DR6_BUS_LOCK when bus lock debug
> exception is generated. (For all other #DB the processor sets this bit
> to 1.) Software #DB handler should set this bit before returning to the
> interrupted task.
> 
> For VM exit caused by debug exception, bit 11 of the exit qualification
> is set to indicate that a bus lock debug exception condition was
> detected. The VMM should emulate the exception by clearing bit 11 of the
> guest DR6.

Please rename DR6_INIT to DR6_ACTIVE_LOW, and then a lot of changes 
become simpler:

> -		dr6 |= DR6_BD | DR6_RTM;
> +		dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;

dr6 |= DR6_BD | DR6_ACTIVE_LOW;

>   		ctxt->ops->set_dr(ctxt, 6, dr6);
>   		return emulate_db(ctxt);
>   	}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cce0143a6f80..3d8a0e30314f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1860,7 +1860,7 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>   	get_debugreg(vcpu->arch.db[2], 2);
>   	get_debugreg(vcpu->arch.db[3], 3);
>   	/*
> -	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
> +	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM|DR6_BUS_LOCK here,

We cannot reset svm->vmcb->save.dr6 to DR6_ACTIVE_LOW

>   	 * because db_interception might need it.  We can do it before vmentry.
>   	 */
>   	vcpu->arch.dr6 = svm->vmcb->save.dr6;
> @@ -1911,7 +1911,7 @@ static int db_interception(struct vcpu_svm *svm)
>   	if (!(svm->vcpu.guest_debug &
>   	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
>   		!svm->nmi_singlestep) {
> -		u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
> +		u32 payload = (svm->vmcb->save.dr6 ^ (DR6_RTM|DR6_BUS_LOCK)) & ~DR6_FIXED_1;

u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;

>   		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
>   		return 1;
>   	}
> @@ -3778,7 +3778,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   	if (unlikely(svm->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
>   		svm_set_dr6(svm, vcpu->arch.dr6);
>   	else
> -		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM);
> +		svm_set_dr6(svm, DR6_FIXED_1 | DR6_RTM | DR6_BUS_LOCK);

svm_set_dr6(svm, DR6_ACTIVE_LOW);

>   
>   	clgi();
>   	kvm_load_guest_xsave_state(vcpu);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e2f26564a12d..c5d71a9b3729 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -412,7 +412,7 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
>   			if (!has_payload) {
>   				payload = vcpu->arch.dr6;
>   				payload &= ~(DR6_FIXED_1 | DR6_BT);
> -				payload ^= DR6_RTM;
> +				payload ^= DR6_RTM | DR6_BUS_LOCK;

payload &= ~DR6_BT;
payload ^= DR6_ACTIVE_LOW;

>   			}
>   			*exit_qual = payload;
>   		} else
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3f7c1fc7a3ce..06de2b9e57f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -483,19 +483,20 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu)
>   		 */
>   		vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>   		/*
> -		 * DR6.RTM is set by all #DB exceptions that don't clear it.
> +		 * DR6.RTM and DR6.BUS_LOCK are set by all #DB exceptions
> +		 * that don't clear it.
>   		 */
> -		vcpu->arch.dr6 |= DR6_RTM;
> +		vcpu->arch.dr6 |= DR6_RTM | DR6_BUS_LOCK;
>   		vcpu->arch.dr6 |= payload;
>   		/*
> -		 * Bit 16 should be set in the payload whenever the #DB
> -		 * exception should clear DR6.RTM. This makes the payload
> -		 * compatible with the pending debug exceptions under VMX.
> -		 * Though not currently documented in the SDM, this also
> -		 * makes the payload compatible with the exit qualification
> -		 * for #DB exceptions under VMX.
> +		 * Bit 16/Bit 11 should be set in the payload whenever
> +		 * the #DB exception should clear DR6.RTM/DR6.BUS_LOCK.
> +		 * This makes the payload compatible with the pending debug
> +		 * exceptions under VMX. Though not currently documented in
> +		 * the SDM, this also makes the payload compatible with the
> +		 * exit qualification for #DB exceptions under VMX.
>   		 */
> -		vcpu->arch.dr6 ^= payload & DR6_RTM;
> +		vcpu->arch.dr6 ^= payload & (DR6_RTM | DR6_BUS_LOCK);

vcpu->arch.dr6 &= ~DR_TRAP_BITS;
vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
vcpu->arch.dr6 |= payload;
vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;

(with comments :))

and so on.

Thanks!

Paolo

>   
>   		/*
>   		 * The #DB payload is defined as compatible with the 'pending
> @@ -1126,6 +1127,9 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
>   
>   	if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
>   		fixed |= DR6_RTM;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> +		fixed |= DR6_BUS_LOCK;
>   	return fixed;
>   }
>   
> @@ -7197,7 +7201,8 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
>   	struct kvm_run *kvm_run = vcpu->run;
>   
>   	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> -		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM;
> +		kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1 | DR6_RTM |
> +					  DR6_BUS_LOCK;
>   		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
>   		kvm_run->debug.arch.exception = DB_VECTOR;
>   		kvm_run->exit_reason = KVM_EXIT_DEBUG;
> @@ -7241,7 +7246,8 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>   					   vcpu->arch.eff_db);
>   
>   		if (dr6 != 0) {
> -			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
> +			kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM |
> +						  DR6_BUS_LOCK;
>   			kvm_run->debug.arch.pc = eip;
>   			kvm_run->debug.arch.exception = DB_VECTOR;
>   			kvm_run->exit_reason = KVM_EXIT_DEBUG;
> 

