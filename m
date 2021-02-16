Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB031CFDC
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 19:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBPSGz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 Feb 2021 13:06:55 -0500
Received: from foss.arm.com ([217.140.110.172]:40474 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhBPSGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 13:06:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1E79101E;
        Tue, 16 Feb 2021 10:06:00 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D16F33F73B;
        Tue, 16 Feb 2021 10:05:59 -0800 (PST)
Date:   Tue, 16 Feb 2021 18:04:48 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH v2 08/12] arm/arm64: gic: Split
 check_acked() into two functions
Message-ID: <20210216180448.20fe4e59@slackpad.fritz.box>
In-Reply-To: <b4c0b997-bb96-6ee9-c959-ec9c1bd2258f@arm.com>
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
        <20201217141400.106137-9-alexandru.elisei@arm.com>
        <3539c229-fd05-2e1c-2159-995e51e2dcc4@arm.com>
        <857a3c2d-772b-0d29-536c-41a829ab8954@arm.com>
        <20210127151051.3e4298f9@slackpad.fritz.box>
        <b4c0b997-bb96-6ee9-c959-ec9c1bd2258f@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jan 2021 16:00:46 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> On 1/27/21 3:10 PM, Andre Przywara wrote:
> > On Mon, 25 Jan 2021 17:27:35 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi Alex,
> >  
> >> On 12/18/20 3:52 PM, André Przywara wrote:  
> >>> On 17/12/2020 14:13, Alexandru Elisei wrote:    
> >>>> check_acked() has several peculiarities: is the only function among the
> >>>> check_* functions which calls report() directly, it does two things
> >>>> (waits for interrupts and checks for misfired interrupts) and it also
> >>>> mixes printf, report_info and report calls.
> >>>>
> >>>> check_acked() also reports a pass and returns as soon all the target CPUs
> >>>> have received interrupts, However, a CPU not having received an interrupt
> >>>> *now* does not guarantee not receiving an erroneous interrupt if we wait
> >>>> long enough.
> >>>>
> >>>> Rework the function by splitting it into two separate functions, each with
> >>>> a single responsibility: wait_for_interrupts(), which waits for the
> >>>> expected interrupts to fire, and check_acked() which checks that interrupts
> >>>> have been received as expected.
> >>>>
> >>>> wait_for_interrupts() also waits an extra 100 milliseconds after the
> >>>> expected interrupts have been received in an effort to make sure we don't
> >>>> miss misfiring interrupts.
> >>>>
> >>>> Splitting check_acked() into two functions will also allow us to
> >>>> customize the behavior of each function in the future more easily
> >>>> without using an unnecessarily long list of arguments for check_acked().    
> >>> Yes, splitting this up looks much better, in general this is a nice
> >>> cleanup, thank you!
> >>>
> >>> Some comments below:
> >>>    
> >>>> CC: Andre Przywara <andre.przywara@arm.com>
> >>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>> ---
> >>>>  arm/gic.c | 73 +++++++++++++++++++++++++++++++++++--------------------
> >>>>  1 file changed, 47 insertions(+), 26 deletions(-)
> >>>>
> >>>> diff --git a/arm/gic.c b/arm/gic.c
> >>>> index ec733719c776..a9ef1a5def56 100644
> >>>> --- a/arm/gic.c
> >>>> +++ b/arm/gic.c
> >>>> @@ -62,41 +62,42 @@ static void stats_reset(void)
> >>>>  	}
> >>>>  }
> >>>>  
> >>>> -static void check_acked(const char *testname, cpumask_t *mask)
> >>>> +static void wait_for_interrupts(cpumask_t *mask)
> >>>>  {
> >>>> -	int missing = 0, extra = 0, unexpected = 0;
> >>>>  	int nr_pass, cpu, i;
> >>>> -	bool bad = false;
> >>>>  
> >>>>  	/* Wait up to 5s for all interrupts to be delivered */
> >>>> -	for (i = 0; i < 50; ++i) {
> >>>> +	for (i = 0; i < 50; i++) {
> >>>>  		mdelay(100);
> >>>>  		nr_pass = 0;
> >>>>  		for_each_present_cpu(cpu) {
> >>>> +			/*
> >>>> +			 * A CPU having received more than one interrupts will
> >>>> +			 * show up in check_acked(), and no matter how long we
> >>>> +			 * wait it cannot un-receive it. Consider at least one
> >>>> +			 * interrupt as a pass.
> >>>> +			 */
> >>>>  			nr_pass += cpumask_test_cpu(cpu, mask) ?
> >>>> -				acked[cpu] == 1 : acked[cpu] == 0;
> >>>> -			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
> >>>> -
> >>>> -			if (bad_sender[cpu] != -1) {
> >>>> -				printf("cpu%d received IPI from wrong sender %d\n",
> >>>> -					cpu, bad_sender[cpu]);
> >>>> -				bad = true;
> >>>> -			}
> >>>> -
> >>>> -			if (bad_irq[cpu] != -1) {
> >>>> -				printf("cpu%d received wrong irq %d\n",
> >>>> -					cpu, bad_irq[cpu]);
> >>>> -				bad = true;
> >>>> -			}
> >>>> +				acked[cpu] >= 1 : acked[cpu] == 0;    
> >>> I wonder if this logic was already flawed to begin with: For interrupts
> >>> we expect to fire, we wait for up to 5 seconds (really that long?), but
> >>> for interrupts we expect *not* to fire we are OK if they don't show up
> >>> in the first 100 ms. That does not sound consistent.    
> >> There are two ways that I see to fix this:
> >>
> >> - Have the caller wait for however long it sees fit, and *after* that waiting
> >> period call wait_for_interrupts().
> >>
> >> - Pass a flag to wait_for_interrupts() to specify that the behaviour should be to
> >> wait for the entire duration instead of until the expected interrupts have been
> >> received.
> >>
> >> Neither sounds appealing to me for inclusion in this patch set, since I want to
> >> concentrate on reworking check_acked() while keeping much of the current behaviour
> >> intact.
> >>  
> >>> I am wondering if we should *not* have the initial 100ms wait at all,
> >>> since most interrupts will fire immediately (especially in KVM). And
> >>> then have *one* extra wait for, say 100ms, to cover latecomers and
> >>> spurious interrupts.    
> >> I don't think it really matters where the 100 millisecond delay is in the loop.  
> > I think it does. I ran tests with 256 vCPUs, I think we support even
> > more, and running k-u-t on those setups is one of the cases where it
> > really matters and we can find real bugs.
> > So 100ms on their own does not sound much, but it means we wait at least
> > 25.6 seconds, even if everything is fine. I found this scary, confusing
> > and annoying (in that order), so was wondering if we can avoid that.  
> 
> I'm not sure where that 25.6 second delay is coming from. The mdelay() is at the
> start of the for loop, *before* the for_each_cpu() loop, so it's not executed for
> each VCPU.

I think that comes from some other patches of mine, which call the test
on *each* VCPU. There this small delay adds up.

> I've also run the ipi test on my rockpro64 with 256 vcpus with kvmtool and I
> didn't notice any unexpected delays.

Thanks for doing that.

> >> If
> >> we call wait_for_interrupts() to actually check that interrupts have fired (as
> >> opposed to checking that they haven't been asserted), then at most we save 100ms
> >> when they are asserted before the start of the loop. I don't think the GIC spec
> >> guarantees that interrupts written to the LR registers will be presented to the
> >> CPU after the guest resumes,  
> > I don't know if the spec says anything about it, I guess it would be
> > out of scope to do so there anyway, but AFAIK this is exactly how it's
> > implemented: when we drop to EL1 with the VGIC armed, the GIC jumps in
> > before the guest executes the first instruction (that ELR_EL2 points
> > to), and raises the IRQ exception in EL1.
> >  
> >> so it is conceivable that there might be a delay,  
> > The only practical reason for a delay would be PSTATE.I being set, or
> > the GICV being disabled, I think.
> >
> > I would say one would expect interrupts to fire *immediately*, and
> > allowing them 100ms slack does not sound like the right thing. If there
> > is some delay, I would at least like to know about it. And I would
> > grant them a few instructions delay, at best.  
> 
> I think you're forgetting the fact that the interrupts are delivered to the other
> VCPUs, not to the VCPU that is calling wait_for_interrupts().

That is one use case, but for the IPI self test we do this on the
same VCPU. My concern was just that those functions are generic, so
should cater for any kind of interrupt tests thrown at them. And as
mentioned above, I had tests which got delayed by the mandatory wait.

For the records: I was coming from my manual testing during the VGIC
development/rework a few years back, where some bugs only showed under
(heavy) *parallel* interrupt load. So I guess I am a bit biased when it
comes to that.

But this is indeed of no concern for what we currently have, so I guess
I will just revisit this as needed, should we get more sophisticated
tests.

Which means the changes here are fine on their own and are definitely
an improvement, so we should go ahead with that.

Cheers,
Andre


> So it's the
> interrupt handlers running on the other VCPUs that update acked, which afterwards
> is read in wait_for_interrupts().
> 
> As an experiment, I moved the mdelay() at the end of the loop and I tried running
> the IPI test with 2 and 256 VCPUs:
> 
> $ taskset -c 4,5 ~/lkvm-static run -c2 -m128 -f arm/gic.flat -p 'ipi'
>   # lkvm run --firmware arm/gic.flat -m 128 -c 2 --name guest-1720
>   Info: Placing fdt at 0x80200000 - 0x80210000
> chr_testdev_init: chr-testdev: can't find a virtio-console
> PASS: gicv3: ipi: self: Interrupts received
> INFO: gicv3: ipi: target-list: interrupts took more than 100 ms
> PASS: gicv3: ipi: target-list: Interrupts received
> INFO: gicv3: ipi: broadcast: interrupts took more than 100 ms
> PASS: gicv3: ipi: broadcast: Interrupts received
> SUMMARY: 3 tests
> 
> $ taskset -c 4,5 ~/lkvm-static run -c256 -m128 -f arm/gic.flat -p 'ipi'
>   # lkvm run --firmware arm/gic.flat -m 128 -c 256 --name guest-2000
>   Info: Placing fdt at 0x80200000 - 0x80210000
>   # Warning: The maximum recommended amount of VCPUs is 6
> chr_testdev_init: chr-testdev: can't find a virtio-console
> PASS: gicv3: ipi: self: Interrupts received
> INFO: gicv3: ipi: target-list: interrupts took more than 100 ms
> PASS: gicv3: ipi: target-list: Interrupts received
> INFO: gicv3: ipi: broadcast: interrupts took more than 100 ms
> PASS: gicv3: ipi: broadcast: Interrupts received
> SUMMARY: 3 tests
> 
> For the 256 VCPUs test, on two runs I got the "interrupts took more than 100 ms"
> message for target-list, on one test I didn't (but for broadcast I always got the
> message).
> 
> For the 2 VCPUs test, I always got the message (tried it 5 times).
> 
> Thanks,
> Alex
> >
> > If you still think you need that delay, because everything else would
> > be too complicated (at least for this iteration), then please make it
> > *much* smaller (< 1us).
> >
> > Cheers,
> > Andre
> >
> >  
> >> thus ending up in waiting the extra 100ms even if the delay is at the end of the loop.
> >>
> >> There are two reasons I chose the approach of having the delay at the start of the
> >> loop:
> >>
> >> 1. To preserve the current behaviour.
> >>
> >> 2. To match what the timer test those (see gic_timer_check_state()). I am also
> >> thinking that maybe at some point we could unify these test-independent functions
> >> in the gic driver.
> >>
> >> As for the 5 seconds delay, I think we can come up with a patch to pass the delay
> >> as a parameter to the function if needed (if I remember correctly, you needed a
> >> shorter waiting period for your GIC tests).
> >>  
> >>> But this might be a topic for some extra work/patch?    
> >> Yes, I would rather make this changes when we have an actual test that needs them.
> >>  
> >>>    
> >>>>  		}
> >>>> +
> >>>>  		if (nr_pass == nr_cpus) {
> >>>> -			report(!bad, "%s", testname);
> >>>>  			if (i)
> >>>> -				report_info("took more than %d ms", i * 100);
> >>>> +				report_info("interrupts took more than %d ms", i * 100);
> >>>> +			mdelay(100);    
> >>> So this is the extra 100ms you mention in the commit message? I am not
> >>> convinced this is the right way (see above) or even the right place
> >>> (rather at the call site?) to wait. But at least it deserves a comment,
> >>> I believe.    
> >> I'm not sure moving it into the caller is the right thing to do. This is something
> >> that has to do with how interrupts are asserted, not something that is specific to
> >> one test.
> >>
> >> You are right about the comment, I'll add one.
> >>
> >> Thanks,
> >> Alex  
> >>>>  			return;
> >>>>  		}
> >>>>  	}
> >>>>  
> >>>> +	report_info("interrupts timed-out (5s)");
> >>>> +}
> >>>> +
> >>>> +static bool check_acked(cpumask_t *mask)
> >>>> +{
> >>>> +	int missing = 0, extra = 0, unexpected = 0;
> >>>> +	bool pass = true;
> >>>> +	int cpu;
> >>>> +
> >>>>  	for_each_present_cpu(cpu) {
> >>>>  		if (cpumask_test_cpu(cpu, mask)) {
> >>>>  			if (!acked[cpu])
> >>>> @@ -107,11 +108,28 @@ static void check_acked(const char *testname, cpumask_t *mask)
> >>>>  			if (acked[cpu])
> >>>>  				++unexpected;
> >>>>  		}
> >>>> +		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
> >>>> +
> >>>> +		if (bad_sender[cpu] != -1) {
> >>>> +			report_info("cpu%d received IPI from wrong sender %d",
> >>>> +					cpu, bad_sender[cpu]);
> >>>> +			pass = false;
> >>>> +		}
> >>>> +
> >>>> +		if (bad_irq[cpu] != -1) {
> >>>> +			report_info("cpu%d received wrong irq %d",
> >>>> +					cpu, bad_irq[cpu]);
> >>>> +			pass = false;
> >>>> +		}
> >>>> +	}
> >>>> +
> >>>> +	if (missing || extra || unexpected) {
> >>>> +		report_info("ACKS: missing=%d extra=%d unexpected=%d",
> >>>> +				missing, extra, unexpected);
> >>>> +		pass = false;    
> >>> Thanks, that so much easier to read now.
> >>>
> >>> Cheers,
> >>> Andre
> >>>    
> >>>>  	}
> >>>>  
> >>>> -	report(false, "%s", testname);
> >>>> -	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> >>>> -		    missing, extra, unexpected);
> >>>> +	return pass;
> >>>>  }
> >>>>  
> >>>>  static void check_spurious(void)
> >>>> @@ -303,7 +321,8 @@ static void ipi_test_self(void)
> >>>>  	cpumask_clear(&mask);
> >>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
> >>>>  	gic->ipi.send_self();
> >>>> -	check_acked("IPI: self", &mask);
> >>>> +	wait_for_interrupts(&mask);
> >>>> +	report(check_acked(&mask), "Interrupts received");
> >>>>  	report_prefix_pop();
> >>>>  }
> >>>>  
> >>>> @@ -318,7 +337,8 @@ static void ipi_test_smp(void)
> >>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> >>>>  		cpumask_clear_cpu(i, &mask);
> >>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
> >>>> -	check_acked("IPI: directed", &mask);
> >>>> +	wait_for_interrupts(&mask);
> >>>> +	report(check_acked(&mask), "Interrupts received");
> >>>>  	report_prefix_pop();
> >>>>  
> >>>>  	report_prefix_push("broadcast");
> >>>> @@ -326,7 +346,8 @@ static void ipi_test_smp(void)
> >>>>  	cpumask_copy(&mask, &cpu_present_mask);
> >>>>  	cpumask_clear_cpu(smp_processor_id(), &mask);
> >>>>  	gic->ipi.send_broadcast();
> >>>> -	check_acked("IPI: broadcast", &mask);
> >>>> +	wait_for_interrupts(&mask);
> >>>> +	report(check_acked(&mask), "Interrupts received");
> >>>>  	report_prefix_pop();
> >>>>  }
> >>>>  
> >>>>    

