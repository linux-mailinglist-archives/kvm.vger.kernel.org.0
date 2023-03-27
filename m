Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CAD6C9FD9
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjC0Jfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 05:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjC0Jfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 05:35:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B1349C9;
        Mon, 27 Mar 2023 02:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679909730; x=1711445730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VFtDtoN5Kck+5X+jp0cmuooALgzxmKpAJpHtfFQwAcw=;
  b=EezmM5revXrYMgKswjusUh/EdCy7AONAeRhxPxAVXEtXEzVepkminpI+
   NLzNPTOCRgO4yPkOO3rJttLif1a68sgFxC6RgAdQUDnrVOxeXWJAHGAgB
   V0bYjg24iV/HRzShdZ/Yp7PbCUb+HP384oc5au71TTqsV4q/QQBXc1dEs
   +N1RF/ytUJuHqJYE3Gtuzxw+8JpXrUiKz+oGne7ZXh40RxvIyxHxOjCp0
   qU8Zm6+IJOSGSNQ2HLx5JaCOQSzDIanhNGvvOhCVWR+zvbZ4Hnxsmj2af
   9mRWTL+8riVtfec70yic0Ky0ZWjqHStlYZzssR640rARNji5YfbrcyvJZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="319879480"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="319879480"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 02:35:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="633554601"
X-IronPort-AV: E=Sophos;i="5.98,294,1673942400"; 
   d="scan'208";a="633554601"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga003.jf.intel.com with ESMTP; 27 Mar 2023 02:34:59 -0700
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
Subject: [PATCH v2 00/10] Introduce new methods for verifying ownership in vfio PCI hot reset
Date:   Mon, 27 Mar 2023 02:34:48 -0700
Message-Id: <20230327093458.44939-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds
to prove that it owns all devices affected by resetting the calling
device. This series introduces several extensions to allow the ownership
check better aligned with iommufd and coming vfio device cdev support.

First, resetting an unopened device is always safe given nobody is using
it. So relax the check to allow such devices not covered by group fd
array. [1]

When iommufd is used we can simply verify that all affected devices are
bound to a same iommufd then no need for the user to provide extra fd
information. This is enabled by the user passing a zero-length fd array
and moving forward this should be the preferred way for hot reset. [2]

However the iommufd method has difficulty working with noiommu devices
since those devices don't have a valid iommufd, unless the noiommu device
is in a singleton dev_set hence no ownership check is required. [3]

For noiommu backward compatibility a 3rd method is introduced by allowing
the user to pass an array of device fds to prove ownership. [4]

As suggested by Jason [5], we have this series to introduce the above
stuffs to the vfio PCI hot reset. Per the dicussion in [6], this series
also adds a new _INFO ioctl to get hot reset scope for given device.

[1] https://lore.kernel.org/kvm/Y%2FdobS6gdSkxnPH7@nvidia.com/
[2] https://lore.kernel.org/kvm/Y%2FZOOClu8nXy2toX@nvidia.com/#t
[3] https://lore.kernel.org/kvm/ZACX+Np%2FIY7ygqL5@nvidia.com/
[4] https://lore.kernel.org/kvm/DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com/#t
[5] https://lore.kernel.org/kvm/ZAcvzvhkt9QhCmdi@nvidia.com/
[6] https://lore.kernel.org/kvm/ZBoYgNq60eDpV9Un@nvidia.com/

Change log:

v2:
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
  vfio/pci: Only check ownership of opened devices in hot reset
  vfio/pci: Move the existing hot reset logic to be a helper
  vfio-iommufd: Add helper to retrieve iommufd_ctx and devid for
    vfio_device
  vfio/pci: Allow passing zero-length fd array in
    VFIO_DEVICE_PCI_HOT_RESET
  vfio: Refine vfio file kAPIs for vfio PCI hot reset
  vfio: Accpet device file from vfio PCI hot reset path
  vfio/pci: Renaming for accepting device fd in hot reset path
  vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
  vfio/pci: Add VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO

 drivers/iommu/iommufd/device.c   |  12 ++
 drivers/vfio/group.c             |  32 ++--
 drivers/vfio/iommufd.c           |  16 ++
 drivers/vfio/pci/vfio_pci_core.c | 244 ++++++++++++++++++++++++-------
 drivers/vfio/vfio.h              |   2 +
 drivers/vfio/vfio_main.c         |  44 ++++++
 include/linux/iommufd.h          |   3 +
 include/linux/vfio.h             |  14 ++
 include/uapi/linux/vfio.h        |  65 +++++++-
 9 files changed, 364 insertions(+), 68 deletions(-)

-- 
2.34.1

