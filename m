Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047A51312C2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 14:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgAFNWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 08:22:45 -0500
Received: from foss.arm.com ([217.140.110.172]:43976 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAFNWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 08:22:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8CC3328;
        Mon,  6 Jan 2020 05:22:44 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B465C3F534;
        Mon,  6 Jan 2020 05:22:43 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 13/18] arm64: timer: Test behavior when
 timer disabled or masked
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-14-git-send-email-alexandru.elisei@arm.com>
 <20200103133720.05f1bfb2@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a32796e7-75e2-5c7e-0ea4-0300f0b04910@arm.com>
Date:   Mon, 6 Jan 2020 13:22:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200103133720.05f1bfb2@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/3/20 1:37 PM, Andre Przywara wrote:
> On Tue, 31 Dec 2019 16:09:44 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
>> timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
>> set), timer interrupts must not be pending or asserted by the VGIC.
>> However, only when the timer interrupt is masked, we can still check
>> that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.
>>
>> This test was used to discover a bug and test the fix introduced by KVM
>> commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
>> interrupts on enable").
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/timer.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arm/timer.c b/arm/timer.c
>> index 67e95ede24ef..a0b57afd4fe4 100644
>> --- a/arm/timer.c
>> +++ b/arm/timer.c
>> @@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
>>  
>>  	/* Disable the timer again and prepare to take interrupts */
>>  	info->write_ctl(0);
>> +	isb();
>> +	info->irq_received = false;
>>  	set_timer_irq_enabled(info, true);
> Are we too impatient here? There does not seem to be a barrier after the write to the ISENABLER register, so I wonder if we need at least a dsb() here? I think in other occasions (GIC test) we even wait for some significant amount of time to allow interrupts to trigger (or not).

I'm not sure exactly what is going on with regards to the GIC write. The gicv3
driver tries to read the RWP (Register Write Pending) register after the ISENABLER
write until it times out. The gicv2 driver doesn't do anything after the write to
ISENABLER. As far as enabling/disabling interrupts, I think it would be best to
have a library function for that, that can deal with the differences between GIC
versions. In practice, this isn't an issue for the GIC because accesses are
trapped and a write always completes after the instruction finishes (and RWP is
always clear, to indicate that there are no writes in progress).

As for waiting for interrupts to trigger, I see no reason why we shouldn't do
that. I have some local patches that fix several issues with the GIC and refactor
check_acked, I'll get back to them after these fixes get merged.

>> +	report(!info->irq_received, "no interrupt when timer is disabled");
>>  	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>>  
>> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
>> +	isb();
>> +	report(!gic_timer_pending(info), "interrupt signal not pending");
>> +	report(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS, "timer condition met");
>> +
>>  	report(test_cval_10msec(info), "latency within 10 ms");
>>  	report(info->irq_received, "interrupt received");
> Not part of your patch, but is this kind of evaluation of the irq_received actually valid? Does the compiler know that this gets set in another part of the code (the IRQ handler)? Do we need some synchronisation or barrier here to prevent the compiler from optimising or reordering the access to irq_received? 

We don't need a synchronization or memory barrier because the test is single
threaded. Exception entry and ERET are context synchronization events, so we don't
need an ISB when setting/reading irq_received.

But I think you're right about the compiler possibly messing with accesses to the
irq_received field. I'll mark it as volatile.

Thanks,
Alex
>
> Cheers,
> Andre.
