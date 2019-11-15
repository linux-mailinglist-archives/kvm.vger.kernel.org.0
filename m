Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8CFDC48
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfKOLcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:32:10 -0500
Received: from foss.arm.com ([217.140.110.172]:57450 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfKOLcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:32:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77B1831B;
        Fri, 15 Nov 2019 03:32:09 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 816033F6C4;
        Fri, 15 Nov 2019 03:32:08 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 07/17] arm: gic: Extend check_acked() to
 allow silent call
To:     Andrew Jones <drjones@redhat.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-8-andre.przywara@arm.com>
 <25598849-b195-3411-8092-b0656bcfb762@arm.com>
 <20191114123224.2b5jr73qqtgtc7na@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7aca029b-c2f7-aef9-9fac-b79f5ff5658b@arm.com>
Date:   Fri, 15 Nov 2019 11:32:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191114123224.2b5jr73qqtgtc7na@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/14/19 12:32 PM, Andrew Jones wrote:
> On Tue, Nov 12, 2019 at 03:23:04PM +0000, Alexandru Elisei wrote:
>> check_acked is starting to become hard to read.
> Agreed. check_acked() could probably have some of its subtests factored
> out to improve its readability.
>
>> The function itself is rather inconsistent, as it mixes regular
>> printf's with report_info's.
> Sounds good
>
>> The return value is also never used:
>>
>> $ awk '/check_acked\(/ && !/const/' arm/gic.c
>>     check_acked("IPI: self", &mask);
>>     check_acked("IPI: directed", &mask);
>>     check_acked("IPI: broadcast", &mask);
> That's good, since it's a void function :-)

Sorry, got confused, this patch changes it to return a value, and that value is
ignored in the existing functions (the ones I listed above), which would make the
usage of check_acked very inconsistent.

>> What I'm thinking is that we can rewrite check_acked to return true/false (or
>> 0/1), meaning success or failure, remove the testname parameter, replace the
>> printfs to report_info, and have the caller do a report based on the value
>> returned by check_acked.
>>
>> Rough version, compile tested only, I'm sure it can be improved:
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index adb6aa464513..5453f2fd3d5f 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -60,11 +60,11 @@ static void stats_reset(void)
>>         smp_wmb();
>>  }
>>  
>> -static void check_acked(const char *testname, cpumask_t *mask)
>> +static bool check_acked(cpumask_t *mask)
> We have several check_* functions in arm/gic.c, and they're all void
> functions. Changing this one to a bool would be inconsistent, but
> maybe that consistency isn't that important, or maybe they should all
> be bool?

I think they should stay void, because they compute statistics, or print a warning
if we got a spurious interrupt (check_spurious). I'm not really sure what to do
about check_acked at the moment, I'll think about it some more.

>>  {
>>         int missing = 0, extra = 0, unexpected = 0;
>>         int nr_pass, cpu, i;
>> -       bool bad = false;
>> +       bool success = true;
>>  
>>         /* Wait up to 5s for all interrupts to be delivered */
>>         for (i = 0; i < 50; ++i) {
>> @@ -76,22 +76,21 @@ static void check_acked(const char *testname, cpumask_t *mask)
>>                                 acked[cpu] == 1 : acked[cpu] == 0;
>>  
>>                         if (bad_sender[cpu] != -1) {
>> -                               printf("cpu%d received IPI from wrong sender %d\n",
>> +                               report_info("cpu%d received IPI from wrong sender
>> %d\n",
>>                                         cpu, bad_sender[cpu]);
>> -                               bad = true;
>> +                               success = false;
>>                         }
>>  
>>                         if (bad_irq[cpu] != -1) {
>> -                               printf("cpu%d received wrong irq %d\n",
>> +                               report_info("cpu%d received wrong irq %d\n",
>>                                         cpu, bad_irq[cpu]);
>> -                               bad = true;
>> +                               success = false;
>>                         }
>>                 }
>>                 if (nr_pass == nr_cpus) {
>> -                       report("%s", !bad, testname);
>>                         if (i)
>>                                 report_info("took more than %d ms", i * 100);
>> -                       return;
>> +                       return success;
>>                 }
>>         }
>>  
>> @@ -107,9 +106,9 @@ static void check_acked(const char *testname, cpumask_t *mask)
>>                 }
>>         }
>>  
>> -       report("%s", false, testname);
>>         report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
>>                     missing, extra, unexpected);
>> +       return false;
>>  }
>>  
>>  static void check_spurious(void)
>> @@ -183,13 +182,11 @@ static void ipi_test_self(void)
>>  {
>>         cpumask_t mask;
>>  
>> -       report_prefix_push("self");
>>         stats_reset();
>>         cpumask_clear(&mask);
>>         cpumask_set_cpu(smp_processor_id(), &mask);
>>         gic->ipi.send_self();
>> -       check_acked("IPI: self", &mask);
>> -       report_prefix_pop();
>> +       report("self", check_acked(&mask));
>>  }
>>  
>>  static void ipi_test_smp(void)
>> @@ -203,7 +200,7 @@ static void ipi_test_smp(void)
>>         for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>                 cpumask_clear_cpu(i, &mask);
>>         gic_ipi_send_mask(IPI_IRQ, &mask);
>> -       check_acked("IPI: directed", &mask);
>> +       report("directed", check_acked(&mask));
>>         report_prefix_pop();
> Shouldn't we also drop the "target-list" prefix push/pop?
>
>>  
>>         report_prefix_push("broadcast");
>> @@ -211,7 +208,7 @@ static void ipi_test_smp(void)
>>         cpumask_copy(&mask, &cpu_present_mask);
>>         cpumask_clear_cpu(smp_processor_id(), &mask);
>>         gic->ipi.send_broadcast();
>> -       check_acked("IPI: broadcast", &mask);
>> +       report("broadcast", check_acked(&mask));
>>         report_prefix_pop();
>>  }
> Shouldn't we also drop the "broadcast" prefix push/pop?

My suggestion was a quick hack to give an idea of how it might look, it can
definitely be improved :)

Thanks,
Alex
>>  
>> I've removed "IPI" from the report string because the prefixed was already pushed
>> in main.
>>
>> Andrew, what do you think? Are we missing something obvious? Do you have a better
>> idea?
> I'm happy to see cleanups and haven't had a chance to look too closely at
> the gic tests in a while so I have no better ideas :-)
>
> Thanks,
> drew
>
