Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3E41C74B
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 12:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfENKyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 06:54:53 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32792 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfENKyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 06:54:52 -0400
Received: by mail-ot1-f66.google.com with SMTP id 66so14792366otq.0;
        Tue, 14 May 2019 03:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QtB5Rs/peEa4JN+D+iPr59JmMiQWnsnfd52Mq2rk5Fc=;
        b=RJsDKL3+Kry+B8IxmAwZ/vkcvpAaZsiTayf7bGzVyoBmjaVPIPTy6hYnyGjK3EPmI5
         0dkYQAXR/6f5xfTqU0cT+sgI+EAf38OalOkteS7YBoR7WfHHZmXOyOCyNDjxA3cvWd2d
         9S4V2K2oWDeZnzSC6nxRDEiZI22X8Y5JiE9fmvbdJ7rfDjaWSFieKVaquT0XPwPCxeMk
         Wjk1RS6dm+cqTciREvRf4v97LERVEiYepfpEj8ylrbLMbzf6/p1C0sIqtadUW1V+k9TA
         KBO4zS7HKLrY/nxQ62xfsPS4fk+wr3md8lz10+V8sYXiA9VjnPEAVRvAij8OGC+yjNRv
         W0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QtB5Rs/peEa4JN+D+iPr59JmMiQWnsnfd52Mq2rk5Fc=;
        b=PCA9mO3c+Pt6i0Kd6JviphUHwzxCJCDO4gWwesHRSvyifOd9xhZ7jEFSq6689Jzemy
         +RUhybPxecZZ/294+o1oJmaBHBpjF1rYrHXS1qLtZsNq6THcP8/x06ebYXZwQXxhz+hC
         cGnim6Gm9emCtVP8UZAYUHqJCPz+pcM04A8yIDSfpZRZqVL/u6WWN3nGPBOZEIifedva
         8knnajhUxWxvy+Jqp+7mJZSmCotvnf2zNlQg8WUK+7dkAThAIXtUmsX2uqCw7an6ocIf
         7APK3n8rWgNS1KqmGUvnfd59ETAJF6EhDZKzFZyfFPbWERt9HNSzsEqx/iNTG55exvA0
         k6xQ==
X-Gm-Message-State: APjAAAUQ+xnDYaUOazWfG8FeoTEZ6sIw1QXvIBTyR2hFbIWl4Z6Vkhc3
        kU7IJpYUPWGlxR54MbOVleYhjkPa1wgqSFg0ahQ=
X-Google-Smtp-Source: APXvYqzGzg2Ya/Iw5LDBCkQejuZY4jHMDMNe2KOKzz+WDUQpKWBSS25E8Ee7CzBzY4e9gtDoeWLGqwc2gVWxNpBbM3g=
X-Received: by 2002:a9d:7343:: with SMTP id l3mr19766347otk.63.1557831291504;
 Tue, 14 May 2019 03:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
 <1557401361-3828-4-git-send-email-wanpengli@tencent.com> <20190513195417.GM28561@linux.intel.com>
 <CANRm+CxVRMQF9yHoqDMJR9FROGtLwYgaQXPqu++S7Juneh2vtw@mail.gmail.com>
In-Reply-To: <CANRm+CxVRMQF9yHoqDMJR9FROGtLwYgaQXPqu++S7Juneh2vtw@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 14 May 2019 18:56:04 +0800
Message-ID: <CANRm+Czg-0m1dV1DVfqSTr89Xrq169xx3LqEGTYH0mmjafvhMQ@mail.gmail.com>
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

On Tue, 14 May 2019 at 09:45, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 14 May 2019 at 03:54, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, May 09, 2019 at 07:29:21PM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Advance lapic timer tries to hidden the hypervisor overhead between h=
ost
> > > timer fires and the guest awares the timer is fired. However, it just=
 hidden
> > > the time between apic_timer_fn/handle_preemption_timer -> wait_lapic_=
expire,
> > > instead of the real position of vmentry which is mentioned in the ori=
gnial
> > > commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrt=
imer
> > > expiration"). There is 700+ cpu cycles between the end of wait_lapic_=
expire
> > > and before world switch on my haswell desktop, it will be 2400+ cycle=
s if
> > > vmentry_l1d_flush is tuned to always.
> > >
> > > This patch tries to narrow the last gap, it measures the time between
> > > the end of wait_lapic_expire and before world switch, we take this
> > > time into consideration when busy waiting, otherwise, the guest still
> > > awares the latency between wait_lapic_expire and world switch, we als=
o
> > > consider this when adaptively tuning the timer advancement. The patch
> > > can reduce 50% latency (~1600+ cycles to ~800+ cycles on a haswell
> > > desktop) for kvm-unit-tests/tscdeadline_latency when testing busy wai=
ts.
> > >
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Cc: Liran Alon <liran.alon@oracle.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c   | 23 +++++++++++++++++++++--
> > >  arch/x86/kvm/lapic.h   |  8 ++++++++
> > >  arch/x86/kvm/vmx/vmx.c |  2 ++
> > >  3 files changed, 31 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index e7a0660..01d3a87 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1545,13 +1545,19 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
> > >
> > >       tsc_deadline =3D apic->lapic_timer.expired_tscdeadline;
> > >       apic->lapic_timer.expired_tscdeadline =3D 0;
> > > -     guest_tsc =3D kvm_read_l1_tsc(vcpu, rdtsc());
> > > +     guest_tsc =3D kvm_read_l1_tsc(vcpu, (apic->lapic_timer.measure_=
delay_done =3D=3D 2) ?
> > > +             rdtsc() + apic->lapic_timer.vmentry_delay : rdtsc());
> > >       trace_kvm_wait_lapic_expire(vcpu->vcpu_id, guest_tsc - tsc_dead=
line);
> > >
> > >       if (guest_tsc < tsc_deadline)
> > >               __wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
> > >
> > >       adaptive_tune_timer_advancement(vcpu, guest_tsc, tsc_deadline);
> > > +
> > > +     if (!apic->lapic_timer.measure_delay_done) {
> > > +             apic->lapic_timer.measure_delay_done =3D 1;
> > > +             apic->lapic_timer.vmentry_delay =3D rdtsc();
> > > +     }
> > >  }
> > >
> > >  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> > > @@ -1837,6 +1843,18 @@ static void apic_manage_nmi_watchdog(struct kv=
m_lapic *apic, u32 lvt0_val)
> > >       }
> > >  }
> > >
> > > +void kvm_lapic_measure_vmentry_delay(struct kvm_vcpu *vcpu)
> > > +{
> > > +     struct kvm_timer *ktimer =3D &vcpu->arch.apic->lapic_timer;
> >
> > This will #GP if the APIC is not in-kernel, i.e. @apic is NULL.
> >
> > > +
> > > +     if (ktimer->measure_delay_done =3D=3D 1) {
> > > +             ktimer->vmentry_delay =3D rdtsc() -
> > > +                     ktimer->vmentry_delay;
> > > +             ktimer->measure_delay_done =3D 2;
> >
> > Measuring the delay a single time is bound to result in random outliers=
,
> > e.g. if an NMI happens to occur after wait_lapic_expire().
> >
> > Rather than reinvent the wheel, can we simply move the call to
> > wait_lapic_expire() into vmx.c and svm.c?  For VMX we'd probably want t=
o
> > support the advancement if enable_unrestricted_guest=3Dtrue so that we =
avoid
> > the emulation_required case, but other than that I don't see anything t=
hat
> > requires wait_lapic_expire() to be called where it is.
>
> I also considered to move wait_lapic_expire() into vmx.c and svm.c
> before, what do you think, Paolo, Radim?

However, guest_enter_irqoff() also prevents this. Otherwise, we will
account busy wait time as guest time. How about sampling several times
and get the average value or conservative min value to handle Sean's
concern?

Regards,
Wanpeng Li
