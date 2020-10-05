Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694D1283B3D
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgJEPkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgJEP3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE29C0613B2;
        Mon,  5 Oct 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gvAsnJJ1/zRcEGHp7vzyF/e1khe55jvd/2pvrS/D7RY=; b=wXaGlU4v1PypzRTV8kxQOkDho4
        ZA/Xh7BtKtaoBaZ5D2+dMf+XUIXpp/5n6Bz5LnvQkT3m4FnBGwtyDO98Ls2HNWRCcFQf03c8dVvlW
        P4QEbEeysbQBcqQFVvQgjIvBqQT33S2uIdedfGwhUR7hOF9ny84RAATU+LB4HZScR7u4H0+QPwh5B
        P7bofAGMp0YXw75hC0hSDm06OIi/R7O0+UNcjpAp5rP8Sy8BdVDoPGD9E+mEQcqc7sGfpWPQjvH3u
        pf7BQPVfzG2OGOoe7KhKyhDQkzIb6hlgF+IK3E6Ht+fu+5eguzCHolkSBbZs0GV/nWjqBmidX1PPP
        9ChKSXkg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ4-0001mG-Na; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045QK-99; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 03/13] x86/ioapic: Handle Extended Destination ID field in RTE
Date:   Mon,  5 Oct 2020 16:28:46 +0100
Message-Id: <20201005152856.974112-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The IOAPIC Redirection Table Entries contain an 8-bit Extended
Destination ID field which maps to bits 11-4 of the MSI address.

The lowest bit is used to indicate remappable format, when interrupt
remapping is in use. A hypervisor can use the other 7 bits to permit
guests to address up to 15 bits of APIC IDs, thus allowing 32768 vCPUs
before having to expose a vIOMMU and interrupt remapping to the guest.

No behavioural change in this patch, since nothing yet permits APIC IDs
above 255 to be used with the non-IR IOAPIC domain.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/io_apic.h |  3 ++-
 arch/x86/kernel/apic/io_apic.c | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a1a26f6d3aa4..e65a0b7379d0 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -78,7 +78,8 @@ struct IO_APIC_route_entry {
 		mask		:  1,	/* 0: enabled, 1: disabled */
 		__reserved_2	: 15;
 
-	__u32	__reserved_3	: 24,
+	__u32	__reserved_3	: 17,
+		ext_dest	:  7,
 		dest		:  8;
 } __attribute__ ((packed));
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a33380059db6..aa9a3b54a96c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1239,10 +1239,10 @@ static void io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 			       buf, (ir_entry->index2 << 15) | ir_entry->index,
 			       ir_entry->zero);
 		else
-			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n",
+			printk(KERN_DEBUG "%s, %s, D(%02X%02X), M(%1d)\n",
 			       buf,
 			       entry.dest_mode == IOAPIC_DEST_MODE_LOGICAL ?
-			       "logical " : "physical",
+			       "logical " : "physical", entry.ext_dest,
 			       entry.dest, entry.delivery_mode);
 	}
 }
@@ -1410,6 +1410,7 @@ void native_restore_boot_irq_mode(void)
 	 */
 	if (ioapic_i8259.pin != -1) {
 		struct IO_APIC_route_entry entry;
+		u32 apic_id = read_apic_id();
 
 		memset(&entry, 0, sizeof(entry));
 		entry.mask		= IOAPIC_UNMASKED;
@@ -1417,7 +1418,8 @@ void native_restore_boot_irq_mode(void)
 		entry.polarity		= IOAPIC_POL_HIGH;
 		entry.dest_mode		= IOAPIC_DEST_MODE_PHYSICAL;
 		entry.delivery_mode	= dest_ExtINT;
-		entry.dest		= read_apic_id();
+		entry.dest		= apic_id & 0xff;
+		entry.ext_dest		= apic_id >> 8;
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1861,7 +1863,8 @@ static void ioapic_configure_entry(struct irq_data *irqd)
 	 * ioapic chip to verify that.
 	 */
 	if (irqd->chip == &ioapic_chip) {
-		mpd->entry.dest = cfg->dest_apicid;
+		mpd->entry.dest = cfg->dest_apicid & 0xff;
+		mpd->entry.ext_dest = cfg->dest_apicid >> 8;
 		mpd->entry.vector = cfg->vector;
 	}
 	for_each_irq_pin(entry, mpd->irq_2_pin)
@@ -2027,6 +2030,7 @@ static inline void __init unlock_ExtINT_logic(void)
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
 	unsigned char save_control, save_freq_select;
+	u32 apic_id;
 
 	pin  = find_isa_irq_pin(8, mp_INT);
 	if (pin == -1) {
@@ -2042,11 +2046,13 @@ static inline void __init unlock_ExtINT_logic(void)
 	entry0 = ioapic_read_entry(apic, pin);
 	clear_IO_APIC_pin(apic, pin);
 
+	apic_id = hard_smp_processor_id();
 	memset(&entry1, 0, sizeof(entry1));
 
 	entry1.dest_mode = IOAPIC_DEST_MODE_PHYSICAL;
 	entry1.mask = IOAPIC_UNMASKED;
-	entry1.dest = hard_smp_processor_id();
+	entry1.dest = apic_id & 0xff;
+	entry1.ext_dest = apic_id >> 8;
 	entry1.delivery_mode = dest_ExtINT;
 	entry1.polarity = entry0.polarity;
 	entry1.trigger = IOAPIC_EDGE;
@@ -2949,7 +2955,8 @@ static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
 	memset(entry, 0, sizeof(*entry));
 	entry->delivery_mode = apic->irq_delivery_mode;
 	entry->dest_mode     = apic->irq_dest_mode;
-	entry->dest	     = cfg->dest_apicid;
+	entry->dest	     = cfg->dest_apicid & 0xff;
+	entry->ext_dest	     = cfg->dest_apicid >> 8;
 	entry->vector	     = cfg->vector;
 	entry->trigger	     = data->trigger;
 	entry->polarity	     = data->polarity;
-- 
2.26.2

