Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09186106D
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfGFLXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:23:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:6331 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfGFLXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:23:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:23:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="158693772"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga008.jf.intel.com with ESMTP; 06 Jul 2019 04:23:09 -0700
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, eric.auger@redhat.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [RFC v1 0/4] vfio: support Shared Virtual Addressing
Date:   Fri,  5 Jul 2019 19:06:08 +0800
Message-Id: <1562324772-3084-1-git-send-email-yi.l.liu@intel.com>
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
requires QEMU/VFIO/IOMMU changes. This series includes the VFIO changes, for
QEMU and IOMMU changes, they are in separate series (listed in the "Related
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

There are roughly three parts:
1. vfio support for PASID allocation and free from VMs
2. vfio support for guest PASID binding from VMs
3. vfio support for IOMMU cache invalidation from VMs

Related series:
[1] [PATCH v4 00/22]  Shared virtual address IOMMU and VT-d support:
https://lwn.net/Articles/790820/
<My series is based on this kernel series from Jacob Pan>

[2] [RFC v1 00/18] intel_iommu: expose Shared Virtual Addressing to VM
from Yi Liu

This work is based on collaboration with other developers on the IOMMU
mailing list. Notably,

[1] [RFC PATCH 00/20] Qemu: Extend intel_iommu emulator to support
Shared Virtual Memory from Yi Liu
https://www.spinics.net/lists/kvm/msg148798.html

[2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d from Yi Liu
https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html

[3] [PATCH v3 00/12] Introduce new iommu notifier framework for virt-SVA by Yi
https://lists.gnu.org/archive/html/qemu-devel/2018-03/msg00078.html

[4] [PATCH v6 00/22] SMMUv3 Nested Stage Setup by Eric Auger
https://lkml.org/lkml/2019/3/17/124

[5] [RFC v4 00/27] vSMMUv3/pSMMUv3 2 stage VFIO integration by Eric Auger
https://lists.sr.ht/~philmd/qemu/%3C20190527114203.2762-1-eric.auger%40redhat.com%3E

[6] [RFC PATCH 2/6] drivers core: Add I/O ASID allocator by Jean-Philippe
Brucker
https://www.spinics.net/lists/iommu/msg30639.html

Liu Yi L (4):
  vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
  vfio: VFIO_IOMMU_CACHE_INVALIDATE
  vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
  vfio/type1: bind guest pasid (guest page tables) to host

 drivers/vfio/vfio_iommu_type1.c | 384 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 116 ++++++++++++
 2 files changed, 500 insertions(+)

-- 
2.7.4

