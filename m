Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541864744CD
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 15:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhLNOY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 09:24:29 -0500
Received: from foss.arm.com ([217.140.110.172]:57250 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234916AbhLNOY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 09:24:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 905A36D;
        Tue, 14 Dec 2021 06:24:28 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.66.239])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68A83F793;
        Tue, 14 Dec 2021 06:24:25 -0800 (PST)
Date:   Tue, 14 Dec 2021 14:24:22 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: Re: [PATCH v2 3/7] cpu/hotplug: Add dynamic parallel bringup states
 before CPUHP_BRINGUP_CPU
Message-ID: <YbipFmlKSf1UuisZ@FVFF77S0Q05N>
References: <20211214123250.88230-1-dwmw2@infradead.org>
 <20211214123250.88230-4-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214123250.88230-4-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021 at 12:32:46PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> If the platform registers these states, bring all CPUs to each registered
> state in turn, before the final bringup to CPUHP_BRINGUP_CPU. This allows
> the architecture to parallelise the slow asynchronous tasks like sending
> INIT/SIPI and waiting for the AP to come to life.
> 
> There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_DYN step,
> this means that *all* CPUs are brought through the prepare states and to
> CPUHP_BP_PREPARE_DYN before any of them are taken to CPUHP_BRINGUP_CPU
> and then are allowed to run for themselves to CPUHP_ONLINE.
> 
> So any combination of prepare/start calls which depend on A-B ordering
> for each CPU in turn, such as the X2APIC code which used to allocate a
> cluster mask 'just in case' and store it in a global variable in the
> prep stage, then potentially consume that preallocated structure from
> the AP and set the global pointer to NULL to be reallocated in
> CPUHP_X2APIC_PREPARE for the next CPU... would explode horribly.
> 
> We believe that X2APIC was the only such case, for x86. But this is why
> it remains an architecture opt-in. For now.

It might be worth elaborating with a non-x86 example, e.g.

|  We believe that X2APIC was the only such case, for x86. Other architectures
|  have similar requirements with global variables used during bringup (e.g.
|  `secondary_data` on arm/arm64), so architectures must opt-in for now.

... so that we have a specific example of how unconditionally enabling this for
all architectures would definitely break things today.

FWIW, that's something I would like to cleanup for arm64 for general
robustness, and if that would make it possible for us to have parallel bringup
in future that would be a nice bonus.

> Note that the new parallel stages do *not* yet bring each AP to the
> CPUHP_BRINGUP_CPU state. The final loop in bringup_nonboot_cpus() is
> untouched, bringing each AP in turn from the final PARALLEL_DYN state
> (or all the way from CPUHP_OFFLINE) to CPUHP_BRINGUP_CPU and then
> waiting for that AP to do its own processing and reach CPUHP_ONLINE
> before releasing the next. Parallelising that part by bringing them all
> to CPUHP_BRINGUP_CPU and then waiting for them all is an exercise for
> the future.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  include/linux/cpuhotplug.h |  2 ++
>  kernel/cpu.c               | 27 +++++++++++++++++++++++++--
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 773c83730906..45c327538321 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -131,6 +131,8 @@ enum cpuhp_state {
>  	CPUHP_MIPS_SOC_PREPARE,
>  	CPUHP_BP_PREPARE_DYN,
>  	CPUHP_BP_PREPARE_DYN_END		= CPUHP_BP_PREPARE_DYN + 20,
> +	CPUHP_BP_PARALLEL_DYN,
> +	CPUHP_BP_PARALLEL_DYN_END		= CPUHP_BP_PARALLEL_DYN + 4,
>  	CPUHP_BRINGUP_CPU,
>  
>  	/*
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 192e43a87407..1a46eb57d8f7 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -1462,6 +1462,24 @@ int bringup_hibernate_cpu(unsigned int sleep_cpu)
>  void bringup_nonboot_cpus(unsigned int setup_max_cpus)
>  {
>  	unsigned int cpu;
> +	int n = setup_max_cpus - num_online_cpus();
> +
> +	/* ∀ parallel pre-bringup state, bring N CPUs to it */

I see you have a fancy maths keyboard. ;)

It might be worth using a few more words here for clarity, e.g.

	/*
	 * Bring all nonboot CPUs through each pre-bringup state in turn
	 */

Thanks,
Mark.

> +	if (n > 0) {
> +		enum cpuhp_state st = CPUHP_BP_PARALLEL_DYN;
> +
> +		while (st <= CPUHP_BP_PARALLEL_DYN_END &&
> +		       cpuhp_hp_states[st].name) {
> +			int i = n;
> +
> +			for_each_present_cpu(cpu) {
> +				cpu_up(cpu, st);
> +				if (!--i)
> +					break;
> +			}
> +			st++;
> +		}
> +	}
>  
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= setup_max_cpus)
> @@ -1829,6 +1847,10 @@ static int cpuhp_reserve_state(enum cpuhp_state state)
>  		step = cpuhp_hp_states + CPUHP_BP_PREPARE_DYN;
>  		end = CPUHP_BP_PREPARE_DYN_END;
>  		break;
> +	case CPUHP_BP_PARALLEL_DYN:
> +		step = cpuhp_hp_states + CPUHP_BP_PARALLEL_DYN;
> +		end = CPUHP_BP_PARALLEL_DYN_END;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1853,14 +1875,15 @@ static int cpuhp_store_callbacks(enum cpuhp_state state, const char *name,
>  	/*
>  	 * If name is NULL, then the state gets removed.
>  	 *
> -	 * CPUHP_AP_ONLINE_DYN and CPUHP_BP_PREPARE_DYN are handed out on
> +	 * CPUHP_AP_ONLINE_DYN and CPUHP_BP_P*_DYN are handed out on
>  	 * the first allocation from these dynamic ranges, so the removal
>  	 * would trigger a new allocation and clear the wrong (already
>  	 * empty) state, leaving the callbacks of the to be cleared state
>  	 * dangling, which causes wreckage on the next hotplug operation.
>  	 */
>  	if (name && (state == CPUHP_AP_ONLINE_DYN ||
> -		     state == CPUHP_BP_PREPARE_DYN)) {
> +		     state == CPUHP_BP_PREPARE_DYN ||
> +		     state == CPUHP_BP_PARALLEL_DYN)) {
>  		ret = cpuhp_reserve_state(state);
>  		if (ret < 0)
>  			return ret;
> -- 
> 2.31.1
> 
