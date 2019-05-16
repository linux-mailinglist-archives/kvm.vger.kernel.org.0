Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4BF1FDF1
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfEPDNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:13:07 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44749 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEPDNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:13:07 -0400
Received: by mail-oi1-f194.google.com with SMTP id z65so1386786oia.11;
        Wed, 15 May 2019 20:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wL2LzkzA7t8tfuIUbLBzWDPQUhplC7NcF2EvAx3KbHM=;
        b=J4V/oeTB9otXxka/396yGMdkhJ/yn13ovryxgY8N9PcOfsgjje5mFWVIW5lTgwMFwc
         cz7TNUqHnaU/X2M+VD8MKw1he+tyRLkFFegRf87mUDbXQjWgk1zKYv7bXP48MGIIun7+
         G8rapKqt4mv3tHbgeUysAzsl3m90gFL82VLeoHAC7PU5z88U2/JH9uoYvABnctwfkdt+
         dQM7ij64Lrx/L2WO6ysihcGGpPe9SbsACTg7X4fpgMEw67pja6h+96VbxQEDn0LJWybx
         ASNQr8MPojY4KrQsf8cqlV9VDY6XV5hoBLJ+LnOqzwzFu82RfvmjZFohm6fQIHaomIE7
         Hc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wL2LzkzA7t8tfuIUbLBzWDPQUhplC7NcF2EvAx3KbHM=;
        b=dUhBmwVeUJab5Exc9uLu2TWbvKNh+/1Bpk6tPGAsEVMfKAB8noZ9eE8oyUvAcpXKlI
         maAKdpOabhPgk6fnfPTb72Ok3LCBWybCa12BgLMWWVCUoXWrlbmtFEBiI6/Xj1dKgQqb
         rOgzKeSfwNIwKmZKswtFok3aCiyCcCpFnobag6tBFvNXMfsmVTgjuCebEMDaf2a3gw/L
         5MVFzwvf6mOflQBiC6UFmsvU0oyE0KTsmt9KxH/H+B3NLFzglPCLywydzBG58rfOoeaV
         CZWXr6bdFoVfy0PSeF7sF5AcTFbNvVt4cj1Jn6KOaKhaR7F89C8cSpMJximt1ZYhaCMb
         tyuw==
X-Gm-Message-State: APjAAAVW2Rz7BOWRuQ8vvDP06sD5M+ClxLeLyRUgtB0dioQL+XvALQdF
        4eZNvuXz8i9LAIMfijByMYnkd4MxXqvynhX8htA=
X-Google-Smtp-Source: APXvYqy0HoXiWSYkQ6g/EjpeBo60qCl3VbRrSqkNF25EstM70Gwp12iz0c6mOUUbBHA7nFlqq5gNNE/YfS4rgW9DA10=
X-Received: by 2002:aca:bf83:: with SMTP id p125mr8860857oif.47.1557976386255;
 Wed, 15 May 2019 20:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
 <1557893514-5815-5-git-send-email-wanpengli@tencent.com> <20190515174251.GF5875@linux.intel.com>
In-Reply-To: <20190515174251.GF5875@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 16 May 2019 11:14:26 +0800
Message-ID: <CANRm+Cy8O9yv6DF8thsJ854yf+82-94Xin_7sDjDmwV=9Pj-vA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: LAPIC: Optimize timer latency further
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

On Thu, 16 May 2019 at 01:42, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, May 15, 2019 at 12:11:54PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Advance lapic timer tries to hidden the hypervisor overhead between the
> > host emulated timer fires and the guest awares the timer is fired. Howe=
ver,
> > it just hidden the time between apic_timer_fn/handle_preemption_timer -=
>
> > wait_lapic_expire, instead of the real position of vmentry which is
> > mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to
> > advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles betw=
een
> > the end of wait_lapic_expire and before world switch on my haswell desk=
top,
> > it will be 2400+ cycles if vmentry_l1d_flush is tuned to always.
> >
> > This patch tries to narrow the last gap(wait_lapic_expire -> world swit=
ch),
> > it takes the real overhead time between apic_timer_fn/handle_preemption=
_timer
> > and before world switch into consideration when adaptively tuning timer
> > advancement. The patch can reduce 40% latency (~1600+ cycles to ~1000+ =
cycles
> > on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when testi=
ng
> > busy waits.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c   | 3 ++-
> >  arch/x86/kvm/lapic.h   | 2 +-
> >  arch/x86/kvm/svm.c     | 4 ++++
> >  arch/x86/kvm/vmx/vmx.c | 4 ++++
> >  arch/x86/kvm/x86.c     | 3 ---
> >  5 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index af38ece..63513de 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1531,7 +1531,7 @@ static inline void adaptive_tune_timer_advancemen=
t(struct kvm_vcpu *vcpu,
> >       apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >  }
> >
> > -void wait_lapic_expire(struct kvm_vcpu *vcpu)
> > +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> >  {
> >       struct kvm_lapic *apic =3D vcpu->arch.apic;
> >       u64 guest_tsc, tsc_deadline;
> > @@ -1553,6 +1553,7 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
> >       if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> >               adaptive_tune_timer_advancement(vcpu, apic->lapic_timer.a=
dvance_expire_delta);
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
> >
> >  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> >  {
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 3e72a25..f974a3d 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm=
_vcpu *vcpu)
> >
> >  bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
> >
> > -void wait_lapic_expire(struct kvm_vcpu *vcpu);
> > +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
> >
> >  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_ir=
q *irq,
> >                       struct kvm_vcpu **dest_vcpu);
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 406b558..740fb3f 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5646,6 +5646,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >        */
> >       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> >
> > +     if (lapic_in_kernel(vcpu) &&
> > +             vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > +             kvm_wait_lapic_expire(vcpu);
> > +
> >       local_irq_enable();
> >
> >       asm volatile (
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9663d41..1c49946 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6437,6 +6437,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >       if (vcpu->arch.cr2 !=3D read_cr2())
> >               write_cr2(vcpu->arch.cr2);
> >
> > +     if (lapic_in_kernel(vcpu) &&
> > +             vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > +             kvm_wait_lapic_expire(vcpu);
>
> One potential hiccup with this approach is that we're now accessing more
> data after flushing the L1.  Not sure if that's actually a problem here,
> but it probably should be explicitly addressed/considered.

Handle it in v3.

Regards,
Wanpeng Li

>
> > +
> >       vmx->fail =3D __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.re=
gs,
> >                                  vmx->loaded_vmcs->launched);
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1d89cb9..0eb9549 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7894,9 +7894,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
)
> >       }
> >
> >       trace_kvm_entry(vcpu->vcpu_id);
> > -     if (lapic_in_kernel(vcpu) &&
> > -         vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > -             wait_lapic_expire(vcpu);
> >       guest_enter_irqoff();
> >
> >       fpregs_assert_state_consistent();
> > --
> > 2.7.4
> >
