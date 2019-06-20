Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9974C49A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 02:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfFTAvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 20:51:14 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34832 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfFTAvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 20:51:14 -0400
Received: by mail-oi1-f193.google.com with SMTP id a127so848209oii.2;
        Wed, 19 Jun 2019 17:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O2Z3TaFkFdhHBnHs8vQwybNpADodYwyp1V3FBbvLHOs=;
        b=gBHnC9wKfsQjLNlqWDrbhfdKLC5eqzWYGmWuFSjrewwVSKabzK7Tyubls5bNzg0+7J
         HDK0zm1oczErhbJpXQT6soG4dNWYAWnFjUQvIRxlMjozSQrmrA9zEpw66ygmJO7I3d6R
         k/MPjIuV1SkX6DkIXIK38ZNhHQdRjULWuksIVVBdC7jdRi9iuwbpFn3xKT4x6VCqceDj
         B78Y3man1sDanou3NH1duf9Xm27Szki+nVOnDEi8KV0Jsv/uDX+Y33JyfnAPF2RAS7Bo
         QMbojRivjFuEMecVo8XV+yeKqpP6EW/ufcV4ZWoPofuUxsnUYJNP5jyfuC29iCGDts9h
         Adgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O2Z3TaFkFdhHBnHs8vQwybNpADodYwyp1V3FBbvLHOs=;
        b=V8Yk3Xbh6kGrqLK04NoJkQ2rTgl4rkMxaPxzbHTRXW2SPNuKj+ZRHpdS0dJASYamnp
         C1K9WnTzHa73DVcVfkpKkUC0vkKmO1kpbmkg9cl/kO6hRwYtFLy+K3MOsWsXrFNWtUjr
         lrDVLb8QhT2xJ8rlxzJRCRx5CPStHLdehYSC6U0BZ0N1dcCULnr/Qliqn0hpRNzRDo/2
         VCCmprw1yovg4GljKfpQRkNsOI/k55CLscIBLWFZxIDlt88o6VTCTwXnH7HZcerfL7mn
         2oNGNXXnE0N19Oy71CqmPEUq22XUvjNYGGpHMHSivlc03hhwPmQtpbZbaw12p3W+NewS
         OzyQ==
X-Gm-Message-State: APjAAAVkkSyJvZZsc3jfg9ddnSJ7U7tD5Ybpe1mwMf9yYk1AD/g0l6OF
        pIk/FgJjL4NcgzEs73bCbbD85o92o4Q3Xf2+Nsbm99PZ
X-Google-Smtp-Source: APXvYqyfKbiTIUPFcGi7oC4n2TKUY6yMwh9vzktDJIMFhZSzH0b4SeqUqwjyA12fZm0aMLqvNbZdZzjbVZ/viD5WQCU=
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr4408735oia.47.1560991873232;
 Wed, 19 Jun 2019 17:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com> <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com> <20190619210346.GA13033@amt.cnet>
In-Reply-To: <20190619210346.GA13033@amt.cnet>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 20 Jun 2019 08:52:27 +0800
Message-ID: <CANRm+CytP4cvzYhM64opQdKgzrLtXUa4qxky_pDvVciQJd+WPw@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by posted interrupt
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> Hi Li,
>
> On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wro=
te:
> > >
> > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > Dedicated instances are currently disturbed by unnecessary jitter d=
ue
> > > > to the emulated lapic timers fire on the same pCPUs which vCPUs res=
ident.
> > > > There is no hardware virtual timer on Intel for guest like ARM. Bot=
h
> > > > programming timer in guest and the emulated timer fires incur vmexi=
ts.
> > > > This patch tries to avoid vmexit which is incurred by the emulated
> > > > timer fires in dedicated instance scenario.
> > > >
> > > > When nohz_full is enabled in dedicated instances scenario, the emul=
ated
> > > > timers can be offload to the nearest busy housekeeping cpus since A=
PICv
> > > > is really common in recent years. The guest timer interrupt is inje=
cted
> > > > by posted-interrupt which is delivered by housekeeping cpu once the=
 emulated
> > > > timer fires.
> > > >
> > > > The host admin should fine tuned, e.g. dedicated instances scenario=
 w/
> > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surpl=
us
> > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in n=
on-root
> > > > mode, ~3% redis performance benefit can be observed on Skylake serv=
er.
> > > >
> > > > w/o patch:
> > > >
> > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time =
  Avg time
> > > >
> > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us =
  0.71us ( +-   1.09% )
> > > >
> > > > w/ patch:
> > > >
> > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time =
        Avg time
> > > >
> > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us =
  0.72us ( +-   4.02% )
> > > >
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++---=
----
> > > >  arch/x86/kvm/lapic.h            |  1 +
> > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > >  arch/x86/kvm/x86.h              |  2 ++
> > > >  include/linux/sched/isolation.h |  2 ++
> > > >  kernel/sched/isolation.c        |  6 ++++++
> > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 87ecb56..9ceeee5 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lap=
ic *apic)
> > > >       return apic->vcpu->vcpu_id;
> > > >  }
> > > >
> > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > >
> > > Paolo, can you explain the reasoning behind this?
> > >
> > > Should not be necessary...
> >
> > Here some new discussions:
> > https://lkml.org/lkml/2019/6/13/1423
>
> Not sure what this has to do with injecting timer
> interrupts via posted interrupts ?

Yeah, need more explain from Paolo! Ping Paolo,

>
> > https://lkml.org/lkml/2019/6/13/1420
>
> Two things (unrelated to the above):
>
> 1) hrtimer_reprogram is unable to wakeup a remote vCPU, therefore
> i believe execution of apic_timer_expired can be delayed.
> Should wakeup the CPU which hosts apic_timer_expired.
>
>
>         /*
>          * If the timer is not on the current cpu, we cannot reprogram
>          * the other cpus clock event device.
>          */
>         if (base->cpu_base !=3D cpu_base)
>                 return;

If it is not the first expiring timer on the new target, we don't need
to reprogram. It can't be the first expired timer on the new target
since below:

/*
 * We switch the timer base to a power-optimized selected CPU target,
 * if:
 * - NO_HZ_COMMON is enabled
 * - timer migration is enabled
 * - the timer callback is not running
 * - the timer is not the first expiring timer on the new target
 *
 * If one of the above requirements is not fulfilled we move the timer
 * to the current CPU or leave it on the previously assigned CPU if
 * the timer callback is currently running.
 */
static inline struct hrtimer_clock_base *
switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
   int pinned)

>
> 2) Getting an oops when running cyclictest, debugging...

Radim point out one issue in patch 5/5, not sure that is cause.

Regards,
Wanpeng Li
