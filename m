Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCAE3CF286
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 05:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244919AbhGTCrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 22:47:40 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60864 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242706AbhGTCrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 22:47:22 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C65E19200B4; Tue, 20 Jul 2021 05:27:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BF5179200B3;
        Tue, 20 Jul 2021 05:27:59 +0200 (CEST)
Date:   Tue, 20 Jul 2021 05:27:59 +0200 (CEST)
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
Subject: [PATCH 3/6] x86/PCI: Add support for the Intel 82374EB/82374SB (ESC)
 PIRQ router
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107192023450.9461@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Intel 82374EB/82374SB EISA System Component (ESC) devices implement 
PCI interrupt steering with a PIRQ router[1] in the form of four PIRQ 
Route Control registers, available in the port I/O space accessible 
indirectly via the index/data register pair at 0x22/0x23, located at 
indices 0x60/0x61/0x62/0x63 for the PIRQ0/1/2/3# lines respectively.  

The semantics is the same as with the PIIX router, however it is not 
clear if BIOSes use register indices or line numbers as the cookie to 
identify PCI interrupts in their routing tables and therefore support 
either scheme.

Accesses to the port I/O space concerned here need to be unlocked by 
writing the value of 0x0f to the ESC ID Register at index 0x02 
beforehand[2].  Do so then and then lock access after use for safety. 

This locking could possibly interfere with accesses to the Intel MP spec 
IMCR register, implemented by the 82374SB variant of the ESC only as the 
PCI/APIC Control Register at index 0x70[3], for which leaving access to 
the configuration space concerned unlocked may have been a requirement 
for the BIOS to remain compliant with the MP spec.  However we only poke 
at the IMCR register if the APIC mode is used, in which case the PIRQ 
router is not, so this arrangement is not going to interfere with IMCR 
access code.

The ESC is implemented as a part of the combined southbridge also made 
of 82375EB/82375SB PCI-EISA Bridge (PCEB) and does itself appear in the 
PCI configuration space.  Use the PCEB's device identification then for
determining the presence of the ESC.

References:

[1] "82374EB/82374SB EISA System Component (ESC)", Intel Corporation, 
    Order Number: 290476-004, March 1996, Section 3.1.12 
    "PIRQ[0:3]#--PIRQ Route Control Registers", pp. 44-45

[2] same, Section 3.1.1 "ESCID--ESC ID Register", p. 36

[3] same, Section 3.1.17 "PAC--PCI/APIC Control Register", p. 47

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 arch/x86/pci/irq.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

linux-x86-pirq-router-esc.diff
Index: linux-macro-pirq/arch/x86/pci/irq.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/pci/irq.c
+++ linux-macro-pirq/arch/x86/pci/irq.c
@@ -359,6 +359,74 @@ static int pirq_ali_set(struct pci_dev *
 }
 
 /*
+ *	PIRQ routing for the 82374EB/82374SB EISA System Component (ESC)
+ *	ASIC used with the Intel 82420 and 82430 PCIsets.  The ESC is not
+ *	decoded in the PCI configuration space, so we identify it by the
+ *	accompanying 82375EB/82375SB PCI-EISA Bridge (PCEB) ASIC.
+ *
+ *	There are four PIRQ Route Control registers, available in the
+ *	port I/O space accessible indirectly via the index/data register
+ *	pair at 0x22/0x23, located at indices 0x60/0x61/0x62/0x63 for the
+ *	PIRQ0/1/2/3# lines respectively.  The semantics is the same as
+ *	with the PIIX router.
+ *
+ *	Accesses to the port I/O space concerned here need to be unlocked
+ *	by writing the value of 0x0f to the ESC ID Register at index 0x02
+ *	beforehand.  Any other value written to said register prevents
+ *	further accesses from reaching the register file, except for the
+ *	ESC ID Register being written with 0x0f again.
+ *
+ *	References:
+ *
+ *	"82374EB/82374SB EISA System Component (ESC)", Intel Corporation,
+ *	Order Number: 290476-004, March 1996
+ *
+ *	"82375EB/82375SB PCI-EISA Bridge (PCEB)", Intel Corporation, Order
+ *	Number: 290477-004, March 1996
+ */
+
+#define PC_CONF_I82374_ESC_ID			0x02u
+#define PC_CONF_I82374_PIRQ_ROUTE_CONTROL	0x60u
+
+#define PC_CONF_I82374_ESC_ID_KEY		0x0fu
+
+static int pirq_esc_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+{
+	unsigned long flags;
+	int reg;
+	u8 x;
+
+	reg = pirq;
+	if (reg >= 1 && reg <= 4)
+		reg += PC_CONF_I82374_PIRQ_ROUTE_CONTROL - 1;
+
+	raw_spin_lock_irqsave(&pc_conf_lock, flags);
+	pc_conf_set(PC_CONF_I82374_ESC_ID, PC_CONF_I82374_ESC_ID_KEY);
+	x = pc_conf_get(reg);
+	pc_conf_set(PC_CONF_I82374_ESC_ID, 0);
+	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
+	return (x < 16) ? x : 0;
+}
+
+static int pirq_esc_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+		       int irq)
+{
+	unsigned long flags;
+	int reg;
+
+	reg = pirq;
+	if (reg >= 1 && reg <= 4)
+		reg += PC_CONF_I82374_PIRQ_ROUTE_CONTROL - 1;
+
+	raw_spin_lock_irqsave(&pc_conf_lock, flags);
+	pc_conf_set(PC_CONF_I82374_ESC_ID, PC_CONF_I82374_ESC_ID_KEY);
+	pc_conf_set(reg, irq);
+	pc_conf_set(PC_CONF_I82374_ESC_ID, 0);
+	raw_spin_unlock_irqrestore(&pc_conf_lock, flags);
+	return 1;
+}
+
+/*
  * The Intel PIIX4 pirq rules are fairly simple: "pirq" is
  * just a pointer to the config space.
  */
@@ -768,6 +836,11 @@ static __init int intel_router_probe(str
 
 	switch (device) {
 		u8 rid;
+	case PCI_DEVICE_ID_INTEL_82375:
+		r->name = "PCEB/ESC";
+		r->get = pirq_esc_get;
+		r->set = pirq_esc_set;
+		return 1;
 	case PCI_DEVICE_ID_INTEL_82378:
 		pci_read_config_byte(router, PCI_REVISION_ID, &rid);
 		/* Tell 82378IB (rev < 3) and 82378ZB/82379AB apart.  */
