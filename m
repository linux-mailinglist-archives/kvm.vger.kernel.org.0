Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737BC2B7C74
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 12:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgKRLWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 06:22:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbgKRLWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 06:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605698534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JkykavBXCXxc/Cc+EpSfpWb6eYs51ekKp9L7LE1iLx4=;
        b=a8BsEnMrTFyehj4YOzyc9yRHvyjaqCcSy99J1KOH5D+kQTKyU06NIAh63y7fpaDhAuitlK
        pEP3hDkFk3Ehda7zWcdEU+ZC2VM99Yc1CkU9bN4hv1DZdR/4ww0jRwFxnbfz5IJV3+JyZR
        nbdXOhGS8s4IpkduF1+nXEHBAPqJFVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-XmM7ArIhOz2XA7mA8hwAKw-1; Wed, 18 Nov 2020 06:22:10 -0500
X-MC-Unique: XmM7ArIhOz2XA7mA8hwAKw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11DC873079;
        Wed, 18 Nov 2020 11:22:07 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-104.ams2.redhat.com [10.36.115.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46D9F51512;
        Wed, 18 Nov 2020 11:21:54 +0000 (UTC)
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
Subject: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
Date:   Wed, 18 Nov 2020 12:21:36 +0100
Message-Id: <20201118112151.25412-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
(including the VFIO part in his last version: v11)

The series includes a patch from Jean-Philippe. It is better to
review the original patch:
[PATCH v8 2/9] iommu/arm-smmu-v3: Maintain a SID->device structure

The VFIO series is sent separately.

History:

v12 -> v13:
- fixed compilation issue with CONFIG_ARM_SMMU_V3_SVA
  reported by Shameer. This urged me to revisit patch 4 into
  iommu/smmuv3: Allow s1 and s2 configs to coexist where
  s1_cfg and s2_cfg are not dynamically allocated anymore.
  Instead I use a new set field in existing structs
- fixed 2 others config checks
- Updated "iommu/arm-smmu-v3: Maintain a SID->device structure"
  according to the last version

v11 -> v12:
- rebase on top of v5.10-rc4

Eric Auger (14):
  iommu: Introduce attach/detach_pasid_table API
  iommu: Introduce bind/unbind_guest_msi
  iommu/smmuv3: Allow s1 and s2 configs to coexist
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

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Maintain a SID->device structure

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 659 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 103 ++-
 drivers/iommu/dma-iommu.c                   | 142 ++++-
 drivers/iommu/iommu.c                       | 105 ++++
 include/linux/dma-iommu.h                   |  16 +
 include/linux/iommu.h                       |  41 ++
 include/uapi/linux/iommu.h                  |  54 ++
 7 files changed, 1042 insertions(+), 78 deletions(-)

-- 
2.21.3

