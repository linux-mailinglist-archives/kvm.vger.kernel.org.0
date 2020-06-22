Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9B203017
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbgFVHHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 03:07:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6381 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731258AbgFVHHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 03:07:31 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9387677F378764EFCB63;
        Mon, 22 Jun 2020 15:07:28 +0800 (CST)
Received: from DESKTOP-J8O3A6U.china.huawei.com (10.173.221.213) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 22 Jun 2020 15:07:22 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <wanghaibin.wang@huawei.com>
Subject: [PATCH] vfio/type1: Add conditional rescheduling after iommu map failed
Date:   Mon, 22 Jun 2020 15:02:17 +0800
Message-ID: <20200622070217.4768-1-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.213]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

c5e6688752c25 ("vfio/type1: Add conditional rescheduling") missed
a "cond_resched()" in vfio_iommu_map if iommu map failed.

This is a very tiny optimization and the case can hardly happen.

Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5e556ac9102a..48fb9cc4a40a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1225,8 +1225,10 @@ static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
 	return 0;
 
 unwind:
-	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next)
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
 		iommu_unmap(d->domain, iova, npage << PAGE_SHIFT);
+		cond_resched();
+	}
 
 	return ret;
 }
-- 
2.19.1


