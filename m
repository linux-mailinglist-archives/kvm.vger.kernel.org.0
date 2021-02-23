Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959833232B3
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 22:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhBWU7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:59:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234536AbhBWU7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 15:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614113855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dspjyoruL6FYvLVfk5NSTgJZHzGM/NlapNw3ZfaV3DI=;
        b=SIXOPfo6TSbrbyYHIjCVHPIxbYU1TihXTK+UWqPc/UKRLA7HXWQ3n6pl7PyOkSUaPmkmBx
        uXOlpzEOyBu5wzsMrHd6P+ebRva6Q11xTXaGi58umFfKvpdw/l8WhvC2r6jL/GhFQFeIkb
        PwTcvUKS96v3Qezjm/+TcbHQgO1dPbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-iiKcvpHJP16wVJHD1fCK1Q-1; Tue, 23 Feb 2021 15:56:51 -0500
X-MC-Unique: iiKcvpHJP16wVJHD1fCK1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 306A3835E25;
        Tue, 23 Feb 2021 20:56:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6207F5D9D0;
        Tue, 23 Feb 2021 20:56:36 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
Subject: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Date:   Tue, 23 Feb 2021 21:56:21 +0100
Message-Id: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series brings the IOMMU part of HW nested paging support
in the SMMUv3. The VFIO part is submitted separately.

This is based on Jean-Philippe's
[PATCH v12 00/10] iommu: I/O page faults for SMMUv3
https://lore.kernel.org/linux-arm-kernel/YBfij71tyYvh8LhB@myrica/T/

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
https://github.com/eauger/linux/tree/v5.11-stallv12-2stage-v14
(including the VFIO part in its last version: v12)

The VFIO series is sent separately.

History:

Previous version (v13):
https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13

v13 -> v14:
- Took into account all received comments I think. Great
  thanks to all the testers for their effort and sometimes
  fixes. I am really grateful to you!
- numerous fixes including guest running in
  noiommu, iommu.strict=0, iommu.passthrough=on,
  enable_unsafe_noiommu_mode

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

Eric Auger (13):
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
  iommu/smmuv3: report additional recoverable faults
  iommu/smmuv3: Accept configs with more than one context descriptor

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 444 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 +-
 drivers/iommu/dma-iommu.c                   | 142 ++++++-
 drivers/iommu/iommu.c                       | 106 +++++
 include/linux/dma-iommu.h                   |  16 +
 include/linux/iommu.h                       |  47 +++
 include/uapi/linux/iommu.h                  |  54 +++
 7 files changed, 781 insertions(+), 42 deletions(-)

-- 
2.26.2

