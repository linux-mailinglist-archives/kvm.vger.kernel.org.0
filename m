Return-Path: <kvm+bounces-63073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 070D7C5A75B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C91303ADA93
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B072E0B5A;
	Thu, 13 Nov 2025 23:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cmkWlEoS"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FBC7083C
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075059; cv=none; b=FyfLrnVKR1A6FnLbakyI9Lxz1YVROlJ0mPlbEAz4vUuRLWwS9fQ4xnUEPIeeceJaYl3CUk7eNuvMOTplLOexYW2+XIT7bzcjiPN4+UBxnc4xxP9n9ZChqU5OZmJYz4xXiJ93hFrTSlIBXNQ022q+1+H6MYONmOUpVvUKI3+cL20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075059; c=relaxed/simple;
	bh=+VaQ0ES65s+1drIbpUZjgzOSmiJKUNrYRP6Uk5FrJnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmxaqULKiVUO8piAZTW1SphuDHKl0sbXAZKOoO76nroT0GZOAb17eKvQBdWIA/SqtylkNTQJm1e4sD9J5h+m7dQMBD1AYyRcVhWmlazOzOMO4ZpRwsIk0b+g2ZisSpt8FMNCcQCNfyiI9JQ4eV/gl+sBAzU9oMOWKpfvmE/QXnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cmkWlEoS; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Nov 2025 23:03:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763075051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JrGZYSBEO9apmamnKTqAWt2/Fv1MDNLBJVmhNnIJxPM=;
	b=cmkWlEoSzhgEc8z1OvFwjOseqwDl2SC6MfZUF8c/+19ym6/ulOWyqN+SxPPn3lq82Mgsx4
	uVfqNpY2QZKw+YotEcyE8JhQq3jg4c3kd+tUYDCkrHcQtvWm4i2ZrySkFNcm99JHHkv+Ab
	HQawXDiSOKvzMAtM3IST5Q9jD6znkCk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 1/9] KVM: nSVM: Clear exit_code_hi in VMCB when
 synthesizing nested VM-Exits
Message-ID: <2fd7bzpxany4ymoqlqlkrtapaxbhnv7xs6nd7hwqnkskyr5jdh@bscvvwnoj7zj>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113225621.1688428-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:56:13PM -0800, Sean Christopherson wrote:
> Explicitly clear exit_code_hi in the VMCB when synthesizing "normal"
> nested VM-Exits, as the full exit code is a 64-bit value (spoiler alert),
> and all exit codes for non-failing VMRUN use only bits 31:0.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 2 ++
>  arch/x86/kvm/svm/svm.h | 7 ++++---
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fc42bcdbb520..7ea034ee6b6c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2433,6 +2433,7 @@ static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
>  
>  	if (cr0 ^ val) {
>  		svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
> +		svm->vmcb->control.exit_code_hi = 0;
>  		ret = (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE);
>  	}
>  
> @@ -4608,6 +4609,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  	if (static_cpu_has(X86_FEATURE_NRIPS))
>  		vmcb->control.next_rip  = info->next_rip;
>  	vmcb->control.exit_code = icpt_info.exit_code;
> +	vmcb->control.exit_code_hi = 0;
>  	vmexit = nested_svm_exit_handled(svm);
>  
>  	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c2acaa49ee1c..253a8dca412c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -763,9 +763,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm);
>  
>  static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
>  {
> -	svm->vmcb->control.exit_code   = exit_code;
> -	svm->vmcb->control.exit_info_1 = 0;
> -	svm->vmcb->control.exit_info_2 = 0;
> +	svm->vmcb->control.exit_code	= exit_code;
> +	svm->vmcb->control.exit_code_hi	= 0;
> +	svm->vmcb->control.exit_info_1	= 0;
> +	svm->vmcb->control.exit_info_2	= 0;
>  	return nested_svm_vmexit(svm);
>  }
>  
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

