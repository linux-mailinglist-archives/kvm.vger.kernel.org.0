Return-Path: <kvm+bounces-11445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C41877171
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 14:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6C71F21658
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 13:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A0D40852;
	Sat,  9 Mar 2024 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NlGjy4uy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BE13F9DB
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709991675; cv=none; b=kkOw0AIBEgD5ezGB1mhC+H03Q5QGbsvdCJ3C6B5sopJ894ZqfLsnszjrLifTVtu3CSEQf9WkweaAfv7okscMfkwvIooLozRQY2YcFBOcnxvGzTFC1od0Z4sm1QojwaJsIdDy+CIxuXa0P5V9L5W8Gq5wXcj6+Wt+CKxGwHDJL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709991675; c=relaxed/simple;
	bh=9R801M/RKXLR9NN8MIzCPaJSfWkUAq02qrdBXSRAmWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NyvFENNF2jbKHA3LyK1pYASjxVYiqeBqFtcrPGI5leRyl/bm9In0COFPJsUlQiI5fi0bKsNCvntSpKKUYr2+mz9DO3q/Xm87NDv/Rg+3xYfcMDu0ahY+K8Gk2W+dbm4hazn2CYiDqRK3v8IkmKjachKJ2d3sMjA1r2ANWv691Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NlGjy4uy; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709991672; x=1741527672;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9R801M/RKXLR9NN8MIzCPaJSfWkUAq02qrdBXSRAmWc=;
  b=NlGjy4uybXxJsmhnJVbKJkwEjkLn6XO4Id//VtyQ1LJezHs1OoU/Wwcp
   cXVIgtyn/Pn2DQ2Wdl+/j8ZGgXAdeLztocFQ9vjN8xs3LOxE8/u2X3Bjq
   jPgzTGvu/rAU0KOE+KjAntosd8bhQ+bjPmKmajic4fcHjmyR4OIX0kZJ0
   gG8RaYjJFVMyNM94k9hxxQGlG80cgVAh+a5I997QwQMbEv+WqlcXV0Dat
   Gh2JAayGsS8+3z0T2ObjY1czb0kd/lS+tikddrWkwPju2wGIekNJpN36o
   gZMT+gb2cwxkFeHWhDlqNnMjSZrN0cpChFLXP3q8F+JVNIuQ5ZKfUmsQ+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="8524672"
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="8524672"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 05:41:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,112,1708416000"; 
   d="scan'208";a="15432603"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2024 05:41:06 -0800
Message-ID: <85cb99a6-dc91-4e62-aa7f-341280d5928d@intel.com>
Date: Sat, 9 Mar 2024 21:41:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/21] i386/cpu: Use APIC ID info get NumSharingCache
 for CPUID[0x8000001D].EAX[bits 25:14]
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
 <20240227103231.1556302-8-zhao1.liu@linux.intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240227103231.1556302-8-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/2024 6:32 PM, Zhao Liu wrote:
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
> 
> Cc: Babu Moger <babu.moger@amd.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> Changes since v7:
>   * Moved this patch after CPUID[4]'s similar change ("i386/cpu: Use APIC
>     ID offset to encode cache topo in CPUID[4]"). (Xiaoyao)
>   * Dropped Michael/Babu's Acked/Reviewed/Tested tags since the code
>     change due to the rebase.
>   * Re-added Yongwei's Tested tag For his re-testing (compilation on
>     Intel platforms).
> 
> Changes since v3:
>   * Rewrote the subject. (Babu)
>   * Deleted the original "comment/help" expression, as this behavior is
>     confirmed for AMD CPUs. (Babu)
>   * Renamed "num_apic_ids" (v3) to "num_sharing_cache" to match spec
>     definition. (Babu)
> 
> Changes since v1:
>   * Renamed "l3_threads" to "num_apic_ids" in
>     encode_cache_cpuid8000001d(). (Yanan)
>   * Added the description of the original commit and add Cc.
> ---
>   target/i386/cpu.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c77bcbc44d59..df56c7a449c8 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -331,7 +331,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>                                          uint32_t *eax, uint32_t *ebx,
>                                          uint32_t *ecx, uint32_t *edx)
>   {
> -    uint32_t l3_threads;
> +    uint32_t num_sharing_cache;
>       assert(cache->size == cache->line_size * cache->associativity *
>                             cache->partitions * cache->sets);
>   
> @@ -340,11 +340,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>   
>       /* L3 is shared among multiple cores */
>       if (cache->level == 3) {
> -        l3_threads = topo_info->cores_per_die * topo_info->threads_per_core;
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


