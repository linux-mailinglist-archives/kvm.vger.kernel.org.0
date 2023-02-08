Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5929668EC4A
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjBHKDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 05:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBHKDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 05:03:45 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756B035BB;
        Wed,  8 Feb 2023 02:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675850623; x=1707386623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bnGKIBFnzJZoxrpMrO7/H65H9sV65Kzy8xs7gTUHeW8=;
  b=b+rbtr69TURczhTOrrJKkbKnHdU3uIbJ67hXhgm8S7VU0Bizd5Y3iJ+D
   0VlFhVG0H4AuoJ8wz6qVSFTnsnMoawLaGijRtoc251xIfjNdJJGz08lDJ
   2yKOo7+8NsE2LrFYky8y6S7gRTSMVa5C5YdGd5+3Dp3dRcoeqf/j0rHGY
   Za7gHo/0QmLgCD7tjXfdFRke4Jyw3JHtbTRbVQDHi6oLvql7HDje6X58R
   v7IMyzjYkLZXzT5G0VH0FfuYxDg1iqr3RlmfOJT0LmPEprf3eNN9baBUs
   SywVud1z3438EIO08E623tCRBBSweZ3nKF+AD6PGzsIUonVXyZffecqK2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="357148889"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="357148889"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 02:03:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="775947741"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="775947741"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga002.fm.intel.com with ESMTP; 08 Feb 2023 02:03:37 -0800
Date:   Wed, 8 Feb 2023 18:03:36 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v7 5/9] x86/smpboot: Split up native_cpu_up into separate
 phases and document them
Message-ID: <20230208100336.mdnrvpsssa2sjodu@yy-desk-7060>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230207230436.2690891-6-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207230436.2690891-6-usama.arif@bytedance.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 11:04:32PM +0000, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> There are four logical parts to what native_cpu_up() does on the BSP (or
> on the controlling CPU for a later hotplug):
>
>  1) Wake the AP by sending the INIT/SIPI/SIPI sequence.
>
>  2) Wait for the AP to make it as far as wait_for_master_cpu() which
>     sets that CPU's bit in cpu_initialized_mask, then sets the bit in
>     cpu_callout_mask to let the AP proceed through cpu_init().
>
>  3) Waits for the AP to finish cpu_init() and get as far as the
>     smp_callin() call, which sets that CPU's bit in cpu_callin_mask.
>
>  4) Perform the TSC synchronization and wait for the AP to actually
>     mark itself online in cpu_online_mask.
>
> In preparation to allow these phases to operate in parallel on multiple
> APs, split them out into separate functions and document the interactions
> a little more clearly in both the BSP and AP code paths.
>
> No functional change intended.
>
> [Usama Arif: fixed rebase conflict]
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  arch/x86/kernel/smpboot.c | 182 +++++++++++++++++++++++++++-----------
>  1 file changed, 128 insertions(+), 54 deletions(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 3a793772a2aa..eee717086ab7 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -204,6 +204,10 @@ static void smp_callin(void)
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
> @@ -231,17 +235,33 @@ static void notrace start_secondary(void *unused)
>  	load_cr3(swapper_pg_dir);
>  	__flush_tlb_all();
>  #endif
> +	/*
> +	 * Sync point with do_wait_cpu_initialized(). On boot, all secondary
> +	 * CPUs reach this stage after receiving INIT/SIPI from do_cpu_up()
> +	 * in the x86/cpu:kick cpuhp stage. At the start of cpu_init() they
> +	 * will wait for do_wait_cpu_initialized() to set their bit in
> +	 * smp_callout_mask to release them.

The last sentence of the comment looks confused. The fact is:

For serial case, The BSP waits AP to set cpu_initialized_mask from
wait_for_master_cpu() after fired INIT/SIPI, then AP starts to wait
cpu_callout_mask set by BSP from do_boot_cpu().

Or the comments below "Bringup step two:..." which also looks clear
enough then above.

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
> @@ -254,6 +274,7 @@ static void notrace start_secondary(void *unused)
>  	 * half valid vector space.
>  	 */
>  	lock_vector_lock();
> +	/* Sync point with do_wait_cpu_online() */
>  	set_cpu_online(smp_processor_id(), true);
>  	lapic_online();
>  	unlock_vector_lock();
> @@ -1083,7 +1104,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
>  	unsigned long start_ip = real_mode_header->trampoline_start;
>
>  	unsigned long boot_error = 0;
> -	unsigned long timeout;
>
>  #ifdef CONFIG_X86_64
>  	/* If 64-bit wakeup method exists, use the 64-bit mode trampoline IP */
> @@ -1144,55 +1164,94 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
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
> @@ -1239,19 +1298,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
> @@ -1263,6 +1309,34 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
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
> +
>  /**
>   * arch_disable_smp_support() - disables SMP support for x86 at runtime
>   */
> --
> 2.25.1
>
