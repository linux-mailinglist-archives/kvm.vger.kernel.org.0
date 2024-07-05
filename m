Return-Path: <kvm+bounces-21007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A12A7928057
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 099A7B24BCA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8165617BAF;
	Fri,  5 Jul 2024 02:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJyth/0s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C52514292
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146135; cv=none; b=ovLmKWUpkbAhEfaTrL9f21xThayp53NiBp7nupfhvbEry972hSFTd2DGA46SZRMOGVyRUgcfNpwJL1pB8ubC34xqLe6bIPo8qnaLIj8cuNA3tPR8+VuGmODhUczGxpCu8XMImNPM/MTS/QOkB9jkXMijJrOAHBW7kAj+o+j/+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146135; c=relaxed/simple;
	bh=heJyvJ7Ou4jE9PUw+XUE3enpd7PAoPi1ciBbQaemWQo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TQzCuVeMR/cVc67KkrCq/QmRSleiUDbv/h1qICUm4YJVLGM8JiNEkr/ki8zg8vhDOA4HvhsF7fgXNHWID5qQMuf3chCSckjLNWwd/b9f1lHJFi+VYLAFKPfimgDnsFfjvppZF3VQStHM+I/6wkQbBSc2CMNjmVLfuEtZDB8x7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJyth/0s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JDq6AJzIaJAASw1KTig/lzHxZCKW+SYKCR87a1/zvM=;
	b=SJyth/0szhxNhN1oKHTGYxnNiWnztL0uoRH2PXwyAsDSouL0gEzqMfo5FCVFiMipT5VRS8
	mA4PNq0CKgDWEIQ9Ond2eNMvbZXesOJgfiCIBr95UW2s9IwPk7HYpYOBScwg8KcJi2voPr
	f8HGONlkZ1COPpW9nfn0SG9dT6QzxDw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-4T22SmCxPT2FSd5QiNhhQA-1; Thu, 04 Jul 2024 22:22:11 -0400
X-MC-Unique: 4T22SmCxPT2FSd5QiNhhQA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4464caaa6f2so16758171cf.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:22:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146131; x=1720750931;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/JDq6AJzIaJAASw1KTig/lzHxZCKW+SYKCR87a1/zvM=;
        b=GQLyAE8jO0E8DQ99ouZdG+8FQ4vHpLxCS8H1o+jFhjftE0COkhVfN5EffzVc2s0EF7
         Xrf+lipBagJ5FzrxTLYlImBd+wtM2AXxk09nzSNAfCnZ1aLHzrUoeUFbJJy1yIsW78bv
         OZt3MVMemh77D4Z82Gk2rG7X7tcZrvFnE6LELXrH8rb87rX62pa3oYYtiJjnSJ2mjz/D
         jB6cMnzYm54qVFHweUpxpuwS5qyXJNx35iZPHcbsk7Akjfrqt25vr8k1sPIkXpxu7aTc
         sA8narLXfXUx5/tMA/botozq1VDSbPIi6maFRFODP7YoAE422BkIVOuaw+majvc3ifzJ
         zSbg==
X-Gm-Message-State: AOJu0YxZjLvkpimtKUBxK+9pZzZgQBJRwYWamFalWY0mjaSyrtVvbNFu
	v1OH4on61I1DLoj6Op5OgV0qIQrNNOjzYPVwXwY+VU3Q+bD+TGbFJlNkzqBtYhUWER1Or7npIqi
	hPukBl6IdqLFH0n+ei4UVrAHveKPBfMnMBwQ4xbpdHPpbhzJN8A==
X-Received: by 2002:a05:6214:2408:b0:6b0:7f0c:d30e with SMTP id 6a1803df08f44-6b5ecf66b28mr44529936d6.10.1720146131286;
        Thu, 04 Jul 2024 19:22:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEBBM0fSvhq100sjzS7sH/g5iNtdgJma8bEBX3O8emWG3Mq+HzrdvKYtW+vIa3N+o4VYFzUQ==
X-Received: by 2002:a05:6214:2408:b0:6b0:7f0c:d30e with SMTP id 6a1803df08f44-6b5ecf66b28mr44529686d6.10.1720146130937;
        Thu, 04 Jul 2024 19:22:10 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5f114f742sm6980376d6.19.2024.07.04.19.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:22:10 -0700 (PDT)
Message-ID: <030c973172dcf3a24256ddc8ddc5e9ef57ecabcb.camel@redhat.com>
Subject: Re: [PATCH v2 40/49] KVM: x86: Initialize guest cpu_caps based on
 KVM support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:22:09 -0400
In-Reply-To: <20240517173926.965351-41-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-41-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Constrain all guest cpu_caps based on KVM support instead of constraining
> only the few features that KVM _currently_ needs to verify are actually
> supported by KVM.  The intent of cpu_caps is to track what the guest is
> actually capable of using, not the raw, unfiltered CPUID values that the
> guest sees.
> 
> I.e. KVM should always consult it's only support when making decisions
> based on guest CPUID, and the only reason KVM has historically made the
> checks opt-in was due to lack of centralized tracking.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c   | 14 +++++++++++++-
>  arch/x86/kvm/cpuid.h   |  7 -------
>  arch/x86/kvm/svm/svm.c | 11 -----------
>  arch/x86/kvm/vmx/vmx.c |  9 ++-------
>  4 files changed, 15 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d1849fe874ab..8ada1cac8fcb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -403,6 +403,8 @@ static u32 cpuid_get_reg_unsafe(struct kvm_cpuid_entry2 *entry, u32 reg)
>  	}
>  }
>  
> +static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func);
> +
>  void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -421,6 +423,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 */
>  	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
>  		const struct cpuid_reg cpuid = reverse_cpuid[i];
> +		struct kvm_cpuid_entry2 emulated;
>  
>  		if (!cpuid.function)
>  			continue;
> @@ -429,7 +432,16 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		if (!entry)
>  			continue;
>  
> -		vcpu->arch.cpu_caps[i] = cpuid_get_reg_unsafe(entry, cpuid.reg);
> +		cpuid_func_emulated(&emulated, cpuid.function);
> +
> +		/*
> +		 * A vCPU has a feature if it's supported by KVM and is enabled
> +		 * in guest CPUID.  Note, this includes features that are
> +		 * supported by KVM but aren't advertised to userspace!
> +		 */
> +		vcpu->arch.cpu_caps[i] = kvm_cpu_caps[i] | kvm_vmm_cpu_caps[i] |
> +					 cpuid_get_reg_unsafe(&emulated, cpuid.reg);
> +		vcpu->arch.cpu_caps[i] &= cpuid_get_reg_unsafe(entry, cpuid.reg);

Hi,

I have an idea. What if we get rid of kvm_vmm_cpu_caps, and instead advertise the
MWAIT in KVM_GET_EMULATED_CPUID?

MWAIT is sort of emulated as NOP after all, plus features in KVM_GET_EMULATED_CPUID are
sort of 'emulated inefficiently' and you can say that NOP is an inefficient emulation
of MWAIT sort of.

It just feels to me that kvm_vmm_cpu_caps, is somewhat an overkill, and its name is
somewhat confusing.

Other than that this code looks good.


>  	}
>  
>  	kvm_update_cpuid_runtime(vcpu);
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index c2c2b8aa347b..60da304db4e4 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -284,13 +284,6 @@ static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
>  		guest_cpu_cap_clear(vcpu, x86_feature);
>  }
>  
> -static __always_inline void guest_cpu_cap_constrain(struct kvm_vcpu *vcpu,
> -						    unsigned int x86_feature)
> -{
> -	if (!kvm_cpu_cap_has(x86_feature))
> -		guest_cpu_cap_clear(vcpu, x86_feature);
> -}
> -
>  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>  					      unsigned int x86_feature)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1bc431a7e862..946a75771946 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4344,10 +4344,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			     boot_cpu_has(X86_FEATURE_XSAVES) &&
>  			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
>  
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_NRIPS);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_TSCRATEMSR);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LBRV);
> -
>  	/*
>  	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
>  	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
> @@ -4355,13 +4351,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 */
>  	if (guest_cpuid_is_intel(vcpu))
>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> -	else
> -		guest_cpu_cap_constrain(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> -
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PAUSEFILTER);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_PFTHRESHOLD);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VGIF);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VNMI);

Finally, this code is gone.

>  
>  	svm_recalc_instruction_intercepts(vcpu, svm);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d873386e1473..653c4b68ec7f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7836,15 +7836,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
>  	 * set if and only if XSAVE is supported.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
> -	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
> -		guest_cpu_cap_constrain(vcpu, X86_FEATURE_XSAVES);
> -	else
> +	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
>  
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_VMX);
> -	guest_cpu_cap_constrain(vcpu, X86_FEATURE_LAM);

Good riddance!
> -
>  	vmx_setup_uret_msrs(vmx);
>  
>  	if (cpu_has_secondary_exec_ctrls())


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


