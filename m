Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB923CF297
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 05:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhGTCro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 22:47:44 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:60906 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242865AbhGTCr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 22:47:26 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 32C1C9200BC; Tue, 20 Jul 2021 05:28:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 2B64C9200BB;
        Tue, 20 Jul 2021 05:28:04 +0200 (CEST)
Date:   Tue, 20 Jul 2021 05:28:04 +0200 (CEST)
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
Subject: [PATCH 4/6] x86/PCI: Add support for the Intel 82426EX PIRQ router
In-Reply-To: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2107200213490.9461@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Intel 82426EX ISA Bridge (IB), a part of the Intel 82420EX PCIset, 
implements PCI interrupt steering with a PIRQ router in the form of two 
PIRQ Route Control registers, available in the PCI configuration space 
at locations 0x66 and 0x67 for the PIRQ0# and PIRQ1# lines respectively.

The semantics is the same as with the PIIX router, however it is not
clear if BIOSes use register indices or line numbers as the cookie to
identify PCI interrupts in their routing tables and therefore support
either scheme.

The IB is directly attached to the Intel 82425EX PCI System Controller 
(PSC) component of the chipset via a dedicated PSC/IB Link interface 
rather than the host bus or PCI.  Therefore it does not itself appear in 
the PCI configuration space even though it responds to configuration 
cycles addressing registers it implements.  Use 82425EX's identification 
then for determining the presence of the IB.

References:

[1] "82420EX PCIset Data Sheet, 82425EX PCI System Controller (PSC) and 
    82426EX ISA Bridge (IB)", Intel Corporation, Order Number: 
    290488-004, December 1995, Section 3.3.18 "PIRQ1RC/PIRQ0RC--PIRQ 
    Route Control Registers", p. 61

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 arch/x86/pci/irq.c      |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 
 2 files changed, 50 insertions(+)

linux-x86-pirq-router-ib.diff
Index: linux-macro-pirq/arch/x86/pci/irq.c
===================================================================
--- linux-macro-pirq.orig/arch/x86/pci/irq.c
+++ linux-macro-pirq/arch/x86/pci/irq.c
@@ -447,6 +447,50 @@ static int pirq_piix_set(struct pci_dev
 }
 
 /*
+ *	PIRQ routing for the 82426EX ISA Bridge (IB) ASIC used with the
+ *	Intel 82420EX PCIset.
+ *
+ *	There are only two PIRQ Route Control registers, available in the
+ *	combined 82425EX/82426EX PCI configuration space, at 0x66 and 0x67
+ *	for the PIRQ0# and PIRQ1# lines respectively.  The semantics is
+ *	the same as with the PIIX router.
+ *
+ *	References:
+ *
+ *	"82420EX PCIset Data Sheet, 82425EX PCI System Controller (PSC)
+ *	and 82426EX ISA Bridge (IB)", Intel Corporation, Order Number:
+ *	290488-004, December 1995
+ */
+
+#define PCI_I82426EX_PIRQ_ROUTE_CONTROL	0x66u
+
+static int pirq_ib_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+{
+	int reg;
+	u8 x;
+
+	reg = pirq;
+	if (reg >= 1 && reg <= 2)
+		reg += PCI_I82426EX_PIRQ_ROUTE_CONTROL - 1;
+
+	pci_read_config_byte(router, reg, &x);
+	return (x < 16) ? x : 0;
+}
+
+static int pirq_ib_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+		       int irq)
+{
+	int reg;
+
+	reg = pirq;
+	if (reg >= 1 && reg <= 2)
+		reg += PCI_I82426EX_PIRQ_ROUTE_CONTROL - 1;
+
+	pci_write_config_byte(router, reg, irq);
+	return 1;
+}
+
+/*
  * The VIA pirq rules are nibble-based, like ALI,
  * but without the ugly irq number munging.
  * However, PIRQD is in the upper instead of lower 4 bits.
@@ -892,6 +936,11 @@ static __init int intel_router_probe(str
 		r->get = pirq_piix_get;
 		r->set = pirq_piix_set;
 		return 1;
+	case PCI_DEVICE_ID_INTEL_82425:
+		r->name = "PSC/IB";
+		r->get = pirq_ib_get;
+		r->set = pirq_ib_set;
+		return 1;
 	}
 
 	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN && 
Index: linux-macro-pirq/include/linux/pci_ids.h
===================================================================
--- linux-macro-pirq.orig/include/linux/pci_ids.h
+++ linux-macro-pirq/include/linux/pci_ids.h
@@ -2644,6 +2644,7 @@
 #define PCI_DEVICE_ID_INTEL_82375	0x0482
 #define PCI_DEVICE_ID_INTEL_82424	0x0483
 #define PCI_DEVICE_ID_INTEL_82378	0x0484
+#define PCI_DEVICE_ID_INTEL_82425	0x0486
 #define PCI_DEVICE_ID_INTEL_MRST_SD0	0x0807
 #define PCI_DEVICE_ID_INTEL_MRST_SD1	0x0808
 #define PCI_DEVICE_ID_INTEL_MFD_SD	0x0820
