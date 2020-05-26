Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC91D6F1F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 04:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgERCwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 22:52:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:24736 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgERCwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 22:52:19 -0400
IronPort-SDR: SmoqznO1D0dVkBH3AVfpSvsozgkXwBaEdEXwtE9Ub9mCKUgL1HQVMjET40QHv7iO1XV9tL2xfV
 oEnV6VTRDc3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 19:52:18 -0700
IronPort-SDR: dGpONDL4XINzTKKYCkvwOCfkoLHItmlDUewrlGxjlXzMlcvILb+Ls18jDQ6NBVLjVAZWKaO2sb
 TyupXRUwlv2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="267371304"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2020 19:52:15 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v4 00/10] Introduce vendor ops in vfio-pci
Date:   Sun, 17 May 2020 22:42:02 -0400
Message-Id: <20200518024202.13996-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using vfio-pci to pass through devices, though it's desired to use
its default implementations in most of time, it is also sometimes
necessary to call vendors specific operations.
For example, in order to do device live migration, the way of dirty
pages detection and device state save-restore may be varied from device
to device.
Vendors may want to add a vendor device region or may want to
intercept writes to a BAR region.
So, in this series, we introduce a way to allow vendors to provide vendor
specific ops for VFIO devices and meanwhile export several vfio-pci
interfaces as default implementations to simplify code of vendor driver
and avoid duplication.

Vendor driver registration/unregistration goes like this:
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
A success probe() would make bind vfio device to vendor provided
vfio_device_ops, which would call exported default implementations in
vfio_pci_ops if necessary. 


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
   register and if vendor driver only do the unregistration in its module_exit,
   then it would have no chance to do the unregistration.


Patch Overview
patches 1-2 provide register/unregister interfaces for vendor drivers
Patch 3     exports several members in vdev, including vendor_data, and
            exports functions in vfio_pci_ops to allow them accessible
	    from vendor drivers.
patches 4-5 export some more vdev members to vendor driver to simplify
            their implementations.
patch 6     is from Tina Zhang to define vendor specific Irq type
            capability.
patch 7     introduces a new vendor defined irq type
            VFIO_IRQ_TYPE_REMAP_BAR_REGION.
patches 8-10
            use VF live migration driver for Intel's 710 SRIOV devices
            as an example of how to implement this vendor ops interface.
    patch 8 first let the vendor ops pass through VFs.
    patch 9 implements a migration region based on migration protocol
            defined in [1][2].
            (Some dirty page tracking functions are intentionally
            commented out and would send out later in future.)
    patch 10 serves as an example of how to define vendor specific irq
            type. This irq will trigger qemu to dynamic map BAR regions
	    in order to implement software based dirty page track.

Changelog:
RFC v3- RFC v4:
- use exported function to make vendor driver access internal fields of
  vdev rather than make struct vfio_pci_device public. (Alex)
- add a new interface vfio_pci_get_barmap() to call vfio_pci_setup_barma()
  and let vfio_pci_setup_barmap() still able to return detailed errno.
  (Alex)
- removed sample code to pass through igd devices. instead, use the
  first patch (patch 8/10) of i40e vf migration as an mere pass-through
  example.
- rebased code to 5.7 and VFIO migration kernel patches v17 and qemu
  patches v16.
- added a demo of vendor defined irq type.

RFC v2- RFC v3:
- embedding struct vfio_pci_device into struct vfio_pci_device_private.
(Alex)

RFC v1- RFC v2:
- renamed mediate ops to vendor ops
- use of request_module and module alias to manage vendor driver load
  (Alex)
- changed from vfio_pci_ops calling vendor ops
  to vendor ops calling default vfio_pci_ops  (Alex)
- dropped patches for dynamic traps of BARs. will submit them later.

Links:
[1] VFIO migration kernel v17:
    https://patchwork.kernel.org/cover/11466129/
[2] VFIO migration qemu v16:
    https://patchwork.kernel.org/cover/11456557/

Previous versions:
RFC v3: https://lkml.org/lkml/2020/2/11/142

RFC v2: https://lkml.org/lkml/2020/1/30/956

RFC v1:
kernel part: https://www.spinics.net/lists/kernel/msg3337337.html.
qemu part: https://www.spinics.net/lists/kernel/msg3337337.html.


Tina Zhang (1):
  vfio: Define device specific irq type capability

Yan Zhao (9):
  vfio/pci: register/unregister vfio_pci_vendor_driver_ops
  vfio/pci: macros to generate module_init and module_exit for vendor
    modules
  vfio/pci: export vendor_data, irq_type, num_regions, pdev and
    functions in vfio_pci_ops
  vfio/pci: let vfio_pci know number of vendor regions and vendor irqs
  vfio/pci: export vfio_pci_get_barmap
  vfio/pci: introduce a new irq type VFIO_IRQ_TYPE_REMAP_BAR_REGION
  i40e/vf_migration: VF live migration - pass-through VF first
  i40e/vf_migration: register a migration vendor region
  i40e/vf_migration: vendor defined irq_type to support dynamic bar map

 drivers/net/ethernet/intel/Kconfig            |  10 +
 drivers/net/ethernet/intel/i40e/Makefile      |   2 +
 .../ethernet/intel/i40e/i40e_vf_migration.c   | 904 ++++++++++++++++++
 .../ethernet/intel/i40e/i40e_vf_migration.h   | 119 +++
 drivers/vfio/pci/vfio_pci.c                   | 181 +++-
 drivers/vfio/pci/vfio_pci_private.h           |   9 +
 drivers/vfio/pci/vfio_pci_rdwr.c              |  10 +
 include/linux/vfio.h                          |  58 ++
 include/uapi/linux/vfio.h                     |  30 +-
 9 files changed, 1311 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
 create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h

-- 
2.17.1

