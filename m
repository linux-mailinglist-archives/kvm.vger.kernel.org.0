Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16328F83E
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbgJOSOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 14:14:21 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39982 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgJOSOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Oct 2020 14:14:21 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6A27B200780;
        Thu, 15 Oct 2020 20:14:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5E0FC200608;
        Thu, 15 Oct 2020 20:14:19 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 10C3A20309;
        Thu, 15 Oct 2020 20:14:19 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        colin.king@canonical.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH] vfio/fsl-mc: Fix the dead code in vfio_fsl_mc_set_irq_trigger
Date:   Thu, 15 Oct 2020 21:14:17 +0300
Message-Id: <20201015181417.28427-1-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Static analysis discovered that some code in vfio_fsl_mc_set_irq_trigger
is dead code. Fixed the code by changing the conditions order.

Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index 2ce2acad3461..c80dceb46f79 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -114,6 +114,9 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
 	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
 
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
+		return vfio_set_trigger(vdev, index, -1);
+
 	if (start != 0 || count != 1)
 		return -EINVAL;
 
@@ -128,9 +131,6 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 		goto unlock;
 	mutex_unlock(&vdev->reflck->lock);
 
-	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
-		return vfio_set_trigger(vdev, index, -1);
-
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		s32 fd = *(s32 *)data;
 
-- 
2.17.1

