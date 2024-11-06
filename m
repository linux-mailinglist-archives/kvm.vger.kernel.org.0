Return-Path: <kvm+bounces-31030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D6E9BF7A1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6837B23357
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA45C13A26F;
	Wed,  6 Nov 2024 19:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="azPQPKMc"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B95204022
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730922805; cv=none; b=HDZcWQBwMQ8V2cZ+JAMVMLHsfElk8DBspV32AqZ0NyxEZuBPvoAVZcrdZLicaW6MhZ87ABUeTl+Tej/Q5R5T45i8c9hF9bDKLFm2jYqa0tYIAdzuy4hC1lbWz8a5YYC+eEqQiEMY5M6YhoNphuV6AmCC7TMF3fvPvcsu3h1lUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730922805; c=relaxed/simple;
	bh=46vNwXHJt3VTkoNVKvyUOMEbBuMcyNhib1Czm9V81qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktSIWziBvH1JF4s5WmJuDPC4BKVouEuw2MEjRhB65FIYAe+pC+CSD56zoM3O3irLzNFYVsKqqSzTBevU+82uFfaRKUKA+HHVOtIbieS+/0CF8kMNxO85EOvoGFXuFYxgCdK96CF4GJyaESgIFLuFrLNIrrgV1H0I5QrTjxopu+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=azPQPKMc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 11:53:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730922800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIYHrYeDhg7kNxYUdjNDrUK44gnqtUzRYj+2b/H+nmQ=;
	b=azPQPKMcRZ7n0haevtf+gW2LUqUgNTZ0txSbzF62ESJFFuZ5O81yldkwxJtbt9eMJ9rYhP
	N+C8TyY7NMWCBJoFUX2fQEo2lLIcOBBEbEAiDRA7VK/RvAEm4WY0TpFGNaZYNkz2wLfxEo
	3CDxbqePxlmasgDPRU9wm5HtPnrmBuo=
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
Subject: Re: [PATCH v6 5/5] perf: Correct perf sampling with guest VMs
Message-ID: <ZyvJIx-UHXawnUYs@linux.dev>
References: <20241105195603.2317483-1-coltonlewis@google.com>
 <20241105195603.2317483-6-coltonlewis@google.com>
 <007cfed1-111d-45aa-b873-24cca9d4af01@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007cfed1-111d-45aa-b873-24cca9d4af01@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 11:07:53AM -0500, Liang, Kan wrote:
> > +#ifndef perf_arch_guest_misc_flags
> > +static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> > +{
> > +	unsigned long guest_state = perf_guest_state();
> > +
> > +	if (guest_state & PERF_GUEST_USER)
> > +		return PERF_RECORD_MISC_GUEST_USER;
> > +
> > +	if (guest_state & PERF_GUEST_ACTIVE)
> > +		return PERF_RECORD_MISC_GUEST_KERNEL;
> 
> Is there by any chance to add a PERF_GUEST_KERNEL flag in KVM?

Why do we need another flag? As it stands today, the vCPU is either in
user mode or kernel mode.

> The PERF_GUEST_ACTIVE flag check looks really confusing.

Perhaps instead:

static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
{
	unsigned long guest_state = perf_guest_state();

	if (!(guest_state & PERF_GUEST_ACTIVE))
		return 0;

	return (guest_state & PERF_GUEST_USER) ? PERF_RECORD_MISC_GUEST_USER :
						 PERF_RECORD_MISC_GUEST_KERNEL;
}

-- 
Thanks,
Oliver

