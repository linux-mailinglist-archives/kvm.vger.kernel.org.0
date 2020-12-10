Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4E2D54C7
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 08:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733156AbgLJHgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 02:36:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9574 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbgLJHgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 02:36:19 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cs5KV1ZwPzM365;
        Thu, 10 Dec 2020 15:34:54 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.37) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 15:35:28 +0800
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
Subject: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when promote pinned_scope
Date:   Thu, 10 Dec 2020 15:34:22 +0800
Message-ID: <20201210073425.25960-5-zhukeqian1@huawei.com>
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

When we pin or detach a group which is not dirty tracking capable,
we will try to promote pinned_scope of vfio_iommu.

If we succeed to do so, vfio only report pinned_scope as dirty to
userspace next time, but these memory written before pin or detach
is missed.

The solution is that we must populate all dma range as dirty before
promoting pinned_scope of vfio_iommu.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bd9a94590ebc..00684597b098 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1633,6 +1633,20 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 	return group;
 }
 
+static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
+		unsigned long nbits = dma->size >> pgshift;
+
+		if (dma->iommu_mapped)
+			bitmap_set(dma->bitmap, 0, nbits);
+	}
+}
+
 static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
@@ -1657,6 +1671,10 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
 	}
 
 	iommu->pinned_page_dirty_scope = true;
+
+	/* Set all bitmap to avoid missing dirty page */
+	if (iommu->dirty_page_tracking)
+		vfio_populate_bitmap_all(iommu);
 }
 
 static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
-- 
2.23.0

