Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1942DBB580
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437045AbfIWNfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:50 -0400
Received: from foss.arm.com ([217.140.110.172]:42352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439770AbfIWNfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D0A61576;
        Mon, 23 Sep 2019 06:35:48 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0B1B63F694;
        Mon, 23 Sep 2019 06:35:46 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 09/16] arm: Allow the user to specify RAM base address
Date:   Mon, 23 Sep 2019 14:35:15 +0100
Message-Id: <1569245722-23375-10-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment, the user can specify the amount of RAM a virtual machine
has, which starts at the fixed address ARM_MEMORY_AREA. The memory below
this address is used by MMIO and PCI devices.

However, it might be interesting to specify a different starting address
for the guest RAM. With this patch, the user can specify the address and
the amount of RAM a virtual machine has from the command line by using the
syntax -m/--mem size[@addr]. The address is optional, and must be higher or
equal to ARM_MEMORY_AREA. If it's not specified, the old behavior is
preserved.

This option is guarded by the define ARCH_SUPPORT_CFG_RAM_BASE, and at
the moment only the arm architecture has support for it. If an
architecture doesn't implement this feature, then the old behavior is
preserved and specifying the RAM base address is considered an user
error.

This patch is based upon previous work by Julien Grall.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h |  2 +-
 arm/aarch64/include/kvm/kvm-arch.h |  6 ++---
 arm/include/arm-common/kvm-arch.h  |  6 +++--
 arm/kvm.c                          | 17 ++++++++++----
 builtin-run.c                      | 48 ++++++++++++++++++++++++++++++++++----
 include/kvm/kvm-config.h           |  3 +++
 kvm.c                              |  6 +++++
 7 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index cd31e72971bd..0aa5db40502d 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -3,7 +3,7 @@
 
 #define ARM_KERN_OFFSET(...)	0x8000
 
-#define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
+#define ARM_MAX_ADDR(...)	ARM_LOMAP_MAX_ADDR
 
 #include "arm-common/kvm-arch.h"
 
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 1b3d0a5fb1b4..0c58675654c5 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -5,9 +5,9 @@
 				0x8000				:	\
 				0x80000)
 
-#define ARM_MAX_MEMORY(cfg)	((cfg)->arch.aarch32_guest	?	\
-				ARM_LOMAP_MAX_MEMORY		:	\
-				ARM_HIMAP_MAX_MEMORY)
+#define ARM_MAX_ADDR(cfg)	((cfg)->arch.aarch32_guest	?	\
+				ARM_LOMAP_MAX_ADDR		:	\
+				ARM_HIMAP_MAX_ADDR)
 
 #include "arm-common/kvm-arch.h"
 
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index f8f6b8f98c96..ad1a0e6872dc 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -14,8 +14,8 @@
 #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
 #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
 
-#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
-#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
+#define ARM_LOMAP_MAX_ADDR	(1ULL << 32)
+#define ARM_HIMAP_MAX_ADDR	(1ULL << 40)
 
 #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
 #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
@@ -35,6 +35,8 @@
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
+#define ARCH_SUPPORT_CFG_RAM_BASE	1
+
 /*
  * On a GICv3 there must be one redistributor per vCPU.
  * The value here is the size for one, we multiply this at runtime with
diff --git a/arm/kvm.c b/arm/kvm.c
index 3e49db7704aa..355c118b098a 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -77,7 +77,7 @@ void kvm__init_ram(struct kvm *kvm)
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
 
-	phys_start	= ARM_MEMORY_AREA;
+	phys_start 	= kvm->cfg.ram_base;
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
@@ -106,8 +106,17 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
 {
-	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
-		cfg->ram_size = ARM_MAX_MEMORY(cfg);
+	if (cfg->ram_base == INVALID_MEM_ADDR)
+		cfg->ram_base = ARM_MEMORY_AREA;
+
+	if (cfg->ram_base < ARM_MEMORY_AREA ||
+	    cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
+		cfg->ram_base = ARM_MEMORY_AREA;
+		pr_warning("Changing RAM base to 0x%llx", cfg->ram_base);
+	}
+
+	if (cfg->ram_base + cfg->ram_size > ARM_MAX_ADDR(cfg)) {
+		cfg->ram_size = ARM_MAX_ADDR(cfg) - cfg->ram_base;
 		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
 	}
 }
@@ -229,7 +238,7 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	/* For default firmware address, lets load it at the begining of RAM */
 	if (fw_addr == 0)
-		fw_addr = ARM_MEMORY_AREA;
+		fw_addr = kvm->cfg.ram_base;
 
 	if (!validate_fw_addr(kvm, fw_addr))
 		die("Bad firmware destination: 0x%016llx", fw_addr);
diff --git a/builtin-run.c b/builtin-run.c
index 4e0c52b3e027..df255cc44078 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -87,6 +87,44 @@ void kvm_run_set_wrapper_sandbox(void)
 	kvm_run_wrapper = KVM_RUN_SANDBOX;
 }
 
+static int mem_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm_config *cfg = opt->value;
+	const char *p = arg;
+	char *next;
+	u64 size, addr = INVALID_MEM_ADDR;
+
+	/* Parse memory size. */
+	size = strtoll(p, &next, 0);
+	if (next == p)
+		die("Invalid memory size");
+
+	/* The user specifies the memory in MB, we use bytes. */
+	size <<= MB_SHIFT;
+
+	if (*next == '\0')
+		goto out;
+	else if (*next == '@')
+		p = next + 1;
+	else
+		die("Unexpected character after memory size: %c", *next);
+
+	addr = strtoll(p, &next, 0);
+	if (next == p)
+		die("Invalid memory address");
+
+#ifndef ARCH_SUPPORT_CFG_RAM_BASE
+	if (addr != INVALID_MEM_ADDR)
+		die("Specifying the memory address not supported by the architecture");
+#endif
+
+out:
+	cfg->ram_base = addr;
+	cfg->ram_size = size;
+
+	return 0;
+}
+
 #ifndef OPT_ARCH_RUN
 #define OPT_ARCH_RUN(...)
 #endif
@@ -97,8 +135,11 @@ void kvm_run_set_wrapper_sandbox(void)
 	OPT_STRING('\0', "name", &(cfg)->guest_name, "guest name",	\
 			"A name for the guest"),			\
 	OPT_INTEGER('c', "cpus", &(cfg)->nrcpus, "Number of CPUs"),	\
-	OPT_U64('m', "mem", &(cfg)->ram_size, "Virtual machine memory"	\
-		" size in MB."),					\
+	OPT_CALLBACK('m', "mem", cfg,					\
+		     "size[@addr]",					\
+		     "Virtual machine memory size in MB,"		\
+		     " optionally starting at <addr>.",			\
+		     mem_parser, NULL),					\
 	OPT_CALLBACK('\0', "shmem", NULL,				\
 		     "[pci:]<addr>:<size>[:handle=<handle>][:create]",	\
 		     "Share host shmem with guest via pci device",	\
@@ -531,9 +572,6 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	if (!kvm->cfg.ram_size)
 		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
-	else
-		/* The user specifies the memory in MB. */
-		kvm->cfg.ram_size <<= MB_SHIFT;
 
 	if (kvm->cfg.ram_size > host_ram_size())
 		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index e0c9ee14e103..76edb54e8bae 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -18,10 +18,13 @@
 #define MIN_RAM_SIZE_MB		(64ULL)
 #define MIN_RAM_SIZE_BYTE	(MIN_RAM_SIZE_MB << MB_SHIFT)
 
+#define INVALID_MEM_ADDR	(~0ULL)
+
 struct kvm_config {
 	struct kvm_config_arch arch;
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
 	struct vfio_device_params *vfio_devices;
+	u64 ram_base;
 	u64 ram_size;		/* Guest memory size, in bytes */
 	u8  image_count;
 	u8 num_net_devices;
diff --git a/kvm.c b/kvm.c
index 36b238791fc1..55a7465960b0 100644
--- a/kvm.c
+++ b/kvm.c
@@ -160,6 +160,12 @@ struct kvm *kvm__new(void)
 	kvm->sys_fd = -1;
 	kvm->vm_fd = -1;
 
+	/*
+	 * Make sure we don't mistake the initialization value 0 for ram_base
+	 * with an user specifying address 0.
+	 */
+	kvm->cfg.ram_base = INVALID_MEM_ADDR;
+
 #ifdef KVM_BRLOCK_DEBUG
 	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
 #endif
-- 
2.7.4

