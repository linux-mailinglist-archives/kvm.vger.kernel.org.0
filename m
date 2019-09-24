Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9DDBC81D
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441007AbfIXMqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440997AbfIXMqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:46:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C26E1307D970;
        Tue, 24 Sep 2019 12:46:04 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94A0160933;
        Tue, 24 Sep 2019 12:45:58 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
Date:   Tue, 24 Sep 2019 14:44:32 +0200
Message-Id: <20190924124433.96810-8-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 24 Sep 2019 12:46:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the new microvm machine type.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 docs/microvm.txt | 78 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 docs/microvm.txt

diff --git a/docs/microvm.txt b/docs/microvm.txt
new file mode 100644
index 0000000000..0241226b2a
--- /dev/null
+++ b/docs/microvm.txt
@@ -0,0 +1,78 @@
+Microvm is a machine type inspired by both NEMU and Firecracker, and
+constructed after the machine model implemented by the latter.
+
+It's main purpose is providing users a minimalist machine type free
+from the burden of legacy compatibility, serving as a stepping stone
+for future projects aiming at improving boot times, reducing the
+attack surface and slimming down QEMU's footprint.
+
+The microvm machine type supports the following devices:
+
+ - ISA bus
+ - i8259 PIC
+ - LAPIC (implicit if using KVM)
+ - IOAPIC (defaults to kernel_irqchip_split = true)
+ - i8254 PIT
+ - MC146818 RTC (optional)
+ - kvmclock (if using KVM)
+ - fw_cfg
+ - One ISA serial port (optional)
+ - Up to eight virtio-mmio devices (configured by the user)
+
+It supports the following machine-specific options:
+
+microvm.option-roms=bool (Set off to disable loading option ROMs)
+microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
+microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
+microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)
+
+By default, microvm uses qboot as its BIOS, to obtain better boot
+times, but it's also compatible with SeaBIOS.
+
+As no current FW is able to boot from a block device using virtio-mmio
+as its transport, a microvm-based VM needs to be run using a host-side
+kernel and, optionally, an initrd image.
+
+This is an example of instantiating a microvm VM with a virtio-mmio
+based console:
+
+qemu-system-x86_64 -M microvm
+ -enable-kvm -cpu host -m 512m -smp 2 \
+ -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
+ -nodefaults -no-user-config -nographic \
+ -chardev stdio,id=virtiocon0,server \
+ -device virtio-serial-device \
+ -device virtconsole,chardev=virtiocon0 \
+ -drive id=test,file=test.img,format=raw,if=none \
+ -device virtio-blk-device,drive=test \
+ -netdev tap,id=tap0,script=no,downscript=no \
+ -device virtio-net-device,netdev=tap0
+
+This is another example, this time using an ISA serial port, useful
+for debugging purposes:
+
+qemu-system-x86_64 -M microvm \
+ -enable-kvm -cpu host -m 512m -smp 2 \
+ -kernel vmlinux -append "earlyprintk=ttyS0 console=ttyS0 root=/dev/vda" \
+ -nodefaults -no-user-config -nographic \
+ -serial stdio \
+ -drive id=test,file=test.img,format=raw,if=none \
+ -device virtio-blk-device,drive=test \
+ -netdev tap,id=tap0,script=no,downscript=no \
+ -device virtio-net-device,netdev=tap0
+
+Finally, in this example a microvm VM is instantiated without RTC,
+without an ISA serial port and without loading the option ROMs,
+obtaining the smallest configuration:
+
+qemu-system-x86_64 -M microvm,rtc=off,isa-serial=off,option-roms=off \
+ -enable-kvm -cpu host -m 512m -smp 2 \
+ -kernel vmlinux -append "console=hvc0 root=/dev/vda" \
+ -nodefaults -no-user-config -nographic \
+ -chardev stdio,id=virtiocon0,server \
+ -device virtio-serial-device \
+ -device virtconsole,chardev=virtiocon0 \
+ -drive id=test,file=test.img,format=raw,if=none \
+ -device virtio-blk-device,drive=test \
+ -netdev tap,id=tap0,script=no,downscript=no \
+ -device virtio-net-device,netdev=tap0
-- 
2.21.0

