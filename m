Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421082F7666
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 11:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbhAOKOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 05:14:38 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10660 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbhAOKOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 05:14:35 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DHH74456Wz15tPH;
        Fri, 15 Jan 2021 18:12:48 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Fri, 15 Jan 2021 18:13:42 +0800
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
Subject: [RESEND PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when remove vfio_dma
Date:   Fri, 15 Jan 2021 18:13:21 +0800
Message-ID: <20210115101321.12084-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210115101321.12084-1-zhukeqian1@huawei.com>
References: <20210115101321.12084-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_sanity_check_pfn_list() is used to check whether pfn_list of
vfio_dma is empty when remove the external domain, so it makes a
wrong assumption that only external domain will add pfn to dma pfn_list.

Now we apply this check when remove a specific vfio_dma and extract
the notifier check just for external domain.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c16924cd54e7..9b7fcff6bd81 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -958,6 +958,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
+	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
@@ -2251,23 +2252,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
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
@@ -2367,7 +2351,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			kfree(group);
 
 			if (list_empty(&iommu->external_domain->group_list)) {
-				vfio_sanity_check_pfn_list(iommu);
+				/* mdev vendor driver must unregister notifier */
+				WARN_ON(iommu->notifier.head);
 
 				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
 					vfio_iommu_unmap_unpin_all(iommu);
@@ -2492,7 +2477,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	if (iommu->external_domain) {
 		vfio_release_domain(iommu->external_domain, true);
-		vfio_sanity_check_pfn_list(iommu);
+		/* mdev vendor driver must unregister notifier */
+		WARN_ON(iommu->notifier.head);
 		kfree(iommu->external_domain);
 	}
 
-- 
2.19.1

