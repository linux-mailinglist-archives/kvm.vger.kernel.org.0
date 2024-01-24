Return-Path: <kvm+bounces-6795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAF983A2BD
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E15411C24CD0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7532317753;
	Wed, 24 Jan 2024 07:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="er/lTHav"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF0B175BB
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080743; cv=none; b=FOYohOnQOfwWGbNB/73SPByAopXmGn5S7Gtt7Cjk1FXWE7P8FQMGvdcU6w9LlQu+kTCpEMVDnfT6w993aSPNxyDCUO5IoNH49bdpw+xFi1263qJLJcrjYDSLiQ4DuWzl+FP0cGPFoG624SmtbHRM1Mf0nhyZ+ycLFMC2uUNscTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080743; c=relaxed/simple;
	bh=duK4Ky9dQS2FhCeik9mAVy94S9JGXg0B8RfICMdYtn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=YH5DvbAOOyylmTOykLxduWDWlOjYlFuxwzgvhogfwGvnz+LJdC31uJFPJC11i+DmzbBeIhjo6kcZsn1eU0ZLMRWMfHNDtZg0PSra4WF2zB7K7NVtXj3r9YWNmD29v7NNtatiNb9kaNJGe6UQ6grwDZ/RNr28NSpcJIFcR5Pie5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=er/lTHav; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Asv+zoXKPYfVzrBYoydUgmNVS1Jl74avyaKm+5exyxY=;
	b=er/lTHavoJXdTtDcyrHklwJYz+4FXVio3Q/gcHucbzkAN1dwQrtzQTz5J5tgrFV5NKXsDu
	SBkW+eCs1pLLeISDTrzllLzkBph9lH3JDlN5aMP22MNwHuIhAFFXNA4BWY1YAB7fMnTSTw
	lEcKRGnvtdzdoGNjVm35HjREnQmn7D8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 16/24] arm/arm64: Share memregions
Date: Wed, 24 Jan 2024 08:18:32 +0100
Message-ID: <20240124071815.6898-42-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

arm/arm64 (and to a small extent powerpc) have memory regions which
get built from hardware descriptions (DT/ACPI/EFI) and then used to
build page tables. Move memregions to common code, tweaking the API
a bit at the same time, e.g. change 'mem_region' to 'memregions'.
The biggest change is there is now a default number of memory regions
which, if too small, should be overridden at setup time with a new
init function, memregions_init().

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/Makefile.common |  1 +
 arm/selftest.c      |  3 +-
 lib/arm/asm/setup.h | 14 -------
 lib/arm/mmu.c       |  1 +
 lib/arm/setup.c     | 93 ++++++++++-----------------------------------
 lib/memregions.c    | 82 +++++++++++++++++++++++++++++++++++++++
 lib/memregions.h    | 29 ++++++++++++++
 7 files changed, 136 insertions(+), 87 deletions(-)
 create mode 100644 lib/memregions.c
 create mode 100644 lib/memregions.h

diff --git a/arm/Makefile.common b/arm/Makefile.common
index dc92a7433350..4dfd570fa59e 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -42,6 +42,7 @@ cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/memregions.o
 cflatobjs += lib/migrate.o
 cflatobjs += lib/on-cpus.o
 cflatobjs += lib/pci.o
diff --git a/arm/selftest.c b/arm/selftest.c
index 9f459ed3d571..007d2309d01c 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <devicetree.h>
+#include <memregions.h>
 #include <vmalloc.h>
 #include <asm/setup.h>
 #include <asm/ptrace.h>
@@ -90,7 +91,7 @@ static bool check_pabt_init(void)
 			highest_end = PAGE_ALIGN(r->end);
 	}
 
-	if (mem_region_get_flags(highest_end) != MR_F_UNKNOWN)
+	if (memregions_get_flags(highest_end) != MR_F_UNKNOWN)
 		return false;
 
 	vaddr = (unsigned long)vmap(highest_end, PAGE_SIZE);
diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index 060691165a20..9f8ef82efb90 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -13,22 +13,8 @@
 extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
 extern int nr_cpus;
 
-#define MR_F_IO			(1U << 0)
-#define MR_F_CODE		(1U << 1)
-#define MR_F_RESERVED		(1U << 2)
-#define MR_F_UNKNOWN		(1U << 31)
-
-struct mem_region {
-	phys_addr_t start;
-	phys_addr_t end;
-	unsigned int flags;
-};
-extern struct mem_region *mem_regions;
 extern phys_addr_t __phys_offset, __phys_end;
 
-extern struct mem_region *mem_region_find(phys_addr_t paddr);
-extern unsigned int mem_region_get_flags(phys_addr_t paddr);
-
 #define PHYS_OFFSET		(__phys_offset)
 #define PHYS_END		(__phys_end)
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index b16517a3200d..eb5e82a95f06 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -6,6 +6,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <cpumask.h>
+#include <memregions.h>
 #include <asm/setup.h>
 #include <asm/thread_info.h>
 #include <asm/mmu.h>
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index b6fc453e5b31..0382cbdaf5a1 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <libfdt/libfdt.h>
 #include <devicetree.h>
+#include <memregions.h>
 #include <alloc.h>
 #include <alloc_phys.h>
 #include <alloc_page.h>
@@ -31,7 +32,7 @@
 
 #define MAX_DT_MEM_REGIONS	16
 #define NR_EXTRA_MEM_REGIONS	64
-#define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
+#define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
 
 extern unsigned long _text, _etext, _data, _edata;
 
@@ -41,8 +42,7 @@ u32 initrd_size;
 u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (u64)~0 };
 int nr_cpus;
 
-static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
-struct mem_region *mem_regions = __initial_mem_regions;
+static struct mem_region arm_mem_regions[NR_MEM_REGIONS + 1];
 phys_addr_t __phys_offset = (phys_addr_t)-1, __phys_end = 0;
 
 extern void exceptions_init(void);
@@ -114,68 +114,14 @@ static void cpu_init(void)
 	set_cpu_online(0, true);
 }
 
-static void mem_region_add(struct mem_region *r)
+static void arm_memregions_add_assumed(void)
 {
-	struct mem_region *r_next = mem_regions;
-	int i = 0;
-
-	for (; r_next->end; ++r_next, ++i)
-		;
-	assert(i < NR_INITIAL_MEM_REGIONS);
-
-	*r_next = *r;
-}
-
-static void mem_regions_add_dt_regions(void)
-{
-	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
-	int nr_regs, i;
-
-	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
-	assert(nr_regs > 0);
-
-	for (i = 0; i < nr_regs; ++i) {
-		mem_region_add(&(struct mem_region){
-			.start = regs[i].addr,
-			.end = regs[i].addr + regs[i].size,
-		});
-	}
-}
-
-struct mem_region *mem_region_find(phys_addr_t paddr)
-{
-	struct mem_region *r;
-
-	for (r = mem_regions; r->end; ++r)
-		if (paddr >= r->start && paddr < r->end)
-			return r;
-	return NULL;
-}
-
-unsigned int mem_region_get_flags(phys_addr_t paddr)
-{
-	struct mem_region *r = mem_region_find(paddr);
-	return r ? r->flags : MR_F_UNKNOWN;
-}
-
-static void mem_regions_add_assumed(void)
-{
-	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
-	struct mem_region *r;
-
-	r = mem_region_find(code_end - 1);
-	assert(r);
+	struct mem_region *code, *data;
 
 	/* Split the region with the code into two regions; code and data */
-	mem_region_add(&(struct mem_region){
-		.start = code_end,
-		.end = r->end,
-	});
-	*r = (struct mem_region){
-		.start = r->start,
-		.end = code_end,
-		.flags = MR_F_CODE,
-	};
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code);
+	code->flags |= MR_F_CODE;
 
 	/*
 	 * mach-virt I/O regions:
@@ -183,10 +129,10 @@ static void mem_regions_add_assumed(void)
 	 *   - 512M at 256G (arm64, arm uses highmem=off)
 	 *   - 512G at 512G (arm64, arm uses highmem=off)
 	 */
-	mem_region_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
+	memregions_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
 #ifdef __aarch64__
-	mem_region_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
-	mem_region_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
+	memregions_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
+	memregions_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
 #endif
 }
 
@@ -197,7 +143,7 @@ static void mem_init(phys_addr_t freemem_start)
 		.start = (phys_addr_t)-1,
 	};
 
-	freemem = mem_region_find(freemem_start);
+	freemem = memregions_find(freemem_start);
 	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
 
 	for (r = mem_regions; r->end; ++r) {
@@ -212,9 +158,9 @@ static void mem_init(phys_addr_t freemem_start)
 	mem.end &= PHYS_MASK;
 
 	/* Check for holes */
-	r = mem_region_find(mem.start);
+	r = memregions_find(mem.start);
 	while (r && r->end != mem.end)
-		r = mem_region_find(r->end);
+		r = memregions_find(r->end);
 	assert(r);
 
 	/* Ensure our selected freemem range is somewhere in our full range */
@@ -263,8 +209,9 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 		freemem += initrd_size;
 	}
 
-	mem_regions_add_dt_regions();
-	mem_regions_add_assumed();
+	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
+	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
+	arm_memregions_add_assumed();
 	mem_init(PAGE_ALIGN((unsigned long)freemem));
 
 	psci_set_conduit();
@@ -371,7 +318,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 				assert(edata <= r.end);
 				r.flags = MR_F_CODE;
 				r.end = data;
-				mem_region_add(&r);
+				memregions_add(&r);
 				r.start = data;
 				r.end = tmp;
 				r.flags = 0;
@@ -393,7 +340,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 			if (r.end > __phys_end)
 				__phys_end = r.end;
 		}
-		mem_region_add(&r);
+		memregions_add(&r);
 	}
 	if (fdt) {
 		/* Move the FDT to the base of free memory */
@@ -439,6 +386,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 
 	exceptions_init();
 
+	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
+
 	status = efi_mem_init(efi_bootinfo);
 	if (status != EFI_SUCCESS) {
 		printf("Failed to initialize memory: ");
diff --git a/lib/memregions.c b/lib/memregions.c
new file mode 100644
index 000000000000..96de86b27333
--- /dev/null
+++ b/lib/memregions.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <libcflat.h>
+#include <devicetree.h>
+#include <memregions.h>
+
+static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
+static size_t nr_regions = NR_INITIAL_MEM_REGIONS;
+
+struct mem_region *mem_regions = __initial_mem_regions;
+
+void memregions_init(struct mem_region regions[], size_t nr)
+{
+	mem_regions = regions;
+	nr_regions = nr;
+}
+
+struct mem_region *memregions_add(struct mem_region *r)
+{
+	struct mem_region *r_next = mem_regions;
+	int i = 0;
+
+	for (; r_next->end; ++r_next, ++i)
+		;
+	assert(i < nr_regions);
+
+	*r_next = *r;
+
+	return r_next;
+}
+
+struct mem_region *memregions_find(phys_addr_t paddr)
+{
+	struct mem_region *r;
+
+	for (r = mem_regions; r->end; ++r)
+		if (paddr >= r->start && paddr < r->end)
+			return r;
+	return NULL;
+}
+
+uint32_t memregions_get_flags(phys_addr_t paddr)
+{
+	struct mem_region *r = memregions_find(paddr);
+
+	return r ? r->flags : MR_F_UNKNOWN;
+}
+
+void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2)
+{
+	*r1 = memregions_find(addr);
+	assert(*r1);
+
+	if ((*r1)->start == addr) {
+		*r2 = *r1;
+		*r1 = NULL;
+		return;
+	}
+
+	*r2 = memregions_add(&(struct mem_region){
+		.start = addr,
+		.end = (*r1)->end,
+		.flags = (*r1)->flags,
+	});
+
+	(*r1)->end = addr;
+}
+
+void memregions_add_dt_regions(size_t max_nr)
+{
+	struct dt_pbus_reg regs[max_nr];
+	int nr_regs, i;
+
+	nr_regs = dt_get_memory_params(regs, max_nr);
+	assert(nr_regs > 0);
+
+	for (i = 0; i < nr_regs; ++i) {
+		memregions_add(&(struct mem_region){
+			.start = regs[i].addr,
+			.end = regs[i].addr + regs[i].size,
+		});
+	}
+}
diff --git a/lib/memregions.h b/lib/memregions.h
new file mode 100644
index 000000000000..9a8e33182fe5
--- /dev/null
+++ b/lib/memregions.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MEMREGIONS_H_
+#define _MEMREGIONS_H_
+#include <libcflat.h>
+#include <bitops.h>
+
+#define NR_INITIAL_MEM_REGIONS		8
+
+#define MR_F_IO				BIT(0)
+#define MR_F_CODE			BIT(1)
+#define MR_F_RESERVED			BIT(2)
+#define MR_F_UNKNOWN			BIT(31)
+
+struct mem_region {
+	phys_addr_t start;
+	phys_addr_t end;
+	uint32_t flags;
+};
+
+extern struct mem_region *mem_regions;
+
+void memregions_init(struct mem_region regions[], size_t nr);
+struct mem_region *memregions_add(struct mem_region *r);
+struct mem_region *memregions_find(phys_addr_t paddr);
+uint32_t memregions_get_flags(phys_addr_t paddr);
+void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2);
+void memregions_add_dt_regions(size_t max_nr);
+
+#endif /* _MEMREGIONS_H_ */
-- 
2.43.0


