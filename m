Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4369869D9B1
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjBUDs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbjBUDs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:48:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC411252B2;
        Mon, 20 Feb 2023 19:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676951303; x=1708487303;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QeYxHmGFkhMVW1y70AvrC7trh8j38sO4fL0HnjHm0No=;
  b=lJXNfKYeKVgFiQlDSHqPWCSd2hUJpBk2ZpbQcsTGVw2dw2ZZylZdN7rH
   7frm/L4k9UTtgmkclpUPLAMWwgzyb4zAeobDu1Fg7IMkcpCiMPfcW7Gr5
   9zwSA6PmLvgorxkvagC5S6OPOUTZ2zZBKKtasp2o/Mgow7PiPKrFNWn44
   ds++b51tUs3KEITK82xsNrm50fOE5Nndndv8eoRRwij2a2qmsz5fvJPq5
   nK92nSJOFqwPhu1uEma9RnDUh8WJo3+GTiQ6DX2RMcF2oX+V2k3zNKill
   KrphjNNT4HRx9sV6qHT72ueAmCSYvVvQgAdUmLBKp3Z04PfhfWFQHB1xC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="397218385"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="397218385"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:48:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="664822134"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="664822134"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2023 19:48:13 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        yan.y.zhao@intel.com, xudong.hao@intel.com, terrence.xu@intel.com
Subject: [PATCH v4 00/19] Add vfio_device cdev for iommufd support
Date:   Mon, 20 Feb 2023 19:47:53 -0800
Message-Id: <20230221034812.138051-1-yi.l.liu@intel.com>
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
blocking device access before iommufd bind, making the device_open exclusive.
between the group path and the cdev path. Eventually, adds the cdev support
for vfio device, and makes group infrastructure optional as it is not needed
when vfio device cdev is compiled.

This is also a prerequisite for iommu nesting for vfio device[2].

The complete code can be found in below branch, simple test done with the
legacy group path and the cdev path. Draft QEMU branch can be found at[3]

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v4
(config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)

base-commit: 9f764ae24522428b3a4c502d394826fe8ef0338c

[1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/linux-iommu/20230209043153.14964-1-yi.l.liu@intel.com/
[3] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv3 (it is based on Eric's
    QEMU iommufd rfcv3 (https://lore.kernel.org/kvm/20230131205305.2726330-1-eric.auger@redhat.com/)
    plus two commits to align with vfio_device_cdev v3/v4)

Change log:

v4:
 - Add r-b from Kevin on patch 09/10
 - Add a line in devices/vfio.rst to emphasize user should add group/device to
   KVM prior to invoke open_device op which may be called in the VFIO_GROUP_GET_DEVICE_FD
   or VFIO_DEVICE_BIND_IOMMUFD ioctl.
 - Modify VFIO_GROUP/VFIO_DEVICE_CDEV Kconfig dependency (Alex)
 - Select VFIO_GROUP for SPAPR (Jason)
 - Check device fully-opened in PCI hotreset path for device fd (Jason)
 - Set df->access_granted in the caller of vfio_device_open() since
   the caller may fail in other operations, but df->access_granted
   does not allow a true to false change. So it should be set only when
   the open path is really done successfully. (Yan, Kevin)
 - Fix missing iommufd_ctx_put() in the cdev path (Yan)
 - Fix an issue found in testing exclusion between group and cdev path.
   vfio_device_cdev_close() should check df->access_granted before heading
   to other operations.
 - Update vfio.rst for iommufd/cdev

v3: https://lore.kernel.org/kvm/20230213151348.56451-1-yi.l.liu@intel.com/
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

Yi Liu (19):
  vfio: Allocate per device file structure
  vfio: Refine vfio file kAPIs
  vfio: Accept vfio device file in the driver facing kAPI
  kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
    fd
  kvm/vfio: Accept vfio device file from userspace
  vfio: Pass struct vfio_device_file * to vfio_device_open/close()
  vfio: Block device access via device fd until device is opened
  vfio/pci: Update comment around group_fd get in
    vfio_pci_ioctl_pci_hot_reset()
  vfio/pci: Accept device fd for hot reset
  vfio: Add infrastructure for bind_iommufd from userspace
  vfio-iommufd: Add detach_ioas support for physical VFIO devices
  vfio-iommufd: Add detach_ioas for emulated VFIO devices
  vfio: Add cdev_device_open_cnt to vfio_group
  vfio: Make vfio_device_open() single open for device cdev path
  vfio: Add cdev for vfio_device
  vfio: Add VFIO_DEVICE_BIND_IOMMUFD
  vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
  vfio: Compile group optionally
  docs: vfio: Add vfio device cdev description

 Documentation/driver-api/vfio.rst             | 133 ++++++++-
 Documentation/virt/kvm/devices/vfio.rst       |  50 ++--
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   1 +
 drivers/s390/cio/vfio_ccw_ops.c               |   1 +
 drivers/s390/crypto/vfio_ap_ops.c             |   1 +
 drivers/vfio/Kconfig                          |  26 ++
 drivers/vfio/Makefile                         |   3 +-
 drivers/vfio/device_cdev.c                    | 276 ++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   1 +
 drivers/vfio/group.c                          | 155 ++++++----
 drivers/vfio/iommufd.c                        |  59 +++-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   2 +
 drivers/vfio/pci/mlx5/main.c                  |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              |  14 +-
 drivers/vfio/platform/vfio_amba.c             |   1 +
 drivers/vfio/platform/vfio_platform.c         |   1 +
 drivers/vfio/vfio.h                           | 188 +++++++++++-
 drivers/vfio/vfio_main.c                      | 271 +++++++++++++++--
 include/linux/iommufd.h                       |   6 +
 include/linux/vfio.h                          |  29 +-
 include/uapi/linux/kvm.h                      |  16 +-
 include/uapi/linux/vfio.h                     |  86 ++++++
 virt/kvm/vfio.c                               | 141 ++++-----
 24 files changed, 1252 insertions(+), 211 deletions(-)
 create mode 100644 drivers/vfio/device_cdev.c

-- 
2.34.1

