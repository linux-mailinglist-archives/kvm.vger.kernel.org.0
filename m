Return-Path: <kvm+bounces-9273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 05DF385D0CF
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70A06B22575
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7C63A26E;
	Wed, 21 Feb 2024 07:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PsjDXkfX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C8AFBF5;
	Wed, 21 Feb 2024 07:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708498814; cv=none; b=Eehb201nqRr9eQRe3/Fc11vXJ/6GtUFujB3MGbt6UFkcPLrUajkCy1xPJDzm8YzKbBP5HrlUZ8IBdB9pgDeWeVeJAjkw1GjXjcyqSgbraid2oAKnSEGwi2k6qCR+upQlNQN5DgXSsSvJHo/ZkHFvn/ZizrX9RGOSRHfzjcXLSzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708498814; c=relaxed/simple;
	bh=Rf54Iv6i33WLa/ODss2DQX3C0tZxKlVlsFA7jmOoRHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7RkEgo75kUQWv2tckwXJTs9GDhVz2j5Kgpm19kITQUv51z+h8LIJK/iTngDIZ+FqsGemBRtRL0OoC4WA87V66FQMnnEI8e+P4jQbctuHh1TJ2e7+Rkpj1pz99tGGdJ6a5VP7beHRbs+NBGy6h4XdHXWC5VfLGvabuQwGd1CKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PsjDXkfX; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708498804; x=1740034804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rf54Iv6i33WLa/ODss2DQX3C0tZxKlVlsFA7jmOoRHg=;
  b=PsjDXkfXBdsAM+slmk5a+WYhoPxEcsFVCR+3FO7qli6HiQUNQrRF07lp
   W84R+D8/WUbhZwA7pASI+WCP9xH4HQMPVdYao/Un54NhyQG1+dDuqO1qh
   pHfAUAT2JRMndxRiEcP+SpzQ9obdGEmYWCPa/RTRtPbGi2UrEQ0C9Up53
   j4DAOA/2XXPRSM/EevVJ8Noj9iyQdtMt+wjadpOUwiglZPwS+zyKu2sLw
   rMd3j5G1nbTyFxMp12alnghZEAFTPf+DhWKBfqNu8ATU7XGfM2PyQrnad
   OJLNtua1M/lIZkIqPwXrA7w8brWkpHNzfTvweSCUjAC4/urS57i4i7LEa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="14062673"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="14062673"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 23:00:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="36076067"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.18.46]) ([10.93.18.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 22:59:59 -0800
Message-ID: <4b1d13c3-3df2-46d7-92bb-a4ffba619dfe@linux.intel.com>
Date: Wed, 21 Feb 2024 14:59:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 072/121] KVM: TDX: Add TSX_CTRL msr into uret_msrs
 list
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Yang Weijiang <weijiang.yang@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <ca819af632d5c7ea2905c4a1d07303139eaef4ea.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ca819af632d5c7ea2905c4a1d07303139eaef4ea.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
> TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
> rely on uret_msrs mechanism to defer the reload of host value until exiting
> to user space.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.h |  8 ++++++++
>   2 files changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4685ff6aa5f8..71c6fc10e8c4 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -597,14 +597,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
>   	{.msr = MSR_LSTAR,},
>   	{.msr = MSR_TSC_AUX,},
>   };
> +static unsigned int tdx_uret_tsx_ctrl_slot;

It should use "int" instead of "unsigned int" since the return type of
kvm_find_user_return_msr() is int.
Not a good code style to compare between unsigned int and int.

>   
> -static void tdx_user_return_update_cache(void)
> +static void tdx_user_return_update_cache(struct kvm_vcpu *vcpu)
>   {
>   	int i;
>   
>   	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
>   		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
>   					     tdx_uret_msrs[i].defval);
> +	/*
> +	 * TSX_CTRL is reset to 0 if guest TSX is supported. Otherwise
> +	 * preserved.
> +	 */
> +	if (to_kvm_tdx(vcpu->kvm)->tsx_supported && tdx_uret_tsx_ctrl_slot != -1)
> +		kvm_user_return_update_cache(tdx_uret_tsx_ctrl_slot, 0);
>   }
>   
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> @@ -699,7 +706,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> -	tdx_user_return_update_cache();
> +	tdx_user_return_update_cache(vcpu);
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1212,6 +1219,22 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
>   	return 0;
>   }
>   
> +static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
> +{
> +	const struct kvm_cpuid_entry2 *entry;
> +	u64 mask;
> +	u32 ebx;
> +
> +	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x7, 0);
> +	if (entry)
> +		ebx = entry->ebx;
> +	else
> +		ebx = 0;
> +
> +	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
> +	return ebx & mask;
> +}
> +
>   static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>   			struct kvm_tdx_init_vm *init_vm)
>   {
> @@ -1253,6 +1276,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>   	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
>   	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
>   
> +	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
>   	return 0;
>   }
>   
> @@ -1978,6 +2002,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   			return -EIO;
>   		}
>   	}
> +	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
> +	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
> +		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
> +		return -EIO;
> +	}
>   
>   	max_pkgs = topology_max_packages();
>   	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 2d3119c60a14..883eb05d207f 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,6 +17,14 @@ struct kvm_tdx {
>   	u64 xfam;
>   	int hkid;
>   
> +	/*
> +	 * Used on each TD-exit, see tdx_user_return_update_cache().
> +	 * TSX_CTRL value on TD exit
> +	 * - set 0     if guest TSX enabled
> +	 * - preserved if guest TSX disabled
> +	 */
> +	bool tsx_supported;
> +
>   	hpa_t source_pa;
>   
>   	bool finalized;


