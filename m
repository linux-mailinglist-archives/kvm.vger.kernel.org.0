Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23616E333F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502250AbfJXNBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:5155 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfJXNBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156134"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:06 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org
Subject: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to VM
Date:   Thu, 24 Oct 2019 08:34:21 -0400
Message-Id: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on Intel
platforms allow address space sharing between device DMA and applications.
SVA can reduce programming complexity and enhance security.
This series is intended to expose SVA capability to VMs. i.e. shared guest
application address space with passthru devices. The whole SVA virtualization
requires QEMU/VFIO/IOMMU changes. This series includes the QEMU changes, for
VFIO and IOMMU changes, they are in separate series (listed in the "Related
series").

The high-level architecture for SVA virtualization is as below:

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

The complete vSVA upstream patches are divided into three phases:
    1. Common APIs and PCI device direct assignment
    2. Page Request Services (PRS) support
    3. Mediated device assignment

This RFC patchset is aiming for the phase 1. Works together with the VT-d
driver[1] changes and VFIO changes[2].

Related series:
[1] [PATCH v6 00/10] Nested Shared Virtual Address (SVA) VT-d support:
https://lkml.org/lkml/2019/10/22/953
<This series is based on this kernel series from Jacob Pan>

[2] [RFC v2 0/3] vfio: support Shared Virtual Addressing from Yi Liu

There are roughly four parts:
 1. Introduce IOMMUContext as abstract layer between vIOMMU emulator and
    VFIO to avoid direct calling between the two
 2. Passdown PASID allocation and free to host
 3. Passdown guest PASID binding to host
 4. Passdown guest IOMMU cache invalidation to host

The full set can be found in below link:
https://github.com/luxis1999/qemu.git: sva_vtd_v6_qemu_rfc_v2

Changelog:
	- RFC v1 -> v2:
	  Introduce IOMMUContext to abstract the connection between VFIO
	  and vIOMMU emulator, which is a replacement of the PCIPASIDOps
	  in RFC v1. Modify x-scalable-mode to be string option instead of
	  adding a new option as RFC v1 did. Refined the pasid cache management
	  and addressed the TODOs mentioned in RFC v1. 
	  RFC v1: https://patchwork.kernel.org/cover/11033657/

Eric Auger (1):
  update-linux-headers: Import iommu.h

Liu Yi L (20):
  header update VFIO/IOMMU vSVA APIs against 5.4.0-rc3+
  intel_iommu: modify x-scalable-mode to be string option
  vfio/common: add iommu_ctx_notifier in container
  hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
  hw/pci: introduce pci_device_iommu_context()
  intel_iommu: provide get_iommu_context() callback
  vfio/pci: add iommu_context notifier for pasid alloc/free
  intel_iommu: add virtual command capability support
  intel_iommu: process pasid cache invalidation
  intel_iommu: add present bit check for pasid table entries
  intel_iommu: add PASID cache management infrastructure
  vfio/pci: add iommu_context notifier for pasid bind/unbind
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: replay guest pasid bindings to host
  intel_iommu: replay pasid binds after context cache invalidation
  intel_iommu: do not passdown pasid bind for PASID #0
  vfio/pci: add iommu_context notifier for PASID-based iotlb flush
  intel_iommu: process PASID-based iotlb invalidation
  intel_iommu: propagate PASID-based iotlb invalidation to host
  intel_iommu: process PASID-based Device-TLB invalidation

Peter Xu (1):
  hw/iommu: introduce IOMMUContext

 hw/Makefile.objs                |    1 +
 hw/alpha/typhoon.c              |    6 +-
 hw/arm/smmu-common.c            |    6 +-
 hw/hppa/dino.c                  |    6 +-
 hw/i386/amd_iommu.c             |    6 +-
 hw/i386/intel_iommu.c           | 1249 +++++++++++++++++++++++++++++++++++++--
 hw/i386/intel_iommu_internal.h  |  109 ++++
 hw/i386/trace-events            |    6 +
 hw/iommu/Makefile.objs          |    1 +
 hw/iommu/iommu.c                |   66 +++
 hw/pci-host/designware.c        |    6 +-
 hw/pci-host/ppce500.c           |    6 +-
 hw/pci-host/prep.c              |    6 +-
 hw/pci-host/sabre.c             |    6 +-
 hw/pci/pci.c                    |   27 +-
 hw/ppc/ppc440_pcix.c            |    6 +-
 hw/ppc/spapr_pci.c              |    6 +-
 hw/s390x/s390-pci-bus.c         |    8 +-
 hw/vfio/common.c                |   10 +
 hw/vfio/pci.c                   |  149 +++++
 include/hw/i386/intel_iommu.h   |   58 +-
 include/hw/iommu/iommu.h        |  113 ++++
 include/hw/pci/pci.h            |   13 +-
 include/hw/pci/pci_bus.h        |    2 +-
 include/hw/vfio/vfio-common.h   |    9 +
 linux-headers/linux/iommu.h     |  324 ++++++++++
 linux-headers/linux/vfio.h      |   83 +++
 scripts/update-linux-headers.sh |    2 +-
 28 files changed, 2232 insertions(+), 58 deletions(-)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/iommu.c
 create mode 100644 include/hw/iommu/iommu.h
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.7.4

