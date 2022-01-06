Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D16485E8B
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbiAFCVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:21:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:45635 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbiAFCVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435710; x=1672971710;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=exYGrLYHGT8TzV5cnLFjwED9oszGYl1Sy9IWfWRq36I=;
  b=cuwTyMkeJolBJHmcVUEKxaW0eLo+70SwxNCTRo71qdu6RO2Qi0BSy9O0
   ugXDlsncJ1EyHpDcVR7nPg/dEE/aTBOmdT/VLTe120oF9U/b2AMsrkSG/
   M/NFd/detzUax6hMhgj+3VCnnb/snulDToiBEL+CAHXaCds0fq/4aQzr5
   ZIFKGtPZ9dY0mpLjvFnJXCea6dD3ljF9tiEkmBl23yJBn69EpSVxgevv6
   FAADQ7ZOm+MlHTmqDSLgISxoPKzpLrCfud2JxTsmaHHipjLW0nvLZLs3v
   D2JmHzvR8a15K6mC/Fn8DopYKukqnNZmiUAQKWExGxNCQBI0H56agJXf1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229389157"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="229389157"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:21:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794259"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:21:42 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v1 0/8] Scrap iommu_attach/detach_group() interfaces
Date:   Thu,  6 Jan 2022 10:20:45 +0800
Message-Id: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

The iommu_attach_device() added first by commit <fc2100eb4d096> ("add
frontend implementation for the IOMMU API") in 2008. At that time,
there was no concept of iommu group yet.

The iommu group was added by commit <d72e31c937462> ("iommu: IOMMU
Groups") four years later in 2012. The iommu_attach_group() was added
at the same time.

Then, people realized that iommu_attach_device() allowed different
device in a same group to attach different domain. This was not in
line with the concept of iommu group. The commit <426a273834eae>
("iommu: Limit iommu_attach/detach_device to device with their own
group") fixed this problem in 2015.

As the result, we have two coexisting interfaces for device drivers
to do the same thing. But neither is perfect:

  - iommu_attach_device() only works for singleton group.
  - iommu_attach_group() asks the device drivers to handle iommu group
    related staff which is beyond the role of a device driver.

Considering from the perspective of a device driver, its motivation is
very simple: "I want to manage my own I/O address space." Inspired by
the discussion [1], we consider heading in this direction:

Make the iommu_attach_device() the only and generic interface for the
device drivers to use their own private domain (I/O address space)
and replace all iommu_attach_group() uses with iommu_attach_device()
and deprecate the former.

This is a follow-up series of this discussion: 
[1] https://lore.kernel.org/linux-iommu/b4405a5e-c4cc-f44a-ab43-8cb62b888565@linux.intel.com/

It depends on the series of "Fix BUG_ON in vfio_iommu_group_notifier()".
The latest version was posted here:
https://lore.kernel.org/linux-iommu/20220104015644.2294354-1-baolu.lu@linux.intel.com/

and the whole patches are available on github:
https://github.com/LuBaolu/intel-iommu/commits/iommu-domain-attach-refactor-v1

Best regards,
baolu

Jason Gunthorpe (1):
  drm/tegra: Use iommu_attach/detatch_device()

Lu Baolu (7):
  iommu: Add iommu_group_replace_domain()
  vfio/type1: Use iommu_group_replace_domain()
  iommu: Extend iommu_at[de]tach_device() for multi-device groups
  iommu/amd: Use iommu_attach/detach_device()
  gpu/host1x: Use iommu_attach/detach_device()
  media: staging: media: tegra-vde: Use iommu_attach/detach_device()
  iommu: Remove iommu_attach/detach_group()

 include/linux/iommu.h                   |  25 ++---
 drivers/gpu/drm/tegra/dc.c              |   1 +
 drivers/gpu/drm/tegra/drm.c             |  47 +++-----
 drivers/gpu/drm/tegra/gr2d.c            |   1 +
 drivers/gpu/drm/tegra/gr3d.c            |   1 +
 drivers/gpu/drm/tegra/vic.c             |   1 +
 drivers/gpu/host1x/dev.c                |   4 +-
 drivers/iommu/amd/iommu_v2.c            |   4 +-
 drivers/iommu/iommu.c                   | 136 +++++++++++++++++-------
 drivers/staging/media/tegra-vde/iommu.c |   6 +-
 drivers/vfio/vfio_iommu_type1.c         |  22 ++--
 11 files changed, 146 insertions(+), 102 deletions(-)

-- 
2.25.1

