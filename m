Return-Path: <kvm+bounces-35833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F274A154F4
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E3DB7A3FA7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DF81A23AD;
	Fri, 17 Jan 2025 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYquXNpJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5E81A08A6
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737132772; cv=none; b=CZwKZiNjSD409n2VOzkPvrjXeBAAoMh8J2T7VQqZs6OBYEw4pZ2zukhQkz4meK0q1E5GZudjnMZ29DLXuUE4jJI6cDaD72sGLdlQn/nJuxYH7OAJmN4FYtv+DDU06/gnofB4VML/ER4w0GITVgrQGpmpXW5Pm8GwsQSW+T7V5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737132772; c=relaxed/simple;
	bh=JshAQuXrdf/vFS7DdPV21az7k1q9yAkl72UZmaWqTPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B7DkVhuZDzZYEYigdWV17YsKT9J7urnHCxEKwG5dXFk38s+HcnWvnJXECN9szEOa+M9EedUVPwdsnxxRcFuMhNAV9i2SM3cndSCr9HolbktOC6lFhSVqQ8eJxEDKjjTvBn+cLpieQdhDgsGQBxt/clwBQvjJ7zMgBQDfgufH2yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYquXNpJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f5538a2356so4440227a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737132770; x=1737737570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eWhQ4gbK6D4YVawcJMZcGVfdNNcEyxTDArO+Kcn+bE=;
        b=LYquXNpJwtDjoJK/oXjqt72xqLBndZnCG4DHVdvmEP+qM7Qn2cuG1UV/Hf5Q1w9N+u
         R+m6S82X5aeybXQZPSrVO7C9J3i5kAS3XdtRjFxZS8IAyBeec2ok4zrScaFC8hzYl9JL
         1xUBZ0s69zABfgfEJ3rRPmY9PUnRQI20Pz6VSsiIQu6kqs6SkS84CdKwOhe+r3lCOqGc
         WFq63GWzptg8Xi4kvjRNPKlcsYyiBVxVXyHcnVECqf+SVxRQecSzTgppcHMIvJ5Qgy12
         vxDE5NyCbVivhplbkI2SKxwMBw1xW3pNNXZ0C5CrTwF/4FMPFnw9Zye96B4Tb2zScxtm
         i1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737132770; x=1737737570;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2eWhQ4gbK6D4YVawcJMZcGVfdNNcEyxTDArO+Kcn+bE=;
        b=ckO6ml4eo/7m/AXqXEbfIVwpHjMYRE4ua0OctJ6R14tjRKyjytJJCZmrZ2DPvZ/E8H
         HfY9mr1h9DuiyP4yzCPN7UieGYMLEzkHcdpXOHOVeu5ObjJqtcNxnBSqxU1+ekYcSPWC
         IRJz3bQ5EJUtArhOuDzDEGSBMT9UB+0VQ8b+UMOFDp9ySDBtixtjZb+rwn8roDGd5i1T
         QXjdefDhveRFTC19GWyOP2BRpp6DU5EbOAIHn/fPX+XPp40SNpnQJ4nn0qXd8acXXDlG
         UlX4OJuEUTU+gY7x/07ZOrfrwzEp4vID54gbKjVYamTVTXz4EXhIUa3seuOQp/vjn2KU
         HqbA==
X-Forwarded-Encrypted: i=1; AJvYcCU+8XBVrjU0GgtQie5+2iyTX6RcmiDEIklASE4FBKyiugM01ftkyjjJI7cC9tTGxfI1VMc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvyKLfd6Un6XJg5K9xcJvYH6JZ4Zawt7EyHDhSD9ney3WEDpYQ
	w6jZafNDtFZsmnQHaGcpu+iDCCgcddyH1YhZv9C8t4j19Y+9aqGkX9wvbOLcvOlNJsSl/Voh/Jq
	OUQ==
X-Google-Smtp-Source: AGHT+IHyq6VJPX9FfnZ6MlDC8z80Nq1NL0zTef+h6tAa7MLyoEn6y308Ywn8tsXMMPCedlKPNa3CH2iVEzU=
X-Received: from pjbqi17.prod.google.com ([2002:a17:90b:2751:b0:2ef:7352:9e97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8b:b0:2f6:539:3cd8
 with SMTP id 98e67ed59e1d1-2f782ca2291mr5301914a91.18.1737132769931; Fri, 17
 Jan 2025 08:52:49 -0800 (PST)
Date: Fri, 17 Jan 2025 08:52:48 -0800
In-Reply-To: <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
Message-ID: <Z4qK4B6taSoZTJMp@google.com>
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

On Fri, Jan 17, 2025, Suleiman Souhlal wrote:
> On Thu, Jan 16, 2025 at 6:49=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > > It returns the cumulative nanoseconds that the host has been suspende=
d.
> > > It is intended to be used for reporting host suspend time to the gues=
t.
> >
> > ...
> >
> > >  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> > > +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> > > +{
> > > +     switch (state) {
> > > +     case PM_HIBERNATION_PREPARE:
> > > +     case PM_SUSPEND_PREPARE:
> > > +             last_suspend =3D ktime_get_boottime_ns();
> > > +     case PM_POST_HIBERNATION:
> > > +     case PM_POST_SUSPEND:
> > > +             total_suspend_ns +=3D ktime_get_boottime_ns() - last_su=
spend;
> >
> > After spending too much time poking around kvmlock and sched_clock code=
, I'm pretty
> > sure that accounting *all* suspend time to steal_time is wildly inaccur=
ate for
> > most clocksources that will be used by KVM x86 guests.
> >
> > KVM already adjusts TSC, and by extension kvmclock, to account for the =
TSC going
> > backwards due to suspend+resume.  I haven't dug super deep, buy I assum=
e/hope the
> > majority of suspend time is handled by massaging guest TSC.
> >
> > There's still a notable gap, as KVM's TSC adjustments likely won't acco=
unt for
> > the lag between CPUs coming online and vCPU's being restarted, but I do=
n't know
> > that having KVM account the suspend duration is the right way to solve =
that issue.
>=20
> (It is my understanding that steal time has no impact on clock sources.)
> On our machines, the problem isn't that the TSC is going backwards. As
> you say, kvmclock takes care of that.
>=20
> The problem these patches are trying to solve is that the time keeps
> advancing for the VM while the host is suspended.

Right, the issue is that because KVM adjusts guest TSC if the host TSC does=
 go
backwards, then the accounting will be all kinds of messed up.

  1. Initiate suspend at host TSC X, guest TSC X+Y.

  2. Save X into last_host_tsc via kvm_arch_vcpu_put():

	vcpu->arch.last_host_tsc =3D rdtsc();

  3. Resume after N hours, host TSC reset to 0 and starts counting.

  4. kvm_arch_enable_virtualization_cpu() runs at new host time Z.

  5. KVM detects backwards TSC (Z < X) and adjusts guest TSC offset so that=
 guest
     TSC stays at/near X+Y, i.e. guest TSC becomes "Z + Y + (X - Z)".

		u64 delta_cyc =3D max_tsc - local_tsc;
		list_for_each_entry(kvm, &vm_list, vm_list) {
			kvm->arch.backwards_tsc_observed =3D true;
			kvm_for_each_vcpu(i, vcpu, kvm) {
				vcpu->arch.tsc_offset_adjustment +=3D delta_cyc;
				vcpu->arch.last_host_tsc =3D local_tsc;
				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
			}

Thus, if the guest is using the TSC for sched_clock, guest time does NOT ke=
ep
advancing.

kvmclock on the other hand counts from *host* boot, and so guest time keeps
advancing if the guest is using kvmclock.

  #ifdef CONFIG_X86_64
  static s64 get_kvmclock_base_ns(void)
  {
	/* Count up from boot time, but with the frequency of the raw clock.  */
	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot)=
);
  }
  #else
  static s64 get_kvmclock_base_ns(void)
  {
	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
	return ktime_get_boottime_ns();
  }
  #endif

In short, AFAICT the issues you are observing are mostly a problem with kvm=
clock.
Or maybe it's the other way around and effectively freezing guest TSC is su=
per
problematic and fundamentally flawed.

Regardless of which one is "broken", unconditionally accounting suspend tim=
e to
steal_time will do the wrong thing when sched_clock=3Dtsc.  To further mudd=
y the
waters, current Linux-as-a-guest on modern hardware will likely use clockso=
urce=3Dtsc,
but sched_clock=3Dkvmclock.  In that scenario, guest time doesn't advanced,=
 but
guest scheduler time does.  Ugh.

That particular wart can be avoided by having the guest use TSC for sched_c=
lock[*],
e.g. so that at least the behavior of time is consistent.

Hmm, if freezing guest time across suspend is indeed problematic, one thoug=
ht
would be to put the onus on the VMM/user to not advertise a "nonstop TSC" i=
f the
host may be suspending.  The Linux-as-a-guest would prefer kvmclock over TS=
C for
both clocksource and sched_clock.

[*] https://lore.kernel.org/all/Z4gqlbumOFPF_rxd@google.com

