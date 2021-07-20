Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE203CF294
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 05:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346640AbhGTCrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 22:47:52 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60826 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236705AbhGTCrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 22:47:15 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 67F0892009D; Tue, 20 Jul 2021 05:27:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 609F192009B;
        Tue, 20 Jul 2021 05:27:49 +0200 (CEST)
Date:   Tue, 20 Jul 2021 05:27:49 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nikolai Zhubr <zhubr.2@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
cc:     x86@kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86: Add support for 0x22/0x23 port I/O configuration
 space
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107182353140.9461@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define macros and accessors for the configuration space addressed 
indirectly with an index register and a data register at the port I/O 
locations of 0x22 and 0x23 respectively.

This space is defined by the Intel MultiProcessor Specification for the 
IMCR register used to switch between the PIC and the APIC mode[1], by 
Cyrix processors for their configuration[2][3], and also some chipsets.

Given the lack of atomicity with the indirect addressing a spinlock is 
required to protect accesses, although for Cyrix processors it is enough 
if accesses are executed with interrupts locally disabled, because the 
registers are local to the accessing CPU, and IMCR is only ever poked at 
by the BSP and early enough for interrupts not to have been configured 
yet.  Therefore existing code does not have to change or use the new 
spinlock and neither it does.

Put the spinlock in a library file then, so that it does not get pulled 
unnecessarily for configurations that do not refer it.

Convert Cyrix accessors to wrappers so as to retain the brevity and 
clarity of the `getCx86' and `setCx86' calls.

References:

[1] "MultiProcessor Specification", Version 1.4, Intel Corporation, 
    Order Number: 242016-006, May 1997, Section 3.6.2.1 "PIC Mode", pp. 
    3-7, 3-8

[2] "5x86 Microprocessor", Cyrix Corporation, Order Number: 94192-00, 
    July 1995, Section 2.3.2.4 "Configuration Registers", p. 2-23

[3] "6x86 Processor", Cyrix Corporation, Order Number: 94175-01, March 
    1996, Section 2.4.4 "6x86 Configuration Registers", p. 2-23

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
Verified with `objdump' not to change arch/x86/kernel/apic/apic.o or 
arch/x86/kernel/cpu/cyrix.o code produced.
---
 arch/x86/include/asm/pc-conf-reg.h     |   33 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor-cyrix.h |    8 ++++----
 arch/x86/kernel/apic/apic.c            |    9 +++------
 arch/x86/lib/Makefile                  |    1 +
 arch/x86/lib/pc-conf-reg.c             |   13 +++++++++++++
 5 files changed, 54 insertions(+), 10 deletions(-)

linux-x86-pc-conf-reg.diff
Index: linux-macro-pirq/arch/x86/include/asm/pc-conf-reg.h
===================================================================
--- /dev/null
+++ linux-macro-pirq/arch/x86/include/asm/pc-conf-reg.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Support for the configuration register space at port I/O locations
+ * 0x22 and 0x23 variously used by PC architectures, e.g. the MP Spec,
+ * Cyrix CPUs, numerous chipsets.
+ */
+#ifndef _ASM_X86_PC_CONF_REG_H
+#define _ASM_X86_PC_CONF_REG_H
+
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#define PC_CONF_INDEX		0x22
+#define PC_CONF_DATA		0x23
+
+#define PC_CONF_MPS_IMCR	0x70
+
+extern raw_spinlock_t pc_conf_lock;
+
+static inline u8 pc_conf_get(u8 reg)
+{
+	outb(reg, PC_CONF_INDEX);
+	return inb(PC_CONF_DATA);
+}
+
+static inline void pc_conf_set(u8 reg, u8 data)
+{
+	outb(reg, PC_CONF_INDEX);
+	outb(data, PC_CONF_DATA);
+}
+
+#endif /* _ASM_X86_PC_CONF_REG_H */
Index: linux-macro-pirq/arch/x86/include/asm/processor-cyrix.h
===================================================================
--- linux-macro-pirq.orig/arch/x86/include/asm/processor-cyrix.h
+++ linux-macro-pirq/arch/x86/include/asm/processor-cyrix.h
@@ -5,14 +5,14 @@
  * Access order is always 0x22 (=offset), 0x23 (=value)
  */
 
+#include <asm/pc-conf-reg.h>
+
 static inline u8 getCx86(u8 reg)
 {
-	outb(reg, 0x22);
-	return inb(0x23);
+	return pc_conf_get(reg);
 }
 
 static inline void setCx86(u8 reg, u8 data)
 {
-	outb(reg, 0x22);
-	outb(data, 0x23);
+	pc_conf_set(reg, data);
 }
Index: linux-macro-pirq/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/apic/apic.c
+++ linux-macro-pirq/arch/x86/kernel/apic/apic.c
@@ -38,6 +38,7 @@
 
 #include <asm/trace/irq_vectors.h>
 #include <asm/irq_remapping.h>
+#include <asm/pc-conf-reg.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <linux/atomic.h>
@@ -132,18 +133,14 @@ static int enabled_via_apicbase __ro_aft
  */
 static inline void imcr_pic_to_apic(void)
 {
-	/* select IMCR register */
-	outb(0x70, 0x22);
 	/* NMI and 8259 INTR go through APIC */
-	outb(0x01, 0x23);
+	pc_conf_set(PC_CONF_MPS_IMCR, 0x01);
 }
 
 static inline void imcr_apic_to_pic(void)
 {
-	/* select IMCR register */
-	outb(0x70, 0x22);
 	/* NMI and 8259 INTR go directly to BSP */
-	outb(0x00, 0x23);
+	pc_conf_set(PC_CONF_MPS_IMCR, 0x00);
 }
 #endif
 
Index: linux-macro-pirq/arch/x86/lib/Makefile
===================================================================
--- linux-macro-pirq.orig/arch/x86/lib/Makefile
+++ linux-macro-pirq/arch/x86/lib/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp
 lib-y := delay.o misc.o cmdline.o cpu.o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-y += pc-conf-reg.o
 lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc.o copy_mc_64.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
Index: linux-macro-pirq/arch/x86/lib/pc-conf-reg.c
===================================================================
--- /dev/null
+++ linux-macro-pirq/arch/x86/lib/pc-conf-reg.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Support for the configuration register space at port I/O locations
+ * 0x22 and 0x23 variously used by PC architectures, e.g. the MP Spec,
+ * Cyrix CPUs, numerous chipsets.  As the space is indirectly addressed
+ * it may have to be protected with a spinlock, depending on the context.
+ */
+
+#include <linux/spinlock.h>
+
+#include <asm/pc-conf-reg.h>
+
+DEFINE_RAW_SPINLOCK(pc_conf_lock);
