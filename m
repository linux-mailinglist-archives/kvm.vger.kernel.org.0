Return-Path: <kvm+bounces-35727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F32A149BD
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 07:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75D953A5A22
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 06:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3719C1F76BD;
	Fri, 17 Jan 2025 06:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YVGS98Cx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A681D6DC5
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 06:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737095714; cv=none; b=kj+okvfPHnbjuNBEyI5WUK2+XO17xg7HpApue6C2pxdUDbihOgi3SzI14YWqdOyGzEnUQEyNd3U7g/TILRIvbBO8IlxqcLoUahVrUIsNy8dWzCytIyso27KEr1sY1pOluBv4w4TuHLtI54KC8HGsixA/I2+IWSTHWFZB1YSrzzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737095714; c=relaxed/simple;
	bh=ZAXbD9yBa2HmNN2nZ6xKSM8mB8CSkS5quDXQ0djFzMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=metu+OagedvEKNJMa2vhPmJuOVoDWLrSgcsivJXyeV17Xwa4LHN1ZDI/hbwvE+Ws6XuDnLmVspEE8Bd/MWFh8DwFLx9noJ2i0x7k7ebiuivYjXl37M/k5prHfL/rEGCQ1PcZEqLT8OW/e2iIbE6yx0SBRIwkCPrFAYzqCapFfhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YVGS98Cx; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d88cb85987so16222906d6.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737095712; x=1737700512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtb14uoWRZs5t4hKcN9GgCBb6tzgns0MmWaxCxI4D/o=;
        b=YVGS98Cxh873nrQLkhY/HWksGw6vNMhT4IOTiOdhWthm3SjLS6JNybH7ct4FeuZUVX
         0SV2hDLpgNur8ZqfGZJ8BXv1MEm4uhDSqiKzdfHWsKay8Ht2EU4PS2fhKJKZ/vfKr3vU
         7RB9bjZsjx5PfRcuKA4TjZ0JOdMeG64TObSXvT/4bVVF2vQGVJW8d2PQq1DSA3GGSZud
         jndoIy8WUljj8T+XWlw5NuAJs9Gaf2m4/1VTIY2Rz41ajF3a9p04sQIHufq7KSUYeUkV
         8PtX6eIYVuay8DfuYsBfofm4/bmA8ZEuE2QxJwABJmTSSlWUCNZSTQWCW25Z92IHb7VE
         MXGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737095712; x=1737700512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtb14uoWRZs5t4hKcN9GgCBb6tzgns0MmWaxCxI4D/o=;
        b=dH2eoLK16gNPaqJaAgE96VJLbs89Ub+hP4WHo4M7x3Oo/cHUZoeehalk6yzuF7F9Gn
         BBCt43pWcBjpmAGZTEQkTX1GboN2ESqOLraWJLXgZhk/VZaXoRrlDaryp5/DgyxY+yn+
         GAGsmvwzNvJkkKVjDQ9jQHp/vS+XSXEoA0joeddvwIuyRouVq48GQBOzAdw+5wDHhvqC
         IMDgFa8X3HAUQOtCahwGYJOWu0z1lAd+6JWMGjjqMZx2a96qtVccpAmphwNbjPeDIc+r
         wjF83EyR+dulmyFKFF8txDo/hjR/rAaoXzrfaeRedAZy1ysJu2T7ujK57Q1rDIPS3EYU
         3Jnw==
X-Forwarded-Encrypted: i=1; AJvYcCUBYsVNzHBXt3HzkB9y4GIBXRozjlieM2dDXa22ruGhIaScfARlsqT/1nHPobtX1rmhWSw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh7gdSmKEbpyxmx1PkVlrBkMRb2THwyDRBYf4b9e0MV5sKvCE4
	SKcpK/tzQQaMkYA5OJ1vOUroRKkHNp+CtKcefK2DVlyrJ8+8kBfHUFUWP/6TRCfYRKsIxcaUYPY
	m2u2oyWBZOMFjXaSJhK6bJuV1PJbpj8O7MpdVzuRKjN31Bq6WzEtc
X-Gm-Gg: ASbGncvWVAtLpyixjglk10ruyqqzUUj89Obs9EZkyCLEFMb9n14b8WJ6/iimo/62qLq
	BaqK/wVTRAggyPnvWOixzYLHX1UOkQTOh6iAn9DI=
X-Google-Smtp-Source: AGHT+IE2zbF72HxpWoWo0r+mtg0GyYLB+CzHjq//bqz32cfmCzTmwgBO7lXjt1wWkV0i+Bgsa0Gfqf8eVjcJHCH44+A=
X-Received: by 2002:a05:6214:4304:b0:6d8:94f4:d2aa with SMTP id
 6a1803df08f44-6e192ba8f77mr158329246d6.13.1737095711615; Thu, 16 Jan 2025
 22:35:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com>
In-Reply-To: <Z4gtb-Z2GpbEkAsQ@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Fri, 17 Jan 2025 15:35:00 +0900
X-Gm-Features: AbW1kvbCJc_f_jZ5xWJ5O1Rk_afe9UrZfHqFaA5BO2vwlO_tEwn4QSYGuRmblDE
Message-ID: <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
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

On Thu, Jan 16, 2025 at 6:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> > It returns the cumulative nanoseconds that the host has been suspended.
> > It is intended to be used for reporting host suspend time to the guest.
>
> ...
>
> >  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> > +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> > +{
> > +     switch (state) {
> > +     case PM_HIBERNATION_PREPARE:
> > +     case PM_SUSPEND_PREPARE:
> > +             last_suspend =3D ktime_get_boottime_ns();
> > +     case PM_POST_HIBERNATION:
> > +     case PM_POST_SUSPEND:
> > +             total_suspend_ns +=3D ktime_get_boottime_ns() - last_susp=
end;
>
> After spending too much time poking around kvmlock and sched_clock code, =
I'm pretty
> sure that accounting *all* suspend time to steal_time is wildly inaccurat=
e for
> most clocksources that will be used by KVM x86 guests.
>
> KVM already adjusts TSC, and by extension kvmclock, to account for the TS=
C going
> backwards due to suspend+resume.  I haven't dug super deep, buy I assume/=
hope the
> majority of suspend time is handled by massaging guest TSC.
>
> There's still a notable gap, as KVM's TSC adjustments likely won't accoun=
t for
> the lag between CPUs coming online and vCPU's being restarted, but I don'=
t know
> that having KVM account the suspend duration is the right way to solve th=
at issue.

(It is my understanding that steal time has no impact on clock sources.)
On our machines, the problem isn't that the TSC is going backwards. As
you say, kvmclock takes care of that.

The problem these patches are trying to solve is that the time keeps
advancing for the VM while the host is suspended.
On the host, this problem does not happen because timekeeping is
stopped by timekeeping_suspend().
The problem with time advancing is that the guest scheduler thinks the
task that was running when the host suspended was running for the
whole duration, which was especially bad when we still had RT
throttling (prior to v6.12), as in the case of a RT task being
current, the scheduler would then throttle all RT tasks for a very
long time. With dlserver, the problem is much less severe, but still
exists.
There is a similar problem when the host CPU is overcommitted, where
the guest scheduler thinks the current task ran for the full duration,
even though the effective running time was much lower. This is exactly
what steal time solves, which is why I thought addressing the suspend
issue with steal time was an acceptable approach.

TSC adjustments would also be a way to address the issue, but we would
then need another mechanism to still advance the guest wall time
during the host suspension.
We have tried that approach in the past, and it was working pretty
well for us, but it did not seem popular with the rest of the
community: https://lore.kernel.org/kvm/20210806100710.2425336-1-hikalium@ch=
romium.org/T/

There is an additional gap with both approaches, which is that time
advances when the VM is blocked because the VMM hasn't run KVM_RUN.
Ideally steal time would also include time where the VM isn't being
scheduled because of the VMM (but maybe only if the blocking is due to
something outside of the guest's control), so that the guest scheduler
doesn't punish tasks for it. But that's a completely different
discussion, and I should probably not even be mentioning that here.

I hope that helps give some background on these patches.
-- Suleiman

