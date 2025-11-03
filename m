Return-Path: <kvm+bounces-61898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1C4C2D7F7
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D94D74E7E81
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 17:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FCB31B81B;
	Mon,  3 Nov 2025 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iRY5OW2v"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548B731A7EF
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191477; cv=none; b=tJfFKYGbK2WzevFkEhD8TapCMIyINXUAo0Pe9o9O0hLZ6IE/8mKE579WMm+I6taKyNFkDsCBGN5wzgSNYSulvgNfPdYXhqPeSvY6uKWU+WdlktzjEay1VuOZ1sCWXG1KZjanqPmkcds+pma933akXJ9w7I1Ze0i/og+HallPJUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191477; c=relaxed/simple;
	bh=xqz4WzvJURSvMfg4fXw5jdyzp2LCtNwdfxevWCUymCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcPb8GrQnNMGJYeNDxLPFJzy+vkjQpTbFQgIgkImU1x2vMuGO3Wk2pkNXQwPKyy+ZamHic01IzR5y5NOWaBCkh8MddhPJahYEC8Dy1X/e6aWBWQ3iBn55CsR6Du8KXb5YZgv2sKhafi4S6+U5+NhVe8TyXAfwQ9Ba4AiaiALjHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iRY5OW2v; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Nov 2025 17:37:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762191473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrXJcvJ5q+6UswBqh5m9xLcbLR++GyO51UqODPezDQQ=;
	b=iRY5OW2veAytDt6YKC+QDL9mjOXLqZN5eEw5PbPMeswV+RE7fnv6+1JJZix5sMw9kJmdqP
	lSt41DS34E51ef0b+nHzvO2FyM+/7dU7vsxVvSyoyvy1nAVx4phC1Pp1jRpLHZo2dfJYwj
	rlBWCwx4At8R2rBJzylcwLm/BIZBu2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
Message-ID: <ojg5bq2guzb6hk7q7n2przo2ygkra6boavhhq7u5kptygu6jij@5nvgdi3preqg>
References: <20251030185004.3372256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 30, 2025 at 11:50:03AM -0700, Sean Christopherson wrote:
> Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> KVM doesn't know how to handle.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/svm.c          |  7 +------
>  arch/x86/kvm/vmx/tdx.c          |  6 +-----
>  arch/x86/kvm/vmx/vmx.c          |  9 +--------
>  arch/x86/kvm/x86.c              | 12 ++++++++++++
>  5 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..4fbe4b7ce1da 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
>  void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>  
>  void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f14709a511aa..83e0d4d5f4c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
>  
>  static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
>  {
> -	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
>  	dump_vmcb(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
>  	return 0;
>  }

We can probably drop svm_handle_invalid_exit() entirely now, but looks
good either way:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..079d9f13eddb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2145,11 +2145,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>  	}
>  
>  unhandled_exit:
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = vp_enter_ret;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, vp_enter_ret);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1021d3b65ea0..08f7957ed4c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6642,15 +6642,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
>  
>  unexpected_vmexit:
> -	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> -		    exit_reason.full);
>  	dump_vmcs(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror =
> -			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_reason.full;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4b5d2d09634..c826cd05228a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9110,6 +9110,18 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_event_vectoring_exit);
>  
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason)
> +{
> +	vcpu_unimpl(vcpu, "unexpected exit reason 0x%llx\n", exit_reason);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +	vcpu->run->internal.ndata = 2;
> +	vcpu->run->internal.data[0] = exit_reason;
> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_unexpected_reason_exit);
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> 
> base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
> -- 
> 2.51.1.930.gacf6e81ea2-goog
> 

