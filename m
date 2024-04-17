Return-Path: <kvm+bounces-14991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 587F58A889B
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B12C0B24F92
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7484149019;
	Wed, 17 Apr 2024 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQVLk93Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046291487E4
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370484; cv=none; b=FVarBYcRkaEvNdKjALpSXpAsuTb4F4ct8eNhLvEq6GXq0fmOiyeEZGrs3WpAcAFowxVnfAsjE0kpkEvzDzxVYO67czqUKmNvEp+GmPvaw18hn48P5zLz0Em9JUUaBpSbfl3Ptwx0OHUR9kJ/N2BD8az7/3U/YhWu1FgPvd4BTfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370484; c=relaxed/simple;
	bh=S1yhgaRLFPOXidC/cYYslItIjG46TDGeuQmOH40nfME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rymhaa1D70lmlgNkXPvn7dX5FElY4EJkkYjePdrODKg3MVX5O17j9k6kW+/O5V/TIqI1pZa5ZGcv21Wu3clijWBzie7e+ezX1L5N8G//i8t6J2l94bSAxMSFSSEKQ8oJbZf385yLBMRplPUYwH5Hxre3kru/BnSApep2ik4N1Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQVLk93Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713370479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVwYiuDV1ATQ7UBW8Sq0lK/csErv1chKrLOaAmc5mOg=;
	b=EQVLk93QTlbHuyPqPxx1IzBrFY3j/UkIemGhTs+zNJIzYqPIu1ylpYQssywE/i8OJbp7zQ
	E8Dtx3pgbPBMkTuNSxn/tpXAv+4PdDE9rCTbWjIsJfg76mYq/+7iLMJX+c9aCb1NUPl2pu
	TLMI1Ek+k+JYwMbLV9BlUZKLbknGBMs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-6kAP76NnOCmOGM6mQn6s8w-1; Wed,
 17 Apr 2024 12:14:35 -0400
X-MC-Unique: 6kAP76NnOCmOGM6mQn6s8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CAB63C14940;
	Wed, 17 Apr 2024 16:14:35 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.8])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD27340C6CB2;
	Wed, 17 Apr 2024 16:14:33 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 50881400DC647; Wed, 17 Apr 2024 13:14:11 -0300 (-03)
Date: Wed, 17 Apr 2024 13:14:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <Zh/1U8MtPWQ/yN2T@tpad>
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <Zh2EQVj5bC0z5R90@tpad>
 <Zh2cPJ-5xh72ojzu@google.com>
 <Zh5w6rAWL+08a5lj@tpad>
 <Zh6GC0NRonCpzpV4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6GC0NRonCpzpV4@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Tue, Apr 16, 2024 at 07:07:32AM -0700, Sean Christopherson wrote:
> On Tue, Apr 16, 2024, Marcelo Tosatti wrote:
> > On Mon, Apr 15, 2024 at 02:29:32PM -0700, Sean Christopherson wrote:
> > > And snapshotting the VM-Exit time will get false negatives when the vCPU is about
> > > to run, but for whatever reason has kvm_last_guest_exit=0, e.g. if a vCPU was
> > > preempted and/or migrated to a different pCPU.
> > 
> > Right, for the use-case where waking up rcuc is a problem, the pCPU is
> > isolated (there are no userspace processes and hopefully no kernel threads
> > executing there), vCPU pinned to that pCPU.
> > 
> > So there should be no preemptions or migrations.
> 
> I understand that preemption/migration will not be problematic if the system is
> configured "correctly", but we still need to play nice with other scenarios and/or
> suboptimal setups.  While false positives aren't fatal, KVM still should do its
> best to avoid them, especially when it's relatively easy to do so.

Sure.

> > > My understanding is that RCU already has a timeout to avoid stalling RCU.  I don't
> > > see what is gained by effectively duplicating that timeout for KVM.
> > 
> > The point is not to avoid stalling RCU. The point is to not perform RCU
> > core processing through rcuc thread (because that interrupts execution
> > of the vCPU thread), if it is known that an extended quiescent state 
> > will occur "soon" anyway (via VM-entry).
> 
> I know.  My point is that, as you note below, RCU will wake-up rcuc after 1 second
> even if KVM is still reporting a VM-Enter is imminent, i.e. there's a 1 second
> timeout to avoid an RCU stall to due to KVM never completing entry to the guest.

Right.

So a reply to the sentence:

"My understanding is that RCU already has a timeout to avoid stalling RCU.  I don't
 see what is gained by effectively duplicating that timeout for KVM."

Is that the current RCU timeout is not functional for KVM VM entries,
therefore it needs modification.

> > If the extended quiescent state does not occur in 1 second, then rcuc
> > will be woken up (the time_before call in rcu_nohz_full_cpu function 
> > above).
> > 
> > > Why not have
> > > KVM provide a "this task is in KVM_RUN" flag, and then let the existing timeout
> > > handle the (hopefully rare) case where KVM doesn't "immediately" re-enter the guest?
> > 
> > Do you mean something like:
> > 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index d9642dd06c25..0ca5a6a45025 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -3938,7 +3938,7 @@ static int rcu_pending(int user)
> >                 return 1;
> >  
> >         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > +       if ((user || rcu_is_cpu_rrupt_from_idle() || this_cpu->in_kvm_run) && rcu_nohz_full_cpu())
> >                 return 0;
> 
> Yes.  This, https://lore.kernel.org/all/ZhAN28BcMsfl4gm-@google.com, plus logic
> in kvm_sched_{in,out}().

Question: where is vcpu->wants_to_run set? (or, where is the full series
again?).

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bfb2b52a1416..5a7efc669a0f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -209,6 +209,9 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu = get_cpu();
 
+	if (vcpu->wants_to_run)
+		context_tracking_guest_start_run_loop();
+
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
@@ -222,6 +225,10 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	__this_cpu_write(kvm_running_vcpu, NULL);
+
+	if (vcpu->wants_to_run)
+		context_tracking_guest_stop_run_loop();
+
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(vcpu_put);

A little worried about guest HLT:

/**
 * rcu_is_cpu_rrupt_from_idle - see if 'interrupted' from idle
 *
 * If the current CPU is idle and running at a first-level (not nested)
 * interrupt, or directly, from idle, return true.
 *
 * The caller must have at least disabled IRQs.
 */
static int rcu_is_cpu_rrupt_from_idle(void)
{
        long nesting;

        /*
         * Usually called from the tick; but also used from smp_function_call()
         * for expedited grace periods. This latter can result in running from
         * the idle task, instead of an actual IPI.
         */
	...

        /* Does CPU appear to be idle from an RCU standpoint? */
        return ct_dynticks_nesting() == 0;
}

static __always_inline void ct_cpuidle_enter(void)
{
        lockdep_assert_irqs_disabled();
        /*
         * Idle is allowed to (temporary) enable IRQs. It
         * will return with IRQs disabled.
         *
         * Trace IRQs enable here, then switch off RCU, and have
         * arch_cpu_idle() use raw_local_irq_enable(). Note that
         * ct_idle_enter() relies on lockdep IRQ state, so switch that
         * last -- this is very similar to the entry code.
         */
        trace_hardirqs_on_prepare();
        lockdep_hardirqs_on_prepare();
        instrumentation_end();
        ct_idle_enter();
        lockdep_hardirqs_on(_RET_IP_);
}

So for guest HLT emulation, there is a window between

kvm_vcpu_block -> fire_sched_out_preempt_notifiers -> vcpu_put 
and
the idle's task call to ct_cpuidle_enter, where 

ct_dynticks_nesting() != 0 and vcpu_put has already executed.

Even for idle=poll, the race exists.

> >         /* Is the RCU core waiting for a quiescent state from this CPU? */
> > 
> > The problem is:
> > 
> > 1) You should only set that flag, in the VM-entry path, after the point
> > where no use of RCU is made: close to guest_state_enter_irqoff call.
> 
> Why?  As established above, KVM essentially has 1 second to enter the guest after
> setting in_guest_run_loop (or whatever we call it).  In the vast majority of cases,
> the time before KVM enters the guest can probably be measured in microseconds.

OK.

> Snapshotting the exit time has the exact same problem of depending on KVM to
> re-enter the guest soon-ish, so I don't understand why this would be considered
> a problem with a flag to note the CPU is in KVM's run loop, but not with a
> snapshot to say the CPU recently exited a KVM guest.

See the race above.

> > 2) While handling a VM-exit, a host timer interrupt can occur before that,
> > or after the point where "this_cpu->in_kvm_run" is set to false.
> >
> > And a host timer interrupt calls rcu_sched_clock_irq which is going to
> > wake up rcuc.
> 
> If in_kvm_run is false when the IRQ is handled, then either KVM exited to userspace
> or the vCPU was scheduled out.  In the former case, rcuc won't be woken up if the
> CPU is in userspace.  And in the latter case, waking up rcuc is absolutely the
> correct thing to do as VM-Enter is not imminent.
> 
> For exits to userspace, there would be a small window where an IRQ could arrive
> between KVM putting the vCPU and the CPU actually returning to userspace, but
> unless that's problematic in practice, I think it's a reasonable tradeoff.

OK, your proposal looks alright except these races.

We don't want those races to occur in production (and they likely will).

Is there any way to fix the races? Perhaps cmpxchg? 



