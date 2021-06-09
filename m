Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958D63A1CD8
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFISja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:39:30 -0400
Received: from foss.arm.com ([217.140.110.172]:39778 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhFISj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:39:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97C67D6E;
        Wed,  9 Jun 2021 11:37:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78BC03F719;
        Wed,  9 Jun 2021 11:37:33 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH kvmtool 0/4] arm/arm64: PCI Express 1.1 support
Date:   Wed,  9 Jun 2021 19:38:08 +0100
Message-Id: <20210609183812.29596-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to add support for PCI Express 1.1. It is based on the
last patch [0] of the reassignable BAR series. The patch was discarded at
the time because there was no easy solution to solve the overlap between
the UART address and kvmtool's PCI I/O region, which made EDK2 and/or a
guest compiled with 64k pages very unhappy [1]. This is not the case
anymore, as the UART has been moved to address 0x1000000 in commit
45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher addresses").

The series has also been tested with a work-in-progress version of EDK2
which supports PCI Express when running under kvmtool. Those patches will
be posted soon. The end result is that someone will be able to download an
official iso from the debian website and install it in a kvmtool VM.

The first two patches in the series are small and hopefully straightford
cleanups for stuff that I discovered when playing with kvmtool.

The third patch implements the PCI Express support only for the arm and
arm64 architectures. The reason for that is that I don't know how to do it
for x86, powerpc and mips (and for the last two I don't even have machines
to test it).

The last patch implements a fix for a Realtek RTL8168 NIC, where the Linux
drivers falls back to a device specific method of initialization if the
device is not PCI Express capable (doesn't have the PCI Express
Capability) [2].

Testing
=======

Warning, wall of text. Unless specified, the guest kernel was built from
tag v5.12.

On a Ryzen 3900x:
-----------------

amd64 architecture and no PCIE support, making sure no regressions are
introduced.

1. Direct kernel boot + Debian 10 disk with SDL, to exercise the emulated
VESA device.  Was able to login using the display manager and
virtio-{net,blk} were working correctly.

2. Direct kernel boot + Debian 10 disk with SDL + Realtek RTL8168 + Intel
82574L PCIE NIC, both assigned to the VM. Assigning an ip address to the
Realtek NIC fails with the message: "No native access to PCI extended
config space, falling back to CSI", which makes sense since kvmtool is
emulating legacy PCI 3.0 for the amd64 architecture. Other than that,
everything works as expected.

On odroid-c4:
-------------

1. Debian 10 disk + upstream EDK2 built from commit 1f515342d8d8
("DynamicTablesPkg: Use AML_NAME_SEG_SIZE define"), **without** --force-pci
(so using virtio-mmio). Kernel compiled with 4k, 16k and 64k pages. This
was done to make sure there are no regressions.

2. Direct kernel boot + Debian 10 disk, with --force-pci. Tried 3 versions
of the kernel, compiled with 4k, 16k and 64k pagesize. Got the warning:
"TCP: enp0s0: Driver has suspect GRO implementation, TCP performance may be
compromised." I suspect it is because of kvmtool legacy version of virtio.
This was further confirmed by running the same kernel with kvmtool built
from master, with and without --force-pci, the warning was still there.

3. Debian 10 disk + a work-in-progress version of EDK2 which enables PCIE
support for kvmtool, with --force-pci. The kernel was booted via Debian
grub, and same as above, I tried with kernels compiled with 4k, 16k and 64k
page sizes.

On AMD Seattle:
---------------

1. Using the EDK2 image and the passthrough Realtek RTL8168 NIC as the
network interface, I was able to use a vanilla netinstall iso from the
debian website [3] and install debian in a virtual machine. Woohoo!

One gotcha during installation: because kvmtool doesn't emulate a SCSI
CD-ROM, you need to manually specify the virtio disk for the installation
iso. At the 'Detect and mount CD-ROM' prompt, choose No when asked to load
CD-ROM drivers from removable media, Yes to manually select a CD-ROM module
and device, none when choosing the CD-ROM module (it's a virtio disk), then
the device file for accessing the CD-ROM is /dev/vda (only if the iso file
is the first --disk kvmtool parameter, otherwise /dev/vdb if it's the
second, and so on).

2. Realtek RTL8168, direct kernel boot and EDK2 boot with Debian 10 disk,
--force-pci, kernel compiled with 4k and 64k pages (Seattle doesn't support
16k pages) for both direct kernel boot and EDK2 boot.

3. Intel 82574L NIC, direct kernel boot and EDK2 boot with Debian 10 disk,
--force-pci, kernel compiled with 4k and 64k pages for both direct boot and
EDK2 boot.

4. AMD FirePro W2100 VGA + HDMI audio, both assigned to a VM, direct kernel
boot and EDK2 boot with Debian 10 disk, --force-pci, kernel compiled with
4k and 64k pages for both direct boot and EDK2 boot.

For this test, I switched the guest kernel to v5.10 because with v5.11 and
v5.12 I was getting this kernel panic caused by a NULL pointer deference:

[..]
[    0.943927] [drm] radeon kernel modesetting enabled.
[    0.945050] [drm] initializing kernel modesetting (OLAND 0x1002:0x6608 0x1002:0x2120 0x00).
[    0.946313] radeon 0000:00:00.0: BAR 6: can't assign [??? 0x00000000 flags 0x20000000] (bogus alignment)
[    0.947736] radeon 0000:00:00.0: BAR 6: can't assign [??? 0x00000000 flags 0x20000000] (bogus alignment)
[    0.949193] [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
[    0.950151] radeon 0000:00:00.0: Fatal error during GPU init
[    0.950990] [drm] radeon: finishing device.
[    0.951633] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
[    0.952936] Mem abort info:
[    0.953369]   ESR = 0x96000004
[    0.953838]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.954635]   SET = 0, FnV = 0
[    0.955100]   EA = 0, S1PTW = 0
[    0.955590] Data abort info:
[    0.956033]   ISV = 0, ISS = 0x00000004
[    0.956608]   CM = 0, WnR = 0
[    0.957099] [0000000000000020] user address but active_mm is swapper
[    0.958051] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    0.958881] Modules linked in:
[    0.959356] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.11.0 #13
[    0.960268] Hardware name: linux,dummy-virt (DT)
[    0.960970] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[    0.962013] pc : ttm_resource_manager_evict_all+0x64/0x1f0
[    0.962972] lr : ttm_resource_manager_evict_all+0x5c/0x1f0
[    0.963931] sp : ffff80001212ba00
[    0.964517] x29: ffff80001212ba00 x28: 0000000000000000 
[    0.965448] x27: ffff8000118004e0 x26: ffff8000120cd000 
[    0.966371] x25: 0000000000000000 x24: ffff000080c946e8 
[    0.967296] x23: 0000000000000020 x22: 0000000000000000 
[    0.968227] x21: 0000000000000000 x20: ffff8000120cdb90 
[    0.969152] x19: ffff000080c94000 x18: ffffffffffffffff 
[    0.970076] x17: 0000000000000000 x16: 0000000000000001 
[    0.970999] x15: ffff80009212b787 x14: 0000000000000006 
[    0.971928] x13: ffff800011de2368 x12: 0000000000000264 
[    0.972852] x11: 00000000000000cc x10: ffff800011de2368 
[    0.973780] x9 : ffff800011de2368 x8 : 00000000ffffefff 
[    0.974701] x7 : ffff800011e3a368 x6 : ffff800011e3a368 
[    0.975637] x5 : 0000000000000000 x4 : 0000000000000000 
[    0.976559] x3 : ffff8000120cdb90 x2 : 0000000000000001 
[    0.977483] x1 : 0000000000000000 x0 : 0000000000000000 
[    0.978410] Call trace:
[    0.978851]  ttm_resource_manager_evict_all+0x64/0x1f0
[    0.979759]  radeon_bo_evict_vram+0x1c/0x30
[    0.980494]  radeon_device_fini+0x34/0xe8
[    0.981209]  radeon_driver_unload_kms+0x48/0x90
[    0.982000]  radeon_driver_load_kms+0x124/0x174
[    0.982792]  drm_dev_register+0xe0/0x210
[    0.983486]  radeon_pci_probe+0x120/0x1bc
[    0.984180]  local_pci_probe+0x40/0xac
[    0.984843]  pci_device_probe+0x114/0x1b0
[    0.985548]  really_probe+0xe4/0x4c0
[    0.986181]  driver_probe_device+0x58/0xc0
[    0.986902]  device_driver_attach+0xc0/0xcc
[    0.987642]  __driver_attach+0x84/0x124
[    0.988317]  bus_for_each_dev+0x70/0xd0
[    0.988996]  driver_attach+0x24/0x30
[    0.989627]  bus_add_driver+0x104/0x1ec
[    0.990300]  driver_register+0x78/0x130
[    0.990974]  __pci_register_driver+0x48/0x54
[    0.991730]  radeon_module_init+0x54/0x64
[    0.992438]  do_one_initcall+0x50/0x1b0
[    0.993115]  kernel_init_freeable+0x1d4/0x23c
[    0.993880]  kernel_init+0x14/0x118
[    0.994496]  ret_from_fork+0x10/0x34
[    0.995132] Code: f90033ff 9420650e d37c7f36 8b1602b6 (f94012c0) 
[    0.996201] ---[ end trace 88eed6171e8cb9bc ]---
[    0.997011] note: swapper/0[1] exited with preempt_count 1
[    0.997840] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    0.998984] SMP: stopping secondary CPUs
[    0.999605] Kernel Offset: disabled
[    1.000137] CPU features: 0x00240022,61006082
[    1.000793] Memory Limit: none
[    1.001330] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

This is how dmesg looks like with v5.10, v5.8 and v5.6:

[..]
[    0.972061] [drm] radeon kernel modesetting enabled.
[    0.973162] [drm] initializing kernel modesetting (OLAND 0x1002:0x6608 0x1002:0x2120 0x00).
[    0.974426] radeon 0000:00:00.0: BAR 6: can't assign [??? 0x00000000 flags 0x20000000] (bogus alignment)
[    0.976037] radeon 0000:00:00.0: BAR 6: can't assign [??? 0x00000000 flags 0x20000000] (bogus alignment)
[    0.977435] [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
[    0.978381] radeon 0000:00:00.0: Fatal error during GPU init
[    0.979341] [drm] radeon: finishing device.
[    0.979963] [TTM] Memory type 2 has not been initialized
[    0.988250] radeon: probe of 0000:00:00.0 failed with error -22
[    0.989282] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    0.993326] loop: module loaded
[..]

In my opinion, this is an upstream bug caused by incorrect clean up when
probing fails. I plan to see if I can reproduce it on my x86 machine (to
make it easier to other people to reproduce it) and then report it
upstream.

Note that I used the radeon driver instead of amdgpu because this is the
recommended driver [4] for the GCN1 architecture.

5. NVIDIA Quadro P400 VGA + HDMI audio, both assigned to a VM, direct kernel
boot and EDK2 boot with Debian 10 disk, --force-pci, kernel compiled with
4k and 64k pages for both direct boot and EDK2 boot.

Nouveau seems to work as expected (it binds to the GPU). but during driver
initialization it looks like the system hangs for 30s-1m. My guess is that
something times out in the driver due to missing emulation in kvmtool:

[..]
[    0.335506] [drm] radeon kernel modesetting enabled.
[    0.336369] nouveau 0000:00:00.0: enabling device (0000 -> 0003)
[    0.359468] nouveau 0000:00:00.0: NVIDIA GP107 (137000a1)
[    0.505066] nouveau 0000:00:00.0: bios: version 86.07.6b.00.01
              <---- hangs here
[  123.867379] nouveau 0000:00:00.0: acr: firmware unavailable
[  123.868337] nouveau 0000:00:00.0: pmu: firmware unavailable
[  123.869488] nouveau 0000:00:00.0: gr: firmware unavailable
[  123.870506] nouveau 0000:00:00.0: sec2: firmware unavailable
[  123.928149] nouveau 0000:00:00.0: fb: 2048 MiB GDDR5
[  123.963159] [TTM] Zone  kernel: Available graphics memory: 8313888 KiB
[  123.964823] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB
[  123.966172] nouveau 0000:00:00.0: DRM: VRAM: 2048 MiB
[  123.967101] nouveau 0000:00:00.0: DRM: GART: 536870912 MiB
[  123.968258] nouveau 0000:00:00.0: DRM: BIT table 'A' not found
[  123.969403] nouveau 0000:00:00.0: DRM: BIT table 'L' not found
[  123.970498] nouveau 0000:00:00.0: DRM: TMDS table version 2.0
[  123.971688] nouveau 0000:00:00.0: DRM: DCB version 4.1
[  123.972639] nouveau 0000:00:00.0: DRM: DCB outp 00: 01800f56 04600020
[  123.973820] nouveau 0000:00:00.0: DRM: DCB outp 01: 01000f52 04620020
[  123.975083] nouveau 0000:00:00.0: DRM: DCB outp 02: 01811f46 04600010
[  123.976500] nouveau 0000:00:00.0: DRM: DCB outp 03: 01011f42 04620010
[  123.977681] nouveau 0000:00:00.0: DRM: DCB outp 04: 02822f76 04600020
[  123.978955] nouveau 0000:00:00.0: DRM: DCB outp 05: 02022f72 00020020
[  123.980309] nouveau 0000:00:00.0: DRM: DCB conn 00: 00002046
[  123.981352] nouveau 0000:00:00.0: DRM: DCB conn 01: 00001146
[  123.982379] nouveau 0000:00:00.0: DRM: DCB conn 02: 00020246
[  123.984507] nouveau 0000:00:00.0: DRM: failed to create kernel channel, -22
[  123.986661] nouveau 0000:00:00.0: DRM: MM: using COPY for buffer copies
[  124.291297] nouveau 0000:00:00.0: [drm] Cannot find any crtc or sizes
[  124.292839] [drm] Initialized nouveau 1.3.1 20120801 for 0000:00:00.0 on minor 0
[..]

6. Crucial MX500 SSD connected to a generic PCIE to sata adapter assigned
to the VM, direct kernel boot and EDK2 boot with Debian 10 disk,
--force-pci, 4k and 64k pages kernel for both direct kernel and UEFI boot.

This was weird. On the host, the PCIE adapter worked just fine with kernel
v5.8, but on v5.12 the host was not able to initialize it:

[    2.891697] ata2: SATA link down (SStatus 0 SControl 300)
[    3.211695] ata3: SATA link down (SStatus 0 SControl 300)
[    3.531699] ata4: SATA link down (SStatus 0 SControl 300)
[    3.851694] ata5: SATA link down (SStatus 0 SControl 300)
[    4.141559] ata9: SATA link down (SStatus 0 SControl 0)
[    4.171691] ata6: SATA link down (SStatus 0 SControl 300)
[    4.491695] ata7: SATA link down (SStatus 0 SControl 300)
[    4.811693] ata8: SATA link down (SStatus 0 SControl 300)
[    6.973559] arm-smmu e0a00000.smmu: Unhandled context fault: fsr=0x2, iova=0x8002420000, fsynr=0x181, cbfrsynra=0x100, cb=0
[    6.983615] ata10: softreset failed (SRST command error)
[    6.989992] ata10: reset failed (errno=-5), retrying in 8 secs
[   17.173560] arm-smmu e0a00000.smmu: Unhandled context fault: fsr=0x2, iova=0x8002420000, fsynr=0x181, cbfrsynra=0x100, cb=0
[   17.183618] ata10: softreset failed (SRST command error)
[   17.189990] ata10: reset failed (errno=-5), retrying in 8 secs
[   27.413557] arm-smmu e0a00000.smmu: Unhandled context fault: fsr=0x2, iova=0x8002420000, fsynr=0x181, cbfrsynra=0x100, cb=0
[   27.423615] ata10: softreset failed (SRST command error)
[   27.429986] ata10: reset failed (errno=-5), retrying in 33 secs
[   60.837548] ata10: limiting SATA link speed to 1.5 Gbps
[   63.001557] arm-smmu e0a00000.smmu: Unhandled context fault: fsr=0x2, iova=0x8002420000, fsynr=0x181, cbfrsynra=0x100, cb=0
[   63.011615] ata10: softreset failed (SRST command error)
[   63.017988] ata10: reset failed, giving up

Assigning it to a VM worked though after the host running Linux v5.8
unitializes the adapter, so I'm going to consider this a pass. After a few
more tests, I was able to trigger the same error on v5.8. On v5.12
initialization has failed every time (so far, at least).

[0] https://lore.kernel.org/kvm/20200326152438.6218-1-alexandru.elisei@arm.com/T/#m835c93ef1dc7c539b4cdda85aee23210d494ea49
[1] https://lore.kernel.org/kvm/20200326152438.6218-1-alexandru.elisei@arm.com/
[2] https://www.spinics.net/lists/kvm/msg245607.html
[3] https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-10.9.0-arm64-netinst.iso
[4] https://wiki.archlinux.org/title/Xorg#AMD

Alexandru Elisei (4):
  Move fdt_irq_fn typedef to fdt.h
  arm/fdt.c: Warn if MMIO device doesn't provide a node generator
  arm/arm64: Add PCI Express 1.1 support
  arm/arm64: vfio: Add PCI Express Capability Structure

 arm/fdt.c                         |  7 ++-
 arm/include/arm-common/kvm-arch.h |  5 ++-
 arm/pci.c                         |  2 +-
 hw/rtc.c                          |  1 +
 include/kvm/fdt.h                 |  2 +
 include/kvm/kvm.h                 |  1 -
 include/kvm/pci.h                 | 75 ++++++++++++++++++++++++++++---
 pci.c                             |  5 ++-
 vfio/pci.c                        | 39 ++++++++++++----
 9 files changed, 116 insertions(+), 21 deletions(-)

-- 
2.32.0

