Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535BA297EFB
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764833AbgJXVgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764744AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0082EC061787;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rRBPjTVV0ZOTPMxFXL1DflibnJyEB+1NPLg1fUvp6iE=; b=LV5fmz/vx1aIK0Lx5EwSFNH0MJ
        sA3O/ZDA11TTMkM3LsNOQkdLE32BK/BHninErmYL2GLGx3J8QTnBvhGeNhQElbJWiQjM+9UGihbQH
        NSa6EJAy6n81Epvb74tBCYecakcu4DVzgwqam0Tr5FLKRJ4XU3gcIi5e7YsWnYXbnyuM9ZfNT8xAj
        Er7Hrg3cC6gSe4QcNPgTu55+P5bYXLVo5+kND3YY/QtN9TAtdyRV7Tuwkl3uwFzx0/IWubS9YTprj
        RE1ztyYK8Pw5Z7V9qf1djFHVdy0ZxEaSHvNN3AKoY2KvmQ2mDAjVqjhHzfrmvh6Mdw5YECnRfPRPk
        cPLVNAxg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HL-Tw; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPW-DE; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 30/35] iommu/vt-d: Simplify intel_irq_remapping_select()
Date:   Sat, 24 Oct 2020 22:35:30 +0100
Message-Id: <20201024213535.443185-31-dwmw2@infradead.org>
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

Now that the old get_irq_domain() method has gone, consolidate on just the
map_XXX_to_iommu() functions.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel/irq_remapping.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index bca44015bc1d..aeffda92b10b 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -203,13 +203,13 @@ static int modify_irte(struct irq_2_iommu *irq_iommu,
 	return rc;
 }
 
-static struct irq_domain *map_hpet_to_ir(u8 hpet_id)
+static struct intel_iommu *map_hpet_to_iommu(u8 hpet_id)
 {
 	int i;
 
 	for (i = 0; i < MAX_HPET_TBS; i++) {
 		if (ir_hpet[i].id == hpet_id && ir_hpet[i].iommu)
-			return ir_hpet[i].iommu->ir_domain;
+			return ir_hpet[i].iommu;
 	}
 	return NULL;
 }
@@ -225,13 +225,6 @@ static struct intel_iommu *map_ioapic_to_iommu(int apic)
 	return NULL;
 }
 
-static struct irq_domain *map_ioapic_to_ir(int apic)
-{
-	struct intel_iommu *iommu = map_ioapic_to_iommu(apic);
-
-	return iommu ? iommu->ir_domain : NULL;
-}
-
 static struct irq_domain *map_dev_to_ir(struct pci_dev *dev)
 {
 	struct dmar_drhd_unit *drhd = dmar_find_matched_drhd_unit(dev);
@@ -1418,12 +1411,14 @@ static int intel_irq_remapping_select(struct irq_domain *d,
 				      struct irq_fwspec *fwspec,
 				      enum irq_domain_bus_token bus_token)
 {
+	struct intel_iommu *iommu = NULL;
+
 	if (x86_fwspec_is_ioapic(fwspec))
-		return d == map_ioapic_to_ir(fwspec->param[0]);
+		iommu = map_ioapic_to_iommu(fwspec->param[0]);
 	else if (x86_fwspec_is_hpet(fwspec))
-		return d == map_hpet_to_ir(fwspec->param[0]);
+		iommu = map_hpet_to_iommu(fwspec->param[0]);
 
-	return 0;
+	return iommu && d == iommu->ir_domain;
 }
 
 static const struct irq_domain_ops intel_ir_domain_ops = {
-- 
2.26.2

