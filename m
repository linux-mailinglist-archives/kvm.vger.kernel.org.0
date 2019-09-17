Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A6B492D
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfIQIUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:20:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34220 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfIQIUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:20:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id z26so2299673oto.1;
        Tue, 17 Sep 2019 01:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XpgjHKHMGdhYytJR52HQX9zR2F19bBgZYV7/64t/ajE=;
        b=USJ+WYYwt74eTznKmC/uRoW4eZVYdWuJsKSS1b43kxlIq3/1Abr1ymMWrWMrRvVLar
         fKzUZvVDlrtf4ErDwa2njNR4Ok16/9FrFQukQZg7t+Mtxz9/rFAJ3wZr55E0s950CGHQ
         dHxUvfbMDJ07XZWB5i3pTwlMKy0D+VPwuEhVO/ItgHIdC+Aj4L0aei6y9GUXC3R8tL6W
         Esxpw+xE57xzL2Xee/fB27zkM2h8UyeyOZe3I27dqi+ZbwQJ5Jbkwisfg3PeP1lggH91
         SmmockzRR4pNecEU/gX4iVfE1ujIEywWbz13OfI2OZ9MRBaNxr6h5ewDnn+7HiMC77Ea
         zgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XpgjHKHMGdhYytJR52HQX9zR2F19bBgZYV7/64t/ajE=;
        b=NYZiZDszYWv1UzXaQL6bFgA1FMqK6UIsBM2TqE1znI7CpWCtWtLI6vzdmeMC9nP4Bj
         VU/oiUXn2VCD0g/68dVWF23i3IguHmlIDJ/4227V5JCn6duBEkJMdZk81gbwVlnAb4e4
         muNBLkkbZjYtnfmY2G2FJoZC4xH3o7PxBgFfAOP9kqiZMBU2V0Qe96hN5gbMPTJqAAKy
         1e7KNcRo4S49hBRk2TPmIatm9LyrPEmw9QVHXDM5CdaddkrzcidaDQBNJFDqA0gK3Lah
         Zdai5BoDjKd64l00Rs7FCkHHSXr6aLlWQjAPM1G2aEdX/OHgpnMPxiOm2CQRaBTKJCx3
         F8og==
X-Gm-Message-State: APjAAAXPxs+XrJKJ+hXk6GYefLDPBOrTBKnfE1wUzp9bIYm8PfMJ1Ktp
        7ig/wA7JsgBArQow9xfx1biI+IBShh9TMJ/v5y8=
X-Google-Smtp-Source: APXvYqwyQGwfv5B2H4CmhMbP4o7l5wMLHcAEVKp9/9auRJcEZJz7hzGluE3CQhHCTn1SmUvI9xVulJA26h3Aef42f5M=
X-Received: by 2002:a9d:4597:: with SMTP id x23mr1829071ote.185.1568708442003;
 Tue, 17 Sep 2019 01:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <1568623199-5294-1-git-send-email-wanpengli@tencent.com> <20190916185551.GL18871@linux.intel.com>
In-Reply-To: <20190916185551.GL18871@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 17 Sep 2019 16:20:30 +0800
Message-ID: <CANRm+CyvFtV7mGz5a-6UwXbqwbk9O81aVr3Z6j5OH7oqVjhPFw@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Sep 2019 at 02:55, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Sep 16, 2019 at 04:39:59PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Filter out drastic fluctuation and random fluctuation, remove
> > timer_advance_adjust_done altogether, the adjustment would be
> > continuous.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 26 ++++++++++++--------------
> >  arch/x86/kvm/lapic.h |  1 -
> >  arch/x86/kvm/x86.c   |  2 +-
> >  arch/x86/kvm/x86.h   |  1 +
> >  4 files changed, 14 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index dbbe478..2585b86 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -69,6 +69,7 @@
> >  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
> >  /* step-by-step approximation to mitigate fluctuation */
> >  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> > +#define LAPIC_TIMER_ADVANCE_FILTER 5000
> >
> >  static inline int apic_test_vector(int vec, void *bitmap)
> >  {
> > @@ -1482,29 +1483,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
> >                                             s64 advance_expire_delta)
> >  {
> >       struct kvm_lapic *apic = vcpu->arch.apic;
> > -     u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
> > -     u64 ns;
> > +     u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
>
> Is changing 'ns' to a u32 intentionaly?  It's still cast to a u32 in the
> calculations, and set from @advance_expire_delta.
>
> > +
> > +     if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER ||
>
> Shouldn't LAPIC_TIMER_ADVANCE_FILTER be used in the other "if ... > 5000"
> check?
>
>         if (unlikely(timer_advance_ns > 5000))
>
> And maybe name it LAPIC_TIMER_ADVANCE_MAX or something?
>
> > +             abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
>
> This should be aligned with the other 'abs', e.g.:
>
>         if (abs(...) ||
>             abs(...))
>                 return
>
> > +             /* filter out random fluctuations */
>
> If you put the comment above the if statement then you can drop the
> parentheses.  And if you're going to bother with a comment, maybe be a bit
> more explicit?  E.g.:
>
>         /* Do not adjust for tiny fluctuations or large random spikes. */
>         if (abs(...) ||
>             abs(...))
>                 return;
>
> > +             return;
> > +     }
> >
> >       /* too early */
> >       if (advance_expire_delta < 0) {
> >               ns = -advance_expire_delta * 1000000ULL;
> >               do_div(ns, vcpu->arch.virtual_tsc_khz);
> > -             timer_advance_ns -= min((u32)ns,
> > -                     timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> > +             timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
> >       } else {
> >       /* too late */
> >               ns = advance_expire_delta * 1000000ULL;
> >               do_div(ns, vcpu->arch.virtual_tsc_khz);
> > -             timer_advance_ns += min((u32)ns,
> > -                     timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> > +             timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
> >       }
> >
> > -     if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> > -             apic->lapic_timer.timer_advance_adjust_done = true;
> > -     if (unlikely(timer_advance_ns > 5000)) {
> > +     if (unlikely(timer_advance_ns > 5000))
> >               timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> > -             apic->lapic_timer.timer_advance_adjust_done = false;
> > -     }
> >       apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> >  }
> >
> > @@ -1524,7 +1524,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >       if (guest_tsc < tsc_deadline)
> >               __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> >
> > -     if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> > +     if (lapic_timer_advance_ns == -1)
>
> Rather than expose 'lapic_timer_advance_ns' from x86.c, what if we add a
> 'static bool dynamically_adjust_timer_advance __read_mostly;' in lapic.c,
> and have that be set in kvm_create_lapic() and checked here?  That'd make
> this code a little more readable, would make this patch more obvious (it
> wasn't immediately clear why lapic_timer_advance_ns was being exposed),
> and would reduce the probability of unintentionally writing/corrupting the
> module param.
>
> >               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
> >  }
> >
> > @@ -2302,10 +2302,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> >       apic->lapic_timer.timer.function = apic_timer_fn;
> >       if (timer_advance_ns == -1) {
> >               apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> > -             apic->lapic_timer.timer_advance_adjust_done = false;
> >       } else {
> >               apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> > -             apic->lapic_timer.timer_advance_adjust_done = true;
> >       }
>
> Parentheses can be dropped (unless this is converted to a local global, as
> above).

I just handle all the comments in the new version.

    Wanpeng
