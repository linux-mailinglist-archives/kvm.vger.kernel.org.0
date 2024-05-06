Return-Path: <kvm+bounces-16764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF798BD4DA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B0291F21FAE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F6B158D8B;
	Mon,  6 May 2024 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPM15xWb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13DD8494
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715021329; cv=none; b=IaUtFRnsM6O+pu9AfI/NZkzsTnYhaVKjxoji5+Jg1EAg1TpICZ4c8hd4TnsD0fBcLs4qTR35joqqZu1slLwjyp373fRec3JEsWFmOTq9n88YeuIroil2V0x+KYnlw41gkJT8ugGHMjuy9qZuepPRYn9Tt+/8JlVyAZPzgQhxo/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715021329; c=relaxed/simple;
	bh=DdMY60eWYf7nFd2XjhGOmHWtIFWpG2Vu5/5hhugXBZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgcFZLq5B+QXLFZfHJD7xL0Alv3fPWJpy3/U0vwIAc10AtxypzukGiek+7sT61mQpzCXM4x5/rpoG5/nhCCG7E26P3QfZJY/OLBx7MoePGiqGSCbat4mYV2yTNP4AouXPqpKuh3QY4xb/FLZOVbEpWk7K5tvKnJ4s/azaxFFH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPM15xWb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715021326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aPOamX9LHTG5t3ZSBhvmzpDMv+bOSB81pKuh6fPgknw=;
	b=YPM15xWbogDpgXPfE+nJG2wWiSLPr1T6vOalmLBIvuNWTrjEzXv23ggcrZc1YaezJec1ZX
	y2tFxTdsUvEhEgzTntizr2o3oAMOVF3LkFeFUYpq59Bkrs09xIawtAISaDylnpbAU/u+OR
	owum3zy1Z6HML3BA29mlYMmHFXwr8Dc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-JxgjRRKQNJC9G07zoB7YFg-1; Mon, 06 May 2024 14:48:43 -0400
X-MC-Unique: JxgjRRKQNJC9G07zoB7YFg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 077BB8032FA;
	Mon,  6 May 2024 18:48:43 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F3D42024513;
	Mon,  6 May 2024 18:48:42 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 0AFB1400DCBB9; Mon,  6 May 2024 15:47:21 -0300 (-03)
Date: Mon, 6 May 2024 15:47:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <ZjkludR5wh0mKZ2H@tpad>
References: <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <Zh2EQVj5bC0z5R90@tpad>
 <Zh2cPJ-5xh72ojzu@google.com>
 <Zh5w6rAWL+08a5lj@tpad>
 <Zh6GC0NRonCpzpV4@google.com>
 <Zh/1U8MtPWQ/yN2T@tpad>
 <ZiAFSlZwxyKzOTRL@google.com>
 <ZjVMpj7zcSf-JYd_@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjVMpj7zcSf-JYd_@LeoBras>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, May 03, 2024 at 05:44:22PM -0300, Leonardo Bras wrote:
> On Wed, Apr 17, 2024 at 10:22:18AM -0700, Sean Christopherson wrote:
> > On Wed, Apr 17, 2024, Marcelo Tosatti wrote:
> > > On Tue, Apr 16, 2024 at 07:07:32AM -0700, Sean Christopherson wrote:
> > > > On Tue, Apr 16, 2024, Marcelo Tosatti wrote:
> > > > > > Why not have
> > > > > > KVM provide a "this task is in KVM_RUN" flag, and then let the existing timeout
> > > > > > handle the (hopefully rare) case where KVM doesn't "immediately" re-enter the guest?
> > > > > 
> > > > > Do you mean something like:
> > > > > 
> > > > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > > > index d9642dd06c25..0ca5a6a45025 100644
> > > > > --- a/kernel/rcu/tree.c
> > > > > +++ b/kernel/rcu/tree.c
> > > > > @@ -3938,7 +3938,7 @@ static int rcu_pending(int user)
> > > > >                 return 1;
> > > > >  
> > > > >         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > > > > -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > > > > +       if ((user || rcu_is_cpu_rrupt_from_idle() || this_cpu->in_kvm_run) && rcu_nohz_full_cpu())
> > > > >                 return 0;
> > > > 
> > > > Yes.  This, https://lore.kernel.org/all/ZhAN28BcMsfl4gm-@google.com, plus logic
> > > > in kvm_sched_{in,out}().
> > > 
> > > Question: where is vcpu->wants_to_run set? (or, where is the full series
> > > again?).
> > 
> > Precisely around the call to kvm_arch_vcpu_ioctl_run().  I am planning on applying
> > the patch that introduces the code for 6.10[*], I just haven't yet for a variety
> > of reasons.
> > 
> > [*] https://lore.kernel.org/all/20240307163541.92138-1-dmatlack@google.com
> > 
> > > So for guest HLT emulation, there is a window between
> > > 
> > > kvm_vcpu_block -> fire_sched_out_preempt_notifiers -> vcpu_put 
> > > and the idle's task call to ct_cpuidle_enter, where 
> > > 
> > > ct_dynticks_nesting() != 0 and vcpu_put has already executed.
> > > 
> > > Even for idle=poll, the race exists.
> > 
> > Is waking rcuc actually problematic?
> 
> Yeah, it may introduce a lot (30us) of latency in some cases, causing a 
> missed deadline.
> 
> When dealing with RT tasks, missing a deadline can be really bad, so we 
> need to make sure it will happen as rarely as possible.
> 
> >  I agree it's not ideal, but it's a smallish
> > window, i.e. is unlikely to happen frequently, and if rcuc is awakened, it will
> > effectively steal cycles from the idle thread, not the vCPU thread.
> 
> It would be fine, but sometimes the idle thread will run very briefly, and 
> stealing microseconds from it will still steal enough time from the vcpu 
> thread to become a problem.
> 
> >  If the vCPU
> > gets a wake event before rcuc completes, then the vCPU could experience jitter,
> > but that could also happen if the CPU ends up in a deep C-state.
> 
> IIUC, if the scenario calls for a very short HLT, which is kind of usual, 
> then the CPU will not get into deep C-state. 
> For the scenarios longer HLT happens, then it would be fine.

And it might be that the chosen idle state has low latency.

There is interest from customer in using realtime and saving energy as
well.

For example:

https://doc.dpdk.org/guides/sample_app_ug/l3_forward_power_man.html

> > And that race exists in general, i.e. any IRQ that arrives just as the idle task
> > is being scheduled in will unnecessarily wakeup rcuc.
> 
> That's a race could be solved with the timeout (snapshot) solution, if we 
> don't zero last_guest_exit on kvm_sched_out(), right?

Yes.

> > > > >         /* Is the RCU core waiting for a quiescent state from this CPU? */
> > > > > 
> > > > > The problem is:
> > > > > 
> > > > > 1) You should only set that flag, in the VM-entry path, after the point
> > > > > where no use of RCU is made: close to guest_state_enter_irqoff call.
> > > > 
> > > > Why?  As established above, KVM essentially has 1 second to enter the guest after
> > > > setting in_guest_run_loop (or whatever we call it).  In the vast majority of cases,
> > > > the time before KVM enters the guest can probably be measured in microseconds.
> > > 
> > > OK.
> > > 
> > > > Snapshotting the exit time has the exact same problem of depending on KVM to
> > > > re-enter the guest soon-ish, so I don't understand why this would be considered
> > > > a problem with a flag to note the CPU is in KVM's run loop, but not with a
> > > > snapshot to say the CPU recently exited a KVM guest.
> > > 
> > > See the race above.
> > 
> > Ya, but if kvm_last_guest_exit is zeroed in kvm_sched_out(), then the snapshot
> > approach ends up with the same race.  And not zeroing kvm_last_guest_exit is
> > arguably much more problematic as encountering a false positive doesn't require
> > hitting a small window.
> 
> For the false positive (only on nohz_full) the maximum delay for the  
> rcu_core() to be run would be 1s, and that would be in case we don't schedule out for 
> some userspace task or idle thread, in which case we have a quiescent state 
> without the need of rcu_core().
> 
> Now, for not being an userspace nor idle thread, it would need to be one or 
> more kernel threads, which I suppose aren't usually many, nor usually 
> take that long for completing, if we consider to be running on an isolated (nohz_full) cpu. 
> 
> So, for the kvm_sched_out() case, I don't actually think we are  
> statistically introducing that much of a delay in the RCU mechanism.
> 
> (I may be missing some point, though)
> 
> Thanks!
> Leo
> 
> > 
> > > > > 2) While handling a VM-exit, a host timer interrupt can occur before that,
> > > > > or after the point where "this_cpu->in_kvm_run" is set to false.
> > > > >
> > > > > And a host timer interrupt calls rcu_sched_clock_irq which is going to
> > > > > wake up rcuc.
> > > > 
> > > > If in_kvm_run is false when the IRQ is handled, then either KVM exited to userspace
> > > > or the vCPU was scheduled out.  In the former case, rcuc won't be woken up if the
> > > > CPU is in userspace.  And in the latter case, waking up rcuc is absolutely the
> > > > correct thing to do as VM-Enter is not imminent.
> > > > 
> > > > For exits to userspace, there would be a small window where an IRQ could arrive
> > > > between KVM putting the vCPU and the CPU actually returning to userspace, but
> > > > unless that's problematic in practice, I think it's a reasonable tradeoff.
> > > 
> > > OK, your proposal looks alright except these races.
> > > 
> > > We don't want those races to occur in production (and they likely will).
> > > 
> > > Is there any way to fix the races? Perhaps cmpxchg?
> > 
> > I don't think an atomic switch from the vCPU task to the idle task is feasible,
> > e.g. KVM would somehow have to know that the idle task is going to run next.
> > This seems like something that needs a generic solution, e.g. to prevent waking
> > rcuc if the idle task is in the process of being scheduled in.
> > 
> 
> 


