Return-Path: <kvm+bounces-13930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B9B89CEE3
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23FD1C2395E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64654146A9A;
	Mon,  8 Apr 2024 23:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5YgRo2y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858751DA5E;
	Mon,  8 Apr 2024 23:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712618414; cv=none; b=hKH/FlZmPvy/tMJfvMfXcozybPmLa2OkKQGSA8VgNztM/Y1GIobGrDDMGhDkI3bK+xyTSDK+sUrt7JbETxfYyN0Lg7ehbByg7DCg+3XqJeZs/0gwfulBGAweXGwCkgH9EYBrfjL5KXgoZ6gVM21M9TlUNkqU8SBZ0OVT1oVDSCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712618414; c=relaxed/simple;
	bh=IfEtQ3E4nR5vHQBjwqTMc8kDx61wvIKdmTWG7x7WHzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4Mq69s+nLWuWirVC3idNvbE5aySkBmh7mWej6QnKJNWSQwvrUJ3sZGZZg4PYUBOGaQMnmAKyV2IHaZ3E53jBfkTIhwbTidLTyvA9Gj73uMgyickLDHharB8lHG43a4mNG7gbN/laaiavH8wcHyAESEXm5Pg3P2djQV1tt4IMCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5YgRo2y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF53C433C7;
	Mon,  8 Apr 2024 23:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712618414;
	bh=IfEtQ3E4nR5vHQBjwqTMc8kDx61wvIKdmTWG7x7WHzY=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=a5YgRo2yr8x98V7V9NszagtKCxGxOsAZWMnB0RbGXRhbn8yfGJFvjL3quCjV6AbiE
	 sDnGU10P5TunaqiS+WaJO84ONfyAI7MSzQ6+1KZvU9sfHQJlihy9llb5iPaAShOD6S
	 zJs8+EoAXu4/wRBZIYlUXVk7LrpRYNov94dhvNhnANDUjKlVBQcdBbMhWNkdRLr6hM
	 I2Ebz915JsAT4hXDxOPrWTwOJMXMz0jHPMkhAVX/uKA6IeHQ3/MjiA3C2tkA0cAimI
	 5cE009USFsi1FZTV4EJH6A8yEOOO0w5OInDwsKTheDXEGqxAe7Q65YKCJQLFWMvNt+
	 P7bcmKD9mazQg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id F15DFCE118A; Mon,  8 Apr 2024 16:20:13 -0700 (PDT)
Date: Mon, 8 Apr 2024 16:20:13 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
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
Message-ID: <f34ea327-bfb1-4014-8967-1429c2133e2d@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZhAAg8KNd8qHEGcO@tpad>
 <ZhAN28BcMsfl4gm-@google.com>
 <a7398da4-a72c-4933-bb8b-5bc8965d96d0@paulmck-laptop>
 <ZhQmaEXPCqmx1rTW@google.com>
 <414eaf1e-ca22-43f3-8dfa-0a86f5b127f5@paulmck-laptop>
 <ZhROKK9dEPsNnH4t@google.com>
 <44eb0d36-7454-41e7-9a16-ce92a88e568c@paulmck-laptop>
 <ZhRoDfoz-YqsGhIB@google.com>
 <edc8b1ad-dee0-456f-89fb-47bd4709ff0e@paulmck-laptop>
 <ZhR4bnFLA08YgAgr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhR4bnFLA08YgAgr@google.com>

On Mon, Apr 08, 2024 at 04:06:22PM -0700, Sean Christopherson wrote:
> On Mon, Apr 08, 2024, Paul E. McKenney wrote:
> > On Mon, Apr 08, 2024 at 02:56:29PM -0700, Sean Christopherson wrote:
> > > > OK, then we can have difficulties with long-running interrupts hitting
> > > > this range of code.  It is unfortunately not unheard-of for interrupts
> > > > plus trailing softirqs to run for tens of seconds, even minutes.
> > > 
> > > Ah, and if that occurs, *and* KVM is slow to re-enter the guest, then there will
> > > be a massive lag before the CPU gets back into a quiescent state.
> > 
> > Exactly!
> 
> ...
> 
> > OK, then is it possible to get some other indication to the
> > rcu_sched_clock_irq() function that it has interrupted a guest OS?
> 
> It's certainly possible, but I don't think we want to go down that road.
> 
> Any functionality built on that would be strictly limited to Intel CPUs, because
> AFAIK, only Intel VMX has the mode where an IRQ can be handled without enabling
> IRQs (which sounds stupid when I write it like that).
> 
> E.g. on AMD SVM, if an IRQ interrupts the guest, KVM literally handles it by
> doing:
> 
> 	local_irq_enable();
> 	++vcpu->stat.exits;
> 	local_irq_disable();
> 
> which means there's no way for KVM to guarantee that the IRQ that leads to
> rcu_sched_clock_irq() is the _only_ IRQ that is taken (or that what RCU sees was
> even the IRQ that interrupted the guest, though that probably doesn't matter much).
> 
> Orthogonal to RCU, I do think it makes sense to have KVM VMX handle IRQs in its
> fastpath for VM-Exit, i.e. handle the IRQ VM-Exit and re-enter the guest without
> ever enabling IRQs.  But that's purely a KVM optimization, e.g. to avoid useless
> work when the host has already done what it needed to do.
> 
> But even then, to make it so RCU could safely skip invoke_rcu_core(), KVM would
> need to _guarantee_ re-entry to the guest, and I don't think we want to do that.
> E.g. if there is some work that needs to be done on the CPU, re-entering the guest
> is a huge waste of cycles, as KVM would need to do some shenanigans to immediately
> force a VM-Exit.  It'd also require a moderate amount of complexity that I wouldn't
> want to maintain, particularly since it'd be Intel-only.

Thank you for the analysis!

It sounds like the current state, imperfect though it might be, is the
best of the known possible worlds at the moment.

But should anyone come up with something better, please do not keep it
a secret!

							Thanx, Paul

> > Not an emergency, and maybe not even necessary, but it might well be
> > one hole that would be good to stop up.
> > 
> > 							Thanx, Paul

