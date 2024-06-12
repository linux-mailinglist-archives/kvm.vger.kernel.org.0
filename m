Return-Path: <kvm+bounces-19386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D23904895
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72FEB28385B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7511863BF;
	Wed, 12 Jun 2024 01:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZtiS24+m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338DF4691;
	Wed, 12 Jun 2024 01:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157258; cv=none; b=SCJPXY8KWZ2IXJtYM51/QBPoFFhOyN4fpgkijF+yQcBN/MFuMBBCsPwLLivJP5nqxLFvHIpxk18TNaoVG3KzOFaBSnhq6zqPy7B1FAD2BsY9ugnh4+Fim08rbwnKLoxOLkVNfjTKD2z5b5HmKzec7MJrHFLv60wC+XVp/4rm76U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157258; c=relaxed/simple;
	bh=OYtZknOWMr5YYhsoINE+HdQxQ/H6xRCXb1U7Ewu55pI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qyKba12TnYggQKeH1pZIJPw7TgP2j7hECiTEBB7MkdIVFNG+goQoUmcXk9hqbC54COACD+Xdq65ByP77VjQtrMjnRqxmUYlj/XOAiCn8aJNdOrI1F43sRlnhlR6L5K175IKq5L1I/8dtf11rLbFnGXoAcylWdAz9ts1jfOXEY9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZtiS24+m; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718157257; x=1749693257;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OYtZknOWMr5YYhsoINE+HdQxQ/H6xRCXb1U7Ewu55pI=;
  b=ZtiS24+mORt27gJRsBFyM09csTw+EjEcL5VH0eFCK2MgPUNhm7Y8T63r
   XpxRpaH2cylA3x4Pmjv68LwtLvIFiK9zg7ebfdq7TPN4R2akbdrCxzUdR
   z79HpplvzOnLpV2IGLNFVtwujUkrGP7YxX5Q7mjumExIqwk29nbTW7VcZ
   CQA1plskKxFNeeUDfa9VlIm+SkHhNmnqNGPfEx2PC5IhOSf2SXKv1rVw2
   DHYCgO0km9Z05Wh9FY66n1GtEvZ7ovf7zEvhqmH59QMjNrn4Z0Pgikanv
   WHIPp2Mg2zSHrUmNMMnKSElA02VlanokroUvS+wyj2ZrFx5y82fV0YuqW
   Q==;
X-CSE-ConnectionGUID: QIJYO0OQRk+Ox3wc38zCOw==
X-CSE-MsgGUID: 8nRSVI9RTp2klhQZUexqIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="15070769"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="15070769"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:54:17 -0700
X-CSE-ConnectionGUID: Mo71GvFHSmaCxxsNjkz9+g==
X-CSE-MsgGUID: 3GUS24hIR1yNUoU8ql0PAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="70831477"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:54:11 -0700
Message-ID: <2760e892-0a06-4790-9d5e-bba690dbdf91@intel.com>
Date: Wed, 12 Jun 2024 09:54:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/10] KVM: VMX: Open code VMX preemption timer rate
 mask in its accessor
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Jim Mattson <jmattson@google.com>,
 Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>,
 Zhao Liu <zhao1.liu@intel.com>
References: <20240605231918.2915961-1-seanjc@google.com>
 <20240605231918.2915961-10-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240605231918.2915961-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/2024 7:19 AM, Sean Christopherson wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
> and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
> that the function looks like all the helpers that grab values from
> VMX_BASIC and VMX_MISC MSR values.
> 
> No functional change intended.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/vmx.h | 3 +--
>   arch/x86/kvm/vmx/vmx.c     | 2 +-
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 400819ccb42c..f7fd4369b821 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -153,7 +153,6 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
>   	return revision | ((u64)size << 32) | ((u64)memtype << 50);
>   }
>   
> -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
>   #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
>   #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
>   #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> @@ -167,7 +166,7 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
>   
>   static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>   {
> -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> +	return vmx_misc & GENMASK_ULL(4, 0);
>   }
>   
>   static inline int vmx_misc_cr3_count(u64 vmx_misc)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3141ef8679e2..69865e7a3506 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8536,7 +8536,7 @@ __init int vmx_hardware_setup(void)
>   		u64 use_timer_freq = 5000ULL * 1000 * 1000;
>   
>   		cpu_preemption_timer_multi =
> -			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> +			vmx_misc_preemption_timer_rate(vmcs_config.misc);
>   
>   		if (tsc_khz)
>   			use_timer_freq = (u64)tsc_khz * 1000;


