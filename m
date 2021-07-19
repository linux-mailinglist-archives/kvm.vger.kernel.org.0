Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE043CCBD6
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 02:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhGSAol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jul 2021 20:44:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:31838 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhGSAok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jul 2021 20:44:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10049"; a="198235299"
X-IronPort-AV: E=Sophos;i="5.84,250,1620716400"; 
   d="scan'208";a="198235299"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2021 17:41:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,250,1620716400"; 
   d="scan'208";a="631745993"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 18 Jul 2021 17:41:38 -0700
Received: from [10.212.244.29] (kliang2-MOBL.ccr.corp.intel.com [10.212.244.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 2826F580342;
        Sun, 18 Jul 2021 17:41:36 -0700 (PDT)
Subject: Re: [PATCH V8 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     Jim Mattson <jmattson@google.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, peterz@infradead.org,
        pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        boris.ostrvsky@oracle.com
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <CALMp9eSz6RPN=spjN6zdD5iQY2ZZDwM2bHJ2R4qWijOt1A_6aw@mail.gmail.com>
 <b6568241-02e3-faf6-7507-c7ad1c4db281@linux.intel.com>
 <CALMp9eT48THXwEG23Kb0-QExyA8qZAtkXxrxc+6+pdvtvVVN0A@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <7c3d3ab5-191f-bd5b-f801-de5ebf68cfee@linux.intel.com>
Date:   Sun, 18 Jul 2021 20:41:34 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT48THXwEG23Kb0-QExyA8qZAtkXxrxc+6+pdvtvVVN0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/16/2021 5:07 PM, Jim Mattson wrote:
> On Fri, Jul 16, 2021 at 12:00 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 7/16/2021 1:02 PM, Jim Mattson wrote:
>>> On Fri, Jul 16, 2021 at 1:54 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>>
>>>> The guest Precise Event Based Sampling (PEBS) feature can provide an
>>>> architectural state of the instruction executed after the guest instruction
>>>> that exactly caused the event. It needs new hardware facility only available
>>>> on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
>>>> feature for KVM guests on ICX.
>>>>
>>>> We can use PEBS feature on the Linux guest like native:
>>>>
>>>>      # echo 0 > /proc/sys/kernel/watchdog (on the host)
>>>>      # perf record -e instructions:ppp ./br_instr a
>>>>      # perf record -c 100000 -e instructions:pp ./br_instr a
>>>>
>>>> To emulate guest PEBS facility for the above perf usages,
>>>> we need to implement 2 code paths:
>>>>
>>>> 1) Fast path
>>>>
>>>> This is when the host assigned physical PMC has an identical index as the
>>>> virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
>>>> This path is used in most common use cases.
>>>>
>>>> 2) Slow path
>>>>
>>>> This is when the host assigned physical PMC has a different index from the
>>>> virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
>>>> KVM needs to rewrite the PEBS records to change the applicable counter indexes
>>>> to the virtual PMC indexes, which would otherwise contain the physical counter
>>>> index written by PEBS facility, and switch the counter reset values to the
>>>> offset corresponding to the physical counter indexes in the DS data structure.
>>>>
>>>> The previous version [0] enables both fast path and slow path, which seems
>>>> a bit more complex as the first step. In this patchset, we want to start with
>>>> the fast path to get the basic guest PEBS enabled while keeping the slow path
>>>> disabled. More focused discussion on the slow path [1] is planned to be put to
>>>> another patchset in the next step.
>>>>
>>>> Compared to later versions in subsequent steps, the functionality to support
>>>> host-guest PEBS both enabled and the functionality to emulate guest PEBS when
>>>> the counter is cross-mapped are missing in this patch set
>>>> (neither of these are typical scenarios).
>>>
>>> I'm not sure exactly what scenarios you're ruling out here. In our
>>> environment, we always have to be able to support host-level
>>> profiling, whether or not the guest is using the PMU (for PEBS or
>>> anything else). Hence, for our *basic* vPMU offering, we only expose
>>> two general purpose counters to the guest, so that we can keep two
>>> general purpose counters for the host. In this scenario, I would
>>> expect cross-mapped counters to be common. Are we going to be able to
>>> use this implementation?
>>>
>>
>> Let's say we have 4 GP counters in HW.
>> Do you mean that the host owns 2 GP counters (counter 0 & 1) and the
>> guest own the other 2 GP counters (counter 2 & 3) in your envirinment?
>> We did a similar implementation in V1, but the proposal has been denied.
>> https://lore.kernel.org/kvm/20200306135317.GD12561@hirez.programming.kicks-ass.net/
> 
> It's the other way around. AFAIK, there is no architectural way to
> specify that only counters 2 and 3 are available, so we have to give
> the guest counters 0 and 1.

How about the host? Can the host see all 4 counters?

> 
>> For the current proposal, both guest and host can see all 4 GP counters.
>> The counters are shared.
> 
> I don't understand how that can work. If the host programs two
> counters, how can you give the guest four counters?
> 
>> The guest cannot know the availability of the counters. It may requires
>> a counter (e.g., counter 0) which may has been used by the host. Host
>> may provides another counter (e.g., counter 1) to the guest. This is the
>> case described in the slow path. For this case, we have to modify the
>> guest PEBS record. Because the counter index in the PEBS record is 1,
>> while the guest perf driver expects 0.
> 
> If we reserve counters 0 and 1 for the guest, this is not a problem
> (assuming we tell the guest it only has two counters). If we don't
> statically partition the counters, I don't see how you can ensure that
> the guest behaves as architected. For example, what do you do when the
> guest programs four counters and the host programs two?

Ideally, we should do multiplexing if the guest requires four and the 
host requires two. But I doubt this patch set implements the 
multiplexing, because the multiplexing should be part of the slow path, 
which will be supported in the next step.

Could you please share more details regarding your environment?
How do you handle the case that guest programs two counters and the host 
programs four counters?

> 
>> If counter 0 is available, guests can use counter 0. That's the fast
>> path. I think the fast path should be more common even both host and
>> guest are profiling. Because except for some specific events, we may
>> move the host event to the counters which are not required by guest if
>> we have enough resources.
> 
> And if you don't have enough resources? 

As my understanding, multiplexing should be the only choice if we don't 
have enough resources.

Thanks,
Kan
