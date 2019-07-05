Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E956061051
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfGFLSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:18:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:6066 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfGFLSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:18:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:18:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354897"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:18:49 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org
Subject: [RFC v1 00/18] intel_iommu: expose Shared Virtual Addressing to VM
Date:   Fri,  5 Jul 2019 19:01:33 +0800
Message-Id: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
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

There are roughly four parts:
1. Introduce PCIPASIDOps to PCIDevice to support PASID related operations
2. Passdown PASID allocation and free to host
3. Passdown guest PASID binding to host
4. Passdown guest IOMMU cache invalidation to host

Related series:
[1] [PATCH v4 00/22]  Shared virtual address IOMMU and VT-d support:
https://lwn.net/Articles/790820/
<My series is based on this kernel series from Jacob Pan>

[2] [RFC PATCH 0/4] vfio: support Shared Virtual Addressing from Yi Liu

This work is based on collaboration with other developers on the IOMMU
mailing list. Notably,
[1] [RFC PATCH 00/20] Qemu: Extend intel_iommu emulator to support
Shared Virtual Memory from Yi Liu
https://www.spinics.net/lists/kvm/msg148798.html

[2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d from Yi Liu
https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html

[3] [PATCH v3 00/12] Introduce new iommu notifier framework for virt-SVA
by Yi Liu
https://lists.gnu.org/archive/html/qemu-devel/2018-03/msg00078.html

[4] [PATCH v6 00/22] SMMUv3 Nested Stage Setup by Eric Auger
https://lkml.org/lkml/2019/3/17/124

[5] [RFC v4 00/27] vSMMUv3/pSMMUv3 2 stage VFIO integration by Eric Auger
https://lists.sr.ht/~philmd/qemu/%3C20190527114203.2762-1-eric.auger%40redhat.com%3E

[6] [RFC PATCH 2/6] drivers core: Add I/O ASID allocator by Jean-Philippe
Brucker
https://www.spinics.net/lists/iommu/msg30639.html

Liu Yi L (18):
  linux-headers: import iommu.h from kernel
  linux-headers: import vfio.h from kernel
  hw/pci: introduce PCIPASIDOps to PCIDevice
  intel_iommu: add "sm_model" option
  vfio/pci: add pasid alloc/free implementation
  intel_iommu: support virtual command emulation and pasid request
  hw/pci: add pci_device_bind/unbind_gpasid
  vfio/pci: add vfio bind/unbind_gpasid implementation
  intel_iommu: process pasid cache invalidation
  intel_iommu: tag VTDAddressSpace instance with PASID
  intel_iommu: create VTDAddressSpace per BDF+PASID
  intel_iommu: bind/unbind guest page table to host
  intel_iommu: flush pasid cache after a DSI context cache flush
  hw/pci: add flush_pasid_iotlb() in PCIPASIDOps
  vfio/pci: adds support for PASID-based iotlb flush
  intel_iommu: add PASID-based iotlb invalidation support
  intel_iommu: propagate PASID-based iotlb flush to host
  intel_iommu: do not passdown pasid bind for PASID #0

 hw/i386/intel_iommu.c          | 811 ++++++++++++++++++++++++++++++++++++++++-
 hw/i386/intel_iommu_internal.h |  97 +++++
 hw/i386/trace-events           |   7 +
 hw/pci/pci.c                   |  95 +++++
 hw/vfio/pci.c                  | 138 +++++++
 include/hw/i386/intel_iommu.h  |  22 +-
 include/hw/pci/pci.h           |  27 ++
 linux-headers/linux/iommu.h    | 338 +++++++++++++++++
 linux-headers/linux/vfio.h     | 116 ++++++
 9 files changed, 1644 insertions(+), 7 deletions(-)
 create mode 100644 linux-headers/linux/iommu.h

-- 
2.7.4

