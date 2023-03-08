Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082DD6B0902
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 14:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCHNad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 08:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjCHNaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 08:30:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F0E83170;
        Wed,  8 Mar 2023 05:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282147; x=1709818147;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LXQtssWMrtfei9DptIVXNOxwEN1lmD+EUGfcMZ+lEEA=;
  b=lB2YNF87WDay5RZwaddWAfLZQN9dESs7xx1zk92F68h3SEgVJcFL1tV1
   HA/rHE2Tb0Gl/WPDfvgo+BtQa0/oohlHGoSTrdWSgQENaM14gti+EpJTE
   rAjWPmTLxZfIRZnqRXEceVKvZY6jWmqv0GbEyuvVdoX7pcNfzM1vlSLqk
   8OLXoNkKyEisRUjWnUL66OZULcsXApQ3iE+PcUKiOS1FeHDPdma7TrPRK
   W3Y+Yj6YGf+xwiQaKSdROnqSHgnJsEu+oVH8OMCMdKiB+ls5xZkjD8vPP
   7tr1lmkaBY3uvw9VQEx+7cfxddJsp4LdY+2ohbJR1zUmNVJuvNfOk3/t2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="336165065"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="336165065"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:29:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="922789198"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="922789198"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2023 05:29:05 -0800
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
Subject: [PATCH v6 00/24] cover-letter: Add vfio_device cdev for iommufd support
Date:   Wed,  8 Mar 2023 05:28:39 -0800
Message-Id: <20230308132903.465159-1-yi.l.liu@intel.com>
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

Existing VFIO provides group-centric user APIs for userspace. Userspace
opens the /dev/vfio/$group_id first before getting device fd and hence
getting access to device. This is not the desired model for iommufd. Per
the conclusion of community discussion[1], iommufd provides device-centric
kAPIs and requires its consumer (like VFIO) to be device-centric user
APIs. Such user APIs are used to associate device with iommufd and also
the I/O address spaces managed by the iommufd.

This series first introduces a per device file structure to be prepared
for further enhancement and refactors the kvm-vfio code to be prepared
for accepting device file from userspace, and also make vfio-pci to be
able to accpet device fd or zero-length fd array in the hot reset path.
The mechanism of blocking device access before iommufd bind is part of
making vfio-pci accepting device fd. Then refactors the vfio to be able
to handle cdev path (e.g. iommufd binding, [de]attach ioas). This refactor
includes making the device_open exclusive between group and cdev path,
only allow single device open in cdev path and vfio-iommufd refactor to
support cdev. Eventually, adds the cdev support for vfio device and the
new ioctls, then makes group infrastructure optional as it is not needed
when vfio device cdev is compiled.

This series is based on some preparation works done to vfio emulated devices[2].
It is a prerequisite for iommu nesting for vfio device[3].

The complete code can be found in below branch, simple tests done to the
legacy group path and the cdev path. Draft QEMU branch can be found at[4]

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v6
(config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)

base-commit: bb549e3c0c1c498b3729fcf3ee3b3dea5d19dde2

[1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/kvm/20230308131340.459224-1-yi.l.liu@intel.com/#t
[3] https://lore.kernel.org/linux-iommu/20230209043153.14964-1-yi.l.liu@intel.com/
[4] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv3 (it is based on Eric's
    QEMU iommufd rfcv3 (https://lore.kernel.org/kvm/20230131205305.2726330-1-eric.auger@redhat.com/)
    plus two commits to align with vfio_device_cdev v3/v4/v5/v6)

Change log:

v6:
 - Add r-b from Jason on patch 01 - 08 and 13 in v5
 - Based on the prerequisite mini-series which makes vfio emulated devices
   be prepared to cdev (Jason)
 - Add the approach to pass a set of device fds to do hot reset ownership
   check, while the zero-length array approach is also kept. (Jason, Kevin, Alex)
 - Drop patch 10 of v5, it is reworked by patch 13 and 17 in v6 (Jason)
 - Store vfio_group pointer in vfio_device_file to check if user is using
   legacy vfio container (Jason)
 - Drop the is_cdev_device flag (introduced in patch 14 of v5) as the group
   pointer stored in vfio_device_file can cover it.
 - Add iommu_group check in the cdev no-iommu path patch 24 (Kevin)
 - Add t-b from Terrence, Nicolin and Matthew (thanks for the help, some patches
   are new in this version, so I just added t-b to the patches that are also
   in v5 and no big change, for others would add in this version).

v5: https://lore.kernel.org/kvm/20230227111135.61728-1-yi.l.liu@intel.com/
 - Add r-b from Kevin on patch 08, 13, 14, 15 and 17.
 - Rename patch 02 to limit the change for KVM facing kAPIs. The vfio pci
   hot reset path only accepts group file until patch 09. (Kevin)
 - Update comment around smp_load_acquire(&df->access_granted) (Yan)
 - Adopt Jason's suggestion on the vfio pci hot reset path, passing zero-length
   fd array to indicate using bound iommufd_ctx as ownership check. (Jason, Kevin)
 - Direct read df->access_granted value in vfio_device_cdev_close() (Kevin, Yan, Jason)
 - Wrap the iommufd get/put into a helper to refine the error path of
   vfio_device_ioctl_bind_iommufd(). (Yan)

v4: https://lore.kernel.org/kvm/20230221034812.138051-1-yi.l.liu@intel.com/
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

Yi Liu (24):
  vfio: Allocate per device file structure
  vfio: Refine vfio file kAPIs for KVM
  vfio: Accept vfio device file in the KVM facing kAPI
  kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
    fd
  kvm/vfio: Accept vfio device file from userspace
  vfio: Pass struct vfio_device_file * to vfio_device_open/close()
  vfio: Block device access via device fd until device is opened
  vfio/pci: Update comment around group_fd get in
    vfio_pci_ioctl_pci_hot_reset()
  vfio/pci: Only need to check opened devices in the dev_set for hot
    reset
  vfio/pci: Rename the helpers and data in hot reset path to accept
    device fd
  vfio/pci: Accept device fd in VFIO_DEVICE_PCI_HOT_RESET ioctl
  vfio/pci: Allow passing zero-length fd array in
    VFIO_DEVICE_PCI_HOT_RESET
  vfio/iommufd: Split the compat_ioas attach out from
    vfio_iommufd_bind()
  vfio: Add cdev_device_open_cnt to vfio_group
  vfio: Make vfio_device_open() single open for device cdev path
  vfio: Make vfio_device_first_open() to cover the noiommu mode in cdev
    path
  vfio-iommufd: Make vfio_iommufd_bind() selectively return devid
  vfio-iommufd: Add detach_ioas support for physical VFIO devices
  vfio-iommufd: Add detach_ioas support for emulated VFIO devices
  vfio: Add cdev for vfio_device
  vfio: Add VFIO_DEVICE_BIND_IOMMUFD
  vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
  vfio: Compile group optionally
  docs: vfio: Add vfio device cdev description

 Documentation/driver-api/vfio.rst             | 133 +++++++-
 Documentation/virt/kvm/devices/vfio.rst       |  52 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   1 +
 drivers/iommu/iommufd/device.c                |   6 +
 drivers/s390/cio/vfio_ccw_ops.c               |   1 +
 drivers/s390/crypto/vfio_ap_ops.c             |   1 +
 drivers/vfio/Kconfig                          |  27 +-
 drivers/vfio/Makefile                         |   3 +-
 drivers/vfio/device_cdev.c                    | 313 ++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   1 +
 drivers/vfio/group.c                          | 192 +++++++----
 drivers/vfio/iommufd.c                        | 119 +++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   2 +
 drivers/vfio/pci/mlx5/main.c                  |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              | 152 ++++++---
 drivers/vfio/platform/vfio_amba.c             |   1 +
 drivers/vfio/platform/vfio_platform.c         |   1 +
 drivers/vfio/vfio.h                           | 212 +++++++++++-
 drivers/vfio/vfio_main.c                      | 293 ++++++++++++++--
 include/linux/iommufd.h                       |   3 +
 include/linux/vfio.h                          |  38 ++-
 include/uapi/linux/kvm.h                      |  16 +-
 include/uapi/linux/vfio.h                     | 106 +++++-
 virt/kvm/vfio.c                               | 141 ++++----
 25 files changed, 1548 insertions(+), 268 deletions(-)
 create mode 100644 drivers/vfio/device_cdev.c

-- 
2.34.1

