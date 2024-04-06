Return-Path: <kvm+bounces-13782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1933889A7D0
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 02:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84A8F1F2376F
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAC4225CF;
	Sat,  6 Apr 2024 00:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIQMKTIg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A5C208D0;
	Sat,  6 Apr 2024 00:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361819; cv=none; b=YkMWesKhr162tF/CFPHY29xy9L8sRF9RU2ylswjXL3/GbJcpCf5kh33eypz+7TWuDD+9TASOL+M6bGvLlNB9ypp84EMgjzOmy79HyG06XTaQKffzga2PN8B+xP6A29CZ33f/IONwB80ZIdHv1G82qDZiZuL1bw26cX2VWenBuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361819; c=relaxed/simple;
	bh=/8MwNaiRY+AmBAKuNcPjP93eohZNaFK95VdK7cN6V+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWiIJ8bGpdZbx49td+l8BlUBNT+veWDoRdLLg2E8ifAorjyfovdweB6LPRl8g4qMJWXHL10/KrxlP4le9w2nSFukEODTO8gli0uo8BD4U29VqDejEVK82yCYIaQLQah5nAp9x9X0FD8PRICn/s/H1cxjXUfkStZuYXkj562aTyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIQMKTIg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D7C433F1;
	Sat,  6 Apr 2024 00:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712361819;
	bh=/8MwNaiRY+AmBAKuNcPjP93eohZNaFK95VdK7cN6V+E=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=IIQMKTIgJpMXLzgfTIzcQPwXLiLBv75hFu4LKHOsjVuDoGJS+oHcA4+PhJXbJT6V4
	 VwaqzcbPhRv9l4hFHX30xqs47xmmVlXEFwDKk7ZB948iS0ywzSxjvwu3yukkcMMp3E
	 WH6dwWijOLTlrSxkHnBXxUq00utZIR3Vfq1ZxscZYeIBBvT1LJosrtvs8b9Auu/sAc
	 8RziOH04gfLgKm0QLGtBe7VckougpPn58E1aWpZPS9TEz3ZljO68TwJXceLBeQ4gA/
	 OQyYBPKvwOhhNsL0S7Q/TBDxSTgvtoHX/0istF6vnVykpF4G9zWxUMKTdB/kLR9zAF
	 CiisVfk35QMaA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id ACB84CE11CE; Fri,  5 Apr 2024 17:03:38 -0700 (PDT)
Date: Fri, 5 Apr 2024 17:03:38 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Leonardo Bras <leobras@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhAN28BcMsfl4gm-@google.com>

On Fri, Apr 05, 2024 at 07:42:35AM -0700, Sean Christopherson wrote:
> On Fri, Apr 05, 2024, Marcelo Tosatti wrote:
> > On Mon, Apr 01, 2024 at 01:21:25PM -0700, Sean Christopherson wrote:
> > > On Thu, Mar 28, 2024, Leonardo Bras wrote:
> > > > I am dealing with a latency issue inside a KVM guest, which is caused by
> > > > a sched_switch to rcuc[1].
> > > > 
> > > > During guest entry, kernel code will signal to RCU that current CPU was on
> > > > a quiescent state, making sure no other CPU is waiting for this one.
> > > > 
> > > > If a vcpu just stopped running (guest_exit), and a syncronize_rcu() was
> > > > issued somewhere since guest entry, there is a chance a timer interrupt
> > > > will happen in that CPU, which will cause rcu_sched_clock_irq() to run.
> > > > 
> > > > rcu_sched_clock_irq() will check rcu_pending() which will return true,
> > > > and cause invoke_rcu_core() to be called, which will (in current config)
> > > > cause rcuc/N to be scheduled into the current cpu.
> > > > 
> > > > On rcu_pending(), I noticed we can avoid returning true (and thus invoking
> > > > rcu_core()) if the current cpu is nohz_full, and the cpu came from either
> > > > idle or userspace, since both are considered quiescent states.
> > > > 
> > > > Since this is also true to guest context, my idea to solve this latency
> > > > issue by avoiding rcu_core() invocation if it was running a guest vcpu.
> > > > 
> > > > On the other hand, I could not find a way of reliably saying the current
> > > > cpu was running a guest vcpu, so patch #1 implements a per-cpu variable
> > > > for keeping the time (jiffies) of the last guest exit.
> > > > 
> > > > In patch #2 I compare current time to that time, and if less than a second
> > > > has past, we just skip rcu_core() invocation, since there is a high chance
> > > > it will just go back to the guest in a moment.
> > > 
> > > What's the downside if there's a false positive?
> > 
> > rcuc wakes up (which might exceed the allowed latency threshold
> > for certain realtime apps).
> 
> Isn't that a false negative? (RCU doesn't detect that a CPU is about to (re)enter
> a guest)  I was trying to ask about the case where RCU thinks a CPU is about to
> enter a guest, but the CPU never does (at least, not in the immediate future).
> 
> Or am I just not understanding how RCU's kthreads work?

It is quite possible that the current rcu_pending() code needs help,
given the possibility of vCPU preemption.  I have heard of people doing
nested KVM virtualization -- or is that no longer a thing?

But the help might well involve RCU telling the hypervisor that a given
vCPU needs to run.  Not sure how that would go over, though it has been
prototyped a couple times in the context of RCU priority boosting.

> > > > What I know it's weird with this patch:
> > > > 1 - Not sure if this is the best way of finding out if the cpu was
> > > >     running a guest recently.
> > > > 
> > > > 2 - This per-cpu variable needs to get set at each guest_exit(), so it's
> > > >     overhead, even though it's supposed to be in local cache. If that's
> > > >     an issue, I would suggest having this part compiled out on 
> > > >     !CONFIG_NO_HZ_FULL, but further checking each cpu for being nohz_full
> > > >     enabled seems more expensive than just setting this out.
> > > 
> > > A per-CPU write isn't problematic, but I suspect reading jiffies will be quite
> > > imprecise, e.g. it'll be a full tick "behind" on many exits.
> > > 
> > > > 3 - It checks if the guest exit happened over than 1 second ago. This 1
> > > >     second value was copied from rcu_nohz_full_cpu() which checks if the
> > > >     grace period started over than a second ago. If this value is bad,
> > > >     I have no issue changing it.
> > > 
> > > IMO, checking if a CPU "recently" ran a KVM vCPU is a suboptimal heuristic regardless
> > > of what magic time threshold is used.  
> > 
> > Why? It works for this particular purpose.
> 
> Because maintaining magic numbers is no fun, AFAICT the heurisitic doesn't guard
> against edge cases, and I'm pretty sure we can do better with about the same amount
> of effort/churn.

Beyond a certain point, we have no choice.  How long should RCU let
a CPU run with preemption disabled before complaining?  We choose 21
seconds in mainline and some distros choose 60 seconds.  Android chooses
20 milliseconds for synchronize_rcu_expedited() grace periods.

> > > IIUC, what you want is a way to detect if a CPU is likely to _run_ a KVM
> > > vCPU in the near future.  KVM can provide that information with much better
> > > precision, e.g. KVM knows when when it's in the core vCPU run loop.
> > 
> > ktime_t ktime_get(void)
> > {
> >         struct timekeeper *tk = &tk_core.timekeeper;
> >         unsigned int seq;
> >         ktime_t base;
> >         u64 nsecs;
> > 
> >         WARN_ON(timekeeping_suspended);
> > 
> >         do {
> >                 seq = read_seqcount_begin(&tk_core.seq);
> >                 base = tk->tkr_mono.base;
> >                 nsecs = timekeeping_get_ns(&tk->tkr_mono);
> > 
> >         } while (read_seqcount_retry(&tk_core.seq, seq));
> > 
> >         return ktime_add_ns(base, nsecs);
> > }
> > EXPORT_SYMBOL_GPL(ktime_get);
> > 
> > ktime_get() is more expensive than unsigned long assignment.
> 
> Huh?  What does ktime_get() have to do with anything?  I'm suggesting something
> like the below (wants_to_run is from an in-flight patch,
> https://lore.kernel.org/all/20240307163541.92138-1-dmatlack@google.com).

Interesting.  Some questions below, especially if we are doing nested
virtualization.

> ---
>  include/linux/context_tracking.h       | 12 ++++++++++++
>  include/linux/context_tracking_state.h |  3 +++
>  kernel/rcu/tree.c                      |  9 +++++++--
>  virt/kvm/kvm_main.c                    |  7 +++++++
>  4 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index 6e76b9dba00e..59bc855701c5 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -86,6 +86,16 @@ static __always_inline void context_tracking_guest_exit(void)
>  		__ct_user_exit(CONTEXT_GUEST);
>  }
>  
> +static inline void context_tracking_guest_start_run_loop(void)
> +{
> +	__this_cpu_write(context_tracking.in_guest_run_loop, true);
> +}
> +
> +static inline void context_tracking_guest_stop_run_loop(void)
> +{
> +	__this_cpu_write(context_tracking.in_guest_run_loop, false);
> +}
> +
>  #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
>  
>  #else
> @@ -99,6 +109,8 @@ static inline int ct_state(void) { return -1; }
>  static inline int __ct_state(void) { return -1; }
>  static __always_inline bool context_tracking_guest_enter(void) { return false; }
>  static __always_inline void context_tracking_guest_exit(void) { }
> +static inline void context_tracking_guest_start_run_loop(void) { }
> +static inline void context_tracking_guest_stop_run_loop(void) { }
>  #define CT_WARN_ON(cond) do { } while (0)
>  #endif /* !CONFIG_CONTEXT_TRACKING_USER */
>  
> diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
> index bbff5f7f8803..629ada1a4d81 100644
> --- a/include/linux/context_tracking_state.h
> +++ b/include/linux/context_tracking_state.h
> @@ -25,6 +25,9 @@ enum ctx_state {
>  #define CT_DYNTICKS_MASK (~CT_STATE_MASK)
>  
>  struct context_tracking {
> +#if IS_ENABLED(CONFIG_KVM)
> +	bool in_guest_run_loop;
> +#endif
>  #ifdef CONFIG_CONTEXT_TRACKING_USER
>  	/*
>  	 * When active is false, probes are unset in order
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index d9642dd06c25..303ae9ae1c53 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3937,8 +3937,13 @@ static int rcu_pending(int user)
>  	if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
>  		return 1;
>  
> -	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> +	/*
> +	 * Is this a nohz_full CPU in userspace, idle, or likely to enter a
> +	 * guest in the near future?  (Ignore RCU if so.)
> +	 */
> +	if ((user || rcu_is_cpu_rrupt_from_idle() ||
> +	     __this_cpu_read(context_tracking.in_guest_run_loop)) &&

In the case of (user || rcu_is_cpu_rrupt_from_idle()), this CPU was in
a quiescent just before the current scheduling-clock interrupt and will
again be in a quiescent state right after return from this interrupt.
This means that the grace-period kthread will be able to remotely sense
this quiescent state, so that the current CPU need do nothing.

In constrast, it looks like context_tracking.in_guest_run_loop instead
means that when we return from this interrupt, this CPU will still be
in a non-quiescent state.

Now, in the nested-virtualization case, your point might be that the
lower-level hypervisor could preempt the vCPU in the interrupt handler
just as easily as in the .in_guest_run_loop code.  Which is a good point.
But I don't know of a way to handle this other than heuristics and maybe
hinting to the hypervisor (which has been prototyped for RCU priority
boosting).

Maybe the time for such hinting has come?

> +	    rcu_nohz_full_cpu())

And rcu_nohz_full_cpu() has a one-second timeout, and has for quite
some time.

>  		return 0;
>  
>  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index bfb2b52a1416..5a7efc669a0f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -209,6 +209,9 @@ void vcpu_load(struct kvm_vcpu *vcpu)
>  {
>  	int cpu = get_cpu();
>  
> +	if (vcpu->wants_to_run)
> +		context_tracking_guest_start_run_loop();

At this point, if this is a nohz_full CPU, it will no longer report
quiescent states until the grace period is at least one second old.

> +
>  	__this_cpu_write(kvm_running_vcpu, vcpu);
>  	preempt_notifier_register(&vcpu->preempt_notifier);
>  	kvm_arch_vcpu_load(vcpu, cpu);
> @@ -222,6 +225,10 @@ void vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_put(vcpu);
>  	preempt_notifier_unregister(&vcpu->preempt_notifier);
>  	__this_cpu_write(kvm_running_vcpu, NULL);
> +

And also at this point, if this is a nohz_full CPU, it will no longer
report quiescent states until the grace period is at least one second old.

> +	if (vcpu->wants_to_run)
> +		context_tracking_guest_stop_run_loop();
> +
>  	preempt_enable();
>  }
>  EXPORT_SYMBOL_GPL(vcpu_put);
> 
> base-commit: 619e56a3810c88b8d16d7b9553932ad05f0d4968

All of which might be OK.  Just checking as to whether all of that was
in fact the intent.

							Thanx, Paul

