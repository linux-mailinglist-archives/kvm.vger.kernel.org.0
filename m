Return-Path: <kvm+bounces-25835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D4E96B2F9
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 09:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB8F2281BA1
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 07:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C617146A9F;
	Wed,  4 Sep 2024 07:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="uvF7FEHv"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCD23C17;
	Wed,  4 Sep 2024 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435310; cv=pass; b=jKFoc30xM/6/nAgwoszcHULyzkYoPO50/HAmdfnIN9lF2w3YwVN0gztDNmdoRskOu8/CVbwvoms2nJcp6pyPK/r7BUjH0qnnvqsklZtvH9JL03BVEdFWvIdibe2YDYxlheUONZMKwA2Op+eu8+u8uwQEPi2jTz1Z1WMoMeJmIHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435310; c=relaxed/simple;
	bh=s7G+1cU3wFHWsB8CGbBC3PlRmQZrTCS8Gt5gpjh1b4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ys4go+w5gU6lu3Hu9Bmh/rykddNjQ/KiXoNZgBW3PsTRk8trWOiaRppZyYR9q5/t8d8PXhjSeP3CFP8I6tfNLkrHJlzfDHPfRbLxn1T3molQ63S/1Dw4d6jc13F2r32ns2H7pBT657b+/PWnWF3RNL4tKHSJl0dwJ3U3v+BG9mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=uvF7FEHv; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [IPv6:2610:1c1:1:606c::19:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4WzDmB3cl5z41Mm;
	Wed,  4 Sep 2024 07:35:06 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [96.47.72.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4WzDmB2r4Xz4FLK;
	Wed,  4 Sep 2024 07:35:06 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1725435306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZD0avwa5MUoFI9ov7p+i7pt8IH9D8rPh/o0IcOG42vs=;
	b=uvF7FEHvhzz9uf3fwh4REMIymiNOtxdPtlC31MlzrkS8A/AwPutDcMO3mQ/zOwuZ5Ef8zZ
	Hzn/Ur13ba/pFambgYeclyHcvkyQVWaXem36VaJlKRlOuJiWuFL+rcaouNqpsYx7s7Ofxh
	LzHcLjUTu+HXqQvZ7tW+aJ0g6hq76XhqcGbQ1ZRlHwFOgUotz0yCSOnBToL9EDUO/xd6Sf
	F4wtiahLGydzkAmAYaMgRwzMYH4hgDmpMWNOaPVS1tpzb66vHj9RSpmoddz4dN0wKkTsBa
	NA077cvVHCnsPwAOjP+RXQShWBE9NG58PttjTkMddEsrycIIRpBtYyPaZjVPNg==
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1725435306; a=rsa-sha256; cv=none;
	b=r/pwZMPKJlOmyGAdM4fBcsKiNwzYC+3CcDm1anedtKnQdEkLd+gu/lKNoYN/BBBWs8ln8b
	LnGsqPKVrYHnB3/A3QsrbZYDN11qo4npOMYj1fqIFrV5bOQdADHWzSq3M82VDib51bbyHM
	0Tyd0veks9nF0B+k2oIvVQxURNhSOJZt7dx6aolUSJGiJRVZurX6kDDQ5kPBwmtZq83NcV
	H9MuZP9OGtGByCAu6HltQs62gxDY+rLDEEnXkYJzkaQjjWmUsPgeqsDEjphJF1tBtuLbFk
	MeQ+B+1JHYplmSEVu3a8ib7sJGAF+FqwjNy3wobWwtJ2GdJ9gkLdeXZcHgEdmg==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1725435306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZD0avwa5MUoFI9ov7p+i7pt8IH9D8rPh/o0IcOG42vs=;
	b=PnZh/3ptInZkoNAm6Ob+lF2xlhYwvkWQoLnEJpBZg/+MvZmYnyKoK+lGSyZq4te18daip2
	KwVmsjTqsy+KIF2kOWQVnF9y1AzOdoq1dH8ACa0RR1DYhwAzCmjndK08tu+Nnro5stNm3a
	NVC4uz0MXu+rmB2yCz/DEG8ljCGQOQ9t9fRS1IfVpTGAi4emNHGlieLWqxPva4byDVfLfK
	kc6sgrT8fnPBQEougsLxxulErma2WjLmtwRBPdw3A27fDPEkG2WvQFayhKJNV8woU2PKD7
	lg2+C9vcGE9lwZKl7pqW62XrDovh+8+iAyCR3kkJJ3cRltApfkrrI5x3O31jDw==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id 4487C23F12; Wed, 04 Sep 2024 07:35:06 +0000 (UTC)
Date: Wed, 4 Sep 2024 07:35:06 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"x86@kernel.org" <x86@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Borislav Petkov <bp@alien8.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Frederic Weisbecker <fweisbec@gmail.com>, suleiman@google.com
Subject: Re: [RFC][PATCH] KVM: Remove HIGH_RES_TIMERS dependency
Message-ID: <ZtgNqv1r7S738osp@freefall.freebsd.org>
References: <20240821095127.45d17b19@gandalf.local.home>
 <Zs97wp2-vIRjgk-e@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs97wp2-vIRjgk-e@google.com>

On Wed, Aug 28, 2024 at 12:34:26PM -0700, Sean Christopherson wrote:
> On Wed, Aug 21, 2024, Steven Rostedt wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
> > to high resolution timers with the comment:
> > 
> >     KVM lapic timer and tsc deadline timer based on hrtimer,
> >     setting a leftmost node to rb tree and then do hrtimer reprogram.
> >     If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
> >     do nothing and then make kvm lapic timer and tsc deadline timer fail.
> > 
> > That was back in 2012, where hrtimer_start_range_ns() would do the
> > reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
> > high resolution timers disabled, this did not work. But a lot has changed
> > in the last 12 years.
> > 
> > For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
> > timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
> > timers. There's been lots of other changes that make low res work.
> > 
> > I added this change to my main server that runs all my VMs (my mail
> > server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
> > system has been running just fine for over a month.
> > 
> > ChromeOS has tested this before as well, and it hasn't seen any issues with
> > running KVM with high res timers disabled.
> 
> Can you provide some background on why this is desirable, and what the effective
> tradeoffs are?  Mostly so that future users have some chance of making an
> informed decision.  Realistically, anyone running with HIGH_RES_TIMERS=n is likely
> already aware of the tradeoffs, but it'd be nice to capture the info here.

We have found that disabling HR timers saves power without degrading
the user experience too much.

> 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  arch/x86/kvm/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 472a1537b7a9..c65127e796a9 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -19,7 +19,6 @@ if VIRTUALIZATION
> >  
> >  config KVM
> >  	tristate "Kernel-based Virtual Machine (KVM) support"
> > -	depends on HIGH_RES_TIMERS
> 
> I did some very basic testing and nothing exploded on me either.  So long as
> nothing in the host catches fire, I don't see a good reason to make high resolution
> timers a hard requirement.
> 
> My only concern is that this could, at least in theory, result in people
> unintentionally breaking their setups, but that seems quite unlikely.
> 
> One thought would be to require the user to enable EXPERT in order to break the
> HIGH_RES_TIMERS dependency.  In practice, I doubt that will be much of a deterrent
> since (IIRC) many distros ship with EXPERT=y.  But it would at least document that
> using KVM x86 without HIGH_RES_TIMERS may come with caveats.  E.g.
> 
> 	depends on HIGH_RES_TIMERS || EXPERT

This sounds like a good compromise.

-- Suleiman

