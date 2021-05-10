Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3D8377E33
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhEJIam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230170AbhEJIam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aiylawv9j3zw+mXYVlxJhWqN7bVZYJ6wJJblRxw4nBk=;
        b=Qi7qnCZtJDIhYXmkRao7ms6UVthiLud55lbPO3jJsoRIo5wn2gCPz4HvqzZ9AQBq8PlIV0
        duH7loLcSiGMYF0QQfOuE4l8WiYYESXbjvM9clP885cLoBpsjNa6rwdGZuIWgIGQ5UMqbt
        LfRW129/txSFhVtlk1+C74HeXXOGIN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-eSv2Og9KO8SSvh0QCBNv4Q-1; Mon, 10 May 2021 04:29:33 -0400
X-MC-Unique: eSv2Og9KO8SSvh0QCBNv4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCA6C107AD30;
        Mon, 10 May 2021 08:29:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A602E380;
        Mon, 10 May 2021 08:29:28 +0000 (UTC)
Message-ID: <7e75b44c0477a7fb87f83962e4ea2ed7337c37e5.camel@redhat.com>
Subject: Re: [PATCH 14/15] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:29:27 +0300
In-Reply-To: <20210504171734.1434054-15-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-15-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Squish the Intel and AMD emulation of MSR_TSC_AUX together and tie it to
> the guest CPU model instead of the host CPU behavior.  While not strictly
> necessary to avoid guest breakage, emulating cross-vendor "architecture"
> will provide consistent behavior for the guest, e.g. WRMSR fault behavior
> won't change if the vCPU is migrated to a host with divergent behavior.
> 
> Note, the "new" kvm_is_supported_user_return_msr() checks do not add new
> functionality on either SVM or VMX.  On SVM, the equivalent was
> "tsc_aux_uret_slot < 0", and on VMX the check was buried in the
> vmx_find_uret_msr() call at the find_uret_msr label.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 +++++
>  arch/x86/kvm/svm/svm.c          | 24 ----------------------
>  arch/x86/kvm/vmx/vmx.c          | 15 --------------
>  arch/x86/kvm/x86.c              | 36 +++++++++++++++++++++++++++++++++
>  4 files changed, 41 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a4b912f7e427..00fb9efb9984 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1782,6 +1782,11 @@ int kvm_add_user_return_msr(u32 msr);
>  int kvm_find_user_return_msr(u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
> +static inline bool kvm_is_supported_user_return_msr(u32 msr)
> +{
> +	return kvm_find_user_return_msr(msr) >= 0;
> +}
> +
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index de921935e8de..6c7c6a303cc5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2663,12 +2663,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
>  		break;
>  	case MSR_TSC_AUX:
> -		if (tsc_aux_uret_slot < 0)
> -			return 1;
> -		if (!msr_info->host_initiated &&
Not related to this patch, but I do wonder why do we need
to always allow writing this msr if done by the host,
since if neither RDTSPC nor RDPID are supported, the guest
won't be able to read this msr at all.


> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> -			return 1;
>  		msr_info->data = svm->tsc_aux;
>  		break;
>  	/*
> @@ -2885,24 +2879,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
>  		break;
>  	case MSR_TSC_AUX:
> -		if (tsc_aux_uret_slot < 0)
> -			return 1;
> -
> -		if (!msr->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> -			return 1;
> -
> -		/*
> -		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
> -		 * incomplete and conflicting architectural behavior.  Current
> -		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
> -		 * reserved and always read as zeros.  Emulate AMD CPU behavior
> -		 * to avoid explosions if the vCPU is migrated from an AMD host
> -		 * to an Intel host.
> -		 */
> -		data = (u32)data;
> -
>  		/*
>  		 * TSC_AUX is usually changed only during boot and never read
>  		 * directly.  Intercept TSC_AUX instead of exposing it to the
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 26f82f302391..d85ac5876982 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1981,12 +1981,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> -	case MSR_TSC_AUX:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> -			return 1;
> -		goto find_uret_msr;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  		break;
> @@ -2302,15 +2296,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> -	case MSR_TSC_AUX:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> -			return 1;
> -		/* Check reserved bit, higher 32 bits should be zero */
> -		if ((data >> 32) != 0)
> -			return 1;
> -		goto find_uret_msr;
>  	case MSR_IA32_PERF_CAPABILITIES:
>  		if (data && !vcpu_to_pmu(vcpu)->version)
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index adca491d3b4b..896127ea4d4f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1642,6 +1642,30 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  		 * invokes 64-bit SYSENTER.
>  		 */
>  		data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
> +		break;
> +	case MSR_TSC_AUX:
> +		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
> +			return 1;
> +
> +		if (!host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> +			return 1;
> +
> +		/*
> +		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
> +		 * incomplete and conflicting architectural behavior.  Current
> +		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
> +		 * reserved and always read as zeros.  Enforce Intel's reserved
> +		 * bits check if and only if the guest CPU is Intel, and clear
> +		 * the bits in all other cases.  This ensures cross-vendor
> +		 * migration will provide consistent behavior for the guest.
> +		 */
> +		if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
> +			return 1;
> +
> +		data = (u32)data;
> +		break;
>  	}
>  
>  	msr.data = data;
> @@ -1678,6 +1702,18 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
>  		return KVM_MSR_RET_FILTERED;
>  
> +	switch (index) {
> +	case MSR_TSC_AUX:
> +		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
> +			return 1;
> +
> +		if (!host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> +			return 1;
> +		break;
> +	}
> +
>  	msr.index = index;
>  	msr.host_initiated = host_initiated;
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

