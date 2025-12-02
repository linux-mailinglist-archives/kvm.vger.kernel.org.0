Return-Path: <kvm+bounces-65098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB26C9B051
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8962D3425F0
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6E930C619;
	Tue,  2 Dec 2025 10:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CG8IqUlc"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A4F1FD4;
	Tue,  2 Dec 2025 10:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764669801; cv=none; b=OWVpgb8KogRV974ZVtc6/DzmY244Hrl6Lwd2+nAYOSHXcO2z1jjOJCnObAO42Z53W//rDhc8NkyDIkLCiXe9+e5UzIUxuobL6hx3s0J0BwTEnlZwE/IZ0Ux0Yf1L+rHd6i534X0ZzZQFZ4bTgFsE86nnVmS/YL2MeZu1Cz/4AeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764669801; c=relaxed/simple;
	bh=baGKa1XZNUY2H5uoBkIcxSscJvGmAf9m6Us1rQQ3eqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVJWwgsA12xcf0mItvZq9wOmyjy0g8vk2gqRA1dMaYB2yYHEMxCYl3KTTKYfI7BAFlsh1VHGwYhzvL28qFrZqqo7t7mGtQ1UzVs4KGpzHIQySGruQCedskNzsYoPYR2dI2dE/Q78GqUVdcyZDURfOBBlFn2MEyEBGkKJxnntYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CG8IqUlc; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G+XY79m/aCBsl7w4S+BulBgfrKCeg/78g+PXKcpubMU=; b=CG8IqUlcndLtV6OzdbA0qREplc
	5G1u/qlxNaolHpig2ViiatauQAqhgZR3FX1FfMO4Cr1Tbc7qPTPgeAxzIhQstY+UkzWsKPXdb+ouF
	hYvdJd6ZM4URTfLbwy/vzqAMmZSyIh1V9Vyg9xWiHj+00XYolB8azyDguMUluvOGhg1Qgbt6qV7xk
	9X/IkyspVyhehOWcwRH/Azq0EumFNcpRAON79XBrK0VIkCDcKM8zW1Ia96RQhPLOphRbrnLYcB4jF
	hlQgSrFLUzUWUwI0LeEZLvSqV+VrcRI4609DWXIGMBzzpYXpLgQn/1/4A/RVCFiELbWd+QXry59Wn
	yrY8vVQg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQMMR-000000003yi-1SAr;
	Tue, 02 Dec 2025 09:07:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 328D03005E0; Tue, 02 Dec 2025 11:03:11 +0100 (CET)
Date: Tue, 2 Dec 2025 11:03:11 +0100
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
Message-ID: <20251202100311.GB2458571@noisy.programming.kicks-ass.net>
References: <20251201142359.344741-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201142359.344741-1-sieberf@amazon.com>

On Mon, Dec 01, 2025 at 04:23:57PM +0200, Fernand Sieber wrote:
>  arch/x86/kvm/pmu.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 487ad19a236e..547512028e24 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -225,6 +225,19 @@ static u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>  {
>  	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
>  
> +	/*
> +	 * A sample_period of 1 might get mistaken by perf for a BTS event, see
> +	 * intel_pmu_has_bts_period(). This would prevent re-arming the counter
> +	 * via pmc_resume_counter(), followed by the accidental creation of an
> +	 * actual BTS event, which we do not want.
> +	 *
> +	 * Avoid this by bumping the sampling period. Note, that we do not lose
> +	 * any precision, because the same quirk happens later anyway (for
> +	 * different reasons) in x86_perf_event_set_period().
> +	 */
> +	if (sample_period == 1)
> +		sample_period = 2;
> +
>  	if (!sample_period)
>  		sample_period = pmc_bitmask(pmc) + 1;
>  	return sample_period;

Oh gawd, I so hate this kvm code. It is so ludicrously bad. The way it
keeps recreating counters is just stupid. And then they complain it
sucks, it does :-(

Anyway, yes this is terrible. Let me try and untangle all this, see if
there's a saner solution.

