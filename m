Return-Path: <kvm+bounces-63098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BFFBC5A938
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A08D64EA301
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50010328608;
	Thu, 13 Nov 2025 23:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V0Ypzelh"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6492A328265
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076542; cv=none; b=FNflsm1nngDbSQG1LftLpQrjMeKYSnNOj8unWEXkE4gEozhKNdqmN94wt7eh9mevkeZ3eU4vpHaWcIrFDFb+2v/3QGgjOF18bI0J219Oa2KP4q2Mg0wuvm5Iey9TTNgbgyyMGBt57lrOUnJM+P7mjRbKgXU9z/maChmXnk+WBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076542; c=relaxed/simple;
	bh=gMZKVQqeY7nZOl/zGkQ22NdBV2O+7XIATtpJrC4fO0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joJMuk4HV2vV6CO8fS9+l6+fkoWOOccVMffk9eVifP9BFUyHwmaejbHMFpwS4eJEKurW9OmykDtOGQ40CSzd/VvfJDM+Hcy2g6Vk9XSWfg6ANH/kJJLy6omzFjz1DRQOyc0grOklzO0WO9ABFWZhFMZ+LqF2skRwf4oZM6iIM8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V0Ypzelh; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 13 Nov 2025 23:28:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763076527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQxu8cfY3zpe4ibXES75EL+tbeWgFHpdhWo+B/hgYak=;
	b=V0YpzelhtM3fC5uMEIqJKM3uqHniHvnPZpifDHAkm6BQjPqEuUCtthZPa9hOdav+hkSfAR
	NeK6JH8DZm59HY6eQERyq5I4cK4qyTDfGsf2L6vFD3J3eO16upX0DvGiI9KzCCH/LukloC
	GDkdnq95PBIKWSlSTnOGhtVgJc97w7w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/9] KVM: nSVM: Set exit_code_hi to -1 when synthesizing
 SVM_EXIT_ERR (failed VMRUN)
Message-ID: <x5sx4ljihax3wzm4kfsiiitd3kq62ymon7ggtxixqsxgwnryj2@f7cq4h72h4xu>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251113225621.1688428-3-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:56:14PM -0800, Sean Christopherson wrote:
> Set exit_code_hi to -1u as a temporary band-aid to fix a long-standing
> (effectively since KVM's inception) bug where KVM treats the exit code as
> a 32-bit value, when in reality it's a 64-bit value.  Per the APM, offset
> 0x70 is a single 64-bit value:
> 
>   070h 63:0 EXITCODE
> 
> And a sane reading of the error values defined in "Table C-1. SVM Intercept
> Codes" is that negative values use the full 64 bits:
> 
>   –1 VMEXIT_INVALID Invalid guest state in VMCB.
>   –2 VMEXIT_BUSYBUSY bit was set in the VMSA
>   –3 VMEXIT_IDLE_REQUIREDThe sibling thread is not in an idle state
>   -4 VMEXIT_INVALID_PMC Invalid PMC state
> 
> And that interpretation is confirmed by testing on Milan and Turin (by
> setting bits in CR0[63:32] to generate VMEXIT_INVALID on VMRUN).
> 
> Furthermore, Xen has treated exitcode as a 64-bit value since HVM support
> was adding in 2006 (see Xen commit d1bd157fbc ("Big merge the HVM
> full-virtualisation abstractions.")).
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c81005b24522..ba0f11c68372 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -985,7 +985,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (!nested_vmcb_check_save(vcpu) ||
>  	    !nested_vmcb_check_controls(vcpu)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> -		vmcb12->control.exit_code_hi = 0;
> +		vmcb12->control.exit_code_hi = -1u;
>  		vmcb12->control.exit_info_1  = 0;
>  		vmcb12->control.exit_info_2  = 0;
>  		goto out;
> @@ -1018,7 +1018,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	svm->soft_int_injected = false;
>  
>  	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
> -	svm->vmcb->control.exit_code_hi = 0;
> +	svm->vmcb->control.exit_code_hi = -1u;
>  	svm->vmcb->control.exit_info_1  = 0;
>  	svm->vmcb->control.exit_info_2  = 0;
>  
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

