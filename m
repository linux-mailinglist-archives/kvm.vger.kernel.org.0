Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E814CA36
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgA2MGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:06:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:59027 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgA2MGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433133"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:06:38 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v3 0/8] vfio: expose virtual Shared Virtual Addressing to VMs
Date:   Wed, 29 Jan 2020 04:11:44 -0800
Message-Id: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
Intel platforms allows address space sharing between device DMA and
applications. SVA can reduce programming complexity and enhance security.

This VFIO series is intended to expose SVA usage to VMs. i.e. Sharing
guest application address space with passthru devices. This is called
vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
changes. For IOMMU and QEMU changes, they are in separate series (listed
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

There are roughly four parts in this patchset which are
corresponding to the basic vSVA support for PCI device
assignment
 1. vfio support for PASID allocation and free for VMs
 2. vfio support for guest page table binding request from VMs
 3. vfio support for IOMMU cache invalidation from VMs
 4. vfio support for vSVA usage on IOMMU-backed mdevs

The complete vSVA kernel upstream patches are divided into three phases:
    1. Common APIs and PCI device direct assignment
    2. IOMMU-backed Mediated Device assignment
    3. Page Request Services (PRS) support

This RFC patchset is aiming for the phase 1 and phase 2, and works
together with the VT-d driver[1] changes and QEMU changes[2]. Complete
set for current vSVA can be found in below branch. This branch also
includes the patches for exposing PASID capability to VM, which will be
in another patchset.
https://github.com/luxis1999/linux-vsva: vsva-linux-5.5-rc3
old version: https://github.com/jacobpan/linux.git:siov_sva.

Related series:
[1] [PATCH V9 00/10] Nested Shared Virtual Address (SVA) VT-d support:
    https://lkml.org/lkml/2020/1/29/37
    [PATCH 0/3] IOMMU user API enhancement:
    https://lkml.org/lkml/2020/1/29/45

[2] [RFC v3 00/25] intel_iommu: expose Shared Virtual Addressing to VMs
    The complete QEMU set can be found in below link:
    https://github.com/luxis1999/qemu.git: sva_vtd_v9_rfcv3

Changelog:
	- RFC v2 -> v3:
	  a) Refine the whole patchset to fit the roughly parts in this series
	  b) Adds complete vfio PASID management framework. e.g. pasid alloc,
	  free, reclaim in VM crash/down and per-VM PASID quota to prevent
	  PASID abuse.
	  c) Adds IOMMU uAPI version check and page table format check to ensure
	  version compatibility and hardware compatibility.
	  d) Adds vSVA vfio support for IOMMU-backed mdevs.

	- RFC v1 -> v2:
	  Dropped vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE.

Liu Yi L (8):
  vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
  vfio/type1: Make per-application (VM) PASID quota tunable
  vfio: Reclaim PASIDs when application is down
  vfio/type1: Add VFIO_NESTING_GET_IOMMU_UAPI_VERSION
  vfio/type1: Report 1st-level/stage-1 page table format to userspace
  vfio/type1: Bind guest page tables to host
  vfio/type1: Add VFIO_IOMMU_CACHE_INVALIDATE
  vfio/type1: Add vSVA support for IOMMU-backed mdevs

 drivers/vfio/vfio.c             | 183 +++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 421 ++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  21 ++
 include/uapi/linux/vfio.h       | 148 ++++++++++++++
 4 files changed, 773 insertions(+)

-- 
2.7.4

