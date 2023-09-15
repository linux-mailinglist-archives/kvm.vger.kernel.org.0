Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC317A1343
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjIOBvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjIOBuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:55 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 972903AA0;
        Thu, 14 Sep 2023 18:50:17 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxl+hOuANlmf8nAA--.41047S3;
        Fri, 15 Sep 2023 09:50:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S29;
        Fri, 15 Sep 2023 09:50:04 +0800 (CST)
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
Subject: [PATCH v21 27/29] LoongArch: KVM: Enable kvm config and add the makefile
Date:   Fri, 15 Sep 2023 09:49:47 +0800
Message-Id: <20230915014949.1222777-28-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S29
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable LoongArch kvm config and add the makefile to support build kvm
module.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202304131526.iXfLaVZc-lkp@intel.com/
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/Kbuild                      |  1 +
 arch/loongarch/Kconfig                     |  3 ++
 arch/loongarch/configs/loongson3_defconfig |  2 +
 arch/loongarch/kvm/Kconfig                 | 45 ++++++++++++++++++++++
 arch/loongarch/kvm/Makefile                | 20 ++++++++++
 5 files changed, 71 insertions(+)
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile

diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
index b01f5cdb27..9679c798c2 100644
--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -2,6 +2,7 @@ obj-y += kernel/
 obj-y += mm/
 obj-y += net/
 obj-y += vdso/
+obj-$(CONFIG_KVM) += kvm/
 
 # for cleaning
 subdir- += boot
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index e14396a2dd..0abb1f12eb 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -129,6 +129,7 @@ config LOONGARCH
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_KRETPROBES
+	select HAVE_KVM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PCI
@@ -676,3 +677,5 @@ source "kernel/power/Kconfig"
 source "drivers/acpi/Kconfig"
 
 endmenu
+
+source "arch/loongarch/kvm/Kconfig"
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index a3b52aaa83..2a8edebcc5 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -67,11 +67,13 @@ CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
 CONFIG_EFI_CAPSULE_LOADER=m
 CONFIG_EFI_TEST=m
 CONFIG_JUMP_LABEL=y
+CONFIG_KVM=m
 CONFIG_MODULES=y
 CONFIG_MODULE_FORCE_LOAD=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
+CONFIG_VIRTUALIZATION=y
 CONFIG_BLK_DEV_THROTTLING=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_BSD_DISKLABEL=y
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
new file mode 100644
index 0000000000..b517785c50
--- /dev/null
+++ b/arch/loongarch/kvm/Kconfig
@@ -0,0 +1,45 @@
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
+	def_bool $(as-instr,hvcl 0)
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on AS_HAS_LVZ_EXTENSION
+	depends on HAVE_KVM
+	select ANON_INODES
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_EVENTFD
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_MMIO
+	select KVM_XFER_TO_GUEST_WORK
+	select MMU_NOTIFIER
+	select PREEMPT_NOTIFIERS
+	select SRCU
+	help
+	  Support hosting virtualized guest machines using
+	  hardware virtualization extensions. You will need
+	  a processor equipped with virtualization extensions.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
new file mode 100644
index 0000000000..77e9ba2b7a
--- /dev/null
+++ b/arch/loongarch/kvm/Makefile
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for LoongArch KVM support
+#
+
+ccflags-y += -I $(srctree)/$(src)
+
+include $(srctree)/virt/kvm/Makefile.kvm
+
+obj-$(CONFIG_KVM) += kvm.o
+
+kvm-y += exit.o
+kvm-y += interrupt.o
+kvm-y += main.o
+kvm-y += mmu.o
+kvm-y += switch.o
+kvm-y += timer.o
+kvm-y += tlb.o
+kvm-y += vcpu.o
+kvm-y += vm.o
-- 
2.39.1

