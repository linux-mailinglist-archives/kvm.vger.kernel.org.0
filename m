Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE844359754
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhDIIN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhDIIN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:13:27 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFA3C061760
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 01:13:15 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id c16so4992587oib.3
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9XgqiPdxg3C4zte8wS8+mM+7OjQRzCoU6HQWbEd64Rc=;
        b=d2VzegrnqSBitwwpXVkKHUnfxmVPU9yfkTMt0uoPWmHo36MlD2KHUV+A5nlxrAcspR
         mv3eUsCG27kNUVSyP4SQ8ZenL6hdD3lU2sVtMlW4vtW03NI4afTAYnsZ68bpZD8Jhxm4
         i7ZS7sNN9o0KPqZ5HozT3wysIXLnabqb76mlcuO1bmDUb/jGvNyRiwtFQ8uBwhtFJunX
         aRNWaEWq8cIqe2eYxDWFdafGPL7qFUIkuyU5IUQan8R3TFKggyJl44jZbMysaMOzZk1s
         3PrU56qwdmtqY4yVGEfswQhNj4ZeYwgkTukf+rVFSJ5EWZpnhk6vfa9LaZmckzv+rhrN
         L1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9XgqiPdxg3C4zte8wS8+mM+7OjQRzCoU6HQWbEd64Rc=;
        b=DriFOFTAvO6ZmivO7cNGYSurWeFAZXEirOtntRhzsovjqk5ON2MKrCDY9I4v1M6xuR
         oCw+IlTgWeGqCXxvo1M4BEjESuiLCwMgcR+mAF4p1+V/Jvoun1oyJoA4IBj7lebEslDR
         AtOrlC53RhrXNCWMag+WugPRagt/GXb+AQPFN30uPaLuEDZaWhhAcZ0AX3ZOLQaOshR2
         nrbVfx+KftzLeh6u5kWkDyzcK9phWtoPZBk0TyEP2n3Fq2EZbCUHAFCLlVZ3PocMjzC8
         r/FeST6qXK5Cy4klNyhcAYTqgyHiMMhvmTSRNKSKMxN15inNKzCFKNmvDSwCTvhzcj6q
         ps9g==
X-Gm-Message-State: AOAM532WrI+4EIy6asnWJmn8LghxQczFXBH/aLk5Fo451LHI/RFRVtKT
        9tGrazT4W+wJJ3h235uk3IWx6967ajOXiA4GsbE=
X-Google-Smtp-Source: ABdhPJwcKn8CHlQHDj9Prp5Fk47MB9U6BhYvTAVDoFYyjaxFaAyVk0bezbe0pSxeU6takauUtp9YErRkYY/yykWvKm8=
X-Received: by 2002:aca:1a01:: with SMTP id a1mr9157785oia.33.1617955994619;
 Fri, 09 Apr 2021 01:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <YGzW/Pa/p7svg5Rr@google.com> <874kgg29uo.ffs@nanos.tec.linutronix.de>
In-Reply-To: <874kgg29uo.ffs@nanos.tec.linutronix.de>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Apr 2021 16:13:03 +0800
Message-ID: <CANRm+CwgvAPOvCxmuEDb+L5kvjBcpWE03Ps70qpqKntHuPxpaA@mail.gmail.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke
 guest time accounting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Michael Tokarev <mjt@tls.msk.ru>, kvm <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Apr 2021 at 21:19, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Tue, Apr 06 2021 at 21:47, Sean Christopherson wrote:
> > On Tue, Apr 06, 2021, Michael Tokarev wrote:
> >> broke kvm guest cpu time accounting - after this commit, when running
> >> qemu-system-x86_64 -enable-kvm, the guest time (in /proc/stat and
> >> elsewhere) is always 0.
> >>
> >> I dunno why it happened, but it happened, and all kernels after 5.9
> >> are affected by this.
> >>
> >> This commit is found in a (painful) git bisect between kernel 5.8 and 5.10.
> >
> > Yes :-(
> >
> > There's a bugzilla[1] and two proposed fixes[2][3].  I don't particularly like
> > either of the fixes, but an elegant solution hasn't presented itself.
> >
> > Thomas/Paolo, can you please weigh in?
> >
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > [2] https://lkml.kernel.org/r/1617011036-11734-1-git-send-email-wanpengli@tencent.com
> > [3] https://lkml.kernel.org/r/20210206004218.312023-1-seanjc@google.com
>
> All of the solutions I looked at so far are ugly as hell. The problem is
> that the accounting is plumbed into the context tracking and moving
> context tracking around to a different place is just wrong.
>
> I think the right solution is to seperate the time accounting logic out
> from guest_enter/exit_irqoff() and have virt time specific helpers which
> can be placed at the proper spots in kvm.

For x86 part, how about something like below:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f3..7aeb724 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3730,6 +3730,7 @@ static noinstr void svm_vcpu_enter_exit(struct
kvm_vcpu *vcpu)
     lockdep_hardirqs_on_prepare(CALLER_ADDR0);
     instrumentation_end();

+    account_guest_enter();
     guest_enter_irqoff();
     lockdep_hardirqs_on(CALLER_ADDR0);

@@ -3759,6 +3760,8 @@ static noinstr void svm_vcpu_enter_exit(struct
kvm_vcpu *vcpu)
      */
     lockdep_hardirqs_off(CALLER_ADDR0);
     guest_exit_irqoff();
+    if (vtime_accounting_enabled_this_cpu())
+        account_guest_exit();

     instrumentation_begin();
     trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2..5f6c30c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6617,6 +6617,7 @@ static noinstr void vmx_vcpu_enter_exit(struct
kvm_vcpu *vcpu,
     lockdep_hardirqs_on_prepare(CALLER_ADDR0);
     instrumentation_end();

+    account_guest_enter();
     guest_enter_irqoff();
     lockdep_hardirqs_on(CALLER_ADDR0);

@@ -6648,6 +6649,8 @@ static noinstr void vmx_vcpu_enter_exit(struct
kvm_vcpu *vcpu,
      */
     lockdep_hardirqs_off(CALLER_ADDR0);
     guest_exit_irqoff();
+    if (vtime_accounting_enabled_this_cpu())
+        account_guest_exit();

     instrumentation_begin();
     trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16fb395..33422c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9229,6 +9229,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
     ++vcpu->stat.exits;
     local_irq_disable();
     kvm_after_interrupt(vcpu);
+    if (!vtime_accounting_enabled_this_cpu())
+        account_guest_exit();

     if (lapic_in_kernel(vcpu)) {
         s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index bceb064..ff70229 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -104,8 +104,7 @@ static inline void context_tracking_init(void) { }


 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-/* must be called with irqs disabled */
-static __always_inline void guest_enter_irqoff(void)
+static __always_inline void account_guest_enter(void)
 {
     instrumentation_begin();
     if (vtime_accounting_enabled_this_cpu())
@@ -113,7 +112,11 @@ static __always_inline void guest_enter_irqoff(void)
     else
         current->flags |= PF_VCPU;
     instrumentation_end();
+}

+/* must be called with irqs disabled */
+static __always_inline void guest_enter_irqoff(void)
+{
     if (context_tracking_enabled())
         __context_tracking_enter(CONTEXT_GUEST);

@@ -131,11 +134,8 @@ static __always_inline void guest_enter_irqoff(void)
     }
 }

-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void account_guest_exit(void)
 {
-    if (context_tracking_enabled())
-        __context_tracking_exit(CONTEXT_GUEST);
-
     instrumentation_begin();
     if (vtime_accounting_enabled_this_cpu())
         vtime_guest_exit(current);
@@ -144,8 +144,14 @@ static __always_inline void guest_exit_irqoff(void)
     instrumentation_end();
 }

+static __always_inline void guest_exit_irqoff(void)
+{
+    if (context_tracking_enabled())
+        __context_tracking_exit(CONTEXT_GUEST);
+}
+
 #else
-static __always_inline void guest_enter_irqoff(void)
+static __always_inline void account_guest_enter(void)
 {
     /*
      * This is running in ioctl context so its safe
@@ -155,11 +161,17 @@ static __always_inline void guest_enter_irqoff(void)
     instrumentation_begin();
     vtime_account_kernel(current);
     current->flags |= PF_VCPU;
+    instrumentation_end();
+}
+
+static __always_inline void guest_enter_irqoff(void)
+{
+    instrumentation_begin();
     rcu_virt_note_context_switch(smp_processor_id());
     instrumentation_end();
 }

-static __always_inline void guest_exit_irqoff(void)
+static __always_inline void account_guest_exit(void)
 {
     instrumentation_begin();
     /* Flush the guest cputime we spent on the guest */
@@ -167,6 +179,11 @@ static __always_inline void guest_exit_irqoff(void)
     current->flags &= ~PF_VCPU;
     instrumentation_end();
 }
+
+static __always_inline void guest_exit_irqoff(void)
+{
+
+}
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */

 static inline void guest_exit(void)
