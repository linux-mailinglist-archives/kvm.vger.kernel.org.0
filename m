Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6256942A2
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjBMKS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjBMKSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75A1F126D8
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:31 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED1971EA6;
        Mon, 13 Feb 2023 02:19:13 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 797363F703;
        Mon, 13 Feb 2023 02:18:30 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 23/30] arm64: Add a setup sequence for systems that boot through EFI
Date:   Mon, 13 Feb 2023 10:17:52 +0000
Message-Id: <20230213101759.2577077-24-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change implements an alternative setup sequence for the system
when we are booting through EFI. The memory map is discovered through
EFI boot services and devices through ACPI.

This change is based on a change initially proposed by
Andrew Jones <drjones@redhat.com>

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart.S        |   1 +
 arm/cstart64.S      |   1 +
 lib/arm/asm/setup.h |   8 ++
 lib/arm/setup.c     | 181 +++++++++++++++++++++++++++++++++++++++++++-
 lib/linux/efi.h     |   1 +
 5 files changed, 190 insertions(+), 2 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67f..3dd71ed9 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -242,6 +242,7 @@ asm_mmu_disable:
  *
  * Input r0 is the stack top, which is the exception stacks base
  */
+.globl exceptions_init
 exceptions_init:
 	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
 	bic	r2, #CR_V		@ SCTLR.V := 0
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06..223c1092 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -265,6 +265,7 @@ asm_mmu_disable:
  * Vectors
  */
 
+.globl exceptions_init
 exceptions_init:
 	adrp	x4, vector_table
 	add	x4, x4, :lo12:vector_table
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 64cd379b..06069116 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -38,4 +38,12 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
 
 void setup(const void *fdt, phys_addr_t freemem_start);
 
+#ifdef CONFIG_EFI
+
+#include <efi.h>
+
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
+
+#endif
+
 #endif /* _ASMARM_SETUP_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 03a4098e..cab19b1e 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -33,7 +33,7 @@
 #define NR_EXTRA_MEM_REGIONS	16
 #define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
-extern unsigned long _etext;
+extern unsigned long _text, _etext, _data, _edata;
 
 char *initrd;
 u32 initrd_size;
@@ -43,7 +43,10 @@ int nr_cpus;
 
 static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
 struct mem_region *mem_regions = __initial_mem_regions;
-phys_addr_t __phys_offset, __phys_end;
+phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
+
+extern void exceptions_init(void);
+extern void asm_mmu_disable(void);
 
 int mpidr_to_cpu(uint64_t mpidr)
 {
@@ -289,3 +292,177 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
 }
+
+#ifdef CONFIG_EFI
+
+#include <efi.h>
+
+static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_status_t status;
+	struct acpi_table_rsdp *rsdp;
+
+	/*
+	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
+	 * by kvm-unit-tests arm64 memory allocator. So it is not necessary to
+	 * copy the data structure to another memory region to prevent
+	 * unintentional overwrite.
+	 */
+	status = efi_get_system_config_table(ACPI_20_TABLE_GUID, (void **)&rsdp);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	set_efi_rsdp(rsdp);
+
+	return EFI_SUCCESS;
+}
+
+static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
+{
+	int i;
+	unsigned long free_mem_pages = 0;
+	unsigned long free_mem_start = 0;
+	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
+	efi_memory_desc_t *buffer = *map->map;
+	efi_memory_desc_t *d = NULL;
+	phys_addr_t base, top;
+	struct mem_region *r;
+	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
+	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
+
+	/*
+	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
+	 * which will be used to set up the memory allocator, so that
+	 * the memory allocator can work in the largest free
+	 * continuous memory region.
+	 */
+	for (i = 0, r = &mem_regions[0]; i < *(map->map_size); i += *(map->desc_size), ++r) {
+		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
+
+		r->start = d->phys_addr;
+		r->end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
+
+		switch (d->type) {
+		case EFI_RESERVED_TYPE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_RUNTIME_SERVICES_CODE:
+		case EFI_RUNTIME_SERVICES_DATA:
+		case EFI_UNUSABLE_MEMORY:
+		case EFI_ACPI_RECLAIM_MEMORY:
+		case EFI_ACPI_MEMORY_NVS:
+		case EFI_PAL_CODE:
+			r->flags = MR_F_RESERVED;
+			break;
+		case EFI_MEMORY_MAPPED_IO:
+		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
+			r->flags = MR_F_IO;
+			break;
+		case EFI_LOADER_CODE:
+			if (r->start <= text && r->end > text) {
+				/* This is the unit test region. Flag the code separately. */
+				phys_addr_t tmp = r->end;
+
+				assert(etext <= data);
+				assert(edata <= r->end);
+				r->flags = MR_F_CODE;
+				r->end = data;
+				++r;
+				r->start = data;
+				r->end = tmp;
+			} else {
+				r->flags = MR_F_RESERVED;
+			}
+			break;
+		case EFI_CONVENTIONAL_MEMORY:
+			if (free_mem_pages < d->num_pages) {
+				free_mem_pages = d->num_pages;
+				free_mem_start = d->phys_addr;
+			}
+			break;
+		}
+
+		if (!(r->flags & MR_F_IO)) {
+			if (r->start < __phys_offset)
+				__phys_offset = r->start;
+			if (r->end > __phys_end)
+				__phys_end = r->end;
+		}
+	}
+	__phys_end &= PHYS_MASK;
+	asm_mmu_disable();
+
+	if (free_mem_pages == 0)
+		return EFI_OUT_OF_RESOURCES;
+
+	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
+
+	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
+	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top = top & PAGE_MASK;
+	assert(sizeof(long) == 8 || !(base >> 32));
+	if (sizeof(long) != 8 && (top >> 32) != 0)
+		top = ((uint64_t)1 << 32);
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
+
+	return EFI_SUCCESS;
+}
+
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_status_t status;
+
+	struct thread_info *ti = current_thread_info();
+
+	memset(ti, 0, sizeof(*ti));
+
+	exceptions_init();
+
+	status = efi_mem_init(efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to initialize memory: ");
+		switch (status) {
+		case EFI_OUT_OF_RESOURCES:
+			printf("No free memory region\n");
+			break;
+		default:
+			printf("Unknown error\n");
+			break;
+		}
+		return status;
+	}
+
+	status = setup_rsdp(efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Cannot find RSDP in EFI system table\n");
+		return status;
+	}
+
+	psci_set_conduit();
+	cpu_init();
+	/* cpu_init must be called before thread_info_init */
+	thread_info_init(current_thread_info(), 0);
+	/* mem_init must be called before io_init */
+	io_init();
+
+	timer_save_state();
+	if (initrd) {
+		/* environ is currently the only file in the initrd */
+		char *env = malloc(initrd_size);
+
+		memcpy(env, initrd, initrd_size);
+		setup_env(env, initrd_size);
+	}
+
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		setup_vm();
+
+	return EFI_SUCCESS;
+}
+
+#endif
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 53748dd4..89f9a9e0 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -63,6 +63,7 @@ typedef guid_t efi_guid_t;
 	(c) & 0xff, ((c) >> 8) & 0xff, d } }
 
 #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
 
 #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 
-- 
2.25.1

