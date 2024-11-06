Return-Path: <kvm+bounces-31037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A5C9BF839
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77F451C22B99
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF0A20C499;
	Wed,  6 Nov 2024 20:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bw/NSx1j"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2514F9D9
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730926320; cv=none; b=b1U06Kt7fgXALgbVlAATALXHvZSb/sYwFjPPT4M4tlF8w5CRh3Q8BDeu+4pdoiSgBkktSmn6oMMzxg/RUmaGcoFb3JN8Npljne3lqY7u7v5Oi7iymKHXTVkcPRLxbvoiJRsCs2nbO0GokdrRKZ4PTCTD3UKUuOAPzbRpnZakXBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730926320; c=relaxed/simple;
	bh=BUiy1Lrkui/QDhUO26WuXJ0XiAVZDQ7hDrKZilM9VkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/bb4I1wLbfJe2Y5j2LypaByParugpocn8v27TpVHeJYBVh7rgX8uWzpYofXLIuqLI8PQJyXnb3d5sZ9npnKrGrFxhG0XXr4/fQMtGWp1kidds8bcRV1xDRVjg8oCprYSxK6j68GGFwHcFsH0DbJzXsLlEFW1mT4s49TaN5CZT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bw/NSx1j; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 12:51:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730926316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iTbQ6DPhP6MjHwSaDILXhZVjYXEH8BwsiSbm61YVqgE=;
	b=Bw/NSx1j2z8iH74+2uUPsORZOF/lHwjDSE1XgPO3bR7hc3VDGRgJjxxqihTFVbyt2Vu2w8
	raQ7DhoPXKD5HHKOAaOJujYj6vS582FOQLBKtpnd3xvd1RSxRYMmmhyO+1CxVOE0maifyR
	a4U5OreS2n4YhRCs77wj4S8lLE19n7c=
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
Message-ID: <ZyvW3FxcezmYyOMa@linux.dev>
References: <20241105195603.2317483-1-coltonlewis@google.com>
 <20241105195603.2317483-5-coltonlewis@google.com>
 <65675ed8-e569-47f8-b1eb-40c853751bfb@linux.intel.com>
 <ZyvLOjy8Vfvai5cG@linux.dev>
 <597dbcf6-8169-4084-881c-8942ed363189@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <597dbcf6-8169-4084-881c-8942ed363189@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 03:33:30PM -0500, Liang, Kan wrote:
> On 2024-11-06 3:02 p.m., Oliver Upton wrote:
> > On Wed, Nov 06, 2024 at 11:03:10AM -0500, Liang, Kan wrote:
> >>> +static unsigned long common_misc_flags(struct pt_regs *regs)
> >>> +{
> >>> +	if (regs->flags & PERF_EFLAGS_EXACT)
> >>> +		return PERF_RECORD_MISC_EXACT_IP;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> >>> +{
> >>> +	unsigned long guest_state = perf_guest_state();
> >>> +	unsigned long flags = common_misc_flags(regs);
> >>> +
> >>> +	if (guest_state & PERF_GUEST_USER)
> >>> +		flags |= PERF_RECORD_MISC_GUEST_USER;
> >>> +	else if (guest_state & PERF_GUEST_ACTIVE)
> >>> +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> >>> +
> >>
> >> The logic of setting the GUEST_KERNEL flag is implicitly changed here.
> >>
> >> For the current code, the GUEST_KERNEL flag is set for !PERF_GUEST_USER,
> >> which include both guest_in_kernel and guest_in_NMI.
> > 
> > Where is the "guest_in_NMI" state coming from? KVM only reports user v.
> > kernel mode.
> 
> I may understand the kvm_arch_pmi_in_guest() wrong.

kvm_arch_pmi_in_guest() is trying to *guess* whether or not an overflow
interrupt caused the most recent VM-exit, implying a counter overflowed
while in the VM. It has no idea what events are loaded on the PMU and
which contexts they're intended to sample in.

It only makes sense to check kvm_arch_pmi_in_guest() if you're dealing with
an event that counts in both host and guest modes and you need to decide who
to sample.

> However, the kvm_guest_state() at least return 3 states.
> 0
> PERF_GUEST_ACTIVE
> PERF_GUEST_ACTIVE | PERF_GUEST_USER
> 
> The existing code indeed assumes two modes. If it's not user mode, it
> must be kernel mode.
> However, the proposed code behave differently, or at least implies there
> are more modes.
> If it's not user mode and sets PERF_GUEST_ACTIVE, it's kernel mode.

A precondition of the call to perf_arch_guest_misc_flags() is that guest
state is nonzero, meaning a vCPU is loaded presently on this CPU.

-- 
Thanks,
Oliver

