Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD5168D67
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgBVIB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:01:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:63018 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbgBVIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547652"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:56 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org
Subject: [RFC v3.1 00/22] intel_iommu: expose Shared Virtual Addressing to VMs
Date:   Sat, 22 Feb 2020 00:07:01 -0800
Message-Id: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
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
changes. This version is 3.1 to address comments in RFCv3. It is based
on the kernel which can be found in below github. This kernel has some
internal tweak between VFIO and VT-d iommu driver, so it is not sent
out to community review. But the interface between kernel and QEMU are
latest. So I send out this version for review.
https://github.com/luxis1999/linux-vsva: vsva-linux-5.5-rc3-rfcv3.1

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

This QEMU RFC patchset is aiming for the phase 1 and phase 2.

Related series:
[1] [PATCH V9 00/10] Nested Shared Virtual Address (SVA) VT-d support:
    https://lkml.org/lkml/2020/1/29/37
    [PATCH 0/3] IOMMU user API enhancement:
    https://lkml.org/lkml/2020/1/29/45

[2] [RFC v3 0/8] vfio: expose virtual Shared Virtual Addressing to VMs
    https://lkml.org/lkml/2020/1/29/255

There are roughly two parts:
 1. Introduce HostIOMMUContext as abstract of host IOMMU. It provides explicit
    method for vIOMMU emulators to communicate with host IOMMU. e.g. propagate
    guest page table binding to host IOMMU to setup dual-stage DMA translation
    in host IOMMU and flush iommu iotlb.
 2. Setup dual-stage IOMMU translation for Intel vIOMMU. Includes 
    - Check IOMMU uAPI version compatibility and VFIO Nesting capabilities which
      includes hardware compatibility (stage 1 format) and VFIO_PASID_REQ
      availability. This is preparation for setting up dual-stage DMA translation
      in host IOMMU.
    - Propagate guest PASID allocation and free request to host.
    - Propagate guest page table binding to host to setup dual-stage IOMMU DMA
      translation in host IOMMU.
    - Propagate guest IOMMU cache invalidation to host to ensure iotlb
      correctness.

The complete QEMU set can be found in below link:
https://github.com/luxis1999/qemu.git: sva_qemu_rfcv3.1

Complete kernel can be found in:
https://github.com/luxis1999/linux-vsva.git: vsva-linux-5.5-rc3-rfcv3.1

Tests: basci functionality test, VM reboot/shutdown, full comapilation.
          <more test would be done as this is RFC series>

Changelog:
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

Eric Auger (1):
  scripts/update-linux-headers: Import iommu.h

Liu Yi L (21):
  header file update VFIO/IOMMU vSVA APIs
  vfio: check VFIO_TYPE1_NESTING_IOMMU support
  hw/iommu: introduce HostIOMMUContext
  hw/pci: add pci_device_setup_iommu
  vfio/pci: init HostIOMMUContext per-container
  vfio: get nesting iommu cap info from Kernel
  vfio/common: add pasid_alloc/free support
  hw/pci: add pci_device_host_iommu_context()
  intel_iommu: add virtual command capability support
  intel_iommu: process pasid cache invalidation
  intel_iommu: add PASID cache management infrastructure
  vfio: add bind stage-1 page table support
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: replay guest pasid bindings to host
  intel_iommu: replay pasid binds after context cache invalidation
  intel_iommu: do not pass down pasid bind for PASID #0
  vfio/common: add support for flush iommu stage-1 cache
  intel_iommu: process PASID-based iotlb invalidation
  intel_iommu: propagate PASID-based iotlb invalidation to host
  intel_iommu: process PASID-based Device-TLB invalidation
  intel_iommu: modify x-scalable-mode to be string option

 hw/Makefile.objs                      |    1 +
 hw/i386/intel_iommu.c                 | 1176 ++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h        |  119 ++++
 hw/i386/trace-events                  |    6 +
 hw/iommu/Makefile.objs                |    1 +
 hw/iommu/host_iommu_context.c         |   88 +++
 hw/pci/pci.c                          |   18 +
 hw/vfio/common.c                      |  236 ++++++-
 hw/vfio/pci.c                         |   21 +
 include/hw/i386/intel_iommu.h         |   41 +-
 include/hw/iommu/host_iommu_context.h |  106 +++
 include/hw/pci/pci.h                  |    7 +
 include/hw/vfio/vfio-common.h         |    2 +
 linux-headers/linux/iommu.h           |  372 +++++++++++
 linux-headers/linux/vfio.h            |  127 ++++
 scripts/update-linux-headers.sh       |    2 +-
 16 files changed, 2311 insertions(+), 12 deletions(-)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 include/hw/iommu/host_iommu_context.h
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.7.4

