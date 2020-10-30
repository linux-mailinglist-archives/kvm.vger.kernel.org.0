Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BFD2A0A09
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgJ3Phc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:37:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7116 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3Phc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 11:37:32 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CN5zF0LPrzLmsJ;
        Fri, 30 Oct 2020 23:37:29 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 30 Oct 2020
 23:37:27 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <eric.auger@redhat.com>, <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH] vfio: platform: fix reference leak in vfio_platform_open
Date:   Fri, 30 Oct 2020 23:47:54 +0800
Message-ID: <20201030154754.99431-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in vfio_platform_open, so we should fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c0771a9567fb..aa97f1678981 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -266,8 +266,10 @@ static int vfio_platform_open(void *device_data)
 			goto err_irq;
 
 		ret = pm_runtime_get_sync(vdev->device);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_noidle(vdev->device);
 			goto err_pm;
+		}
 
 		ret = vfio_platform_call_reset(vdev, &extra_dbg);
 		if (ret && vdev->reset_required) {
-- 
2.17.1

