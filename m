Return-Path: <kvm+bounces-13918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D9E89CD2B
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57EDF28585A
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 21:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59219147C6D;
	Mon,  8 Apr 2024 21:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sB1I/khI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769C37E8;
	Mon,  8 Apr 2024 21:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712610157; cv=none; b=C/phv4EcLfBxiBpdJhiOHPKGp8DWg1x5uEes2/dzp4Miyn1Q/WF3weiVXkkjs8dMS8ZUsEed2uqye6IF42eMnUA5TeVL2NbYS8O4ndKMH0WYMFRVn1OleQm/m5du5vCf7BYth2bfdMBEWNsudpY0QiBRzBGgiYKByjWPZjLSbK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712610157; c=relaxed/simple;
	bh=Ej1u1Tdv0D0n+r2ATTiCoJkaC37D44Rek2hCwrgsKEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8p438dFDnL3WlKtW+p/uMDy9pB0ZZqgPeO2GWMXTTfvJiPAn3MwzWdrkgC0qbCtAw5d0LzKW60PCk8Eity33wDbQ1aVcidI6VQuwS2Lea54dDxzb7fFniWKtFSdQyEVChOjTmXsJ6mC0SU8fr6Zjni92njip+PA+obwDaha96k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sB1I/khI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1086BC433C7;
	Mon,  8 Apr 2024 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712610157;
	bh=Ej1u1Tdv0D0n+r2ATTiCoJkaC37D44Rek2hCwrgsKEI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=sB1I/khIpIxg90XRIeiSg7/vraPbjc2IZWdXbRVw7h1gbUe1wA0QOQjUOp6IiMknx
	 6DRGes7EBdBUN/afiPpnkS9iiFPNj7aPS9anB/NzvWaLVslY2gipmAxCYOH5eq7bGK
	 xfybZBz22QF1EYUNBOCWM/lSM/BzKWf82ZwYTAzDJdr89A6odTJRFVBrh63Q9L1ckr
	 ZM6Yv0HnbG8Tq/XTiIa0EsOGIf6rGAtAKL+B+wFV1Deuu+v5PzbPi/LX9W0zZr2eD2
	 hPQrAW+DNf+EDNHUiJcddANlPOGldOT9QWz9afJYZrTLMix9NDcuoqykunsE3H1gxd
	 6PlhpePZUMdHA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 9E70FCE126C; Mon,  8 Apr 2024 14:02:36 -0700 (PDT)
Date: Mon, 8 Apr 2024 14:02:36 -0700
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
Message-ID: <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
 <ZhROKK9dEPsNnH4t@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhROKK9dEPsNnH4t@google.com>

On Mon, Apr 08, 2024 at 01:06:00PM -0700, Sean Christopherson wrote:
> On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> > On Mon, Apr 08, 2024 at 10:16:24AM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 05, 2024, Paul E. McKenney wrote:
> > > Issuing a warning based on an arbitrary time limit is wildly different than using
> > > an arbitrary time window to make functional decisions.  My objection to the "assume
> > > the CPU will enter a quiescent state if it exited a KVM guest in the last second"
> > > is that there are plenty of scenarios where that assumption falls apart, i.e. where
> > > _that_ physical CPU will not re-enter the guest.
> > > 
> > > Off the top of my head:
> > > 
> > >  - If the vCPU is migrated to a different physical CPU (pCPU), the *old* pCPU
> > >    will get false positives, and the *new* pCPU will get false negatives (though
> > >    the false negatives aren't all that problematic since the pCPU will enter a
> > >    quiescent state on the next VM-Enter.
> > > 
> > >  - If the vCPU halts, in which case KVM will schedule out the vCPU/task, i.e.
> > >    won't re-enter the guest.  And so the pCPU will get false positives until the
> > >    vCPU gets a wake event or the 1 second window expires.
> > > 
> > >  - If the VM terminates, the pCPU will get false positives until the 1 second
> > >    window expires.
> > > 
> > > The false positives are solvable problems, by hooking vcpu_put() to reset
> > > kvm_last_guest_exit.  And to help with the false negatives when a vCPU task is
> > > scheduled in on a different pCPU, KVM would hook vcpu_load().
> > 
> > Here you are arguing against the heuristic in the original patch, correct?
> 
> Yep, correct.

Whew!!!  ;-)

> > As opposed to the current RCU heuristic that ignores certain quiescent
> > states for nohz_full CPUs until the grace period reaches an age of
> > one second?
> > 
> > If so, no argument here.  In fact, please consider my ack cancelled.
> 
> ...
> 
> > > That's a largely orthogonal discussion.  As above, boosting the scheduling priority
> > > of a vCPU because that vCPU is in critical section of some form is not at all
> > > unique to nested virtualization (or RCU).
> > > 
> > > For basic functional correctness, the L0 hypervisor already has the "hint" it 
> > > needs.  L0 knows that the L1 CPU wants to run by virtue of the L1 CPU being
> > > runnable, i.e. not halted, not in WFS, etc.
> > 
> > And if the system is sufficiently lightly loaded, all will be well, as is
> > the case with my rcutorture usage.  However, if the system is saturated,
> > that basic functional correctness might not be enough.  I haven't heard
> > many complaints, other than research work, so I have been assuming that
> > we do not yet need hinting.  But you guys tell me.  ;-)
> 
> We should never use hinting for basic, *default* functionality.  If the host is
> so overloaded that it can induce RCU stalls with the default threshold of 21
> seconds, then something in the host's domain is broken/misconfigured.  E.g. it
> doesn't necessary have to be a host kernel/userspace bug, it could be an issue
> with VM scheduling at the control plane.  But it's still a host issue, and under
> no circumstance should the host need a hint in order for the guest to not complain
> after 20+ seconds.
> 
> And _if_ we were to push the default lower, e.g. all the way down to Android's
> aggressive 20 milliseconds, a boosting hint would still be the wrong way to go
> about it, because no sane hypervisor would ever back such a hint with strong
> guarantees for all scenarios.
> 
> It's very much possible to achieve a 20ms deadline when running as a VM, but it
> would require strong guarantees about the VM's configuration and environment,
> e.g. that memory isn't overcommited, that each vCPU has a fully dedicated pCPU,
> etc.

Agreed, and again, you guys need to tell me what is necessary here.

> > > > > +	    rcu_nohz_full_cpu())
> > > > 
> > > > And rcu_nohz_full_cpu() has a one-second timeout, and has for quite
> > > > some time.
> > > 
> > > That's not a good reason to use a suboptimal heuristic for determining whether
> > > or not a CPU is likely to enter a KVM guest, it simply mitigates the worst case
> > > scenario of a false positive.
> > 
> > Again, are you referring to the current RCU code, or the original patch
> > that started this email thread?
> 
> Original patch.
> 
> > > > >  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > > index bfb2b52a1416..5a7efc669a0f 100644
> > > > > --- a/virt/kvm/kvm_main.c
> > > > > +++ b/virt/kvm/kvm_main.c
> > > > > @@ -209,6 +209,9 @@ void vcpu_load(struct kvm_vcpu *vcpu)
> > > > >  {
> > > > >  	int cpu = get_cpu();
> > > > >  
> > > > > +	if (vcpu->wants_to_run)
> > > > > +		context_tracking_guest_start_run_loop();
> > > > 
> > > > At this point, if this is a nohz_full CPU, it will no longer report
> > > > quiescent states until the grace period is at least one second old.
> > > 
> > > I don't think I follow the "will no longer report quiescent states" issue.  Are
> > > you saying that this would prevent guest_context_enter_irqoff() from reporting
> > > that the CPU is entering a quiescent state?  If so, that's an issue that would
> > > need to be resolved regardless of what heuristic we use to determine whether or
> > > not a CPU is likely to enter a KVM guest.
> > 
> > Please allow me to start over.  Are interrupts disabled at this point,
> 
> Nope, IRQs are enabled.
> 
> Oof, I'm glad you asked, because I was going to say that there's one exception,
> kvm_sched_in(), which is KVM's notifier for when a preempted task/vCPU is scheduled
> back in.  But I forgot that kvm_sched_{in,out}() don't use vcpu_{load,put}(),
> i.e. would need explicit calls to context_tracking_guest_{stop,start}_run_loop().
> 
> > and, if so, will they remain disabled until the transfer of control to
> > the guest has become visible to RCU via the context-tracking code?
> > 
> > Or has the context-tracking code already made the transfer of control
> > to the guest visible to RCU?
> 
> Nope.  The call to __ct_user_enter(CONTEXT_GUEST) or rcu_virt_note_context_switch()
> happens later, just before the actual VM-Enter.  And that call does happen with
> IRQs disabled (and IRQs stay disabled until the CPU enters the guest).

OK, then we can have difficulties with long-running interrupts hitting
this range of code.  It is unfortunately not unheard-of for interrupts
plus trailing softirqs to run for tens of seconds, even minutes.

One counter-argument is that that softirq would take scheduling-clock
interrupts, and would eventually make rcu_core() run.

But does a rcu_sched_clock_irq() from a guest OS have its "user"
argument set?

> > > > >  	__this_cpu_write(kvm_running_vcpu, vcpu);
> > > > >  	preempt_notifier_register(&vcpu->preempt_notifier);
> > > > >  	kvm_arch_vcpu_load(vcpu, cpu);
> > > > > @@ -222,6 +225,10 @@ void vcpu_put(struct kvm_vcpu *vcpu)
> > > > >  	kvm_arch_vcpu_put(vcpu);
> > > > >  	preempt_notifier_unregister(&vcpu->preempt_notifier);
> > > > >  	__this_cpu_write(kvm_running_vcpu, NULL);
> > > > > +
> > > > 
> > > > And also at this point, if this is a nohz_full CPU, it will no longer
> > > > report quiescent states until the grace period is at least one second old.
> > 
> > And here, are interrupts disabled at this point, and if so, have they
> > been disabled since the time that the exit from the guest become
> > visible to RCU via the context-tracking code?
> 
> IRQs are enabled.
> 
> The gist of my suggestion is:
> 
> 	ioctl(KVM_RUN) {
> 
> 		context_tracking_guest_start_run_loop();
> 
> 		for (;;) {
> 
> 			vcpu_run();
> 
> 			if (<need to return to userspace>)
> 				break;
> 		}
> 
> 		context_tracking_guest_stop_run_loop();
> 	}
> 
> where vcpu_run() encompasses a fairly huge amount of code and functionality,
> including the logic to do world switches between host and guest.
> 
> E.g. if a vCPU triggers a VM-Exit because it tried to access memory that has been
> swapped out by the host, KVM could end up way down in mm/ doing I/O to bring a
> page back into memory for the guest.  Immediately after VM-Exit, before enabling
> IRQs, KVM will notify RCU that the CPU has exited the extended quiescent state
> (this is what happens today).  But the "in KVM run loop" flag would stay set, and
> RCU would rely on rcu_nohz_full_cpu() for protection, e.g. in case faulting in
> memory somehow takes more than a second.
> 
> But, barring something that triggers a return to userspace, KVM _will_ re-enter
> the guest as quickly as possible.  So it's still a heuristic in the sense that
> the CPU isn't guaranteed to enter the guest, nor are there any enforceable SLOs
> on how quickly the CPU will enter the guest, but I think it's the best tradeoff
> between simplicity and functionality, especially since rcu_nohz_full_cpu() has
> a one second timeout to safeguard against some unforeseen hiccup that prevents
> KVM from re-entering the guest in a timely manner.
> 
> Note, as above, my intent is that there would also be hooks in kvm_sched_{in,out}()
> to note that the guest run loop is starting/stopping if the vCPU task yields or
> is preempted.

Very good, same responses as for the context_tracking_guest_start_run_loop()
case.

							Thanx, Paul

