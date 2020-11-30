Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EFB2C8681
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgK3OTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:19:02 -0500
Received: from foss.arm.com ([217.140.110.172]:55476 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgK3OTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 09:19:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D7D5D6E;
        Mon, 30 Nov 2020 06:18:16 -0800 (PST)
Received: from [10.37.12.38] (unknown [10.37.12.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4923C3F71F;
        Mon, 30 Nov 2020 06:18:15 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To:     Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com, Eric Auger <eric.auger@redhat.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
 <fd32d075-c6a9-a869-14a9-2c29f41d3318@arm.com>
 <49be46a8-2c29-b805-366e-7c955d395874@huawei.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <eb8f5df2-6ea5-7aad-344a-70fcef3adad8@arm.com>
Date:   Mon, 30 Nov 2020 14:19:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <49be46a8-2c29-b805-366e-7c955d395874@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 11/30/20 1:59 PM, Zenghui Yu wrote:
> Hi Alex,
>
> On 2020/11/27 22:50, Alexandru Elisei wrote:
>> Hi Zhenghui,
>>
>> Thank you for having a look at this!
>>
>> On 11/26/20 9:30 AM, Zenghui Yu wrote:
>>> On 2020/11/25 23:51, Alexandru Elisei wrote:
>>>> The reason for the failure is that the test "dev2/eventid=20 now triggers
>>>> an LPI" triggers 2 LPIs, not one. This behavior was present before this
>>>> patch, but it was ignored because check_lpi_stats() wasn't looking at the
>>>> acked array.
>>>>
>>>> I'm not familiar with the ITS so I'm not sure if this is expected, if the
>>>> test is incorrect or if there is something wrong with KVM emulation.
>>>
>>> I think this is expected, or not.
>>>
>>> Before INVALL, the LPI-8195 was already pending but disabled. On
>>> receiving INVALL, VGIC will reload configuration for all LPIs targeting
>>> collection-3 and deliver the now enabled LPI-8195. We'll therefore see
>>> and handle it before sending the following INT (which will set the
>>> LPI-8195 pending again).
>>>
>>>> Did some more testing on an Ampere eMAG (fast out-of-order cores) using
>>>> qemu and kvmtool and Linux v5.8, here's what I found:
>>>>
>>>> - Using qemu and gic.flat built from*master*: error encountered 864 times
>>>>     out of 1088 runs.
>>>> - Using qemu: error encountered 852 times out of 1027 runs.
>>>> - Using kvmtool: error encountered 8164 times out of 10602 runs.
>>>
>>> If vcpu-3 hadn't seen and handled LPI-8195 as quickly as possible (e.g.,
>>> vcpu-3 hadn't been scheduled), the following INT will set the already
>>> pending LPI-8195 pending again and we'll receive it *once* on vcpu-3.
>>> And we won't see the mentioned failure.
>>>
>>> I think we can just drop the (meaningless and confusing?) INT.
>>
>> I think I understand your explanation, the VCPU takes the interrupt immediately
>> after the INVALL and before the INT, and the second interrupt that I am seeing is
>> the one caused by the INT command.
>
> Yes.
>
>> I tried modifying the test like this:
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 6e93da80fe0d..0ef8c12ea234 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -761,10 +761,17 @@ static void test_its_trigger(void)
>>          wmb();
>>          cpumask_clear(&mask);
>>          cpumask_set_cpu(3, &mask);
>> -       its_send_int(dev2, 20);
>
> Shouldn't its_send_invall(col3) be moved down here? See below.
>
>>          wait_for_interrupts(&mask);
>>          report(check_acked(&mask, 0, 8195),
>> -                       "dev2/eventid=20 now triggers an LPI");
>> +                       "dev2/eventid=20 pending LPI is received");
>> +
>> +       stats_reset();
>> +       wmb();
>> +       cpumask_clear(&mask);
>> +       cpumask_set_cpu(3, &mask);
>> +       its_send_int(dev2, 20);
>> +       wait_for_interrupts(&mask);
>> +       report(check_acked(&mask, 0, 8195), "dev2/eventid=20 triggers an LPI");
>>            report_prefix_pop();
>>   I removed the INT from the initial test, and added a separate one to check that
>> the INT command still works. That looks to me that preserves the spirit of the
>> original test. After doing stress testing this is what I got:
>>
>> - with kvmtool, 47,709 iterations, 27 times the test timed out when waiting for
>> the interrupt after INVALL.
>> - with qemu, 15,511 iterations, 258 times the test timed out when waiting for the
>> interrupt after INVALL, just like with kvmtool.
>
> I guess the reason of failure is that the LPI is taken *immediately*
> after the INVALL?
>
>     /* Now call the invall and check the LPI hits */
>     its_send_invall(col3);
>         <- LPI is taken, acked[]++
>     stats_reset();
>         <- acked[] is cleared unexpectedly
>     wmb();
>     cpumask_clear(&mask);
>     cpumask_set_cpu(3, &mask);
>     wait_for_interrupts(&mask);
>         <- we'll hit timed-out since acked[] is 0

Yes, of course, you're right, I didn't realize that I was resetting the stats
*after* the interrupt was enabled. This also explains why I was still seeing
timeouts even when the timeout duration was set to 50 seconds. I'll retest with
the fix:

diff --git a/arm/gic.c b/arm/gic.c
index 6e93da80fe0d..c4240f5aba39 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -756,15 +756,22 @@ static void test_its_trigger(void)
                        "dev2/eventid=20 still does not trigger any LPI");
 
        /* Now call the invall and check the LPI hits */
+       stats_reset();
+       wmb();
+       cpumask_clear(&mask);
+       cpumask_set_cpu(3, &mask);
        its_send_invall(col3);
+       wait_for_interrupts(&mask);
+       report(check_acked(&mask, 0, 8195),
+                       "dev2/eventid=20 pending LPI is received");
+
        stats_reset();
        wmb();
        cpumask_clear(&mask);
        cpumask_set_cpu(3, &mask);
        its_send_int(dev2, 20);
        wait_for_interrupts(&mask);
-       report(check_acked(&mask, 0, 8195),
-                       "dev2/eventid=20 now triggers an LPI");
+       report(check_acked(&mask, 0, 8195), "dev2/eventid20 triggers an LPI");
 
        report_prefix_pop();
 
I also pushed a branch at [1].

Thank you so much for spotting this! You've saved me (and probably others) a lot
of time debugging.

[1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/fixes1-v2

Thanks,
Alex
