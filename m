Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503A65A366F
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 11:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiH0Jtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 05:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiH0Jtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 05:49:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4BA282;
        Sat, 27 Aug 2022 02:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661593787; x=1693129787;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uvIblq34aYIPJlbRVx73G0ZjG5Pc8EFbqlJh/UMzIhQ=;
  b=BDLoQ8z8xR74yTmC6sfSDyZkdpky0EZrFHA/xyDtzU2ZlPDsO7nsJo58
   ymh64BBngCVEJDCfFJwldBLiASD366HEzJnT+Tdfcnkjh1P9iF3fOEq7h
   KYuu2sNmvT6kBtgnKu83AyyvKnXsXd5uv9hzurGUjhxAd1qZl+fwkkm0C
   3GdtOjdW7GuNuTvJSnEUi1evC6CKeG9gXInanUvplJXQbmIufwMMgwRek
   x4Ell/ecic4HU+PfpjI5GfIuFfVF3wwbELONbl3MLH322f1VjXTTT8aUO
   Ri4qXZRPZ7FS7ia1k66kNrBLooTYiqFR1tI48SdlwLSQP2QfAVuurLWvK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="356365703"
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="356365703"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2022 02:49:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="640353741"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2022 02:49:38 -0700
From:   Kevin Tian <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 00/15] Tidy up vfio_device life cycle
Date:   Sun, 28 Aug 2022 01:10:22 +0800
Message-Id: <20220827171037.30297-1-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea is to let vfio core manage the vfio_device life cycle instead
of duplicating the logic cross drivers. Besides cleaner code in driver
side this also allows adding struct device to vfio_device as the first
step toward adding cdev uAPI in the future. Another benefit is that
user can now look at sysfs to decide whether a device is bound to
vfio [1], e.g.:

	/sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0

Though most drivers can fit the new model naturally:

 - vfio_alloc_device() to allocate and initialize vfio_device
 - vfio_put_device() to release vfio_device
 - dev_ops->init() for driver private initialization
 - dev_ops->release() for driver private cleanup

vfio-ccw is the only exception due to a life cycle mess that its private
structure mixes both parent and mdev info hence must be alloc/free'ed
outside of the life cycle of vfio device.

Per prior discussions this won't be fixed in short term by IBM folks [2].

Instead of waiting this series introduces a few tricks to move forward:

 - vfio_init_device() to initialize a pre-allocated device structure;

 - require *EVERY* driver to implement @release and free vfio_device
   inside. Then vfio-ccw can use a completion mechanism to delay the
   free to css driver;

The second trick is not a real burden to other drivers because they
all require a @release for private cleanup anyay. Later once the ccw
mess is fixed a simple cleanup can be done by moving free from @release
to vfio core.

Thanks
Kevin

[1] https://listman.redhat.com/archives/libvir-list/2022-August/233482.html
[2] https://lore.kernel.org/all/0ee29bd6583f17f0ee4ec0769fa50e8ea6703623.camel@linux.ibm.com/

Kevin Tian (6):
  vfio: Add helpers for unifying vfio_device life cycle
  drm/i915/gvt: Use the new device life cycle helpers
  vfio/platform: Use the new device life cycle helpers
  vfio/amba: Use the new device life cycle helpers
  vfio/ccw: Use the new device life cycle helpers
  vfio: Rename vfio_device_put() and vfio_device_try_get()

Yi Liu (9):
  vfio/pci: Use the new device life cycle helpers
  vfio/mlx5: Use the new device life cycle helpers
  vfio/hisi_acc: Use the new device life cycle helpers
  vfio/mdpy: Use the new device life cycle helpers
  vfio/mtty: Use the new device life cycle helpers
  vfio/mbochs: Use the new device life cycle helpers
  vfio/ap: Use the new device life cycle helpers
  vfio/fsl-mc: Use the new device life cycle helpers
  vfio: Add struct device to vfio_device

 drivers/gpu/drm/i915/gvt/gvt.h                |   5 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  52 ++++--
 drivers/gpu/drm/i915/gvt/vgpu.c               |  31 ++--
 drivers/s390/cio/vfio_ccw_ops.c               |  52 +++++-
 drivers/s390/cio/vfio_ccw_private.h           |   3 +
 drivers/s390/crypto/vfio_ap_ops.c             |  50 +++---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  87 +++++----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  80 ++++-----
 drivers/vfio/pci/mlx5/main.c                  |  49 ++++--
 drivers/vfio/pci/vfio_pci.c                   |  20 +--
 drivers/vfio/pci/vfio_pci_core.c              |  23 ++-
 drivers/vfio/platform/vfio_amba.c             |  72 ++++++--
 drivers/vfio/platform/vfio_platform.c         |  66 +++++--
 drivers/vfio/platform/vfio_platform_common.c  |  61 +++----
 drivers/vfio/platform/vfio_platform_private.h |  18 +-
 drivers/vfio/vfio_main.c                      | 165 +++++++++++++++---
 include/linux/vfio.h                          |  29 ++-
 include/linux/vfio_pci_core.h                 |   6 +-
 samples/vfio-mdev/mbochs.c                    |  73 +++++---
 samples/vfio-mdev/mdpy.c                      |  81 +++++----
 samples/vfio-mdev/mtty.c                      |  67 ++++---
 21 files changed, 724 insertions(+), 366 deletions(-)


base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.21.3

