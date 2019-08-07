Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9284FD5
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbfHGP06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 11:26:58 -0400
Received: from foss.arm.com ([217.140.110.172]:50204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbfHGP06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 11:26:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C05F5344;
        Wed,  7 Aug 2019 08:26:56 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69BC03F706;
        Wed,  7 Aug 2019 08:26:55 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com> <m1mugnmv0x.fsf@dinechin.org>
 <ff2d038d-d866-65fa-655d-b9865bf14016@arm.com>
 <9F77FA64-C71B-4025-A58D-3AC07E6688DE@dinechin.org>
From:   Steven Price <steven.price@arm.com>
Message-ID: <e56c3179-c988-1598-9274-7c3a31444a53@arm.com>
Date:   Wed, 7 Aug 2019 16:26:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9F77FA64-C71B-4025-A58D-3AC07E6688DE@dinechin.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2019 15:28, Christophe de Dinechin wrote:
> 
> 
>> On 7 Aug 2019, at 15:21, Steven Price <steven.price@arm.com
>> <mailto:steven.price@arm.com>> wrote:
>>
>> On 05/08/2019 17:40, Christophe de Dinechin wrote:
>>>
>>> Steven Price writes:
>>>
>>>> Introduce a paravirtualization interface for KVM/arm64 based on the
>>>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>>>
>>>> This only adds the details about "Stolen Time" as the details of "Live
>>>> Physical Time" have not been fully agreed.
>>>>
>>> [...]
>>>
>>>> +
>>>> +Stolen Time
>>>> +-----------
>>>> +
>>>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>>>> +
>>>> +  Field       | Byte Length | Byte Offset | Description
>>>> +  ----------- | ----------- | ----------- | --------------------------
>>>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>>>> +  Attributes  |      4      |      4      | Must be 0
>>>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>>>> +              |             |             | nanoseconds indicating how
>>>> +              |             |             | much time this VCPU thread
>>>> +              |             |             | was involuntarily not
>>>> +              |             |             | running on a physical CPU.
>>>
>>> I know very little about the topic, but I don't understand how the spec
>>> as proposed allows an accurate reading of the relation between physical
>>> time and stolen time simultaneously. In other words, could you draw
>>> Figure 1 of the spec from within the guest? Or is it a non-objective?
>>
>> Figure 1 is mostly attempting to explain Live Physical Time (LPT), which
>> is not part of this patch series. But it does touch on stolen time by
>> the difference between "live physical time" and "virtual time".
>>
>> I'm not sure what you mean by "from within the guest". From the
>> perspective of the guest the parts of the diagram where the guest isn't
>> running don't exist (therefore there are discontinuities in the
>> "physical time" and "live physical time" lines).
> 
> I meant: If I run code within the guest that attempts to draw Figure 1,
> race conditions may cause the diagram actually drawn by your guest
> program to look completely wrong on occasions.
> 
>> This patch series doesn't attempt to provide the guest with a view of
>> "physical time" (or LPT) - but it might be able to observe that by
>> consulting something external (e.g. an NTP server, or an emulated RTC
>> which reports wall-clock time).
> 
> … with what appear to be like a built-in race condition, as you correctly
> identified. I was wondering if the built-in race condition was deliberate
> and/or necessary, or if it was irrelevant for the planned uses of the value.
> 
>> What it does provide is a mechanism for obtaining the difference (as
>> reported by the host) between "live physical time" and "virtual time" -
>> this is reported in nanoseconds in the above structure.
>>
>>> For example, if you read the stolen time before you read CNTVCT_EL0,
>>> isn't it possible for a lengthy event like a migration to occur between
>>> the two reads, causing the stolen time to be obsolete and off by seconds?
>>
>> "Lengthy events" like migration are represented by the "paused" state in
>> the diagram - i.e. it's the difference between "physical time" and "live
>> physical time". So stolen time doesn't attempt to represent that.
>>
>> And yes, there is a race between reading CNTVCT_EL0 and reading stolen
>> time - but in practice this doesn't really matter. The usual pseudo-code
>> way of using stolen time is:
> 
> I’m assuming this is the guest scheduler you are talking about,

yes

> and I’m assuming virtualization can preempt that code anywhere.
> Maybe that’s where I’m wrong?

You are correct, the guest can be preempted at any point.

> 
> For the sake of the argument, assume there is a 1s pause.
> Not completely unreasonable in a migration scenario.

As I mentioned before, events like migration are not represented by
stolen time. They would be represented by CNTVCT_EL0 appearing to pause
during the migration (so showing a difference between "physical time"
and "live physical time"). The stolen time value would not be incremented.

>>  * scheduler captures stolen time from structure and CNTVCT_EL0:
>>      before_timer = CNTVCT_EL0
> 
> [insert optional 1s pause here, case A]
> 
>>      before_stolen = stolen
>>  * schedule in process
>>  * process is pre-empted (or blocked in some way)
>>  * scheduler captures stolen time from structure and CNTVCT_EL0:
>>      after_timer = CNTVCT_EL0
> 
> [insert optional 1s pause here, case B]
> 
>>      after_stolen = stolen
>>      time = to_nsecs(after_timer - before_timer) -
>>             (after_stolen - before_stolen)
> 
> In case A, time is too big by one second. In case B, it is too small,
> to the point where your code might need to be ready for
> “time” unexpectedly showing up as negative.

So a 1 second pause is unlikely for stolen time - this means that the
VCPU was ready to run, but the host didn't run it for some reason. But
in theory you are correct this could happen. The core code deals with it
like this (update_rq_clock_task):
> 	if (static_key_false((&paravirt_steal_rq_enabled))) {
> 		steal = paravirt_steal_clock(cpu_of(rq));
> 		steal -= rq->prev_steal_time_rq;
> 
> 		if (unlikely(steal > delta))
> 			steal = delta;
> 
> 		rq->prev_steal_time_rq += steal;
> 		delta -= steal;
> 	}

So if (steal > delta) then steal is capped to delta, preventing the
final delta from going negative.

>>
>> The scheduler can then charge the process for "time" nanoseconds of
>> time. This ensures that a process isn't unfairly penalised if the host
>> doesn't schedule the VCPU while it is supposed to be running.
>>
>> The race is very small in comparison to the time the process is running,
>> and in the worst case just means the process is charged slightly more
>> (or less) than it should be.
> 
> At this point, what I don’t understand is why the race would be
> “very small” or why you would only be charged “slightly” more or less?

The window between measuring the time using CNTVCT_EL0 and getting the
stolen time from the hypervisor is pretty short. The amount of time that
is (normally) stolen in one go is also small. So the race is unlikely
and the error when it occurs is (usually) small.

Long events (such as migration or pausing the guest) are not considered
"stolen time" and should be reflected to the guest in other ways.

>> I guess if you're really worried about it, you could do a dance like:
>>
>> do {
>> before = stolen
>> timer = CNTVCT_EL0
>> after = stolen
>> } while (before != after);
> 
> That will work as long as nothing in that loop requires something
> that would cause `stolen` to jump. If there is such a guarantee,
> then that’s even efficient, because in most cases the loop
> would only run once, at the cost of one extra read and one test.

Note that other architectures don't have such loops, so arm64 is just
following the lead of existing architecture.

>> But I don't see the need to have such an accurate view of elapsed time
>> that the VCPU was scheduled. And of course at the moment (without this
>> series) the guest has no idea about time stolen by the host.
> 
> I’m certainly not arguing that exposing stolen time is a bad idea,
> I’m only wondering if the proposed solution is racy, and if so, if
> it is intentional.
> 
> If it’s indeed racy, the problem could be mitigated in a number of
> ways
> 
> a) document your loop or something similar as being the recommended
> way to avoid the race, and then ensure that the loop actually
> will always work as intended. The upside is that it’s just a change in
> some comments or documentation.
> 
> b) having a single interface that exposes multiple times. For example,
> you could have a copy of CNTVCT_EL0 written alongside stolen time,
> and then the scheduler could use that copy for its decision.

That would still be racy - the structure can be updated at any time (as
the host could interrupt the VCPU at any time), so you would still be
left with the problem of reading both atomically - which would mean
going back to the loop. This is the approach that LPT takes and is
documented in the spec.

Also I can't see why you would want to know the CNTVCT_EL0 value at the
point the stolen time was updated, it's much more useful to know the
current CNTVCT_EL0 value.

Ultimately reading the stolen time is always going to be slightly racy
because you are including some of the scheduler's time in the
calculation of how much time the process was running for. The pauses you
describe above are instances where time has been stolen from the
scheduler, but that time is being accounted for/against a user space
process. While the algorithm could be changed so that it's always a
positive for the user space process I'm not sure that's a benefit (it's
probably better that statistically it can go either way).

Steve

