Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB0297C69
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 14:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761477AbgJXMon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 08:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761470AbgJXMom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 08:44:42 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95961C0613CE;
        Sat, 24 Oct 2020 05:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ytbzsY3MYQoB07gSB/iQyxjHhNuMGuPQzQqfVAZ6KjA=; b=CVKQfsBWJf2JcKvak0oGMmGN8X
        wT61DJLLknf/JQyT6ajXF/rsSTJp8dRxxT51SQ2AwtCZIQ1ga/Y+LQgvTkHXlUrYjTAc6Y2akT5IQ
        b0ii8QuFw0/bUKcT3ojRMPWRJa7Xu0XXwV2brgdm6nyzVy5RAD3AXBtNd3VwN/d3ZfKSHtUdRd3xh
        iWozLpwYIfqdGuDZqhgPsUkHe3RsDg/L+c9TUYoUbJvj+9Qpg/cHVzGwdAaKM8gpsQSsW8LdTsVAi
        yFbuOe+eUKdg9BSZM+B5LDdUr0BM1HHb9IXWFQ+92Hf0CZDH6vJgZt1Yd1pv/C/3WQsgwLKPJL3IH
        et+KKixw==;
Received: from dyn-227.woodhou.se ([90.155.92.227])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWIuQ-0005yo-Oo; Sat, 24 Oct 2020 12:44:35 +0000
Message-ID: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent
 irqchip's MSI message
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Date:   Sat, 24 Oct 2020 13:44:32 +0100
In-Reply-To: <A2753AD1-9BE8-43D8-870D-236C394A892B@infradead.org>
References: <87y2jy542v.fsf@nanos.tec.linutronix.de>
         <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org>
         <87d01863a2.fsf@nanos.tec.linutronix.de>
         <be564fccc341efa730b8cdfe18ef4d7e709ebf50.camel@infradead.org>
         <ddf17616-04c7-9593-eae8-8e9e473ecd90@redhat.com>
         <A2753AD1-9BE8-43D8-870D-236C394A892B@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-jngacfh4zQtjAO6UD6YJ"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-jngacfh4zQtjAO6UD6YJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-10-24 at 11:13 +0100, David Woodhouse wrote:
> OK, thanks. I'll rework Thomas's tree with that first and the other
> changes I'd mentioned in my parts, as well as fixing up that unholy
> chim=C3=A6ra of struct/union in which we set some bitfields from each sid=
e
> of the union, test and push it out later today.

OK, pushed out to=20
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/x86/api=
c]

It's Thomas's tree plus the struct/union fixes and other things I
mentioned earlier, a few comment fixes in the 'Generate RTE directly
from parent irqchip' patch, but the most interesting part is finishing
the job of the 'Cleanup IO/APIC route entry structs' patch...

=46rom 54b623fc2b03eadb76485b4ca0ade3e79acf6c27 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 22 Oct 2020 14:48:18 +0200
Subject: [PATCH 124/137] x86/ioapic: Cleanup IO/APIC route entry structs

Having two seperate structs for the I/O-APIC RTE entries (non-remapped and
DMAR remapped) requires type casts and makes it hard to map.

Combine them in IO_APIC_routing_entry by defining a union of two 64bit
bitfields. Use naming which reflects which bits are shared and which bits
are actually different for the operating modes.

[dwmw2: Fix it up and finish the job, pulling the 32-bit w1,w2 words for
        register access into the same union and eliminating a few more
        places where bits were accessed through masks and shifts.]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/io_apic.h      |  78 ++++++---------
 arch/x86/kernel/apic/io_apic.c      | 144 +++++++++++++---------------
 drivers/iommu/amd/iommu.c           |   8 +-
 drivers/iommu/hyperv-iommu.c        |   4 +-
 drivers/iommu/intel/irq_remapping.c |  19 ++--
 5 files changed, 108 insertions(+), 145 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.=
h
index a1a26f6d3aa4..73da644b2f0d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -13,15 +13,6 @@
  * Copyright (C) 1997, 1998, 1999, 2000 Ingo Molnar
  */
=20
-/* I/O Unit Redirection Table */
-#define IO_APIC_REDIR_VECTOR_MASK	0x000FF
-#define IO_APIC_REDIR_DEST_LOGICAL	0x00800
-#define IO_APIC_REDIR_DEST_PHYSICAL	0x00000
-#define IO_APIC_REDIR_SEND_PENDING	(1 << 12)
-#define IO_APIC_REDIR_REMOTE_IRR	(1 << 14)
-#define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
-#define IO_APIC_REDIR_MASKED		(1 << 16)
-
 /*
  * The structure of the IO-APIC:
  */
@@ -65,52 +56,39 @@ union IO_APIC_reg_03 {
 };
=20
 struct IO_APIC_route_entry {
-	__u32	vector		:  8,
-		delivery_mode	:  3,	/* 000: FIXED
-					 * 001: lowest prio
-					 * 111: ExtINT
-					 */
-		dest_mode	:  1,	/* 0: physical, 1: logical */
-		delivery_status	:  1,
-		polarity	:  1,
-		irr		:  1,
-		trigger		:  1,	/* 0: edge, 1: level */
-		mask		:  1,	/* 0: enabled, 1: disabled */
-		__reserved_2	: 15;
-
-	__u32	__reserved_3	: 24,
-		dest		:  8;
-} __attribute__ ((packed));
-
-struct IR_IO_APIC_route_entry {
-	__u64	vector		: 8,
-		zero		: 3,
-		index2		: 1,
-		delivery_status : 1,
-		polarity	: 1,
-		irr		: 1,
-		trigger		: 1,
-		mask		: 1,
-		reserved	: 31,
-		format		: 1,
-		index		: 15;
+	union {
+		struct {
+			u64	vector			:  8,
+				delivery_mode		:  3,
+				dest_mode_logical	:  1,
+				delivery_status		:  1,
+				active_low		:  1,
+				irr			:  1,
+				is_level		:  1,
+				masked			:  1,
+				reserved_0		: 15,
+				reserved_1		: 24,
+				destid_0_7		:  8;
+		};
+		struct {
+			u64	ir_shared_0		:  8,
+				ir_zero			:  3,
+				ir_index_15		:  1,
+				ir_shared_1		:  5,
+				ir_reserved_0		: 31,
+				ir_format		:  1,
+				ir_index_0_14		: 15;
+		};
+		struct {
+			u64	w1			: 32,
+				w2			: 32;
+		};
+	};
 } __attribute__ ((packed));
=20
 struct irq_alloc_info;
 struct ioapic_domain_cfg;
=20
-#define IOAPIC_EDGE			0
-#define IOAPIC_LEVEL			1
-
-#define IOAPIC_MASKED			1
-#define IOAPIC_UNMASKED			0
-
-#define IOAPIC_POL_HIGH			0
-#define IOAPIC_POL_LOW			1
-
-#define IOAPIC_DEST_MODE_PHYSICAL	0
-#define IOAPIC_DEST_MODE_LOGICAL	1
-
 #define	IOAPIC_MAP_ALLOC		0x1
 #define	IOAPIC_MAP_CHECK		0x2
=20
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.=
c
index 24a7bba7cbf4..07e754131854 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -286,31 +286,26 @@ static void io_apic_write(unsigned int apic, unsigned=
 int reg,
 	writel(value, &io_apic->data);
 }
=20
-union entry_union {
-	struct { u32 w1, w2; };
-	struct IO_APIC_route_entry entry;
-};
-
 static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
 {
-	union entry_union eu;
+	struct IO_APIC_route_entry entry;
=20
-	eu.w1 =3D io_apic_read(apic, 0x10 + 2 * pin);
-	eu.w2 =3D io_apic_read(apic, 0x11 + 2 * pin);
+	entry.w1 =3D io_apic_read(apic, 0x10 + 2 * pin);
+	entry.w2 =3D io_apic_read(apic, 0x11 + 2 * pin);
=20
-	return eu.entry;
+	return entry;
 }
=20
 static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
-	union entry_union eu;
+	struct IO_APIC_route_entry entry;
 	unsigned long flags;
=20
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	eu.entry =3D __ioapic_read_entry(apic, pin);
+	entry =3D __ioapic_read_entry(apic, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
=20
-	return eu.entry;
+	return entry;
 }
=20
 /*
@@ -321,11 +316,8 @@ static struct IO_APIC_route_entry ioapic_read_entry(in=
t apic, int pin)
  */
 static void __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_e=
ntry e)
 {
-	union entry_union eu =3D {{0, 0}};
-
-	eu.entry =3D e;
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
+	io_apic_write(apic, 0x11 + 2*pin, e.w2);
+	io_apic_write(apic, 0x10 + 2*pin, e.w1);
 }
=20
 static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_ent=
ry e)
@@ -344,12 +336,12 @@ static void ioapic_write_entry(int apic, int pin, str=
uct IO_APIC_route_entry e)
  */
 static void ioapic_mask_entry(int apic, int pin)
 {
+	struct IO_APIC_route_entry e =3D { .masked =3D true };
 	unsigned long flags;
-	union entry_union eu =3D { .entry.mask =3D IOAPIC_MASKED };
=20
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
-	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
+	io_apic_write(apic, 0x10 + 2*pin, e.w1);
+	io_apic_write(apic, 0x11 + 2*pin, e.w2);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
=20
@@ -422,20 +414,15 @@ static void __init replace_pin_at_irq_node(struct mp_=
chip_data *data, int node,
 	add_pin_to_irq_node(data, node, newapic, newpin);
 }
=20
-static void io_apic_modify_irq(struct mp_chip_data *data,
-			       int mask_and, int mask_or,
+static void io_apic_modify_irq(struct mp_chip_data *data, bool masked,
 			       void (*final)(struct irq_pin_list *entry))
 {
-	union entry_union eu;
 	struct irq_pin_list *entry;
=20
-	eu.entry =3D data->entry;
-	eu.w1 &=3D mask_and;
-	eu.w1 |=3D mask_or;
-	data->entry =3D eu.entry;
+	data->entry.masked =3D masked;
=20
 	for_each_irq_pin(entry, data->irq_2_pin) {
-		io_apic_write(entry->apic, 0x10 + 2 * entry->pin, eu.w1);
+		io_apic_write(entry->apic, 0x10 + 2 * entry->pin, data->entry.w1);
 		if (final)
 			final(entry);
 	}
@@ -459,13 +446,13 @@ static void mask_ioapic_irq(struct irq_data *irq_data=
)
 	unsigned long flags;
=20
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	io_apic_modify_irq(data, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+	io_apic_modify_irq(data, true, &io_apic_sync);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
=20
 static void __unmask_ioapic(struct mp_chip_data *data)
 {
-	io_apic_modify_irq(data, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(data, false, NULL);
 }
=20
 static void unmask_ioapic_irq(struct irq_data *irq_data)
@@ -506,8 +493,8 @@ static void __eoi_ioapic_pin(int apic, int pin, int vec=
tor)
 		/*
 		 * Mask the entry and change the trigger mode to edge.
 		 */
-		entry1.mask =3D IOAPIC_MASKED;
-		entry1.trigger =3D IOAPIC_EDGE;
+		entry1.masked =3D true;
+		entry1.is_level =3D false;
=20
 		__ioapic_write_entry(apic, pin, entry1);
=20
@@ -542,8 +529,8 @@ static void clear_IO_APIC_pin(unsigned int apic, unsign=
ed int pin)
 	 * Make sure the entry is masked and re-read the contents to check
 	 * if it is a level triggered pin and if the remote-IRR is set.
 	 */
-	if (entry.mask =3D=3D IOAPIC_UNMASKED) {
-		entry.mask =3D IOAPIC_MASKED;
+	if (!entry.masked) {
+		entry.masked =3D true;
 		ioapic_write_entry(apic, pin, entry);
 		entry =3D ioapic_read_entry(apic, pin);
 	}
@@ -556,8 +543,8 @@ static void clear_IO_APIC_pin(unsigned int apic, unsign=
ed int pin)
 		 * doesn't clear the remote-IRR if the trigger mode is not
 		 * set to level.
 		 */
-		if (entry.trigger =3D=3D IOAPIC_EDGE) {
-			entry.trigger =3D IOAPIC_LEVEL;
+		if (!entry.is_level) {
+			entry.is_level =3D true;
 			ioapic_write_entry(apic, pin, entry);
 		}
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
@@ -659,8 +646,8 @@ void mask_ioapic_entries(void)
 			struct IO_APIC_route_entry entry;
=20
 			entry =3D ioapics[apic].saved_registers[pin];
-			if (entry.mask =3D=3D IOAPIC_UNMASKED) {
-				entry.mask =3D IOAPIC_MASKED;
+			if (!entry.masked) {
+				entry.masked =3D true;
 				ioapic_write_entry(apic, pin, entry);
 			}
 		}
@@ -947,8 +934,8 @@ static bool mp_check_pin_attr(int irq, struct irq_alloc=
_info *info)
 	if (irq < nr_legacy_irqs() && data->count =3D=3D 1) {
 		if (info->ioapic.is_level !=3D data->is_level)
 			mp_register_handler(irq, info->ioapic.is_level);
-		data->entry.trigger =3D data->is_level =3D info->ioapic.is_level;
-		data->entry.polarity =3D data->active_low =3D info->ioapic.active_low;
+		data->entry.is_level =3D data->is_level =3D info->ioapic.is_level;
+		data->entry.active_low =3D data->active_low =3D info->ioapic.active_low;
 	}
=20
 	return data->is_level =3D=3D info->ioapic.is_level &&
@@ -1231,10 +1218,9 @@ void ioapic_zap_locks(void)
=20
 static void io_apic_print_entries(unsigned int apic, unsigned int nr_entri=
es)
 {
-	int i;
-	char buf[256];
 	struct IO_APIC_route_entry entry;
-	struct IR_IO_APIC_route_entry *ir_entry =3D (void *)&entry;
+	char buf[256];
+	int i;
=20
 	printk(KERN_DEBUG "IOAPIC %d:\n", apic);
 	for (i =3D 0; i <=3D nr_entries; i++) {
@@ -1242,20 +1228,20 @@ static void io_apic_print_entries(unsigned int apic=
, unsigned int nr_entries)
 		snprintf(buf, sizeof(buf),
 			 " pin%02x, %s, %s, %s, V(%02X), IRR(%1d), S(%1d)",
 			 i,
-			 entry.mask =3D=3D IOAPIC_MASKED ? "disabled" : "enabled ",
-			 entry.trigger =3D=3D IOAPIC_LEVEL ? "level" : "edge ",
-			 entry.polarity =3D=3D IOAPIC_POL_LOW ? "low " : "high",
+			 entry.masked ? "disabled" : "enabled ",
+			 entry.is_level ? "level" : "edge ",
+			 entry.active_low ? "low " : "high",
 			 entry.vector, entry.irr, entry.delivery_status);
-		if (ir_entry->format)
+		if (entry.ir_format) {
 			printk(KERN_DEBUG "%s, remapped, I(%04X),  Z(%X)\n",
-			       buf, (ir_entry->index2 << 15) | ir_entry->index,
-			       ir_entry->zero);
-		else
-			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n",
 			       buf,
-			       entry.dest_mode =3D=3D IOAPIC_DEST_MODE_LOGICAL ?
-			       "logical " : "physical",
-			       entry.dest, entry.delivery_mode);
+			       (entry.ir_index_15 << 15) | entry.ir_index_0_14,
+				entry.ir_zero);
+		} else {
+			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n", buf,
+			       entry.dest_mode_logical ? "logical " : "physical",
+			       entry.destid_0_7, entry.delivery_mode);
+		}
 	}
 }
=20
@@ -1380,8 +1366,8 @@ void __init enable_IO_APIC(void)
 		/* If the interrupt line is enabled and in ExtInt mode
 		 * I have found the pin where the i8259 is connected.
 		 */
-		if ((entry.mask =3D=3D 0) &&
-		    (entry.delivery_mode =3D=3D APIC_DELIVERY_MODE_EXTINT)) {
+		if (!entry.masked &&
+		    entry.delivery_mode =3D=3D APIC_DELIVERY_MODE_EXTINT) {
 			ioapic_i8259.apic =3D apic;
 			ioapic_i8259.pin  =3D pin;
 			goto found_i8259;
@@ -1425,12 +1411,12 @@ void native_restore_boot_irq_mode(void)
 		struct IO_APIC_route_entry entry;
=20
 		memset(&entry, 0, sizeof(entry));
-		entry.mask		=3D IOAPIC_UNMASKED;
-		entry.trigger		=3D IOAPIC_EDGE;
-		entry.polarity		=3D IOAPIC_POL_HIGH;
-		entry.dest_mode		=3D IOAPIC_DEST_MODE_PHYSICAL;
+		entry.masked		=3D false;
+		entry.is_level		=3D false;
+		entry.active_low	=3D false;
+		entry.dest_mode_logical	=3D false;
 		entry.delivery_mode	=3D APIC_DELIVERY_MODE_EXTINT;
-		entry.dest		=3D read_apic_id();
+		entry.destid_0_7	=3D read_apic_id();
=20
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1709,13 +1695,13 @@ static bool io_apic_level_ack_pending(struct mp_chi=
p_data *data)
=20
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, data->irq_2_pin) {
-		unsigned int reg;
+		struct IO_APIC_route_entry e;
 		int pin;
=20
 		pin =3D entry->pin;
-		reg =3D io_apic_read(entry->apic, 0x10 + pin*2);
+		e.w1 =3D io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
-		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+		if (e.irr) {
 			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
@@ -1874,7 +1860,7 @@ static void ioapic_configure_entry(struct irq_data *i=
rqd)
 	 * ioapic chip to verify that.
 	 */
 	if (irqd->chip =3D=3D &ioapic_chip) {
-		mpd->entry.dest =3D cfg->dest_apicid;
+		mpd->entry.destid_0_7 =3D cfg->dest_apicid;
 		mpd->entry.vector =3D cfg->vector;
 	}
 	for_each_irq_pin(entry, mpd->irq_2_pin)
@@ -1932,7 +1918,7 @@ static int ioapic_irq_get_chip_state(struct irq_data =
*irqd,
 		 * irrelevant because the IO-APIC treats them as fire and
 		 * forget.
 		 */
-		if (rentry.irr && rentry.trigger) {
+		if (rentry.irr && rentry.is_level) {
 			*state =3D true;
 			break;
 		}
@@ -2057,12 +2043,12 @@ static inline void __init unlock_ExtINT_logic(void)
=20
 	memset(&entry1, 0, sizeof(entry1));
=20
-	entry1.dest_mode =3D IOAPIC_DEST_MODE_PHYSICAL;
-	entry1.mask =3D IOAPIC_UNMASKED;
-	entry1.dest =3D hard_smp_processor_id();
-	entry1.delivery_mode =3D APIC_DELIVERY_MODE_EXTINT;
-	entry1.polarity =3D entry0.polarity;
-	entry1.trigger =3D IOAPIC_EDGE;
+	entry1.dest_mode_logical	=3D true;
+	entry1.masked			=3D false;
+	entry1.destid_0_7		=3D hard_smp_processor_id();
+	entry1.delivery_mode		=3D APIC_DELIVERY_MODE_EXTINT;
+	entry1.active_low		=3D entry0.active_low;
+	entry1.is_level			=3D false;
 	entry1.vector =3D 0;
=20
 	ioapic_write_entry(apic, pin, entry1);
@@ -2937,17 +2923,17 @@ static void mp_setup_entry(struct irq_cfg *cfg, str=
uct mp_chip_data *data,
 			   struct IO_APIC_route_entry *entry)
 {
 	memset(entry, 0, sizeof(*entry));
-	entry->delivery_mode =3D apic->delivery_mode;
-	entry->dest_mode     =3D apic->dest_mode_logical;
-	entry->dest	     =3D cfg->dest_apicid;
-	entry->vector	     =3D cfg->vector;
-	entry->trigger	     =3D data->is_level;
-	entry->polarity	     =3D data->active_low;
+	entry->delivery_mode	 =3D apic->delivery_mode;
+	entry->dest_mode_logical =3D apic->dest_mode_logical;
+	entry->destid_0_7	 =3D cfg->dest_apicid;
+	entry->vector		 =3D cfg->vector;
+	entry->is_level		 =3D data->is_level;
+	entry->active_low	 =3D data->active_low;
 	/*
 	 * Mask level triggered irqs. Edge triggered irqs are masked
 	 * by the irq core code in case they fire.
 	 */
-	entry->mask =3D data->is_level;
+	entry->masked		=3D data->is_level;
 }
=20
 int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b0e5210e53b2..3d72ec7bbbf8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3687,11 +3687,11 @@ static void irq_remapping_prepare_irte(struct amd_i=
r_data *data,
 		entry =3D info->ioapic.entry;
 		info->ioapic.entry =3D NULL;
 		memset(entry, 0, sizeof(*entry));
-		entry->vector	=3D index;
-		entry->trigger	=3D info->ioapic.is_level;
-		entry->polarity	=3D info->ioapic.active_low;
+		entry->vector		=3D index;
+		entry->is_level		=3D info->ioapic.is_level;
+		entry->active_low	=3D info->ioapic.active_low;
 		/* Mask level triggered irqs. */
-		entry->mask	=3D info->ioapic.is_level;
+		entry->masked		=3D info->ioapic.is_level;
 		break;
=20
 	case X86_IRQ_ALLOC_TYPE_HPET:
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index e09e2d734c57..1ab7eb918a5c 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -52,7 +52,7 @@ static int hyperv_ir_set_affinity(struct irq_data *data,
 		return ret;
=20
 	entry =3D data->chip_data;
-	entry->dest =3D cfg->dest_apicid;
+	entry->destid_0_7 =3D cfg->dest_apicid;
 	entry->vector =3D cfg->vector;
 	send_cleanup_vector(cfg);
=20
@@ -125,7 +125,7 @@ static int hyperv_irq_remapping_activate(struct irq_dom=
ain *domain,
 	struct irq_cfg *cfg =3D irqd_cfg(irq_data);
 	struct IO_APIC_route_entry *entry =3D irq_data->chip_data;
=20
-	entry->dest =3D cfg->dest_apicid;
+	entry->destid_0_7 =3D cfg->dest_apicid;
 	entry->vector =3D cfg->vector;
=20
 	return 0;
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_=
remapping.c
index 54ca69333445..625bdb9f1627 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1279,8 +1279,8 @@ static void intel_irq_remapping_prepare_irte(struct i=
ntel_ir_data *data,
 					     struct irq_alloc_info *info,
 					     int index, int sub_handle)
 {
-	struct IR_IO_APIC_route_entry *entry;
 	struct irte *irte =3D &data->irte_entry;
+	struct IO_APIC_route_entry *entry;
=20
 	prepare_irte(irte, irq_cfg->vector, irq_cfg->dest_apicid);
 	switch (info->type) {
@@ -1294,22 +1294,21 @@ static void intel_irq_remapping_prepare_irte(struct=
 intel_ir_data *data,
 			irte->avail, irte->vector, irte->dest_id,
 			irte->sid, irte->sq, irte->svt);
=20
-		entry =3D (struct IR_IO_APIC_route_entry *)info->ioapic.entry;
+		entry =3D info->ioapic.entry;
 		info->ioapic.entry =3D NULL;
 		memset(entry, 0, sizeof(*entry));
-		entry->index2	=3D (index >> 15) & 0x1;
-		entry->zero	=3D 0;
-		entry->format	=3D 1;
-		entry->index	=3D (index & 0x7fff);
+		entry->ir_index_15	=3D !!(index & 0x8000);
+		entry->ir_format	=3D true;
+		entry->ir_index_0_14	=3D index & 0x7fff;
 		/*
 		 * IO-APIC RTE will be configured with virtual vector.
 		 * irq handler will do the explicit EOI to the io-apic.
 		 */
-		entry->vector	=3D info->ioapic.pin;
-		entry->trigger	=3D info->ioapic.is_level;
-		entry->polarity	=3D info->ioapic.active_low;
+		entry->vector		=3D info->ioapic.pin;
+		entry->is_level		=3D info->ioapic.is_level;
+		entry->active_low	=3D info->ioapic.active_low;
 		/* Mask level triggered irqs. */
-		entry->mask	=3D info->ioapic.is_level;
+		entry->masked		=3D info->ioapic.is_level;
 		break;
=20
 	case X86_IRQ_ALLOC_TYPE_HPET:
--=20
2.17.1


--=-jngacfh4zQtjAO6UD6YJ
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
MDI0MTI0NDMyWjAvBgkqhkiG9w0BCQQxIgQgZa+/eIzmREq7hvEUJBogSV74+gFqb6076TYOkrjK
yScwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAEvzSEKDzt44mfK/OP2wM1aU3XWV0N8KKmNU/0oHHPYp4HC3jvGcm8NxM9r0KC7R
WCn+s6pfzZZ0tE4DiHuavpR6/GcllcZ0DamlxQwGQzaUxmAQ64HKezHfEc6Ztnnu6jerrN8nioc/
pPwwRDtL6sPp77Z02YqnhwxcEgQZsQNmzLQOmkDpn+n8w4goYx3v4RqLM7to0r901wgtDRK2SOES
vUXTg26gmaM80wybEKZJqRRcndZa3ChTV+utg+w7FhZr7PQY9D2nVaD8sJYIoFm1iW1gQrMx/z3t
kdAF2nRE3W/eIDJGgE8/IRgCy4GBjgoC/a0p5eAoSbfNoZmwL30AAAAAAAA=


--=-jngacfh4zQtjAO6UD6YJ--

