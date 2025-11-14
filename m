Return-Path: <kvm+bounces-63123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AB5C5AB63
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7D9634E7066
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3E386329;
	Fri, 14 Nov 2025 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uSPuR97R"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED81E505
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078819; cv=none; b=TpX72gzgtobIouhDA2NXhVQoJ1tXy+o0BHm99EB6cTmEWC08cGithX6aRAtwPLEFJhsSBCFcaQc2rvo/qEkw9kGb2I+4GTAfPw+gk5x7SuwEU9HtQiGL5+o37H6DrFbvue4L4dNmqHahNHT8P9NhQXzRxd6k13QUx5z/AW0Abmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078819; c=relaxed/simple;
	bh=R33AdgTjSR1SWKU3UPzVhhkvLoRemUWmq48vjSWAjtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1uz5p+/JvOifCwtQggGQsEmnvCFApdhv7NEgIc92aR71JD8wuj9aMC0viSgiAuMc7G7t2dkSXvbqkozLWa5RkA9u1fBNL5RPtkkeS0YdElmQ4myyUb31ZDqgdtwtHqRwkbN5C4fE04LD/iT/EIfAuEyLsw2yZFB3FDY3EbwbOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uSPuR97R; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 00:06:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763078814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Li0/cPd0Ha1pYMgeIuNhanlXxtY5IF4nmf8wn3pJB6I=;
	b=uSPuR97RDn+UI2sQer/AiPNjItMLdP/Z9251mA8/dWRxL+R6jAzQspgmv9yF90VsuEehiP
	8s6BW4BEVMn4OF6yBfJQUpzVBNM1FnYYAfUSoHCur0vYaFa9CCJkZej29tDWbWLtTOuaeZ
	H+A52yEQ1dze5ObyR0MxoNRKn/X6++c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Filter out 64-bit exit codes when invoking
 exit handlers on bare metal
Message-ID: <ajyebe4aiouvjm6craaamaq4nrlgs64ccziexpxdet6cl5yr53@gum4bwvwq5aa>
References: <20251113225621.1688428-1-seanjc@google.com>
 <20251113225621.1688428-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113225621.1688428-7-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 02:56:18PM -0800, Sean Christopherson wrote:
> Explicitly filter out 64-bit exit codes when invoking exit handlers, as
> svm_exit_handlers[] will never be sized with entries that use bits 63:32.
> 
> Processing the non-failing exit code as a 32-bit value will allow tracking
> exit_code as a single 64-bit value (which it is, architecturally).  This
> will also allow hardening KVM against Spectre-like attacks without needing
> to do silly things to avoid build failures on 32-bit kernels
> (array_index_nospec() rightly asserts that the index fits in an "unsigned
> long").
> 
> Omit the check when running as a VM, as KVM has historically failed to set
> bits 63:32 appropriately when synthesizing VM-Exits, i.e. KVM could get
> false positives when running as a VM on an older, broken KVM/kernel.  From
> a functional perspective, omitting the check is "fine", as any unwanted
> collision between e.g. VMEXIT_INVALID and a 32-bit exit code will be
> fatal to KVM-on-KVM regardless of what KVM-as-L1 does.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 202a4d8088a2..3b05476296d0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3433,8 +3433,22 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  		sev_free_decrypted_vmsa(vcpu, save);
>  }
>  
> -int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
> +int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 __exit_code)
>  {
> +	u32 exit_code = __exit_code;
> +
> +	/*
> +	 * SVM uses negative values, i.e. 64-bit values, to indicate that VMRUN
> +	 * failed.  Report all such errors to userspace (note, VMEXIT_INVALID,
> +	 * a.k.a. SVM_EXIT_ERR, is special cased by svm_handle_exit()).  Skip
> +	 * the check when running as a VM, as KVM has historically left garbage
> +	 * in bits 63:32, i.e. running KVM-on-KVM would hit false positives if
> +	 * the underlying kernel is buggy.
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
> +	    (u64)exit_code != __exit_code)
> +		goto unexpected_vmexit;
> +
>  #ifdef CONFIG_MITIGATION_RETPOLINE
>  	if (exit_code == SVM_EXIT_MSR)
>  		return msr_interception(vcpu);
> @@ -3461,7 +3475,7 @@ int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code)
>  
>  unexpected_vmexit:
>  	dump_vmcb(vcpu);
> -	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
> +	kvm_prepare_unexpected_reason_exit(vcpu, __exit_code);
>  	return 0;
>  }
>  
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

