Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034365E6B26
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiIVSml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIVSmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:42:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D4DCE89;
        Thu, 22 Sep 2022 11:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663872158; x=1695408158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JMwydWYZn7z86BpUMx/qytT3+s91mayLwEtnzlfgdiw=;
  b=AxZOK+kdnJ8iAfRNhJ5voJgeW3qJnioWz0FIzqAMGZums03c3rxnjYoQ
   XVGzhkMH7NF9FxEPbFqZE1i38F/gNQpVGQKBhsMj2TrTyuIPPnUCA4IhD
   PmwkaDVc2ce8xmq8lOGVtmFeDrbEkFatiV5JiUPj5VcLzoWMeqcFGzhDo
   Ptp2pN3Mt+Ld4qy1cuhV9Rq9CivefdplZqh7VbsMdC1E3FEKKXqd3NuxR
   MrgtZhrVnVt1ou9vlozrF9Oh4HEiHLgS+TZdDbvq54cHRioC4gHDnRQt8
   /29PgCR0qYzzLnT1QAnN7QrIwnWATH6uDTbvxSJdlZR6qA/NAxGVdmneX
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326720063"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326720063"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:42:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="615325567"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 22 Sep 2022 11:42:23 -0700
Received: from [10.252.210.171] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id C26AA580AD7;
        Thu, 22 Sep 2022 11:42:21 -0700 (PDT)
Message-ID: <06962580-e052-e058-eb08-6732e633241e@linux.intel.com>
Date:   Thu, 22 Sep 2022 14:42:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH RFC 1/1] perf stat: do not fatal if the leader is errored
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, joe.jin@oracle.com,
        linux-perf-users@vger.kernel.org, kvm list <kvm@vger.kernel.org>
References: <20220922071017.17398-1-dongli.zhang@oracle.com>
 <ad2572d0-06b5-7250-31f2-a5efa1048cc0@gmail.com>
 <27cb9747-8911-b3cc-25d9-9438521db832@linux.intel.com>
 <d03d8a07-a05a-f03e-189d-a07c6aecbb8a@oracle.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <d03d8a07-a05a-f03e-189d-a07c6aecbb8a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-22 2:00 p.m., Dongli Zhang wrote:
> Hi Kan,
> 
> I have tested that the patch works by hiding 'slots' sysfs entries.
> 
> # ll /sys/bus/event_source/devices/cpu/events/
> total 0
> -r--r--r--. 1 root root 4096 Sep 22 17:57 branch-instructions
> -r--r--r--. 1 root root 4096 Sep 22 17:57 branch-misses
> -r--r--r--. 1 root root 4096 Sep 22 17:57 bus-cycles
> -r--r--r--. 1 root root 4096 Sep 22 17:57 cache-misses
> -r--r--r--. 1 root root 4096 Sep 22 17:57 cache-references
> -r--r--r--. 1 root root 4096 Sep 22 17:57 cpu-cycles
> -r--r--r--. 1 root root 4096 Sep 22 17:57 instructions
> -r--r--r--. 1 root root 4096 Sep 22 17:57 ref-cycles
> 
> # perf stat
> ^C
>  Performance counter stats for 'system wide':
> 
>          19,256.20 msec cpu-clock                        #   16.025 CPUs
> utilized
>                179      context-switches                 #    9.296 /sec
> 
>                 17      cpu-migrations                   #    0.883 /sec
> 
>                  3      page-faults                      #    0.156 /sec
> 
>          7,502,294      cycles                           #    0.000 GHz
> 
>          2,512,587      instructions                     #    0.33  insn per
> cycle
>            552,989      branches                         #   28.717 K/sec
> 
>             15,999      branch-misses                    #    2.89% of all
> branches
> 
>        1.201628129 seconds time elapsed
> 
> 
> Would you send this patch to fix at the kernel side?

Yes, I will send it out shortly.


Thanks,
Kan
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> On 9/22/22 6:34 AM, Liang, Kan wrote:
>>
>>
>> On 2022-09-22 4:07 a.m., Like Xu wrote:
>>> On 22/9/2022 3:10 pm, Dongli Zhang wrote:
>>>> There are three options to fix the issue.
>>>>
>>>> 1. Do not expose /sys/bus/event_source/devices/cpu/events/slots to
>>>> userspace so that pmu_have_event(pmu->name, "slots") returns false.
>>>
>>> IMO, the guest PMU driver should be fixed
>>> since it misrepresents emulated hardware capabilities in terms of slots.
>>
>> Yes, we need to fix the kernel to hide the slots event if it's not
>> available.
>>
>> The patch as below should fix it. (Not tested yet)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index b20e646c8205..27ee43faba32 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -5565,6 +5565,19 @@ static struct attribute *intel_pmu_attrs[] = {
>>  	NULL,
>>  };
>>
>> +static umode_t
>> +td_is_visible(struct kobject *kobj, struct attribute *attr, int i)
>> +{
>> +	/*
>> +	 * Hide the perf metrics topdown events
>> +	 * if the slots is not in CPUID.
>> +	 */
>> +	if (x86_pmu.num_topdown_events)
>> +		return (x86_pmu.intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
>> +
>> +	return attr->mode;
>> +}
>> +
>>  static umode_t
>>  tsx_is_visible(struct kobject *kobj, struct attribute *attr, int i)
>>  {
>> @@ -5600,6 +5613,7 @@ default_is_visible(struct kobject *kobj, struct
>> attribute *attr, int i)
>>
>>  static struct attribute_group group_events_td  = {
>>  	.name = "events",
>> +	.is_visible = td_is_visible,
>>  };
>>
>>  static struct attribute_group group_events_mem = {
>> @@ -5758,6 +5772,23 @@ static inline int
>> hybrid_find_supported_cpu(struct x86_hybrid_pmu *pmu)
>>  	return (cpu >= nr_cpu_ids) ? -1 : cpu;
>>  }
>>
>> +static umode_t hybrid_td_is_visible(struct kobject *kobj,
>> +					struct attribute *attr, int i)
>> +{
>> +	struct device *dev = kobj_to_dev(kobj);
>> +	struct x86_hybrid_pmu *pmu =
>> +		 container_of(dev_get_drvdata(dev), struct x86_hybrid_pmu, pmu);
>> +
>> +	if (!is_attr_for_this_pmu(kobj, attr))
>> +		return 0;
>> +
>> +	/* Only check the big core which supports perf metrics */
>> +	if (pmu->cpu_type == hybrid_big)
>> +		return (pmu->intel_ctrl & INTEL_PMC_MSK_FIXED_SLOTS) ? attr->mode : 0;
>> +
>> +	return attr->mode;
>> +}
>> +
>>  static umode_t hybrid_tsx_is_visible(struct kobject *kobj,
>>  				     struct attribute *attr, int i)
>>  {
>> @@ -5784,7 +5815,7 @@ static umode_t hybrid_format_is_visible(struct
>> kobject *kobj,
>>
>>  static struct attribute_group hybrid_group_events_td  = {
>>  	.name		= "events",
>> -	.is_visible	= hybrid_events_is_visible,
>> +	.is_visible	= hybrid_td_is_visible,
>>  };
>>
>>  static struct attribute_group hybrid_group_events_mem = {
>>
>>
>> Thanks,
>> Kan
>>
