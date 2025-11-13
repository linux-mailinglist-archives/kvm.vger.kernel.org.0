Return-Path: <kvm+bounces-63101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 42708C5A9B1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id D050A20054
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86702330329;
	Thu, 13 Nov 2025 23:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nGgLUSV5"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4332ED3D
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076671; cv=none; b=UZxFueBBfrr4tci8ijRI22v1MSStC/I95MxOtcW6enjBNmaU9KAVHBdyv1xdyQitpPmGWi5RCpoHBu/rbODWfBUY+alilWGQxq/QucMmtOj6nekh+vupPQVdWfVy+4Y9TVu8q8JxBi/JGeIkcXl3GTBRe3JwsOV9KxPCujMZOJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076671; c=relaxed/simple;
	bh=DAbCs//mtPxd5k85nUUfTqCOJpzRV6pSf90G2PjiY5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FerfTEw9KiuuSIBKthZ5pxyU24ORVQGuVSiU5cygv3RqaEjj55sRSYLVwupnICmJfvgIkPL642PL9DLs0PGhA90EVHEFBnC48NUeB/h4lKwXTKSErOe+VVHerlPA2S5y3p5rglqfakJQc5W1O2+DxRdwRVAvF/mMu+9yPlsms7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nGgLUSV5; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Nov 2025 23:30:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763076665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kBbQ2CJNsfMBaqbZTQqlMMMsF+slfZDXMrzVY/zHEPA=;
	b=nGgLUSV5szEJY6hsbUE4dE79IjX84miz4QTSXl3E9rQLtAFbG+Qo/3Ip+iKgqSOCsvKJlF
	YRigJJF9gQemE+GsQ7IYdYKElwueaUM+r8r/QO/HGL0RwZP6TJUJi021S5iPJua3Rubk5V
	eaTI/3+vPhQmAf2CPTmAJWv8QuM5Tcg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/9] KVM: SVM: Add a helper to detect VMRUN failures
Message-ID: <ellmjkhqmgpsbhc4if3emhn3fzbqd3ji4u2dnyvmub6bjgfnti@vtvjhn5cjwrs>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113225621.1688428-4-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:56:15PM -0800, Sean Christopherson wrote:
> Add a helper to detect VMRUN failures so that KVM can guard against its
> own long-standing bug, where KVM neglects to set exitcode[63:32] when
> synthesizing a nested VMFAIL_INVALID VM-Exit.  This will allow fixing
> KVM's mess of treating exitcode as two separate 32-bit values without
> breaking KVM-on-KVM when running on an older, unfixed KVM.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/nested.c | 16 +++++++---------
>  arch/x86/kvm/svm/svm.c    |  4 ++--
>  arch/x86/kvm/svm/svm.h    |  5 +++++
>  3 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ba0f11c68372..8070e20ed5a7 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1134,7 +1134,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
>  	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
>  
> -	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
> +	if (svm_is_vmrun_failure(vmcb12->control.exit_code))

This was flipped, wasn't it?

>  		nested_save_pending_event_to_vmcb12(svm, vmcb12);
>  
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> @@ -1425,6 +1425,9 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>  	u32 exit_code = svm->vmcb->control.exit_code;
>  	int vmexit = NESTED_EXIT_HOST;
>  
> +	if (svm_is_vmrun_failure(exit_code))
> +		return NESTED_EXIT_DONE;
> +
>  	switch (exit_code) {
>  	case SVM_EXIT_MSR:
>  		vmexit = nested_svm_exit_handled_msr(svm);
> @@ -1432,7 +1435,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>  	case SVM_EXIT_IOIO:
>  		vmexit = nested_svm_intercept_ioio(svm);
>  		break;
> -	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
> +	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f:
>  		/*
>  		 * Host-intercepted exceptions have been checked already in
>  		 * nested_svm_exit_special.  There is nothing to do here,
> @@ -1440,15 +1443,10 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>  		 */
>  		vmexit = NESTED_EXIT_DONE;
>  		break;
> -	}
> -	case SVM_EXIT_ERR: {
> -		vmexit = NESTED_EXIT_DONE;
> -		break;
> -	}
> -	default: {
> +	default:
>  		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
>  			vmexit = NESTED_EXIT_DONE;
> -	}
> +		break;
>  	}
>  
>  	return vmexit;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ea034ee6b6c..52b759408853 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3530,7 +3530,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  			return 1;
>  	}
>  
> -	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
> +	if (svm_is_vmrun_failure(svm->vmcb->control.exit_code)) {
>  		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
>  		kvm_run->fail_entry.hardware_entry_failure_reason
>  			= svm->vmcb->control.exit_code;
> @@ -4302,7 +4302,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  
>  		/* Track VMRUNs that have made past consistency checking */
>  		if (svm->nested.nested_run_pending &&
> -		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
> +		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
>                          ++vcpu->stat.nested_run;
>  
>  		svm->nested.nested_run_pending = 0;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 253a8dca412c..6b35925e3a33 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -426,6 +426,11 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>  	return container_of(vcpu, struct vcpu_svm, vcpu);
>  }
>  
> +static inline bool svm_is_vmrun_failure(u64 exit_code)
> +{
> +	return (u32)exit_code == (u32)SVM_EXIT_ERR;
> +}
> +
>  /*
>   * Only the PDPTRs are loaded on demand into the shadow MMU.  All other
>   * fields are synchronized on VM-Exit, because accessing the VMCB is cheap.
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

