Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47D1915AF
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 17:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgCXQJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 12:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727628AbgCXQJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 12:09:11 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAAB920775;
        Tue, 24 Mar 2020 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585066149;
        bh=AaT8eWh4mFXpJz4Lgi4w8mU/brid/vniuLUWuBHPBkQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YfW9u3k9KyGgrUNO6hl3nfH0+WNdJ5uuAcQBSwY5Ev3py3AmIaFg2V/6x/BP8S48n
         kVKhhuUcRHDPnBJ7tIWqC7CT7W4STplv6Kvavr73WMuZcC9QDxf4gp7K9Fw15TaQos
         2wyieljtVZ098AWg7CHH+UC07mCoMHnKObjSzjq4=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 9E4773522AE1; Tue, 24 Mar 2020 09:09:09 -0700 (PDT)
Date:   Tue, 24 Mar 2020 09:09:09 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RESEND][patch V3 17/23] rcu/tree: Mark the idle relevant
 functions noinstr
Message-ID: <20200324160909.GD19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200320175956.033706968@linutronix.de>
 <20200320180034.095809808@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320180034.095809808@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 07:00:13PM +0100, Thomas Gleixner wrote:
> These functions are invoked from context tracking and other places in the
> low level entry code. Move them into the .noinstr.text section to exclude
> them from instrumentation.
> 
> Mark the places which are safe to invoke traceable functions with
> instr_begin/end() so objtool won't complain.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

A few questions and comments below.  I have not yet tried rcutorture
on this series, but this is on my list.  (Just when you thought it
was safe...)

							Thanx, Paul

> ---
> V3: New patch
> ---
>  kernel/rcu/tree.c        |   66 ++++++++++++++++++++++++++---------------------
>  kernel/rcu/tree_plugin.h |    4 +-
>  kernel/rcu/update.c      |    7 ++--
>  3 files changed, 42 insertions(+), 35 deletions(-)
> 
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -75,9 +75,6 @@
>   */
>  #define RCU_DYNTICK_CTRL_MASK 0x1
>  #define RCU_DYNTICK_CTRL_CTR  (RCU_DYNTICK_CTRL_MASK + 1)
> -#ifndef rcu_eqs_special_exit
> -#define rcu_eqs_special_exit() do { } while (0)
> -#endif

Note to self:  Check to see if anyone is ever going to use
rcu_eqs_special_set() and thus the bottom bit of ->dynticks, and get
rid of both if not.  The rcu_eqs_special_exit() was to be how this
bit was to be sensed by the user.

>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
>  	.dynticks_nesting = 1,
> @@ -228,7 +225,7 @@ void rcu_softirq_qs(void)
>   * RCU is watching prior to the call to this function and is no longer
>   * watching upon return.
>   */
> -static void rcu_dynticks_eqs_enter(void)
> +static noinstr void rcu_dynticks_eqs_enter(void)
>  {
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  	int seq;
> @@ -252,7 +249,7 @@ static void rcu_dynticks_eqs_enter(void)
>   * called from an extended quiescent state, that is, RCU is not watching
>   * prior to the call to this function and is watching upon return.
>   */
> -static void rcu_dynticks_eqs_exit(void)
> +static noinstr void rcu_dynticks_eqs_exit(void)
>  {
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  	int seq;
> @@ -269,8 +266,6 @@ static void rcu_dynticks_eqs_exit(void)
>  	if (seq & RCU_DYNTICK_CTRL_MASK) {
>  		atomic_andnot(RCU_DYNTICK_CTRL_MASK, &rdp->dynticks);
>  		smp_mb__after_atomic(); /* _exit after clearing mask. */
> -		/* Prefer duplicate flushes to losing a flush. */
> -		rcu_eqs_special_exit();
>  	}
>  }
>  
> @@ -298,7 +293,7 @@ static void rcu_dynticks_eqs_online(void
>   *
>   * No ordering, as we are sampling CPU-local information.
>   */
> -static bool rcu_dynticks_curr_cpu_in_eqs(void)
> +static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
>  {
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  
> @@ -557,7 +552,7 @@ EXPORT_SYMBOL_GPL(rcutorture_get_gp_data
>   * the possibility of usermode upcalls having messed up our count
>   * of interrupt nesting level during the prior busy period.
>   */
> -static void rcu_eqs_enter(bool user)
> +static noinstr void rcu_eqs_enter(bool user)
>  {
>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  
> @@ -572,12 +567,14 @@ static void rcu_eqs_enter(bool user)
>  	}
>  
>  	lockdep_assert_irqs_disabled();
> +	instr_begin();
>  	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
>  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
>  	rdp = this_cpu_ptr(&rcu_data);
>  	do_nocb_deferred_wakeup(rdp);
>  	rcu_prepare_for_idle();
>  	rcu_preempt_deferred_qs(current);
> +	instr_end();
>  	WRITE_ONCE(rdp->dynticks_nesting, 0); /* Avoid irq-access tearing. */
>  	// RCU is watching here ...
>  	rcu_dynticks_eqs_enter();
> @@ -614,7 +611,7 @@ void rcu_idle_enter(void)
>   * If you add or remove a call to rcu_user_enter(), be sure to test with
>   * CONFIG_RCU_EQS_DEBUG=y.
>   */
> -void rcu_user_enter(void)
> +noinstr void rcu_user_enter(void)
>  {
>  	lockdep_assert_irqs_disabled();

Just out of curiosity -- this means that lockdep_assert_irqs_disabled()
must be noinstr, correct?

>  	rcu_eqs_enter(true);
> @@ -647,19 +644,23 @@ static __always_inline void rcu_nmi_exit
>  	 * leave it in non-RCU-idle state.
>  	 */
>  	if (rdp->dynticks_nmi_nesting != 1) {
> +		instr_begin();
>  		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
>  				  atomic_read(&rdp->dynticks));
>  		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
>  			   rdp->dynticks_nmi_nesting - 2);
> +		instr_end();
>  		return;
>  	}
>  
> +		instr_begin();

Indentation?

>  	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
>  	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, atomic_read(&rdp->dynticks));
>  	WRITE_ONCE(rdp->dynticks_nmi_nesting, 0); /* Avoid store tearing. */
>  
>  	if (irq)
>  		rcu_prepare_for_idle();
> +	instr_end();
>  
>  	// RCU is watching here ...
>  	rcu_dynticks_eqs_enter();
> @@ -675,7 +676,7 @@ static __always_inline void rcu_nmi_exit
>   * If you add or remove a call to rcu_nmi_exit(), be sure to test
>   * with CONFIG_RCU_EQS_DEBUG=y.
>   */
> -void rcu_nmi_exit(void)
> +void noinstr rcu_nmi_exit(void)
>  {
>  	rcu_nmi_exit_common(false);
>  }
> @@ -728,7 +729,7 @@ void rcu_irq_exit_irqson(void)
>   * allow for the possibility of usermode upcalls messing up our count of
>   * interrupt nesting level during the busy period that is just now starting.
>   */
> -static void rcu_eqs_exit(bool user)
> +static void noinstr rcu_eqs_exit(bool user)
>  {
>  	struct rcu_data *rdp;
>  	long oldval;
> @@ -746,12 +747,14 @@ static void rcu_eqs_exit(bool user)
>  	// RCU is not watching here ...
>  	rcu_dynticks_eqs_exit();
>  	// ... but is watching here.
> +	instr_begin();
>  	rcu_cleanup_after_idle();
>  	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, atomic_read(&rdp->dynticks));
>  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
>  	WRITE_ONCE(rdp->dynticks_nesting, 1);
>  	WARN_ON_ONCE(rdp->dynticks_nmi_nesting);
>  	WRITE_ONCE(rdp->dynticks_nmi_nesting, DYNTICK_IRQ_NONIDLE);
> +	instr_end();
>  }
>  
>  /**
> @@ -782,7 +785,7 @@ void rcu_idle_exit(void)
>   * If you add or remove a call to rcu_user_exit(), be sure to test with
>   * CONFIG_RCU_EQS_DEBUG=y.
>   */
> -void rcu_user_exit(void)
> +void noinstr rcu_user_exit(void)
>  {
>  	rcu_eqs_exit(1);
>  }
> @@ -830,27 +833,33 @@ static __always_inline void rcu_nmi_ente
>  			rcu_cleanup_after_idle();
>  
>  		incby = 1;
> -	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
> -		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
> -		   READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
> +	} else if (irq) {
>  		// We get here only if we had already exited the extended
>  		// quiescent state and this was an interrupt (not an NMI).
>  		// Therefore, (1) RCU is already watching and (2) The fact
>  		// that we are in an interrupt handler and that the rcu_node
>  		// lock is an irq-disabled lock prevents self-deadlock.
>  		// So we can safely recheck under the lock.

The above comment is a bit misleading in this location.

> -		raw_spin_lock_rcu_node(rdp->mynode);
> -		if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
> -			// A nohz_full CPU is in the kernel and RCU
> -			// needs a quiescent state.  Turn on the tick!
> -			rdp->rcu_forced_tick = true;
> -			tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
> +		instr_begin();
> +		if (tick_nohz_full_cpu(rdp->cpu) &&
> +		    rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
> +		    READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {

So how about like this?

			// We get here only if we had already exited
			// the extended quiescent state and this was an
			// interrupt (not an NMI).  Therefore, (1) RCU is
			// already watching and (2) The fact that we are in
			// an interrupt handler and that the rcu_node lock
			// is an irq-disabled lock prevents self-deadlock.
			// So we can safely recheck under the lock.

> +			raw_spin_lock_rcu_node(rdp->mynode);
> +			if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
> +				// A nohz_full CPU is in the kernel and RCU
> +				// needs a quiescent state.  Turn on the tick!
> +				rdp->rcu_forced_tick = true;
> +				tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
> +			}
> +			raw_spin_unlock_rcu_node(rdp->mynode);
>  		}
> -		raw_spin_unlock_rcu_node(rdp->mynode);
> +		instr_end();
>  	}
> +	instr_begin();
>  	trace_rcu_dyntick(incby == 1 ? TPS("Endirq") : TPS("++="),
>  			  rdp->dynticks_nmi_nesting,
>  			  rdp->dynticks_nmi_nesting + incby, atomic_read(&rdp->dynticks));
> +	instr_end();
>  	WRITE_ONCE(rdp->dynticks_nmi_nesting, /* Prevent store tearing. */
>  		   rdp->dynticks_nmi_nesting + incby);
>  	barrier();
> @@ -859,11 +868,10 @@ static __always_inline void rcu_nmi_ente
>  /**
>   * rcu_nmi_enter - inform RCU of entry to NMI context
>   */
> -void rcu_nmi_enter(void)
> +noinstr void rcu_nmi_enter(void)
>  {
>  	rcu_nmi_enter_common(false);
>  }
> -NOKPROBE_SYMBOL(rcu_nmi_enter);
>  
>  /**
>   * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
> @@ -932,7 +940,7 @@ static void rcu_disable_urgency_upon_qs(
>   * if the current CPU is not in its idle loop or is in an interrupt or
>   * NMI handler, return true.
>   */
> -bool notrace rcu_is_watching(void)
> +noinstr bool rcu_is_watching(void)
>  {
>  	bool ret;
>  
> @@ -976,7 +984,7 @@ void rcu_request_urgent_qs_task(struct t
>   * RCU on an offline processor during initial boot, hence the check for
>   * rcu_scheduler_fully_active.
>   */
> -bool rcu_lockdep_current_cpu_online(void)
> +noinstr bool rcu_lockdep_current_cpu_online(void)
>  {
>  	struct rcu_data *rdp;
>  	struct rcu_node *rnp;
> @@ -984,12 +992,12 @@ bool rcu_lockdep_current_cpu_online(void
>  
>  	if (in_nmi() || !rcu_scheduler_fully_active)
>  		return true;
> -	preempt_disable();
> +	preempt_disable_notrace();
>  	rdp = this_cpu_ptr(&rcu_data);
>  	rnp = rdp->mynode;
>  	if (rdp->grpmask & rcu_rnp_online_cpus(rnp))
>  		ret = true;
> -	preempt_enable();
> +	preempt_enable_notrace();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2546,7 +2546,7 @@ static void rcu_bind_gp_kthread(void)
>  }
>  
>  /* Record the current task on dyntick-idle entry. */
> -static void rcu_dynticks_task_enter(void)
> +static void noinstr rcu_dynticks_task_enter(void)
>  {
>  #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
>  	WRITE_ONCE(current->rcu_tasks_idle_cpu, smp_processor_id());
> @@ -2554,7 +2554,7 @@ static void rcu_dynticks_task_enter(void
>  }
>  
>  /* Record no current task on dyntick-idle exit. */
> -static void rcu_dynticks_task_exit(void)
> +static void noinstr rcu_dynticks_task_exit(void)
>  {
>  #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
>  	WRITE_ONCE(current->rcu_tasks_idle_cpu, -1);
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -95,7 +95,7 @@ module_param(rcu_normal_after_boot, int,
>   * Similarly, we avoid claiming an RCU read lock held if the current
>   * CPU is offline.
>   */
> -static bool rcu_read_lock_held_common(bool *ret)
> +static noinstr bool rcu_read_lock_held_common(bool *ret)
>  {
>  	if (!debug_lockdep_rcu_enabled()) {
>  		*ret = 1;
> @@ -112,7 +112,7 @@ static bool rcu_read_lock_held_common(bo
>  	return false;
>  }
>  
> -int rcu_read_lock_sched_held(void)
> +noinstr int rcu_read_lock_sched_held(void)
>  {
>  	bool ret;
>  
> @@ -246,13 +246,12 @@ struct lockdep_map rcu_callback_map =
>  	STATIC_LOCKDEP_MAP_INIT("rcu_callback", &rcu_callback_key);
>  EXPORT_SYMBOL_GPL(rcu_callback_map);
>  
> -int notrace debug_lockdep_rcu_enabled(void)
> +noinstr int notrace debug_lockdep_rcu_enabled(void)
>  {
>  	return rcu_scheduler_active != RCU_SCHEDULER_INACTIVE && debug_locks &&
>  	       current->lockdep_recursion == 0;
>  }
>  EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
> -NOKPROBE_SYMBOL(debug_lockdep_rcu_enabled);
>  
>  /**
>   * rcu_read_lock_held() - might we be in RCU read-side critical section?
> 
