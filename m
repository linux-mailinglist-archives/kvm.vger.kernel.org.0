Return-Path: <kvm+bounces-14762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA2D8A6B33
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2813B210AC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D602112A16E;
	Tue, 16 Apr 2024 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtlcNlSu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3F71804A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 12:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271048; cv=none; b=S4px3dP3odM/yhpMV7MKXgaVuJCyi7Iui3RWUlYn7CebRYda49B8V3jNiZcriqW2uj0eCPbi0D/+h3HvbV0lbIojvqpQ7pPZPGkzcSJpztKEUP7CBZGBqUDVqBQd/rfsxvKRwzxoFVjM65/LC1PCh5J0v4W+Sj8oYp20llqRQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271048; c=relaxed/simple;
	bh=ekVxjPvBZVT4t7cOXasmQhQ9V9xKqVBbv4JjdxDpiuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1FrIHPZuQwefFtThIDZUC0SPdsBaqLSEZPgTDyQgJ6Wo1y+HR50JgnnsSFpGtMiq0iLZMH3mCQuM72auK2tXstCzupfN8HxSYIKA8ADuMGmp9Udk29Erqd8W92yJo6qPdPrGU+zHuGZVAfYfhrvlkpNc215QY2PPlolv1AWADo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtlcNlSu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713271045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YEPZpegKIfFunNWQiBPq4cn9O4X8BwktfnZ/+S4ey9o=;
	b=gtlcNlSuoTmdWMFU8mqzAB3I06/RVV42CwXeWMgvqqaJdKN6PTqhhGzXJcwXKWeUrYlHem
	NpyeIE+FLYrmYi6TctvwK4UEjdYLekyFAU0AGE+6VjsNcTjQStD5ok/FNvxC9I0R0zmCgd
	QwZ8tXjokrDV75XJviYk1MsPmu/2hzo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-hlrPcNl7PLGsBLO_PWYimg-1; Tue, 16 Apr 2024 08:37:21 -0400
X-MC-Unique: hlrPcNl7PLGsBLO_PWYimg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6B81801787;
	Tue, 16 Apr 2024 12:37:20 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1B651121306;
	Tue, 16 Apr 2024 12:37:19 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 0F71440552114; Tue, 16 Apr 2024 09:36:58 -0300 (-03)
Date: Tue, 16 Apr 2024 09:36:58 -0300
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
Message-ID: <Zh5w6rAWL+08a5lj@tpad>
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <Zh2EQVj5bC0z5R90@tpad>
 <Zh2cPJ-5xh72ojzu@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh2cPJ-5xh72ojzu@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Apr 15, 2024 at 02:29:32PM -0700, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Marcelo Tosatti wrote:
> > On Mon, Apr 08, 2024 at 10:16:24AM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 05, 2024, Paul E. McKenney wrote:
> > > > Beyond a certain point, we have no choice.  How long should RCU let
> > > > a CPU run with preemption disabled before complaining?  We choose 21
> > > > seconds in mainline and some distros choose 60 seconds.  Android chooses
> > > > 20 milliseconds for synchronize_rcu_expedited() grace periods.
> > > 
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
> > Hi Sean,
> > 
> > So this should deal with it? (untested, don't apply...).
> 
> Not entirely.  As I belatedly noted, hooking vcpu_put() doesn't handle the case
> where the vCPU is preempted, i.e. kvm_sched_out() would also need to zero out
> kvm_last_guest_exit to avoid a false positive. 

True. Can fix that.

> Going through the scheduler will
> note the CPU is quiescent for the current grace period, but after that RCU will
> still see a non-zero kvm_last_guest_exit even though the vCPU task isn't actively
> running.

Right, can fix kvm_sched_out().

> And snapshotting the VM-Exit time will get false negatives when the vCPU is about
> to run, but for whatever reason has kvm_last_guest_exit=0, e.g. if a vCPU was
> preempted and/or migrated to a different pCPU.

Right, for the use-case where waking up rcuc is a problem, the pCPU is
isolated (there are no userspace processes and hopefully no kernel threads
executing there), vCPU pinned to that pCPU.

So there should be no preemptions or migrations.

> I don't understand the motivation for keeping the kvm_last_guest_exit logic.

The motivation is to _avoid_ waking up rcuc to perform RCU core
processing, in case the vCPU runs on a nohz full CPU, since
entering the VM is an extended quiescent state.

The logic for userspace/idle extended quiescent states is:

This is called from the sched clock interrupt.

/*
 * This function is invoked from each scheduling-clock interrupt,
 * and checks to see if this CPU is in a non-context-switch quiescent
 * state, for example, user mode or idle loop.  It also schedules RCU
 * core processing.  If the current grace period has gone on too long,
 * it will ask the scheduler to manufacture a context switch for the sole
 * purpose of providing the needed quiescent state.
 */
void rcu_sched_clock_irq(int user)
{
...
        if (rcu_pending(user))
                invoke_rcu_core();
...
}

And, from rcu_pending:

        /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
        if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
                return 0;

/*
 * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
 * grace-period kthread will do force_quiescent_state() processing?
 * The idea is to avoid waking up RCU core processing on such a
 * CPU unless the grace period has extended for too long.
 *
 * This code relies on the fact that all NO_HZ_FULL CPUs are also
 * RCU_NOCB_CPU CPUs.
 */
static bool rcu_nohz_full_cpu(void)
{
#ifdef CONFIG_NO_HZ_FULL
        if (tick_nohz_full_cpu(smp_processor_id()) &&
            (!rcu_gp_in_progress() ||
             time_before(jiffies, READ_ONCE(rcu_state.gp_start) + HZ)))
                return true;
#endif /* #ifdef CONFIG_NO_HZ_FULL */
        return false;
}

Does that make sense?

> My understanding is that RCU already has a timeout to avoid stalling RCU.  I don't
> see what is gained by effectively duplicating that timeout for KVM.

The point is not to avoid stalling RCU. The point is to not perform RCU
core processing through rcuc thread (because that interrupts execution
of the vCPU thread), if it is known that an extended quiescent state 
will occur "soon" anyway (via VM-entry).

If the extended quiescent state does not occur in 1 second, then rcuc
will be woken up (the time_before call in rcu_nohz_full_cpu function 
above).

> Why not have
> KVM provide a "this task is in KVM_RUN" flag, and then let the existing timeout
> handle the (hopefully rare) case where KVM doesn't "immediately" re-enter the guest?

Do you mean something like:

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d9642dd06c25..0ca5a6a45025 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3938,7 +3938,7 @@ static int rcu_pending(int user)
                return 1;
 
        /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
-       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
+       if ((user || rcu_is_cpu_rrupt_from_idle() || this_cpu->in_kvm_run) && rcu_nohz_full_cpu())
                return 0;
 
        /* Is the RCU core waiting for a quiescent state from this CPU? */

The problem is:

1) You should only set that flag, in the VM-entry path, after the point
where no use of RCU is made: close to guest_state_enter_irqoff call.

2) While handling a VM-exit, a host timer interrupt can occur before that,
or after the point where "this_cpu->in_kvm_run" is set to false.

And a host timer interrupt calls rcu_sched_clock_irq which is going to
wake up rcuc.

Or am i missing something?

Thanks.

> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 48f31dcd318a..be90d83d631a 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -477,6 +477,16 @@ static __always_inline void guest_state_enter_irqoff(void)
> >  	lockdep_hardirqs_on(CALLER_ADDR0);
> >  }
> >  
> > +DECLARE_PER_CPU(unsigned long, kvm_last_guest_exit);
> > +
> > +/*
> > + * Returns time (jiffies) for the last guest exit in current cpu
> > + */
> > +static inline unsigned long guest_exit_last_time(void)
> > +{
> > +	return this_cpu_read(kvm_last_guest_exit);
> > +}
> > +
> >  /*
> >   * Exit guest context and exit an RCU extended quiescent state.
> >   *
> > @@ -488,6 +498,9 @@ static __always_inline void guest_state_enter_irqoff(void)
> >  static __always_inline void guest_context_exit_irqoff(void)
> >  {
> >  	context_tracking_guest_exit();
> > +
> > +	/* Keeps track of last guest exit */
> > +	this_cpu_write(kvm_last_guest_exit, jiffies);
> >  }
> >  
> >  /*
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fb49c2a60200..231d0e4d2cf1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -110,6 +110,9 @@ static struct kmem_cache *kvm_vcpu_cache;
> >  static __read_mostly struct preempt_ops kvm_preempt_ops;
> >  static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
> >  
> > +DEFINE_PER_CPU(unsigned long, kvm_last_guest_exit);
> > +EXPORT_SYMBOL_GPL(kvm_last_guest_exit);
> > +
> >  struct dentry *kvm_debugfs_dir;
> >  EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
> >  
> > @@ -210,6 +213,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
> >  	int cpu = get_cpu();
> >  
> >  	__this_cpu_write(kvm_running_vcpu, vcpu);
> > +	__this_cpu_write(kvm_last_guest_exit, 0);
> >  	preempt_notifier_register(&vcpu->preempt_notifier);
> >  	kvm_arch_vcpu_load(vcpu, cpu);
> >  	put_cpu();
> > @@ -222,6 +226,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
> >  	kvm_arch_vcpu_put(vcpu);
> >  	preempt_notifier_unregister(&vcpu->preempt_notifier);
> >  	__this_cpu_write(kvm_running_vcpu, NULL);
> > +	__this_cpu_write(kvm_last_guest_exit, 0);
> >  	preempt_enable();
> >  }
> >  EXPORT_SYMBOL_GPL(vcpu_put);
> > 
> 
> 


