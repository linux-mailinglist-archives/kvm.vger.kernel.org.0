Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E3E1D3543
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgENPik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:40 -0400
Received: from foss.arm.com ([217.140.110.172]:39136 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgENPik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71B891FB;
        Thu, 14 May 2020 08:38:39 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B4E93F71E;
        Thu, 14 May 2020 08:38:38 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 00/12] Add reassignable BARs
Date:   Thu, 14 May 2020 16:38:17 +0100
Message-Id: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
it from trying to reassign the BARs. Let's make the BARs reassignable so we
can get rid of this band-aid.

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

Two important changes this iteration: the first 18 patches and patch 22
from v3 have been merged and I have dropped the last patch, the patch that
adds support for PCI Express 1.1 (hence the subject change). The CFI
patches have been merged and EDK2 can run right now under kvmtool with
virtio-mmio, and PCI Express breaks that. EDK2 doesn't have support for
legacy PCI, so when running under kvmtool, the PCI bus doesn't exist as far
as EDK2 is concerned. As soon as we add support for PCI Express, EDK2 will
run into the bug that I described in v3 [1]. I'll resent that patch along
with the fixes that make EDK2 work with PCI Express.

Like before, I have tested the patches on an x86_64 and arm64 machine:

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

I wrote a kvm-unit-tests test that stresses the MMIO emulation locking
scheme that I implemented by spawning 4 vcpus (the Seattle machine has 8
physical CPUs) that toggle memory, and another 4 vcpus that read from the
memory region described by a BAR. I ran this under valgrind, and no
deadlocks or use-after-free errors were detected.

I've also installed an official debian iso in a virtual machine by using
the EDK2 binary that Ard posted [2] and virtio-mmio.

2. Ryzen 3900x + Gigabyte x570 Aorus Master (bios F10). Tried PCI passthrough
with a Realtek 8168 and Intel 82574L Gigabit Ethernet cards at the same time,
plus running with --sdl enabled to test VESA device emulation at the same time.
I also managed to get the guest to do bar reassignment for one device by using
the kernel command line parameter pci.resource_alignment=16@pci:10ec:8168.

Changes in v4:
* Patches 1-18 and 22 have been merged.
* Gathered Reviewed-by tags. Thank you!
* Patch #1 (was #19): added comments explaining why refcount starts at 0
  and we use a separate variable for deletion; minor changes to
  ioport__unregister to make it more similar to kvm__deregister_mmio.
* Patch #6 (was #25): assert that size is less than or equal to 4 to
  prevent any stack overruns.
* Patch #7 (was #26): rewrote it, now we prohibit the user from requesting
  more than one of --gtk, --vnc and --sdl.
* Patch #8 (was #27): fixed coding style issues, added a comment explaining
  the the MSIX table and PBA structure can share the same BAR and removed
  the assert from pci__register_bar_regions.
* Patch #10 (was #29): removed unused parameter from the functions that
  activate/deactivate BAR emulation and consolidated them into one
  function; added a comment summarizing the algorithm for BAR reassignment.
* Dropped patch #13 (was #32) for the reasons explained above.

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

[1] https://www.spinics.net/lists/kvm/msg211272.html
[2] https://www.spinics.net/lists/kvm/msg213842.html


Alexandru Elisei (11):
  ioport: mmio: Use a mutex and reference counting for locking
  pci: Add helpers for BAR values and memory/IO space access
  virtio/pci: Get emulated region address from BARs
  vfio: Reserve ioports when configuring the BAR
  pci: Limit configuration transaction size to 32 bits
  vfio/pci: Don't write configuration value twice
  Don't allow more than one framebuffers
  pci: Implement callbacks for toggling BAR emulation
  pci: Toggle BAR I/O and memory space emulation
  pci: Implement reassignable BARs
  vfio: Trap MMIO access to BAR addresses which aren't page aligned

Julien Thierry (1):
  arm/fdt: Remove 'linux,pci-probe-only' property

 arm/fdt.c                     |   1 -
 builtin-run.c                 |   5 +
 hw/vesa.c                     |  72 +++++---
 include/kvm/ioport.h          |   2 +
 include/kvm/pci.h             |  85 ++++++++-
 include/kvm/rbtree-interval.h |   4 +-
 include/kvm/virtio-pci.h      |   3 -
 ioport.c                      |  85 ++++++---
 mmio.c                        | 107 +++++++++---
 pci.c                         | 320 ++++++++++++++++++++++++++++++----
 powerpc/spapr_pci.c           |   2 +-
 vfio/core.c                   |  18 +-
 vfio/pci.c                    | 132 ++++++++++++--
 virtio/pci.c                  | 158 ++++++++++++-----
 14 files changed, 794 insertions(+), 200 deletions(-)

-- 
2.26.2

