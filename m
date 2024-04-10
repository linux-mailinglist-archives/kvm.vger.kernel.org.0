Return-Path: <kvm+bounces-14271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAAC8A1C37
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70E2A1C20A1B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6586515AD97;
	Thu, 11 Apr 2024 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AzuSqk/C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2702915AD95
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712851923; cv=none; b=UJ9AvmO0fM8NvvAppGv1n+Y+d7CFktC/8r6kmnxsb5moL2zMWs7aKmPXvwDK8YmKWiEA6B9KlfsO7jxw2OZ0CGjqsYo5x67OkPBWFJFyU9xLhe0tyfpJ/dIYZkUUB3vNx49FT6fpUXDlaqjvuY+IV55cRxtWLE+i6/ytVMaEljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712851923; c=relaxed/simple;
	bh=iZJ65E4jwpdPJWy55MJCZoVveyH46gJ2hl1C21236H4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+cKqpqilr9pp4jOCK0KYs+nGokxm6/BP61MHXWOorglKoApMlriwXGGjQ/iU9/UnHi6s0JfPuWLgjI8gwx6udioRVytnSzBnuH/pFvh3x/tOw8KozwyN+Y0LTmyD8B3NDXKwrw6kWoe6i52kr+upOMU1/vMKJET0VysAOM6WCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AzuSqk/C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712851921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WMYXluZdka6NWHeIT5ZbQJbQ6V8bbh3I4kjosa1hc3E=;
	b=AzuSqk/CY4s+tSzOKpYc7ZIJ81rKLugeRA9GVlU55iEEwk4Y86Yj4AumsmHuHGeuSIP908
	rf1i+XMUwfTOrisdqYzhyCL+0oCZk2Xu9Ljp2GBCwiWI9C1IauJLTM71hQq+/ssClCx/XY
	T4hC2le2SH/Vm+MXzYJNRnJDW9PvJ4k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-CUvC8KVAOeeiiVXbQ2VcNQ-1; Thu, 11 Apr 2024 12:11:56 -0400
X-MC-Unique: CUvC8KVAOeeiiVXbQ2VcNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE1C61887318;
	Thu, 11 Apr 2024 16:11:54 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9657490E8;
	Thu, 11 Apr 2024 16:11:53 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 439A1400DCB1A; Tue,  9 Apr 2024 23:39:16 -0300 (-03)
Date: Tue, 9 Apr 2024 23:39:16 -0300
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
Message-ID: <ZhX71JRK0W+BaeXR@tpad>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

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

Sean,

It seems that fixing the problems you pointed out above is a way to go.


