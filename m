Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93F82B41DB
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 12:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgKPLA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 06:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729283AbgKPLA4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 06:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605524454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QzuoH1p35VV4g03kwoyeAFURWii+1W0hJfGTpTcqbBw=;
        b=a8JWZ9c+8Vh3Drl51dRMLpvDr3elpJAcWx+OddYP8Nc0mYgT9XdjbLXzb06/uTVwh3hLt8
        i6XFcaKWG3tE8mjDYxMCJXb7DXGS5sBpgwcMf4pIUQrdQPe+2KcZMI7f5NtTpM95Uvltln
        Yqf6SLdaN6pgq/lMPUmADibXYidRPnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-raXlza9pOOy6h8sdQaSZuA-1; Mon, 16 Nov 2020 06:00:50 -0500
X-MC-Unique: raXlza9pOOy6h8sdQaSZuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6844C1902EC7;
        Mon, 16 Nov 2020 11:00:47 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B6F35C5AF;
        Mon, 16 Nov 2020 11:00:35 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com, yuzenghui@huawei.com
Subject: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (VFIO part)
Date:   Mon, 16 Nov 2020 12:00:17 +0100
Message-Id: <20201116110030.32335-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series brings the VFIO part of HW nested paging support
in the SMMUv3.

This is a rebase on top of v5.10-rc4

The series depends on:
[PATCH v12 00/15] SMMUv3 Nested Stage Setup (IOMMU part)

3 new IOCTLs are introduced that allow the userspace to
1) pass the guest stage 1 configuration
2) pass stage 1 MSI bindings
3) invalidate stage 1 related caches

They map onto the related new IOMMU API functions.

We introduce the capability to register specific interrupt
indexes (see [1]). A new DMA_FAULT interrupt index allows to register
an eventfd to be signaled whenever a stage 1 related fault
is detected at physical level. Also two specific regions allow to
- expose the fault records to the user space and
- inject page responses.

This latter functionality is not exercised in this series
but is provided as a POC for further vSVA activities (Shameer's input).

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/5.10-rc4-2stage-v12

The series series includes Tina's patch steming from
[1] "[RFC PATCH v2 1/3] vfio: Use capability chains to handle device
specific irq" plus patches originally contributed by Yi.

History:

v10 -> v11:
- rebase on top of v5.10-rc4
- adapt to changes on the IOMMU API (compliant with the doc
  written by Jacob/Yi)
- addition of the page response region
- Took into account Zenghui's comments
- In this version I have kept the ioctl separate. Since
  Yi's series [2] is currently stalled, I've just rebased here.

[2] [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
to VMs

v9 -> v10
- rebase on top of 5.6.0-rc3 (no change versus v9)

v8 -> v9:
- introduce specific irq framework
- single fault region
- iommu_unregister_device_fault_handler failure case not handled
  yet.

v7 -> v8:
- rebase on top of v5.2-rc1 and especially
  8be39a1a04c1  iommu/arm-smmu-v3: Add a master->domain pointer
- dynamic alloc of s1_cfg/s2_cfg
- __arm_smmu_tlb_inv_asid/s1_range_nosync
- check there is no HW MSI regions
- asid invalidation using pasid extended struct (change in the uapi)
- add s1_live/s2_live checks
- move check about support of nested stages in domain finalise
- fixes in error reporting according to the discussion with Robin
- reordered the patches to have first iommu/smmuv3 patches and then
  VFIO patches

v6 -> v7:
- removed device handle from bind/unbind_guest_msi
- added "iommu/smmuv3: Nested mode single MSI doorbell per domain
  enforcement"
- added few uapi comments as suggested by Jean, Jacop and Alex

v5 -> v6:
- Fix compilation issue when CONFIG_IOMMU_API is unset

v4 -> v5:
- fix bug reported by Vincent: fault handler unregistration now happens in
  vfio_pci_release
- IOMMU_FAULT_PERM_* moved outside of struct definition + small
  uapi changes suggested by Kean-Philippe (except fetch_addr)
- iommu: introduce device fault report API: removed the PRI part.
- see individual logs for more details
- reset the ste abort flag on detach

v3 -> v4:
- took into account Alex, jean-Philippe and Robin's comments on v3
- rework of the smmuv3 driver integration
- add tear down ops for msi binding and PASID table binding
- fix S1 fault propagation
- put fault reporting patches at the beginning of the series following
  Jean-Philippe's request
- update of the cache invalidate and fault API uapis
- VFIO fault reporting rework with 2 separate regions and one mmappable
  segment for the fault queue
- moved to PATCH

v2 -> v3:
- When registering the S1 MSI binding we now store the device handle. This
  addresses Robin's comment about discimination of devices beonging to
  different S1 groups and using different physical MSI doorbells.
- Change the fault reporting API: use VFIO_PCI_DMA_FAULT_IRQ_INDEX to
  set the eventfd and expose the faults through an mmappable fault region

v1 -> v2:
- Added the fault reporting capability
- asid properly passed on invalidation (fix assignment of multiple
  devices)
- see individual change logs for more info


Eric Auger (10):
  vfio: VFIO_IOMMU_SET_MSI_BINDING
  vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
  vfio/pci: Register an iommu fault handler
  vfio/pci: Allow to mmap the fault queue
  vfio/pci: Add framework for custom interrupt indices
  vfio: Add new IRQ for DMA fault reporting
  vfio/pci: Register and allow DMA FAULT IRQ signaling
  vfio: Document nested stage control
  vfio/pci: Register a DMA fault response region
  vfio/pci: Inject page response upon response region fill

Liu, Yi L (2):
  vfio: VFIO_IOMMU_SET_PASID_TABLE
  vfio: VFIO_IOMMU_CACHE_INVALIDATE

Tina Zhang (1):
  vfio: Use capability chains to handle device specific irq

 Documentation/driver-api/vfio.rst   |  77 +++++
 drivers/vfio/pci/vfio_pci.c         | 430 ++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_intrs.c   |  62 ++++
 drivers/vfio/pci/vfio_pci_private.h |  33 +++
 drivers/vfio/pci/vfio_pci_rdwr.c    |  84 ++++++
 drivers/vfio/vfio_iommu_type1.c     | 186 ++++++++++++
 include/uapi/linux/vfio.h           | 140 ++++++++-
 7 files changed, 993 insertions(+), 19 deletions(-)

-- 
2.21.3

