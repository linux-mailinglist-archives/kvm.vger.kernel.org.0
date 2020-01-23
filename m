Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168B7146988
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAWNsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:22 -0500
Received: from foss.arm.com ([217.140.110.172]:39636 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgAWNsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BD26FEC;
        Thu, 23 Jan 2020 05:48:19 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 56FE33F68E;
        Thu, 23 Jan 2020 05:48:18 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 00/30] Add reassignable BARs and PCIE 1.1 support
Date:   Thu, 23 Jan 2020 13:47:35 +0000
Message-Id: <20200123134805.1993-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
it from trying to reassign the BARs. Let's make the BARs reassignable so
we can get rid of this band-aid.

Let's also extend the legacy PCI emulation, which came out in 1992, so we
can properly emulate the PCI Express version 1.1 protocol, which is
relatively new, being published in 2005.

For this iteration, I have completely reworked the way BARs are
reassigned. As I was adding support for reassignable BARs to more devices,
it became clear to me that I was duplicating the same code over and over
again.  Furthermore, during device configuration, Linux can assign a region
resource to a BAR that temporarily overlaps with another device. With my
original approach, that meant that every device must be aware of the BAR
values for all the other devices.

With this new approach, the algorithm for activating/deactivating emulation
as BAR addresses change lives completely inside the PCI code. Each device
registers two callback functions which are called when device emulation is
activated (for example, to activate emulation for a newly assigned BAR
address), respectively, when device emulation is deactivated (a previous
BAR address is changed, and emulation for that region must be deactivated).

I also tried to do better at testing the patches. I have tested VFIO with
virtio-pci on an arm64 and a x86 machine:

1. AMD Seattle: Intel 82574L Gigabit Ethernet card, Samsung 970 Pro NVME
(controller registers are in the same BAR region as the MSIX table and PBA,
I wrote a nasty hack to make it work, will try to upstream something after
this series), Realtek 8168 Gigabit Ethernet card, NVIDIA Quadro P400 (only
device detection), AMD Firepro W2100 (amdgpu driver fails probing
because of missing expansion ROM emulation in kvmtool, I will send patches
for this too), Myricom 10 Gigabit Ethernet card, Seagate Barracuda 1000GB
drive.

2. Ryzen 3900x + Gigabyte x570 Aorus Master (bios F10): Realtek 8168
Gigabit Ethernet card, AMD Firepro W2100 (same issue as on Seattle).

Using the CFI flash emulation for kvmtool [1] and a hacked version of EDK2
as the firmware for the virtual machine, I was able download an official
debian arm64 installation iso, install debian and then run it. EDK2 patches
for kvmtool will be posted soon.

You will notice from the changelog that there are a lot of new patches
(17!), but most of them are fixes for stuff that I found while testing.

Patches 1-18 are fixes and cleanups, and can be merged independently. They
are pretty straightforward, so if the size of the series looks off-putting,
please review these first. I am aware that the series has grown quite a
lot, I am willing to split the fixes from the rest of the patches, or
whatever else can make reviewing easier.

Changes in v2:
* Patches 2, 11-18, 20, 22-27, 29 are new.
* Patches 11, 13, and 14 have been dropped.
* Reworked the way BAR reassignment is implemented.
* The patch "Add PCI Express 1.1 support" has been reworked to apply only
  to arm64. For x86 we would need ACPI support in order to advertise the
  location of the ECAM space.
* Gathered Reviewed-by tags.
* Implemented review comments.

[1] https://www.spinics.net/lists/arm-kernel/msg778623.html

Alexandru Elisei (24):
  Makefile: Use correct objcopy binary when cross-compiling for x86_64
  hw/i8042: Compile only for x86
  Remove pci-shmem device
  Check that a PCI device's memory size is power of two
  arm/pci: Advertise only PCI bus 0 in the DT
  vfio/pci: Allocate correct size for MSIX table and PBA BARs
  vfio/pci: Don't assume that only even numbered BARs are 64bit
  vfio/pci: Ignore expansion ROM BAR writes
  vfio/pci: Don't access potentially unallocated regions
  virtio: Don't ignore initialization failures
  Don't ignore errors registering a device, ioport or mmio emulation
  hw/vesa: Don't ignore fatal errors
  hw/vesa: Set the size for BAR 0
  Use independent read/write locks for ioport and mmio
  pci: Add helpers for BAR values and memory/IO space access
  virtio/pci: Get emulated region address from BARs
  vfio: Destroy memslot when unmapping the associated VAs
  vfio: Reserve ioports when configuring the BAR
  vfio/pci: Don't write configuration value twice
  pci: Implement callbacks for toggling BAR emulation
  pci: Toggle BAR I/O and memory space emulation
  pci: Implement reassignable BARs
  vfio: Trap MMIO access to BAR addresses which aren't page aligned
  arm/arm64: Add PCI Express 1.1 support

Julien Thierry (5):
  ioport: pci: Move port allocations to PCI devices
  pci: Fix ioport allocation size
  arm/pci: Fix PCI IO region
  virtio/pci: Make memory and IO BARs independent
  arm/fdt: Remove 'linux,pci-probe-only' property

Sami Mujawar (1):
  pci: Fix BAR resource sizing arbitration

 Makefile                          |   6 +-
 arm/fdt.c                         |   1 -
 arm/include/arm-common/kvm-arch.h |   4 +-
 arm/include/arm-common/pci.h      |   1 +
 arm/ioport.c                      |   3 +-
 arm/kvm.c                         |   3 +
 arm/pci.c                         |  25 +-
 builtin-run.c                     |   6 +-
 hw/i8042.c                        |  14 +-
 hw/pci-shmem.c                    | 400 ------------------------------
 hw/vesa.c                         | 132 +++++++---
 include/kvm/devices.h             |   3 +-
 include/kvm/ioport.h              |  10 +-
 include/kvm/kvm-config.h          |   2 +-
 include/kvm/kvm.h                 |   9 +-
 include/kvm/pci-shmem.h           |  32 ---
 include/kvm/pci.h                 | 168 ++++++++++++-
 include/kvm/util.h                |   2 +
 include/kvm/vesa.h                |   6 +-
 include/kvm/virtio-pci.h          |   3 -
 include/kvm/virtio.h              |   7 +-
 include/linux/compiler.h          |   2 +-
 ioport.c                          |  57 ++---
 kvm.c                             |  65 ++++-
 mips/kvm.c                        |   3 +-
 mmio.c                            |  26 +-
 pci.c                             | 320 ++++++++++++++++++++++--
 powerpc/include/kvm/kvm-arch.h    |   2 +-
 powerpc/ioport.c                  |   3 +-
 powerpc/spapr_pci.c               |   2 +-
 vfio/core.c                       |  22 +-
 vfio/pci.c                        | 231 +++++++++++++----
 virtio/9p.c                       |   9 +-
 virtio/balloon.c                  |  10 +-
 virtio/blk.c                      |  14 +-
 virtio/console.c                  |  11 +-
 virtio/core.c                     |   9 +-
 virtio/mmio.c                     |  13 +-
 virtio/net.c                      |  32 +--
 virtio/pci.c                      | 220 +++++++++++-----
 virtio/scsi.c                     |  14 +-
 x86/include/kvm/kvm-arch.h        |   2 +-
 x86/ioport.c                      |  66 +++--
 43 files changed, 1217 insertions(+), 753 deletions(-)
 delete mode 100644 hw/pci-shmem.c
 delete mode 100644 include/kvm/pci-shmem.h

-- 
2.20.1

