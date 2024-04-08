Return-Path: <kvm+bounces-13910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3027689CBDE
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:43:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DB121F26E31
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0056B6A8A4;
	Mon,  8 Apr 2024 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/Parmi+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C4F51B;
	Mon,  8 Apr 2024 18:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712601771; cv=none; b=GRVNpkRdqhsq4W0Trp1frvnfdjRv32jSfgj6OU2xNP4SxTQdkjdPxqYvoxvQZbgq/a6mkprL0r15Rm8D06IeDZ7083+z7Oy6/r9Nz3T7n6d3NfuN/pinhOcTTBxAHG+iE07gQQ0pDTkFMbCKg8IPhN30bBaADaHITse9vuKh6Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712601771; c=relaxed/simple;
	bh=0yVcPh6jQemtqyf3pVMKTuzquslNkgOsytj52m1E4yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPyPBfnXjNspbhUmkFe21vofkXgU7xCNgSPe6Z86L6BSVkrgcsSaHaZXxlFzotjOPGhLsxLveMxHhZv38vl3LT8O7mg9QzfOXrb4/V2k2TayRpv/FcUzQUgW2JMMgqqyH/StllM20AwGRV/TcPGhxlY0rA/T8u1dIc+3gOelODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/Parmi+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E07C433C7;
	Mon,  8 Apr 2024 18:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712601770;
	bh=0yVcPh6jQemtqyf3pVMKTuzquslNkgOsytj52m1E4yI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=V/Parmi+bnfDse6/WIy/AZTXDq7tM///tp2rcTx+UvSLiQS6IRjkgidPKy3EXXCfN
	 g3+3H7kYg6bbGrV1Agp6dbL4qSPQfUwgf8XrSkjYGASSMk6dp1yAyQhqFxgAkxHz+r
	 KN0NFN0eEB34+CLBi8S16HftMysjUy6+95qXDmEaj8W4Tb8fbcTvqqPwiSbF2Cwzt3
	 wvu+2AXgwigLnjsr070sHG1F1hKqM43mLF7xIzbbOCja4RiI2Va/EJxYHKQSTprdUS
	 iTk5caK9IphRbleDCca+0lPf0Y62fyZRoN/n/HF574rOBCImUfoLJ/0CATnfkvJ+gc
	 pB3vARJ0KTK2Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 3D9B9CE126C; Mon,  8 Apr 2024 11:42:50 -0700 (PDT)
Date: Mon, 8 Apr 2024 11:42:50 -0700
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
Message-ID: <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhQmaEXPCqmx1rTW@google.com>

On Mon, Apr 08, 2024 at 10:16:24AM -0700, Sean Christopherson wrote:
> On Fri, Apr 05, 2024, Paul E. McKenney wrote:
> > On Fri, Apr 05, 2024 at 07:42:35AM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 05, 2024, Marcelo Tosatti wrote:
> > > > rcuc wakes up (which might exceed the allowed latency threshold
> > > > for certain realtime apps).
> > > 
> > > Isn't that a false negative? (RCU doesn't detect that a CPU is about to (re)enter
> > > a guest)  I was trying to ask about the case where RCU thinks a CPU is about to
> > > enter a guest, but the CPU never does (at least, not in the immediate future).
> > > 
> > > Or am I just not understanding how RCU's kthreads work?
> > 
> > It is quite possible that the current rcu_pending() code needs help,
> > given the possibility of vCPU preemption.  I have heard of people doing
> > nested KVM virtualization -- or is that no longer a thing?
> 
> Nested virtualization is still very much a thing, but I don't see how it is at
> all unique with respect to RCU grace periods and quiescent states.  More below.

When the hypervisor runs on bare metal, the existing checks have
interrupts disables.  Yes, you can still get added delays from NMIs and
SMIs, but excessively long NMI/SMI handlers are either considered to be
bugs or happen when the system is already in trouble (backtrace NMIs,
for an example of the latter).

But if the hypervisor is running on top of another hypervisor, then
the scheduling-clock interrupt handler is subject to vCPU preemption,
which can unduly delay reporting of RCU quiescent states.

And no, this is not exactly new, but your patch reminded me of it.

> > But the help might well involve RCU telling the hypervisor that a given
> > vCPU needs to run.  Not sure how that would go over, though it has been
> > prototyped a couple times in the context of RCU priority boosting.
> >
> > > > > > 3 - It checks if the guest exit happened over than 1 second ago. This 1
> > > > > >     second value was copied from rcu_nohz_full_cpu() which checks if the
> > > > > >     grace period started over than a second ago. If this value is bad,
> > > > > >     I have no issue changing it.
> > > > > 
> > > > > IMO, checking if a CPU "recently" ran a KVM vCPU is a suboptimal heuristic regardless
> > > > > of what magic time threshold is used.  
> > > > 
> > > > Why? It works for this particular purpose.
> > > 
> > > Because maintaining magic numbers is no fun, AFAICT the heurisitic doesn't guard
> > > against edge cases, and I'm pretty sure we can do better with about the same amount
> > > of effort/churn.
> > 
> > Beyond a certain point, we have no choice.  How long should RCU let
> > a CPU run with preemption disabled before complaining?  We choose 21
> > seconds in mainline and some distros choose 60 seconds.  Android chooses
> > 20 milliseconds for synchronize_rcu_expedited() grace periods.
> 
> Issuing a warning based on an arbitrary time limit is wildly different than using
> an arbitrary time window to make functional decisions.  My objection to the "assume
> the CPU will enter a quiescent state if it exited a KVM guest in the last second"
> is that there are plenty of scenarios where that assumption falls apart, i.e. where
> _that_ physical CPU will not re-enter the guest.
> 
> Off the top of my head:
> 
>  - If the vCPU is migrated to a different physical CPU (pCPU), the *old* pCPU
>    will get false positives, and the *new* pCPU will get false negatives (though
>    the false negatives aren't all that problematic since the pCPU will enter a
>    quiescent state on the next VM-Enter.
> 
>  - If the vCPU halts, in which case KVM will schedule out the vCPU/task, i.e.
>    won't re-enter the guest.  And so the pCPU will get false positives until the
>    vCPU gets a wake event or the 1 second window expires.
> 
>  - If the VM terminates, the pCPU will get false positives until the 1 second
>    window expires.
> 
> The false positives are solvable problems, by hooking vcpu_put() to reset
> kvm_last_guest_exit.  And to help with the false negatives when a vCPU task is
> scheduled in on a different pCPU, KVM would hook vcpu_load().

Here you are arguing against the heuristic in the original patch, correct?
As opposed to the current RCU heuristic that ignores certain quiescent
states for nohz_full CPUs until the grace period reaches an age of
one second?

If so, no argument here.  In fact, please consider my ack cancelled.

> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index d9642dd06c25..303ae9ae1c53 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -3937,8 +3937,13 @@ static int rcu_pending(int user)
> > >  	if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
> > >  		return 1;
> > >  
> > > -	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > > -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > > +	/*
> > > +	 * Is this a nohz_full CPU in userspace, idle, or likely to enter a
> > > +	 * guest in the near future?  (Ignore RCU if so.)
> > > +	 */
> > > +	if ((user || rcu_is_cpu_rrupt_from_idle() ||
> > > +	     __this_cpu_read(context_tracking.in_guest_run_loop)) &&
> > 
> > In the case of (user || rcu_is_cpu_rrupt_from_idle()), this CPU was in
> > a quiescent just before the current scheduling-clock interrupt and will
> > again be in a quiescent state right after return from this interrupt.
> > This means that the grace-period kthread will be able to remotely sense
> > this quiescent state, so that the current CPU need do nothing.
> >
> > In constrast, it looks like context_tracking.in_guest_run_loop instead
> > means that when we return from this interrupt, this CPU will still be
> > in a non-quiescent state.
> > 
> > Now, in the nested-virtualization case, your point might be that the
> > lower-level hypervisor could preempt the vCPU in the interrupt handler
> > just as easily as in the .in_guest_run_loop code.  Which is a good point.
> > But I don't know of a way to handle this other than heuristics and maybe
> > hinting to the hypervisor (which has been prototyped for RCU priority
> > boosting).
> 
> Regarding nested virtualization, what exactly is your concern?  IIUC, you are
> worried about this code running at L1, i.e. as a nested hypervisor, and L0, i.e.
> the bare metal hypervisor, scheduling out the L1 CPU.  And because the L1 CPU
> doesn't get run "soon", it won't enter a quiescent state as expected by RCU.

I don't believe that I have any additional concerns over and above
those for the current situation for nested virtualization.  But see my
additional question on your patch below for non-nested virtualization.

> But that's 100% the case with RCU in a VM in general.  If an L1 CPU gets scheduled
> out by L0, that L1 CPU won't participate in any RCU stuff until it gets scheduled
> back in by L0.
> 
> E.g. throw away all of the special case checks for rcu_nohz_full_cpu() in
> rcu_pending(), and the exact same problem exists.  The L1 CPU could get scheduled
> out while trying to run the RCU core kthread just as easily as it could get
> scheduled out while trying to run the vCPU task.  Or the L1 CPU could get scheduled
> out while it's still in the IRQ handler, before it even completes it rcu_pending().
> 
> And FWIW, it's not just L0 scheduling that is problematic.  If something in L0
> prevents an L1 CPU (vCPU from L0's perspective) from making forward progress, e.g.
> due to a bug in L0, or severe resource contention, from the L1 kernel's perspective,
> the L1 CPU will appear stuck and trigger various warnings, e.g. soft-lockup,
> need_resched, RCU stalls, etc.

Indeed, there was a USENIX paper on some aspects of this topic some years back.
https://www.usenix.org/conference/atc17/technical-sessions/presentation/prasad

> > Maybe the time for such hinting has come?
> 
> That's a largely orthogonal discussion.  As above, boosting the scheduling priority
> of a vCPU because that vCPU is in critical section of some form is not at all
> unique to nested virtualization (or RCU).
> 
> For basic functional correctness, the L0 hypervisor already has the "hint" it 
> needs.  L0 knows that the L1 CPU wants to run by virtue of the L1 CPU being
> runnable, i.e. not halted, not in WFS, etc.

And if the system is sufficiently lightly loaded, all will be well, as is
the case with my rcutorture usage.  However, if the system is saturated,
that basic functional correctness might not be enough.  I haven't heard
many complaints, other than research work, so I have been assuming that
we do not yet need hinting.  But you guys tell me.  ;-)

> > > +	    rcu_nohz_full_cpu())
> > 
> > And rcu_nohz_full_cpu() has a one-second timeout, and has for quite
> > some time.
> 
> That's not a good reason to use a suboptimal heuristic for determining whether
> or not a CPU is likely to enter a KVM guest, it simply mitigates the worst case
> scenario of a false positive.

Again, are you referring to the current RCU code, or the original patch
that started this email thread?

> > >  		return 0;
> > >  
> > >  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index bfb2b52a1416..5a7efc669a0f 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -209,6 +209,9 @@ void vcpu_load(struct kvm_vcpu *vcpu)
> > >  {
> > >  	int cpu = get_cpu();
> > >  
> > > +	if (vcpu->wants_to_run)
> > > +		context_tracking_guest_start_run_loop();
> > 
> > At this point, if this is a nohz_full CPU, it will no longer report
> > quiescent states until the grace period is at least one second old.
> 
> I don't think I follow the "will no longer report quiescent states" issue.  Are
> you saying that this would prevent guest_context_enter_irqoff() from reporting
> that the CPU is entering a quiescent state?  If so, that's an issue that would
> need to be resolved regardless of what heuristic we use to determine whether or
> not a CPU is likely to enter a KVM guest.

Please allow me to start over.  Are interrupts disabled at this point,
and, if so, will they remain disabled until the transfer of control to
the guest has become visible to RCU via the context-tracking code?

Or has the context-tracking code already made the transfer of control
to the guest visible to RCU?

> > >  	__this_cpu_write(kvm_running_vcpu, vcpu);
> > >  	preempt_notifier_register(&vcpu->preempt_notifier);
> > >  	kvm_arch_vcpu_load(vcpu, cpu);
> > > @@ -222,6 +225,10 @@ void vcpu_put(struct kvm_vcpu *vcpu)
> > >  	kvm_arch_vcpu_put(vcpu);
> > >  	preempt_notifier_unregister(&vcpu->preempt_notifier);
> > >  	__this_cpu_write(kvm_running_vcpu, NULL);
> > > +
> > 
> > And also at this point, if this is a nohz_full CPU, it will no longer
> > report quiescent states until the grace period is at least one second old.

And here, are interrupts disabled at this point, and if so, have they
been disabled since the time that the exit from the guest become
visible to RCU via the context-tracking code?

Or will the context-tracking code make the transfer of control to the
guest visible to RCU at some later time?

							Thanx, Paul

> > > +	if (vcpu->wants_to_run)
> > > +		context_tracking_guest_stop_run_loop();
> > > +
> > >  	preempt_enable();
> > >  }
> > >  EXPORT_SYMBOL_GPL(vcpu_put);
> > > 
> > > base-commit: 619e56a3810c88b8d16d7b9553932ad05f0d4968
> > 
> > All of which might be OK.  Just checking as to whether all of that was
> > in fact the intent.
> > 
> > 							Thanx, Paul

