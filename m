Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2E77F73B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 15:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351103AbjHQNAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351292AbjHQNAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 09:00:41 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46BAA30C8;
        Thu, 17 Aug 2023 06:00:38 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxDOvRGd5kyoYZAA--.47088S3;
        Thu, 17 Aug 2023 21:00:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxniPIGd5kmchcAA--.55665S30;
        Thu, 17 Aug 2023 21:00:00 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v19 28/30] LoongArch: KVM: Enable kvm config and add the makefile
Date:   Thu, 17 Aug 2023 20:59:49 +0800
Message-Id: <20230817125951.1126909-29-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230817125951.1126909-1-zhaotianrui@loongson.cn>
References: <20230817125951.1126909-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxniPIGd5kmchcAA--.55665S30
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable LoongArch kvm config and add the makefile to support build kvm
module.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/Kbuild                      |  1 +
 arch/loongarch/Kconfig                     |  2 +
 arch/loongarch/configs/loongson3_defconfig |  2 +
 arch/loongarch/kvm/Kconfig                 | 44 ++++++++++++++++++++++
 arch/loongarch/kvm/Makefile                | 22 +++++++++++
 5 files changed, 71 insertions(+)
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile

diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
index b01f5cdb27e0..40be8a1696f9 100644
--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -2,6 +2,7 @@ obj-y += kernel/
 obj-y += mm/
 obj-y += net/
 obj-y += vdso/
+obj-y += kvm/
 
 # for cleaning
 subdir- += boot
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index e71d5bf2cee0..ff2cc42eb513 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -123,6 +123,7 @@ config LOONGARCH
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_KRETPROBES
+	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PCI
@@ -664,3 +665,4 @@ source "drivers/acpi/Kconfig"
 endmenu
 
 source "drivers/firmware/Kconfig"
+source "arch/loongarch/kvm/Kconfig"
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index d64849b4cba1..7acb4ae7afa7 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -63,6 +63,8 @@ CONFIG_EFI_ZBOOT=y
 CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
 CONFIG_EFI_CAPSULE_LOADER=m
 CONFIG_EFI_TEST=m
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_MODULES=y
 CONFIG_MODULE_FORCE_LOAD=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
new file mode 100644
index 000000000000..5b34abeeebb5
--- /dev/null
+++ b/arch/loongarch/kvm/Kconfig
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	help
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config AS_HAS_LVZ_EXTENSION
+	def_bool $(as-instr, hvcl)
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on HAVE_KVM
+	select MMU_NOTIFIER
+	select ANON_INODES
+	select PREEMPT_NOTIFIERS
+	select KVM_MMIO
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_XFER_TO_GUEST_WORK
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select HAVE_KVM_EVENTFD
+	select SRCU
+	help
+	  Support hosting virtualized guest machines using hardware
+	  virtualization extensions. You will need a fairly processor
+	  equipped with virtualization extensions.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
new file mode 100644
index 000000000000..2335e873a6ef
--- /dev/null
+++ b/arch/loongarch/kvm/Makefile
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for LOONGARCH KVM support
+#
+
+ccflags-y += -I $(srctree)/$(src)
+
+include $(srctree)/virt/kvm/Makefile.kvm
+
+obj-$(CONFIG_KVM) += kvm.o
+
+kvm-y += main.o
+kvm-y += vm.o
+kvm-y += vmid.o
+kvm-y += tlb.o
+kvm-y += mmu.o
+kvm-y += vcpu.o
+kvm-y += exit.o
+kvm-y += interrupt.o
+kvm-y += timer.o
+kvm-y += switch.o
+kvm-y += csr_ops.o
-- 
2.39.1

