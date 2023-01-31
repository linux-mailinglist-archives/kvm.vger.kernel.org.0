Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675F4682A06
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 11:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjAaKLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 05:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjAaKLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 05:11:00 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AFFA4C6CA
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 02:10:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 267102F4;
        Tue, 31 Jan 2023 01:53:50 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E1813F64C;
        Tue, 31 Jan 2023 01:53:07 -0800 (PST)
Date:   Tue, 31 Jan 2023 09:52:56 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v5 2/2] arm/psci: Add PSCI CPU_OFF test
 case
Message-ID: <Y9jk+MVEPYNC1heb@monolith.localdoman>
References: <20230127175916.65389-1-alexandru.elisei@arm.com>
 <20230127175916.65389-3-alexandru.elisei@arm.com>
 <20230131065623.7jj4a2hp44vphw5t@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131065623.7jj4a2hp44vphw5t@orel>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Jan 31, 2023 at 07:56:23AM +0100, Andrew Jones wrote:
> On Fri, Jan 27, 2023 at 05:59:16PM +0000, Alexandru Elisei wrote:
> > From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> > 
> > The test uses the following method.
> > 
> > The primary CPU brings up all the secondary CPUs, which are held in a wait
> > loop. Once the primary releases the CPUs, each of the secondary CPUs
> > proceed to issue CPU_OFF.
> > 
> > The primary CPU then checks for the status of the individual CPU_OFF
> > request. There is a chance that some CPUs might return from the CPU_OFF
> > function call after the primary CPU has finished the scan. There is no
> > foolproof method to handle this, but the test tries its best to
> > eliminate these false positives by introducing an extra delay if all the
> > CPUs are reported offline after the initial scan.
> > 
> > Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> > [ Alex E: Skip CPU_OFF test if CPU_ON failed, drop cpu_off_success in
> > 	  favour of checking AFFINITY_INFO, commit message tweaking ]
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > 
> > Decided to drop Drew's Reviewed-by tag because the changes are not trivial
> > from the previous version.
> > 
> >  arm/psci.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 75 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arm/psci.c b/arm/psci.c
> > index f7238f8e0bbd..7034d8ebe6e1 100644
> > --- a/arm/psci.c
> > +++ b/arm/psci.c
> > @@ -72,8 +72,9 @@ static bool psci_affinity_info_off(void)
> >  }
> >  
> >  static int cpu_on_ret[NR_CPUS];
> > -static cpumask_t cpu_on_ready, cpu_on_done;
> > +static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
> >  static volatile int cpu_on_start;
> > +static volatile int cpu_off_start;
> >  
> >  extern void secondary_entry(void);
> >  static void cpu_on_do_wake_target(void)
> > @@ -171,9 +172,71 @@ static bool psci_cpu_on_test(void)
> >  	return !failed;
> >  }
> >  
> > -int main(void)
> > +static void cpu_off_secondary_entry(void *data)
> > +{
> > +	int cpu = smp_processor_id();
> > +
> > +	while (!cpu_off_start)
> > +		cpu_relax();
> > +	cpumask_set_cpu(cpu, &cpu_off_done);
> > +	cpu_psci_cpu_die();
> > +}
> > +
> > +static bool psci_cpu_off_test(void)
> > +{
> > +	bool failed = false;
> > +	int i, count, cpu;
> > +
> > +	for_each_present_cpu(cpu) {
> > +		if (cpu == 0)
> > +			continue;
> > +		on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
> > +	}
> > +
> > +	cpumask_set_cpu(0, &cpu_off_done);
> > +
> > +	cpu_off_start = 1;
> > +	report_info("waiting for the CPUs to be offlined...");
> > +	while (!cpumask_full(&cpu_off_done))
> > +		cpu_relax();
> > +
> > +	/* Allow all the other CPUs to complete the operation */
> > +	for (i = 0; i < 100; i++) {
> > +		mdelay(10);
> > +
> > +		count = 0;
> > +		for_each_present_cpu(cpu) {
> > +			if (cpu == 0)
> > +				continue;
> > +			if (psci_affinity_info(cpus[cpu], 0) != PSCI_0_2_AFFINITY_LEVEL_OFF)
> > +				count++;
> > +		}
> > +		if (count > 0)
> > +			continue;
> 
> This should be
> 
> if (count == 0)
>    break;
> 
> otherwise we never leave the loop early.

Duh, don't know what I was thinking. Thanks for noticing it.

> 
> > +	}
> > +
> > +	/* Try to catch CPUs that return from CPU_OFF. */
> > +	if (count == 0)
> > +		mdelay(100);
> > +
> > +	for_each_present_cpu(cpu) {
> > +		if (cpu == 0)
> > +			continue;
> > +		if (cpu_idle(cpu)) {
> > +			report_info("CPU%d failed to be offlined", cpu);
> > +			if (psci_affinity_info(cpus[cpu], 0) == PSCI_0_2_AFFINITY_LEVEL_OFF)
> > +				report_info("AFFINITY_INFO incorrectly reports CPU%d as offline", cpu);
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
> > @@ -188,10 +251,17 @@ int main(void)
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
> 
> We should output "was skipped" when the cpu-on test was skipped, rather
> than always reporting "failed". We need two booleans, try_cpu_on_test and
> cpu_on_success.

This is not about cpu-on being a precondition for cpu-off. cpu-off makes
only one assumption, and that is that all secondaries can be onlined
successfully. Even if cpu-on is never run, cpu-off calls on_cpu_async,
which will online a secondary. This is safe even if the errata is not
present, because the errata is about concurrent CPU_ON calls for the same
VCPU, not for different VCPUs.

The cpu-off test is skipped here because it can hang indefinitely if
onlining CPU1 was not successful:

[..]
        for_each_present_cpu(cpu) {
                if (cpu == 0)
                        continue;
                on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
        }

        cpumask_set_cpu(0, &cpu_off_done);

        cpu_off_start = 1;
        report_info("waiting for the CPUs to be offlined...");
        while (!cpumask_full(&cpu_off_done))	// infinite loop if CPU1
                cpu_relax();			// cannot be onlined.

Does that make sense? Should I add a comment to make it clear why cpu-off
is skipped when cpu-on fails?

Thanks,
Alex

> 
> > +	else
> > +		report(psci_cpu_off_test(), "cpu-off");
> >  
> >  done:
> >  #if 0
> > -- 
> > 2.39.0
> > 
> 
> Thanks,
> drew
