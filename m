Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18821304A21
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbhAZFPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:08 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11439 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbhAYJ3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:29:25 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DPP6x0jn8zjBwh;
        Mon, 25 Jan 2021 17:03:53 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 17:04:40 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Date:   Mon, 25 Jan 2021 17:03:58 +0800
Message-ID: <20210125090402.1429-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.186.182]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The static pinning and mapping problem in VFIO and possible solutions
have been discussed a lot [1, 2]. One of the solutions is to add I/O
page fault support for VFIO devices. Different from those relatively
complicated software approaches such as presenting a vIOMMU that provides
the DMA buffer information (might include para-virtualized optimizations),
IOPF mainly depends on the hardware faulting capability, such as the PCIe
PRI extension or Arm SMMU stall model. What's more, the IOPF support in
the IOMMU driver is being implemented in SVA [3]. So do we consider to
add IOPF support for VFIO passthrough based on the IOPF part of SVA at
present?

We have implemented a basic demo only for one stage of translation (GPA
-> HPA in virtualization, note that it can be configured at either stage),
and tested on Hisilicon Kunpeng920 board. The nested mode is more complicated
since VFIO only handles the second stage page faults (same as the non-nested
case), while the first stage page faults need to be further delivered to
the guest, which is being implemented in [4] on ARM. My thought on this
is to report the page faults to VFIO regardless of the occured stage (try
to carry the stage information), and handle respectively according to the
configured mode in VFIO. Or the IOMMU driver might evolve to support more...

Might TODO:
 - Optimize the faulting path, and measure the performance (it might still
   be a big issue).
 - Add support for PRI.
 - Add a MMU notifier to avoid pinning.
 - Add support for the nested mode.
...

Any comments and suggestions are very welcome. :-)

Links:
[1] Lesokhin I, et al. Page Fault Support for Network Controllers. In ASPLOS,
    2016.
[2] Tian K, et al. coIOMMU: A Virtual IOMMU with Cooperative DMA Buffer Tracking
    for Efficient Memory Management in Direct I/O. In USENIX ATC, 2020.
[3] iommu: I/O page faults for SMMUv3:
    https://patchwork.kernel.org/project/linux-arm-kernel/cover/20210121123623.2060416-1-jean-philippe@linaro.org/
[4] SMMUv3 Nested Stage Setup (VFIO part):
    https://patchwork.kernel.org/project/kvm/cover/20201116110030.32335-1-eric.auger@redhat.com/

Thanks,
Shenming


Shenming Lu (4):
  vfio/type1: Add a bitmap to track IOPF mapped pages
  vfio: Add a page fault handler
  vfio: Try to enable IOPF for VFIO devices
  vfio: Allow to pin and map dynamically

 drivers/vfio/vfio.c             |  75 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 131 +++++++++++++++++++++++++++++++-
 include/linux/vfio.h            |   6 ++
 3 files changed, 211 insertions(+), 1 deletion(-)

-- 
2.19.1

