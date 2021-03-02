Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C85A32A722
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449110AbhCBQE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:04:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:29670 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444907AbhCBMlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:23 -0500
IronPort-SDR: IV/PHukfCWqXcKNDaSQu768qIeCT/orpLZATVl6cjSb4UBv+X3xEKZWx4u6aUKvPeVgo8i2Chl
 z/Tsld6YVirQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184363115"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184363115"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:39:27 -0800
IronPort-SDR: EjvOZzD0TPPiJusCauhC+4vlQW0ZZc8zSpZ9FXH/5Dat8RMJemU89uSJIP0efeaM4gBoYCocqB
 rQbkbLBTgidQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472642"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:39:23 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com
Subject: [RFC v11 00/25] intel_iommu: expose Shared Virtual Addressing to VMs
Date:   Wed,  3 Mar 2021 04:38:02 +0800
Message-Id: <20210302203827.437645-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
Intel platforms allows address space sharing between device DMA and
applications. SVA can reduce programming complexity and enhance security.

This QEMU series is intended to expose SVA usage to VMs. i.e. Sharing
guest application address space with passthru devices. This is called
vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
changes.

The high-level architecture for SVA virtualization is as below, the key
design of vSVA support is to utilize the dual-stage IOMMU translation (
also known as IOMMU nesting translation) capability in host IOMMU.

    .-------------.  .---------------------------.
    |   vIOMMU    |  | Guest process CR3, FL only|
    |             |  '---------------------------'
    .----------------/
    | PASID Entry |--- PASID cache flush -
    '-------------'                       |
    |             |                       V
    |             |                CR3 in GPA
    '-------------'
Guest
------| Shadow |--------------------------|--------
      v        v                          v
Host
    .-------------.  .----------------------.
    |   pIOMMU    |  | Bind FL for GVA-GPA  |
    |             |  '----------------------'
    .----------------/  |
    | PASID Entry |     V (Nested xlate)
    '----------------\.------------------------------.
    |             |   |SL for GPA-HPA, default domain|
    |             |   '------------------------------'
    '-------------'
Where:
 - FL = First level/stage one page tables
 - SL = Second level/stage two page tables

The complete vSVA kernel upstream patches are divided into three phases:
    1. Common APIs and PCI device direct assignment
    2. IOMMU-backed Mediated Device assignment
    3. Page Request Services (PRS) support

This QEMU patchset is aiming for the phase 1 and phase 2. Compared with
last version, the major change in this series is the PASID allocation.
Instead of utilizing VFIO's uAPI to request PASID from kernel, this
series uses /dev/ioasid uAPI to do it. For the reason of the change, please
refer to [1]. This series is based on two kernel series [2] and [3] posted
earlier.

Patch Overview:
 1. patch 0001 - 0003: update kernel header files
 2. patch 0004 - 0008: select VFIO_TYPE1_NESTING_IOMMU for vIOMMU built
                       on IOMMU nesting translation.
 3. patch 0009 - 0013: introduce HostIOMMUContext, and implements in VFIO.
 4. patch 0014       : IOMMU nesting capability sync between vIOMMU and host.
 5. patch 0015       : PASID allocation/free support in Intel vIOMMU.
 6. patch 0016 - 0017: PASID cache management for Intel vIOMMU.
 7. patch 0018 - 0020: bind guest page table to host.
 8. patch 0021 - 0024: flush first level/stage cache for vIOMMU.
 9. patch 0025       : expose SVA to VM by x-scalable-mode="modern"

The complete QEMU set can be found in [4], and complete kernel can be found
in [5].

Tests: basci vSVA functionality test, VM reboot/shutdown/crash, kernel build in
guest, boot VM with vSVA disabled, full comapilation with all archs, passthru
entire PCI device, passthru Scalable IOV ADI.

[1] https://lore.kernel.org/kvm/DM5PR11MB14351121729909028D6EB365C31D0@DM5PR11MB1435.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/linux-iommu/20210302203545.436623-1-yi.l.liu@intel.com/
[3] https://lore.kernel.org/linux-iommu/1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com/
[4] https://github.com/jacobpan/linux/tree/vsva-linux-5.12-rc1-v8
[5] https://github.com/luxis1999/qemu/tree/vsva_5.12_rc1_qemu_rfcv11

Regards,
Yi Liu

Changelog:
	- RFC v10 -> RFC v11:
	  a) Rebase to latest kernel implementation (5.12-rc1 vsva v8) and adopt to /dev/ioasid for
	     requesting PASID from host.
	  RFC v10: https://lore.kernel.org/qemu-devel/1599735398-6829-1-git-send-email-yi.l.liu@intel.com/

	- RFC v9 -> RFC v10:
	  a) Rebase to latest kernel implementation (5.9-rc2 vsva v7)
	  RFC v9: https://lore.kernel.org/kvm/1595918058-33392-1-git-send-email-yi.l.liu@intel.com/

	- RFC v8 -> RFC v9:
	  a) Rebase to latest kernel implementation (5.8-rc6 vsva v6)
	  RFC v8: https://lore.kernel.org/kvm/1594553181-55810-1-git-send-email-yi.l.liu@intel.com/

	- RFC v7 -> RFC v8:
	  a) Rebase to latest kernel implementation (5.8-rc3 vsva v5)
	  RFC v7: https://lore.kernel.org/kvm/1593862609-36135-1-git-send-email-yi.l.liu@intel.com/

	- RFC v6 -> RFC v7:
	  a) Rebase to latest kernel implementation (5.8-rc3 vsva)
	  RFC v6: https://lore.kernel.org/kvm/1591880064-30638-1-git-send-email-yi.l.liu@intel.com/

	- RFC v5 -> RFC v6:
	  a) Use RFC instead of formal patch as kernel patch is in progress.
	  b) Address comments from Peter and Eric.
	  c) Add get_iommu_attr() to advertise vIOMMU nesting requirement to
	     VFIO.
	  d) Update per latest kernel UAPI definition.
	  e) Add patch 0017 to check iommu nesting cap info in set_iommu().
	  RFC v5: https://www.spinics.net/lists/kvm/msg211475.html

	- RFC v4 -> RFC v5:
	  a) Refactor the vfio HostIOMMUContext init code (patch 0008 - 0009 of v1 series)
	  b) Refactor the pasid binding handling (patch 0011 - 0016 of v1 series)
	  RFC v4: https://patchwork.ozlabs.org/cover/1259648/

	- RFC v3.1 -> RFC v4:
	  a) Implement HostIOMMUContext in QOM manner.
	  b) Add pci_set/unset_iommu_context() to register HostIOMMUContext to
	     vIOMMU, thus the lifecircle of HostIOMMUContext is awared in vIOMMU
	     side. In such way, vIOMMU could use the methods provided by the
	     HostIOMMUContext safely.
	  c) Add back patch "[RFC v3 01/25] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps"
	  RFCv3.1: https://patchwork.kernel.org/cover/11397879/

	- RFC v3 -> v3.1:
	  a) Drop IOMMUContext, and rename DualStageIOMMUObject to HostIOMMUContext.
	     HostIOMMUContext is per-vfio-container, it is exposed to  vIOMMU via PCI
	     layer. VFIO registers a PCIHostIOMMUFunc callback to PCI layer, vIOMMU
	     could get HostIOMMUContext instance via it.
	  b) Check IOMMU uAPI version by VFIO_CHECK_EXTENSION
	  c) Add a check on VFIO_PASID_REQ availability via VFIO_GET_IOMMU_IHNFO
	  d) Reorder the series, put vSVA linux header file update in the beginning
	     put the x-scalable-mode option mofification in the end of the series.
	  e) Dropped patch "[RFC v3 01/25] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps"
	  RFCv3: https://patchwork.kernel.org/cover/11356033/

	- RFC v2 -> v3:
	  a) Introduce DualStageIOMMUObject to abstract the host IOMMU programming
	  capability. e.g. request PASID from host, setup IOMMU nesting translation
	  on host IOMMU. The pasid_alloc/bind_guest_page_table/iommu_cache_flush
	  operations are moved to be DualStageIOMMUOps. Thus, DualStageIOMMUObject
	  is an abstract layer which provides QEMU vIOMMU emulators with an explicit
	  method to program host IOMMU.
	  b) Compared with RFC v2, the IOMMUContext has also been updated. It is
	  modified to provide an abstract for vIOMMU emulators. It provides the
	  method for pass-through modules (like VFIO) to communicate with host IOMMU.
	  e.g. tell vIOMMU emulators about the IOMMU nesting capability on host side
	  and report the host IOMMU DMA translation faults to vIOMMU emulators.
	  RFC v2: https://www.spinics.net/lists/kvm/msg198556.html

	- RFC v1 -> v2:
	  Introduce IOMMUContext to abstract the connection between VFIO
	  and vIOMMU emulators, which is a replacement of the PCIPASIDOps
	  in RFC v1. Modify x-scalable-mode to be string option instead of
	  adding a new option as RFC v1 did. Refined the pasid cache management
	  and addressed the TODOs mentioned in RFC v1. 
	  RFC v1: https://patchwork.kernel.org/cover/11033657/

---
Eric Auger (1):
  scripts/update-linux-headers: Import iommu.h

Liu Yi L (24):
  scripts/update-linux-headers: Import ioasid.h
  header file update VFIO/IOMMU vSVA APIs kernel 5.12-rc1
  hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
  hw/pci: introduce pci_device_get_iommu_attr()
  intel_iommu: add get_iommu_attr() callback
  vfio: pass nesting requirement into vfio_get_group()
  vfio: check VFIO_TYPE1_NESTING_IOMMU support
  hw/iommu: introduce HostIOMMUContext
  hw/pci: introduce pci_device_set/unset_iommu_context()
  intel_iommu: add set/unset_iommu_context callback
  vfio: add HostIOMMUContext support
  vfio: init HostIOMMUContext per-container
  intel_iommu: sync IOMMU nesting cap info for assigned devices
  intel_iommu: add virtual command capability support
  intel_iommu: process PASID cache invalidation
  intel_iommu: add PASID cache management infrastructure
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: replay pasid binds after context cache invalidation
  intel_iommu: do not pass down pasid bind for PASID #0
  vfio: add support for flush iommu stage-1 cache
  intel_iommu: process PASID-based iotlb invalidation
  intel_iommu: propagate PASID-based iotlb invalidation to host
  intel_iommu: process PASID-based Device-TLB invalidation
  intel_iommu: modify x-scalable-mode to be string option

 hw/Kconfig                            |    3 +
 hw/alpha/typhoon.c                    |    6 +-
 hw/arm/smmu-common.c                  |    6 +-
 hw/hppa/dino.c                        |    6 +-
 hw/i386/amd_iommu.c                   |    6 +-
 hw/i386/intel_iommu.c                 | 1279 ++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h        |  132 +++
 hw/i386/trace-events                  |    6 +
 hw/iommu/Kconfig                      |    4 +
 hw/iommu/host_iommu_context.c         |  125 +++
 hw/iommu/meson.build                  |    6 +
 hw/meson.build                        |    1 +
 hw/pci-host/designware.c              |    6 +-
 hw/pci-host/pnv_phb3.c                |    6 +-
 hw/pci-host/pnv_phb4.c                |    6 +-
 hw/pci-host/ppce500.c                 |    6 +-
 hw/pci-host/prep.c                    |    6 +-
 hw/pci-host/sabre.c                   |    6 +-
 hw/pci/pci.c                          |   73 +-
 hw/ppc/ppc440_pcix.c                  |    6 +-
 hw/ppc/spapr_pci.c                    |    6 +-
 hw/s390x/s390-pci-bus.c               |    8 +-
 hw/vfio/ap.c                          |    2 +-
 hw/vfio/ccw.c                         |    2 +-
 hw/vfio/common.c                      |  249 ++++-
 hw/vfio/pci.c                         |   26 +-
 hw/vfio/platform.c                    |    2 +-
 hw/virtio/virtio-iommu.c              |    6 +-
 include/hw/i386/intel_iommu.h         |   65 +-
 include/hw/iommu/host_iommu_context.h |   86 ++
 include/hw/pci/pci.h                  |   25 +-
 include/hw/pci/pci_bus.h              |    2 +-
 include/hw/vfio/vfio-common.h         |    7 +-
 linux-headers/linux/iommu.h           |  413 ++++++++
 linux-headers/linux/vfio.h            |   84 ++
 scripts/update-linux-headers.sh       |    2 +-
 36 files changed, 2595 insertions(+), 85 deletions(-)
 create mode 100644 hw/iommu/Kconfig
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 hw/iommu/meson.build
 create mode 100644 include/hw/iommu/host_iommu_context.h
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.25.1

