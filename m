Return-Path: <kvm+bounces-16540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A29018BB505
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 22:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 585FB2816A2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B950233CF1;
	Fri,  3 May 2024 20:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1w+opTw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB362C190
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 20:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714769075; cv=none; b=e0IfBFqErzaUqvUQpF1dV+CFGHcVCtMKkaragtH6TpSJSaiGP7d4z1pZMr+RLI/f5h9rvlB0pGf+Vl1aVULc1cTHNggTZstT7T+5nhwS6uzKFRbi/QsYtane2JiO2Ut9CCo+jr88vK8JPuJKnxxpCAsLxLZr/QgTfC1jpyTi0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714769075; c=relaxed/simple;
	bh=JzRjkCX97QxPT+mb9uzryASAmrChjV0ADLlSGccLdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=AuYW6Gna+cKrZ81/xPpsNtJ3UzWmfEDm6Q1+bSjgn/otuZXXRV8rUNlLeZzz7YTylzB9vy47ZXaOqiQ7YqFKOcFzle7komrI5sw/J9rcjL+1GiOv33FQRmdjoh0OVhusi1OZnBGpdn6NdPFDdJRgl4/YwH5NDefS/HdfX6m0gIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1w+opTw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714769073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPCuy2UEuVN4pMmMZGfLyGZGFO30PUf2umTvt3R4wAg=;
	b=L1w+opTw9X4ZIIaAuFxArI0uxoCknaoFakUUhAZqZtJNtIFVNcuUMjqDveDmz/L1bDd99k
	OQin+I5lxP+qbx+L3zRKIMGA5Nhc9fdBbuUg5vc2u+VaNrxra61/Q2SU0UmtBiE7xMbMOQ
	8ILC9kCoLnp83eWPJtpMB+mxPeNMLCs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-OKDrUsOROEeY76462NLWuw-1; Fri, 03 May 2024 16:44:32 -0400
X-MC-Unique: OKDrUsOROEeY76462NLWuw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-78ee7776740so3892085a.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 13:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714769071; x=1715373871;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MPCuy2UEuVN4pMmMZGfLyGZGFO30PUf2umTvt3R4wAg=;
        b=ULWa2Cm+O4nxJrLo7INQuKZDiFcY6vMvElaB6UnhSO3Uvu9i0pfnB0u5nfoiGItH4i
         U/tjltDXC6kYVm5GAAzzD8cP40l3oaiL72CEGs85AMFucoud6Ie5FK2PdZWxKEdyfs7w
         A3Y9T0iw4P34gbkXyLzoYmFZpKYwDK5clDjcOmP+F2YniqspihaRlLNBmSlu3vSOViwJ
         +B56y+RG0xHxoVdT0VKfSEM9PaGjuB7KWzEXfDSOKJLcNhrVA+rJ1kmqRKdlWag/YmuM
         S4RDPqoouA7GNdrwoXhTmEYiT/ZeguxFj4x2YusUgcOdb3C68KPfJFnUsMoSKpL6RJOC
         4Uyw==
X-Forwarded-Encrypted: i=1; AJvYcCUN0pHW2S/XPas98Q5eN2dvoiX+h7IAqnaFjbtKJCtP7s9lUGhlnqW30b5EuuzbXeJXrlvM8GC8vznV9oC7TneWUZ+9
X-Gm-Message-State: AOJu0YwklADt9N3M0kFN6VoAxLbxXvpT8G7mlJoCtARimLIhb7CZ2fTn
	K9oMg7XVO5Z+Msl7+OOTKq8wu7oZYjUay/o7JV6PMIQK0+Nyn5AzHLm5xRvk8nWhGURle5e8XDQ
	FarOCdndmAM4KMR261qqlrmHGUcKlgKsvchFkB5zvUcfvvl7wzQ==
X-Received: by 2002:a05:620a:3713:b0:78f:405:95ea with SMTP id de19-20020a05620a371300b0078f040595eamr4007244qkb.20.1714769071453;
        Fri, 03 May 2024 13:44:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4AcQehl9JUPoSGXujIYRwTeelKr+7ueA7bjBtN6ZPAq3O3bweRVjLuqFV+C/OKibQLDOZyw==
X-Received: by 2002:a05:620a:3713:b0:78f:405:95ea with SMTP id de19-20020a05620a371300b0078f040595eamr4007202qkb.20.1714769070805;
        Fri, 03 May 2024 13:44:30 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:4b0a:b7a4:5eb9:b8a9:508d])
        by smtp.gmail.com with ESMTPSA id vq17-20020a05620a559100b0078ec8690764sm1532578qkn.87.2024.05.03.13.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 13:44:30 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
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
	Zqiang <qiang.zhang1211@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Fri,  3 May 2024 17:44:22 -0300
Message-ID: <ZjVMpj7zcSf-JYd_@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <ZiAFSlZwxyKzOTRL@google.com>
References: <ZhAAg8KNd8qHEGcO@tpad> <ZhAN28BcMsfl4gm-@google.com> <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop> <ZhQmaEXPCqmx1rTW@google.com> <Zh2EQVj5bC0z5R90@tpad> <Zh2cPJ-5xh72ojzu@google.com> <Zh5w6rAWL+08a5lj@tpad> <Zh6GC0NRonCpzpV4@google.com> <Zh/1U8MtPWQ/yN2T@tpad> <ZiAFSlZwxyKzOTRL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 17, 2024 at 10:22:18AM -0700, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Marcelo Tosatti wrote:
> > On Tue, Apr 16, 2024 at 07:07:32AM -0700, Sean Christopherson wrote:
> > > On Tue, Apr 16, 2024, Marcelo Tosatti wrote:
> > > > > Why not have
> > > > > KVM provide a "this task is in KVM_RUN" flag, and then let the existing timeout
> > > > > handle the (hopefully rare) case where KVM doesn't "immediately" re-enter the guest?
> > > > 
> > > > Do you mean something like:
> > > > 
> > > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > > index d9642dd06c25..0ca5a6a45025 100644
> > > > --- a/kernel/rcu/tree.c
> > > > +++ b/kernel/rcu/tree.c
> > > > @@ -3938,7 +3938,7 @@ static int rcu_pending(int user)
> > > >                 return 1;
> > > >  
> > > >         /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > > > -       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > > > +       if ((user || rcu_is_cpu_rrupt_from_idle() || this_cpu->in_kvm_run) && rcu_nohz_full_cpu())
> > > >                 return 0;
> > > 
> > > Yes.  This, https://lore.kernel.org/all/ZhAN28BcMsfl4gm-@google.com, plus logic
> > > in kvm_sched_{in,out}().
> > 
> > Question: where is vcpu->wants_to_run set? (or, where is the full series
> > again?).
> 
> Precisely around the call to kvm_arch_vcpu_ioctl_run().  I am planning on applying
> the patch that introduces the code for 6.10[*], I just haven't yet for a variety
> of reasons.
> 
> [*] https://lore.kernel.org/all/20240307163541.92138-1-dmatlack@google.com
> 
> > So for guest HLT emulation, there is a window between
> > 
> > kvm_vcpu_block -> fire_sched_out_preempt_notifiers -> vcpu_put 
> > and the idle's task call to ct_cpuidle_enter, where 
> > 
> > ct_dynticks_nesting() != 0 and vcpu_put has already executed.
> > 
> > Even for idle=poll, the race exists.
> 
> Is waking rcuc actually problematic?

Yeah, it may introduce a lot (30us) of latency in some cases, causing a 
missed deadline.

When dealing with RT tasks, missing a deadline can be really bad, so we 
need to make sure it will happen as rarely as possible.

>  I agree it's not ideal, but it's a smallish
> window, i.e. is unlikely to happen frequently, and if rcuc is awakened, it will
> effectively steal cycles from the idle thread, not the vCPU thread.

It would be fine, but sometimes the idle thread will run very briefly, and 
stealing microseconds from it will still steal enough time from the vcpu 
thread to become a problem.

>  If the vCPU
> gets a wake event before rcuc completes, then the vCPU could experience jitter,
> but that could also happen if the CPU ends up in a deep C-state.

IIUC, if the scenario calls for a very short HLT, which is kind of usual, 
then the CPU will not get into deep C-state. 
For the scenarios longer HLT happens, then it would be fine.

> 
> And that race exists in general, i.e. any IRQ that arrives just as the idle task
> is being scheduled in will unnecessarily wakeup rcuc.

That's a race could be solved with the timeout (snapshot) solution, if we 
don't zero last_guest_exit on kvm_sched_out(), right?

> 
> > > >         /* Is the RCU core waiting for a quiescent state from this CPU? */
> > > > 
> > > > The problem is:
> > > > 
> > > > 1) You should only set that flag, in the VM-entry path, after the point
> > > > where no use of RCU is made: close to guest_state_enter_irqoff call.
> > > 
> > > Why?  As established above, KVM essentially has 1 second to enter the guest after
> > > setting in_guest_run_loop (or whatever we call it).  In the vast majority of cases,
> > > the time before KVM enters the guest can probably be measured in microseconds.
> > 
> > OK.
> > 
> > > Snapshotting the exit time has the exact same problem of depending on KVM to
> > > re-enter the guest soon-ish, so I don't understand why this would be considered
> > > a problem with a flag to note the CPU is in KVM's run loop, but not with a
> > > snapshot to say the CPU recently exited a KVM guest.
> > 
> > See the race above.
> 
> Ya, but if kvm_last_guest_exit is zeroed in kvm_sched_out(), then the snapshot
> approach ends up with the same race.  And not zeroing kvm_last_guest_exit is
> arguably much more problematic as encountering a false positive doesn't require
> hitting a small window.

For the false positive (only on nohz_full) the maximum delay for the  
rcu_core() to be run would be 1s, and that would be in case we don't schedule out for 
some userspace task or idle thread, in which case we have a quiescent state 
without the need of rcu_core().

Now, for not being an userspace nor idle thread, it would need to be one or 
more kernel threads, which I suppose aren't usually many, nor usually 
take that long for completing, if we consider to be running on an isolated (nohz_full) cpu. 

So, for the kvm_sched_out() case, I don't actually think we are  
statistically introducing that much of a delay in the RCU mechanism.

(I may be missing some point, though)

Thanks!
Leo

> 
> > > > 2) While handling a VM-exit, a host timer interrupt can occur before that,
> > > > or after the point where "this_cpu->in_kvm_run" is set to false.
> > > >
> > > > And a host timer interrupt calls rcu_sched_clock_irq which is going to
> > > > wake up rcuc.
> > > 
> > > If in_kvm_run is false when the IRQ is handled, then either KVM exited to userspace
> > > or the vCPU was scheduled out.  In the former case, rcuc won't be woken up if the
> > > CPU is in userspace.  And in the latter case, waking up rcuc is absolutely the
> > > correct thing to do as VM-Enter is not imminent.
> > > 
> > > For exits to userspace, there would be a small window where an IRQ could arrive
> > > between KVM putting the vCPU and the CPU actually returning to userspace, but
> > > unless that's problematic in practice, I think it's a reasonable tradeoff.
> > 
> > OK, your proposal looks alright except these races.
> > 
> > We don't want those races to occur in production (and they likely will).
> > 
> > Is there any way to fix the races? Perhaps cmpxchg?
> 
> I don't think an atomic switch from the vCPU task to the idle task is feasible,
> e.g. KVM would somehow have to know that the idle task is going to run next.
> This seems like something that needs a generic solution, e.g. to prevent waking
> rcuc if the idle task is in the process of being scheduled in.
> 


