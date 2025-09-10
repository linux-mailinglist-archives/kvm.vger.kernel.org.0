Return-Path: <kvm+bounces-57189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8900B512B4
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0EDE1C82767
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83445314B66;
	Wed, 10 Sep 2025 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUCm+0Cc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB93314A7F;
	Wed, 10 Sep 2025 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757497083; cv=none; b=XoGXaCQX79PC2H/5cWVWlo248RsgCNgnc2tKfNp7ZCl0b5zDcfIeioDzgBJ7Zmyt2UngYWzibpsUCWQssn4gatj0+Ra9H1R/2zx44ZkOIl1MN4eQeKQ64hb8SZYIvzDEZ2Fe1eGGCz5Z2FGO6EvOAf54fxZp3g6nJ/DAmnKsS3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757497083; c=relaxed/simple;
	bh=K3S4/YYR0q8eWSDj5bQrQ8p7/okLw1YwfbW83NtyxJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUtMTqbieoUss0ipuakEKZzx0uaFn3bhCN1uu/PIcuBianXgCP1zuKXuO0mlH45Z2GozUEG/mlNsHeqRorHO8KCRvDjpVyDX9k5Z4z7uGizpgTVCjB5TmelnFGun8V89Px7mJzIURoWsiZdMT7xDEKMNUTJbzTzCJ5Y4yHZvA4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUCm+0Cc; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757497082; x=1789033082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K3S4/YYR0q8eWSDj5bQrQ8p7/okLw1YwfbW83NtyxJk=;
  b=CUCm+0CcRMnQxPRsd3/WPaJHmpXf9Fb47d7btCGotty7HdUU50fT356l
   2LGVLmoFqA5mqbG9gjU7R1Ie58RSsZMQlF4pfzfQQ2QKa8cnrG1DwLs6H
   iwINZB4skhrehCe+7Ybt/HOJan99YiAH5vEABzxusRAysV92r6OTHfBhO
   AgJbMBFf+19FM6fwI/pPUFyHGGgPlaL72OBFlCDHiVwAZ8j8/iE7v7fAH
   jMO2kR4MFKN4iPB8aq2iKXBxtdZCI3gudMEauhrPOfNIL5zBZTt+hGro2
   kv4nHwqeUwf4morHzmg+UU5b4m7KIqr1rFJLKCXHVtCO6BpgaIczLzm5U
   w==;
X-CSE-ConnectionGUID: NWsILvWZR5C4/b/unB1nfQ==
X-CSE-MsgGUID: 9AXy5W7ZTza7PEDFTNI1pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="71216806"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="71216806"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:38:01 -0700
X-CSE-ConnectionGUID: nYyyuxHNT0WdC4Vb/XqFhg==
X-CSE-MsgGUID: pTxQS5PpTXmqP5Puv2L3NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173255428"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 02:37:56 -0700
Message-ID: <be3459db-d972-4d46-a48a-2fab1cde7faa@intel.com>
Date: Wed, 10 Sep 2025 17:37:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: acme@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-7-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250909093953.202028-7-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
> to facilitate access to such kind of MSRs.
> 
> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
> the guest MSRs are swapped with host's before vCPU exits to userspace and
> after it reenters kernel before next VM-entry.
> 
> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
> explicitly check @vcpu is non-null before attempting to load guest state.
> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
> loading guest FPU state (which doesn't exist).
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed to
> access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
> 
> The two helpers are put here in order to manifest accessing xsave-managed
> MSRs requires special check and handling to guarantee the correctness of
> read/write to the MSRs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
> v14:
> - s/rdmsrl/rdmsrq, s/wrmsrl/wrmsrq (Xin)
> - return true in is_xstate_managed_msr() for MSR_IA32_S_CET
> ---
>   arch/x86/kvm/x86.c | 36 +++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
>   2 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c15e8c00dc7d..7c0a07be6b64 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>   
>   static DEFINE_MUTEX(vendor_module_lock);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> +
>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>   
>   #define KVM_X86_OP(func)					     \
> @@ -4566,6 +4569,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   }
>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>   
> +/*
> + *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
> + *  switched with the rest of guest FPU state.
> + */
> +static bool is_xstate_managed_msr(u32 index)
> +{
> +	switch (index) {
> +	case MSR_IA32_S_CET:
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   /*
>    * Read or write a bunch of msrs. All parameters are kernel addresses.
>    *
> @@ -4576,11 +4595,26 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>   		    int (*do_msr)(struct kvm_vcpu *vcpu,
>   				  unsigned index, u64 *data))
>   {
> +	bool fpu_loaded = false;
>   	int i;
>   
> -	for (i = 0; i < msrs->nmsrs; ++i)
> +	for (i = 0; i < msrs->nmsrs; ++i) {
> +		/*
> +		 * If userspace is accessing one or more XSTATE-managed MSRs,
> +		 * temporarily load the guest's FPU state so that the guest's
> +		 * MSR value(s) is resident in hardware, i.e. so that KVM can
> +		 * get/set the MSR via RDMSR/WRMSR.
> +		 */
> +		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&

why not check vcpu->arch.guest_supported_xss?

> +		    is_xstate_managed_msr(entries[i].index)) {
> +			kvm_load_guest_fpu(vcpu);
> +			fpu_loaded = true;
> +		}
>   		if (do_msr(vcpu, entries[i].index, &entries[i].data))
>   			break;
> +	}
> +	if (fpu_loaded)
> +		kvm_put_guest_fpu(vcpu);
>   
>   	return i;
>   }
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index eb3088684e8a..34afe43579bb 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -701,4 +701,28 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   
> +/*
> + * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
> + * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
> + * guest FPU should have been loaded already.
> + */
> +
> +static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	rdmsrq(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
> +static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr_info)
> +{
> +	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
> +	kvm_fpu_get();
> +	wrmsrq(msr_info->index, msr_info->data);
> +	kvm_fpu_put();
> +}
> +
>   #endif


