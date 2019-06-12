Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34240420B0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408721AbfFLJ0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:26:18 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36509 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406598AbfFLJ0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:26:18 -0400
Received: by mail-oi1-f195.google.com with SMTP id w7so11174345oic.3;
        Wed, 12 Jun 2019 02:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+wBbh02PquGQYzMb8PBH+bcdYLtCgL7ng1xqyOD2UWk=;
        b=OMR+UiN/wLemTK6SD0hMMTPGSri2avW5VVW6DEO2Ejbklqa6ZEimHszzZbmNWWdbmy
         GjUVxSi8kLYAthKJVQBUKnz+vI4LC7DZevdiKWd7trhUfP0WFA1ozRGmvd2IavdR6E1e
         JpzI6bAZ+SKGLgQM4DTT3xuT36HqnFFOFxUB05KcTW7BVnUDpgejgqIBaWllAMrf9+Ia
         wcXgKEd15cNjfrLL2fg7RmdeW6U5cJdNjuj+CRVJlm4lo75gwnNGCvOXnWn4I9etlt3c
         NT38OUotZWdrdcS8pv7EU20O90lQfo+bJMhWlbo7ntRtu0FLMUQMO3kEO3udjJTFu04H
         K5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+wBbh02PquGQYzMb8PBH+bcdYLtCgL7ng1xqyOD2UWk=;
        b=mxM0CDXX6HLbiXcaMyLQGvPzSTNFab3cs9oJsmw5JiidjQvqS/yp406+d4tTJfxL12
         yuHS4WRN6ULFvmR0zoJx6hW93+5N7OagJZDTzIzijgoNlDhuIXZyBsUDkNORdiu9RrK2
         L8F6iw9HvuFaAjJUK5+NoMSelFWoVkZDnAFdpVR9wrMKt0SmNVGznM+m/ugi8JGENWN8
         RPexxElOagODDy743yr4LDGXSCNMhXBQvycY8TliYYO1QKTyHiq0JW9WADHqhG24lxdx
         xmkXnv8dEBjl+i1A8gG+jKsf8y8WmKH/VQ5JwRccu4QoJVIBv60zCmIim6/t7T2yIMGK
         57ug==
X-Gm-Message-State: APjAAAX5BkbJP0dsiboPFLGE3u7k5j3B/+MLvtY+lm5YmAs45xyhqSE6
        eL2jUhYtW+qEspx9TC/D4xxcqu1152Pt8SmcLdo=
X-Google-Smtp-Source: APXvYqxsHz4A4siDqGDH5Yf3W+tXjAuKmkRdmOUOBGQcfLzPLQxyws01E4CK5Q8nDMFzHjv52X40ST0gG3kwb5pQ/OA=
X-Received: by 2002:aca:51ce:: with SMTP id f197mr18760856oib.33.1560331577426;
 Wed, 12 Jun 2019 02:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com> <20190611012118.GC24835@linux.intel.com>
In-Reply-To: <20190611012118.GC24835@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 17:27:00 +0800
Message-ID: <CANRm+CxTOz-6dkgZTbsw5VTPFJkMB2wcBBqf98E4KJw0k4jYMA@mail.gmail.com>
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

compute_vmentry_advance_cycles() is also used in x86.c

> lapic.h, in which case compute_vmentry_advance_cycles() would need to be
> exported.
>
> > +{
> > +     u64 cycles;
> > +     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > +     u64 val =3D min_t(u32, vmentry_lapic_timer_advance_ns, MAX_VMENTR=
Y_ADVANCE_NS);
> > +
> > +     cycles =3D (val & ~1ULL) * vcpu->arch.virtual_tsc_khz;
> > +     do_div(cycles, 1000000);
> > +
> > +     /* setting bit 0 locks the value, it is cached */
> > +     if (val & 1)
> > +             apic->lapic_timer.vmentry_advance_cycles =3D cycles;
> > +
> > +     return cycles;
> > +}
> > +
> > +inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
>
> This shouldn't be 'inline' since it's exported from a C file.  That being

Agreed.

> said, I think it's short enough to define as a 'static inline' in lapic.h=
.
>
> > +{
> > +     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > +
> > +     if (!vmentry_lapic_timer_advance_ns)
> > +             return 0;
> > +
> > +     if (likely(apic->lapic_timer.vmentry_advance_cycles))
> > +             return apic->lapic_timer.vmentry_advance_cycles;
> > +
> > +     return compute_vmentry_advance_cycles(vcpu);
> > +}
> > +EXPORT_SYMBOL_GPL(get_vmentry_advance_cycles);
> > +
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_lapic *apic =3D vcpu->arch.apic;
> > @@ -1544,7 +1576,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >
> >       tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
> >       apic->lapic_timer.expired_tscdeadline =3D 0;
> > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advanc=
e_cycles(vcpu);
> >       apic->lapic_timer.advance_expire_delta =3D guest_tsc - tsc_deadli=
ne;
> >
> >       if (guest_tsc < tsc_deadline)
> > @@ -1572,7 +1604,7 @@ static void start_sw_tscdeadline(struct kvm_lapic=
 *apic)
> >       local_irq_save(flags);
> >
> >       now =3D ktime_get();
> > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) + get_vmentry_advanc=
e_cycles(vcpu);
> >
> >       ns =3D (tscdeadline - guest_tsc) * 1000000ULL;
> >       do_div(ns, this_tsc_khz);
> > @@ -2329,7 +2361,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int t=
imer_advance_ns)
> >               apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >               apic->lapic_timer.timer_advance_adjust_done =3D true;
> >       }
> > -
> > +     apic->lapic_timer.vmentry_advance_cycles =3D 0;
> >
> >       /*
> >        * APIC is created enabled. This will prevent kvm_lapic_set_base =
from
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index f974a3d..70854a9 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -33,6 +33,7 @@ struct kvm_timer {
> >       u64 expired_tscdeadline;
> >       u32 timer_advance_ns;
> >       s64 advance_expire_delta;
> > +     u64 vmentry_advance_cycles;
> >       atomic_t pending;                       /* accumulated triggered =
timers */
> >       bool hv_timer_in_use;
> >       bool timer_advance_adjust_done;
> > @@ -221,6 +222,8 @@ static inline int kvm_lapic_latched_init(struct kvm=
_vcpu *vcpu)
> >  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
> >
> >  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> > +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
> > +inline u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu);
> >
> >  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_ir=
q *irq,
> >                       struct kvm_vcpu **dest_vcpu);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index a341663..255b5d5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7047,7 +7047,7 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu=
, u64 guest_deadline_tsc,
> >
> >       vmx =3D to_vmx(vcpu);
> >       tscl =3D rdtsc();
> > -     guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl);
> > +     guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl) + get_vmentry_advance_=
cycles(vcpu);
> >       delta_tsc =3D max(guest_deadline_tsc, guest_tscl) - guest_tscl;
> >       lapic_timer_advance_cycles =3D nsec_to_cycles(vcpu,
> >                                                   ktimer->timer_advance=
_ns);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 69c3672e..0d4eb27 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -145,6 +145,13 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_=
IWUSR);
> >  static int __read_mostly lapic_timer_advance_ns =3D -1;
> >  module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
> >
> > +/*
> > + * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.=
 Setting
> > + * bit 0 to 1 after well manually tuning to cache vmentry advance time=
.
> > + */
> > +u32 __read_mostly vmentry_lapic_timer_advance_ns =3D 0;
> > +module_param(vmentry_lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
> > +
> >  static bool __read_mostly vector_hashing =3D true;
> >  module_param(vector_hashing, bool, S_IRUGO);
> >
> > @@ -1592,6 +1599,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu,=
 u32 user_tsc_khz)
> >       kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
> >                          &vcpu->arch.virtual_tsc_shift,
> >                          &vcpu->arch.virtual_tsc_mult);
> > +     if (vcpu->arch.apic && user_tsc_khz !=3D vcpu->arch.virtual_tsc_k=
hz)
> > +             compute_vmentry_advance_cycles(vcpu);
> >       vcpu->arch.virtual_tsc_khz =3D user_tsc_khz;
> >
> >       /*
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
