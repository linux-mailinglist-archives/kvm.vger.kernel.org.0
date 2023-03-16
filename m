Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571946BCF22
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjCPMPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPMP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:15:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35862FFB;
        Thu, 16 Mar 2023 05:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678968928; x=1710504928;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sxytFivzmEF3JiIZ5gxIgrAj7qk6BTLqEQSy5lsJZpY=;
  b=AQ8QqBosq/3VVKoOPEzh6txq85zusjYyhtoOQku6PaD7cgaLhoXed5MV
   jgiuGmRQ0kLcbyc0LhwDm6Ke9WhK2aVVAlf7YaIPY63J+/410pV7FOcK9
   U4YPK65io7Ocj7ATu5N8xTJk2gPFtgnGrDxpgH+gUU+iTmQvqaixNuMF5
   6KGm+Jh/9q7by2hEI9HsPOpHcR+yZxQ9kO0AGFZGsEGfH7OT+xYsYdnGh
   QyTAZs8oz2NVUw6syejlwxcHahouCQyGl0sbcBtfD2wVwI2LJXlyNLeMH
   PVFnVTbg5+AwTOwvZmPyuiUZEcb7ON+cqWNUWIbHGoPORDF3vJ/NKRzTc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336661357"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336661357"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:15:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="679874203"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679874203"
Received: from unknown (HELO 984fee00a4c6.jf.intel.com) ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 05:15:27 -0700
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
Subject: [PATCH v2 0/5] vfio: Make emulated devices prepared for vfio device cdev
Date:   Thu, 16 Mar 2023 05:15:21 -0700
Message-Id: <20230316121526.5644-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

v2:
 - Add r-b from Kevin and Jason
 - Refine patch 01 per comments from Jason and Kevin

v1: https://lore.kernel.org/kvm/20230308131340.459224-1-yi.l.liu@intel.com/

Thanks,
	Yi Liu

Nicolin Chen (1):
  iommufd: Create access in vfio_iommufd_emulated_bind()

Yi Liu (4):
  vfio-iommufd: No need to record iommufd_ctx in vfio_device
  vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access
    ID
  vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample
    drivers
  vfio: Check the presence for iommufd callbacks in
    __vfio_register_dev()

 drivers/iommu/iommufd/device.c   | 57 ++++++++++++++++++++------------
 drivers/iommu/iommufd/selftest.c |  8 +++--
 drivers/vfio/iommufd.c           | 39 +++++++++++-----------
 drivers/vfio/vfio_main.c         |  5 +--
 include/linux/iommufd.h          |  5 +--
 include/linux/vfio.h             |  1 -
 samples/vfio-mdev/mbochs.c       |  3 ++
 samples/vfio-mdev/mdpy.c         |  3 ++
 samples/vfio-mdev/mtty.c         |  3 ++
 9 files changed, 76 insertions(+), 48 deletions(-)

-- 
2.34.1

