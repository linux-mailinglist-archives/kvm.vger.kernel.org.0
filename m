Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFB2359900
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 11:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhDIJUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 05:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhDIJUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 05:20:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8389C061760
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 02:19:51 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1617959989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WfcZ5q0KU6r5Mjht3FAZ0XMh57ML+b4s2AEOei31CUo=;
        b=xoLcrIkIawpTNZ3LQUzhi7x9ccpgy/pSVEIY99tRm9kbitE1qpEYynpQyqLnW+mcC1xsny
        BsMWYb2yzo8TjMf3wUujvOyymz1j05yCerDfVUlPL+68yR2rU+7WW9YJczi4xrJ3O6t+50
        7hi5BED+G5xmJhEmND4iMxxYHh8AuyfV/WOuBi01nMq+26PwvKBXHfwut0P2DHoEBmT/cx
        sis/L07yykDEn1HMhR33Lx7uAJrEw/hdJLyAnOzi5C0N+qCpo5KvqnkFcUx/pGdhmLLZAi
        hd1zTxmrI5xsZQ5SjafTJSOW65Z4Yi2vevgKuL/50zBApDQx3R4QA8mLc40W/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1617959989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WfcZ5q0KU6r5Mjht3FAZ0XMh57ML+b4s2AEOei31CUo=;
        b=4zhzvsRiUgV1AIipj4zLtc/L6rPMz45SrnYUvDDr41jUbJFn/8OULNdT5zp2qUp4BhUOIj
        y7SeMxfv60zFcxBQ==
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Michael Tokarev <mjt@tls.msk.ru>, kvm <kvm@vger.kernel.org>,
        "qemu-devel\@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Commit "x86/kvm: Move context tracking where it belongs" broke guest time accounting
In-Reply-To: <CANRm+CwgvAPOvCxmuEDb+L5kvjBcpWE03Ps70qpqKntHuPxpaA@mail.gmail.com>
References: <YGzW/Pa/p7svg5Rr@google.com> <874kgg29uo.ffs@nanos.tec.linutronix.de> <CANRm+CwgvAPOvCxmuEDb+L5kvjBcpWE03Ps70qpqKntHuPxpaA@mail.gmail.com>
Date:   Fri, 09 Apr 2021 11:19:48 +0200
Message-ID: <871rbj6ci3.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09 2021 at 16:13, Wanpeng Li wrote:
> On Thu, 8 Apr 2021 at 21:19, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> +    account_guest_enter();

This wants to move into the instrumentation_begin/end() section above.

>      guest_enter_irqoff();
>      lockdep_hardirqs_on(CALLER_ADDR0);
>
> @@ -3759,6 +3760,8 @@ static noinstr void svm_vcpu_enter_exit(struct
> kvm_vcpu *vcpu)
>       */
>      lockdep_hardirqs_off(CALLER_ADDR0);
>      guest_exit_irqoff();
> +    if (vtime_accounting_enabled_this_cpu())
> +        account_guest_exit();

This time below. Aside of that I'd suggest to have two inlines instead
of having the conditional here.

>
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> -/* must be called with irqs disabled */
> -static __always_inline void guest_enter_irqoff(void)
> +static __always_inline void account_guest_enter(void)
>  {
>      instrumentation_begin();
>      if (vtime_accounting_enabled_this_cpu())
> @@ -113,7 +112,11 @@ static __always_inline void guest_enter_irqoff(void)
>      else
>          current->flags |= PF_VCPU;
>      instrumentation_end();

If you move the invocation into the instrumentable section then this
instrumentation_begin/end() can be removed.

Something like the below +/- the obligatory bikeshed painting
vs. function names.

Thanks,

        tglx
---
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3782,6 +3782,7 @@ static noinstr void svm_vcpu_enter_exit(
 	 * accordingly.
 	 */
 	instrumentation_begin();
+	vtime_account_guest_enter();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	instrumentation_end();
@@ -3816,6 +3817,7 @@ static noinstr void svm_vcpu_enter_exit(
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6655,6 +6655,7 @@ static noinstr void vmx_vcpu_enter_exit(
 	 * accordingly.
 	 */
 	instrumentation_begin();
+	vtime_account_guest_enter();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	instrumentation_end();
@@ -6693,6 +6694,7 @@ static noinstr void vmx_vcpu_enter_exit(
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
+	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9200,6 +9200,7 @@ static int vcpu_enter_guest(struct kvm_v
 	++vcpu->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
+	vcpu_account_guest_exit();
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -107,13 +107,6 @@ static inline void context_tracking_init
 /* must be called with irqs disabled */
 static __always_inline void guest_enter_irqoff(void)
 {
-	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_enter(current);
-	else
-		current->flags |= PF_VCPU;
-	instrumentation_end();
-
 	if (context_tracking_enabled())
 		__context_tracking_enter(CONTEXT_GUEST);
 
@@ -135,37 +128,18 @@ static __always_inline void guest_exit_i
 {
 	if (context_tracking_enabled())
 		__context_tracking_exit(CONTEXT_GUEST);
-
-	instrumentation_begin();
-	if (vtime_accounting_enabled_this_cpu())
-		vtime_guest_exit(current);
-	else
-		current->flags &= ~PF_VCPU;
-	instrumentation_end();
 }
 
 #else
 static __always_inline void guest_enter_irqoff(void)
 {
-	/*
-	 * This is running in ioctl context so its safe
-	 * to assume that it's the stime pending cputime
-	 * to flush.
-	 */
 	instrumentation_begin();
-	vtime_account_kernel(current);
-	current->flags |= PF_VCPU;
 	rcu_virt_note_context_switch(smp_processor_id());
 	instrumentation_end();
 }
 
 static __always_inline void guest_exit_irqoff(void)
 {
-	instrumentation_begin();
-	/* Flush the guest cputime we spent on the guest */
-	vtime_account_kernel(current);
-	current->flags &= ~PF_VCPU;
-	instrumentation_end();
 }
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */
 
@@ -178,4 +152,24 @@ static inline void guest_exit(void)
 	local_irq_restore(flags);
 }
 
+static __always_inline void vtime_account_guest_enter(void)
+{
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_guest_enter(current);
+	else
+		current->flags |= PF_VCPU;
+}
+
+static __always_inline void vtime_account_guest_exit(void)
+{
+	if (vtime_accounting_enabled_this_cpu())
+		vtime_guest_exit(current);
+}
+
+static __always_inline void vcpu_account_guest_exit(void)
+{
+	if (!vtime_accounting_enabled_this_cpu())
+		current->flags &= ~PF_VCPU;
+}
+
 #endif
