Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6FD288740
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387895AbgJIKrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbgJIKq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:46:27 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A5C0613DB;
        Fri,  9 Oct 2020 03:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kuTqzhVG0LNb29VAmYWMEQAkS2Bnr6LWN3rexef6i8o=; b=iIrdS+ckQwuVrNYOdpqaSiorVa
        qRlO8pbCglkMo20YCllSvoOE5u4zgtkMjWA4qYSiU9GOJFFXaFHNS8tWwbQUyOchwBHerFPz0X2vq
        gWK+hn9D5dt94wn7AmtGs9X3SzdClWvYgNAsS++IGPB3Oeroid8KydreIG+VDCgk0sZA4vBbPj00r
        EtcB++wlrsEylsyMC5hqGZ0PiGo41x5lQK3GFy4OoVn5J86NPZGhRXCp+F2OTjhG7t/F4/Z39GEeT
        iHgD2ly7jm/pk/ojws6qtbdHpXhoFrhqrILAGOIMO/rTx7KhGGI+ToDhraDVjXoY4XTFRTq/OWAhO
        DVAD4PBg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQpuq-00050V-3M; Fri, 09 Oct 2020 10:46:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kQpup-005W44-2i; Fri, 09 Oct 2020 11:46:23 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 3/8] x86/apic: Always provide irq_compose_msi_msg() method for vector domain
Date:   Fri,  9 Oct 2020 11:46:11 +0100
Message-Id: <20201009104616.1314746-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009104616.1314746-1-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201009104616.1314746-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This shouldn't be dependent on PCI_MSI. HPET and I/OAPIC can deliver
interrupts through MSI without having any PCI in the system at all.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/apic.h   |  8 +++-----
 arch/x86/kernel/apic/apic.c   | 32 +++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/msi.c    | 36 -----------------------------------
 arch/x86/kernel/apic/vector.c |  6 ++++++
 4 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b0fd204e0023..f5b88fb723bf 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -521,12 +521,10 @@ static inline void apic_smt_update(void) { }
 #endif
 
 struct msi_msg;
+struct irq_cfg;
 
-#ifdef CONFIG_PCI_MSI
-void x86_vector_msi_compose_msg(struct irq_data *data, struct msi_msg *msg);
-#else
-# define x86_vector_msi_compose_msg NULL
-#endif
+extern void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
+				  bool dmar);
 
 extern void ioapic_zap_locks(void);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 113f6ca7b828..fba3ba383ad2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -50,6 +50,7 @@
 #include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
+#include <asm/msidef.h>
 #include <asm/mtrr.h>
 #include <asm/time.h>
 #include <asm/smp.h>
@@ -2480,6 +2481,37 @@ int hard_smp_processor_id(void)
 	return read_apic_id();
 }
 
+void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
+			   bool dmar)
+{
+	msg->address_hi = MSI_ADDR_BASE_HI;
+
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		((apic->irq_dest_mode == 0) ?
+			MSI_ADDR_DEST_MODE_PHYSICAL :
+			MSI_ADDR_DEST_MODE_LOGICAL) |
+		MSI_ADDR_REDIRECTION_CPU |
+		MSI_ADDR_DEST_ID(cfg->dest_apicid);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		MSI_DATA_DELIVERY_FIXED |
+		MSI_DATA_VECTOR(cfg->vector);
+
+	/*
+	 * Only the IOMMU itself can use the trick of putting destination
+	 * APIC ID into the high bits of the address. Anything else would
+	 * just be writing to memory if it tried that, and needs IR to
+	 * address higher APIC IDs.
+	 */
+	if (dmar)
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
+	else
+		WARN_ON_ONCE(MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid));
+}
+
 /*
  * Override the generic EOI implementation with an optimized version.
  * Only called during early boot when only one CPU is active and with
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 516df47bde73..de585cfa4d6c 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -23,42 +23,6 @@
 
 struct irq_domain *x86_pci_msi_default_domain __ro_after_init;
 
-static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
-				  bool dmar)
-{
-	msg->address_hi = MSI_ADDR_BASE_HI;
-
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		((apic->irq_dest_mode == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL :
-			MSI_ADDR_DEST_MODE_LOGICAL) |
-		MSI_ADDR_REDIRECTION_CPU |
-		MSI_ADDR_DEST_ID(cfg->dest_apicid);
-
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		MSI_DATA_DELIVERY_FIXED |
-		MSI_DATA_VECTOR(cfg->vector);
-
-	/*
-	 * Only the IOMMU itself can use the trick of putting destination
-	 * APIC ID into the high bits of the address. Anything else would
-	 * just be writing to memory if it tried that, and needs IR to
-	 * address higher APIC IDs.
-	 */
-	if (dmar)
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
-	else
-		WARN_ON_ONCE(MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid));
-}
-
-void x86_vector_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
-{
-	__irq_msi_compose_msg(irqd_cfg(data), msg, false);
-}
-
 static void irq_msi_update_msg(struct irq_data *irqd, struct irq_cfg *cfg)
 {
 	struct msi_msg msg[2] = { [1] = { }, };
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 1eac53632786..bb2e2a2488a5 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -818,6 +818,12 @@ void apic_ack_edge(struct irq_data *irqd)
 	apic_ack_irq(irqd);
 }
 
+static void x86_vector_msi_compose_msg(struct irq_data *data,
+				       struct msi_msg *msg)
+{
+       __irq_msi_compose_msg(irqd_cfg(data), msg, false);
+}
+
 static struct irq_chip lapic_controller = {
 	.name			= "APIC",
 	.irq_ack		= apic_ack_edge,
-- 
2.26.2

