Return-Path: <kvm+bounces-17137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E238C1987
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 00:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C99428280A
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 22:41:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A630770E0;
	Thu,  9 May 2024 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8JGIzqe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA68129E76;
	Thu,  9 May 2024 22:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715294498; cv=none; b=uKO6T10Ma3NAhnnByCb2JK+Eb/OsCcfJlz2JCV0m5Jpw0zyqTFwq6oQ4qhiBJtciEKEm0oxar8FbCAhMF0DO4LbXkEICuiWFl+m7DqdBGO18b/lYjpVFre7uJqeHlq5Siz43K0JdBfg1zxN1fVcL+k8o/tkqNfMaiFga7lcQBEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715294498; c=relaxed/simple;
	bh=ZStfz+7SAPXBya+1cmR3OE1rs4ZUeYeuw7TPFCKi6Kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mP+oIvF4+dEqgk/zFjnF+jJMQ5X5s7BR8wgsard5odMz5OZZFpBEc4fMbC9pFrn8QtZEK9Kn9ISSU3aCkquCCH1nWvq6jyicV2o9aBt6VHNmR2MqHza9w1a6pDqd/2eC2cJAzIe5/HW5au13CNnZ84QI+JMoCVx5o+1InXNnjww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8JGIzqe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3923C116B1;
	Thu,  9 May 2024 22:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715294497;
	bh=ZStfz+7SAPXBya+1cmR3OE1rs4ZUeYeuw7TPFCKi6Kw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=g8JGIzqe5O3hp560kRjTM4ectDADuWbG1WKs681FMOkIlloVNCFoVjf5/MeCCJxFb
	 O7cj7E9oZN5QDfGoiP5XaqeDOlJ6kJ4H+heZsOI/YKOWUPlyezJjNahF5FCJyfFYIi
	 angmgw7jglvr7e7GLnswev/RwslWe4k/ppsxB4ioggKfkf5G+CISCM8I6SxlcX6Ukl
	 RUxvq/gSf7Y/Zuf30BxeBwNfK34upYsNRNfUdbNpv2i8y+KSeJOcz11fFssKugZ37f
	 bTTpAdphLlYfEP/iXbgns9AIDkjp6+8DV+nDMTWl76JZY0pSRfIreSL46/mtoI3COB
	 ZAM4tZoBZMBXA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5D8BBCE04A9; Thu,  9 May 2024 15:41:37 -0700 (PDT)
Date: Thu, 9 May 2024 15:41:37 -0700
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
Message-ID: <4e368040-05b0-46ab-bafa-59710d5de549@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZjqWXPFuoYWWcxP3@google.com>
 <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com>
 <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras>
 <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
 <ZjsZVUdmDXZOn10l@LeoBras>
 <ZjuFuZHKUy7n6-sG@google.com>
 <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
 <ZjyGefTZ8ThZukNG@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjyGefTZ8ThZukNG@LeoBras>

On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> On Wed, May 08, 2024 at 08:32:40PM -0700, Paul E. McKenney wrote:
> > On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> > > On Wed, May 08, 2024, Leonardo Bras wrote:
> > > > Something just hit me, and maybe I need to propose something more generic.
> > > 
> > > Yes.  This is what I was trying to get across with my complaints about keying off
> > > of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
> > > be quiescent soon" and so the core concept/functionality belongs in common code,
> > > not KVM.
> > 
> > OK, we could do something like the following wholly within RCU, namely
> > to make rcu_pending() refrain from invoking rcu_core() until the grace
> > period is at least the specified age, defaulting to zero (and to the
> > current behavior).
> > 
> > Perhaps something like the patch shown below.
> 
> That's exactly what I was thinking :)
> 
> > 
> > Thoughts?
> 
> Some suggestions below:
> 
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit abc7cd2facdebf85aa075c567321589862f88542
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Wed May 8 20:11:58 2024 -0700
> > 
> >     rcu: Add rcutree.nocb_patience_delay to reduce nohz_full OS jitter
> >     
> >     If a CPU is running either a userspace application or a guest OS in
> >     nohz_full mode, it is possible for a system call to occur just as an
> >     RCU grace period is starting.  If that CPU also has the scheduling-clock
> >     tick enabled for any reason (such as a second runnable task), and if the
> >     system was booted with rcutree.use_softirq=0, then RCU can add insult to
> >     injury by awakening that CPU's rcuc kthread, resulting in yet another
> >     task and yet more OS jitter due to switching to that task, running it,
> >     and switching back.
> >     
> >     In addition, in the common case where that system call is not of
> >     excessively long duration, awakening the rcuc task is pointless.
> >     This pointlessness is due to the fact that the CPU will enter an extended
> >     quiescent state upon returning to the userspace application or guest OS.
> >     In this case, the rcuc kthread cannot do anything that the main RCU
> >     grace-period kthread cannot do on its behalf, at least if it is given
> >     a few additional milliseconds (for example, given the time duration
> >     specified by rcutree.jiffies_till_first_fqs, give or take scheduling
> >     delays).
> >     
> >     This commit therefore adds a rcutree.nocb_patience_delay kernel boot
> >     parameter that specifies the grace period age (in milliseconds)
> >     before which RCU will refrain from awakening the rcuc kthread.
> >     Preliminary experiementation suggests a value of 1000, that is,
> >     one second.  Increasing rcutree.nocb_patience_delay will increase
> >     grace-period latency and in turn increase memory footprint, so systems
> >     with constrained memory might choose a smaller value.  Systems with
> >     less-aggressive OS-jitter requirements might choose the default value
> >     of zero, which keeps the traditional immediate-wakeup behavior, thus
> >     avoiding increases in grace-period latency.
> >     
> >     Link: https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
> >     
> >     Reported-by: Leonardo Bras <leobras@redhat.com>
> >     Suggested-by: Leonardo Bras <leobras@redhat.com>
> >     Suggested-by: Sean Christopherson <seanjc@google.com>
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 0a3b0fd1910e6..42383986e692b 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -4981,6 +4981,13 @@
> >  			the ->nocb_bypass queue.  The definition of "too
> >  			many" is supplied by this kernel boot parameter.
> >  
> > +	rcutree.nocb_patience_delay= [KNL]
> > +			On callback-offloaded (rcu_nocbs) CPUs, avoid
> > +			disturbing RCU unless the grace period has
> > +			reached the specified age in milliseconds.
> > +			Defaults to zero.  Large values will be capped
> > +			at five seconds.
> > +
> >  	rcutree.qhimark= [KNL]
> >  			Set threshold of queued RCU callbacks beyond which
> >  			batch limiting is disabled.
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 7560e204198bb..6e4b8b43855a0 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -176,6 +176,8 @@ static int gp_init_delay;
> >  module_param(gp_init_delay, int, 0444);
> >  static int gp_cleanup_delay;
> >  module_param(gp_cleanup_delay, int, 0444);
> > +static int nocb_patience_delay;
> > +module_param(nocb_patience_delay, int, 0444);
> >  
> >  // Add delay to rcu_read_unlock() for strict grace periods.
> >  static int rcu_unlock_delay;
> > @@ -4334,6 +4336,8 @@ EXPORT_SYMBOL_GPL(cond_synchronize_rcu_full);
> >  static int rcu_pending(int user)
> >  {
> >  	bool gp_in_progress;
> > +	unsigned long j = jiffies;
> 
> I think this is probably taken care by the compiler, but just in case I would move the 
> j = jiffies;
> closer to it's use, in order to avoid reading 'jiffies' if rcu_pending 
> exits before the nohz_full testing.

Good point!  I just removed j and used jiffies directly.

> > +	unsigned int patience = msecs_to_jiffies(nocb_patience_delay);
> 
> What do you think on processsing the new parameter in boot, and saving it 
> in terms of jiffies already? 
> 
> It would make it unnecessary to convert ms -> jiffies every time we run 
> rcu_pending.
> 
> (OOO will probably remove the extra division, but may cause less impact in 
> some arch)

This isn't exactly a fastpath, but it is easy enough to do the conversion
in rcu_bootup_announce_oddness() and place it into another variable
(for the benefit of those using drgn or going through crash dumps).

> >  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
> >  	struct rcu_node *rnp = rdp->mynode;
> >  
> > @@ -4347,11 +4351,13 @@ static int rcu_pending(int user)
> >  		return 1;
> >  
> >  	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > +	gp_in_progress = rcu_gp_in_progress();
> > +	if ((user || rcu_is_cpu_rrupt_from_idle() ||
> > +	     (gp_in_progress && time_before(j + patience, rcu_state.gp_start))) &&
> 
> I think you meant:
> 	time_before(j, rcu_state.gp_start + patience)
> 
> or else this always fails, as we can never have now to happen before a 
> previously started gp, right?
> 
> Also, as per rcu_nohz_full_cpu() we probably need it to be read with 
> READ_ONCE():
> 
> 	time_before(j, READ_ONCE(rcu_state.gp_start) + patience)

Good catch on both counts, fixed!

> > +	    rcu_nohz_full_cpu())
> >  		return 0;
> >  
> >  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > -	gp_in_progress = rcu_gp_in_progress();
> >  	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
> >  		return 1;
> >  
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 340bbefe5f652..174333d0e9507 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -93,6 +93,15 @@ static void __init rcu_bootup_announce_oddness(void)
> >  		pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
> >  	if (gp_cleanup_delay)
> >  		pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> > +	if (nocb_patience_delay < 0) {
> > +		pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n", nocb_patience_delay);
> > +		nocb_patience_delay = 0;
> > +	} else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > +		pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n", nocb_patience_delay, 5 * MSEC_PER_SEC);
> > +		nocb_patience_delay = 5 * MSEC_PER_SEC;
> > +	} else if (nocb_patience_delay) {
> 
> Here you suggest that we don't print if 'nocb_patience_delay == 0', 
> as it's the default behavior, right?

Exactly, in keeping with the function name rcu_bootup_announce_oddness().

This approach allows easy spotting of deviations from default settings,
which can be very helpful when debugging.

> I think printing on 0 could be useful to check if the feature exists, even 
> though we are zeroing it, but this will probably add unnecessary verbosity.

It could be quite useful to people learning the RCU implementation,
and I encourage those people to remove all those "if" statements from
rcu_bootup_announce_oddness() in order to get the full story.

> > +		pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n", nocb_patience_delay);
> > +	}
> 
> Here I suppose something like this can take care of not needing to convert 
> ms -> jiffies every rcu_pending():
> 
> +	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);

Agreed, but I used a separate variable to help people looking at crash
dumps or using drgn.

And thank you for your review and comments!  Applying these changes
with attribution.

							Thanx, Paul

> >  	if (!use_softirq)
> >  		pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
> >  	if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> > 
> 
> 
> Thanks!
> Leo
> 

