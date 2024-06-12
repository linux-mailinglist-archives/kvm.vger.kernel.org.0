Return-Path: <kvm+bounces-19384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 164FA90488D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B466D1F231EF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E245CB0;
	Wed, 12 Jun 2024 01:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KR3TSfCi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BF823A6;
	Wed, 12 Jun 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157007; cv=none; b=lsVFEmb2mr9XrVLW7IWQx5g3g8E8DBPj+hRZEKw0j+RH5QChHiXMv0HqKu67jWjxAdoAxNBYgB5aPkmlDQkX9fM9DhCa4Y2hb2lwmJcWDGXjkH5H1vDXbA+McVd3yKX+gvRqE0K8aDTB7IdOa//wLJsQ51Cd/3kyuyGKEwt3BCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157007; c=relaxed/simple;
	bh=mruOr8BApZYwayCBu9Ee90puSaZOMe5vEm6X1V8AExY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AP0Pwl8ClGBEZ3Z4og8UN5XXJYfWZIBnpFesC1Nwussx3dsKfpuiqNycmYpcJBvn9Ow/claB2Xnb8Svk13jOKJ67P6FrxhUgZvBe0tR2tuN4STb5C77jSQizSRHemzQ0AO3rcMkXpJCDYLy/DdJZvVCmRjthbFwxSpLIjZM0ZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KR3TSfCi; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718157005; x=1749693005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mruOr8BApZYwayCBu9Ee90puSaZOMe5vEm6X1V8AExY=;
  b=KR3TSfCiw0JaJp7zOXv1xPuSI0UKRvk+jrid7NeQW2igrvVyyXnqrpjr
   Bz42Y/kPmLSBP3EdrsqRkwL2KYHbgG+W27yAQkp02ddah2FA6NZnNcziA
   p9yLv/2E8vfCUIpFLCTHELLvcV4DNsoN0xbfLJ/VvcL+1RxSy6ITUrP+U
   BMMwh9/CKNYs1kqKxXVLmePbb4WoBXSHc/Q/FPJsWaLVpgSkxrRUh+KmS
   lw6j/3i2Fi5XByyEYj8NBdwnPDlprgRcTr7Fnb0kjRdxrP+ilCRayHH40
   Yoleav9HKBOuLKup34kEmyBxLZfJOLt+jiLjUJ/vnh8Ntnbc4g/3h0B76
   g==;
X-CSE-ConnectionGUID: hRv6ej2gQgGsQj4pJ20ndA==
X-CSE-MsgGUID: qHALJiI3TCq+WOcR7BUhnw==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14626140"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14626140"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:50:04 -0700
X-CSE-ConnectionGUID: FlxYsiKURFyp8kWXOcDlWQ==
X-CSE-MsgGUID: vYyZtfXZSZabcZlcflZg/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39685966"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:50:00 -0700
Message-ID: <98b1d143-13bf-471d-8dc6-5f8e03ddde79@intel.com>
Date: Wed, 12 Jun 2024 09:49:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
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
 <20240605231918.2915961-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240605231918.2915961-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/2024 7:19 AM, Sean Christopherson wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Move the bit defines for MSR_IA32_VMX_BASIC from msr-index.h to vmx.h so
> that they are colocated with other VMX MSR bit defines, and with the
> helpers that extract specific information from an MSR_IA32_VMX_BASIC value.
> 
> Opportunistically use BIT_ULL() instead of open coding hex values.
> 
> Opportunistically rename VMX_BASIC_64 to VMX_BASIC_32BIT_PHYS_ADDR_ONLY,
> as "VMX_BASIC_64" is widly misleading.  The flag enumerates that addresses
> are limited to 32 bits, not that 64-bit addresses are allowed.
> 
> Last but not least, opportunistically #define DUAL_MONITOR_TREATMENT so
> that all known single-bit feature flags are defined (this will allow
> replacing open-coded literals in the future).
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/msr-index.h | 8 --------
>   arch/x86/include/asm/vmx.h       | 7 +++++++
>   2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index d93b73476583..b25c1c62b77c 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1167,14 +1167,6 @@
>   #define MSR_IA32_VMX_VMFUNC             0x00000491
>   #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>   
> -/* VMX_BASIC bits and bitmasks */
> -#define VMX_BASIC_VMCS_SIZE_SHIFT	32
> -#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
> -#define VMX_BASIC_64		0x0001000000000000LLU
> -#define VMX_BASIC_MEM_TYPE_SHIFT	50
> -#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
> -#define VMX_BASIC_INOUT		0x0040000000000000LLU
> -
>   /* Resctrl MSRs: */
>   /* - Intel: */
>   #define MSR_IA32_L3_QOS_CFG		0xc81
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index e531d8d80a11..81b986e501a9 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -135,6 +135,13 @@
>   #define VMX_VMFUNC_EPTP_SWITCHING               VMFUNC_CONTROL_BIT(EPTP_SWITCHING)
>   #define VMFUNC_EPTP_ENTRIES  512
>   
> +#define VMX_BASIC_VMCS_SIZE_SHIFT		32
> +#define VMX_BASIC_32BIT_PHYS_ADDR_ONLY		BIT_ULL(48)
> +#define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
> +#define VMX_BASIC_INOUT				BIT_ULL(54)
> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
> +
>   static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
>   {
>   	return vmx_basic & GENMASK_ULL(30, 0);


