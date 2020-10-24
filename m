Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25395297F08
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764752AbgJXVgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764741AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D3C0613E5;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SjJIzmWg+Wc6S8qtF7/MOirYPL9xDxO1aChj88JyVCc=; b=EW6tOMQ/neq7AaP/90HgvlSmKn
        zlTviMuIhJxs+80X4JfSEZyj9rP4dE/hnA8V5Z2/7ezQCFUT2DEkhiR0l0Nak6zPLwBIkE6G9y7mJ
        ttW/7Qfwx5gt+Sw4+OKGpplY+pAJWcVIQfP69qXMGLjjzu/SDwbYPrmmO8ZKhOnr+pu0ywZD0xNDQ
        VqjEPiwNGNQp+qMszdxVwTm1147Mr68fOA+V80KjQnPwCwjOQxOEOlZv4LjVnfDVRF0A2HZS5L5+A
        TiRxOGFJQBUI/KAy5ECjC7LS2LKbPUTr93VpUSEeIC+E7mHotJ3jIU+DRGrYAuLFFyNq8mYhd1G9e
        aP2Kx4HA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HK-RX; Sat, 24 Oct 2020 21:35:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPS-CO; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 29/35] x86: Kill all traces of irq_remapping_get_irq_domain()
Date:   Sat, 24 Oct 2020 22:35:29 +0100
Message-Id: <20201024213535.443185-30-dwmw2@infradead.org>
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

All users are converted to use the fwspec based parent domain lookup.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h        |  2 --
 arch/x86/include/asm/irq_remapping.h |  9 --------
 drivers/iommu/amd/iommu.c            | 34 ----------------------------
 drivers/iommu/hyperv-iommu.c         |  9 --------
 drivers/iommu/intel/irq_remapping.c  | 17 --------------
 drivers/iommu/irq_remapping.c        | 14 ------------
 drivers/iommu/irq_remapping.h        |  3 ---
 7 files changed, 88 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 83a69f62637e..458f5a676402 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -40,8 +40,6 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_PCI_MSIX,
 	X86_IRQ_ALLOC_TYPE_DMAR,
 	X86_IRQ_ALLOC_TYPE_UV,
-	X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT,
-	X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT,
 };
 
 struct ioapic_alloc_info {
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index af4a151d70b3..7cc49432187f 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -44,9 +44,6 @@ extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
 extern void panic_if_irq_remap(const char *msg);
 
-extern struct irq_domain *
-irq_remapping_get_irq_domain(struct irq_alloc_info *info);
-
 /* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
 extern struct irq_domain *
 arch_create_remap_msi_irq_domain(struct irq_domain *par, const char *n, int id);
@@ -71,11 +68,5 @@ static inline void panic_if_irq_remap(const char *msg)
 {
 }
 
-static inline struct irq_domain *
-irq_remapping_get_irq_domain(struct irq_alloc_info *info)
-{
-	return NULL;
-}
-
 #endif /* CONFIG_IRQ_REMAP */
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 31b22244e9c2..463d322a4f3b 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3601,10 +3601,8 @@ static int get_devid(struct irq_alloc_info *info)
 {
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC:
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
 		return get_ioapic_devid(info->devid);
 	case X86_IRQ_ALLOC_TYPE_HPET:
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
 		return get_hpet_devid(info->devid);
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
@@ -3615,44 +3613,12 @@ static int get_devid(struct irq_alloc_info *info)
 	}
 }
 
-static struct irq_domain *get_irq_domain_for_devid(struct irq_alloc_info *info,
-						   int devid)
-{
-	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
-
-	if (!iommu)
-		return NULL;
-
-	switch (info->type) {
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
-		return iommu->ir_domain;
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-}
-
-static struct irq_domain *get_irq_domain(struct irq_alloc_info *info)
-{
-	int devid;
-
-	if (!info)
-		return NULL;
-
-	devid = get_devid(info);
-	if (devid < 0)
-		return NULL;
-	return get_irq_domain_for_devid(info, devid);
-}
-
 struct irq_remap_ops amd_iommu_irq_ops = {
 	.prepare		= amd_iommu_prepare,
 	.enable			= amd_iommu_enable,
 	.disable		= amd_iommu_disable,
 	.reenable		= amd_iommu_reenable,
 	.enable_faulting	= amd_iommu_enable_faulting,
-	.get_irq_domain		= get_irq_domain,
 };
 
 static void fill_msi_msg(struct msi_msg *msg, u32 index)
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 78a264ad9405..a629a6be65c7 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -160,18 +160,9 @@ static int __init hyperv_enable_irq_remapping(void)
 	return IRQ_REMAP_X2APIC_MODE;
 }
 
-static struct irq_domain *hyperv_get_irq_domain(struct irq_alloc_info *info)
-{
-	if (info->type == X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT)
-		return ioapic_ir_domain;
-	else
-		return NULL;
-}
-
 struct irq_remap_ops hyperv_irq_remap_ops = {
 	.prepare		= hyperv_prepare_irq_remapping,
 	.enable			= hyperv_enable_irq_remapping,
-	.get_irq_domain		= hyperv_get_irq_domain,
 };
 
 #endif
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index b3b079c0b51e..bca44015bc1d 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1127,29 +1127,12 @@ static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
 	irte->redir_hint = 1;
 }
 
-static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info)
-{
-	if (!info)
-		return NULL;
-
-	switch (info->type) {
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
-		return map_ioapic_to_ir(info->devid);
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
-		return map_hpet_to_ir(info->devid);
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-}
-
 struct irq_remap_ops intel_irq_remap_ops = {
 	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
-	.get_irq_domain		= intel_get_irq_domain,
 };
 
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 2d84b1ed205e..83314b9d8f38 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -158,17 +158,3 @@ void panic_if_irq_remap(const char *msg)
 	if (irq_remapping_enabled)
 		panic(msg);
 }
-
-/**
- * irq_remapping_get_irq_domain - Get the irqdomain serving the request @info
- * @info: interrupt allocation information, used to identify the IOMMU device
- *
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *irq_remapping_get_irq_domain(struct irq_alloc_info *info)
-{
-	if (!remap_ops || !remap_ops->get_irq_domain)
-		return NULL;
-
-	return remap_ops->get_irq_domain(info);
-}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 1661b3d75920..8c89cb947cdb 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -42,9 +42,6 @@ struct irq_remap_ops {
 
 	/* Enable fault handling */
 	int  (*enable_faulting)(void);
-
-	/* Get the irqdomain associated to IOMMU device */
-	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
 };
 
 extern struct irq_remap_ops intel_irq_remap_ops;
-- 
2.26.2

