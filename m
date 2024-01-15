Return-Path: <kvm+bounces-6186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B4C82D3A3
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 05:28:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD7021F2134B
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 04:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39575233;
	Mon, 15 Jan 2024 04:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhrpuhqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC0A46A1
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 04:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705292871; x=1736828871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ADNYX0sXyhJEQBPOP1j26AhT59aSb/3DLJMQn2Rse24=;
  b=UhrpuhqZNrlMlEqa4Uab9D5bYng6ZE/UF29wPlWeT/HT3uuaASN3Z9Fh
   xz8cO25yh5R0db1cvAor3yTyYy3lvuDvigbEil8iYkHJmw5La2rk0UCWj
   +BLRZRbqAGgWRkxFbRawk4wFb7V1GNXDD6+/hnztL6jyxiM8vE+tvxvKT
   ve3sbuAKQJl/dT9pQkaA14CgZfwVIejNH/oGK3wPgb3dB0NL1RdNTXYV+
   pItEGLvMSynwFD/wH482dvo8owrpf14+QhMHoOOd1WtZu8wndtCxkk9De
   rI9qYxy8T/SN51TFMu6/23rYHRDihjCV11s+aDlJhPaKJWA2rvbR4EwRC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="6245811"
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="6245811"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 20:27:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,195,1695711600"; 
   d="scan'208";a="25666142"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.22.149]) ([10.93.22.149])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2024 20:27:46 -0800
Message-ID: <23c5eb57-d086-4e51-bfdf-a3019aad1c29@intel.com>
Date: Mon, 15 Jan 2024 12:27:43 +0800
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
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
 <20240108082727.420817-16-zhao1.liu@linux.intel.com>
 <599ddf2d-dc2e-4684-b2c2-ba6dfd886f32@intel.com> <ZaSrKB3y9TEJZG5T@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZaSrKB3y9TEJZG5T@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/2024 11:48 AM, Zhao Liu wrote:
> Hi Xiaoyao,
> 
> On Sun, Jan 14, 2024 at 10:42:41PM +0800, Xiaoyao Li wrote:
>> Date: Sun, 14 Jan 2024 22:42:41 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v7 15/16] i386: Use offsets get NumSharingCache for
>>   CPUID[0x8000001D].EAX[bits 25:14]
>>
>> On 1/8/2024 4:27 PM, Zhao Liu wrote:
>>> From: Zhao Liu <zhao1.liu@intel.com>
>>>
>>> The commit 8f4202fb1080 ("i386: Populate AMD Processor Cache Information
>>> for cpuid 0x8000001D") adds the cache topology for AMD CPU by encoding
>>> the number of sharing threads directly.
>>>
>>>   From AMD's APM, NumSharingCache (CPUID[0x8000001D].EAX[bits 25:14])
>>> means [1]:
>>>
>>> The number of logical processors sharing this cache is the value of
>>> this field incremented by 1. To determine which logical processors are
>>> sharing a cache, determine a Share Id for each processor as follows:
>>>
>>> ShareId = LocalApicId >> log2(NumSharingCache+1)
>>>
>>> Logical processors with the same ShareId then share a cache. If
>>> NumSharingCache+1 is not a power of two, round it up to the next power
>>> of two.
>>>
>>>   From the description above, the calculation of this field should be same
>>> as CPUID[4].EAX[bits 25:14] for Intel CPUs. So also use the offsets of
>>> APIC ID to calculate this field.
>>>
>>> [1]: APM, vol.3, appendix.E.4.15 Function 8000_001Dh--Cache Topology
>>>        Information
>>
>> this patch can be dropped because we have next patch.
> 
> This patch is mainly used to explicitly emphasize the change in encoding
> way and compliance with AMD spec... I didn't tested on AMD machine, so
> the more granular patch would make it easier for the community to review
> and test.

then please move this patch ahead, e.g., after patch 2.

> Thanks,
> Zhao
> 
>>
>>> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>>> Reviewed-by: Babu Moger <babu.moger@amd.com>
>>> Tested-by: Babu Moger <babu.moger@amd.com>
>>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>> Changes since v3:
>>>    * Rewrite the subject. (Babu)
>>>    * Delete the original "comment/help" expression, as this behavior is
>>>      confirmed for AMD CPUs. (Babu)
>>>    * Rename "num_apic_ids" (v3) to "num_sharing_cache" to match spec
>>>      definition. (Babu)
>>>
>>> Changes since v1:
>>>    * Rename "l3_threads" to "num_apic_ids" in
>>>      encode_cache_cpuid8000001d(). (Yanan)
>>>    * Add the description of the original commit and add Cc.
>>> ---
>>>    target/i386/cpu.c | 10 ++++------
>>>    1 file changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index b23e8190dc68..8a4d72f6f760 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -483,7 +483,7 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>>>                                           uint32_t *eax, uint32_t *ebx,
>>>                                           uint32_t *ecx, uint32_t *edx)
>>>    {
>>> -    uint32_t l3_threads;
>>> +    uint32_t num_sharing_cache;
>>>        assert(cache->size == cache->line_size * cache->associativity *
>>>                              cache->partitions * cache->sets);
>>> @@ -492,13 +492,11 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
>>>        /* L3 is shared among multiple cores */
>>>        if (cache->level == 3) {
>>> -        l3_threads = topo_info->modules_per_die *
>>> -                     topo_info->cores_per_module *
>>> -                     topo_info->threads_per_core;
>>> -        *eax |= (l3_threads - 1) << 14;
>>> +        num_sharing_cache = 1 << apicid_die_offset(topo_info);
>>>        } else {
>>> -        *eax |= ((topo_info->threads_per_core - 1) << 14);
>>> +        num_sharing_cache = 1 << apicid_core_offset(topo_info);
>>>        }
>>> +    *eax |= (num_sharing_cache - 1) << 14;
>>>        assert(cache->line_size > 0);
>>>        assert(cache->partitions > 0);
>>


