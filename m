Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733A7307977
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhA1PSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:18:51 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11213 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhA1PSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:18:48 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DRPFQ4vV3zlC5j;
        Thu, 28 Jan 2021 23:16:26 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 23:17:53 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH 00/11] vfio/iommu_type1: Implement dirty log tracking based on smmuv3 HTTU
Date:   Thu, 28 Jan 2021 23:17:31 +0800
Message-ID: <20210128151742.18840-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This patch series implement a new dirty log tracking method for vfio dma.

Intention：

As we know, vfio live migration is an important and valuable feature, but there
are still many hurdles to solve, including migration of interrupt, device state,
DMA dirty log tracking, and etc.

For now, the only dirty log tracking interface is pinning. It has some drawbacks:
1. Only smart vendor drivers are aware of this.
2. It's coarse-grained, the pinned-scope is generally bigger than what the device actually access.
3. It can't track dirty continuously and precisely, vfio populates all pinned-scope as dirty.
   So it doesn't work well with iteratively dirty log handling.

About SMMU HTTU:

HTTU (Hardware Translation Table Update) is a feature of ARM SMMUv3, it can update
access flag or/and dirty state of the TTD (Translation Table Descriptor) by hardware.
With HTTU, stage1 TTD is classified into 3 types:
                        DBM bit             AP[2](readonly bit)
1. writable_clean         1                       1
2. writable_dirty         1                       0
3. readonly               0                       1

If HTTU_HD (manage dirty state) is enabled, smmu can change TTD from writable_clean to
writable_dirty. Then software can scan TTD to sync dirty state into dirty bitmap. With
this feature, we can track the dirty log of DMA continuously and precisely.

About this series:

Patch 1-3: Add feature detection for smmu HTTU and enable HTTU for smmu stage1 mapping.
           And add feature detection for smmu BBML. We need to split block mapping when
           start dirty log tracking and merge page mapping when stop dirty log tracking,
		   which requires break-before-make procedure. But it might cause problems when the
		   TTD is alive. The I/O streams might not tolerate translation faults. So BBML
		   should be used.

Patch 4-7: Add four interfaces (split_block, merge_page, sync_dirty_log and clear_dirty_log)
           in IOMMU layer, they are essential to implement dma dirty log tracking for vfio.
		   We implement these interfaces for arm smmuv3.

Patch   8: Add HWDBM (Hardware Dirty Bit Management) device feature reporting in IOMMU layer.

Patch9-11: Implement a new dirty log tracking method for vfio based on iommu hwdbm. A new
           ioctl operation named VFIO_DIRTY_LOG_MANUAL_CLEAR is added, which can eliminate
		   some redundant dirty handling of userspace.

Optimizations TO Do:

1. We recognized that each smmu_domain (a vfio_container may has several smmu_domain) has its
   own stage1 mapping, and we must scan all these mapping to sync dirty state. We plan to refactor
   smmu_domain to support more than one smmu in one smmu_domain, then these smmus can share a same
   stage1 mapping.
2. We also recognized that scan TTD is a hotspot of performance. Recently, I have implement a
   SW/HW conbined dirty log tracking at MMU side [1], which can effectively solve this problem.
   This idea can be applied to smmu side too.

Thanks,
Keqian


[1] https://lore.kernel.org/linux-arm-kernel/20210126124444.27136-1-zhukeqian1@huawei.com/

jiangkunkun (11):
  iommu/arm-smmu-v3: Add feature detection for HTTU
  iommu/arm-smmu-v3: Enable HTTU for SMMU stage1 mapping
  iommu/arm-smmu-v3: Add feature detection for BBML
  iommu/arm-smmu-v3: Split block descriptor to a span of page
  iommu/arm-smmu-v3: Merge a span of page to block descriptor
  iommu/arm-smmu-v3: Scan leaf TTD to sync hardware dirty log
  iommu/arm-smmu-v3: Clear dirty log according to bitmap
  iommu/arm-smmu-v3: Add HWDBM device feature reporting
  vfio/iommu_type1: Add HWDBM status maintanance
  vfio/iommu_type1: Optimize dirty bitmap population based on iommu
    HWDBM
  vfio/iommu_type1: Add support for manual dirty log clear

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 138 ++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 +
 drivers/iommu/io-pgtable-arm.c              | 392 +++++++++++++++++++-
 drivers/iommu/iommu.c                       | 227 ++++++++++++
 drivers/vfio/vfio_iommu_type1.c             | 235 +++++++++++-
 include/linux/io-pgtable.h                  |  14 +
 include/linux/iommu.h                       |  55 +++
 include/uapi/linux/vfio.h                   |  28 +-
 8 files changed, 1093 insertions(+), 10 deletions(-)

-- 
2.19.1

