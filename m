Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6D387864
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245395AbhERMF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244853AbhERMFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:05:21 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE3DC061756;
        Tue, 18 May 2021 05:04:03 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id s5-20020a05683004c5b029032307304915so1119253otd.7;
        Tue, 18 May 2021 05:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnEkWdOm+ENMVf7yX2CMz4AbmpChSKu1dSZbsT4Oixw=;
        b=fA10MkgaqDEVhjoHM2C49i5DiSk8QAv4S6KmSm+TWymGUNEmMNwlQWgVBOL+FX5xNJ
         jBMhtpWp2zR7jsRBbqdKIlYPrkI3GHhwKNET3JTmsE77g6Nq3xdwTNXQwlpNyCzVfwGI
         8bBel7+0EimQUk0jK0YdphDaRqwBErksDkKo3YQJoXqrz+KvXSwJldlfcYMVMkJVcrDs
         Neyw/FG6h991r91f4QDnNev86TDyIW/OlVorhwyDbCo4pdVaD3JF75bicZJYqVVgoxlP
         jixurboqH+jmKiWNvEl4c5AVp9GS6343Id+BXrWYIgUofhRFfEyXDzIL0BYd/LY3kXiX
         Fozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnEkWdOm+ENMVf7yX2CMz4AbmpChSKu1dSZbsT4Oixw=;
        b=WUME1Te3JKHh+tV5ER9dUulckhFvycapsnsqOHO9Sl8iYsgEvHcVZPG2C7/CORkJLD
         0W6XGQdDQoPjI7pHs9MyfOO82oq1yargpDcGHQFMMPWggML2aQwRyBrOKe9/romt8iwL
         FQ+i42vUQr+n1ZAN/w58ArRjJJkOPkScwbUB60QaxCJf42u8UAm37lzU5WTAtRSEW/wb
         7j35epn2GcRZbHXmaNSyyVwDSBze2qnEoeouVV2gD8uZ26+4mo4aQKcmE5aClaLEF5Rg
         7TsFawLQVUgLHLMEJpmrF/3mW7pADGKMwVMtL1YPfJ94FpDrBlPpE8txG31fGHgUxod/
         momg==
X-Gm-Message-State: AOAM532pph1ckAK8OjF7+DHDj1fWYwDC1DBH86ZWxg+B1x8nGYUfko+k
        a+jmCLgg0i5uQy/FzvD3cX/81hO7b0irCsco7kQ=
X-Google-Smtp-Source: ABdhPJyIaAZb1sIkjlEXWT/sarDwOHEse+DMPZ5WggyfW2+nl28U6UnNUU6DCxuQTi70TB7lL7jko4irKlixMQcEvJM=
X-Received: by 2002:a9d:2966:: with SMTP id d93mr4007167otb.56.1621339443306;
 Tue, 18 May 2021 05:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
 <1621260028-6467-5-git-send-email-wanpengli@tencent.com> <YKKtFOl3oklFp1lW@google.com>
In-Reply-To: <YKKtFOl3oklFp1lW@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 May 2021 20:03:52 +0800
Message-ID: <CANRm+CyHSQBXa6D2VYgysNaVwnRbK8xQ02_zoHkvxrKXAh6+CQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: LAPIC: Narrow the timer latency between
 wait_lapic_expire and world switch
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 at 01:51, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 17, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Let's treat lapic_timer_advance_ns automatically tune logic as hypervisor
> > overhead, move it before wait_lapic_expire instead of between wait_lapic_expire
> > and the world switch, the wait duration should be calculated by the
> > up-to-date guest_tsc after the overhead of automatically tune logic. This
> > patch reduces ~30+ cycles for kvm-unit-tests/tscdeadline-latency when testing
> > busy waits.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index c0ebef560bd1..552d2acf89ab 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1598,11 +1598,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >       guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> >       apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
> >
> > -     if (guest_tsc < tsc_deadline)
> > -             __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> > -
> >       if (lapic_timer_advance_dynamic)
> >               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
> > +
> > +     guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>
> This is redundant and unnecessary if automatic tuning is disabled, or if the
> timer did not arrive early.  A comment would also be helpful.  E.g. I think this
> would micro-optimize all paths:

Do it in v4, thanks.

    Wanpeng

>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c0ebef560bd1..5d91f2367c31 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1598,11 +1598,19 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>         apic->lapic_timer.advance_expire_delta = guest_tsc - tsc_deadline;
>
> +       if (lapic_timer_advance_dynamic) {
> +               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
> +               /*
> +                * If the timer fired early, reread the TSC to account for the
> +                * overhead of the above adjustment to avoid waiting longer
> +                * than is necessary.
> +                */
> +               if (guest_tsc < tsc_deadline)
> +                       guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> +       }
> +
>         if (guest_tsc < tsc_deadline)
>                 __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> -
> -       if (lapic_timer_advance_dynamic)
> -               adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
>
>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>
> > +     if (guest_tsc < tsc_deadline)
> > +             __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> >  }
> >
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> > --
> > 2.25.1
> >
