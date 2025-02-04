Return-Path: <kvm+bounces-37208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6F9A26CF0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 08:58:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C890F165364
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 07:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66712063FF;
	Tue,  4 Feb 2025 07:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WyvJJIUx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696A7205E3B
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738655911; cv=none; b=n4y935sNIKnDkmetArnDhhxtl9CuiLNENXddt3j7vAc7KGAqZbM1QGhnwpAXgzgGEVMDvswlghE2v7Mk5vDb95eAhSgBdAklTrfBdJG/yOL31mSqdqT7p86qW3LhLsiywdPYsmpFuUQccHGLza6IsTKs3dvt5ItaSib42Mjm2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738655911; c=relaxed/simple;
	bh=WpVGtnVFRTc6n58BBzvAawZURCR8NYw/GenB/8vqGss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ryNFWBK5ovhWT1w1TjFIZWTw0875Ou6NsFgRh3V78t/HVe5TQH6eiPGA5xo+gATacnsOSaULCIBz6VTHWH61lAuPcyXozSC+2Y3OxSk41T2uvjYykNDGpb/nt/p1tptVuSns1Q2ekWyx0Mq/jk8nCt8ZwxBNKBy3sZftidHcwDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WyvJJIUx; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4678cce3d60so55039711cf.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 23:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738655908; x=1739260708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiXrPR2xXfkTqljxu4z94L8Ip1ipN2GMIvZnYSax9qw=;
        b=WyvJJIUxEs85gs97lkrBmSZqmNLZqhHimqjjxo5Mp0yMynnvowdKkUWgooFQ1rcg9j
         nImORSvkE6X4rI7YHCAF/Sh1hTMhTxdrtAvGb4tk932aH980qAzyy9sF/Lk14+ryT86F
         v4lHlwZmQ/Y/TA4fvdWSPl3m8CLXuaFJDlrPRqjMcykXvhvRe3asjLCgElfBlobQuJGy
         6smvRzLu/cn8FxRGZm89WUI66663REP65jYPFKmYiEeZC8mGiW0qJpYoUkcbQosYbmHr
         leDgU/eADVoSX2rw9Q057DcsB1dqy9ZBhpsbJYkGXiQgq42oPWIZR3IZ9jkanVpj9C1p
         2qCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738655908; x=1739260708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XiXrPR2xXfkTqljxu4z94L8Ip1ipN2GMIvZnYSax9qw=;
        b=dA2ZFKCsZRKmeQ9ViHkZxFrKFshazbea7X579x5M/WHs8xFtTtwJFbxk3DlMfwK4N2
         vRlCFXDXUR9LZRalLJIp03QcWY72y4xz5p0fhaDu2gCEpzs5NSBVLop4V7If1ruTq9ZO
         +VaLknR2Cu4N0DQSapxrlxzLHZR2ggYq2xuFYPyccIDsV/nbwe/8jEVYGSVGLk3axS/0
         jxcMbtQQqcYt74tW/vnbNrEhdxFdtburR7Nu0zq6lanAnT3N+csNtnKk54IfArIbOhsf
         +zNT6N3NcJVhpnCvVpzV8KAgQPNkGVG2yQQou7WAL394vE3DgAXf5kYOGC5MCMJdQyVf
         iVbg==
X-Forwarded-Encrypted: i=1; AJvYcCX2OHfoKq52s6w5YUbdIrCwQT/WUC28U4gcGjHane8I64H1JcMzTDBg0+vcob760psnSQk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9cjx9wOXAsbDvEnm5AEh0V9965YrlDkN5brP+uYFup8tArKfq
	U1V4VSSEPv7oQ4xyUTYiWZPjlZxNg/GvgNL5wlMVmAa+o0meDh3Z83jzyLQTAWPaDuZVlWb1OcU
	ijGjRPJD0Kuc0LyuFtHbA7IeMLPZijw1LfNfA
X-Gm-Gg: ASbGncstMldUxlW1MLR7OWoljY4J2onNoB7jgW1gup+05FPsCzEZyP3Pw90XnomZb6c
	yAmhp5bnGna9hE/TFE86iNM50Q7UJttEtXzTTVrt3Bqzs2QDHd10vRl81LUzlv9hD/pMjfsqr6w
	==
X-Google-Smtp-Source: AGHT+IHTIrAFs1xD38iTkLdSv6lbaUX6t3r909DZtF/mbm0wm+xk5lPFTbiwArxzHDHXRHsu2726slyElOb9NmzU9jA=
X-Received: by 2002:ac8:5713:0:b0:466:886f:3774 with SMTP id
 d75a77b69052e-46fd09e28f1mr306933821cf.8.1738655907978; Mon, 03 Feb 2025
 23:58:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com> <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
 <Z5AB-6bLRNLle27G@google.com>
In-Reply-To: <Z5AB-6bLRNLle27G@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Tue, 4 Feb 2025 16:58:16 +0900
X-Gm-Features: AWEUYZm23hx-Dkt13hsxp221MHOD76k5IiH6BRUJp63z5aATuOuh9Zi36Ky2saY
Message-ID: <CABCjUKB-4kvAg5U0D2O2aiTgfHnYx5qBTBEJJsK7edZY5g5eTQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 5:22=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 21, 2025, Suleiman Souhlal wrote:
> > On Sat, Jan 18, 2025 at 1:52=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > In short, AFAICT the issues you are observing are mostly a problem wi=
th kvmclock.
> > > Or maybe it's the other way around and effectively freezing guest TSC=
 is super
> > > problematic and fundamentally flawed.
> > >
> > > Regardless of which one is "broken", unconditionally accounting suspe=
nd time to
> > > steal_time will do the wrong thing when sched_clock=3Dtsc.  To furthe=
r muddy the
> > > waters, current Linux-as-a-guest on modern hardware will likely use c=
locksource=3Dtsc,
> > > but sched_clock=3Dkvmclock.  In that scenario, guest time doesn't adv=
anced, but
> > > guest scheduler time does.  Ugh.
> > >
> > > That particular wart can be avoided by having the guest use TSC for s=
ched_clock[*],
> > > e.g. so that at least the behavior of time is consistent.
> > >
> > > Hmm, if freezing guest time across suspend is indeed problematic, one=
 thought
> > > would be to put the onus on the VMM/user to not advertise a "nonstop =
TSC" if the
> > > host may be suspending.  The Linux-as-a-guest would prefer kvmclock o=
ver TSC for
> > > both clocksource and sched_clock.
> > >
> > > [*] https://lore.kernel.org/all/Z4gqlbumOFPF_rxd@google.com
> >
> > I see what you're saying. Thanks for explaining.
> >
> > To complicate things further there are also different kinds of
> > suspends. From what I've seen "shallow" (and/or "suspend-to-idle")
> > suspends don't stop the CPU, at least on our machines, so the host TSC
> > keeps ticking. On "deep" suspends, on the other hand, the TSC might go
> > backwards.
>
> Yeah, only S3 and lower will power down the CPU.  All bets are off if the=
 CPU
> doesn't have a nonstop TSC, but that's not at all unique to suspend, e.g.=
 it's a
> problem if the CPU goes idle, and so I think it's safe to only worry abou=
t CPUs
> with nonstop TSC.
>
> > But I suppose if the guest uses kvmclock the behavior should be the
> > same in either case.
> >
> > At least for our use case we would definitely want guest *wall* time
> > to keep advancing, so we would still want to use kvmclock.
> >
> > Would accounting the suspend duration in steal time be acceptable if
> > it was conditional on the guest using kvmclock?
> > We would need a way for the host to be notified that the guest is
> > indeed using it,
>
> And not just using kvmclock, but specifically using for sched_clock.  E.g=
. the
> current behavior for most Linux guests on modern hardware is that they'll=
 use TSC
> for clocksource, but kvmclock for sched_clock and wall clock.
>
> > possibly by adding a new MSR to be written to in
> > kvm_cs_enable().
>
> I don't think that's a good way forward.  I expect kvmclock to be largely
> deprecated (guest side) in favor of raw TSC (with hardware-provided scale=
+offset),
> at which point tying this to kvmclock puts us back at square one.
>
> Given that s2idle and standby don't reset host TSC, I think the right way=
 to
> handle this conundrum is to address the flaw that's noted in the "backwar=
ds TSC"
> logic, and adjust guest TSC to be fully up-to-date in the S3 (or lower) c=
ase.
>
>          * ......................................  Unfortunately, we can'=
t
>          * bring the TSCs fully up to date with real time, as we aren't y=
et far
>          * enough into CPU bringup that we know how much real time has ac=
tually
>          * elapsed; our helper function, ktime_get_boottime_ns() will be =
using boot
>          * variables that haven't been updated yet.
>
> I have no idea why commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due =
to S4
> suspend") hooked kvm_arch_enable_virtualization_cpu() instead of implemen=
ting a
> PM notifier, but I don't see anything that suggests it was deliberate, i.=
e. that
> KVm *needs* to effectively snapshot guest TSC when onlining CPUs.
>
> If that wart is fixed, then both kvmclock and TSC will account host suspe=
nd time,
> and KVM can safely account the suspend time into steal time regardless of=
 which
> clock(s) the guest is using.

I tried your suggestion of moving this to a PM notifier and I found
that it's possible for VCPUs to run after resume but before the PM
notifier has been called, because the resume notifiers get called
after tasks are unfrozen. Unfortunately that means that if we were to
do that, guest TSCs could go backwards.

However, I think it should be possible to keep the existing backwards
guest TSC prevention code but also use a notifier that further adjusts
the guest TSCs to advance time on suspends where the TSC did go
backwards. This would make both s2idle and deep suspends behave the
same way.

-- Suleiman

