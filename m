Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BCE3CF298
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 05:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346803AbhGTCsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 22:48:35 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60964 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbhGTCri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 22:47:38 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 611F89200C1; Tue, 20 Jul 2021 05:28:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 5AF8A9200C0;
        Tue, 20 Jul 2021 05:28:15 +0200 (CEST)
Date:   Tue, 20 Jul 2021 05:28:15 +0200 (CEST)
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
Subject: [PATCH 6/6] x86: Fix typo s/ECLR/ELCR/ for the PIC register
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107200251080.9461@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The proper spelling for the acronym referring to the Edge/Level Control 
Register is ELCR rather than ECLR.  Adjust references accordingly.  No 
functional change.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 arch/x86/kernel/acpi/boot.c |    6 +++---
 arch/x86/kvm/i8259.c        |   20 ++++++++++----------
 arch/x86/kvm/irq.h          |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

linux-x86-pic-elcr-typo.diff
Index: linux-macro-pirq/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kernel/acpi/boot.c
+++ linux-macro-pirq/arch/x86/kernel/acpi/boot.c
@@ -558,10 +558,10 @@ acpi_parse_nmi_src(union acpi_subtable_h
  * If a PIC-mode SCI is not recognized or gives spurious IRQ7's
  * it may require Edge Trigger -- use "acpi_sci=edge"
  *
- * Port 0x4d0-4d1 are ECLR1 and ECLR2, the Edge/Level Control Registers
+ * Port 0x4d0-4d1 are ELCR1 and ELCR2, the Edge/Level Control Registers
  * for the 8259 PIC.  bit[n] = 1 means irq[n] is Level, otherwise Edge.
- * ECLR1 is IRQs 0-7 (IRQ 0, 1, 2 must be 0)
- * ECLR2 is IRQs 8-15 (IRQ 8, 13 must be 0)
+ * ELCR1 is IRQs 0-7 (IRQ 0, 1, 2 must be 0)
+ * ELCR2 is IRQs 8-15 (IRQ 8, 13 must be 0)
  */
 
 void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
Index: linux-macro-pirq/arch/x86/kvm/i8259.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/kvm/i8259.c
+++ linux-macro-pirq/arch/x86/kvm/i8259.c
@@ -541,17 +541,17 @@ static int picdev_slave_read(struct kvm_
 			    addr, len, val);
 }
 
-static int picdev_eclr_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int picdev_elcr_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			     gpa_t addr, int len, const void *val)
 {
-	return picdev_write(container_of(dev, struct kvm_pic, dev_eclr),
+	return picdev_write(container_of(dev, struct kvm_pic, dev_elcr),
 			    addr, len, val);
 }
 
-static int picdev_eclr_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+static int picdev_elcr_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 			    gpa_t addr, int len, void *val)
 {
-	return picdev_read(container_of(dev, struct kvm_pic, dev_eclr),
+	return picdev_read(container_of(dev, struct kvm_pic, dev_elcr),
 			    addr, len, val);
 }
 
@@ -577,9 +577,9 @@ static const struct kvm_io_device_ops pi
 	.write    = picdev_slave_write,
 };
 
-static const struct kvm_io_device_ops picdev_eclr_ops = {
-	.read     = picdev_eclr_read,
-	.write    = picdev_eclr_write,
+static const struct kvm_io_device_ops picdev_elcr_ops = {
+	.read     = picdev_elcr_read,
+	.write    = picdev_elcr_write,
 };
 
 int kvm_pic_init(struct kvm *kvm)
@@ -602,7 +602,7 @@ int kvm_pic_init(struct kvm *kvm)
 	 */
 	kvm_iodevice_init(&s->dev_master, &picdev_master_ops);
 	kvm_iodevice_init(&s->dev_slave, &picdev_slave_ops);
-	kvm_iodevice_init(&s->dev_eclr, &picdev_eclr_ops);
+	kvm_iodevice_init(&s->dev_elcr, &picdev_elcr_ops);
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, 0x20, 2,
 				      &s->dev_master);
@@ -613,7 +613,7 @@ int kvm_pic_init(struct kvm *kvm)
 	if (ret < 0)
 		goto fail_unreg_2;
 
-	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, 0x4d0, 2, &s->dev_eclr);
+	ret = kvm_io_bus_register_dev(kvm, KVM_PIO_BUS, 0x4d0, 2, &s->dev_elcr);
 	if (ret < 0)
 		goto fail_unreg_1;
 
@@ -647,7 +647,7 @@ void kvm_pic_destroy(struct kvm *kvm)
 	mutex_lock(&kvm->slots_lock);
 	kvm_io_bus_unregister_dev(vpic->kvm, KVM_PIO_BUS, &vpic->dev_master);
 	kvm_io_bus_unregister_dev(vpic->kvm, KVM_PIO_BUS, &vpic->dev_slave);
-	kvm_io_bus_unregister_dev(vpic->kvm, KVM_PIO_BUS, &vpic->dev_eclr);
+	kvm_io_bus_unregister_dev(vpic->kvm, KVM_PIO_BUS, &vpic->dev_elcr);
 	mutex_unlock(&kvm->slots_lock);
 
 	kvm->arch.vpic = NULL;
Index: linux-macro-pirq/arch/x86/kvm/irq.h
===================================================================
--- linux-macro-pirq.orig/arch/x86/kvm/irq.h
+++ linux-macro-pirq/arch/x86/kvm/irq.h
@@ -55,7 +55,7 @@ struct kvm_pic {
 	int output;		/* intr from master PIC */
 	struct kvm_io_device dev_master;
 	struct kvm_io_device dev_slave;
-	struct kvm_io_device dev_eclr;
+	struct kvm_io_device dev_elcr;
 	void (*ack_notifier)(void *opaque, int irq);
 	unsigned long irq_states[PIC_NUM_PINS];
 };
