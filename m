Return-Path: <kvm+bounces-11512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B34C6877BE4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D66E01C20D51
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B541426D;
	Mon, 11 Mar 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nk6T4RVc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4B12B97
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710146752; cv=none; b=tNsTAuYTctSGDAHRli/XdwYPoOJSfOrjYXaf7gepZexUZP0+iGbU5dgAbf5EreC2fKvjypGcz+eTvyAAf8Dqa9MhG3a6BumPPBrrWbK+qQUYjcFoZUYN28kKcsycjkwojHq29OwnPO4qbcf2bOA4ZJqVtIHBdBWpWdD7kliBSVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710146752; c=relaxed/simple;
	bh=/F4x4ozVLeWf9qgvXPYCqWzDmTkI4g5EUawF7zHp6IA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gh3yd/fcLqqD2m7b7x0pNrTPqMX/laZhGjXLbyDq9TsdUzSTwFp996E/DUvRo7byNKrlEDDely2XcTnZocw+5mPnReB7n0ZMTzufg//U4gj5HZcJHSR4d8xX0/9oGiRIBHor1DitSFDrcngyKAj8XmprwHpyymEUIuwU9ywI6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nk6T4RVc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710146750; x=1741682750;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/F4x4ozVLeWf9qgvXPYCqWzDmTkI4g5EUawF7zHp6IA=;
  b=Nk6T4RVcVhP3VtJ97LjTg6vxsqJlryl9G+i6sweAD2jdKcRmvQpHmE7i
   fUO14IJpsE9KRYPYyNk9l98hJGXdAyLrHw9anO5WwYsjdGGjgcszGI7/E
   zygLjGRSH7A3Zzn5fG71fJtVsiLKyx1G/mqCOgOLBYKpDJ+DVl12a65Oj
   KoZl6bxU03iJcK2owY9EDhcySwZAGRmotqzDSP6tztkPJ3j9iWikUWiH3
   2O6bjxeT8BAjUaZ7i+7D5j5ciFiPADmcBGNT6PlTwB5/qmMJdpp0BHBzT
   WilMR9gMbU1pA+zNRiL23ocNwtcVro/4uH+L1VvjjTHsFj46xxdYxmA7j
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="8550331"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="8550331"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 01:45:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="11195125"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 01:45:44 -0700
Message-ID: <005c1649-43d3-494f-951a-166e7200ffd5@intel.com>
Date: Mon, 11 Mar 2024 16:45:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/21] i386/cpu: Decouple CPUID[0x1F] subleaf with
 specific topology level
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-12-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227103231.1556302-12-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 6:32 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> At present, the subleaf 0x02 of CPUID[0x1F] is bound to the "die" level.
> 
> In fact, the specific topology level exposed in 0x1F depends on the
> platform's support for extension levels (module, tile and die).
> 
> To help expose "module" level in 0x1F, decouple CPUID[0x1F] subleaf
> with specific topology level.
> 
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Besides, some nits below.

> ---
> Changes since v7:
>   * Refactored the encode_topo_cpuid1f() to use traversal to search the
>     encoded level and avoid using static variables. (Xiaoyao)
>     - Since the total number of levels in the bitmap is not too large,
>       the overhead of traversing is supposed to be acceptable.
>   * Renamed the variable num_cpus_next_level to num_threads_next_level.
>     (Xiaoyao)
>   * Renamed the helper num_cpus_by_topo_level() to
>     num_threads_by_topo_level(). (Xiaoyao)
>   * Dropped Michael/Babu's Acked/Tested tags since the code change.
>   * Re-added Yongwei's Tested tag For his re-testing.
> 
> Changes since v3:
>   * New patch to prepare to expose module level in 0x1F.
>   * Moved the CPUTopoLevel enumeration definition from "i386: Add cache
>     topology info in CPUCacheInfo" to this patch. Note, to align with
>     topology types in SDM, revert the name of CPU_TOPO_LEVEL_UNKNOW to
>     CPU_TOPO_LEVEL_INVALID.
> ---
>   target/i386/cpu.c | 138 +++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 113 insertions(+), 25 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 88dffd2b52e3..b0f171c6a465 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -269,6 +269,118 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
>              (cache->complex_indexing ? CACHE_COMPLEX_IDX : 0);
>   }
>   
> +static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
> +                                          enum CPUTopoLevel topo_level)
> +{
> +    switch (topo_level) {
> +    case CPU_TOPO_LEVEL_SMT:
> +        return 1;
> +    case CPU_TOPO_LEVEL_CORE:
> +        return topo_info->threads_per_core;
> +    case CPU_TOPO_LEVEL_DIE:
> +        return topo_info->threads_per_core * topo_info->cores_per_die;
> +    case CPU_TOPO_LEVEL_PACKAGE:
> +        return topo_info->threads_per_core * topo_info->cores_per_die *
> +               topo_info->dies_per_pkg;
> +    default:
> +        g_assert_not_reached();
> +    }
> +    return 0;
> +}
> +
> +static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
> +                                            enum CPUTopoLevel topo_level)
> +{
> +    switch (topo_level) {
> +    case CPU_TOPO_LEVEL_SMT:
> +        return 0;
> +    case CPU_TOPO_LEVEL_CORE:
> +        return apicid_core_offset(topo_info);
> +    case CPU_TOPO_LEVEL_DIE:
> +        return apicid_die_offset(topo_info);
> +    case CPU_TOPO_LEVEL_PACKAGE:
> +        return apicid_pkg_offset(topo_info);
> +    default:
> +        g_assert_not_reached();
> +    }
> +    return 0;
> +}
> +
> +static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> +{
> +    switch (topo_level) {
> +    case CPU_TOPO_LEVEL_INVALID:
> +        return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> +    case CPU_TOPO_LEVEL_SMT:
> +        return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> +    case CPU_TOPO_LEVEL_CORE:
> +        return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> +    case CPU_TOPO_LEVEL_DIE:
> +        return CPUID_1F_ECX_TOPO_LEVEL_DIE;
> +    default:
> +        /* Other types are not supported in QEMU. */
> +        g_assert_not_reached();
> +    }
> +    return 0;
> +}
> +
> +static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
> +                                X86CPUTopoInfo *topo_info,
> +                                uint32_t *eax, uint32_t *ebx,
> +                                uint32_t *ecx, uint32_t *edx)
> +{
> +    X86CPU *cpu = env_archcpu(env);
> +    unsigned long level;
> +    uint32_t num_threads_next_level, offset_next_level;
> +
> +    assert(count + 1 < CPU_TOPO_LEVEL_MAX);
> +
> +    /*
> +     * Find the No.count topology levels in avail_cpu_topo bitmap.
> +     * Start from bit 0 (CPU_TOPO_LEVEL_INVALID).

AFAICS, it starts from bit 1 (CPU_TOPO_LEVEL_SMT). Because the initial 
value of level is CPU_TOPO_LEVEL_INVALID, but the first round of the 
loop is to find the valid bit starting from (level + 1).

> +     */
> +    level = CPU_TOPO_LEVEL_INVALID;
> +    for (int i = 0; i <= count; i++) {
> +        level = find_next_bit(env->avail_cpu_topo,
> +                              CPU_TOPO_LEVEL_PACKAGE,
> +                              level + 1);
> +
> +        /*
> +         * CPUID[0x1f] doesn't explicitly encode the package level,
> +         * and it just encode the invalid level (all fields are 0)
> +         * into the last subleaf of 0x1f.
> +         */

QEMU will never set bit CPU_TOPO_LEVEL_PACKAGE in env->avail_cpu_topo.

So I think we should assert() it instead of fixing it silently.

> +        if (level == CPU_TOPO_LEVEL_PACKAGE) {
> +            level = CPU_TOPO_LEVEL_INVALID;
> +            break;
> +        }
> +    }
> +
> +    if (level == CPU_TOPO_LEVEL_INVALID) {
> +        num_threads_next_level = 0;
> +        offset_next_level = 0;
> +    } else {
> +        unsigned long next_level;

please define it at the beginning of the function. e.g.,

> +        next_level = find_next_bit(env->avail_cpu_topo,
> +                                   CPU_TOPO_LEVEL_PACKAGE,
> +                                   level + 1);
> +        num_threads_next_level = num_threads_by_topo_level(topo_info,
> +                                                           next_level);
> +        offset_next_level = apicid_offset_by_topo_level(topo_info,
> +                                                        next_level);
> +    }
> +
> +    *eax = offset_next_level;
> +    *ebx = num_threads_next_level;
> +    *ebx &= 0xffff; /* The count doesn't need to be reliable. */

we can combine them together. e.g.,

*ebx = num_threads_next_level & 0xffff; /* ... */

> +    *ecx = count & 0xff;
> +    *ecx |= cpuid1f_topo_type(level) << 8;

Ditto,

*ecx = count & 0xff | cpuid1f_topo_type(level) << 8;

> +    *edx = cpu->apic_id;
> +
> +    assert(!(*eax & ~0x1f));
> +}
> +
>   /* Encode cache info for CPUID[0x80000005].ECX or CPUID[0x80000005].EDX */
>   static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
>   {
> @@ -6287,31 +6399,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               break;
>           }
>   
> -        *ecx = count & 0xff;
> -        *edx = cpu->apic_id;
> -        switch (count) {
> -        case 0:
> -            *eax = apicid_core_offset(&topo_info);
> -            *ebx = topo_info.threads_per_core;
> -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_SMT << 8;
> -            break;
> -        case 1:
> -            *eax = apicid_die_offset(&topo_info);
> -            *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
> -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_CORE << 8;
> -            break;
> -        case 2:
> -            *eax = apicid_pkg_offset(&topo_info);
> -            *ebx = threads_per_pkg;
> -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_DIE << 8;
> -            break;
> -        default:
> -            *eax = 0;
> -            *ebx = 0;
> -            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_INVALID << 8;
> -        }
> -        assert(!(*eax & ~0x1f));
> -        *ebx &= 0xffff; /* The count doesn't need to be reliable. */
> +        encode_topo_cpuid1f(env, count, &topo_info, eax, ebx, ecx, edx);
>           break;
>       case 0xD: {
>           /* Processor Extended State */


