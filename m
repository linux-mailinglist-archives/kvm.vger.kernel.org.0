Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C32302B2
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgG1GU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:20:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:26362 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgG1GU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:20:56 -0400
IronPort-SDR: YjjR2wcfzydZ7E/DK6ayQQl4eiyUofys18EBusI2y2arzUCebWdVxU9Ada5TrlMkODuMJv6Jus
 AP4kwt8MO3vA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681237"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681237"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:55 -0700
IronPort-SDR: 1R39JSLKZPY/jvYAqc2FiYUhyk4zIpzPhvlm+gQ8r/A7hesyzH4vUVqpSzLgdgTY8jaHP1qsWV
 FFgP2ywW5Srg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274385"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2020 23:20:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/15] vfio: expose virtual Shared Virtual Addressing to VMs
Date:   Mon, 27 Jul 2020 23:27:29 -0700
Message-Id: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
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

Patch Overview:
 1. a refactor to vfio_iommu_type1 ioctl (patch 0001)
 2. reports IOMMU nesting info to userspace ( patch 0002, 0003, 0004 and 0015)
 3. vfio support for PASID allocation and free for VMs (patch 0005, 0006, 0007)
 4. vfio support for binding guest page table to host (patch 0008, 0009, 0010)
 5. vfio support for IOMMU cache invalidation from VMs (patch 0011)
 6. vfio support for vSVA usage on IOMMU-backed mdevs (patch 0012)
 7. expose PASID capability to VM (patch 0013)
 8. add doc for VFIO dual stage control (patch 0014)

The complete vSVA kernel upstream patches are divided into three phases:
    1. Common APIs and PCI device direct assignment
    2. IOMMU-backed Mediated Device assignment
    3. Page Request Services (PRS) support

This patchset is aiming for the phase 1 and phase 2, and based on Jacob's
below series.
*) [PATCH v6 0/6] IOMMU user API enhancement - wip
   https://lore.kernel.org/linux-iommu/1595525140-23899-1-git-send-email-jacob.jun.pan@linux.intel.com/

*) [PATCH 00/10] IOASID extensions for guest SVA - wip
   https://lore.kernel.org/linux-iommu/1585158931-1825-1-git-send-email-jacob.jun.pan@linux.intel.com/

The latest IOASID code added below new interface for itertate all PASIDs of an
ioasid_set. The implementation is not sent out yet as Jacob needs some cleanup,
it can be found in branch vsva-linux-5.8-rc6-v6 on github (mentioned below):
 int ioasid_set_for_each_ioasid(int sid, void (*fn)(ioasid_t id, void *data), void *data);

Complete set for current vSVA can be found in below branch.
https://github.com/luxis1999/linux-vsva.git: vsva-linux-5.8-rc6-v6

The corresponding QEMU patch series is included in below branch:
https://github.com/luxis1999/qemu.git: vsva_5.8_rc6_qemu_rfcv9


Regards,
Yi Liu

Changelog:
	- Patch v5 -> Patch v6:
	  a) Address comments against v5 from Eric.
	  b) rebase on Jacob's v6 IOMMU uapi enhancement
	  Patch v5: https://lore.kernel.org/kvm/1594552870-55687-1-git-send-email-yi.l.liu@intel.com/

	- Patch v4 -> Patch v5:
	  a) Address comments against v4
	  Patch v4: https://lore.kernel.org/kvm/1593861989-35920-1-git-send-email-yi.l.liu@intel.com/

	- Patch v3 -> Patch v4:
	  a) Address comments against v3
	  b) Add rb from Stefan on patch 14/15
	  Patch v3: https://lore.kernel.org/linux-iommu/1592988927-48009-1-git-send-email-yi.l.liu@intel.com/

	- Patch v2 -> Patch v3:
	  a) Rebase on top of Jacob's v3 iommu uapi patchset
	  b) Address comments from Kevin and Stefan Hajnoczi
	  c) Reuse DOMAIN_ATTR_NESTING to get iommu nesting info
	  d) Drop [PATCH v2 07/15] iommu/uapi: Add iommu_gpasid_unbind_data
	  Patch v2: https://lore.kernel.org/linux-iommu/1591877734-66527-1-git-send-email-yi.l.liu@intel.com/#r

	- Patch v1 -> Patch v2:
	  a) Refactor vfio_iommu_type1_ioctl() per suggestion from Christoph
	     Hellwig.
	  b) Re-sequence the patch series for better bisect support.
	  c) Report IOMMU nesting cap info in detail instead of a format in
	     v1.
	  d) Enforce one group per nesting type container for vfio iommu type1
	     driver.
	  e) Build the vfio_mm related code from vfio.c to be a separate
	     vfio_pasid.ko.
	  f) Add PASID ownership check in IOMMU driver.
	  g) Adopted to latest IOMMU UAPI design. Removed IOMMU UAPI version
	     check. Added iommu_gpasid_unbind_data for unbind requests from
	     userspace.
	  h) Define a single ioctl:VFIO_IOMMU_NESTING_OP for bind/unbind_gtbl
	     and cahce_invld.
	  i) Document dual stage control in vfio.rst.
	  Patch v1: https://lore.kernel.org/linux-iommu/1584880325-10561-1-git-send-email-yi.l.liu@intel.com/

	- RFC v3 -> Patch v1:
	  a) Address comments to the PASID request(alloc/free) path
	  b) Report PASID alloc/free availabitiy to user-space
	  c) Add a vfio_iommu_type1 parameter to support pasid quota tuning
	  d) Adjusted to latest ioasid code implementation. e.g. remove the
	     code for tracking the allocated PASIDs as latest ioasid code
	     will track it, VFIO could use ioasid_free_set() to free all
	     PASIDs.
	  RFC v3: https://lore.kernel.org/linux-iommu/1580299912-86084-1-git-send-email-yi.l.liu@intel.com/

	- RFC v2 -> v3:
	  a) Refine the whole patchset to fit the roughly parts in this series
	  b) Adds complete vfio PASID management framework. e.g. pasid alloc,
	  free, reclaim in VM crash/down and per-VM PASID quota to prevent
	  PASID abuse.
	  c) Adds IOMMU uAPI version check and page table format check to ensure
	  version compatibility and hardware compatibility.
	  d) Adds vSVA vfio support for IOMMU-backed mdevs.
	  RFC v2: https://lore.kernel.org/linux-iommu/1571919983-3231-1-git-send-email-yi.l.liu@intel.com/

	- RFC v1 -> v2:
	  Dropped vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE.
	  RFC v1: https://lore.kernel.org/linux-iommu/1562324772-3084-1-git-send-email-yi.l.liu@intel.com/

---
Eric Auger (1):
  vfio: Document dual stage control

Liu Yi L (13):
  vfio/type1: Refactor vfio_iommu_type1_ioctl()
  iommu: Report domain nesting info
  iommu/smmu: Report empty domain nesting info
  vfio/type1: Report iommu nesting info to userspace
  vfio: Add PASID allocation/free support
  iommu/vt-d: Support setting ioasid set to domain
  vfio/type1: Add VFIO_IOMMU_PASID_REQUEST (alloc/free)
  iommu/vt-d: Check ownership for PASIDs from user-space
  vfio/type1: Support binding guest page tables to PASID
  vfio/type1: Allow invalidating first-level/stage IOMMU cache
  vfio/type1: Add vSVA support for IOMMU-backed mdevs
  vfio/pci: Expose PCIe PASID capability to guest
  iommu/vt-d: Support reporting nesting capability info

Yi Sun (1):
  iommu: Pass domain to sva_unbind_gpasid()

 Documentation/driver-api/vfio.rst  |  75 ++++
 drivers/iommu/arm-smmu-v3.c        |  29 +-
 drivers/iommu/arm-smmu.c           |  29 +-
 drivers/iommu/intel/iommu.c        | 114 +++++-
 drivers/iommu/intel/svm.c          |  10 +-
 drivers/iommu/iommu.c              |   2 +-
 drivers/vfio/Kconfig               |   6 +
 drivers/vfio/Makefile              |   1 +
 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/vfio_iommu_type1.c    | 796 ++++++++++++++++++++++++++++---------
 drivers/vfio/vfio_pasid.c          | 284 +++++++++++++
 include/linux/intel-iommu.h        |  23 +-
 include/linux/iommu.h              |   4 +-
 include/linux/vfio.h               |  54 +++
 include/uapi/linux/iommu.h         |  74 ++++
 include/uapi/linux/vfio.h          |  90 +++++
 16 files changed, 1391 insertions(+), 202 deletions(-)
 create mode 100644 drivers/vfio/vfio_pasid.c

-- 
2.7.4

