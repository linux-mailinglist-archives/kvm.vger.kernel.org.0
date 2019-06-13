Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98239446F8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393134AbfFMQz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:55:59 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34585 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbfFMBuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 21:50:08 -0400
Received: by mail-ot1-f66.google.com with SMTP id n5so2065051otk.1;
        Wed, 12 Jun 2019 18:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gx3YnKtSzt9rdh6pfGvWWJAMtveCUZj5zGsX07BxLkE=;
        b=rduUuyGFaWFmehp25pw2u4x5VizGp1fuJ4cUrodAmj6wCZG2cGhNo/deAmDtrD+Nb2
         EgcJlxTGHLr6AOHQZDRcHyA832lusHkxiuEput7wPApYTdFzAGaVJ+OfO3ptFvxor5PR
         vlbLgSf3C5leAzA4kJWdsT61MdQO7toyeezQ2fBZHQ3fjkuHb/oaI9gK89i/Oaj0/4gN
         OhMz0rQNzKCxsZUCNj6GwhOFsvIKsYw4j4lTP3CjvC/cf0oFjWgZHeaZVPHLFbg9Gz0n
         zHiUAmQnMJFjei40R3eFF8rSy0DTOpDjT4oYp8VLd94La2ns4XPq9CyBFT0so787P1yK
         PWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gx3YnKtSzt9rdh6pfGvWWJAMtveCUZj5zGsX07BxLkE=;
        b=g25+AHZbU1tChW8BLMQTRluV0lQiO/wFRCRD44PdIIM83Ip541LUNX1HZ8Ns9g1Eru
         fFa1C4udEZtWCr6cVBDRJdZGTd4EPnMB1D4BHGB6l9pDCi4LTV0pWCWubTIzzzCphV8E
         NX3az3PCiCkHI2gwQMmTu+e2NVaRynzrGFEuFvoFV+4Y7hVl997ymlKZvszyTS3VdVDi
         fJ4PJ7x3yC6xLLzvTJ3vDpWep69BGxh4HNlzz77qavOeg1z821gBR800BmuKptK4Wr8F
         pPeAC16hjhRF7oqYfdrdwRosn8ydUQ8sFUOYgfeUnce4Avi8iqst/28toKnJRsGH6YBV
         9SnQ==
X-Gm-Message-State: APjAAAUhMQwgipoOIvX6HvGjeRHpcV7kevMt71O8MKQJgcu5U7zdW5oZ
        e/fZ8R/ocTWqYTt54xXi1mhncM9zlJlXr1GSyC0=
X-Google-Smtp-Source: APXvYqzs6vXhdgKNKx31z0vi/BFoGxNhmu90a2SY4rvrhQxkGY5umG/Ceo6MXovKrcXHIzD5ew+VQ9ry0eIyNtN1+xw=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr19123505oto.118.1560390607013;
 Wed, 12 Jun 2019 18:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <1560332419-17195-1-git-send-email-wanpengli@tencent.com> <20190612151447.GD20308@linux.intel.com>
In-Reply-To: <20190612151447.GD20308@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 13 Jun 2019 09:50:49 +0800
Message-ID: <CANRm+CyOQ+fDquCe2R4E9isSUiZTZR0Htr1JAz7jHr=xZ7GOYg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: LAPIC: Optimize timer latency consider world
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

On Wed, 12 Jun 2019 at 23:14, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Jun 12, 2019 at 05:40:18PM +0800, Wanpeng Li wrote:
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
> > The vmentry+vmexit time which is measured by kvm-unit-tests/vmexit.falt=
 is
> > 1800 cycles on my 2.5GHz Skylake server, the vmentry_advance_ns module
> > parameter default value is 300ns, it can be tuned/reworked in the furth=
er.
> > This patch can reduce average cyclictest latency from 3us to 2us on Sky=
lake
> > server. (guest w/ nohz=3Doff, idle=3Dpoll, host w/ preemption_timer=3DN=
, the
> > cyclictest latency is not too sensitive when preemption_timer=3DY for t=
his
> > optimization in my testing).
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v2 -> v3:
> >  * read-only module parameter
> >  * get_vmentry_advance_cycles() not inline
> > v1 -> v2:
> >  * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
> >  * cache vmentry_advance_cycles by setting param bit 0
> >  * add param max limit
> >
> >  arch/x86/kvm/lapic.c   | 33 ++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/lapic.h   |  3 +++
> >  arch/x86/kvm/vmx/vmx.c |  2 +-
> >  arch/x86/kvm/x86.c     |  8 ++++++++
> >  arch/x86/kvm/x86.h     |  2 ++
> >  5 files changed, 44 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index fcf42a3..c6d76f9 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1531,6 +1531,33 @@ static inline void adjust_lapic_timer_advance(st=
ruct kvm_vcpu *vcpu,
> >       apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >  }
> >
> > +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
> > +{
> > +     u64 cycles;
> > +     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > +
> > +     cycles =3D vmentry_advance_ns * vcpu->arch.virtual_tsc_khz;
> > +     do_div(cycles, 1000000);
> > +
> > +     apic->lapic_timer.vmentry_advance_cycles =3D cycles;
> > +
> > +     return cycles;
> > +}
> > +
> > +u64 get_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_lapic *apic =3D vcpu->arch.apic;
> > +
> > +     if (unlikely(!vmentry_advance_ns))
> > +             return 0;
> > +
> > +     if (likely(apic->lapic_timer.vmentry_advance_cycles))
> > +             return apic->lapic_timer.vmentry_advance_cycles;
> > +
> > +     return compute_vmentry_advance_cycles(vcpu);
>
> If vmentry_advance_ns is read-only, then we don't need to be able to
> compute lapic_timer.vmentry_advance_cycles on demand, e.g. it can be set
> during kvm_create_lapic() and recomputed in kvm_set_tsc_khz().
>
> Alternatively, it could be handled purely in kvm_set_tsc_khz() if the cal=
l
> to kvm_create_lapic() were moved before kvm_set_tsc_khz().

hardcode 25ns, how about something like this:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..ed62d6b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1531,6 +1531,19 @@ static inline void
adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
     apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
 }

+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
+{
+    u64 cycles;
+    struct kvm_lapic *apic =3D vcpu->arch.apic;
+
+    cycles =3D vmentry_advance_ns * vcpu->arch.virtual_tsc_khz;
+    do_div(cycles, 1000000);
+
+    apic->lapic_timer.vmentry_advance_cycles =3D cycles;
+
+    return cycles;
+}
+
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
     struct kvm_lapic *apic =3D vcpu->arch.apic;
@@ -1544,7 +1557,8 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)

     tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
     apic->lapic_timer.expired_tscdeadline =3D 0;
-    guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
+    guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) +
+        apic->lapic_timer.vmentry_advance_cycles;
     apic->lapic_timer.advance_expire_delta =3D guest_tsc - tsc_deadline;

     if (guest_tsc < tsc_deadline)
@@ -1572,7 +1586,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *ap=
ic)
     local_irq_save(flags);

     now =3D ktime_get();
-    guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
+    guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc()) +
+        apic->lapic_timer.vmentry_advance_cycles;

     ns =3D (tscdeadline - guest_tsc) * 1000000ULL;
     do_div(ns, this_tsc_khz);
@@ -2329,7 +2344,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int
timer_advance_ns)
         apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
         apic->lapic_timer.timer_advance_adjust_done =3D true;
     }
-
+    apic->lapic_timer.vmentry_advance_cycles =3D 0;

     /*
      * APIC is created enabled. This will prevent kvm_lapic_set_base from
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..751cb26 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -33,6 +33,7 @@ struct kvm_timer {
     u64 expired_tscdeadline;
     u32 timer_advance_ns;
     s64 advance_expire_delta;
+    u64 vmentry_advance_cycles;
     atomic_t pending;            /* accumulated triggered timers */
     bool hv_timer_in_use;
     bool timer_advance_adjust_done;
@@ -221,6 +222,7 @@ static inline int kvm_lapic_latched_init(struct
kvm_vcpu *vcpu)
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);

 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu);

 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *i=
rq,
             struct kvm_vcpu **dest_vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0861c71..b572359 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7041,7 +7041,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu
*vcpu, u64 guest_deadline_tsc,

     vmx =3D to_vmx(vcpu);
     tscl =3D rdtsc();
-    guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl);
+    guest_tscl =3D kvm_read_l1_tsc(vcpu, tscl) +
+        vcpu->arch.apic->lapic_timer.vmentry_advance_cycles;
     delta_tsc =3D max(guest_deadline_tsc, guest_tscl) - guest_tscl;
     lapic_timer_advance_cycles =3D nsec_to_cycles(vcpu,
                             ktimer->timer_advance_ns);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 553c292..f6e1366 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -145,6 +145,12 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUS=
R);
 static int __read_mostly lapic_timer_advance_ns =3D -1;
 module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);

+/*
+ * lapic timer vmentry advance (tscdeadline mode only) in nanoseconds.
+ */
+u32 __read_mostly vmentry_advance_ns =3D 25;
+module_param(vmentry_advance_ns, uint, S_IRUGO);
+
 static bool __read_mostly vector_hashing =3D true;
 module_param(vector_hashing, bool, S_IRUGO);

@@ -1592,6 +1598,8 @@ static int kvm_set_tsc_khz(struct kvm_vcpu
*vcpu, u32 user_tsc_khz)
     kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC,
                &vcpu->arch.virtual_tsc_shift,
                &vcpu->arch.virtual_tsc_mult);
+    if (user_tsc_khz !=3D vcpu->arch.virtual_tsc_khz)
+        compute_vmentry_advance_cycles(vcpu);
     vcpu->arch.virtual_tsc_khz =3D user_tsc_khz;

     /*
@@ -9127,8 +9135,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
     }
     vcpu->arch.pio_data =3D page_address(page);

-    kvm_set_tsc_khz(vcpu, max_tsc_khz);
-
     r =3D kvm_mmu_create(vcpu);
     if (r < 0)
         goto fail_free_pio_data;
@@ -9141,6 +9147,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
     } else
         static_key_slow_inc(&kvm_no_apic_vcpu);

+    kvm_set_tsc_khz(vcpu, max_tsc_khz);
+
     vcpu->arch.mce_banks =3D kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
                        GFP_KERNEL_ACCOUNT);
     if (!vcpu->arch.mce_banks) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0..2174355 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,6 +294,8 @@ extern u64 kvm_supported_xcr0(void);

 extern unsigned int min_timer_period_us;

+extern unsigned int vmentry_advance_ns;
+
 extern bool enable_vmware_backdoor;

 extern struct static_key kvm_no_apic_vcpu;
