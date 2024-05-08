Return-Path: <kvm+bounces-16947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 029988BF34F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 02:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC0A228B3A7
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 00:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA36944E;
	Wed,  8 May 2024 00:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PjwqI0f8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5218472
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715126938; cv=none; b=s+jjsmcBbcVvXyGDV6eOttTYnvRo0ykwmDGngUQAd7a05Z4GHT6ofaSzbPvzmwo6XdZOCPOfPqWwvANWdhXEKYBZ+GjusGlK1zQcFFRnrfNRbzyWGG+tu5L/COOJFUJGIvX8Pi2bT4fXA1zoMx1OQNY41XsvUev1U2ygXEeGOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715126938; c=relaxed/simple;
	bh=ahC4gTpeG6g5UN8k6ONucOy255QEUM6cPgCi8OrXZ10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LKQ03B733RcS1EcfeAEXwcPT6Yla6pLs4RiwySWmV9Nz//GxeuOHJrZa5tbFBjgWz44XYTmvfQQBNE9lqkZsaveA9LEWNK0JQUCv8Bygu1LnKQr4OnhVqGpBcYW3JSmhm8DzLDzPnn1fYqwNl9WJRInK7K6CVLbrWYT4x3iIvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PjwqI0f8; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62035d9ecc4so77405627b3.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 17:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715126936; x=1715731736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnwhV/LvL/OQPBIYCw7gCMwrNIFJkJqk8vM/Wxi/lik=;
        b=PjwqI0f83GufDtwTocqOeGwjmIQrFHnJvjXmgf3UM3lgll4kUrNxWSU+rw5kWuuqEZ
         34ulZybOUVYRiA/xqht/RomDHsrRmV+KXsi6SILD3dUgM0uyHTrpwhnHw4kobPHqsG4a
         QjI5UuqZlXaKbrZzeZzeW5IjjiwnUYOkLxynfvAAiJlsEtNLFyn/3EJlPgEkgWbq1yS/
         M5fFD70TB+zC0ApxIV80CCZVkMmAOxuh6/hMvZ+Kz+i/7xiE0tWoYF391y1rtF+GfA7A
         TBUhBBtshcAHk2D/xLgx8OTfD6oj9rp/uwd1slpqBOC0VKW2Hyqzry7ytNoWKz21iDcO
         BWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715126936; x=1715731736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnwhV/LvL/OQPBIYCw7gCMwrNIFJkJqk8vM/Wxi/lik=;
        b=kLGoacE3oYROGWMxlYBVgQuAuZ/9Lnv0+p/9eYU2fltJEI0jbyoFcuYD3PfsFX1R7O
         miBUBViXov44QhfBctiftFDpNMiaUBz2fCkUAmodvVauE7cMzjd5/Xbvol/r/pnxrb0M
         +dGkCiGolQRLSvmwHgrH4ONgN+dEU73U9TgHLvd8nqevHjkVNiB3laZib3MUBudgdIrD
         41T7SRQ6DP0FpYA9EknVODVX/5zgOwPzI9KyXVthmEILuEAsjUjbX6Q28Ecn8DYbZExC
         lZ0KdO6K2WhUU6w7iyfnR+5ILQFshN5odJr1SYuhQKC5xrZ7IjSEoQ1K7tBOd+5n4+ig
         ajbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCTz7MwuBm629pnw1N8PICzL0PuLsFlmlC89AM7trPdHk125VgDBkeyay1P8Lxdjw5s4Q1SDlEiwj7DtEbUlSj5Fkw
X-Gm-Message-State: AOJu0Yx7wDL7Ix6sfLQyuOYfJyKCA0Qqh8ukO7+Ti0F3gJwHV80imT3w
	ioYUF40RyXzLgLaPoISgGEkl/sB8XPWY9GHwz83AKJWR1cNEG7zFIsB1XMiK+SFGKUUxZf0Udh1
	yMg==
X-Google-Smtp-Source: AGHT+IGUjkXS7Kg3JrQMkuTAkn9sibTQZUqhvskBNGnmJe8WZDEH6Igv7+GWZETlEtG78YOqQFhSkvchNrQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f4d:0:b0:61b:e0a6:3c21 with SMTP id
 00721157ae682-62085c5d6e9mr3394117b3.8.1715126935733; Tue, 07 May 2024
 17:08:55 -0700 (PDT)
Date: Tue, 7 May 2024 17:08:54 -0700
In-Reply-To: <Zjq9okodmvkywz82@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras> <ZjVXVc2e_V8NiMy3@google.com> <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com> <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com>
Message-ID: <ZjrClk4Lqw_cLO5A@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 07, 2024, Sean Christopherson wrote:
> On Tue, May 07, 2024, Paul E. McKenney wrote:
> > On Tue, May 07, 2024 at 02:00:12PM -0700, Sean Christopherson wrote:
> > > On Tue, May 07, 2024, Paul E. McKenney wrote:
> > > > On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> > > > > On Fri, May 03, 2024, Paul E. McKenney wrote:
> > > > > > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > > > > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > > > > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > > > > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > > > > > userspace communicate to the kernel that it's a real-time task that spends the
> > > > > > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > > > > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > > > > > while it's in kernel context.
> > > > > > 
> > > > > > But if the task is executing in host kernel context for quite some time,
> > > > > > then the host kernel's RCU really does need to take evasive action.
> > > > > 
> > > > > Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> > > > > form of the 1 second timeout.
> > > > 
> > > > Plus RCU will force-enable that CPU's scheduler-clock tick after about
> > > > ten milliseconds of that CPU not being in a quiescent state, with
> > > > the time varying depending on the value of HZ and the number of CPUs.
> > > > After about ten seconds (halfway to the RCU CPU stall warning), it will
> > > > resched_cpu() that CPU every few milliseconds.
> > > > 
> > > > > And while KVM does not guarantee that it will immediately resume the guest after
> > > > > servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> > > > > anything that would prevent the kernel from preempting the interrupt task.
> > > > 
> > > > Similarly, the hypervisor could preempt a guest OS's RCU read-side
> > > > critical section or its preempt_disable() code.
> > > > 
> > > > Or am I missing your point?
> > > 
> > > I think you're missing my point?  I'm talking specifically about host RCU, what
> > > is or isn't happening in the guest is completely out of scope.
> > 
> > Ah, I was thinking of nested virtualization.
> > 
> > > My overarching point is that the existing @user check in rcu_pending() is optimistic,
> > > in the sense that the CPU is _likely_ to quickly enter a quiescent state if @user
> > > is true, but it's not 100% guaranteed.  And because it's not guaranteed, RCU has
> > > the aforementioned guardrails.
> > 
> > You lost me on this one.
> > 
> > The "user" argument to rcu_pending() comes from the context saved at
> > the time of the scheduling-clock interrupt.  In other words, the CPU
> > really was executing in user mode (which is an RCU quiescent state)
> > when the interrupt arrived.
> > 
> > And that suffices, 100% guaranteed.
> 
> Ooh, that's where I'm off in the weeds.  I was viewing @user as "this CPU will be
> quiescent", but it really means "this CPU _was_ quiescent".

Hrm, I'm still confused though.  That's rock solid for this check:

	/* Is the RCU core waiting for a quiescent state from this CPU? */

But I don't understand how it plays into the next three checks that can result in
rcuc being awakened.  I suspect it's these checks that Leo and Marcelo are trying
squash, and these _do_ seem like they are NOT 100% guaranteed by the @user check.

	/* Does this CPU have callbacks ready to invoke? */
	/* Has RCU gone idle with this CPU needing another grace period? */
	/* Have RCU grace period completed or started?  */

> > The reason that it suffices is that other RCU code such as rcu_qs() and
> > rcu_note_context_switch() ensure that this CPU does not pay attention to
> > the user-argument-induced quiescent state unless this CPU had previously
> > acknowledged the current grace period.
> > 
> > And if the CPU has previously acknowledged the current grace period, that
> > acknowledgement must have preceded the interrupt from user-mode execution.
> > Thus the prior quiescent state represented by that user-mode execution
> > applies to that previously acknowledged grace period.
> 
> To confirm my own understanding: 
> 
>   1. Acknowledging the current grace period means any future rcu_read_lock() on
>      the CPU will be accounted to the next grace period.
> 
>   2. A CPU can acknowledge a grace period without being quiescent.
> 
>   3. Userspace can't acknowledge a grace period, because it doesn't run kernel
>      code (stating the obvious).
> 
>   4. All RCU read-side critical sections must complete before exiting to usersepace.
> 
> And so if an IRQ interrupts userspace, and the CPU previously acknowledged grace
> period N, RCU can infer that grace period N elapsed on the CPU, because all
> "locks" held on grace period N are guaranteed to have been dropped.
> 
> > This is admittedly a bit indirect, but then again this is Linux-kernel
> > RCU that we are talking about.
> > 
> > > And I'm arguing that, since the @user check isn't bombproof, there's no reason to
> > > try to harden against every possible edge case in an equivalent @guest check,
> > > because it's unnecessary for kernel safety, thanks to the guardrails.
> > 
> > And the same argument above would also apply to an equivalent check for
> > execution in guest mode at the time of the interrupt.
> 
> This is partly why I was off in the weeds.  KVM cannot guarantee that the
> interrupt that leads to rcu_pending() actually interrupted the guest.  And the
> original patch didn't help at all, because a time-based check doesn't come
> remotely close to the guarantees that the @user check provides.
> 
> > Please understand that I am not saying that we absolutely need an
> > additional check (you tell me!).
> 
> Heh, I don't think I'm qualified to answer that question, at least not yet.
> 
> > But if we do need RCU to be more aggressive about treating guest execution as
> > an RCU quiescent state within the host, that additional check would be an
> > excellent way of making that happen.
> 
> It's not clear to me that being more agressive is warranted.  If my understanding
> of the existing @user check is correct, we _could_ achieve similar functionality
> for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
> with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
> On x86, this would be relatively straightforward (hack-a-patch below), but I've
> no idea what it would look like on other architectures.
> 
> But the value added isn't entirely clear to me, probably because I'm still missing
> something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
> note the transition from guest to host kernel.  Why isn't that a sufficient hook
> for RCU to infer grace period completion?
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1a9e1e0c9f49..259b60adaad7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11301,6 +11301,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         if (vcpu->arch.guest_fpu.xfd_err)
>                 wrmsrl(MSR_IA32_XFD_ERR, 0);
>  
> +       RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
> +                        lock_is_held(&rcu_lock_map) ||
> +                        lock_is_held(&rcu_sched_lock_map),
> +                        "KVM in RCU read-side critical section with PF_VCPU set and IRQs enabled");
> +
>         /*
>          * Consume any pending interrupts, including the possible source of
>          * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index b2bccfd37c38..cdb815105de4 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3929,7 +3929,8 @@ static int rcu_pending(int user)
>                 return 1;
>  
>         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> +       if ((user || rcu_is_cpu_rrupt_from_idle() || (current->flags & PF_VCPU)) &&
> +           rcu_nohz_full_cpu())
>                 return 0;
>  
>         /* Is the RCU core waiting for a quiescent state from this CPU? */
> 
> 

