Return-Path: <kvm+bounces-32733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFCE9DB3E9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDF161666DF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 385E214F9D6;
	Thu, 28 Nov 2024 08:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AC7qpo50"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5588F14B945;
	Thu, 28 Nov 2024 08:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783140; cv=none; b=Nh449VsxDqi/zftSVsC9UQLk3DRUiM4C6YmATeoBchI+0mFaSQNVZZ7CPLhyHnzK6mYrxNq8z4SdGFkeNyrZDbzL0J7h7MRaxRyGn5a4YnKwKHGoRNiBUPg9CEe9iQEvOcguSYGsNVB54B+5cj5OxE7mjQdJdYH8DgYCzVoS0+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783140; c=relaxed/simple;
	bh=QHNUYOXfKmBqQs4XnAF2SqCz5YEJFGvdWeQ5oQ3T1X0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fojQIhEI4NRE7XY/0VyQHoWviufEeiKACOrNt5brzp7mYBJez1l9QRU/QsFsMJc8e/dXOqK8enGWKsRIUmjQEDZK+5+jhn1mVT+PstZVdH4S6ZT0nWkjkCmd+YCI66VKbtXD8YxTBiHbQcMaGrObZ/FdMJk7QQWr4wH7XYb+NRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AC7qpo50; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732783138; x=1764319138;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QHNUYOXfKmBqQs4XnAF2SqCz5YEJFGvdWeQ5oQ3T1X0=;
  b=AC7qpo508b0VNyoOXwffNsS0n2Be03GnbpSdSrqQ+tIRmFit97V2pMtz
   4Fvusvigs/6uPo9kw2nEpFeAZjqxMj8lx32QDhc7rZVBDuz0GhBEh/iJy
   JmcnB5sKEJKoofocsGPK4quWaWemfT6ehDgSkeQvkMIN56gr2QZNB+AzI
   1UnH78oGMQeVZ5o8UhPweffvNfQz00N4dhOUbHqgBAhur36WnF6b62geL
   BY/Bwkm0Gw9RkBmpdimiau5hjhmXDWassHwVIbATrLoR022f4LZDfhUca
   SE5B3bIDssERjg9KPiJpMpGtsaWwEgDiC1SzFleJbHZJGYnhq0sd0c740
   w==;
X-CSE-ConnectionGUID: 7Imu0u4PTziQJahBSYEp7Q==
X-CSE-MsgGUID: Cfh3gLOyTta8036JCDKcUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43620703"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="43620703"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2024 00:38:58 -0800
X-CSE-ConnectionGUID: sNLpTX62QCunniYqJJCCnw==
X-CSE-MsgGUID: P4/3DxJ+T32elzTSK64SYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="91989605"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.89.141])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2024 00:38:54 -0800
Message-ID: <90577aad-552a-4cf8-a4a3-a4efcf997455@intel.com>
Date: Thu, 28 Nov 2024 10:38:49 +0200
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
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-7-seanjc@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20241128004344.4072099-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/11/24 02:43, Sean Christopherson wrote:
> Rework __kvm_emulate_hypercall() into a macro so that completion of
> hypercalls that don't exit to userspace use direct function calls to the
> completion helper, i.e. don't trigger a retpoline when RETPOLINE=y.
> 
> Opportunistically take the names of the input registers, as opposed to
> taking the input values, to preemptively dedup more of the calling code
> (TDX needs to use different registers).  Use the direct GPR accessors to
> read values to avoid the pointless marking of the registers as available
> (KVM requires GPRs to always be available).

For TDX, there is an RFC relating to using descriptively
named parameters instead of register names for tdh_vp_enter():

	https://lore.kernel.org/all/fa817f29-e3ba-4c54-8600-e28cf6ab1953@intel.com/

Please do give some feedback on that approach.  Note we
need both KVM and x86 maintainer approval for SEAMCALL
wrappers like tdh_vp_enter().

As proposed, that ends up with putting the values back into
vcpu->arch.regs[] for __kvm_emulate_hypercall() which is not
pretty:

 static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int r;
 
+	kvm_r10_write(vcpu, tdx->vp_enter_args.tdcall.fn);
+	kvm_r11_write(vcpu, tdx->vp_enter_args.tdcall.subfn);
+	kvm_r12_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p2);
+	kvm_r13_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p3);
+	kvm_r14_write(vcpu, tdx->vp_enter_args.tdcall.vmcall.p4);
+
 	/*
 	 * ABI for KVM tdvmcall argument:
 	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
@@ -1092,13 +1042,12 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
 	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
 	 * number.
-	 *
-	 * R10: KVM hypercall number
-	 * arguments: R11, R12, R13, R14.
 	 */
 	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
 				    R10, complete_hypercall_exit);
 
+	tdvmcall_set_return_code(vcpu, kvm_r10_read(vcpu));
+
 	return r > 0;
 }

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 29 +++++++++--------------------
>  arch/x86/kvm/x86.h | 25 ++++++++++++++++++++-----
>  2 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 39be2a891ab4..fef8b4e63d25 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9982,11 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
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
>  {
>  	unsigned long ret;
>  
> @@ -10073,32 +10073,21 @@ int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  
>  out:
>  	vcpu->run->hypercall.ret = ret;
> -	complete_hypercall(vcpu);
>  	return 1;
>  }
> -EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> +EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long nr, a0, a1, a2, a3;
> -	int op_64_bit;
> -	int cpl;
> -
>  	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>  		return kvm_xen_hypercall(vcpu);
>  
>  	if (kvm_hv_hypercall_enabled(vcpu))
>  		return kvm_hv_hypercall(vcpu);
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
>  				       complete_hypercall_exit);
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 28adc8ea04bf..ad6fe6159dea 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,11 +617,26 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>  	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>  }
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
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>  


