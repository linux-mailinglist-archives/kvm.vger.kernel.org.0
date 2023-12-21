Return-Path: <kvm+bounces-5101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0327081BED0
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 20:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C3C9286376
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 19:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA6B651AE;
	Thu, 21 Dec 2023 19:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OqvsvJ4S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2AA651AC
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so1381a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 11:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703185812; x=1703790612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFrW4mwSQkPFJyi7GEYfnWuglO4pb57kPDM5jaJU5mM=;
        b=OqvsvJ4SH4vdSlMUMle9A0tanulvhIA/g9oMMpC44T8WzUDd3+ADTS7gNdqvyEBbt9
         Ou1i3Jv5W4dGlcj1RGdiirRjh8KYAjmsEP9eGBZWEcYiNF8uqGB4rFkRnl2PlOhXIcw8
         ZV4VXlH7jhC81N/WuEuMokRopcdBJYjRnKNTCXsheB+/xEEMmYU91jaYkziJvXy6Vnzw
         ZPYEoOSYgP3kCPU+GTttm2pGctr0uHNSCM3ouL1DAtwHTDbb/gRo1kfMo7cxhvciFCxN
         ji5apUSyvUzQIpa7lnXmvDSih5ACkcUzDsZhyJUYbAQE0rGHf4HZ97d7WG+NTtSYsZ8d
         OEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185812; x=1703790612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFrW4mwSQkPFJyi7GEYfnWuglO4pb57kPDM5jaJU5mM=;
        b=aCRfrYAvheBPmY9Cmrvl+TAVQpnodO92pg2ienCk2VdkggyZyniVA5qBSKtvc5UFnO
         AO9iMMKSJaHDZ9IIkLH1+9ITobDY5svPswy5fjY9vfTz6PgxevQxPK6YRDaX3UaFmf92
         TLP5gRcG/2/LKBadgBYWjt9wUJgszRBHkWgeUWS+++sR6WL0FgB9wbuzidz73d+DP5Hi
         4ufLQifzpNtirDs5Qt95iAhcnx9D9dQ6tVKSXCfTVd4i/s4J321aqnywQsGUHkjOapSz
         PGEkxFdKE4hKq0pG9exj+FVIoF24mN4AefqPB4W7lA6A4Ie+i5g6fnKYEHPgq3/VFvL6
         6Kxw==
X-Gm-Message-State: AOJu0YxUHNf1RgncJ1C+3+aGwOvrvUwkOpGc9+h0XlbNBBpO+pLfoUEj
	+J9an3KrT9Jj8DxgwQwHTirYjAkd6cqgPxzxyPUjvNMabW1l
X-Google-Smtp-Source: AGHT+IESeqEdgrqKz0/GMqLTd/fjag+tdJcjQwL7DLqFfGzpbYDoxB294HxeTrld5LUrQiq+V6r6BSM4bMcT4cv0olc=
X-Received: by 2002:a50:d705:0:b0:553:62b4:5063 with SMTP id
 t5-20020a50d705000000b0055362b45063mr8689edi.4.1703185812520; Thu, 21 Dec
 2023 11:10:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
In-Reply-To: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 21 Dec 2023 11:09:57 -0800
Message-ID: <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC deadline timers
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 8:52=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.com=
> wrote:
>
>
> Hi!
>
> Recently I was tasked with triage of the failures of 'vmx_preemption_time=
r'
> that happen in our kernel CI pipeline.
>
>
> The test usually fails because L2 observes TSC after the
> preemption timer deadline, before the VM exit happens.
>
> This happens because KVM emulates nested preemption timer with HR timers,
> so it converts the preemption timer value to nanoseconds, taking in accou=
nt
> tsc scaling and host tsc frequency, and sets HR timer.
>
> HR timer however as I found out the hard way is bound to CLOCK_MONOTONIC,
> and thus its rate can be adjusted by NTP, which means that it can run slo=
wer or
> faster than KVM expects, which can result in the interrupt arriving earli=
er,
> or late, which is what is happening.
>
> This is how you can reproduce it on an Intel machine:
>
>
> 1. stop the NTP daemon:
>       sudo systemctl stop chronyd.service
> 2. introduce a small error in the system time:
>       sudo date -s "$(date)"
>
> 3. start NTP daemon:
>       sudo chronyd -d -n  (for debug) or start the systemd service again
>
> 4. run the vmx_preemption_timer test a few times until it fails:
>
>
> I did some research and it looks like I am not the first to encounter thi=
s:
>
> From the ARM side there was an attempt to support CLOCK_MONOTONIC_RAW wit=
h
> timer subsystem which was even merged but then reverted due to issues:
>
> https://lore.kernel.org/all/1452879670-16133-3-git-send-email-marc.zyngie=
r@arm.com/T/#u
>
> It looks like this issue was later worked around in the ARM code:
>
>
> commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
> Author: Marc Zyngier <maz@kernel.org>
> Date:   Wed Apr 6 09:37:22 2016 +0100
>
>     KVM: arm/arm64: Handle forward time correction gracefully
>
>     On a host that runs NTP, corrections can have a direct impact on
>     the background timer that we program on the behalf of a vcpu.
>
>     In particular, NTP performing a forward correction will result in
>     a timer expiring sooner than expected from a guest point of view.
>     Not a big deal, we kick the vcpu anyway.
>
>     But on wake-up, the vcpu thread is going to perform a check to
>     find out whether or not it should block. And at that point, the
>     timer check is going to say "timer has not expired yet, go back
>     to sleep". This results in the timer event being lost forever.
>
>     There are multiple ways to handle this. One would be record that
>     the timer has expired and let kvm_cpu_has_pending_timer return
>     true in that case, but that would be fairly invasive. Another is
>     to check for the "short sleep" condition in the hrtimer callback,
>     and restart the timer for the remaining time when the condition
>     is detected.
>
>     This patch implements the latter, with a bit of refactoring in
>     order to avoid too much code duplication.
>
>     Cc: <stable@vger.kernel.org>
>     Reported-by: Alexander Graf <agraf@suse.de>
>     Reviewed-by: Alexander Graf <agraf@suse.de>
>     Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>
>
> So to solve this issue there are two options:
>
>
> 1. Have another go at implementing support for CLOCK_MONOTONIC_RAW timers=
.
>    I don't know if that is feasible and I would be very happy to hear a f=
eedback from you.
>
> 2. Also work this around in KVM. KVM does listen to changes in the timeke=
eping system
>   (kernel calls its update_pvclock_gtod), and it even notes rates of both=
 regular and raw clocks.
>
>   When starting a HR timer I can adjust its period for the difference in =
rates, which will in most
>   cases produce more correct result that what we have now, but will still=
 fail if the rate
>   is changed at the same time the timer is started or before it expires.
>
>   Or I can also restart the timer, although that might cause more harm th=
an
>   good to the accuracy.
>
>
> What do you think?

Is this what the "adaptive tuning" in the local APIC TSC_DEADLINE
timer is all about (lapic_timer_advance_ns =3D -1)? If so, can we
leverage that for the VMX-preemption timer as well?
>
> Best regards,
>         Maxim Levitsky
>
>
>

