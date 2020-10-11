Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6789B28A97C
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 20:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgJKSuZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 11 Oct 2020 14:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgJKSuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 14:50:24 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Sun, 11 Oct 2020 18:50:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: luoyonggang@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203477-28872-1OefpayFqW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203477

--- Comment #6 from Yonggang Luo (luoyonggang@gmail.com) ---
The command line I am using
```
/usr/bin/kvm -id 101 -name Win10-Video -chardev
socket,id=qmp,path=/var/run/qemu-server/101.qmp,server,nowait -mon
chardev=qmp,mode=control -chardev
socket,id=qmp-event,path=/var/run/qmeventd.sock,reconnect=5 -mon
chardev=qmp-event,mode=control -pidfile /var/run/qemu-server/101.pid -daemonize
-smbios type=1,uuid=0e1a8f04-2fcd-4e7b-a615-b5f60c17c244 -smp
16,sockets=1,cores=16,maxcpus=16 -nodefaults -boot
menu=on,strict=on,reboot-timeout=1000,splash=/usr/share/qemu-server/bootsplash.jpg
-vnc unix:/var/run/qemu-server/101.vnc,password -no-hpet -cpu
kvm64,enforce,hv_ipi,hv_relaxed,hv_reset,hv_runtime,hv_spinlocks=0x1fff,hv_stimer,hv_synic,hv_time,hv_vapic,hv_vpindex,+kvm_pv_eoi,+kvm_pv_unhalt,+lahf_lm,+sep
-m 16384 -readconfig /usr/share/qemu-server/pve-q35-4.0.cfg -device
vmgenid,guid=4d51db1b-14b4-48ee-a10e-87e12165dd90 -device
nec-usb-xhci,id=xhci,bus=pci.1,addr=0x1b -device
usb-tablet,id=tablet,bus=ehci.0,port=1 -device
usb-host,bus=xhci.0,hostbus=4,hostport=2,id=usb0 -device
qxl-vga,id=vga,bus=pcie.0,addr=0x1 -device
virtio-serial,id=spice,bus=pci.0,addr=0x9 -chardev
spicevmc,id=vdagent,name=vdagent -device
virtserialport,chardev=vdagent,name=com.redhat.spice.0 -spice
tls-port=61000,addr=127.0.0.1,tls-ciphers=HIGH,seamless-migration=on -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3 -iscsi
initiator-name=iqn.1993-08.org.debian:01:fbd3a8f979d -drive
file=/var/lib/vz/template/iso/virtio-win-0.1.189.iso,if=none,id=drive-ide0,media=cdrom,aio=threads
-device ide-cd,bus=ide.0,unit=0,drive=drive-ide0,id=ide0,bootindex=200 -drive
file=/var/lib/vz/template/iso/cn_windows_10_business_editions_version_2004_updated_sep_2020_x64_dvd_7134ba4b.iso,if=none,id=drive-ide2,media=cdrom,aio=threads
-device ide-cd,bus=ide.1,unit=0,drive=drive-ide2,id=ide2,bootindex=201 -drive
file=/dev/pve/vm-101-disk-0,if=none,id=drive-virtio0,format=raw,cache=none,aio=native,detect-zeroes=on
-device
virtio-blk-pci,drive=drive-virtio0,id=virtio0,bus=pci.0,addr=0xa,bootindex=100
-netdev
type=tap,id=net0,ifname=tap101i0,script=/var/lib/qemu-server/pve-bridge,downscript=/var/lib/qemu-server/pve-bridgedown,vhost=on
-device
virtio-net-pci,mac=AE:79:28:76:97:65,netdev=net0,bus=pci.0,addr=0x12,id=net0,bootindex=300
-rtc driftfix=slew,base=localtime -machine type=q35+pve0 -global
kvm-pit.lost_tick_policy=discard -cpu
host,enforce,hv_ipi,hv_relaxed,hv_reset,hv_runtime,hv_spinlocks=0x1fff,hv_stimer,hv_synic,hv_time,hv_vapic,hv_vpindex,+kvm_pv_eoi,+kvm_pv_unhalt,+lahf_lm,+sep,+svm,-hypervisor
```

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
