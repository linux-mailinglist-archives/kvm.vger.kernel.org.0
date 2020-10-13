Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707E528C9D8
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390721AbgJMILv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390417AbgJMILs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:11:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1475C0613D0;
        Tue, 13 Oct 2020 01:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mD7ATGAMxZC0gKwRSGwBx1Sd38JSaE1OrctSWtMO/Nw=; b=YfjkjVDUXEFc594Qink8xaelhX
        E+oh3IA4i1xMeFcAtC6cLLOpQRZcgamcubpuF4IpY8gAM/Fi4WyVBwVWImF6DwEG5zTe90X0ER2QN
        3fk+IlGs7Y0XK6pfIA3mT4aHq03bSnoFVzZQT/Lot33TUj7ZhVLYtwp1tTkh1NieQWQS6VmETIzzv
        xNpznNGZAF6tacPJM5kRKF2GBMw3KReJpcZuR+ZMXULzp37GBKwF5GS6PZ0H2c/TXI2BBPpPzA9Kr
        F9VU3VxkP+NlSZedlR8KH9g9k8+/rqz/TLW8MkX7FIyl+OU4LmFKkrwMdH0ge3Yp8W6Cg+hM9Gs+/
        ANvXiwtQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPN-0005sX-E1; Tue, 13 Oct 2020 08:11:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXW-Dg; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 3/9] iommu/amd: Implement select() method on remapping irqdomain
Date:   Tue, 13 Oct 2020 09:11:33 +0100
Message-Id: <20201013081139.1558200-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013081139.1558200-1-dwmw2@infradead.org>
References: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <20201013081139.1558200-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/amd/iommu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 13d0a8f42d56..7ecebc5d255f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3590,6 +3590,24 @@ struct irq_remap_ops amd_iommu_irq_ops = {
 	.get_irq_domain		= get_irq_domain,
 };
 
+static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *fwspec,
+				enum irq_domain_bus_token bus_token)
+{
+	struct amd_iommu *iommu;
+	int devid = -1;
+
+	if (x86_fwspec_is_ioapic(fwspec))
+		devid = get_ioapic_devid(fwspec->param[0]);
+	else if (x86_fwspec_is_ioapic(fwspec))
+		devid = get_hpet_devid(fwspec->param[0]);
+
+	if (devid < 0)
+		return 0;
+
+	iommu = amd_iommu_rlookup_table[devid];
+	return iommu && iommu->ir_domain == d;
+}
+
 static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 				       struct irq_cfg *irq_cfg,
 				       struct irq_alloc_info *info,
@@ -3813,6 +3831,7 @@ static void irq_remapping_deactivate(struct irq_domain *domain,
 }
 
 static const struct irq_domain_ops amd_ir_domain_ops = {
+	.select = irq_remapping_select,
 	.alloc = irq_remapping_alloc,
 	.free = irq_remapping_free,
 	.activate = irq_remapping_activate,
-- 
2.26.2

