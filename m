Return-Path: <kvm+bounces-61131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C01C0BDA1
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 06:48:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A540D18912E5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 05:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FBB2D4B71;
	Mon, 27 Oct 2025 05:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nAwNL5Uy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7BB200BAE
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 05:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761544084; cv=none; b=NwZBDodUmZsCItmGICJrvWJ+Z4ywON5M9+Qc+tar3gugwb4kfnSILYDNYGDzlcrGngC/4OhMIeBQyvoBUCFWYHRDzX17PDwOVePkvo2Dmb/erfthF/NL4agwTWMuHwsDepNqQT6A4X7/A0+qtb2f/toLNb6xCMAooY9k9AC83mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761544084; c=relaxed/simple;
	bh=24zEWJ2BhHyTK1Z3gf/A4Z3jWdwL2s4O/5Gno5jTRLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NX4+jo/Q6emyMhjZlUv6F+b3DnNeNf82piGneuqLEF1iH0VL/6woZgbGqnu36q1ZjxlEmpYPJnzyb5uMJ4jQgEV+pP9EYXBY25buvQB45Q9Vq8s48HG4pjZgmcUCepIZxmCHztn3KmiiQRSe0RE8pRYwmnISOBPrZ91TecH8DfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nAwNL5Uy; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761544082; x=1793080082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=24zEWJ2BhHyTK1Z3gf/A4Z3jWdwL2s4O/5Gno5jTRLU=;
  b=nAwNL5Uy0AiyR8U+4k5JnjWLOekr5WXQZVMyzhM2OFFW7H4+sA8ibLD6
   3Pvp/XRZcX4w6wXFPJfA4PMWfPiXUhtyuyuAzfr+0YNFgYY/5UaDv30Xa
   JY+d8ShS2swp5wCVfMDnrw6TtT977FkClcZRFdyJ4vnFqy6S2KEiakAEj
   E4PLUdB39Dlovc1lB1DP4pA/iyFj5muCRwlbty/fI9Y75ISp5UdMDbnxa
   6eDwbiFejXF2Tcxon/ESYm0F6IrovCfeh+I/f8Clt2helOEZ9ezYdpEZa
   fJnEd3KxMkhq/AOuNL/0tpWGqpqA5JiYbFPb23Arxig32DUZvMYqR0LY5
   A==;
X-CSE-ConnectionGUID: RD1v3RC3Qj+aP8X65jyhmQ==
X-CSE-MsgGUID: D/9i+XS9SoacvhMGPEV4TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63711861"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="63711861"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 22:48:01 -0700
X-CSE-ConnectionGUID: /SnmDoMzTvOFq7mwUpzN/Q==
X-CSE-MsgGUID: b6cy4JhCSIe4bWzQbH9gHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184566973"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 22:47:57 -0700
Message-ID: <94d254b3-3d0f-4fe8-b6aa-da5df2b9c0e6@intel.com>
Date: Mon, 27 Oct 2025 13:47:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/20] i386/cpu: Clean up indent style of
 x86_ext_save_areas[]
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-3-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-3-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:

<empty commit message> isn't good.

> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 58 +++++++++++++++++++++++++++--------------------
>   1 file changed, 33 insertions(+), 25 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 0a66e1fec939..f0e179c2d235 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2028,38 +2028,46 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
>           .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
>           .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
>       },
> -    [XSTATE_YMM_BIT] =
> -          { .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
> -            .size = sizeof(XSaveAVX) },
> -    [XSTATE_BNDREGS_BIT] =
> -          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
> -            .size = sizeof(XSaveBNDREG)  },
> -    [XSTATE_BNDCSR_BIT] =
> -          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
> -            .size = sizeof(XSaveBNDCSR)  },
> -    [XSTATE_OPMASK_BIT] =
> -          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> -            .size = sizeof(XSaveOpmask) },
> -    [XSTATE_ZMM_Hi256_BIT] =
> -          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> -            .size = sizeof(XSaveZMM_Hi256) },
> -    [XSTATE_Hi16_ZMM_BIT] =
> -          { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> -            .size = sizeof(XSaveHi16_ZMM) },
> -    [XSTATE_PKRU_BIT] =
> -          { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
> -            .size = sizeof(XSavePKRU) },
> +    [XSTATE_YMM_BIT] = {
> +        .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
> +        .size = sizeof(XSaveAVX),
> +    },
> +    [XSTATE_BNDREGS_BIT] = {
> +        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
> +        .size = sizeof(XSaveBNDREG),
> +    },
> +    [XSTATE_BNDCSR_BIT] = {
> +        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
> +        .size = sizeof(XSaveBNDCSR),
> +    },
> +    [XSTATE_OPMASK_BIT] = {
> +        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> +        .size = sizeof(XSaveOpmask),
> +    },
> +    [XSTATE_ZMM_Hi256_BIT] = {
> +        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> +        .size = sizeof(XSaveZMM_Hi256),
> +    },
> +    [XSTATE_Hi16_ZMM_BIT] = {
> +        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
> +        .size = sizeof(XSaveHi16_ZMM),
> +    },
> +    [XSTATE_PKRU_BIT] = {
> +        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
> +        .size = sizeof(XSavePKRU),
> +    },
>       [XSTATE_ARCH_LBR_BIT] = {
> -            .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
> -            .offset = 0 /*supervisor mode component, offset = 0 */,
> -            .size = sizeof(XSavesArchLBR) },
> +        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
> +        .offset = 0 /*supervisor mode component, offset = 0 */,
> +        .size = sizeof(XSavesArchLBR),
> +    },
>       [XSTATE_XTILE_CFG_BIT] = {
>           .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
>           .size = sizeof(XSaveXTILECFG),
>       },
>       [XSTATE_XTILE_DATA_BIT] = {
>           .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
> -        .size = sizeof(XSaveXTILEDATA)
> +        .size = sizeof(XSaveXTILEDATA),
>       },
>   };
>   


