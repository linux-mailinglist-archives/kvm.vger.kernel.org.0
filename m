Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4900170BC94
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 13:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjEVL6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 07:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjEVL6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 07:58:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14323102;
        Mon, 22 May 2023 04:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684756674; x=1716292674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BLXMCQDrKINRByhqfbDyGSL06QEMe6DSv6ECfLWvVCc=;
  b=YJ+xLa1JTWeE3PZvGjJe8mw3GahTVea0wclrW5tDz5nf1zOq33Ur34SS
   2vyHTMNbxLfKrlTtJrPiHSSu6Hm7eKYmv2zdg58AsVgrYZtaO+vsEDsQz
   QPFvJAieXWcRoI9dUr2+M5cpoaipfJPLILFthqQBEHOJXTC5xsrqU7Stt
   qLbl02vAuYkVxYNJygfrTOVCUOGJwRiGWq5JUahh6kgp5pV607o3Hkhy5
   srWXrxmXa2vJbGarmlxke1GoMilpNEw+h1ne8xFCjOYN01cr9x5A2YLrn
   paBIuWYywLFOxLcr/w+xdEOYBfOXqqcmqmxXVke7E6edjFOww1gSNSbNq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="356128134"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="356128134"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 04:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815660158"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="815660158"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 04:57:52 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v6 00/10] Enhance vfio PCI hot reset for vfio cdev device
Date:   Mon, 22 May 2023 04:57:41 -0700
Message-Id: <20230522115751.326947-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

v6:
 - Remove noiommu_access, reuse iommufd_access instead (Alex)
 - vfio_iommufd_physical_ictx -> vfio_iommufd_device_ictx
 - vfio_iommufd_physical_devid -> vfio_iommufd_device_hot_reset_devid
 - Refine logic in patch 9 and 10 of v5, no uapi change. (Alex)
 - Remove lockdep asset in vfio_pci_is_device_in_set (Cédric)
 - Add t-b from Terrence (Tested GVT-g / GVT-d VFIO legacy mode / compat mode
   / cdev mode, including negative tests. No regression be introduced.)

v5: https://lore.kernel.org/kvm/20230513132136.15021-1-yi.l.liu@intel.com/
 - Drop patch 01 of v4 (Alex)
 - Create noiommu_access for noiommu devices (Jason)
 - Reserve all negative iommufd IDs, hence VFIO can encode negative
   values (Jason)
 - Make vfio_iommufd_physical_devid() return -EINVAL if it's not called
   with a physical device or a noiommu device.
 - Add vfio_find_device_in_devset() in vfio_main.c (Alex)
 - Add iommufd_ctx_has_group() to replace vfio_devset_iommufd_has_group().
   Reason: vfio_devset_iommufd_has_group() only loops the devices within
   the given devset to check the iommufd an iommu_group, but an iommu_group
   can span into multiple devsets. So if failed to find the group in a
   devset doesn't mean the group is not owned by the iommufd. So here either
   needs to search all the devsets or add an iommufd API to check it. It
   appears an iommufd API makes more sense.
 - Adopt suggestions from Alex on patch 08 and 09 of v4, refine the hot-reset
   uapi description and minor tweaks
 - Use bitfields for bool members (Alex)

v4: https://lore.kernel.org/kvm/20230426145419.450922-1-yi.l.liu@intel.com/
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

Yi Liu (10):
  vfio-iommufd: Create iommufd_access for noiommu devices
  vfio/pci: Update comment around group_fd get in
    vfio_pci_ioctl_pci_hot_reset()
  vfio/pci: Move the existing hot reset logic to be a helper
  iommufd: Reserve all negative IDs in the iommufd xarray
  iommufd: Add iommufd_ctx_has_group()
  iommufd: Add helper to retrieve iommufd_ctx and devid
  vfio: Mark cdev usage in vfio_device
  vfio: Add helper to search vfio_device in a dev_set
  vfio/pci: Extend VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device
    cdev
  vfio/pci: Allow passing zero-length fd array in
    VFIO_DEVICE_PCI_HOT_RESET

 drivers/iommu/iommufd/device.c   |  54 +++++++++++
 drivers/iommu/iommufd/main.c     |   2 +-
 drivers/vfio/iommufd.c           | 101 +++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 158 ++++++++++++++++++++++---------
 drivers/vfio/vfio_main.c         |  15 +++
 include/linux/iommufd.h          |  14 +++
 include/linux/vfio.h             |  24 +++++
 include/uapi/linux/vfio.h        |  60 +++++++++++-
 8 files changed, 377 insertions(+), 51 deletions(-)

-- 
2.34.1

