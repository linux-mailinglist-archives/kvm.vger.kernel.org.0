Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91312CE29
	for <lists+kvm@lfdr.de>; Mon, 30 Dec 2019 10:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfL3JVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Dec 2019 04:21:21 -0500
Received: from foss.arm.com ([217.140.110.172]:53654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfL3JVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Dec 2019 04:21:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA237328;
        Mon, 30 Dec 2019 01:21:20 -0800 (PST)
Received: from [10.37.8.67] (unknown [10.37.8.67])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 582A23F703;
        Mon, 30 Dec 2019 01:21:17 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 13/18] arm64: timer: Test behavior when
 timer disabled or masked
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-14-alexandru.elisei@arm.com>
 <20191213182815.i6sai77zv4jfunr4@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <36dbc7c6-8c03-fa2b-bc19-a9de008970f3@arm.com>
Date:   Mon, 30 Dec 2019 09:21:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213182815.i6sai77zv4jfunr4@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/13/19 6:28 PM, Andrew Jones wrote:
> On Thu, Nov 28, 2019 at 06:04:13PM +0000, Alexandru Elisei wrote:
>> When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
>> timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
>> set), timer interrupts must not be pending or asserted by the VGIC.
>> However, only when the timer interrupt is masked, we can still check
>> that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>
>> This test was used to discover a bug and test the fix introduced by KVM
>> commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
>> interrupts on enable").
> This kind of information can/should go above the ---, IMO.

Sure, I'll do that.

Thanks,
Alex
> Thanks,
> drew
>
>>  arm/timer.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arm/timer.c b/arm/timer.c
>> index d2cd5dc7a58b..09d527bb09a8 100644
>> --- a/arm/timer.c
>> +++ b/arm/timer.c
>> @@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
>>  
>>  	/* Disable the timer again and prepare to take interrupts */
>>  	info->write_ctl(0);
>> +	isb();
>> +	info->irq_received = false;
>>  	set_timer_irq_enabled(info, true);
>> +	report("no interrupt when timer is disabled", !info->irq_received);
>>  	report("interrupt signal no longer pending", !gic_timer_pending(info));
>>  
>> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
>> +	isb();
>> +	report("interrupt signal not pending", !gic_timer_pending(info));
>> +	report("timer condition met", info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
>> +
>>  	report("latency within 10 ms", test_cval_10msec(info));
>>  	report("interrupt received", info->irq_received);
>>  
>> -- 
>> 2.20.1
>>
