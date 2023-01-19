Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE467374E
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 12:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjASLrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 06:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjASLqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 06:46:53 -0500
Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3593B4ABFD
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 03:46:33 -0800 (PST)
Date:   Thu, 19 Jan 2023 12:46:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674128791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aQ2IUhUvzSbVHZgw7YwuEUz0bDmpBiwVacUuCwfatnM=;
        b=P13bpELiKcp6tuNoqxMXyevckgunBxS+KULhI7xbIUeO7mEHSThZEDrKVp2tsCVkD15De8
        pu0dGcN02H++iosj2jVUBB57elUB44TQbSlXDDutZ937MVI0JLwUt4jhbF2yPWmAxbclw0
        xcvlvpBHdqAIywVYcZdxZdjKVkKpp8E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v4 1/2] arm/psci: Test that CPU 1 has been
 successfully brought online
Message-ID: <20230119114624.5dzzwfueudvuyp5q@orel>
References: <20230118144912.32049-1-alexandru.elisei@arm.com>
 <20230118144912.32049-2-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118144912.32049-2-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 02:49:11PM +0000, Alexandru Elisei wrote:
> For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
> that target CPU 1. The test is considered a success if CPU_ON returns PSCI
> SUCCESS exactly once, and for the rest of the calls PSCI ALREADY_ON.
> 
> Enhance the test by checking that CPU 1 is actually online and able to
> execute code. Also make the test more robust by checking that the CPU_ON
> call returns, instead of assuming that it will always succeed and
> hanging indefinitely if it doesn't.
> 
> Since the CPU 1 thread is now being set up properly by kvm-unit-tests
> when being brought online, it becomes possible to add other tests in the
> future that require all CPUs.
> 
> The include header order in arm/psci.c has been changed to be in
> alphabetic order. This means moving the errata.h include before
> libcflat.h, which causes compilation to fail because of missing includes
> in errata.h. Fix that also by including the needed header in errata.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/psci.c        | 60 ++++++++++++++++++++++++++++++++++++-----------
>  lib/arm/asm/smp.h |  1 +
>  lib/arm/smp.c     | 12 +++++++---
>  lib/errata.h      |  2 ++
>  4 files changed, 58 insertions(+), 17 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index efa0722c0566..e96be941953b 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -7,11 +7,13 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> -#include <libcflat.h>
>  #include <errata.h>
> +#include <libcflat.h>
> +
> +#include <asm/delay.h>
>  #include <asm/processor.h>
> -#include <asm/smp.h>
>  #include <asm/psci.h>
> +#include <asm/smp.h>
>  
>  static bool invalid_function_exception;
>  
> @@ -72,14 +74,23 @@ static int cpu_on_ret[NR_CPUS];
>  static cpumask_t cpu_on_ready, cpu_on_done;
>  static volatile int cpu_on_start;
>  
> -static void cpu_on_secondary_entry(void)
> +extern void secondary_entry(void);
> +static void cpu_on_do_wake_target(void)
>  {
>  	int cpu = smp_processor_id();
>  
>  	cpumask_set_cpu(cpu, &cpu_on_ready);
>  	while (!cpu_on_start)
>  		cpu_relax();
> -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
> +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(secondary_entry));
> +	cpumask_set_cpu(cpu, &cpu_on_done);
> +}
> +
> +static void cpu_on_target(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	cpu_on_ret[cpu] = PSCI_RET_ALREADY_ON;
>  	cpumask_set_cpu(cpu, &cpu_on_done);
>  }
>  
> @@ -87,33 +98,53 @@ static bool psci_cpu_on_test(void)
>  {
>  	bool failed = false;
>  	int ret_success = 0;
> -	int cpu;
> -
> -	cpumask_set_cpu(1, &cpu_on_ready);
> -	cpumask_set_cpu(1, &cpu_on_done);
> +	int i, cpu;
>  
>  	for_each_present_cpu(cpu) {
>  		if (cpu < 2)
>  			continue;
> -		smp_boot_secondary(cpu, cpu_on_secondary_entry);
> +		smp_boot_secondary(cpu, cpu_on_do_wake_target);
>  	}
>  
>  	cpumask_set_cpu(0, &cpu_on_ready);
> +	cpumask_set_cpu(1, &cpu_on_ready);
>  	while (!cpumask_full(&cpu_on_ready))
>  		cpu_relax();
>  
> +	/*
> +	 * Wait for all other CPUs to be online before configuring the thread
> +	 * for the target CPU, as all secondaries are set up using the same
> +	 * global variable.
> +	 */
> +	smp_prepare_secondary(1, cpu_on_target);
> +
>  	cpu_on_start = 1;
>  	smp_mb();
>  
> -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
> +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(secondary_entry));
>  	cpumask_set_cpu(0, &cpu_on_done);
>  
> -	while (!cpumask_full(&cpu_on_done))
> -		cpu_relax();
> +	report_info("waiting for CPU1 to come online...");
> +	for (i = 0; i < 10; i++) {
> +		mdelay(100);

Changing this to

     for (i = 0; i < 100; i++) {
             mdelay(10);

may speed it up a bit.

Thanks,
drew

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
> +		failed = true;
> +		goto out;
> +	}
>  
>  	for_each_present_cpu(cpu) {
> -		if (cpu == 1)
> -			continue;
>  		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
>  			ret_success++;
>  		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
> @@ -127,6 +158,7 @@ static bool psci_cpu_on_test(void)
>  		failed = true;
>  	}
>  
> +out:
>  	return !failed;
>  }
>  
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index 077afde85520..ff2ef8f88247 100644
> --- a/lib/arm/asm/smp.h
> +++ b/lib/arm/asm/smp.h
> @@ -49,6 +49,7 @@ static inline void set_cpu_idle(int cpu, bool idle)
>  }
>  
>  typedef void (*secondary_entry_fn)(void);
> +extern void smp_prepare_secondary(int cpu, secondary_entry_fn entry);
>  extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
>  extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
>  extern void on_cpu(int cpu, void (*func)(void *data), void *data);
> diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> index 98a5054e039b..947f417f4aea 100644
> --- a/lib/arm/smp.c
> +++ b/lib/arm/smp.c
> @@ -58,13 +58,19 @@ secondary_entry_fn secondary_cinit(void)
>  	return entry;
>  }
>  
> -static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
> +void smp_prepare_secondary(int cpu, secondary_entry_fn entry)
>  {
> -	int ret;
> -
>  	secondary_data.stack = thread_stack_alloc();
>  	secondary_data.entry = entry;
>  	mmu_mark_disabled(cpu);
> +}
> +
> +static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
> +{
> +	int ret;
> +
> +	smp_prepare_secondary(cpu, entry);
> +
>  	ret = cpu_psci_cpu_boot(cpu);
>  	assert(ret == 0);
>  
> diff --git a/lib/errata.h b/lib/errata.h
> index 5af0eb3bf8e2..de8205d8b370 100644
> --- a/lib/errata.h
> +++ b/lib/errata.h
> @@ -6,6 +6,8 @@
>   */
>  #ifndef _ERRATA_H_
>  #define _ERRATA_H_
> +#include <libcflat.h>
> +
>  #include "config.h"
>  
>  #ifndef CONFIG_ERRATA_FORCE
> -- 
> 2.25.1
> 
