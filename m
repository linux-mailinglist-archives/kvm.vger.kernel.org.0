Return-Path: <kvm+bounces-65652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1537BCB2CCB
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 12:17:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24E4A300D654
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 11:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC78026981E;
	Wed, 10 Dec 2025 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nTnfrDNW"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CA2AEF5;
	Wed, 10 Dec 2025 11:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765365438; cv=none; b=lX4C/pI0PiNNk67q8KtBgUoSSrNlQblopb8wovvsfMPcqZJrg94YK7xOG9bwhOm/yQYnmU5OtFhiU/AD6OJG68Z1w3CoSkwUarKlzAHOFAKYpX/OheaRs9/ssH1AKnMZSm7Pl6J6kEqYPiteU5ua8aORuBK9dB7GBiNGOWVOghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765365438; c=relaxed/simple;
	bh=ZzMI9Yz+prlZhwZGR1FXlY/yFrWepGXV2CWoNm4Nbmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AjEWTOaCceahiQz5hRn68g79mcuWXM/iMIh05oDwMOb2AGz3nQJzwvZWXRv9r27Nhyhp7l6xhdcRg2NhwFzuw8kPH9iW1p+/uPuAIpiOStzmeAsDIfn4bFQBGFIi5CYpZMgawuT8qsoAIDhoVmjoQm3bqUigAl/FQRbC6pQhvX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nTnfrDNW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ks6k3NdN4uI/TI255dpKtGcQF9B19neoPARrlPX/NQQ=; b=nTnfrDNWSdURYmE2rWVunzXOdS
	hpzJqUHwCDVl9R1Mfza1ipT8VhcslIf769cwm5/MzRyrNJBUWekmSZFMFn3DWBaUVwtYpjuA/tDbs
	vqJwr0tuFI5aBRUgaiIBDXF1W8rbykUh0iyRF2WZeCauSUyuKskSK/QL8zU4BsuWBXJpTAxWs2xFP
	m7zTxGNmP1QHADSF1tGeR0OdUZRN+WxGsIX+AzQe4Qfpk7CIGbII/esDArnKMHorlb/ZKTNA0Na1f
	tqF0ZwKDj/Nj4cpoZBtZxRiaDd0biCsHWeX0e1WH0gvZ96vQKsJWiHcPVmRzWP+NCr+WkD93jfd5C
	ULMtWVjA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTIBk-0000000ClU1-37Dx;
	Wed, 10 Dec 2025 11:16:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8765A302EC2; Wed, 10 Dec 2025 12:16:55 +0100 (CET)
Date: Wed, 10 Dec 2025 12:16:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fernand Sieber <sieberf@amazon.com>
Cc: abusse@amazon.de, bp@alien8.de, dave.hansen@linux.intel.com,
	dwmw@amazon.co.uk, hborghor@amazon.de, hpa@zytor.com,
	jschoenh@amazon.de, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, mingo@redhat.com,
	nh-open-source@amazon.com, nsaenz@amazon.com, pbonzini@redhat.com,
	seanjc@google.com, stable@vger.kernel.org, tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Message-ID: <20251210111655.GB3911114@noisy.programming.kicks-ass.net>
References: <20251201142359.344741-1-sieberf@amazon.com>
 <20251202100311.GB2458571@noisy.programming.kicks-ass.net>
 <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
 <20251210101147.139674-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210101147.139674-1-sieberf@amazon.com>

On Wed, Dec 10, 2025 at 12:11:47PM +0200, Fernand Sieber wrote:

> > Does something like so work? It is still terrible, but perhaps slightly
> > less so.
> >
> > diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
> > index 2b969386dcdd..493e6ba51e06 100644
> > --- a/arch/x86/events/perf_event.h
> > +++ b/arch/x86/events/perf_event.h
> > @@ -1558,13 +1558,22 @@ static inline bool intel_pmu_has_bts_period(struct perf_event *event, u64 period
> >  	struct hw_perf_event *hwc = &event->hw;
> >  	unsigned int hw_event, bts_event;
> >
> > -	if (event->attr.freq)
> > +	/*
> > +	 * Only use BTS for fixed rate period==1 events.
> > +	 */
> > +	if (event->attr.freq || period != 1)
> > +		return false;
> > +
> > +	/*
> > +	 * BTS doesn't virtualize.
> > +	 */
> > +	if (event->attr.exclude_host)
> >  		return false;
> >
> >  	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
> >  	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
> >
> > -	return hw_event == bts_event && period == 1;
> > +	return hw_event == bts_event;
> >  }
> >
> >  static inline bool intel_pmu_has_bts(struct perf_event *event)
> 
> Hi Peter,
> 
> I've pulled your changes and confirmed that they address the original
> bug report.
> 
> The repro I use is running on host, with a guest running:
> `perf record -e branches:u -c 2 -a &`
> `perf record -e branches:u -c 2 -a &`
> Then I monitor the enablement of BTS on the host and verify that without
> the change BTS is enabled, and with the change it's not.
> 
> This looks good to me, should we go ahead with your changes then?

Yeah, I suppose. Please stick a coherent changelog on and repost.

