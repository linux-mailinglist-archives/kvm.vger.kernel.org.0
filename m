Return-Path: <kvm+bounces-65122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEE3C9C133
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 754F73A4C14
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A712727F5;
	Tue,  2 Dec 2025 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="masZH/aq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866DF263F52
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691410; cv=none; b=e8d8JDEn/8sLrkJFqxgGDTcrc+m+diPONX/vjhUMR6VwzyOoCNI3uko0pfuo2ZAkZfebrHipXCZkufkL+DG8P3ZA8vfo4afA/Wr+RgbS/Y+0GGI4mcX+kK++kMM4zxpZP/s3LB1Oh1bhw0l+GI8HiIff1Ma6Blsh11skDiOo3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691410; c=relaxed/simple;
	bh=qRYb2UuLMho7adIKiGqSJm3f0QgiMpUF9tCgxUcb1ls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EUwHuEu0IrQruwPL9cjU8jkPgKfqgP/vlWV4fXoLihYQlsLxR93/r5HiMY3M7XtmyoWa81dsNHODt75ha/s3xzPxGrXHIn0gcrbjGZYVogs76PbgZyMlsLANOhq+O55MRmakNPLPCx0R8VJwW2YYZVzAEDq3D1eCw7Z2opSsNx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=masZH/aq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso5620534a91.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 08:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764691408; x=1765296208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7h65javEKiZCilvi53EqrbcCyqwHMbAxO5ZzdpYHZ2Q=;
        b=masZH/aqlMEUaLDkXB46XPz6/Tw58M9bfX7tPa37CMc35hdprpAhQH8fi2syvRE2CH
         Rmo30Tag66rhRj8cwfXYrKKJS0DXuI3b3pYpVAHJgWeOa/7ihsaqQqOIVmbJzZuHZ99f
         IEYLqNa+VZpHtdl58LrkXcHm0KHD2bYqNEjsZd5U2hc3G1Q0FVWWCOHl1UahzlkFrl1C
         7dniGt15KRjnQBnpvyVp5Z3gRhszx/Lco2f6mU3cTmsIfGMlC9dBiTMhDq1SF54H0W6z
         0HscIHluBmCaiBJyIk7kL3x11yepDNgxtR/i7QB1UWi9dsvff/w9R8o5/E8gP5l51wQ5
         Fk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691408; x=1765296208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7h65javEKiZCilvi53EqrbcCyqwHMbAxO5ZzdpYHZ2Q=;
        b=JZXrP7lEMFWxN4st5cbB8Rklmu2eGLT/EgnJu3QTP1cB2fifR3rZLxKJiJcWg2Y0bD
         bBUvQXkqd/rgPdprOzXt/9ZdLNcDBq+Lj/S2NwXWHQqYP00nU0oqc5fCLTIfPX8vcX+L
         ynPpbd4/Vn6OTTKVPEUscUVFH3Z7M8xr+7B6AJTXPSxnoFkwY7Ygje75XFJOLt7mX4XC
         X6uP8lprE+ag7JukzHtSCG9VNmiRc+4AUekSAFQ8t9hqQfkQv1vrDxHKXiNRJiEOLJWq
         WCFpiUSGffft6XQOHvlFv6TT+ZSSysc0ZzzdNJdmxMxw2jRQZ8WyRyn9ehfHSMDU9wI9
         JKAA==
X-Forwarded-Encrypted: i=1; AJvYcCXWuCwc1yoj61ZYuel4a60enwT2uSfnruqFeZeyZqsIdl5OWDr07vuBLBoJTmE7+BV/qo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw7DSD/prsn5xVCmhE/lFAXnA1EYVpxMswZZMrxCaR6DdKOXfr
	D4TXafb4vMGTkObclfQPw+sEsq6JyD5ujKqWNpO5gSIkychqUAHlFrAyMCAuam5P0lpy2gUVFrp
	yHfGmog==
X-Google-Smtp-Source: AGHT+IHgZDUiSW6QxjIjcAOYgkuyQjls1DupsHMaqWae+TriC3tvVF94Ipa05PoU8Re45MZOfysmDED4NVs=
X-Received: from pjbca18.prod.google.com ([2002:a17:90a:f312:b0:32b:ae4c:196c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5605:b0:340:bc27:97bd
 with SMTP id 98e67ed59e1d1-3475ebf93b2mr25169788a91.9.1764691407827; Tue, 02
 Dec 2025 08:03:27 -0800 (PST)
Date: Tue, 2 Dec 2025 08:03:26 -0800
In-Reply-To: <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251201142359.344741-1-sieberf@amazon.com> <20251202100311.GB2458571@noisy.programming.kicks-ass.net>
 <20251202124423.GC2458571@noisy.programming.kicks-ass.net>
Message-ID: <aS8Nzomxsy5S4AQ-@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fernand Sieber <sieberf@amazon.com>, pbonzini@redhat.com, 
	"Jan =?utf-8?Q?H=2E_Sch=C3=B6nherr?=" <jschoenh@amazon.de>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw@amazon.co.uk, 
	hborghor@amazon.de, nh-open-source@amazon.com, abusse@amazon.de, 
	nsaenz@amazon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 02, 2025, Peter Zijlstra wrote:
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

Ya, this seems like the right fix.  Pulling in the original bug report:

  When BTS is enabled, it leads to general host performance degradation to both
  VMs and host.

I assume the underlying problem is that intel_pmu_enable_bts() is called even
when the event isn't enabled in the host, and BTS doesn't discrimate once it's
enable and bogs down the host (but presumably not the guest, at least not directly,
since KVM should prevent setting BTS in vmcs.GUEST_IA32_DEBUGCTL).  Enabling BTS
for exclude-host events simply can't work, even if the event came from host userspace.

