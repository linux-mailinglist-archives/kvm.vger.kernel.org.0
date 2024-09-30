Return-Path: <kvm+bounces-27707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B623098AEF0
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 23:20:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CEE41F23500
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 21:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977691A2576;
	Mon, 30 Sep 2024 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JqxOLwmG";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="E3iwWgUO"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84117C7B6;
	Mon, 30 Sep 2024 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727731218; cv=none; b=cUcXFtRDvRTK/X12heigzBwbKS4Ys6h/S1NF9ngkKiUrhHYSV7IZhEBGvyDZp7cFAZbJfUXjcZX0phyZLc7XvnbmgR2L/TVXoJyLpJO7OG+mfHZZ5KMI7Wm8dNljrGCXu1emDf02DmyVS0bdygWE5BppRG7TI2vzj92UppnGa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727731218; c=relaxed/simple;
	bh=tY8XocEtgtVSdAPIezhDjjECcvAHq3nAVZmpJDnJL9s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aT/t4BM20g1wDbDVDqtQmHzRM/gruOnI3G79A/P/akp7fUPABjjfHrChWCwvvgafSGGmKbz5JEDPQk7beNM72b9R9Jyz71ux1cWiGUkiUlkS4e+JvPRQrVbj/6TgX+MEe7247wvoorgxrKvRY2xzgHs0PvM7pM7SIraA2nTDwHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JqxOLwmG; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=E3iwWgUO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1727731215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVrodz+zVYZqHTHz5n+k7AAFqLETeJjEjKXZHvgoB0I=;
	b=JqxOLwmG2pWJtkHKwi9eTbkC8aEqoukfcrT4mIHYwmjv8MNJouahg40RQrm7g3gI0jHj5M
	ujnBkdkKWe4P/3ag+sNTZOljjuuw0HcR8/91ep6saRvRSDbN4MX59FUC54pI1qqELLjGWx
	I00XlzhJcOFPv6FuVxCne8p9DL9zd0OVpXEL8QhJcpaYHqUrVaYX0fQAxeD3UCTj2eJS8p
	f412+joiU9gks7pok/rDn/TgjDs1/2J7T+xeU0xlIwjXoMQReGl5kuqaO0lb++ByBIcwru
	EkG8frFf9sBxFMjshIbCZYWBSEN7hNYVopOwAlDlvHNviO2A+vcOCaGcAVO6Lw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1727731215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVrodz+zVYZqHTHz5n+k7AAFqLETeJjEjKXZHvgoB0I=;
	b=E3iwWgUONvf3wmjcoDIGkl6chDOPaVvQDj48A9FONl4al4CY6txgJ5FpltYOPQUQjegeFP
	UfCETTVtz4JpUqCw==
To: "Nikunj A. Dadhania" <nikunj@amd.com>, Sean Christopherson
 <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 peterz@infradead.org, gautham.shenoy@amd.com
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC
 is available
In-Reply-To: <64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com>
 <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com>
 <Zu0iiMoLJprb4nUP@google.com>
 <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
 <ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com>
 <ZvQHpbNauYTBgU6M@google.com>
 <64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com>
Date: Mon, 30 Sep 2024 23:20:14 +0200
Message-ID: <87setgzvn5.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 30 2024 at 11:57, Nikunj A. Dadhania wrote:
> TSC Clock Rating Adjustment:
> * During TSC initialization, downgrade the TSC clock rating to 200 if TSC is not
>   constant/reliable, placing it below HPET.

Downgrading a constant TSC is a bad idea. Reliable just means that it
does not need a watchdog clocksource. If it's non-constant it's
downgraded anyway.

> * Ensure the kvm-clock rating is set to 299 by default in the 
>   struct clocksource kvm_clock.
> * Avoid changing the kvm clock rating based on the availability of reliable
>   clock sources. Let the TSC clock source determine and downgrade itself.

Why downgrade? If it's the best one you want to upgrade it so it's
preferred over the others.

> The above will make sure that the PV clocksource rating remain
> unaffected.
>
> Clock soure selection order when the ratings match:
> * Currently, clocks are registered and enqueued based on their rating.
> * When clock ratings are tied, use the advertised clock frequency(freq_khz) as a
>   secondary key to favor clocks with better frequency.
>
> This approach improves the selection process by considering both rating and
> frequency. Something like below:

What does the frequency tell us? Not really anything. It's not
necessarily the better clocksource.

Higher frequency gives you a slightly better resolution, but as all of
this is usually sub-nanosecond resolution already that's not making a
difference in practice.

So if you know you want TSC to be selected, then upgrade the rating of
both the early and the regular TSC clocksource and be done with it.

Thanks,

        tglx

