Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB904285EF7
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgJGMUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 08:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgJGMUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 08:20:49 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D2C061755;
        Wed,  7 Oct 2020 05:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cNgotZdjiIhAs7j/ixWpCy1UlcLX0MFDuxjv5x5yEEc=; b=0TV4f2leaW99tqzJK6ROTbbswN
        HX0dVFJiTwWHCk2YSvyFm7KiAkBAXfDR9rsO/6AOv/+qZ874rGxq8osPuUlBprDiokcYDbqXRG+sW
        xO7rZtO+WI/XF+xWM92o0YrUFBhMpwz5lBZDOqlla3NDrimXAHv1BYrN34j4f2lKXbyTx5+nJel+B
        ITdaXdA9rMPBXbp+KfC7bTCZbIp0znVPD9k3S1yiyo+LRwozn9Xr+kQDLM1keMDxskFIrCTBYOMK4
        AlPFZqObSBYUjBbuKilE4r6q9gu9OHHI3Bk9YsUdTE7Xcvwx03LnGQrbQ3oQurN3J+E2Z8ZwgQoGj
        CKB49k2Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQ8R5-000803-JN; Wed, 07 Oct 2020 12:20:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kQ8R4-004fhh-I5; Wed, 07 Oct 2020 13:20:46 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] x86/msi: Only use high bits of MSI address for DMAR unit
Date:   Wed,  7 Oct 2020 13:20:43 +0100
Message-Id: <20201007122046.1113577-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007122046.1113577-1-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201007122046.1113577-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The Intel IOMMU has an MSI-like configuration for its interrupt, but
it isn't really MSI. So it gets to abuse the high 32 bits of the address,
and puts the high 24 bits of the extended APIC ID there.

This isn't something that can be used in the general case for real MSIs,
since external devices using the high bits of the address would be
performing writes to actual memory space above 4GiB, not targeted at the
APIC.

Factor the hack out and allow it only to be used when appropriate,
adding a WARN_ON_ONCE() if other MSIs are targeted at an unreachable
APIC ID. In *theory* that should never happen since the compatibility
MSI messages are not supposed to be used with Interrupt Remapping
enabled. In practice, if IR is enabled but some devices aren't within
scope of any given remapping unit, it might happen. But that's a longer
story and this warning is the right thing to do in that case for the
short term.

The x2apic_enabled() check isn't needed because Linux won't bring up
CPUs with higher APIC IDs unless x2apic is enabled anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/msi.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6313f0a05db7..2825e003259c 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -23,13 +23,11 @@
 
 struct irq_domain *x86_pci_msi_default_domain __ro_after_init;
 
-static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
+static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
+				  bool dmar)
 {
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
-	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
-
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
 		((apic->irq_dest_mode == 0) ?
@@ -43,18 +41,40 @@ static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 		MSI_DATA_LEVEL_ASSERT |
 		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(cfg->vector);
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
 }
 
 void x86_vector_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	__irq_msi_compose_msg(irqd_cfg(data), msg);
+	__irq_msi_compose_msg(irqd_cfg(data), msg, false);
+}
+
+/*
+ * The Intel IOMMU (ab)uses the high bits of the MSI address to contain the
+ * high bits of the destination APIC ID. This can't be done in the general
+ * case for MSIs as it would be targeting real memory above 4GiB not the
+ * APIC.
+ */
+static void dmar_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	__irq_msi_compose_msg(irqd_cfg(data), msg, true);
 }
 
 static void irq_msi_update_msg(struct irq_data *irqd, struct irq_cfg *cfg)
 {
 	struct msi_msg msg[2] = { [1] = { }, };
 
-	__irq_msi_compose_msg(cfg, msg);
+	__irq_msi_compose_msg(cfg, msg, 0);
 	irq_data_get_irq_chip(irqd)->irq_write_msi_msg(irqd, msg);
 }
 
@@ -288,6 +308,7 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_compose_msi_msg	= dmar_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
-- 
2.26.2

