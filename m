Return-Path: <kvm+bounces-36086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C00A1770A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 06:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021AA16A58B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 05:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CD0199FBA;
	Tue, 21 Jan 2025 05:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gBFGwfnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D4B383
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 05:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737437885; cv=none; b=f6le6N2cI0jTllWqA6wBWjvZ1UsI/PSieFZNCSGxXAQPGVNqAlj/HwCKIU7ktwi0TssZim8HXp59kmXXN+65erl7tXdGjvs6o+I9QuxlDApNZtQ1WXkX+TvdC+FpWcCuMUaVdhUzU0/lOgkk6WRDS3eHrXiz9TWMdogUYE7NwfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737437885; c=relaxed/simple;
	bh=WUonKqdMpCOoJXylWgKKL0HWR6Kqr5oBuq3mD2lpdvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t82p1Qr4IyYylorgB8QGY4Slw6E2eQkMraHr2c1D7QCJXWVc7lYKauOBOqmx1ArbzgO0MXV/Nk9uFAebt1v46rFYMRiG/7gf1obT/hrvlSl+sEQYeQgW4VBO7cVcSiGMKCW9TKpbyaeM2NIJy9LhAeE9mMBIY/rYlKw5QxS/v1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gBFGwfnX; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-467a17055e6so60227601cf.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 21:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737437882; x=1738042682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hApkXbFMxZLsXTizlCKBKFEmZmeWLn29OK3OXjQI2U=;
        b=gBFGwfnXrBqzLNwypJFL9zawAFExanjlYbfNfR7VAo1yi3DQ6yF56r+wRnkTjxGyJQ
         k5M4H3LFG7Or6E8KjXNFdn/xIC7PdfUBW+jfDZPtAW+qCbX333FrnSlg/GUun2E44xhT
         Ld3s2UsxEqHbZM1UFOPAUDhft4MspPDyuq0AVM6ljXO+fztfX9yhs0YirqVHu15uTyZl
         29sro4En9ts3JHltUs2Wc9cm+q1ozUzbQF8UkX00v3kLPMp7vO4UCe6yM7wJ8JBD73dS
         RvTTvMfwMc3df1cN/cKxTTmPOms7+vAZr8o0vUXzN32SK425ByxU5vcfNhddyiyMgfq/
         PGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737437882; x=1738042682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hApkXbFMxZLsXTizlCKBKFEmZmeWLn29OK3OXjQI2U=;
        b=RPZBMs56grq2Wd4AgPPb7AsK+twUx9gThQLK/CvPuYKZ3G4rRM9OANfdMnpkVt4Umq
         kMUJexeOp7VXAnaRKnpg8EPtQOP4hGSpUihG+MBoxxC0PPKuc3xQBfdW7v9VmtzNrnz+
         PH3C01MQSuKf4TD8puawzn2vmdjo/q8JPryO9yXhv05m+Bjbb0ewMXziyen2XePFZdeE
         WvdeJTKTA7EwMp6YmDbbl9+SaIvSFOvaNtzL33sSusvW2uNAKhjlvX9BETOVYG0Lyxtl
         2Pcmi+usZ0zqo0LYIJ4djcBEIWP6jXG94b5b0if5V6lX6Br1a3oja76bkb9y/LtWeXGo
         VtIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVMac6/zQLqNlupUiRSzXJ05v0ySoxDhWH8wK23/fjaFmduj1QGo5XgiFd0pQE6JT1P+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlTXcLN6LHtKTLFU+ICeL1k33cw5MVJxzi2dXDAzfD0FDImH8F
	UMxrNwOBnnnYTrbuYN6Jy8wgFp4DcE8HecbhEYpcyOQfF/4C6L4r0yDFChp2UHLuNheDJccmUje
	NDBpG+9CObQvTSSVn9MRoflR0ce2nIQWCZpoc
X-Gm-Gg: ASbGncteV0jTUqnaHg6SFbVcELqDJnMxl11DhIE0GkfnERFH5Kj26idPLur0i/GTb3E
	Qaxc+ZatLRIbOuc7YI7p9DuvAl3fmhZZFh/DxN1kW6qBvo0h2sjx7QqSvZmrthReEjD/qUk18Jk
	oktLi/
X-Google-Smtp-Source: AGHT+IHbSzp3QiE0lkyqhctqFXrLQBEhMtub+uY8aeVlP9CEqccAymFh9QHqndw+z8IXOdhFUteI1bw1Yl5rhJjmm80=
X-Received: by 2002:a05:622a:2d5:b0:467:7441:2717 with SMTP id
 d75a77b69052e-46e12a40489mr265877951cf.19.1737437881887; Mon, 20 Jan 2025
 21:38:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com>
In-Reply-To: <Z4qK4B6taSoZTJMp@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Tue, 21 Jan 2025 14:37:50 +0900
X-Gm-Features: AbW1kvbSm0kCrrqMxpuh1Q0A93h8ZThxoiiJ5P9REEIgeB2rzzGQi9mCvgWri94
Message-ID: <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
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

On Sat, Jan 18, 2025 at 1:52=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 17, 2025, Suleiman Souhlal wrote:
> > On Thu, Jan 16, 2025 at 6:49=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > > > It returns the cumulative nanoseconds that the host has been suspen=
ded.
> > > > It is intended to be used for reporting host suspend time to the gu=
est.
> > >
> > > ...
> > >
> > > >  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> > > > +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> > > > +{
> > > > +     switch (state) {
> > > > +     case PM_HIBERNATION_PREPARE:
> > > > +     case PM_SUSPEND_PREPARE:
> > > > +             last_suspend =3D ktime_get_boottime_ns();
> > > > +     case PM_POST_HIBERNATION:
> > > > +     case PM_POST_SUSPEND:
> > > > +             total_suspend_ns +=3D ktime_get_boottime_ns() - last_=
suspend;
> > >
> > > After spending too much time poking around kvmlock and sched_clock co=
de, I'm pretty
> > > sure that accounting *all* suspend time to steal_time is wildly inacc=
urate for
> > > most clocksources that will be used by KVM x86 guests.
> > >
> > > KVM already adjusts TSC, and by extension kvmclock, to account for th=
e TSC going
> > > backwards due to suspend+resume.  I haven't dug super deep, buy I ass=
ume/hope the
> > > majority of suspend time is handled by massaging guest TSC.
> > >
> > > There's still a notable gap, as KVM's TSC adjustments likely won't ac=
count for
> > > the lag between CPUs coming online and vCPU's being restarted, but I =
don't know
> > > that having KVM account the suspend duration is the right way to solv=
e that issue.
> >
> > (It is my understanding that steal time has no impact on clock sources.=
)
> > On our machines, the problem isn't that the TSC is going backwards. As
> > you say, kvmclock takes care of that.
> >
> > The problem these patches are trying to solve is that the time keeps
> > advancing for the VM while the host is suspended.
>
> Right, the issue is that because KVM adjusts guest TSC if the host TSC do=
es go
> backwards, then the accounting will be all kinds of messed up.
>
>   1. Initiate suspend at host TSC X, guest TSC X+Y.
>
>   2. Save X into last_host_tsc via kvm_arch_vcpu_put():
>
>         vcpu->arch.last_host_tsc =3D rdtsc();
>
>   3. Resume after N hours, host TSC reset to 0 and starts counting.
>
>   4. kvm_arch_enable_virtualization_cpu() runs at new host time Z.
>
>   5. KVM detects backwards TSC (Z < X) and adjusts guest TSC offset so th=
at guest
>      TSC stays at/near X+Y, i.e. guest TSC becomes "Z + Y + (X - Z)".
>
>                 u64 delta_cyc =3D max_tsc - local_tsc;
>                 list_for_each_entry(kvm, &vm_list, vm_list) {
>                         kvm->arch.backwards_tsc_observed =3D true;
>                         kvm_for_each_vcpu(i, vcpu, kvm) {
>                                 vcpu->arch.tsc_offset_adjustment +=3D del=
ta_cyc;
>                                 vcpu->arch.last_host_tsc =3D local_tsc;
>                                 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDA=
TE, vcpu);
>                         }
>
> Thus, if the guest is using the TSC for sched_clock, guest time does NOT =
keep
> advancing.
>
> kvmclock on the other hand counts from *host* boot, and so guest time kee=
ps
> advancing if the guest is using kvmclock.
>
>   #ifdef CONFIG_X86_64
>   static s64 get_kvmclock_base_ns(void)
>   {
>         /* Count up from boot time, but with the frequency of the raw clo=
ck.  */
>         return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.o=
ffs_boot));
>   }
>   #else
>   static s64 get_kvmclock_base_ns(void)
>   {
>         /* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
>         return ktime_get_boottime_ns();
>   }
>   #endif
>
> In short, AFAICT the issues you are observing are mostly a problem with k=
vmclock.
> Or maybe it's the other way around and effectively freezing guest TSC is =
super
> problematic and fundamentally flawed.
>
> Regardless of which one is "broken", unconditionally accounting suspend t=
ime to
> steal_time will do the wrong thing when sched_clock=3Dtsc.  To further mu=
ddy the
> waters, current Linux-as-a-guest on modern hardware will likely use clock=
source=3Dtsc,
> but sched_clock=3Dkvmclock.  In that scenario, guest time doesn't advance=
d, but
> guest scheduler time does.  Ugh.
>
> That particular wart can be avoided by having the guest use TSC for sched=
_clock[*],
> e.g. so that at least the behavior of time is consistent.
>
> Hmm, if freezing guest time across suspend is indeed problematic, one tho=
ught
> would be to put the onus on the VMM/user to not advertise a "nonstop TSC"=
 if the
> host may be suspending.  The Linux-as-a-guest would prefer kvmclock over =
TSC for
> both clocksource and sched_clock.
>
> [*] https://lore.kernel.org/all/Z4gqlbumOFPF_rxd@google.com

I see what you're saying. Thanks for explaining.

To complicate things further there are also different kinds of
suspends. From what I've seen "shallow" (and/or "suspend-to-idle")
suspends don't stop the CPU, at least on our machines, so the host TSC
keeps ticking. On "deep" suspends, on the other hand, the TSC might go
backwards.

But I suppose if the guest uses kvmclock the behavior should be the
same in either case.

At least for our use case we would definitely want guest *wall* time
to keep advancing, so we would still want to use kvmclock.

Would accounting the suspend duration in steal time be acceptable if
it was conditional on the guest using kvmclock?
We would need a way for the host to be notified that the guest is
indeed using it, possibly by adding a new MSR to be written to in
kvm_cs_enable().

-- Suleiman

