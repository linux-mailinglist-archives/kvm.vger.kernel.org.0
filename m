Return-Path: <kvm+bounces-5993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B358299DB
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 12:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E2BCB20C67
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 11:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F46348CD1;
	Wed, 10 Jan 2024 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RFqGoNKG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1748CC6
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704887567; x=1736423567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PpTniVRf/mUrjDL1i7K82KKY0DYSCGANpu49oItuHkE=;
  b=RFqGoNKGG881uyi5XNT7Sm6Ri51Qc/cRse9IacF6Qo9a+fgRBHGP7ChB
   yC3S39otAKow68HQ7lC1h9V5VMaQw/qwZ+ndvQOvXKaWheEQJuclGDNQj
   BJTT+C2neHDsdYa9H/K7/JkZN1erisuB3L1FL04fOJp/9BOPhYLvEdZ7Q
   hggR9dYHYnGh78sN0EwJdhYwTOKmq8ES9xQgTezMHMvKmf0N38qLGq1lC
   Bf9iOgZ+ijwEDb4rhSs07dKwEbSp/ImRcaH1juZByl3sIQ60IdytlFq4Z
   zEqfkaDWlMDZ15SuGUO5wKKKQzUPK+OcwXhGpg6rN6DDBuqkak8zhr/Dv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10948"; a="11977273"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="11977273"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 03:52:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10948"; a="905505974"
X-IronPort-AV: E=Sophos;i="6.04,184,1695711600"; 
   d="scan'208";a="905505974"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2024 03:52:41 -0800
Message-ID: <ddb911d0-6054-43ab-a763-242216b9c8d9@intel.com>
Date: Wed, 10 Jan 2024 19:52:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/16] i386/cpu: Consolidate the use of topo_info in
 cpu_x86_cpuid()
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
 <20240108082727.420817-4-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108082727.420817-4-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2024 4:27 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> In cpu_x86_cpuid(), there are many variables in representing the cpu
> topology, e.g., topo_info, cs->nr_cores/cs->nr_threads.

Please use comma instead of slash. cs->nr_cores/cs->nr_threads looks 
like one variable.

> Since the names of cs->nr_cores/cs->nr_threads does not accurately
> represent its meaning, the use of cs->nr_cores/cs->nr_threads is prone
> to confusion and mistakes.
> 
> And the structure X86CPUTopoInfo names its members clearly, thus the
> variable "topo_info" should be preferred.
> 
> In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
> replace env->dies with topo_info.dies_per_pkg as well.
> 
> Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v3:
>   * Fix typo. (Babu)
> 
> Changes since v1:
>   * Extract cores_per_socket from the code block and use it as a local
>     variable for cpu_x86_cpuid(). (Yanan)
>   * Remove vcpus_per_socket variable and use cpus_per_pkg directly.
>     (Yanan)
>   * Replace env->dies with topo_info.dies_per_pkg in cpu_x86_cpuid().
> ---
>   target/i386/cpu.c | 31 ++++++++++++++++++-------------
>   1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c8d2a585723a..6f8fa772ecf8 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6017,11 +6017,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>       uint32_t limit;
>       uint32_t signature[3];
>       X86CPUTopoInfo topo_info;
> +    uint32_t cores_per_pkg;
> +    uint32_t cpus_per_pkg;

I prefer to lps_per_pkg or threads_per_pkg.

Other than it,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   
>       topo_info.dies_per_pkg = env->nr_dies;
>       topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
>       topo_info.threads_per_core = cs->nr_threads;
>   
> +    cores_per_pkg = topo_info.cores_per_die * topo_info.dies_per_pkg;
> +    cpus_per_pkg = cores_per_pkg * topo_info.threads_per_core;
> +
>       /* Calculate & apply limits for different index ranges */
>       if (index >= 0xC0000000) {
>           limit = env->cpuid_xlevel2;
> @@ -6057,8 +6062,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               *ecx |= CPUID_EXT_OSXSAVE;
>           }
>           *edx = env->features[FEAT_1_EDX];
> -        if (cs->nr_cores * cs->nr_threads > 1) {
> -            *ebx |= (cs->nr_cores * cs->nr_threads) << 16;
> +        if (cpus_per_pkg > 1) {
> +            *ebx |= cpus_per_pkg << 16;
>               *edx |= CPUID_HT;
>           }
>           if (!cpu->enable_pmu) {
> @@ -6095,8 +6100,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                */
>               if (*eax & 31) {
>                   int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
> -                int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
> -                if (cs->nr_cores > 1) {
> +
> +                if (cores_per_pkg > 1) {
>                       int addressable_cores_offset =
>                                                   apicid_pkg_offset(&topo_info) -
>                                                   apicid_core_offset(&topo_info);
> @@ -6104,7 +6109,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                       *eax &= ~0xFC000000;
>                       *eax |= (1 << (addressable_cores_offset - 1)) << 26;
>                   }
> -                if (host_vcpus_per_cache > vcpus_per_socket) {
> +                if (host_vcpus_per_cache > cpus_per_pkg) {
>                       int pkg_offset = apicid_pkg_offset(&topo_info);
>   
>                       *eax &= ~0x3FFC000;
> @@ -6249,12 +6254,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           switch (count) {
>           case 0:
>               *eax = apicid_core_offset(&topo_info);
> -            *ebx = cs->nr_threads;
> +            *ebx = topo_info.threads_per_core;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
>               break;
>           case 1:
>               *eax = apicid_pkg_offset(&topo_info);
> -            *ebx = cs->nr_cores * cs->nr_threads;
> +            *ebx = cpus_per_pkg;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
>               break;
>           default:
> @@ -6274,7 +6279,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           break;
>       case 0x1F:
>           /* V2 Extended Topology Enumeration Leaf */
> -        if (env->nr_dies < 2) {
> +        if (topo_info.dies_per_pkg < 2) {
>               *eax = *ebx = *ecx = *edx = 0;
>               break;
>           }
> @@ -6284,7 +6289,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>           switch (count) {
>           case 0:
>               *eax = apicid_core_offset(&topo_info);
> -            *ebx = cs->nr_threads;
> +            *ebx = topo_info.threads_per_core;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
>               break;
>           case 1:
> @@ -6294,7 +6299,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               break;
>           case 2:
>               *eax = apicid_pkg_offset(&topo_info);
> -            *ebx = cs->nr_cores * cs->nr_threads;
> +            *ebx = cpus_per_pkg;
>               *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
>               break;
>           default:
> @@ -6518,7 +6523,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>            * discards multiple thread information if it is set.
>            * So don't set it here for Intel to make Linux guests happy.
>            */
> -        if (cs->nr_cores * cs->nr_threads > 1) {
> +        if (cpus_per_pkg > 1) {
>               if (env->cpuid_vendor1 != CPUID_VENDOR_INTEL_1 ||
>                   env->cpuid_vendor2 != CPUID_VENDOR_INTEL_2 ||
>                   env->cpuid_vendor3 != CPUID_VENDOR_INTEL_3) {
> @@ -6584,7 +6589,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
>           }
>           *ebx = env->features[FEAT_8000_0008_EBX];
> -        if (cs->nr_cores * cs->nr_threads > 1) {
> +        if (cpus_per_pkg > 1) {
>               /*
>                * Bits 15:12 is "The number of bits in the initial
>                * Core::X86::Apic::ApicId[ApicId] value that indicate
> @@ -6592,7 +6597,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>                * Bits 7:0 is "The number of threads in the package is NC+1"
>                */
>               *ecx = (apicid_pkg_offset(&topo_info) << 12) |
> -                   ((cs->nr_cores * cs->nr_threads) - 1);
> +                   (cpus_per_pkg - 1);
>           } else {
>               *ecx = 0;
>           }


