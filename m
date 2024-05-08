Return-Path: <kvm+bounces-16957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77298BF4EA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 05:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A7E6B21D7E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 03:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E709714A8D;
	Wed,  8 May 2024 03:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmJj1Tjs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2AEAFA;
	Wed,  8 May 2024 03:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715138563; cv=none; b=hFvIEYxB/1nS9werXcoZlxHMrF6kS0BhTFyZmwceaJQL+eC9j5BxvAjy+QDboakpL9gpFyh8NeD+a2vj7XyBnpKBsPR/XrEFHE1UdzYu4iHRT0x0B14KVC3PJfW47fLD744M86m9qWCJkDyQBhUwFVYgGVsu94xcrQhfJEYSWX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715138563; c=relaxed/simple;
	bh=Bo0TxYWQZo+xruw6iLSuspPwh3c8wpp/I0KvRvyz+sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLmeMc5NW61YhbkerWCgmXLULejGWalqPlAo5LCAOOuQ2FuB/sf9YknVO67lNXxPnIwkHVaYlIVGYKKwSNxVrI8AkfdDGuP9IgUpidIA3QFyLkC0G8s10Kc8NqIe8b5uWgXPA4acGri3XrpZbJfyHeK6jRKKLC9Ao9A6hcecKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmJj1Tjs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9686CC2BBFC;
	Wed,  8 May 2024 03:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715138562;
	bh=Bo0TxYWQZo+xruw6iLSuspPwh3c8wpp/I0KvRvyz+sg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=VmJj1Tjs+s+zsKEfPnJBiDbACAQY9Ya+d7MO6Hcx0FU4S4lGeX14qoBMwOFvcX9c3
	 TIZjxpsGAzybxt9hEVSm8NvWVX8z1O++Qi0XSougis9+r3/Mbq11cvUAca903XQ8SD
	 l72KYu9eaPU1D2pcKXAcUMWD036iAZVEKMyHvViz1iJtDB69WwMBy28KShWGiupXVk
	 Ds6Xm5fN6GxMVOFBsGkmKUQ+rqLkmR8/8KbqW5fDsnOkWBFBXK20bclAveuRlHEwD6
	 Xyoz5XnA8yRC18H4UfBwRarXgY5l9aPl4PxFQVBhK31aYiEcCaQ1fLko44tht6yyMK
	 Jh054ghMCXGJQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4691ACE0FF3; Tue,  7 May 2024 20:22:42 -0700 (PDT)
Date: Tue, 7 May 2024 20:22:42 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Leonardo Bras <leobras@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
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
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZjUwHvyvkM3lj80Q@LeoBras>
 <ZjVXVc2e_V8NiMy3@google.com>
 <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com>
 <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com>
 <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com>
 <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zjroo8OsYcVJLsYO@LeoBras>

On Tue, May 07, 2024 at 11:51:15PM -0300, Leonardo Bras wrote:
> On Tue, May 07, 2024 at 05:08:54PM -0700, Sean Christopherson wrote:
> > On Tue, May 07, 2024, Sean Christopherson wrote:
> > > On Tue, May 07, 2024, Paul E. McKenney wrote:

[ . . . ]

> > > > But if we do need RCU to be more aggressive about treating guest execution as
> > > > an RCU quiescent state within the host, that additional check would be an
> > > > excellent way of making that happen.
> > > 
> > > It's not clear to me that being more agressive is warranted.  If my understanding
> > > of the existing @user check is correct, we _could_ achieve similar functionality
> > > for vCPU tasks by defining a rule that KVM must never enter an RCU critical section
> > > with PF_VCPU set and IRQs enabled, and then rcu_pending() could check PF_VCPU.
> > > On x86, this would be relatively straightforward (hack-a-patch below), but I've
> > > no idea what it would look like on other architectures.
> > > 
> > > But the value added isn't entirely clear to me, probably because I'm still missing
> > > something.  KVM will have *very* recently called __ct_user_exit(CONTEXT_GUEST) to
> > > note the transition from guest to host kernel.  Why isn't that a sufficient hook
> > > for RCU to infer grace period completion?
> 
> This is one of the solutions I tested when I was trying to solve the bug:
> - Report quiescent state both in guest entry & guest exit.
> 
> It improves the bug, but has 2 issues compared to the timing alternative:
> 1 - Saving jiffies to a per-cpu local variable is usually cheaper than 
>     reporting a quiescent state
> 2 - If we report it on guest_exit() and some other cpu requests a grace 
>     period in the next few cpu cycles, there is chance a timer interrupt 
>     can trigger rcu_core() before the next guest_entry, which would 
>     introduce unnecessary latency, and cause be the issue we are trying to 
>     fix.
> 
> I mean, it makes the bug reproduce less, but do not fix it.

OK, then it sounds like something might be needed, but again, I must
defer to you guys on the need.

If there is a need, what are your thoughts on the approach that Sean
suggested?

							Thanx, Paul

