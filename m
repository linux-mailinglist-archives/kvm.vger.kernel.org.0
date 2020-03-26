Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F16194302
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgCZPYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:24:55 -0400
Received: from foss.arm.com ([217.140.110.172]:33664 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgCZPYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:24:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FF0D7FA;
        Thu, 26 Mar 2020 08:24:54 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 468AE3F71E;
        Thu, 26 Mar 2020 08:24:53 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 00/32] Add reassignable BARs and PCIE 1.1 support
Date:   Thu, 26 Mar 2020 15:24:06 +0000
Message-Id: <20200326152438.6218-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
it from trying to reassign the BARs. Let's make the BARs reassignable so we
can get rid of this band-aid.

Let's also extend the legacy PCI emulation, which came out in 1992, so we
can properly emulate the PCI Express version 1.1 protocol, which is new in
comparison, being published in 2005.

During device configuration, Linux can assign a region resource to a BAR
that temporarily overlaps with another device. This means that the code
that emulates BAR reassignment must be aware of all the registered PCI
devices. Because of this, and to avoid re-implementing the same code for
each emulated device, the algorithm for activating/deactivating emulation
as BAR addresses change lives completely inside the PCI code. Each device
registers two callback functions which are called when device emulation is
activated (for example, to activate emulation for a newly assigned BAR
address), respectively, when device emulation is deactivated (a previous
BAR address is changed, and emulation for that region must be deactivated).

There's one change this iteration that deserves a more elaborate
explanation. I have removed patch #9 "arm/pci: Fix PCI IO region". The
problem that the patch is trying to fix is still present: the PCI ioport
region overlaps with the 8250 uart, but the fix that the patch proposed was
incorrect, as it only works when the guest uses 4k pages (gory details at
[1]). I considered several fixes:

1. Changing the uart to live above the 64k address, which makes sense, as
on arm it is memory mapped anyway, and the Linux driver gets that address
from the dtb.

2. Changing the PCI CPU I/O addresses to live in the PCI MMIO space, and
keeping the PCI bus I/O addresses unchanged (in the 0-64K region).

3. Dropping PCI I/O ports altogether, which also makes sense: I/O ports are
an x86 architectural feature, and the PCI spec mandates that all controls
that are accessible via an I/O BAR should also be implemented by a memory
BAR.

However, all the above approaches are not the obviously right solution and
not trivial to implement for various reasons:

1. Software might rely on those addresses being fixed (kvm-unit-tests,
EDK2).

2. It requires invasive and subtle changes in the PCI and the device
emulation code, because now we have to distinguish between PCI CPU address
(which we trap and emulate) and PCI bus addresses, which will be used by
the guest to program the devices (for example, the I/O BAR addresses).

3. It requires changes to each device PCI code, because PCI I/O port
address requests failing will become a recoverable error on the arm and
arm64 architectures.

Considering the fact that this series is already very big, and this bug has
been present since 2014 without anyone complaining about it, I decided to
leave out any potential fixes. I will investigate which fix works better
and I will send it as a standalone series.

I tested the patches on an x86_64 and arm64 machine:

1. On AMD Seattle. Tried PCI passthrough using two different guests in each
case; one with 4k pages, and one with 64k pages (the CPU doesn't have
support for 16k pages):
- Intel 82574L Gigabit Ethernet card
- Samsung 970 Pro NVME (controller registers are in the same BAR region as the
  MSIX table and PBA, I wrote a nasty hack to make it work, will try to upstream
  something after this series)
- Realtek 8168 Gigabit Ethernet card
- NVIDIA Quadro P400 (nouveau probe fails because expansion ROM emulation not
  implemented in kvmtool, I will write a fix for that)
- AMD Firepro W2100 (amdgpu driver probe fails just like on the NVIDIA card)
- Seagate Barracuda 1000GB drive and Crucial MX500 SSD attached to a PCIE to
  SATA card.

I also wrote a kvm-unit-tests test that stresses the MMIO emulation locking
scheme that I implemented by spawning 4 vcpus (the Seattle machine has 8
physical CPUs) that toggle memory, and another 4 vcpus that read from the memory
region described by a BAR. I ran this under valgrind, and no deadlocks
use-after-free errors were detected.

2. Ryzen 3900x + Gigabyte x570 Aorus Master (bios F10). Tried PCI passthrough
with a Realtek 8168 and Intel 82574L Gigabit Ethernet cards at the same time,
plus running with --sdl enabled to test VESA device emulation at the same time.
I also managed to get the guest to do bar reassignment for one device by using
the kernel command line parameter pci.resource_alignment=16@pci:10ec:8168.

Patches 1-18 are fixes and cleanups, and can be merged independently. They
are pretty straightforward, so if the size of the series looks off-putting,
please review these first. I am aware that the series has grown quite a
lot, I am willing to split the fixes from the rest of the patches, or
whatever else can make reviewing easier.

Changes in v3:
* Patches 18, 24 and 26 are new.
* Dropped #9 "arm/pci: Fix PCI IO region" for reasons explained above.
* Reworded commit message for #12 "vfio/pci: Ignore expansion ROM BAR
  writes" to make it clear that kvmtool's implementation of VFIO doesn't
  support expansion BAR emulation.
* Moved variable declaration at the start of the function for #13
  "vfio/pci: Don't access unallocated regions".
* Patch #15 "Don't ignore errors registering a device, ioport or mmio
  emulation" uses ioport__remove consistenly.
* Reworked error cleanup for #16 "hw/vesa: Don't ignore fatal errors".
* Reworded commit message for #17 "hw/vesa: Set the size for BAR 0".
* Reworked #19 "ioport: mmio: Use a mutex and reference counting for
  locking" to also use reference counting to prevent races (and updated the
  commit message in the process).
* Added the function pci__bar_size to #20 "pci: Add helpers for BAR values
  and memory/IO space access".
* Protect mem_banks list with a mutex in #22 "vfio: Destroy memslot when
  unmapping the associated VAs"; also moved the munmap after the slot is
  destroyed, as per the KVM api.
* Dropped the rework of the vesa device in patch #27 "pci: Implement
  callbacks for toggling BAR emulation". Also added a few assert statements
  in some callbacks to make sure that they don't get called with an
  unxpected BAR number (which can only result from a coding error). Also
  return -ENOENT when kvm__deregister_mmio fails, to match ioport behavior
  and for better diagnostics.
* Dropped the PCI configuration write callback from the vesa device in #28
  "pci: Toggle BAR I/O and memory space emulation". Apparently, if we don't
  allow the guest kernel to disable BAR access, it treats the VESA device
  as a VGA boot device, instead of a regular VGA device, and Xorg cannot
  use it.
* Droped struct bar_info from #29 "pci: Implement reassignable BARs". Also
  changed pci_dev_err to pci_dev_warn in pci_{activate,deactivate}_bar,
  because the errors can be benign (they can happen because two vcpus race
  against each other to deactivate memory or I/O access, for example).
* Replaced the PCI device configuration space define with the actual
  number in #32 "arm/arm64: Add PCI Express 1.1 support". On some distros
  the defines weren't present in /usr/include/linux/pci_regs.h.
* Implemented other minor review comments.
* Gathered Reviewed-by tags.

Changes in v2:
* Patches 2, 11-18, 20, 22-27, 29 are new.
* Patches 11, 13, and 14 have been dropped.
* Reworked the way BAR reassignment is implemented.
* The patch "Add PCI Express 1.1 support" has been reworked to apply only
  to arm64. For x86 we would need ACPI support in order to advertise the
  location of the ECAM space.
* Gathered Reviewed-by tags.
* Implemented review comments.

[1] https://www.spinics.net/lists/kvm/msg209178.html
[2] https://www.spinics.net/lists/kvm/msg209178.html
[3] https://www.spinics.net/lists/arm-kernel/msg778623.html


Alexandru Elisei (27):
  Makefile: Use correct objcopy binary when cross-compiling for x86_64
  hw/i8042: Compile only for x86
  Remove pci-shmem device
  Check that a PCI device's memory size is power of two
  arm/pci: Advertise only PCI bus 0 in the DT
  vfio/pci: Allocate correct size for MSIX table and PBA BARs
  vfio/pci: Don't assume that only even numbered BARs are 64bit
  vfio/pci: Ignore expansion ROM BAR writes
  vfio/pci: Don't access unallocated regions
  virtio: Don't ignore initialization failures
  Don't ignore errors registering a device, ioport or mmio emulation
  hw/vesa: Don't ignore fatal errors
  hw/vesa: Set the size for BAR 0
  ioport: Fail when registering overlapping ports
  ioport: mmio: Use a mutex and reference counting for locking
  pci: Add helpers for BAR values and memory/IO space access
  virtio/pci: Get emulated region address from BARs
  vfio: Destroy memslot when unmapping the associated VAs
  vfio: Reserve ioports when configuring the BAR
  pci: Limit configuration transaction size to 32 bits
  vfio/pci: Don't write configuration value twice
  vesa: Create device exactly once
  pci: Implement callbacks for toggling BAR emulation
  pci: Toggle BAR I/O and memory space emulation
  pci: Implement reassignable BARs
  vfio: Trap MMIO access to BAR addresses which aren't page aligned
  arm/arm64: Add PCI Express 1.1 support

Julien Thierry (4):
  ioport: pci: Move port allocations to PCI devices
  pci: Fix ioport allocation size
  virtio/pci: Make memory and IO BARs independent
  arm/fdt: Remove 'linux,pci-probe-only' property

Sami Mujawar (1):
  pci: Fix BAR resource sizing arbitration

 Makefile                          |   6 +-
 arm/fdt.c                         |   1 -
 arm/include/arm-common/kvm-arch.h |   4 +-
 arm/ioport.c                      |   3 +-
 arm/pci.c                         |   4 +-
 builtin-run.c                     |   6 +-
 hw/i8042.c                        |  14 +-
 hw/pci-shmem.c                    | 400 ------------------------------
 hw/vesa.c                         | 113 ++++++---
 include/kvm/devices.h             |   3 +-
 include/kvm/ioport.h              |  12 +-
 include/kvm/kvm-config.h          |   2 +-
 include/kvm/kvm.h                 |  11 +-
 include/kvm/pci-shmem.h           |  32 ---
 include/kvm/pci.h                 | 163 +++++++++++-
 include/kvm/rbtree-interval.h     |   4 +-
 include/kvm/util.h                |   2 +
 include/kvm/vesa.h                |   6 +-
 include/kvm/virtio-pci.h          |   3 -
 include/kvm/virtio.h              |   7 +-
 include/linux/compiler.h          |   2 +-
 ioport.c                          | 108 ++++----
 kvm.c                             | 101 +++++++-
 mips/kvm.c                        |   3 +-
 mmio.c                            |  91 +++++--
 pci.c                             | 334 +++++++++++++++++++++++--
 powerpc/include/kvm/kvm-arch.h    |   2 +-
 powerpc/ioport.c                  |   3 +-
 powerpc/spapr_pci.c               |   2 +-
 vfio/core.c                       |  22 +-
 vfio/pci.c                        | 233 +++++++++++++----
 virtio/9p.c                       |   9 +-
 virtio/balloon.c                  |  10 +-
 virtio/blk.c                      |  14 +-
 virtio/console.c                  |  11 +-
 virtio/core.c                     |   9 +-
 virtio/mmio.c                     |  13 +-
 virtio/net.c                      |  32 +--
 virtio/pci.c                      | 206 ++++++++++-----
 virtio/scsi.c                     |  14 +-
 x86/include/kvm/kvm-arch.h        |   2 +-
 x86/ioport.c                      |  66 +++--
 42 files changed, 1287 insertions(+), 796 deletions(-)
 delete mode 100644 hw/pci-shmem.c
 delete mode 100644 include/kvm/pci-shmem.h

-- 
2.20.1

