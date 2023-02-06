Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A463568CAE2
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjBFX7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBFX7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:59:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9C3212BB;
        Mon,  6 Feb 2023 15:59:10 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675727948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fDDaXVY6/J+p9ip6iSx3ZsuEe1LaCfiIVkmBPaV4KG8=;
        b=vgdO2GnoVG/xwlnxxDBH7KeNRiji6WFNUXlkaCkr452vMma1Wp9cZ3KE3+Vt3ZVD3/38JW
        6wYaBrmkLpB+NlWdKngK4hSY8wROJUxD6sk+sYLt21ZivuxEJdMq176J1wO+ugPRo0qpQQ
        g9neSpYefIyWS2nf73wxhOgrshD+bFBm1OcN60kzub7dxpQ32vEyFLiGjyhapj54ZaHrDG
        faevuOn085QVMwwsP+IhT6Ui8qqa7ur444n+JxVzvH1oGKg4PlqY55M4+ZClIAL0WTml72
        w9S7ltNbkHLgESfQq/KExJkVsyzTWvhdPrvrTaw724oFvvlxEPpp9aoX3H7fsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675727948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fDDaXVY6/J+p9ip6iSx3ZsuEe1LaCfiIVkmBPaV4KG8=;
        b=eEfUo3Jh9bewqLbDt7/7QG+QOueUiy4bunFVVHcoyUyZbE+YSULv8136tErYUO5M+cfrOr
        jox2T5fUmlHe8YAQ==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: Re: [PATCH v6 05/11] x86/smpboot: Split up native_cpu_up into
 separate phases and document them
In-Reply-To: <20230202215625.3248306-6-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-6-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 00:59:07 +0100
Message-ID: <87y1pawdkk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> There are four logical parts to what native_cpu_up() does on the BSP (or
> on the controlling CPU for a later hotplug).
>
> First it actually wakes the AP by sending the INIT/SIPI/SIPI sequence.
>
> Second, it waits for the AP to make it as far as wait_for_master_cpu()
> which sets that CPU's bit in cpu_initialized_mask, then sets the bit in
> cpu_callout_mask to let the AP proceed through cpu_init().
>
> Then, it waits for the AP to finish cpu_init() and get as far as the
> smp_callin() call, which sets that CPU's bit in cpu_callin_mask.
>
> Finally, it does the TSC synchronization and waits for the AP to actually
> mark itself online in cpu_online_mask.

Sigh. Four parts and why can't we have the obvious formatting here which
matches the _four_ parts?

  1) It wakes the AP by sending ...

  2) It waits for the AP

  3) ....

  4) ...

> This commit should have no behavioural change, but merely splits those

"This commit" is equally useless as "This patch"....

git grep "This patch" Documentation/process

> phases out into separate functions so that future commits can make them
> happen in parallel for all APs. And adds some comments around them on
> both the BSP and AP code paths.

   Prepare for a partial parallelization of these phases by splitting
   the code into separate function so that ......

   Add comments at both the BSP and the AP code paths to clarify the
   functionality.

   No functional change intended.

Hmm?

> [Usama Arif: fixed rebase conflict]
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

Sigh....

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a19eddcdccc2..fdcf7c08945f 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -206,6 +206,10 @@ static void smp_callin(void)
>  
>  	wmb();
>  
> +	/*
> +	 * This runs the AP through all the cpuhp states to its target
> +	 * state (CPUHP_ONLINE in the case of serial bringup).
> +	 */
>  	notify_cpu_starting(cpuid);
>  
>  	/*
> @@ -233,17 +237,33 @@ static void notrace start_secondary(void *unused)
>  	load_cr3(swapper_pg_dir);
>  	__flush_tlb_all();
>  #endif
> +	/*
> +	 * Sync point with do_wait_cpu_initialized(). On boot, all secondary
> +	 * CPUs reach this stage after receiving INIT/SIPI from do_cpu_up()
> +	 * in the x86/cpu:kick cpuhp stage. At the start of cpu_init() they
> +	 * will wait for do_wait_cpu_initialized() to set their bit in
> +	 * smp_callout_mask to release them.
> +	 */
>  	cpu_init_secondary();
>  	rcu_cpu_starting(raw_smp_processor_id());
>  	x86_cpuinit.early_percpu_clock_init();
> +
> +	/*
> +	 * Sync point with do_wait_cpu_callin(). The AP doesn't wait here
> +	 * but just sets the bit to let the controlling CPU (BSP) know that
> +	 * it's got this far.
> +	 */
>  	smp_callin();
>  
>  	enable_start_cpu0 = 0;
>  
>  	/* otherwise gcc will move up smp_processor_id before the cpu_init */
>  	barrier();
> +
>  	/*
> -	 * Check TSC synchronization with the boot CPU:
> +	 * Check TSC synchronization with the boot CPU (or whichever CPU
> +	 * is controlling the bringup). It will do its part of this from
> +	 * do_wait_cpu_online(), making it an implicit sync point.
>  	 */
>  	check_tsc_sync_target();
>  
> @@ -256,6 +276,7 @@ static void notrace start_secondary(void *unused)
>  	 * half valid vector space.
>  	 */
>  	lock_vector_lock();
> +	/* Sync point with do_wait_cpu_online() */
>  	set_cpu_online(smp_processor_id(), true);
>  	lapic_online();
>  	unlock_vector_lock();
> @@ -1085,7 +1106,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
>  	unsigned long start_ip = real_mode_header->trampoline_start;
>  
>  	unsigned long boot_error = 0;
> -	unsigned long timeout;
>  
>  #ifdef CONFIG_X86_64
>  	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
> @@ -1146,55 +1166,94 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
>  		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
>  						     cpu0_nmi_registered);
>  
> -	if (!boot_error) {
> -		/*
> -		 * Wait 10s total for first sign of life from AP
> -		 */
> -		boot_error = -1;
> -		timeout = jiffies + 10*HZ;
> -		while (time_before(jiffies, timeout)) {
> -			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
> -				/*
> -				 * Tell AP to proceed with initialization
> -				 */
> -				cpumask_set_cpu(cpu, cpu_callout_mask);
> -				boot_error = 0;
> -				break;
> -			}
> -			schedule();
> -		}
> -	}
> +	return boot_error;
> +}
>  
> -	if (!boot_error) {
> -		/*
> -		 * Wait till AP completes initial initialization
> -		 */
> -		while (!cpumask_test_cpu(cpu, cpu_callin_mask)) {
> -			/*
> -			 * Allow other tasks to run while we wait for the
> -			 * AP to come online. This also gives a chance
> -			 * for the MTRR work(triggered by the AP coming online)
> -			 * to be completed in the stop machine context.
> -			 */
> -			schedule();
> -		}
> +static int do_wait_cpu_cpumask(unsigned int cpu, const struct cpumask *mask)
> +{
> +	unsigned long timeout;
> +
> +	/*
> +	 * Wait up to 10s for the CPU to report in.
> +	 */
> +	timeout = jiffies + 10*HZ;
> +	while (time_before(jiffies, timeout)) {
> +		if (cpumask_test_cpu(cpu, mask))
> +			return 0;
> +
> +		schedule();
>  	}
> +	return -1;
> +}
>  
> -	if (x86_platform.legacy.warm_reset) {
> -		/*
> -		 * Cleanup possible dangling ends...
> -		 */
> -		smpboot_restore_warm_reset_vector();
> +/*
> + * Bringup step two: Wait for the target AP to reach cpu_init_secondary()
> + * and thus wait_for_master_cpu(), then set cpu_callout_mask to allow it
> + * to proceed.  The AP will then proceed past setting its 'callin' bit
> + * and end up waiting in check_tsc_sync_target() until we reach
> + * do_wait_cpu_online() to tend to it.
> + */
> +static int do_wait_cpu_initialized(unsigned int cpu)
> +{
> +	/*
> +	 * Wait for first sign of life from AP.
> +	 */
> +	if (do_wait_cpu_cpumask(cpu, cpu_initialized_mask))
> +		return -1;
> +
> +	cpumask_set_cpu(cpu, cpu_callout_mask);
> +	return 0;
> +}
> +
> +/*
> + * Bringup step three: Wait for the target AP to reach smp_callin().
> + * The AP is not waiting for us here so we don't need to parallelise
> + * this step. Not entirely clear why we care about this, since we just
> + * proceed directly to TSC synchronization which is the next sync
> + * point with the AP anyway.
> + */
> +static int do_wait_cpu_callin(unsigned int cpu)
> +{
> +	/*
> +	 * Wait till AP completes initial initialization.
> +	 */
> +	return do_wait_cpu_cpumask(cpu, cpu_callin_mask);
> +}
> +
> +/*
> + * Bringup step four: Synchronize the TSC and wait for the target AP
> + * to reach set_cpu_online() in start_secondary().
> + */
> +static int do_wait_cpu_online(unsigned int cpu)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Check TSC synchronization with the AP (keep irqs disabled
> +	 * while doing so):
> +	 */
> +	local_irq_save(flags);
> +	check_tsc_sync_source(cpu);
> +	local_irq_restore(flags);
> +
> +	/*
> +	 * Wait for the AP to mark itself online. Not entirely
> +	 * clear why we care, since the generic cpuhp code will
> +	 * wait for it to each CPUHP_AP_ONLINE_IDLE before going
> +	 * ahead with the rest of the bringup anyway.
> +	 */
> +	while (!cpu_online(cpu)) {
> +		cpu_relax();
> +		touch_nmi_watchdog();
>  	}
>  
> -	return boot_error;
> +	return 0;
>  }
>  
> -int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
> +static int do_cpu_up(unsigned int cpu, struct task_struct *tidle)
>  {
>  	int apicid = apic->cpu_present_to_apicid(cpu);
>  	int cpu0_nmi_registered = 0;
> -	unsigned long flags;
>  	int err, ret = 0;
>  
>  	lockdep_assert_irqs_enabled();
> @@ -1241,19 +1300,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
>  		goto unreg_nmi;
>  	}
>  
> -	/*
> -	 * Check TSC synchronization with the AP (keep irqs disabled
> -	 * while doing so):
> -	 */
> -	local_irq_save(flags);
> -	check_tsc_sync_source(cpu);
> -	local_irq_restore(flags);
> -
> -	while (!cpu_online(cpu)) {
> -		cpu_relax();
> -		touch_nmi_watchdog();
> -	}
> -
>  unreg_nmi:
>  	/*
>  	 * Clean up the nmi handler. Do this after the callin and callout sync
> @@ -1265,6 +1311,34 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
>  	return ret;
>  }
>  
> +int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
> +{
> +	int ret;
> +
> +	ret = do_cpu_up(cpu, tidle);
> +	if (ret)
> +		return ret;
> +
> +	ret = do_wait_cpu_initialized(cpu);
> +	if (ret)
> +		return ret;
> +
> +	ret = do_wait_cpu_callin(cpu);
> +	if (ret)
> +		return ret;
> +
> +	ret = do_wait_cpu_online(cpu);
> +
> +	if (x86_platform.legacy.warm_reset) {
> +		/*
> +		 * Cleanup possible dangling ends...
> +		 */
> +		smpboot_restore_warm_reset_vector();
> +	}
> +
> +	return ret;
> +}

I'm fine with the approach, but can you please structure this into the
obvious steps of splitting out things step by step and not forcing the
reviewer to digest all of this at once?

Thanks,

        tglx
