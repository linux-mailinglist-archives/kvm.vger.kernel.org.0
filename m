Return-Path: <kvm+bounces-52258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE32B03464
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 04:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BED31885A21
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 02:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C260F1C861D;
	Mon, 14 Jul 2025 02:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CdSYKPx2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CF817B50A
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 02:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752459268; cv=none; b=BPLvM0QH0X4SoWW2uaCxmnkVw5eib6V/ynLtmsMZvs3wbJREhj1UmbwCYloN1MnXPeel553ATf0qNCsy669ttGKJk4vIZQOsa4M3HZKyjIvQumxT9Hqn19FqBnCqD3Rk4D/ATBM45WNtHF9w4v1LbqEcn3DV3IsE0bRwYk+3cv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752459268; c=relaxed/simple;
	bh=HRVqwjo/sUcMRBRRlPeumOnSGG3iOiRC73GSgqSZB1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NB5ULlTaHDeTLJ+Bo49aAe8GjT+FLVgw6enqvptANyMU3Oonki80d5dB8Ws/NpzXoLIHGHCq8LjPaobCJBP++7mQRgINxp0POUaX4SZ8jxtLbVk8qgAqiPEhl81GNaEYbA5dbOikRXXD6oYBTbDuQLdVcN1DfhAkkk0ENoMdcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CdSYKPx2; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752459267; x=1783995267;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HRVqwjo/sUcMRBRRlPeumOnSGG3iOiRC73GSgqSZB1g=;
  b=CdSYKPx25DR+4omlTZ6qQ5f6Xwy9E40DAi2lb8JVe4iMuZtZ+VT713tI
   VcJrsmawozLijL/Ei4fwA8FpMW5Ciw5rF35WARvRMi4UtHy8jyQfru+Yi
   Iq8r2kkMB8IEV+jjtiU8egiifMWDfZhTwfabVnWUiBU54YMMAygdauD+m
   ZyLK62xWWiGB2XxxvR5A8sAGvACk5Giz6voF6VNP8PTiLmY1A63olaXiY
   zxoBOn96RpZQXPhz70yfqL5idVdjz3G6njdBhXBS5ZWr+d6awsPCh43Mg
   5ZunLC6pn+wTYQ73xZlqMZ/shcx7Smh0SsaIViBgCubS2zohiNBFUYVDB
   Q==;
X-CSE-ConnectionGUID: zmTuyGVEQbOyuTAp+PanKw==
X-CSE-MsgGUID: 7FlZBd0nRCyX8Da5spU9Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54781331"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54781331"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 19:14:27 -0700
X-CSE-ConnectionGUID: n/fwqHXaRaCNrrZ1LIZ6yQ==
X-CSE-MsgGUID: sOxpYQfBQlSd1+04/xh3uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="157304989"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.57]) ([10.124.240.57])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 19:14:22 -0700
Message-ID: <2c2ea3ae-30ea-4ff3-848a-fed6a86c0c53@linux.intel.com>
Date: Mon, 14 Jul 2025 10:14:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/18] i386/cpu: Add default cache model for Intel CPUs
 with level < 4
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
 <20250711102143.1622339-4-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250711102143.1622339-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 7/11/2025 6:21 PM, Zhao Liu wrote:
> Old Intel CPUs with CPUID level < 4, use CPUID 0x2 leaf (if available)
> to encode cache information.
>
> Introduce a cache model "legacy_intel_cpuid2_cache_info" for the CPUs
> with CPUID level < 4, based on legacy_l1d_cache, legacy_l1i_cache,
> legacy_l2_cache_cpuid2 and legacy_l3_cache. But for L2 cache, this
> cache model completes self_init, sets, partitions, no_invd_sharing and
> share_level fields, referring legacy_l2_cache, to avoid someone
> increases CPUID level manually and meets assert() error. But the cache
> information present in CPUID 0x2 leaf doesn't change.
>
> This new cache model makes it possible to remove legacy_l2_cache_cpuid2
> in X86CPUState and help to clarify historical cache inconsistency issue.
>
> Furthermore, apply this legacy cache model to all Intel CPUs with CPUID
> level < 4. This includes not only "pentium2" and "pentium3" (which have
> 0x2 leaf), but also "486" and "pentium" (which only have 0x1 leaf, and
> cache model won't be presented, just for simplicity).
>
> A legacy_intel_cpuid2_cache_info cache model doesn't change the cache
> information of the above CPUs, because they just depend on 0x2 leaf.
>
> Only when someone adjusts the min-level to >=4 will the cache
> information in CPUID leaf 4 differ from before: previously, the L2
> cache information in CPUID leaf 0x2 and 0x4 was different, but now with
> legacy_intel_cpuid2_cache_info, the information they present will be
> consistent. This case almost never happens, emulating a CPUID that is
> not supported by the "ancient" hardware is itself meaningless behavior.
>
> Therefore, even though there's the above difference (for really rare
> case) and considering these old CPUs ("486", "pentium", "pentium2" and
> "pentium3") won't be used for migration, there's no need to add new
> versioned CPU models
>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 75932579542a..f85e087bf7df 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -710,6 +710,67 @@ static CPUCacheInfo legacy_l3_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_DIE,
>  };
>  
> +/*
> + * Only used for the CPU models with CPUID level < 4.
> + * These CPUs (CPUID level < 4) only use CPUID leaf 2 to present
> + * cache information.
> + *
> + * Note: This cache model is just a default one, and is not
> + *       guaranteed to match real hardwares.
> + */
> +static const CPUCaches legacy_intel_cpuid2_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .sets = 64,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .sets = 64,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 2 * MiB,
> +        .self_init = 1,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .sets = 4096,
> +        .partitions = 1,
> +        .no_invd_sharing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 16 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .sets = 16384,
> +        .partitions = 1,
> +        .lines_per_tag = 1,
> +        .self_init = true,
> +        .inclusive = true,
> +        .complex_indexing = true,
> +        .share_level = CPU_TOPOLOGY_LEVEL_DIE,
> +    },
> +};
> +
>  /* TLB definitions: */
>  
>  #define L1_DTLB_2M_ASSOC       1
> @@ -3043,6 +3104,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              I486_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium",
> @@ -3055,6 +3117,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium2",
> @@ -3067,6 +3130,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM2_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "pentium3",
> @@ -3079,6 +3143,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>              PENTIUM3_FEATURES,
>          .xlevel = 0,
>          .model_id = "",
> +        .cache_info = &legacy_intel_cpuid2_cache_info,
>      },
>      {
>          .name = "athlon",

Reviewed-by:  Dapeng Mi <dapeng1.mi@linux.intel.com>



