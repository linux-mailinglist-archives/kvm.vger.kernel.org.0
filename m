Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB31B459CAC
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhKWHZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbhKWHZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:25:37 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EAEC061574;
        Mon, 22 Nov 2021 23:22:29 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso32437631otj.11;
        Mon, 22 Nov 2021 23:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E6qdF+xT3t2HA1txTSkWAyaI9rgoVw9j02qTMEQZZ0U=;
        b=mGzEZJuUONGTeP9qivEXdM4XgtUaymQ6an6yMvu4DlZ4uEOly+8qIMcpm3NvxL9GlG
         dTmhkv1WROS1vSamIvkuUzP/FebadrOUv7a/bzHkeVGwzHpF+9cjlS0ERcV66KZRrX0M
         aWK8DT7u9xcvnYSH5xXGLgY3YWNoExBzWhAZ6IiEFuZjZA0126rRN1UiiPgxxMRPcmDM
         IKmzxS4cWdjHDb+ervmHgpZONrHu6lePT5AYjUYSWou289oFLB1YOiTdOzLg7TB/Us2g
         njgcyz/2bPt+7ZRFD8Oe60U6iocfQV4x3dsCzC9W3su2KDOq+tj48p3MMHUFUkP8CgE0
         HGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E6qdF+xT3t2HA1txTSkWAyaI9rgoVw9j02qTMEQZZ0U=;
        b=nh++loW1FNkK/Hn/OcKg1UHSREizmmimhQL1HT0DDFuPe9RZdVvfk07wQ+DU+NCkNM
         ffOgXuGhP85ZpyNDeUEXI4EjyYphImQABJkQxp9Y6ECFHwMrsFmelUM900beNVPgFl2z
         gCDf815G0D10G2bGtDzaeSd5dfntkfWv9RioB/iYALzRV+Oh33ZfkHuPjjJ9bLE7XoyD
         hny9ssR9sg/TsFIM2Tox6Wd7dKjR9EbdvCOwL+FOl6kAiDzPmQjXyJA5ksRPTq6hPGdo
         cQZTY1zZ1/WZhC48bwAmA1gDZNA0olKWuZCNyKHSqw153+KVdcQ8HTD79Obq957AFH2L
         ewjw==
X-Gm-Message-State: AOAM533YCHABccd4k9RXTcHsUBrX9lIxx3tLnnnmAoVVwWNFhrC0adBf
        LAfG7hkx/l76K9ewyadV9bYdFAe6C92AFJh+qPE=
X-Google-Smtp-Source: ABdhPJwGo5ukFvItEeIr8a9Of+4gCrN+cKsOBRDKfW6LXKRDsQrtWJfZdoK1Tt5Q+7AIAtW6SVhpKwL1SmUd2mFDs4g=
X-Received: by 2002:a9d:6559:: with SMTP id q25mr2445324otl.0.1637652148527;
 Mon, 22 Nov 2021 23:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20211122095619.000060d2@gmail.com> <YZvrvmRnuDc1e+gi@google.com>
 <CANRm+Cx+bC8D7s1qzJYbrT+1rm46wxg6bAXD+kGYAHGnruZMXw@mail.gmail.com>
 <3204a646aa9d43d0b9af8da1c5ddf79f@kingsoft.com> <CANRm+CxAM-h1F3CTNUY6wc-LAgRPDbwFrTPKXS_aoOBx9mveCQ@mail.gmail.com>
 <20211123145713.76a7d5b8@gmail.com>
In-Reply-To: <20211123145713.76a7d5b8@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Nov 2021 15:22:17 +0800
Message-ID: <CANRm+CzDBZRMC5L2_NuEG8Ek-d8fJqC-SLRxM7p0=6XuB-2w=w@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over kvm_can_post_timer_interrupt
To:     Aili Yao <yaoaili126@gmail.com>
Cc:     =?UTF-8?B?eWFvYWlsaSBb5LmI54ix5YipXQ==?= <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>,
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

On Tue, 23 Nov 2021 at 15:04, Aili Yao <yaoaili126@gmail.com> wrote:
>
> On Tue, 23 Nov 2021 14:24:19 +0800
> Wanpeng Li <kernellwp@gmail.com> wrote:
>
> > On Tue, 23 Nov 2021 at 12:11, yaoaili [=E4=B9=88=E7=88=B1=E5=88=A9] <ya=
oaili@kingsoft.com>
> > wrote:
> > >
> > > > On Tue, 23 Nov 2021 at 03:14, Sean Christopherson
> > > > <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Nov 22, 2021, Aili Yao wrote:
> > > > > > From: Aili Yao <yaoaili@kingsoft.com>
> > > > > >
> > > > > > When we isolate some pyhiscal cores, We may not use them for
> > > > > > kvm guests, We may use them for other purposes like DPDK, or
> > > > > > we can make some kvm guests isolated and some not, the global
> > > > > > judgement pi_inject_timer is not enough; We may make wrong
> > > > > > decisions:
> > > > > >
> > > > > > In such a scenario, the guests without isolated cores will
> > > > > > not be permitted to use vmx preemption timer, and tscdeadline
> > > > > > fastpath also be disabled, both will lead to performance
> > > > > > penalty.
> > > > > >
> > > > > > So check whether the vcpu->cpu is isolated, if not, don't
> > > > > > post timer interrupt.
> > > > > >
> > > > > > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > > > > > ---
> > > > > >  arch/x86/kvm/lapic.c | 4 +++-
> > > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > > > > 759952dd1222..72dde5532101 100644
> > > > > > --- a/arch/x86/kvm/lapic.c
> > > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > > @@ -34,6 +34,7 @@
> > > > > >  #include <asm/delay.h>
> > > > > >  #include <linux/atomic.h>
> > > > > >  #include <linux/jump_label.h>
> > > > > > +#include <linux/sched/isolation.h>
> > > > > >  #include "kvm_cache_regs.h"
> > > > > >  #include "irq.h"
> > > > > >  #include "ioapic.h"
> > > > > > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct
> > > > > > kvm_lapic *apic)
> > > > > >
> > > > > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu
> > > > > > *vcpu)  {
> > > > > > -     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > > > +             !housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);
> > > > >
> > > > > I don't think this is safe, vcpu->cpu will be -1 if the vCPU
> > > > > isn't scheduled in.
> > >
> > > Yes, vcpu->cpu is  -1 before vcpu create, but in my environments,
> > > it didn't trigger this issue. I need to dig more, Thanks!
> > > Maybe I need one valid check here.
> > >
> > > > > This also doesn't play nice with the admin forcing
> > > > > pi_inject_timer=3D1. Not saying there's a reasonable use case for
> > > > > doing that, but it's supported today and this would break that
> > > > > behavior.  It would also lead to weird behavior if a vCPU were
> > > > > migrated on/off a housekeeping vCPU.  Again, probably not a
> > > > > reasonable use case, but I don't see anything
> > > > that would outright prevent that behavior.
> > >
> > > Yes,  this is not one common operation,  But I did do test some
> > > scenarios: 1. isolated cpu --> housekeeping cpu;
> > >     isolated guest timer is in housekeeping CPU, for migration,
> > > kvm_can_post_timer_interrupt will return false, so the timer may be
> > > migrated to vcpu->cpu; This seems works in my test;
> > > 2. isolated --> isolated
> > >     Isolated guest timer is in housekeeping cpu, for
> > > migration,kvm_can_post_timer_interrupt return true, timer is not
> > > migrated 3. housekeeping CPU --> isolated CPU
> > >     non-isolated CPU timer is usually in vcpu->cpu, for migration
> > > to isolated, kvm_can_post_timer_interrupt will be true,  the timer
> > > remain on the same CPU; This seems works in my test;
> > > 4. housekeeping CPU --> housekeeping CPU
> > >      timer migrated;
> > > It seems this is not an affecting problem;
> > >
> > > > >
> > > > > The existing behavior also feels a bit unsafe as
> > > > > pi_inject_timer is writable while KVM is running, though I
> > > > > supposed that's orthogonal to this
> > > > discussion.
> > > > >
> > > > > Rather than check vcpu->cpu, is there an existing vCPU flag
> > > > > that can be queried, e.g. KVM_HINTS_REALTIME?
> > > >
> > > > How about something like below:
> > > >
> > > > From 67f605120e212384cb3d5788ba8c83f15659503b Mon Sep 17 00:00:00
> > > > 2001
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > Date: Tue, 23 Nov 2021 10:36:10 +0800
> > > > Subject: [PATCH] KVM: LAPIC: To keep the vCPUs in non-root mode
> > > > for timer- pi
> > > >
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via
> > > > posted interrupt) mentioned that the host admin should well tune
> > > > the guest setup, so that vCPUs are placed on isolated pCPUs, and
> > > > with several pCPUs surplus for
> > > > *busy* housekeeping.
> > > > It is better to disable mwait/hlt/pause vmexits to keep the vCPUs
> > > > in non-root mode. However, we may isolate pCPUs for other purpose
> > > > like DPDK or we can make some guests isolated and others not,
> > > > Let's add the checking kvm_mwait_in_guest() to
> > > > kvm_can_post_timer_interrupt() since we can't benefit from timer
> > > > posted-interrupt w/o keeping the vCPUs in non-root mode.
> > > >
> > > > Reported-by: Aili Yao <yaoaili@kingsoft.com>
> > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > > > 759952dd1222..8257566d44c7 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct
> > > > kvm_lapic *apic)
> > > >
> > > >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> > > > {
> > > > -    return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > > > +    return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) &&
> > > > kvm_vcpu_apicv_active(vcpu);
> > > >  }
> > > >
> > > >  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)  {
> > > >      return kvm_x86_ops.set_hv_timer
> > > > -           && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > > > -            kvm_can_post_timer_interrupt(vcpu));
> > > > +           && !kvm_mwait_in_guest(vcpu->kvm);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
> > >
> > > This method seems more quick and safe, but I have one question:
> > > Does this kvm_mwait_in_guest can guarantee the CPU isolated,  in
> > > some production environments and usually,  MWAIT feature is
> > > disabled in host and even guests with isolated CPUs.  And also we
> > > can set guests kvm_mwait_in_guest true with CPUs just pinned, not
> > > isolated.
> >
> > You won't benefit from timer posted-interrupt if mwait is not exposed
> > to the guest since you can't keep CPU in non-root mode.
> > kvm_mwait_in_guest() will not guarantee the CPU is isolated, but
> > what's still bothering?
>
> Sorry, Did I miss some thing?
>
> What in my mind: MWait may be disabled in bios, so host will use halt
> instruction as one replacement for idle operation, in such a
> configuration, Mwait in guest will also be disabled even if you try to
> set kvm_mwait_in_guest true; As a result, halt,pause may not exit the
> guest, so the post interrupt still counts?

I prefer to expose mwait/hlt/pause to the guest simultaneously, you
don't need the ultra schedule latency/performance if you aren't
exposing mwait. Then why do you care about latency from the timer?

>
> For current code, We can migrate guest between isolated and
> housekeeping or we can change the cpu pinning on the fly, we allow this
> even the operation is not usually used, right?

My patch will not prevent using vmx preemption timer or tscdeadline fastpat=
h.

    Wanpeng
