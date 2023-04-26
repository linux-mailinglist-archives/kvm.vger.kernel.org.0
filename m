Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5806EF6C5
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbjDZOy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbjDZOy0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:54:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034906E91;
        Wed, 26 Apr 2023 07:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682520864; x=1714056864;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4m9wk/nfUu+Ko6ZOipEux5/ofaGiWcx58iIPXEvzblM=;
  b=WiLWAfFkIQtiyZ+muKWk/fKmYW4sDI4OHNVcUtW97+R3c1JqYFQoUhMV
   FJZ0kcqjIR+2nyfB+RcsHyrkzJX4tcqNWirSmm5+jo8ojQ8O1YSxiEVDc
   GF8Nf5hGiRU4WHadT2ysLJYgJ1YoZ4FWb9NiabuzS0dyznpWTZk+fqh6U
   UvSQ7fIgbCuzRV/MzBvCgaPsVUSPtJ+lTOxCk2GJEs6q8DB0kQCjoF84v
   EEqYDC4t8pThmK0Qpz1UW6IK0Uhd6rqX5iqFtOSFvDoT3KRJXjqCf2miW
   KunAhB/HlwxNLtYIxolXs/LcP/HpZ947yuTAtvSpRJ9RIGaGpaRZLucFh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433410206"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="433410206"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 07:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758643974"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="758643974"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2023 07:54:21 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com
Subject: [PATCH v4 0/9] Enhance vfio PCI hot reset for vfio cdev device
Date:   Wed, 26 Apr 2023 07:54:10 -0700
Message-Id: <20230426145419.450922-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds
to prove that it owns all devices affected by resetting the calling
device. While for cdev devices, user can use an iommufd-based ownership
checking model and invoke VFIO_DEVICE_PCI_HOT_RESET with a zero-length
fd array.

This series first creates iommufd_access for noiommu devices to fill the
gap for adding iommufd-based ownership checking model, then extends
VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to check ownership and return the
check result and the devid of affected devices to user. In the end, extends
the VFIO_DEVICE_PCI_HOT_RESET to accept zero-length fd array for hot-reset
with cdev devices.

The new hot reset method and updated _INFO ioctl are tested with the
below qemu:

https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3
(requires to test with the cdev kernel)

Change log:

v4:
 - Rename the patch series subject
 - Patch 01 is moved from the cdev series
 - Patch 02, 06 are new per review comments in v3
 - Patch 03/04/05/07/08/09 are from v3 with updates

v3: https://lore.kernel.org/kvm/20230401144429.88673-1-yi.l.liu@intel.com/
 - Remove the new _INFO ioctl of v2, extend the existing _INFO ioctl to
   report devid (Alex)
 - Add r-b from Jason
 - Add t-b from Terrence Xu and Yanting Jiang (mainly regression test)

v2: https://lore.kernel.org/kvm/20230327093458.44939-1-yi.l.liu@intel.com/
 - Split the patch 03 of v1 to be 03, 04 and 05 of v2 (Jaon)
 - Add r-b from Kevin and Jason
 - Add patch 10 to introduce a new _INFO ioctl for the usage of device
   fd passing usage in cdev path (Jason, Alex)

v1: https://lore.kernel.org/kvm/20230316124156.12064-1-yi.l.liu@intel.com/

Regards,
	Yi Liu

Yi Liu (9):
  vfio: Determine noiommu in vfio_device registration
  vfio-iommufd: Create iommufd_access for noiommu devices
  vfio/pci: Update comment around group_fd get in
    vfio_pci_ioctl_pci_hot_reset()
  vfio/pci: Move the existing hot reset logic to be a helper
  vfio: Mark cdev usage in vfio_device
  iommufd: Reserved -1 in the iommufd xarray
  vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for
    vfio_device
  vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device
    cdev
  vfio/pci: Allow passing zero-length fd array in
    VFIO_DEVICE_PCI_HOT_RESET

 drivers/iommu/iommufd/device.c   |  24 ++++
 drivers/iommu/iommufd/main.c     |   5 +-
 drivers/vfio/iommufd.c           |  48 +++++--
 drivers/vfio/pci/vfio_pci_core.c | 223 +++++++++++++++++++++++++------
 drivers/vfio/vfio.h              |   7 +-
 drivers/vfio/vfio_main.c         |   4 +
 include/linux/iommufd.h          |   6 +
 include/linux/vfio.h             |  22 +++
 include/uapi/linux/vfio.h        |  61 ++++++++-
 9 files changed, 347 insertions(+), 53 deletions(-)

-- 
2.34.1

