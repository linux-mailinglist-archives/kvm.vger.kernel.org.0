Return-Path: <kvm+bounces-13282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF7F893D85
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 17:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FFF81C21D5A
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 15:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356884D5A0;
	Mon,  1 Apr 2024 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maCQSVj7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C04CDEC;
	Mon,  1 Apr 2024 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986743; cv=none; b=OroiuCmroVElvS7YGl3RW+VD76LOEXW5O6caTs4ddjMGwUv1mX0yyo8T1gdp8ss0iykXVpYK3cp1vFAFfd6Qlx5DgeTKUQnY6aIgsxhbzkdFmE9lhfgZfVSQ5jc0LTEmLyKu8DRcCBOe+yP28sEm8zlRhGhc0qV501sCNxTOZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986743; c=relaxed/simple;
	bh=uIutiB+eFvtzipMrxJvLjeiPeG6GFWVZ0ZS/y6LRjGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iELN8PJUlEdb1Rb2sDOGaepP8gwSG5rW5wj0zyghbUXbOxwd/wyG6iobALQrfaHGHieN79tOz6NM9fQqls1hgRzUsl+rYVPFTrsxsaM5CexdO/oz3jUa3C0ATHhh9Iq/iLECJ8kKLRWn3bIG2vIkgEmTp4tfVlnMqpJ90siZ+OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maCQSVj7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1527DC433C7;
	Mon,  1 Apr 2024 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711986743;
	bh=uIutiB+eFvtzipMrxJvLjeiPeG6GFWVZ0ZS/y6LRjGU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=maCQSVj7j4KkshiBSoREmRa4yq4iZt5uxfMsJkGTonSY3n/GY7KWRMQcANBFLHif1
	 rvM8fOo4rvJL3owxfRJzk7Dit/OugetLeKm3FrjVgbTHoSy1lNNf3JlRvRsPbPQBj4
	 J0sjdd+xgI1vQbuEy+n3dqwLNO0FMYyzLPhMiuRxlaAJPC+qaQqT9riuzQ4oVhVwIz
	 J5g5jHiqD+sexrW+EzhJnH/YBKDOls2OvdzKbgV3NY82+pG064WikCinLrmVc8FDOh
	 Tve5M4RStj9v9/OmJjakhVxaGvvBLVg+Q1j2eqn+UD3AuFebHEWfmZCl0WN0VqwgHD
	 d1krplPPRuwnw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id B2B10CE0738; Mon,  1 Apr 2024 08:52:22 -0700 (PDT)
Date: Mon, 1 Apr 2024 08:52:22 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras <leobras@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/2] rcu: Ignore RCU in nohz_full cpus if it was
 running a guest recently
Message-ID: <b616a57b-56bf-4cdd-abc3-f2064b14abf6@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <20240328171949.743211-3-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328171949.743211-3-leobras@redhat.com>

On Thu, Mar 28, 2024 at 02:19:47PM -0300, Leonardo Bras wrote:
> In current code, we can ignore the RCU request on a nohz_full cpu for up to
> a second if it has interrupted idle or userspace tasks, since those are
> quiescent states, and will probably return to it soon thus not requiring
> to run a softirq or a rcuc thread.
> 
> Running a guest is also considered to be a quiescent state, and will
> follow the same logic, so it makes sense to also ignore the RCU request in
> this case.
> 
> This solves a latency issue of a latency-sensitive workload running on a
> guest pinned in nohz_full cpu: if the guest goes out for any reason, and a
> synchronize_rcu() is requested between guest exit and a timer interrupt,
> then invoke_rcu_core() is called, and introduce latency due to either a
> softirq, or a reschedule to run rcuc, if the host is a PREEMPT_RT kernel.
> 
> Suggested-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Leonardo Bras <leobras@redhat.com>

Looks plausible to me!

Acked-by: Paul E. McKenney <paulmck@kernel.org>

Or let me know if you would rather these go through -rcu.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 14 ++++++++++++++
>  kernel/rcu/tree.c        |  4 +++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 36a8b5dbf5b5..16f3cf2e15df 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -5,20 +5,21 @@
>   * or preemptible semantics.
>   *
>   * Copyright Red Hat, 2009
>   * Copyright IBM Corporation, 2009
>   *
>   * Author: Ingo Molnar <mingo@elte.hu>
>   *	   Paul E. McKenney <paulmck@linux.ibm.com>
>   */
>  
>  #include "../locking/rtmutex_common.h"
> +#include "linux/kvm_host.h"
>  
>  static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
>  {
>  	/*
>  	 * In order to read the offloaded state of an rdp in a safe
>  	 * and stable way and prevent from its value to be changed
>  	 * under us, we must either hold the barrier mutex, the cpu
>  	 * hotplug lock (read or write) or the nocb lock. Local
>  	 * non-preemptible reads are also safe. NOCB kthreads and
>  	 * timers have their own means of synchronization against the
> @@ -1260,10 +1261,23 @@ static bool rcu_nohz_full_cpu(void)
>  
>  /*
>   * Bind the RCU grace-period kthreads to the housekeeping CPU.
>   */
>  static void rcu_bind_gp_kthread(void)
>  {
>  	if (!tick_nohz_full_enabled())
>  		return;
>  	housekeeping_affine(current, HK_TYPE_RCU);
>  }
> +
> +/*
> + * true if for this cpu guest exit is at most over a second ago,
> + * false otherwise
> + */
> +static bool rcu_recent_guest_exit(void)
> +{
> +#ifdef CONFIG_KVM
> +	return time_before(jiffies, guest_exit_last_time() + HZ);
> +#else
> +	return false;
> +#endif
> +}
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index d9642dd06c25..e5ce00bf1898 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -148,20 +148,21 @@ static void rcu_report_qs_rnp(unsigned long mask, struct rcu_node *rnp,
>  static struct task_struct *rcu_boost_task(struct rcu_node *rnp);
>  static void invoke_rcu_core(void);
>  static void rcu_report_exp_rdp(struct rcu_data *rdp);
>  static void sync_sched_exp_online_cleanup(int cpu);
>  static void check_cb_ovld_locked(struct rcu_data *rdp, struct rcu_node *rnp);
>  static bool rcu_rdp_is_offloaded(struct rcu_data *rdp);
>  static bool rcu_rdp_cpu_online(struct rcu_data *rdp);
>  static bool rcu_init_invoked(void);
>  static void rcu_cleanup_dead_rnp(struct rcu_node *rnp_leaf);
>  static void rcu_init_new_rnp(struct rcu_node *rnp_leaf);
> +static bool rcu_recent_guest_exit(void);
>  
>  /*
>   * rcuc/rcub/rcuop kthread realtime priority. The "rcuop"
>   * real-time priority(enabling/disabling) is controlled by
>   * the extra CONFIG_RCU_NOCB_CPU_CB_BOOST configuration.
>   */
>  static int kthread_prio = IS_ENABLED(CONFIG_RCU_BOOST) ? 1 : 0;
>  module_param(kthread_prio, int, 0444);
>  
>  /* Delay in jiffies for grace-period initialization delays, debug only. */
> @@ -3931,21 +3932,22 @@ static int rcu_pending(int user)
>  	lockdep_assert_irqs_disabled();
>  
>  	/* Check for CPU stalls, if enabled. */
>  	check_cpu_stall(rdp);
>  
>  	/* Does this CPU need a deferred NOCB wakeup? */
>  	if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
>  		return 1;
>  
>  	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> +	if ((user || rcu_is_cpu_rrupt_from_idle() || rcu_recent_guest_exit()) &&
> +	    rcu_nohz_full_cpu())
>  		return 0;
>  
>  	/* Is the RCU core waiting for a quiescent state from this CPU? */
>  	gp_in_progress = rcu_gp_in_progress();
>  	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
>  		return 1;
>  
>  	/* Does this CPU have callbacks ready to invoke? */
>  	if (!rcu_rdp_is_offloaded(rdp) &&
>  	    rcu_segcblist_ready_cbs(&rdp->cblist))
> -- 
> 2.44.0
> 

