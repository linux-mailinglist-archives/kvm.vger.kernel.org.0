Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849376735AB
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjASKg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 05:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjASKgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 05:36:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E71AD676C6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 02:35:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5164176A;
        Thu, 19 Jan 2023 02:36:19 -0800 (PST)
Received: from arm.com (e121798.cambridge.arm.com [10.1.196.158])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEB093F71A;
        Thu, 19 Jan 2023 02:35:37 -0800 (PST)
Date:   Thu, 19 Jan 2023 10:35:35 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 2/2] arm/psci: Add PSCI CPU_OFF test
 case
Message-ID: <Y8kc92nC4tiVXNfs@arm.com>
References: <20230118144912.32049-1-alexandru.elisei@arm.com>
 <20230118144912.32049-3-alexandru.elisei@arm.com>
 <20230118184821.frpeemjwt4ey6m7v@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118184821.frpeemjwt4ey6m7v@orel>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Wed, Jan 18, 2023 at 07:48:21PM +0100, Andrew Jones wrote:
> On Wed, Jan 18, 2023 at 02:49:12PM +0000, Alexandru Elisei wrote:
> > From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> > 
> > The test uses the following method.
> > 
> > The primary CPU brings up all the secondary CPUs, which are held in a wait
> > loop. Once the primary releases the CPUs, each of the secondary CPUs
> > proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also the
> > status of the call is updated by the secondary CPU in cpu_off_done[].
> > 
> > The primary CPU waits for all the secondary CPUs to update the cpumask and
> > then proceeds to check for the status of the individual CPU CPU_OFF
> > request. There is a chance that some CPUs might fail at the CPU_OFF request
> > and come back and update the status once the primary CPU has finished the
> > scan. There is no fool proof method to handle this. As of now, we add a
> > 1sec delay between the cpumask check and the scan for the status.
> > 
> > Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> > [ Alex E: Skip CPU_OFF test if CPU_ON failed ]
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/psci.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 66 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arm/psci.c b/arm/psci.c
> > index e96be941953b..d045616bfcd4 100644
> > --- a/arm/psci.c
> > +++ b/arm/psci.c
> > @@ -15,6 +15,8 @@
> >  #include <asm/psci.h>
> >  #include <asm/smp.h>
> >  
> > +#define CPU_OFF_TEST_WAIT_TIME 1000
> > +
> >  static bool invalid_function_exception;
> >  
> >  #ifdef __arm__
> > @@ -71,8 +73,10 @@ static bool psci_affinity_info_off(void)
> >  }
> >  
> >  static int cpu_on_ret[NR_CPUS];
> > -static cpumask_t cpu_on_ready, cpu_on_done;
> > +static bool cpu_off_success[NR_CPUS];
> > +static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
> >  static volatile int cpu_on_start;
> > +static volatile int cpu_off_start;
> >  
> >  extern void secondary_entry(void);
> >  static void cpu_on_do_wake_target(void)
> > @@ -94,6 +98,20 @@ static void cpu_on_target(void)
> >  	cpumask_set_cpu(cpu, &cpu_on_done);
> >  }
> >  
> > +static void cpu_off_secondary_entry(void *data)
> > +{
> > +	int cpu = smp_processor_id();
> > +
> > +	while (!cpu_off_start)
> > +		cpu_relax();
> > +	/* On to the CPU off test */
> > +	cpu_off_success[cpu] = true;
> > +	cpumask_set_cpu(cpu, &cpu_off_done);
> > +	cpu_psci_cpu_die();
> > +	/* The CPU shouldn't execute the next steps. */
> > +	cpu_off_success[cpu] = false;
> > +}
> > +
> >  static bool psci_cpu_on_test(void)
> >  {
> >  	bool failed = false;
> > @@ -162,9 +180,45 @@ out:
> >  	return !failed;
> >  }
> >  
> > -int main(void)
> > +static bool psci_cpu_off_test(void)
> > +{
> > +	bool failed = false;
> > +	int cpu;
> > +
> > +	for_each_present_cpu(cpu) {
> > +		if (cpu == 0)
> > +			continue;
> > +		on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
> > +	}
> > +
> > +	cpumask_set_cpu(0, &cpu_off_done);
> 
> Since we're setting cpu_off_done for cpu0, then we could also set
> cpu_off_success[0] = true and not have to skip it in the check loop
> below.

I would prefer not to, since CPU 0 never invokes CPU_OFF for itself and setting
cpu_off_success to true for CPU 0 might get confusing. Unless you insist :)

> 
> > +
> > +	report_info("starting CPU_OFF test...");
> > +
> > +	cpu_off_start = 1;
> > +	while (!cpumask_full(&cpu_off_done))
> > +		cpu_relax();
> > +
> > +	/* Allow all the other CPUs to complete the operation */
> > +	mdelay(CPU_OFF_TEST_WAIT_TIME);
> 
> Don't really need the define, just the numbers work for stuff
> like this, but OK.

I'll get rid of the define.

You ok with waiting for 1 second for each test run? I remember you had
objections when I added a similar delay to the timer tests.

> 
> > +
> > +	for_each_present_cpu(cpu) {
> > +		if (cpu == 0)
> > +			continue;
> > +
> > +		if (!cpu_off_success[cpu]) {
> > +			report_info("CPU%d could not be turned off", cpu);
> > +			failed = true;
> > +		}
> > +	}
> > +
> > +	return !failed;
> > +}
> > +
> > +int main(int argc, char **argv)
> >  {
> >  	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> > +	bool cpu_on_success = true;
> >  
> >  	report_prefix_push("psci");
> >  
> > @@ -179,10 +233,17 @@ int main(void)
> >  	report(psci_affinity_info_on(), "affinity-info-on");
> >  	report(psci_affinity_info_off(), "affinity-info-off");
> >  
> > -	if (ERRATA(6c7a5dce22b3))
> > -		report(psci_cpu_on_test(), "cpu-on");
> > -	else
> > +	if (ERRATA(6c7a5dce22b3)) {
> > +		cpu_on_success = psci_cpu_on_test();
> > +		report(cpu_on_success, "cpu-on");
> > +	} else {
> >  		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> > +	}
> > +
> > +	if (!cpu_on_success)
> > +		report_skip("Skipping cpu-off test because the cpu-on test failed");
> > +	else
> > +		report(psci_cpu_off_test(), "cpu-off");
> >  
> >  done:
> >  #if 0
> > -- 
> > 2.25.1
> > 
> 
> Besides the nits,
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks!

Alex

> 
> Thanks,
> drew
