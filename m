Return-Path: <kvm+bounces-6172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 946D582D0F8
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 15:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7443D1C20BAC
	for <lists+kvm@lfdr.de>; Sun, 14 Jan 2024 14:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A9423CA;
	Sun, 14 Jan 2024 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QHumuefl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BFD7E
	for <kvm@vger.kernel.org>; Sun, 14 Jan 2024 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705243369; x=1736779369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gKAH/bj/4KLPDvKzUW3tzCCJvLFNjJ2nNWsjeglu8so=;
  b=QHumueflalE/HIgxXo5KW+W0mh4hU+Z1D8oz2OAzjmIEIultCABLcOkn
   EZiKuhabtCti6PSOiVQ8rleOsGDNyycRcbip5BF4q8kVEuMbAywHWrsNr
   CEkFpZxPS3DYfMvVW/TWDHxyLuVQsyL4WwPmMw4zb4xxxGO/w6X1rp+RL
   3Ktqr9Rh+wbvLjTzAE4HfO15SfmZMcZ7X709G8noqXpes7quPPpzV0jWc
   Gt8hRmXzpmnnw9x1I3b6yTOE0ShLwzYe7XYj7enhBjJUfXuEYK9crwPDq
   eFaQqILahgh69UB9U9UHyR1f0sISag27jio3EMWoVfYne/UPEPyDporN6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="18069597"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="18069597"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 06:42:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="926882205"
X-IronPort-AV: E=Sophos;i="6.04,194,1695711600"; 
   d="scan'208";a="926882205"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 06:42:44 -0800
Message-ID: <599ddf2d-dc2e-4684-b2c2-ba6dfd886f32@intel.com>
Date: Sun, 14 Jan 2024 22:42:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/16] i386: Use offsets get NumSharingCache for
 CPUID[0x8000001D].EAX[bits 25:14]
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
 <20240108082727.420817-16-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240108082727.420817-16-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/2024 4:27 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
> for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
> the number of sharing threads directly.
> 
>  From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
> means [1]:
> 
> The number of logical processors sharing this cache is the value of
> this field incremented by 1. To determine which logical processors are
> sharing a cache, determine a Share Id for each processor as follows:
> 
> ShareId = LocalApicId >> log2(NumSharingCache+1)
> 
> Logical processors with the same ShareId then share a cache. If
> NumSharingCache+1 is not a power of two, round it up to the next power
> of two.
> 
>  From the description above, the calculation of this field should be same
> as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
> APIC ID to calculate this field.
> 
> [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
>       Information

this patch can be dropped because we have next patch.

> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> Changes since v3:
>   * Rewrite the subject. (Babu)
>   * Delete the original "comment/help" expression, as this behavior is
>     confirmed for AMD CPUs. (Babu)
>   * Rename "num_apic_ids" (v3) to "num_sharing_cache" to match spec
>     definition. (Babu)
> 
> Changes since v1:
>   * Rename "l3_threads" to "num_apic_ids" in
>     encode_cache_cpuid8000001d(). (Yanan)
>   * Add the description of the original commit and add Cc.
> ---
>   target/i386/cpu.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index b23e8190dc68..8a4d72f6f760 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -483,7 +483,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>                                          uint32_t *eax, uint32_t *ebx,
>                                          uint32_t *ecx, uint32_t *edx)
>   {
> -    uint32_t l3_threads;
> +    uint32_t num_sharing_cache;
>       assert(cache->size == cache->line_size * cache->associativity *
>                             cache->partitions * cache->sets);
>   
> @@ -492,13 +492,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>   
>       /* L3 is shared among multiple cores */
>       if (cache->level == 3) {
> -        l3_threads = topo_info->modules_per_die *
> -                     topo_info->cores_per_module *
> -                     topo_info->threads_per_core;
> -        *eax |= (l3_threads - 1) << 14;
> +        num_sharing_cache = 1 << apicid_die_offset(topo_info);
>       } else {
> -        *eax |= ((topo_info->threads_per_core - 1) << 14);
> +        num_sharing_cache = 1 << apicid_core_offset(topo_info);
>       }
> +    *eax |= (num_sharing_cache - 1) << 14;
>   
>       assert(cache->line_size > 0);
>       assert(cache->partitions > 0);


