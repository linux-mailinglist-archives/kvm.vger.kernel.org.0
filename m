Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D19295E56
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 14:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898158AbgJVM1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 08:27:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15243 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2898151AbgJVM1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 08:27:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B8C0452696F9DE132DF9;
        Thu, 22 Oct 2020 20:25:33 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.179) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 22 Oct 2020 20:25:26 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] vfio/type1: Use the new helper to find vfio_group
Date:   Thu, 22 Oct 2020 20:24:17 +0800
Message-ID: <20201022122417.245-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When attaching a new group to the container, let's use the new helper
vfio_iommu_find_iommu_group() to check if it's already attached. There
is no functional change.

Also take this chance to add a missing blank line.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a05d856ae806..aa586bd684da 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1997,6 +1997,7 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 
 	list_splice_tail(iova_copy, iova);
 }
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -2013,18 +2014,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
-	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (find_iommu_group(d, iommu_group)) {
-			mutex_unlock(&iommu->lock);
-			return -EINVAL;
-		}
-	}
-
-	if (iommu->external_domain) {
-		if (find_iommu_group(iommu->external_domain, iommu_group)) {
-			mutex_unlock(&iommu->lock);
-			return -EINVAL;
-		}
+	/* Check for duplicates */
+	if (vfio_iommu_find_iommu_group(iommu, iommu_group)) {
+		mutex_unlock(&iommu->lock);
+		return -EINVAL;
 	}
 
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
-- 
2.19.1

