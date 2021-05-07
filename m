Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72E93763F1
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhEGKh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 06:37:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18009 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbhEGKh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 06:37:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fc6HP36dszQkLN;
        Fri,  7 May 2021 18:33:37 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 18:36:49 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Tian Kevin <kevin.tian@intel.com>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 0/3] vfio/iommu_type1: Implement dirty log tracking based on IOMMU HWDBM
Date:   Fri, 7 May 2021 18:36:05 +0800
Message-ID: <20210507103608.39440-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex and everyone,

This patch series implement vfio dma dirty log tracking based on IOMMU HWDBM (hardware
dirty bit management, such as SMMU with HTTU or intel IOMMU with SLADE).

This patch series is split from the series[1] that containes both IOMMU part and
VFIO part. Please refer the new IOMMU part v4[2] to review or test.

Changelog:

v2:
 - Use separate ioctl to get dirty log without clear it automatically. (Alex)
 - Implement based on new iommu dirty tracking framework.
 - Track hwdbm status at domain level.
 - Bugfix: When get_no_clear, we should recover dirty bitmap too.
 - Bugfix: When switch from full dirty policy to iommu hwdbm policy, we should populate full dirty.

Intention:

As we know, vfio live migration is an important and valuable feature, but there
are still many hurdles to solve, including migration of interrupt, device state,
DMA dirty log tracking, and etc.

For now, the only dirty log tracking interface is pinning. It has some drawbacks:
1. Only smart vendor drivers are aware of this.
2. It's coarse-grained, the pinned-scope is generally bigger than what the device actually access.
3. It can't track dirty continuously and precisely, vfio populates all pinned-scope as dirty.
   So it doesn't work well with iteratively dirty log handling.

About this series:

Implement a new dirty log tracking method for vfio based on iommu hwdbm. A new
ioctl operation named VFIO_DIRTY_LOG_MANUAL_CLEAR is added, which can eliminate
some redundant dirty handling of userspace.   
   
Optimizations Todo:

1. We recognized that each smmu_domain (a vfio_container may has several smmu_domain) has its
   own stage1 mapping, and we must scan all these mapping to sync dirty state. We plan to refactor
   smmu_domain to support more than one smmu in one smmu_domain, then these smmus can share a same
   stage1 mapping.
2. We also recognized that scan TTD is a hotspot of performance. Recently, I have implement a
   SW/HW conbined dirty log tracking at MMU side[3], which can effectively solve this problem.
   This idea can be applied to smmu side too.

Thanks,
Keqian

[1] https://lore.kernel.org/linux-iommu/20210310090614.26668-1-zhukeqian1@huawei.com/
[2] https://lore.kernel.org/linux-iommu/20210507102211.8836-1-zhukeqian1@huawei.com/ 
[3] https://lore.kernel.org/linux-arm-kernel/20210126124444.27136-1-zhukeqian1@huawei.com/


Kunkun Jiang (3):
  vfio/iommu_type1: Add HWDBM status maintenance
  vfio/iommu_type1: Optimize dirty bitmap population based on iommu
    HWDBM
  vfio/iommu_type1: Add support for manual dirty log clear

 drivers/vfio/vfio_iommu_type1.c | 315 ++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       |  36 +++-
 2 files changed, 337 insertions(+), 14 deletions(-)

-- 
2.19.1

