Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5EB459A4A
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhKWDA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 22:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKWDA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 22:00:57 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E7C061574;
        Mon, 22 Nov 2021 18:57:50 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id u74so41690774oie.8;
        Mon, 22 Nov 2021 18:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+PfKM5+BXtpPxMwFFLQf7c1ReGeR+E33SLHVUAdsXro=;
        b=HsgBuuFhMwWG5y0W7zpMNyVPm524nbiUnao0Ns/KspjMP0JkIkg0LaE6IZZOibFQvK
         IRerg8RuCEbdcC3WvQK95mE+zyjeyfdlexO63jr+OzlSpJ7WiAByOdYMJvhxm0xIBx5K
         xVYoVuNxJPhtWHv1XPYwGlVErJzk6H580f0RGnDv7SS1G5rVrl3y8CQ27gW21OQbitKP
         KSB2MbMepd1+lzBdJb1C/kk31YKBmXcG1A5mVBJxopIvyEvqk0b0t9eSip/gxOOBenV0
         PIypaazJvcEq/iArBwgQHLzswkYNJ5zJMmnURl6q7BW5QUzK+agMMICxMR8GJVQKuDMh
         yQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+PfKM5+BXtpPxMwFFLQf7c1ReGeR+E33SLHVUAdsXro=;
        b=whB2ejKceP97JK2sYERkncpbZaAe8O1w4K8V78d2/xOApPX5gI9v0THSxHUOv+qa1U
         VN7lAx7Z+euN5/Oh5EkfhvRaGd9Rz3HugPdAtDvP2QPrWrUuwttqDSCkPd2ZKjJpU5pP
         AOEhy7x/+oXUuVDQbn5X8s5DHClbMhUUTu8Orim2K4rTPmRxQYsAizbXUzGoA9kAP3Jr
         xWGCZr+1CtmW2nqdaH6mnpzn74Sj9svrFmpjLhy93ksjR3zZ/rWPyixrjfrSfWKlJiAl
         XP4w8jJZirVWguAAF+a3aIbiCY8+Y+QY5G1H/QaYq9OK4FQ3STkBvyJ2GU6i8Wen7yBN
         ewMA==
X-Gm-Message-State: AOAM5305meXiUZcuS0YNpGGRHY+pLsfN3hB+FZVLdXdkZ39ByhEie5qJ
        v4ErGtGwN6trZ++GMa68r+H0hd/IZJoUvn2Awjk=
X-Google-Smtp-Source: ABdhPJyzJnmXDZeeINl57vI96DP1Mg/KDzKedP8P1UH7ZgqxWQWyg1wA1cTJLwWGplxKZKH3oHLsdgNo5OGs4knEqMQ=
X-Received: by 2002:a05:6808:5c1:: with SMTP id d1mr27439882oij.141.1637636269627;
 Mon, 22 Nov 2021 18:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20211122095619.000060d2@gmail.com> <YZvrvmRnuDc1e+gi@google.com>
In-Reply-To: <YZvrvmRnuDc1e+gi@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 23 Nov 2021 10:57:38 +0800
Message-ID: <CANRm+Cx+bC8D7s1qzJYbrT+1rm46wxg6bAXD+kGYAHGnruZMXw@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Per vCPU control over kvm_can_post_timer_interrupt
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aili Yao <yaoaili126@gmail.com>,
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
        LKML <linux-kernel@vger.kernel.org>, yaoaili@kingsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 at 03:14, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Aili Yao wrote:
> > From: Aili Yao <yaoaili@kingsoft.com>
> >
> > When we isolate some pyhiscal cores, We may not use them for kvm guests,
> > We may use them for other purposes like DPDK, or we can make some kvm
> > guests isolated and some not, the global judgement pi_inject_timer is
> > not enough; We may make wrong decisions:
> >
> > In such a scenario, the guests without isolated cores will not be
> > permitted to use vmx preemption timer, and tscdeadline fastpath also be
> > disabled, both will lead to performance penalty.
> >
> > So check whether the vcpu->cpu is isolated, if not, don't post timer
> > interrupt.
> >
> > Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 759952dd1222..72dde5532101 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -34,6 +34,7 @@
> >  #include <asm/delay.h>
> >  #include <linux/atomic.h>
> >  #include <linux/jump_label.h>
> > +#include <linux/sched/isolation.h>
> >  #include "kvm_cache_regs.h"
> >  #include "irq.h"
> >  #include "ioapic.h"
> > @@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> >
> >  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> >  {
> > -     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > +             !housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);
>
> I don't think this is safe, vcpu->cpu will be -1 if the vCPU isn't scheduled in.
> This also doesn't play nice with the admin forcing pi_inject_timer=1.  Not saying
> there's a reasonable use case for doing that, but it's supported today and this
> would break that behavior.  It would also lead to weird behavior if a vCPU were
> migrated on/off a housekeeping vCPU.  Again, probably not a reasonable use case,
> but I don't see anything that would outright prevent that behavior.
>
> The existing behavior also feels a bit unsafe as pi_inject_timer is writable while
> KVM is running, though I supposed that's orthogonal to this discussion.
>
> Rather than check vcpu->cpu, is there an existing vCPU flag that can be queried,
> e.g. KVM_HINTS_REALTIME?

How about something like below:

From 67f605120e212384cb3d5788ba8c83f15659503b Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Tue, 23 Nov 2021 10:36:10 +0800
Subject: [PATCH] KVM: LAPIC: To keep the vCPUs in non-root mode for timer-pi

From: Wanpeng Li <wanpengli@tencent.com>

As commit 0c5f81dad46 (KVM: LAPIC: Inject timer interrupt via posted interrupt)
mentioned that the host admin should well tune the guest setup, so that vCPUs
are placed on isolated pCPUs, and with several pCPUs surplus for
*busy* housekeeping.
It is better to disable mwait/hlt/pause vmexits to keep the vCPUs in non-root
mode. However, we may isolate pCPUs for other purpose like DPDK or we can make
some guests isolated and others not, Let's add the checking kvm_mwait_in_guest()
to kvm_can_post_timer_interrupt() since we can't benefit from timer
posted-interrupt
w/o keeping the vCPUs in non-root mode.

Reported-by: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..8257566d44c7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -113,14 +113,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)

 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-    return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+    return pi_inject_timer && kvm_mwait_in_guest(vcpu->kvm) &&
kvm_vcpu_apicv_active(vcpu);
 }

 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
     return kvm_x86_ops.set_hv_timer
-           && !(kvm_mwait_in_guest(vcpu->kvm) ||
-            kvm_can_post_timer_interrupt(vcpu));
+           && !kvm_mwait_in_guest(vcpu->kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
