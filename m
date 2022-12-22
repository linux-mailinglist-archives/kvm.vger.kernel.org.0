Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879646545B9
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 18:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiLVRs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 12:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLVRs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 12:48:26 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E200628E12
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 09:48:24 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 628482F4;
        Thu, 22 Dec 2022 09:49:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F3B33FAFB;
        Thu, 22 Dec 2022 09:48:22 -0800 (PST)
Date:   Thu, 22 Dec 2022 17:48:12 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, nd@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 2/2] arm/psci: Add PSCI_CPU_OFF
 testscase to arm/psci testsuite
Message-ID: <Y6SYXNsF616Brf/Q@monolith.localdoman>
References: <20221220143156.208143-1-Nikita.Venkatesh@arm.com>
 <20221220143156.208143-3-Nikita.Venkatesh@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220143156.208143-3-Nikita.Venkatesh@arm.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Dec 20, 2022 at 02:31:56PM +0000, Nikita Venkatesh wrote:
> The test uses the following method.
> 
> The primary CPU brings up all the secondary CPUs, which are held in a wait
> loop. Once the primary releases the CPUs, each of the secondary CPUs
> proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
> the status of the call is updated by the secondary CPU in cpu_off_done[].
> 
> The primary CPU waits for all the secondary CPUs to update the cpumask
> and then proceeds to check for the status of the individual CPU CPU_OFF
> request. There is a chance that some CPUs might fail at the CPU_OFF
> request and come back and update the status once the primary CPU has
> finished the scan. There is no fool proof method to handle this. As of
> now, we add a 1sec delay between the cpumask check and the scan for the
> status.
> 
> The test can be triggered by "cpu-off" command line argument.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I don't think that's true anymore.

> 
> Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> ---
>  arm/psci.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 84 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index 0b9834c..8e664c2 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -12,6 +12,9 @@
>  #include <asm/processor.h>
>  #include <asm/smp.h>
>  #include <asm/psci.h>
> +#include <asm/delay.h>
> +
> +#define CPU_OFF_TEST_WAIT_TIME 1000
>  
>  static bool invalid_function_exception;
>  
> @@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
>  }
>  
>  static int cpu_on_ret[NR_CPUS];
> -static cpumask_t cpu_on_ready, cpu_on_done;
> +static bool cpu_off_success[NR_CPUS];
> +static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
>  static volatile int cpu_on_start;
> +static volatile int cpu_off_start;
>  
>  extern void secondary_entry(void);
>  static void cpu_on_wake_target(void)
> @@ -92,11 +97,25 @@ static void cpu_on_target(void)
>  	cpumask_set_cpu(cpu, &cpu_on_done);
>  }
>  
> +static void cpu_off_secondary_entry(void *data)
> +{
> +	int cpu = smp_processor_id();
> +
> +	while (!cpu_off_start)
> +		cpu_relax();
> +	/* On to the CPU off test */
> +	cpu_off_success[cpu] = true;
> +	cpumask_set_cpu(cpu, &cpu_off_done);
> +	cpu_psci_cpu_die();
> +	/* The CPU shouldn't execute the next steps. */
> +	cpu_off_success[cpu] = false;
> +}
> +
>  static bool psci_cpu_on_test(void)
>  {
>  	bool failed = false;
>  	int ret_success = 0;
> -	int cpu;
> +	int i, cpu;
>  
>  	for_each_present_cpu(cpu) {
>  		if (cpu < 2)
> @@ -125,6 +144,25 @@ static bool psci_cpu_on_test(void)
>  	while (!cpumask_full(&cpu_on_done))
>  		cpu_relax();
>  
> +	report_info("waiting for CPU1 to come online...");
> +	for (i = 0; i < 10; i++) {
> +		mdelay(100);
> +		if (cpumask_full(&cpu_on_done))
> +			break;
> +	}
> +
> +	if (!cpumask_full(&cpu_on_done)) {
> +		for_each_present_cpu(cpu) {
> +			if (!cpumask_test_cpu(cpu, &cpu_on_done)) {
> +				if (cpu == 1)
> +					report_info("CPU1 failed to come online");
> +				else
> +					report_info("CPU%d failed to online CPU1", cpu);
> +			}
> +		}
> +		return false;
> +	}
> +

This change should be part of the previous patch.

>  	for_each_present_cpu(cpu) {
>  		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
>  			ret_success++;
> @@ -142,7 +180,44 @@ static bool psci_cpu_on_test(void)
>  	return !failed;
>  }
>  
> -int main(void)
> +static bool psci_cpu_off_test(void)
> +{
> +	bool failed = false;
> +	int cpu;
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == 0)
> +			continue;
> +		on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
> +	}
> +
> +	cpumask_set_cpu(0, &cpu_off_done);
> +
> +	report_info("starting CPU_OFF test...");
> +
> +	/* Release the CPUs */
> +	cpu_off_start = 1;
> +
> +	/* Wait until all are done */
> +	while (!cpumask_full(&cpu_off_done))
> +		cpu_relax();
> +
> +	/* Allow all the other CPUs to complete the operation */
> +	mdelay(CPU_OFF_TEST_WAIT_TIME);
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == 0)
> +			continue;
> +
> +		if (!cpu_off_success[cpu]) {
> +			report_info("CPU%d could not be turned off", cpu);
> +			failed = true;
> +		}
> +	}
> +	return !failed;
> +}
> +
> +int main(int argc, char **argv)
>  {
>  	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
>  
> @@ -154,15 +229,18 @@ int main(void)
>  	}
>  
>  	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
> -					  PSCI_VERSION_MINOR(ver));
> +					PSCI_VERSION_MINOR(ver));

This change is unneeded. Whitespace change?

> +
>  	report(psci_invalid_function(), "invalid-function");
>  	report(psci_affinity_info_on(), "affinity-info-on");
>  	report(psci_affinity_info_off(), "affinity-info-off");
>  
> -	if (ERRATA(6c7a5dce22b3))
> +	if (ERRATA(6c7a5dce22b3)){
>  		report(psci_cpu_on_test(), "cpu-on");
> -	else
> +	} else {
>  		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> +	}

The adition of braces here seems unnecessary. Is it by any chance a
leftover from the previous version of the patches, where they were
necessary?

Otherwise, the patches look good, also ran a few tests for good measure.

Thanks,
Alex

> +	report(psci_cpu_off_test(), "cpu-off");
>  
>  done:
>  #if 0
> -- 
> 2.25.1
> 
