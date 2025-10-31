Return-Path: <kvm+bounces-61648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB9CC234D4
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 06:44:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA18E1A62830
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 05:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DBB2DA75B;
	Fri, 31 Oct 2025 05:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="uT/cmhNa"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA54125A0;
	Fri, 31 Oct 2025 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761889458; cv=none; b=qKwluZY0WZiOnexRGvk/wFnVAitGCKdTGhzi/1YfA8h4Yv8zuodbi8TKNW9wLg63ZCjVjYr17U2pHRU2ec3TsRc0Eb64rZQCTjCy3B7j3oDMHchhPiZghiL/bJKbD8gZnh2ntyl4O/vcJZ3QECSzvGVX+Z9vkTmCNAkV6J9ve+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761889458; c=relaxed/simple;
	bh=hJZcwaREdyooTw7ekMFhetoz3m4WKC3YzfAuftLEIn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtn6/Vw1v4HEWOaIIeyromaWSM/KPZeSwXhCUa5GyVP9loQuP+PjgfGu5ig6irAyfwhXmDSwsrjvwxKV1fEglQ9dojzyUtUSDbKhRKEAd32sLyja2JvGES+M2PQNzqMm6x/sWX8b5slXUscYdL2XbB133+WcEkjcwfzg2W1Pz+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=uT/cmhNa; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761889452; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=prp471TDpmlGTa1VRCbwN+HtEDRrSF74UDrkF5mmx9g=;
	b=uT/cmhNaypWnogdEKkueYvkREyBroAZ00i3vLysvUnG12g7gp7qWGmNwCjeeRKv1nERZO1s87GZyVnF3NKKaz44l25623F1oIBnlZenTaF0c2mi9TBGdFO+IZzg+3XBMUcecgwAdRtDu9Dlc4PqHyo05dAZVgOCR6DVIPgTo+Aw=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WrNrsWB_1761889451 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Oct 2025 13:44:12 +0800
Date: Fri, 31 Oct 2025 13:44:11 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
Message-ID: <bophxumzbp2yuovzhvt62jeb5e6vwc2mirvcl6uyztse5mqvjt@xmbhgmqnpn5d>
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

On Thu, Oct 30, 2025 at 11:50:03AM +0800, Sean Christopherson wrote:
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

I like the dedup, and this brings above for tdx which not
before. Just one small thing: Will it be better if keep the
"vmx"/"svm" hint as before and plus the "tdx" hint yet ?

Reviewed-by: Yao Yuan <yaoyuan@linux.alibaba.com>

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

