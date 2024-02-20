Return-Path: <kvm+bounces-9162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8802A85B700
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA51C1C241D2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D8C5F477;
	Tue, 20 Feb 2024 09:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CNo2JsfW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049ED5D754;
	Tue, 20 Feb 2024 09:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420455; cv=none; b=o/6KP51i+H1/zjQ6vpHc6DipJpjXP1XGFp1hKl3yNlUcVQIXZYGq8U3AHRv73wBtNxDRLyCGAHPJJXUC+z00dP2tYUEiypxDUqZFd5UCNFjvS40RA9bc3ns/YeHCEPWKp+512THZsXbe7P5MOEmlqd9rRqvqloHMHj0/sqCgYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420455; c=relaxed/simple;
	bh=q6kvoJgE0z5BcXgSf9dbJPhAt3VIlqlLvkUsJ7HopDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BWqKQi/qzGYkOY/ly7vLzKuiMBMm43/p+J1Mp6dTDGelRj0hAeMqTrScGdTtdCmwGuAJnrhMUis5ieFWMFo8+MHRGNThzOTsDqELSOyuJvYbOiZgN32crDwk0tAQkLmGJA0y0KRUFFijzQFhosELBSIZJ7YXQpYkO2k4Qvupxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CNo2JsfW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708420454; x=1739956454;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q6kvoJgE0z5BcXgSf9dbJPhAt3VIlqlLvkUsJ7HopDw=;
  b=CNo2JsfWl7hajPqrosT+Do/on8aTQvebwGR9ENYSnwVxOJfN3upc0OkU
   /IppJsKq/wzaPx60NIp90Ai8MlyzoqNhmMLqFL8zmmiqQSBCs9GXDtFwQ
   YPNIgbhHpe7c61SVPRWWbxKnVCdNCeBHCg8bkcU5teeN0pWMBYbOFXgHm
   /hBeNfADNxjexZ24rFY+hQCCCOuFLiIbvE+7DmS2UYMz3xc1bxkMAGvw/
   X9RZmHfrF5Tb8Xoy/zj2eS8toddFBooHhPGL0Bsw9h6sIlc/hdka6BeWH
   l1L5wtbD1JkEtKBayDWWx3QUJIEQbB4DpedaPFSbrZLiDg3fLLqyuIX6S
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="6330084"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="6330084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:14:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="9385712"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.66]) ([10.238.1.66])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 01:14:04 -0800
Message-ID: <3ac7bcfc-ea22-43b5-b8ba-d87830637d4d@linux.intel.com>
Date: Tue, 20 Feb 2024 17:14:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 071/121] KVM: TDX: restore user ret MSRs
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <65e96a61c497c78b41fa670e20fbeb3593f56bfe.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <65e96a61c497c78b41fa670e20fbeb3593f56bfe.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Several user ret MSRs are clobbered on TD exit.  Restore those values on
> TD exit and before returning to ring 3.  Because TSX_CTRL requires special
> treat, this patch doesn't address it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index fe818cfde9e7..4685ff6aa5f8 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -585,6 +585,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +struct tdx_uret_msr {
> +	u32 msr;
> +	unsigned int slot;
> +	u64 defval;
> +};
> +
> +static struct tdx_uret_msr tdx_uret_msrs[] = {
> +	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
> +	{.msr = MSR_STAR,},
> +	{.msr = MSR_LSTAR,},
> +	{.msr = MSR_TSC_AUX,},
> +};
> +
> +static void tdx_user_return_update_cache(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> +					     tdx_uret_msrs[i].defval);
> +}
> +
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -677,6 +699,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> +	tdx_user_return_update_cache();
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1936,6 +1959,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   		return -EINVAL;
>   	}
>   
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		/*
> +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> +		 * before returning to user space.
> +		 *
> +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> +		 * because the registration is done at vcpu runtime by
> +		 * kvm_set_user_return_msr().

For tdx, it's done by kvm_user_return_update_cache(), right?

> +		 * Here is setting up cpu feature before running vcpu,
> +		 * registered is already false.
> +		 */
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
> +
>   	max_pkgs = topology_max_packages();
>   	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
>   				   GFP_KERNEL);


