Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F11673587
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjASKcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 05:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjASKcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 05:32:13 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56DA23ABA
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 02:32:11 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 728FD176A;
        Thu, 19 Jan 2023 02:32:52 -0800 (PST)
Received: from arm.com (e121798.cambridge.arm.com [10.1.196.158])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58AE13F71A;
        Thu, 19 Jan 2023 02:32:10 -0800 (PST)
Date:   Thu, 19 Jan 2023 10:32:07 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 1/2] arm/psci: Test that CPU 1 has been
 successfully brought online
Message-ID: <Y8kcJ9P5brmPEpS1@arm.com>
References: <20230118144912.32049-1-alexandru.elisei@arm.com>
 <20230118144912.32049-2-alexandru.elisei@arm.com>
 <20230118183512.xlwukqsg5i3wzfnv@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118183512.xlwukqsg5i3wzfnv@orel>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

Thanks for the quick review!

On Wed, Jan 18, 2023 at 07:35:12PM +0100, Andrew Jones wrote:
> On Wed, Jan 18, 2023 at 02:49:11PM +0000, Alexandru Elisei wrote:
> > For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
> > that target CPU 1. The test is considered a success if CPU_ON returns PSCI
> > SUCCESS exactly once, and for the rest of the calls PSCI ALREADY_ON.
> > 
> > Enhance the test by checking that CPU 1 is actually online and able to
> > execute code. Also make the test more robust by checking that the CPU_ON
> > call returns, instead of assuming that it will always succeed and
> > hanging indefinitely if it doesn't.
> > 
> > Since the CPU 1 thread is now being set up properly by kvm-unit-tests
> > when being brought online, it becomes possible to add other tests in the
> > future that require all CPUs.
> > 
> > The include header order in arm/psci.c has been changed to be in
> > alphabetic order. This means moving the errata.h include before
> > libcflat.h, which causes compilation to fail because of missing includes
> > in errata.h. Fix that also by including the needed header in errata.h.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/psci.c        | 60 ++++++++++++++++++++++++++++++++++++-----------
> >  lib/arm/asm/smp.h |  1 +
> >  lib/arm/smp.c     | 12 +++++++---
> >  lib/errata.h      |  2 ++
> >  4 files changed, 58 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arm/psci.c b/arm/psci.c
> > index efa0722c0566..e96be941953b 100644
> > --- a/arm/psci.c
> > +++ b/arm/psci.c
> > @@ -7,11 +7,13 @@
> >   *
> >   * This work is licensed under the terms of the GNU LGPL, version 2.
> >   */
> > -#include <libcflat.h>
> >  #include <errata.h>
> > +#include <libcflat.h>
> > +
> > +#include <asm/delay.h>
> >  #include <asm/processor.h>
> > -#include <asm/smp.h>
> >  #include <asm/psci.h>
> > +#include <asm/smp.h>
> >  
> >  static bool invalid_function_exception;
> >  
> > @@ -72,14 +74,23 @@ static int cpu_on_ret[NR_CPUS];
> >  static cpumask_t cpu_on_ready, cpu_on_done;
> >  static volatile int cpu_on_start;
> >  
> > -static void cpu_on_secondary_entry(void)
> > +extern void secondary_entry(void);
> > +static void cpu_on_do_wake_target(void)
> >  {
> >  	int cpu = smp_processor_id();
> >  
> >  	cpumask_set_cpu(cpu, &cpu_on_ready);
> >  	while (!cpu_on_start)
> >  		cpu_relax();
> > -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
> > +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(secondary_entry));
> > +	cpumask_set_cpu(cpu, &cpu_on_done);
> > +}
> > +
> > +static void cpu_on_target(void)
> > +{
> > +	int cpu = smp_processor_id();
> > +
> > +	cpu_on_ret[cpu] = PSCI_RET_ALREADY_ON;
> 
> I'm not sure this is better than just skipping cpu1 in the check loop, as
> is done now, but OK. 

I think that's a good idea, I'll remove this and skip CPU 1 in the check
loop, because CPU 1 never invokes psci_cpu_on for itself.

> 
> >  	cpumask_set_cpu(cpu, &cpu_on_done);
> >  }
> >  
> > @@ -87,33 +98,53 @@ static bool psci_cpu_on_test(void)
> >  {
> >  	bool failed = false;
> >  	int ret_success = 0;
> > -	int cpu;
> > -
> > -	cpumask_set_cpu(1, &cpu_on_ready);
> > -	cpumask_set_cpu(1, &cpu_on_done);
> > +	int i, cpu;
> >  
> >  	for_each_present_cpu(cpu) {
> >  		if (cpu < 2)
> >  			continue;
> > -		smp_boot_secondary(cpu, cpu_on_secondary_entry);
> > +		smp_boot_secondary(cpu, cpu_on_do_wake_target);
> >  	}
> >  
> >  	cpumask_set_cpu(0, &cpu_on_ready);
> > +	cpumask_set_cpu(1, &cpu_on_ready);
> >  	while (!cpumask_full(&cpu_on_ready))
> >  		cpu_relax();
> >  
> > +	/*
> > +	 * Wait for all other CPUs to be online before configuring the thread
> > +	 * for the target CPU, as all secondaries are set up using the same
> > +	 * global variable.
> > +	 */
> 
> This comment says "Wait", so I'd move the while loop under it.

Can I reword it to keep it here?

	/*
	 * Configure CPU 1 after all the secondaries are online to avoid
	 * secondary_data being overwritten.
	 */

What do you think?

> 
> > +	smp_prepare_secondary(1, cpu_on_target);
> 
> This new smp_prepare_secondary() function should be local to this unit
> test, please see my justification below.

Reply below.

> 
> > +
> >  	cpu_on_start = 1;
> >  	smp_mb();
> >  
> > -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
> > +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(secondary_entry));
> >  	cpumask_set_cpu(0, &cpu_on_done);
> >  
> > -	while (!cpumask_full(&cpu_on_done))
> > -		cpu_relax();
> > +	report_info("waiting for CPU1 to come online...");
> > +	for (i = 0; i < 10; i++) {
> > +		mdelay(100);
> > +		if (cpumask_full(&cpu_on_done))
> > +			break;
> > +	}
> > +
> > +	if (!cpumask_full(&cpu_on_done)) {
> > +		for_each_present_cpu(cpu) {
> > +			if (!cpumask_test_cpu(cpu, &cpu_on_done)) {
> > +				if (cpu == 1)
> > +					report_info("CPU1 failed to come online");
> > +				else
> > +					report_info("CPU%d failed to online CPU1", cpu);
> > +			}
> > +		}
> > +		failed = true;
> > +		goto out;
> 
> We could still run the other checks below, perhaps guarded with
> cpumask_test_cpu(cpu, &cpu_on_done), rather than bail early. I'm
> also OK with bailing early though. But, for that, I'd just return
> false right here rather than introduce the goto.

I like the idea of checking the return value for the CPU_ON calls that have
returned (I'll use for_each_cpu(cpu, &cpu_on _done) in the for loop below).

> 
> > +	}
> >  
> >  	for_each_present_cpu(cpu) {
> > -		if (cpu == 1)
> > -			continue;
> >  		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
> >  			ret_success++;
> >  		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
> > @@ -127,6 +158,7 @@ static bool psci_cpu_on_test(void)
> >  		failed = true;
> >  	}
> >  
> > +out:
> >  	return !failed;
> >  }
> >  
> > diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> > index 077afde85520..ff2ef8f88247 100644
> > --- a/lib/arm/asm/smp.h
> > +++ b/lib/arm/asm/smp.h
> > @@ -49,6 +49,7 @@ static inline void set_cpu_idle(int cpu, bool idle)
> >  }
> >  
> >  typedef void (*secondary_entry_fn)(void);
> > +extern void smp_prepare_secondary(int cpu, secondary_entry_fn entry);
> >  extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
> >  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
> >  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
> > diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> > index 98a5054e039b..947f417f4aea 100644
> > --- a/lib/arm/smp.c
> > +++ b/lib/arm/smp.c
> > @@ -58,13 +58,19 @@ secondary_entry_fn secondary_cinit(void)
> >  	return entry;
> >  }
> >  
> > -static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
> > +void smp_prepare_secondary(int cpu, secondary_entry_fn entry)
> 
> I'd rather not create an unsafe library function, especially one named
> without the leading underscores. It's OK for a unit test to duplicate
> __smp_boot_secondary() (secondary_data is available), but then the unit
> test also needs to ensure it does its own synchronization, as you do
> with the wait on cpu_on_ready already.

I created the function to share the code between __smp_boot_secondary and
the PSCI test. Cache maintenance would have to be added here (one CPU
writes to secondary_data, another CPU reads from it, possible with the MMU
off), and I would prefer to keep it in one place, in the library code,
rather than expose the boot cache maintenance requirements to tests.

If I rename it to __smp_boot_secondary(), would you find that acceptable?

Thanks,
Alex

> 
> >  {
> > -	int ret;
> > -
> >  	secondary_data.stack = thread_stack_alloc();
> >  	secondary_data.entry = entry;
> >  	mmu_mark_disabled(cpu);
> > +}
> > +
> > +static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
> > +{
> > +	int ret;
> > +
> > +	smp_prepare_secondary(cpu, entry);
> > +
> >  	ret = cpu_psci_cpu_boot(cpu);
> >  	assert(ret == 0);
> >  
> > diff --git a/lib/errata.h b/lib/errata.h
> > index 5af0eb3bf8e2..de8205d8b370 100644
> > --- a/lib/errata.h
> > +++ b/lib/errata.h
> > @@ -6,6 +6,8 @@
> >   */
> >  #ifndef _ERRATA_H_
> >  #define _ERRATA_H_
> > +#include <libcflat.h>
> > +
> >  #include "config.h"
> >  
> >  #ifndef CONFIG_ERRATA_FORCE
> > -- 
> > 2.25.1
> >
> 
> Thanks,
> drew
