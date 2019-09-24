Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B11BC816
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfIXMpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:45:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfIXMpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:45:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29B7518C37B;
        Tue, 24 Sep 2019 12:45:04 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87B0D60852;
        Tue, 24 Sep 2019 12:44:50 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 0/8] Introduce the microvm machine type
Date:   Tue, 24 Sep 2019 14:44:25 +0200
Message-Id: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 24 Sep 2019 12:45:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Microvm is a machine type inspired by both NEMU and Firecracker, and
constructed after the machine model implemented by the latter.

It's main purpose is providing users a minimalist machine type free
from the burden of legacy compatibility, serving as a stepping stone
for future projects aiming at improving boot times, reducing the
attack surface and slimming down QEMU's footprint.

The microvm machine type supports the following devices:

 - ISA bus
 - i8259 PIC
 - LAPIC (implicit if using KVM)
 - IOAPIC (defaults to kernel_irqchip_split = true)
 - i8254 PIT
 - MC146818 RTC (optional)
 - kvmclock (if using KVM)
 - fw_cfg
 - One ISA serial port (optional)
 - Up to eight virtio-mmio devices (configured by the user)

It supports the following machine-specific options:

microvm.option-roms=bool (Set off to disable loading option ROMs)
microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)

By default, microvm uses qboot as its BIOS, to obtain better boot
times, but it's also compatible with SeaBIOS.

As no current FW is able to boot from a block device using virtio-mmio
as its transport, a microvm-based VM needs to be run using a host-side
kernel and, optionally, an initrd image.

This is an example of instantiating a microvm VM with a virtio-mmio
based console:

qemu-system-x86_64 -M microvm
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -chardev stdio,id=virtiocon0,server \
 -device virtio-serial-device \
 -device virtconsole,chardev=virtiocon0 \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

This is another example, this time using an ISA serial port, useful
for debugging purposes:

qemu-system-x86_64 -M microvm \
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "earlyprintk=ttyS0 console=ttyS0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -serial stdio \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

Finally, in this example a microvm VM is instantiated without RTC,
without an ISA serial port and without loading the option ROMs,
obtaining the smallest configuration:

qemu-system-x86_64 -M microvm,rtc=off,isa-serial=off,option-roms=off \
 -enable-kvm -cpu host -m 512m -smp 2 \
 -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
 -nodefaults -no-user-config -nographic \
 -chardev stdio,id=virtiocon0,server \
 -device virtio-serial-device \
 -device virtconsole,chardev=virtiocon0 \
 -drive id=test,file=test.img,format=raw,if=none \
 -device virtio-blk-device,drive=test \
 -netdev tap,id=tap0,script=no,downscript=no \
 -device virtio-net-device,netdev=tap0

---

Changelog
v4:
 - This is a complete rewrite of the whole patchset, with a focus on
   reusing as much existing code as possible to ease the maintenance burden
   and making the machine type as compatible as possible by default. As
   a result, the number of lines dedicated specifically to microvm is
   383 (code lines measured by "cloc") and, with the default
   configuration, it's now able to boot both PVH ELF images and
   bzImages with either SeaBIOS or qboot.

v3:
  - Add initrd support (thanks Stefano).

v2:
  - Drop "[PATCH 1/4] hw/i386: Factorize CPU routine".
  - Simplify machine definition (thanks Eduardo).
  - Remove use of unneeded NUMA-related callbacks (thanks Eduardo).
  - Add a patch to factorize PVH-related functions.
  - Replace use of Linux's Zero Page with PVH (thanks Maran and Paolo).
  
---
Sergio Lopez (8):
  hw/i386: Factorize PVH related functions
  hw/i386: Factorize e820 related functions
  hw/virtio: Factorize virtio-mmio headers
  hw/i386: split PCMachineState deriving X86MachineState from it
  fw_cfg: add "modify" functions for all types
  roms: add microvm-bios (qboot) as binary and git submodule
  docs/microvm.txt: document the new microvm machine type
  hw/i386: Introduce the microvm machine type

 .gitmodules                      |   3 +
 default-configs/i386-softmmu.mak |   1 +
 docs/microvm.txt                 |  78 +++
 hw/acpi/cpu_hotplug.c            |  10 +-
 hw/i386/Kconfig                  |   4 +
 hw/i386/Makefile.objs            |   4 +
 hw/i386/acpi-build.c             |  31 +-
 hw/i386/amd_iommu.c              |   4 +-
 hw/i386/e820.c                   |  99 ++++
 hw/i386/e820.h                   |  11 +
 hw/i386/intel_iommu.c            |   4 +-
 hw/i386/microvm.c                | 512 +++++++++++++++++
 hw/i386/pc.c                     | 960 +++----------------------------
 hw/i386/pc_piix.c                |  48 +-
 hw/i386/pc_q35.c                 |  38 +-
 hw/i386/pc_sysfw.c               |  60 +-
 hw/i386/pvh.c                    | 113 ++++
 hw/i386/pvh.h                    |  10 +
 hw/i386/x86.c                    | 788 +++++++++++++++++++++++++
 hw/intc/ioapic.c                 |   3 +-
 hw/nvram/fw_cfg.c                |  29 +
 hw/virtio/virtio-mmio.c          |  35 +-
 include/hw/i386/microvm.h        |  80 +++
 include/hw/i386/pc.h             |  40 +-
 include/hw/i386/x86.h            |  97 ++++
 include/hw/nvram/fw_cfg.h        |  42 ++
 include/hw/virtio/virtio-mmio.h  |  60 ++
 pc-bios/bios-microvm.bin         | Bin 0 -> 65536 bytes
 roms/Makefile                    |   6 +
 roms/qboot                       |   1 +
 target/i386/kvm.c                |   1 +
 31 files changed, 2102 insertions(+), 1070 deletions(-)
 create mode 100644 docs/microvm.txt
 create mode 100644 hw/i386/e820.c
 create mode 100644 hw/i386/e820.h
 create mode 100644 hw/i386/microvm.c
 create mode 100644 hw/i386/pvh.c
 create mode 100644 hw/i386/pvh.h
 create mode 100644 hw/i386/x86.c
 create mode 100644 include/hw/i386/microvm.h
 create mode 100644 include/hw/i386/x86.h
 create mode 100644 include/hw/virtio/virtio-mmio.h
 create mode 100755 pc-bios/bios-microvm.bin
 create mode 160000 roms/qboot

-- 
2.21.0

