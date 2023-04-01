Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5646D316A
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDAOod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDAOoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321E41A95E;
        Sat,  1 Apr 2023 07:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360271; x=1711896271;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5F7P7Jg2V0ZDZMnrZa1Gd5CHrngSw5dblTzPduvISBM=;
  b=UtfLaOpq63socgFOQAdikwmdv+cr6l0Leh8Yossz3Z+4g7K0Qut/FebR
   Z8Wgt74krQaw7xoRw82XmRTOs4d5gGMcTCMec7xx5eGHYFFO1/24TL9WH
   DpsV2FWMbAKPIYug9hS61l30yhFag8mCIT5DC0a8qfxQrZj1BPBAlQ+oG
   qKytjbDqdDmWUmYaGzYiQ7KYArwZ/aZ693s+fEOrj5zmGWMTT5m4DYv9h
   fuImOBY7J65lYKpKSPT5TDlmrppu8HLkilhrGs0ajBNfPL7I8uGlpAO1s
   BfMNR82NSv8fkZl6TvFT0V8GaxF3aMvDccWmC+I4B9N2CgVXEOfl34YXC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385065"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385065"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705799"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705799"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:30 -0700
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
Subject: [PATCH v3 00/12] Introduce new methods for verifying ownership in vfio PCI hot reset
Date:   Sat,  1 Apr 2023 07:44:17 -0700
Message-Id: <20230401144429.88673-1-yi.l.liu@intel.com>
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
stuffs to the vfio PCI hot reset. Per the dicussion in [6] [7], in the
end of this series, the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is extended
to report devid for the devices opened as cdev. This is goging to support
the device fd passing usage.

The new hot reset method and updated _INFO ioctl are tested with two
test commits in below qemu:

https://github.com/yiliu1765/qemu/commits/iommufd_rfcv3
(requires to test with cdev kernel)

[1] https://lore.kernel.org/kvm/Y%2FdobS6gdSkxnPH7@nvidia.com/
[2] https://lore.kernel.org/kvm/Y%2FZOOClu8nXy2toX@nvidia.com/#t
[3] https://lore.kernel.org/kvm/ZACX+Np%2FIY7ygqL5@nvidia.com/
[4] https://lore.kernel.org/kvm/DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com/#t
[5] https://lore.kernel.org/kvm/ZAcvzvhkt9QhCmdi@nvidia.com/
[6] https://lore.kernel.org/kvm/ZBoYgNq60eDpV9Un@nvidia.com/
[7] https://lore.kernel.org/kvm/20230327132619.5ab15440.alex.williamson@redhat.com/

Change log:

v3:
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

Yi Liu (12):
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
  vfio: Mark cdev usage in vfio_device
  iommufd: Define IOMMUFD_INVALID_ID in uapi
  vfio/pci: Report dev_id in VFIO_DEVICE_GET_PCI_HOT_RESET_INFO

 drivers/iommu/iommufd/device.c   |  12 ++
 drivers/vfio/group.c             |  32 +++--
 drivers/vfio/iommufd.c           |  14 +++
 drivers/vfio/pci/vfio_pci_core.c | 204 ++++++++++++++++++++++---------
 drivers/vfio/vfio.h              |   2 +
 drivers/vfio/vfio_main.c         |  44 +++++++
 include/linux/iommufd.h          |   3 +
 include/linux/vfio.h             |  21 ++++
 include/uapi/linux/iommufd.h     |   3 +
 include/uapi/linux/vfio.h        |  42 ++++++-
 10 files changed, 301 insertions(+), 76 deletions(-)

-- 
2.34.1

