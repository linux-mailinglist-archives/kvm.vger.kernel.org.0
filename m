Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47B6BB57C
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfIWNf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:59 -0400
Received: from foss.arm.com ([217.140.110.172]:42416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730553AbfIWNf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C73E21000;
        Mon, 23 Sep 2019 06:35:56 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C0EA33F694;
        Mon, 23 Sep 2019 06:35:55 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 16/16] arm: Allow the user to define the MMIO regions
Date:   Mon, 23 Sep 2019 14:35:22 +0100
Message-Id: <1569245722-23375-17-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the user to specify the I/O port (--ioport), MMIO (--mmio) and PCI
MMIO (--pci-mmio) memory regions using the size@addr format.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/kvm-config-arch.h |  25 +++++
 arm/include/arm-common/memory.h          |   3 +
 arm/memory.c                             | 168 ++++++++++++++++++++++++++++---
 arm/pci.c                                |   5 +-
 kvm.c                                    |   5 +
 5 files changed, 192 insertions(+), 14 deletions(-)

diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46ab9e6..3d2be1ae4c60 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -6,6 +6,12 @@
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
 	unsigned int	force_cntfrq;
+	u64		ioport_addr;
+	u64		ioport_size;
+	u64		mmio_addr;
+	u64		mmio_size;
+	u64		pci_mmio_addr;
+	u64		pci_mmio_size;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
@@ -15,10 +21,29 @@ struct kvm_config_arch {
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
+int ioport_parser(const struct option *opt, const char *arg, int unset);
+int mmio_parser(const struct option *opt, const char *arg, int unset);
+int pci_mmio_parser(const struct option *opt, const char *arg, int unset);
 
 #define OPT_ARCH_RUN(pfx, cfg)							\
 	pfx,									\
 	ARM_OPT_ARCH_RUN(cfg)							\
+	OPT_CALLBACK('\0', "ioport", (cfg),					\
+		     "size[@addr]",						\
+		     "Virtual machine I/O port region size, "			\
+		     "optionally starting at <addr> This is where "		\
+		     "the 8250 UART is emulated.",				\
+		     ioport_parser, NULL),					\
+	OPT_CALLBACK('\0', "mmio", (cfg),					\
+		     "size[@addr]",						\
+		     "Virtual machine MMIO memory size, "			\
+		     " optionally starting at <addr>.",				\
+		     mmio_parser, NULL),					\
+	OPT_CALLBACK('\0', "pci-mmio", (cfg),					\
+		     "size[@addr]",						\
+		     "Virtual machine PCI MMIO memory size, "			\
+		     " optionally starting at <addr>.",				\
+		     pci_mmio_parser, NULL),					\
 	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,			\
 		   ".dtb file", "Dump generated .dtb to specified file"),	\
 	OPT_UINTEGER('\0', "override-bad-firmware-cntfrq", &(cfg)->force_cntfrq,\
diff --git a/arm/include/arm-common/memory.h b/arm/include/arm-common/memory.h
index a22e503f3349..074b2a5ff82c 100644
--- a/arm/include/arm-common/memory.h
+++ b/arm/include/arm-common/memory.h
@@ -7,4 +7,7 @@
 void memory_init(struct kvm *kvm);
 void memory_sanitize_cfg(struct kvm_config *cfg);
 
+u64 memory_get_ioport_size(void);
+u64 memory_get_pci_mmio_size(void);
+
 #endif
diff --git a/arm/memory.c b/arm/memory.c
index 39ed9e224c72..818a9add80e3 100644
--- a/arm/memory.c
+++ b/arm/memory.c
@@ -12,12 +12,58 @@ u64 mmio_addr = ALLOC_INVALID_ADDR;
 u64 pci_cfg_addr = ALLOC_INVALID_ADDR;
 u64 pci_mmio_addr = ALLOC_INVALID_ADDR;
 
+static u64 ioport_size;
+
 static struct allocator *lomap_allocator;
 static struct allocator *mmio_allocator;
 static struct allocator *pci_mmio_allocator;
 
+int ioport_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm_config *cfg = opt->value;
+	const char *p = arg;
+	u64 size, addr;
+
+	kvm__parse_size_addr_option(p, &size, &addr);
+
+	cfg->arch.ioport_addr = addr;
+	cfg->arch.ioport_size = size;
+
+	return 0;
+}
+
+int mmio_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm_config *cfg = opt->value;
+	const char *p = arg;
+	u64 size, addr;
+
+	kvm__parse_size_addr_option(p, &size, &addr);
+
+	cfg->arch.mmio_addr = addr;
+	cfg->arch.mmio_size = size;
+
+	return 0;
+}
+
+int pci_mmio_parser(const struct option *opt, const char *arg, int unset)
+{
+	struct kvm_config *cfg = opt->value;
+	const char *p = arg;
+	u64 size, addr;
+
+	kvm__parse_size_addr_option(p, &size, &addr);
+
+	cfg->arch.pci_mmio_addr = addr;
+	cfg->arch.pci_mmio_size = size;
+
+	return 0;
+}
+
 void memory_sanitize_cfg(struct kvm_config *cfg)
 {
+	struct kvm_config_arch *arch = &cfg->arch;
+
 	if (cfg->ram_base == INVALID_MEM_ADDR)
 		cfg->ram_base = ARM_MEMORY_AREA;
 
@@ -30,6 +76,102 @@ void memory_sanitize_cfg(struct kvm_config *cfg)
 		cfg->ram_size = ARM_MAX_ADDR(cfg) - cfg->ram_base;
 		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
 	}
+
+	if (!arch->ioport_size)
+		arch->ioport_size = ARM_IOPORT_SIZE;
+
+	if (arch->ioport_size < ALLOC_PAGE_SIZE) {
+		/*
+		 * Allocate at least one page of maximum size for ioports. No
+		 * need to check the sized for general MMIO and PCI MMIO, as
+		 * allocations from those regions are larger than the page size
+		 * and they will fail if the regions are too small.
+		 */
+		arch->ioport_size = ALLOC_PAGE_SIZE;
+		pr_warning("Changing IOPORT memory size to 0x%x", ALLOC_PAGE_SIZE);
+	}
+
+	if (arch->ioport_size & (ALLOC_PAGE_SIZE - 1)) {
+		arch->ioport_size = ALIGN(arch->ioport_size, ALLOC_PAGE_SIZE);
+		pr_warning("Aligning IOPORT size to maximum page size (now is 0x%llx)",
+			   arch->ioport_size);
+	}
+
+	if (!cfg->arch.mmio_size)
+		cfg->arch.mmio_size = ARM_MMIO_SIZE;
+
+	if (arch->mmio_size & (ALLOC_PAGE_SIZE - 1)) {
+		arch->mmio_size = ALIGN(arch->mmio_size, ALLOC_PAGE_SIZE);
+		pr_warning("Aligning MMIO size to maximum page size (now is 0x%llx)",
+			   arch->mmio_size);
+	}
+
+	if (!cfg->arch.pci_mmio_size)
+		cfg->arch.pci_mmio_size = ARM_PCI_MMIO_SIZE;
+
+	if (arch->pci_mmio_size & (ALLOC_PAGE_SIZE - 1)) {
+		arch->pci_mmio_size = ALIGN(arch->pci_mmio_size, ALLOC_PAGE_SIZE);
+		pr_warning("Aligning PCI MMIO size to maximum page size (now is 0x%llx)",
+			   arch->pci_mmio_size);
+	}
+}
+
+static void init_ioport_region(struct kvm *kvm)
+{
+	struct kvm_config_arch *arch = &kvm->cfg.arch;
+	int ret;
+
+	if (arch->ioport_addr == INVALID_MEM_ADDR) {
+		ioport_addr = allocator_alloc(lomap_allocator, arch->ioport_size);
+		if (ioport_addr == ALLOC_INVALID_ADDR)
+			die("Not enough memory to allocate KVM_IOPORT_AREA");
+	} else {
+		ret = allocator_reserve(lomap_allocator, arch->ioport_addr,
+					arch->ioport_size);
+		if (ret)
+			die("Not enough memory to reserve KVM_IOPORT_AREA");
+		ioport_addr = arch->ioport_addr;
+	}
+	ioport_size = arch->ioport_size;
+}
+
+static void init_mmio_region(struct kvm *kvm)
+{
+	struct kvm_config_arch *arch = &kvm->cfg.arch;
+	int ret;
+
+	if (arch->mmio_addr == INVALID_MEM_ADDR) {
+		mmio_addr = allocator_alloc(lomap_allocator, arch->mmio_size);
+		if (mmio_addr == ALLOC_INVALID_ADDR)
+			die("Not enough memory to allocate KVM_MMIO_AREA");
+	} else {
+		ret = allocator_reserve(lomap_allocator, arch->mmio_addr,
+					arch->mmio_size);
+		if (ret)
+			die("Not enough memory to reserve KVM_MMIO_AREA");
+		mmio_addr = arch->mmio_addr;
+	}
+	mmio_allocator = allocator_create(mmio_addr, arch->mmio_size);
+}
+
+static void init_pci_mmio_region(struct kvm *kvm)
+{
+	struct kvm_config_arch *arch = &kvm->cfg.arch;
+	int ret;
+
+	if (arch->pci_mmio_addr == INVALID_MEM_ADDR) {
+		pci_mmio_addr = allocator_alloc(lomap_allocator, arch->pci_mmio_size);
+		if (pci_mmio_addr == ALLOC_INVALID_ADDR)
+			die("Not enough memory to allocate KVM_PCI_MMIO_AREA");
+	} else {
+		ret = allocator_reserve(lomap_allocator,
+					arch->pci_mmio_addr,
+					arch->pci_mmio_size);
+		if (ret)
+			die("Not enough memory to reserve KVM_PCI_MMIO_AREA");
+		pci_mmio_addr = arch->pci_mmio_addr;
+	}
+	pci_mmio_allocator = allocator_create(pci_mmio_addr, arch->pci_mmio_size);
 }
 
 static void init_mmio(struct kvm *kvm)
@@ -49,23 +191,15 @@ static void init_mmio(struct kvm *kvm)
 	if (ret)
 		die("Could not reserve RAM address space");
 
-	ioport_addr = allocator_alloc(lomap_allocator, ARM_IOPORT_SIZE);
-	if (ioport_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_IOPORT_AREA");
-
-	mmio_addr = allocator_alloc(lomap_allocator, ARM_MMIO_SIZE);
-	if (mmio_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_MMIO_AREA");
-	mmio_allocator = allocator_create(mmio_addr, ARM_MMIO_SIZE);
+	init_ioport_region(kvm);
+	init_mmio_region(kvm);
 
+	/* The user cannot define the PCI CFG area. */
 	pci_cfg_addr = allocator_alloc(lomap_allocator, PCI_CFG_SIZE);
 	if (pci_cfg_addr == ALLOC_INVALID_ADDR)
 		die("Not enough memory to allocate KVM_PCI_CFG_AREA");
 
-	pci_mmio_addr = allocator_alloc(lomap_allocator, ARM_PCI_MMIO_SIZE);
-	if (pci_mmio_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_PCI_MMIO_AREA");
-	pci_mmio_allocator = allocator_create(pci_mmio_addr, ARM_PCI_MMIO_SIZE);
+	init_pci_mmio_region(kvm);
 }
 
 static void init_ram(struct kvm *kvm)
@@ -180,3 +314,13 @@ u32 kvm__arch_alloc_pci_mmio_block(u32 size)
 	 */
 	return (u32)addr;
 }
+
+u64 memory_get_ioport_size(void)
+{
+	return ioport_size;
+}
+
+u64 memory_get_pci_mmio_size(void)
+{
+	return pci_mmio_allocator->size;
+}
diff --git a/arm/pci.c b/arm/pci.c
index 1a2fc2688c9e..01242017c143 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -6,6 +6,7 @@
 #include "kvm/util.h"
 
 #include "arm-common/pci.h"
+#include "arm-common/memory.h"
 
 /*
  * An entry in the interrupt-map table looks like:
@@ -43,7 +44,7 @@ void pci__generate_fdt_nodes(void *fdt)
 				.lo	= 0,
 			},
 			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
-			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
+			.length		= cpu_to_fdt64(memory_get_ioport_size()),
 		},
 		{
 			.pci_addr = {
@@ -52,7 +53,7 @@ void pci__generate_fdt_nodes(void *fdt)
 				.lo	= cpu_to_fdt32(KVM_PCI_MMIO_AREA),
 			},
 			.cpu_addr	= cpu_to_fdt64(KVM_PCI_MMIO_AREA),
-			.length		= cpu_to_fdt64(ARM_PCI_MMIO_SIZE),
+			.length		= cpu_to_fdt64(memory_get_pci_mmio_size()),
 		},
 	};
 
diff --git a/kvm.c b/kvm.c
index 4da413e0681d..b6b0abf7cd59 100644
--- a/kvm.c
+++ b/kvm.c
@@ -165,6 +165,11 @@ struct kvm *kvm__new(void)
 	 * with an user specifying address 0.
 	 */
 	kvm->cfg.ram_base = INVALID_MEM_ADDR;
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+	kvm->cfg.arch.ioport_addr = INVALID_MEM_ADDR;
+	kvm->cfg.arch.mmio_addr = INVALID_MEM_ADDR;
+	kvm->cfg.arch.pci_mmio_addr = INVALID_MEM_ADDR;
+#endif
 
 #ifdef KVM_BRLOCK_DEBUG
 	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
-- 
2.7.4

