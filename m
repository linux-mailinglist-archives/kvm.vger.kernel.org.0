Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86B428C6FC
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 04:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgJMCAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 22:00:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15205 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728492AbgJMCAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 22:00:21 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6723A2474EE92E0AD1B6;
        Tue, 13 Oct 2020 10:00:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 13 Oct 2020 10:00:10 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <song.bao.hua@hisilicon.com>
CC:     <linuxarm@huawei.com>
Subject: [PATCH] vfio/platform: Replace spin_lock_irqsave by spin_lock in hard IRQ
Date:   Tue, 13 Oct 2020 10:00:58 +0800
Message-ID: <1602554458-26927-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is redundant to do irqsave and irqrestore in hardIRQ context.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/vfio/platform/vfio_platform_irq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c5b09ec..24fd6c5 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -139,10 +139,9 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
-	unsigned long flags;
 	int ret = IRQ_NONE;
 
-	spin_lock_irqsave(&irq_ctx->lock, flags);
+	spin_lock(&irq_ctx->lock);
 
 	if (!irq_ctx->masked) {
 		ret = IRQ_HANDLED;
@@ -152,7 +151,7 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
 		irq_ctx->masked = true;
 	}
 
-	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+	spin_unlock(&irq_ctx->lock);
 
 	if (ret == IRQ_HANDLED)
 		eventfd_signal(irq_ctx->trigger, 1);
-- 
2.7.4

