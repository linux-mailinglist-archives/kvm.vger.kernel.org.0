Return-Path: <kvm+bounces-16946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C44C8BF326
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 02:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 906481C21538
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 00:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7680D135A68;
	Tue,  7 May 2024 23:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tDj1/7T2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EA8135A56
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 23:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715125670; cv=none; b=NOOGOxOUH4urgKXKMHGa2X5XueI5YZdoMGKdvjIDm9OjWpZGfGekMv4aOei2/LDYaC1kulfZiXVmr5J0O7oJssls3hil3+2rVyhOjXL5vzhm0CM+iCyHKGlWaaO21dFi9nOeXSIuzmRcA25h3hl1Ws217Fr2ZuBbkW7eFhGtd8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715125670; c=relaxed/simple;
	bh=eJJcc9/vEoAgKc0vBQHiq0LQSeWtMHmX7IdNRX5mLMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ow9iY315/tAznmUI5vN8z407qWoSNZX6y1Zln1cMhkOW55hZBbwcyrD/tn/Z54tVvw0ntrzyZ9lZkQt7eBPNoNAgebodFzaKO08haSvxtOq88D9sp4AyvogK9CurGVe7XCq8ZkeUVWdz/IWpXYPjFcVLV5ZwabL2eWHvaYeLBVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tDj1/7T2; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de59e612376so5990956276.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 16:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715125668; x=1715730468; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IXBITghFu68KvfLK/vk4MdUQB79Xb1JqM3/6jUAIT0=;
        b=tDj1/7T2sVLLz0OZaPa6Yev/UamStagunEeBAIAfHUDyzj1qTD0U+Iaz6RUWXGja5f
         osOtfp92mCtCDF7gXb3RwO++ZYw9QiWz5m/OxwDJK7koKvh38BNv4z2I8vIORJ5OC3s5
         gXONvr4DV868bvZnCHOpfSr66n2F7uIAK9Blr030yuMgGy1UFlKj0sjxOjTlEh6H5grz
         1Juyo+x74t6BdqvH1g7DdGN+7MR2ru3OlYK+mukrL3qj84/H+UgjfA8CqNdqFgr1yhVR
         1H8wcUFytulJpmgYqEnleaPRS9AwamfRLgRVrudbiGY4wkDyI7drt3cTEyxOMCzppr4N
         txUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715125668; x=1715730468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IXBITghFu68KvfLK/vk4MdUQB79Xb1JqM3/6jUAIT0=;
        b=iz9XmSB7lTiOChwyZ3xv7aYeZn4VJbN86bl914siIMJV5du78m5Hd2QC0On06gGppS
         B0l9U8B1oyeCwMc7H+/3tpBCqyReB4TxSjOEVbxxnO6liLRHsmRE8dACmxaZpjsWvDY+
         eCzoqQENgTmCCIBrkxqfLEw/zsylrf+B3swxo6Y2ri+53cKJPZbzlcDawdIFTVyr5B4F
         9NPPM8RdaaCqvThWRpSlDEIKgWEsH6ugdlpnWfCK0gvM7m1+6c8hfoW/aar6ooAnAVPQ
         8EkjOch6Cu4GjIsIT/+6zZj9qQ3NZH8z8+VHgaY/rup1L9uzGTkRXJoIrYZ/J3dwN8M6
         K6wg==
X-Forwarded-Encrypted: i=1; AJvYcCUirbgwFS7REWnmgtqHCTVeLuhbcWD7eeL8rTYOw8vHSvjcol8DPLJUWisFv+M6KXYlywjqXP4hj/jrPUqD6C4c7egy
X-Gm-Message-State: AOJu0Yxd7lx0sXdzIeD6Tbn6VPDDCu0y6U6A8A5NOesbCZdxSXc45eFc
	Okj7RMRzSPMoR5QxqfMzoLfJddPgXYwLYGLEfFo0prIl/CFHvZnB42iYMd68hRsKUlU+RIrqGc5
	d0A==
X-Google-Smtp-Source: AGHT+IG/zbW3ZTXeLZe8peXCzOYAoo/IILDrQq8ef+DM8SDCbnL9oZ9XTD5+3e/nY3886sM0N39DaloXhVM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dd1:38ec:905d with SMTP id
 3f1490d57ef6-debb9e0bdeemr128969276.11.1715125668120; Tue, 07 May 2024
 16:47:48 -0700 (PDT)
Date: Tue, 7 May 2024 16:47:46 -0700
In-Reply-To: <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
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
Message-ID: <Zjq9okodmvkywz82@google.com>
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

On Tue, May 07, 2024, Paul E. McKenney wrote:
> On Tue, May 07, 2024 at 02:00:12PM -0700, Sean Christopherson wrote:
> > On Tue, May 07, 2024, Paul E. McKenney wrote:
> > > On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> > > > On Fri, May 03, 2024, Paul E. McKenney wrote:
> > > > > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > > > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > > > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > > > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > > > > userspace communicate to the kernel that it's a real-time task that spends the
> > > > > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > > > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > > > > while it's in kernel context.
> > > > > 
> > > > > But if the task is executing in host kernel context for quite some time,
> > > > > then the host kernel's RCU really does need to take evasive action.
> > > > 
> > > > Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> > > > form of the 1 second timeout.
> > > 
> > > Plus RCU will force-enable that CPU's scheduler-clock tick after about
> > > ten milliseconds of that CPU not being in a quiescent state, with
> > > the time varying depending on the value of HZ and the number of CPUs.
> > > After about ten seconds (halfway to the RCU CPU stall warning), it will
> > > resched_cpu() that CPU every few milliseconds.
> > > 
> > > > And while KVM does not guarantee that it will immediately resume the guest after
> > > > servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> > > > anything that would prevent the kernel from preempting the interrupt task.
> > > 
> > > Similarly, the hypervisor could preempt a guest OS's RCU read-side
> > > critical section or its preempt_disable() code.
> > > 
> > > Or am I missing your point?
> > 
> > I think you're missing my point?  I'm talking specifically about host RCU, what
> > is or isn't happening in the guest is completely out of scope.
> 
> Ah, I was thinking of nested virtualization.
> 
> > My overarching point is that the existing @user check in rcu_pending() is optimistic,
> > in the sense that the CPU is _likely_ to quickly enter a quiescent state if @user
> > is true, but it's not 100% guaranteed.  And because it's not guaranteed, RCU has
> > the aforementioned guardrails.
> 
> You lost me on this one.
> 
> The "user" argument to rcu_pending() comes from the context saved at
> the time of the scheduling-clock interrupt.  In other words, the CPU
> really was executing in user mode (which is an RCU quiescent state)
> when the interrupt arrived.
> 
> And that suffices, 100% guaranteed.

Ooh, that's where I'm off in the weeds.  I was viewing @user as "this CPU will be
quiescent", but it really means "this CPU _was_ quiescent".

> The reason that it suffices is that other RCU code such as rcu_qs() and
> rcu_note_context_switch() ensure that this CPU does not pay attention to
> the user-argument-induced quiescent state unless this CPU had previously
> acknowledged the current grace period.
> 
> And if the CPU has previously acknowledged the current grace period, that
> acknowledgement must have preceded the interrupt from user-mode execution.
> Thus the prior quiescent state represented by that user-mode execution
> applies to that previously acknowledged grace period.

To confirm my own understanding: 

  1. Acknowledging the current grace period means any future rcu_read_lock() on
     the CPU will be accounted to the next grace period.

  2. A CPU can acknowledge a grace period without being quiescent.

  3. Userspace can't acknowledge a grace period, because it doesn't run kernel
     code (stating the obvious).

  4. All RCU read-side critical sections must complete before exiting to usersepace.

And so if an IRQ interrupts userspace, and the CPU previously acknowledged grace
period N, RCU can infer that grace period N elapsed on the CPU, because all
"locks" held on grace period N are guaranteed to have been dropped.

> This is admittedly a bit indirect, but then again this is Linux-kernel
> RCU that we are talking about.
> 
> > And I'm arguing that, since the @user check isn't bombproof, there's no reason to
> > try to harden against every possible edge case in an equivalent @guest check,
> > because it's unnecessary for kernel safety, thanks to the guardrails.
> 
> And the same argument above would also apply to an equivalent check for
> execution in guest mode at the time of the interrupt.

This is partly why I was off in the weeds.  KVM cannot guarantee that the
interrupt that leads to rcu_pending() actually interrupted the guest.  And the
original patch didn't help at all, because a time-based check doesn't come
remotely close to the guarantees that the @user check provides.

> Please understand that I am not saying that we absolutely need an
> additional check (you tell me!).

Heh, I don't think I'm qualified to answer that question, at least not yet.

> But if we do need RCU to be more aggressive about treating guest execution as
> an RCU quiescent state within the host, that additional check would be an
> excellent way of making that happen.

It's not clear to me that being more agressive is warranted.  If my understanding
of the existing @user check is correct, we _could_ achieve similar functionality
for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
On x86, this would be relatively straightforward (hack-a-patch below), but I've
no idea what it would look like on other architectures.

But the value added isn't entirely clear to me, probably because I'm still missing
something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
note the transition from guest to host kernel.  Why isn't that a sufficient hook
for RCU to infer grace period completion?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a9e1e0c9f49..259b60adaad7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11301,6 +11301,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
        if (vcpu->arch.guest_fpu.xfd_err)
                wrmsrl(MSR_IA32_XFD_ERR, 0);
 
+       RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
+                        lock_is_held(&rcu_lock_map) ||
+                        lock_is_held(&rcu_sched_lock_map),
+                        "KVM in RCU read-side critical section with PF_VCPU set and IRQs enabled");
+
        /*
         * Consume any pending interrupts, including the possible source of
         * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b2bccfd37c38..cdb815105de4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3929,7 +3929,8 @@ static int rcu_pending(int user)
                return 1;
 
        /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
-       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
+       if ((user || rcu_is_cpu_rrupt_from_idle() || (current->flags & PF_VCPU)) &&
+           rcu_nohz_full_cpu())
                return 0;
 
        /* Is the RCU core waiting for a quiescent state from this CPU? */



