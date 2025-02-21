Return-Path: <kvm+bounces-38828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B835EA3EAC9
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 03:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 668AA172BC2
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D0C21D5160;
	Fri, 21 Feb 2025 02:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1F+I2/U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A88BA34;
	Fri, 21 Feb 2025 02:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740105115; cv=none; b=Xk/wQJOf5vDYfjAjRKh1dUHlxnc02DRk9QBIggxewOjMs/UNry2uGTeyNwC58tVtMtog9mwcMkeziFDUUjpxSPToA5LMhC6vJsVX21GMrtozL8/FJl+0IjsFTL3iGx1O1vbKm2R+OIHim4iMP+geA7bppC8eGatcRAH2f5dWdoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740105115; c=relaxed/simple;
	bh=BWlNHIH0/AOJFiGGyXRBUuBMFb7JWpAod8K4GJRzKVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fdzt2dZIhxNyXuOr8RBZexGhFyLj+yGk57XlEpaYLbGwjcXQZIRcVWECKjp0uds5wmnF+YRxVU5UtYr7AiMAUXFBQKHgATpp6JwLoVmMditP1ZbeKxHTy6BeHdf4vL5DIDA5pLzDB34WBdX5VmCoSHJpk4ZnrklMTv7/o2JJssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1F+I2/U; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740105113; x=1771641113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BWlNHIH0/AOJFiGGyXRBUuBMFb7JWpAod8K4GJRzKVg=;
  b=h1F+I2/UMuE9yfrUh/lhYAeYksOLVvNvCZuGOR3RpVux7AFrGZ6mQoDr
   7wCqX36RGqWv8qfVbDqmLjXJNCv55u7K+obpDnDmYXxr8kYDAExQpqKWP
   LJsgqMs4kKBUBcqVNLUsqoDhs5cWNkbt5EwBh4VrWfqqssaP8vDGSrtb+
   QPw07MXDm2W/Dinz8svMNeByGeLA52hfTJjMhWDUMzONrSMcbyBptngju
   WdIpWNuK/Pl6TB6euFZHaVmXLjOCKCRoViZlU5DzztHE9fAO9FZ9a1FqN
   e3apg6NZC6iiuYvDPg5o46IoS90KOP8OayCUFlAi2lpEH3HVEGYIV5V0Z
   Q==;
X-CSE-ConnectionGUID: NaD4bsj5QqqmW9bBd47GYw==
X-CSE-MsgGUID: xOs4cpBSTdWXoIeu0wUDWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="41175443"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="41175443"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 18:31:52 -0800
X-CSE-ConnectionGUID: Hy45tasLSa2KlaLlXC9Qjg==
X-CSE-MsgGUID: mqxwaQ9bRWu2IhY+mfzPNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="152428172"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 18:31:50 -0800
Message-ID: <1a959b69-5256-4c6e-8287-d36bf2b9339c@intel.com>
Date: Fri, 21 Feb 2025 10:31:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/30] KVM: TDX: initialize VM with TDX specific
 parameters
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, Yan Zhao <yan.y.zhao@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
 <20250220170604.2279312-24-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250220170604.2279312-24-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/2025 1:05 AM, Paolo Bonzini wrote:

...

> @@ -403,8 +412,9 @@ int tdx_vm_init(struct kvm *kvm)
>   	 */
>   	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
>   
> -	/* Place holder for TDX specific logic. */
> -	return __tdx_td_init(kvm);

it moves __tdx_td_init() from KVM_CRAETE_VM->tdx_vm_init() to ...

> +	kvm_tdx->state = TD_STATE_UNINITIALIZED;
> +
> +	return 0;
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
> +	if (kvm_tdx->state != TD_STATE_UNINITIALIZED)
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

... KVM_TDX_INIT_VM, which moves the keyid allocation, TDR/TDCS page 
allocation and other works from KVM_CREATE_VM to KVM_TDX_INIT_VM as well.

I'm not sure if it is intentional, or by accident. There is no 
mentioning and justfication of it.

> +	if (ret)
> +		goto out;
> +
> +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->attributes = td_params->attributes;
> +	kvm_tdx->xfam = td_params->xfam;
> +
> +	kvm_tdx->state = TD_STATE_INITIALIZED;
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
> @@ -647,6 +882,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>   	case KVM_TDX_CAPABILITIES:
>   		r = tdx_get_capabilities(&tdx_cmd);
>   		break;
> +	case KVM_TDX_INIT_VM:
> +		r = tdx_td_init(kvm, &tdx_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;


