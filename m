Return-Path: <kvm+bounces-51396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0804AF6DB6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 515A53B0FFB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2492D3728;
	Thu,  3 Jul 2025 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k8LLgW6T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2362D3221
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751532839; cv=none; b=JlLr7oCO1peU1GvL5I4IcW9BnKgoFsE//+HAn+BDumPF73OIvSyocC6qLVfINZZnhzyxxy70xxP/PkYGKReqwka9Xxw8yV/p1AD7tMFqvJLTpV8vEw+eH2il0lS+j17D334MWMrt6MtkL3vL8eKMVyzl0L0oCIp49Myb3nsZtkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751532839; c=relaxed/simple;
	bh=SKH7Y/vJ/A35SyFZsuFjwuZaWMzUx+bEsUWgwn1epWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oC44jz41lNaWpMLrmhtItZ/TlSiXUvvT2Puv3zhQy6ZANdgwB7Kxgd/9knRSftlvFu2C7j0qoEBGiDU8Ao6Nevn4kfCNUFTA+eqFTuk6bzuVuF7ORfoCtp9vss/WRqg9z4qGvZbX8pGDh7vj5qDwHMfhPNU1TXBd7YMfVUfBRNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k8LLgW6T; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751532838; x=1783068838;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SKH7Y/vJ/A35SyFZsuFjwuZaWMzUx+bEsUWgwn1epWc=;
  b=k8LLgW6TDdO65kmjTTZBQN8ufmK4qPNv2ASO9coOrWWmC8Zu2EOepcQz
   VL9D9xjcw0fI8RhjVrGILPiWpmCfPLkTQ5WNGvGvsRUgi8eGvCXpXNu6x
   T4EcdwT33I1JLqmjqL9LuBZ1tIadwA9DsNZdtYjL8Kl6IJZBjgcmF4tr9
   6h4k2xscPFHSQC/53B5eFgCWRF5YGrfOOeEPHbCtDvmBfgaWz+OHmaoIy
   dX4wNTeJ7GOeqgZ6kQVvoQww6/HawgipFRjfMRSyh5Z3FVcBKR+s6Lv2u
   V+di+etaSE5g+S9wnR5ovfS95ZW7OwV1pzJHSuv8+V4jbVGyc8MUGUjhy
   g==;
X-CSE-ConnectionGUID: n7KXdIqfSTq6vjXBksgfqQ==
X-CSE-MsgGUID: PGfU1hJLTXqL6DuXfGcxjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64447702"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64447702"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:53:57 -0700
X-CSE-ConnectionGUID: KlZHhfQpSnOAX9GZpnmLRw==
X-CSE-MsgGUID: br6cLjd/T8WEEwPyCmY+mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153742936"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:53:54 -0700
Message-ID: <3d1f5698-1936-4fc0-af04-db900f0d1b9e@linux.intel.com>
Date: Thu, 3 Jul 2025 16:53:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/16] i386/cpu: Use a unified cache_info in X86CPUState
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
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-17-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-17-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> At present, all cases using the cache model (CPUID 0x2, 0x4, 0x80000005,
> 0x80000006 and 0x8000001D leaves) have been verified to be able to
> select either cache_info_intel or cache_info_amd based on the vendor.
>
> Therefore, further merge cache_info_intel and cache_info_amd into a
> unified cache_info in X86CPUState, and during its initialization, set
> different legacy cache models based on the vendor.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 150 ++++++++--------------------------------------
>  target/i386/cpu.h |   5 +-
>  2 files changed, 27 insertions(+), 128 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 4e9ac37850c0..c1d1289ee9de 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7484,27 +7484,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          } else if (env->enable_legacy_vendor_cache) {
>              caches = &legacy_intel_cache_info;
>          } else {
> -            /*
> -             * FIXME: Temporarily select cache info model here based on
> -             * vendor, and merge these 2 cache info models later.
> -             *
> -             * This condition covers the following cases (with
> -             * enable_legacy_vendor_cache=false):
> -             *  - When CPU model has its own cache model and doesn't use legacy
> -             *    cache model (legacy_model=off). Then cache_info_amd and
> -             *    cache_info_cpuid4 are the same.
> -             *
> -             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> -             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
> -             *    CPU will use cache_info_amd. But this doesn't matter for AMD
> -             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
> -             *    model is.
> -             */
> -            if (IS_AMD_CPU(env)) {
> -                caches = &env->cache_info_amd;
> -            } else {
> -                caches = &env->cache_info_cpuid4;
> -            }
> +            caches = &env->cache_info;
>          }
>  
>          if (cpu->cache_info_passthrough) {
> @@ -7523,27 +7503,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (env->enable_legacy_vendor_cache) {
>              caches = &legacy_intel_cache_info;
>          } else {
> -            /*
> -             * FIXME: Temporarily select cache info model here based on
> -             * vendor, and merge these 2 cache info models later.
> -             *
> -             * This condition covers the following cases (with
> -             * enable_legacy_vendor_cache=false):
> -             *  - When CPU model has its own cache model and doesn't use legacy
> -             *    cache model (legacy_model=off). Then cache_info_amd and
> -             *    cache_info_cpuid4 are the same.
> -             *
> -             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> -             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
> -             *    CPU will use cache_info_amd. But this doesn't matter for AMD
> -             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
> -             *    model is.
> -             */
> -            if (IS_AMD_CPU(env)) {
> -                caches = &env->cache_info_amd;
> -            } else {
> -                caches = &env->cache_info_cpuid4;
> -            }
> +            caches = &env->cache_info;
>          }
>  
>          /* cache info: needed for Core compatibility */
> @@ -7951,27 +7911,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (env->enable_legacy_vendor_cache) {
>              caches = &legacy_amd_cache_info;
>          } else {
> -            /*
> -             * FIXME: Temporarily select cache info model here based on
> -             * vendor, and merge these 2 cache info models later.
> -             *
> -             * This condition covers the following cases (with
> -             * enable_legacy_vendor_cache=false):
> -             *  - When CPU model has its own cache model and doesn't uses legacy
> -             *    cache model (legacy_model=off). Then cache_info_amd and
> -             *    cache_info_cpuid4 are the same.
> -             *
> -             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> -             *    model. AMD CPUs use cache_info_amd like before and non-AMD
> -             *    CPU will use cache_info_cpuid4. But this doesn't matter,
> -             *    because for Intel CPU, it will get all-0 leaf, and Zhaoxin CPU
> -             *    will get correct cache info. Both are expected.
> -             */
> -            if (IS_AMD_CPU(env)) {
> -                caches = &env->cache_info_amd;
> -            } else {
> -                caches = &env->cache_info_cpuid4;
> -            }
> +            caches = &env->cache_info;
>          }
>  
>          if (cpu->cache_info_passthrough) {
> @@ -7998,25 +7938,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          if (env->enable_legacy_vendor_cache) {
>              caches = &legacy_amd_cache_info;
>          } else {
> -            /*
> -             * FIXME: Temporarily select cache info model here based on
> -             * vendor, and merge these 2 cache info models later.
> -             *
> -             * This condition covers the following cases (with
> -             * enable_legacy_vendor_cache=false):
> -             *  - When CPU model has its own cache model and doesn't uses legacy
> -             *    cache model (legacy_model=off). Then cache_info_amd and
> -             *    cache_info_cpuid4 are the same.
> -             *
> -             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> -             *    model. AMD CPUs use cache_info_amd like before and non-AMD
> -             *    CPU (Intel & Zhaoxin) will use cache_info_cpuid4 as expected.
> -             */
> -            if (IS_AMD_CPU(env)) {
> -                caches = &env->cache_info_amd;
> -            } else {
> -                caches = &env->cache_info_cpuid4;
> -            }
> +            caches = &env->cache_info;
>          }
>  
>          if (cpu->cache_info_passthrough) {
> @@ -8089,22 +8011,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *edx = 0;
>          }
>          break;
> -    case 0x8000001D: {
> -        const CPUCaches *caches;
> -
> -        /*
> -         * FIXME: Temporarily select cache info model here based on
> -         * vendor, and merge these 2 cache info models later.
> -         *
> -         * Intel doesn't support this leaf so that Intel Guests don't
> -         * have this leaf. This change is harmless to Intel CPUs.
> -         */
> -        if (IS_AMD_CPU(env)) {
> -            caches = &env->cache_info_amd;
> -        } else {
> -            caches = &env->cache_info_cpuid4;
> -        }
> -
> +    case 0x8000001D:
>          *eax = 0;
>          if (cpu->cache_info_passthrough) {
>              x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
> @@ -8112,19 +8019,19 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          }
>          switch (count) {
>          case 0: /* L1 dcache info */
> -            encode_cache_cpuid8000001d(caches->l1d_cache,
> +            encode_cache_cpuid8000001d(env->cache_info.l1d_cache,
>                                         topo_info, eax, ebx, ecx, edx);
>              break;
>          case 1: /* L1 icache info */
> -            encode_cache_cpuid8000001d(caches->l1i_cache,
> +            encode_cache_cpuid8000001d(env->cache_info.l1i_cache,
>                                         topo_info, eax, ebx, ecx, edx);
>              break;
>          case 2: /* L2 cache info */
> -            encode_cache_cpuid8000001d(caches->l2_cache,
> +            encode_cache_cpuid8000001d(env->cache_info.l2_cache,
>                                         topo_info, eax, ebx, ecx, edx);
>              break;
>          case 3: /* L3 cache info */
> -            encode_cache_cpuid8000001d(caches->l3_cache,
> +            encode_cache_cpuid8000001d(env->cache_info.l3_cache,
>                                         topo_info, eax, ebx, ecx, edx);
>              break;
>          default: /* end of info */
> @@ -8135,7 +8042,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              *edx &= CACHE_NO_INVD_SHARING | CACHE_INCLUSIVE;
>          }
>          break;
> -    }
>      case 0x8000001E:
>          if (cpu->core_id <= 255) {
>              encode_topo_cpuid8000001e(cpu, topo_info, eax, ebx, ecx, edx);
> @@ -8825,46 +8731,34 @@ static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
>  
>      level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D);
>      if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
> -        env->cache_info_cpuid4.l1d_cache->share_level = level;
> -        env->cache_info_amd.l1d_cache->share_level = level;
> +        env->cache_info.l1d_cache->share_level = level;
>      } else {
>          machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
> -            env->cache_info_cpuid4.l1d_cache->share_level);
> -        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
> -            env->cache_info_amd.l1d_cache->share_level);
> +            env->cache_info.l1d_cache->share_level);
>      }
>  
>      level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I);
>      if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
> -        env->cache_info_cpuid4.l1i_cache->share_level = level;
> -        env->cache_info_amd.l1i_cache->share_level = level;
> +        env->cache_info.l1i_cache->share_level = level;
>      } else {
>          machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
> -            env->cache_info_cpuid4.l1i_cache->share_level);
> -        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
> -            env->cache_info_amd.l1i_cache->share_level);
> +            env->cache_info.l1i_cache->share_level);
>      }
>  
>      level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2);
>      if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
> -        env->cache_info_cpuid4.l2_cache->share_level = level;
> -        env->cache_info_amd.l2_cache->share_level = level;
> +        env->cache_info.l2_cache->share_level = level;
>      } else {
>          machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
> -            env->cache_info_cpuid4.l2_cache->share_level);
> -        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
> -            env->cache_info_amd.l2_cache->share_level);
> +            env->cache_info.l2_cache->share_level);
>      }
>  
>      level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3);
>      if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
> -        env->cache_info_cpuid4.l3_cache->share_level = level;
> -        env->cache_info_amd.l3_cache->share_level = level;
> +        env->cache_info.l3_cache->share_level = level;
>      } else {
>          machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
> -            env->cache_info_cpuid4.l3_cache->share_level);
> -        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
> -            env->cache_info_amd.l3_cache->share_level);
> +            env->cache_info.l3_cache->share_level);
>      }
>  
>      if (!machine_check_smp_cache(ms, errp)) {
> @@ -9091,7 +8985,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>                         "CPU model '%s' doesn't support legacy-cache=off", name);
>              return;
>          }
> -        env->cache_info_cpuid4 = env->cache_info_amd = *cache_info;
> +        env->cache_info = *cache_info;
>      } else {
>          /* Build legacy cache information */
>          if (!cpu->consistent_cache) {
> @@ -9101,8 +8995,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
>          if (!cpu->vendor_cpuid_only_v2) {
>              env->enable_legacy_vendor_cache = true;
>          }
> -        env->cache_info_cpuid4 = legacy_intel_cache_info;
> -        env->cache_info_amd = legacy_amd_cache_info;
> +
> +        if (IS_AMD_CPU(env)) {
> +            env->cache_info = legacy_amd_cache_info;
> +        } else {
> +            env->cache_info = legacy_intel_cache_info;
> +        }
>      }
>  
>  #ifndef CONFIG_USER_ONLY
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 243383efd602..3f79db679888 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2072,11 +2072,12 @@ typedef struct CPUArchState {
>      /* Features that were explicitly enabled/disabled */
>      FeatureWordArray user_features;
>      uint32_t cpuid_model[12];
> -    /* Cache information for CPUID.  When legacy-cache=on, the cache data
> +    /*
> +     * Cache information for CPUID.  When legacy-cache=on, the cache data
>       * on each CPUID leaf will be different, because we keep compatibility
>       * with old QEMU versions.
>       */
> -    CPUCaches cache_info_cpuid4, cache_info_amd;
> +    CPUCaches cache_info;
>      bool enable_legacy_cpuid2_cache;
>      bool enable_legacy_vendor_cache;
>  

Nice clean-up patch series. Thanks.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



