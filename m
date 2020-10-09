Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2992288735
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387827AbgJIKqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387788AbgJIKq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:46:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25058C0613D6;
        Fri,  9 Oct 2020 03:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=k8rruyYtHOtLX+T0n4yk5E6HXM140fcZiSnIws1lqdU=; b=mqAp2hgew7NDqlipuzrwMXHsIF
        Kp/WOkDEEVdHZ52DN/Lu5fyi60Fae8oCrcvtl7NvX2jd+ipkQU1Y7gw899ZwVSKLIAVDzmcG03mgj
        etHhilhMVBbGinNorZG5McFqAs6TcehkM/HJsBnakzt6LbiB4Vo73Dk0YcECpxXMkSCBQaaiVZ2jG
        zIsUp+ofjfkN3B2EhgV33k08bnHgNvJzq8hzpR90ZfR+Wvd9KJp3fm39RmXXzyaBVlUDQVE5egmuv
        tcrLOf0oTz/Xvu0hrO0NI6kEFMRVoQP8zAOh7rtmdXmz72DUIoUQxJ5bvL2jS2HZBBE3dy1Hll83n
        2OmATyrw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQpup-0000ju-KG; Fri, 09 Oct 2020 10:46:23 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kQpup-005W4T-6w; Fri, 09 Oct 2020 11:46:23 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent irqchip's MSI message
Date:   Fri,  9 Oct 2020 11:46:16 +0100
Message-Id: <20201009104616.1314746-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009104616.1314746-1-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201009104616.1314746-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The I/OAPIC generates an MSI cycle with address/data bits taken from its
Redirection Table Entry in some combination which used to make sense,
but now is just a bunch of bits which get passed through in some
seemingly arbitrary order.

Instead of making IRQ remapping drivers directly frob the I/OAPIC RTE,
let them just do their job and generate an MSI message. The bit
swizzling to turn that MSI message into the IOAPIC's RTE is the same in
all cases, since it's a function of the I/OAPIC hardware. The IRQ
remappers have no real need to get involved with that.

The only slight caveat is that the I/OAPIC is interpreting some of
those fields too, and it does want the 'vector' field to be unique
to make EOI work. The AMD IOMMU happens to put its IRTE index in the
bits that the I/OAPIC thinks are the vector field, and accommodates
this requirement by reserving the first 32 indices for the I/OAPIC.
The Intel IOMMU doesn't actually use the bits that the I/OAPIC thinks
are the vector field, so it fills in the 'pin' value there instead.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/hw_irq.h       | 11 +++---
 arch/x86/include/asm/msidef.h       |  2 ++
 arch/x86/kernel/apic/io_apic.c      | 55 ++++++++++++++++++-----------
 drivers/iommu/amd/iommu.c           | 14 --------
 drivers/iommu/hyperv-iommu.c        | 31 ----------------
 drivers/iommu/intel/irq_remapping.c | 19 +++-------
 6 files changed, 46 insertions(+), 86 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a4aeeaace040..aabd8f1b6bb0 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -45,12 +45,11 @@ enum irq_alloc_type {
 };
 
 struct ioapic_alloc_info {
-	int				pin;
-	int				node;
-	u32				trigger : 1;
-	u32				polarity : 1;
-	u32				valid : 1;
-	struct IO_APIC_route_entry	*entry;
+	int		pin;
+	int		node;
+	u32		trigger : 1;
+	u32		polarity : 1;
+	u32		valid : 1;
 };
 
 struct uv_alloc_info {
diff --git a/arch/x86/include/asm/msidef.h b/arch/x86/include/asm/msidef.h
index ee2f8ccc32d0..37c3d2d492c9 100644
--- a/arch/x86/include/asm/msidef.h
+++ b/arch/x86/include/asm/msidef.h
@@ -18,6 +18,7 @@
 #define MSI_DATA_DELIVERY_MODE_SHIFT	8
 #define  MSI_DATA_DELIVERY_FIXED	(0 << MSI_DATA_DELIVERY_MODE_SHIFT)
 #define  MSI_DATA_DELIVERY_LOWPRI	(1 << MSI_DATA_DELIVERY_MODE_SHIFT)
+#define  MSI_DATA_DELIVERY_MODE_MASK	(3 << MSI_DATA_DELIVERY_MODE_SHIFT)
 
 #define MSI_DATA_LEVEL_SHIFT		14
 #define	 MSI_DATA_LEVEL_DEASSERT	(0 << MSI_DATA_LEVEL_SHIFT)
@@ -37,6 +38,7 @@
 #define MSI_ADDR_DEST_MODE_SHIFT	2
 #define  MSI_ADDR_DEST_MODE_PHYSICAL	(0 << MSI_ADDR_DEST_MODE_SHIFT)
 #define	 MSI_ADDR_DEST_MODE_LOGICAL	(1 << MSI_ADDR_DEST_MODE_SHIFT)
+#define  MSI_ADDR_DEST_MODE_MASK	(1 << MSI_DATA_DELIVERY_MODE_SHIFT)
 
 #define MSI_ADDR_REDIRECTION_SHIFT	3
 #define  MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 54f6a029b1d1..ca2da19d5c55 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -48,6 +48,7 @@
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
 #include <linux/memblock.h>
+#include <linux/msi.h>
 
 #include <asm/irqdomain.h>
 #include <asm/io.h>
@@ -63,6 +64,7 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hw_irq.h>
+#include <asm/msidef.h>
 
 #include <asm/apic.h>
 
@@ -1851,22 +1853,36 @@ static void ioapic_ir_ack_level(struct irq_data *irq_data)
 	eoi_ioapic_pin(data->entry.vector, data);
 }
 
+static void mp_swizzle_msi_dest_bits(struct irq_data *irq_data, void *_entry)
+{
+	struct msi_msg msg;
+	u32 *entry = _entry;
+
+	irq_chip_compose_msi_msg(irq_data, &msg);
+
+	/*
+	 * They're in a bit of a random order for historical reasons, but
+	 * the IO/APIC is just a device for turning interrupt lines into
+	 * MSIs, and various bits of the MSI addr/data are just swizzled
+	 * into/from the bits of Redirection Table Entry.
+	 */
+	entry[0] &= 0xfffff000;
+	entry[0] |= (msg.data & (MSI_DATA_DELIVERY_MODE_MASK |
+				 MSI_DATA_VECTOR_MASK));
+	entry[0] |= (msg.address_lo & MSI_ADDR_DEST_MODE_MASK) << 9;
+
+	entry[1] &= 0xffff;
+	entry[1] |= (msg.address_lo & MSI_ADDR_DEST_ID_MASK) << 12;
+}
+
+
 static void ioapic_configure_entry(struct irq_data *irqd)
 {
 	struct mp_chip_data *mpd = irqd->chip_data;
-	struct irq_cfg *cfg = irqd_cfg(irqd);
 	struct irq_pin_list *entry;
 
-	/*
-	 * Only update when the parent is the vector domain, don't touch it
-	 * if the parent is the remapping domain. Check the installed
-	 * ioapic chip to verify that.
-	 */
-	if (irqd->chip == &ioapic_chip) {
-		mpd->entry.dest = cfg->dest_apicid & 0xff;
-		mpd->entry.virt_ext_dest = cfg->dest_apicid >> 8;
-		mpd->entry.vector = cfg->vector;
-	}
+	mp_swizzle_msi_dest_bits(irqd, &mpd->entry);
+
 	for_each_irq_pin(entry, mpd->irq_2_pin)
 		__ioapic_write_entry(entry->apic, entry->pin, mpd->entry);
 }
@@ -2949,15 +2965,14 @@ static void mp_irqdomain_get_attr(u32 gsi, struct mp_chip_data *data,
 	}
 }
 
-static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
-			   struct IO_APIC_route_entry *entry)
+static void mp_setup_entry(struct irq_data *irq_data, struct mp_chip_data *data)
 {
+	struct IO_APIC_route_entry *entry = &data->entry;
+
 	memset(entry, 0, sizeof(*entry));
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode     = apic->irq_dest_mode;
-	entry->dest	     = cfg->dest_apicid & 0xff;
-	entry->virt_ext_dest = cfg->dest_apicid >> 8;
-	entry->vector	     = cfg->vector;
+
+	mp_swizzle_msi_dest_bits(irq_data, entry);
+
 	entry->trigger	     = data->trigger;
 	entry->polarity	     = data->polarity;
 	/*
@@ -2995,7 +3010,6 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	if (!data)
 		return -ENOMEM;
 
-	info->ioapic.entry = &data->entry;
 	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
 	if (ret < 0) {
 		kfree(data);
@@ -3013,8 +3027,7 @@ int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	add_pin_to_irq_node(data, ioapic_alloc_attr_node(info), ioapic, pin);
 
 	local_irq_save(flags);
-	if (info->ioapic.entry)
-		mp_setup_entry(cfg, data, info->ioapic.entry);
+	mp_setup_entry(irq_data, data);
 	mp_register_handler(virq, data->trigger);
 	if (virq < nr_legacy_irqs())
 		legacy_pic->mask(virq);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index ef64e01f66d7..13d0a8f42d56 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3597,7 +3597,6 @@ static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 {
 	struct irq_2_irte *irte_info = &data->irq_2_irte;
 	struct msi_msg *msg = &data->msi_entry;
-	struct IO_APIC_route_entry *entry;
 	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 
 	if (!iommu)
@@ -3611,19 +3610,6 @@ static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC:
-		/* Setup IOAPIC entry */
-		entry = info->ioapic.entry;
-		info->ioapic.entry = NULL;
-		memset(entry, 0, sizeof(*entry));
-		entry->vector        = index;
-		entry->mask          = 0;
-		entry->trigger       = info->ioapic.trigger;
-		entry->polarity      = info->ioapic.polarity;
-		/* Mask level triggered irqs. */
-		if (info->ioapic.trigger)
-			entry->mask = 1;
-		break;
-
 	case X86_IRQ_ALLOC_TYPE_HPET:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e09e2d734c57..37dd485a5640 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -40,7 +40,6 @@ static int hyperv_ir_set_affinity(struct irq_data *data,
 {
 	struct irq_data *parent = data->parent_data;
 	struct irq_cfg *cfg = irqd_cfg(data);
-	struct IO_APIC_route_entry *entry;
 	int ret;
 
 	/* Return error If new irq affinity is out of ioapic_max_cpumask. */
@@ -51,9 +50,6 @@ static int hyperv_ir_set_affinity(struct irq_data *data,
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
 
-	entry = data->chip_data;
-	entry->dest = cfg->dest_apicid;
-	entry->vector = cfg->vector;
 	send_cleanup_vector(cfg);
 
 	return 0;
@@ -89,20 +85,6 @@ static int hyperv_irq_remapping_alloc(struct irq_domain *domain,
 
 	irq_data->chip = &hyperv_ir_chip;
 
-	/*
-	 * If there is interrupt remapping function of IOMMU, setting irq
-	 * affinity only needs to change IRTE of IOMMU. But Hyper-V doesn't
-	 * support interrupt remapping function, setting irq affinity of IO-APIC
-	 * interrupts still needs to change IO-APIC registers. But ioapic_
-	 * configure_entry() will ignore value of cfg->vector and cfg->
-	 * dest_apicid when IO-APIC's parent irq domain is not the vector
-	 * domain.(See ioapic_configure_entry()) In order to setting vector
-	 * and dest_apicid to IO-APIC register, IO-APIC entry pointer is saved
-	 * in the chip_data and hyperv_irq_remapping_activate()/hyperv_ir_set_
-	 * affinity() set vector and dest_apicid directly into IO-APIC entry.
-	 */
-	irq_data->chip_data = info->ioapic.entry;
-
 	/*
 	 * Hypver-V IO APIC irq affinity should be in the scope of
 	 * ioapic_max_cpumask because no irq remapping support.
@@ -119,22 +101,9 @@ static void hyperv_irq_remapping_free(struct irq_domain *domain,
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 }
 
-static int hyperv_irq_remapping_activate(struct irq_domain *domain,
-			  struct irq_data *irq_data, bool reserve)
-{
-	struct irq_cfg *cfg = irqd_cfg(irq_data);
-	struct IO_APIC_route_entry *entry = irq_data->chip_data;
-
-	entry->dest = cfg->dest_apicid;
-	entry->vector = cfg->vector;
-
-	return 0;
-}
-
 static const struct irq_domain_ops hyperv_ir_domain_ops = {
 	.alloc = hyperv_irq_remapping_alloc,
 	.free = hyperv_irq_remapping_free,
-	.activate = hyperv_irq_remapping_activate,
 };
 
 static int __init hyperv_prepare_irq_remapping(void)
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 0cfce1d3b7bb..511dfb4884bc 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1265,7 +1265,6 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 					     struct irq_alloc_info *info,
 					     int index, int sub_handle)
 {
-	struct IR_IO_APIC_route_entry *entry;
 	struct irte *irte = &data->irte_entry;
 	struct msi_msg *msg = &data->msi_entry;
 
@@ -1281,23 +1280,15 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 			irte->avail, irte->vector, irte->dest_id,
 			irte->sid, irte->sq, irte->svt);
 
-		entry = (struct IR_IO_APIC_route_entry *)info->ioapic.entry;
-		info->ioapic.entry = NULL;
-		memset(entry, 0, sizeof(*entry));
-		entry->index2	= (index >> 15) & 0x1;
-		entry->zero	= 0;
-		entry->format	= 1;
-		entry->index	= (index & 0x7fff);
 		/*
 		 * IO-APIC RTE will be configured with virtual vector.
 		 * irq handler will do the explicit EOI to the io-apic.
 		 */
-		entry->vector	= info->ioapic.pin;
-		entry->mask	= 0;			/* enable IRQ */
-		entry->trigger	= info->ioapic.trigger;
-		entry->polarity	= info->ioapic.polarity;
-		if (info->ioapic.trigger)
-			entry->mask = 1; /* Mask level triggered irqs. */
+		msg->data = info->ioapic.pin;
+		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_INDEX1(index) |
+				  MSI_ADDR_IR_INDEX2(index);
 		break;
 
 	case X86_IRQ_ALLOC_TYPE_HPET:
-- 
2.26.2

