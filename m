Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6071C064
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 03:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfENBo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 21:44:28 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45119 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfENBo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 21:44:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id t24so4989194otl.12;
        Mon, 13 May 2019 18:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yy2Yel/USF4a4M7OXdkKtgr8TJY88ids8FL33ul2o24=;
        b=ftyK0Zu9SdNODowfCGef5M5MWQtnQRW+K0ewSddIAjJgnD5x5De/Wful+d8XCktU23
         4bwBdP69H8+MQYi+jRvJAp7NBtj/l8b8Nk/UJojkNONU61O9M4mNHoZdkj4TIhMbUVAM
         jzpRiTb7mMsfy1ss082O4RGHaU0k2paXKqcFb2Z8OFlohjBHm3Y51WGnD5DQSXjX6YzA
         bzSocXEUoe8HCjc6tavJnVIqrzWsZpVhZyOsOL4MCKps1BozD8llD+CJ1BEBvatCLfyf
         uWsGnTe0nWTT3qPkBjayQHVVjHjZL511+xkHrf0urrRA4OYcRcM1HOO1LqBVzgQGYr2I
         cYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yy2Yel/USF4a4M7OXdkKtgr8TJY88ids8FL33ul2o24=;
        b=AiMsWd2Z0Uq5NhKLCx40gv4OGuMNjeYSCj1MvaGyhg7TWKZHid4LlDrxklaDiYlolw
         ViS3O7fwjnUgZSZEnFQMztz9f4A8qqr/PosSjxdjFqXz1u75UFfqVg5BtEAgOteXA3n6
         hLIHDB1f/1bvIB4MWOykMU5P6ZMCmv+54VwW5PatwHtpcU4yL2FDnX5UZubUMQmc8B1w
         LJhtpVv3dZLSUU7ms2Tw0WCdh3jxsC97iSf3s8LoyZTjzjuu6L/BF8MT+02eBjOqUqry
         2JQxVw5M/Vaf/q5LPRxhH0gcwWVP1DRi8CINIYqPK/RyKIstoU4DvtHnTzyClBY2B7SL
         1LOQ==
X-Gm-Message-State: APjAAAXjLVIiWzprUh/7d2u/KFj5AEC627bWpYIjV8sGYeXUZJrFcfUZ
        ZDgAn1ExORToPRrUAH1IVecoSJGxHD4Mo36DhWE=
X-Google-Smtp-Source: APXvYqwCwweRgGxR0q2aDofRD6zHvfdGOjy5pQEcLdAMiC084mM+T8w4F7wNjpERXuETfAeHr9bSFtMlVmspTdrv4ZM=
X-Received: by 2002:a9d:7f8b:: with SMTP id t11mr18632299otp.110.1557798267465;
 Mon, 13 May 2019 18:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-4-git-send-email-wanpengli@tencent.com> <20190513195417.GM28561@linux.intel.com>
In-Reply-To: <20190513195417.GM28561@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 14 May 2019 09:45:40 +0800
Message-ID: <CANRm+CxVRMQF9yHoqDMJR9FROGtLwYgaQXPqu++S7Juneh2vtw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: LAPIC: Optimize timer latency further
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

On Tue, 14 May 2019 at 03:54, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 09, 2019 at 07:29:21PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Advance lapic timer tries to hidden the hypervisor overhead between hos=
t
> > timer fires and the guest awares the timer is fired. However, it just h=
idden
> > the time between apic_timer_fn/handle_preemption_timer -> wait_lapic_ex=
pire,
> > instead of the real position of vmentry which is mentioned in the orign=
ial
> > commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrtim=
er
> > expiration"). There is 700+ cpu cycles between the end of wait_lapic_ex=
pire
> > and before world switch on my haswell desktop, it will be 2400+ cycles =
if
> > vmentry_l1d_flush is tuned to always.
> >
> > This patch tries to narrow the last gap, it measures the time between
> > the end of wait_lapic_expire and before world switch, we take this
> > time into consideration when busy waiting, otherwise, the guest still
> > awares the latency between wait_lapic_expire and world switch, we also
> > consider this when adaptively tuning the timer advancement. The patch
> > can reduce 50% latency (~1600+ cycles to ~800+ cycles on a haswell
> > desktop) for kvm-unit-tests/tscdeadline_latency when testing busy waits=
.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c   | 23 +++++++++++++++++++++--
> >  arch/x86/kvm/lapic.h   |  8 ++++++++
> >  arch/x86/kvm/vmx/vmx.c |  2 ++
> >  3 files changed, 31 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index e7a0660..01d3a87 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1545,13 +1545,19 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
> >
> >       tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
> >       apic->lapic_timer.expired_tscdeadline =3D 0;
> > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, (apic->lapic_timer.measure_de=
lay_done =3D=3D 2) ?
> > +             rdtsc() + apic->lapic_timer.vmentry_delay : rdtsc());
> >       trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_deadli=
ne);
> >
> >       if (guest_tsc < tsc_deadline)
> >               __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> >
> >       adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
> > +
> > +     if (!apic->lapic_timer.measure_delay_done) {
> > +             apic->lapic_timer.measure_delay_done =3D 1;
> > +             apic->lapic_timer.vmentry_delay =3D rdtsc();
> > +     }
> >  }
> >
> >  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> > @@ -1837,6 +1843,18 @@ static void apic_manage_nmi_watchdog(struct kvm_=
lapic *apic, u32 lvt0_val)
> >       }
> >  }
> >
> > +void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_timer *ktimer =3D &vcpu->arch.apic->lapic_timer;
>
> This will #GP if the APIC is not in-kernel, i.e. @apic is NULL.
>
> > +
> > +     if (ktimer->measure_delay_done =3D=3D 1) {
> > +             ktimer->vmentry_delay =3D rdtsc() -
> > +                     ktimer->vmentry_delay;
> > +             ktimer->measure_delay_done =3D 2;
>
> Measuring the delay a single time is bound to result in random outliers,
> e.g. if an NMI happens to occur after wait_lapic_expire().
>
> Rather than reinvent the wheel, can we simply move the call to
> wait_lapic_expire() into vmx.c and svm.c?  For VMX we'd probably want to
> support the advancement if enable_unrestricted_guest=3Dtrue so that we av=
oid
> the emulation_required case, but other than that I don't see anything tha=
t
> requires wait_lapic_expire() to be called where it is.

I also considered to move wait_lapic_expire() into vmx.c and svm.c
before, what do you think, Paolo, Radim?

Regards,
Wanpeng Li

>
> > +     }
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_lapic_measure_vmentry_delay);
> > +
> >  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >  {
> >       int ret =3D 0;
> > @@ -2318,7 +2336,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int t=
imer_advance_ns)
> >               apic->lapic_timer.timer_advance_ns =3D timer_advance_ns;
> >               apic->lapic_timer.timer_advance_adjust_done =3D true;
> >       }
> > -
> > +     apic->lapic_timer.vmentry_delay =3D 0;
> > +     apic->lapic_timer.measure_delay_done =3D 0;
> >
> >       /*
> >        * APIC is created enabled. This will prevent kvm_lapic_set_base =
from
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index d6d049b..f1d037b 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -35,6 +35,13 @@ struct kvm_timer {
> >       atomic_t pending;                       /* accumulated triggered =
timers */
> >       bool hv_timer_in_use;
> >       bool timer_advance_adjust_done;
> > +     /**
> > +      * 0 unstart measure
> > +      * 1 start record
> > +      * 2 get delta
> > +      */
> > +     u32 measure_delay_done;
> > +     u64 vmentry_delay;
> >  };
> >
> >  struct kvm_lapic {
> > @@ -230,6 +237,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *=
vcpu);
> >  void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
> >  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
> >  void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
> > +void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu);
> >
> >  static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
> >  {
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9663d41..a939bf5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6437,6 +6437,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >       if (vcpu->arch.cr2 !=3D read_cr2())
> >               write_cr2(vcpu->arch.cr2);
> >
> > +     kvm_lapic_measure_vmentry_delay(vcpu);
>
> This should be wrapped in an unlikely of some form given that it happens
> literally once out of thousands/millions runs.
>
> > +
> >       vmx->fail =3D __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.re=
gs,
> >                                  vmx->loaded_vmcs->launched);
> >
> > --
> > 2.7.4
> >
