Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B27AB3D4
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390116AbfIFIRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:17:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:23720 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389928AbfIFIRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:17:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 01:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,472,1559545200"; 
   d="scan'208";a="383186101"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Sep 2019 01:17:19 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, yan.y.zhao@intel.com, shaopeng.he@intel.com,
        chenbo.xia@intel.com, jun.j.tian@intel.com
Subject: [PATCH v2 00/13] vfio_pci: wrap pci device as a mediated device
Date:   Thu,  5 Sep 2019 15:59:17 +0800
Message-Id: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset aims to add a vfio-pci-like meta driver as a demo
user of the vfio changes introduced in "vfio/mdev: IOMMU aware
mediated device" patchset from Baolu Lu. Besides the test purpose,
per Alex's comments, it could also be a good base driver for
experimenting with device specific mdev migration.

Specific interface tested in this proposal:
 *) int mdev_set_iommu_device(struct device *dev,
 				struct device *iommu_device)
    introduced in the patch as below:
    "[PATCH v5 6/8] vfio/mdev: Add iommu related member in mdev_device"

Patch Overview:
 *) patch 1 ~ 7: code refactor for existing vfio-pci module
                 move the common codes from vfio_pci.c to
                 vfio_pci_common.c
 *) patch 8: add protection to perm_bits alloc/free
 *) patch 9: add vfio-mdev-pci sample driver
 *) patch 10: refine the sample driver
 *) patch 11 - 13: make the sample driver work for non-singleton groups
                   also work for vfio-pci and vfio-mdev-pci mixed usage
                   includes vfio-mdev-pci driver change and vfio_iommu_type1
                   changes.

Links:
 *) Link of "vfio/mdev: IOMMU aware mediated device"
         https://lwn.net/Articles/780522/
 *) Previous versions:
         RFC v1: https://lkml.org/lkml/2019/3/4/529
         RFC v2: https://lkml.org/lkml/2019/3/13/113
         RFC v3: https://lkml.org/lkml/2019/4/24/495
         Patch v1: https://www.spinics.net/lists/kvm/msg188952.html
 *) may try it with the codes in below repo
    current version is branch "v5.3-rc7-pci-mdev":
         https://github.com/luxis1999/vfio-mdev-pci-sample-driver.git

Test done on two NICs which share an iommu group.

-------------------------------------------------------------------
         |  NIC0           |  NIC1      | vIOMMU  | VMs  | Passtrhu
-------------------------------------------------------------------
  Test#0 |  vfio-pci       |  vfio-pci  | no      |  1   | pass
-------------------------------------------------------------------
  Test#1 |  vfio-pci       |  vfio-pci  | no      |  2   | fail[1]
-------------------------------------------------------------------
  Test#2 |  vfio-pci       |  vfio-pci  | yes     |  1   | fail[2]
-------------------------------------------------------------------
  Test#3 |  vfio-pci-mdev  |  vfio-pci  | no      |  1   | pass
-------------------------------------------------------------------
  Test#4 |  vfio-pci-mdev  |  vfio-pci  | no      |  2   | fail[3]
-------------------------------------------------------------------
  Test#5 |  vfio-pci-mdev  |  vfio-pci  | yes     |  1   | fail[4]
-------------------------------------------------------------------
Tips:
[1] qemu-system-x86_64: -device vfio-pci,host=01:00.1,id=hostdev0,addr=0x6: 
     vfio 0000:01:00.1: failed to open /dev/vfio/1: Device or resource busy
[2] qemu-system-x86_64: -device vfio-pci,host=01:00.1,id=hostdev0,addr=0x6:
     vfio 0000:01:00.1: group 1 used in multiple address spaces
[3] qemu-system-x86_64: -device vfio-pci,host=01:00.1,id=hostdev0,addr=0x6:
     vfio 0000:01:00.1: failed to setup container for group 1: Failed to set
     iommu for container: Device or resource busy
[4] qemu-system-x86_64: -device vfio-pci,host=01:00.1,id=hostdev0,addr=0x6:
     vfio 0000:01:00.1: failed to setup container for group 1: Failed to set
     iommu for container: Device or resource busy
    Or
    qemu-system-x86_64: -device vfio-pci,sysfsdev=/sys/bus/mdev/devices/
     83b8f4f2-509f-382f-3c1e-e6bfe0fa1003: vfio 83b8f4f2-509f-382f-3c1e-
     e6bfe0fa1003: failed to setup container for group 11: Failed to set iommu
     for container: Device or resource busy
Some other tests are not listed. Like bind NIC0 to vfio-pci-mdev and try to
passthru it with "vfio-pci,host=01:00.0", kernel will throw a warn log and
fail the operation.

Please feel free give your comments.

Thanks,
Yi Liu

Change log:
  patch v1 -> patch v2:
  - the sample driver implementation refined
  - the sample driver can work on non-singleton iommu groups
  - the sample driver can work with vfio-pci, devices from a non-singleton
    group can either be bound to vfio-mdev-pci or vfio-pci, and the
    assignment of this group still follows current vfio assignment rule.

  RFC v3 -> patch v1:
  - split the patchset from 3 patches to 9 patches to better demonstrate
    the changes step by step

  v2->v3:
  - use vfio-mdev-pci instead of vfio-pci-mdev
  - place the new driver under drivers/vfio/pci while define
    Kconfig in samples/Kconfig to clarify it is a sample driver

  v1->v2:
  - instead of adding kernel option to existing vfio-pci
    module in v1, v2 follows Alex's suggestion to add a
    separate vfio-pci-mdev module.
  - new patchset subject: "vfio/pci: wrap pci device as a mediated device"

Alex Williamson (1):
  samples: refine vfio-mdev-pci driver

Liu Yi L (12):
  vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header
  vfio_pci: refine user config reference in vfio-pci module
  vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
  vfio_pci: make common functions be extern
  vfio_pci: duplicate vfio_pci.c
  vfio_pci: shrink vfio_pci_common.c
  vfio_pci: shrink vfio_pci.c
  vfio/pci: protect cap/ecap_perm bits alloc/free with atomic op
  samples: add vfio-mdev-pci driver
  samples/vfio-mdev-pci: call vfio_add_group_dev()
  vfio/type1: use iommu_attach_group() for wrapping PF/VF as mdev
  vfio/type1: track iommu backed group attach

 drivers/vfio/pci/Makefile           |    9 +-
 drivers/vfio/pci/vfio_mdev_pci.c    |  497 ++++++++++++
 drivers/vfio/pci/vfio_pci.c         | 1449 +---------------------------------
 drivers/vfio/pci/vfio_pci_common.c  | 1455 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c  |    9 +
 drivers/vfio/pci/vfio_pci_private.h |   36 +
 drivers/vfio/vfio_iommu_type1.c     |  185 ++++-
 samples/Kconfig                     |   11 +
 8 files changed, 2194 insertions(+), 1457 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_mdev_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_common.c

-- 
2.7.4

