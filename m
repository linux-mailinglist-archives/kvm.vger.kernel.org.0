Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF013C0F3
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 03:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390658AbfFKBhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 21:37:34 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34755 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389168AbfFKBhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 21:37:33 -0400
Received: by mail-oi1-f196.google.com with SMTP id u64so7736447oib.1;
        Mon, 10 Jun 2019 18:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fGPZMeJ1EnlKMpnGfl89g5dre+BiZQl2zm9s8Z/1iC8=;
        b=pBIiVtcuDIrxjR3mwZAwHasTxfrU3E8tSa6iKlMHgdcsVGAO1FLfZyMfphJjILWwZA
         nCankq2MqTbsPuZaazyT++K+xbajOpWJj5AjQGZy7T8TC/6DoGPY5uXBMt3cgNgWorTR
         +WEhUdMEBeoTlv4je+ABlPa4qoQgZ1+9LuFONO5458xEQKGAUgbmuzfciXXGfw6zNojg
         HCIV+/E8+FQ/xe0H4/hFXSJ46H7pLCiJAL6wzEcV1NH3QSuSMESn3pewukUb4QsiNrJm
         jftom9v9GcJ++F7hbdc7sh1rWaI23L0CCWIUlWlZtDAqEOaj1/abCRwxd5400PMMevXj
         cL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fGPZMeJ1EnlKMpnGfl89g5dre+BiZQl2zm9s8Z/1iC8=;
        b=o09jLdXIxGadiFpDuUMsB7jigHDytCad37JxvlDTpsvu2Y4PF6bOnydWjBuda9/g/Y
         hPWfcClwQdjFzqY81y4oqcWewApNLq0cqWqIzy5UL4k6W4L/aqCeXdabexu1fojFZoOO
         Fw/NQKvuwuSCDv5EKxwVuw9OoQ5mYRLA9Gh+PTPCl2AKCoY90OX2OWDJOu+f42swLHF/
         s+oPr1FJboO+SBTn7Puhinn+B1ERLGIwIn706XLEYlofP5iqojd8rcyMqhV1IG00mtN7
         nLtqBNkpxzAWswxu095TklIcplRF5j/kJdas7JCd8yznbCxkxWfCyPi1RUKzOlVj+GTt
         GfSQ==
X-Gm-Message-State: APjAAAWOFvpFZHCWK3xYDGstOZMdIZmA+AFRMYhbYqPMKvFNMo8UH1vE
        7e2LqE87zz0XGqZKps2t2IFlxJWwzE4XMCZReRE=
X-Google-Smtp-Source: APXvYqwNj1lVGk5KSffnwL4YiLo49T5IAtiZ6lJoASphoz+XfG9ITpyB+ZYnGj1xThfg2Uwa7mqcmmBfkC6ySH9SsDw=
X-Received: by 2002:aca:544b:: with SMTP id i72mr14141895oib.174.1560217052971;
 Mon, 10 Jun 2019 18:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com> <20190611012118.GC24835@linux.intel.com>
In-Reply-To: <20190611012118.GC24835@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 09:38:18 +0800
Message-ID: <CANRm+CxrYJXB1WaBz0w1NpBkz8p5tAsmyoAVwTO0MueqcDkQLQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 09:21, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 31, 2019 at 02:40:13PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Advance lapic timer tries to hidden the hypervisor overhead between the
> > host emulated timer fires and the guest awares the timer is fired. Howe=
ver,
> > even though after more sustaining optimizations, kvm-unit-tests/tscdead=
line_latency
> > still awares ~1000 cycles latency since we lost the time between the en=
d of
> > wait_lapic_expire and the guest awares the timer is fired. There are
> > codes between the end of wait_lapic_expire and the world switch, furthe=
rmore,
> > the world switch itself also has overhead. Actually the guest_tsc is eq=
ual
> > to the target deadline time in wait_lapic_expire is too late, guest wil=
l
> > aware the latency between the end of wait_lapic_expire() and after vmen=
try
> > to the guest. This patch takes this time into consideration.
> >
> > The vmentry_lapic_timer_advance_ns module parameter should be well tune=
d by
> > host admin, setting bit 0 to 1 to finally cache parameter in KVM. This =
patch
> > can reduce average cyclictest latency from 3us to 2us on Skylake server=
.
> > (guest w/ nohz=3Doff, idle=3Dpoll, host w/ preemption_timer=3DN, the cy=
clictest
> > latency is not too sensitive when preemption_timer=3DY for this optimiz=
ation in
> > my testing), kvm-unit-tests/tscdeadline_latency can reach 0.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > NOTE: rebase on https://lkml.org/lkml/2019/5/20/449
> > v1 -> v2:
> >  * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
> >  * cache vmentry_advance_cycles by setting param bit 0
> >  * add param max limit
> >
> >  arch/x86/kvm/lapic.c   | 38 +++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/lapic.h   |  3 +++
> >  arch/x86/kvm/vmx/vmx.c |  2 +-
> >  arch/x86/kvm/x86.c     |  9 +++++++++
> >  arch/x86/kvm/x86.h     |  2 ++
> >  5 files changed, 50 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index fcf42a3..60587b5 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1531,6 +1531,38 @@ static inline void adjust_lapic_timer_advance(st=
ruct kvm_vcpu *vcpu,
> >       apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >  }
> >
> > +#define MAX_VMENTRY_ADVANCE_NS 1000
> > +
> > +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
>
> This can be static, unless get_vmentry_advance_cycles() is moved to
> lapic.h, in which case compute_vmentry_advance_cycles() would need to be
> exported.

Thanks for the review, Sean. I think Paolo has already drop this one.
https://lkml.org/lkml/2019/5/31/210

Regards,
Wanpeng Li
