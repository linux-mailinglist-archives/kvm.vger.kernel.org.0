Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19543028DD
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 18:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbhAYR2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 12:28:36 -0500
Received: from foss.arm.com ([217.140.110.172]:52966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbhAYR21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 12:28:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C2371063;
        Mon, 25 Jan 2021 09:27:38 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D4193F68F;
        Mon, 25 Jan 2021 09:27:37 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 08/12] arm/arm64: gic: Split
 check_acked() into two functions
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, yuzenghui@huawei.com
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-9-alexandru.elisei@arm.com>
 <3539c229-fd05-2e1c-2159-995e51e2dcc4@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <857a3c2d-772b-0d29-536c-41a829ab8954@arm.com>
Date:   Mon, 25 Jan 2021 17:27:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <3539c229-fd05-2e1c-2159-995e51e2dcc4@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/18/20 3:52 PM, André Przywara wrote:
> On 17/12/2020 14:13, Alexandru Elisei wrote:
>> check_acked() has several peculiarities: is the only function among the
>> check_* functions which calls report() directly, it does two things
>> (waits for interrupts and checks for misfired interrupts) and it also
>> mixes printf, report_info and report calls.
>>
>> check_acked() also reports a pass and returns as soon all the target CPUs
>> have received interrupts, However, a CPU not having received an interrupt
>> *now* does not guarantee not receiving an erroneous interrupt if we wait
>> long enough.
>>
>> Rework the function by splitting it into two separate functions, each with
>> a single responsibility: wait_for_interrupts(), which waits for the
>> expected interrupts to fire, and check_acked() which checks that interrupts
>> have been received as expected.
>>
>> wait_for_interrupts() also waits an extra 100 milliseconds after the
>> expected interrupts have been received in an effort to make sure we don't
>> miss misfiring interrupts.
>>
>> Splitting check_acked() into two functions will also allow us to
>> customize the behavior of each function in the future more easily
>> without using an unnecessarily long list of arguments for check_acked().
> Yes, splitting this up looks much better, in general this is a nice
> cleanup, thank you!
>
> Some comments below:
>
>> CC: Andre Przywara <andre.przywara@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/gic.c | 73 +++++++++++++++++++++++++++++++++++--------------------
>>  1 file changed, 47 insertions(+), 26 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index ec733719c776..a9ef1a5def56 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -62,41 +62,42 @@ static void stats_reset(void)
>>  	}
>>  }
>>  
>> -static void check_acked(const char *testname, cpumask_t *mask)
>> +static void wait_for_interrupts(cpumask_t *mask)
>>  {
>> -	int missing = 0, extra = 0, unexpected = 0;
>>  	int nr_pass, cpu, i;
>> -	bool bad = false;
>>  
>>  	/* Wait up to 5s for all interrupts to be delivered */
>> -	for (i = 0; i < 50; ++i) {
>> +	for (i = 0; i < 50; i++) {
>>  		mdelay(100);
>>  		nr_pass = 0;
>>  		for_each_present_cpu(cpu) {
>> +			/*
>> +			 * A CPU having received more than one interrupts will
>> +			 * show up in check_acked(), and no matter how long we
>> +			 * wait it cannot un-receive it. Consider at least one
>> +			 * interrupt as a pass.
>> +			 */
>>  			nr_pass += cpumask_test_cpu(cpu, mask) ?
>> -				acked[cpu] == 1 : acked[cpu] == 0;
>> -			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>> -
>> -			if (bad_sender[cpu] != -1) {
>> -				printf("cpu%d received IPI from wrong sender %d\n",
>> -					cpu, bad_sender[cpu]);
>> -				bad = true;
>> -			}
>> -
>> -			if (bad_irq[cpu] != -1) {
>> -				printf("cpu%d received wrong irq %d\n",
>> -					cpu, bad_irq[cpu]);
>> -				bad = true;
>> -			}
>> +				acked[cpu] >= 1 : acked[cpu] == 0;
>
> I wonder if this logic was already flawed to begin with: For interrupts
> we expect to fire, we wait for up to 5 seconds (really that long?), but
> for interrupts we expect *not* to fire we are OK if they don't show up
> in the first 100 ms. That does not sound consistent.

There are two ways that I see to fix this:

- Have the caller wait for however long it sees fit, and *after* that waiting
period call wait_for_interrupts().

- Pass a flag to wait_for_interrupts() to specify that the behaviour should be to
wait for the entire duration instead of until the expected interrupts have been
received.

Neither sounds appealing to me for inclusion in this patch set, since I want to
concentrate on reworking check_acked() while keeping much of the current behaviour
intact.

>
> I am wondering if we should *not* have the initial 100ms wait at all,
> since most interrupts will fire immediately (especially in KVM). And
> then have *one* extra wait for, say 100ms, to cover latecomers and
> spurious interrupts.

I don't think it really matters where the 100 millisecond delay is in the loop. If
we call wait_for_interrupts() to actually check that interrupts have fired (as
opposed to checking that they haven't been asserted), then at most we save 100ms
when they are asserted before the start of the loop. I don't think the GIC spec
guarantees that interrupts written to the LR registers will be presented to the
CPU after the guest resumes, so it is conceivable that there might be a delay,
thus ending up in waiting the extra 100ms even if the delay is at the end of the loop.

There are two reasons I chose the approach of having the delay at the start of the
loop:

1. To preserve the current behaviour.

2. To match what the timer test those (see gic_timer_check_state()). I am also
thinking that maybe at some point we could unify these test-independent functions
in the gic driver.

As for the 5 seconds delay, I think we can come up with a patch to pass the delay
as a parameter to the function if needed (if I remember correctly, you needed a
shorter waiting period for your GIC tests).

>
> But this might be a topic for some extra work/patch?

Yes, I would rather make this changes when we have an actual test that needs them.

>
>>  		}
>> +
>>  		if (nr_pass == nr_cpus) {
>> -			report(!bad, "%s", testname);
>>  			if (i)
>> -				report_info("took more than %d ms", i * 100);
>> +				report_info("interrupts took more than %d ms", i * 100);
>> +			mdelay(100);
> So this is the extra 100ms you mention in the commit message? I am not
> convinced this is the right way (see above) or even the right place
> (rather at the call site?) to wait. But at least it deserves a comment,
> I believe.

I'm not sure moving it into the caller is the right thing to do. This is something
that has to do with how interrupts are asserted, not something that is specific to
one test.

You are right about the comment, I'll add one.

Thanks,
Alex
>>  			return;
>>  		}
>>  	}
>>  
>> +	report_info("interrupts timed-out (5s)");
>> +}
>> +
>> +static bool check_acked(cpumask_t *mask)
>> +{
>> +	int missing = 0, extra = 0, unexpected = 0;
>> +	bool pass = true;
>> +	int cpu;
>> +
>>  	for_each_present_cpu(cpu) {
>>  		if (cpumask_test_cpu(cpu, mask)) {
>>  			if (!acked[cpu])
>> @@ -107,11 +108,28 @@ static void check_acked(const char *testname, cpumask_t *mask)
>>  			if (acked[cpu])
>>  				++unexpected;
>>  		}
>> +		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>> +
>> +		if (bad_sender[cpu] != -1) {
>> +			report_info("cpu%d received IPI from wrong sender %d",
>> +					cpu, bad_sender[cpu]);
>> +			pass = false;
>> +		}
>> +
>> +		if (bad_irq[cpu] != -1) {
>> +			report_info("cpu%d received wrong irq %d",
>> +					cpu, bad_irq[cpu]);
>> +			pass = false;
>> +		}
>> +	}
>> +
>> +	if (missing || extra || unexpected) {
>> +		report_info("ACKS: missing=%d extra=%d unexpected=%d",
>> +				missing, extra, unexpected);
>> +		pass = false;
> Thanks, that so much easier to read now.
>
> Cheers,
> Andre
>
>>  	}
>>  
>> -	report(false, "%s", testname);
>> -	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
>> -		    missing, extra, unexpected);
>> +	return pass;
>>  }
>>  
>>  static void check_spurious(void)
>> @@ -303,7 +321,8 @@ static void ipi_test_self(void)
>>  	cpumask_clear(&mask);
>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>  	gic->ipi.send_self();
>> -	check_acked("IPI: self", &mask);
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask), "Interrupts received");
>>  	report_prefix_pop();
>>  }
>>  
>> @@ -318,7 +337,8 @@ static void ipi_test_smp(void)
>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>  		cpumask_clear_cpu(i, &mask);
>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>> -	check_acked("IPI: directed", &mask);
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask), "Interrupts received");
>>  	report_prefix_pop();
>>  
>>  	report_prefix_push("broadcast");
>> @@ -326,7 +346,8 @@ static void ipi_test_smp(void)
>>  	cpumask_copy(&mask, &cpu_present_mask);
>>  	cpumask_clear_cpu(smp_processor_id(), &mask);
>>  	gic->ipi.send_broadcast();
>> -	check_acked("IPI: broadcast", &mask);
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask), "Interrupts received");
>>  	report_prefix_pop();
>>  }
>>  
>>
