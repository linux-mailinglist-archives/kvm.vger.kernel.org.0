Return-Path: <kvm+bounces-13920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6140589CDE5
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9789DB21DAC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 21:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7E114A0A0;
	Mon,  8 Apr 2024 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KjlAgZE3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293B149DEF
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712613393; cv=none; b=ZtYBRUdd/zOWLRWfz+FoNfLFjB4N1SRLJB9AoeF+eNwXhnpFAMvpq62RH8+FC0Xrv/92PescggVU4uJhiFt+GtbNM5A7t73IQkQcOf+cn9o0m+6gpWFLglK96e5gVz74SLFxapv6wHG01LtJ7UykrJX08ONudwG2zD2tC1MJnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712613393; c=relaxed/simple;
	bh=KMgMj5SuCHh7Ha85uQVvUmDrUucgoYhw/hHwBlpvQbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jUx5vnVdkKvXKTqyCqEMCyYkN4PQv7NUszh4iqj0A4gOaXBdqelW11svbuYEspf13O18zhatlnUEoq8XFi+f8p14hlD/ytHv68Mo8lhhz1fN5VW1I+L59PqprD37QMKGaMe25TOOy32VE9fphdb4X6SHcPywhE9/ANiVIoixIwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KjlAgZE3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6ceade361so8069702276.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 14:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712613391; x=1713218191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0+YtI06tP7BJVW9G+3zSEn/HDI9HVvJWqFii9XPCuXU=;
        b=KjlAgZE3nlz98x0q293PDPdRhk+5X5FEXRErDY3u7gM43ADQ/PrutCwp5eZioqhPWy
         h6k04WR84E+XdEpDKttS2IabfF6FqTWsZN9OU0uY0tSDUjv40UDMuVNi/0N0hZJf3ORt
         ag9HbWcuCI1ey5sl4jSrgcBusSM7snMLAZVLxYFimTmyAMJityePZwtdWOfGQ96MsymH
         X/3hykJ/yE89A2G7XGt5onu6nDtLkz13oraQPqUZ6KGSp5bGS6UztbLBrcQh5/e80pBc
         h7muRYDazcBlqdIFnBVppQad/bCTceGFJ08oCTSuJMicu/vWT2HNqC62Qnl626Yd+NEK
         nZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712613391; x=1713218191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0+YtI06tP7BJVW9G+3zSEn/HDI9HVvJWqFii9XPCuXU=;
        b=BN8yXpIlDNO3tL4bdIQ/cbAj7xbVONpd95H+IsiUxI2FEb5yPulp932utVI9mCPKhC
         Z14YiQ8tiL/q9JsODcr895zj5dSmVRpKmybq505lxsfLEyHe6wQJ4JPl9G1hAkx0U3E8
         OarIr+pLgRkqEiTlzD9NWg9cXBdDgbX3PPLPwVAU/jwpxe96UtgwLB4VyIF9vAToinso
         bpbVpGdRXr6YGO3FbEeMsrg9/mE0IQwF4yw9RFDDgf4gL2jVR7EL3niTroOMmUqmJqCm
         7+onvT3pDtsMs6gTmSemAsSo/ugcyVHc5RnAz72SHN/sCeUf3mZ5/fJtFta3O7aW2yEn
         yOXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkzwB0LbHfsaOLonZGezHgXzBvWvDUwWUOqh9DWZ2c8sH7byBvjJAoXfYxxiMltwB1AN94KFTZa1mSYak5i0hb6U9h
X-Gm-Message-State: AOJu0Yzso1suDqpyz6euXigrBj+hx7cD/wD6/OscBfXzk0yE+wZkP0KL
	Cy5IRUyQ28bp7M+UEfD6QiB9vzPZ04SNxxL0aUbYAdziF50bZXrhQt66xusItijKLAW/ghHpcnt
	0Og==
X-Google-Smtp-Source: AGHT+IFa/2P8Cih2UGweMY65SGXpak6RdHKhKQJP1InxT1VYZjJvdFlyLiwBH6E9kuck3BIMa7OXlmY5chc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188e:b0:dc2:550b:a4f4 with SMTP id
 cj14-20020a056902188e00b00dc2550ba4f4mr3047423ybb.1.1712613391167; Mon, 08
 Apr 2024 14:56:31 -0700 (PDT)
Date: Mon, 8 Apr 2024 14:56:29 -0700
In-Reply-To: <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad> <ZhAN28BcMsfl4gm-@google.com> <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com> <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
 <ZhROKK9dEPsNnH4t@google.com> <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
Message-ID: <ZhRoDfoz-YqsGhIB@google.com>
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
> On Mon, Apr 08, 2024 at 01:06:00PM -0700, Sean Christopherson wrote:
> > On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> > > > > > +	if (vcpu->wants_to_run)
> > > > > > +		context_tracking_guest_start_run_loop();
> > > > > 
> > > > > At this point, if this is a nohz_full CPU, it will no longer report
> > > > > quiescent states until the grace period is at least one second old.
> > > > 
> > > > I don't think I follow the "will no longer report quiescent states" issue.  Are
> > > > you saying that this would prevent guest_context_enter_irqoff() from reporting
> > > > that the CPU is entering a quiescent state?  If so, that's an issue that would
> > > > need to be resolved regardless of what heuristic we use to determine whether or
> > > > not a CPU is likely to enter a KVM guest.
> > > 
> > > Please allow me to start over.  Are interrupts disabled at this point,
> > 
> > Nope, IRQs are enabled.
> > 
> > Oof, I'm glad you asked, because I was going to say that there's one exception,
> > kvm_sched_in(), which is KVM's notifier for when a preempted task/vCPU is scheduled
> > back in.  But I forgot that kvm_sched_{in,out}() don't use vcpu_{load,put}(),
> > i.e. would need explicit calls to context_tracking_guest_{stop,start}_run_loop().
> > 
> > > and, if so, will they remain disabled until the transfer of control to
> > > the guest has become visible to RCU via the context-tracking code?
> > > 
> > > Or has the context-tracking code already made the transfer of control
> > > to the guest visible to RCU?
> > 
> > Nope.  The call to __ct_user_enter(CONTEXT_GUEST) or rcu_virt_note_context_switch()
> > happens later, just before the actual VM-Enter.  And that call does happen with
> > IRQs disabled (and IRQs stay disabled until the CPU enters the guest).
> 
> OK, then we can have difficulties with long-running interrupts hitting
> this range of code.  It is unfortunately not unheard-of for interrupts
> plus trailing softirqs to run for tens of seconds, even minutes.

Ah, and if that occurs, *and* KVM is slow to re-enter the guest, then there will
be a massive lag before the CPU gets back into a quiescent state.

> One counter-argument is that that softirq would take scheduling-clock
> interrupts, and would eventually make rcu_core() run.

Considering that this behavior would be unique to nohz_full CPUs, how much
responsibility does RCU have to ensure a sane setup?  E.g. if a softirq runs for
multiple seconds on a nohz_full CPU whose primary role is to run a KVM vCPU, then
whatever real-time workaround the vCPU is running is already doomed.

> But does a rcu_sched_clock_irq() from a guest OS have its "user"
> argument set?

No, and it shouldn't, at least not on x86 (I assume other architectures are
similar, but I don't actually no for sure).

On x86, the IRQ that the kernel sees comes looks like it comes from host kernel
code.  And on AMD (SVM), the IRQ doesn't just "look" like it came from host kernel,
the IRQ really does get vectored/handled in the host kernel.  Intel CPUs have a
performance optimization where the IRQ gets "eaten" as part of the VM-Exit, and
so KVM synthesizes a stack frame and does a manual CALL to invoke the IRQ handler.

And that's just for IRQs that actually arrive while the guest is running.  IRQs
arrive while KVM is active, e.g. running its large vcpu_run(), are "pure" host
IRQs.

