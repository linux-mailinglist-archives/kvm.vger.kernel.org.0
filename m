Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F008A6C9FA9
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjC0Jeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbjC0JeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:34:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E854EEF;
        Mon, 27 Mar 2023 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909640; x=1711445640;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VkV/8FTePBOMnCIePLYijAz1Ei748yULDz/BHYMAuKo=;
  b=gavowbTKP1cz6KYbqF5AOiEWJW/m6WMy+PRAAK6T5zML54KqbtEVqFBb
   TqXOmtUU1lLkjuKMq+Fn4lek6zB0Y5zXdS5FOl9zFe9BZBuM/lDYeodO3
   9iYCSkEDwD0w/p7Y69V7yEYVuOWxTUrvrJ7Kn9piemYObJek1yGEfEdNA
   7oTfj2sluOtc6/R6dekpdE0S6yUkN9IyA2gLCM64jGDfgcRIQfUZNZGyt
   3GiOdziCmaR/lCWfKxMna172CnlIQq5wpYfY8ebKOEvsBaHby3anGBYfS
   ZdxULwM29bG0YoLUl/j3AXgNECOBLmITt29BfysCRKst6vO9TWLmR+wvf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="402817903"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="402817903"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:33:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="685908071"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="685908071"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2023 02:33:53 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio device cdev
Date:   Mon, 27 Mar 2023 02:33:45 -0700
Message-Id: <20230327093351.44505-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The .bind_iommufd op of vfio emulated devices are either empty or does
nothing. This is different with the vfio physical devices, to add vfio
device cdev, need to make them act the same.

This series first makes the .bind_iommufd op of vfio emulated devices
to create iommufd_access, this introduces a new iommufd API. Then let
the driver that does not provide .bind_iommufd op to use the vfio emulated
iommufd op set. This makes all vfio device drivers have consistent iommufd
operations, which is good for adding new device uAPIs in the device cdev
series.

Change log:

v3:
 - Use iommufd_get_ioas() for ioas get, hence patch 01 is added to modify
   the input parameter of iommufd_get_ioas(). (Jason)
 - Add r-b from Jason and Kevin
 - Add t-b from Terrence Xu

v2: https://lore.kernel.org/kvm/20230316121526.5644-1-yi.l.liu@intel.com/
 - Add r-b from Kevin and Jason
 - Refine patch 01 per comments from Jason and Kevin

v1: https://lore.kernel.org/kvm/20230308131340.459224-1-yi.l.liu@intel.com/

Thanks,
        Yi Liu
    
Nicolin Chen (1):
  iommufd: Create access in vfio_iommufd_emulated_bind()

Yi Liu (5):
  iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
  vfio-iommufd: No need to record iommufd_ctx in vfio_device
  vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access
    ID
  vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample
    drivers
  vfio: Check the presence for iommufd callbacks in
    __vfio_register_dev()

 drivers/iommu/iommufd/device.c          | 55 +++++++++++++++----------
 drivers/iommu/iommufd/ioas.c            | 14 +++----
 drivers/iommu/iommufd/iommufd_private.h |  4 +-
 drivers/iommu/iommufd/selftest.c        | 14 ++++---
 drivers/iommu/iommufd/vfio_compat.c     |  2 +-
 drivers/vfio/iommufd.c                  | 37 ++++++++---------
 drivers/vfio/vfio_main.c                |  5 ++-
 include/linux/iommufd.h                 |  5 ++-
 include/linux/vfio.h                    |  1 -
 samples/vfio-mdev/mbochs.c              |  3 ++
 samples/vfio-mdev/mdpy.c                |  3 ++
 samples/vfio-mdev/mtty.c                |  3 ++
 12 files changed, 85 insertions(+), 61 deletions(-)

-- 
2.34.1

