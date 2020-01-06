Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1EBE131172
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 12:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgAFLf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 06:35:59 -0500
Received: from foss.arm.com ([217.140.110.172]:43146 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAFLf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 06:35:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4204E328;
        Mon,  6 Jan 2020 03:35:58 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 552223F534;
        Mon,  6 Jan 2020 03:35:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 12/18] arm64: timer: EOIR the interrupt
 after masking the timer
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-13-git-send-email-alexandru.elisei@arm.com>
 <20200103133651.4988de7a@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6516afb5-3eb4-e307-3762-0a4b2dfd1864@arm.com>
Date:   Mon, 6 Jan 2020 11:35:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200103133651.4988de7a@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/3/20 1:36 PM, Andre Przywara wrote:
> On Tue, 31 Dec 2019 16:09:43 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> Writing to the EOIR register before masking the HW mapped timer
>> interrupt can cause taking another timer interrupt immediately after
>> exception return. This doesn't happen all the time, because KVM
>> reevaluates the state of pending HW mapped level sensitive interrupts on
>> each guest exit. If the second interrupt is pending and a guest exit
>> occurs after masking the timer interrupt and before the ERET (which
>> restores PSTATE.I), then KVM removes it.
>>
>> Move the write after the IMASK bit has been set to prevent this from
>> happening.
> Sounds about right, just one comment below:
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/timer.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/timer.c b/arm/timer.c
>> index f390e8e65d31..67e95ede24ef 100644
>> --- a/arm/timer.c
>> +++ b/arm/timer.c
>> @@ -149,8 +149,8 @@ static void irq_handler(struct pt_regs *regs)
>>  	u32 irqstat = gic_read_iar();
>>  	u32 irqnr = gic_iar_irqnr(irqstat);
>>  
>> -	if (irqnr != GICC_INT_SPURIOUS)
>> -		gic_write_eoir(irqstat);
>> +	if (irqnr == GICC_INT_SPURIOUS)
>> +		return;
>>  
>>  	if (irqnr == PPI(vtimer_info.irq)) {
>>  		info = &vtimer_info;
>> @@ -162,7 +162,11 @@ static void irq_handler(struct pt_regs *regs)
>>  	}
>>  
>>  	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
>> +	isb();
> Shall this isb() actually go into the write_[pv]timer_ctl() implementation? I see one other call where we enable the timer without an isb() afterwards. Plus I am not sure we wouldn't need it as well for disabling the timers?

Good catch. From ARM DDI 0487E.a glossary, the section "Context synchronization
event":

"All direct and indirect writes to System registers that are made before the
Context synchronization event affect any instruction, including a direct read,
that appears in program order after the instruction causing the Context
synchronization event."

Based on that, I'll add an ISB after a control register write.

Thanks,
Alex
>
> Cheers,
> Andre.
>
>> +
>>  	info->irq_received = true;
>> +
>> +	gic_write_eoir(irqstat);
>>  }
>>  
>>  static bool gic_timer_pending(struct timer_info *info)
