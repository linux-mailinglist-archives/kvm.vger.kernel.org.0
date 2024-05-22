Return-Path: <kvm+bounces-17929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1C78CBB89
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC3BB2827CC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB56779950;
	Wed, 22 May 2024 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A9Wd/ZiV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF5E4C62;
	Wed, 22 May 2024 06:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716360530; cv=none; b=hgsd88N72/TaIhEGfWlOlbAyWOyrfBk44D+AXsZtaka1fTY8dTK6gVizP+IVFxBFJHQnJ7ngCaCyjBjscZEqvekPm+98cOqoe9h6txBFPC1rDYQBe12id9aPO0aypkrFML+zy57WvSv0ecVmXAhfwuj3r8sZffTDA6czDTGBAkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716360530; c=relaxed/simple;
	bh=Jl2fXLtvIPGDFHybLQKPphcqtovlI/3sW73cHL+/w7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHYf+mL8cQkER2Rg9SdMhsqK2aMpTmDxm9J4gTRbcODA7J984c+977dT/sG8jIOzoLXdGSeWBeR2ZkmqSGnplHvLE2a9BYBV4Ttfh1KZanoz+/8FVQdJw3dDwfLjGe2BL3M83NizMTugjvkBXoQCFQJRARu+KS3j1vs0ay5jVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A9Wd/ZiV; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716360528; x=1747896528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Jl2fXLtvIPGDFHybLQKPphcqtovlI/3sW73cHL+/w7M=;
  b=A9Wd/ZiVsWKsMlYcEyEDrjz+OG15+w5EnHxAF3PEVu4HAb2gyRo4JMcS
   a8wWLzqaImWZLkK/T21HOz7l7/ov1TjakN/KjoHwNmC58Gbi8XvqZX1x+
   zr2b8PHDJerGHupJHNcldBGl/px+nTUPiYilPRFIU2H1QTPrdCAupY66a
   iJif8KU4y28HO4CId7qJQnNM9ZjRAqpXz2WTCcfSt6Kc+3xVzq3SM+8aE
   TmMfFBpLOQFCdOl6SdKzb6bxnMqhVdat4bkMqK27zXhptbVs1ABBidDm9
   hVPpxZgT1WOVZjKuQjbH15zXsHdMu4ka1A6HxFNYdKfrucltriOQEd6vC
   w==;
X-CSE-ConnectionGUID: bLFCmyoFQwSnS5xt/AMJeg==
X-CSE-MsgGUID: I3XLXv/nQ9aEQyaWpy4XlA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="23997423"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="23997423"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:48:48 -0700
X-CSE-ConnectionGUID: x2vpTcWsR+aUAuHCJmDz+w==
X-CSE-MsgGUID: fbL4ld0/TTOn7b5M4QLCvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37572475"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:48:45 -0700
Message-ID: <46dae102-b6b0-4626-a33e-c20b08e97a14@intel.com>
Date: Wed, 22 May 2024 14:48:42 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/10] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Shan Kang <shan.kang@intel.com>,
 Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240520175925.1217334-1-seanjc@google.com>
 <20240520175925.1217334-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240520175925.1217334-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/2024 1:59 AM, Sean Christopherson wrote:
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
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/msr-index.h | 8 --------
>   arch/x86/include/asm/vmx.h       | 7 +++++++
>   2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index b14434af00df..7e7cad59e552 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1168,14 +1168,6 @@
>   #define MSR_IA32_VMX_VMFUNC             0x00000491
>   #define MSR_IA32_VMX_PROCBASED_CTLS3	0x00000492
>   
> -/* VMX_BASIC bits and bitmasks */
> -#define VMX_BASIC_VMCS_SIZE_SHIFT	32
> -#define VMX_BASIC_TRUE_CTLS		(1ULL << 55)
> -#define VMX_BASIC_64		0x0001000000000000LLU
> -#define VMX_BASIC_MEM_TYPE_SHIFT	50

> -#define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU

VMX_BASIC_MEM_TYPE_MASK	gets deleted. It deserves to be mentioned?

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

why add it?

> +#define VMX_BASIC_MEM_TYPE_SHIFT		50
> +#define VMX_BASIC_INOUT				BIT_ULL(54)
> +#define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
> +
>   static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
>   {
>   	return vmx_basic & GENMASK_ULL(30, 0);


