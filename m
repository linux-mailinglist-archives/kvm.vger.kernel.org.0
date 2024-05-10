Return-Path: <kvm+bounces-17197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93ADE8C28A8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 18:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5411F241B9
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE39A172BB2;
	Fri, 10 May 2024 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fmb5TIUj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152251A2C3A;
	Fri, 10 May 2024 16:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715358120; cv=none; b=nt6RTrZ4XBOM5AXymHjtLk8BPSEX0Z2CsHOylzLoQVmsMgXPIsWwnVUKSzk+Qson+14j0JhwUuK0sA6LtbChL7t6BlA05Inx2x9wmZeRuzebbkVzyAL3SehI2U4KA2bV8a26fP40YWZOXZO3rlL34lVyZDsvKcLC7A3fqbQJQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715358120; c=relaxed/simple;
	bh=t65f4jnK9Y0kArp0L6VpbmFAs/ipV4rc1P0xnazLwXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqJ224wmzrEj1218xcSt8LafQ7yWZv0DOZuQ7RUJ8DJMyx7gn9itSpxyHlV0s1hx516yxUbpN3KTWLy10s3EDyaDaP24vuYEjpROcn6hVvLs5qzDJB+AHa0UHeXFk2Hmhb+62RWrwY0h3mvhIJkuJXx/HflzgT79/0KxMb5WXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fmb5TIUj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876CBC113CC;
	Fri, 10 May 2024 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715358119;
	bh=t65f4jnK9Y0kArp0L6VpbmFAs/ipV4rc1P0xnazLwXg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=Fmb5TIUjJ4cLj3bc7HmEKIirJtt7QqidVefu7pz5XqmAOhl76CobbYOFgtL5ZvWpy
	 sflTYymAun5jLWet2ilqZym4E94K9fnX+Y15uzLF+wXNdS9Ruh+P6maKdUzon5XLxF
	 x4nO6BTZWkN8dvLoZMEQjtFCJJlvc6FoIkP5dY8Q5XGAXiVYffpd1k6z0z0Uz6o/Jk
	 JGB2j/YtDjb04PbDkIyWFk8uIHZlwvCPG5U/kAkgL0Ei7N5UgXfZUZ4McPkb5/aN8T
	 DRyg4V72E7AjcORZzybmEu4ZeiigeQmoCyOCEiDEKvmWZ2xxoX+gn0Xhuv78h2Gz24
	 zeedRO4Q9WldQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 20CF1CE094C; Fri, 10 May 2024 09:21:59 -0700 (PDT)
Date: Fri, 10 May 2024 09:21:59 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras <leobras@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <a5784417-d65d-45c2-a66f-310a494b9827@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras>
 <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
 <ZjsZVUdmDXZOn10l@LeoBras>
 <ZjuFuZHKUy7n6-sG@google.com>
 <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
 <ZjyGefTZ8ThZukNG@LeoBras>
 <Zjyh-qRt3YewHsdP@LeoBras>
 <09a8f4f6-a692-4586-bb68-b0a524b7a5d8@paulmck-laptop>
 <Zj5GEK8bt3061TiD@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj5GEK8bt3061TiD@LeoBras>

On Fri, May 10, 2024 at 01:06:40PM -0300, Leonardo Bras wrote:
> On Thu, May 09, 2024 at 04:45:53PM -0700, Paul E. McKenney wrote:
> > On Thu, May 09, 2024 at 07:14:18AM -0300, Leonardo Bras wrote:
> > > On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> > 
> > [ . . . ]
> > 
> > > > Here I suppose something like this can take care of not needing to convert 
> > > > ms -> jiffies every rcu_pending():
> > > > 
> > > > +	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > > 
> > > 
> > > Uh, there is more to it, actually. We need to make sure the user 
> > > understands that we are rounding-down the value to multiple of a jiffy 
> > > period, so it's not a surprise if the delay value is not exactly the same 
> > > as the passed on kernel cmdline.
> > > 
> > > So something like bellow diff should be ok, as this behavior is explained 
> > > in the docs, and pr_info() will print the effective value.
> > > 
> > > What do you think?
> > 
> > Good point, and I have taken your advice on making the documentation
> > say what it does.
> 
> Thanks :)
> 
> > 
> > > Thanks!
> > > Leo
> > > 
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index 0a3b0fd1910e..9a50be9fd9eb 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -4974,20 +4974,28 @@
> > >                         otherwise be caused by callback floods through
> > >                         use of the ->nocb_bypass list.  However, in the
> > >                         common non-flooded case, RCU queues directly to
> > >                         the main ->cblist in order to avoid the extra
> > >                         overhead of the ->nocb_bypass list and its lock.
> > >                         But if there are too many callbacks queued during
> > >                         a single jiffy, RCU pre-queues the callbacks into
> > >                         the ->nocb_bypass queue.  The definition of "too
> > >                         many" is supplied by this kernel boot parameter.
> > >  
> > > +       rcutree.nocb_patience_delay= [KNL]
> > > +                       On callback-offloaded (rcu_nocbs) CPUs, avoid
> > > +                       disturbing RCU unless the grace period has
> > > +                       reached the specified age in milliseconds.
> > > +                       Defaults to zero.  Large values will be capped
> > > +                       at five seconds. Values rounded-down to a multiple
> > > +                       of a jiffy period.
> > > +
> > >         rcutree.qhimark= [KNL]
> > >                         Set threshold of queued RCU callbacks beyond which
> > >                         batch limiting is disabled.
> > >  
> > >         rcutree.qlowmark= [KNL]
> > >                         Set threshold of queued RCU callbacks below which
> > >                         batch limiting is re-enabled.
> > >  
> > >         rcutree.qovld= [KNL]
> > >                         Set threshold of queued RCU callbacks beyond which
> > > diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> > > index fcf2b4aa3441..62ede401420f 100644
> > > --- a/kernel/rcu/tree.h
> > > +++ b/kernel/rcu/tree.h
> > > @@ -512,20 +512,21 @@ do {                                                              \
> > >         local_irq_save(flags);                                  \
> > >         if (rcu_segcblist_is_offloaded(&(rdp)->cblist)) \
> > >                 raw_spin_lock(&(rdp)->nocb_lock);               \
> > >  } while (0)
> > >  #else /* #ifdef CONFIG_RCU_NOCB_CPU */
> > >  #define rcu_nocb_lock_irqsave(rdp, flags) local_irq_save(flags)
> > >  #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
> > >  
> > >  static void rcu_bind_gp_kthread(void);
> > >  static bool rcu_nohz_full_cpu(void);
> > > +static bool rcu_on_patience_delay(void);
> > 
> > I don't think we need an access function, but will check below.
> > 
> > >  /* Forward declarations for tree_stall.h */
> > >  static void record_gp_stall_check_time(void);
> > >  static void rcu_iw_handler(struct irq_work *iwp);
> > >  static void check_cpu_stall(struct rcu_data *rdp);
> > >  static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
> > >                                      const unsigned long gpssdelay);
> > >  
> > >  /* Forward declarations for tree_exp.h. */
> > >  static void sync_rcu_do_polled_gp(struct work_struct *wp);
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index 340bbefe5f65..639243b0410f 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -5,20 +5,21 @@
> > >   * or preemptible semantics.
> > >   *
> > >   * Copyright Red Hat, 2009
> > >   * Copyright IBM Corporation, 2009
> > >   *
> > >   * Author: Ingo Molnar <mingo@elte.hu>
> > >   *        Paul E. McKenney <paulmck@linux.ibm.com>
> > >   */
> > >  
> > >  #include "../locking/rtmutex_common.h"
> > > +#include <linux/jiffies.h>
> > 
> > This is already pulled in by the enclosing tree.c file, so it should not
> > be necessary to include it again. 
> 
> Even better :)
> 
> > (Or did you get a build failure when
> > leaving this out?)
> 
> I didn't, it's just that my editor complained the symbols were not getting 
> properly resolved, so I included it and it was fixed. But since clangd is 
> know to make some mistakes, I should have compile-test'd before adding it.

Ah, got it!  ;-)

> > >  static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
> > >  {
> > >         /*
> > >          * In order to read the offloaded state of an rdp in a safe
> > >          * and stable way and prevent from its value to be changed
> > >          * under us, we must either hold the barrier mutex, the cpu
> > >          * hotplug lock (read or write) or the nocb lock. Local
> > >          * non-preemptible reads are also safe. NOCB kthreads and
> > >          * timers have their own means of synchronization against the
> > > @@ -86,20 +87,33 @@ static void __init rcu_bootup_announce_oddness(void)
> > >         if (rcu_kick_kthreads)
> > >                 pr_info("\tKick kthreads if too-long grace period.\n");
> > >         if (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD))
> > >                 pr_info("\tRCU callback double-/use-after-free debug is enabled.\n");
> > >         if (gp_preinit_delay)
> > >                 pr_info("\tRCU debug GP pre-init slowdown %d jiffies.\n", gp_preinit_delay);
> > >         if (gp_init_delay)
> > >                 pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
> > >         if (gp_cleanup_delay)
> > >                 pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> > > +       if (nocb_patience_delay < 0) {
> > > +               pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n",
> > > +                       nocb_patience_delay);
> > > +               nocb_patience_delay = 0;
> > > +       } else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > > +               pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n",
> > > +                       nocb_patience_delay, 5 * MSEC_PER_SEC);
> > > +               nocb_patience_delay = msecs_to_jiffies(5 * MSEC_PER_SEC);
> > > +       } else if (nocb_patience_delay) {
> > > +               nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > +               pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n",
> > > +                       jiffies_to_msecs(nocb_patience_delay);
> > > +       }
> > 
> > I just did this here at the end:
> > 
> > 	nocb_patience_delay_jiffies = msecs_to_jiffies(nocb_patience_delay);
> > 
> > Ah, you are wanting to print out the milliseconds after the rounding
> > to jiffies.
> 
> That's right, just to make sure the user gets the effective patience time, 
> instead of the before-rounding one, which was on input.
> 
> > I am going to hold off on that for the moment, but I hear your request
> > and I have not yet said "no".  ;-)
> 
> Sure :)
> It's just something I think it's nice to have (as a user).

If you would like to do a separate patch adding this, here are the
requirements:

o	If the current code prints nothing, nothing additional should
	be printed.

o	If the rounding ended up with the same value (as it should in
	systems with HZ=1000), nothing additional should be printed.

o	Your choice as to whether or not you want to print out the
	jiffies value.

o	If the additional message is on a new line, it needs to be
	indented so that it is clear that it is subordinate to the
	previous message.

	Otherwise, you can use pr_cont() to continue the previous
	line, of course being careful about "\n".

Probably also something that I am forgetting, but that is most of it.

> > >         if (!use_softirq)
> > >                 pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
> > >         if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> > >                 pr_info("\tRCU debug extended QS entry/exit.\n");
> > >         rcupdate_announce_bootup_oddness();
> > >  }
> > >  
> > >  #ifdef CONFIG_PREEMPT_RCU
> > >  
> > >  static void rcu_report_exp_rnp(struct rcu_node *rnp, bool wake);
> > > @@ -1260,10 +1274,29 @@ static bool rcu_nohz_full_cpu(void)
> > >  
> > >  /*
> > >   * Bind the RCU grace-period kthreads to the housekeeping CPU.
> > >   */
> > >  static void rcu_bind_gp_kthread(void)
> > >  {
> > >         if (!tick_nohz_full_enabled())
> > >                 return;
> > >         housekeeping_affine(current, HK_TYPE_RCU);
> > >  }
> > > +
> > > +/*
> > > + * Is this CPU a NO_HZ_FULL CPU that should ignore RCU if the time since the
> > > + * start of current grace period is smaller than nocb_patience_delay ?
> > > + *
> > > + * This code relies on the fact that all NO_HZ_FULL CPUs are also
> > > + * RCU_NOCB_CPU CPUs.
> > > + */
> > > +static bool rcu_on_patience_delay(void)
> > > +{
> > > +#ifdef CONFIG_NO_HZ_FULL
> > 
> > You lost me on this one.  Why do we need the #ifdef instead of
> > IS_ENABLED()?  Also, please note that rcu_nohz_full_cpu() is already a
> > compile-time @false in CONFIG_NO_HZ_FULL=n kernels.
> 
> You are right. rcu_nohz_full_cpu() has a high chance of being inlined on
> 	if ((...) && rcu_nohz_full_cpu())
> And since it returns false, this whole statement will be compiled out, and 
> the new function will not exist in CONFIG_NO_HZ_FULL=n, so there  is no 
> need to test it.

Very good!  You had me going there for a bit.  ;-)

> > > +       if (!nocb_patience_delay)
> > > +               return false;
> > 
> > We get this automatically with the comparison below, right?
> 
> Right
> 
> >   If so, we
> > are not gaining much by creating the helper function.  Or am I missing
> > some trick here?
> 
> Well, it's a fastpath. Up to here, we just need to read 
> nocb_patience_delay{,_jiffies} from memory.

Just nocb_patience_delay_jiffies, correct?  Unless I am missing something,
nocb_patience_delay is unused after boot.

> If we don't include the fastpath we have to read jiffies and 
> rcu_state.gp_start, which can take extra time: up to 2 cache misses.
> 
> I thought it could be relevant, as we reduce the overhead of the new 
> parameter when it's disabled (patience=0). 
> 
> Do you think that could be relevant?

Well, the hardware's opinion is what matters.  ;-)

But the caller's code path reads jiffies a few times, so it should
be hot in the cache, correct?

But that does lead to another topic, namely the possibility of tagging
nocb_patience_delay_jiffies with __read_mostly.  And there might be
a number of other of RCU's variables that could be similarly tagged
in order to avoid false sharing.  (But is there any false sharing?
This might be worth testing.)

							Thanx, Paul

> Thanks!
> Leo
> 
> > 
> > 							Thanx, Paul
> > 
> > > +       if (time_before(jiffies, READ_ONCE(rcu_state.gp_start) + nocb_patience_delay))
> > > +               return true;
> > > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > > +       return false;
> > > +}
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index 7560e204198b..7a2d94370ab4 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -169,20 +169,22 @@ static int kthread_prio = IS_ENABLED(CONFIG_RCU_BOOST) ? 1 : 0;
> > >  module_param(kthread_prio, int, 0444);
> > >  
> > >  /* Delay in jiffies for grace-period initialization delays, debug only. */
> > >  
> > >  static int gp_preinit_delay;
> > >  module_param(gp_preinit_delay, int, 0444);
> > >  static int gp_init_delay;
> > >  module_param(gp_init_delay, int, 0444);
> > >  static int gp_cleanup_delay;
> > >  module_param(gp_cleanup_delay, int, 0444);
> > > +static int nocb_patience_delay;
> > > +module_param(nocb_patience_delay, int, 0444);
> > >  
> > >  // Add delay to rcu_read_unlock() for strict grace periods.
> > >  static int rcu_unlock_delay;
> > >  #ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
> > >  module_param(rcu_unlock_delay, int, 0444);
> > >  #endif
> > >  
> > >  /*
> > >   * This rcu parameter is runtime-read-only. It reflects
> > >   * a minimum allowed number of objects which can be cached
> > > @@ -4340,25 +4342,27 @@ static int rcu_pending(int user)
> > >         lockdep_assert_irqs_disabled();
> > >  
> > >         /* Check for CPU stalls, if enabled. */
> > >         check_cpu_stall(rdp);
> > >  
> > >         /* Does this CPU need a deferred NOCB wakeup? */
> > >         if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
> > >                 return 1;
> > >  
> > >         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > > -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > > +       gp_in_progress = rcu_gp_in_progress();
> > > +       if ((user || rcu_is_cpu_rrupt_from_idle() ||
> > > +            (gp_in_progress && rcu_on_patience_delay())) &&
> > > +           rcu_nohz_full_cpu())
> > >                 return 0;
> > >  
> > >         /* Is the RCU core waiting for a quiescent state from this CPU? */
> > > -       gp_in_progress = rcu_gp_in_progress();
> > >         if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
> > >                 return 1;
> > >  
> > >         /* Does this CPU have callbacks ready to invoke? */
> > >         if (!rcu_rdp_is_offloaded(rdp) &&
> > >             rcu_segcblist_ready_cbs(&rdp->cblist))
> > >                 return 1;
> > >  
> > >         /* Has RCU gone idle with this CPU needing another grace period? */
> > >         if (!gp_in_progress && rcu_segcblist_is_enabled(&rdp->cblist) &&
> > > 
> > > 
> > > 
> > 
> 
> 

