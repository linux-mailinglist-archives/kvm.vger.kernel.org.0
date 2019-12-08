Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0731162DD
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2019 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfLHPkR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 8 Dec 2019 10:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfLHPkR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Dec 2019 10:40:17 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205801] ignore_msrs =Y and report_ignored_msrs = N not working
Date:   Sun, 08 Dec 2019 15:40:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: harliff@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205801-28872-e7MZonzFnf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205801-28872@https.bugzilla.kernel.org/>
References: <bug-205801-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205801

--- Comment #1 from Ilya Yakushin (harliff@gmail.com) ---
The VM runned as:

/usr/bin/kvm -id 302 -name <skipped> -chardev
socket,id=qmp,path=/var/run/qemu-server/302.qmp,server,nowait -mon
chardev=qmp,mode=control -chardev
socket,id=qmp-event,path=/var/run/qmeventd.sock,reconnect=5 -mon
chardev=qmp-event,mode=control -pidfile /var/run/qemu-server/302.pid -daemonize
-smbios type=1,uuid=9b793bd8-30b0-400d-8196-6264858d3300 -smp
1,sockets=1,cores=4,maxcpus=4 -device
kvm64-x86_64-cpu,id=cpu2,socket-id=0,core-id=1,thread-id=0 -device
kvm64-x86_64-cpu,id=cpu3,socket-id=0,core-id=2,thread-id=0 -device
kvm64-x86_64-cpu,id=cpu4,socket-id=0,core-id=3,thread-id=0 -nodefaults -boot
menu=on,strict=on,reboot-timeout=1000,splash=/usr/share/qemu-server/bootsplash.jpg
-vnc unix:/var/run/qemu-server/302.vnc,password -no-hpet -cpu
kvm64,+lahf_lm,+sep,+kvm_pv_unhalt,+kvm_pv_eoi,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_reset,hv_vpindex,hv_runtime,hv_relaxed,hv_synic,hv_stimer,hv_tlbflush,hv_ipi,enforce
-m size=1024,slots=255,maxmem=4194304M -object
memory-backend-ram,id=ram-node0,size=1024M -numa
node,nodeid=0,cpus=0-3,memdev=ram-node0 -object
memory-backend-ram,id=mem-dimm0,size=512M -device
pc-dimm,id=dimm0,memdev=mem-dimm0,node=0 -object
memory-backend-ram,id=mem-dimm1,size=512M -device
pc-dimm,id=dimm1,memdev=mem-dimm1,node=0 -object
memory-backend-ram,id=mem-dimm2,size=512M -device
pc-dimm,id=dimm2,memdev=mem-dimm2,node=0 -object
memory-backend-ram,id=mem-dimm3,size=512M -device
pc-dimm,id=dimm3,memdev=mem-dimm3,node=0 -object
memory-backend-ram,id=mem-dimm4,size=512M -device
pc-dimm,id=dimm4,memdev=mem-dimm4,node=0 -object
memory-backend-ram,id=mem-dimm5,size=512M -device
pc-dimm,id=dimm5,memdev=mem-dimm5,node=0 -object
memory-backend-ram,id=mem-dimm6,size=512M -device
pc-dimm,id=dimm6,memdev=mem-dimm6,node=0 -object
memory-backend-ram,id=mem-dimm7,size=512M -device
pc-dimm,id=dimm7,memdev=mem-dimm7,node=0 -object
memory-backend-ram,id=mem-dimm8,size=512M -device
pc-dimm,id=dimm8,memdev=mem-dimm8,node=0 -object
memory-backend-ram,id=mem-dimm9,size=512M -device
pc-dimm,id=dimm9,memdev=mem-dimm9,node=0 -object
memory-backend-ram,id=mem-dimm10,size=512M -device
pc-dimm,id=dimm10,memdev=mem-dimm10,node=0 -object
memory-backend-ram,id=mem-dimm11,size=512M -device
pc-dimm,id=dimm11,memdev=mem-dimm11,node=0 -object
memory-backend-ram,id=mem-dimm12,size=512M -device
pc-dimm,id=dimm12,memdev=mem-dimm12,node=0 -object
memory-backend-ram,id=mem-dimm13,size=512M -device
pc-dimm,id=dimm13,memdev=mem-dimm13,node=0 -object
memory-backend-ram,id=mem-dimm14,size=512M -device
pc-dimm,id=dimm14,memdev=mem-dimm14,node=0 -device
pci-bridge,id=pci.2,chassis_nr=2,bus=pci.0,addr=0x1f -device
pci-bridge,id=pci.1,chassis_nr=1,bus=pci.0,addr=0x1e -device
piix3-usb-uhci,id=uhci,bus=pci.0,addr=0x1.0x2 -device
usb-tablet,id=tablet,bus=uhci.0,port=1 -device VGA,id=vga,bus=pci.0,addr=0x2
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3 -iscsi
initiator-name=iqn.1993-08.org.debian:01:82e1b7bc30 -device
virtio-scsi-pci,id=scsihw0,bus=pci.0,addr=0x5 -drive
file=/dev/zvol/fastpool/vm/vm-302-disk-0,if=none,id=drive-scsi0,format=raw,cache=none,aio=native,detect-zeroes=on
-device
scsi-hd,bus=scsihw0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0,id=scsi0,bootindex=100
-netdev
type=tap,id=net0,ifname=tap302i0,script=/var/lib/qemu-server/pve-bridge,downscript=/var/lib/qemu-server/pve-bridgedown,vhost=on
-device
virtio-net-pci,mac=F6:8B:2F:03:9F:2A,netdev=net0,bus=pci.0,addr=0x12,id=net0,bootindex=300
-rtc driftfix=slew,base=localtime -machine type=pc -global
kvm-pit.lost_tick_policy=discard

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
