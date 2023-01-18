Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA7672774
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjARSs2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 13:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjARSs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 13:48:26 -0500
Received: from out-215.mta0.migadu.com (out-215.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3ED16317
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 10:48:25 -0800 (PST)
Date:   Wed, 18 Jan 2023 19:48:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674067703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wrnMfvqHg1QKur3G2dv42qbg74ikci7ZEQclhCr2Z6M=;
        b=XY4gnXtDPXlp6arUKF5WJcNTOBmT9KAu02hUUy1/GNl63kkHbRLIvIqcw9j//TEqXcAtrI
        ZZ6pav2iHIlPkOv29Nhp6uW/bKjVaqb5AHBzNeqpUgn7jYUUY1gBzZlOtmhM8eG/ChHhrb
        JOWTdxsWza9Zcg6oCd0OG5u3SI2yB2E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 2/2] arm/psci: Add PSCI CPU_OFF test
 case
Message-ID: <20230118184821.frpeemjwt4ey6m7v@orel>
References: <20230118144912.32049-1-alexandru.elisei@arm.com>
 <20230118144912.32049-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118144912.32049-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 02:49:12PM +0000, Alexandru Elisei wrote:
> From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> 
> The test uses the following method.
> 
> The primary CPU brings up all the secondary CPUs, which are held in a wait
> loop. Once the primary releases the CPUs, each of the secondary CPUs
> proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also the
> status of the call is updated by the secondary CPU in cpu_off_done[].
> 
> The primary CPU waits for all the secondary CPUs to update the cpumask and
> then proceeds to check for the status of the individual CPU CPU_OFF
> request. There is a chance that some CPUs might fail at the CPU_OFF request
> and come back and update the status once the primary CPU has finished the
> scan. There is no fool proof method to handle this. As of now, we add a
> 1sec delay between the cpumask check and the scan for the status.
> 
> Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> [ Alex E: Skip CPU_OFF test if CPU_ON failed ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/psci.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 66 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index e96be941953b..d045616bfcd4 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -15,6 +15,8 @@
>  #include <asm/psci.h>
>  #include <asm/smp.h>
>  
> +#define CPU_OFF_TEST_WAIT_TIME 1000
> +
>  static bool invalid_function_exception;
>  
>  #ifdef __arm__
> @@ -71,8 +73,10 @@ static bool psci_affinity_info_off(void)
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
>  static void cpu_on_do_wake_target(void)
> @@ -94,6 +98,20 @@ static void cpu_on_target(void)
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
> @@ -162,9 +180,45 @@ out:
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

Since we're setting cpu_off_done for cpu0, then we could also set
cpu_off_success[0] = true and not have to skip it in the check loop
below.

> +
> +	report_info("starting CPU_OFF test...");
> +
> +	cpu_off_start = 1;
> +	while (!cpumask_full(&cpu_off_done))
> +		cpu_relax();
> +
> +	/* Allow all the other CPUs to complete the operation */
> +	mdelay(CPU_OFF_TEST_WAIT_TIME);

Don't really need the define, just the numbers work for stuff
like this, but OK.

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
> +
> +	return !failed;
> +}
> +
> +int main(int argc, char **argv)
>  {
>  	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> +	bool cpu_on_success = true;
>  
>  	report_prefix_push("psci");
>  
> @@ -179,10 +233,17 @@ int main(void)
>  	report(psci_affinity_info_on(), "affinity-info-on");
>  	report(psci_affinity_info_off(), "affinity-info-off");
>  
> -	if (ERRATA(6c7a5dce22b3))
> -		report(psci_cpu_on_test(), "cpu-on");
> -	else
> +	if (ERRATA(6c7a5dce22b3)) {
> +		cpu_on_success = psci_cpu_on_test();
> +		report(cpu_on_success, "cpu-on");
> +	} else {
>  		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> +	}
> +
> +	if (!cpu_on_success)
> +		report_skip("Skipping cpu-off test because the cpu-on test failed");
> +	else
> +		report(psci_cpu_off_test(), "cpu-off");
>  
>  done:
>  #if 0
> -- 
> 2.25.1
> 

Besides the nits,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
