Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A4814E704
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 03:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgAaCSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 21:18:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:45714 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgAaCSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 21:18:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 18:18:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="222995947"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 30 Jan 2020 18:18:03 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 0/9] Introduce vendor ops in vfio-pci
Date:   Thu, 30 Jan 2020 21:08:03 -0500
Message-Id: <20200131020803.27519-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using module vfio-pci to pass through devices, though for the most
of time, it is desired to use default implementations in vfio-pci, vendors
sometimes may want to do certain kind of customization.
For example, vendors may want to add a vendor device region or may want to
intercept writes to a BAR region.
So, in this patch set, we introduce a way to allow vendors to focus on
handling of regions of their interest and call default vfio-pci ops to
handle the reset ones.

It goes like this:
(1) macros are provided to let vendor drivers register/unregister
vfio_pci_vendor_driver_ops to vfio_pci in their module_init() and
module_exit().
vfio_pci_vendor_driver_ops contains callbacks probe() and remove() and a
pointer to vfio_device_ops.

(2) vendor drivers define their module aliases as
"vfio-pci:$vendor_id-$device_id".
E.g. A vendor module for VF devices of Intel(R) Ethernet Controller XL710
family can define its module alias as MODULE_ALIAS("vfio-pci:8086-154c").

(3) when module vfio_pci is bound to a device, it would call modprobe in
user space for modules of alias "vfio-pci:$vendor_id-$device_id", which
would trigger unloaded vendor drivers to register their
vfio_pci_vendor_driver_ops to vfio_pci.
Then it searches registered ops list and calls probe() to test whether this
vendor driver supports this physical device.
A success probe() would make vfio_pci to use vfio_device_ops provided
vendor driver as the ops of the vfio device. So vfio_pci_ops are not to be
called for this device any more. Instead, they are exported to be called
from vendor drivers as a default implementation.


                                        _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
                                  
 __________   (un)register vendor ops  |  ___________    ___________   |
|          |<----------------------------|    VF    |   |           |   
| vfio-pci |                           | |  vendor  |   | PF driver |  |
|__________|---------------------------->|  driver  |   |___________|   
     |           probe/remove()        |  -----------          |       |
     |                                                         |         
     |                                 |_ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _|
    \|/                                                       \|/
-----------                                              ------------
|    VF   |                                              |    PF    |
-----------                                              ------------
                   a typical usage in SRIOV



Ref counts:
(1) vendor drivers must be a module and compiled to depend on module
vfio_pci.
(2) In vfio_pci, a successful register would add refs of itself, and a
successful unregister would derefs of itself.
(3) In vfio_pci, a successful probe() of a vendor driver would add ref of
the vendor module. It derefs of the vendor module after calling remove().
(4) macro provided to make sure vendor module always unregister itself in
its module_exit

Those are to prevent below conditions:
a. vfio_pci is unloaded after a successful register from vendor driver.
   Though vfio_pci would later call modprobe to ask the vendor module to
   register again, it cannot help if vendor driver remain as loaded
   across unloading-loading of vfio_pci.
b. vendor driver unregisters itself after successfully probed by vfio_pci.
c. circular dependency between vfio_pci and the vendor driver.
   if vfio_pci adds refs to both vfio_pci and vendor driver on a successful
   register and if vendor driver only do the unregister in its module_exit,
   then it would have no chance to do the unregister.


Patch Overview
patches 1-2 makes vfio_pci inheritable by vendor modules
            by making part of struct vfio_pci_device public and functions
            in struct vfio_pci_ops exported
patches 3-4 provide register/unregister interfaces for vendor drivers
patches 5-6 some more enhancements
patch 7 provides an sample to pass through IGD devices
patches 8-9 implement VF live migration on Intel's 710 SRIOV devices.
            Some dirty page tracking functions are intentionally
            commented out and would send out later in future.

Changelog:
RFC v1- RFC v2:
- renamed mediate ops to vendor ops
- use of request_module and module alias to manage vendor driver load
  (Alex)
- changed from vfio_pci_ops calling vendor ops
  to vendor ops calling default vfio_pci_ops  (Alex)
- dropped patches for dynamic traps of BARs. will submit them later.

Links:
Previous version (RFC v1):
kernel part: https://www.spinics.net/lists/kernel/msg3337337.html.
qemu part: https://www.spinics.net/lists/kernel/msg3337337.html.

VFIO live migration v8:
https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05542.html.


Yan Zhao (9):
  vfio/pci: split vfio_pci_device into public and private parts
  vfio/pci: export functions in vfio_pci_ops
  vfio/pci: register/unregister vfio_pci_vendor_driver_ops
  vfio/pci: macros to generate module_init and module_exit for vendor
    modules
  vfio/pci: let vfio_pci know how many vendor regions are registered
  vfio/pci: export vfio_pci_setup_barmap
  samples/vfio-pci: add a sample vendor module of vfio-pci for IGD
    devices
  vfio: header for vfio live migration region.
  i40e/vf_migration: vfio-pci vendor driver for VF live migration

 drivers/net/ethernet/intel/Kconfig            |  10 +
 drivers/net/ethernet/intel/i40e/Makefile      |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 590 ++++++++++++++++++
 .../ethernet/intel/i40e/i40e_vf_migration.h   |  92 +++
 drivers/vfio/pci/vfio_pci.c                   | 337 ++++++----
 drivers/vfio/pci/vfio_pci_config.c            | 157 ++---
 drivers/vfio/pci/vfio_pci_igd.c               |  16 +-
 drivers/vfio/pci/vfio_pci_intrs.c             | 171 ++---
 drivers/vfio/pci/vfio_pci_nvlink2.c           |  16 +-
 drivers/vfio/pci/vfio_pci_private.h           |  11 +-
 drivers/vfio/pci/vfio_pci_rdwr.c              |  60 +-
 include/linux/vfio.h                          |  61 ++
 include/uapi/linux/vfio.h                     | 149 +++++
 samples/Kconfig                               |   6 +
 samples/Makefile                              |   1 +
 samples/vfio-pci/Makefile                     |   2 +
 samples/vfio-pci/igd_pt.c                     | 153 +++++
 18 files changed, 1518 insertions(+), 318 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
 create mode 100644 samples/vfio-pci/Makefile
 create mode 100644 samples/vfio-pci/igd_pt.c

-- 
2.17.1

