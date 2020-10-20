Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DF283D7E
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgJERg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 13:36:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44592 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbgJERg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 13:36:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B703B2007A3;
        Mon,  5 Oct 2020 19:36:57 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B4BF42015A3;
        Mon,  5 Oct 2020 19:36:57 +0200 (CEST)
Received: from fsr-ub1864-111.ea.freescale.net (fsr-ub1864-111.ea.freescale.net [10.171.82.141])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 70B542032B;
        Mon,  5 Oct 2020 19:36:57 +0200 (CEST)
From:   Diana Craciun <diana.craciun@oss.nxp.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Diana Craciun <diana.craciun@oss.nxp.com>
Subject: [PATCH v6 00/10] vfio/fsl-mc: VFIO support for FSL-MC device
Date:   Mon,  5 Oct 2020 20:36:44 +0300
Message-Id: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DPAA2 (Data Path Acceleration Architecture) consists in
mechanisms for processing Ethernet packets, queue management,
accelerators, etc.

The Management Complex (mc) is a hardware entity that manages the DPAA2
hardware resources. It provides an object-based abstraction for software
drivers to use the DPAA2 hardware. The MC mediates operations such as
create, discover, destroy of DPAA2 objects.
The MC provides memory-mapped I/O command interfaces (MC portals) which
DPAA2 software drivers use to operate on DPAA2 objects.

A DPRC is a container object that holds other types of DPAA2 objects.
Each object in the DPRC is a Linux device and bound to a driver.
The MC-bus driver is a platform driver (different from PCI or platform
bus). The DPRC driver does runtime management of a bus instance. It
performs the initial scan of the DPRC and handles changes in the DPRC
configuration (adding/removing objects).

All objects inside a container share the same hardware isolation
context, meaning that only an entire DPRC can be assigned to
a virtual machine.
When a container is assigned to a virtual machine, all the objects
within that container are assigned to that virtual machine.
The DPRC container assigned to the virtual machine is not allowed
to change contents (add/remove objects) by the guest. The restriction
is set by the host and enforced by the mc hardware.

The DPAA2 objects can be directly assigned to the guest. However
the MC portals (the memory mapped command interface to the MC) need
to be emulated because there are commands that configure the
interrupts and the isolation IDs which are virtual in the guest.

Example:
echo vfio-fsl-mc > /sys/bus/fsl-mc/devices/dprc.2/driver_override
echo dprc.2 > /sys/bus/fsl-mc/drivers/vfio-fsl-mc/bind

The dprc.2 is bound to the VFIO driver and all the objects within
dprc.2 are going to be bound to the VFIO driver.

More details about the DPAA2 objects can be found here:
Documentation/networking/device_drivers/freescale/dpaa2/overview.rst

The patches are dependent on some changes in the mc-bus (bus/fsl-mc)
driver. The changes were needed in order to re-use code and to export
some more functions that are needed by the VFIO driver.
Currenlty the mc-bus patches were queued for merging.
https://www.spinics.net/lists/kernel/msg3680670.html

v5 --> v6
- style fixes
- review fixes

v4 --> v5
- do not allow mmap for DPRCs
- style fixes

v3 --> v4
- use bus provided functions to tear down the DPRC
- added reset support

v2 --> v3
- There is no need to align region size to page size
- read/write implemented for all DPAA2 objects
- review fixes

v1 --> v2
- Fixed the container reset, a new flag added to the firmware command
- Implement a bus notifier for setting driver_override


Bharat Bhushan (1):
  vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc devices

Diana Craciun (9):
  vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
  vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO ioctl
  vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
  vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
  vfio/fsl-mc: Added lock support in preparation for interrupt handling
  vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
  vfio/fsl-mc: trigger an interrupt via eventfd
  vfio/fsl-mc: Add read/write support for fsl-mc devices
  vfio/fsl-mc: Add support for device reset

 MAINTAINERS                               |   6 +
 drivers/vfio/Kconfig                      |   1 +
 drivers/vfio/Makefile                     |   1 +
 drivers/vfio/fsl-mc/Kconfig               |   9 +
 drivers/vfio/fsl-mc/Makefile              |   4 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 682 ++++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 194 ++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  55 ++
 include/uapi/linux/vfio.h                 |   1 +
 9 files changed, 953 insertions(+)
 create mode 100644 drivers/vfio/fsl-mc/Kconfig
 create mode 100644 drivers/vfio/fsl-mc/Makefile
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h

-- 
2.17.1

