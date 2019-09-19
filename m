Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C85B71CE
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 05:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbfISDLN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 18 Sep 2019 23:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbfISDLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 23:11:13 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Thu, 19 Sep 2019 03:11:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: edufrazao@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203477-28872-j5x1ddChGR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203477

--- Comment #3 from Eduardo Frazão (edufrazao@gmail.com) ---
I have the exact same errors, but here my Windows 10 Pro L1 freezes few seconds
start. I'm trying to use Windows SandBox.

Ryzen 3700x // Gigabyte X570 Aorus Elite
Kernel 5.3.0.

I have AMD SVM enabled in BIOS and IOMMU disabled.



beast ~ # grep -H '' /sys/module/kvm_amd/parameters/*
/sys/module/kvm_amd/parameters/avic:0
/sys/module/kvm_amd/parameters/dump_invalid_vmcb:N
/sys/module/kvm_amd/parameters/nested:1
/sys/module/kvm_amd/parameters/npt:1
/sys/module/kvm_amd/parameters/nrips:1
/sys/module/kvm_amd/parameters/pause_filter_count:3000
/sys/module/kvm_amd/parameters/pause_filter_count_grow:2
/sys/module/kvm_amd/parameters/pause_filter_count_max:65535
/sys/module/kvm_amd/parameters/pause_filter_count_shrink:0
/sys/module/kvm_amd/parameters/pause_filter_thresh:128
/sys/module/kvm_amd/parameters/sev:0
/sys/module/kvm_amd/parameters/vgif:1
/sys/module/kvm_amd/parameters/vls:1

beast ~ # grep -H '' /sys/module/kvm/parameters/*
/sys/module/kvm/parameters/enable_vmware_backdoor:N
/sys/module/kvm/parameters/force_emulation_prefix:N
/sys/module/kvm/parameters/halt_poll_ns:200000
/sys/module/kvm/parameters/halt_poll_ns_grow:2
/sys/module/kvm/parameters/halt_poll_ns_grow_start:10000
/sys/module/kvm/parameters/halt_poll_ns_shrink:0
/sys/module/kvm/parameters/ignore_msrs:Y
/sys/module/kvm/parameters/kvmclock_periodic_sync:Y
/sys/module/kvm/parameters/lapic_timer_advance_ns:-1
/sys/module/kvm/parameters/min_timer_period_us:200
/sys/module/kvm/parameters/pi_inject_timer:0
/sys/module/kvm/parameters/report_ignored_msrs:Y
/sys/module/kvm/parameters/tsc_tolerance_ppm:250
/sys/module/kvm/parameters/vector_hashing:Y


QEMU Command line:
usr/bin/qemu-system-x86_64 -name guest=Win10Devel,debug-threads=on -S -object
secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-Win10Devel/master-key.aes
-machine pc-q35-4.0.1,accel=kvm,usb=off,dump-guest-core=off -cpu
EPYC-IBPB,svm=on,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff -m 6072
-overcommit mem-lock=off -smp 4,sockets=1,cores=2,threads=2 -uuid
466412cf-36da-4297-ba3e-6f7e7b0b0b5d -no-user-config -nodefaults -chardev
socket,id=charmonitor,fd=22,server,nowait -mon
chardev=charmonitor,id=monitor,mode=control -rtc base=localtime,driftfix=slew
-global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global
ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on -device
pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2
-device pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1
-device pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2
-device pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3
-device pcie-root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4
-device pcie-root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5
-device qemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0 -device
virtio-serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0 -drive
file=/mnt/storage/Eduardo/VM/KVM/win10_desenvolvimento.qcow2,format=qcow2,if=none,id=drive-virtio-disk0,cache=none,aio=native
-device
virtio-blk-pci,scsi=off,bus=pci.4,addr=0x0,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=2,write-cache=on
-drive if=none,id=drive-sata0-0-1,readonly=on -device
ide-cd,bus=ide.1,drive=drive-sata0-0-1,id=sata0-0-1,bootindex=1 -drive
if=none,id=drive-fdc0-0-0 -device isa-fdc,driveA=drive-fdc0-0-0 -netdev
tap,fd=24,id=hostnet0,vhost=on,vhostfd=25 -device
virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:00:2f:ca,bus=pci.1,addr=0x0
-chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0
-chardev spicevmc,id=charchannel0,name=vdagent -device
virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=com.redhat.spice.0
-chardev socket,id=charchannel1,fd=26,server,nowait -device
virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,id=channel1,name=org.qemu.guest_agent.0
-chardev spiceport,id=charchannel2,name=org.spice-space.webdav.0 -device
virtserialport,bus=virtio-serial0.0,nr=3,chardev=charchannel2,id=channel2,name=org.spice-space.webdav.0
-device usb-tablet,id=input0,bus=usb.0,port=1 -spice
port=5900,addr=127.0.0.1,disable-ticketing,image-compression=off,seamless-migration=on
-device
qxl-vga,id=video0,ram_size=134217728,vram_size=134217728,vram64_size_mb=0,vgamem_mb=64,max_outputs=1,bus=pcie.0,addr=0x1
-device virtio-balloon-pci,id=balloon0,bus=pci.5,addr=0x0 -sandbox
on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -msg
timestamp=on

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
