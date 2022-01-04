Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413BE483A0E
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiADB5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:57:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:30112 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbiADB5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261450; x=1672797450;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p2DUmxc/ab0HU0elEfR+FsWKpZ/BMGHpII+WrlsVUic=;
  b=SYM3tkQsRFxMImb1y4JbhAwxEQl7jJyReUt1xCKaETY20JJbAhzReo3z
   AocI6j8Ryb15jl+p/+KlTqloZnGB3geGUzGieHUHnCtKaeekZx3vswaT2
   06LJvhYhXS01hXIhMVcc226GtTRquRVnUZYG6aIKAsBlwM8xZONuxXeCm
   VbdribsO2BYMpBbh0HV2Kvf0iv6eXWa5MPCVD2AGXp7AGreGs3DSc0WpD
   01QvacK0hKPpVzw4o/nHyNE8NDKDnmtbJJPzhsnEn1zJSPBwSsrtm10CY
   klhppzoKUFGYU0XfzRf2pjmOTSXfey5iK7oSqQm9OZpnkbcZzlNnmxhjL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="222133668"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="222133668"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:57:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573188"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:57:23 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 00/14] Fix BUG_ON in vfio_iommu_group_notifier()
Date:   Tue,  4 Jan 2022 09:56:30 +0800
Message-Id: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
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
  [PATCH 1-7]: Detect DMA ownership conflicts during driver binding;
  [PATCH 8-10]: Add security context management for assigned devices;
  [PATCH 11-14]: Various cleanups.

This is also part one of three initial series for IOMMUFD:
 * Move IOMMU Group security into the iommu layer
 - Generic IOMMUFD implementation
 - VFIO ability to consume IOMMUFD

Change log:
v1: initial post
  - https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/

v2:
  - https://lore.kernel.org/linux-iommu/20211128025051.355578-1-baolu.lu@linux.intel.com/

  - Move kernel dma ownership auto-claiming from driver core to bus
    callback. [Greg/Christoph/Robin/Jason]
    https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/T/#m153706912b770682cb12e3c28f57e171aa1f9d0c

  - Code and interface refactoring for iommu_set/release_dma_owner()
    interfaces. [Jason]
    https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/T/#mea70ed8e4e3665aedf32a5a0a7db095bf680325e

  - [NEW]Add new iommu_attach/detach_device_shared() interfaces for
    multiple devices group. [Robin/Jason]
    https://lore.kernel.org/linux-iommu/20211115020552.2378167-1-baolu.lu@linux.intel.com/T/#mea70ed8e4e3665aedf32a5a0a7db095bf680325e

  - [NEW]Use iommu_attach/detach_device_shared() in drm/tegra drivers.

  - Refactoring and description refinement.

v3:
  - https://lore.kernel.org/linux-iommu/20211206015903.88687-1-baolu.lu@linux.intel.com/

  - Rename bus_type::dma_unconfigure to bus_type::dma_cleanup. [Greg]
    https://lore.kernel.org/linux-iommu/c3230ace-c878-39db-1663-2b752ff5384e@linux.intel.com/T/#m6711e041e47cb0cbe3964fad0a3466f5ae4b3b9b

  - Avoid _platform_dma_configure for platform_bus_type::dma_configure.
    [Greg]
    https://lore.kernel.org/linux-iommu/c3230ace-c878-39db-1663-2b752ff5384e@linux.intel.com/T/#m43fc46286611aa56a5c0eeaad99d539e5519f3f6

  - Patch "0012-iommu-Add-iommu_at-de-tach_device_shared-for-mult.patch"
    and "0018-drm-tegra-Use-the-iommu-dma_owner-mechanism.patch" have
    been tested by Dmitry Osipenko <digetx@gmail.com>.

v4:
  - https://lore.kernel.org/linux-iommu/20211217063708.1740334-1-baolu.lu@linux.intel.com/
  - Remove unnecessary tegra->domain chech in the tegra patch. (Jason)
  - Remove DMA_OWNER_NONE. (Joerg)
  - Change refcount to unsigned int. (Christoph)
  - Move mutex lock into group set_dma_owner functions. (Christoph)
  - Add kernel doc for iommu_attach/detach_domain_shared(). (Christoph)
  - Move dma auto-claim into driver core. (Jason/Christoph)

v5:
  - Move kernel dma ownership auto-claiming from driver core to bus
    callback. (Greg)
  - Refactor the iommu interfaces to make them more specific.
    (Jason/Robin)
  - Simplify the dma ownership implementation by removing the owner
    type. (Jason)
  - Commit message refactoring for PCI drivers. (Bjorn)
  - Move iommu_attach/detach_device() improvement patches into another
    series as there are a lot of code refactoring and cleanup staffs
    in various device drivers.

This is based on next branch of linux-iommu tree:
https://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git
and also available on github:
https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-v5

Best regards,
baolu

Jason Gunthorpe (1):
  vfio: Delete the unbound_list

Lu Baolu (13):
  iommu: Add dma ownership management interfaces
  driver core: Add dma_cleanup callback in bus_type
  amba: Stop sharing platform_dma_configure()
  driver core: platform: Add driver dma ownership management
  amba: Add driver dma ownership management
  bus: fsl-mc: Add driver dma ownership management
  PCI: Add driver dma ownership management
  PCI: pci_stub: Suppress kernel DMA ownership auto-claiming
  PCI: portdrv: Suppress kernel DMA ownership auto-claiming
  vfio: Set DMA ownership for VFIO devices
  vfio: Remove use of vfio_group_viable()
  vfio: Remove iommu group notifier
  iommu: Remove iommu group changes notifier

 include/linux/amba/bus.h              |   1 +
 include/linux/device/bus.h            |   3 +
 include/linux/fsl/mc.h                |   5 +
 include/linux/iommu.h                 |  54 +++---
 include/linux/pci.h                   |   5 +
 include/linux/platform_device.h       |   3 +-
 drivers/amba/bus.c                    |  39 +++-
 drivers/base/dd.c                     |   5 +
 drivers/base/platform.c               |  23 ++-
 drivers/bus/fsl-mc/fsl-mc-bus.c       |  26 ++-
 drivers/iommu/iommu.c                 | 236 +++++++++++++++++--------
 drivers/pci/pci-driver.c              |  21 +++
 drivers/pci/pci-stub.c                |   1 +
 drivers/pci/pcie/portdrv_pci.c        |   2 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c     |   1 +
 drivers/vfio/pci/vfio_pci.c           |   1 +
 drivers/vfio/platform/vfio_amba.c     |   1 +
 drivers/vfio/platform/vfio_platform.c |   1 +
 drivers/vfio/vfio.c                   | 245 ++------------------------
 19 files changed, 335 insertions(+), 338 deletions(-)

-- 
2.25.1

