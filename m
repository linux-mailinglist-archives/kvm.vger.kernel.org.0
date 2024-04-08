Return-Path: <kvm+bounces-13916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A54F289CCC8
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C77A284244
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE38146D4C;
	Mon,  8 Apr 2024 20:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cvHdHIMS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E4E1465B0
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 20:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606764; cv=none; b=XyePcqz81AN+XECQrIQg0NseH/L2r5QgeETMPaSU+NsmdRsrLYx6YEEyV5nm8lnnIRnKVT0Qcs3KJPgV+K54TeIR0ME6hJlqe0vxblvVHHrD9N+5W73Oyfmw3bc7/RNtXEWYUN1EZoTXf5z/tMvmZrXV0E4OnjUnhfdhsbnZQ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606764; c=relaxed/simple;
	bh=kwV78+Fzzfpcqphz1BsacSHHvAKDUYxpiRcKcMigDrE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tx3Yz0KhEDp3lrxDsmXNFNAxwrxxBsCjHENHNdL9lT3rFF92Eu09zMZwg19eVMtMRMa7KPNOcOEJ3BoTA2lH3e9vRXD5jlO4zin7sr8/5h7LprwC0fXb1Ueph6yTAk+m5nCH9VxCh/qubU9hDoWaAIdpQwH4weJsOzRIQd8rdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cvHdHIMS; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso7924976276.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712606762; x=1713211562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUX/BXxm5tfHPj51YbzD/r2YRPmp66ayVdDNd7IKh2E=;
        b=cvHdHIMSN59EXypqzzYnxMdLoNQ8UtrIzHQirT02dZSk3ttuSKpSTVbGtmVZni5zVU
         vwzCXJyya3IrKkopXQFKozjA232haSrhVYlkBbBQIOV6lcttafbRfXtFzffwELJbNRAF
         nxHgdQDQ9Xdbgtv7TpCo5G9jjnS2pWj6QdPbi4fOhI3EBx/+LiYAAq6+plKiCrxKpTD+
         e4vjFrfxCDj3WzqNYHBQPH8TFyr5BPFkxDdiluiz81VnqzcuKzJkn/hp0fjAg37+tXYX
         ybE5vEkjnZdub/qP1DH+sHe/IOTiD98XNmQCq1bRKzV/Wwipagfc+KSvAtZ3TCFdlq7/
         7nfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712606762; x=1713211562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUX/BXxm5tfHPj51YbzD/r2YRPmp66ayVdDNd7IKh2E=;
        b=swDvnPIhuUqVnIvNfzyk4JoKY2F+wsrFmYACVT+5ER3HSMJIMxYv8L0R5ad3hb8xYx
         7vJk/PX+GmAFVspVjQCnVjsEj2bLwJ6ZBenRmbDT2zzJGSVqHEDOnyPB6fCz7z+wI+sq
         oQc8C5u2WlWNLnMCK4Mq1y4nykRDCayxhbAKvEoT8fOqvC0tgf16h357DW+ybq2BFv6J
         +g1v6ljIZJGkug0nfQWJNrr9kNHVa9lXuTVYlHCSpHpx9wCSloNAGx//mJjPu1+5aRq+
         S+fgbKeOUfm5iJE2ftIgz0+gYAOCLrHwD/dUyo3J00gtv9Sm6N2XsAEqJCBe/R14BHAX
         GOLw==
X-Forwarded-Encrypted: i=1; AJvYcCVUA+UAo6F9Gn4dPTjYaaDwzJpTBm5/kFfRoTuuJITtCLsA1859oGvXI/PioyAZil9cB/yw1l85A7MdlEkogChwxOCg
X-Gm-Message-State: AOJu0YzcM3ADT1Q4sli/2b3EOS9ZzHEYW/VLXIrXBmpo5busvk48UicI
	2m+bHEvm14FquNT229b1zXl37UjVNNt33wNszz1rk4y0t1VdvGK0LKkaWUvSRTrr9JIc6SrOhd6
	NLQ==
X-Google-Smtp-Source: AGHT+IEB8jlPzBidINz230BTnhZGeoYevoscMEtx8YW1F+hykhRihBES0ZiVVSCK+/sGR7wlk6nH3t/5rL8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c09:b0:dcd:b431:7f5b with SMTP id
 fs9-20020a0569020c0900b00dcdb4317f5bmr3254276ybb.0.1712606761926; Mon, 08 Apr
 2024 13:06:01 -0700 (PDT)
Date: Mon, 8 Apr 2024 13:06:00 -0700
In-Reply-To: <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad> <ZhAN28BcMsfl4gm-@google.com> <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com> <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
Message-ID: <ZhROKK9dEPsNnH4t@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Leonardo Bras <leobras@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <quic_neeraju@quicinc.com>, Joel Fernandes <joel@joelfernandes.org>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> On Mon, Apr 08, 2024 at 10:16:24AM -0700, Sean Christopherson wrote:
> > On Fri, Apr 05, 2024, Paul E. McKenney wrote:
> > Issuing a warning based on an arbitrary time limit is wildly different than using
> > an arbitrary time window to make functional decisions.  My objection to the "assume
> > the CPU will enter a quiescent state if it exited a KVM guest in the last second"
> > is that there are plenty of scenarios where that assumption falls apart, i.e. where
> > _that_ physical CPU will not re-enter the guest.
> > 
> > Off the top of my head:
> > 
> >  - If the vCPU is migrated to a different physical CPU (pCPU), the *old* pCPU
> >    will get false positives, and the *new* pCPU will get false negatives (though
> >    the false negatives aren't all that problematic since the pCPU will enter a
> >    quiescent state on the next VM-Enter.
> > 
> >  - If the vCPU halts, in which case KVM will schedule out the vCPU/task, i.e.
> >    won't re-enter the guest.  And so the pCPU will get false positives until the
> >    vCPU gets a wake event or the 1 second window expires.
> > 
> >  - If the VM terminates, the pCPU will get false positives until the 1 second
> >    window expires.
> > 
> > The false positives are solvable problems, by hooking vcpu_put() to reset
> > kvm_last_guest_exit.  And to help with the false negatives when a vCPU task is
> > scheduled in on a different pCPU, KVM would hook vcpu_load().
> 
> Here you are arguing against the heuristic in the original patch, correct?

Yep, correct.

> As opposed to the current RCU heuristic that ignores certain quiescent
> states for nohz_full CPUs until the grace period reaches an age of
> one second?
> 
> If so, no argument here.  In fact, please consider my ack cancelled.

...

> > That's a largely orthogonal discussion.  As above, boosting the scheduling priority
> > of a vCPU because that vCPU is in critical section of some form is not at all
> > unique to nested virtualization (or RCU).
> > 
> > For basic functional correctness, the L0 hypervisor already has the "hint" it 
> > needs.  L0 knows that the L1 CPU wants to run by virtue of the L1 CPU being
> > runnable, i.e. not halted, not in WFS, etc.
> 
> And if the system is sufficiently lightly loaded, all will be well, as is
> the case with my rcutorture usage.  However, if the system is saturated,
> that basic functional correctness might not be enough.  I haven't heard
> many complaints, other than research work, so I have been assuming that
> we do not yet need hinting.  But you guys tell me.  ;-)

We should never use hinting for basic, *default* functionality.  If the host is
so overloaded that it can induce RCU stalls with the default threshold of 21
seconds, then something in the host's domain is broken/misconfigured.  E.g. it
doesn't necessary have to be a host kernel/userspace bug, it could be an issue
with VM scheduling at the control plane.  But it's still a host issue, and under
no circumstance should the host need a hint in order for the guest to not complain
after 20+ seconds.

And _if_ we were to push the default lower, e.g. all the way down to Android's
aggressive 20 milliseconds, a boosting hint would still be the wrong way to go
about it, because no sane hypervisor would ever back such a hint with strong
guarantees for all scenarios.

It's very much possible to achieve a 20ms deadline when running as a VM, but it
would require strong guarantees about the VM's configuration and environment,
e.g. that memory isn't overcommited, that each vCPU has a fully dedicated pCPU,
etc.

> > > > +	    rcu_nohz_full_cpu())
> > > 
> > > And rcu_nohz_full_cpu() has a one-second timeout, and has for quite
> > > some time.
> > 
> > That's not a good reason to use a suboptimal heuristic for determining whether
> > or not a CPU is likely to enter a KVM guest, it simply mitigates the worst case
> > scenario of a false positive.
> 
> Again, are you referring to the current RCU code, or the original patch
> that started this email thread?

Original patch.

> > > >  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index bfb2b52a1416..5a7efc669a0f 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -209,6 +209,9 @@ void vcpu_load(struct kvm_vcpu *vcpu)
> > > >  {
> > > >  	int cpu = get_cpu();
> > > >  
> > > > +	if (vcpu->wants_to_run)
> > > > +		context_tracking_guest_start_run_loop();
> > > 
> > > At this point, if this is a nohz_full CPU, it will no longer report
> > > quiescent states until the grace period is at least one second old.
> > 
> > I don't think I follow the "will no longer report quiescent states" issue.  Are
> > you saying that this would prevent guest_context_enter_irqoff() from reporting
> > that the CPU is entering a quiescent state?  If so, that's an issue that would
> > need to be resolved regardless of what heuristic we use to determine whether or
> > not a CPU is likely to enter a KVM guest.
> 
> Please allow me to start over.  Are interrupts disabled at this point,

Nope, IRQs are enabled.

Oof, I'm glad you asked, because I was going to say that there's one exception,
kvm_sched_in(), which is KVM's notifier for when a preempted task/vCPU is scheduled
back in.  But I forgot that kvm_sched_{in,out}() don't use vcpu_{load,put}(),
i.e. would need explicit calls to context_tracking_guest_{stop,start}_run_loop().

> and, if so, will they remain disabled until the transfer of control to
> the guest has become visible to RCU via the context-tracking code?
> 
> Or has the context-tracking code already made the transfer of control
> to the guest visible to RCU?

Nope.  The call to __ct_user_enter(CONTEXT_GUEST) or rcu_virt_note_context_switch()
happens later, just before the actual VM-Enter.  And that call does happen with
IRQs disabled (and IRQs stay disabled until the CPU enters the guest).

> > > >  	__this_cpu_write(kvm_running_vcpu, vcpu);
> > > >  	preempt_notifier_register(&vcpu->preempt_notifier);
> > > >  	kvm_arch_vcpu_load(vcpu, cpu);
> > > > @@ -222,6 +225,10 @@ void vcpu_put(struct kvm_vcpu *vcpu)
> > > >  	kvm_arch_vcpu_put(vcpu);
> > > >  	preempt_notifier_unregister(&vcpu->preempt_notifier);
> > > >  	__this_cpu_write(kvm_running_vcpu, NULL);
> > > > +
> > > 
> > > And also at this point, if this is a nohz_full CPU, it will no longer
> > > report quiescent states until the grace period is at least one second old.
> 
> And here, are interrupts disabled at this point, and if so, have they
> been disabled since the time that the exit from the guest become
> visible to RCU via the context-tracking code?

IRQs are enabled.

The gist of my suggestion is:

	ioctl(KVM_RUN) {

		context_tracking_guest_start_run_loop();

		for (;;) {

			vcpu_run();

			if (<need to return to userspace>)
				break;
		}

		context_tracking_guest_stop_run_loop();
	}

where vcpu_run() encompasses a fairly huge amount of code and functionality,
including the logic to do world switches between host and guest.

E.g. if a vCPU triggers a VM-Exit because it tried to access memory that has been
swapped out by the host, KVM could end up way down in mm/ doing I/O to bring a
page back into memory for the guest.  Immediately after VM-Exit, before enabling
IRQs, KVM will notify RCU that the CPU has exited the extended quiescent state
(this is what happens today).  But the "in KVM run loop" flag would stay set, and
RCU would rely on rcu_nohz_full_cpu() for protection, e.g. in case faulting in
memory somehow takes more than a second.

But, barring something that triggers a return to userspace, KVM _will_ re-enter
the guest as quickly as possible.  So it's still a heuristic in the sense that
the CPU isn't guaranteed to enter the guest, nor are there any enforceable SLOs
on how quickly the CPU will enter the guest, but I think it's the best tradeoff
between simplicity and functionality, especially since rcu_nohz_full_cpu() has
a one second timeout to safeguard against some unforeseen hiccup that prevents
KVM from re-entering the guest in a timely manner.

Note, as above, my intent is that there would also be hooks in kvm_sched_{in,out}()
to note that the guest run loop is starting/stopping if the vCPU task yields or
is preempted.

