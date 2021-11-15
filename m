Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A844FCE0
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 03:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhKOCNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Nov 2021 21:13:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:15410 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230395AbhKOCNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Nov 2021 21:13:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233307209"
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="233307209"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2021 18:10:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,235,1631602800"; 
   d="scan'208";a="505714518"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2021 18:10:21 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 00/11] Fix BUG_ON in vfio_iommu_group_notifier()
Date:   Mon, 15 Nov 2021 10:05:41 +0800
Message-Id: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

The iommu group is the minimal isolation boundary for DMA. Devices in
a group can access each other's MMIO registers via peer to peer DMA
and also need share the same I/O address space.

Once the I/O address space is assigned to user control it is no longer
available to the dma_map* API, which effectively makes the DMA API
non-working.

Second, userspace can use DMA initiated by a device that it controls
to access the MMIO spaces of other devices in the group. This allows
userspace to indirectly attack any kernel owned device and it's driver.

Therefore groups must either be entirely under kernel control or
userspace control, never a mixture. Unfortunately some systems have
problems with the granularity of groups and there are a couple of
important exceptions:

 - pci_stub allows the admin to block driver binding on a device and
   make it permanently shared with userspace. Since PCI stub does not
   do DMA it is safe, however the admin must understand that using
   pci_stub allows userspace to attack whatever device it was bound
   it.

 - PCI bridges are sometimes included in groups. Typically PCI bridges
   do not use DMA, and generally do not have MMIO regions.

Generally any device that does not have any MMIO registers is a
possible candidate for an exception.

Currently vfio adopts a workaround to detect violations of the above
restrictions by monitoring the driver core BOUND event, and hardwiring
the above exceptions. Since there is no way for vfio to reject driver
binding at this point, BUG_ON() is triggered if a violation is
captured (kernel driver BOUND event on a group which already has some
devices assigned to userspace). Aside from the bad user experience
this opens a way for root userspace to crash the kernel, even in high
integrity configurations, by manipulating the module binding and
triggering the BUG_ON.

This series solves this problem by making the user/kernel ownership a
core concept at the IOMMU layer. The driver core enforces kernel
ownership while drivers are bound and violations now result in a error
codes during probe, not BUG_ON failures.

Patch partitions:
  [PATCH 1-2]: Detect DMA ownership conflicts during driver binding;
  [PATCH 3-6]: Add security context management for assigned devices;
  [PATCH 7-11]: Various cleanups.

Ideas contributed by:
  Jason Gunthorpe <jgg@nvidia.com>
  Kevin Tian <kevin.tian@intel.com>
  Ashok Raj <ashok.raj@intel.com>
  Lu Baolu <baolu.lu@linux.intel.com>

Review contributors:
  Jason Gunthorpe <jgg@nvidia.com>
  Kevin Tian <kevin.tian@intel.com>
  Ashok Raj <ashok.raj@intel.com>
  Liu Yi L <yi.l.liu@intel.com>
  Jacob jun Pan <jacob.jun.pan@intel.com>
  Chaitanya Kulkarni <kch@nvidia.com>

This also is part one of three initial series for IOMMUFD:
 * Move IOMMU Group security into the iommu layer
 - Generic IOMMUFD implementation
 - VFIO ability to consume IOMMUFD

This is based on v5.16-rc1 and available on github:
https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-v1

Best regards,
baolu

Jason Gunthorpe (1):
  vfio: Delete the unbound_list

Lu Baolu (10):
  iommu: Add device dma ownership set/release interfaces
  driver core: Set DMA ownership during driver bind/unbind
  PCI: pci_stub: Suppress kernel DMA ownership auto-claiming
  PCI: portdrv: Suppress kernel DMA ownership auto-claiming
  iommu: Add security context management for assigned devices
  iommu: Expose group variants of dma ownership interfaces
  vfio: Use DMA_OWNER_USER to declaim passthrough devices
  vfio: Remove use of vfio_group_viable()
  vfio: Remove iommu group notifier
  iommu: Remove iommu group changes notifier

 include/linux/device/driver.h         |   7 +-
 include/linux/iommu.h                 |  75 ++++---
 drivers/base/dd.c                     |  12 ++
 drivers/iommu/iommu.c                 | 274 ++++++++++++++++++--------
 drivers/pci/pci-stub.c                |   3 +
 drivers/pci/pcie/portdrv_pci.c        |   2 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c     |   1 +
 drivers/vfio/pci/vfio_pci.c           |   3 +
 drivers/vfio/platform/vfio_amba.c     |   1 +
 drivers/vfio/platform/vfio_platform.c |   1 +
 drivers/vfio/vfio.c                   | 247 ++---------------------
 11 files changed, 294 insertions(+), 332 deletions(-)

-- 
2.25.1

