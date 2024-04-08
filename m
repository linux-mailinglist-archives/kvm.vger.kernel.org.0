Return-Path: <kvm+bounces-13924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 000E089CE7C
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63968281978
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24DFA28389;
	Mon,  8 Apr 2024 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJlZIYqY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C327462;
	Mon,  8 Apr 2024 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712615713; cv=none; b=RClinOqDn+hV/bm6GI693hySiSr/l9KaKtcJXYUm/15W0/iuF+7AqK2vuS26TjkPcPhqg1c0fjIv8qmfkjITQVWjCxGLx7ijxeyefT9zEnaUHmKGHiNYR8ELDRSbdoeLmuMtyddGsQz63nI5q2HT7howpYAArHqcSxIjdgnnJvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712615713; c=relaxed/simple;
	bh=t+9wrEyDbOSCNx4ZXTbZR4MUwwym+2CgIj+H0hIRykA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKkZO+hsCazolAIzwnKISw2D5F74GWDsbU/6nCbxHuMGef1PfBa3PPwCMWbw6d2MfBOD6+IgrFwwLUUtLdfeXD/gL5cE7Y99bZROjWgIl0s9ZBML9PCsAcY6CH7Hrw0TDOD+MPAGdAYNI6xpF4+GCLtecXlny8WMDv/lzfIFdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJlZIYqY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C038DC433C7;
	Mon,  8 Apr 2024 22:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712615712;
	bh=t+9wrEyDbOSCNx4ZXTbZR4MUwwym+2CgIj+H0hIRykA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=jJlZIYqYUMy4yIcvfVEK40mHzAc0SXiC16+zKpD1UCn6OpHaJNr2Xcqu3DNX7xdNb
	 dq223WT6Bi4ch2ROsPlXnpIjeK1iDBgmMimiYD7DhBs3xZto5CTvpFbR1EgPlVdenY
	 OPUwIuqMBsySKE8+Ohtl81IzUDlJY769T5lxY+UlFlyMrCLcxJ7n0t6gCCSln3HzWY
	 WqWphZbLZ+Be69hfzz7XUk24B3aSB24Jflh34XBX6miP+jfbmJREOtXTQZPJoUzjSs
	 U33Q6+8spxA8QDU4QrmyR3YrfYmg2J/ZndPSh6OWtjEiO9Y1hSz3QKmHDm6uQBLhmk
	 zA8def02mHsoA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 62018CE118A; Mon,  8 Apr 2024 15:35:12 -0700 (PDT)
Date: Mon, 8 Apr 2024 15:35:12 -0700
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
Message-ID: <edc8b1ad-dee0-456f-89fb-47bd4709ff0e@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
 <ZhROKK9dEPsNnH4t@google.com>
 <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
 <ZhRoDfoz-YqsGhIB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhRoDfoz-YqsGhIB@google.com>

On Mon, Apr 08, 2024 at 02:56:29PM -0700, Sean Christopherson wrote:
> On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> > On Mon, Apr 08, 2024 at 01:06:00PM -0700, Sean Christopherson wrote:
> > > On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> > > > > > > +	if (vcpu->wants_to_run)
> > > > > > > +		context_tracking_guest_start_run_loop();
> > > > > > 
> > > > > > At this point, if this is a nohz_full CPU, it will no longer report
> > > > > > quiescent states until the grace period is at least one second old.
> > > > > 
> > > > > I don't think I follow the "will no longer report quiescent states" issue.  Are
> > > > > you saying that this would prevent guest_context_enter_irqoff() from reporting
> > > > > that the CPU is entering a quiescent state?  If so, that's an issue that would
> > > > > need to be resolved regardless of what heuristic we use to determine whether or
> > > > > not a CPU is likely to enter a KVM guest.
> > > > 
> > > > Please allow me to start over.  Are interrupts disabled at this point,
> > > 
> > > Nope, IRQs are enabled.
> > > 
> > > Oof, I'm glad you asked, because I was going to say that there's one exception,
> > > kvm_sched_in(), which is KVM's notifier for when a preempted task/vCPU is scheduled
> > > back in.  But I forgot that kvm_sched_{in,out}() don't use vcpu_{load,put}(),
> > > i.e. would need explicit calls to context_tracking_guest_{stop,start}_run_loop().
> > > 
> > > > and, if so, will they remain disabled until the transfer of control to
> > > > the guest has become visible to RCU via the context-tracking code?
> > > > 
> > > > Or has the context-tracking code already made the transfer of control
> > > > to the guest visible to RCU?
> > > 
> > > Nope.  The call to __ct_user_enter(CONTEXT_GUEST) or rcu_virt_note_context_switch()
> > > happens later, just before the actual VM-Enter.  And that call does happen with
> > > IRQs disabled (and IRQs stay disabled until the CPU enters the guest).
> > 
> > OK, then we can have difficulties with long-running interrupts hitting
> > this range of code.  It is unfortunately not unheard-of for interrupts
> > plus trailing softirqs to run for tens of seconds, even minutes.
> 
> Ah, and if that occurs, *and* KVM is slow to re-enter the guest, then there will
> be a massive lag before the CPU gets back into a quiescent state.

Exactly!

> > One counter-argument is that that softirq would take scheduling-clock
> > interrupts, and would eventually make rcu_core() run.
> 
> Considering that this behavior would be unique to nohz_full CPUs, how much
> responsibility does RCU have to ensure a sane setup?  E.g. if a softirq runs for
> multiple seconds on a nohz_full CPU whose primary role is to run a KVM vCPU, then
> whatever real-time workaround the vCPU is running is already doomed.

True, but it is always good to be doing one's part.

> > But does a rcu_sched_clock_irq() from a guest OS have its "user"
> > argument set?
> 
> No, and it shouldn't, at least not on x86 (I assume other architectures are
> similar, but I don't actually no for sure).
> 
> On x86, the IRQ that the kernel sees comes looks like it comes from host kernel
> code.  And on AMD (SVM), the IRQ doesn't just "look" like it came from host kernel,
> the IRQ really does get vectored/handled in the host kernel.  Intel CPUs have a
> performance optimization where the IRQ gets "eaten" as part of the VM-Exit, and
> so KVM synthesizes a stack frame and does a manual CALL to invoke the IRQ handler.
> 
> And that's just for IRQs that actually arrive while the guest is running.  IRQs
> arrive while KVM is active, e.g. running its large vcpu_run(), are "pure" host
> IRQs.

OK, then is it possible to get some other indication to the
rcu_sched_clock_irq() function that it has interrupted a guest OS?

Not an emergency, and maybe not even necessary, but it might well be
one hole that would be good to stop up.

							Thanx, Paul

