Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57EF1F6838
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgFKMsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:48:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:58110 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgFKMsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:48:00 -0400
IronPort-SDR: 1W37q/1oDtWAoMHTlut0VzSTxSLxoBQuGUm87UHifPSFVfwwLDVEYjLC4m+cpPV1e4MLVbl+mj
 Ux2f6cqjBLXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:47:59 -0700
IronPort-SDR: ZR9eWu/92aYlQzrFf3INu69Eg3X3k2Trvn/gtugYqPrWneYkJKycA6ACHVNuD9sMZQIGmism/9
 hM3NebKbuhJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="447911214"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 05:47:59 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org
Subject: [RFC v6 00/25] intel_iommu: expose Shared Virtual Addressing to VMs
Date:   Thu, 11 Jun 2020 05:53:59 -0700
Message-Id: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
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

This QEMU patchset is aiming for the phase 1 and phase 2. It is based
on the kernel series below:
[PATCH v2 00/15] vfio: expose virtual Shared Virtual Addressing to VMs
https://lore.kernel.org/linux-iommu/1591877734-66527-1-git-send-email-yi.l.liu@intel.com/

Patch Overview:
 1. patch 0001 - 0002: update kernel header files
 2. patch 0003 - 0007: select VFIO_TYPE1_NESTING_IOMMU for vIOMMU built
                       on IOMMU nesting translation.
 3. patch 0008 - 0010: set HostIOMMUContext to vIOMMU.
 4. patch 0011 - 0013: allocate PASID for vIOMMU.
 5. patch 0014 - 0015: PASID cache management for Intel vIOMMU.
 6. patch 0016 - 0020: bind guest page table to host.
 7. patch 0021 - 0024: flush first level/stage cache for vIOMMU.
 8. patch 0025: expose SVA to VM by x-scalable-mode="modern"

The complete QEMU set can be found in below link:
https://github.com/luxis1999/qemu.git:vsva_5.7_rc4_qemu_rfcv6

Complete kernel can be found in:
https://github.com/luxis1999/linux-vsva.git:vsva-linux-5.7-rc4-v2

Tests: basci vSVA functionality test, VM reboot/shutdown/crash, kernel build in
guest, boot VM with vSVA disabled, full comapilation with all archs, passthru
entire PCI device, passthru Scalable IOV ADI.

Regards,
Yi Liu

Changelog:
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


*** BLURB HERE ***

Eric Auger (1):
  scripts/update-linux-headers: Import iommu.h

Liu Yi L (24):
  header file update VFIO/IOMMU vSVA APIs kernel 5.7-rc4
  hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
  hw/pci: introduce pci_device_get_iommu_attr()
  intel_iommu: add get_iommu_attr() callback
  vfio: pass nesting iommu requirement into vfio_get_group()
  vfio: check VFIO_TYPE1_NESTING_IOMMU support
  hw/iommu: introduce HostIOMMUContext
  hw/pci: introduce pci_device_set/unset_iommu_context()
  intel_iommu: add set/unset_iommu_context callback
  vfio/common: provide PASID alloc/free hooks
  vfio: init HostIOMMUContext per-container
  intel_iommu: add virtual command capability support
  intel_iommu: process PASID cache invalidation
  intel_iommu: add PASID cache management infrastructure
  vfio: add bind stage-1 page table support
  intel_iommu: sync IOMMU nesting cap info for assigned devices
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: replay pasid binds after context cache invalidation
  intel_iommu: do not pass down pasid bind for PASID #0
  vfio: add support for flush iommu stage-1 cache
  intel_iommu: process PASID-based iotlb invalidation
  intel_iommu: propagate PASID-based iotlb invalidation to host
  intel_iommu: process PASID-based Device-TLB invalidation
  intel_iommu: modify x-scalable-mode to be string option

 hw/Makefile.objs                      |    1 +
 hw/alpha/typhoon.c                    |    6 +-
 hw/arm/smmu-common.c                  |    6 +-
 hw/hppa/dino.c                        |    6 +-
 hw/i386/amd_iommu.c                   |    6 +-
 hw/i386/intel_iommu.c                 | 1229 ++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h        |  118 ++++
 hw/i386/trace-events                  |    6 +
 hw/iommu/Makefile.objs                |    1 +
 hw/iommu/host_iommu_context.c         |  171 +++++
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
 hw/vfio/common.c                      |  297 +++++++-
 hw/vfio/pci.c                         |   26 +-
 hw/vfio/platform.c                    |    2 +-
 hw/virtio/virtio-iommu.c              |    6 +-
 include/hw/i386/intel_iommu.h         |   61 +-
 include/hw/iommu/host_iommu_context.h |  103 +++
 include/hw/pci/pci.h                  |   25 +-
 include/hw/pci/pci_bus.h              |    2 +-
 include/hw/vfio/vfio-common.h         |    7 +-
 linux-headers/linux/iommu.h           |  382 ++++++++++
 linux-headers/linux/vfio.h            |   78 +++
 scripts/update-linux-headers.sh       |    2 +-
 34 files changed, 2614 insertions(+), 60 deletions(-)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 include/hw/iommu/host_iommu_context.h
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.7.4

