Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF16648609
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 16:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiLIP5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 10:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiLIP5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 10:57:42 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70EA32BE1
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 07:57:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D5AE623A;
        Fri,  9 Dec 2022 07:57:46 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 585463F73D;
        Fri,  9 Dec 2022 07:57:37 -0800 (PST)
Date:   Fri, 9 Dec 2022 15:57:26 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, Suzuki.Poulose@arm.com, nd@arm.com
Subject: Re: [PATCH 1/2] arm/psci: Test that CPU 1 has been successfully
 brought online
Message-ID: <Y5Na5vKX4XEWBqSh@monolith.localdoman>
References: <20221205121053.125964-1-Nikita.Venkatesh@arm.com>
 <20221205121053.125964-2-Nikita.Venkatesh@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205121053.125964-2-Nikita.Venkatesh@arm.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Dec 05, 2022 at 12:10:52PM +0000, Nikita Venkatesh wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> For the PSCI CPU_ON function test, all other CPUs perform a CPU_ON call
> that target CPU 1. The test is considered a success if CPU_ON returns
> SUCCESS exactly once, and for the rest of the calls ALREADY_ON.
> 
> Enhance the test by making sure that CPU 1 is actually online and able to
> execute code. Since the CPU 1 thread is now being set up properly by
> kvm-unit-tests when being brought online, it becomes possible to add other
> tests in the future that require all CPUs.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> ---
>  arm/psci.c        | 30 +++++++++++++++++++++---------
>  lib/arm/asm/smp.h |  1 +
>  lib/arm/smp.c     | 12 +++++++++---
>  3 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index efa0722..0b9834c 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -72,14 +72,23 @@ static int cpu_on_ret[NR_CPUS];
>  static cpumask_t cpu_on_ready, cpu_on_done;
>  static volatile int cpu_on_start;
>  
> -static void cpu_on_secondary_entry(void)
> +extern void secondary_entry(void);
> +static void cpu_on_wake_target(void)
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
> @@ -89,31 +98,34 @@ static bool psci_cpu_on_test(void)
>  	int ret_success = 0;
>  	int cpu;
>  
> -	cpumask_set_cpu(1, &cpu_on_ready);
> -	cpumask_set_cpu(1, &cpu_on_done);
> -
>  	for_each_present_cpu(cpu) {
>  		if (cpu < 2)
>  			continue;
> -		smp_boot_secondary(cpu, cpu_on_secondary_entry);
> +		smp_boot_secondary(cpu, cpu_on_wake_target);
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
>  	while (!cpumask_full(&cpu_on_done))
>  		cpu_relax();

I've realized that with this change the test hangs if CPU 1 doesn't come
online, which wasn't the case before.

I think adding a timeout here would be the best way to fix it, something
like this:

--- a/arm/psci.c
+++ b/arm/psci.c
@@ -9,6 +9,7 @@
  */
 #include <libcflat.h>
 #include <errata.h>
+#include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
@@ -96,7 +97,7 @@ static bool psci_cpu_on_test(void)
 {
        bool failed = false;
        int ret_success = 0;
-       int cpu;
+       int i, cpu;

        for_each_present_cpu(cpu) {
                if (cpu < 2)
@@ -122,8 +123,24 @@ static bool psci_cpu_on_test(void)
        cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(secondary_entry));
        cpumask_set_cpu(0, &cpu_on_done);

-       while (!cpumask_full(&cpu_on_done))
-               cpu_relax();
+       report_info("waiting for CPU1 to come online...");
+       for (i = 0; i < 10; i++) {
+               mdelay(100);
+               if (cpumask_full(&cpu_on_done))
+                       break;
+       }
+
+       if (!cpumask_full(&cpu_on_done)) {
+               for_each_present_cpu(cpu) {
+                       if (!cpumask_test_cpu(cpu, &cpu_on_done)) {
+                               if (cpu == 1)
+                                       report_info("CPU1 failed to come online");
+                               else
+                                       report_info("CPU%d failed to online CPU1", cpu);
+                       }
+               }
+               return false;
+       }

        for_each_present_cpu(cpu) {
                if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {

What do you think?

Thanks,
Alex

>  
>  	for_each_present_cpu(cpu) {
> -		if (cpu == 1)
> -			continue;
>  		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
>  			ret_success++;
>  		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
> diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
> index 077afde..ff2ef8f 100644
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
> index 98a5054..947f417 100644
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
> -- 
> 2.25.1
> 
