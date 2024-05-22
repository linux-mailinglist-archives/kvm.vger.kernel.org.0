Return-Path: <kvm+bounces-17931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0260C8CBB9D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43DE8B21580
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC17379DD4;
	Wed, 22 May 2024 06:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W7SC4IyV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA674E3D;
	Wed, 22 May 2024 06:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716360882; cv=none; b=h8TG2OuvdVKCTkmzLmCJuIYjyGbbPd7ezFVfWhNJbV4xf6pONWouWQKdrz2zX4TzMQHKcW3Jksl2t8I/DWPVwkKxIalo+issR4OjACDwI/jPkr3sXWSD6VlgrkPXs/UtyqswtG1m5IlyATef7cwlkxE5M5aETPm/e/exWeech5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716360882; c=relaxed/simple;
	bh=2pX/LCZ6hGHka5Q0D7rOPSBgXKZ79U0LHg4ijlN3vnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fu7rNLOVk0ijNUCXuexV2vMXUpDa8xisfZ21T/ySNUfqhHWC2lfdXcc1vLGm5a8ZNXhrnINwbAnlRlz/hSwVwj4nlWotU0ri/QDUMLAWxogVarVHaup/W0SkjaIBnCumZ1WmcoHi/A6P3aG6H8Oh+8/sp3u2eA0EOfFasVf3v44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W7SC4IyV; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716360881; x=1747896881;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2pX/LCZ6hGHka5Q0D7rOPSBgXKZ79U0LHg4ijlN3vnA=;
  b=W7SC4IyVOg4fYfTNhpQqiBV5P0i1l4/SjOqEftZCyUDDPWxIwXp7qEQz
   gXtd2IHLOAPGHSwF4pBE6UdV4IRe5p9L6MZ032FzNCd0FdwIw9Di3As5X
   LSbgq9zY6tdPxD88dBBEBHr0l7FD1gXeaiwqasacqreE0wgh8ESZuK1rA
   y4yUuaoavnvXxQH57R23edxXNU4udmndK+eJudXjYiZ++UK6Na2YmM+te
   47zpor/g2IcYCS336KOqNYxl1EamR11L8DAEg/qwhzROBwUcJfbS8Lw1e
   CQOp1DK8GvxiTaK7oQE9xhpcRZVxml6Cl7rrxBk0BbGh5ABk8XYd6gt5n
   w==;
X-CSE-ConnectionGUID: rioNoovzQ5Wzr0Bev+Ms7Q==
X-CSE-MsgGUID: heXOuaEZSMOPX2Y/65YOtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16381232"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="16381232"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:54:40 -0700
X-CSE-ConnectionGUID: 6cwL83/SS3Glp6YI4IZ/Mg==
X-CSE-MsgGUID: U0ckjVvUTJWNSbMY7eMCLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37661274"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:54:37 -0700
Message-ID: <783061e3-51ad-46f3-aca8-73cebf603e27@intel.com>
Date: Wed, 22 May 2024 14:54:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] KVM: nVMX: Add a helper to encode VMCS info in
 MSR_IA32_VMX_BASIC
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Shan Kang <shan.kang@intel.com>,
 Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240520175925.1217334-1-seanjc@google.com>
 <20240520175925.1217334-8-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240520175925.1217334-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/2024 1:59 AM, Sean Christopherson wrote:
> Add a helper to encode the VMCS revision, size, and supported memory types
> in MSR_IA32_VMX_BASIC, i.e. when synthesizing KVM's supported BASIC MSR
> value, and delete the now unused VMCS size and memtype shift macros.
> 
> For a variety of reasons, KVM has shifted (pun intended) to using helpers
> to *get* information from the VMX MSRs, as opposed to defined MASK and
> SHIFT macros for direct use.  Provide a similar helper for the nested VMX
> code, which needs to *set* information, so that KVM isn't left with a mix
> of SHIFT macros and dedicated helpers.
> 
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/vmx.h | 7 +++++--
>   arch/x86/kvm/vmx/nested.c  | 8 +++-----
>   2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 90963b14afaa..65aaf0577265 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -135,10 +135,8 @@
>   #define VMX_VMFUNC_EPTP_SWITCHING               VMFUNC_CONTROL_BIT(EPTP_SWITCHING)
>   #define VMFUNC_EPTP_ENTRIES  512
>   
> -#define VMX_BASIC_VMCS_SIZE_SHIFT		32
>   #define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
>   #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
> -#define VMX_BASIC_MEM_TYPE_SHIFT		50
>   #define VMX_BASIC_INOUT				BIT_ULL(54)
>   #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
>   
> @@ -157,6 +155,11 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>   	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
>   }
>   
> +static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
> +{
> +	return revision | ((u64)size << 32) | ((u64)memtype << 50);
> +}
> +
>   static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>   {
>   	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fbfd3c5cb541..d690fa720dcf 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -7035,12 +7035,10 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
>   	 * guest, and the VMCS structure we give it - not about the
>   	 * VMX support of the underlying hardware.
>   	 */
> -	msrs->basic =
> -		VMCS12_REVISION |
> -		VMX_BASIC_TRUE_CTLS |
> -		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
> -		(X86_MEMTYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
> +	msrs->basic = vmx_basic_encode_vmcs_info(VMCS12_REVISION, VMCS12_SIZE,
> +						 X86_MEMTYPE_WB);
>   
> +	msrs->basic |= VMX_BASIC_TRUE_CTLS;
>   	if (cpu_has_vmx_basic_inout())
>   		msrs->basic |= VMX_BASIC_INOUT;
>   }


