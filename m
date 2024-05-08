Return-Path: <kvm+bounces-16959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A828BF51D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 429E61F26288
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD2715E88;
	Wed,  8 May 2024 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKZvkECi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045351400B;
	Wed,  8 May 2024 04:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715141063; cv=none; b=enn2OGtmPRMBVXAdO2slwcFhRpFGXJShGs1eHAcotvFl2qXaZIH/4cwTAx7tVG96HXUfquvMj3tydUG3ZOYi8aJJPOl5txl5ALj8cyX+pk7cH17WKfUNdlP0PIkVm49hvXQMTNnLTpr65lJa0ORuDbxWdS4xNyiTSXpedGjq2ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715141063; c=relaxed/simple;
	bh=GfkI5wIQZ+St7/ntLJAfB+8ENptnx47swkAfJyHQQ1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YObJWNGpCVUoMSrMGmcI98dvN20aGe2y/PnzJWpoR4wJ9ocg2ikcpQMUcGQkJvmsGf7Oq6nAGUDuoUeH/Qrgf4DUxSDErrHXOcEn+qSQ2RjVViaNzDqbDMFx7XndSmhB4sYjhvI/PDFxSNbVpV0nkZy1tfLqX3lNj9E1o3MKRUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKZvkECi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C8EC113CC;
	Wed,  8 May 2024 04:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715141062;
	bh=GfkI5wIQZ+St7/ntLJAfB+8ENptnx47swkAfJyHQQ1M=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=gKZvkECiyHalOQT5Yu9+iMtDplQacObRaQ6sqkbL1XwGZ4LGbyvv89N4DIOjw9doX
	 Ni2L1YVnfECLCHYxcD3vZsrNlMMml4sxKKDVkiYjQHgIQ3S2c6ankVEd/rojf0jmZp
	 I9/9BbSfrzF4F1Vn6iaVm/pD67wZs0v3rH1KVRTZaniO57Qv0X/o4NYHbSzukLmKKu
	 Quc0df29yhd1z41vP4SyBzDYFNIBOXh+sCGTuKKLxTKC2BAq+4SZxNhL+Abnycsiu7
	 kUOMv7I2eX/PdxXnI3z+86ZkIxt+RJc/BrnZHM90WHg4u7tAvNJ9Q0/nvPBiZcR0Q1
	 z3yHk3DM82eyA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 0D8C5CE0FF3; Tue,  7 May 2024 21:04:22 -0700 (PDT)
Date: Tue, 7 May 2024 21:04:22 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <42694682-b498-4997-a334-ca1bbd84a4f7@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZjUwHvyvkM3lj80Q@LeoBras>
 <ZjVXVc2e_V8NiMy3@google.com>
 <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com>
 <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com>
 <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com>
 <ZjrClk4Lqw_cLO5A@google.com>
 <ac66bb23-2955-41bf-b1f0-85adcc4628a0@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac66bb23-2955-41bf-b1f0-85adcc4628a0@paulmck-laptop>

On Tue, May 07, 2024 at 08:20:53PM -0700, Paul E. McKenney wrote:
> On Tue, May 07, 2024 at 05:08:54PM -0700, Sean Christopherson wrote:
> > On Tue, May 07, 2024, Sean Christopherson wrote:
> > > On Tue, May 07, 2024, Paul E. McKenney wrote:
> > > > On Tue, May 07, 2024 at 02:00:12PM -0700, Sean Christopherson wrote:
> > > > > On Tue, May 07, 2024, Paul E. McKenney wrote:
> > > > > > On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> > > > > > > On Fri, May 03, 2024, Paul E. McKenney wrote:
> > > > > > > > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > > > > > > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > > > > > > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > > > > > > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > > > > > > > userspace communicate to the kernel that it's a real-time task that spends the
> > > > > > > > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > > > > > > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > > > > > > > while it's in kernel context.
> > > > > > > > 
> > > > > > > > But if the task is executing in host kernel context for quite some time,
> > > > > > > > then the host kernel's RCU really does need to take evasive action.
> > > > > > > 
> > > > > > > Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> > > > > > > form of the 1 second timeout.
> > > > > > 
> > > > > > Plus RCU will force-enable that CPU's scheduler-clock tick after about
> > > > > > ten milliseconds of that CPU not being in a quiescent state, with
> > > > > > the time varying depending on the value of HZ and the number of CPUs.
> > > > > > After about ten seconds (halfway to the RCU CPU stall warning), it will
> > > > > > resched_cpu() that CPU every few milliseconds.
> > > > > > 
> > > > > > > And while KVM does not guarantee that it will immediately resume the guest after
> > > > > > > servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> > > > > > > anything that would prevent the kernel from preempting the interrupt task.
> > > > > > 
> > > > > > Similarly, the hypervisor could preempt a guest OS's RCU read-side
> > > > > > critical section or its preempt_disable() code.
> > > > > > 
> > > > > > Or am I missing your point?
> > > > > 
> > > > > I think you're missing my point?  I'm talking specifically about host RCU, what
> > > > > is or isn't happening in the guest is completely out of scope.
> > > > 
> > > > Ah, I was thinking of nested virtualization.
> > > > 
> > > > > My overarching point is that the existing @user check in rcu_pending() is optimistic,
> > > > > in the sense that the CPU is _likely_ to quickly enter a quiescent state if @user
> > > > > is true, but it's not 100% guaranteed.  And because it's not guaranteed, RCU has
> > > > > the aforementioned guardrails.
> > > > 
> > > > You lost me on this one.
> > > > 
> > > > The "user" argument to rcu_pending() comes from the context saved at
> > > > the time of the scheduling-clock interrupt.  In other words, the CPU
> > > > really was executing in user mode (which is an RCU quiescent state)
> > > > when the interrupt arrived.
> > > > 
> > > > And that suffices, 100% guaranteed.
> > > 
> > > Ooh, that's where I'm off in the weeds.  I was viewing @user as "this CPU will be
> > > quiescent", but it really means "this CPU _was_ quiescent".
> 
> Exactly!
> 
> > Hrm, I'm still confused though.  That's rock solid for this check:
> > 
> > 	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > 
> > But I don't understand how it plays into the next three checks that can result in
> > rcuc being awakened.  I suspect it's these checks that Leo and Marcelo are trying
> > squash, and these _do_ seem like they are NOT 100% guaranteed by the @user check.
> 
> The short answer is that RCU is a state machine.  These checks all
> indicate that there is something for that state machine to do, so
> rcu_core() (in the rcuc kthread in some configurations) is invoked to
> make the per-CPU portion of this state machine take a step.  The state
> machine's state will reject a quiescent-state report that does not
> apply to the current grace period.  It will also recognize the case
> where there is no quiescent-state report.
> 
> > 	/* Does this CPU have callbacks ready to invoke? */
> 
> If callbacks are not offloaded, then the state machine is in charge of
> invoking them.
> 
> > 	/* Has RCU gone idle with this CPU needing another grace period? */
> 
> If this CPU needs a grace period and there is currently on grace
> period in progress, the state machine will start a grace period.
> (Though grace periods can also be started from elsewhere.)
> 
> > 	/* Have RCU grace period completed or started?  */
> 
> If this CPU is not yet aware of a grace period's start or completion,
> the state machine takes care of it.
> 
> This state machine has per-task, per-CPU, and global components.
> It optimizes to do its work locally.  This means that the implementation
> of this state machine is distributed across quite a bit of code.
> You won't likely understand it by looking at only a small piece of it.
> You will instead need to go line-by-line through much of the contents
> of kernel/rcu, starting with kernel/rcu/tree.c.
> 
> If you are interested, we have done quite a bit of work documenting it,
> please see here:
> 
> https://docs.google.com/document/d/1GCdQC8SDbb54W1shjEXqGZ0Rq8a6kIeYutdSIajfpLA/edit?usp=sharing
> 
> If you do get a chance to look it over, feedback is welcome!
> 
> > > > The reason that it suffices is that other RCU code such as rcu_qs() and
> > > > rcu_note_context_switch() ensure that this CPU does not pay attention to
> > > > the user-argument-induced quiescent state unless this CPU had previously
> > > > acknowledged the current grace period.
> > > > 
> > > > And if the CPU has previously acknowledged the current grace period, that
> > > > acknowledgement must have preceded the interrupt from user-mode execution.
> > > > Thus the prior quiescent state represented by that user-mode execution
> > > > applies to that previously acknowledged grace period.
> > > 
> > > To confirm my own understanding: 
> > > 
> > >   1. Acknowledging the current grace period means any future rcu_read_lock() on
> > >      the CPU will be accounted to the next grace period.
> 
> More or less.  Any uncertainty will cause RCU to err on the side of
> accounting that rcu_read_lock() to the current grace period.  Why any
> uncertainty?  Because certainty is exceedingly expensive in this game.
> See for example the video of my Kernel Recipes talk from last year.
> 
> > >   2. A CPU can acknowledge a grace period without being quiescent.
> 
> Yes, and either the beginning or the end of that grace period.
> (It clearly cannot acknowledge both without going quiescent at some
> point in between times, because otherwise that grace period could not
> be permitted to end.)
> 
> > >   3. Userspace can't acknowledge a grace period, because it doesn't run kernel
> > >      code (stating the obvious).
> 
> Agreed.
> 
> > >   4. All RCU read-side critical sections must complete before exiting to usersepace.
> 
> Agreed.  Any that try not to will hear from lockdep.
> 
> > > And so if an IRQ interrupts userspace, and the CPU previously acknowledged grace
> > > period N, RCU can infer that grace period N elapsed on the CPU, because all
> > > "locks" held on grace period N are guaranteed to have been dropped.
> 
> More precisely, previously noted the beginning of that grace period,
> but yes.
> 
> > > > This is admittedly a bit indirect, but then again this is Linux-kernel
> > > > RCU that we are talking about.
> > > > 
> > > > > And I'm arguing that, since the @user check isn't bombproof, there's no reason to
> > > > > try to harden against every possible edge case in an equivalent @guest check,
> > > > > because it's unnecessary for kernel safety, thanks to the guardrails.
> > > > 
> > > > And the same argument above would also apply to an equivalent check for
> > > > execution in guest mode at the time of the interrupt.
> > > 
> > > This is partly why I was off in the weeds.  KVM cannot guarantee that the
> > > interrupt that leads to rcu_pending() actually interrupted the guest.  And the
> > > original patch didn't help at all, because a time-based check doesn't come
> > > remotely close to the guarantees that the @user check provides.
> 
> Nothing in the registers from the interrupted context permits that
> determination?
> 
> > > > Please understand that I am not saying that we absolutely need an
> > > > additional check (you tell me!).
> > > 
> > > Heh, I don't think I'm qualified to answer that question, at least not yet.
> 
> Me, I would assume that we don't unless something says otherwise.  One
> example of such a somthing is an RCU CPU stall warning.
> 
> > > > But if we do need RCU to be more aggressive about treating guest execution as
> > > > an RCU quiescent state within the host, that additional check would be an
> > > > excellent way of making that happen.
> > > 
> > > It's not clear to me that being more agressive is warranted.  If my understanding
> > > of the existing @user check is correct, we _could_ achieve similar functionality
> > > for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
> > > with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
> > > On x86, this would be relatively straightforward (hack-a-patch below), but I've
> > > no idea what it would look like on other architectures.
> 
> At first glance, this looks plausible.  I would guess that a real patch
> would have to be architecture dependent, and that could simply involve
> a Kconfig option (perhaps something like CONFIG_RCU_SENSE_GUEST), so
> that the check you add to rcu_pending is conditioned on something like
> IS_ENABLED(CONFIG_RCU_SENSE_GUEST).
> 
> There would also need to be a similar check in rcu_sched_clock_irq(),
> or maybe in rcu_flavor_sched_clock_irq(), to force a call to rcu_qs()
> in this situation.

Never mind this last paragraph.  It is clearly time for me to put down
the keyboard.  :-/

						Thanx, Paul

> > > But the value added isn't entirely clear to me, probably because I'm still missing
> > > something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
> > > note the transition from guest to host kernel.  Why isn't that a sufficient hook
> > > for RCU to infer grace period completion?
> 
> Agreed, unless we are sure we need the change, we should not make it.
> All I am going on is that I was sent a patch that looked to be intended to
> make RCU more aggressive about finding quiescent states from guest OSes.
> I suspect that some change like this might eventually be needed in the
> non-nohz_full case, something about a 2017 USENIX paper.
> 
> But we should have hard evidence that we need a change before making one.
> And you are more likely to come across such evidence than am I.  ;-)
> 
> 							Thanx, Paul
> 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 1a9e1e0c9f49..259b60adaad7 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -11301,6 +11301,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> > >         if (vcpu->arch.guest_fpu.xfd_err)
> > >                 wrmsrl(MSR_IA32_XFD_ERR, 0);
> > >  
> > > +       RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
> > > +                        lock_is_held(&rcu_lock_map) ||
> > > +                        lock_is_held(&rcu_sched_lock_map),
> > > +                        "KVM in RCU read-side critical section with PF_VCPU set and IRQs enabled");
> > > +
> > >         /*
> > >          * Consume any pending interrupts, including the possible source of
> > >          * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index b2bccfd37c38..cdb815105de4 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -3929,7 +3929,8 @@ static int rcu_pending(int user)
> > >                 return 1;
> > >  
> > >         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > > -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > > +       if ((user || rcu_is_cpu_rrupt_from_idle() || (current->flags & PF_VCPU)) &&
> > > +           rcu_nohz_full_cpu())
> > >                 return 0;
> > >  
> > >         /* Is the RCU core waiting for a quiescent state from this CPU? */
> > > 
> > > 

