Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD98ABB57A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfIWNfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:54 -0400
Received: from foss.arm.com ([217.140.110.172]:42388 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730351AbfIWNfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B03C1597;
        Mon, 23 Sep 2019 06:35:53 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF81B3F694;
        Mon, 23 Sep 2019 06:35:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 13/16] arm: Allow any base address for RAM
Date:   Mon, 23 Sep 2019 14:35:19 +0100
Message-Id: <1569245722-23375-14-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ARM memory layout is fixed: the guest RAM must start at an address
higher or equal to 2G, the ioport area is a between 0 and 64K, the MMIO
space lives above it and PCI is situated between 1G and 2G. However, when
it comes to real hardware, there is a wide range of different memory
layouts.

Let's be more flexible with the way we construct the memory layout for the
guest. Introduce a memory allocator which will be used for allocating
chunks from the guest address space for the different memory regions based
on their size and remaining memory.

Special care has been taken to keep the current behavior as much as
possible. The memory allocator allocates consecutive memory chunks where
possible, and if the guest RAM is situated above 2G, the current layout is
mostly preserved. The only difference is in the location of the GIC
components: instead of being at the top of the MMIO address space
(immediately below 1G), they are now at the bottom (directly above the
ioport space).

Because of the default sizes for the various MMIO regions, there are
limitations to what an user can specify. The most restrictive requirement
is that there needs to be enough space in the lower 4G memory region to
allocate one contiguous chunks of approximately 1G for MMIO and another one
for PCI MMIO.

We've also taken this opportunity to remove the unused include assert.h
from pci.c.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile                           |   2 +-
 arm/allocator.c                    | 150 +++++++++++++++++++++++++++++++++++++
 arm/gic.c                          |  30 +++++---
 arm/include/arm-common/allocator.h |  25 +++++++
 arm/include/arm-common/kvm-arch.h  |  52 ++++++-------
 arm/kvm.c                          |  94 ++++++++++++++++++++++-
 pci.c                              |   8 +-
 virtio/mmio.c                      |   7 ++
 8 files changed, 324 insertions(+), 44 deletions(-)
 create mode 100644 arm/allocator.c
 create mode 100644 arm/include/arm-common/allocator.h

diff --git a/Makefile b/Makefile
index b76d844f2e01..0ae52c6ad88b 100644
--- a/Makefile
+++ b/Makefile
@@ -158,7 +158,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/pmu.o arm/allocator.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/allocator.c b/arm/allocator.c
new file mode 100644
index 000000000000..301f4975c305
--- /dev/null
+++ b/arm/allocator.c
@@ -0,0 +1,150 @@
+#include "kvm/kvm.h"
+#include "kvm/virtio-mmio.h"
+
+#include "arm-common/allocator.h"
+
+#include <linux/list.h>
+#include <linux/sizes.h>
+
+#include <stdlib.h>
+#include <assert.h>
+
+struct mem_region {
+	u64 start;
+	u64 size;
+	struct list_head list;
+};
+
+struct allocator *allocator_create(u64 start, u64 size)
+{
+	struct allocator *allocator;
+	struct mem_region *chunk;
+
+	allocator = calloc(1, sizeof(*allocator));
+	if (!allocator)
+		die_perror("calloc");
+
+	chunk = calloc(1, sizeof(*chunk));
+	if (!chunk)
+		die_perror("calloc");
+
+	assert(size != 0);
+
+	allocator->start = start;
+	allocator->size = size;
+	INIT_LIST_HEAD(&allocator->freelist);
+
+	chunk->start = start;
+	chunk->size = size;
+	list_add(&chunk->list, &allocator->freelist);
+
+	return allocator;
+}
+
+int allocator_reserve(struct allocator *allocator,
+		       u64 start, u64 size)
+{
+	struct mem_region *pos;
+	struct mem_region *chunk = NULL;
+	struct mem_region *new_chunk;
+	unsigned long limit;
+
+	if (start < allocator->start ||
+	    start + size > allocator->start + allocator->size)
+		return 1;
+
+	limit = start + size;
+
+	list_for_each_entry(pos, &allocator->freelist, list)
+		if (start >= pos->start && limit <= pos->start + pos->size) {
+			chunk = pos;
+			break;
+		}
+
+	if (!chunk)
+		return 1;
+
+	if (start == chunk->start) {
+		chunk->size = chunk->start + chunk->size - limit;
+		chunk->start = limit;
+
+		if (chunk->size == 0) {
+			list_del(&chunk->list);
+			free(chunk);
+		}
+	} else {
+		new_chunk = calloc(1, sizeof(*chunk));
+		if (!new_chunk)
+			die_perror("calloc");
+		new_chunk->start = limit;
+		new_chunk->size = chunk->start + chunk->size - limit;
+		list_add(&new_chunk->list, &chunk->list);
+
+		chunk->size = start - chunk->start;
+	}
+
+	return 0;
+}
+
+u64 allocator_alloc_align(struct allocator *allocator,
+			  u64 size, unsigned long alignment)
+{
+	struct mem_region *pos;
+	struct mem_region *chunk = NULL;
+	unsigned long start, limit;
+	unsigned long addr;
+
+	list_for_each_entry(pos, &allocator->freelist, list) {
+		start = ALIGN(pos->start, alignment);
+		limit = start + size;
+		if (limit <= pos->start + pos->size) {
+			chunk = pos;
+			break;
+		}
+	}
+
+	if (!chunk)
+		return ALLOC_INVALID_ADDR;
+
+	addr = start;
+
+	chunk->size = chunk->start + chunk->size - limit;
+	chunk->start = limit;
+
+	if (chunk->size == 0) {
+		list_del(&pos->list);
+		free(pos);
+	}
+
+	return addr;
+}
+
+u64 allocator_alloc(struct allocator *allocator, u64 size)
+{
+	return allocator_alloc_align(allocator, size, ALLOC_PAGE_SIZE);
+}
+
+void allocator_destroy(struct allocator *allocator)
+{
+	struct mem_region *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &allocator->freelist, list) {
+		list_del(&pos->list);
+		free(pos);
+	}
+
+	free(allocator);
+}
+
+void allocator_print(struct allocator *allocator)
+{
+	struct mem_region *pos;
+	int i = 0;
+
+	fprintf(stderr, "Allocator [0x%llx@0x%llx]:\n",
+		allocator->size, allocator->start);
+	list_for_each_entry(pos, &allocator->freelist, list) {
+		fprintf(stderr, "%3d: 0x%8llx@0x%-8llx\n", i, pos->size, pos->start);
+		i++;
+	}
+}
diff --git a/arm/gic.c b/arm/gic.c
index 26be4b4c650b..ab3245e53cab 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -13,6 +13,8 @@
 #define IRQCHIP_GIC 0
 
 static int gic_fd = -1;
+static u64 gic_dist_base;
+static u64 gic_cpu_if_base;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
 static u64 gic_msi_base;
@@ -151,19 +153,17 @@ static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
-	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
-	u64 dist_addr = ARM_GIC_DIST_BASE;
 	struct kvm_create_device gic_device = {
 		.flags	= 0,
 	};
 	struct kvm_device_attr cpu_if_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
 		.attr	= KVM_VGIC_V2_ADDR_TYPE_CPU,
-		.addr	= (u64)(unsigned long)&cpu_if_addr,
+		.addr	= (u64)(unsigned long)&gic_cpu_if_base,
 	};
 	struct kvm_device_attr dist_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
-		.addr	= (u64)(unsigned long)&dist_addr,
+		.addr	= (u64)(unsigned long)&gic_dist_base,
 	};
 	struct kvm_device_attr redist_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -230,12 +230,12 @@ static int gic__create_irqchip(struct kvm *kvm)
 		[0] = {
 			.id = KVM_VGIC_V2_ADDR_TYPE_DIST |
 			(KVM_ARM_DEVICE_VGIC_V2 << KVM_ARM_DEVICE_ID_SHIFT),
-			.addr = ARM_GIC_DIST_BASE,
+			.addr = gic_dist_base,
 		},
 		[1] = {
 			.id = KVM_VGIC_V2_ADDR_TYPE_CPU |
 			(KVM_ARM_DEVICE_VGIC_V2 << KVM_ARM_DEVICE_ID_SHIFT),
-			.addr = ARM_GIC_CPUI_BASE,
+			.addr = gic_cpu_if_base,
 		}
 	};
 
@@ -256,6 +256,10 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	enum irqchip_type try;
 	int err;
 
+	gic_dist_base = kvm__arch_alloc_mmio_block(ARM_GIC_DIST_SIZE);
+	if (type == IRQCHIP_GICV2M || type == IRQCHIP_GICV2)
+		gic_cpu_if_base = kvm__arch_alloc_mmio_block(ARM_GIC_CPUI_SIZE);
+
 	switch (type) {
 	case IRQCHIP_AUTO:
 		for (try = IRQCHIP_GICV3_ITS; try >= IRQCHIP_GICV2; try--) {
@@ -270,18 +274,20 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 		return 0;
 	case IRQCHIP_GICV2M:
 		gic_msi_size = KVM_VGIC_V2M_SIZE;
-		gic_msi_base = ARM_GIC_CPUI_BASE - gic_msi_size;
+		gic_msi_base = kvm__arch_alloc_mmio_block(gic_msi_size);
 		break;
 	case IRQCHIP_GICV2:
 		break;
 	case IRQCHIP_GICV3_ITS:
-		/* The 64K page with the doorbell is included. */
 		gic_msi_size = KVM_VGIC_V3_ITS_SIZE;
 		/* fall through */
 	case IRQCHIP_GICV3:
 		gic_redists_size = kvm->cfg.nrcpus * ARM_GIC_REDIST_SIZE;
-		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
-		gic_msi_base = gic_redists_base - gic_msi_size;
+		gic_redists_base = kvm__arch_alloc_mmio_block(gic_redists_size);
+		if (gic_msi_size == 0)
+			gic_msi_base = gic_redists_base;
+		else
+			gic_msi_base = kvm__arch_alloc_mmio_block(gic_msi_size);
 		break;
 	default:
 		return -ENODEV;
@@ -349,7 +355,7 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	const char *compatible, *msi_compatible = NULL;
 	u64 msi_prop[2];
 	u64 reg_prop[] = {
-		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
+		cpu_to_fdt64(gic_dist_base), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
 	};
 
@@ -359,7 +365,7 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		/* fall-through */
 	case IRQCHIP_GICV2:
 		compatible = "arm,cortex-a15-gic";
-		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
+		reg_prop[2] = cpu_to_fdt64(gic_cpu_if_base);
 		reg_prop[3] = cpu_to_fdt64(ARM_GIC_CPUI_SIZE);
 		break;
 	case IRQCHIP_GICV3_ITS:
diff --git a/arm/include/arm-common/allocator.h b/arm/include/arm-common/allocator.h
new file mode 100644
index 000000000000..6b649905907a
--- /dev/null
+++ b/arm/include/arm-common/allocator.h
@@ -0,0 +1,25 @@
+#ifndef ARM_COMMON_ALLOCATOR_H
+#define ARM_COMMON_ALLOCATOR_H
+
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+
+#define ALLOC_PAGE_SIZE		SZ_64K
+#define ALLOC_INVALID_ADDR	(~0ul)
+
+struct allocator {
+	struct list_head freelist;
+	u64 start;
+	u64 size;
+};
+
+struct allocator *allocator_create(u64 start, u64 size);
+void allocator_destroy(struct allocator *allocator);
+void allocator_print(struct allocator *allocator);
+int allocator_reserve(struct allocator *allocator, u64 start, u64 size);
+u64 allocator_alloc_align(struct allocator *allocator, u64 size,
+			  unsigned long alignment);
+u64 allocator_alloc(struct allocator *allocator, u64 size);
+
+#endif
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index ad1a0e6872dc..a058c550b902 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -4,46 +4,43 @@
 #include <stdbool.h>
 #include <linux/const.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 
 #include "kvm/pci.h"
 
 #include "arm-common/gic.h"
 
-#define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
-#define ARM_MMIO_AREA		_AC(0x0000000000010000, UL)
-#define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
-#define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
+extern u64 ioport_addr;
+extern u64 mmio_addr;
+extern u64 pci_cfg_addr;
+extern u64 pci_mmio_addr;
 
-#define ARM_LOMAP_MAX_ADDR	(1ULL << 32)
-#define ARM_HIMAP_MAX_ADDR	(1ULL << 40)
+#define ARM_IOPORT_SIZE		SZ_64K
+#define ARM_MMIO_SIZE		(SZ_1G - ARM_IOPORT_SIZE)
+#define ARM_PCI_MMIO_SIZE	(SZ_1G - PCI_CFG_SIZE)
 
-#define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
-#define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
-#define ARM_GIC_SIZE		(ARM_GIC_DIST_SIZE + ARM_GIC_CPUI_SIZE)
-#define ARM_GIC_DIST_SIZE	0x10000
-#define ARM_GIC_CPUI_SIZE	0x20000
+#define ARM_GIC_DIST_SIZE	SZ_64K
+#define ARM_GIC_CPUI_SIZE	SZ_128K
+/*
+ * On a GICv3 there must be one redistributor per vCPU.
+ * The value here is the size for one, we multiply this at runtime with
+ * the number of requested vCPUs to get the actual size.
+ */
+#define ARM_GIC_REDIST_SIZE	SZ_128K
 
-#define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
-#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
-#define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
-				(ARM_AXI_AREA + PCI_CFG_SIZE))
+#define KVM_IOPORT_AREA		ioport_addr
+#define KVM_MMIO_AREA		mmio_addr
+#define KVM_PCI_CFG_AREA	pci_cfg_addr
+#define KVM_PCI_MMIO_AREA	pci_mmio_addr
 
-#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
-#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
-#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + PCI_CFG_SIZE)
-#define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
+#define ARM_MEMORY_AREA		SZ_2G
+#define ARM_LOMAP_MAX_ADDR	(1ULL << 32)
+#define ARM_HIMAP_MAX_ADDR	(1ULL << 40)
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
 #define ARCH_SUPPORT_CFG_RAM_BASE	1
 
-/*
- * On a GICv3 there must be one redistributor per vCPU.
- * The value here is the size for one, we multiply this at runtime with
- * the number of requested vCPUs to get the actual size.
- */
-#define ARM_GIC_REDIST_SIZE	0x20000
-
 #define KVM_IRQ_OFFSET		GIC_SPI_IRQ_BASE
 
 #define KVM_VM_TYPE		0
@@ -81,4 +78,7 @@ struct kvm_config;
 
 void kvm__arch_sanitize_cfg(struct kvm_config *cfg);
 
+u32 kvm__arch_alloc_mmio_block(u32 size);
+u32 kvm__arch_alloc_pci_mmio_block(u32 size);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index 138ef5763cc2..a12a75d94cdd 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -4,13 +4,17 @@
 #include "kvm/8250-serial.h"
 #include "kvm/virtio-console.h"
 #include "kvm/fdt.h"
+#include "kvm/pci.h"
 
 #include "arm-common/gic.h"
+#include "arm-common/allocator.h"
 
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
 
+#include <assert.h>
+
 struct kvm_ext kvm_req_ext[] = {
 	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
 	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
@@ -18,12 +22,57 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+u64 ioport_addr = ALLOC_INVALID_ADDR;
+u64 mmio_addr = ALLOC_INVALID_ADDR;
+u64 pci_cfg_addr = ALLOC_INVALID_ADDR;
+u64 pci_mmio_addr = ALLOC_INVALID_ADDR;
+
+static struct allocator *lomap_allocator;
+static struct allocator *mmio_allocator;
+static struct allocator *pci_mmio_allocator;
+
 bool kvm__arch_cpu_supports_vm(void)
 {
 	/* The KVM capability check is enough. */
 	return true;
 }
 
+static void init_mmio_mem(struct kvm *kvm)
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
 static void init_ram(struct kvm *kvm)
 {
 	int err;
@@ -92,6 +141,9 @@ static void init_ram(struct kvm *kvm)
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
 	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+	allocator_destroy(mmio_allocator);
+	allocator_destroy(pci_mmio_allocator);
+	allocator_destroy(lomap_allocator);
 }
 
 void kvm__arch_read_term(struct kvm *kvm)
@@ -109,8 +161,7 @@ void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
 	if (cfg->ram_base == INVALID_MEM_ADDR)
 		cfg->ram_base = ARM_MEMORY_AREA;
 
-	if (cfg->ram_base < ARM_MEMORY_AREA ||
-	    cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
+	if (cfg->ram_base >= ARM_MAX_ADDR(cfg)) {
 		cfg->ram_base = ARM_MEMORY_AREA;
 		pr_warning("Changing RAM base to 0x%llx", cfg->ram_base);
 	}
@@ -123,11 +174,12 @@ void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
 
 void kvm__arch_init(struct kvm *kvm)
 {
+	init_ram(kvm);
+	init_mmio_mem(kvm);
+
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
-
-	init_ram(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
@@ -279,3 +331,37 @@ int kvm__arch_setup_firmware(struct kvm *kvm)
 {
 	return 0;
 }
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
diff --git a/pci.c b/pci.c
index 88ee78ad7d08..87c7079e0fe9 100644
--- a/pci.c
+++ b/pci.c
@@ -6,10 +6,15 @@
 #include "kvm/kvm.h"
 
 #include <linux/err.h>
-#include <assert.h>
 
 static u32 pci_config_address_bits;
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+u32 pci_get_io_space_block(u32 size)
+{
+	return kvm__arch_alloc_pci_mmio_block(size);
+}
+#else
 /* This is within our PCI gap - in an unused area.
  * Note this is a PCI *bus address*, is used to assign BARs etc.!
  * (That's why it can still 32bit even with 64bit guests-- 64bit
@@ -26,6 +31,7 @@ u32 pci_get_io_space_block(u32 size)
 	io_space_blocks = block + size;
 	return block;
 }
+#endif
 
 void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type)
 {
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 03cecc366292..9599774b825b 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -11,6 +11,12 @@
 #include <linux/virtio_mmio.h>
 #include <string.h>
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
+static u32 virtio_mmio_get_io_space_block(u32 size)
+{
+	return kvm__arch_alloc_mmio_block(size);
+}
+#else
 static u32 virtio_mmio_io_space_blocks = KVM_VIRTIO_MMIO_AREA;
 
 static u32 virtio_mmio_get_io_space_block(u32 size)
@@ -20,6 +26,7 @@ static u32 virtio_mmio_get_io_space_block(u32 size)
 
 	return block;
 }
+#endif
 
 static void virtio_mmio_ioevent_callback(struct kvm *kvm, void *param)
 {
-- 
2.7.4

