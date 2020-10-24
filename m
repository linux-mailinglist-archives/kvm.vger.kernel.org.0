Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BB9297F13
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764954AbgJXVhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764736AbgJXVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388BFC0613E1;
        Sat, 24 Oct 2020 14:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JW78knbqw7EYlsJkBZcRrOydz/oXelrB7ardJZkkdqY=; b=PDezbMGPDWtFQXHB+z5YGGVwLN
        zhLBtlAB6feibtgg4eZNFkMHrHmcZq9SSnLxL6dz/yGWZaAxjGJfHl6v5ZgVCzPLx50aWH/3ms3nc
        GsLcLCVvoKVE1xH15H2z/U1dXe6rJI9ZtCFuTJk6N36otUqtnu+pvC4tfF+kZhrGdE8SGXCIVXpSH
        5LCoGCRTCSO+TrYjBEjAev+qpIJ/sbQhCMlkoj0k4FH2enFmpSKvxbfGqX89igqJPI02szLf56AJR
        FmlDK+SiUwPF4WfhqkIYeGokwj0XLGoqe4swfWKDqgeAv8e9/9jmMjrZJgljMaA0SNeH+XaB4+Lh3
        8BhwKgxQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HD-Gm; Sat, 24 Oct 2020 21:35:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rOf-1P; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 17/35] x86/pci/xen: Use msi_msg shadow structs
Date:   Sat, 24 Oct 2020 22:35:17 +0100
Message-Id: <20201024213535.443185-18-dwmw2@infradead.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

Use the msi_msg shadow structs and compose the message with named bitfields
instead of the unreadable macro maze.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/pci/xen.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index c552cd2d0632..3d41a09c2c14 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -152,7 +152,6 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
-#include <asm/msidef.h>
 
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
@@ -210,23 +209,20 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	return ret;
 }
 
-#define XEN_PIRQ_MSI_DATA  (MSI_DATA_TRIGGER_EDGE | \
-		MSI_DATA_LEVEL_ASSERT | (3 << 8) | MSI_DATA_VECTOR(0))
-
 static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
 		struct msi_msg *msg)
 {
-	/* We set vector == 0 to tell the hypervisor we don't care about it,
-	 * but we want a pirq setup instead.
-	 * We use the dest_id field to pass the pirq that we want. */
-	msg->address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(pirq);
-	msg->address_lo =
-		MSI_ADDR_BASE_LO |
-		MSI_ADDR_DEST_MODE_PHYSICAL |
-		MSI_ADDR_REDIRECTION_CPU |
-		MSI_ADDR_DEST_ID(pirq);
-
-	msg->data = XEN_PIRQ_MSI_DATA;
+	/*
+	 * We set vector == 0 to tell the hypervisor we don't care about
+	 * it, but we want a pirq setup instead.  We use the dest_id fields
+	 * to pass the pirq that we want.
+	 */
+	memset(msg, 0, sizeof(*msg));
+	msg->address_hi = X86_MSI_BASE_ADDRESS_HIGH;
+	msg->arch_addr_hi.destid_8_31 = pirq >> 8;
+	msg->arch_addr_lo.destid_0_7 = pirq & 0xFF;
+	msg->arch_addr_lo.base_address = X86_MSI_BASE_ADDRESS_LOW;
+	msg->arch_data.delivery_mode = APIC_DELIVERY_MODE_EXTINT;
 }
 
 static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-- 
2.26.2

