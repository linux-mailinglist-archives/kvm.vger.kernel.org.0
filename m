Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CC48EB2E
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 15:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbiANOES convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jan 2022 09:04:18 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:38390 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiANOES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 09:04:18 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2022 09:04:18 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7A9329C02A6
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:57:23 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id JW-rC3P_-Yay; Fri, 14 Jan 2022 08:57:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id E98199C02A5;
        Fri, 14 Jan 2022 08:57:22 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BbXN5zqYlOcF; Fri, 14 Jan 2022 08:57:22 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id CBF6A9C023E;
        Fri, 14 Jan 2022 08:57:22 -0500 (EST)
Date:   Fri, 14 Jan 2022 08:57:22 -0500 (EST)
From:   Mathieu =?utf-8?Q?Dupr=C3=A9?= 
        <mathieu.dupre@savoirfairelinux.com>
To:     kvm@vger.kernel.org
Cc:     Eloi Bail <eloi.bail@savoirfairelinux.com>
Message-ID: <2145240823.143808.1642168642764.JavaMail.zimbra@savoirfairelinux.com>
Subject: KVM-RT high max latency after upgrade host from 4.19 to 5.15
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.8.15_GA_4180 (ZimbraWebClient - FF95 (Linux)/8.8.15_GA_4177)
Thread-Index: oRJ4hgB0SScxc5sxDJfwhu0LJaK/uA==
Thread-Topic: KVM-RT high max latency after upgrade host from 4.19 to 5.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I have a high latency in KVM with Linux 5.15 that I did not have in 4.19.

Previously I was on version 4.19.188-rt77 (with the PREEMPT_RT and CONFIG_PREEMPT_FULL patch), I was running KVM on an isolated CPU and I had a max latency with cyclictest of ~60 µs.

I have bumped the kernel version to 5.15.13-rt26 (on both host and guest) and I have now a huge maximal latency of 40 ms.

I try to tweak halt_poll_ns, and I managed to reduce the latency to 4 ms.

The host max latency outside KVM is the same.

When I used LTTng to know what’s happen, I see that periodically the CPU core running KVM enter in idle mode.

I have tried with 3 different Intel CPU (Intel Core i3-4130, Intel Xeon E5-2680 and Intel Xeon X5660) and I have always the same result.

Here is my setup :
Intel CPU
KVM runing on a dedecated CPU with real-time priority
Kernel parameters : isolcpus=2-3 nohz_full=2-3 rcu_nocbs=2-3 irqaffinity=0-1
CONFIG_CPU_IDLE not set
qemu-x86_64 version 4.2.0
cyclictest command : cyclictest -l1000000 -m -Sp90 -i200 -h200

Qemu parameters
/usr/bin/qemu-system-x86_64
-name guest=guest0,debug-threads=on
-S
-object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-2-guest0/master-key.aes
-blockdev {"driver":"file","filename":"/usr/share/qemu/edk2-x86_64-code.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}
-blockdev {"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/guest0_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}
-machine pc-i440fx-4.1,accel=kvm,usb=off,dump-guest-core=off,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format
-cpu host,tsc-deadline=on,pmu=off
-m 256
-overcommit mem-lock=off
-smp 1,sockets=1,dies=1,cores=1,threads=1
-uuid 06ed47d1-6dc8-437b-a655-c578768dd0c2
-no-user-config
-nodefaults
-device sga
-chardev socket,id=charmonitor,fd=35,server,nowait
-mon chardev=charmonitor,id=monitor,mode=control
-rtc base=utc,driftfix=slew
-global kvm-pit.lost_tick_policy=delay
-no-hpet
-no-shutdown
-global PIIX4_PM.disable_s3=1
-global PIIX4_PM.disable_s4=1
-boot menu=off,reboot-timeout=0,strict=on
-device piix3-usb-uhci,id=usb,bus=pci.0,addr=0x1.0x2
-blockdev {"driver":"file","filename":"/var/lib/libvirt/images/seapath-guest-efi-test-image-votp-vm.wic.qcow2","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}
-blockdev {"node-name":"libvirt-1-format","read-only":false,"driver":"qcow2","file":"libvirt-1-storage","backing":null}
-device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x3,drive=libvirt-1-format,id=virtio-disk0,bootindex=1
-netdev tap,fd=37,id=hostnet0,vhost=on,vhostfd=38
-device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:34:56:4d,bus=pci.0,addr=0x5
-chardev pty,id=charserial0
-device isa-serial,chardev=charserial0,id=serial0
-vnc 127.0.0.1:0
-device VGA,id=video0,vgamem_mb=16,bus=pci.0,addr=0x4
-device ib700,id=watchdog0
-watchdog-action poweroff
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x2
-msg timestamp=on

Results :
Kernel host : 4.19.188-rt77
Kernel guest : 4.19.188-rt77
halt_poll_ns : default value
Max latency : ~60 µs

Kernel host : 5.15.13-rt26
Kernel guest :  5.15.13-rt26
halt_poll_ns : default value
Max latency : > 40 ms

Kernel host : 5.15.13-rt26
Kernel guest :  4.19.188-rt77
halt_poll_ns : default value
Max latency : > 40 ms

Kernel host : 5.15.13-rt26
Kernel guest :  5.15.13-rt26
halt_poll_ns : 50000
Max latency : > 4 ms

I would like to know what is introducing this latency. Is it related to the fact that the CPU running KVM periodically enters IDLE mode? Why do we have this behavior in 5.15 and not in 4.19?

Thanks
