Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D5917CF40
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 17:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCGQHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 11:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGQHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 11:07:07 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B362077C
        for <kvm@vger.kernel.org>; Sat,  7 Mar 2020 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583597225;
        bh=yyqK+Ql2p4NXPr4RjWF269NGUHTHvvPj0zJ+ILRkEOg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NL2x4LxRYKBgtzACYWlJ2pMI2FhHtawWlR1dNr+OEMGq4wtXfu+jDuErJZ621Eo9V
         pyNKtA+g6i2pQVjrJqM9HU/+OwGee39y9b3TUnEwraXGxgVPqCl+sqLsOWw67e1GHv
         3GSoav2poMwmYQz7PAv09M81nqNVqekxvY/ZkefY=
Received: by mail-wm1-f46.google.com with SMTP id p9so5618627wmc.2
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2020 08:07:05 -0800 (PST)
X-Gm-Message-State: ANhLgQ0x/rKOaIOEeBCl22ZltwE4DyxtiWzdXWrwqwZiOkA+D1qtOK5I
        Y9Og3H4/GhPVwbca9xIwb6RZdxhbZ1K0Czv4VYHLSQ==
X-Google-Smtp-Source: ADFU+vudN2xwPRYRNB2o4MM2vanAeeTTHZ6j/KCg28MIjew9C/SRRYIi+AzD8kBMAgCC+UznEhbzhnyozZYz03npvFQ=
X-Received: by 2002:a7b:ce09:: with SMTP id m9mr10869694wmc.49.1583597223816;
 Sat, 07 Mar 2020 08:07:03 -0800 (PST)
MIME-Version: 1.0
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de>
 <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
 <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
 <87d09o9n7y.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87d09o9n7y.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 08:06:52 -0800
X-Gmail-Original-Message-ID: <CALCETrXpW5TYRNu2hMXt=fGC8EOh7WVqffCzS5GrwApC1inTzw@mail.gmail.com>
Message-ID: <CALCETrXpW5TYRNu2hMXt=fGC8EOh7WVqffCzS5GrwApC1inTzw@mail.gmail.com>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 7, 2020 at 7:52 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
> > On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wro=
te:
> >> > What=E2=80=99s the local_irq_disable() here for? I would believe a
> >> > lockdep_assert_irqs_disabled() somewhere in here would make sense.
> >> > (Yes, I see you copied this from the old code. It=E2=80=99s still no=
nsense.)
> >>
> >> native_safe_halt() does:
> >>
> >>          STI
> >>          HLT
> >>
> >> So the irq disable is required as the loop should exit with interrupts
> >> disabled.
> >
> > Oops, should have looked at what native_safe_halt() does.
> >
> >>
> >> > I also find it truly bizarre that hlt actually works in this context=
.
> >> > Does KVM in fact wake a HLTed guest that HLTed with IRQs off when a
> >> > pending async pf is satisfied?  This would make sense if the wake
> >> > event were an interrupt, but it=E2=80=99s not according to Paolo.
> >>
> >> See above. safe halt enables interrupts, which means IF =3D=3D 1 and t=
he
> >> host sanity check for IF =3D=3D 1 is satisfied.
> >>
> >> In fact, if e.g. some regular interrupt arrives before the page become=
s
> >> available and the guest entered the halt loop because the fault happen=
ed
> >> inside a RCU read side critical section with preemption enabled, then
> >> the interrupt might wake up another task, set need resched and this
> >> other task can run.
> >
> > Now I'm confused again.  Your patch is very careful not to schedule if
> > we're in an RCU read-side critical section, but the regular preemption
> > code (preempt_schedule_irq, etc) seems to be willing to schedule
> > inside an RCU read-side critical section.  Why is the latter okay but
> > not the async pf case?
>
> Preemption is fine, but voluntary schedule not. voluntary schedule might
> end up in idle if this is the last runnable task.

I guess something horrible happens if we try to go idle while in an
RCU read-side critical section.  Like perhaps it's considered a grace
period.  Hmm.

>
> > Ignoring that, this still seems racy:
> >
> > STI
> > nested #PF telling us to wake up
> > #PF returns
> > HLT
>
> You will say Ooops, should have looked .... when I tell you that the
> above cannot happen. From the SDM:
>
>   If IF =3D 0, maskable hardware interrupts remain inhibited on the
>   instruction boundary following an execution of STI.
>
> Otherwise safe_halt would not work at all :)

Ooops, should have looked. :)

> > Sadly, wrmsr to turn off async pf will inject wakeups even if IF =3D=3D=
 0.
>
> WHAT? That's fundamentally broken. Can you point me to the code in
> question?

I think Paolo said so in a different thread, but I can't Let me see if
I can find it:

kvm_pv_enable_async_pf()
  kvm_clear_async_pf_completion_queue()

but that doesn't actually seem to send #PF.  So maybe I'm wrong.

I will admit that, even after reading the host code a few times, I'm
also not convinced that wakeups don't get swallowed on occasion if
they would have been delivered at times when it's illegal.
