Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D47694AAC
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBMPOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBMPOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:14:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A15FF06;
        Mon, 13 Feb 2023 07:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676301252; x=1707837252;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NuL3WKfeg4daNOlumqOVMpxB8O0V9YixwTzc+OOAYBY=;
  b=G5T/9mvfe2eDDe70GJk92krY+sdsSbpwa+JUdtkQ8Y/J9OZu/By2exy1
   ILqdbamVGyo3uo/oSdayK1gdpMnJ0NcI6sXiN2M6cOiOdMbg3AOmocVUj
   +xelxtjZ5KVoOVJKCf90ww2+jRUwdYQ5bsD+01tDPnX+SbQBa46vRp8HV
   FI5eRGRozHJE8YRGve48fBqaYPSIgfd6wJTGUsglsu/kgMLF8qVVYrn9p
   MAltaDcZj98y6j5UbAJi4YJ9rKt8RoDAFCDHSlRvEJUfqtGVVvAZM5R3H
   vufBqih0a20Hq9ZB8ns4Lt0zrf5S+dc1QtxSwC7aRfMica9CGLcNOeaI0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="318931515"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="318931515"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 07:13:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701289649"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701289649"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 07:13:50 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     joro@8bytes.org, alex.williamson@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, robin.murphy@arm.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Date:   Mon, 13 Feb 2023 07:13:33 -0800
Message-Id: <20230213151348.56451-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existing VFIO provides group-centric user APIs for userspace. Userspace
opens the /dev/vfio/$group_id first before getting device fd and hence
getting access to device. This is not the desired model for iommufd. Per
the conclusion of community discussion[1], iommufd provides device-centric
kAPIs and requires its consumer (like VFIO) to be device-centric user
APIs. Such user APIs are used to associate device with iommufd and also
the I/O address spaces managed by the iommufd.

This series first introduces a per device file structure to be prepared
for further enhancement and refactors the kvm-vfio code to be prepared
for accepting device file from userspace. Then refactors the vfio to be
able to handle iommufd binding. This refactor includes the mechanism of
blocking device access before iommufd bind, making vfio_device_open() be
exclusive between the group path and the cdev path. Eventually, adds the
cdev support for vfio device, and makes group infrastructure optional as
it is not needed when vfio device cdev is compiled.

This is also a prerequisite for iommu nesting for vfio device[2].

The complete code can be found in below branch, simple test done with the
legacy group path and the cdev path. Draft QEMU branch can be found at[3]

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v3
(config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)

base-commit: 06a24ad

[1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/linux-iommu/20230209043153.14964-1-yi.l.liu@intel.com/
[3] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv3 (it is based on Eric's
    QEMU iommufd rfcv3 (https://lore.kernel.org/kvm/20230131205305.2726330-1-eric.auger@redhat.com/)
    plus two commits to align with vfio_device_cdev v3)

Change log:

v3:
 - Add r-b from Kevin on patch 03, 06, 07, 08.
 - Refine the group and cdev path exclusion. Remove vfio_device:single_open;
   add vfio_group::cdev_device_open_cnt to achieve exlucsion between group
   path and cdev path (Kevin, Jason)
 - Fix a bug in the error handling path (Yan Zhao)
 - Address misc remarks from Kevin

v2: https://lore.kernel.org/kvm/20230206090532.95598-1-yi.l.liu@intel.com/
 - Add r-b from Kevin and Eric on patch 01 02 04.
 - "Split kvm/vfio: Provide struct kvm_device_ops::release() insted of ::destroy()"
   from this series and got applied. (Alex, Kevin, Jason, Mathhew)
 - Add kvm_ref_lock to protect vfio_device_file->kvm instead of reusing
   dev_set->lock as dead-lock is observed with vfio-ap which would try to
   acquire kvm_lock. This is opposite lock order with kvm_device_release()
   which holds kvm_lock first and then hold dev_set->lock. (Kevin)
 - Use a separate ioctl for detaching IOAS. (Alex)
 - Rename vfio_device_file::single_open to be is_cdev_device (Kevin, Alex)
 - Move the vfio device cdev code into device_cdev.c and add a VFIO_DEVICE_CDEV
   kconfig for it. (Kevin, Jason)

v1: https://lore.kernel.org/kvm/20230117134942.101112-1-yi.l.liu@intel.com/
 - Fix the circular refcount between kvm struct and device file reference. (JasonG)
 - Address comments from KevinT
 - Remained the ioctl for detach, needs to Alex's taste
   (https://lore.kernel.org/kvm/BN9PR11MB5276BE9F4B0613EE859317028CFF9@BN9PR11MB5276.namprd11.prod.outlook.com/)

rfc: https://lore.kernel.org/kvm/20221219084718.9342-1-yi.l.liu@intel.com/

Thanks,
	Yi Liu

Yi Liu (15):
  vfio: Allocate per device file structure
  vfio: Refine vfio file kAPIs
  vfio: Accept vfio device file in the driver facing kAPI
  kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
    fd
  kvm/vfio: Accept vfio device file from userspace
  vfio: Pass struct vfio_device_file * to vfio_device_open/close()
  vfio: Block device access via device fd until device is opened
  vfio: Add infrastructure for bind_iommufd from userspace
  vfio-iommufd: Add detach_ioas support for physical VFIO devices
  vfio-iommufd: Add detach_ioas for emulated VFIO devices
  vfio: Add cdev_device_open_cnt to vfio_group
  vfio: Make vfio_device_open() single open for device cdev path
  vfio: Add cdev for vfio_device
  vfio: Add ioctls for device cdev using iommufd
  vfio: Compile group optionally

 Documentation/driver-api/vfio.rst             |   8 +-
 Documentation/virt/kvm/devices/vfio.rst       |  45 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   1 +
 drivers/s390/cio/vfio_ccw_ops.c               |   1 +
 drivers/s390/crypto/vfio_ap_ops.c             |   1 +
 drivers/vfio/Kconfig                          |  29 ++
 drivers/vfio/Makefile                         |   3 +-
 drivers/vfio/device_cdev.c                    | 264 ++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   1 +
 drivers/vfio/group.c                          | 149 +++++----
 drivers/vfio/iommufd.c                        |  59 +++-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   2 +
 drivers/vfio/pci/mlx5/main.c                  |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              |   4 +-
 drivers/vfio/platform/vfio_amba.c             |   1 +
 drivers/vfio/platform/vfio_platform.c         |   1 +
 drivers/vfio/vfio.h                           | 168 +++++++++-
 drivers/vfio/vfio_main.c                      | 295 ++++++++++++++++--
 include/linux/iommufd.h                       |   6 +
 include/linux/vfio.h                          |  28 +-
 include/uapi/linux/kvm.h                      |  16 +-
 include/uapi/linux/vfio.h                     |  86 +++++
 virt/kvm/vfio.c                               | 141 ++++-----
 24 files changed, 1106 insertions(+), 205 deletions(-)
 create mode 100644 drivers/vfio/device_cdev.c

-- 
2.34.1

