Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC6682509
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 07:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjAaG42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 01:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAaG41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 01:56:27 -0500
Received: from out-167.mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3DF24118
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 22:56:26 -0800 (PST)
Date:   Tue, 31 Jan 2023 07:56:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675148184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sWID8ti8DVCLp0zi0ZTfUQyrTwlHOgzWWaJWeVBi0eg=;
        b=CkCu1Ez13qTGLZLLqCN+jtWn77hMWUFP5XRN9IWvjNkbu/O/qMP60J9IH2i1Lm/gicersP
        c983mrNhgQ6ESsXDxyvMNDQvLoMFGkwGuTZ5xzRrYvZToiQhO0yx/cWkPZJ/DiMGxa9Iny
        /JEezWkVbzVsRynW+hMLzELH+whz/DY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v5 2/2] arm/psci: Add PSCI CPU_OFF test
 case
Message-ID: <20230131065623.7jj4a2hp44vphw5t@orel>
References: <20230127175916.65389-1-alexandru.elisei@arm.com>
 <20230127175916.65389-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127175916.65389-3-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 05:59:16PM +0000, Alexandru Elisei wrote:
> From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> 
> The test uses the following method.
> 
> The primary CPU brings up all the secondary CPUs, which are held in a wait
> loop. Once the primary releases the CPUs, each of the secondary CPUs
> proceed to issue CPU_OFF.
> 
> The primary CPU then checks for the status of the individual CPU_OFF
> request. There is a chance that some CPUs might return from the CPU_OFF
> function call after the primary CPU has finished the scan. There is no
> foolproof method to handle this, but the test tries its best to
> eliminate these false positives by introducing an extra delay if all the
> CPUs are reported offline after the initial scan.
> 
> Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> [ Alex E: Skip CPU_OFF test if CPU_ON failed, drop cpu_off_success in
> 	  favour of checking AFFINITY_INFO, commit message tweaking ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> 
> Decided to drop Drew's Reviewed-by tag because the changes are not trivial
> from the previous version.
> 
>  arm/psci.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 75 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index f7238f8e0bbd..7034d8ebe6e1 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -72,8 +72,9 @@ static bool psci_affinity_info_off(void)
>  }
>  
>  static int cpu_on_ret[NR_CPUS];
> -static cpumask_t cpu_on_ready, cpu_on_done;
> +static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
>  static volatile int cpu_on_start;
> +static volatile int cpu_off_start;
>  
>  extern void secondary_entry(void);
>  static void cpu_on_do_wake_target(void)
> @@ -171,9 +172,71 @@ static bool psci_cpu_on_test(void)
>  	return !failed;
>  }
>  
> -int main(void)
> +static void cpu_off_secondary_entry(void *data)
> +{
> +	int cpu = smp_processor_id();
> +
> +	while (!cpu_off_start)
> +		cpu_relax();
> +	cpumask_set_cpu(cpu, &cpu_off_done);
> +	cpu_psci_cpu_die();
> +}
> +
> +static bool psci_cpu_off_test(void)
> +{
> +	bool failed = false;
> +	int i, count, cpu;
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == 0)
> +			continue;
> +		on_cpu_async(cpu, cpu_off_secondary_entry, NULL);
> +	}
> +
> +	cpumask_set_cpu(0, &cpu_off_done);
> +
> +	cpu_off_start = 1;
> +	report_info("waiting for the CPUs to be offlined...");
> +	while (!cpumask_full(&cpu_off_done))
> +		cpu_relax();
> +
> +	/* Allow all the other CPUs to complete the operation */
> +	for (i = 0; i < 100; i++) {
> +		mdelay(10);
> +
> +		count = 0;
> +		for_each_present_cpu(cpu) {
> +			if (cpu == 0)
> +				continue;
> +			if (psci_affinity_info(cpus[cpu], 0) != PSCI_0_2_AFFINITY_LEVEL_OFF)
> +				count++;
> +		}
> +		if (count > 0)
> +			continue;

This should be

if (count == 0)
   break;

otherwise we never leave the loop early.

> +	}
> +
> +	/* Try to catch CPUs that return from CPU_OFF. */
> +	if (count == 0)
> +		mdelay(100);
> +
> +	for_each_present_cpu(cpu) {
> +		if (cpu == 0)
> +			continue;
> +		if (cpu_idle(cpu)) {
> +			report_info("CPU%d failed to be offlined", cpu);
> +			if (psci_affinity_info(cpus[cpu], 0) == PSCI_0_2_AFFINITY_LEVEL_OFF)
> +				report_info("AFFINITY_INFO incorrectly reports CPU%d as offline", cpu);
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
> @@ -188,10 +251,17 @@ int main(void)
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

We should output "was skipped" when the cpu-on test was skipped, rather
than always reporting "failed". We need two booleans, try_cpu_on_test and
cpu_on_success.

> +	else
> +		report(psci_cpu_off_test(), "cpu-off");
>  
>  done:
>  #if 0
> -- 
> 2.39.0
> 

Thanks,
drew
