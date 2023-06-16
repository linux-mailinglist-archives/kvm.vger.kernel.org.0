Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD3732C21
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344563AbjFPJkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbjFPJjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:39:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDCF2728;
        Fri, 16 Jun 2023 02:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686908389; x=1718444389;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s0fjWxYcqVfdj+nclfzKM599jEEVwiqyzDiAXaIRVRo=;
  b=Dvtu1IQP5imdjbjy70zU/sAjWIwd8UML/33pf/EUFxMca01b0SveTL4M
   BxmAq44SKKIgOl2zOKj4lEtGNqqug5rlTHAcJGPVQGBaLWEfThnZgo5eE
   uWfSDQofkO32zNNdr8+cHn+LofR03uTSUgIvgRA/3lapZaVawlrEOpDMJ
   G5ApJTEPhld305oWOZB2++3eKhdUZazUe0CHKGo9P8Ub2I1w4rws5igkY
   Jzg3HmFnYY8UKP/LS5Uw9a3kk6nyVTtOxei1iXgVg2myaNkVpLH1rBSiy
   tyzltK4ZtPxvHNwoBGShPhLwb4972Wnw/g4IdC/uuv0ztJuVI/8jJMKx8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361700104"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361700104"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:39:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715950981"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="715950981"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2023 02:39:47 -0700
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
Subject: [PATCH v13 00/22] Add vfio_device cdev for iommufd support
Date:   Fri, 16 Jun 2023 02:39:24 -0700
Message-Id: <20230616093946.68711-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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
for accepting device file from userspace. After this, adds a mechanism for
blocking device access before iommufd bind. Then refactors the vfio to be
able to handle cdev path (e.g. iommufd binding, no-iommufd, [de]attach ioas).
This refactor includes making the device_open exclusive between the group
and the cdev path, only allow single device open in cdev path; vfio-iommufd
code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
into two steps. Eventually, adds the cdev support for vfio device and the
new ioctls, then makes group infrastructure optional as it is not needed
when vfio device cdev is compiled.

This series is based on some preparation works done to vfio emulated devices[2]
and vfio pci hot reset enhancements[3].

This series is a prerequisite for iommu nesting for vfio device[4] [5].

The complete code can be found in below branch, simple tests done to the
legacy group path and the cdev path. Draft QEMU branch can be found at[6]
However, the noiommu mode test is only done with some hacks in kernel and
qemu to check if qemu can boot with noiommu devices.

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v13
(config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)

base-commit: dcc9d48709e6bc6ec3da97626b8768582e138326

[1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
[2] https://lore.kernel.org/kvm/20230327093351.44505-1-yi.l.liu@intel.com/ - merged
[3] https://lore.kernel.org/kvm/20230616093042.65094-1-yi.l.liu@intel.com/
[4] https://lore.kernel.org/linux-iommu/20230511143844.22693-1-yi.l.liu@intel.com/
[5] https://lore.kernel.org/linux-iommu/20230511145110.27707-1-yi.l.liu@intel.com/#t
[6] https://github.com/yiliu1765/qemu/tree/iommufd_rfcv4.mig.reset.v4_var3

Change log:

v13:
 - vfio_device_first_open() and vfio_device_last_close() to be vfio_df_device_first_open()
   vfio_df_device_last_close() (Alex)
 - Define struct vfio_device_file::access_granted as u8 and also place the u32 devid to
   be behind this flag as this structure access is hot, so needs to avoid too much hole
   in the structure (Alex)
 - Use u8 instead bool in the struct vfio_device for the flags (Alex)
 - Define BIND, ATTACH, DETACH ioctl behind VFIO_DEVICE_FEATURE whose offset is 17 (Alex)
 - Drop patch 20, 21, 22 of v12 (Alex)
 - Per the patch drop, still needs to detect the physical devices that do not have
   IOMMU in the cdev registration as cdev does not support such devices. Per the
   suggestion from Jason, lift the IOMMU_CAP_CACHE_COHERENCY check to be in vfio_main.c
   so that it can fail the registration of such devices if only cdev is compiled. (Jason, Alex)
 - Refine the vfio.rst doc, highlight that the cdev device access is stil bound with
   iommu group. (Alex)
 - Reaffirm t-b from below folks:
   Nicolin Chen - Test nesting branch which is based on cdev v12, the test is done on ARM64 (SMMUv3)
   Matthew Rosato - vfio-pci, vfio-ap, vfio-ccw under container, compat and cdev mode, and nesting
                    test on SMMUv3 and Intel.
   Yanting Jiang - regression tests with NIC passthrough on Intel platform

v12: https://lore.kernel.org/kvm/20230602121653.80017-1-yi.l.liu@intel.com/#r
 - Rename vfio_device_xx() to be vfio_df_xx() if the object is vfio_device_file (Alex)
 - Refine patch 10 of v11 (Alex)
 - Add new device ioctls from offset 18 (Alex)
 - Add a patch to check group->type for noiommu test, no need to check
   CONFIG_VFIO_NOIOMMU (Alex)
 - Refine the logic of vfio_device_set_noiommu() per Alex's suggestion. The noiommu
   taint is moved to __vfio_register_dev(), also add a check on group type before
   calling vfio_device_set_noiommu() as only physical device can be noiommu device.
 - Drop noiommu support for cdev, patch 16 of v11 is dropped, the related changes
   are in patch 17 - 24 of this series.

v11: https://lore.kernel.org/kvm/20230513132827.39066-1-yi.l.liu@intel.com/
 - Add back the noiommu determination at vfio device registration patch and
   put it prior to compiling vfio_group code optionally as compiling vfio_group
   optionaly is the major reason for it.
 - Fix a typo related to SPAPR (Cédric Le Goater)
 - Add t-b from Shameerali Kolothum Thodi, tested on HiSilicon D06(ARM64) platform
   with a NIC pass-through

v10: https://lore.kernel.org/kvm/20230426150321.454465-1-yi.l.liu@intel.com/
 - Drop patch 03 of v9 as vfio_file_is_group() is still needed by pci hot reset path
 - Drop 11 of v9 per the change of noiommu support
 - Move patch 18 of v9 to hot-reset series [3]
 - vfio_file_has_device_access() is dropped as no usage now (hot-reset does not accept
   device fd, hence no need for this helper)
 - Minor change to patch 02, mainly make it back to patch v2 of v6 which is before
   splitting hot-reset series
 - Minor change in 10 and 11 due to rebase
 - Functional changes in patch 19, 20 and 21 per the latest noiommu support
   policy. noiommu device can be bound to valid iommufd now, this is different
   from the prior policy in which noiommu device is not allowed to be bound to
   valid iommufd. So may pay more attention on the three patches, previous r-b
   and t-b are dropped for these three patches.

v9: https://lore.kernel.org/kvm/20230401151833.124749-1-yi.l.liu@intel.com/
 - Use smp_load_acquire() in vfio_file_has_device_access() for df->access_granted (Alex)
 - Fix lock init in patch 16 of v8 (Jon Pan-Doh)
 - Split patch 20 of v8 (Alex)
 - Refine noiommu logic in BIND_IOMMUFD (Alex)
 - Remove dev_cookie in BIND_IOMMUFD ioctl (Alex, Jason)
 - Remove static_assert in ATTACH/DETACH ioctl handling (Alex)
 - Remove device->ops->bind_iommufd presence check in BIND_IOMMUFD/ATTACH/DETACH handling (Alex)
 - Remove VFIO dependecny for VFIO_CONTAINER as VFIO_GROUP should imply it (Alex)
 - Improve the documentation per suggestions from Alex on patch 24 of v8 (Alex)
 - Remove WARN_ON(df->group) in vfio_device_group_uses_container() of patch 11
 - Add r-b from Kevin to patch 18/19 of v8
 - Add r-b from Jason to patch 03/10/11 of v8
 - Add t-b from Yanting Jiang and Nicolin Chen

v8: https://lore.kernel.org/kvm/20230327094047.47215-1-yi.l.liu@intel.com/
 - Add patch 18 to determine noiommu device at vfio_device registration (Jason)
 - Add patch 19 to name noiommu device with "noiommu-" prefix to be par with
   group path
 - Add r-b from Kevin
 - Add t-b from Terrence

v7: https://lore.kernel.org/kvm/20230316125534.17216-1-yi.l.liu@intel.com/
 - Split the vfio-pci hot reset changes to be separate patch series (Jason, Kevin)
 - More polish on no-iommufd support (patch 11 - 13) in cdev path (Kevin)
 - iommufd_access_detach() in patch 16 is added by Nic for emulated devices (Kevin, Jason)

v6: https://lore.kernel.org/kvm/20230308132903.465159-1-yi.l.liu@intel.com/#t
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

Nicolin Chen (1):
  iommufd/device: Add iommufd_access_detach() API

Yi Liu (21):
  vfio: Allocate per device file structure
  vfio: Refine vfio file kAPIs for KVM
  vfio: Accept vfio device file in the KVM facing kAPI
  kvm/vfio: Prepare for accepting vfio device fd
  kvm/vfio: Accept vfio device file from userspace
  vfio: Pass struct vfio_device_file * to vfio_device_open/close()
  vfio: Block device access via device fd until device is opened
  vfio: Add cdev_device_open_cnt to vfio_group
  vfio: Make vfio_df_open() single open for device cdev path
  vfio-iommufd: Move noiommu compat validation out of
    vfio_iommufd_bind()
  vfio-iommufd: Split bind/attach into two steps
  vfio: Record devid in vfio_device_file
  vfio-iommufd: Add detach_ioas support for physical VFIO devices
  vfio-iommufd: Add detach_ioas support for emulated VFIO devices
  vfio: Move vfio_device_group_unregister() to be the first operation in
    unregister
  vfio: Add cdev for vfio_device
  vfio: Add VFIO_DEVICE_BIND_IOMMUFD
  vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
  vfio: Move the IOMMU_CAP_CACHE_COHERENCY check in
    __vfio_register_dev()
  vfio: Compile vfio_group infrastructure optionally
  docs: vfio: Add vfio device cdev description

 Documentation/driver-api/vfio.rst             | 147 +++++++++-
 Documentation/virt/kvm/devices/vfio.rst       |  47 ++--
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   1 +
 drivers/iommu/iommufd/Kconfig                 |   4 +-
 drivers/iommu/iommufd/device.c                |  76 +++++-
 drivers/iommu/iommufd/iommufd_private.h       |   2 +
 drivers/s390/cio/vfio_ccw_ops.c               |   1 +
 drivers/s390/crypto/vfio_ap_ops.c             |   1 +
 drivers/vfio/Kconfig                          |  27 ++
 drivers/vfio/Makefile                         |   3 +-
 drivers/vfio/device_cdev.c                    | 251 ++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc.c             |   1 +
 drivers/vfio/group.c                          | 166 ++++++++----
 drivers/vfio/iommufd.c                        |  94 ++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   2 +
 drivers/vfio/pci/mlx5/main.c                  |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/platform/vfio_amba.c             |   1 +
 drivers/vfio/platform/vfio_platform.c         |   1 +
 drivers/vfio/vfio.h                           | 223 +++++++++++++++-
 drivers/vfio/vfio_main.c                      | 224 ++++++++++++++--
 include/linux/iommufd.h                       |   1 +
 include/linux/vfio.h                          |  46 +++-
 include/uapi/linux/kvm.h                      |  13 +-
 include/uapi/linux/vfio.h                     |  71 +++++
 samples/vfio-mdev/mbochs.c                    |   1 +
 samples/vfio-mdev/mdpy.c                      |   1 +
 samples/vfio-mdev/mtty.c                      |   1 +
 virt/kvm/vfio.c                               | 137 +++++-----
 29 files changed, 1313 insertions(+), 232 deletions(-)
 create mode 100644 drivers/vfio/device_cdev.c

-- 
2.34.1

