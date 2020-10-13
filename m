Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD58828C9E8
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbgJMIM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391064AbgJMIMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:12:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1312BC0613D6;
        Tue, 13 Oct 2020 01:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vSHMa7280Wak9ZJPalSvwueQQ62GFEXDZRJeNiRWtnk=; b=INRSEj3QtmaKBv3OHSiSVHNggy
        v62HsyDuLQ56pLZwpTDounBJSC0K2lodvD3UJd9547ZYtE0OyENqPeZjVixyhrA+fOJNA/XiZobv3
        YYk5min7ZUloynMa50Zt9PI016gOY3uF7UIaSEYsuHWFCKjO/waia2WQlvG3zRtkKRTK6VBzsvqzW
        SJBRezinPDZHlRYPHC/pSJ5NN74M6OuSQiTHuc2cFdkIkB4DSfxVj778fICXoPEPF6VaV0nHD7x1+
        6FOlzQKFCQXldLuHBsexHpOGWuORKpDXtdSbtuYz9wYNti34aPMw1Q6ttSfGZ8xz2LiR4Ldce7CtM
        oPXuYAfg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPN-0006fT-1u; Tue, 13 Oct 2020 08:12:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XY0-Hx; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 9/9] iommu/vt-d: Simplify intel_irq_remapping_select()
Date:   Tue, 13 Oct 2020 09:11:39 +0100
Message-Id: <20201013081139.1558200-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013081139.1558200-1-dwmw2@infradead.org>
References: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <20201013081139.1558200-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Now that the old get_irq_domain() method has gone, we can consolidate on
just the map_XXX_to_iommu() functions.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/intel/irq_remapping.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index ccf61cd18f69..8a41bcb10e26 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -204,13 +204,13 @@ static int modify_irte(struct irq_2_iommu *irq_iommu,
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
@@ -226,13 +226,6 @@ static struct intel_iommu *map_ioapic_to_iommu(int apic)
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
@@ -1422,12 +1415,14 @@ static int intel_irq_remapping_select(struct irq_domain *d,
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

