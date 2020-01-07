Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDB132612
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgAGMVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:21:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:13867 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgAGMVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:21:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 04:21:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,406,1571727600"; 
   d="scan'208";a="422475978"
Received: from iov2.bj.intel.com ([10.238.145.72])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jan 2020 04:21:01 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kevin.tian@intel.com, joro@8bytes.org, peterx@redhat.com,
        baolu.lu@linux.intel.com
Subject: [PATCH v4 00/12] vfio_pci: wrap pci device as a mediated device
Date:   Tue,  7 Jan 2020 20:01:37 +0800
Message-Id: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
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
 *) patch 1 ~ 9: code refactor for existing vfio-pci module
                 move the common codes from vfio_pci.c to
                 vfio_pci_common.c
 *) patch 10: build vfio-pci-common.ko
 *) patch 11: add initial vfio-mdev-pci sample driver
 *) patch 12: refine the sample driver

Links:
 *) Link of "vfio/mdev: IOMMU aware mediated device"
         https://lwn.net/Articles/780522/
 *) Previous versions:
         Patch v3: https://lkml.org/lkml/2019/11/22/1558
         Patch v2: https://lkml.org/lkml/2019/9/6/115
         Patch v1: https://www.spinics.net/lists/kvm/msg188952.html
         RFC v3: https://lkml.org/lkml/2019/4/24/495
         RFC v2: https://lkml.org/lkml/2019/3/13/113
         RFC v1: https://lkml.org/lkml/2019/3/4/529
 *) may try it with the codes in below repo
    https://github.com/luxis1999/vfio-mdev-pci-sample-driver.git : v5.5-rc5-pci-mdev

Please feel free give your comments.

Thanks,
Yi Liu

Change log:
  patch v3 -> patch v4:
  - switched the sequence of
    "vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header"
    and
    "vfio_pci: refine user config reference in vfio-pci module".
  - refined "vfio_pci: refine vfio_pci_driver reference in vfio_pci.c"
    per Alex's comments.
  - split the vfio_pci_private.h file to be two files.
  - Build vfio_pci_common.c to be vfio-pci-common.ko for code sharing
    outside of drivers/vfio/pci/.
  - moved vfio-mdev-pci driver to under samples/.
  - dropped "vfio/pci: protect cap/ecap_perm bits alloc/free" as new
    version builds vfio_pci_common.c to be a kernel module.

  patch v2 -> patch v3:
  - refresh the disable_idle_d3, disable_vga and nointxmask config
    according to user config in device open.
  - add a semaphore around the vfio-pci cap/ecap perm bits allocation/free
  - drop the non-singleton iommu group support to keep it simple as it's
    a sample driver for now.

  patch v1 -> patch v2:
  - the sample driver implementation refined
  - the sample driver can work on non-singleton iommu groups
  - the sample driver can work with vfio-pci, devices from a non-singleton
    group can either be bound to vfio-mdev-pci or vfio-pci, and the
    assignment of this group still follows current vfio assignment rule.

  RFC v3 -> patch v1:
  - split the patchset from 3 patches to 9 patches to better demonstrate
    the changes step by step

  rfc v2->v3:
  - use vfio-mdev-pci instead of vfio-pci-mdev
  - place the new driver under drivers/vfio/pci while define
    Kconfig in samples/Kconfig to clarify it is a sample driver

  rfc v1->v2:
  - instead of adding kernel option to existing vfio-pci
    module in v1, v2 follows Alex's suggestion to add a
    separate vfio-pci-mdev module.
  - new patchset subject: "vfio/pci: wrap pci device as a mediated device"

Alex Williamson (1):
  samples: refine vfio-mdev-pci driver

Liu Yi L (11):
  vfio_pci: refine user config reference in vfio-pci module
  vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header file
  vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
  vfio_pci: make common functions be extern
  vfio_pci: duplicate vfio_pci.c
  vfio_pci: shrink vfio_pci_common.c
  vfio_pci: shrink vfio_pci.c
  vfio_pci: duplicate vfio_pci_private.h to include/linux
  vfio: split vfio_pci_private.h into two files
  vfio: build vfio_pci_common.c into a kernel module
  samples: add vfio-mdev-pci driver

 drivers/vfio/pci/Kconfig              |    9 +-
 drivers/vfio/pci/Makefile             |   10 +-
 drivers/vfio/pci/vfio_pci.c           | 1477 +-------------------------------
 drivers/vfio/pci/vfio_pci_common.c    | 1512 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h   |   94 +-
 include/linux/vfio_pci_common.h       |  154 ++++
 samples/Kconfig                       |   10 +
 samples/Makefile                      |    1 +
 samples/vfio-mdev-pci/Makefile        |    4 +
 samples/vfio-mdev-pci/vfio_mdev_pci.c |  420 +++++++++
 10 files changed, 2128 insertions(+), 1563 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_common.c
 create mode 100644 include/linux/vfio_pci_common.h
 create mode 100644 samples/vfio-mdev-pci/Makefile
 create mode 100644 samples/vfio-mdev-pci/vfio_mdev_pci.c

-- 
2.7.4

