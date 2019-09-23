Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F49BB57F
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfIWNgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:36:07 -0400
Received: from foss.arm.com ([217.140.110.172]:42398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbfIWNfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 539FC1000;
        Mon, 23 Sep 2019 06:35:54 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 509493F694;
        Mon, 23 Sep 2019 06:35:53 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 14/16] arm: Move memory related code to memory.c
Date:   Mon, 23 Sep 2019 14:35:20 +0100
Message-Id: <1569245722-23375-15-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The amount of memory related code in kvm.c has grown to a respectable size,
and it will only grow larger with the introduction of user specified MMIO
memory regions. Let's keep things tidy and move the code to its own
separate file in memory.c.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                        |   2 +-
 arm/include/arm-common/memory.h |  10 +++
 arm/kvm.c                       | 170 +------------------------------------
 arm/memory.c                    | 182 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 196 insertions(+), 168 deletions(-)
 create mode 100644 arm/include/arm-common/memory.h
 create mode 100644 arm/memory.c

diff --git a/Makefile b/Makefile
index 0ae52c6ad88b..146c3e4ce0e9 100644
--- a/Makefile
+++ b/Makefile
@@ -158,7 +158,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o arm/allocator.o
+			   arm/pmu.o arm/allocator.o arm/memory.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/include/arm-common/memory.h b/arm/include/arm-common/memory.h
new file mode 100644
index 000000000000..a22e503f3349
--- /dev/null
+++ b/arm/include/arm-common/memory.h
@@ -0,0 +1,10 @@
+#ifndef ARM_COMMON_MEMORY_H
+#define ARM_COMMON_MEMORY_H
+
+#include "kvm/kvm.h"
+#include "kvm/kvm-config.h"
+
+void memory_init(struct kvm *kvm);
+void memory_sanitize_cfg(struct kvm_config *cfg);
+
+#endif
diff --git a/arm/kvm.c b/arm/kvm.c
index a12a75d94cdd..45aae76eddfb 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -7,7 +7,7 @@
 #include "kvm/pci.h"
 
 #include "arm-common/gic.h"
-#include "arm-common/allocator.h"
+#include "arm-common/memory.h"
 
 #include <linux/kernel.h>
 #include <linux/kvm.h>
@@ -22,130 +22,12 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
-u64 ioport_addr = ALLOC_INVALID_ADDR;
-u64 mmio_addr = ALLOC_INVALID_ADDR;
-u64 pci_cfg_addr = ALLOC_INVALID_ADDR;
-u64 pci_mmio_addr = ALLOC_INVALID_ADDR;
-
-static struct allocator *lomap_allocator;
-static struct allocator *mmio_allocator;
-static struct allocator *pci_mmio_allocator;
-
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
 	return true;
 }
 
-static void init_mmio_mem(struct kvm *kvm)
-{
-	u64 reserve;
-	int ret;
-
-	/* Allocate MMIO memory below 4G so 32 bit arm can use it. */
-	lomap_allocator = allocator_create(0, ARM_LOMAP_MAX_ADDR);
-
-	if (kvm->arch.memory_guest_start + kvm->ram_size > ARM_LOMAP_MAX_ADDR)
-		reserve = ARM_LOMAP_MAX_ADDR - kvm->arch.memory_guest_start;
-	else
-		reserve = kvm->ram_size;
-	ret = allocator_reserve(lomap_allocator, kvm->arch.memory_guest_start,
-				reserve);
-	if (ret)
-		die("Could not reserve RAM address space");
-
-	ioport_addr = allocator_alloc(lomap_allocator, ARM_IOPORT_SIZE);
-	if (ioport_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_IOPORT_AREA");
-
-	mmio_addr = allocator_alloc(lomap_allocator, ARM_MMIO_SIZE);
-	if (mmio_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_MMIO_AREA");
-	mmio_allocator = allocator_create(mmio_addr, ARM_MMIO_SIZE);
-
-	pci_cfg_addr = allocator_alloc(lomap_allocator, PCI_CFG_SIZE);
-	if (pci_cfg_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_PCI_CFG_AREA");
-
-	pci_mmio_addr = allocator_alloc(lomap_allocator, ARM_PCI_MMIO_SIZE);
-	if (pci_mmio_addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate KVM_PCI_MMIO_AREA");
-	pci_mmio_allocator = allocator_create(pci_mmio_addr, ARM_PCI_MMIO_SIZE);
-}
-
-static void init_ram(struct kvm *kvm)
-{
-	int err;
-	u64 phys_start, phys_size;
-	void *host_mem;
-	unsigned long alignment;
-	/* Convenience aliases */
-	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
-
-	/*
-	 * Allocate guest memory. If the user wants to use hugetlbfs, then the
-	 * specified guest memory size must be a multiple of the host huge page
-	 * size in order for the allocation to succeed. The mmap return adress
-	 * is naturally aligned to the huge page size, so in this case we don't
-	 * need to perform any alignment.
-	 *
-	 * Otherwise, we must align our buffer to 64K to correlate with the
-	 * maximum guest page size for virtio-mmio. If using THP, then our
-	 * minimal alignment becomes 2M with a 4K page size. With a 16K page
-	 * size, the alignment becomes 32M. 32M and 2M trump 64K, so let's go
-	 * with the largest alignment supported by the host.
-	 */
-	if (hugetlbfs_path) {
-		/* Don't do any alignment. */
-		alignment = 0;
-	} else {
-		if (sysconf(_SC_PAGESIZE) == SZ_16K)
-			alignment = SZ_32M;
-		else
-			alignment = SZ_2M;
-	}
-
-	kvm->ram_size = kvm->cfg.ram_size;
-	kvm->arch.ram_alloc_size = kvm->ram_size + alignment;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
-						kvm->arch.ram_alloc_size);
-
-	if (kvm->arch.ram_alloc_start == MAP_FAILED)
-		die("Failed to map %lld bytes for guest memory (%d)",
-		    kvm->arch.ram_alloc_size, errno);
-
-	kvm->ram_start = kvm->arch.ram_alloc_start;
-	/* The result of aligning to 0 is 0. Let's avoid that. */
-	if (alignment)
-		kvm->ram_start = (void *)ALIGN((unsigned long)kvm->ram_start,
-					       alignment);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_HUGEPAGE);
-
-	phys_start 	= kvm->cfg.ram_base;
-	phys_size	= kvm->ram_size;
-	host_mem	= kvm->ram_start;
-
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
-	if (err)
-		die("Failed to register %lld bytes of memory at physical "
-		    "address 0x%llx [err %d]", phys_size, phys_start, err);
-
-	kvm->arch.memory_guest_start = phys_start;
-}
-
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
-	allocator_destroy(mmio_allocator);
-	allocator_destroy(pci_mmio_allocator);
-	allocator_destroy(lomap_allocator);
-}
-
 void kvm__arch_read_term(struct kvm *kvm)
 {
 	serial8250__update_consoles(kvm);
@@ -158,24 +40,12 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
 {
-	if (cfg->ram_base == INVALID_MEM_ADDR)
-		cfg->ram_base = ARM_MEMORY_AREA;
-
-	if (cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
-		cfg->ram_base = ARM_MEMORY_AREA;
-		pr_warning("Changing RAM base to 0x%llx", cfg->ram_base);
-	}
-
-	if (cfg->ram_base + cfg->ram_size > ARM_MAX_ADDR(cfg)) {
-		cfg->ram_size = ARM_MAX_ADDR(cfg) - cfg->ram_base;
-		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
-	}
+	memory_sanitize_cfg(cfg);
 }
 
 void kvm__arch_init(struct kvm *kvm)
 {
-	init_ram(kvm);
-	init_mmio_mem(kvm);
+	memory_init(kvm);
 
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
@@ -331,37 +201,3 @@ int kvm__arch_setup_firmware(struct kvm *kvm)
 {
 	return 0;
 }
-
-u32 kvm__arch_alloc_mmio_block(u32 size)
-{
-	unsigned long addr;
-
-	assert(mmio_allocator);
-
-	addr = allocator_alloc(mmio_allocator, size);
-	if (addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate a MMIO block");
-
-	/*
-	 * The allocator memory lives entirely below 4G on both arm and arm64,
-	 * so the cast is safe to do.
-	 */
-	return (u32)addr;
-}
-
-u32 kvm__arch_alloc_pci_mmio_block(u32 size)
-{
-	unsigned long addr;
-
-	assert(pci_mmio_allocator);
-
-	addr = allocator_alloc_align(pci_mmio_allocator, size, size);
-	if (addr == ALLOC_INVALID_ADDR)
-		die("Not enough memory to allocate a PCI MMIO block");
-
-	/*
-	 * The allocator memory lives entirely below 4G on both arm and arm64,
-	 * so the cast is safe to do.
-	 */
-	return (u32)addr;
-}
diff --git a/arm/memory.c b/arm/memory.c
new file mode 100644
index 000000000000..39ed9e224c72
--- /dev/null
+++ b/arm/memory.c
@@ -0,0 +1,182 @@
+#include "kvm/kvm.h"
+
+#include "arm-common/allocator.h"
+#include "arm-common/memory.h"
+
+#include <linux/types.h>
+
+#include <assert.h>
+
+u64 ioport_addr = ALLOC_INVALID_ADDR;
+u64 mmio_addr = ALLOC_INVALID_ADDR;
+u64 pci_cfg_addr = ALLOC_INVALID_ADDR;
+u64 pci_mmio_addr = ALLOC_INVALID_ADDR;
+
+static struct allocator *lomap_allocator;
+static struct allocator *mmio_allocator;
+static struct allocator *pci_mmio_allocator;
+
+void memory_sanitize_cfg(struct kvm_config *cfg)
+{
+	if (cfg->ram_base == INVALID_MEM_ADDR)
+		cfg->ram_base = ARM_MEMORY_AREA;
+
+	if (cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
+		cfg->ram_base = ARM_MEMORY_AREA;
+		pr_warning("Changing RAM base to 0x%llx", cfg->ram_base);
+	}
+
+	if (cfg->ram_base + cfg->ram_size > ARM_MAX_ADDR(cfg)) {
+		cfg->ram_size = ARM_MAX_ADDR(cfg) - cfg->ram_base;
+		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
+	}
+}
+
+static void init_mmio(struct kvm *kvm)
+{
+	u64 reserve;
+	int ret;
+
+	/* Allocate MMIO memory below 4G so 32 bit arm can use it. */
+	lomap_allocator = allocator_create(0, ARM_LOMAP_MAX_ADDR);
+
+	if (kvm->arch.memory_guest_start + kvm->ram_size > ARM_LOMAP_MAX_ADDR)
+		reserve = ARM_LOMAP_MAX_ADDR - kvm->arch.memory_guest_start;
+	else
+		reserve = kvm->ram_size;
+	ret = allocator_reserve(lomap_allocator, kvm->arch.memory_guest_start,
+				reserve);
+	if (ret)
+		die("Could not reserve RAM address space");
+
+	ioport_addr = allocator_alloc(lomap_allocator, ARM_IOPORT_SIZE);
+	if (ioport_addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate KVM_IOPORT_AREA");
+
+	mmio_addr = allocator_alloc(lomap_allocator, ARM_MMIO_SIZE);
+	if (mmio_addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate KVM_MMIO_AREA");
+	mmio_allocator = allocator_create(mmio_addr, ARM_MMIO_SIZE);
+
+	pci_cfg_addr = allocator_alloc(lomap_allocator, PCI_CFG_SIZE);
+	if (pci_cfg_addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate KVM_PCI_CFG_AREA");
+
+	pci_mmio_addr = allocator_alloc(lomap_allocator, ARM_PCI_MMIO_SIZE);
+	if (pci_mmio_addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate KVM_PCI_MMIO_AREA");
+	pci_mmio_allocator = allocator_create(pci_mmio_addr, ARM_PCI_MMIO_SIZE);
+}
+
+static void init_ram(struct kvm *kvm)
+{
+	int err;
+	u64 phys_start, phys_size;
+	void *host_mem;
+	unsigned long alignment;
+	/* Convenience aliases */
+	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
+
+	/*
+	 * Allocate guest memory. If the user wants to use hugetlbfs, then the
+	 * specified guest memory size must be a multiple of the host huge page
+	 * size in order for the allocation to succeed. The mmap return adress
+	 * is naturally aligned to the huge page size, so in this case we don't
+	 * need to perform any alignment.
+	 *
+	 * Otherwise, we must align our buffer to 64K to correlate with the
+	 * maximum guest page size for virtio-mmio. If using THP, then our
+	 * minimal alignment becomes 2M with a 4K page size. With a 16K page
+	 * size, the alignment becomes 32M. 32M and 2M trump 64K, so let's go
+	 * with the largest alignment supported by the host.
+	 */
+	if (hugetlbfs_path) {
+		/* Don't do any alignment. */
+		alignment = 0;
+	} else {
+		if (sysconf(_SC_PAGESIZE) == SZ_16K)
+			alignment = SZ_32M;
+		else
+			alignment = SZ_2M;
+	}
+
+	kvm->ram_size = kvm->cfg.ram_size;
+	kvm->arch.ram_alloc_size = kvm->ram_size + alignment;
+	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
+						kvm->arch.ram_alloc_size);
+
+	if (kvm->arch.ram_alloc_start == MAP_FAILED)
+		die("Failed to map %lld bytes for guest memory (%d)",
+		    kvm->arch.ram_alloc_size, errno);
+
+	kvm->ram_start = kvm->arch.ram_alloc_start;
+	/* The result of aligning to 0 is 0. Let's avoid that. */
+	if (alignment)
+		kvm->ram_start = (void *)ALIGN((unsigned long)kvm->ram_start,
+					       alignment);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_MERGEABLE);
+
+	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+		MADV_HUGEPAGE);
+
+	phys_start 	= kvm->cfg.ram_base;
+	phys_size	= kvm->ram_size;
+	host_mem	= kvm->ram_start;
+
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	if (err)
+		die("Failed to register %lld bytes of memory at physical "
+		    "address 0x%llx [err %d]", phys_size, phys_start, err);
+
+	kvm->arch.memory_guest_start = phys_start;
+}
+
+void memory_init(struct kvm *kvm)
+{
+	init_ram(kvm);
+	init_mmio(kvm);
+}
+
+void kvm__arch_delete_ram(struct kvm *kvm)
+{
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+	allocator_destroy(mmio_allocator);
+	allocator_destroy(pci_mmio_allocator);
+	allocator_destroy(lomap_allocator);
+}
+
+u32 kvm__arch_alloc_mmio_block(u32 size)
+{
+	unsigned long addr;
+
+	assert(mmio_allocator);
+
+	addr = allocator_alloc(mmio_allocator, size);
+	if (addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate a MMIO block");
+
+	/*
+	 * The allocator memory lives entirely below 4G on both arm and arm64,
+	 * so the cast is safe to do.
+	 */
+	return (u32)addr;
+}
+
+u32 kvm__arch_alloc_pci_mmio_block(u32 size)
+{
+	unsigned long addr;
+
+	assert(pci_mmio_allocator);
+
+	addr = allocator_alloc_align(pci_mmio_allocator, size, size);
+	if (addr == ALLOC_INVALID_ADDR)
+		die("Not enough memory to allocate a PCI MMIO block");
+
+	/*
+	 * The allocator memory lives entirely below 4G on both arm and arm64,
+	 * so the cast is safe to do.
+	 */
+	return (u32)addr;
+}
-- 
2.7.4

