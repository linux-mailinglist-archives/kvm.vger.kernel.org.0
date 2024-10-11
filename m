Return-Path: <kvm+bounces-28626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F14D99A4AA
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D24222853B4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F102185B1;
	Fri, 11 Oct 2024 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CaNuG/Zo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D79D1E502;
	Fri, 11 Oct 2024 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652624; cv=none; b=ehdvjABZFZhxUVSpTywP8jiWWAopxcoOCI3nuTW/4y46dT1S1AETXM5xv1SJzkU/INC+zrmdSUd7V4kriWDrvqbBloWrMNZxG04gHQGP3FtrzXy0QVaOljJOYmXT8KFio6Cj87g2Xj4tGLc8sDpzWUHNKEq2vIzMHIsN3PQ2BYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652624; c=relaxed/simple;
	bh=XVUvhcUEfu4AMjzxw8BFxUUHR+h2R9zbvpPCsjl4N+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HeHhr8q9tBwI6VnHt9UYULnrjaSdG/rO4SwWgv7KSljoNJtpobTJkUB8FFQlVIRlpeVnF6T7JvYV/ajaSASEJb73u2mbajOVSlyBcvxPUUEZ7nBif50axLMObJ3Xjc+3FxyRnstDpyBYKAnI/NZmbCxwHQ6a73Syxpz/Y4kLghY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CaNuG/Zo; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728652623; x=1760188623;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XVUvhcUEfu4AMjzxw8BFxUUHR+h2R9zbvpPCsjl4N+w=;
  b=CaNuG/Zo4Yzlu1yZ6VMtzKe2QX7n0E1iuQaYXpJ4ONClJKVOrrJfkXnY
   rl5cntfsJF6WJEzsfLLWBuvhbRp0PVVEqyjfn1C5J0EJEZmbGSjyJXAsu
   CR7gyrluBS5yuK6CuGgv2gyX7e7AHAFV4SvYX8dbPEj3zgXjrle7D9jbl
   siRAvPixa/mcLLvwUYALYSGcnP78LjHfbphQ4TUEP4/NIA57V26E816PO
   bs/+vNVm9cRGGHCwWG8VXTPXrfSfparAT99mxYZV/HLcbATlZNqTLDgnE
   BZm1NqQcBQFFFQ0JO0OHQkyqZ/8qCIP0S037tiSFGvx0vkFQVm2Msk9Pg
   w==;
X-CSE-ConnectionGUID: ZuE8alATQSadyG1ZmG3gRQ==
X-CSE-MsgGUID: dUHNquwXRC2nJez5rgurXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="39180104"
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="39180104"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 06:17:02 -0700
X-CSE-ConnectionGUID: xEFJjv3CS7WsFRJaKJh3PA==
X-CSE-MsgGUID: g0ZslaxFQrGVB9iJBzMJ/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="81734237"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 06:17:02 -0700
Received: from [10.212.124.153] (kliang2-mobl1.ccr.corp.intel.com [10.212.124.153])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 2E0CB20B5782;
	Fri, 11 Oct 2024 06:16:59 -0700 (PDT)
Message-ID: <f06468d9-3f9d-4ced-a523-c78e6c4a7a90@linux.intel.com>
Date: Fri, 11 Oct 2024 09:16:57 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
To: Peter Zijlstra <peterz@infradead.org>,
 "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <095522b1-faad-4544-9282-4dda8be03695@linux.intel.com>
 <20241011114150.GO14587@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241011114150.GO14587@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-10-11 7:41 a.m., Peter Zijlstra wrote:
> On Wed, Aug 21, 2024 at 01:27:17PM +0800, Mi, Dapeng wrote:
>> On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> 
>>> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
>>> +					    struct perf_time_ctx *time,
>>> +					    struct perf_time_ctx *timeguest,
>>> +					    u64 now)
>>> +{
>>> +	/*
>>> +	 * The exclude_guest event time should be calculated from
>>> +	 * the ctx time -  the guest time.
>>> +	 * The ctx time is now + READ_ONCE(time->offset).
>>> +	 * The guest time is now + READ_ONCE(timeguest->offset).
>>> +	 * So the exclude_guest time is
>>> +	 * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
>>> +	 */
>>> +	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
>>
>> Hi Kan,
>>
>> we see the following the warning when run perf record command after
>> enabling "CONFIG_DEBUG_PREEMPT" config item.
>>
>> [  166.779208] BUG: using __this_cpu_read() in preemptible [00000000] code:
>> perf/9494
>> [  166.779234] caller is __this_cpu_preempt_check+0x13/0x20
>> [  166.779241] CPU: 56 UID: 0 PID: 9494 Comm: perf Not tainted
>> 6.11.0-rc4-perf-next-mediated-vpmu-v3+ #80
>> [  166.779245] Hardware name: Quanta Cloud Technology Inc. QuantaGrid
>> D54Q-2U/S6Q-MB-MPS, BIOS 3A11.uh 12/02/2022
>> [  166.779248] Call Trace:
>> [  166.779250]  <TASK>
>> [  166.779252]  dump_stack_lvl+0x76/0xa0
>> [  166.779260]  dump_stack+0x10/0x20
>> [  166.779267]  check_preemption_disabled+0xd7/0xf0
>> [  166.779273]  __this_cpu_preempt_check+0x13/0x20
>> [  166.779279]  calc_timer_values+0x193/0x200
>> [  166.779287]  perf_event_update_userpage+0x4b/0x170
>> [  166.779294]  ? ring_buffer_attach+0x14c/0x200
>> [  166.779301]  perf_mmap+0x533/0x5d0
>> [  166.779309]  mmap_region+0x243/0xaa0
>> [  166.779322]  do_mmap+0x35b/0x640
>> [  166.779333]  vm_mmap_pgoff+0xf0/0x1c0
>> [  166.779345]  ksys_mmap_pgoff+0x17a/0x250
>> [  166.779354]  __x64_sys_mmap+0x33/0x70
>> [  166.779362]  x64_sys_call+0x1fa4/0x25f0
>> [  166.779369]  do_syscall_64+0x70/0x130
>>
>> The season that kernel complains this is __perf_event_time_ctx_now() calls
>> __this_cpu_read() in preemption enabled context.
>>
>> To eliminate the warning, we may need to use this_cpu_read() to replace
>> __this_cpu_read().
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index ccd61fd06e8d..1eb628f8b3a0 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -1581,7 +1581,7 @@ static inline u64 __perf_event_time_ctx_now(struct
>> perf_event *event,
>>          * So the exclude_guest time is
>>          * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
>>          */
>> -       if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
>> +       if (event->attr.exclude_guest && this_cpu_read(perf_in_guest))
>>                 return READ_ONCE(time->offset) - READ_ONCE(timeguest->offset);
>>         else
>>                 return now + READ_ONCE(time->offset);
> 
> The saner fix is moving the preempt_disable() in
> perf_event_update_userpage() up a few lines, no?

Yes, the preempt_disable() is to guarantee consistent time stamps. It
makes sense to include the time calculation part in the preempt_disable().

Since the time-related code was updated recently, I will fold all the
suggestions into the newly re-based code.

Thanks,
Kan


