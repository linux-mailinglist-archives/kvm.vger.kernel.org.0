Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1451D440D48
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 06:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhJaF7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 01:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhJaF7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 01:59:12 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCDCC061570
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m21so14077850pgu.13
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 22:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3D97zzbRhx50B9t+KHBT6Rfou057pYqpsgXTZNmmL2Q=;
        b=OLjLxsupgr1lisX8eIyWTJICGMf9XtnbC04jm66olJktBl74sNSJf+HzGk/JDyWSFm
         s57iymHolC/ashRWoMR0C8Drm7fSqg4AAjZtJTUIQR7lOeH6ayuqKI2dTi9i9MLTenzv
         +ZetMO/DtZw4aPKKdPhX+LzkMMEhK4621JYHnQANVko81V8/KW9B9pYppbo2UOcdiUsa
         51EeNu+aFyjWKdxapU6GjczKJ2W5TCZrvLpPug2YBAMl7XLSNKwOr2WCl9pzDxuNVLmg
         vl04z9xlvLpnwKKBx3djjnCK9D8yvQYiOsvsSjlQO1BSaJCFqMm3yXCCFtkDkDjwRKW9
         tkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3D97zzbRhx50B9t+KHBT6Rfou057pYqpsgXTZNmmL2Q=;
        b=kFO1sv3egEyQwsO4KUv1i24O3TZqVCqowy6HQgcGWJw4PN/f2av44X6hznkDVXGe9t
         CMmuh/i1663PMQh91YTGTa9mJdP9sLxllp/H9CrE7Xhs5Lzwpy5TnPwTtYfsNhdVhOQL
         7kpG2Ltihhl67qhPgayyzU/2Q0DbRB8/xi2gpmwnmfCqcqrAO61CLPTmDHDv9adv0iqC
         p5d6M0S68pQbYV/e6/VxI4d4i6UfCFfAMU0umzrjQef15ISeNAN0vGkfh0oS6479z6oz
         PLGu6YDvdGxSMghiQSP1rZZ34ChsMC9SY+9uINVTp6ib9m0cFunuCq0PpUgHggWl7sW6
         7KtA==
X-Gm-Message-State: AOAM5311kNPE7wNlOoIACJNv18fWwIs8v3YfnczkFs0+rhDvwVfDRp31
        +bwCdMNKRhxM/ZjqjTL2+rBNjORE/NMpNA==
X-Google-Smtp-Source: ABdhPJya9OXLr1Rzx23+ZSUXNnK2CEHpZ+2Rdg2nFjW9FK+thUTgjr2DXtLj7da3kJQzvFvDkEtbVg==
X-Received: by 2002:a63:2248:: with SMTP id t8mr5633610pgm.223.1635659800110;
        Sat, 30 Oct 2021 22:56:40 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id j19sm11403179pfj.127.2021.10.30.22.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 22:56:39 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 2/7] x86 UEFI: Refactor set up process
Date:   Sat, 30 Oct 2021 22:56:29 -0700
Message-Id: <20211031055634.894263-3-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211031055634.894263-1-zxwang42@gmail.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

Refactor the EFI set up process. The previous set up process calls
multiple arch-specific functions, now it's simplified to call
only one arch-specific function:

1. (Arch neutral ) Extract EFI data structures, e.g., memory maps
2. (Arch neutral ) Exit EFI boot services
3. (Arch specific) Parse EFI data structures and set up arch-specific
                   resources
4. (Arch neutral ) Run test cases' main functions

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/efi.c           |  50 ++++++++++++---
 lib/efi.h           |  19 ++++--
 lib/x86/acpi.c      |  36 ++++++-----
 lib/x86/acpi.h      |   5 +-
 lib/x86/asm/setup.h |  16 +----
 lib/x86/setup.c     | 153 +++++++++++++++++++++-----------------------
 6 files changed, 149 insertions(+), 130 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index 9506830..99eb00c 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -65,9 +65,9 @@ out:
 	return status;
 }
 
-efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
+efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map)
 {
-	return efi_bs_call(exit_boot_services, handle, mapkey);
+	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
 }
 
 efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
@@ -88,31 +88,61 @@ efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
-	unsigned long mapkey = 0;
 	efi_status_t status;
 	efi_bootinfo_t efi_bootinfo;
 
 	efi_system_table = sys_tab;
 
-	setup_efi_bootinfo(&efi_bootinfo);
-	status = setup_efi_pre_boot(&mapkey, &efi_bootinfo);
+	/* Memory map struct values */
+	efi_memory_desc_t *map = NULL;
+	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
+	u32 desc_ver;
+
+	/* Set up efi_bootinfo */
+	efi_bootinfo.mem_map.map = &map;
+	efi_bootinfo.mem_map.map_size = &map_size;
+	efi_bootinfo.mem_map.desc_size = &desc_size;
+	efi_bootinfo.mem_map.desc_ver = &desc_ver;
+	efi_bootinfo.mem_map.key_ptr = &key;
+	efi_bootinfo.mem_map.buff_size = &buff_size;
+
+	/* Get EFI memory map */
+	status = efi_get_memory_map(&efi_bootinfo.mem_map);
 	if (status != EFI_SUCCESS) {
-		printf("Failed to set up before ExitBootServices, exiting.\n");
-		return status;
+		printf("Failed to get memory map\n");
+		goto efi_main_error;
 	}
 
-	status = efi_exit_boot_services(handle, mapkey);
+	/* 
+	 * Exit EFI boot services, let kvm-unit-tests take full control of the
+	 * guest
+	 */
+	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
 	if (status != EFI_SUCCESS) {
 		printf("Failed to exit boot services\n");
-		return status;
+		goto efi_main_error;
 	}
 
-	setup_efi(&efi_bootinfo);
+	/* Set up arch-specific resources */
+	status = setup_efi(&efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to set up arch-specific resources\n");
+		goto efi_main_error;
+	}
+
+	/* Run the test case */
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the guest VM */
 	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, ret, 0, NULL);
 
+	/* Unreachable */
+	return EFI_UNSUPPORTED;
+
+efi_main_error:
+	/* Shutdown the guest with error EFI status */
+	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, status, 0, NULL);
+
 	/* Unreachable */
 	return EFI_UNSUPPORTED;
 }
diff --git a/lib/efi.h b/lib/efi.h
index 1b3abd0..ce8b74d 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -2,9 +2,7 @@
 #define _EFI_H_
 
 /*
- * EFI-related functions in . This file's name "efi.h" is in
- * conflict with GNU-EFI library's "efi.h", but  does not include
- * GNU-EFI headers or links against GNU-EFI.
+ * EFI-related functions.
  *
  * Copyright (c) 2021, Google Inc, Zixuan Wang <zixuanwang@google.com>
  *
@@ -13,9 +11,20 @@
 #include "linux/efi.h"
 #include <elf.h>
 
-efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
+/*
+ * efi_bootinfo_t: stores EFI-related machine info retrieved before exiting EFI
+ * boot services, and is then used by setup_efi(). setup_efi() cannot retrieve
+ * this info as it is called after ExitBootServices and thus some EFI resources
+ * and functions are not available.
+ */
+typedef struct {
+	struct efi_boot_memmap mem_map;
+} efi_bootinfo_t;
+
+efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle,
+		       efi_system_table_t *sys_tab);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
-efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
+efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map);
 efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table);
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 
diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
index 0f75d79..c523dac 100644
--- a/lib/x86/acpi.c
+++ b/lib/x86/acpi.c
@@ -4,29 +4,35 @@
 #ifdef TARGET_EFI
 struct rsdp_descriptor *efi_rsdp = NULL;
 
-void setup_efi_rsdp(struct rsdp_descriptor *rsdp) {
+void set_efi_rsdp(struct rsdp_descriptor *rsdp)
+{
 	efi_rsdp = rsdp;
 }
 
-static struct rsdp_descriptor *get_rsdp(void) {
+static struct rsdp_descriptor *get_rsdp(void)
+{
 	if (efi_rsdp == NULL) {
-		printf("Can't find RSDP from UEFI, maybe setup_efi_rsdp() was not called\n");
+		printf("Can't find RSDP from UEFI, maybe set_efi_rsdp() was not called\n");
 	}
 	return efi_rsdp;
 }
 #else
-static struct rsdp_descriptor *get_rsdp(void) {
-    struct rsdp_descriptor *rsdp;
-    unsigned long addr;
-    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
-	rsdp = (void*)addr;
-	if (rsdp->signature == RSDP_SIGNATURE_8BYTE)
-          break;
-    }
-    if (addr == 0x100000) {
-        return NULL;
-    }
-    return rsdp;
+static struct rsdp_descriptor *get_rsdp(void)
+{
+	struct rsdp_descriptor *rsdp;
+	unsigned long addr;
+
+	for (addr = 0xf0000; addr < 0x100000; addr += 16) {
+		rsdp = (void *)addr;
+		if (rsdp->signature == RSDP_SIGNATURE_8BYTE)
+			break;
+	}
+
+	if (addr == 0x100000) {
+		return NULL;
+	}
+
+	return rsdp;
 }
 #endif /* TARGET_EFI */
 
diff --git a/lib/x86/acpi.h b/lib/x86/acpi.h
index db8ee56..67ba389 100644
--- a/lib/x86/acpi.h
+++ b/lib/x86/acpi.h
@@ -106,10 +106,7 @@ struct facs_descriptor_rev1
     u8  reserved3 [40];         /* Reserved - must be zero */
 };
 
+void set_efi_rsdp(struct rsdp_descriptor *rsdp);
 void* find_acpi_table_addr(u32 sig);
 
-#ifdef TARGET_EFI
-void setup_efi_rsdp(struct rsdp_descriptor *rsdp);
-#endif /* TARGET_EFI */
-
 #endif
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 73ff4a3..dbfb2a2 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -12,21 +12,7 @@ unsigned long setup_tss(u8 *stacktop);
 #include "efi.h"
 #include "x86/amd_sev.h"
 
-/*
- * efi_bootinfo_t: stores EFI-related machine info retrieved by
- * setup_efi_pre_boot(), and is then used by setup_efi(). setup_efi() cannot
- * retrieve this info as it is called after ExitBootServices and thus some EFI
- * resources are not available.
- */
-typedef struct {
-	phys_addr_t free_mem_start;
-	phys_addr_t free_mem_size;
-	struct rsdp_descriptor *rsdp;
-} efi_bootinfo_t;
-
-void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
-void setup_efi(efi_bootinfo_t *efi_bootinfo);
-efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
 #endif /* TARGET_EFI */
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 24fe74e..57b9b5e 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -173,34 +173,14 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 extern void load_idt(void);
 extern void load_gdt_tss(size_t tss_offset);
 
-void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
-{
-	efi_bootinfo->free_mem_size = 0;
-	efi_bootinfo->free_mem_start = 0;
-	efi_bootinfo->rsdp = NULL;
-}
-
-static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+static efi_status_t setup_memory_allocator(efi_bootinfo_t *efi_bootinfo)
 {
 	int i;
-	unsigned long free_mem_total_pages;
-	efi_status_t status;
-	struct efi_boot_memmap map;
-	efi_memory_desc_t *buffer, *d;
-	unsigned long map_size, desc_size, buff_size;
-	u32 desc_ver;
-
-	map.map = &buffer;
-	map.map_size = &map_size;
-	map.desc_size = &desc_size;
-	map.desc_ver = &desc_ver;
-	map.buff_size = &buff_size;
-	map.key_ptr = mapkey;
-
-	status = efi_get_memory_map(&map);
-	if (status != EFI_SUCCESS) {
-		return status;
-	}
+	unsigned long free_mem_pages = 0;
+	unsigned long free_mem_start = 0;
+	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
+	efi_memory_desc_t *buffer = *map->map;
+	efi_memory_desc_t *d = NULL;
 
 	/*
 	 * The 'buffer' contains multiple descriptors that describe memory
@@ -209,77 +189,42 @@ static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t
 	 * memory allocator, so that the memory allocator can work in the
 	 * largest free continuous memory region.
 	 */
-	free_mem_total_pages = 0;
-	for (i = 0; i < map_size; i += desc_size) {
+	for (i = 0; i < *(map->map_size); i += *(map->desc_size)) {
 		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
 		if (d->type == EFI_CONVENTIONAL_MEMORY) {
-			if (free_mem_total_pages < d->num_pages) {
-				free_mem_total_pages = d->num_pages;
-				efi_bootinfo->free_mem_size = free_mem_total_pages << EFI_PAGE_SHIFT;
-				efi_bootinfo->free_mem_start = d->phys_addr;
+			if (free_mem_pages < d->num_pages) {
+				free_mem_pages = d->num_pages;
+				free_mem_start = d->phys_addr;
 			}
 		}
 	}
 
-	if (efi_bootinfo->free_mem_size == 0) {
+	if (free_mem_pages == 0) {
 		return EFI_OUT_OF_RESOURCES;
 	}
 
-	return EFI_SUCCESS;
-}
+	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
 
-static efi_status_t setup_pre_boot_rsdp(efi_bootinfo_t *efi_bootinfo)
-{
-	return efi_get_system_config_table(ACPI_TABLE_GUID, (void **)&efi_bootinfo->rsdp);
+	return EFI_SUCCESS;
 }
 
-efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+static efi_status_t setup_rsdp(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
+	struct rsdp_descriptor *rsdp;
 
-	status = setup_pre_boot_memory(mapkey, efi_bootinfo);
-	if (status != EFI_SUCCESS) {
-		printf("setup_pre_boot_memory() failed: ");
-		switch (status) {
-		case EFI_OUT_OF_RESOURCES:
-			printf("No free memory region\n");
-			break;
-		default:
-			printf("Unknown error\n");
-			break;
-		}
-		return status;
-	}
-
-	status = setup_pre_boot_rsdp(efi_bootinfo);
+	/*
+	 * RSDP resides in an EFI_ACPI_RECLAIM_MEMORY region, which is not used
+	 * by kvm-unit-tests x86's memory allocator. So it is not necessary to
+	 * copy the data structure to another memory region to prevent
+	 * unintentional overwrite.
+	 */
+	status = efi_get_system_config_table(ACPI_TABLE_GUID, (void **)&rsdp);
 	if (status != EFI_SUCCESS) {
-		printf("Cannot find RSDP in EFI system table\n");
 		return status;
 	}
 
-	status = setup_amd_sev();
-	if (status != EFI_SUCCESS) {
-		switch (status) {
-		case EFI_UNSUPPORTED:
-			/* Continue if AMD SEV is not supported */
-			break;
-		default:
-			printf("Set up AMD SEV failed\n");
-			return status;
-		}
-	}
-
-	status = setup_amd_sev_es();
-	if (status != EFI_SUCCESS) {
-		switch (status) {
-		case EFI_UNSUPPORTED:
-			/* Continue if AMD SEV-ES is not supported */
-			break;
-		default:
-			printf("Set up AMD SEV-ES failed\n");
-			return status;
-		}
-	}
+	set_efi_rsdp(rsdp);
 
 	return EFI_SUCCESS;
 }
@@ -333,8 +278,54 @@ static void setup_gdt_tss(void)
 	load_gdt_tss(tss_offset);
 }
 
-void setup_efi(efi_bootinfo_t *efi_bootinfo)
+efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
+	efi_status_t status;
+
+	status = setup_memory_allocator(efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to set up memory allocator: ");
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
+	status = setup_amd_sev();
+	if (status != EFI_SUCCESS) {
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			/* Continue if AMD SEV is not supported */
+			break;
+		default:
+			printf("Set up AMD SEV failed\n");
+			return status;
+		}
+	}
+
+	status = setup_amd_sev_es();
+	if (status != EFI_SUCCESS) {
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			/* Continue if AMD SEV-ES is not supported */
+			break;
+		default:
+			printf("Set up AMD SEV-ES failed\n");
+			return status;
+		}
+	}
+
 	reset_apic();
 	setup_gdt_tss();
 	setup_idt();
@@ -343,9 +334,9 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	enable_apic();
 	enable_x2apic();
 	smp_init();
-	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
-	setup_efi_rsdp(efi_bootinfo->rsdp);
 	setup_page_table();
+
+	return EFI_SUCCESS;
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0

