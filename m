Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3906D669C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbjDDPAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbjDDO7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:59:54 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2F45255
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:59:30 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d17so33122052wrb.11
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 07:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680620369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=begeEv6PzHWw3JSOB2kgWACzTnnU0szOMJ+RXUWQ8A8=;
        b=E/Ca0Bd7C4CXGFCDNsOJDB649tVI0gVBga77QPwxXTrFMx2LTp/uNm3f38qC6Zv8F+
         w74iAgHTgiGHcbqenRue9Jidd+uWx0iI9nCCMLpDlsqnvow/co2U69LIy28979mZyKMX
         EJHV6QzHJ4VYDRgLucIfoIiyTnpfXqfQZRT+CfbEEN3tPJFiqvsf9gQ/+kPlIY53iLv4
         E2Ew8+V5uLWeY0KvZwooepdGMTqLis8VnXPzVsR6tRNbuW1RcZ8itGajZDSItPltopnf
         vBJFYnEz5Q2EVQUjBsPFFpmh2JsUNHV4m/r/EEVoSOx7m9pmorWzOkPdS/nwBh1slRn1
         Iueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=begeEv6PzHWw3JSOB2kgWACzTnnU0szOMJ+RXUWQ8A8=;
        b=CUX+GjmH8WxqpGe4iGcbmqAZBOJgIKBOOs0qJY9W5ww7AtrDwo13MsdiJJqVneNjJZ
         NTZ2TW79FSemjMF8gLYYMQld6xI05FxMhsgE1OQ/p393HgnrPpfiOyVtJE4L6o6OpcO3
         HyW3liUK9bBVEZCGLh2xRWZqoD0F6mAHYrt4kw99XPOpTkYhaHIf18KZw/0kiVqKd+AC
         JJe/+/HT058Nmx8S7hMGNmwvlJGkiCwXavYasWVAkpbT30NR+HhOmcZbublN8u0n1D1a
         o2a4L/bS38/WUU4pUqS5Wz2Ae2/qtXqGVRfI5VnHRCpMq0/aEYUePtYoiM2l+vTTH/YQ
         O1yQ==
X-Gm-Message-State: AAQBX9fLxEQKWofQfJM0gzByX+KY4qpxvwJ0rzcJyo6HzLUSjOSdpmdv
        I/+MRAniv5lq/pTuVXZ5Oh4wcQ==
X-Google-Smtp-Source: AKy350alnLyE9Lv4tw9cAE87Lu9aWd0kBZNEJvmfTxu/IIz036lViKXHuS9JugZL8rnoiXVsCyMtHA==
X-Received: by 2002:adf:dd8d:0:b0:2d7:d4b:b33 with SMTP id x13-20020adfdd8d000000b002d70d4b0b33mr1891316wrl.21.1680620369444;
        Tue, 04 Apr 2023 07:59:29 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000100c00b002cea8664304sm12362109wrx.91.2023.04.04.07.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:59:27 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 0EA191FFC1;
        Tue,  4 Apr 2023 15:59:26 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     peter.maydell@linaro.org, David Woodhouse <dwmw@amazon.co.uk>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PULL 10/10] tests/avocado: Test Xen guest support under KVM
Date:   Tue,  4 Apr 2023 15:59:25 +0100
Message-Id: <20230404145925.2638152-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404145925.2638152-1-alex.bennee@linaro.org>
References: <20230404145925.2638152-1-alex.bennee@linaro.org>
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
Message-Id: <20230403134920.2132362-12-alex.bennee@linaro.org>

diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
new file mode 100644
index 0000000000..5391283113
--- /dev/null
+++ b/tests/avocado/kvm_xen_guest.py
@@ -0,0 +1,171 @@
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
+                self.cancel("KVM Xen support is not present "
+                            "(need v5.12+ kernel with CONFIG_KVM_XEN)")
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

