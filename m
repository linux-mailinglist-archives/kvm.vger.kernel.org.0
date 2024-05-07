Return-Path: <kvm+bounces-16923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4878BEC67
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 21:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AA97B20BF7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5EF16DEC3;
	Tue,  7 May 2024 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeXMztK8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4429116C84E;
	Tue,  7 May 2024 19:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715109331; cv=none; b=JKmEJCjQYi3Jzh5AKvoo+oEKGCmw4xz81Mxre1SOOeuXoppqF7ZfjydE/lAMCYHwwX74srg46q/Qk3XxYvKQvZKfCAFSAxz33uDxfuT/AfTAyCuz7uEq0YK+5c9yFidY0KFnuFFtmYFxOSwLTWFT6e9EMMEJqrS/iVw//0mmIQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715109331; c=relaxed/simple;
	bh=0/ri/nVyB1skAAyK4LnIFrNcXIXlUs+7hWnIcd/Le84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nliq/OmEprmkJ4zQ3m+Rpwc6M9dStIxYrXL2bMFVNSMeYdxg2+iVauEk9Bils+5GQD6H88fsiCvbQnFuXogPd4VEcSXDHl8/xhZSOoQDMnamHlkuZua++7CrcqazyUmwPhfT4eiH4ACUwdNUvlUNPQa98+Cd3CFjKVhSiQNw3Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YeXMztK8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9007C2BBFC;
	Tue,  7 May 2024 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715109330;
	bh=0/ri/nVyB1skAAyK4LnIFrNcXIXlUs+7hWnIcd/Le84=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=YeXMztK88N+kpNF1+Gbn1aa1vUbsn9rdOjjLe92AHx2EgYHYKHNw72me/Pemn5guz
	 SvH04+N3zxGzuqupc+skL4Uo8qf0Y/Y7qzAo34RKFuHe8Qed2SN/RJ9goxWUifiP38
	 DsvA9PFtyaLE7Wdy+0hwJ+Nu7NhivTTYlUGaqnML7JvjnJENkKAKj/vHqTBzJrl8T7
	 PU29tLJ8CHNn04bOlXFiTNf3R5eQYeiOo32lxsb3chrN+PcZOGtzTG9OR5CVGJsGw6
	 5byoouA7nrYf9me+gdtT7SNRUWwXAuw7VVhZyk6Ybdxb8WdtGwkyALlhQOFTl41dtf
	 dVb4o6AaezsVg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 660FECE0C56; Tue,  7 May 2024 12:15:30 -0700 (PDT)
Date: Tue, 7 May 2024 12:15:30 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras>
 <ZjVXVc2e_V8NiMy3@google.com>
 <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjprKm5jG3JYsgGB@google.com>

On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> On Fri, May 03, 2024, Paul E. McKenney wrote:
> > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > userspace communicate to the kernel that it's a real-time task that spends the
> > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > while it's in kernel context.
> > 
> > But if the task is executing in host kernel context for quite some time,
> > then the host kernel's RCU really does need to take evasive action.
> 
> Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> form of the 1 second timeout.

Plus RCU will force-enable that CPU's scheduler-clock tick after about
ten milliseconds of that CPU not being in a quiescent state, with
the time varying depending on the value of HZ and the number of CPUs.
After about ten seconds (halfway to the RCU CPU stall warning), it will
resched_cpu() that CPU every few milliseconds.

> And while KVM does not guarantee that it will immediately resume the guest after
> servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> anything that would prevent the kernel from preempting the interrupt task.

Similarly, the hypervisor could preempt a guest OS's RCU read-side
critical section or its preempt_disable() code.

Or am I missing your point?

> > On the other hand, if that task is executing in guest context (either
> > kernel or userspace), then the host kernel's RCU can immediately report
> > that task's quiescent state.
> > 
> > Too much to ask for the host kernel's RCU to be able to sense the
> > difference?  ;-)
> 
> KVM already notifies RCU when its entering/exiting an extended quiescent state,
> via __ct_user_{enter,exit}().
> 
> When handling an IRQ that _probably_ triggered an exit from the guest, the CPU
> has already exited the quiescent state.  And AFAIK, that can't be safely changed,
> i.e. KVM must note the context switch before enabling IRQs.

Whew!!!  ;-)

Just to make sure that I understand, is there any part of the problem
to be solved that does not involve vCPU preemption?

							Thanx, Paul

