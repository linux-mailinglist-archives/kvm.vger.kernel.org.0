Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0490B2CE861
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 08:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgLDHDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 02:03:39 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8683 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLDHDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 02:03:39 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnNtc3WcLzklD0;
        Fri,  4 Dec 2020 15:02:16 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 15:02:43 +0800
Subject: Re: [PATCH v2 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To:     Marc Zyngier <maz@kernel.org>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-3-zhukeqian1@huawei.com>
 <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <c41a32f6-e671-4c69-cbbc-57c11d35112f@huawei.com>
Date:   Fri, 4 Dec 2020 15:02:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/12/3 22:57, Marc Zyngier wrote:
> On 2020-08-18 04:28, Keqian Zhu wrote:
>> ARM virtual counter supports event stream, it can only trigger an event
>> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 changes,
>> so the actual period of event stream is 2^(cntkctl_evnti + 1). For example,
>> when the trigger bit is 0, then virtual counter trigger an event for every
>> two cycles.
>>
>> Fixes: 037f637767a8 ("drivers: clocksource: add support for
>>        ARM architected timer event stream")
> 
> Fixes: tags should on a single line.
Will do.

> 
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/clocksource/arm_arch_timer.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c
>> b/drivers/clocksource/arm_arch_timer.c
>> index 777d38c..e3b2ee0 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -824,10 +824,14 @@ static void arch_timer_configure_evtstream(void)
>>  {
>>      int evt_stream_div, pos;
>>
>> -    /* Find the closest power of two to the divisor */
>> -    evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
>> +    /*
>> +     * Find the closest power of two to the divisor. As the event
>> +     * stream can at most be generated at half the frequency of the
>> +     * counter, use half the frequency when computing the divider.
>> +     */
>> +    evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
>>      pos = fls(evt_stream_div);
>> -    if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
>> +    if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>>          pos--;
> 
> You don't explain why you are special-casing pos == 1.
The logic is not clear here, I will try to reform it.

> 
>>      /* enable event stream */
>>      arch_timer_evtstrm_enable(min(pos, 15));
> 
> Also, please Cc the subsystem maintainers:
> 
> CLOCKSOURCE, CLOCKEVENT DRIVERS
> M:      Daniel Lezcano <daniel.lezcano@linaro.org>
> M:      Thomas Gleixner <tglx@linutronix.de>
> L:      linux-kernel@vger.kernel.org
> S:      Supported
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> F:      Documentation/devicetree/bindings/timer/
> F:      drivers/clocksource/
> 
Will do.

> Thanks,
> 
>         M.

Thanks,
Keqian
