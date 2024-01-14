Return-Path: <kvm+bounces-6171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D6C82D0E6
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 15:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F10C81C20B9B
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 14:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFC923DE;
	Sun, 14 Jan 2024 14:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDR9Xz/9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2F23BD
	for <kvm@vger.kernel.org>; Sun, 14 Jan 2024 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705242716; x=1736778716;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j6+Urk3lkm3T5NcmHM8cKKiAlRUgQrRUD/6ylVMNn3I=;
  b=YDR9Xz/9wDleLaw+BhVwBF2MaP9Q4PEDnlQeMy1E4/D07uDlDs3juGQ3
   u2Kh0+S0qvVyW/X8udtGDSWSFVC9WqmISJ+y8RAJUsJnOX14jI03mNi23
   9DSd1O2fROf4w7FLsX7bHKpWGp65VzRXkl1BXZsjGlTLEDyPITU47cODC
   iPufusNgcAYwZp8VnYeJqK+hImNEKYUnabc3e6KLUHBT84EvNSypJu4jq
   WPKA/RxyWJ/vvxsyGfs4QiVyZg3zN/NfCLiYhF7DFMLC1x4rwN/SMMbh5
   Thx8u3fNRnjIf7rP7ImuwSORbN2Zhl8d8vyqznOxV0CjtLoKJ6gRrq4g5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6559356"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="6559356"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 06:31:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="906806193"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="906806193"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 06:31:52 -0800
Message-ID: <a0cd67f2-94f2-4c4b-9212-6b7344163660@intel.com>
Date: Sun, 14 Jan 2024 22:31:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/16] i386: Use CPUCacheInfo.share_level to encode
 CPUID[4]
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-15-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108082727.420817-15-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2024 4:27 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> CPUID[4].EAX[bits 25:14] is used to represent the cache topology for
> Intel CPUs.
> 
> After cache models have topology information, we can use
> CPUCacheInfo.share_level to decide which topology level to be encoded
> into CPUID[4].EAX[bits 25:14].
> 
> And since maximum_processor_id (original "num_apic_ids") is parsed
> based on cpu topology levels, which are verified when parsing smp, it's
> no need to check this value by "assert(num_apic_ids > 0)" again, so
> remove this assert.
> 
> Additionally, wrap the encoding of CPUID[4].EAX[bits 31:26] into a
> helper to make the code cleaner.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v1:
>   * Use "enum CPUTopoLevel share_level" as the parameter in
>     max_processor_ids_for_cache().
>   * Make cache_into_passthrough case also use
>     max_processor_ids_for_cache() and max_core_ids_in_package() to
>     encode CPUID[4]. (Yanan)
>   * Rename the title of this patch (the original is "i386: Use
>     CPUCacheInfo.share_level to encode CPUID[4].EAX[bits 25:14]").
> ---
>   target/i386/cpu.c | 70 +++++++++++++++++++++++++++++------------------
>   1 file changed, 43 insertions(+), 27 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 81e07474acef..b23e8190dc68 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -235,22 +235,53 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
>                          ((t) == UNIFIED_CACHE) ? CACHE_TYPE_UNIFIED : \
>                          0 /* Invalid value */)
>   
> +static uint32_t max_processor_ids_for_cache(X86CPUTopoInfo *topo_info,
> +                                            enum CPUTopoLevel share_level)

I prefer the name to max_lp_ids_share_the_cache()

> +{
> +    uint32_t num_ids = 0;
> +
> +    switch (share_level) {
> +    case CPU_TOPO_LEVEL_CORE:
> +        num_ids = 1 << apicid_core_offset(topo_info);
> +        break;
> +    case CPU_TOPO_LEVEL_DIE:
> +        num_ids = 1 << apicid_die_offset(topo_info);
> +        break;
> +    case CPU_TOPO_LEVEL_PACKAGE:
> +        num_ids = 1 << apicid_pkg_offset(topo_info);
> +        break;
> +    default:
> +        /*
> +         * Currently there is no use case for SMT and MODULE, so use
> +         * assert directly to facilitate debugging.
> +         */
> +        g_assert_not_reached();
> +    }
> +
> +    return num_ids - 1;

suggest to just return num_ids, and let the caller to do the -1 work.

> +}
> +
> +static uint32_t max_core_ids_in_package(X86CPUTopoInfo *topo_info)
> +{
> +    uint32_t num_cores = 1 << (apicid_pkg_offset(topo_info) -
> +                               apicid_core_offset(topo_info));
> +    return num_cores - 1;

ditto.

> +}
>   
>   /* Encode cache info for CPUID[4] */
>   static void encode_cache_cpuid4(CPUCacheInfo *cache,
> -                                int num_apic_ids, int num_cores,
> +                                X86CPUTopoInfo *topo_info,
>                                   uint32_t *eax, uint32_t *ebx,
>                                   uint32_t *ecx, uint32_t *edx)
>   {
>       assert(cache->size == cache->line_size * cache->associativity *
>                             cache->partitions * cache->sets);
>   
> -    assert(num_apic_ids > 0);
>       *eax = CACHE_TYPE(cache->type) |
>              CACHE_LEVEL(cache->level) |
>              (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0) |
> -           ((num_cores - 1) << 26) |
> -           ((num_apic_ids - 1) << 14);
> +           (max_core_ids_in_package(topo_info) << 26) |
> +           (max_processor_ids_for_cache(topo_info, cache->share_level) << 14);

by the way, we can change the order of the two line. :)

>   
>       assert(cache->line_size > 0);
>       assert(cache->partitions > 0);
> @@ -6263,56 +6294,41 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
>   
>                   if (cores_per_pkg > 1) {
> -                    int addressable_cores_offset =
> -                                                apicid_pkg_offset(&topo_info) -
> -                                                apicid_core_offset(&topo_info);
> -
>                       *eax &= ~0xFC000000;
> -                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
> +                    *eax |= max_core_ids_in_package(&topo_info) << 26;
>                   }
>                   if (host_vcpus_per_cache > cpus_per_pkg) {
> -                    int pkg_offset = apicid_pkg_offset(&topo_info);
> -
>                       *eax &= ~0x3FFC000;
> -                    *eax |= (1 << (pkg_offset - 1)) << 14;
> +                    *eax |=
> +                        max_processor_ids_for_cache(&topo_info,
> +                                                CPU_TOPO_LEVEL_PACKAGE) << 14;
>                   }
>               }
>           } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
>               *eax = *ebx = *ecx = *edx = 0;
>           } else {
>               *eax = 0;
> -            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
> -                                           apicid_core_offset(&topo_info);
> -            int core_offset, die_offset;
>   
>               switch (count) {
>               case 0: /* L1 dcache info */
> -                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
> -                                    (1 << core_offset),
> -                                    (1 << addressable_cores_offset),
> +                                    &topo_info,
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 1: /* L1 icache info */
> -                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
> -                                    (1 << core_offset),
> -                                    (1 << addressable_cores_offset),
> +                                    &topo_info,
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 2: /* L2 cache info */
> -                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
> -                                    (1 << core_offset),
> -                                    (1 << addressable_cores_offset),
> +                                    &topo_info,
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 3: /* L3 cache info */
> -                die_offset = apicid_die_offset(&topo_info);
>                   if (cpu->enable_l3_cache) {
>                       encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
> -                                        (1 << die_offset),
> -                                        (1 << addressable_cores_offset),
> +                                        &topo_info,
>                                           eax, ebx, ecx, edx);
>                       break;
>                   }


