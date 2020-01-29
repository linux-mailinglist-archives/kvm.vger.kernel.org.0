Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB31E14CA67
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgA2MLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:15927 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgA2MLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314070739"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:43 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com
Subject: [RFC v3 00/25] intel_iommu: expose Shared Virtual Addressing to VMs
Date:   Wed, 29 Jan 2020 04:16:31 -0800
Message-Id: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
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
changes. For IOMMU and VFIO changes, they are in separate series (listed
in the "Related series").

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

This QEMU RFC patchset is aiming for the phase 1 and phase 2, and works
together with the VT-d driver[1] changes and VFIO changes[2].

Related series:
[1] [PATCH V9 00/10] Nested Shared Virtual Address (SVA) VT-d support:
    https://lkml.org/lkml/2020/1/29/37
    [PATCH 0/3] IOMMU user API enhancement:
    https://lkml.org/lkml/2020/1/29/45

[2] [RFC v3 0/8] vfio: expose virtual Shared Virtual Addressing to VMs
    https://lkml.org/lkml/2020/1/29/255

There are roughly four parts:
 1. Modify pci_setup_iommu() to set PCIIOMMUOps instead of setup PCIIOMMUFunc
 2. Introduce DualStageIOMMUObject as abstract of host IOMMU. It provides
    method for vIOMMU emulators to communicate with host IOMMU. e.g. propagate
    guest page table binding to host IOMMU to setup dual-stage DMA translation
    in host IOMMU and flush iommu iotlb.
 3. Introduce IOMMUContext as abstract of vIOMMU. It provides operations for
    VFIO to communicate with vIOMMU emulators. e.g. let vIOMMU emulators be
    aware of host IOMMU's dual-stage translation capability by registering
    DualStageIOMMUObject instances to vIOMMU emulators.
 4. Setup dual-stage IOMMU translation for Intel vIOMMU. Includes 
    - Check IOMMU uAPI version compatibility and hardware compatibility which
      is preparation for setting up dual-stage DMA translation in host IOMMU.
    - Propagate guest PASID allocation and free request to host.
    - Propagate guest page table binding to host to setup dual-stage IOMMU DMA
      translation in host IOMMU.
    - Propagate guest IOMMU cache invalidation to host to ensure iotlb
      correctness.

The complete QEMU set can be found in below link:
https://github.com/luxis1999/qemu.git: sva_vtd_v9_rfcv3

Complete kernel can be found in:
https://github.com/luxis1999/linux-vsva: vsva-linux-5.5-rc3

Changelog:
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

Eric Auger (1):
  scripts/update-linux-headers: Import iommu.h

Liu Yi L (23):
  hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
  hw/iommu: introduce DualStageIOMMUObject
  hw/pci: introduce pci_device_iommu_context()
  intel_iommu: provide get_iommu_context() callback
  header file update VFIO/IOMMU vSVA APIs
  vfio: pass IOMMUContext into vfio_get_group()
  vfio: check VFIO_TYPE1_NESTING_IOMMU support
  vfio: register DualStageIOMMUObject to vIOMMU
  vfio: get stage-1 pasid formats from Kernel
  vfio/common: add pasid_alloc/free support
  intel_iommu: modify x-scalable-mode to be string option
  intel_iommu: add virtual command capability support
  intel_iommu: process pasid cache invalidation
  intel_iommu: add PASID cache management infrastructure
  vfio: add bind stage-1 page table support
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: replay guest pasid bindings to host
  intel_iommu: replay pasid binds after context cache invalidation
  intel_iommu: do not pass down pasid bind for PASID #0
  vfio: add support for flush iommu stage-1 cache
  intel_iommu: process PASID-based iotlb invalidation
  intel_iommu: propagate PASID-based iotlb invalidation to host
  intel_iommu: process PASID-based Device-TLB invalidation

Peter Xu (1):
  hw/iommu: introduce IOMMUContext

 hw/Makefile.objs                    |    1 +
 hw/alpha/typhoon.c                  |    6 +-
 hw/arm/smmu-common.c                |    6 +-
 hw/hppa/dino.c                      |    6 +-
 hw/i386/amd_iommu.c                 |    6 +-
 hw/i386/intel_iommu.c               | 1208 ++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h      |  119 ++++
 hw/i386/trace-events                |    6 +
 hw/iommu/Makefile.objs              |    2 +
 hw/iommu/dual_stage_iommu.c         |  101 +++
 hw/iommu/iommu_context.c            |   54 ++
 hw/pci-host/designware.c            |    6 +-
 hw/pci-host/ppce500.c               |    6 +-
 hw/pci-host/prep.c                  |    6 +-
 hw/pci-host/sabre.c                 |    6 +-
 hw/pci/pci.c                        |   39 +-
 hw/ppc/ppc440_pcix.c                |    6 +-
 hw/ppc/spapr_pci.c                  |    6 +-
 hw/s390x/s390-pci-bus.c             |    8 +-
 hw/vfio/ap.c                        |    2 +-
 hw/vfio/ccw.c                       |    2 +-
 hw/vfio/common.c                    |  244 ++++++-
 hw/vfio/pci.c                       |    3 +-
 hw/vfio/platform.c                  |    2 +-
 include/hw/i386/intel_iommu.h       |   59 +-
 include/hw/iommu/dual_stage_iommu.h |  103 +++
 include/hw/iommu/iommu_context.h    |   61 ++
 include/hw/pci/pci.h                |   13 +-
 include/hw/pci/pci_bus.h            |    2 +-
 include/hw/vfio/vfio-common.h       |    6 +-
 linux-headers/linux/iommu.h         |  372 +++++++++++
 linux-headers/linux/vfio.h          |  148 +++++
 scripts/update-linux-headers.sh     |    2 +-
 33 files changed, 2568 insertions(+), 49 deletions(-)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/dual_stage_iommu.c
 create mode 100644 hw/iommu/iommu_context.c
 create mode 100644 include/hw/iommu/dual_stage_iommu.h
 create mode 100644 include/hw/iommu/iommu_context.h
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.7.4

