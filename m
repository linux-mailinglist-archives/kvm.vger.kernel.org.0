Return-Path: <kvm+bounces-31319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC009C2579
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C6C61F23B7F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134231AA1F8;
	Fri,  8 Nov 2024 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cZYBwdrp"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9B0233D6B;
	Fri,  8 Nov 2024 19:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731093672; cv=none; b=RMdOepfoxFTxvLgOo+bESM4lqtt6gf1quIeqcdf9w82YLgk8Y1EkjqXRBrkYLKWIxYy11Iz4pfm9ZJJpTctUjoZhvWW4EJ2FK1FNbcFMQ5lxwjkgjMfDw4nIRO/AxTfTXwiaKxQa28X1KaE6wCUlP+5A73VZ5qdmv2LziQ0J+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731093672; c=relaxed/simple;
	bh=FgO0s7qgEfr4xUgIm4T9v+y7MarK6KxwIQz3BcdqHRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+e43Pg7IQYKT6yKKQJetEjR7tvkGl3Kv54+/AqyNveCweXHmxfMPcYroMIXkyOdZ2RP8iKTzWQW9aOd3+VQtErUxjmM3YcQR86+2V8Rq3DPgknzylyu8vNlC6sKSyViOo6mx6cLDkvLrJzWw35gJ9cZykO2h7GTKq3Yrvr9Nsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cZYBwdrp; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8YcjDPRp+ch63AiHWbyUonpJU1I1xzWMm60VjxeSPBg=; b=cZYBwdrpfBq0WkAzRag13fRlS+
	+srbnreYjdRBxyphguUoNEdRENMc2XQvjvdmcPCG8tSi0IBd8RLKxJ9tVIKKCXbrYhVgAlphm7nFw
	KaOQ0DI3OZtCLdtVPbfYEJVunJWsU6yxRKMG5SYnngYK6zSyWVyBmQMCBmKL8ASErMzOjFliOr1mf
	2LGzPOyztA+UnoRF4/9kZWW+fAaVytkEptmIljkMleewymLWOvGhcue0d8GGy16tmNypfEEULMmnL
	CkTYE7C3ZtK277xJSY/wpLNDvmH4tyWeyO6lWNLkHljqzc1EiAJps/puK56riWhqlGDWL8ndXq/w4
	lQvZSyMg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9UXE-00000009Dec-12gL;
	Fri, 08 Nov 2024 19:20:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2150230049D; Fri,  8 Nov 2024 20:20:44 +0100 (CET)
Date: Fri, 8 Nov 2024 20:20:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, will@kernel.org, linux@armlinux.org.uk,
	catalin.marinas@arm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com, tglx@linutronix.de,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
Message-ID: <20241108192043.GA22801@noisy.programming.kicks-ass.net>
References: <20241108153411.GF38786@noisy.programming.kicks-ass.net>
 <gsntbjypft37.fsf@coltonlewis-kvm.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntbjypft37.fsf@coltonlewis-kvm.c.googlers.com>

On Fri, Nov 08, 2024 at 07:01:16PM +0000, Colton Lewis wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Thu, Nov 07, 2024 at 07:03:35PM +0000, Colton Lewis wrote:
> > > Break the assignment logic for misc flags into their own respective
> > > functions to reduce the complexity of the nested logic.
> 
> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >   arch/x86/events/core.c            | 32 +++++++++++++++++++++++--------
> > >   arch/x86/include/asm/perf_event.h |  2 ++
> > >   2 files changed, 26 insertions(+), 8 deletions(-)
> 
> > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > > index d19e939f3998..9fdc5fa22c66 100644
> > > --- a/arch/x86/events/core.c
> > > +++ b/arch/x86/events/core.c
> > > @@ -3011,16 +3011,35 @@ unsigned long
> > > perf_arch_instruction_pointer(struct pt_regs *regs)
> > >   	return regs->ip + code_segment_base(regs);
> > >   }
> 
> > > +static unsigned long common_misc_flags(struct pt_regs *regs)
> > > +{
> > > +	if (regs->flags & PERF_EFLAGS_EXACT)
> > > +		return PERF_RECORD_MISC_EXACT_IP;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> > > +{
> > > +	unsigned long guest_state = perf_guest_state();
> > > +	unsigned long flags = common_misc_flags(regs);
> 
> > This is double common_misc and makes no sense
> 
> I'm confused what you mean. Are you referring to starting with
> common_misc_flags in both perf_arch_misc_flags and
> perf_arch_guest_misc_flags so possibly the common_msic_flags are set
> twice?
> 
> That seems like a good thing that common flags are set wherever they
> apply. You can't guarantee where perf_arch_guest_misc_flags may be
> called in the future.

I got confused by perf_arch_misc_flags() calling common_misc_flags()
twice. It is in fact worse, because afaict all of
perf_arch_guest_misc_flags() is 'common'.

Isn't the below more or less what you want?

static unsigned long misc_flags(struct pt_regs *regs)
{
	unsigned long flags = 0;

	if (regs->flags & PERF_EFLAGS_EXACT)
		flags |= PERF_RECORD_MISC_EXACT_IP;

	return flags;
}

static unsigned long native_flags(struct pt_regs *regs)
{
	unsigned long flags = 0;

	if (user_mode(regs))
		flags |= PERF_RECORD_MISC_USER;
	else
		flags |= PERF_RECORD_MISC_KERNEL;

	return flags;
}

static unsigned long guest_flags(struct pt_regs *regs)
{
	unsigned long guest_state = perf_guest_state();
	unsigned long flags = 0;

	if (guest_state & PERF_GUEST_ACTIVE) {
		if (guest_state & PERF_GUEST_USER)
			flags |= PERF_RECORD_MISC_GUEST_USER;
		else
			flags |= PERF_RECORD_MISC_GUEST_KERNEL;
	}

	return flags;
}

unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
{
	unsigned long flags;

	flags = misc_flags(regs);
	flags |= guest_flags(regs);

	return flags;
}

unsigned long perf_arch_misc_flags(struct pt_regs *regs)
{
	unsigned long flags;
	unsigned long guest;

	flags = misc_flags(regs);
	guest = guest_flags(regs);
	if (guest)
		flags |= guest;
	else
		flags |= native_flags(regs);

	return flags;
}

Note how both perf_arch*() functions end up calling both misc and guest.

