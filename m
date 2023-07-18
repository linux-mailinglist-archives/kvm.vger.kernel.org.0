Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E973C7579BD
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 12:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjGRKzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 06:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjGRKzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 06:55:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B0A10C7;
        Tue, 18 Jul 2023 03:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689677744; x=1721213744;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cE5c2fkHYzHc+0wK6/9xesZLsRA0C85BABfAYO+q2Kc=;
  b=YSh4Dk9PHfx7GuguFnrIbfa7aFzaGdE03iVJ6ZLMHcBHZBSBhuQawfA5
   VunFPQrhANy8rkbYY22ry0/G3cN4t3ZCV3BZXM4X5Kw5VuSUlteije8uc
   ycKqFu/KQTvAh3nD55l1p/Eo8Fz18SaFsrUDECJf24YcT5LV7xc7VBZa7
   Qq4X6X/2TACRdWJzXvH9GNEQemQaXeMd2R7wtxVHLx4caxsFNXcJ64ep9
   xfccN1pmU4V7lQGpsh4k10NsJ7pYJfDjhckP/ia2VkmEWvLSt4Y71EjAk
   DYYIGKcdqlcWCkeeNLLYqR4FQjO2JC3h0xb9JjPqr1NCQH4z/Edeh8t6y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="452553506"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="452553506"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 03:55:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673863788"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="673863788"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 18 Jul 2023 03:55:43 -0700
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
Subject: [PATCH v10 00/10] Enhance vfio PCI hot reset for vfio cdev device
Date:   Tue, 18 Jul 2023 03:55:32 -0700
Message-Id: <20230718105542.4138-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

This series first extends VFIO_DEVICE_GET_PCI_HOT_RESET_INFO to report the
devid of affected devices and the ownership check result of the affected
devices to userspace. Then, extends the VFIO_DEVICE_PCI_HOT_RESET to accept
zero-length fd array for the hot-reset of cdev devices.

The updated _INFO ioctl and new hot-reset approach were tested with the
below qemu:

https://github.com/yiliu1765/qemu/tree/zhenzhong/iommufd_rfcv4
(requires to test with the cdev kernel)

Change log:

v10:
 - Add Jason's r-b to patch 06
 - More accurate check to return -ENOSPC in patch 09 when kernel has more
   devices to report than the user buffer (Jason)
 - Add t-b from Zhenzhong (wrote a selftest app to verify functions of this
		           patchset by referencing https://github.com/awilliam/tests/)

v9: https://lore.kernel.org/kvm/20230711023126.5531-1-yi.l.liu@intel.com/
 - Add Jason's r-b to patch 08

v8: https://lore.kernel.org/kvm/ZJRnHO0p+pPgBZdr@nvidia.com/
 - Add r-b from Jason to patch 03, 04, 05, 07, 09 of v7
 - Add a patch to copy the per-device hot-reset structure to user during the
   device loop instead of storing them in a buffer and copy all the contents
   in one copy, this avoids an extra loop to count device and also avoids
   allocating a temporay buffer for it. (Jason)
 - Rename vfio_iommufd_device_hot_reset_devid() to be vfio_iommufd_get_dev_id()
   and refine its return value for the case no valid ID can be returned. Hence
   make it a general helper to get ID for a device. (Alex, Jason)
 - Remove iommufd_ctx_has_group() CONIFG_IOMMUFD disabled stub as this API is
   called in iommufd specific code which is compiled when CONFIG_IOMMU is
   enabled. (Alex)
 - Reaffirming Yanting's t-b (Tested NIC passthrough on Intel platform. mainly
   regression tests)

v7: https://lore.kernel.org/kvm/20230602121515.79374-1-yi.l.liu@intel.com/
 - Drop noiommu support (patch 01 of v6 is dropped)
 - Remove helpers to get devid and ictx for iommufd_access
 - Document the dev_set representative requirement in the
   VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for the cdev opened device (Alex)
 - zero-length fd array approach is only for cdev opened device (Alex)

v6: https://lore.kernel.org/kvm/20230522115751.326947-1-yi.l.liu@intel.com/
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
  vfio/pci: Copy hot-reset device info to userspace in the devices loop
  vfio/pci: Allow passing zero-length fd array in
    VFIO_DEVICE_PCI_HOT_RESET

 drivers/iommu/iommufd/device.c   |  42 ++++++
 drivers/iommu/iommufd/main.c     |   2 +-
 drivers/vfio/iommufd.c           |  44 ++++++
 drivers/vfio/pci/vfio_pci_core.c | 250 +++++++++++++++++++------------
 drivers/vfio/vfio_main.c         |  15 ++
 include/linux/iommufd.h          |   5 +
 include/linux/vfio.h             |  22 +++
 include/uapi/linux/vfio.h        |  71 ++++++++-
 8 files changed, 352 insertions(+), 99 deletions(-)

-- 
2.34.1

