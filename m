Return-Path: <kvm+bounces-36183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 548EBA18612
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E903C188B2E4
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A9F1F76AF;
	Tue, 21 Jan 2025 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dHZ1QRxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AA44594A
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737490943; cv=none; b=EXV2JjEqvfrKi8nQ0pBPW/yGCCEaG/gvyz7GspZjCwTKknh3X+X8GiSI07xbYN9TWYSJCPJJbNBzzwzIWdHs/L+n66oGVfteh5UPikW/JKPLYLlR6x4n3ngi2NDQd+clSDvUMoPcY0DRQgeky66haDOreaBzs5gUWIn0YvgLAlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737490943; c=relaxed/simple;
	bh=sfsa44dx/GiptBaBDheJxLaUrkCXXBtCxm8xhPPGxgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UKBtN/s5deKSne31xA+js5+Bam8X9al5u8+iLH2bOWUPmbCqvt/1hw3O4FBqC51fvvMAtmMoDjrGcke7Vgu4XKCAg9+ZYkd6iNGyHCfKxkfOvSVWc7azWkmWb6EcP2hnySqIIiAXyt0Z94sy5FXvUCuA7qBm8hWMDTNKglLAmWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dHZ1QRxk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so16731844a91.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737490941; x=1738095741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2osgii321xHdpLF27fV8JrRroiYrHnwk/f4sg35AhRk=;
        b=dHZ1QRxkzo7aOvqT+5JqEp1EzO3S5rq+BvsEqyzAoBYQ0J7jGnVYprZeEufyD6KFQv
         71db7toqHeJxF3gSeApPs4yHubfcWFcvPiWTQNUnPXMH6czH+9TFVBADBUqEwVt/R4p5
         /vprAE6nM1heFt6fEFE6Y6bLhbn4IPkeYQzmRFVHv5jIOlEqr6ap0ffiiMqRws6we9uM
         N6ZP1zA6ZVvtetjaNw25GG7zkvdljXRgNCvfmGmK5n881NcQiJyv20t5EoAMz0SBajDE
         dC+yP709ycENfl5goBg4AqkJJz1OIOdhCdLfNqet16KYQPrHEWfXeQ69tYMDJr7ryGOi
         p/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737490941; x=1738095741;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2osgii321xHdpLF27fV8JrRroiYrHnwk/f4sg35AhRk=;
        b=f8pjdCM7+g2SsGh5AHtxY99wcNN4JSEsEFgmOvk7MyawLlV+Fy/KJM8zRQoVoSncep
         16H/kd7UibAuMi8XIMPIencMhbgCUgMWcQDEKWzqcrRBUdCIK8dR5aVI5c9pCUycxIeV
         EwCWChefJfZVGR2jPvJkfKSCW5U2HeMqDTrxCcZz/zJUJNhMewNs4kDWLrAHtUZ8L6rn
         RgxtJKX1mQc+TFqd3skZkr2umbVco3es+3WyL8fNXXdVvYtF/ibYh21cN7tO6cqj9IFU
         slHj0dEem6bzfup4ZpVXWPOPnbUTHTlPUeHtT5BG/WAoF6eqIQP631LBvxl3gnWMrb/3
         hj/w==
X-Forwarded-Encrypted: i=1; AJvYcCU9BgJhRG9wq15ZNWqFQ7kOPQjj8dMKScu/ayc4EG+ePSWOXosTS7QBa4VFDxkdXzr7G34=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHSbAfUNnuyEFz6KZrr4aXRdH2A6k4hoNDQFv6PC80u4IM+CnS
	jH4PrRoEAiltsuUZYAiJrPftkLPFgzasZQmJwiLVBDT8BSRYt1/khwJjMyQ5SffqykoS68JPsRb
	9OQ==
X-Google-Smtp-Source: AGHT+IGOO1hQm82zN2yLyHv2/gNy5MzjEdUJWiR6aEsp7kYlEQk+WqNPkZqP5BDJYL9539mV7ehRamkJ6+E=
X-Received: from pfxa2.prod.google.com ([2002:a05:6a00:1d02:b0:72d:afb3:3a2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8c6:b0:725:4615:a778
 with SMTP id d2e1a72fcca58-72dafa015e7mr27416427b3a.7.1737490941329; Tue, 21
 Jan 2025 12:22:21 -0800 (PST)
Date: Tue, 21 Jan 2025 12:22:19 -0800
In-Reply-To: <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com> <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
Message-ID: <Z5AB-6bLRNLle27G@google.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025, Suleiman Souhlal wrote:
> On Sat, Jan 18, 2025 at 1:52=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > In short, AFAICT the issues you are observing are mostly a problem with=
 kvmclock.
> > Or maybe it's the other way around and effectively freezing guest TSC i=
s super
> > problematic and fundamentally flawed.
> >
> > Regardless of which one is "broken", unconditionally accounting suspend=
 time to
> > steal_time will do the wrong thing when sched_clock=3Dtsc.  To further =
muddy the
> > waters, current Linux-as-a-guest on modern hardware will likely use clo=
cksource=3Dtsc,
> > but sched_clock=3Dkvmclock.  In that scenario, guest time doesn't advan=
ced, but
> > guest scheduler time does.  Ugh.
> >
> > That particular wart can be avoided by having the guest use TSC for sch=
ed_clock[*],
> > e.g. so that at least the behavior of time is consistent.
> >
> > Hmm, if freezing guest time across suspend is indeed problematic, one t=
hought
> > would be to put the onus on the VMM/user to not advertise a "nonstop TS=
C" if the
> > host may be suspending.  The Linux-as-a-guest would prefer kvmclock ove=
r TSC for
> > both clocksource and sched_clock.
> >
> > [*] https://lore.kernel.org/all/Z4gqlbumOFPF_rxd@google.com
>=20
> I see what you're saying. Thanks for explaining.
>=20
> To complicate things further there are also different kinds of
> suspends. From what I've seen "shallow" (and/or "suspend-to-idle")
> suspends don't stop the CPU, at least on our machines, so the host TSC
> keeps ticking. On "deep" suspends, on the other hand, the TSC might go
> backwards.

Yeah, only S3 and lower will power down the CPU.  All bets are off if the C=
PU
doesn't have a nonstop TSC, but that's not at all unique to suspend, e.g. i=
t's a
problem if the CPU goes idle, and so I think it's safe to only worry about =
CPUs
with nonstop TSC.

> But I suppose if the guest uses kvmclock the behavior should be the
> same in either case.
>=20
> At least for our use case we would definitely want guest *wall* time
> to keep advancing, so we would still want to use kvmclock.
>=20
> Would accounting the suspend duration in steal time be acceptable if
> it was conditional on the guest using kvmclock?
> We would need a way for the host to be notified that the guest is
> indeed using it,

And not just using kvmclock, but specifically using for sched_clock.  E.g. =
the
current behavior for most Linux guests on modern hardware is that they'll u=
se TSC
for clocksource, but kvmclock for sched_clock and wall clock.

> possibly by adding a new MSR to be written to in
> kvm_cs_enable().

I don't think that's a good way forward.  I expect kvmclock to be largely
deprecated (guest side) in favor of raw TSC (with hardware-provided scale+o=
ffset),
at which point tying this to kvmclock puts us back at square one.

Given that s2idle and standby don't reset host TSC, I think the right way t=
o
handle this conundrum is to address the flaw that's noted in the "backwards=
 TSC"
logic, and adjust guest TSC to be fully up-to-date in the S3 (or lower) cas=
e.

	 * ......................................  Unfortunately, we can't
	 * bring the TSCs fully up to date with real time, as we aren't yet far
	 * enough into CPU bringup that we know how much real time has actually
	 * elapsed; our helper function, ktime_get_boottime_ns() will be using boo=
t
	 * variables that haven't been updated yet.

I have no idea why commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to=
 S4
suspend") hooked kvm_arch_enable_virtualization_cpu() instead of implementi=
ng a
PM notifier, but I don't see anything that suggests it was deliberate, i.e.=
 that
KVm *needs* to effectively snapshot guest TSC when onlining CPUs.

If that wart is fixed, then both kvmclock and TSC will account host suspend=
 time,
and KVM can safely account the suspend time into steal time regardless of w=
hich
clock(s) the guest is using.

