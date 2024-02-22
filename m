Return-Path: <kvm+bounces-9393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5164585FB67
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 15:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E71591F22FC0
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 14:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9871C1474D4;
	Thu, 22 Feb 2024 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Of0qbvK6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC636B15;
	Thu, 22 Feb 2024 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708612647; cv=none; b=ej++9jh0zxX9ceRVJpV5yFbnGP+/1lX5HvSRTMmrReFbM6UYDwgmEHO2/7+IqBDyZayPdGXoLHnZu/8BC9DbowQGd+hMATYonf57M+BroRyTF17EfJHEU52n9uNXp1dNbRT3dQz5aB+S11dW9rt65lL0NzRqEbBMX/IFomiFavo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708612647; c=relaxed/simple;
	bh=nA+GwPV8So810YxlOsuziJpf9lYOI6OtcvWyEM/PeAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwl84NuN6+a3w6GZejHcII+GsAoU9oOdvgMBKDs7jT9DGvJohcn4zsPQ+TzpSG82kkA94ogOneg3AvrVrRP+Z8BNIgF6c8PJ+9dV38ZlwPWB2f/qnl7yHC2HNYFZfjNwFp+lQQ32C9SowifGd0abIZHDEF+fwrCHO3rK/DAq/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Of0qbvK6; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708612647; x=1740148647;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nA+GwPV8So810YxlOsuziJpf9lYOI6OtcvWyEM/PeAI=;
  b=Of0qbvK6jpIl1T63Paf5joZ8kWBW4UsFOERUsSYZUJaQl6z12GbD9AYQ
   sRg3IgbHzlFzGiyFjrlP70f+N9A3DF6wh34Rl9QLWfz6NX+IQrQSdHd/k
   OpKyj6aWOeS/DRIBKbT6hRmRWqfy8v/sCRYIOJOadktvXn0plnfVcOv4e
   nNqbTKkrlUE4u/enBAIJWP+epjmydDfUAIbc9eOqRumk7DCk3+riMpWxs
   1xNDWUNhCzUiS/PJO2L8uTQ0yaChryk/PeDXtTLeAwJP+zyEGbeLVcTFw
   VaNRAY3VjMsYL25cudYJbaIsjs+ASFlJTbDtDqOu0x2A2xmFnxbFiazx6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2961658"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="2961658"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 06:37:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="5411770"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.18.46]) ([10.93.18.46])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 06:37:22 -0800
Message-ID: <a650200e-5fd9-4ae3-a1e0-d676e96b8490@linux.intel.com>
Date: Thu, 22 Feb 2024 22:37:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 074/121] KVM: TDX: complete interrupts after tdexit
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <379b4d2e8995f0f8b5e6635010b4fd12f4c2571f.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <379b4d2e8995f0f8b5e6635010b4fd12f4c2571f.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> virtualize vAPIC, KVM only needs to care NMI injection.

Nit: complete -> Complete in shortlog.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>   arch/x86/kvm/vmx/tdx.h |  2 ++
>   2 files changed, 12 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 71c6fc10e8c4..3b2ba9f974be 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -585,6 +585,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	/* Avoid costly SEAMCALL if no nmi was injected */
> +	if (vcpu->arch.nmi_injected)
> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> +							      TD_VCPU_PEND_NMI);
> +}
> +
>   struct tdx_uret_msr {
>   	u32 msr;
>   	unsigned int slot;
> @@ -713,6 +721,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
> +	tdx_complete_interrupts(vcpu);
> +
>   	return EXIT_FASTPATH_NONE;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 883eb05d207f..9082a2604ec6 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -201,6 +201,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
>   TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
>   TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
>   
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>   static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
>   {
>   	struct tdx_module_args out;


