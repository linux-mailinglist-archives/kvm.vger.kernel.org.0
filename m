Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53A2A1328
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 03:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgJaCxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 22:53:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7013 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgJaCxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 22:53:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNNz40wX0zhdMw;
        Sat, 31 Oct 2020 10:53:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 10:53:13 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <eric.auger@redhat.com>, <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH v2] vfio: platform: fix reference leak in vfio_platform_open
Date:   Sat, 31 Oct 2020 11:03:53 +0800
Message-ID: <20201031030353.9699-1-zhangqilong3@huawei.com>
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
failed. Forgetting to call pm_runtime_put will result in
reference leak in vfio_platform_open, so we should fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c0771a9567fb..fb4b385191f2 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -267,7 +267,7 @@ static int vfio_platform_open(void *device_data)
 
 		ret = pm_runtime_get_sync(vdev->device);
 		if (ret < 0)
-			goto err_pm;
+			goto err_rst;
 
 		ret = vfio_platform_call_reset(vdev, &extra_dbg);
 		if (ret && vdev->reset_required) {
@@ -284,7 +284,6 @@ static int vfio_platform_open(void *device_data)
 
 err_rst:
 	pm_runtime_put(vdev->device);
-err_pm:
 	vfio_platform_irq_cleanup(vdev);
 err_irq:
 	vfio_platform_regions_cleanup(vdev);
-- 
2.17.1

