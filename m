Return-Path: <kvm+bounces-13718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 775DE899EA8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 15:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29FCA28461C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 13:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A00E16D9B5;
	Fri,  5 Apr 2024 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EW+85BBJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CCB1C69E
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712324766; cv=none; b=gekcAB0ifMPmpiVugC8WHrWrEgxs5g8VZGIUBVhkhROYu7couqFQLdFro4kdJJBB/EK13bcxs50A/DoPzU5B4WItsQQfT7rIm9icfnLFhLjjLs7mwePEUkaWq21w+G/JHplxi5oGoDyGiHgqvsnRWpOKfObnb7ecEDJHUorGtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712324766; c=relaxed/simple;
	bh=/zinqNVTVxNGsbsEheCpLj9G3tHSvBu/H2D25u/4YHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hL6n6kGDav697mY4j2nxDNA+/Wh8qRPErm86AgZ9AnGgjIuinzYrxDYk8JeH6NJk0bBdv33nnAKToiA+Hd9pymEuFDxLtiXDUXwA0axcugk4+sC7Adh/dWQDvuAUtQ7X5N/UBud4VriXTmNr+qe4m5l4E1lIt+xqEFFgUQQiAGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EW+85BBJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712324762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ds5HqRlcZsJw1NwtspBjr4yi/f3BIcikQYMcgYaEtiE=;
	b=EW+85BBJsHsM+cNztZodubUXzpSGOeIC2sK+wuFbbxCvgyVTeIbL54i2DwIQdYSGYHX78n
	+ZgHtG4KYeyzJUL7W6JwsMpNv8haaUijDZNAjo6YQ0U/V+pzjtPb2fi6QQL4seerjHFvnk
	cuvU4LG/SrBHHeNYgAFVIjPhlqrBNqg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-ZNe6GffuObSLTYpt4S8s6Q-1; Fri, 05 Apr 2024 09:45:58 -0400
X-MC-Unique: ZNe6GffuObSLTYpt4S8s6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25B8B811E81;
	Fri,  5 Apr 2024 13:45:58 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BEFB3C21;
	Fri,  5 Apr 2024 13:45:57 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 43FF240135043; Fri,  5 Apr 2024 10:45:39 -0300 (-03)
Date: Fri, 5 Apr 2024 10:45:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <ZhAAg8KNd8qHEGcO@tpad>
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgsXRUTj40LmXVS4@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Mon, Apr 01, 2024 at 01:21:25PM -0700, Sean Christopherson wrote:
> On Thu, Mar 28, 2024, Leonardo Bras wrote:
> > I am dealing with a latency issue inside a KVM guest, which is caused by
> > a sched_switch to rcuc[1].
> > 
> > During guest entry, kernel code will signal to RCU that current CPU was on
> > a quiescent state, making sure no other CPU is waiting for this one.
> > 
> > If a vcpu just stopped running (guest_exit), and a syncronize_rcu() was
> > issued somewhere since guest entry, there is a chance a timer interrupt
> > will happen in that CPU, which will cause rcu_sched_clock_irq() to run.
> > 
> > rcu_sched_clock_irq() will check rcu_pending() which will return true,
> > and cause invoke_rcu_core() to be called, which will (in current config)
> > cause rcuc/N to be scheduled into the current cpu.
> > 
> > On rcu_pending(), I noticed we can avoid returning true (and thus invoking
> > rcu_core()) if the current cpu is nohz_full, and the cpu came from either
> > idle or userspace, since both are considered quiescent states.
> > 
> > Since this is also true to guest context, my idea to solve this latency
> > issue by avoiding rcu_core() invocation if it was running a guest vcpu.
> > 
> > On the other hand, I could not find a way of reliably saying the current
> > cpu was running a guest vcpu, so patch #1 implements a per-cpu variable
> > for keeping the time (jiffies) of the last guest exit.
> > 
> > In patch #2 I compare current time to that time, and if less than a second
> > has past, we just skip rcu_core() invocation, since there is a high chance
> > it will just go back to the guest in a moment.
> 
> What's the downside if there's a false positive?

rcuc wakes up (which might exceed the allowed latency threshold
for certain realtime apps).

> > What I know it's weird with this patch:
> > 1 - Not sure if this is the best way of finding out if the cpu was
> >     running a guest recently.
> > 
> > 2 - This per-cpu variable needs to get set at each guest_exit(), so it's
> >     overhead, even though it's supposed to be in local cache. If that's
> >     an issue, I would suggest having this part compiled out on 
> >     !CONFIG_NO_HZ_FULL, but further checking each cpu for being nohz_full
> >     enabled seems more expensive than just setting this out.
> 
> A per-CPU write isn't problematic, but I suspect reading jiffies will be quite
> imprecise, e.g. it'll be a full tick "behind" on many exits.
> 
> > 3 - It checks if the guest exit happened over than 1 second ago. This 1
> >     second value was copied from rcu_nohz_full_cpu() which checks if the
> >     grace period started over than a second ago. If this value is bad,
> >     I have no issue changing it.
> 
> IMO, checking if a CPU "recently" ran a KVM vCPU is a suboptimal heuristic regardless
> of what magic time threshold is used.  

Why? It works for this particular purpose.

> IIUC, what you want is a way to detect if
> a CPU is likely to _run_ a KVM vCPU in the near future.  KVM can provide that
> information with much better precision, e.g. KVM knows when when it's in the core
> vCPU run loop.

ktime_t ktime_get(void)
{
        struct timekeeper *tk = &tk_core.timekeeper;
        unsigned int seq;
        ktime_t base;
        u64 nsecs;

        WARN_ON(timekeeping_suspended);

        do {
                seq = read_seqcount_begin(&tk_core.seq);
                base = tk->tkr_mono.base;
                nsecs = timekeeping_get_ns(&tk->tkr_mono);

        } while (read_seqcount_retry(&tk_core.seq, seq));

        return ktime_add_ns(base, nsecs);
}
EXPORT_SYMBOL_GPL(ktime_get);

ktime_get() is more expensive than unsigned long assignment.

What is done is: If vcpu has entered guest mode in the past, then RCU
extended quiescent state has been transitioned into the CPU, therefore
it is not necessary to wake up rcu core.

The logic is copied from:

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

Note:

avoid waking up RCU core processing on such a
CPU unless the grace period has extended for too long.

> > 4 - Even though I could detect no issue, I included linux/kvm_host.h into 
> >     rcu/tree_plugin.h, which is the first time it's getting included
> >     outside of kvm or arch code, and can be weird.
> 
> Heh, kvm_host.h isn't included outside of KVM because several architectures can
> build KVM as a module, which means referencing global KVM varibles from the kernel
> proper won't work.
> 
> >     An alternative would be to create a new header for providing data for
> >     non-kvm code.
> 
> I doubt a new .h or .c file is needed just for this, there's gotta be a decent
> landing spot for a one-off variable.  E.g. I wouldn't be at all surprised if there
> is additional usefulness in knowing if a CPU is in KVM's core run loop and thus
> likely to do a VM-Enter in the near future, at which point you could probably make
> a good argument for adding a flag in "struct context_tracking".  Even without a
> separate use case, there's a good argument for adding that info to context_tracking.

Well, jiffies is cheap and just works. 

Perhaps can add higher resolution later if required?


