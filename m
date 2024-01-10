Return-Path: <kvm+bounces-5985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 27046829655
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 10:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11F751C2194B
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 09:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC573EA7E;
	Wed, 10 Jan 2024 09:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOJhi59P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C563EA71
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 09:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704879102; x=1736415102;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/ygn6JtmrinRVkGJ8YnVjTEcwrCjm9jo5L/XJXXDOvA=;
  b=jOJhi59PknUffklDgZo9J0fh2fsrxFovfkysVnI85J17K2kRqpnbw74D
   bOzRFsIrNoGExzwkQjQGmWLASonRDtKi1olk6YA7w+936qeIc3QKu10XX
   b+F9rdFFocwPoHzAFgRhqN4cAQtlRioVKnv8p0MrRwPtbN44q+h231/bu
   YA3GuOG6AKi9sqOTTVzALKvNU4TBML58NMp/y31Xygt8YcAwYKnfqWkC2
   vSYtugsIbPG8AXvrRGbeCrJNh7GOEI9bXS+mXUf8XjaGAGONRaZyx91BN
   Z+ByEiltkzJuKUzzCKV85X2ao7906xmK8gtE26pk3FrY3xY9kn5Siap6i
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="5830132"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="5830132"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 01:31:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="785544000"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="785544000"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 01:31:32 -0800
Message-ID: <f5202ebd-6bc8-44b1-b22b-f3a033e0f283@intel.com>
Date: Wed, 10 Jan 2024 17:31:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache
 topo in CPUID[4]
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
 Robert Hoo <robert.hu@linux.intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-3-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108082727.420817-3-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2024 4:27 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
> CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
> nearest power-of-2 integer.
> 
> The nearest power-of-2 integer can be calculated by pow2ceil() or by
> using APIC ID offset (like L3 topology using 1 << die_offset [3]).
> 
> But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
> are associated with APIC ID. For example, in linux kernel, the field
> "num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID. 

And for
> another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
> matched with actual core numbers and it's calculated by:
> "(1 << (pkg_offset - core_offset)) - 1".

could you elaborate it more? what is the value of actual core numbers on 
Alder lake P? and what is the pkg_offset and core_offset?

> Therefore the offset of APIC ID should be preferred to calculate nearest
> power-of-2 integer for CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits
> 31:26]:
> 1. d/i cache is shared in a core, 1 << core_offset should be used
>     instand of "cs->nr_threads" in encode_cache_cpuid4() for

/s/instand/instead

>     CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits 25:14].
> 2. L2 cache is supposed to be shared in a core as for now, thereby
>     1 << core_offset should also be used instand of "cs->nr_threads" in

ditto

>     encode_cache_cpuid4() for CPUID.04H.02H:EAX[bits 25:14].
> 3. Similarly, the value for CPUID.04H:EAX[bits 31:26] should also be
>     calculated with the bit width between the Package and SMT levels in
>     the APIC ID (1 << (pkg_offset - core_offset) - 1).
> 
> In addition, use APIC ID offset to replace "pow2ceil()" for
> cache_info_passthrough case.
> 
> [1]: efb3934adf9e ("x86: cpu: make sure number of addressable IDs for processor cores meets the spec")
> [2]: d7caf13b5fcf ("x86: cpu: fixup number of addressable IDs for logical processors sharing cache")
> [3]: d65af288a84d ("i386: Update new x86_apicid parsing rules with die_offset support")
> 
> Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
> Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v3:
>   * Fix compile warnings. (Babu)
>   * Fix spelling typo.
> 
> Changes since v1:
>   * Use APIC ID offset to replace "pow2ceil()" for cache_info_passthrough
>     case. (Yanan)
>   * Split the L1 cache fix into a separate patch.
>   * Rename the title of this patch (the original is "i386/cpu: Fix number
>     of addressable IDs in CPUID.04H").
> ---
>   target/i386/cpu.c | 30 +++++++++++++++++++++++-------
>   1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 5a3678a789cf..c8d2a585723a 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6014,7 +6014,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>   {
>       X86CPU *cpu = env_archcpu(env);
>       CPUState *cs = env_cpu(env);
> -    uint32_t die_offset;
>       uint32_t limit;
>       uint32_t signature[3];
>       X86CPUTopoInfo topo_info;
> @@ -6098,39 +6097,56 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
>                   int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
>                   if (cs->nr_cores > 1) {
> +                    int addressable_cores_offset =
> +                                                apicid_pkg_offset(&topo_info) -
> +                                                apicid_core_offset(&topo_info);
> +
>                       *eax &= ~0xFC000000;
> -                    *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
> +                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;

it should be ((1 << addressable_cores_offset) - 1) << 26

I think naming it addressable_cores_width is better than 
addressable_cores_offset. It's not offset because offset means the bit 
position from bit 0.

And we can get the width by another algorithm:

int addressable_cores_width = apicid_core_width(&topo_info) + 
apicid_die_width(&topo_info);
*eax |= ((1 << addressable_cores_width) - 1)) << 26;
		
>                   }
>                   if (host_vcpus_per_cache > vcpus_per_socket) {
> +                    int pkg_offset = apicid_pkg_offset(&topo_info);
> +
>                       *eax &= ~0x3FFC000;
> -                    *eax |= (pow2ceil(vcpus_per_socket) - 1) << 14;
> +                    *eax |= (1 << (pkg_offset - 1)) << 14;

Ditto, ((1 << pkg_offset) - 1) << 14

For this one, I think pow2ceil(vcpus_per_socket) is better. Because it's 
intuitive that when host_vcpus_per_cache > vcpus_per_socket, we expose 
vcpus_per_cache (configured by users) to VM.

>                   }
>               }
>           } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
>               *eax = *ebx = *ecx = *edx = 0;
>           } else {
>               *eax = 0;
> +            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
> +                                           apicid_core_offset(&topo_info);
> +            int core_offset, die_offset;
> +
>               switch (count) {
>               case 0: /* L1 dcache info */
> +                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
> -                                    cs->nr_threads, cs->nr_cores,
> +                                    (1 << core_offset),
> +                                    (1 << addressable_cores_offset),
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 1: /* L1 icache info */
> +                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
> -                                    cs->nr_threads, cs->nr_cores,
> +                                    (1 << core_offset),
> +                                    (1 << addressable_cores_offset),
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 2: /* L2 cache info */
> +                core_offset = apicid_core_offset(&topo_info);
>                   encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
> -                                    cs->nr_threads, cs->nr_cores,
> +                                    (1 << core_offset),
> +                                    (1 << addressable_cores_offset),
>                                       eax, ebx, ecx, edx);
>                   break;
>               case 3: /* L3 cache info */
>                   die_offset = apicid_die_offset(&topo_info);
>                   if (cpu->enable_l3_cache) {
>                       encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
> -                                        (1 << die_offset), cs->nr_cores,
> +                                        (1 << die_offset),
> +                                        (1 << addressable_cores_offset),
>                                           eax, ebx, ecx, edx);
>                       break;
>                   }


