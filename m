Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B416F2ECCD7
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbhAGJa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:30:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10034 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbhAGJa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:30:28 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DBLX02xl0zj491;
        Thu,  7 Jan 2021 17:28:48 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 17:29:34 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH 5/5] vfio/iommu_type1: Move sanity_check_pfn_list to unmap_unpin_all
Date:   Thu, 7 Jan 2021 17:29:01 +0800
Message-ID: <20210107092901.19712-6-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210107092901.19712-1-zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both external domain and iommu backend domain can use pinning
interface, thus both can add pfn to dma pfn_list. By moving
the sanity_check_pfn_list to unmap_unpin_all can apply it to
all types of domain.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 38 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9776a059904d..d796be8bcbc5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2225,10 +2225,28 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	return ret;
 }
 
+static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+
+	n = rb_first(&iommu->dma_list);
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma;
+
+		dma = rb_entry(n, struct vfio_dma, node);
+
+		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
+			break;
+	}
+	/* mdev vendor driver must unregister notifier */
+	WARN_ON(iommu->notifier.head);
+}
+
 static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
 {
 	struct rb_node *node;
 
+	vfio_sanity_check_pfn_list(iommu);
 	while ((node = rb_first(&iommu->dma_list)))
 		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
 }
@@ -2256,23 +2274,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 	}
 }
 
-static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
-{
-	struct rb_node *n;
-
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
-		struct vfio_dma *dma;
-
-		dma = rb_entry(n, struct vfio_dma, node);
-
-		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
-			break;
-	}
-	/* mdev vendor driver must unregister notifier */
-	WARN_ON(iommu->notifier.head);
-}
-
 /*
  * Called when a domain is removed in detach. It is possible that
  * the removed domain decided the iova aperture window. Modify the
@@ -2371,8 +2372,6 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			kfree(group);
 
 			if (list_empty(&iommu->external_domain->group_list)) {
-				vfio_sanity_check_pfn_list(iommu);
-
 				/*
 				 * During dirty page tracking, we can't remove
 				 * vfio_dma because dirty log will lose.
@@ -2503,7 +2502,6 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	if (iommu->external_domain) {
 		vfio_release_domain(iommu->external_domain, true);
-		vfio_sanity_check_pfn_list(iommu);
 		kfree(iommu->external_domain);
 	}
 
-- 
2.19.1

