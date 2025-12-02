Return-Path: <kvm+bounces-65107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD57C9B82A
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 13:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3D1B3A6172
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 12:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3532FD7CA;
	Tue,  2 Dec 2025 12:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G2BkLjq+"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C4B1FDE31;
	Tue,  2 Dec 2025 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764679475; cv=none; b=pQJeSx9UpWVO3t+5R0HK6Vp6DSHq+e+ihYc8MdzzKa6frsMFTfGbFXvHzh3A7HqjS8uPJsr7ymRJQt6PP1C9I74vztg344KmfMufOO90So8NnbL9JsJCd2z0UwT8LMloOqo4Ytvtbt7biWyKzHguhHM12wAhoCeo+i13Ux7BH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764679475; c=relaxed/simple;
	bh=fzAPWwhUFDXtJQgN9X0qUwTcuXgPtQJvK7zTu2GJVO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=So73uvUtCM82TvZYgiFyN0y2Yhfn2mGrqmisoOwqMzrW4o1WGR+qQRu7yXJ6DkR/RjwjBlfJuHPoMOg5AR/acCMFhqrhD3RmTSR0z7VceepMq1hNxkt8r9qarVhLJK4JxQpw8HLFY7iBkXnBPMiga1P3BdMx40v3AAV2EE3Zrwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G2BkLjq+; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mXcVy5Xtf1bA620+TPKKQEzEhyr0Jc4knvWcxlH7UrE=; b=G2BkLjq+hjAbppHemVXGFfW+UX
	mmG+xU4ddmhlxnwU1ULsylOYDYfYssKhKE1YS0wcU5H8HCLXcqwsivy2SjUe0qG5l4IB1jMUOhsfS
	ZMvELy/A8osby27pzukTsVH9yl9tRwOikQWr8yfCHipj7y+Uv3iUQGSx8uU1RF+gtoIGnieCZVIrC
	SR2IA3XRKEo8HYKGYyJhAmYy+Bp1RR+VJLHkFran7osJ81ySGFZrBiALgjxGWRHQLnZxyZttrPJB0
	aQkE5ZfGCypIrtsUq2HkBWA+je+X7a4QryCX20hdAtAxV6FlqPjCVWSgOAEFxv9+GyS5tC4pfoCcS
	V7tvyqwg==;
Received: from 2001-1c00-8d82-9800-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d82:9800:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQOsS-00000000Kpl-2sRV;
	Tue, 02 Dec 2025 11:49:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9C57E30027B; Tue, 02 Dec 2025 13:44:23 +0100 (CET)
Date: Tue, 2 Dec 2025 13:44:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fernand Sieber <sieberf@amazon.com>
Cc: seanjc@google.com, pbonzini@redhat.com,
	Jan =?iso-8859-1?Q?H=2E_Sch=F6nherr?= <jschoenh@amazon.de>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	dwmw@amazon.co.uk, hborghor@amazon.de, nh-open-source@amazon.com,
	abusse@amazon.de, nsaenz@amazon.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Message-ID: <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
References: <20251201142359.344741-1-sieberf@amazon.com>
 <20251202100311.GB2458571@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202100311.GB2458571@noisy.programming.kicks-ass.net>

On Tue, Dec 02, 2025 at 11:03:11AM +0100, Peter Zijlstra wrote:
> On Mon, Dec 01, 2025 at 04:23:57PM +0200, Fernand Sieber wrote:
> >  arch/x86/kvm/pmu.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 487ad19a236e..547512028e24 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -225,6 +225,19 @@ static u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
> >  {
> >  	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
> >  
> > +	/*
> > +	 * A sample_period of 1 might get mistaken by perf for a BTS event, see
> > +	 * intel_pmu_has_bts_period(). This would prevent re-arming the counter
> > +	 * via pmc_resume_counter(), followed by the accidental creation of an
> > +	 * actual BTS event, which we do not want.
> > +	 *
> > +	 * Avoid this by bumping the sampling period. Note, that we do not lose
> > +	 * any precision, because the same quirk happens later anyway (for
> > +	 * different reasons) in x86_perf_event_set_period().
> > +	 */
> > +	if (sample_period == 1)
> > +		sample_period = 2;
> > +
> >  	if (!sample_period)
> >  		sample_period = pmc_bitmask(pmc) + 1;
> >  	return sample_period;
> 
> Oh gawd, I so hate this kvm code. It is so ludicrously bad. The way it
> keeps recreating counters is just stupid. And then they complain it
> sucks, it does :-(
> 
> Anyway, yes this is terrible. Let me try and untangle all this, see if
> there's a saner solution.

Does something like so work? It is still terrible, but perhaps slightly
less so.

diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 2b969386dcdd..493e6ba51e06 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1558,13 +1558,22 @@ static inline bool intel_pmu_has_bts_period(struct perf_event *event, u64 period
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int hw_event, bts_event;
 
-	if (event->attr.freq)
+	/*
+	 * Only use BTS for fixed rate period==1 events.
+	 */
+	if (event->attr.freq || period != 1)
+		return false;
+
+	/*
+	 * BTS doesn't virtualize.
+	 */
+	if (event->attr.exclude_host)
 		return false;
 
 	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
 	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
-	return hw_event == bts_event && period == 1;
+	return hw_event == bts_event;
 }
 
 static inline bool intel_pmu_has_bts(struct perf_event *event)

