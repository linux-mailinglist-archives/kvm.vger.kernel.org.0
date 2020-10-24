Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E33297F29
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765031AbgJXVhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764704AbgJXVfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77778C0613D4;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mMHqR/4muo63Dmf2k2RCeLCg8gG2gyMpTS8W3rogIK8=; b=fsUjTvBw42sTYz+IGOorUxzO/l
        2xvBi+ioybdIq9zPQkHYsvsID5Cf9KyhBY9E/n5S8lWwaissea3+XL14MyiiqX72AZ0bFl1HN+SM9
        AKW64SMAxsUsx9T0pTirZhDCGhULbbreEEROHS4psAjSq6NBr8Bx6rdOelxM41d1ZuRRuDftNChMC
        VEEBVK2MiOwfhfF6/zkj/AJhu2agaIOXfVq7nBEiookEyd6jw56FSaG+htRN5B0k2mO/fMSiRt/82
        hu5ZxLIArLCWbevCZx2YI9Ya/BfwoZdbltsmd5iqKj3657EbSv5eezmXYMC73JBA+iBzwBfMU655k
        OF6GIw/w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0008BX-Ul; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rOL-Tg; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 12/35] x86/msi: Provide msi message shadow structs
Date:   Sat, 24 Oct 2020 22:35:12 +0100
Message-Id: <20201024213535.443185-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Create shadow structs with named bitfields for msi_msg data, address_lo and
address_hi and use them in the MSI message composer.

Provide a function to retrieve the destination ID. This could be inline,
but that'd create a circular header dependency.

[dwmw2: fix bitfields not all to be a union]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/msi.h  | 49 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c | 35 ++++++++++++++------------
 2 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index cd30013d15d3..322fd905da9c 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -9,4 +9,53 @@ typedef struct irq_alloc_info msi_alloc_info_t;
 int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 		    msi_alloc_info_t *arg);
 
+/* Structs and defines for the X86 specific MSI message format */
+
+typedef struct x86_msi_data {
+	u32	vector			:  8,
+		delivery_mode		:  3,
+		dest_mode_logical	:  1,
+		reserved		:  2,
+		active_low		:  1,
+		is_level		:  1;
+
+	u32	dmar_subhandle;
+} __attribute__ ((packed)) arch_msi_msg_data_t;
+#define arch_msi_msg_data	x86_msi_data
+
+typedef struct x86_msi_addr_lo {
+	union {
+		struct {
+			u32	reserved_0		:  2,
+				dest_mode_logical	:  1,
+				redirect_hint		:  1,
+				reserved_1		:  8,
+				destid_0_7		:  8,
+				base_address		: 12;
+		};
+		struct {
+			u32	dmar_reserved_0		:  2,
+				dmar_index_15		:  1,
+				dmar_subhandle_valid	:  1,
+				dmar_format		:  1,
+				dmar_index_0_14		: 15,
+				dmar_base_address	: 12;
+		};
+	};
+} __attribute__ ((packed)) arch_msi_msg_addr_lo_t;
+#define arch_msi_msg_addr_lo	x86_msi_addr_lo
+
+#define X86_MSI_BASE_ADDRESS_LOW	(0xfee00000 >> 20)
+
+typedef struct x86_msi_addr_hi {
+	u32	reserved		:  8,
+		destid_8_31		: 24;
+} __attribute__ ((packed)) arch_msi_msg_addr_hi_t;
+#define arch_msi_msg_addr_hi	x86_msi_addr_hi
+
+#define X86_MSI_BASE_ADDRESS_HIGH	(0)
+
+struct msi_msg;
+u32 x86_msi_msg_get_destid(struct msi_msg *msg, bool extid);
+
 #endif /* _ASM_X86_MSI_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4c15bf29ea2c..f7196ee0f005 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -50,7 +50,6 @@
 #include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
-#include <asm/msidef.h>
 #include <asm/mtrr.h>
 #include <asm/time.h>
 #include <asm/smp.h>
@@ -2484,22 +2483,16 @@ int hard_smp_processor_id(void)
 void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
 			   bool dmar)
 {
-	msg->address_hi = MSI_ADDR_BASE_HI;
+	memset(msg, 0, sizeof(*msg));
 
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		(apic->dest_mode_logical ?
-			MSI_ADDR_DEST_MODE_LOGICAL :
-			MSI_ADDR_DEST_MODE_PHYSICAL) |
-		MSI_ADDR_REDIRECTION_CPU |
-		MSI_ADDR_DEST_ID(cfg->dest_apicid);
+	msg->arch_addr_lo.base_address = X86_MSI_BASE_ADDRESS_LOW;
+	msg->arch_addr_lo.dest_mode_logical = apic->dest_mode_logical;
+	msg->arch_addr_lo.destid_0_7 = cfg->dest_apicid & 0xFF;
 
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		MSI_DATA_DELIVERY_FIXED |
-		MSI_DATA_VECTOR(cfg->vector);
+	msg->arch_data.delivery_mode = APIC_DELIVERY_MODE_FIXED;
+	msg->arch_data.vector = cfg->vector;
 
+	msg->address_hi = X86_MSI_BASE_ADDRESS_HIGH;
 	/*
 	 * Only the IOMMU itself can use the trick of putting destination
 	 * APIC ID into the high bits of the address. Anything else would
@@ -2507,11 +2500,21 @@ void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
 	 * address higher APIC IDs.
 	 */
 	if (dmar)
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
+		msg->arch_addr_hi.destid_8_31 = cfg->dest_apicid >> 8;
 	else
-		WARN_ON_ONCE(MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid));
+		WARN_ON_ONCE(cfg->dest_apicid > 0xFF);
 }
 
+u32 x86_msi_msg_get_destid(struct msi_msg *msg, bool extid)
+{
+	u32 dest = msg->arch_addr_lo.destid_0_7;
+
+	if (extid)
+		dest |= msg->arch_addr_hi.destid_8_31 << 8;
+	return dest;
+}
+EXPORT_SYMBOL_GPL(x86_msi_msg_get_destid);
+
 /*
  * Override the generic EOI implementation with an optimized version.
  * Only called during early boot when only one CPU is active and with
-- 
2.26.2

