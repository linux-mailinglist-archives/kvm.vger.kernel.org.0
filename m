Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC933A5F8
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 15:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfFINhx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 09:37:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:25056 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbfFINhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 09:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jun 2019 06:37:52 -0700
X-ExtLoop1: 1
Received: from yiliu-dev.bj.intel.com ([10.238.156.125])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2019 06:37:50 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v1 0/9] vfio_pci: wrap pci device as a mediated device
Date:   Sat,  8 Jun 2019 21:21:02 +0800
Message-Id: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
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

Links:
 *) Link of "vfio/mdev: IOMMU aware mediated device"
         https://lwn.net/Articles/780522/
 *) Previous versions:
         RFC v1: https://lkml.org/lkml/2019/3/4/529
         RFC v2: https://lkml.org/lkml/2019/3/13/113
         RFC v3: https://lkml.org/lkml/2019/4/24/495
 *) may try it with the codes in below repo
    current version is branch "v5.2-rc3-pci-mdev":
         https://github.com/luxis1999/vfio-mdev-pci-sample-driver.git

Please feel free give your comments.

Thanks,
Yi Liu

Change log:
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

Liu Yi L (9):
  vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header
  vfio_pci: refine user config reference in vfio-pci module
  vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
  vfio_pci: make common functions be extern
  vfio_pci: duplicate vfio_pci.c
  vfio_pci: shrink vfio_pci_common.c
  vfio_pci: shrink vfio_pci.c
  vfio/pci: protect cap/ecap_perm bits alloc/free with atomic op
  smaples: add vfio-mdev-pci driver

 drivers/vfio/pci/Makefile           |    9 +-
 drivers/vfio/pci/vfio_mdev_pci.c    |  403 ++++++++++
 drivers/vfio/pci/vfio_pci.c         | 1449 +---------------------------------
 drivers/vfio/pci/vfio_pci_common.c  | 1458 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c  |    9 +
 drivers/vfio/pci/vfio_pci_private.h |   36 +
 samples/Kconfig                     |   11 +
 7 files changed, 1933 insertions(+), 1442 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_mdev_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_common.c

-- 
2.7.4

