Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBE2DDE4D
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 07:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgLRGBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 01:01:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9538 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLRGBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 01:01:43 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cxyrk026gzhrg4;
        Fri, 18 Dec 2020 14:00:22 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 18 Dec 2020 14:00:50 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <tglx@linutronix.de>
CC:     <kvm@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] genirq/msi: Initialize msi_alloc_info to zero for msi_prepare API
Date:   Fri, 18 Dec 2020 14:00:39 +0800
Message-ID: <20201218060039.1770-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit 5fe71d271df8 ("irqchip/gic-v3-its: Tag ITS device as shared if
allocating for a proxy device"), some of the devices are wrongly marked as
"shared" by the ITS driver on systems equipped with the ITS(es). The
problem is that the @info->flags may not be initialized anywhere and we end
up looking at random bits on the stack. That's obviously not good.

The straightforward fix is to properly initialize msi_alloc_info inside the
.prepare callback of affected MSI domains (its-pci-msi, its-platform-msi,
etc). We can also perform the initialization in IRQ core layer for
msi_domain_prepare_irqs() API and it looks much neater to me.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

This was noticed when I was playing with the assigned devices on arm64 and
VFIO failed to enable MSI-X vectors for almost all VFs (CCed kvm list in
case others will hit the same issue). It turned out that these VFs are
marked as "shared" by mistake and have trouble with the following sequence:

	pci_alloc_irq_vectors(pdev, 1, 1, flag);
	pci_free_irq_vectors(pdev);
	pci_alloc_irq_vectors(pdev, 1, 2, flag); --> we can only get
						     *one* vector

But besides VFIO, I guess there are already some devices get into trouble
at probe time and can't work properly.

 kernel/irq/msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 2c0c4d6d0f83..dc0e2d7fbdfd 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -402,7 +402,7 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 	struct msi_domain_ops *ops = info->ops;
 	struct irq_data *irq_data;
 	struct msi_desc *desc;
-	msi_alloc_info_t arg;
+	msi_alloc_info_t arg = { };
 	int i, ret, virq;
 	bool can_reserve;
 
-- 
2.19.1

