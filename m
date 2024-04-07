Return-Path: <kvm+bounces-13831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A29C89AF01
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 09:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C5328253D
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 07:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96907107A6;
	Sun,  7 Apr 2024 07:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nhMI1GDC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FBADDBD;
	Sun,  7 Apr 2024 07:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712473528; cv=none; b=rZ7PRmMoBsg8fpyl1+Zoxgd1kYEyCPfKXTT4hnjxZHqcvHJUDI7C2zObi9K/TXZXxAEdS7ZG9KKQOYD2nbNw/4BwnxBFRgL2QjujxuTWrMFEsj7snAiX+8sJCzKi5vsXKKt3GWPY2KHqGmxPqISgeJB5WKCNFKRz+IQIAJWdhUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712473528; c=relaxed/simple;
	bh=1Fh78Lruhd8XOhkhBtqIrEdi2tQkBLSdIKNesvY5ZLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=huVxVdJl54MPOBdRN8fIDavWvHbRHED6A5PyoypT5PWPxjwru0SRSvAQEowxAMc68x0gC9d5ZU0u1/2SrHk4ow4uC2soZqp30Kw+yFi5ABznI0y8fDWLo0ASA5VnweRFpwHuIYwkSsbk0TtTWkmVWuE7vlmWLOGdJM2oijylKzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nhMI1GDC; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712473528; x=1744009528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Fh78Lruhd8XOhkhBtqIrEdi2tQkBLSdIKNesvY5ZLM=;
  b=nhMI1GDC5YYMQz8is92pvunGHjGukSn1kZQJr0zEFplIGH1NzxCK8I+w
   LyZLH6SOrP+uSmTfF0dVF6Ynm3qpIHnoTKq8WRfEsX8OA2ewqn3gN1PoG
   PDglTxmvb/gPh63Sc4sYjCy82UU+M31027j2eHQ2KTNVCEbmzeyY0TBwq
   brpTYvzfkcCZM2uK4n1q/sFgHBBp0CfkgAjXsWORdI+aDl37EjDW6NkgY
   jJMPEjYo3ZVAi21Cow48C+KMr4qcMx3bJmanI6uywpxsdEqBtafA/wgow
   4ZrwdmXebSa4bhnOi3ApzdjT2oLQYGug7Ks1RhTRq4c0aNVOMEicITR8v
   g==;
X-CSE-ConnectionGUID: mL4N/wWhTcm1ai/8Puvwtw==
X-CSE-MsgGUID: jcsKQ4JpSvm3auI62XT8tg==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="7862180"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="7862180"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 00:05:27 -0700
X-CSE-ConnectionGUID: 2rcPilMkToy0RPNUumuJYw==
X-CSE-MsgGUID: WgN7RM+WSKCDQLjXtSZHlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="19494144"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2024 00:05:23 -0700
Message-ID: <dec685d5-96a7-453d-8b1b-7c662e222977@linux.intel.com>
Date: Sun, 7 Apr 2024 15:05:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 083/130] KVM: TDX: Add TSX_CTRL msr into uret_msrs
 list
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Yang Weijiang <weijiang.yang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <06135e0897ae90c3dc7fd608948f8bdcd30a17ae.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <06135e0897ae90c3dc7fd608948f8bdcd30a17ae.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
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
> v19:
> - fix the type of tdx_uret_tsx_ctrl_slot. unguent int => int.
> ---
>   arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.h |  8 ++++++++
>   2 files changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 7e2b1e554246..83dcaf5b6fbd 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -547,14 +547,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
>   	{.msr = MSR_LSTAR,},
>   	{.msr = MSR_TSC_AUX,},
>   };
> +static int tdx_uret_tsx_ctrl_slot;
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

If to_kvm_tdx(vcpu->kvm)->tsx_supported is true, tdx_uret_tsx_ctrl_slot 
shouldn't be -1 at this point.
Otherwise, it's a KVM bug, right?
Not sure if it needs a warning if tdx_uret_tsx_ctrl_slot is -1, or just 
remove the check?

> +		kvm_user_return_update_cache(tdx_uret_tsx_ctrl_slot, 0);
>   }
>   
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> @@ -649,7 +656,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> -	tdx_user_return_update_cache();
> +	tdx_user_return_update_cache(vcpu);
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1167,6 +1174,22 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
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
> @@ -1209,6 +1232,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>   	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
>   	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
>   
> +	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
>   	return 0;
>   }
>   
> @@ -2014,6 +2038,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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
> index e96c416e73bf..44eab734e702 100644
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
>   	bool finalized;
>   	atomic_t tdh_mem_track;
>   


