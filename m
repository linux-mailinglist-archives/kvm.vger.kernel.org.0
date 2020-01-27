Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299F414A70E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 16:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgA0PUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 10:20:51 -0500
Received: from foss.arm.com ([217.140.110.172]:46056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbgA0PUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 10:20:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFD9D31B;
        Mon, 27 Jan 2020 07:20:49 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF9EB3F67D;
        Mon, 27 Jan 2020 07:20:48 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] arm: expand the timer tests
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>
References: <20200110160511.17821-1-alex.bennee@linaro.org>
 <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com> <871rs3ntok.fsf@linaro.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c5b006e9-bff9-1d92-e1f9-98287a0cebcc@arm.com>
Date:   Mon, 27 Jan 2020 15:20:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <871rs3ntok.fsf@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

CC'ing the arm maintainer)

Sorry for the late reply, got distracted by something else.

On 1/13/20 5:38 PM, Alex Bennée wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
>
>> Hi,
>>
>> On 1/10/20 4:05 PM, Alex Bennée wrote:
>>> This was an attempt to replicate a QEMU bug. However to trigger the
>>> bug you need to have an offset set in EL2 which kvm-unit-tests is
>>> unable to do. However it does exercise some more corner cases.
>>>
>>> Bug: https://bugs.launchpad.net/bugs/1859021
>> I'm not aware of any Bug: tags in the Linux kernel. If you want people to follow
>> the link to the bug, how about referencing something like this:
>>
>> "This was an attempt to replicate a QEMU bug [1]. [..]
>>
>> [1] https://bugs.launchpad.net/qemu/+bug/1859021"
> OK, I'll fix that in v2.
>
>> Also, are launchpad bug reports permanent? Will the link still work in
>> a years' time?
> They should be - they are a unique id and we use them in the QEMU source
> tree.
>
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>>  arm/timer.c | 27 ++++++++++++++++++++++++++-
>>>  1 file changed, 26 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arm/timer.c b/arm/timer.c
>>> index f390e8e..ae1d299 100644
>>> --- a/arm/timer.c
>>> +++ b/arm/timer.c
>>> @@ -214,21 +214,46 @@ static void test_timer(struct timer_info *info)
>>>  	 * still read the pending state even if it's disabled. */
>>>  	set_timer_irq_enabled(info, false);
>>>  
>>> +	/* Verify count goes up */
>>> +	report(info->read_counter() >= now, "counter increments");
>>> +
>>>  	/* Enable the timer, but schedule it for much later */
>>>  	info->write_cval(later);
>>>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>>>  	isb();
>>> -	report(!gic_timer_pending(info), "not pending before");
>>> +	report(!gic_timer_pending(info), "not pending before 10s");
>>> +
>>> +	/* Check with a maximum possible cval */
>>> +	info->write_cval(UINT64_MAX);
>>> +	isb();
>>> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX");

This check alone was enough for me to trigger the qemu bug. Would you mind
explaining the reason for performing the test again, but with the timer interrupt
enabled at the GIC level? Did the fix have something to do with the interrupt?

>>> +
>>> +	/* also by setting tval */
>> All the comments in this file seem to start with a capital letter.
>>
>>> +	info->write_tval(time_10s);
>>> +	isb();
>>> +	report(!gic_timer_pending(info), "not pending before 10s (via tval)");
>> You can remove the "(via tval)" part - the message is unique enough to figure out
>> which part of the test it refers to.
> I added it to differentiate with the message a little further above.

You're right, I didn't notice that we already have the exact same message.

But I thought some more about this test, and I'm not really sure we can do it
reliably. I ran your patch on an AMD Seattle, where the timer frequency is
0xee6b280, which multiplied by 10 gives us 0x9502f900, which will be interpreted
as a negative value because TimerValue is a **signed** 32-bit integer. That means
that we're actually programming the timer to fire in the **past**, so this test
fails. Let's say we limit the value that we're writing to TVAL to INT32_MAX, but
because of a high timer frequency, the time window before the interrupt is
asserted could be too small, and, depending on the environment and how Linux
schedules tasks, this check might randomly fail.

>
>>> +	report_info("TVAL is %d (delta CVAL %ld) ticks",
>>> +		    info->read_tval(), info->read_cval() - info->read_counter());
>> I'm not sure what you are trying to achieve with this. You can transform it to
>> check that TVAL is indeed positive and (almost) equal to cval - cntpct, something
>> like this:
>>
>> +	s32 tval = info->read_tval();
>> +	report(tval > 0 && tval <= info->read_cval() -
>> info->read_counter(), "TVAL measures time to next interrupt");
> Yes it was purely informational to say tval decrements towards the next
> IRQ. I can make it a pure test.
>
>>>  
>>> +        /* check pending once cval is before now */
>> This comment adds nothing to the test.
> dropped.
>
>>>  	info->write_cval(now - 1);
>>>  	isb();
>>>  	report(gic_timer_pending(info), "interrupt signal pending");
>>> +	report_info("TVAL is %d ticks", info->read_tval());
>> You can test that TVAL is negative here instead of printing the value.
> ok.
>
>>>  
>>>  	/* Disable the timer again and prepare to take interrupts */
>>>  	info->write_ctl(0);
>>>  	set_timer_irq_enabled(info, true);
>>>  	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>>>  
>>> +	/* QEMU bug when cntvoff_el2 > 0
>>> +	 * https://bugs.launchpad.net/bugs/1859021 */
>> This looks confusing to me. From the commit message, I got that kvm-unit-tests
>> needs qemu to set a special value for CNTVOFF_EL2. But the comments seems to
>> suggest that kvm-unit-tests can trigger the bug without qemu doing anything
>> special. Can you elaborate under which condition kvm-unit-tests can
>> trigger the bug?
> It can't without some sort of mechanism to set the hypervisor registers
> before running the test. The QEMU bug is an overflow when cval of UINT64_MAX
> with a non-zero CNTVOFF_EL2.
>
> Running under KVM the host kernel will have likely set CNTVOFF_EL2 to
> some sort of value with:
>
> 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());

I was able to replicate the bug by running KVM under qemu with virtualization=on,
thanks.

>
>>> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>>> +	info->write_cval(UINT64_MAX);
>> The order is wrong - you write CVAL first, *then* enable to timer. Otherwise you
>> might get an interrupt because of the previous CVAL value.
>>
>> The previous value for CVAL was now -1, so your change triggers an unwanted
>> interrupt after enabling the timer. The interrupt handler masks the timer
>> interrupt at the timer level, which means that as far as the gic is concerned the
>> interrupt is not pending, making the report call afterwards useless.
>>
>>> +	isb();
>>> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX (irqs on)");
>> This check can be improved. You want to check the timer CTL.ISTATUS here, not the
>> gic. A device (in this case, the timer) can assert the interrupt, but the gic does
>> not sample it immediately. Come to think of it, the entire timer test is wrong
>> because of this.
> Is it worth still checking the GIC or just replacing everything with
> calls to:
>
>   static bool timer_pending(struct timer_info *info)
>   {
>           return info->read_ctl() & ARCH_TIMER_CTL_ISTATUS;
>   }

We should still check that the GIC sees the interrupt as pending, because we need
it to inject interrupts in a guest. I'm already working on improving that [1].

[1] https://www.spinics.net/lists/kvm/msg203609.html

Thanks,
Alex
>
>> Thanks,
>> Alex
>>> +	info->write_ctl(0);
>>> +
>>>  	report(test_cval_10msec(info), "latency within 10 ms");
>>>  	report(info->irq_received, "interrupt received");
>>>  
>
