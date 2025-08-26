Return-Path: <kvm+bounces-55787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FF0B37308
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 21:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 161B94630F9
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B5737428A;
	Tue, 26 Aug 2025 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LGvR0U5Y"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057EC262FD8
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 19:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756236328; cv=none; b=LYdBpJwNPdofgPGoLlR7q4n44HGdJkLmuU+13YEU4fQR7I/ud1/NaMuv/ZqTcNGQii9oGWvbaeZqAmetghfOwipMGuyeuDzsyhhwSIT6g6NxqpvK1Nsr33sC/40eNhbJRZXpy5ms+k3ErQjLReZnM0jndyFJwJdsyov1o0W8Gzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756236328; c=relaxed/simple;
	bh=TIwen88LojEtqJsmUY7vK8YG0QX4vhduLnEXSKWkIhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Polq6uTD6fWmuNOZ4ze62mF0QHokjJHlWb0jpRQLPRJzRvrx0NcTqsIJw05/8A+yh5YqmLBMycs/zmY/UxE1i2hMo/ZuQbV2Ko9pX6PAUZEmgeRxp1TYGheUGMjKCqbQcG3ib4SUVJ2qpMd5DGNKS7jIclrbRRaeL7ftdkf8FqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LGvR0U5Y; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 26 Aug 2025 12:24:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756236310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y4qvZnHIq/rLDQqSB4x4EUgaIF9JpQ4JSYMZzNwApLY=;
	b=LGvR0U5Y3NhPWpyPQSEB//AwQyYyNUfzVXjRtH8g9Du9ppuBHDt72wfrXdvhpiOM4tPIed
	rdp52ERydTIoS9iACwUc2dSfUGEKEH0jdoateYW1J4DMALl0laMjGEsidf869z12pc1C/B
	6zoP06K1Q0OqfGd9coZDnqu7bdaLDfQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
Message-ID: <aK4J5EA10ufKJZsU@linux.dev>
References: <20250825155203.71989-1-sebott@redhat.com>
 <aKy-9eby1OS38uqM@google.com>
 <87zfbnyvk9.wl-maz@kernel.org>
 <aKzRgp58vU6h02n6@google.com>
 <aKzX152737nAo479@linux.dev>
 <aK4CJnNxB6omPufp@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK4CJnNxB6omPufp@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 26, 2025 at 11:51:18AM -0700, Sean Christopherson wrote:
> On Mon, Aug 25, 2025, Oliver Upton wrote:
> > The majority of selftests don't even need an irqchip anyway.
> 
> But it's really, really nice for developers if they can assume a certain level of
> configuration is done by the infrastructure, i.e. don't have worry about doing
> what is effectively "basic" VM setup.

The more we pile behind what a "basic" VM configuration is the less
expressive the tests become. Being able to immediately grok the *intent*
of a test from reading it first pass is a very good thing. Otherwise I
need to go figure out what the definition of "basic" means when I need
to write a test and decide if that is compatible with what I'm trying to
do.

vm_create_with_irqchip() is delightfully unambiguous.

> E.g. x86 selftests creates an IRQCHIP, sets up descriptor tables and exception
> handlers, and a handful of other "basic" things, and that has eliminated soooo
> much boilerplate code and the associated friction with having to know/discover
> that e.g. sending IRQs in a test requires additional setup beyond the obvious
> steps like wiring up a handler.

That simply isn't going to happen on arm64. On top of the fact that the
irqchip configuration depends on the intent of the test (e.g. wired IRQs
v. MSIs), there's a bunch of guest-side initialization that needs to
happen too.

We can add an extremely barebones GIC when asked for (although guest
init isn't addressed) but batteries are not included on this architecture
and I'd rather not attempt to abstract that.

Thanks,
Oliver

