Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2275D2D54BB
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 08:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgLJHgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 02:36:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9862 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733123AbgLJHgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 02:36:19 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cs5Kg6mXDz7CCV;
        Thu, 10 Dec 2020 15:35:03 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.37) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 15:35:26 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 2/7] vfio: iommu_type1: Initially set the pinned_page_dirty_scope
Date:   Thu, 10 Dec 2020 15:34:20 +0800
Message-ID: <20201210073425.25960-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20201210073425.25960-1-zhukeqian1@huawei.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently there are 3 ways to promote the pinned_page_dirty_scope
status of vfio_iommu:

1. Through pin interface.
2. Detach a group without dirty tracking.
3. Attach a group with dirty tracking.

For point 3, the only chance to change the pinned status is that
the vfio_iommu is newly created.

Consider that we can safely set the pinned status when create a
new vfio_iommu, as we do it, the point 3 can be removed to reduce
operations.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f129d24a6ec3..c52bcefba96b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2064,12 +2064,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			 * Non-iommu backed group cannot dirty memory directly,
 			 * it can only use interfaces that provide dirty
 			 * tracking.
-			 * The iommu scope can only be promoted with the
-			 * addition of a dirty tracking group.
 			 */
 			group->pinned_page_dirty_scope = true;
-			if (!iommu->pinned_page_dirty_scope)
-				update_pinned_page_dirty_scope(iommu);
 			mutex_unlock(&iommu->lock);
 
 			return 0;
@@ -2457,6 +2453,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
+	iommu->pinned_page_dirty_scope = true;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 
-- 
2.23.0

