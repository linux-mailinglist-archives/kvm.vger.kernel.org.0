Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A756D4626
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjDCNth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjDCNt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C2D6E95
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:27 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id y14so29447095wrq.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKaHaFlstk5VQMLZ9VjcumTBmG2FDADA92zKOBfHglo=;
        b=c4D5FAHNNne6aHzgXm5PKvuQrV0KwTkfjJrPgEUCbjhxQtZdGE6JVakoULkhd4i0Jp
         KQ44SWWS+vuj0c/x1WHBgAJVF0VkrLqxVfK+GJjHs7Vea8fmVUlRf1Ue5TAdeVnp9KRt
         HyiaBIFGGqVpXbqVvGqeMubwlUqQNCZtGvzXPLyTiBafiVbmJ5rk5FMteRW5UZpVxlOP
         Coe1KPAvwVYf9gfUKbXzQm/PUx95STeBTH+X/m9TYt0ik4ltlVpmOHols2Q8yhqBI2oc
         T7M2Qg9KeZKsqn6T1nFy3QM0dtzikm8kUK4amICoZQ+Ulw9BczaCvvd3MmZdonHSCx4j
         3oXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKaHaFlstk5VQMLZ9VjcumTBmG2FDADA92zKOBfHglo=;
        b=rqUE8ZkrgsUeIu22I7V6zNWFdtEzYmIv5DCTE5++GFasqGDSA+/5z2mEnPxandY4/W
         O9jX1lluiBYd1bcO3T2z3ersSZ1RRp/1BZzektFjaAFw1l0N/l93EHuLXUpUsLtWRepG
         peJh2kmwL+Oscce7oh/ey6b/VQ6mWoN68u6/4jtcmG/cM5SHgYBI9WcVF5eJn4kZ+CDQ
         6nsMz+8B10JUB6zDtMSko1YQtWPpgMGBTdVOvu84Xf2S9ivHDkqi/vqd7SHvQC+1Lcis
         WXEBlu/H0hL/t3VHtZAuD+d8XwniAnFzAzILPCzZhkk7De9kJb/Y/USMGgjDqY88xw/n
         o0VQ==
X-Gm-Message-State: AAQBX9fK4hA+DOotdYKy6YFPv86LD/pF1P6MOJ1Yz4Xm6WaqaFu/NJHt
        6JYQ1oaatMW2jUHwLEt8qWHEJw==
X-Google-Smtp-Source: AKy350Ydv65QkkABiTX0HooAnoZ65jAKnxHGHWOofsFjIU4hIEUqi5s3uitbO13gUcAIrUZq7sRtTA==
X-Received: by 2002:a05:6000:ca:b0:2d6:5afe:7b91 with SMTP id q10-20020a05600000ca00b002d65afe7b91mr12487847wrx.30.1680529765861;
        Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id j8-20020adfe508000000b002cfe71153b4sm9696735wrm.60.2023.04.03.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C43841FFB8;
        Mon,  3 Apr 2023 14:49:21 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v2 11/11] tests/avocado: Test Xen guest support under KVM
Date:   Mon,  3 Apr 2023 14:49:20 +0100
Message-Id: <20230403134920.2132362-12-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Exercise guests with a few different modes for interrupt delivery. In
particular we want to cover:

 • Xen event channel delivery via GSI to the I/O APIC
 • Xen event channel delivery via GSI to the i8259 PIC
 • MSIs routed to PIRQ event channels
 • GSIs routed to PIRQ event channels

As well as some variants of normal non-Xen stuff like MSI to vAPIC and
PCI INTx going to the I/O APIC and PIC, which ought to still work even
in Xen mode.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230324160719.1790792-1-alex.bennee@linaro.org>

---
v2
  - catch fail to launch and skip on lack of support
---
 tests/avocado/kvm_xen_guest.py | 170 +++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)
 create mode 100644 tests/avocado/kvm_xen_guest.py

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
new file mode 100644
index 0000000000..112c955976
--- /dev/null
+++ b/tests/avocado/kvm_xen_guest.py
@@ -0,0 +1,170 @@
+# KVM Xen guest functional tests
+#
+# Copyright © 2021 Red Hat, Inc.
+# Copyright © 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+#
+# Author:
+#  David Woodhouse <dwmw2@infradead.org>
+#  Alex Bennée <alex.bennee@linaro.org>
+#
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+import os
+
+from qemu.machine import machine
+
+from avocado_qemu import LinuxSSHMixIn
+from avocado_qemu import QemuSystemTest
+from avocado_qemu import wait_for_console_pattern
+
+class KVMXenGuest(QemuSystemTest, LinuxSSHMixIn):
+    """
+    :avocado: tags=arch:x86_64
+    :avocado: tags=machine:q35
+    :avocado: tags=accel:kvm
+    :avocado: tags=kvm_xen_guest
+    """
+
+    KERNEL_DEFAULT = 'printk.time=0 root=/dev/xvda console=ttyS0'
+
+    kernel_path = None
+    kernel_params = None
+
+    # Fetch assets from the kvm-xen-guest subdir of my shared test
+    # images directory on fileserver.linaro.org where you can find
+    # build instructions for how they where assembled.
+    def get_asset(self, name, sha1):
+        base_url = ('https://fileserver.linaro.org/s/'
+                    'kE4nCFLdQcoBF9t/download?'
+                    'path=%2Fkvm-xen-guest&files=' )
+        url = base_url + name
+        # use explicit name rather than failing to neatly parse the
+        # URL into a unique one
+        return self.fetch_asset(name=name, locations=(url), asset_hash=sha1)
+
+    def common_vm_setup(self):
+        # We also catch lack of KVM_XEN support if we fail to launch
+        self.require_accelerator("kvm")
+
+        self.vm.set_console()
+
+        self.vm.add_args("-accel", "kvm,xen-version=0x4000a,kernel-irqchip=split")
+        self.vm.add_args("-smp", "2")
+
+        self.kernel_path = self.get_asset("bzImage",
+                                          "367962983d0d32109998a70b45dcee4672d0b045")
+        self.rootfs = self.get_asset("rootfs.ext4",
+                                     "f1478401ea4b3fa2ea196396be44315bab2bb5e4")
+
+    def run_and_check(self):
+        self.vm.add_args('-kernel', self.kernel_path,
+                         '-append', self.kernel_params,
+                         '-drive',  f"file={self.rootfs},if=none,format=raw,id=drv0",
+                         '-device', 'xen-disk,drive=drv0,vdev=xvda',
+                         '-device', 'virtio-net-pci,netdev=unet',
+                         '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
+
+        try:
+            self.vm.launch()
+        except machine.VMLaunchFailure as e:
+            if "Xen HVM guest support not present" in e.output:
+                self.cancel("KVM Xen support is not present (need v5.12+ kernel with CONFIG_KVM_XEN)")
+            elif "Property 'kvm-accel.xen-version' not found" in e.output:
+                self.cancel("QEMU not built with CONFIG_XEN_EMU support")
+            else:
+                raise e
+
+        self.log.info('VM launched, waiting for sshd')
+        console_pattern = 'Starting dropbear sshd: OK'
+        wait_for_console_pattern(self, console_pattern, 'Oops')
+        self.log.info('sshd ready')
+        self.ssh_connect('root', '', False)
+
+        self.ssh_command('cat /proc/cmdline')
+        self.ssh_command('dmesg | grep -e "Grant table initialized"')
+
+    def test_kvm_xen_guest(self):
+        """
+        :avocado: tags=kvm_xen_guest
+        """
+
+        self.common_vm_setup()
+
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks')
+        self.run_and_check()
+        self.ssh_command('grep xen-pirq.*msi /proc/interrupts')
+
+    def test_kvm_xen_guest_nomsi(self):
+        """
+        :avocado: tags=kvm_xen_guest_nomsi
+        """
+
+        self.common_vm_setup()
+
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks pci=nomsi')
+        self.run_and_check()
+        self.ssh_command('grep xen-pirq.* /proc/interrupts')
+
+    def test_kvm_xen_guest_noapic_nomsi(self):
+        """
+        :avocado: tags=kvm_xen_guest_noapic_nomsi
+        """
+
+        self.common_vm_setup()
+
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks noapic pci=nomsi')
+        self.run_and_check()
+        self.ssh_command('grep xen-pirq /proc/interrupts')
+
+    def test_kvm_xen_guest_vapic(self):
+        """
+        :avocado: tags=kvm_xen_guest_vapic
+        """
+
+        self.common_vm_setup()
+        self.vm.add_args('-cpu', 'host,+xen-vapic')
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks')
+        self.run_and_check()
+        self.ssh_command('grep xen-pirq /proc/interrupts')
+        self.ssh_command('grep PCI-MSI /proc/interrupts')
+
+    def test_kvm_xen_guest_novector(self):
+        """
+        :avocado: tags=kvm_xen_guest_novector
+        """
+
+        self.common_vm_setup()
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks' +
+                              ' xen_no_vector_callback')
+        self.run_and_check()
+        self.ssh_command('grep xen-platform-pci /proc/interrupts')
+
+    def test_kvm_xen_guest_novector_nomsi(self):
+        """
+        :avocado: tags=kvm_xen_guest_novector_nomsi
+        """
+
+        self.common_vm_setup()
+
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks pci=nomsi' +
+                              ' xen_no_vector_callback')
+        self.run_and_check()
+        self.ssh_command('grep xen-platform-pci /proc/interrupts')
+
+    def test_kvm_xen_guest_novector_noapic(self):
+        """
+        :avocado: tags=kvm_xen_guest_novector_noapic
+        """
+
+        self.common_vm_setup()
+        self.kernel_params = (self.KERNEL_DEFAULT +
+                              ' xen_emul_unplug=ide-disks' +
+                              ' xen_no_vector_callback noapic')
+        self.run_and_check()
+        self.ssh_command('grep xen-platform-pci /proc/interrupts')
-- 
2.39.2

