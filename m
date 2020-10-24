Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717B2297F03
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764850AbgJXVge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764746AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B69C0613E9;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IEuM/DY48LV1kSqzyk1PpZ8V9H+gSFXivoek6I+9py8=; b=pcSMH5Uf7aMUj+QI2qxpqDBW60
        v8jB7TDJe7fFIA5RTGZic2fzHTRjKamdE26IZweyod2fS7lop/pkHotBUJOwAkAUn99IOTcr5coaD
        iSrVJaEOaCBqpywm5xk8r037hTXqM7SBWGtGnJYARQ9Bs6xlx9nyf5lRnZnfsh3lP0JIMXt71OlIv
        bWou9ix3RNI9POEqGDby1NVnjMImabKERWPjWRxX+BS6JmVqyWIhTTdgnAyEXP1KH0zpzGDlDL6Ie
        Oz+XvA2Odnw4Y+KQyBPgvNOvGq0cHxd0lEjZZKKdHRTFz6II6D3ycd2aersugYj+8zf7GmQTchyOs
        qZxvCt0w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HM-TX; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPa-Ef; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 31/35] x86/ioapic: Handle Extended Destination ID field in RTE
Date:   Sat, 24 Oct 2020 22:35:31 +0100
Message-Id: <20201024213535.443185-32-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Bits 63-48 of the I/OAPIC Redirection Table Entry map directly to bits 19-4
of the address used in the resulting MSI cycle.

Historically, the x86 MSI format only used the top 8 of those 16 bits as
the destination APIC ID, and the "Extended Destination ID" in the lower 8
bits was unused.

With interrupt remapping, the lowest bit of the Extended Destination ID
(bit 48 of RTE, bit 4 of MSI address) is now used to indicate a remappable
format MSI.

A hypervisor can use the other 7 bits of the Extended Destination ID to
permit guests to address up to 15 bits of APIC IDs, thus allowing 32768
vCPUs before having to expose a vIOMMU and interrupt remapping to the
guest.

No behavioural change in this patch, since nothing yet permits APIC IDs
above 255 to be used with the non-IR I/OAPIC domain.

[ tglx: Converted it to the cleaned up entry/msi_msg format and added
  	commentry ]

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  3 ++-
 arch/x86/kernel/apic/io_apic.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 73da644b2f0d..437aa8d00e53 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -67,7 +67,8 @@ struct IO_APIC_route_entry {
 				is_level		:  1,
 				masked			:  1,
 				reserved_0		: 15,
-				reserved_1		: 24,
+				reserved_1		: 17,
+				virt_destid_8_14	:  7,
 				destid_0_7		:  8;
 		};
 		struct {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 443d2c9086b9..1cfd65ef295b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1238,9 +1238,10 @@ static void io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 			       (entry.ir_index_15 << 15) | entry.ir_index_0_14,
 				entry.ir_zero);
 		} else {
-			printk(KERN_DEBUG "%s, %s, D(%02X), M(%1d)\n", buf,
+			printk(KERN_DEBUG "%s, %s, D(%02X%02X), M(%1d)\n", buf,
 			       entry.dest_mode_logical ? "logical " : "physical",
-			       entry.destid_0_7, entry.delivery_mode);
+			       entry.virt_destid_8_14, entry.destid_0_7,
+			       entry.delivery_mode);
 		}
 	}
 }
@@ -1409,6 +1410,7 @@ void native_restore_boot_irq_mode(void)
 	 */
 	if (ioapic_i8259.pin != -1) {
 		struct IO_APIC_route_entry entry;
+		u32 apic_id = read_apic_id();
 
 		memset(&entry, 0, sizeof(entry));
 		entry.masked		= false;
@@ -1416,7 +1418,8 @@ void native_restore_boot_irq_mode(void)
 		entry.active_low	= false;
 		entry.dest_mode_logical	= false;
 		entry.delivery_mode	= APIC_DELIVERY_MODE_EXTINT;
-		entry.destid_0_7	= read_apic_id();
+		entry.destid_0_7	= apic_id & 0xFF;
+		entry.virt_destid_8_14	= apic_id >> 8;
 
 		/*
 		 * Add it to the IO-APIC irq-routing table:
@@ -1885,7 +1888,11 @@ static void ioapic_setup_msg_from_msi(struct irq_data *irq_data,
 	/* DMAR/IR: 1, 0 for all other modes */
 	entry->ir_format		= msg.arch_addr_lo.dmar_format;
 	/*
-	 * DMAR/IR: index bit 0-14.
+	 * - DMAR/IR: index bit 0-14.
+	 *
+	 * - Virt: If the host supports x2apic without a virtualized IR
+	 *	   unit then bit 0-6 of dmar_index_0_14 are providing bit
+	 *	   8-14 of the destination id.
 	 *
 	 * All other modes have bit 0-6 of dmar_index_0_14 cleared and the
 	 * topmost 8 bits are destination id bit 0-7 (entry::destid_0_7).
@@ -2063,6 +2070,7 @@ static inline void __init unlock_ExtINT_logic(void)
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
 	unsigned char save_control, save_freq_select;
+	u32 apic_id;
 
 	pin  = find_isa_irq_pin(8, mp_INT);
 	if (pin == -1) {
@@ -2078,11 +2086,13 @@ static inline void __init unlock_ExtINT_logic(void)
 	entry0 = ioapic_read_entry(apic, pin);
 	clear_IO_APIC_pin(apic, pin);
 
+	apic_id = hard_smp_processor_id();
 	memset(&entry1, 0, sizeof(entry1));
 
 	entry1.dest_mode_logical	= true;
 	entry1.masked			= false;
-	entry1.destid_0_7		= hard_smp_processor_id();
+	entry1.destid_0_7		= apic_id & 0xFF;
+	entry1.virt_destid_8_14		= apic_id >> 8;
 	entry1.delivery_mode		= APIC_DELIVERY_MODE_EXTINT;
 	entry1.active_low		= entry0.active_low;
 	entry1.is_level			= false;
-- 
2.26.2

