Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716923CF296
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 05:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346618AbhGTCsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 22:48:06 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60940 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243220AbhGTCrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 22:47:37 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 1FAF89200BF; Tue, 20 Jul 2021 05:28:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 1A3049200BB;
        Tue, 20 Jul 2021 05:28:09 +0200 (CEST)
Date:   Tue, 20 Jul 2021 05:28:09 +0200 (CEST)
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
Subject: [PATCH 5/6] x86: Avoid magic number with ELCR register accesses
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107200237300.9461@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define PIC_ELCR1 and PIC_ELCR2 macros for accesses to the ELCR registers 
implemented by many chipsets in their embedded 8259A PIC cores, avoiding 
magic numbers that are difficult to handle, and complementing the macros 
we already have for registers originally defined with discrete 8259A PIC 
implementations.  No functional change.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
This deliberately doesn't touch KVM, which refrains from using macros for 
any PIC accesses.
---
 arch/x86/include/asm/i8259.h   |    2 ++
 arch/x86/kernel/acpi/boot.c    |    6 +++---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 arch/x86/kernel/apic/vector.c  |    2 +-
 arch/x86/kernel/i8259.c        |    8 ++++----
 arch/x86/kernel/mpparse.c      |    3 ++-
 arch/x86/pci/irq.c             |    3 ++-
 7 files changed, 15 insertions(+), 11 deletions(-)

linux-x86-pic-elcr.diff
Index: linux-macro-pirq/arch/x86/include/asm/i8259.h
===================================================================
--- linux-macro-pirq.orig/arch/x86/include/asm/i8259.h
+++ linux-macro-pirq/arch/x86/include/asm/i8259.h
@@ -19,6 +19,8 @@ extern unsigned int cached_irq_mask;
 #define PIC_MASTER_OCW3		PIC_MASTER_ISR
 #define PIC_SLAVE_CMD		0xa0
 #define PIC_SLAVE_IMR		0xa1
+#define PIC_ELCR1		0x4d0
+#define PIC_ELCR2		0x4d1
 
 /* i8259A PIC related value */
 #define PIC_CASCADE_IR		2
Index: linux-macro-pirq/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/acpi/boot.c
+++ linux-macro-pirq/arch/x86/kernel/acpi/boot.c
@@ -570,7 +570,7 @@ void __init acpi_pic_sci_set_trigger(uns
 	unsigned int old, new;
 
 	/* Real old ELCR mask */
-	old = inb(0x4d0) | (inb(0x4d1) << 8);
+	old = inb(PIC_ELCR1) | (inb(PIC_ELCR2) << 8);
 
 	/*
 	 * If we use ACPI to set PCI IRQs, then we should clear ELCR
@@ -596,8 +596,8 @@ void __init acpi_pic_sci_set_trigger(uns
 		return;
 
 	pr_warn("setting ELCR to %04x (from %04x)\n", new, old);
-	outb(new, 0x4d0);
-	outb(new >> 8, 0x4d1);
+	outb(new, PIC_ELCR1);
+	outb(new >> 8, PIC_ELCR2);
 }
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
Index: linux-macro-pirq/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-macro-pirq/arch/x86/kernel/apic/io_apic.c
@@ -764,7 +764,7 @@ static bool irq_active_low(int idx)
 static bool EISA_ELCR(unsigned int irq)
 {
 	if (irq < nr_legacy_irqs()) {
-		unsigned int port = 0x4d0 + (irq >> 3);
+		unsigned int port = PIC_ELCR1 + (irq >> 3);
 		return (inb(port) >> (irq & 7)) & 1;
 	}
 	apic_printk(APIC_VERBOSE, KERN_INFO
Index: linux-macro-pirq/arch/x86/kernel/apic/vector.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/apic/vector.c
+++ linux-macro-pirq/arch/x86/kernel/apic/vector.c
@@ -1299,7 +1299,7 @@ static void __init print_PIC(void)
 
 	pr_debug("... PIC  ISR: %04x\n", v);
 
-	v = inb(0x4d1) << 8 | inb(0x4d0);
+	v = inb(PIC_ELCR2) << 8 | inb(PIC_ELCR1);
 	pr_debug("... PIC ELCR: %04x\n", v);
 }
 
Index: linux-macro-pirq/arch/x86/kernel/i8259.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/i8259.c
+++ linux-macro-pirq/arch/x86/kernel/i8259.c
@@ -235,15 +235,15 @@ static char irq_trigger[2];
  */
 static void restore_ELCR(char *trigger)
 {
-	outb(trigger[0], 0x4d0);
-	outb(trigger[1], 0x4d1);
+	outb(trigger[0], PIC_ELCR1);
+	outb(trigger[1], PIC_ELCR2);
 }
 
 static void save_ELCR(char *trigger)
 {
 	/* IRQ 0,1,2,8,13 are marked as reserved */
-	trigger[0] = inb(0x4d0) & 0xF8;
-	trigger[1] = inb(0x4d1) & 0xDE;
+	trigger[0] = inb(PIC_ELCR1) & 0xF8;
+	trigger[1] = inb(PIC_ELCR2) & 0xDE;
 }
 
 static void i8259A_resume(void)
Index: linux-macro-pirq/arch/x86/kernel/mpparse.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/mpparse.c
+++ linux-macro-pirq/arch/x86/kernel/mpparse.c
@@ -19,6 +19,7 @@
 #include <linux/smp.h>
 #include <linux/pci.h>
 
+#include <asm/i8259.h>
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
 #include <asm/irqdomain.h>
@@ -251,7 +252,7 @@ static int __init ELCR_trigger(unsigned
 {
 	unsigned int port;
 
-	port = 0x4d0 + (irq >> 3);
+	port = PIC_ELCR1 + (irq >> 3);
 	return (inb(port) >> (irq & 7)) & 1;
 }
 
Index: linux-macro-pirq/arch/x86/pci/irq.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/pci/irq.c
+++ linux-macro-pirq/arch/x86/pci/irq.c
@@ -18,6 +18,7 @@
 #include <linux/irq.h>
 #include <linux/acpi.h>
 
+#include <asm/i8259.h>
 #include <asm/pc-conf-reg.h>
 #include <asm/pci_x86.h>
 
@@ -159,7 +160,7 @@ static void __init pirq_peer_trick(void)
 void elcr_set_level_irq(unsigned int irq)
 {
 	unsigned char mask = 1 << (irq & 7);
-	unsigned int port = 0x4d0 + (irq >> 3);
+	unsigned int port = PIC_ELCR1 + (irq >> 3);
 	unsigned char val;
 	static u16 elcr_irq_mask;
 
