Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7767A63C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 12:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfG3KtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 06:49:12 -0400
Received: from foss.arm.com ([217.140.110.172]:59182 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfG3KtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 06:49:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B05CF344;
        Tue, 30 Jul 2019 03:49:11 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 011073F575;
        Tue, 30 Jul 2019 03:49:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
 <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
 <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
 <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e827084e-7c8c-0970-dcb0-8227d5660bff@arm.com>
Date:   Tue, 30 Jul 2019 11:49:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/19 11:12 AM, Andrew Jones wrote:
> On Tue, Jul 30, 2019 at 10:30:50AM +0100, Alexandru Elisei wrote:
>> On 7/29/19 12:23 PM, Andrew Jones wrote:
>>> On Mon, Jul 29, 2019 at 10:28:52AM +0100, Alexandru Elisei wrote:
>>>> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
>>>> to report_info after enabling the timer and before the wfi instruction. The
>>>> uart that printf uses is emulated by userspace and is slow, which makes it
>>>> more likely that the timer interrupt will fire before executing the wfi
>>>> instruction, which leads to a deadlock.
>>>>
>>>> An interrupt can wake up a CPU out of wfi, regardless of the
>>>> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
>>>> before enabling the timer and unmasking them after the wfi returns so the
>>>> CPU can execute the timer interrupt handler.
>>>>
>>>> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>  arm/timer.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/arm/timer.c b/arm/timer.c
>>>> index 6f2ad1d76ab2..f2f60192ba62 100644
>>>> --- a/arm/timer.c
>>>> +++ b/arm/timer.c
>>>> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
>>>>  	/* Test TVAL and IRQ trigger */
>>>>  	info->irq_received = false;
>>>>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
>>>> +	local_irq_disable();
>>>>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>>>>  	report_info("waiting for interrupt...");
>>>>  	wfi();
>>>> +	local_irq_enable();
>>>>  	left = info->read_tval();
>>>>  	report("interrupt received after TVAL/WFI", info->irq_received);
>>>>  	report("timer has expired (%d)", left < 0, left);
>>>> -- 
>>>> 2.7.4
>>>>
>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>>
>>> Thanks Alexandru. It now makes more sense to me that wfi wakes up on
>>> an interrupt, even when interrupts are masked, as it's clearly to
>>> avoid these types of races. I see we have the same type of race in
>>> arm/gic.c. I'll try to get around to fixing that at some point, unless
>>> somebody beats me to it :)
>> Something like this? Tested with gicv3-ipi.
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index ed5642e74f70..f0bd5739842a 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -220,12 +220,12 @@ static void ipi_enable(void)
>>  #else
>>         install_irq_handler(EL1H_IRQ, ipi_handler);
>>  #endif
>> -       local_irq_enable();
>>  }
>>  
>>  static void ipi_send(void)
>>  {
>>         ipi_enable();
>> +       local_irq_enable();
>>         wait_on_ready();
>>         ipi_test_self();
>>         ipi_test_smp();
>> @@ -236,9 +236,13 @@ static void ipi_send(void)
>>  static void ipi_recv(void)
>>  {
>>         ipi_enable();
>> +       local_irq_disable();
>>         cpumask_set_cpu(smp_processor_id(), &ready);
>> -       while (1)
>> +       while (1) {
>> +               local_irq_disable();
>>                 wfi();
>> +               local_irq_enable();
>> +       }
>>  }
>>  
>>  static void ipi_test(void *data __unused)
> I'm not sure we need to worry about enabling/disabling interrupts around
> the wfi, since we're just doing a tight loop on it. I think something like
> this (untested), which is quite similar to your approach, should work
>
> diff --git a/arm/gic.c b/arm/gic.c
> index ed5642e74f70..cdbb4134b0af 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -214,18 +214,19 @@ static void ipi_test_smp(void)
>  
>  static void ipi_enable(void)
>  {
> +       local_irq_disable();
>         gic_enable_defaults();
>  #ifdef __arm__
>         install_exception_handler(EXCPTN_IRQ, ipi_handler);
>  #else
>         install_irq_handler(EL1H_IRQ, ipi_handler);
>  #endif
> -       local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
>         ipi_enable();
> +       local_irq_enable();
>         wait_on_ready();
>         ipi_test_self();
>         ipi_test_smp();
> @@ -237,6 +238,7 @@ static void ipi_recv(void)
>  {
>         ipi_enable();
>         cpumask_set_cpu(smp_processor_id(), &ready);
> +       local_irq_enable();
>         while (1)
>                 wfi();
>  }
>
> What do you think?

I've been thinking about it and I think that the gic test is fine as it is. The
secondaries are already synchronized with the boot cpu via the ready mask, we
don't care if the secondaries receive the IPIs before or after the wfi
instruction, and they will end up blocked in wfi at the end of the test either
way (because of the while(1) loop). Am I missing something?

Thanks,
Alex
>
> Thanks,
> drew
