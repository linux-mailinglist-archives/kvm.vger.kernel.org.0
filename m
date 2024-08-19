Return-Path: <kvm+bounces-24537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 294ED956EDF
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D6F51F22609
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDCB7E0E4;
	Mon, 19 Aug 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gFbNXDUg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CF560DCF
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724081712; cv=none; b=rApxBg6EI49yYqWFOYUy4REPJrjIooSp0COBcaysiRJhjEXKZJ9gJBvQscWrblmJTN6vZm9EXLWcq7j2kayKVspMGPLyPLDPaHtPvgudDtOMPnbiMDVFbk1/Fx13QcdDBmKoRPIyjWnQTLkDYHhzkvmH8P6epJsxxnYh42gNRRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724081712; c=relaxed/simple;
	bh=YLF37eAQvh5lgzpaTo0MKTkIxfxfpfBfhUqCi+d75HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9dGI93HlhERbHgMQIwj/mDxkbA9hWkh2AqHZVm2dvbKPsOx0znTzlPwd42WJYd/ZmmjA9Szo5b6n9pWUJ97rSI6spZCvDBzhzURWKm2rw8Mlw9Y+heecPrJBp9udng1FSJOmIwZUFB52juDGt8jyzh/NDhbkQ0RgNXQKydiIFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gFbNXDUg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5bed83487aeso3157398a12.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 08:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724081707; x=1724686507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dm5ql1wu8/2cGvWBZTZR9lu7EO5dAqH855O0OBVNN/Y=;
        b=gFbNXDUgnLP3rWouvHy6v1C7QKnYuuW6hYV91JEmvFEjvjKshWwCyBMTrq/QQbwlrM
         xnSxdtrO+OT0A3EPIn47BagCyqnlCi93aBVjWwwLrZkDQOWYv1kcc1Uvgl2AphT9J1qP
         Avo7pX948Pml5v3VBh6SYYPHjhuL1gC/6yFnYeGZmE4b2OKFc+JNQ8ZEz7kYhJ2v5nps
         yfVxZdDhxftypX1IR9rJN9I8KsxHnjB6ZxsneuOX8j+BuDlDMvXaZis1arlWLjvDuPh/
         essX4hSenyO6KWIm4To2pDEVeCyXY07N0q9v2uttPZ0cSiio3nfrfl4aJzw+pQ5K8Gx7
         uwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724081707; x=1724686507;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dm5ql1wu8/2cGvWBZTZR9lu7EO5dAqH855O0OBVNN/Y=;
        b=DPsoDhvXkX50Fcku+FY3s73ylvfEs3aoocOQhISZcmj2r+7wxhUdrCsEklZfqU0cgD
         WNwLz2DwG+HTqz9UNnGtm8lIovtK1Gp+sLoBGE/5no7roz4/yV1KbBi6EhdQplaN6ZoQ
         F0XIfE9lwQiS+52rkDQpl80hv3quVHRIxo968WdSA8RsstwPg1V2BGYnF871RRK9vsLk
         jleF57qGIeJdXL7Udgp+RCajO6o6gzsMQPiPkQmn1tk8Q06MPXmo3upFtpxK0P3B1H0h
         Wjec8p0ettdQYtY8fnox+MghJQB6KCpNGtscUM6ps9zir9OtLwTy4s1x3SFzLTS7oeFu
         rMiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWijshqYhgJV/l/AayVWr6NKMRTsSMBbAshN5QkRVAIvJOYJX2qPsA1tLDf4k7ZbnCUToGOs+0ngQAwCxu2ytlmIXGb
X-Gm-Message-State: AOJu0YxyIXFBHGlBqoX1R8/GMP8A3IH1rVYf5ZMHsumaDzMjwi0k2edt
	YiB0+4hIU9ZRtJzIc6MAxnrxxDdlW67ovh/aH76qX2vRFfzrOw2/RxZWDSDo200=
X-Google-Smtp-Source: AGHT+IHQZLpXQGD7OozKacrfpk6EoO3Ok9YaSaMuer8G09xpVdnjAu1IukKXkwLshDH8A+aKZzWi1g==
X-Received: by 2002:a05:6402:274d:b0:5be:dbbb:2d49 with SMTP id 4fb4d7f45d1cf-5bedbbb33b9mr6414525a12.1.1724081707068;
        Mon, 19 Aug 2024 08:35:07 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe2707sm5686408a12.7.2024.08.19.08.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 08:35:06 -0700 (PDT)
Message-ID: <822766d1-746a-4b15-b790-d1e331e4d9aa@suse.com>
Date: Mon, 19 Aug 2024 18:35:05 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240812224820.34826-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> After the crypto-protection key has been configured, TDX requires a
> VM-scope initialization as a step of creating the TDX guest.  This
> "per-VM" TDX initialization does the global configurations/features that
> the TDX guest can support, such as guest's CPUIDs (emulated by the TDX
> module), the maximum number of vcpus etc.
> 
> This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
> initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
> to be done before KVM creates any vcpus.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Drop TDX_TD_XFAM_CET and use XFEATURE_MASK_CET_{USER, KERNEL}.
>   - Update for the wrapper functions for SEAMCALLs. (Sean)
>   - Move gfn_shared_mask settings into this patch due to MMU section move
>   - Fix bisectability issues in headers (Kai)
>   - Updates from seamcall overhaul (Kai)
>   - Allow userspace configure xfam directly
>   - Check if user sets non-configurable bits in CPUIDs
>   - Rename error->hw_error
>   - Move code change to tdx_module_setup() to __tdx_bringup() due to
>     initializing is done in post hardware_setup() now and
>     tdx_module_setup() is removed.  Remove the code to use API to read
>     global metadata but use exported 'struct tdx_sysinfo' pointer.
>   - Replace 'tdx_info->nr_tdcs_pages' with a wrapper
>     tdx_sysinfo_nr_tdcs_pages() because the 'struct tdx_sysinfo' doesn't
>     have nr_tdcs_pages directly.
>   - Replace tdx_info->max_vcpus_per_td with the new exported pointer in
>     tdx_vm_init().
>   - Decrease the reserved space for struct kvm_tdx_init_vm (Kai)
>   - Use sizeof_field() for struct kvm_tdx_init_vm cpuids (Tony)
>   - No need to init init_vm, it gets copied over in tdx_td_init() (Chao)
>   - Use kmalloc() instead of () kzalloc for init_vm in tdx_td_init() (Chao)
>   - Add more line breaks to tdx_td_init() to make code easier to read (Tony)
>   - Clarify patch description (Kai)
> 
> v19:
>   - Check NO_RBP_MOD of feature0 and set it
>   - Update the comment for PT and CET
> 
> v18:
>   - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
>   - typo in comment. sha348 => sha384
>   - updated comment in setup_tdparams_xfam()
>   - fix setup_tdparams_xfam() to use init_vm instead of td_params
> 
> v16:
>   - Removed AMX check as the KVM upstream supports AMX.
>   - Added CET flag to guest supported xss
> ---
>   arch/x86/include/uapi/asm/kvm.h |  24 ++++
>   arch/x86/kvm/cpuid.c            |   7 +
>   arch/x86/kvm/cpuid.h            |   2 +
>   arch/x86/kvm/vmx/tdx.c          | 237 ++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.h          |   4 +
>   arch/x86/kvm/vmx/tdx_ops.h      |  12 ++
>   6 files changed, 276 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 2e3caa5a58fd..95ae2d4a4697 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -929,6 +929,7 @@ struct kvm_hyperv_eventfd {
>   /* Trust Domain eXtension sub-ioctl() commands. */
>   enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
> +	KVM_TDX_INIT_VM,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> @@ -970,4 +971,27 @@ struct kvm_tdx_capabilities {
>   	struct kvm_tdx_cpuid_config cpuid_configs[];
>   };
>   
> +struct kvm_tdx_init_vm {
> +	__u64 attributes;
> +	__u64 xfam;
> +	__u64 mrconfigid[6];	/* sha384 digest */
> +	__u64 mrowner[6];	/* sha384 digest */
> +	__u64 mrownerconfig[6];	/* sha384 digest */
> +
> +	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
> +	__u64 reserved[12];
> +
> +	/*
> +	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
> +	 * KVM_SET_CPUID2.
> +	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
> +	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
> +	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
> +	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
> +	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
> +	 * module doesn't virtualize.
> +	 */
> +	struct kvm_cpuid2 cpuid;
> +};
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2617be544480..7310d8a8a503 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1487,6 +1487,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   	return r;
>   }
>   
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
> +	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
> +{
> +	return cpuid_entry2_find(entries, nent, function, index);
> +}
> +EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
> +
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index)
>   {
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 41697cca354e..00570227e2ae 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
>   
>   void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>   void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
> +struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
> +					       int nent, u32 function, u64 index);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
>   						    u32 function, u32 index);
>   struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a0954c3928e2..a6c711715a4a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -7,6 +7,7 @@
>   #include "tdx.h"
>   #include "tdx_ops.h"
>   
> +
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> @@ -356,12 +357,16 @@ static int tdx_do_tdh_mng_key_config(void *param)
>   	return 0;
>   }
>   
> -static int __tdx_td_init(struct kvm *kvm);
> -
>   int tdx_vm_init(struct kvm *kvm)
>   {
>   	kvm->arch.has_private_mem = true;
>   
> +	/*
> +	 * This function initializes only KVM software construct.  It doesn't
> +	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
> +	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
> +	 */

If you need to put a comment like that it means the function has the 
wrong name.

> +
>   	/*
>   	 * TDX has its own limit of the number of vcpus in addition to
>   	 * KVM_MAX_VCPUS.

<snip>

> +
> +static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> +			 u64 *seamcall_err)

What criteria did you use to split __tdx_td_init from tdx_td_init? Seems 
somewhar arbitrary, I think it's best if the TD VM init code is in a 
single function, yet it will be rather large but the code should be 
self-explanatory and fairly linear. Additionally I think some of the 
code can be factored out in more specific helpers i.e the key 
programming bits can be a separate helper.

>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   	cpumask_var_t packages;
> @@ -427,8 +547,9 @@ static int __tdx_td_init(struct kvm *kvm)
>   	unsigned long tdr_pa = 0;
>   	unsigned long va;
>   	int ret, i;
> -	u64 err;
> +	u64 err, rcx;
>   
> +	*seamcall_err = 0;
>   	ret = tdx_guest_keyid_alloc();
>   	if (ret < 0)
>   		return ret;
> @@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
>   		}
>   	}
>   
> -	/*
> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> -	 * ioctl() to define the configure CPUID values for the TD.
> -	 */
> +	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
> +		/*
> +		 * Because a user gives operands, don't warn.
> +		 * Return a hint to the user because it's sometimes hard for the
> +		 * user to figure out which operand is invalid.  SEAMCALL status
> +		 * code includes which operand caused invalid operand error.
> +		 */
> +		*seamcall_err = err;
> +		ret = -EINVAL;
> +		goto teardown;
> +	} else if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
> +		ret = -EIO;
> +		goto teardown;
> +	}
> +
>   	return 0;
>   
>   	/*
> @@ -592,6 +726,86 @@ static int __tdx_td_init(struct kvm *kvm)
>   	return ret;
>   }
>   
> +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm *init_vm;
> +	struct td_params *td_params = NULL;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
> +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> +
> +	if (is_hkid_assigned(kvm_tdx))
> +		return -EINVAL;
> +
> +	if (cmd->flags)
> +		return -EINVAL;
> +
> +	init_vm = kmalloc(sizeof(*init_vm) +
> +			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			  GFP_KERNEL);
> +	if (!init_vm)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
> +		ret = -E2BIG;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(init_vm->cpuid.entries,
> +			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
> +			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (init_vm->cpuid.padding) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
> +	if (!td_params) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = setup_tdparams(kvm, td_params, init_vm);
> +	if (ret)
> +		goto out;
> +
> +	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> +	else
> +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> +
> +out:
> +	/* kfree() accepts NULL. */
> +	kfree(init_vm);
> +	kfree(td_params);
> +
> +	return ret;
> +}
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_tdx_cmd tdx_cmd;
> @@ -613,6 +827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_TDX_CAPABILITIES:
>   		r = tdx_get_capabilities(&tdx_cmd);
>   		break;
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 268959d0f74f..8912cb6d5bc2 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -16,7 +16,11 @@ struct kvm_tdx {
>   	unsigned long tdr_pa;
>   	unsigned long *tdcs_pa;
>   
> +	u64 attributes;
> +	u64 xfam;
>   	int hkid;
> +
> +	u64 tsc_offset;
>   };
>   
>   struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 3f64c871a3f2..0363d8544f42 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -399,4 +399,16 @@ static inline u64 tdh_vp_wr(struct vcpu_tdx *tdx, u64 field, u64 val, u64 mask)
>   	return seamcall(TDH_VP_WR, &in);
>   }
>   
> +static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> +{
> +	u64 err, data;
> +
> +	err = tdh_mng_rd(kvm_tdx, TDCS_EXEC(field), &data);
> +	if (unlikely(err)) {
> +		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
> +		return 0;
> +	}
> +	return data;
> +}
> +
>   #endif /* __KVM_X86_TDX_OPS_H */

