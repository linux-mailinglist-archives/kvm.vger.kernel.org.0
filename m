Return-Path: <kvm+bounces-65650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AF6CB2A4A
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 11:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F93A30715D9
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 10:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B84309EEB;
	Wed, 10 Dec 2025 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="m3p0wm55"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C02F9D94;
	Wed, 10 Dec 2025 10:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.57.120.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361554; cv=none; b=sQKiEyoRmoOBW/+ndlxN3+DtKb+VT3IXmg/e8ANUi6LA8fe+Jwx1v92ibmxud6nx7pvrUBRhYxXVcVmhS+gHOfmIIVR+CwPiYhlZ/0bWXrfTHtQ3hacxPSlVNmXdL2NHi725ilzlNL/9z6sgSRKcycXRSF5YUoTk8laiFkkP3SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361554; c=relaxed/simple;
	bh=S/O3YqefQKXR05d+gG30fRGzvuwlDSO+8pa0rD4W38s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZWBxcS6kK7qvcTNhA0G2ugm4TLPTRZaFqetUswWH8+YqxUzXmOSso5gLGal3j5StHjVTR+8/TgF0uTii1YW1jY4bwOdykVIiAhYTp2k6rxE2nN1c5ZWomK9wNkclwI+cKY141LhMo5s0IDaGqRN5xSzEfv16pCuAOnlfgiduhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=m3p0wm55; arc=none smtp.client-ip=52.57.120.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1765361552; x=1796897552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jd+KiXAoKFN9/zgzQvBameA8MGSW2F2LlWJJK0vBbS4=;
  b=m3p0wm55lTfkl+uVQ0FMxsybLa1g5eVIIo/TeUZlBeUm0FipMLKjID3W
   gTpV4eatNUhLrhR0otjBDnADRa+PUll4WGD9Lrkx8QzstcDTWLbAYe4nv
   iZ4RZ9Wr2/h4Pen/xZM1XzVoMJeKdRupRchoC0Qi3CRgyMXd7lWTqZKfi
   FxBggoyjF00Us9bSFiFCk4EPqkKeSzF3Ma63cR35jSzhagC8rJHYzc2KV
   6KRm4tyz+RiHPLF3vzhksgo4eWMqoefP02dyWKv8yChXxJLitxXK0tIN7
   8arGoYVzNse/MO/9lilRgZ+OLuFncps8jtxPqjrFMOkd/3cSB7Ea9gAIw
   Q==;
X-CSE-ConnectionGUID: cHcS0sOFRb+vLqIUIU52LQ==
X-CSE-MsgGUID: w3K8DJA5SMCAe44sf0LrEA==
X-IronPort-AV: E=Sophos;i="6.20,263,1758585600"; 
   d="scan'208";a="6397635"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 10:12:14 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:8674]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.31.164:2525] with esmtp (Farcaster)
 id 5330ea93-bfde-4547-8bd2-6d3857b49658; Wed, 10 Dec 2025 10:12:14 +0000 (UTC)
X-Farcaster-Flow-ID: 5330ea93-bfde-4547-8bd2-6d3857b49658
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 10 Dec 2025 10:12:13 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.222) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 10 Dec 2025 10:12:04 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <peterz@infradead.org>
CC: <abusse@amazon.de>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<dwmw@amazon.co.uk>, <hborghor@amazon.de>, <hpa@zytor.com>,
	<jschoenh@amazon.de>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <nh-open-source@amazon.com>, <nsaenz@amazon.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <sieberf@amazon.com>,
	<stable@vger.kernel.org>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Date: Wed, 10 Dec 2025 12:11:47 +0200
Message-ID: <20251210101147.139674-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
References: <20251201142359.344741-1-sieberf@amazon.com> <20251202100311.GB2458571@noisy.programming.kicks-ass.net> <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 02, 2025 at 01:44:23PM +0100, Peter Zijlstra wrote:
> On Tue, Dec 02, 2025 at 11:03:11AM +0100, Peter Zijlstra wrote:
> > On Mon, Dec 01, 2025 at 04:23:57PM +0200, Fernand Sieber wrote:
> > >  arch/x86/kvm/pmu.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > > index 487ad19a236e..547512028e24 100644
> > > --- a/arch/x86/kvm/pmu.c
> > > +++ b/arch/x86/kvm/pmu.c
> > > @@ -225,6 +225,19 @@ static u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
> > >  {
> > >  	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
> > >
> > > +	/*
> > > +	 * A sample_period of 1 might get mistaken by perf for a BTS event, see
> > > +	 * intel_pmu_has_bts_period(). This would prevent re-arming the counter
> > > +	 * via pmc_resume_counter(), followed by the accidental creation of an
> > > +	 * actual BTS event, which we do not want.
> > > +	 *
> > > +	 * Avoid this by bumping the sampling period. Note, that we do not lose
> > > +	 * any precision, because the same quirk happens later anyway (for
> > > +	 * different reasons) in x86_perf_event_set_period().
> > > +	 */
> > > +	if (sample_period == 1)
> > > +		sample_period = 2;
> > > +
> > >  	if (!sample_period)
> > >  		sample_period = pmc_bitmask(pmc) + 1;
> > >  	return sample_period;
> >
> > Oh gawd, I so hate this kvm code. It is so ludicrously bad. The way it
> > keeps recreating counters is just stupid. And then they complain it
> > sucks, it does :-(
> >
> > Anyway, yes this is terrible. Let me try and untangle all this, see if
> > there's a saner solution.
>
> Does something like so work? It is still terrible, but perhaps slightly
> less so.
>
> diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
> index 2b969386dcdd..493e6ba51e06 100644
> --- a/arch/x86/events/perf_event.h
> +++ b/arch/x86/events/perf_event.h
> @@ -1558,13 +1558,22 @@ static inline bool intel_pmu_has_bts_period(struct perf_event *event, u64 period
>  	struct hw_perf_event *hwc = &event->hw;
>  	unsigned int hw_event, bts_event;
>
> -	if (event->attr.freq)
> +	/*
> +	 * Only use BTS for fixed rate period==1 events.
> +	 */
> +	if (event->attr.freq || period != 1)
> +		return false;
> +
> +	/*
> +	 * BTS doesn't virtualize.
> +	 */
> +	if (event->attr.exclude_host)
>  		return false;
>
>  	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
>  	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>
> -	return hw_event == bts_event && period == 1;
> +	return hw_event == bts_event;
>  }
>
>  static inline bool intel_pmu_has_bts(struct perf_event *event)

Hi Peter,

I've pulled your changes and confirmed that they address the original
bug report.

The repro I use is running on host, with a guest running:
`perf record -e branches:u -c 2 -a &`
`perf record -e branches:u -c 2 -a &`
Then I monitor the enablement of BTS on the host and verify that without
the change BTS is enabled, and with the change it's not.

This looks good to me, should we go ahead with your changes then?

--Fernand



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


