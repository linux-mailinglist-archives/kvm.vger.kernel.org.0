Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A411C03D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 02:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfENA6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 20:58:01 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36508 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfENA6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 20:58:01 -0400
Received: by mail-ot1-f67.google.com with SMTP id c3so13622316otr.3;
        Mon, 13 May 2019 17:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5rfYyyZa4QBXLtekQDW2u5rDpfxUQyTQIBx6qQjkZZ4=;
        b=STE7B08orS/QS1xLAmu/iG54QcoWAH8ulUI5uQKsqI3U2f0l1EXc3Dh++7OFgjilXW
         tCEenF2dSwOppEGDc+der5j6JeQpJvXS2DJKhmFx0cv/92PlJwSDvaBKrLeTb3b5DBvr
         BrOhDbLQBZcn7eqsbd8kcdrWQAB6DRhuYrhd7yDSkDpuxyBVkC4soxZSnzO5WkWaVEhB
         ZY12FRnKmmzEP7Bz2tNPUb0W1F/x5bb6p53N878+/TSMTehNYzkkbE8maV5bxRpFGnHk
         zf/RrgYetQJOqOPh6MRpHRrp8ICEkhP863BjlJ62aUdM/NQv+5sc+MMNgJtIqjqrIp77
         YWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5rfYyyZa4QBXLtekQDW2u5rDpfxUQyTQIBx6qQjkZZ4=;
        b=Ligb/2tgDG3sOodUldt7IhivJuWCTNMNiQYAzO/Rw5rGFCShIe2L4IDF0tYvCLp8Kk
         85CF3YXh5UZ4RZ3p8dU0x/L7lydbLhXxzbOPjnhe7EGi2Ukbh9gi4nbEIYTsZ/H/YMIV
         /IwCZCoGS+OdbExRn0JlLK9905CUhm+3SzfGRzukDFEKCn546XwqRy7/kefBZAlwvad0
         Q92YboyTC9q3yl1AmXIWH+wxS0jiH3fbhqG1LcSZIDJZWVJbWzJZh9h4PFk0tnTuRHvA
         Ke3b5jL1clqkCxda5B90zlrtt2DsdZrVg1IN4P0pYASkSznsggbiARGTkP8qn2YhAfhL
         HUOA==
X-Gm-Message-State: APjAAAUz0bcIzjAtJb4jUBaqKwi5HIGmqpGO/cXtWRGMSZ2DFMwwIO1r
        XKlw9ZhhRx8OK4rh3+1mRWFKvkYhQ23dK6ofysw=
X-Google-Smtp-Source: APXvYqxm+eya3WzAyTbMyI5pqWDx7Hc+i7L8iNYMsWhxZ+8oXd4MDWPwOeCiCPZNrI8CJG2SKH/Bcy94nAMIDN6H4HM=
X-Received: by 2002:a9d:588b:: with SMTP id x11mr15757624otg.295.1557795480507;
 Mon, 13 May 2019 17:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-2-git-send-email-wanpengli@tencent.com> <20190513193940.GL28561@linux.intel.com>
In-Reply-To: <20190513193940.GL28561@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 14 May 2019 08:59:14 +0800
Message-ID: <CANRm+Cyoip9Yq7cbeo0O8wrVWbZZ59QnRFEtD5DC452Spc3M+Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: LAPIC: Extract adaptive tune timer advancement logic
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 at 03:39, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 09, 2019 at 07:29:19PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Extract adaptive tune timer advancement logic to a single function.
>
> Why?

Just because the function wait_lapic_expire() is too complex now.

Regards,
Wanpeng Li

>
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 57 ++++++++++++++++++++++++++++++--------------=
--------
> >  1 file changed, 33 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index bd13fdd..e7a0660 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1501,11 +1501,41 @@ static inline void __wait_lapic_expire(struct k=
vm_vcpu *vcpu, u64 guest_cycles)
> >       }
> >  }
> >
> > -void wait_lapic_expire(struct kvm_vcpu *vcpu)
> > +static inline void adaptive_tune_timer_advancement(struct kvm_vcpu *vc=
pu,
> > +                             u64 guest_tsc, u64 tsc_deadline)
> >  {
> >       struct kvm_lapic *apic =3D vcpu->arch.apic;
> >       u32 timer_advance_ns =3D apic->lapic_timer.timer_advance_ns;
> > -     u64 guest_tsc, tsc_deadline, ns;
> > +     u64 ns;
> > +
> > +     if (!apic->lapic_timer.timer_advance_adjust_done) {
> > +                     /* too early */
> > +                     if (guest_tsc < tsc_deadline) {
> > +                             ns =3D (tsc_deadline - guest_tsc) * 10000=
00ULL;
> > +                             do_div(ns, vcpu->arch.virtual_tsc_khz);
> > +                             timer_advance_ns -=3D min((u32)ns,
> > +                                     timer_advance_ns / LAPIC_TIMER_AD=
VANCE_ADJUST_STEP);
> > +                     } else {
> > +                     /* too late */
> > +                             ns =3D (guest_tsc - tsc_deadline) * 10000=
00ULL;
> > +                             do_div(ns, vcpu->arch.virtual_tsc_khz);
> > +                             timer_advance_ns +=3D min((u32)ns,
> > +                                     timer_advance_ns / LAPIC_TIMER_AD=
VANCE_ADJUST_STEP);
> > +                     }
> > +                     if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_A=
DVANCE_ADJUST_DONE)
> > +                             apic->lapic_timer.timer_advance_adjust_do=
ne =3D true;
> > +                     if (unlikely(timer_advance_ns > 5000)) {
> > +                             timer_advance_ns =3D 0;
> > +                             apic->lapic_timer.timer_advance_adjust_do=
ne =3D true;
> > +                     }
> > +                     apic->lapic_timer.timer_advance_ns =3D timer_adva=
nce_ns;
> > +             }
>
> This whole block is indented too far.
>
> > +}
> > +
> > +void wait_lapic_expire(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > +     u64 guest_tsc, tsc_deadline;
> >
> >       if (apic->lapic_timer.expired_tscdeadline =3D=3D 0)
> >               return;
> > @@ -1521,28 +1551,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
> >       if (guest_tsc < tsc_deadline)
> >               __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> >
> > -     if (!apic->lapic_timer.timer_advance_adjust_done) {
> > -             /* too early */
> > -             if (guest_tsc < tsc_deadline) {
> > -                     ns =3D (tsc_deadline - guest_tsc) * 1000000ULL;
> > -                     do_div(ns, vcpu->arch.virtual_tsc_khz);
> > -                     timer_advance_ns -=3D min((u32)ns,
> > -                             timer_advance_ns / LAPIC_TIMER_ADVANCE_AD=
JUST_STEP);
> > -             } else {
> > -             /* too late */
> > -                     ns =3D (guest_tsc - tsc_deadline) * 1000000ULL;
> > -                     do_div(ns, vcpu->arch.virtual_tsc_khz);
> > -                     timer_advance_ns +=3D min((u32)ns,
> > -                             timer_advance_ns / LAPIC_TIMER_ADVANCE_AD=
JUST_STEP);
> > -             }
> > -             if (abs(guest_tsc - tsc_deadline) < LAPIC_TIMER_ADVANCE_A=
DJUST_DONE)
> > -                     apic->lapic_timer.timer_advance_adjust_done =3D t=
rue;
> > -             if (unlikely(timer_advance_ns > 5000)) {
> > -                     timer_advance_ns =3D 0;
> > -                     apic->lapic_timer.timer_advance_adjust_done =3D t=
rue;
> > -             }
> > -             apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> > -     }
> > +     adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
> >  }
> >
> >  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> > --
> > 2.7.4
> >
