Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1592839E0
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgJEP3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbgJEP3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:00 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A1BC0613AB;
        Mon,  5 Oct 2020 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lyPVYoaHwjsnXkUEZdaJkJjqQjrE8gIBWZLSCTwUPec=; b=HDro/TSE0gHgkjLa+dMb+opTsu
        1Pf+l+eTRn/SyozTcLUce7ta2RjiO0QaPOqbJr4jCRRD76UQ8mY8Cne6SuOCz6fRFve3NjUsjhq4E
        E6gwj2nLMCBQecPTaILWdLnM56SCqhIjFTjTwJm2yT25tpt2DU0Fy8H7DsOZeDXq1gSDKP08VvwC2
        DHvwN/D9vYHRd/q6avT1m97D8SNm+uRAlsxiej0lk1mm9oT98NaQrlzSVpNzW7gwhZ/Re9JbvcB0n
        zHQCsM8XP83YSinl1XYBoDjXNmZoXccNAdMZZ1Jvbj3zf44KYkp2cqjDbXGpbeqa+vGxrTPKTDIZR
        lB9fQeyg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ5-0004MI-99; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045QG-8R; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 02/13] x86/msi: Only use high bits of MSI address for DMAR unit
Date:   Mon,  5 Oct 2020 16:28:45 +0100
Message-Id: <20201005152856.974112-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
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
adding a WARN_ON_ONCE() if other MSIs are targeted at an unreachable APIC
ID. That should never happen since the legacy MSI messages are not supposed
to be used with Interrupt Remapping enabled.

The x2apic_enabled() check isn't needed because we won't bring up CPUs
with higher APIC IDs unless x2apic is enabled anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/msi.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6313f0a05db7..356f8acf4927 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -23,13 +23,10 @@
 
 struct irq_domain *x86_pci_msi_default_domain __ro_after_init;
 
-static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
+static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg, int dmar)
 {
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
-	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
-
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
 		((apic->irq_dest_mode == 0) ?
@@ -43,18 +40,42 @@ static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 		MSI_DATA_LEVEL_ASSERT |
 		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(cfg->vector);
+
+	/*
+	 * Only the IOMMU itself can use the trick of putting destination
+	 * APIC ID into the high bits of the address. Anything else would
+	 * just be writing to memory if it tried that, and needs IR to
+	 * address APICs above 255.
+	 */
+	if (dmar)
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
+	else
+		WARN_ON_ONCE(MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid));
 }
 
 void x86_vector_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	__irq_msi_compose_msg(irqd_cfg(data), msg);
+	__irq_msi_compose_msg(irqd_cfg(data), msg, 0);
 }
 
+/*
+ * The Intel IOMMU (ab)uses the high bits of the MSI address to contain the
+ * high bits of the destination APIC ID. This can't be done in the general
+ * case for MSIs as it would be targeting real memory above 4GiB not the
+ * APIC.
+ */
+static void dmar_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	__irq_msi_compose_msg(irqd_cfg(data), msg, 1);
+
+
+
+}
 static void irq_msi_update_msg(struct irq_data *irqd, struct irq_cfg *cfg)
 {
 	struct msi_msg msg[2] = { [1] = { }, };
 
-	__irq_msi_compose_msg(cfg, msg);
+	__irq_msi_compose_msg(cfg, msg, 0);
 	irq_data_get_irq_chip(irqd)->irq_write_msi_msg(irqd, msg);
 }
 
@@ -288,6 +309,7 @@ static struct irq_chip dmar_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_compose_msi_msg	= dmar_msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
-- 
2.26.2

