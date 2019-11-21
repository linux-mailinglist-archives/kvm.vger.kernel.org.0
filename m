Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF81071A7
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 12:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKVLmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 06:42:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:15269 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbfKVLmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 06:42:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 03:42:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,229,1571727600"; 
   d="scan'208";a="358110467"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 03:42:02 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com
Cc:     kevin.tian@intel.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, joro@8bytes.org, jean-philippe.brucker@arm.com,
        peterx@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 00/10] vfio_pci: wrap pci device as a mediated device
Date:   Thu, 21 Nov 2019 19:23:37 +0800
Message-Id: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
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

Links:
 *) Link of "vfio/mdev: IOMMU aware mediated device"
         https://lwn.net/Articles/780522/
 *) Previous versions:
         Patch v2: https://lkml.org/lkml/2019/9/6/115
         Patch v1: https://www.spinics.net/lists/kvm/msg188952.html
         RFC v3: https://lkml.org/lkml/2019/4/24/495
         RFC v2: https://lkml.org/lkml/2019/3/13/113
         RFC v1: https://lkml.org/lkml/2019/3/4/529
 *) may try it with the codes in below repo
    https://github.com/luxis1999/vfio-mdev-pci-sample-driver.git : v5.4-rc7-pci-mdev

Please feel free give your comments.

Thanks,
Yi Liu

Change log:
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

Liu Yi L (9):
  vfio_pci: move vfio_pci_is_vga/vfio_vga_disabled to header
  vfio_pci: refine user config reference in vfio-pci module
  vfio_pci: refine vfio_pci_driver reference in vfio_pci.c
  vfio_pci: make common functions be extern
  vfio_pci: duplicate vfio_pci.c
  vfio_pci: shrink vfio_pci_common.c
  vfio_pci: shrink vfio_pci.c
  vfio/pci: protect cap/ecap_perm bits alloc/free
  samples: add vfio-mdev-pci driver

 drivers/vfio/pci/Makefile           |    9 +-
 drivers/vfio/pci/vfio_mdev_pci.c    |  430 ++++++++++
 drivers/vfio/pci/vfio_pci.c         | 1460 +---------------------------------
 drivers/vfio/pci/vfio_pci_common.c  | 1471 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c  |   33 +-
 drivers/vfio/pci/vfio_pci_private.h |   39 +
 samples/Kconfig                     |   11 +
 7 files changed, 2000 insertions(+), 1453 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_mdev_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_common.c

-- 
2.7.4

