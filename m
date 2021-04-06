Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556913555B3
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 15:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhDFNuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 09:50:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16001 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbhDFNue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 09:50:34 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF83b4Yz0zPnX8;
        Tue,  6 Apr 2021 21:47:39 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 21:50:18 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [PATCH v1] vfio/type1: Remove the almost unused check in vfio_iommu_type1_unpin_pages
Date:   Tue, 6 Apr 2021 21:50:09 +0800
Message-ID: <20210406135009.1707-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check i > npage at the end of vfio_iommu_type1_unpin_pages is unused
unless npage < 0, but if npage < 0, this function will return npage, which
should return -EINVAL instead. So let's just check the parameter npage at
the start of the function. By the way, replace unpin_exit with break.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 45cbfd4879a5..fd4213c41743 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -960,7 +960,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 	bool do_accounting;
 	int i;
 
-	if (!iommu || !user_pfn)
+	if (!iommu || !user_pfn || npage <= 0)
 		return -EINVAL;
 
 	/* Supported for v2 version only */
@@ -977,13 +977,13 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 		iova = user_pfn[i] << PAGE_SHIFT;
 		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
 		if (!dma)
-			goto unpin_exit;
+			break;
+
 		vfio_unpin_page_external(dma, iova, do_accounting);
 	}
 
-unpin_exit:
 	mutex_unlock(&iommu->lock);
-	return i > npage ? npage : (i > 0 ? i : -EINVAL);
+	return i > 0 ? i : -EINVAL;
 }
 
 static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
-- 
2.19.1

