Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6106288748
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbgJIKrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387790AbgJIKq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:46:27 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AFCC0613DA;
        Fri,  9 Oct 2020 03:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nIfuILCsIGon8Erk55Ntq680fWPgiNl5Dn9hBdKaUu8=; b=GZjnKez0xwYHxC+pKfa6q70uxS
        SAUEa/jjusT371+OcJpvssYY+kBwmE7vdcSXSVX8j5hjkPbZr2shwiqQVN5nLrXji01SQM2OnkJDq
        pB7SCCmyOl/G5qtDG2CzQIzfm9tB5fQmwQLD21ZP0pKliWlyVFMAydSIO2eqyfI1EZzzdSWhxJ97B
        NbRidNxyhdKW9mJCHpkRMQzFUcLXOKjO1iHgZKCoICKo37bSGn//hyo85VDzzLja69HGHop2SvjhL
        SCNFE2E04erSzO1+4RnnG271RVETdP5oRUGOO+XG30ekfnnAcvzqHV9OmRnC7X57UBuzN7gF4KvF8
        9S1V/t0g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQpuq-00050U-2Y; Fri, 09 Oct 2020 10:46:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kQpup-005W3z-1t; Fri, 09 Oct 2020 11:46:23 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 2/8] x86/msi: Only use high bits of MSI address for DMAR unit
Date:   Fri,  9 Oct 2020 11:46:10 +0100
Message-Id: <20201009104616.1314746-3-dwmw2@infradead.org>
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

The Intel IOMMU has an MSI-like configuration for its interrupt, but
it isn't really MSI. So it gets to abuse the high 32 bits of the address,
and puts the high 24 bits of the extended APIC ID there.

This isn't something that can be used in the general case for real MSIs,
since external devices using the high bits of the address would be
performing writes to actual memory space above 4GiB, not targeted at the
APIC.

Factor the hack out and allow it only to be used when appropriate,
adding a WARN_ON_ONCE() if other MSIs are targeted at an unreachable
APIC ID. That should never happen since the compatibility MSI messages
are not used when Interrupt Remapping is enabled.

The x2apic_enabled() check isn't needed because Linux won't bring up
CPUs with higher APIC IDs unless IR and x2apic are enabled anyway.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/msi.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6313f0a05db7..516df47bde73 100644
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
@@ -43,18 +41,29 @@ static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg)
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
 }
 
 static void irq_msi_update_msg(struct irq_data *irqd, struct irq_cfg *cfg)
 {
 	struct msi_msg msg[2] = { [1] = { }, };
 
-	__irq_msi_compose_msg(cfg, msg);
+	__irq_msi_compose_msg(cfg, msg, false);
 	irq_data_get_irq_chip(irqd)->irq_write_msi_msg(irqd, msg);
 }
 
@@ -276,6 +285,17 @@ struct irq_domain *arch_create_remap_msi_irq_domain(struct irq_domain *parent,
 #endif
 
 #ifdef CONFIG_DMAR_TABLE
+/*
+ * The Intel IOMMU (ab)uses the high bits of the MSI address to contain the
+ * high bits of the destination APIC ID. This can't be done in the general
+ * case for MSIs as it would be targeting real memory above 4GiB not the
+ * APIC.
+ */
+static void dmar_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	__irq_msi_compose_msg(irqd_cfg(data), msg, true);
+}
+
 static void dmar_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	dmar_msi_write(data->irq, msg);
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

