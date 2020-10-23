Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E455F2971D9
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 17:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465500AbgJWPB7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 23 Oct 2020 11:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S461452AbgJWPB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 11:01:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209831] New: Time spent on behalf of vcpu is not accounted as
 guest time
Date:   Fri, 23 Oct 2020 15:01:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mkoutny@suse.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209831-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209831

            Bug ID: 209831
           Summary: Time spent on behalf of vcpu is not accounted as guest
                    time
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.9.0-2.gb1f22f7-default
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: mkoutny@suse.com
        Regression: No

## Reproduction steps

1) Start a Qemu/KVM guest
2) On the host, start watching /proc/stat

> while sleep 1 ; do date +"%s.%N%t" | tr -d "\n" ; grep "cpu " /proc/stat |
> sed 's/cpu//' ; done | \
>         awk '    {for (i=1; i < 12; ++i) {diff[i] = $i-prev[i]; prev[i]=$i;
>         printf("%.2f\t", diff[i]/diff[1]);} print ""; }'

3) In the guest, keep a vcpu busy, `while true ; do true ; done`

4) Watch fields of /proc/stat grow

## Expected behavior

The cpu field (9) guest time grows at ~USER_HZ/s (typically 100). Possibly,
field (10) guest_nice grows. (Not sure about other fields.)

## Actual behavior

The cpu fields (9) guest and (10) guest_nice time remain 0.

## Additional information

host kernel: 5.9.0-2.gb1f22f7-default
guest kernel: 5.3.12-1
host config:
  CONFIG_VIRT_CPU_ACCOUNTING=y
  CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
  CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
Qemu: qemu-x86-5.1.0-7.1.x86_64
Qemu command: 
> qemu       19144  1.9 10.0 4590592 808196 ?      Sl   14:55   2:01
> /usr/bin/qemu-system-x86_64 ... -machine
> pc-q35-4.0,accel=kvm,usb=off,vmport=off,dump-guest-core=off
Qemu full command: 
> qemu       19144  1.9 10.0 4590592 808196 ?      Sl   14:55   2:01
> /usr/bin/qemu-system-x86_64 -name
> guest=opensusetumbleweed-01,debug-threads=on -S -object
> secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-1-opensusetumbleweed-0/master-key.aes
> -machine pc-q35-4.0,accel=kvm,usb=off,vmport=off,dump-guest-core=off -cpu
> Broadwell-IBRS,vme=on,ss=on,vmx=on,pdcm=on,f16c=on,rdrand=on,hypervisor=on,arat=on,tsc-adjust=on,umip=on,md-clear=on,stibp=on,arch-capabilities=on,ssbd=on,xsaveopt=on,pdpe1gb=on,abm=on,ibpb=on,amd-stibp=on,amd-ssbd=on,skip-l1dfl-vmentry=on,pschange-mc-no=on
> -m 2048 -overcommit mem-lock=off -smp 2,sockets=2,cores=1,threads=1 -uuid
> 16e8e5b8-7ce1-44b1-9a5a-4fabfc274d8d -no-user-config -nodefaults -chardev
> socket,id=charmonitor,fd=31,server,nowait -mon
> chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew
> -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global
> ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on -device
> pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2
> -device pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1
> -device pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2
> -device pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3
> -device pcie-root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4
> -device pcie-root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5
> -device pcie-root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6
> -device qemu-xhci,p2=15,p3=15,id=usb,bus=pci.2,addr=0x0 -device
> virtio-serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0 -blockdev
> {"driver":"file","filename":"/images/opensusetumbleweed.qcow2","node-name":"libvirt-2-storage","auto-read-only":true,"discard":"unmap"}
> -blockdev
> {"node-name":"libvirt-2-format","read-only":false,"driver":"qcow2","file":"libvirt-2-storage","backing":null}
> -device
> virtio-blk-pci,bus=pci.4,addr=0x0,drive=libvirt-2-format,id=virtio-disk0,bootindex=1
> -blockdev
> {"driver":"file","filename":"/images/opensusetumbleweed-01-swap.img","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}
> -blockdev
> {"node-name":"libvirt-1-format","read-only":false,"driver":"raw","file":"libvirt-1-storage"}
> -device
> virtio-blk-pci,bus=pci.7,addr=0x0,drive=libvirt-1-format,id=virtio-disk1
> -netdev tap,fd=33,id=hostnet0,vhost=on,vhostfd=34 -device
> virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:34:40:b9,bus=pci.1,addr=0x0
> -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0
> -chardev socket,id=charchannel0,fd=35,server,nowait -device
> virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0
> -chardev spicevmc,id=charchannel1,name=vdagent -device
> virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,id=channel1,name=com.redhat.spice.0
> -device usb-tablet,id=input0,bus=usb.0,port=1 -spice
> port=5900,addr=127.0.0.1,disable-ticketing,image-compression=off,seamless-migration=on
> -device
> qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pcie.0,addr=0x1
> -device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b -device
> hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -chardev
> spicevmc,id=charredir0,name=usbredir -device
> usb-redir,chardev=charredir0,id=redir0,bus=usb.0,port=2 -chardev
> spicevmc,id=charredir1,name=usbredir -device
> usb-redir,chardev=charredir1,id=redir1,bus=usb.0,port=3 -device
> virtio-balloon-pci,id=balloon0,bus=pci.5,addr=0x0 -object
> rng-random,id=objrng0,filename=/dev/urandom -device
> virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.6,addr=0x0 -sandbox
> on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -msg
> timestamp=on                                                                  

## Past information

I saw similar mismatch with v5.5-based kernel where the KVM vcpu time was
accounted both to user (1) and guest (9) components.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
