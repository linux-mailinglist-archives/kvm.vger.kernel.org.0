Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF36508BC
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiLSIrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiLSIrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:37 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B09CA1B1
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439656; x=1702975656;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QMoyz3oAiIMz2I4vg0aj3CNysJqnK+6UyxEw3x+o8qo=;
  b=cHvNJd06QmreVmk1o4CzXXeCLeT8hpqftTFnR6WpnqfabwX+ISG6Y6vw
   T8Vh/tYQyf1ZOG7BjNxYhubMvB7KbzHpyrCnmPUVLyKleH9UvZSPAId02
   yG0PxeTD3Z30J02kA/gROWRyDCO1KmZtyYUOjdoFjoC0VHOgfyM9Pg58E
   4LDBsHgRj5WQmStt7n5vbwWMyEB/sXYcKyC/SjE/q7MobLFgtd/hzor9q
   erzrmpg5/l8JASOFCrPCxTeBL4SyyMrXFF5yOlM33L0TPnOYjM1PGbgrO
   cySXAdkLeJv/Q7qcYgJb3+J48bZh3T7NQHCnVAohSnFwNMAE2boreHZCK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528426"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528426"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233713"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233713"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:34 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 00/12] Add vfio_device cdev for iommufd support
Date:   Mon, 19 Dec 2022 00:47:06 -0800
Message-Id: <20221219084718.9342-1-yi.l.liu@intel.com>
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
blocking device access before iommufd bind, making vfio_device_open() be
exclusive between the group path and the cdev path. Eventually, adds the
cdev support for vfio device, and makes group infrastructure optional as
it is not needed when vfio device cdev is compiled.

This is also a base for further support iommu nesting for vfio device[2].

The complete code can be found in below branch, simple test done with the
legacy group path and the cdev path. Draft QEMU branch can be found at[3]

https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_rfcv1
(config CONFIG_IOMMUFD=y)

[1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
[2] https://github.com/yiliu1765/iommufd/tree/wip/iommufd-v6.1-rc3-nesting
[3] https://github.com/yiliu1765/qemu/tree/wip/qemu-iommufd-6.1-rc3

Regards,
	Yi Liu

Yi Liu (12):
  vfio: Allocate per device file structure
  vfio: Refine vfio file kAPIs
  vfio: Accept vfio device file in the driver facing kAPI
  kvm/vfio: Rename kvm_vfio_group to prepare for accepting vfio device
    fd
  kvm/vfio: Accept vfio device file from userspace
  vfio: Pass struct vfio_device_file * to vfio_device_open/close()
  vfio: Block device access via device fd until device is opened
  vfio: Add infrastructure for bind_iommufd and attach
  vfio: Make vfio_device_open() exclusive between group path and device
    cdev path
  vfio: Add cdev for vfio_device
  vfio: Add ioctls for device cdev iommufd
  vfio: Compile group optionally

 Documentation/virt/kvm/devices/vfio.rst |  32 +-
 drivers/vfio/Kconfig                    |  17 +
 drivers/vfio/Makefile                   |   3 +-
 drivers/vfio/group.c                    | 131 +++----
 drivers/vfio/iommufd.c                  |  79 +++-
 drivers/vfio/pci/vfio_pci_core.c        |   4 +-
 drivers/vfio/vfio.h                     | 108 +++++-
 drivers/vfio/vfio_main.c                | 492 ++++++++++++++++++++++--
 include/linux/vfio.h                    |  21 +-
 include/uapi/linux/iommufd.h            |   2 +
 include/uapi/linux/kvm.h                |  23 +-
 include/uapi/linux/vfio.h               |  64 +++
 virt/kvm/vfio.c                         | 143 +++----
 13 files changed, 891 insertions(+), 228 deletions(-)

-- 
2.34.1

