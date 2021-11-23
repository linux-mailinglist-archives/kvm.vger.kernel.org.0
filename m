Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748C3459C54
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 07:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKWG1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 01:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhKWG1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 01:27:39 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8969C061574;
        Mon, 22 Nov 2021 22:24:31 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so13845762otv.9;
        Mon, 22 Nov 2021 22:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1MyPL/teepfOMeGoHWnYgPytER+dJaXjpVCRvPxPmgc=;
        b=qcZEeXY80RJkSJOhAckMutQc1CCMNlkS4bsaNaBl7ILGKEMM3vplHNO4HezI1/4Tmf
         ZB4OnIa2akgLixhK1uo/oXE0Y7PNqVT13/AYc6QEsJLO9fjywZew+SPBNRBBbmWMNn0d
         jSVh4d/VpRcJMjN1nh5WjLTxNnAUw/5O2Lqi9cYStNjEIFoNg3sLgXRAMtG7Ha5kpBtE
         DAnAzIYfhe4fG7Mp29VTFGaZepyw87pwx1f1R+4NYYMW6H+UjlNIuijcodHG2hM1oPCC
         6ArJtgAycKAFk2WKu+1zqrpoHuwIxosl30sIg1PewJbMwww4jZczb4x/xoNMJXVUDj6A
         sPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1MyPL/teepfOMeGoHWnYgPytER+dJaXjpVCRvPxPmgc=;
        b=mJKJBXlA1haKJp6vnPX7PEEmCCb1SIWSvOGvkSUnOZsPpd/tOC51yrn8LKoVG6eDn5
         Xs9LQB6ysnoW9K6T3QpocwV4X67VZ3bOr9ZvEciYSaDeyjyreg+owNXPFrhtDABB4TUt
         9dvzV5r2NjCIEz3Zzt07QyBud4xReB67PeRI9C6qGlGwcDbUX+JiDtn/p06c8N/8ukqE
         C9M/7kwL8rO7SAjsRKb95jw6zhaVh1kkrgkr/3zI+HkRZzg6jOcPhsz/oolnBS/Fq7Jl
         v5we3yugT1h2tFF+xi9+bPJ+ql52YKavPwfp/u+s9PLPxLP8/LIbQDDpNMyOWX+jGqra
         p2TQ==
X-Gm-Message-State: AOAM533ctLz+JqQSFzhrVniZDXT9z9OwBEm0wGck/0SYjwYxSyuFOklc
        LFqLlU+bHUQQY9//DK2RMxq9ro0VaaJE6Ti2Nyw=
X-Google-Smtp-Source: ABdhPJzptK3j4oCoTK32vSa8oZL5Kf7bMD6jIgfr6JHvPNFzmGkdxZbJrQw1tjEmQ7n9n5lZ2ymCmPvfLR3Xyc1iblM=
X-Received: by 2002:a9d:200b:: with SMTP id n11mr2187992ota.169.1637648671050;
 Mon, 22 Nov 2021 22:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20211122095619.000060d2@gmail.com> <YZvrvmRnuDc1e+gi@google.com>
 <CANRm+Cx+bC8D7s1qzJYbrT+1rm46wxg6bAXD+kGYAHGnruZMXw@mail.gmail.com> <3204a646aa9d43d0b9af8da1c5ddf79f@kingsoft.com>
In-Reply-To: <3204a646aa9d43d0b9af8da1c5ddf79f@kingsoft.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Nov 2021 14:24:19 +0800
Message-ID: <CANRm+CxAM-h1F3CTNUY6wc-LAgRPDbwFrTPKXS_aoOBx9mveCQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over kvm_can_post_timer_interrupt
To:     =?UTF-8?B?eWFvYWlsaSBb5LmI54ix5YipXQ==?= <yaoaili@kingsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aili Yao <yaoaili126@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 at 12:11, yaoaili [=E4=B9=88=E7=88=B1=E5=88=A9] <yaoail=
i@kingsoft.com> wrote:
>
> > On Tue, 23 Nov 2021 at 03:14, Sean Christopherson <seanjc@google.com>
> > wrote:
> > >
> > > On Mon, Nov 22, 2021, Aili Yao wrote:
> > > > From: Aili Yao <yaoaili@kingsoft.com>
> > > >
> > > > When we isolate some pyhiscal cores, We may not use them for kvm
> > > > guests, We may use them for other purposes like DPDK, or we can mak=
e
> > > > some kvm guests isolated and some not, the global judgement
> > > > pi_inject_timer is not enough; We may make wrong decisions:
> > > >
> > > > In such a scenario, the guests without isolated cores will not be
> > > > permitted to use vmx preemption timer, and tscdeadline fastpath als=
o
> > > > be disabled, both will lead to performance penalty.
> > > >
> > > > So check whether the vcpu->cpu is isolated, if not, don't post time=
r
> > > > interrupt.
> > > >
> > > > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > > 759952dd1222..72dde5532101 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -34,6 +34,7 @@
> > > >  #include <asm/delay.h>
> > > >  #include <linux/atomic.h>
> > > >  #include <linux/jump_label.h>
> > > > +#include <linux/sched/isolation.h>
> > > >  #include "kvm_cache_regs.h"
> > > >  #include "irq.h"
> > > >  #include "ioapic.h"
> > > > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapi=
c
> > > > *apic)
> > > >
> > > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)  {
> > > > -     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > +             !housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);
> > >
> > > I don't think this is safe, vcpu->cpu will be -1 if the vCPU isn't sc=
heduled in.
>
> Yes, vcpu->cpu is  -1 before vcpu create, but in my environments, it didn=
't
> trigger this issue. I need to dig more, Thanks!
> Maybe I need one valid check here.
>
> > > This also doesn't play nice with the admin forcing pi_inject_timer=3D=
1.
> > > Not saying there's a reasonable use case for doing that, but it's
> > > supported today and this would break that behavior.  It would also
> > > lead to weird behavior if a vCPU were migrated on/off a housekeeping
> > > vCPU.  Again, probably not a reasonable use case, but I don't see any=
thing
> > that would outright prevent that behavior.
>
> Yes,  this is not one common operation,  But I did do test some scenarios=
:
> 1. isolated cpu --> housekeeping cpu;
>     isolated guest timer is in housekeeping CPU, for migration, kvm_can_p=
ost_timer_interrupt
>     will return false, so the timer may be migrated to vcpu->cpu;
>     This seems works in my test;
> 2. isolated --> isolated
>     Isolated guest timer is in housekeeping cpu, for migration,kvm_can_po=
st_timer_interrupt return
>     true, timer is not migrated
> 3. housekeeping CPU --> isolated CPU
>     non-isolated CPU timer is usually in vcpu->cpu, for migration to isol=
ated, kvm_can_post_timer_interrupt
>     will be true,  the timer remain on the same CPU;
>     This seems works in my test;
> 4. housekeeping CPU --> housekeeping CPU
>      timer migrated;
> It seems this is not an affecting problem;
>
> > >
> > > The existing behavior also feels a bit unsafe as pi_inject_timer is
> > > writable while KVM is running, though I supposed that's orthogonal to=
 this
> > discussion.
> > >
> > > Rather than check vcpu->cpu, is there an existing vCPU flag that can
> > > be queried, e.g. KVM_HINTS_REALTIME?
> >
> > How about something like below:
> >
> > From 67f605120e212384cb3d5788ba8c83f15659503b Mon Sep 17 00:00:00
> > 2001
> > From: Wanpeng Li <wanpengli@tencent.com>
> > Date: Tue, 23 Nov 2021 10:36:10 +0800
> > Subject: [PATCH] KVM: LAPIC: To keep the vCPUs in non-root mode for tim=
er-
> > pi
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted
> > interrupt) mentioned that the host admin should well tune the guest set=
up,
> > so that vCPUs are placed on isolated pCPUs, and with several pCPUs surp=
lus
> > for
> > *busy* housekeeping.
> > It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in no=
n-root
> > mode. However, we may isolate pCPUs for other purpose like DPDK or we
> > can make some guests isolated and others not, Let's add the checking
> > kvm_mwait_in_guest() to kvm_can_post_timer_interrupt() since we can't
> > benefit from timer posted-interrupt w/o keeping the vCPUs in non-root
> > mode.
> >
> > Reported-by: Aili Yao <yaoaili@kingsoft.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > 759952dd1222..8257566d44c7 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic
> > *apic)
> >
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)  {
> > -    return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +    return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) &&
> > kvm_vcpu_apicv_active(vcpu);
> >  }
> >
> >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)  {
> >      return kvm_x86_ops.set_hv_timer
> > -           && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > -            kvm_can_post_timer_interrupt(vcpu));
> > +           && !kvm_mwait_in_guest(vcpu->kvm);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
>
> This method seems more quick and safe, but I have one question: Does this=
 kvm_mwait_in_guest
> can guarantee the CPU isolated,  in some production environments and usua=
lly,  MWAIT feature is disabled in host
> and even guests with isolated CPUs.  And also we can set guests kvm_mwait=
_in_guest true with CPUs just pinned, not isolated.

You won't benefit from timer posted-interrupt if mwait is not exposed
to the guest since you can't keep CPU in non-root mode.
kvm_mwait_in_guest() will not guarantee the CPU is isolated, but
what's still bothering?

   Wanpeng
