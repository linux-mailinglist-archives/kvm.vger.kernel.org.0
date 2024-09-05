Return-Path: <kvm+bounces-25925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C950C96D051
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E63411C224C2
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 07:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7C419308C;
	Thu,  5 Sep 2024 07:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="Rj0r6suk"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80F48CCC;
	Thu,  5 Sep 2024 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725521012; cv=pass; b=IIX8OJBvksFFbIpSL4lcbGNFpa2KkKa6GiIpyEw9ia3SD6J75HkJc8p8btiC1KTib1DFcy7Zw23mdy5pvtophF+mwDK6e/DipmEUNacL1/3YjsACdUyRT+QH/kb/neMVWwht2U7MJr4BfDwo4kfnGYLe1CpYbtJ/kS342dUloR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725521012; c=relaxed/simple;
	bh=fwjyZr0hhXrpSxAvTAozxDoPzTvw4FKbp8Pj/QsDXHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5Ur3142dC6W1XIJT1+qiTsw3g+O96o8Jm99wA9na/DCEzBARtkZ44CRrh2am7gnvAkS2/eYw/lfusz3tS3uoGpBnN8F/dY89mhbXl6XmQUEPrxYPbv/KGdz43lCGoz1qnMzGdj0oWaQa2ivffKxWVr2dKFzlBdutGH1NM2LA4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=Rj0r6suk; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [96.47.72.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4WzrSJ6Btlz4WkV;
	Thu,  5 Sep 2024 07:23:28 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [96.47.72.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4WzrSJ55hhz4VcV;
	Thu,  5 Sep 2024 07:23:28 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1725521008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=elZCUY6hLY/xsZmJf+VAyQ4knFJv9hbqHxeG+NskNGg=;
	b=Rj0r6sukH3AJV1fnHp/g68h/3fzB2mq5Jro40HHpNfPvKbZCDLLH7Zj8FewmvWEk0//ImS
	s5B2dT4WPFWJOu+zzYENGs842sZ6ALpwP0eYsZ96pIxs5dJGqkVfCxGOYe2LYqmjEc7Wg2
	qoiOF/sf5dtmLiulnatjZNcMsk/44S0uL4rKo8PG7aUrcD1R1+XUNfBl36nUyjmNHILzNd
	o9Nv7zpPG3lUKYkoU4HbDJfGgemc3zyJXgK1KKwiiZ8albQ7K9hFUrMpzKypU2LhVX9XjL
	wPxI//8Qo76P1ZISH48km3Zay+XgxkQr5/moNQiFUMQVDEMvIW1/LNyBwQ66Ow==
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1725521008; a=rsa-sha256; cv=none;
	b=Ne9cGlXwEbsBWE+vhf3uU0bpWWVL6mvaINIBtHX3mOaGnSC2Q8VLtJfqgru6kZWypCu8gb
	WikyDWlRA+BhYmwMu7aw93614AENjKUBPJRaHkZniK38DHKaJs1nCHKob0hKKXWwdJCoO1
	+ZxCqsalEQxk3ZQ0a/hXfTMwX0dYmnDeKwDNwZKhN7K3QNaAw7jnhjog4dVaOWagsshdKX
	q+zNYNmvt8/+O2efcIQjh5t8GQd426BBkJihL+pQCSyjphodTSb9w+cELmAHq1Ag1LFB++
	Tb7dHeuVu6Vp0lNexdTFb1QxkfdFC9O0pRARqy6QOkWkX0vvT8EqFLa2cJOsoA==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1725521008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=elZCUY6hLY/xsZmJf+VAyQ4knFJv9hbqHxeG+NskNGg=;
	b=XR5mIOamGNy/oHJsfrjumTGEf254TDM9QVIpEbP0f0gCPpAUrbFDmppp1kEHMVQJXYaAZv
	mz61qFXCL2C5yF8LKkS0jbebQTPkrBlqRWZkleNKRoWog6K9dQlSkbl4wrJwsk/FS0qBAE
	z4+Xe5VjZ49qBsmCyn637/j7mCPN2F2zXjP2MpyjhTgTdZMg8ld9W9h2kvtcIdsIAolEAO
	DvPxT3FQ+FaJvHX/0uOORUGLrUcS4MfWjYnAiQ6LyohV+G8Bwiw8PYxNAgPrUDj9iJaMN0
	/DgNE3d62FpSn/Niy1JTmAeJjeW6HyCZ8dgsoBN/JQ6h/Yt6f0S/2IPn2dL4GQ==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id 8B62426ED; Thu, 05 Sep 2024 07:23:28 +0000 (UTC)
Date: Thu, 5 Sep 2024 07:23:28 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
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
Message-ID: <ZtlccIb0CgLFeL5k@freefall.freebsd.org>
References: <20240821095127.45d17b19@gandalf.local.home>
 <Zs97wp2-vIRjgk-e@google.com>
 <ZtgNqv1r7S738osp@freefall.freebsd.org>
 <9b6ef0fa-99f5-4eac-b51a-aa0a3126c443@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b6ef0fa-99f5-4eac-b51a-aa0a3126c443@redhat.com>

On Wed, Sep 04, 2024 at 03:25:51PM +0200, Paolo Bonzini wrote:
> On 9/4/24 09:35, Suleiman Souhlal wrote:
> > On Wed, Aug 28, 2024 at 12:34:26PM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 21, 2024, Steven Rostedt wrote:
> > > > From: Steven Rostedt <rostedt@goodmis.org>
> > > > 
> > > > Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
> > > > to high resolution timers with the comment:
> > > > 
> > > >      KVM lapic timer and tsc deadline timer based on hrtimer,
> > > >      setting a leftmost node to rb tree and then do hrtimer reprogram.
> > > >      If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
> > > >      do nothing and then make kvm lapic timer and tsc deadline timer fail.
> > > > 
> > > > That was back in 2012, where hrtimer_start_range_ns() would do the
> > > > reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
> > > > high resolution timers disabled, this did not work. But a lot has changed
> > > > in the last 12 years.
> > > > 
> > > > For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
> > > > timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
> > > > timers. There's been lots of other changes that make low res work.
> > > > 
> > > > I added this change to my main server that runs all my VMs (my mail
> > > > server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
> > > > system has been running just fine for over a month.
> > > > 
> > > > ChromeOS has tested this before as well, and it hasn't seen any issues with
> > > > running KVM with high res timers disabled.
> > > 
> > > Can you provide some background on why this is desirable, and what the effective
> > > tradeoffs are?  Mostly so that future users have some chance of making an
> > > informed decision.  Realistically, anyone running with HIGH_RES_TIMERS=n is likely
> > > already aware of the tradeoffs, but it'd be nice to capture the info here.
> > 
> > We have found that disabling HR timers saves power without degrading
> > the user experience too much.
> 
> This might have some issues on guests that do not support kvmclock, because
> they rely on precise delivery of periodic timers to keep their clock
> running.  This can be the APIC timer (provided by the kernel), the RTC
> (provided by userspace), or the i8254 (choice of kernel/userspace).
> 
> These guests are few and far between these days, and in the case of the APIC
> timer + Intel hosts we can use the preemption timer (which is TSC-based and
> has better latency _and_ accuracy).  Furthermore, only x86 is requiring
> CONFIG_HIGH_RES_TIMERS, so it's probably just excessive care and we can even
> apply Steven's patch as is.
> 
> Alternatively, the "depends on HIGH_RES_TIMERS || EXPERT" could be added to
> virt/kvm.  Or a pr_warn could be added to kvm_init if HIGH_RES_TIMERS are
> not enabled.
> 
> But in general, it seems that Linux has a laissez-faire approach to
> disabling CONFIG_HIGH_RES_TIMERS - there must be other code in the kernel
> (maybe sound/?) that is relying on having high-enough HZ or hrtimers but
> that's not documented anywhere.  I don't have an objection to doing the same
> in KVM, honestly, since most systems are running CONFIG_HIGH_RES_TIMERS
> anyway.

I'm not sure how much my opinion on the matter counts, but I would be more
than happy to see Steven's current patch get applied as is.
It would make our (ChromeOS) life a bit simpler.

-- Suleiman

