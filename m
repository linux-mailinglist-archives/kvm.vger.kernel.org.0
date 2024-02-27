Return-Path: <kvm+bounces-10129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D65486A01B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D666229223A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09D814A0BE;
	Tue, 27 Feb 2024 19:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nm8lKdNW"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C5E148FF4
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061736; cv=none; b=DdPevM2I1CWMd53upS5/XbhjffnVMVKLKsmYrsNNKttD0sdoKic/IxPV+9GtS2rZGwhrMHxApB5z9qwwbOTScuhCepolanaBx+avQzZ/xH/u2DRYKBYtAMT4PyHjm/9UV0a+uVaXI0nT9yIz+tQnh4EXbVjyTigQXllyx2wZcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061736; c=relaxed/simple;
	bh=7Kr3plQchSMiIQYbr4wOhdln/AZYDtugEC3kA3MxMrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=hwwWbEAeFJl0oW1fH4iARNUSLj2yqfXcV1oN7IJw2+JJIMZIRRffG265ws3vxWqiyD2Mv4Aq9MY1gNBH3kK4NOJLswC/afwkbRYsh4MptAmdxaQyX4parhlSx8Y+76+cswHV/yWCUlvdW4ld8ePQddt+on5HG5h3FncZ4vOuMyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nm8lKdNW; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2T4Kqd4tvpYrB57Yd7YaZ9uYNemRTb8ajPKBpkHocx0=;
	b=Nm8lKdNWAxrIAD3y0NdAJ07lxTEjDHGkzqxj51bM8mabmFwz7SHEFKaYmo4r50ylRQ4hf9
	DWduyIqt4899DA+X+7hsNUIwlJ84XUpWYY0QqkixGsEXq1vOiFHfcw2sCt7YpVoHhkBbI1
	+ZDtowODtOWt3aVVA6tQao9lCVKDq6I=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 14/18] arm64: Add memregions_efi_init
Date: Tue, 27 Feb 2024 20:21:24 +0100
Message-ID: <20240227192109.487402-34-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Provide a memregions function which initialized memregions from an
EFI memory map. Add a new memregions flag (MR_F_PERSISTENT) for
EFI_PERSISTENT_MEMORY since that type should not be reserved, but it
should also be distinct from conventional memory. The function also
points out the largest conventional memory region by returning a
pointer to it in the freemem parameter. Immediately apply this
function to arm64's efi_mem_init(). riscv will make use of it as well.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c  | 76 ++++++++----------------------------------------
 lib/memregions.c | 51 ++++++++++++++++++++++++++++++++
 lib/memregions.h |  6 ++++
 3 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 631597b343f1..521928186fb0 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -295,58 +295,13 @@ static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
 
 static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 {
-	int i;
-	unsigned long free_mem_pages = 0;
-	unsigned long free_mem_start = 0;
-	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
-	efi_memory_desc_t *buffer = *map->map;
-	efi_memory_desc_t *d = NULL;
-	struct mem_region r, *code, *data;
-	const void *fdt = efi_bootinfo->fdt;
-
-	/*
-	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
-	 * which will be used to set up the memory allocator, so that
-	 * the memory allocator can work in the largest free
-	 * continuous memory region.
-	 */
-	for (i = 0; i < *(map->map_size); i += *(map->desc_size)) {
-		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
-
-		r.start = d->phys_addr;
-		r.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE;
-		r.flags = 0;
-
-		switch (d->type) {
-		case EFI_RESERVED_TYPE:
-		case EFI_LOADER_DATA:
-		case EFI_BOOT_SERVICES_CODE:
-		case EFI_BOOT_SERVICES_DATA:
-		case EFI_RUNTIME_SERVICES_CODE:
-		case EFI_RUNTIME_SERVICES_DATA:
-		case EFI_UNUSABLE_MEMORY:
-		case EFI_ACPI_RECLAIM_MEMORY:
-		case EFI_ACPI_MEMORY_NVS:
-		case EFI_PAL_CODE:
-			r.flags = MR_F_RESERVED;
-			break;
-		case EFI_MEMORY_MAPPED_IO:
-		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
-			r.flags = MR_F_IO;
-			break;
-		case EFI_LOADER_CODE:
-			r.flags = MR_F_CODE;
-			break;
-		case EFI_CONVENTIONAL_MEMORY:
-			if (free_mem_pages < d->num_pages) {
-				free_mem_pages = d->num_pages;
-				free_mem_start = d->phys_addr;
-			}
-			break;
-		}
+	struct mem_region *freemem_mr = NULL, *code, *data;
+	phys_addr_t freemem_start;
+	void *freemem;
 
-		memregions_add(&r);
-	}
+	memregions_efi_init(&efi_bootinfo->mem_map, &freemem_mr);
+	if (!freemem_mr)
+		return EFI_OUT_OF_RESOURCES;
 
 	memregions_split((unsigned long)&_etext, &code, &data);
 	assert(code && (code->flags & MR_F_CODE));
@@ -366,24 +321,17 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	}
 	__phys_end &= PHYS_MASK;
 
-	if (efi_bootinfo->fdt_valid) {
-		unsigned long old_start = free_mem_start;
-		void *freemem = (void *)free_mem_start;
+	freemem = (void *)PAGE_ALIGN(freemem_mr->start);
 
-		freemem_push_fdt(&freemem, fdt);
+	if (efi_bootinfo->fdt_valid)
+		freemem_push_fdt(&freemem, efi_bootinfo->fdt);
 
-		free_mem_start = ALIGN((unsigned long)freemem, EFI_PAGE_SIZE);
-		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
-	}
+	freemem_start = PAGE_ALIGN((unsigned long)freemem);
+	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
 
 	asm_mmu_disable();
 
-	if (free_mem_pages == 0)
-		return EFI_OUT_OF_RESOURCES;
-
-	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
-
-	mem_allocator_init(free_mem_start, free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
+	mem_allocator_init(freemem_start, freemem_mr->end);
 
 	return EFI_SUCCESS;
 }
diff --git a/lib/memregions.c b/lib/memregions.c
index 96de86b27333..9cdbb639ab62 100644
--- a/lib/memregions.c
+++ b/lib/memregions.c
@@ -80,3 +80,54 @@ void memregions_add_dt_regions(size_t max_nr)
 		});
 	}
 }
+
+#ifdef CONFIG_EFI
+/*
+ * Add memory regions based on the EFI memory map. Also set a pointer to the
+ * memory region which corresponds to the largest EFI_CONVENTIONAL_MEMORY
+ * region, as that region is the largest free, continuous region, making it
+ * a good choice for the memory allocator.
+ */
+void memregions_efi_init(struct efi_boot_memmap *mem_map,
+			 struct mem_region **freemem)
+{
+	u8 *buffer = (u8 *)*mem_map->map;
+	u64 freemem_pages = 0;
+
+	*freemem = NULL;
+
+	for (int i = 0; i < *mem_map->map_size; i += *mem_map->desc_size) {
+		efi_memory_desc_t *d = (efi_memory_desc_t *)&buffer[i];
+		struct mem_region r = {
+			.start = d->phys_addr,
+			.end = d->phys_addr + d->num_pages * EFI_PAGE_SIZE,
+			.flags = 0,
+		};
+
+		switch (d->type) {
+		case EFI_MEMORY_MAPPED_IO:
+		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
+			r.flags = MR_F_IO;
+			break;
+		case EFI_LOADER_CODE:
+			r.flags = MR_F_CODE;
+			break;
+		case EFI_PERSISTENT_MEMORY:
+			r.flags = MR_F_PERSISTENT;
+			break;
+		case EFI_CONVENTIONAL_MEMORY:
+			if (freemem_pages < d->num_pages) {
+				freemem_pages = d->num_pages;
+				*freemem = memregions_add(&r);
+				continue;
+			}
+			break;
+		default:
+			r.flags = MR_F_RESERVED;
+			break;
+		}
+
+		memregions_add(&r);
+	}
+}
+#endif /* CONFIG_EFI */
diff --git a/lib/memregions.h b/lib/memregions.h
index 9a8e33182fe5..1600530ad7bf 100644
--- a/lib/memregions.h
+++ b/lib/memregions.h
@@ -9,6 +9,7 @@
 #define MR_F_IO				BIT(0)
 #define MR_F_CODE			BIT(1)
 #define MR_F_RESERVED			BIT(2)
+#define MR_F_PERSISTENT			BIT(3)
 #define MR_F_UNKNOWN			BIT(31)
 
 struct mem_region {
@@ -26,4 +27,9 @@ uint32_t memregions_get_flags(phys_addr_t paddr);
 void memregions_split(phys_addr_t addr, struct mem_region **r1, struct mem_region **r2);
 void memregions_add_dt_regions(size_t max_nr);
 
+#ifdef CONFIG_EFI
+#include <efi.h>
+void memregions_efi_init(struct efi_boot_memmap *mem_map, struct mem_region **freemem);
+#endif
+
 #endif /* _MEMREGIONS_H_ */
-- 
2.43.0


