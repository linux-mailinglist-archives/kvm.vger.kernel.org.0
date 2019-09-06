Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B39AB070
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbfIFByh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:54:37 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46955 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbfIFByh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:54:37 -0400
Received: by mail-ot1-f67.google.com with SMTP id g19so4230236otg.13;
        Thu, 05 Sep 2019 18:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K4IFwD6VM+XLab7BYsbQN6PVDmVS6cIQkZE+YPWUOPU=;
        b=WrLJm/MW5tbyw7TlKFFlM2O2CiNTHVtwpxcgm0nmNCI9be7PPZbHhtNkHYn5/eceZT
         A0IRWAJAZEa4Ipem66aHvsFLLW6NXJmX4xS/n7twVXWUkCkeXvdo8HEC/P37Lqt9SuC2
         qXDv22KnGWOp/mtuGE3/V0MzR9ukygUrBvFf1xzoPk/xVsEGGFjQppAt+oMHfXB9KDON
         W+9fT6k7bWM7GwPOFjJSYkUVDHS3+8ZNGcflYJD0p7tGgYotZzTGrq6KRsE0kn54e4NH
         tA0fbfg4JMPSLMmBzpVDuSUuAYht/fuFECkkNVZixWIGPFfHrAJ974GDQ6YgfI6GWf3Y
         xh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K4IFwD6VM+XLab7BYsbQN6PVDmVS6cIQkZE+YPWUOPU=;
        b=eIxoqjMHbsHhbE+dIEVC+8umb7s9nQYd+IBwIMNlPNXqkgokv+bjgDFAKHxA5+Vr+e
         +gdoqrhYlkLcT6PGn67/bdes+pFKpzWNprxaDTXuFaSMtnQVGec4Tg+avJoKiVow/lEe
         WiTj3o/KYwAuolnzJb767AWhywQQ1gStM5nfOGsqYqL7zq5nOI9A0mJxQUCKSqWnfqf8
         hsb9EEEGCbAtgJp6ISwbU8a1qV8GLIWhYV56djD5PqqlGKiGyM/Qe+qxj2sCfmBjmDol
         XRqhJwI+FtZkH/2H7JRj0VF4mFrap9DErS0ujlQyRKZIPRxm1xojlZkMSXCfBBkO8nax
         1s9g==
X-Gm-Message-State: APjAAAUSFwF7Le7L+cp4oNcgHelt+Wrsvn5sgBd8KF2eBkJF+h8Z5PWy
        eEkr6VCBDhRN6LDuwCzW64sdqsytkGsiV1JwMu4=
X-Google-Smtp-Source: APXvYqyfziUSAkRNvffX8M48//3wAYR9dKmOeDSPAKVir2eFp79YrLdsxiD2iIxxWfguu0ZSJzJmQ2d0M3HpFcgZcKE=
X-Received: by 2002:a9d:3ae:: with SMTP id f43mr4081296otf.254.1567734875909;
 Thu, 05 Sep 2019 18:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <1567680270-14022-1-git-send-email-wanpengli@tencent.com> <87ftlakhn6.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ftlakhn6.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 6 Sep 2019 09:54:23 +0800
Message-ID: <CANRm+CyPxb+ZY2cTdbLL_LBKMJSOaMqnPGKc_ATc6-TMHW-rJw@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Fix SynIC Timers inject timer interrupt w/o
 LAPIC present
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Sep 2019 at 21:16, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >       kasan: GPF could be caused by NULL-ptr deref or user memory acces=
s
> >       general protection fault: 0000 [#1] PREEMPT SMP KASAN
> >       RIP: 0010:__apic_accept_irq+0x46/0x740 arch/x86/kvm/lapic.c:1029
> >       Call Trace:
> >       kvm_apic_set_irq+0xb4/0x140 arch/x86/kvm/lapic.c:558
> >       stimer_notify_direct arch/x86/kvm/hyperv.c:648 [inline]
> >       stimer_expiration arch/x86/kvm/hyperv.c:659 [inline]
> >       kvm_hv_process_stimers+0x594/0x1650 arch/x86/kvm/hyperv.c:686
> >       vcpu_enter_guest+0x2b2a/0x54b0 arch/x86/kvm/x86.c:7896
> >       vcpu_run+0x393/0xd40 arch/x86/kvm/x86.c:8152
> >       kvm_arch_vcpu_ioctl_run+0x636/0x900 arch/x86/kvm/x86.c:8360
> >       kvm_vcpu_ioctl+0x6cf/0xaf0 arch/x86/kvm/../../../virt/kvm/kvm_mai=
n.c:2765
> >
> > The testcase programs HV_X64_MSR_STIMERn_CONFIG/HV_X64_MSR_STIMERn_COUN=
T,
> > in addition, there is no lapic in the kernel, the counters value are sm=
all
> > enough in order that kvm_hv_process_stimers() inject this already-expir=
ed
> > timer interrupt into the guest through lapic in the kernel which trigge=
rs
> > the NULL deferencing. This patch fixes it by checking lapic_in_kernel,
> > discarding the inject if it is 0.
> >
> > Reported-by: syzbot+dff25ee91f0c7d5c1695@syzkaller.appspotmail.com
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index c10a8b1..461fcc5 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -645,7 +645,9 @@ static int stimer_notify_direct(struct kvm_vcpu_hv_=
stimer *stimer)
> >               .vector =3D stimer->config.apic_vector
> >       };
> >
> > -     return !kvm_apic_set_irq(vcpu, &irq, NULL);
> > +     if (lapic_in_kernel(vcpu))
> > +             return !kvm_apic_set_irq(vcpu, &irq, NULL);
> > +     return 0;
> >  }
> >
> >  static void stimer_expiration(struct kvm_vcpu_hv_stimer *stimer)
>
> Hm, but this basically means direct mode synthetic timers won't work
> when LAPIC is not in kernel but the feature will still be advertised to
> the guest, not good. Shall we stop advertizing it? Something like
> (completely untested):
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 3f5ad84853fb..1dfa594eaab6 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1856,7 +1856,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *v=
cpu, struct kvm_cpuid2 *cpuid,
>
>                         ent->edx |=3D HV_FEATURE_FREQUENCY_MSRS_AVAILABLE=
;
>                         ent->edx |=3D HV_FEATURE_GUEST_CRASH_MSR_AVAILABL=
E;
> -                       ent->edx |=3D HV_STIMER_DIRECT_MODE_AVAILABLE;
> +
> +                       /*
> +                        * Direct Synthetic timers only make sense with i=
n-kernel
> +                        * LAPIC
> +                        */
> +                       if (lapic_in_kernel(vcpu))
> +                               ent->edx |=3D HV_STIMER_DIRECT_MODE_AVAIL=
ABLE;
>
>                         break;

Thanks, I fold this into v2, syzkaller even didn't check the cpuid, so
I still keep the discard inject part.

                                                                   Wanpeng
