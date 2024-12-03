Return-Path: <kvm+bounces-32894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA4C19E1503
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AD63281418
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 08:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8981DDC37;
	Tue,  3 Dec 2024 08:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efqFtwdU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2036E1DB54C;
	Tue,  3 Dec 2024 08:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733212890; cv=none; b=pY87GymTXNd7BqDVeGKlBxdhWcj4cQ8krLzilD9sE6e8A3s4vDMitkdKdH1qGh9LOaih98a+XFL3vPwdIT9cwUVkrFW9r2amkCLh/emYQFKlbJ+6TTix1KyPXEjRMWxgbwVTiFFP6uW6hxM6X2rI/2ct7Koj4tLhV6DUGxKUDmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733212890; c=relaxed/simple;
	bh=ZKJAqQp41SZRunZBqI23p2AD5fXliOJ9+DJTqvaKdBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aU2fTi6PUMAR4znOcNcqfOnapEnTE9nTWiZL9A8srrJB9ma+YQp4p8PZfPI0tU3QCr207NfeIDWcbpsJ+yLiC7uQo9JyaRQF1/HQiJudLXteiLTEmyuuNf3KAuphgWN8QOFNpIkiqjCDw4v+EgbRDYRHdLDpefWv89jZIh8NWKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efqFtwdU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733212888; x=1764748888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZKJAqQp41SZRunZBqI23p2AD5fXliOJ9+DJTqvaKdBc=;
  b=efqFtwdUXBrm4vYWcIg5ApUhPChVhwJ9nlva6ek177URP50D0lnNERe/
   zYvHi7l2qidIMuTppl0GSMlxD9Yz769r4a5i6r1oEzPkEEDj2Csdq4TUW
   siR/PMg8ibWPq+lSc/e00AsxepsykPOICJPnQ0qUdWUV/UrUXkhz2w5xn
   Uc9deNgCs83A9moLqdD8VaRMr8gqYUeEplKS0dSSSp64PQhlW1W4ugALy
   274t3cSYcjE0EWYxCcXh5sHzeKzYPBYZnH3GXXHR08JLOnU0Cs7E9H6IE
   PFIT0vk/jR84PmNiwiYxdTjTK3KCuYsgOzdCmdhrFZ4PqhUVWCX+NAl33
   A==;
X-CSE-ConnectionGUID: NnWLSaIDTWeim00q23vIRQ==
X-CSE-MsgGUID: /om1VUvtTSWf8/jAKffejg==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="50823657"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="50823657"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 00:01:28 -0800
X-CSE-ConnectionGUID: dSCn8zhxTWa51nV7uyuzgQ==
X-CSE-MsgGUID: 1TelqYUfT4m/0GVFI//h4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="93250015"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 00:01:25 -0800
Message-ID: <86e1f270-0bf1-4ac2-9195-4092d21c5888@linux.intel.com>
Date: Tue, 3 Dec 2024 16:01:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into
 a macro
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241128004344.4072099-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Rework __kvm_emulate_hypercall() into a macro so that completion of
> hypercalls that don't exit to userspace use direct function calls to the
> completion helper, i.e. don't trigger a retpoline when RETPOLINE=y.
>
> Opportunistically take the names of the input registers, as opposed to
> taking the input values, to preemptively dedup more of the calling code
> (TDX needs to use different registers).  Use the direct GPR accessors to
> read values to avoid the pointless marking of the registers as available
> (KVM requires GPRs to always be available).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 29 +++++++++--------------------
>   arch/x86/kvm/x86.h | 25 ++++++++++++++++++++-----
>   2 files changed, 29 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 39be2a891ab4..fef8b4e63d25 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9982,11 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> -int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -			    unsigned long a0, unsigned long a1,
> -			    unsigned long a2, unsigned long a3,
> -			    int op_64_bit, int cpl,
> -			    int (*complete_hypercall)(struct kvm_vcpu *))
> +int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			      unsigned long a0, unsigned long a1,
> +			      unsigned long a2, unsigned long a3,
> +			      int op_64_bit, int cpl,
> +			      int (*complete_hypercall)(struct kvm_vcpu *))
>   {
>   	unsigned long ret;
>   
> @@ -10073,32 +10073,21 @@ int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   
>   out:
>   	vcpu->run->hypercall.ret = ret;
> -	complete_hypercall(vcpu);
>   	return 1;
>   }
> -EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> +EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long nr, a0, a1, a2, a3;
> -	int op_64_bit;
> -	int cpl;
> -
>   	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>   		return kvm_xen_hypercall(vcpu);
>   
>   	if (kvm_hv_hypercall_enabled(vcpu))
>   		return kvm_hv_hypercall(vcpu);
>   
> -	nr = kvm_rax_read(vcpu);
> -	a0 = kvm_rbx_read(vcpu);
> -	a1 = kvm_rcx_read(vcpu);
> -	a2 = kvm_rdx_read(vcpu);
> -	a3 = kvm_rsi_read(vcpu);
> -	op_64_bit = is_64_bit_hypercall(vcpu);
> -	cpl = kvm_x86_call(get_cpl)(vcpu);
> -
> -	return __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl,
> +	return __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
> +				       is_64_bit_hypercall(vcpu),
> +				       kvm_x86_call(get_cpl)(vcpu),
>   				       complete_hypercall_exit);
>   }
>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 28adc8ea04bf..ad6fe6159dea 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,11 +617,26 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>   	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>   }
>   
> -int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -			    unsigned long a0, unsigned long a1,
> -			    unsigned long a2, unsigned long a3,
> -			    int op_64_bit, int cpl,
> -			    int (*complete_hypercall)(struct kvm_vcpu *));
> +int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			      unsigned long a0, unsigned long a1,
> +			      unsigned long a2, unsigned long a3,
> +			      int op_64_bit, int cpl,
> +			      int (*complete_hypercall)(struct kvm_vcpu *));
> +
> +#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, complete_hypercall)	\
> +({												\
> +	int __ret;										\
> +												\
> +	__ret = ____kvm_emulate_hypercall(_vcpu,						\
> +					  kvm_##nr##_read(_vcpu), kvm_##a0##_read(_vcpu),	\
> +					  kvm_##a1##_read(_vcpu), kvm_##a2##_read(_vcpu),	\
> +					  kvm_##a3##_read(_vcpu), op_64_bit, cpl,		\
> +					  complete_hypercall);					\
> +												\
> +	if (__ret > 0)										\
> +		complete_hypercall(_vcpu);							\
> +	__ret;											\
> +})
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   


