Return-Path: <kvm+bounces-16928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D72788BEEEA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 23:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C1631F24D91
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 21:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F9377F30;
	Tue,  7 May 2024 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+vpBcZ1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE022187326;
	Tue,  7 May 2024 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715117879; cv=none; b=grlZm6QEaSSkcj8RXKZZ13gG44LS1islPYV7kp4LfCsyBPnxgr0KvWVpg9sfKpWEF46+OXUNSosgLc6yN8DRLLag1eBSKCJSXDgQhPC7Ab7uPjAu+2O6QqAuJH+aCmNoLDTGksJCoFyxeg2CWSqbUSI4MWuGzyf2I6eBLRt3hG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715117879; c=relaxed/simple;
	bh=b0erpGJkbKehHG2oRo2+D/HPvaIA53JmaUColexBDK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8+0pPooxruE72mv00ydKVaPD+ljqYITFVlwHR0Nmq6IsLL9C3fdfy+w2e6FRNDoj8qsa9MTnykeQbsneDe6UPHV2SLtXro2FEB1YjDwUfTj63hxC/Ekk9+lPU1tE65VgjFWFteO52FT3rnKJRX9trlHrsEZ8UawC4hRZXC0m20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+vpBcZ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C325C2BBFC;
	Tue,  7 May 2024 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715117878;
	bh=b0erpGJkbKehHG2oRo2+D/HPvaIA53JmaUColexBDK0=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=W+vpBcZ1T0cZAzGv4Vm3pWP6Skmffhzq9UvcBveRu2iX51Pcp4aBUZWS6arxPQTTJ
	 k8pYZasyBwioDP/z7EVPkIn7+ZtGun1LAN5Ux9S08WhuH6HiMD/qjA6npj1W+t+pnO
	 zJR1uvpOWxMtEhsyYXpm2ob/oQ23glrIcfxmU0SonH5a/sg4Pu1ZUOBTZMDShDmQvX
	 +YNVOnALWHHjlkI50GCjyfsoPNWmnpv5kAdagepBJC7S/ztTXhON53jbwYDP5ghoYw
	 O1ofq1BOP/KDdomjtPe1nlSr8k+UTOZSG39DmcjkdTHOBS1zUYTqQWnylZreXRYXoS
	 QrOWdIKLpvi+w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id DEB30CE0FF3; Tue,  7 May 2024 14:37:57 -0700 (PDT)
Date: Tue, 7 May 2024 14:37:57 -0700
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
Message-ID: <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras>
 <ZjVXVc2e_V8NiMy3@google.com>
 <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com>
 <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjqWXPFuoYWWcxP3@google.com>

On Tue, May 07, 2024 at 02:00:12PM -0700, Sean Christopherson wrote:
> On Tue, May 07, 2024, Paul E. McKenney wrote:
> > On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> > > On Fri, May 03, 2024, Paul E. McKenney wrote:
> > > > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > > > userspace communicate to the kernel that it's a real-time task that spends the
> > > > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > > > while it's in kernel context.
> > > > 
> > > > But if the task is executing in host kernel context for quite some time,
> > > > then the host kernel's RCU really does need to take evasive action.
> > > 
> > > Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> > > form of the 1 second timeout.
> > 
> > Plus RCU will force-enable that CPU's scheduler-clock tick after about
> > ten milliseconds of that CPU not being in a quiescent state, with
> > the time varying depending on the value of HZ and the number of CPUs.
> > After about ten seconds (halfway to the RCU CPU stall warning), it will
> > resched_cpu() that CPU every few milliseconds.
> > 
> > > And while KVM does not guarantee that it will immediately resume the guest after
> > > servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> > > anything that would prevent the kernel from preempting the interrupt task.
> > 
> > Similarly, the hypervisor could preempt a guest OS's RCU read-side
> > critical section or its preempt_disable() code.
> > 
> > Or am I missing your point?
> 
> I think you're missing my point?  I'm talking specifically about host RCU, what
> is or isn't happening in the guest is completely out of scope.

Ah, I was thinking of nested virtualization.

> My overarching point is that the existing @user check in rcu_pending() is optimistic,
> in the sense that the CPU is _likely_ to quickly enter a quiescent state if @user
> is true, but it's not 100% guaranteed.  And because it's not guaranteed, RCU has
> the aforementioned guardrails.

You lost me on this one.

The "user" argument to rcu_pending() comes from the context saved at
the time of the scheduling-clock interrupt.  In other words, the CPU
really was executing in user mode (which is an RCU quiescent state)
when the interrupt arrived.

And that suffices, 100% guaranteed.

The reason that it suffices is that other RCU code such as rcu_qs() and
rcu_note_context_switch() ensure that this CPU does not pay attention to
the user-argument-induced quiescent state unless this CPU had previously
acknowledged the current grace period.

And if the CPU has previously acknowledged the current grace period, that
acknowledgement must have preceded the interrupt from user-mode execution.
Thus the prior quiescent state represented by that user-mode execution
applies to that previously acknowledged grace period.

This is admittedly a bit indirect, but then again this is Linux-kernel
RCU that we are talking about.

> And I'm arguing that, since the @user check isn't bombproof, there's no reason to
> try to harden against every possible edge case in an equivalent @guest check,
> because it's unnecessary for kernel safety, thanks to the guardrails.

And the same argument above would also apply to an equivalent check for
execution in guest mode at the time of the interrupt.

Please understand that I am not saying that we absolutely need an
additional check (you tell me!).  But if we do need RCU to be more
aggressive about treating guest execution as an RCU quiescent state
within the host, that additional check would be an excellent way of
making that happen.

							Thanx, Paul

