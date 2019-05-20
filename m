Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E66722E46
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbfETIT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:19:57 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39614 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfETIT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:19:57 -0400
Received: by mail-oi1-f194.google.com with SMTP id v2so9326400oie.6;
        Mon, 20 May 2019 01:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Io8U2uxD7AxFcrvz9R7N8axfmbAkr2qEV9G+U3v4mUM=;
        b=PGe3DtvjNrOxtHbxnpL666wCxe3YyG46ZOiZiiygJ/JZ6zcpkZR3tZghhSUCHZ6RpU
         9qfMxyv0F7AbQB9aOEWtXcaLDIndkW28fTC+aRlxzn1awXUnvNXk8+S77h2h2AXWWBRn
         d9UMM4tgXXP+bWhyKjPZYy0PUkPmYNLE37Vx1LS+p5UWk7FSTuY8rrZWNzGVB5Ogd5l6
         l6mvMg3MrZC33Y09Fz8SluXr97z5044KVJBFZ8bQUgpmzIbNpVmLi8Fmy2L3BWetPZ9b
         9y5HuBNZOa5074aW04kDJlyG74FKE4XpLCuwQt9O/w0UoorkbzZFftOrieYICqaZK+cU
         VXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Io8U2uxD7AxFcrvz9R7N8axfmbAkr2qEV9G+U3v4mUM=;
        b=iQsozkLfNXXVPI/YcQSXi+hPaJnT6Y33LoPy/VpS1graJLHJrxmy9nHuazDd+Y0vso
         6etHZ+AFwq8qZNjW1yfm8w9kZwO/7YsJlIKYSFkEzcj9z1AaVep7THpmFbdkY5tTdN9v
         QJ8JrSviCAZ2H8WQyjVddJWnEnwSg1NW5xaRruohTVN9GRCoUKlQ4fjGeoBCMALPR7aJ
         Zf6eba8/qp5fCid3vW+s/9RkLLcfhj6vBH3PXwce79O33oi85GN62CkcS+0AHNiVCUQu
         1wN1qyXlmkNMemuzokE1Nt6YNgVIlrHTWgFlAZ3zT5rJIV0xrY4TwySgIJYjDUY5+Y9s
         IyAQ==
X-Gm-Message-State: APjAAAV9BmlGqkoE8Rr94l9FLK+G/HHOtpaYakuXyupWlhJgq8bYkBjw
        ai/lRMwS/2nrHrG2yDChKDtZrgChKdExm75Tsxo=
X-Google-Smtp-Source: APXvYqxwBPJTrJRMWYDJHKYX+JLUubFq4AZB+BrSKFkshE8IDhEU8yoGvoIEdwo3CZps18UUrSiTsXiu9H43mA6+BCk=
X-Received: by 2002:aca:ea55:: with SMTP id i82mr22043801oih.33.1558340396639;
 Mon, 20 May 2019 01:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-6-git-send-email-wanpengli@tencent.com> <20190517195049.GI15006@linux.intel.com>
In-Reply-To: <20190517195049.GI15006@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 16:19:47 +0800
Message-ID: <CANRm+CwfDbVS2tYG0XCD8Gvx6GtszGLphiTvFMBYmwdt13P=1Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: LAPIC: Optimize timer latency further
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

On Sat, 18 May 2019 at 03:50, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 16, 2019 at 11:06:20AM +0800, Wanpeng Li wrote:
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
top.
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
> > index 6b92eaf..955cfcb 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5638,6 +5638,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >       clgi();
> >       kvm_load_guest_xcr0(vcpu);
> >
> > +     if (lapic_in_kernel(vcpu) &&
> > +             vcpu->arch.apic->lapic_timer.timer_advance_ns)
>
> Nit: align the two lines of the if statement, doing so makes it easier to
>      differentiate between the condition and execution, e.g.:
>
>         if (lapic_in_kernel(vcpu) &&
>             vcpu->arch.apic->lapic_timer.timer_advance_ns)
>                 kvm_wait_lapic_expire(vcpu);

This can result in checkpatch.pl complain:

WARNING: suspect code indent for conditional statements (8, 24)
#94: FILE: arch/x86/kvm/vmx/vmx.c:6436:
+    if (lapic_in_kernel(vcpu) &&
[...]
+            kvm_wait_lapic_expire(vcpu);

Regards,
Wanpeng Li

>
> > +             kvm_wait_lapic_expire(vcpu);
> > +
> >       /*
> >        * If this vCPU has touched SPEC_CTRL, restore the guest's value =
if
> >        * it's non-zero. Since vmentry is serialising on affected CPUs, =
there
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e1fa935..771d3bf 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6423,6 +6423,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >
> >       vmx_update_hv_timer(vcpu);
> >
> > +     if (lapic_in_kernel(vcpu) &&
> > +             vcpu->arch.apic->lapic_timer.timer_advance_ns)
> > +             kvm_wait_lapic_expire(vcpu);
>
> Same comment as above.  With those fixed:
>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>
> > +
> >       /*
> >        * If this vCPU has touched SPEC_CTRL, restore the guest's value =
if
> >        * it's non-zero. Since vmentry is serialising on affected CPUs, =
there
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4a7b00c..e154f52 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7903,9 +7903,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu=
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
