Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645CA2ECCD4
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 10:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbhAGJaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 04:30:24 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10557 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbhAGJaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 04:30:22 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DBLWb6mFDzMGT6;
        Thu,  7 Jan 2021 17:28:27 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 17:29:32 +0800
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
Subject: [PATCH 4/5] vfio/iommu_type1: Carefully use unmap_unpin_all during dirty tracking
Date:   Thu, 7 Jan 2021 17:29:00 +0800
Message-ID: <20210107092901.19712-5-zhukeqian1@huawei.com>
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

If we detach group during dirty page tracking, we shouldn't remove
vfio_dma, because dirty log will lose.

But we don't prevent unmap_unpin_all in vfio_iommu_release, because
under normal procedure, dirty tracking has been stopped.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 26b7eb2a5cfc..9776a059904d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2373,7 +2373,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			if (list_empty(&iommu->external_domain->group_list)) {
 				vfio_sanity_check_pfn_list(iommu);
 
-				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+				/*
+				 * During dirty page tracking, we can't remove
+				 * vfio_dma because dirty log will lose.
+				 */
+				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) &&
+				    !iommu->dirty_page_tracking)
 					vfio_iommu_unmap_unpin_all(iommu);
 
 				kfree(iommu->external_domain);
@@ -2406,10 +2411,15 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		 * iommu and external domain doesn't exist, then all the
 		 * mappings go away too. If it's the last domain with iommu and
 		 * external domain exist, update accounting
+		 *
+		 * Note: During dirty page tracking, we can't remove vfio_dma
+		 * because dirty log will lose. Just update accounting is a good
+		 * choice.
 		 */
 		if (list_empty(&domain->group_list)) {
 			if (list_is_singular(&iommu->domain_list)) {
-				if (!iommu->external_domain)
+				if (!iommu->external_domain &&
+				    !iommu->dirty_page_tracking)
 					vfio_iommu_unmap_unpin_all(iommu);
 				else
 					vfio_iommu_unmap_unpin_reaccount(iommu);
-- 
2.19.1

