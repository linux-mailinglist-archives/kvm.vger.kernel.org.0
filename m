Return-Path: <kvm+bounces-13976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4673F89D593
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 11:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEE09284FEF
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 09:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CFF80029;
	Tue,  9 Apr 2024 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgaVIP8j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333DA7FBC0;
	Tue,  9 Apr 2024 09:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712654892; cv=none; b=Eb84yXfxZ5ifqboxHDYHdqy5OAu/HUFVo9jIt0WYyfq7hxRjVwcEqpNdsn7OWuISmi9P36EGR8vGBEmZVTfNmxO3fqisvUVqIxrIYktSurquSM2lZ4vwiGx3draqEU4851JIDJCkuM/N02AkeR+eEH/z4Z1jotZproktrkzSCkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712654892; c=relaxed/simple;
	bh=VoJ8ZdxNnf5Ly4hU62H933il+lzRT2qk2o5pp6nco08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HItvsnXn85XdmdHOuGQJ3n3iKtQ4VAbGnZWZgYacWSAGLU6U6xySGY7KoB34xo4GF+XoZn4neB3QExocFHZUwedsHo2R0E75ONwCF8VeDtNbODcvIGH/0jJGODzGGNUpOGjGk20VhnEkUlOUj/rPhimvjK/YsfKJdVJ6gZqbkjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgaVIP8j; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712654892; x=1744190892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VoJ8ZdxNnf5Ly4hU62H933il+lzRT2qk2o5pp6nco08=;
  b=PgaVIP8j7ki9ztOmoUp1ARBDBSXATO4xWyu15qdqd8rK/7JL7hBWNcJY
   XBf7fZvdc04Sap1TEo0eoHPb/qgUGtsPWcCGMSY6YJByJTcYmhn1kznBf
   Y9ipztmo7rUE+eYJRfXXld7XMrNfDJ+EZtJvf54UAI27yd7PP1Wxu2cIc
   PC8x12ouFqzjcFqL92ynGycfa76GZMlcTl/eb0cJq0c7b7I23v2wwYFLd
   tINM8AE9NnwqEO7eM60Y6tZJYzDg5M9HPyufLfhjtgDrCqor6zcB+gGCg
   0iFjSOdb6ovLocYnrXIqakY+Zds5UDPl5CjjK8LFv7Bypc1ROw/ZAui4w
   w==;
X-CSE-ConnectionGUID: vukaHeYmSJCZIWyhGkHzMQ==
X-CSE-MsgGUID: 0SOzjeTFQxyBrzN4A8ILEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="18527311"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="18527311"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 02:28:11 -0700
X-CSE-ConnectionGUID: 5xCYZL8qSFe11zSgyHZzqA==
X-CSE-MsgGUID: KCrSgwiSTGyTyUrYeTITkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="20121992"
Received: from unknown (HELO [10.238.9.252]) ([10.238.9.252])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 02:28:07 -0700
Message-ID: <73394dea-81d9-469c-b94f-6d58bfca186a@linux.intel.com>
Date: Tue, 9 Apr 2024 17:28:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 097/130] KVM: x86: Split core of hypercall emulation
 to helper function
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> By necessity, TDX will use a different register ABI for hypercalls.
> Break out the core functionality so that it may be reused for TDX.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 +++
>   arch/x86/kvm/x86.c              | 56 ++++++++++++++++++++++-----------
>   2 files changed, 42 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e0ffef1d377d..bb8be091f996 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2177,6 +2177,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +				      unsigned long a0, unsigned long a1,
> +				      unsigned long a2, unsigned long a3,
> +				      int op_64_bit, int cpl);
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb7597c22f31..03950368d8db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10073,26 +10073,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +				      unsigned long a0, unsigned long a1,
> +				      unsigned long a2, unsigned long a3,
> +				      int op_64_bit, int cpl)
>   {
> -	unsigned long nr, a0, a1, a2, a3, ret;
> -	int op_64_bit;
> -
> -	if (kvm_xen_hypercall_enabled(vcpu->kvm))
> -		return kvm_xen_hypercall(vcpu);
> -
> -	if (kvm_hv_hypercall_enabled(vcpu))
> -		return kvm_hv_hypercall(vcpu);
> -
> -	nr = kvm_rax_read(vcpu);
> -	a0 = kvm_rbx_read(vcpu);
> -	a1 = kvm_rcx_read(vcpu);
> -	a2 = kvm_rdx_read(vcpu);
> -	a3 = kvm_rsi_read(vcpu);
> +	unsigned long ret;
>   
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
> -	op_64_bit = is_64_bit_hypercall(vcpu);
>   	if (!op_64_bit) {
>   		nr &= 0xFFFFFFFF;
>   		a0 &= 0xFFFFFFFF;
> @@ -10101,7 +10090,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   		a3 &= 0xFFFFFFFF;
>   	}
>   
> -	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> +	if (cpl) {
>   		ret = -KVM_EPERM;
>   		goto out;
>   	}
> @@ -10162,18 +10151,49 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   
>   		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
>   		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> +		/* stat is incremented on completion. */
>   		return 0;
>   	}
>   	default:
>   		ret = -KVM_ENOSYS;
>   		break;
>   	}
> +
>   out:
> +	++vcpu->stat.hypercalls;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> +
> +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long nr, a0, a1, a2, a3, ret;
> +	int op_64_bit;

Can it be opportunistically changed to bool type, as well as the 
argument type of "op_64_bit" in __kvm_emulate_hypercall()?

> +	int cpl;
> +
> +	if (kvm_xen_hypercall_enabled(vcpu->kvm))
> +		return kvm_xen_hypercall(vcpu);
> +
> +	if (kvm_hv_hypercall_enabled(vcpu))
> +		return kvm_hv_hypercall(vcpu);
> +
> +	nr = kvm_rax_read(vcpu);
> +	a0 = kvm_rbx_read(vcpu);
> +	a1 = kvm_rcx_read(vcpu);
> +	a2 = kvm_rdx_read(vcpu);
> +	a3 = kvm_rsi_read(vcpu);
> +	op_64_bit = is_64_bit_hypercall(vcpu);
> +	cpl = static_call(kvm_x86_get_cpl)(vcpu);
> +
> +	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> +	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> +		/* MAP_GPA tosses the request to the user space. */
> +		return 0;
> +
>   	if (!op_64_bit)
>   		ret = (u32)ret;
>   	kvm_rax_write(vcpu, ret);
>   
> -	++vcpu->stat.hypercalls;
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);


