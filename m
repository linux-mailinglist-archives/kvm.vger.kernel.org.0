Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ED32879B6
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 18:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgJHQIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgJHQIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 12:08:17 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBD7C061755;
        Thu,  8 Oct 2020 09:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZSZmVlZ+jsFH+mIdkl0Nv5H7r6C6nirarL3mMgb3C1I=; b=KrqtN8pezAXhwS7j49cNMETHxV
        tNx/oOf01hNzOfHxkqNUsk81I0zhQIPNVJ9k5/zwncJzekUaKWkQDyCVbVNaEFAUSDrIbtKqWjF9T
        fA8g/5+uIbcwX+WEDm0gwy/crMZVvg4VKFOMov15QIwAoI9qpaIptvrKbDMhC7VGlVxHz4+QBwAZs
        /51Ps8AzuDeGGL4MdHeWa7Nl2h+Zelrd7P8e6MqqwFLJpk7xAJQNF9d+hpdk7LCqojJ5PFTUfqhz2
        ew1uOeeYbjI549dyUGeqQhKMjSOA9Za2PV9StJl+qdZ3Nd/A6PWeRCBKIe+QX8+DHHjuX05HiMOvO
        Cca1z5XQ==;
Received: from [54.239.6.187] (helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQYSe-0006IH-So; Thu, 08 Oct 2020 16:08:09 +0000
Message-ID: <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 08 Oct 2020 17:08:06 +0100
In-Reply-To: <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
         <20201007122046.1113577-1-dwmw2@infradead.org>
         <20201007122046.1113577-5-dwmw2@infradead.org>
         <87blhcx6qz.fsf@nanos.tec.linutronix.de>
         <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-9Rz78B0mms1lhSEat8uw"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-9Rz78B0mms1lhSEat8uw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-10-08 at 13:55 +0100, David Woodhouse wrote:
>=20
> In fact I'm really tempted to make Linux's io_apic.c just use
> irq_chip_compose_msi_msg() and swizzle the bits out of the message
> identically for IR and non-IR alike (modulo the pin hack), and delete
> the IR_IO_APIC_route_entry struct completely.=20
>=20
> That also completely removes the ext_dest_id trick from visibility in
> io_apic.c. And might avoid further confusion.

That looks a bit like this, FWIW. Turns out it doesn't *entirely*
remove the ext_dest_id trick from io_apic.c because it does still need
to put together an entry manually for the ExtINT hackery and for
restoring boot mode. But it does remove a lot of incestuous ioapic
hackery from IOMMU drivers, and deletes more code than it adds.

It has the additional effect of enabling the WARN_ON for unreachable
APIC IDs in __irq_msi_compose_msg(), for IOAPIC interrupts too.

(We'd want the x86_vector_domain to actually have an MSI compose
function in the !CONFIG_PCI_MSI case if we did this, of course.)

=46rom 2fbc79588d4677ee1cc9df661162fcf1a7da57f0 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Thu, 8 Oct 2020 15:44:42 +0100
Subject: [PATCH 6/5] x86/ioapic: Generate RTE directly from parent irqchip'=
s MSI
 message

The IOAPIC generates an MSI cycle with address/data bits taken from its
Redirection Table Entry in some combination which used to make sense,
but now is just a bunch of bits which get passed through in some
seemingly arbitrary order.

Instead of making IRQ remapping drivers directly frob the IOAPIC RTE,
let them just do their job and generate an MSI message. The bit
swizzling to turn that MSI message into the IOAPIC's RTE is the same in
all cases, since it's a function of the IOAPIC hardware. The IRQ
remappers have no real need to get involved with that.

The only slight caveat is that the IOAPIC is interpreting some of
those fields too, and it does want the 'vector' field to be unique
to make EOI work. The AMD IOMMU happens to put its IRTE index in the
bits that the IOAPIC thinks are the vector field, and accommodates
this requirement by reserving the first 32 indices for the IOAPIC.
The Intel IOMMU doesn't actually use the bits that the IOAPIC thinks
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
=20
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
=20
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
=20
 #define MSI_DATA_LEVEL_SHIFT		14
 #define	 MSI_DATA_LEVEL_DEASSERT	(0 << MSI_DATA_LEVEL_SHIFT)
@@ -37,6 +38,7 @@
 #define MSI_ADDR_DEST_MODE_SHIFT	2
 #define  MSI_ADDR_DEST_MODE_PHYSICAL	(0 << MSI_ADDR_DEST_MODE_SHIFT)
 #define	 MSI_ADDR_DEST_MODE_LOGICAL	(1 << MSI_ADDR_DEST_MODE_SHIFT)
+#define  MSI_ADDR_DEST_MODE_MASK	(1 << MSI_DATA_DELIVERY_MODE_SHIFT)
=20
 #define MSI_ADDR_REDIRECTION_SHIFT	3
 #define  MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.=
c
index 54f6a029b1d1..ca2da19d5c55 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -48,6 +48,7 @@
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
 #include <linux/memblock.h>
+#include <linux/msi.h>
=20
 #include <asm/irqdomain.h>
 #include <asm/io.h>
@@ -63,6 +64,7 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hw_irq.h>
+#include <asm/msidef.h>
=20
 #include <asm/apic.h>
=20
@@ -1851,22 +1853,36 @@ static void ioapic_ir_ack_level(struct irq_data *ir=
q_data)
 	eoi_ioapic_pin(data->entry.vector, data);
 }
=20
+static void mp_swizzle_msi_dest_bits(struct irq_data *irq_data, void *_ent=
ry)
+{
+	struct msi_msg msg;
+	u32 *entry =3D _entry;
+
+	irq_chip_compose_msi_msg(irq_data, &msg);
+
+	/*
+	 * They're in a bit of a random order for historical reasons, but
+	 * the IO/APIC is just a device for turning interrupt lines into
+	 * MSIs, and various bits of the MSI addr/data are just swizzled
+	 * into/from the bits of Redirection Table Entry.
+	 */
+	entry[0] &=3D 0xfffff000;
+	entry[0] |=3D (msg.data & (MSI_DATA_DELIVERY_MODE_MASK |
+				 MSI_DATA_VECTOR_MASK));
+	entry[0] |=3D (msg.address_lo & MSI_ADDR_DEST_MODE_MASK) << 9;
+
+	entry[1] &=3D 0xffff;
+	entry[1] |=3D (msg.address_lo & MSI_ADDR_DEST_ID_MASK) << 12;
+}
+
+
 static void ioapic_configure_entry(struct irq_data *irqd)
 {
 	struct mp_chip_data *mpd =3D irqd->chip_data;
-	struct irq_cfg *cfg =3D irqd_cfg(irqd);
 	struct irq_pin_list *entry;
=20
-	/*
-	 * Only update when the parent is the vector domain, don't touch it
-	 * if the parent is the remapping domain. Check the installed
-	 * ioapic chip to verify that.
-	 */
-	if (irqd->chip =3D=3D &ioapic_chip) {
-		mpd->entry.dest =3D cfg->dest_apicid & 0xff;
-		mpd->entry.virt_ext_dest =3D cfg->dest_apicid >> 8;
-		mpd->entry.vector =3D cfg->vector;
-	}
+	mp_swizzle_msi_dest_bits(irqd, &mpd->entry);
+
 	for_each_irq_pin(entry, mpd->irq_2_pin)
 		__ioapic_write_entry(entry->apic, entry->pin, mpd->entry);
 }
@@ -2949,15 +2965,14 @@ static void mp_irqdomain_get_attr(u32 gsi, struct m=
p_chip_data *data,
 	}
 }
=20
-static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
-			   struct IO_APIC_route_entry *entry)
+static void mp_setup_entry(struct irq_data *irq_data, struct mp_chip_data =
*data)
 {
+	struct IO_APIC_route_entry *entry =3D &data->entry;
+
 	memset(entry, 0, sizeof(*entry));
-	entry->delivery_mode =3D apic->irq_delivery_mode;
-	entry->dest_mode     =3D apic->irq_dest_mode;
-	entry->dest	     =3D cfg->dest_apicid & 0xff;
-	entry->virt_ext_dest =3D cfg->dest_apicid >> 8;
-	entry->vector	     =3D cfg->vector;
+
+	mp_swizzle_msi_dest_bits(irq_data, entry);
+
 	entry->trigger	     =3D data->trigger;
 	entry->polarity	     =3D data->polarity;
 	/*
@@ -2995,7 +3010,6 @@ int mp_irqdomain_alloc(struct irq_domain *domain, uns=
igned int virq,
 	if (!data)
 		return -ENOMEM;
=20
-	info->ioapic.entry =3D &data->entry;
 	ret =3D irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, info);
 	if (ret < 0) {
 		kfree(data);
@@ -3013,8 +3027,7 @@ int mp_irqdomain_alloc(struct irq_domain *domain, uns=
igned int virq,
 	add_pin_to_irq_node(data, ioapic_alloc_attr_node(info), ioapic, pin);
=20
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
@@ -3597,7 +3597,6 @@ static void irq_remapping_prepare_irte(struct amd_ir_=
data *data,
 {
 	struct irq_2_irte *irte_info =3D &data->irq_2_irte;
 	struct msi_msg *msg =3D &data->msi_entry;
-	struct IO_APIC_route_entry *entry;
 	struct amd_iommu *iommu =3D amd_iommu_rlookup_table[devid];
=20
 	if (!iommu)
@@ -3611,19 +3610,6 @@ static void irq_remapping_prepare_irte(struct amd_ir=
_data *data,
=20
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC:
-		/* Setup IOAPIC entry */
-		entry =3D info->ioapic.entry;
-		info->ioapic.entry =3D NULL;
-		memset(entry, 0, sizeof(*entry));
-		entry->vector        =3D index;
-		entry->mask          =3D 0;
-		entry->trigger       =3D info->ioapic.trigger;
-		entry->polarity      =3D info->ioapic.polarity;
-		/* Mask level triggered irqs. */
-		if (info->ioapic.trigger)
-			entry->mask =3D 1;
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
 	struct irq_data *parent =3D data->parent_data;
 	struct irq_cfg *cfg =3D irqd_cfg(data);
-	struct IO_APIC_route_entry *entry;
 	int ret;
=20
 	/* Return error If new irq affinity is out of ioapic_max_cpumask. */
@@ -51,9 +50,6 @@ static int hyperv_ir_set_affinity(struct irq_data *data,
 	if (ret < 0 || ret =3D=3D IRQ_SET_MASK_OK_DONE)
 		return ret;
=20
-	entry =3D data->chip_data;
-	entry->dest =3D cfg->dest_apicid;
-	entry->vector =3D cfg->vector;
 	send_cleanup_vector(cfg);
=20
 	return 0;
@@ -89,20 +85,6 @@ static int hyperv_irq_remapping_alloc(struct irq_domain =
*domain,
=20
 	irq_data->chip =3D &hyperv_ir_chip;
=20
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
-	irq_data->chip_data =3D info->ioapic.entry;
-
 	/*
 	 * Hypver-V IO APIC irq affinity should be in the scope of
 	 * ioapic_max_cpumask because no irq remapping support.
@@ -119,22 +101,9 @@ static void hyperv_irq_remapping_free(struct irq_domai=
n *domain,
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 }
=20
-static int hyperv_irq_remapping_activate(struct irq_domain *domain,
-			  struct irq_data *irq_data, bool reserve)
-{
-	struct irq_cfg *cfg =3D irqd_cfg(irq_data);
-	struct IO_APIC_route_entry *entry =3D irq_data->chip_data;
-
-	entry->dest =3D cfg->dest_apicid;
-	entry->vector =3D cfg->vector;
-
-	return 0;
-}
-
 static const struct irq_domain_ops hyperv_ir_domain_ops =3D {
 	.alloc =3D hyperv_irq_remapping_alloc,
 	.free =3D hyperv_irq_remapping_free,
-	.activate =3D hyperv_irq_remapping_activate,
 };
=20
 static int __init hyperv_prepare_irq_remapping(void)
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_=
remapping.c
index 0cfce1d3b7bb..511dfb4884bc 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1265,7 +1265,6 @@ static void intel_irq_remapping_prepare_irte(struct i=
ntel_ir_data *data,
 					     struct irq_alloc_info *info,
 					     int index, int sub_handle)
 {
-	struct IR_IO_APIC_route_entry *entry;
 	struct irte *irte =3D &data->irte_entry;
 	struct msi_msg *msg =3D &data->msi_entry;
=20
@@ -1281,23 +1280,15 @@ static void intel_irq_remapping_prepare_irte(struct=
 intel_ir_data *data,
 			irte->avail, irte->vector, irte->dest_id,
 			irte->sid, irte->sq, irte->svt);
=20
-		entry =3D (struct IR_IO_APIC_route_entry *)info->ioapic.entry;
-		info->ioapic.entry =3D NULL;
-		memset(entry, 0, sizeof(*entry));
-		entry->index2	=3D (index >> 15) & 0x1;
-		entry->zero	=3D 0;
-		entry->format	=3D 1;
-		entry->index	=3D (index & 0x7fff);
 		/*
 		 * IO-APIC RTE will be configured with virtual vector.
 		 * irq handler will do the explicit EOI to the io-apic.
 		 */
-		entry->vector	=3D info->ioapic.pin;
-		entry->mask	=3D 0;			/* enable IRQ */
-		entry->trigger	=3D info->ioapic.trigger;
-		entry->polarity	=3D info->ioapic.polarity;
-		if (info->ioapic.trigger)
-			entry->mask =3D 1; /* Mask level triggered irqs. */
+		msg->data =3D info->ioapic.pin;
+		msg->address_hi =3D MSI_ADDR_BASE_HI;
+		msg->address_lo =3D MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_INDEX1(index) |
+				  MSI_ADDR_IR_INDEX2(index);
 		break;
=20
 	case X86_IRQ_ALLOC_TYPE_HPET:
--=20
2.17.1







--=-9Rz78B0mms1lhSEat8uw
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MDA4MTYwODA2WjAvBgkqhkiG9w0BCQQxIgQgJlLhFD0MJTJNMVV5sALLMPewVc8j2BomVJJczq3O
ggAwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAAytmHyYJryeeuq5a4y+oiCpF5v+eXgjr4+yEqVno+dsrs2Njwrt+R62w/3qMceO
JG8Qp+1MsO6laqGFkVZzFMR9PK+6fZvHEHVOCwto0B6v3zP8oi6XtAUuYUDPjEGKo3jVXlW6dCJM
O96qY81nj+5z1NlLlh0LMJeRGcd0/heU0fVejDmt3wcEOy0bK4WprG2wUpbVRZwHZGEYRo61Mge7
aYTxFclLYB7RYODYfuPagv3tTXjZoqY0KBq63yo6/SgJKOfKilbzWWlWzOzQkbCd+CConMPESap0
009SwjfKL6f+4x1AAbpHdCuwhTfBN9e40xFumoRO6chzqt5uz28AAAAAAAA=


--=-9Rz78B0mms1lhSEat8uw--

