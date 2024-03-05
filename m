Return-Path: <kvm+bounces-10871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 498898715D5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:25:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3DE8B21D52
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07CB7D09B;
	Tue,  5 Mar 2024 06:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irfwNRNO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EBB7BAE1;
	Tue,  5 Mar 2024 06:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709619889; cv=none; b=rInq46Eqa/mYd/USNXlEhtx9VwTZCL5R4kffBUov6LTgKU5P7iMGKbvKtH0mHeKJIjgCJWJz/TcydmOGJuYcyZMVTaBIBGvHTgmMIYmkiN9sHHar9xGGdHuDucXrma42HY3/EYmdidclav6SJt4e+tYg9b38u1DfFt+q1gCHSJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709619889; c=relaxed/simple;
	bh=Gp8RDpqAbtBudoNJG6a7uMv4LSn5RgcxXgofHv8t050=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrqNLltb0plc1ATZ1cbyg+bZaqyR2UW8RVVB4zGvCN8yMMaMLtIbtKIZyNB0suCKJqtcVG2KrB18kchnUEfYxa9C5F8UN4ARv7CYEgwSlFmcgVFPxusZwK887IW+5ZDaB23JZSgK8q1zgA8E4XRx7xHUHqaY1wrs/IxYuySbQk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irfwNRNO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709619888; x=1741155888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gp8RDpqAbtBudoNJG6a7uMv4LSn5RgcxXgofHv8t050=;
  b=irfwNRNOn+m6NcSccmIMLn3KYYqqDvc1MtMVqWHBSyNErSmh3TH8u4hI
   GSK0EXL8UlsSTgHOnnlesty09gMO+M1PaNOD92HDS5pMqp17bfgSyFwZT
   rGfrFAVM8NRn9DbMjP7RPDC52EZmMmrvpsR6v+IdN5oIER05HwP44bbfP
   NgvCiI96Q75U3XdLvSHJZ+86Wvmwyyhok952OeJPCL9qs2QX+e/5VL5ct
   24pXsqAqWeQ/r8n+YIf2UW5kwk4GTWo4AtnofOhMPMmVVvw+ZI/U3G1gZ
   dnP4CUjxbgZNau7E1rgD58r72zJ15Cf98iucMHtPp7W81JsxuNKJRWTNK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="21606638"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="21606638"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 22:24:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="13952277"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.218]) ([10.238.8.218])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 22:24:45 -0800
Message-ID: <258e607d-d01c-4674-b6d0-c967fd805018@linux.intel.com>
Date: Tue, 5 Mar 2024 14:24:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/21] KVM: x86: Split core of hypercall emulation to
 helper function
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-2-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> By necessity, TDX will use a different register ABI for hypercalls.
> Break out the core functionality so that it may be reused for TDX.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <5134caa55ac3dec33fb2addb5545b52b3b52db02.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  4 +++
>   arch/x86/kvm/x86.c              | 56 ++++++++++++++++++++++-----------
>   2 files changed, 42 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 724a0c778f79..85dc0f7d09e3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2133,6 +2133,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
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
> index b9dfe3179332..f10a5a617120 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10046,26 +10046,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
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
> @@ -10074,7 +10063,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   		a3 &= 0xFFFFFFFF;
>   	}
>   
> -	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> +	if (cpl) {
>   		ret = -KVM_EPERM;
>   		goto out;
>   	}
> @@ -10135,18 +10124,49 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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


