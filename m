Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE3297F12
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764889AbgJXVhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764740AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26424C0613E4;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DBXQeOdNuSbK9uNqJUHpNvc0pB1QrhBTIryIhIif25g=; b=CgD2OtSg5phvJF0lzasncrO8uK
        xA3V4sVprblWZiPp63cQPaMPcYuLnJGTih31/fVNFD1rH+tIIRwvVaPEG1LvZ5nllrQ4EcQpOvLUR
        ceZy7a+JEuxUda0Q4m+WCpk78ZgOvQoDs9GnJfNdjUKuD9aJebLjkCl9LjpzBP9/T4wdJGePVbaJW
        dg/UhMqKHT287Dbnj1d5E8ewf+s8+XRKjlEk5khlLpraUmK+PIjYTuEtCu3EoKK0tPU6hkrzdQ62U
        RP58JV+MMOm6BNkIvg2mqE0h6s9X9HcC4qZnFzePZ1PXXfLyOKwsbhETxfoepVki0OSGjBjBZIFj+
        Wge9wkrw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HH-Ne; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rP8-8j; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 24/35] iommu/amd: Implement select() method on remapping irqdomain
Date:   Sat, 24 Oct 2020 22:35:24 +0100
Message-Id: <20201024213535.443185-25-dwmw2@infradead.org>
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

Preparatory change to remove irq_remapping_get_irq_domain().

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/amd/iommu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 9744cdbefd88..31b22244e9c2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3882,7 +3882,26 @@ static void irq_remapping_deactivate(struct irq_domain *domain,
 					    irte_info->index);
 }
 
+static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *fwspec,
+				enum irq_domain_bus_token bus_token)
+{
+	struct amd_iommu *iommu;
+	int devid = -1;
+
+	if (x86_fwspec_is_ioapic(fwspec))
+		devid = get_ioapic_devid(fwspec->param[0]);
+	else if (x86_fwspec_is_hpet(fwspec))
+		devid = get_hpet_devid(fwspec->param[0]);
+
+	if (devid < 0)
+		return 0;
+
+	iommu = amd_iommu_rlookup_table[devid];
+	return iommu && iommu->ir_domain == d;
+}
+
 static const struct irq_domain_ops amd_ir_domain_ops = {
+	.select = irq_remapping_select,
 	.alloc = irq_remapping_alloc,
 	.free = irq_remapping_free,
 	.activate = irq_remapping_activate,
-- 
2.26.2

