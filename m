Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9ED48B0F1
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 16:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343657AbiAKPgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 10:36:18 -0500
Received: from foss.arm.com ([217.140.110.172]:48212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240480AbiAKPgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 10:36:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C24F8ED1;
        Tue, 11 Jan 2022 07:36:17 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 482BB3F774;
        Tue, 11 Jan 2022 07:36:13 -0800 (PST)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     aleksandar.qemu.devel@gmail.com, alexandru.elisei@arm.com,
        anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        mark.rutland@arm.com, maz@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, nsaenzju@redhat.com, palmer@dabbelt.com,
        paulmck@kernel.org, paulus@samba.org, paul.walmsley@sifive.com,
        pbonzini@redhat.com, seanjc@google.com, suzuki.poulose@arm.com,
        tglx@linutronix.de, tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: [PATCH 1/5] kvm: add exit_to_guest_mode() and enter_from_guest_mode()
Date:   Tue, 11 Jan 2022 15:35:35 +0000
Message-Id: <20220111153539.2532246-2-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111153539.2532246-1-mark.rutland@arm.com>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When transitioning to/from guest mode, it is necessary to inform
lockdep, tracing, and RCU in a specific order, similar to the
requirements for transitions to/from user mode. Additionally, it is
necessary to perform vtime accounting for a window around running the
guest, with RCU enabled, such that timer interrupts taken from the guest
can be accounted as guest time.

Most architectures don't handle all the necessary pieces, and a have a
number of common bugs, including unsafe usage of RCU during the window
between guest_enter() and guest_exit().

On x86, this was dealt with across commits:

  87fa7f3e98a1310e ("x86/kvm: Move context tracking where it belongs")
  0642391e2139a2c1 ("x86/kvm/vmx: Add hardirq tracing to guest enter/exit")
  9fc975e9efd03e57 ("x86/kvm/svm: Add hardirq tracing on guest enter/exit")
  3ebccdf373c21d86 ("x86/kvm/vmx: Move guest enter/exit into .noinstr.text")
  135961e0a7d555fc ("x86/kvm/svm: Move guest enter/exit into .noinstr.text")
  160457140187c5fb ("KVM: x86: Defer vtime accounting 'til after IRQ handling")
  bc908e091b326467 ("KVM: x86: Consolidate guest enter/exit logic to common helpers")

... but those fixes are specific to x86, and as the resulting logic
(while correct) is split across generic helper functions and
x86-specific helper functions, it is difficult to see that the
entry/exit accounting is balanced.

This patch adds generic helpers which architectures can use to handle
guest entry/exit consistently and correctly. The guest_{enter,exit}()
helpers are split into guest_timing_{enter,exit}() to perform vtime
accounting, and guest_context_{enter,exit}() to perform the necessary
context tracking and RCU management. The existing guest_{enter,exit}()
heleprs are left as wrappers of these.

Atop this, new exit_to_guest_mode() and enter_from_guest_mode() helpers
are added to handle the ordering of lockdep, tracing, and RCU manageent.
These are named to align with exit_to_user_mode() and
enter_from_user_mode().

Subsequent patches will migrate architectures over to the new helpers,
following a sequence:

	guest_timing_enter_irqoff();

	exit_to_guest_mode();
	< run the vcpu >
	enter_from_guest_mode();

	< take any pending IRQs >

	guest_timing_exit_irqoff();

This sequences handles all of the above correctly, and more clearly
balances the entry and exit portions, making it easier to understand.

The existing helpers are marked as deprecated, and will be removed once
all architectures have been converted.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 include/linux/kvm_host.h | 108 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..13fcf7979880 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -29,6 +29,8 @@
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <linux/notifier.h>
+#include <linux/ftrace.h>
+#include <linux/instrumentation.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -362,8 +364,11 @@ struct kvm_vcpu {
 	int last_used_slot;
 };
 
-/* must be called with irqs disabled */
-static __always_inline void guest_enter_irqoff(void)
+/*
+ * Start accounting time towards a guest.
+ * Must be called before entering guest context.
+ */
+static __always_inline void guest_timing_enter_irqoff(void)
 {
 	/*
 	 * This is running in ioctl context so its safe to assume that it's the
@@ -372,7 +377,17 @@ static __always_inline void guest_enter_irqoff(void)
 	instrumentation_begin();
 	vtime_account_guest_enter();
 	instrumentation_end();
+}
 
+/*
+ * Enter guest context and enter an RCU extended quiescent state.
+ *
+ * This should be the last thing called before entering the guest, and must be
+ * called after any potential use of RCU (including any potentially
+ * instrumented code).
+ */
+static __always_inline void guest_context_enter_irqoff(void)
+{
 	/*
 	 * KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -388,16 +403,77 @@ static __always_inline void guest_enter_irqoff(void)
 	}
 }
 
-static __always_inline void guest_exit_irqoff(void)
+/*
+ * Deprecated. Architectures should move to guest_timing_enter_irqoff() and
+ * exit_to_guest_mode().
+ */
+static __always_inline void guest_enter_irqoff(void)
+{
+	guest_timing_enter_irqoff();
+	guest_context_enter_irqoff();
+}
+
+/**
+ * exit_to_guest_mode - Fixup state when exiting to guest mode
+ *
+ * This is analagous to exit_to_user_mode(), and ensures we perform the
+ * following in order:
+ *
+ * 1) Trace interrupts on state
+ * 2) Invoke context tracking if enabled to adjust RCU state
+ * 3) Tell lockdep that interrupts are enabled
+ *
+ * Invoked from architecture specific code as the last step before entering a
+ * guest. Must be invoked with interrupts disabled and the caller must be
+ * non-instrumentable.
+ *
+ * This must be called after guest_timing_enter_irqoff().
+ */
+static __always_inline void exit_to_guest_mode(void)
+{
+	instrumentation_begin();
+	trace_hardirqs_on_prepare();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instrumentation_end();
+
+	guest_context_enter_irqoff();
+	lockdep_hardirqs_on(CALLER_ADDR0);
+}
+
+/*
+ * Exit guest context and exit an RCU extended quiescent state.
+ *
+ * This should be the first thing called after exiting the guest, and must be
+ * called before any potential use of RCU (including any potentially
+ * instrumented code).
+ */
+static __always_inline void guest_context_exit_irqoff(void)
 {
 	context_tracking_guest_exit();
+}
 
+/*
+ * Stop accounting time towards a guest.
+ * Must be called after exiting guest context.
+ */
+static __always_inline void guest_timing_exit_irqoff(void)
+{
 	instrumentation_begin();
 	/* Flush the guest cputime we spent on the guest */
 	vtime_account_guest_exit();
 	instrumentation_end();
 }
 
+/*
+ * Deprecated. Architectures should move to enter_from_guest_mode() and
+ * guest_timing_enter_irqoff().
+ */
+static __always_inline void guest_exit_irqoff(void)
+{
+	guest_context_exit_irqoff();
+	guest_timing_exit_irqoff();
+}
+
 static inline void guest_exit(void)
 {
 	unsigned long flags;
@@ -407,6 +483,32 @@ static inline void guest_exit(void)
 	local_irq_restore(flags);
 }
 
+/**
+ * enter_from_guest_mode - Establish state when returning from guest mode
+ *
+ * This is analagous to enter_from_user_mode(), and ensures we perform the
+ * following in order:
+ *
+ * 1) Tell lockdep that interrupts are disabled
+ * 2) Invoke context tracking if enabled to reactivate RCU
+ * 3) Trace interrupts off state
+ *
+ * Invoked from architecture specific code as the first step after exiting a
+ * guest. Must be invoked with interrupts disabled and the caller must be
+ * non-instrumentable.
+ *
+ * This must be called before guest_timing_exit_irqoff().
+ */
+static __always_inline void enter_from_guest_mode(void)
+{
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	guest_context_exit_irqoff();
+
+	instrumentation_begin();
+	trace_hardirqs_off_finish();
+	instrumentation_end();
+}
+
 static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
 {
 	/*
-- 
2.30.2

