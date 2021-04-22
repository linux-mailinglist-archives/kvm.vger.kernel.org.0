Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5B368036
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbhDVMWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhDVMWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 08:22:34 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06CCC06174A;
        Thu, 22 Apr 2021 05:21:59 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 92-20020a9d02e50000b029028fcc3d2c9eso19442630otl.0;
        Thu, 22 Apr 2021 05:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2wdQcpOEIW3s5NuQZdH2AHeKKAm7rq2ZvU9omVKAZ0=;
        b=Lrr0naib7wyVfnNhDsk8hikPV65ca5UFbn8EaW5Q4knsvibd1Zq6RZBLi16WbpUm+3
         VLNamAMjAl57aAyvkd5tk3tczPkutOd949mTxH3R8oRhPSEAavWkTsVawj33RJfOwqR+
         WERL67HIhEcAsNvZAwPG4n4gXl1m3HLWKbMMxB3mKWy0NwThV3BuAQxMxyElhBGY/Hgw
         dLie1X6m8UmmFcsdn97e57BNDhwARjOJ8AQoyjR+lZAPiJK2wKdDqbBZPVUU31D8P742
         v68uIVthkYNRVYNbpwBUIqKz2yDuVWBopdc46ZB8XMeDpbSJZpra2cildzULk/XVd+JI
         eqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2wdQcpOEIW3s5NuQZdH2AHeKKAm7rq2ZvU9omVKAZ0=;
        b=pGJywkfRh51K2H41mH/3dKMZvI5YxZY1qj3tiey+gt3jkSCalkSmQAPMmAW12rSJ7w
         QnqzEpY/GjitKnfH3XAdkluT19eqzBwgQPvgIMR1AL90pFKKj1xaBedVdu2/C4fTSAMC
         XwSK+enItvsbCy0PRl7LUqB+4SZ5LQT+j3+LI6NOTo40114e8jlACsZsVRx7rdrVluMw
         OPNFsVmTbVvPRxJOvGCmeC8UZYFYvI3uzPoxj0/8bdkSwuPUCDAp12kcejMXNErxwN0s
         WrJI3dNjcO22ETPvE2hBKU5NdlSBUfZtc36oZ5u3Hia8is3WjFiv9FZowvu1wq8uvW2v
         NzHQ==
X-Gm-Message-State: AOAM532fP5yHkkuMZVHLAH5/YcoKeYKLzxNE1U8JRy01oApee463pGR3
        zj095zdz4zNeMPpgV/NNLiAvn4yUMqoSpwkKGAc=
X-Google-Smtp-Source: ABdhPJyh2M17Kcti6C2M3sLt6f83mwvLP/2AeNIveuDBG7mmME6Fs88u+uGPglEX8thieAl/yPfaBE01tMDn8B3cz20=
X-Received: by 2002:a9d:6b13:: with SMTP id g19mr2642849otp.185.1619094119375;
 Thu, 22 Apr 2021 05:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp> <YIBQmMih1sNb5/rg@google.com>
In-Reply-To: <YIBQmMih1sNb5/rg@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 22 Apr 2021 20:21:47 +0800
Message-ID: <CANRm+CxMf=kwDRQE-BNbhgCARuV3fuKpDbEV2oWTeKuGhUYd+w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in
 VM-Agnostic KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pierre-Louis Aublin <pl@sslab.ics.keio.ac.jp>,
        =?UTF-8?B?5rKz6YeO5YGl5LqM?= <kono@sslab.ics.keio.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Apr 2021 at 09:45, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Apr 22, 2021, Kenta Ishiguro wrote:
> > To solve problems (2) and (3), patch 2 monitors IPI communication between
> > vCPUs and leverages the relationship between vCPUs to select boost
> > candidates.  The "[PATCH] KVM: Boost vCPU candidiate in user mode which is
> > delivering interrupt" patch
> > (https://lore.kernel.org/kvm/CANRm+Cy-78UnrkX8nh5WdHut2WW5NU=UL84FRJnUNjsAPK+Uww@mail.gmail.com/T/)
> > seems to be effective for (2) while it only uses the IPI receiver
> > information.
>
> On the IPI side of thing, I like the idea of explicitly tracking the IPIs,
> especially if we can simplify the implementation, e.g. by losing the receiver
> info and making ipi_received a bool.  Maybe temporarily table Wanpeng's patch
> while this approach is analyzed?

Hi all,

I evaluate my patch
(https://lore.kernel.org/kvm/1618542490-14756-1-git-send-email-wanpengli@tencent.com),
Kenta's patch 2 and Sean's suggestion. The testing environment is
pbzip2 in 96 vCPUs VM in over-subscribe scenario (The host machine is
2 socket, 48 cores, 96 HTs Intel CLX box). Note: the Kenta's scheduler
hacking is not applied. The score of my patch is the most stable and
the best performance.

Wanpeng's patch

The average: vanilla -> boost: 69.124 -> 61.975, 10.3%

* Wall Clock: 61.695359 seconds
* Wall Clock: 63.343579 seconds
* Wall Clock: 61.567513 seconds
* Wall Clock: 62.144722 seconds
* Wall Clock: 61.091442 seconds
* Wall Clock: 62.085912 seconds
* Wall Clock: 61.311954 seconds

Kenta' patch

The average: vanilla -> boost: 69.148 -> 64.567, 6.6%

* Wall Clock:  66.288113 seconds
* Wall Clock:  61.228642 seconds
* Wall Clock:  62.100524 seconds
* Wall Clock:  68.355473 seconds
* Wall Clock:  64.864608 seconds

Sean's suggestion:

The average: vanilla -> boost: 69.148 -> 66.505, 3.8%

* Wall Clock: 60.583562 seconds
* Wall Clock: 58.533960 seconds
* Wall Clock: 70.103489 seconds
* Wall Clock: 74.279028 seconds
* Wall Clock: 69.024194 seconds

I follow(almost) Sean's suggestion:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0050f39..78b5eb6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1272,6 +1272,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
     struct kvm_lapic_irq irq;
+    struct kvm_vcpu *dest_vcpu;

     irq.vector = icr_low & APIC_VECTOR_MASK;
     irq.delivery_mode = icr_low & APIC_MODE_MASK;
@@ -1285,6 +1286,10 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic,
u32 icr_low, u32 icr_high)
     else
         irq.dest_id = GET_APIC_DEST_FIELD(icr_high);

+    dest_vcpu = kvm_get_vcpu_by_id(apic->vcpu->kvm, irq.dest_id);
+    if (dest_vcpu)
+        WRITE_ONCE(dest_vcpu->ipi_received, true);
+
     trace_kvm_apic_ipi(icr_low, irq.dest_id);

     kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 303fb55..a98bf571 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9298,6 +9298,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
     if (test_thread_flag(TIF_NEED_FPU_LOAD))
         switch_fpu_return();

+    WRITE_ONCE(vcpu->ipi_received, false);
+
     if (unlikely(vcpu->arch.switch_db_regs)) {
         set_debugreg(0, 7);
         set_debugreg(vcpu->arch.eff_db[0], 0);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5ef09a4..81e39fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -332,6 +332,8 @@ struct kvm_vcpu {
         bool dy_eligible;
     } spin_loop;
 #endif
+
+    bool ipi_received;
     bool preempted;
     bool ready;
     struct kvm_vcpu_arch arch;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c682f82..5098929 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -411,6 +411,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu,
struct kvm *kvm, unsigned id)

     kvm_vcpu_set_in_spin_loop(vcpu, false);
     kvm_vcpu_set_dy_eligible(vcpu, false);
+    vcpu->ipi_received = false;
     vcpu->preempted = false;
     vcpu->ready = false;
     preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
@@ -3220,6 +3221,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool
yield_to_kernel_mode)
                 !vcpu_dy_runnable(vcpu))
                 continue;
             if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+                !READ_ONCE(vcpu->ipi_received) &&
                 !kvm_arch_vcpu_in_kernel(vcpu))
                 continue;
             if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
