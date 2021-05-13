Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E837F27A
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 07:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhEMFIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 01:08:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2650 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhEMFIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 01:08:19 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fgfh05KQ2zQmjK;
        Thu, 13 May 2021 13:03:44 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Thu, 13 May 2021
 13:07:02 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <eric.auger@redhat.com>, <alex.williamson@redhat.com>
Subject: [PATCH -next] vfio: platform: reset: add missing iounmap() on error in vfio_platform_amdxgbe_reset()
Date:   Thu, 13 May 2021 13:09:24 +0800
Message-ID: <20210513050924.627625-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the missing iounmap() before return from vfio_platform_amdxgbe_reset()
in the error handling case.

Fixes: 0990822c9866 ("VFIO: platform: reset: AMD xgbe reset module")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
index abdca900802d..c6d823a27bd6 100644
--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -61,8 +61,10 @@ static int vfio_platform_amdxgbe_reset(struct vfio_platform_device *vdev)
 	if (!xpcs_regs->ioaddr) {
 		xpcs_regs->ioaddr =
 			ioremap(xpcs_regs->addr, xpcs_regs->size);
-		if (!xpcs_regs->ioaddr)
+		if (!xpcs_regs->ioaddr) {
+			iounmap(xgmac_regs->ioaddr);
 			return -ENOMEM;
+		}
 	}
 
 	/* reset the PHY through MDIO*/
-- 
2.25.1

