Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6F81F73B6
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 08:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgFLGPZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 12 Jun 2020 02:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgFLGPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 02:15:25 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 200101] random freeze under load
Date:   Fri, 12 Jun 2020 06:15:24 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: filakhtov@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-200101-28872-Pc7HUPDomr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200101-28872@https.bugzilla.kernel.org/>
References: <bug-200101-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200101

--- Comment #3 from Garry Filakhtov (filakhtov@gmail.com) ---
Struggling with the same issue. Also coming from Gentoo 👋 lekto!

This was long coming, I just needed a lot of time to ensure there is no
hardware issues or any kind of misconfiguration on my end, before reporting
here.

I have Intel X299 platform and using it to run Windows 10 virtual machine with
PCI pass-through. I use NVMe SSD (Samsung EVO 970 Plus), PCIe USB 3.0 (StarTech
PEXUSB3S3GE) adapter and GPU (nVidia GeForce 1650) pass-through to get best
possible performance and isolation from host OS.

I have been running on 4.19 LTS kernel without any issues, but 5.4 LTS got
promoted to stable for AMD64 architecture and I have switched. After doing so,
I have started experiencing random guest freezes, happening anywhere
immediately after boot all the way up to multiple hours of usage without a
freeze. When the freeze occurs, guest machine will completely stop responding
to input, ping, etc. Host machine works fine and I can connect to qemu socket
without any problems. I am running on QEMU 4.2.0.

Freeze can continue anywhere from 1 minute up to 5 minutes, and eventually VM
is recovering and working properly afterwards, up until the next freeze.
Inspecting dmesg or journalctl on the host machine reveals no any relevant
entries.

Problem appears regardless of the type of workflow performed. It can just
freeze on the desktop, in the web browser or in the GPU benchmark. I was
playing music on the system and just before freezing, sound starts to
drop/glitch and then goes completely silent.

Windows event viewer is of course as useful as a fridge on the North pole
before the climate change :D (pardon my pun), meaning no entries are produced
during the freeze, and there is actually a gap between written entries for
however long the freeze took.

So far, I have tested a good variety of Kernel versions:

  [1]   linux-4.19.120-gentoo <- works fine
  [2]   linux-4.20.17-gentoo <- works fine
  [3]   linux-5.0.0-gentoo <- randomly freezes as described
  [4]   linux-5.0.21-gentoo <- randomly freezes as described
  [5]   linux-5.1.21-gentoo <- can't even boot guest, getting freeze during
very early boot
  [6]   linux-5.2.20-gentoo <- qemu won't even start, complaining about KVM
suberror 1
  [7]   linux-5.3.18-gentoo <- randomly freezes as described
  [8]   linux-5.4.38-gentoo <- randomly freezes as described

My takeaway here is that something went wrong in the 5.0.0 and was never fixed
since.

I have not yet tried to bisect the GIT source, but might give it a go, time
permitting.

I am using naked qemu-system-x86_64 command, to rule out virt-manager problems.
PCIe devices are attached via separate pcie-root-port devices. Using OVMF UEFI
(sys-firmware/edk2-ovmf-201905) for booting with Secure Boot enabled (disabling
Secure Boot makes no difference). I have also did clean Windows 10 install to
rule out any issues with the guest OS itself, but problem persisted. I have
tried using Windows-provided GPU drivers as well as the latest from nVidia.
Using "host" CPU for qemu.

There is a similar problem reported on Reddit too, the solution was to
downgrade:
https://www.reddit.com/r/VFIO/comments/b1xx0g/windows_10_qemukvm_freezes_after_50x_kernel_update/

Host hardware:
Motherboard: ASUS WS X299 SAGE
CPU: Intel i9-9940x
Guest GPU: nVidia GTX 1650
Host GPU: AMD Radeon PRO WX 3100
RAM: 64Gb (4x16Gb) DDR4 2666MHz
SSD: Samsung 970 EVO Plus
PCIe adapter: StarTech PEXUSB3S3GE 3xUSB3.0 + USB Realtek Gigabit network combo
adapter
Guest OS: Windows 10 Professional (1909)
QEMU version: 4.2.0

qemu options used:
-name Microsoft Windows 10 Professional
-M q35,kernel_irqchip=on,vmport=off,accel=kvm,mem-merge=off
-nodefaults
-display none
-vga none
-net none
-nographic
-monitor unix:/run/qemu/win10.sock,server,nowait
-pidfile /run/qemu/win10.pid
-cpu host,kvm=off
-smp sockets=1,cores=6,threads=2
-m size=16G
-drive
if=pflash,format=raw,readonly,file=/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd
-drive if=pflash,format=raw,file=/usr/share/edk2-ovmf/OVMF_VARS.secboot.fd
-rtc base=localtime
-device pcie-root-port,id=port0.0,bus=pcie.0,chassis=0,slot=0,addr=1.0
-device vfio-pci,host=19:0.0,multifunction=on,bus=port0.0,addr=0.0
-device vfio-pci,host=19:0.1,bus=pcie.0,bus=port0.0,addr=0.1
-device pcie-root-port,id=port0.2,bus=pcie.0,chassis=0,slot=2
-device vfio-pci,host=1a:0.0,bus=port0.2
-device pcie-root-port,id=port0.5,bus=pcie.0,chassis=0,slot=5
-device vfio-pci,host=b3:0.0,bus=port0.5

I will try lekto's suggestion and report back any progress.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
