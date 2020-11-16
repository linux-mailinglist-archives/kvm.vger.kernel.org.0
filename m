Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899012B4183
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 11:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgKPKnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 05:43:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbgKPKni (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 05:43:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605523418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uXqx5Ho/BGflxGNGIUa2LXehbjyeIn4bhOsfc7gDmnk=;
        b=OyvZcUve3fwiEbUVcrvSQC42ZWYOtzk2gKWGjqVfWTuNy8J0xq1tXvXhu1hz0VrL+AxtHb
        7VEK/NnJV97jORdSadJJtzap5nCKBVCC7lCMuVEXiY2oMQsMFo5SiA7X6aMVP5EXddYuhH
        Y5Gy1spmjj9HjWuiaQUzRBc5wZioXIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-RCDH81_pM9Slp_IaylvHhg-1; Mon, 16 Nov 2020 05:43:32 -0500
X-MC-Unique: RCDH81_pM9Slp_IaylvHhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49FF78030D1;
        Mon, 16 Nov 2020 10:43:30 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 267A15C5AF;
        Mon, 16 Nov 2020 10:43:18 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, tn@semihalf.com,
        nicoleotsuka@gmail.com
Subject: [PATCH v12 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
Date:   Mon, 16 Nov 2020 11:43:01 +0100
Message-Id: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series brings the IOMMU part of HW nested paging support
in the SMMUv3. The VFIO part is submitted separately.

The IOMMU API is extended to support 2 new API functionalities:
1) pass the guest stage 1 configuration
2) pass stage 1 MSI bindings

Then those capabilities gets implemented in the SMMUv3 driver.

The virtualizer passes information through the VFIO user API
which cascades them to the iommu subsystem. This allows the guest
to own stage 1 tables and context descriptors (so-called PASID
table) while the host owns stage 2 tables and main configuration
structures (STE).

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/5.10-rc4-2stage-v12
(including the VFIO part)

The series includes a patch from Jean-Philippe. It is better to
review the original patch:
[PATCH v8 2/9] iommu/arm-smmu-v3: Maintain a SID->device structure

The VFIO series is sent separately.

History:

v11 -> v12:
- rebase on top of v5.10-rc4

Two new patches paving the way for vSVA/ARM (Shameer's input)
- iommu/smmuv3: Accept configs with more than one context descriptor
- iommu/smmuv3: Add PASID cache invalidation per PASID

v10 -> v11:
- S2TTB reset when S2 is off
- fix compil issue when CONFIG_IOMMU_DMA is not set

v9 -> v10:
- rebase on top of 5.6.0-rc3

v8 -> v9:
- rebase on 5.3
- split iommu/vfio parts

v6 -> v8:
- Implement VFIO-PCI device specific interrupt framework

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


Eric Auger (15):
  iommu: Introduce attach/detach_pasid_table API
  iommu: Introduce bind/unbind_guest_msi
  iommu/arm-smmu-v3: Maintain a SID->device structure
  iommu/smmuv3: Dynamically allocate s1_cfg and s2_cfg
  iommu/smmuv3: Get prepared for nested stage support
  iommu/smmuv3: Implement attach/detach_pasid_table
  iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
  iommu/smmuv3: Implement cache_invalidate
  dma-iommu: Implement NESTED_MSI cookie
  iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
  iommu/smmuv3: Enforce incompatibility between nested mode and HW MSI
    regions
  iommu/smmuv3: Implement bind/unbind_guest_msi
  iommu/smmuv3: Report non recoverable faults
  iommu/smmuv3: Accept configs with more than one context descriptor
  iommu/smmuv3: Add PASID cache invalidation per PASID

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 650 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  98 ++-
 drivers/iommu/dma-iommu.c                   | 142 ++++-
 drivers/iommu/iommu.c                       | 104 ++++
 include/linux/dma-iommu.h                   |  16 +
 include/linux/iommu.h                       |  41 ++
 include/uapi/linux/iommu.h                  |  54 ++
 7 files changed, 1035 insertions(+), 70 deletions(-)

-- 
2.21.3

