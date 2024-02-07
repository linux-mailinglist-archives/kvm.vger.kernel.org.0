Return-Path: <kvm+bounces-8246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C36984CE9E
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 17:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6D172856B0
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BF17FBDE;
	Wed,  7 Feb 2024 16:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hes8HIdE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2480056
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707322137; cv=none; b=F/chgogVY03ekcz/g9tX3vbY27BVQAU0bpyhssrI+e0GOx5rFVjriOhTC+2hP4R2Iwj+GD1CGP1GpF/XxLp9sjQwUzGxXSI0lKfsWUZoQ40LcqnRMBTQy9rV9Vo6x4Ejq60Xvas8H5JVpYqOe4Oe1BvGp+tNEqu/jUXVw5uL+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707322137; c=relaxed/simple;
	bh=b6Pbg0aSosy9STDoBERpFBWvqP2/G4p3nZSShoKz0EA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RPv3BvOPRNY4p9PtgOyiRRezHXIneAQf2zWf3EIbD3AmyQ0iVYmEktsxMiefHYOEVJqU2KB3nwAt+Wc2gdBS/xL839Qj8WU89+N6bby+yxyblWQxOO71weNiInNr68pq9MR+Xe1LizxytsUqCiUwSwAZDZawo4g8N8m6tBfScDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hes8HIdE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6df2b2d1aso1030756276.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 08:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707322134; x=1707926934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b6Pbg0aSosy9STDoBERpFBWvqP2/G4p3nZSShoKz0EA=;
        b=Hes8HIdExo5hJfKu7G1taJvHisMdFqJ0TM3RtEQZ63NsbKXrEjkO1+YTQa1uTvhfiw
         jB1/5h3x4Q9uI/RoSHXQb+jRtTilb+X/8sjVD9pMJI6984Cugjg+cTvgmpL4dwwD2SkD
         bXAmq3JBmuwMGu8yiPPqSOzy5MFuyLYXmjAdpPmSodO8LJmpdWAtsGCrKBR0FysDb8zG
         ksjQcgfIVZ67tvHp72bj3m4wEV3XvdeLs/ZgkSXa1o4Jwv2D6Wcj0N3dzAc06qEvpahi
         AhXI06iOI+5P8p91phUyp/nX0VR2bUYjgPwvtuTX7R0HFcaYeSS5CYJL6/IIkMehZhfh
         ICFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707322134; x=1707926934;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b6Pbg0aSosy9STDoBERpFBWvqP2/G4p3nZSShoKz0EA=;
        b=YYsrrX0KsdSCLHSWpTHNY7DCMaqb6zRFxTuSqNb+geMePyTxlEk3+Bb+QeS4yHudLX
         +nIhKg3psb8SWZATltrzZ/7rp90YrBWHSzB6cSJZZJ0CBIrLWPmZ4Hx/NMogyi7og432
         qNhP56biqVRUxTi6k33Dq9i1jEwttGkpsLieJZx6tfGY13/csMloFFI8SeUQHl439Nr9
         Kl5PVGWULeqqrKPQxmAr64uGyTUpHQPY07gAY/M7vCie5LcNpnKglZMFRLjCxNF9yxT3
         vhBTYabJMnmo/+Mu/PS6enYOBSV8bNIPqMJc5xnCvJ23x/h5tGWKxOZCppHIf8ldZ4lY
         3Hzw==
X-Gm-Message-State: AOJu0YwZGtH4Uw+rPmqMqwaZ6mDGpl2rEvJam5mhNWVyNiF+9oCUnEsi
	dJpABjX2Tq5qZGjKbs8kRETAQxoNLKAczEk8/aWhevBDY4SHy5PaMbB08ZSzLqyjbcRw0NkNRh8
	9gw==
X-Google-Smtp-Source: AGHT+IFo7vSX32978mHp9DuIV/CuPmJCEwqoVvO8kVgUZkqtVinWNB21gS0NfuMw8kBxSh/qL8E88+WZRgE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2293:b0:dc6:207c:dc93 with SMTP id
 dn19-20020a056902229300b00dc6207cdc93mr194834ybb.2.1707322134581; Wed, 07 Feb
 2024 08:08:54 -0800 (PST)
Date: Wed, 7 Feb 2024 08:08:52 -0800
In-Reply-To: <afc496b886bc46b956ede716d8db6f208e7bab0a.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <afc496b886bc46b956ede716d8db6f208e7bab0a.camel@infradead.org>
Message-ID: <ZcOrFOPKekcDq3xe@google.com>
Subject: Re: [PATCH v3] KVM: x86/xen: improve accuracy of Xen timers
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, 
	Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> A test program such as http://david.woodhou.se/timerlat.c=C2=A0confirms u=
ser
> reports that timers are increasingly inaccurate as the lifetime of a
> guest increases. Reporting the actual delay observed when asking for
> 100=C2=B5s of sleep, it starts off OK on a newly-launched guest but gets
> worse over time, giving incorrect sleep times:
>=20
> root@ip-10-0-193-21:~# ./timerlat -c -n 5
> 00000000 latency 103243/100000 (3.2430%)
> 00000001 latency 103243/100000 (3.2430%)
> 00000002 latency 103242/100000 (3.2420%)
> 00000003 latency 103245/100000 (3.2450%)
> 00000004 latency 103245/100000 (3.2450%)
>=20
> The biggest problem is that get_kvmclock_ns() returns inaccurate values
> when the guest TSC is scaled. The guest sees a TSC value scaled from the
> host TSC by a mul/shift conversion (hopefully done in hardware). The
> guest then converts that guest TSC value into nanoseconds using the
> mul/shift conversion given to it by the KVM pvclock information.
>=20
> But get_kvmclock_ns() performs only a single conversion directly from
> host TSC to nanoseconds, giving a different result. A test program at
> http://david.woodhou.se/tsdrift.c=C2=A0demonstrates the cumulative error
> over a day.
>=20
> It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
> that. The actual guest hv_clock is per-CPU, and *theoretically* each
> vCPU could be running at a *different* frequency. But this patch is
> needed anyway because...
>=20
> The other issue with Xen timers was that the code would snapshot the
> host CLOCK_MONOTONIC at some point in time, and then... after a few
> interrupts may have occurred, some preemption perhaps... would also read
> the guest's kvmclock. Then it would proceed under the false assumption
> that those two happened at the *same* time. Any time which *actually*
> elapsed between reading the two clocks was introduced as inaccuracies
> in the time at which the timer fired.
>=20
> Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
> host TSC just *once*, then use the returned TSC value to calculate the
> kvmclock (making sure to do that the way the guest would instead of
> making the same mistake get_kvmclock_ns() does).
>=20
> Sadly, hrtimers based on CLOCK_MONOTONIC_RAW are not supported, so Xen
> timers still have to use CLOCK_MONOTONIC. In practice the difference
> between the two won't matter over the timescales involved, as the
> *absolute* values don't matter; just the delta.
>=20
> This does mean a new variant of kvm_get_time_and_clockread() is needed;
> called kvm_get_monotonic_and_clockread() because that's what it does.
>=20
> Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---

Dagnabbit, this one is corrupt too :-/

