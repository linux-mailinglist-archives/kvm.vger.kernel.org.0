Return-Path: <kvm+bounces-17544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 380078C7AB7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 18:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63F9CB20F98
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0E7EEC0;
	Thu, 16 May 2024 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3tm54BWb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2679D0
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715878425; cv=none; b=IfsB31kSuT05v8W2zMFD4E6xVa2FaYgAMNAE4hKdBovwczfWN5r4OCtL6YIKwNYjxs0/jwAjL8sE/3QAJhTad/7zKhmnkdPwd7C8ERA3YOzzz8BDJfMAIgCY6sD+yBW1s5Fimx+KlREF8pmdczp7+MlqfJJcP8vFrYzYY1hFw04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715878425; c=relaxed/simple;
	bh=Rfukpev61+HUMGELE+Yl7kWQy/3drovke0iAQklwEEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WSi94c1J5/IeUhsxbGzY8/dTZkmGnidfZQ50OeVIurlx8TgH5mjBXViX0GPMTsX+d2L4p2EmT7Iiereu/N00seOD7JJDBpwYPLgnyiC2sVXWz7DyEQKidA3i5U8d7YiFZr18VNGfFK19wzrnVRGFU3HkKfpvtAZphCY7iSNWeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3tm54BWb; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5724736770cso287a12.1
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715878420; x=1716483220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAtUZuQuQXgYjpu4YwyXcnTpXb8aUu6f5oRyQ9gZtmU=;
        b=3tm54BWbr21TJMlgDChb/GyzrptEbx+2ocxtAvNBfNq1gbq8W1eENZNb+PcXnL9uRX
         mnY1UGJXTAtma8025IW3ONB+yiiuNjAZy9cJS2NJr1TSu4MG7+cTr+2QKixzBTiH5iQX
         g83dmLEhRl7I8LsZ7nz3k37WuEvXAkIIgxIC6M/+Fp6iY/l2iLPx+NX3ArksAV2OFaAp
         1qIuZZxmWxnBIuTaKEGgsl/j2cO+aHAoVURL5xxXTPJu5py1DfMSZO1f3+go2afG/g20
         JUgjGZCQFba/owghuMjX7yfOYHBaAGrQpfEGH5niUAJtLObDvLChr19H9qmvEb2jK9vU
         afhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715878420; x=1716483220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pAtUZuQuQXgYjpu4YwyXcnTpXb8aUu6f5oRyQ9gZtmU=;
        b=DmefFRtwb43YnRZDp1mMX7GK6X7Pq312Km6Gg6/2JRY5Cvp4yid2zq1qGPRZeUu+5R
         WnbHUoQLpsL6x1ddTUnNBiGDXh/x8huIdt3ynwUZ5yNrv8AoUMYTMpsSYwNo/+j16YNK
         6ErOxn0EMZrT2UwZjWICOqTkK6Xxk9WEeE6/S/AUsSHQF3LnxSzF4X3F6OA2Ne9oeeaz
         bXMKOkKB0RZDHqbJ+xOOZnp2fpUy+Woz0diOdD7Rv8bqWv4C0idhalDPBZ/kZ/PLMypm
         /TLuwlSdjTo3Pr7w89feqtdjzHvtUfJA83S6F20fWVpJuAWm5oa5qBWgieNTQOx+aiEv
         jP9A==
X-Gm-Message-State: AOJu0YzY2yYPmr8BTtSIh25i+NjpL6GxwKsgvMWLxgTDFqjubONXU3HB
	5KETzU4PAmOkwYhTVM5ZjFeieBXHD5oAxX9FZ827UOnw7hspmRSwfxu2+hY1UNDNnKNMhx27zTL
	QWI/OraP8f8ZkI+1iZDtXd7zJbrdUiwdqr0uu
X-Google-Smtp-Source: AGHT+IFIAvF85e35+Fm7m3Nysi8LcbeJfOl5NCE999v6MsinV+qpkVH0+qT4nGj5N3ynxrf1ZtMbmvPdiKG/ZITLHcQ=
X-Received: by 2002:a50:cb8c:0:b0:573:438c:778d with SMTP id
 4fb4d7f45d1cf-574ae3c1280mr1017459a12.1.1715878419750; Thu, 16 May 2024
 09:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
 <CALMp9eSy2r+iUzqHV+V2mbPaPWfn=Y=a1aM+9C65PGtE0=nGqA@mail.gmail.com>
 <481be19e33915804c855a55181c310dd8071b546.camel@redhat.com>
 <CALMp9eQcRF_oS2rc_xF1H3=pfHB7ggts44obZgvh-K03UYJLSQ@mail.gmail.com> <7cb1aec718178ee9effe1017dad2ef7ab8b2a714.camel@redhat.com>
In-Reply-To: <7cb1aec718178ee9effe1017dad2ef7ab8b2a714.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 16 May 2024 09:53:24 -0700
Message-ID: <CALMp9eSPXP-9u7Fd+QMmeKzO6+fbTfn3iAHUn83Og+F=SvcQ4A@mail.gmail.com>
Subject: Re: RFC: NTP adjustments interfere with KVM emulation of TSC deadline timers
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 2:03=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.com=
> wrote:
>
> On Tue, 2024-01-02 at 15:49 -0800, Jim Mattson wrote:
> > On Tue, Jan 2, 2024 at 2:21=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.=
com> wrote:
> > > On Thu, 2023-12-21 at 11:09 -0800, Jim Mattson wrote:
> > > > On Thu, Dec 21, 2023 at 8:52=E2=80=AFAM Maxim Levitsky <mlevitsk@re=
dhat.com> wrote:
> > > > > Hi!
> > > > >
> > > > > Recently I was tasked with triage of the failures of 'vmx_preempt=
ion_timer'
> > > > > that happen in our kernel CI pipeline.
> > > > >
> > > > >
> > > > > The test usually fails because L2 observes TSC after the
> > > > > preemption timer deadline, before the VM exit happens.
> > > > >
> > > > > This happens because KVM emulates nested preemption timer with HR=
 timers,
> > > > > so it converts the preemption timer value to nanoseconds, taking =
in account
> > > > > tsc scaling and host tsc frequency, and sets HR timer.
> > > > >
> > > > > HR timer however as I found out the hard way is bound to CLOCK_MO=
NOTONIC,
> > > > > and thus its rate can be adjusted by NTP, which means that it can=
 run slower or
> > > > > faster than KVM expects, which can result in the interrupt arrivi=
ng earlier,
> > > > > or late, which is what is happening.
> > > > >
> > > > > This is how you can reproduce it on an Intel machine:
> > > > >
> > > > >
> > > > > 1. stop the NTP daemon:
> > > > >       sudo systemctl stop chronyd.service
> > > > > 2. introduce a small error in the system time:
> > > > >       sudo date -s "$(date)"
> > > > >
> > > > > 3. start NTP daemon:
> > > > >       sudo chronyd -d -n  (for debug) or start the systemd servic=
e again
> > > > >
> > > > > 4. run the vmx_preemption_timer test a few times until it fails:
> > > > >
> > > > >
> > > > > I did some research and it looks like I am not the first to encou=
nter this:
> > > > >
> > > > > From the ARM side there was an attempt to support CLOCK_MONOTONIC=
_RAW with
> > > > > timer subsystem which was even merged but then reverted due to is=
sues:
> > > > >
> > > > > https://lore.kernel.org/all/1452879670-16133-3-git-send-email-mar=
c.zyngier@arm.com/T/#u
> > > > >
> > > > > It looks like this issue was later worked around in the ARM code:
> > > > >
> > > > >
> > > > > commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
> > > > > Author: Marc Zyngier <maz@kernel.org>
> > > > > Date:   Wed Apr 6 09:37:22 2016 +0100
> > > > >
> > > > >     KVM: arm/arm64: Handle forward time correction gracefully
> > > > >
> > > > >     On a host that runs NTP, corrections can have a direct impact=
 on
> > > > >     the background timer that we program on the behalf of a vcpu.
> > > > >
> > > > >     In particular, NTP performing a forward correction will resul=
t in
> > > > >     a timer expiring sooner than expected from a guest point of v=
iew.
> > > > >     Not a big deal, we kick the vcpu anyway.
> > > > >
> > > > >     But on wake-up, the vcpu thread is going to perform a check t=
o
> > > > >     find out whether or not it should block. And at that point, t=
he
> > > > >     timer check is going to say "timer has not expired yet, go ba=
ck
> > > > >     to sleep". This results in the timer event being lost forever=
.
> > > > >
> > > > >     There are multiple ways to handle this. One would be record t=
hat
> > > > >     the timer has expired and let kvm_cpu_has_pending_timer retur=
n
> > > > >     true in that case, but that would be fairly invasive. Another=
 is
> > > > >     to check for the "short sleep" condition in the hrtimer callb=
ack,
> > > > >     and restart the timer for the remaining time when the conditi=
on
> > > > >     is detected.
> > > > >
> > > > >     This patch implements the latter, with a bit of refactoring i=
n
> > > > >     order to avoid too much code duplication.
> > > > >
> > > > >     Cc: <stable@vger.kernel.org>
> > > > >     Reported-by: Alexander Graf <agraf@suse.de>
> > > > >     Reviewed-by: Alexander Graf <agraf@suse.de>
> > > > >     Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > > >     Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > > >
> > > > >
> > > > > So to solve this issue there are two options:
> > > > >
> > > > >
> > > > > 1. Have another go at implementing support for CLOCK_MONOTONIC_RA=
W timers.
> > > > >    I don't know if that is feasible and I would be very happy to =
hear a feedback from you.
> > > > >
> > > > > 2. Also work this around in KVM. KVM does listen to changes in th=
e timekeeping system
> > > > >   (kernel calls its update_pvclock_gtod), and it even notes rates=
 of both regular and raw clocks.
> > > > >
> > > > >   When starting a HR timer I can adjust its period for the differ=
ence in rates, which will in most
> > > > >   cases produce more correct result that what we have now, but wi=
ll still fail if the rate
> > > > >   is changed at the same time the timer is started or before it e=
xpires.
> > > > >
> > > > >   Or I can also restart the timer, although that might cause more=
 harm than
> > > > >   good to the accuracy.
> > > > >
> > > > >
> > > > > What do you think?
> > > >
> > > > Is this what the "adaptive tuning" in the local APIC TSC_DEADLINE
> > > > timer is all about (lapic_timer_advance_ns =3D -1)?
> > >
> > > Hi,
> > >
> > > I don't think that 'lapic_timer_advance' is designed for that but it =
does
> > > mask this problem somewhat.
> > >
> > > The goal of 'lapic_timer_advance' is to decrease time between deadlin=
e passing and start
> > > of guest timer irq routine by making the deadline happen a bit earlie=
r (by timer_advance_ns), and then busy-waiting
> > > (hopefully only a bit) until the deadline passes, and then immediatel=
y do the VM entry.
> > >
> > > This way instead of overhead of VM exit and VM entry that both happen=
 after the deadline,
> > > only the VM entry happens after the deadline.
> > >
> > >
> > > In relation to NTP interference: If the deadline happens earlier than=
 expected, then
> > > KVM will busy wait and decrease the 'timer_advance_ns', and next time=
 the deadline
> > > will happen a bit later thus adopting for the NTP adjustment somewhat=
.
> > >
> > > Note though that 'timer_advance_ns' variable is unsigned and adjust_l=
apic_timer_advance can underflow
> > > it, which can be fixed.
> > >
> > > Now if the deadline happens later than expected, then the guest will =
see this happen,
> > > but at least adjust_lapic_timer_advance should increase the 'timer_ad=
vance_ns' so next
> > > time the deadline will happen earlier which will also eventually hide=
 the problem.
> > >
> > > So overall I do think that implementing the 'lapic_timer_advance' for=
 nested VMX preemption timer
> > > is a good idea, especially since this feature is not really nested in=
 some sense - the timer is
> > > just delivered as a VM exit but it is always delivered to L1, so VMX =
preemption timer can
> > > be seen as just an extra L1's deadline timer.
> > >
> > > I do think that nested VMX preemption timer should use its own value =
of timer_advance_ns, thus
> > > we need to extract the common code and make both timers use it. Does =
this make sense?
> >
> > Alternatively, why not just use the hardware VMX-preemption timer to
> > deliver the virtual VMX-preemption timer?
> >
> > Today, I believe that we only use the hardware VMX-preemption timer to
> > deliver the virtual local APIC timer. However, it shouldn't be that
> > hard to pick the first deadline of {VMX-preemption timer, local APIC
> > timer} at each emulated VM-entry to L2.
>
> I assume that this is possible but it might add some complexity.
>
> AFAIK the design choice here was that L1 uses the hardware VMX preemption=
 timer always,
> while L2 uses the software preemption timer which is relatively simple.
>
> I do agree that this might work and if it does work it might be even wort=
hwhile
> change on its own.
>
> If you agree that this is a good idea, I can prepare a patch series for t=
hat.

I do think it would be worthwhile to provide the infrastructure for
multiple clients of the VMX-preemption timer. (Better yet would be to
provide a CLOCK_MONOTONIC_RAW hrtimer, but that's outwith our domain.)

> Note though that the same problem (although somewhat masked by lapic_time=
r_advance)
> does exit on AMD as well because while AMD lacks both VMX preemption time=
r and even the TSC deadline timer,
> KVM exposes TSC deadline to the guest, and HR timers are always used for =
its emulation,
> and are prone to NTP interference as I discovered.

It's not a problem if userspace ignores KVM's claim to support TSC deadline=
. :)

> Best regards,
>         Maxim Levitsky
>
> >
> > > Best regards,
> > >         Maxim Levitsky
> > >
> > >
> > > >  If so, can we
> > > > leverage that for the VMX-preemption timer as well?
> > > > > Best regards,
> > > > >         Maxim Levitsky
> > > > >
> > > > >
> > > > >
> > >
> > >
> > >
>
>
>
>

