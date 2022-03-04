Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B824CD4A6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 14:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiCDNEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 08:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiCDNEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 08:04:07 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9586D382;
        Fri,  4 Mar 2022 05:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646399000; x=1677935000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QzqtvEulxxy6jWYbqOKMhoYEWwiQo5TigvzNtH1HySw=;
  b=T/AyPUVsT8O2ayKvs8eLTnarYctNGISq0swFIL2/Sb0T3Z/Mnpo+a5ey
   K9lTCHUnj4/QHA1b21Im2ToI/mcOGlbLorB/4ZtHTKaXhoAFcZyP6Ok66
   gKxo5XFHuZmEGese5Mcvn+3nlIVJ7w/QzGoG1ofsS/F8H16YjcioEKsH3
   fjZHSmrHb4bxWYKwkth/6VKdBQq5MDAkGkGHdrAGEv3r5K7olHgGS9m1K
   sqPUosaszIFlCe3U/OokmOuyIQxVjZ9cK1rMuMe2yjPSe6Pd4lBdU5sIj
   pzjiMS4scq5xP3ri7KAqC9PiTKqN33uysSklvy3D8dbvDrK8rH5lD32zI
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="253902544"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="253902544"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 05:03:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="609938671"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by fmsmga004.fm.intel.com with ESMTP; 04 Mar 2022 05:03:14 -0800
Message-ID: <6c089aeb-7111-f869-02d1-7e7a1bf56b6b@intel.com>
Date:   Fri, 4 Mar 2022 15:03:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event
 clock
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-3-adrian.hunter@intel.com>
 <YiIGbbyx0uimsGN4@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YiIGbbyx0uimsGN4@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/2022 14:30, Peter Zijlstra wrote:
> On Mon, Feb 14, 2022 at 01:09:05PM +0200, Adrian Hunter wrote:
>> Currently, using Intel PT to trace a VM guest is limited to kernel space
>> because decoding requires side band events such as MMAP and CONTEXT_SWITCH.
>> While these events can be collected for the host, there is not a way to do
>> that yet for a guest. One approach, would be to collect them inside the
>> guest, but that would require being able to synchronize with host
>> timestamps.
>>
>> The motivation for this patch is to provide a clock that can be used within
>> a VM guest, and that correlates to a VM host clock. In the case of TSC, if
>> the hypervisor leaves rdtsc alone, the TSC value will be subject only to
>> the VMCS TSC Offset and Scaling. Adjusting for that would make it possible
>> to inject events from a guest perf.data file, into a host perf.data file.
>>
>> Thus making possible the collection of VM guest side band for Intel PT
>> decoding.
>>
>> There are other potential benefits of TSC as a perf event clock:
>> 	- ability to work directly with TSC
>> 	- ability to inject non-Intel-PT-related events from a guest
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  arch/x86/events/core.c            | 16 +++++++++
>>  arch/x86/include/asm/perf_event.h |  3 ++
>>  include/uapi/linux/perf_event.h   | 12 ++++++-
>>  kernel/events/core.c              | 57 +++++++++++++++++++------------
>>  4 files changed, 65 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index e686c5e0537b..51d5345de30a 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -2728,6 +2728,17 @@ void arch_perf_update_userpage(struct perf_event *event,
>>  		!!(event->hw.flags & PERF_EVENT_FLAG_USER_READ_CNT);
>>  	userpg->pmc_width = x86_pmu.cntval_bits;
>>  
>> +	if (event->attr.use_clockid &&
>> +	    event->attr.ns_clockid &&
>> +	    event->attr.clockid == CLOCK_PERF_HW_CLOCK) {
>> +		userpg->cap_user_time_zero = 1;
>> +		userpg->time_mult = 1;
>> +		userpg->time_shift = 0;
>> +		userpg->time_offset = 0;
>> +		userpg->time_zero = 0;
>> +		return;
>> +	}
>> +
>>  	if (!using_native_sched_clock() || !sched_clock_stable())
>>  		return;
> 
> This looks the wrong way around. If TSC is found unstable, we should
> never expose it.

Intel PT traces contain TSC whether or not it is stable, and it could
still be usable in some cases e.g. short traces on a single CPU.

Ftrace seems to offer x86-tsc unconditionally as a clock.

We could add warnings to comments and documentation about its potential
pitfalls.

> 
> And I'm not at all sure about the whole virt thing. Last time I looked
> at pvclock it made no sense at all.

It is certainly not useful for synchronizing events against TSC.
