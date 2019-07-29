Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9625279C32
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 00:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfG2WHf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Jul 2019 18:07:35 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58764 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727562AbfG2WHf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jul 2019 18:07:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 37C9C287BA
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 22:07:34 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 15C7D287A8; Mon, 29 Jul 2019 22:07:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203477] [AMD][KVM] Windows L1 guest becomes extremely slow and
 unusable after enabling Hyper-V
Date:   Mon, 29 Jul 2019 22:07:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lol123lol125@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203477-28872-3siWrNIGG7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203477-28872@https.bugzilla.kernel.org/>
References: <bug-203477-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203477

lol123lol125@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lol123lol125@gmail.com

--- Comment #1 from lol123lol125@gmail.com ---
I am having a similar probably the same issue with proxmox 6/windows server
2019. i am able to boot an ubuntu image as l2 guest. But Either the l1 system
is unresponsive or it crashes with a bluesceen before reaching the gui.
Bluescreens seem to be all watchdog related but vary. (DPC Watchdog
Violation,clock watchdog timeout).



Hardware platform:  
CPU: AMD Ryzen Threadripper 2950X
Board: ASRock X399 Taichi X399-A (SVM, IOMMU related settings enabled in BIOS)


root@pve-master:~# grep -H '' /sys/module/kvm_amd/parameters/*
/sys/module/kvm_amd/parameters/avic:0
/sys/module/kvm_amd/parameters/nested:1
/sys/module/kvm_amd/parameters/npt:1
/sys/module/kvm_amd/parameters/pause_filter_count:3000
/sys/module/kvm_amd/parameters/pause_filter_count_grow:2
/sys/module/kvm_amd/parameters/pause_filter_count_max:65535
/sys/module/kvm_amd/parameters/pause_filter_count_shrink:0
/sys/module/kvm_amd/parameters/pause_filter_thresh:128
/sys/module/kvm_amd/parameters/sev:0
/sys/module/kvm_amd/parameters/vgif:1
/sys/module/kvm_amd/parameters/vls:1

root@pve-master:~# grep -H '' /sys/module/kvm/parameters/*
/sys/module/kvm/parameters/enable_vmware_backdoor:N
/sys/module/kvm/parameters/force_emulation_prefix:N
/sys/module/kvm/parameters/halt_poll_ns:200000
/sys/module/kvm/parameters/halt_poll_ns_grow:0
/sys/module/kvm/parametQers/halt_poll_ns_shrink:0
/sys/module/kvm/parameters/ignore_msrs:Y
/sys/module/kvm/parameters/kvmclock_periodic_sync:Y
/sys/module/kvm/parameters/lapic_timer_advance_ns:4294967295
/sys/module/kvm/parameters/min_timer_period_us:200
/sys/module/kvm/parameters/report_ignored_msrs:N
/sys/module/kvm/parameters/tsc_tolerance_ppm:250
/sys/module/kvm/parameters/vector_hashing:Y


/usr/bin/kvm -id 114 -name server2019 -chardev
socket,id=qmp,path=/var/run/qemu-server/114.qmp,server,nowait -mon
chardev=qmp,mode=control -chardev
socket,id=qmp-event,path=/var/run/qmeventd.sock,reconnect=5 -mon
chardev=qmp-event,mode=control -pidfile /var/run/qemu-server/114.pid -daemonize
-smbios type=1,uuid=8167be1e-8f3d-4667-8535-62a035ebd087 -smp
6,sockets=1,cores=6,maxcpus=6 -nodefaults -boot
menu=on,strict=on,reboot-timeout=1000,splash=/usr/share/qemu-server/bootsplash.jpg
-vnc unix:/var/run/qemu-server/114.vnc,password -no-hpet -cpu
EPYC,+kvm_pv_unhalt,+kvm_pv_eoi,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_reset,hv_vpindex,hv_runtime,hv_relaxed,hv_synic,hv_stimer,hv_tlbflush,hv_ipi,enforce,vendor=AuthenticAMD
-m 8192 -device vmgenid,guid=53ded4c7-f067-4ae6-8ab0-6a571ccbc1ba -readconfig
/usr/share/qemu-server/pve-q35-4.0.cfg -device
qxl-vga,id=vga,bus=pcie.0,addr=0x1 -spice
tls-port=61000,addr=127.0.0.1,tls-ciphers=HIGH,seamless-migration=on -device
virtio-serial,id=spice,bus=pci.0,addr=0x9 -chardev
spicevmc,id=vdagent,name=vdagent -device
virtserialport,chardev=vdagent,name=com.redhat.spice.0 -device
virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x3 -iscsi
initiator-name=iqn.1993-08.org.debian:01:6ff4f776953c -drive
file=/pool_t1/t1_dir//template/iso/virtio-win-0.1.141.iso,if=none,id=drive-ide0,media=cdrom,aio=threads
-device ide-cd,bus=ide.0,unit=0,drive=drive-ide0,id=ide0,bootindex=200 -drive
file=/pool_t1/t1_dir//template/iso/winserver19_17763.1.180914-1434.rs5_release_SERVER_EVAL_x64fre_de-de.iso,if=none,id=drive-ide2,media=cdrom,aio=threads
-device ide-cd,bus=ide.1,unit=0,drive=drive-ide2,id=ide2,bootindex=201 -drive
file=/dev/zvol/pool_t1/vmdata/vm-114-disk-0,if=none,id=drive-virtio0,format=raw,cache=none,aio=native,detect-zeroes=on
-device
virtio-blk-pci,drive=drive-virtio0,id=virtio0,bus=pci.0,addr=0xa,bootindex=100
-netdev
type=tap,id=net0,ifname=tap114i0,script=/var/lib/qemu-server/pve-bridge,downscript=/var/lib/qemu-server/pve-bridgedown,vhost=on
-device
virtio-net-pci,mac=16:72:12:9F:33:FA,netdev=net0,bus=pci.0,addr=0x12,id=net0,bootindex=300
-rtc driftfix=slew,base=localtime -machine type=q35 -global
kvm-pit.lost_tick_policy=discard -cpu host,+svm

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
