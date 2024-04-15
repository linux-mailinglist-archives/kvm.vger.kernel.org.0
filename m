Return-Path: <kvm+bounces-14693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D67A48A5BF4
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05C6B1C20BBF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 20:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DC0156661;
	Mon, 15 Apr 2024 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mns1Lm9i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B775C15625E
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 20:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211454; cv=none; b=tksghX9EtW15lM8NJV1p+Z4y/2BpguNowVRBIqY4vqJ1ibSCPgYxOiAxqa3cUwxlZIGTnV0tm/iCrWCJkONZH8Ah7riK95ftK7e4GyaHbG7kI9tyYT5T+dWqwJtmf1JyhsJSm/dxIDonUDqTLCx4rzrOzrXDmuycA5CDO5t/qX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211454; c=relaxed/simple;
	bh=pr/4/oQR+r5R/l6P0ikxCsCgBmbd6uWclml/OEa3wn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQnaCVqxY4bc/OLivRlFcY+hNKKBs6WoInwav8ZdwgplbEAXgysGNbCqeyQ3ifXrr43p2KEKGhtg78swufv9BmeG/0dd/en5ysINKeG6APlBghlTJUdoelVrBj4eREAwU4Qv8tZP7hOszrUSbep+POG8F6njBnAUnsm2c0JYhbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mns1Lm9i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713211451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfn+y1J1zY2Ja72aghi8awXYV9tGOwVsfBqRShbrfOE=;
	b=Mns1Lm9iuFun3dNkBuh4PsOovncshW5270759zi3R3U3ehyHA7+kifQ9kim6RjoLCx7AvO
	3U7syyzctw7tkSzLkxu1Bn/Q3g2FcA6BxcCLZqz5piCd0xMyRVJJ3TmpokP8I/zhWpoxc9
	l5Vu4U9yBYCW49LAPf5f/eOJGlhef7Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-9efXX8AHOMmW2BIjYR2LjQ-1; Mon,
 15 Apr 2024 16:04:07 -0400
X-MC-Unique: 9efXX8AHOMmW2BIjYR2LjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 764111C0513D;
	Mon, 15 Apr 2024 20:04:06 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1312166B32;
	Mon, 15 Apr 2024 20:04:05 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id BFE67401801CE; Mon, 15 Apr 2024 16:47:13 -0300 (-03)
Date: Mon, 15 Apr 2024 16:47:13 -0300
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
Message-ID: <Zh2EQVj5bC0z5R90@tpad>
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhQmaEXPCqmx1rTW@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, Apr 08, 2024 at 10:16:24AM -0700, Sean Christopherson wrote:
> On Fri, Apr 05, 2024, Paul E. McKenney wrote:
> > On Fri, Apr 05, 2024 at 07:42:35AM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 05, 2024, Marcelo Tosatti wrote:
> > > > rcuc wakes up (which might exceed the allowed latency threshold
> > > > for certain realtime apps).
> > > 
> > > Isn't that a false negative? (RCU doesn't detect that a CPU is about to (re)enter
> > > a guest)  I was trying to ask about the case where RCU thinks a CPU is about to
> > > enter a guest, but the CPU never does (at least, not in the immediate future).
> > > 
> > > Or am I just not understanding how RCU's kthreads work?
> > 
> > It is quite possible that the current rcu_pending() code needs help,
> > given the possibility of vCPU preemption.  I have heard of people doing
> > nested KVM virtualization -- or is that no longer a thing?
> 
> Nested virtualization is still very much a thing, but I don't see how it is at
> all unique with respect to RCU grace periods and quiescent states.  More below.
> 
> > But the help might well involve RCU telling the hypervisor that a given
> > vCPU needs to run.  Not sure how that would go over, though it has been
> > prototyped a couple times in the context of RCU priority boosting.
> >
> > > > > > 3 - It checks if the guest exit happened over than 1 second ago. This 1
> > > > > >     second value was copied from rcu_nohz_full_cpu() which checks if the
> > > > > >     grace period started over than a second ago. If this value is bad,
> > > > > >     I have no issue changing it.
> > > > > 
> > > > > IMO, checking if a CPU "recently" ran a KVM vCPU is a suboptimal heuristic regardless
> > > > > of what magic time threshold is used.  
> > > > 
> > > > Why? It works for this particular purpose.
> > > 
> > > Because maintaining magic numbers is no fun, AFAICT the heurisitic doesn't guard
> > > against edge cases, and I'm pretty sure we can do better with about the same amount
> > > of effort/churn.
> > 
> > Beyond a certain point, we have no choice.  How long should RCU let
> > a CPU run with preemption disabled before complaining?  We choose 21
> > seconds in mainline and some distros choose 60 seconds.  Android chooses
> > 20 milliseconds for synchronize_rcu_expedited() grace periods.
> 
> Issuing a warning based on an arbitrary time limit is wildly different than using
> an arbitrary time window to make functional decisions.  My objection to the "assume
> the CPU will enter a quiescent state if it exited a KVM guest in the last second"
> is that there are plenty of scenarios where that assumption falls apart, i.e. where
> _that_ physical CPU will not re-enter the guest.
> 
> Off the top of my head:
> 
>  - If the vCPU is migrated to a different physical CPU (pCPU), the *old* pCPU
>    will get false positives, and the *new* pCPU will get false negatives (though
>    the false negatives aren't all that problematic since the pCPU will enter a
>    quiescent state on the next VM-Enter.
> 
>  - If the vCPU halts, in which case KVM will schedule out the vCPU/task, i.e.
>    won't re-enter the guest.  And so the pCPU will get false positives until the
>    vCPU gets a wake event or the 1 second window expires.
> 
>  - If the VM terminates, the pCPU will get false positives until the 1 second
>    window expires.
> 
> The false positives are solvable problems, by hooking vcpu_put() to reset
> kvm_last_guest_exit.  And to help with the false negatives when a vCPU task is
> scheduled in on a different pCPU, KVM would hook vcpu_load().

Hi Sean,

So this should deal with it? (untested, don't apply...).

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..be90d83d631a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -477,6 +477,16 @@ static __always_inline void guest_state_enter_irqoff(void)
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 
+DECLARE_PER_CPU(unsigned long, kvm_last_guest_exit);
+
+/*
+ * Returns time (jiffies) for the last guest exit in current cpu
+ */
+static inline unsigned long guest_exit_last_time(void)
+{
+	return this_cpu_read(kvm_last_guest_exit);
+}
+
 /*
  * Exit guest context and exit an RCU extended quiescent state.
  *
@@ -488,6 +498,9 @@ static __always_inline void guest_state_enter_irqoff(void)
 static __always_inline void guest_context_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
+
+	/* Keeps track of last guest exit */
+	this_cpu_write(kvm_last_guest_exit, jiffies);
 }
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb49c2a60200..231d0e4d2cf1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -110,6 +110,9 @@ static struct kmem_cache *kvm_vcpu_cache;
 static __read_mostly struct preempt_ops kvm_preempt_ops;
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 
+DEFINE_PER_CPU(unsigned long, kvm_last_guest_exit);
+EXPORT_SYMBOL_GPL(kvm_last_guest_exit);
+
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
@@ -210,6 +213,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 	int cpu = get_cpu();
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
+	__this_cpu_write(kvm_last_guest_exit, 0);
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
@@ -222,6 +226,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	__this_cpu_write(kvm_running_vcpu, NULL);
+	__this_cpu_write(kvm_last_guest_exit, 0);
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(vcpu_put);


