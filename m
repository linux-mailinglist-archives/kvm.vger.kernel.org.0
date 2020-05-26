Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7321A81D5
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437995AbgDNPQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 11:16:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407288AbgDNPGo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 11:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586876802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gD722PN6ndX2Ky7HUW8f5x6XQX7yxgYbbOC6l5hh6w8=;
        b=Z/lndZOZDXPNxHWq52ZvVy9GjGXP/++Pt2LQkCTNPsHkV9d0obiAH23lyYAiNJhP3Npa3A
        GI7mq0L0eb+ASlUiFjZSg7QNVNfVH8YGRWhwEcGlbxmNnJXFv5fKqyIDYsTCxr5ubFJzCo
        +guGe5PUlto+Lni8W/o9dlgGBQk4hHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-CkgRZL-OMimvAKL0BDNpJA-1; Tue, 14 Apr 2020 11:06:37 -0400
X-MC-Unique: CkgRZL-OMimvAKL0BDNpJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 459CD800D5C;
        Tue, 14 Apr 2020 15:06:34 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CADD19C69;
        Tue, 14 Apr 2020 15:06:23 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        shameerali.kolothum.thodi@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        peter.maydell@linaro.org, zhangfei.gao@gmail.com, tn@semihalf.com,
        zhangfei.gao@foxmail.com, bbhushan2@marvell.com
Subject: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Date:   Tue, 14 Apr 2020 17:05:54 +0200
Message-Id: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This version fixes an issue observed by Shameer on an SMMU 3.2,
when moving from dual stage config to stage 1 only config.
The 2 high 64b of the STE now get reset. Otherwise, leaving the
S2TTB set may cause a C_BAD_STE error.

This series can be found at:
https://github.com/eauger/linux/tree/v5.6-2stage-v11_10.1
(including the VFIO part)
The QEMU fellow series still can be found at:
https://github.com/eauger/qemu/tree/v4.2.0-2stage-rfcv6

Users have expressed interest in that work and tested v9/v10:
- https://patchwork.kernel.org/cover/11039995/#23012381
- https://patchwork.kernel.org/cover/11039995/#23197235

Background:

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


History:

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
- fix bug reported by Vincent: fault handler unregistration now happens i=
n
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
- When registering the S1 MSI binding we now store the device handle. Thi=
s
  addresses Robin's comment about discimination of devices beonging to
  different S1 groups and using different physical MSI doorbells.
- Change the fault reporting API: use VFIO_PCI_DMA_FAULT_IRQ_INDEX to
  set the eventfd and expose the faults through an mmappable fault region

v1 -> v2:
- Added the fault reporting capability
- asid properly passed on invalidation (fix assignment of multiple
  devices)
- see individual change logs for more info

Eric Auger (11):
  iommu: Introduce bind/unbind_guest_msi
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

Jacob Pan (1):
  iommu: Introduce attach/detach_pasid_table API

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Maintain a SID->device structure

 drivers/iommu/arm-smmu-v3.c | 744 ++++++++++++++++++++++++++++++++----
 drivers/iommu/dma-iommu.c   | 142 ++++++-
 drivers/iommu/iommu.c       |  56 +++
 include/linux/dma-iommu.h   |  16 +
 include/linux/iommu.h       |  38 ++
 include/uapi/linux/iommu.h  |  51 +++
 6 files changed, 975 insertions(+), 72 deletions(-)

--=20
2.20.1

