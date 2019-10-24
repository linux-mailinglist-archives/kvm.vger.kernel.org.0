Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6013FE3311
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 14:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502181AbfJXMwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 08:52:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:11532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731315AbfJXMwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 08:52:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 05:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="201464798"
Received: from iov.bj.intel.com ([10.238.145.67])
  by orsmga003.jf.intel.com with ESMTP; 24 Oct 2019 05:52:47 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [RFC v2 0/3] vfio: support Shared Virtual Addressing
Date:   Thu, 24 Oct 2019 08:26:20 -0400
Message-Id: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
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

There are roughly three parts in this patchset which are
corresponding to the basic vSVA support for PCI device
assignment
 1. vfio support for PASID allocation and free from VMs
 2. vfio support for guest PASID binding from VMs
 3. vfio support for IOMMU cache invalidation from VMs

The complete vSVA upstream patches are divided into three phases:
    1. Common APIs and PCI device direct assignment
    2. Page Request Services (PRS) support
    3. Mediated device assignment

This RFC patchset is aiming for the phase 1, and works together with the
VT-d driver[1] changes and QEMU changes[2]. Complete set for vSVA can be
found in:
https://github.com/jacobpan/linux.git:siov_sva.

And this patchset doesn't include the patch to expose PASID capability to
guest. This is expected to be in another series.

Related series:
[1] [PATCH v6 00/10] Nested Shared Virtual Address (SVA) VT-d support:
https://lkml.org/lkml/2019/10/22/953
<This series is based on this kernel series from Jacob Pan>

[2] [RFC v2 00/20] intel_iommu: expose Shared Virtual Addressing to VM
from Yi Liu

Changelog:
	- RFC v1 -> v2:
	  Dropped vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE.
	  RFC v1: https://patchwork.kernel.org/cover/11033699/

Liu Yi L (3):
  vfio: VFIO_IOMMU_CACHE_INVALIDATE
  vfio/type1: VFIO_IOMMU_PASID_REQUEST(alloc/free)
  vfio/type1: bind guest pasid (guest page tables) to host

 drivers/vfio/vfio_iommu_type1.c | 305 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  82 +++++++++++
 2 files changed, 387 insertions(+)

-- 
2.7.4

