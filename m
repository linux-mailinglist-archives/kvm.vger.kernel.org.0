Return-Path: <kvm+bounces-61135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB11C0C082
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E2B83B12CE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB602C21C0;
	Mon, 27 Oct 2025 07:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JxVzcgz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1A2F5B
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548681; cv=none; b=C6zNi0wR4dI3/ogLnBDc65JmfSKznsutMl1MPaMzNHdIRVadOgBGDC7Iz6TZmu0qZvxFijNU0eZmgkJ65YSd7JYL71wIBWJmdrqFLsw/z64gLGw0eos98L4Hwos7xpiEuKx/YjTw5UTIhKPQEzUZ08Tr7r54UC7bKvNoyb9LdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548681; c=relaxed/simple;
	bh=olAYm4gwdFtK3VGM0wCNtaciXqun0aHCPvoDQqsoDLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rdiJMjWnv/VkU7psGDS9z01GddV2UZHauEI86EuXPWFbzh6jhAtPhemCSZ+6ILjJygeUET8n3byatLo6L3s6Zmbu7LT4Q9KFkgFHOWo9WFDUfmR7MjwnFHoYv4h1pZJYlykDIaYq+PPmVbysthYkvMbKRBTHO+TPI64tcmrephY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JxVzcgz9; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761548680; x=1793084680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=olAYm4gwdFtK3VGM0wCNtaciXqun0aHCPvoDQqsoDLM=;
  b=JxVzcgz9fNoXxbxyaGE6ILLW49AlAStKqvz+OzpJgmXCRtqUyW6hVoJ2
   Dm+ckbzuzABWAIFQIvdnUjd6PRvFh3UPI6mFkyPPUjTN0rmc8trLUf3QA
   AMRxe+xgH0RXkOs7lbKXlRwBC+YeCo55tM6sIm/xi/HfcfefPjqfadvOL
   xHBYP5bOfHoefcKIDAAJKNodG+vBvVAlGm0NcboHsyjpVCswzYP684uDD
   0ifYWRYvGDLd2OrCcf0m0UDo1NXmSLOBz0g+/8VvvOscM8VHFEjxhRIMw
   q+mW22mhdcmMIqh83meLGIJXOTAO+0Xnxy6rhbx5zDgj7jk68lJl8uXu3
   g==;
X-CSE-ConnectionGUID: o1noj8bWTZ6R78OF9agCdw==
X-CSE-MsgGUID: M08kdmdfQASfINqMkE1hpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74297663"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74297663"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:04:38 -0700
X-CSE-ConnectionGUID: pcqZwjFkQKSVJmCzokiDAw==
X-CSE-MsgGUID: +O+eNcOeS6S+1Im4f28zTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184583506"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 00:04:35 -0700
Message-ID: <2d9f489e-dfa5-4bd1-bc7f-62223f81c167@intel.com>
Date: Mon, 27 Oct 2025 15:04:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/20] i386/cpu: Make ExtSaveArea store an array of
 dependencies
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-6-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> Some XSAVE components depend on multiple features. For example, Opmask/
> ZMM_Hi256/Hi16_ZMM depend on avx512f OR avx10, and for CET (which will
> be supported later), cet_u/cet_s will depend on shstk OR ibt.
> 
> Although previously there's the special check for the dependencies of
> AVX512F OR AVX10 on their respective XSAVE components (in
> cpuid_has_xsave_feature()), to make the code more general and avoid
> adding more special cases, make ExtSaveArea store a features array
> instead of a single feature, so that it can describe multiple
> dependencies.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
 > --->   target/i386/cpu.c | 71 
++++++++++++++++++++++++++++++++++-------------
>   target/i386/cpu.h |  9 +++++-
>   2 files changed, 59 insertions(+), 21 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b9a5a0400dea..cd269d15ce0b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2020,53 +2020,77 @@ static const X86RegisterInfo32 x86_reg_info_32[CPU_NB_REGS32] = {
>   ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
>       [XSTATE_FP_BIT] = {
>           /* x87 FP state component is always enabled if XSAVE is supported */
> -        .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
>           .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
> +        .features = {
> +            { FEAT_1_ECX,           CPUID_EXT_XSAVE },
> +        },
>       },
>       [XSTATE_SSE_BIT] = {
>           /* SSE state component is always enabled if XSAVE is supported */
> -        .feature = FEAT_1_ECX, .bits = CPUID_EXT_XSAVE,
>           .size = sizeof(X86LegacyXSaveArea) + sizeof(X86XSaveHeader),
> +        .features = {
> +            { FEAT_1_ECX,           CPUID_EXT_XSAVE },
> +        },
>       },
>       [XSTATE_YMM_BIT] = {
> -        .feature = FEAT_1_ECX, .bits = CPUID_EXT_AVX,
>           .size = sizeof(XSaveAVX),
> +        .features = {
> +            { FEAT_1_ECX,           CPUID_EXT_AVX },
> +        },
>       },
>       [XSTATE_BNDREGS_BIT] = {
> -        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
>           .size = sizeof(XSaveBNDREG),
> +        .features = {
> +            { FEAT_7_0_EBX,         CPUID_7_0_EBX_MPX },
> +        },
>       },
>       [XSTATE_BNDCSR_BIT] = {
> -        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
>           .size = sizeof(XSaveBNDCSR),
> +        .features = {
> +            { FEAT_7_0_EBX,         CPUID_7_0_EBX_MPX },
> +        },
>       },
>       [XSTATE_OPMASK_BIT] = {
> -        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
>           .size = sizeof(XSaveOpmask),
> +        .features = {
> +            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +        },
>       },
>       [XSTATE_ZMM_Hi256_BIT] = {
> -        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
>           .size = sizeof(XSaveZMM_Hi256),
> +        .features = {
> +            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +        },
>       },
>       [XSTATE_Hi16_ZMM_BIT] = {
> -        .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_AVX512F,
>           .size = sizeof(XSaveHi16_ZMM),
> +        .features = {
> +            { FEAT_7_0_EBX,         CPUID_7_0_EBX_AVX512F },
> +        },
>       },
>       [XSTATE_PKRU_BIT] = {
> -        .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
>           .size = sizeof(XSavePKRU),
> +        .features = {
> +            { FEAT_7_0_ECX,         CPUID_7_0_ECX_PKU },
> +        },
>       },
>       [XSTATE_ARCH_LBR_BIT] = {
> -        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
>           .size = sizeof(XSaveArchLBR),
> +        .features = {
> +            { FEAT_7_0_EDX,         CPUID_7_0_EDX_ARCH_LBR },
> +        },
>       },
>       [XSTATE_XTILE_CFG_BIT] = {
> -        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
>           .size = sizeof(XSaveXTILECFG),
> +        .features = {
> +            { FEAT_7_0_EDX,         CPUID_7_0_EDX_AMX_TILE },
> +        },
>       },
>       [XSTATE_XTILE_DATA_BIT] = {
> -        .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
>           .size = sizeof(XSaveXTILEDATA),
> +        .features = {
> +            { FEAT_7_0_EDX,         CPUID_7_0_EDX_AMX_TILE },
> +        },
>       },
>   };
>   
> @@ -7137,10 +7161,13 @@ static const char *x86_cpu_feature_name(FeatureWord w, int bitnr)
>       if (w == FEAT_XSAVE_XCR0_LO || w == FEAT_XSAVE_XCR0_HI) {
>           int comp = (w == FEAT_XSAVE_XCR0_HI) ? bitnr + 32 : bitnr;
>   
> -        if (comp < ARRAY_SIZE(x86_ext_save_areas) &&
> -            x86_ext_save_areas[comp].bits) {
> -            w = x86_ext_save_areas[comp].feature;
> -            bitnr = ctz32(x86_ext_save_areas[comp].bits);
> +        if (comp < ARRAY_SIZE(x86_ext_save_areas)) {
> +            /* Present the first feature as the default. */
> +            const FeatureMask *fm = &x86_ext_save_areas[comp].features[0];

It doesn't look right to me.

E.g., when users are requesting IBT, thus CET_U and CET_S, they might 
get "shstk" not avaiable.

> +            if (fm->mask != 0) {

Nit: if (fm->mask) is enough

> +                w = fm->index;
> +                bitnr = ctz32(fm->mask);
> +            }
>           }
>       }
>   
> @@ -8610,11 +8637,15 @@ static bool cpuid_has_xsave_feature(CPUX86State *env, const ExtSaveArea *esa)
>           return false;
>       }
>   
> -    if (env->features[esa->feature] & esa->bits) {
> -        return true;
> +    for (int i = 0; i < ARRAY_SIZE(esa->features); i++) {
> +        if (env->features[esa->features[i].index] & esa->features[i].mask) {
> +            return true;
> +        }
>       }
> -    if (esa->feature == FEAT_7_0_EBX && esa->bits == CPUID_7_0_EBX_AVX512F
> -        && (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
> +
> +    if (esa->features[0].index == FEAT_7_0_EBX &&
> +        esa->features[0].mask == CPUID_7_0_EBX_AVX512F &&
> +        (env->features[FEAT_7_1_EDX] & CPUID_7_1_EDX_AVX10)) {
>           return true;
>       }
>   
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index ac527971d8cd..6537affcf067 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1769,9 +1769,16 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
>   
>   typedef struct ExtSaveArea {
> -    uint32_t feature, bits;
>       uint32_t offset, size;
>       uint32_t ecx;
> +    /*
> +     * The dependencies in the array work as OR relationships, which
> +     * means having just one of those features is enough.
> +     *
> +     * At most two features are sharing the same xsave area.
> +     * Number of features can be adjusted if necessary.
> +     */
> +    const FeatureMask features[2];
>   } ExtSaveArea;
>   
>   #define XSAVE_STATE_AREA_COUNT (XSTATE_XTILE_DATA_BIT + 1)


