Return-Path: <kvm+bounces-51394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F30EAF6D9A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78AE47B1023
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E95D28D8F4;
	Thu,  3 Jul 2025 08:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DyYNZCjZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFAB1E8338
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 08:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751532571; cv=none; b=ZrGntEMEvNPFJkiXNkQCCV7Mcs6FVULNvRhs0TTdW0cuhOKKVzmPuodxhiwbm30WZM9wPYcdTi7c5EZtEu22bi+lK4nzLS7xIW9ZqqrDalWavKAr2dKK53PRl1piUBO2lrQ2njv9Z/oNbdUOE7zerAIIsBrhA5emxQ24Rv4saLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751532571; c=relaxed/simple;
	bh=V4eHQYcw5OmdxKXnRWEzCLHYS09ZKY+sR720sZb1t3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MTz2Aj8ClgL7WnRIA1GTWSAhg17odqZU3Ib/kbWiHlH6RcvjJGxczmiOfYRQ2WAZCKltkjK+GNUmcH1zXVVVvuLkNERE6C3+cV56XUrXizEk3KdN0snYutu8LhQks17tiCY0YwfuxlDiHIODsuyz69BZQARUgByB8YUmPnpH/cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DyYNZCjZ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751532569; x=1783068569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V4eHQYcw5OmdxKXnRWEzCLHYS09ZKY+sR720sZb1t3U=;
  b=DyYNZCjZI+s5nvpuWMZHp+3x9l12AC9htkEI9SxRzc+QkFftuJk7Bzv0
   tJ8PD4MmQgMzQKzxQDIyG404Iv8WhoCT/dHOqvlQdPDF68GvyyUQtYfJb
   E2Jp8XlzSBExudp9syOX4R4FBR3d55mJfR3peZPbrjtqbIwJ9fue2FNv7
   rPYyCcx1x6Hu3cNkE60UhFAXq1rzVg8lmgyQfvnp/CUcOIU6zB2FIZgKO
   xlY6NZwYAWVUF9w3WkyalPb1gZfsL2VKqXHnyb2+G3f829FV6LsikUP1M
   n0PpaVI9cJDWj/3pldekFh+MpKnZ+500t9Hs6IiFSoMZozT3ah61xD90H
   A==;
X-CSE-ConnectionGUID: 8duJ9MF0TsG4MfIa7wdIwA==
X-CSE-MsgGUID: 52zdOzwZSneLkZvhIBGasQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="41474744"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="41474744"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:49:29 -0700
X-CSE-ConnectionGUID: VtkWFAWfQ1+TXtN15UGzUg==
X-CSE-MsgGUID: eqP/oKRMTk6eqBsi5FZL3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158675033"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 01:49:25 -0700
Message-ID: <ee01bc7e-31a2-46af-8c2b-271119cc53ee@linux.intel.com>
Date: Thu, 3 Jul 2025 16:49:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] i386/cpu: Select legacy cache model based on vendor
 in CPUID 0x4
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
 <20250620092734.1576677-13-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-13-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> As preparation for merging cache_info_cpuid4 and cache_info_amd in
> X86CPUState, set legacy cache model based on vendor in the CPUID 0x4
> leaf. For AMD CPU, select legacy AMD cache model (in cache_info_amd) as
> the default cache model, otherwise, select legacy Intel cache model (in
> cache_info_cpuid4) as before.
>
> To ensure compatibility is not broken, add an enable_legacy_vendor_cache
> flag based on x-vendor-only-v2 to indicate cases where the legacy cache
> model should be used regardless of the vendor. For CPUID 0x4 leaf,
> enable_legacy_vendor_cache flag indicates to pick legacy Intel cache
> model, which is for compatibility with the behavior of PC machine v10.0
> and older.
>
> The following explains how current vendor-based default legacy cache
> model ensures correctness without breaking compatibility.
>
> * For the PC machine v6.0 and older, vendor_cpuid_only=false, and
>   vendor_cpuid_only_v2=false.
>
>   - If the named CPU model has its own cache model, and doesn't use
>     legacy cache model (legacy_cache=false), then cache_info_cpuid4 and
>     cache_info_amd are same, so 0x4 leaf uses its own cache model
>     regardless of the vendor.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is true, they will use legacy Intel cache
>     model just like their previous behavior.
>
> * For the PC machine v10.0 and older (to v6.1), vendor_cpuid_only=true,
>   and vendor_cpuid_only_v2=false.
>
>   - If the named CPU model has its own cache model (legacy_cache=false),
>     then cache_info_cpuid4 & cache_info_amd both equal to its own cache
>     model, so it uses its own cache model in 0x4 leaf regardless of the
>     vendor. Only AMD CPUs have all-0 leaf due to vendor_cpuid_only=true,
>     and this is exactly the behavior of these old machines.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is true, they will use legacy Intel cache
>     model. Similarly, only AMD CPUs have all-0 leaf, and this is exactly
>     the behavior of these old machines.
>
> * For the PC machine v10.1 and newer, vendor_cpuid_only=true, and
>   vendor_cpuid_only_v2=true.
>
>   - If the named CPU model has its own cache model (legacy_cache=false),
>     then cache_info_cpuid4 & cache_info_amd both equal to its own cache
>     model, so it uses its own cache model in 0x4 leaf regardless of the
>     vendor. And AMD CPUs have all-0 leaf. Nothing will change.
>
>   - For max/host/named CPU (without its own cache model), then the flag
>     enable_legacy_vendor_cache is false, the legacy cache model is
>     selected based on vendor.
>
>     For AMD CPU, it will use legacy AMD cache but still get all-0 leaf
>     due to vendor_cpuid_only=true.
>
>     For non-AMD (Intel/Zhaoxin) CPU, it will use legacy Intel cache as
>     expected.
>
>     Here, selecting the legacy cache model based on the vendor does not
>     change the previous (before the change) behavior.
>
> Therefore, the above analysis proves that, with the help of the flag
> enable_legacy_vendor_cache, it is acceptable to select the default
> legacy cache model based on the vendor.
>
> For the CPUID 0x4 leaf, in X86CPUState, a unified cache_info is enough.
> It only needs to be initialized and configured with the corresponding
> legacy cache model based on the vendor.
>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>  target/i386/cpu.c | 43 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 9 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 524d39de9ace..afbf11569ab4 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7517,7 +7517,35 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          encode_cache_cpuid2(cpu, caches, eax, ebx, ecx, edx);
>          break;
>      }
> -    case 4:
> +    case 4: {
> +        const CPUCaches *caches;
> +
> +        if (env->enable_legacy_vendor_cache) {
> +            caches = &legacy_intel_cache_info;
> +        } else {
> +            /*
> +             * FIXME: Temporarily select cache info model here based on
> +             * vendor, and merge these 2 cache info models later.
> +             *
> +             * This condition covers the following cases (with
> +             * enable_legacy_vendor_cache=false):
> +             *  - When CPU model has its own cache model and doesn't use legacy
> +             *    cache model (legacy_model=off). Then cache_info_amd and
> +             *    cache_info_cpuid4 are the same.
> +             *
> +             *  - For v10.1 and newer machines, when CPU model uses legacy cache
> +             *    model. Non-AMD CPUs use cache_info_cpuid4 like before and AMD
> +             *    CPU will use cache_info_amd. But this doesn't matter for AMD
> +             *    CPU, because this leaf encodes all-0 for AMD whatever its cache
> +             *    model is.
> +             */
> +            if (IS_AMD_CPU(env)) {
> +                caches = &env->cache_info_amd;
> +            } else {
> +                caches = &env->cache_info_cpuid4;
> +            }
> +        }
> +
>          /* cache info: needed for Core compatibility */
>          if (cpu->cache_info_passthrough) {
>              x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
> @@ -7545,30 +7573,26 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>  
>              switch (count) {
>              case 0: /* L1 dcache info */
> -                encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
> -                                    topo_info,
> +                encode_cache_cpuid4(caches->l1d_cache, topo_info,
>                                      eax, ebx, ecx, edx);
>                  if (!cpu->l1_cache_per_core) {
>                      *eax &= ~MAKE_64BIT_MASK(14, 12);
>                  }
>                  break;
>              case 1: /* L1 icache info */
> -                encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
> -                                    topo_info,
> +                encode_cache_cpuid4(caches->l1i_cache, topo_info,
>                                      eax, ebx, ecx, edx);
>                  if (!cpu->l1_cache_per_core) {
>                      *eax &= ~MAKE_64BIT_MASK(14, 12);
>                  }
>                  break;
>              case 2: /* L2 cache info */
> -                encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
> -                                    topo_info,
> +                encode_cache_cpuid4(caches->l2_cache, topo_info,
>                                      eax, ebx, ecx, edx);
>                  break;
>              case 3: /* L3 cache info */
>                  if (cpu->enable_l3_cache) {
> -                    encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
> -                                        topo_info,
> +                    encode_cache_cpuid4(caches->l3_cache, topo_info,
>                                          eax, ebx, ecx, edx);
>                      break;
>                  }
> @@ -7579,6 +7603,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>              }
>          }
>          break;
> +    }
>      case 5:
>          /* MONITOR/MWAIT Leaf */
>          *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */

LGTM. Thanks.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



