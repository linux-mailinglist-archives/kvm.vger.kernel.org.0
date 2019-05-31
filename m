Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B967308D3
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfEaGlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:41:37 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43210 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaGlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:41:36 -0400
Received: by mail-ot1-f68.google.com with SMTP id i8so8105987oth.10;
        Thu, 30 May 2019 23:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IEp6YnRYtBI3k0AHk7RIVAfM1GTZ+Bf/+Lw9qUYFQl0=;
        b=XVxhIq8DqMD3SwJQx3S72O1+y0bzomnt8H9PpIZ6COi05oJPP08JLpDMHFsIEoP+Xv
         m0iLtzjKPrPF4SHfWVXpWdnuFOmfYPz2iD0tOcQ+6jt4ozWM5e8SaqPOdNkclRL/RO+X
         8jZ9AelwQ6WWBgSYCLu+3Lgz7G4610xmC0wFjMqZuL946A4QaE0w4D+/wUHQf+9YhvV9
         MwUarVsilswA7aXgHo3gXag/MU0d/c83zitSOQkoLsCpzq+L4S1yE9ZENqjCMv49XCfO
         e1PE17Eu2SgSd2YL2N/b4+lGVgQMeHykCUrE3KK/gHPrk2tFTVcG9xxfTzCsw7xPEvUV
         On+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IEp6YnRYtBI3k0AHk7RIVAfM1GTZ+Bf/+Lw9qUYFQl0=;
        b=b+a6WBb0qggKSvr7UNpn23J5DRzr6vErXMIICbCyWrYjuvBVhNISRY0+x62u62KZSK
         5eKxOxTHDoxqKOHf16XNtSDA5l9IbFiJa6bGVPsmR7CJudhypIU+QGCDpfq70WOZLkgW
         pA4N8DRQM98LDndGnGm5YIZ/QIkSKzUWhR9aUMbJNgZXSW8ijDOhyD2M7qxGmB0ys04/
         XAeRNVMEz7SSBjXzdCLba0GSWllF8pRvxmGOWbR7JxE55X7aUIMeUNYqjWBejgX7jvEZ
         C3Xs3yzFJCznMgQGanTOuFJvHLxzzVrEJUrVSx1+WLVb07Gk2b6L/AhpNeW8GFdc2l9A
         eB/g==
X-Gm-Message-State: APjAAAXLIAoQeJ2edzYxF++q7CBdP8bawG4tY2UgFsre+smX7GFLhAq0
        qT3/b8LS3y46CMtVu7xHbxFnWxAKGOUv1CXkhlU=
X-Google-Smtp-Source: APXvYqyrhIO1/T7ysI79mc6QTXa5eTv2tllHe0vWkRSq+mUbUjCQlRtgzBcwnlWnhDedMHx2gBrUhTfinInjwyQQoNY=
X-Received: by 2002:a9d:469a:: with SMTP id z26mr602911ote.56.1559284895795;
 Thu, 30 May 2019 23:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <1558585131-1321-1-git-send-email-wanpengli@tencent.com> <20190530193653.GA27551@linux.intel.com>
In-Reply-To: <20190530193653.GA27551@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 31 May 2019 14:41:25 +0800
Message-ID: <CANRm+CxW70MZo_LRCNg_TivPrNPQ2ZvzBL+ugZ4Gy+_Cw2UFVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: Optimize timer latency consider world
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

On Fri, 31 May 2019 at 03:36, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 23, 2019 at 12:18:50PM +0800, Wanpeng Li wrote:
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
> > codes between the end of wait_lapic_expire and the world switch, futher=
more,
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
> > host admin, it can reduce average cyclictest latency from 3us to 2us on
> > Skylake server. (guest w/ nohz=3Doff, idle=3Dpoll, host w/ preemption_t=
imer=3DN,
> > the cyclictest latency is not too sensitive when preemption_timer=3DY f=
or this
> > optimization in my testing), kvm-unit-tests/tscdeadline_latency can rea=
ch 0.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c   | 17 +++++++++++++++--
> >  arch/x86/kvm/lapic.h   |  1 +
> >  arch/x86/kvm/vmx/vmx.c |  2 +-
> >  arch/x86/kvm/x86.c     |  3 +++
> >  arch/x86/kvm/x86.h     |  2 ++
> >  5 files changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index fcf42a3..6f85221 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1531,6 +1531,19 @@ static inline void adjust_lapic_timer_advance(st=
ruct kvm_vcpu *vcpu,
> >       apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >  }
> >
> > +u64 get_vmentry_advance_delta(struct kvm_vcpu *vcpu)
>
> Hmm, this isn't a delta, I think get_vmentry_advance_cycles would be more
> appropriate.
>
> > +{
> > +     u64 vmentry_lapic_timer_advance_cycles =3D 0;
> > +
> > +     if (vmentry_lapic_timer_advance_ns) {
> > +             vmentry_lapic_timer_advance_cycles =3D vmentry_lapic_time=
r_advance_ns *
> > +                     vcpu->arch.virtual_tsc_khz;
> > +             do_div(vmentry_lapic_timer_advance_cycles, 1000000);
> > +     }
> > +     return vmentry_lapic_timer_advance_cycles;
> > +}
> > +EXPORT_SYMBOL_GPL(get_vmentry_advance_delta);
> > +
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_lapic *apic =3D vcpu->arch.apic;
> > @@ -1544,7 +1557,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >
> >       tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
> >       apic->lapic_timer.expired_tscdeadline =3D 0;
> > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advanc=
e_delta(vcpu);
> >       apic->lapic_timer.advance_expire_delta =3D guest_tsc - tsc_deadli=
ne;
> >
> >       if (guest_tsc < tsc_deadline)
> > @@ -1572,7 +1585,7 @@ static void start_sw_tscdeadline(struct kvm_lapic=
 *apic)
> >       local_irq_save(flags);
> >
> >       now =3D ktime_get();
> > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advanc=
e_delta(vcpu);
> >
> >       ns =3D (tscdeadline - guest_tsc) * 1000000ULL;
> >       do_div(ns, this_tsc_khz);
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index f974a3d..df2fe17 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -221,6 +221,7 @@ static inline int kvm_lapic_latched_init(struct kvm=
_vcpu *vcpu)
> >  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
> >
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> > +u64 get_vmentry_advance_delta(struct kvm_vcpu *vcpu);
> >
> >  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_ir=
q *irq,
> >                       struct kvm_vcpu **dest_vcpu);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index da24f18..0199ac3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7047,7 +7047,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu=
, u64 guest_deadline_tsc,
> >
> >       vmx =3D to_vmx(vcpu);
> >       tscl =3D rdtsc();
> > -     guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl);
> > +     guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_=
delta(vcpu);
> >       delta_tsc =3D max(guest_deadline_tsc, guest_tscl) - guest_tscl;
> >       lapic_timer_advance_cycles =3D nsec_to_cycles(vcpu,
> >                                                   ktimer->timer_advance=
_ns);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a4eb711..a02e2c3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -145,6 +145,9 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_I=
WUSR);
> >  static int __read_mostly lapic_timer_advance_ns =3D -1;
> >  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> >
> > +u32 __read_mostly vmentry_lapic_timer_advance_ns =3D 0;
> > +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
>
> Hmm, an interesting idea would be to have some way to "lock" this param,
> e.g. setting bit 0 locks the param.  That would allow KVM to calculate th=
e
> cycles value to avoid the function call and the MUL+DIV.  If I'm not
> mistaken, vcpu->arch.virtual_tsc_khz is set only in kvm_set_tsc_khz().
>
> For example, if get_vmentry_advance_cycles() sees the value is locked, it
> caches the value in struct kvm_lapic.  The cached value would also need t=
o
> be updated in kvm_set_tsc_khz() if it has been set.

Good point, handle it in v2.

Regards,
Wanpeng Li

>
> static inline u64 get_vmentry_advance_cycles(struct kvm_lapic *lapic)
> {
>         if (lapic->vmentry_advance_cycles)
>                 return lapic->vmentry_advance_cycles;
>
>         return compute_vmentry_advance_cycles(lapic);
> }
>
> u64 compute_vmentry_advance_cycles(struct kvm_lapic *lapic)
> {
>         u64 val =3D vmentry_lapic_timer_advance_ns;
>         u64 cycles =3D (val & ~1ULL) * lapic->vcpu->arch.virtual_tsc_khz;
>
>         do_div(cycles, 1000000);
>
>         if (val & 1)
>                 lapic->vmentry_advance_cycles =3D cycles;
>         return cycles;
> }
>
> > +
> >  static bool __read_mostly vector_hashing =3D true;
> >  module_param(vector_hashing, bool, S_IRUGO);
> >
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 275b3b6..b0a3b84 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -294,6 +294,8 @@ extern u64 kvm_supported_xcr0(void);
> >
> >  extern unsigned int min_timer_period_us;
> >
> > +extern unsigned int vmentry_lapic_timer_advance_ns;
> > +
> >  extern bool enable_vmware_backdoor;
> >
> >  extern struct static_key kvm_no_apic_vcpu;
> > --
> > 2.7.4
> >
