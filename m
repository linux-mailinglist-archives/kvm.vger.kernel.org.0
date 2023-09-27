Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268FE7AF985
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjI0EgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjI0Ef0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:35:26 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB65AF4;
        Tue, 26 Sep 2023 20:10:18 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxyOgRnRNltRctAA--.50576S3;
        Wed, 27 Sep 2023 11:10:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S25;
        Wed, 27 Sep 2023 11:10:09 +0800 (CST)
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
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 23/25] LoongArch: KVM: Enable kvm config and add the makefile
Date:   Wed, 27 Sep 2023 11:09:57 +0800
Message-Id: <20230927030959.3629941-24-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S25
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
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/Kbuild                      |  2 ++
 arch/loongarch/Kconfig                     |  6 ++++
 arch/loongarch/configs/loongson3_defconfig |  2 ++
 arch/loongarch/kvm/Kconfig                 | 40 ++++++++++++++++++++++
 arch/loongarch/kvm/Makefile                | 20 +++++++++++
 5 files changed, 70 insertions(+)
 create mode 100644 arch/loongarch/kvm/Kconfig
 create mode 100644 arch/loongarch/kvm/Makefile

diff --git a/arch/loongarch/Kbuild b/arch/loongarch/Kbuild
index b01f5cdb27..beb8499dd8 100644
--- a/arch/loongarch/Kbuild
+++ b/arch/loongarch/Kbuild
@@ -3,5 +3,7 @@ obj-y += mm/
 obj-y += net/
 obj-y += vdso/
 
+obj-$(CONFIG_KVM) += kvm/
+
 # for cleaning
 subdir- += boot
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index e14396a2dd..d889a0b97b 100644
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
@@ -263,6 +264,9 @@ config AS_HAS_LASX_EXTENSION
 config AS_HAS_LBT_EXTENSION
 	def_bool $(as-instr,movscr2gr \$a0$(comma)\$scr0)
 
+config AS_HAS_LVZ_EXTENSION
+	def_bool $(as-instr,hvcl 0)
+
 menu "Kernel type and options"
 
 source "kernel/Kconfig.hz"
@@ -676,3 +680,5 @@ source "kernel/power/Kconfig"
 source "drivers/acpi/Kconfig"
 
 endmenu
+
+source "arch/loongarch/kvm/Kconfig"
diff --git a/arch/loongarch/configs/loongson3_defconfig b/arch/loongarch/configs/loongson3_defconfig
index a3b52aaa83..cdcd61a5f4 100644
--- a/arch/loongarch/configs/loongson3_defconfig
+++ b/arch/loongarch/configs/loongson3_defconfig
@@ -62,6 +62,8 @@ CONFIG_ACPI_IPMI=m
 CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_PCI_SLOT=y
 CONFIG_ACPI_HOTPLUG_MEMORY=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_KVM=m
 CONFIG_EFI_ZBOOT=y
 CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
 CONFIG_EFI_CAPSULE_LOADER=m
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
new file mode 100644
index 0000000000..fda425babf
--- /dev/null
+++ b/arch/loongarch/kvm/Kconfig
@@ -0,0 +1,40 @@
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
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on AS_HAS_LVZ_EXTENSION
+	depends on HAVE_KVM
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select HAVE_KVM_EVENTFD
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
+	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_MMIO
+	select KVM_XFER_TO_GUEST_WORK
+	select MMU_NOTIFIER
+	select PREEMPT_NOTIFIERS
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
2.39.3

