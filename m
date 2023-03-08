Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305296B0883
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjCHNUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjCHNT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:19:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821A9DB6ED;
        Wed,  8 Mar 2023 05:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678281371; x=1709817371;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jonEG8yk9naLkZYL/M4HRCN722cu+ImMHdIJf3nmHqM=;
  b=MqkD0RDUdaAy07BYZjMXGVl55J1fHzrzFlZnJIX82ykOcbm7Qu3EcHCK
   ShzWAkA/p/GH1U4YUMyTHZFcvbo2JR2XkjddVmNOu+1Z6rV3QoUffekZp
   aSsKh/yyqeo5QS9sXFW/ZntbUKVRLxOxSlXcre6A65bHcUGKG4dVT9kQ7
   ve8LQLgtc4NR2nvkaB3qf2OFmOW1Hi7c+r7fSY/gPGcp3Fpc6GgDfEnet
   9AdCWSKH63TGYpg1Ki/Lml6cBmJz6pq8+NbhzxwAJ+Ac4c5FEUcV4NCcV
   QuHJatL6T7+6eBHJ4eY6X6qxO5q2JzZEjMByKmr09OREbgwdhzwUkUDIf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338474763"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338474763"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:13:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="670330894"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="670330894"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 08 Mar 2023 05:13:41 -0800
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v1 0/5] vfio: Make emulated devices prepared for vfio device cdev
Date:   Wed,  8 Mar 2023 05:13:35 -0800
Message-Id: <20230308131340.459224-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
iommufd op set.

Thanks,
	Yi Liu

Nicolin Chen (1):
  iommufd: Create access in vfio_iommufd_emulated_bind()

Yi Liu (4):
  vfio-iommufd: No need to record iommufd_ctx in vfio_device
  vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access
    ID
  Samples/mdev: Uses the vfio emulated iommufd ops set in the mdev
    sample drivers
  vfio: Check the presence for iommufd callbacks in
    __vfio_register_dev()

 drivers/iommu/iommufd/device.c          | 107 ++++++++++++++++++------
 drivers/iommu/iommufd/iommufd_private.h |   1 +
 drivers/iommu/iommufd/selftest.c        |   8 +-
 drivers/vfio/iommufd.c                  |  35 ++++----
 drivers/vfio/vfio_main.c                |   5 +-
 include/linux/iommufd.h                 |   5 +-
 include/linux/vfio.h                    |   1 -
 samples/vfio-mdev/mbochs.c              |   3 +
 samples/vfio-mdev/mdpy.c                |   3 +
 samples/vfio-mdev/mtty.c                |   3 +
 10 files changed, 119 insertions(+), 52 deletions(-)

-- 
2.34.1

