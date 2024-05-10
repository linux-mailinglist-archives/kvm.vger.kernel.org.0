Return-Path: <kvm+bounces-17232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAEB8C2BF8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 626BB283E40
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E1013C665;
	Fri, 10 May 2024 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6dsrSu9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A1D13C3E1;
	Fri, 10 May 2024 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715377111; cv=none; b=G+Hdbo9PuaAa5jxWwZjGmo6hfEpjz0TljsRYk6QMZ1c37vfDFokBlNceyeFc/m3TIX9JskhuY4P9XI+1sRdESJraAtVJs3nHQ+W4a50oxpC1ch6fFTNTn0F9xAwCsotIkhJkT9LP7x6AH+5QzoXMlkY8A11o2rfpI183fvfJLDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715377111; c=relaxed/simple;
	bh=66Qdw7PNH8lENGMIP7hFe96TUgiWpJnxSGEpQhVvjtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2DTF4rH7Yp5FddeZR/ZdlVD0PUMtT8t3cBtg61isISj+O2pvx2cE2cqUsL2EGWXF6gzln3dCL5DcW3AOLO/14P5hzdmrIapVzzkzMpuFjDyCiH8Y+D5wMTGeX3Sppc0ZPYUbiMhFFpv953gM4jEOsHFQ3rEjOpvA4HxMDFb4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6dsrSu9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D9CC113CC;
	Fri, 10 May 2024 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715377110;
	bh=66Qdw7PNH8lENGMIP7hFe96TUgiWpJnxSGEpQhVvjtI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=q6dsrSu9pD5NCMfoKX7yGl9r1ADJawuQZM1bgpnl5S166QDNXeLHceK9QfJZ+o70V
	 BhUeT+gfAdJkKQI+Av7dnse1eUayhKblceZ33rgjAImbVNUCkcLK0OI1Nv/Kj8aply
	 oL8OIwhf3sgKL+lf4NIcurhpSr8SWJUvVg5fJvEj6nn1tamaMVhCDmiHTvy44eaUZ+
	 1XkA2jj76kEC8f0ujI4O0zPVYNo30W0LI6XgcqFsq4fm1bK7V0ulrdO3wZYrNiVyl2
	 3tX3bCGq1kbbMv7WLyaWFkdAZYO976Y+sgvD1HUBFjuslMZ81fqDHjp6tkMiBOO0WC
	 ja9nnCqGfzUDw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 8BF91CE0F90; Fri, 10 May 2024 14:38:30 -0700 (PDT)
Date: Fri, 10 May 2024 14:38:30 -0700
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
Message-ID: <fe92ac26-9a6f-430d-952b-ff139b723953@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
 <ZjyGefTZ8ThZukNG@LeoBras>
 <Zjyh-qRt3YewHsdP@LeoBras>
 <09a8f4f6-a692-4586-bb68-b0a524b7a5d8@paulmck-laptop>
 <Zj5GEK8bt3061TiD@LeoBras>
 <a5784417-d65d-45c2-a66f-310a494b9827@paulmck-laptop>
 <Zj5VgM_RzaDWQs1t@LeoBras>
 <d5021b48-09d6-4a54-9874-740051aab574@paulmck-laptop>
 <Zj56kVxuTJm4EsAn@LeoBras>
 <Zj6OYvivXF7tUIqV@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj6OYvivXF7tUIqV@LeoBras>

On Fri, May 10, 2024 at 06:15:14PM -0300, Leonardo Bras wrote:
> On Fri, May 10, 2024 at 04:50:41PM -0300, Leonardo Bras wrote:
> > On Fri, May 10, 2024 at 10:41:53AM -0700, Paul E. McKenney wrote:
> > > On Fri, May 10, 2024 at 02:12:32PM -0300, Leonardo Bras wrote:
> > > > On Fri, May 10, 2024 at 09:21:59AM -0700, Paul E. McKenney wrote:
> > > > > On Fri, May 10, 2024 at 01:06:40PM -0300, Leonardo Bras wrote:
> > > > > > On Thu, May 09, 2024 at 04:45:53PM -0700, Paul E. McKenney wrote:
> > > > > > > On Thu, May 09, 2024 at 07:14:18AM -0300, Leonardo Bras wrote:
> > > > > > > > On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> > > > > > > 
> > > > > > > [ . . . ]
> > > > > > > 
> > > > > > > > > Here I suppose something like this can take care of not needing to convert 
> > > > > > > > > ms -> jiffies every rcu_pending():
> > > > > > > > > 
> > > > > > > > > +	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Uh, there is more to it, actually. We need to make sure the user 
> > > > > > > > understands that we are rounding-down the value to multiple of a jiffy 
> > > > > > > > period, so it's not a surprise if the delay value is not exactly the same 
> > > > > > > > as the passed on kernel cmdline.
> > > > > > > > 
> > > > > > > > So something like bellow diff should be ok, as this behavior is explained 
> > > > > > > > in the docs, and pr_info() will print the effective value.
> > > > > > > > 
> > > > > > > > What do you think?
> > > > > > > 
> > > > > > > Good point, and I have taken your advice on making the documentation
> > > > > > > say what it does.
> > > > > > 
> > > > > > Thanks :)
> > > > > > 
> > > > > > > 
> > > > > > > > Thanks!
> > > > > > > > Leo
> > > > > > > > 
> > > > > > > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > > index 0a3b0fd1910e..9a50be9fd9eb 100644
> > > > > > > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > > @@ -4974,20 +4974,28 @@
> > > > > > > >                         otherwise be caused by callback floods through
> > > > > > > >                         use of the ->nocb_bypass list.  However, in the
> > > > > > > >                         common non-flooded case, RCU queues directly to
> > > > > > > >                         the main ->cblist in order to avoid the extra
> > > > > > > >                         overhead of the ->nocb_bypass list and its lock.
> > > > > > > >                         But if there are too many callbacks queued during
> > > > > > > >                         a single jiffy, RCU pre-queues the callbacks into
> > > > > > > >                         the ->nocb_bypass queue.  The definition of "too
> > > > > > > >                         many" is supplied by this kernel boot parameter.
> > > > > > > >  
> > > > > > > > +       rcutree.nocb_patience_delay= [KNL]
> > > > > > > > +                       On callback-offloaded (rcu_nocbs) CPUs, avoid
> > > > > > > > +                       disturbing RCU unless the grace period has
> > > > > > > > +                       reached the specified age in milliseconds.
> > > > > > > > +                       Defaults to zero.  Large values will be capped
> > > > > > > > +                       at five seconds. Values rounded-down to a multiple
> > > > > > > > +                       of a jiffy period.
> > > > > > > > +
> > > > > > > >         rcutree.qhimark= [KNL]
> > > > > > > >                         Set threshold of queued RCU callbacks beyond which
> > > > > > > >                         batch limiting is disabled.
> > > > > > > >  
> > > > > > > >         rcutree.qlowmark= [KNL]
> > > > > > > >                         Set threshold of queued RCU callbacks below which
> > > > > > > >                         batch limiting is re-enabled.
> > > > > > > >  
> > > > > > > >         rcutree.qovld= [KNL]
> > > > > > > >                         Set threshold of queued RCU callbacks beyond which
> > > > > > > > diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> > > > > > > > index fcf2b4aa3441..62ede401420f 100644
> > > > > > > > --- a/kernel/rcu/tree.h
> > > > > > > > +++ b/kernel/rcu/tree.h
> > > > > > > > @@ -512,20 +512,21 @@ do {                                                              \
> > > > > > > >         local_irq_save(flags);                                  \
> > > > > > > >         if (rcu_segcblist_is_offloaded(&(rdp)->cblist)) \
> > > > > > > >                 raw_spin_lock(&(rdp)->nocb_lock);               \
> > > > > > > >  } while (0)
> > > > > > > >  #else /* #ifdef CONFIG_RCU_NOCB_CPU */
> > > > > > > >  #define rcu_nocb_lock_irqsave(rdp, flags) local_irq_save(flags)
> > > > > > > >  #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
> > > > > > > >  
> > > > > > > >  static void rcu_bind_gp_kthread(void);
> > > > > > > >  static bool rcu_nohz_full_cpu(void);
> > > > > > > > +static bool rcu_on_patience_delay(void);
> > > > > > > 
> > > > > > > I don't think we need an access function, but will check below.
> > > > > > > 
> > > > > > > >  /* Forward declarations for tree_stall.h */
> > > > > > > >  static void record_gp_stall_check_time(void);
> > > > > > > >  static void rcu_iw_handler(struct irq_work *iwp);
> > > > > > > >  static void check_cpu_stall(struct rcu_data *rdp);
> > > > > > > >  static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
> > > > > > > >                                      const unsigned long gpssdelay);
> > > > > > > >  
> > > > > > > >  /* Forward declarations for tree_exp.h. */
> > > > > > > >  static void sync_rcu_do_polled_gp(struct work_struct *wp);
> > > > > > > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > > > > > > index 340bbefe5f65..639243b0410f 100644
> > > > > > > > --- a/kernel/rcu/tree_plugin.h
> > > > > > > > +++ b/kernel/rcu/tree_plugin.h
> > > > > > > > @@ -5,20 +5,21 @@
> > > > > > > >   * or preemptible semantics.
> > > > > > > >   *
> > > > > > > >   * Copyright Red Hat, 2009
> > > > > > > >   * Copyright IBM Corporation, 2009
> > > > > > > >   *
> > > > > > > >   * Author: Ingo Molnar <mingo@elte.hu>
> > > > > > > >   *        Paul E. McKenney <paulmck@linux.ibm.com>
> > > > > > > >   */
> > > > > > > >  
> > > > > > > >  #include "../locking/rtmutex_common.h"
> > > > > > > > +#include <linux/jiffies.h>
> > > > > > > 
> > > > > > > This is already pulled in by the enclosing tree.c file, so it should not
> > > > > > > be necessary to include it again. 
> > > > > > 
> > > > > > Even better :)
> > > > > > 
> > > > > > > (Or did you get a build failure when
> > > > > > > leaving this out?)
> > > > > > 
> > > > > > I didn't, it's just that my editor complained the symbols were not getting 
> > > > > > properly resolved, so I included it and it was fixed. But since clangd is 
> > > > > > know to make some mistakes, I should have compile-test'd before adding it.
> > > > > 
> > > > > Ah, got it!  ;-)
> > > > > 
> > > > > > > >  static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
> > > > > > > >  {
> > > > > > > >         /*
> > > > > > > >          * In order to read the offloaded state of an rdp in a safe
> > > > > > > >          * and stable way and prevent from its value to be changed
> > > > > > > >          * under us, we must either hold the barrier mutex, the cpu
> > > > > > > >          * hotplug lock (read or write) or the nocb lock. Local
> > > > > > > >          * non-preemptible reads are also safe. NOCB kthreads and
> > > > > > > >          * timers have their own means of synchronization against the
> > > > > > > > @@ -86,20 +87,33 @@ static void __init rcu_bootup_announce_oddness(void)
> > > > > > > >         if (rcu_kick_kthreads)
> > > > > > > >                 pr_info("\tKick kthreads if too-long grace period.\n");
> > > > > > > >         if (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD))
> > > > > > > >                 pr_info("\tRCU callback double-/use-after-free debug is enabled.\n");
> > > > > > > >         if (gp_preinit_delay)
> > > > > > > >                 pr_info("\tRCU debug GP pre-init slowdown %d jiffies.\n", gp_preinit_delay);
> > > > > > > >         if (gp_init_delay)
> > > > > > > >                 pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
> > > > > > > >         if (gp_cleanup_delay)
> > > > > > > >                 pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> > > > > > > > +       if (nocb_patience_delay < 0) {
> > > > > > > > +               pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n",
> > > > > > > > +                       nocb_patience_delay);
> > > > > > > > +               nocb_patience_delay = 0;
> > > > > > > > +       } else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > > > > > > > +               pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n",
> > > > > > > > +                       nocb_patience_delay, 5 * MSEC_PER_SEC);
> > > > > > > > +               nocb_patience_delay = msecs_to_jiffies(5 * MSEC_PER_SEC);
> > > > > > > > +       } else if (nocb_patience_delay) {
> > > > > > > > +               nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > > > > > > +               pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n",
> > > > > > > > +                       jiffies_to_msecs(nocb_patience_delay);
> > > > > > > > +       }
> > > > > > > 
> > > > > > > I just did this here at the end:
> > > > > > > 
> > > > > > > 	nocb_patience_delay_jiffies = msecs_to_jiffies(nocb_patience_delay);
> > > > > > > 
> > > > > > > Ah, you are wanting to print out the milliseconds after the rounding
> > > > > > > to jiffies.
> > > > > > 
> > > > > > That's right, just to make sure the user gets the effective patience time, 
> > > > > > instead of the before-rounding one, which was on input.
> > > > > > 
> > > > > > > I am going to hold off on that for the moment, but I hear your request
> > > > > > > and I have not yet said "no".  ;-)
> > > > > > 
> > > > > > Sure :)
> > > > > > It's just something I think it's nice to have (as a user).
> > > > > 
> > > > > If you would like to do a separate patch adding this, here are the
> > > > > requirements:
> > > > > 
> > > > > o	If the current code prints nothing, nothing additional should
> > > > > 	be printed.
> > > > > 
> > > > > o	If the rounding ended up with the same value (as it should in
> > > > > 	systems with HZ=1000), nothing additional should be printed.
> > > > > 
> > > > > o	Your choice as to whether or not you want to print out the
> > > > > 	jiffies value.
> > > > > 
> > > > > o	If the additional message is on a new line, it needs to be
> > > > > 	indented so that it is clear that it is subordinate to the
> > > > > 	previous message.
> > > > > 
> > > > > 	Otherwise, you can use pr_cont() to continue the previous
> > > > > 	line, of course being careful about "\n".
> > > > > 
> > > > > Probably also something that I am forgetting, but that is most of it.
> > > > 
> > > > Thanks!
> > > > I will work on a patch doing that :)
> > > 
> > > Very good, looking forward to seeing what you come up with!
> > > 
> > > My current state is on the "dev" branch of the -rcu tree, so please base
> > > on that.
> > 
> > Thanks! I used it earlier to send the previous diff :)
> > 
> > > 
> > > > > > > >         if (!use_softirq)
> > > > > > > >                 pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
> > > > > > > >         if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> > > > > > > >                 pr_info("\tRCU debug extended QS entry/exit.\n");
> > > > > > > >         rcupdate_announce_bootup_oddness();
> > > > > > > >  }
> > > > > > > >  
> > > > > > > >  #ifdef CONFIG_PREEMPT_RCU
> > > > > > > >  
> > > > > > > >  static void rcu_report_exp_rnp(struct rcu_node *rnp, bool wake);
> > > > > > > > @@ -1260,10 +1274,29 @@ static bool rcu_nohz_full_cpu(void)
> > > > > > > >  
> > > > > > > >  /*
> > > > > > > >   * Bind the RCU grace-period kthreads to the housekeeping CPU.
> > > > > > > >   */
> > > > > > > >  static void rcu_bind_gp_kthread(void)
> > > > > > > >  {
> > > > > > > >         if (!tick_nohz_full_enabled())
> > > > > > > >                 return;
> > > > > > > >         housekeeping_affine(current, HK_TYPE_RCU);
> > > > > > > >  }
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * Is this CPU a NO_HZ_FULL CPU that should ignore RCU if the time since the
> > > > > > > > + * start of current grace period is smaller than nocb_patience_delay ?
> > > > > > > > + *
> > > > > > > > + * This code relies on the fact that all NO_HZ_FULL CPUs are also
> > > > > > > > + * RCU_NOCB_CPU CPUs.
> > > > > > > > + */
> > > > > > > > +static bool rcu_on_patience_delay(void)
> > > > > > > > +{
> > > > > > > > +#ifdef CONFIG_NO_HZ_FULL
> > > > > > > 
> > > > > > > You lost me on this one.  Why do we need the #ifdef instead of
> > > > > > > IS_ENABLED()?  Also, please note that rcu_nohz_full_cpu() is already a
> > > > > > > compile-time @false in CONFIG_NO_HZ_FULL=n kernels.
> > > > > > 
> > > > > > You are right. rcu_nohz_full_cpu() has a high chance of being inlined on
> > > > > > 	if ((...) && rcu_nohz_full_cpu())
> > > > > > And since it returns false, this whole statement will be compiled out, and 
> > > > > > the new function will not exist in CONFIG_NO_HZ_FULL=n, so there  is no 
> > > > > > need to test it.
> > > > > 
> > > > > Very good!  You had me going there for a bit.  ;-)
> > > > > 
> > > > > > > > +       if (!nocb_patience_delay)
> > > > > > > > +               return false;
> > > > > > > 
> > > > > > > We get this automatically with the comparison below, right?
> > > > > > 
> > > > > > Right
> > > > > > 
> > > > > > >   If so, we
> > > > > > > are not gaining much by creating the helper function.  Or am I missing
> > > > > > > some trick here?
> > > > > > 
> > > > > > Well, it's a fastpath. Up to here, we just need to read 
> > > > > > nocb_patience_delay{,_jiffies} from memory.
> > > > > 
> > > > > Just nocb_patience_delay_jiffies, correct?  Unless I am missing something,
> > > > > nocb_patience_delay is unused after boot.
> > > > 
> > > > Right, I used both because I was referring to the older version and the 
> > > > current version with _jiffies.
> > > 
> > > Fair enough!
> > > 
> > > > > > If we don't include the fastpath we have to read jiffies and 
> > > > > > rcu_state.gp_start, which can take extra time: up to 2 cache misses.
> > > > > > 
> > > > > > I thought it could be relevant, as we reduce the overhead of the new 
> > > > > > parameter when it's disabled (patience=0). 
> > > > > > 
> > > > > > Do you think that could be relevant?
> > > > > 
> > > > > Well, the hardware's opinion is what matters.  ;-)
> > > > > 
> > > > > But the caller's code path reads jiffies a few times, so it should
> > > > > be hot in the cache, correct?
> > > > 
> > > > Right, but I wonder how are the chances of it getting updated between  
> > > > caller's use and this function's. Same for gp_start.
> > > 
> > > Well, jiffies is updated at most once per millisecond, and gp_start is
> > > updated at most once per few milliseconds.  So the chances of it being
> > > updated within that code sequence are quite small.
> > 
> > Fair enough, and we probably don't need to worry about it getting 
> > cached-out in this sequence, as well. 
> > 
> > Also time_before() is a macro and we don't need to worry on the function 
> > call, so we just spend 2 extra L1-cache reads and a couple arithmetic 
> > instructions which are not supposed to take long, so it's fair to assume 
> > the fast-path would not be that much faster than the slow path, which means 
> > we don't need a fast path after all.
> > 
> > Thanks for helping me notice that :)
> > 
> > > 
> > > > > But that does lead to another topic, namely the possibility of tagging
> > > > > nocb_patience_delay_jiffies with __read_mostly. 
> > > > 
> > > > Oh, right. This was supposed to be in the diff I sent earlier, but I 
> > > > completelly forgot to change before sending. So, yeah, I agree on 
> > > > nocb_patience_delay being __read_mostly; 
> > > > 
> > > > > And there might be
> > > > > a number of other of RCU's variables that could be similarly tagged
> > > > > in order to avoid false sharing.  (But is there any false sharing?
> > > > > This might be worth testing.)
> > > > 
> > > > Maybe there isn't, but I wonder if it would hurt performance if they were 
> > > > tagged as __read_only anyway. 
> > > 
> > > Let's be at least a little careful here.  It is just as easy to hurt
> > > performance by marking things __read_mostly or __read_only as it is
> > > to help performance.  ;-)
> > 
> > Fair enough :)
> > 
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> 
> Oh, btw, for what it's worth:
> Reviewed-by: Leonardo Bras <leobras@redhat.com>

Applied, thank you!

							Thanx, Paul

