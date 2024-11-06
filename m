Return-Path: <kvm+bounces-31032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE9D9BF7BB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84C7B282F94
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1E820BB38;
	Wed,  6 Nov 2024 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ev2IHzSQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0705A20ADF2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 20:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730923341; cv=none; b=kmGfWjT7/buScU9/FqHJeA4SpLsodKnWc0xL5FOskPW80ngHszU4WUW8ueZvuxJkNUFvgN4SKmjpsns7bgqpxvFWFCmhkXIrKYlpLgGY6SvWXQtJlzkkj3qOZiC5cch1cS4YMOpAMSVCg6a88eo9pcU3MDMmFvT5ZiREuyTXFmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730923341; c=relaxed/simple;
	bh=kr2hSk9kD/Q1HlbZ6L5rhE0nc4/U9zvSmMbYZicmkng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTQEGzlUVvg5n/+cYys4u/5F6zLT93w7Ea1EEdJBhppZjRlJ1eoD2J6LkqyczIsOINdcGj1y3Sq3FRAi6a5beT9MqslypTfhFD6wtgsYj/SGPRdDC4zUThvgjRQeiIbSjnGeyunKkvCn1zHOxD8oRAV8w1EOd6mzM84UrYKunBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ev2IHzSQ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 12:02:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730923334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SOBsyQjKR+aopD9T4x3Q0P1OVO7qyX9T6pAaFYsEySE=;
	b=Ev2IHzSQp/e4ZHbWSktOjEbNH4Qrutu7t3FQZgZAUdjLZ2w0IRzdDpE0H0/CbqWzpKlYQ9
	YoBodBX6TP/KL8N4d4CPCs7LoHILZ6KO7RZoORayqY7Bdtm+n+C1UqxpuBYqJothRojsuy
	YXhRfwcYbNxEKBIQGEpmwmMsXoiL+Q4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 4/5] x86: perf: Refactor misc flag assignments
Message-ID: <ZyvLOjy8Vfvai5cG@linux.dev>
References: <20241105195603.2317483-1-coltonlewis@google.com>
 <20241105195603.2317483-5-coltonlewis@google.com>
 <65675ed8-e569-47f8-b1eb-40c853751bfb@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65675ed8-e569-47f8-b1eb-40c853751bfb@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 11:03:10AM -0500, Liang, Kan wrote:
> > +static unsigned long common_misc_flags(struct pt_regs *regs)
> > +{
> > +	if (regs->flags & PERF_EFLAGS_EXACT)
> > +		return PERF_RECORD_MISC_EXACT_IP;
> > +
> > +	return 0;
> > +}
> > +
> > +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> > +{
> > +	unsigned long guest_state = perf_guest_state();
> > +	unsigned long flags = common_misc_flags(regs);
> > +
> > +	if (guest_state & PERF_GUEST_USER)
> > +		flags |= PERF_RECORD_MISC_GUEST_USER;
> > +	else if (guest_state & PERF_GUEST_ACTIVE)
> > +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> > +
> 
> The logic of setting the GUEST_KERNEL flag is implicitly changed here.
> 
> For the current code, the GUEST_KERNEL flag is set for !PERF_GUEST_USER,
> which include both guest_in_kernel and guest_in_NMI.

Where is the "guest_in_NMI" state coming from? KVM only reports user v.
kernel mode.

-- 
Thanks
Oliver

