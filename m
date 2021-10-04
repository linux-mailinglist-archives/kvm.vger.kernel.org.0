Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861684218A9
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhJDUvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbhJDUvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:36 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B140CC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 145so15538117pfz.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hXwn823JQ7drM0H+obg9KOE1Pms6D1N1N6K9pRWG81k=;
        b=WoI4fBoxWE3mdyh98CyNLhDxgUAXTIh8qp7pvGV200fVCgKeYDHCxJ2FulryKtFwby
         +9pE0uNLGmu6AW5KWA+8p4Lf1ZxjPS4Ypjsfa4L7bkOTYH1gj8fjBOE1Kct9opZIBFMD
         H+FVEsEuYR2yM2mncBHwr7+CFJRiGr/dr29zeJxBwtnuu1Wqg2bxNlRcVoTq0Wef93Js
         9uT5EBgCFepFTgjH2q+BIGNDHzlEJGjFK4bZ3+7mzK4Ty/7Rzsh7Xgvis72pzQ41zj5l
         4OjMF1uhViBJE6cHmpOPYXDI+9a7WQzu2EVSMZ+ufP4lC08u3F0VivXbyLYPRoQ4LDik
         WlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hXwn823JQ7drM0H+obg9KOE1Pms6D1N1N6K9pRWG81k=;
        b=MfWsCLOSTpiZkSOG0S4e3/zZJXc1Giy0+yNj9jmtIDACB4Rkou3O2/9N02yFBCd5NA
         96DwxTtWt2xjZp7KE4gpGhHL7b9jiOQhdf8537KHs6gE2oALI5XJsm3MHyx7AI+wi1HT
         HetTYiop2aGanPdGhj9gsEbZyYldeRj+hAHPw34CY+KIxGb6Jn7gf7kJZltEhJHmx/Ax
         li3YYOzc0G3lDPnB64/EeQ9bRGfqWopfRFUUgFSU9xEAwZK+R0U47xPYrsh2iygML5pm
         j7H7rCqIE7RwFVWzIvQXBfz6lGZsaVC/ps6azlXDRMX4rgnYCQNgkxtG+IemTlL2UyNo
         DWzg==
X-Gm-Message-State: AOAM5303jbmBangRk9UnV7PJUTv6w1Menzax3rcmB6OqjztVIw+PCszO
        HIUDA0uVdEdR775GOoHaVosgsuuDEUJkrg==
X-Google-Smtp-Source: ABdhPJwPlRUm3ZP49j3nLFJ+iXgfYKTcE7KP4LkuQvcCA9ZYRIuc6bA08adbFFh9WtorOz6Dx2oGLg==
X-Received: by 2002:a63:dc03:: with SMTP id s3mr12514957pgg.88.1633380585819;
        Mon, 04 Oct 2021 13:49:45 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:45 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 08/17] x86 UEFI: Set up memory allocator
Date:   Mon,  4 Oct 2021 13:49:22 -0700
Message-Id: <20211004204931.1537823-9-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

KVM-Unit-Tests library implements a memory allocator which requires
two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
more details):
   1. A base (start) physical address
   2. Size of available memory for allocation

To get this memory info, we scan all the memory regions returned by
`LibMemoryMap()`, find out the largest free memory region and use it for
memory allocation.

After retrieving this memory info, we call `ExitBootServices` so that
KVM-Unit-Tests has full control of the machine, and UEFI will not touch
the memory after this point.

Starting from this commit, `x86/hypercall.c` test case can run in UEFI
and generates the same output as in Seabios.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/efi.c           | 28 +++++++++++++---
 lib/efi.h           |  2 +-
 lib/x86/asm/setup.h | 16 +++++++++-
 lib/x86/setup.c     | 78 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index f3214b8..c1c3806 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -30,9 +30,10 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
 	unsigned long key = 0, map_size = 0, desc_size = 0;
+	u32 desc_ver;
 
 	status = efi_bs_call(get_memory_map, &map_size,
-			     NULL, &key, &desc_size, NULL);
+			     NULL, &key, &desc_size, &desc_ver);
 	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
 		goto out;
 
@@ -49,12 +50,13 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
 
 	/* Get the map. */
 	status = efi_bs_call(get_memory_map, &map_size,
-			     m, &key, &desc_size, NULL);
+			     m, &key, &desc_size, &desc_ver);
 	if (status != EFI_SUCCESS) {
 		efi_free_pool(m);
 		goto out;
 	}
 
+	*map->desc_ver = desc_ver;
 	*map->desc_size = desc_size;
 	*map->map_size = map_size;
 	*map->key_ptr = key;
@@ -63,18 +65,34 @@ out:
 	return status;
 }
 
-efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map)
+efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
 {
-	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
+	return efi_bs_call(exit_boot_services, handle, mapkey);
 }
 
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
+	unsigned long mapkey = 0;
+	efi_status_t status;
+	efi_bootinfo_t efi_bootinfo;
 
 	efi_system_table = sys_tab;
 
-	setup_efi();
+	setup_efi_bootinfo(&efi_bootinfo);
+	status = setup_efi_pre_boot(&mapkey, &efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to set up before ExitBootServices, exiting.\n");
+		return status;
+	}
+
+	status = efi_exit_boot_services(handle, mapkey);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to exit boot services\n");
+		return status;
+	}
+
+	setup_efi(&efi_bootinfo);
 	ret = main(__argc, __argv, __environ);
 
 	/* Shutdown the guest VM */
diff --git a/lib/efi.h b/lib/efi.h
index 889de18..0f1dafd 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -15,7 +15,7 @@
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
-efi_status_t efi_exit_boot_services(void *handle, struct efi_boot_memmap *map);
+efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 
 #endif /* _EFI_H_ */
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index a1f869c..3f0a870 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -8,8 +8,22 @@ unsigned long setup_tss(void);
 #ifdef TARGET_EFI
 #include "x86/apic.h"
 #include "x86/smp.h"
+#include "efi.h"
 
-void setup_efi(void);
+/*
+ * efi_bootinfo_t: stores EFI-related machine info retrieved by
+ * setup_efi_pre_boot(), and is then used by setup_efi(). setup_efi() cannot
+ * retrieve this info as it is called after ExitBootServices and thus some EFI
+ * resources are not available.
+ */
+typedef struct {
+	phys_addr_t free_mem_start;
+	phys_addr_t free_mem_size;
+} efi_bootinfo_t;
+
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
+void setup_efi(efi_bootinfo_t *efi_bootinfo);
+efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo);
 #endif /* TARGET_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index f4f9e1b..90f95a3 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -167,6 +167,81 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 extern void load_idt(void);
 extern void load_gdt_tss(size_t tss_offset);
 
+void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
+{
+	efi_bootinfo->free_mem_size = 0;
+	efi_bootinfo->free_mem_start = 0;
+}
+
+static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	int i;
+	unsigned long free_mem_total_pages;
+	efi_status_t status;
+	struct efi_boot_memmap map;
+	efi_memory_desc_t *buffer, *d;
+	unsigned long map_size, desc_size, buff_size;
+	u32 desc_ver;
+
+	map.map = &buffer;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = &desc_ver;
+	map.buff_size = &buff_size;
+	map.key_ptr = mapkey;
+
+	status = efi_get_memory_map(&map);
+	if (status != EFI_SUCCESS) {
+		return status;
+	}
+
+	/*
+	 * The 'buffer' contains multiple descriptors that describe memory
+	 * regions maintained by UEFI. This code records the largest free
+	 * EFI_CONVENTIONAL_MEMORY region which will be used to set up the
+	 * memory allocator, so that the memory allocator can work in the
+	 * largest free continuous memory region.
+	 */
+	free_mem_total_pages = 0;
+	for (i = 0; i < map_size; i += desc_size) {
+		d = (efi_memory_desc_t *)(&((u8 *)buffer)[i]);
+		if (d->type == EFI_CONVENTIONAL_MEMORY) {
+			if (free_mem_total_pages < d->num_pages) {
+				free_mem_total_pages = d->num_pages;
+				efi_bootinfo->free_mem_size = free_mem_total_pages << EFI_PAGE_SHIFT;
+				efi_bootinfo->free_mem_start = d->phys_addr;
+			}
+		}
+	}
+
+	if (efi_bootinfo->free_mem_size == 0) {
+		return EFI_OUT_OF_RESOURCES;
+	}
+
+	return EFI_SUCCESS;
+}
+
+efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
+{
+	efi_status_t status;
+
+	status = setup_pre_boot_memory(mapkey, efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("setup_pre_boot_memory() failed: ");
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
+	return EFI_SUCCESS;
+}
+
 static void setup_gdt_tss(void)
 {
 	size_t tss_offset;
@@ -175,7 +250,7 @@ static void setup_gdt_tss(void)
 	load_gdt_tss(tss_offset);
 }
 
-void setup_efi(void)
+void setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	reset_apic();
 	setup_gdt_tss();
@@ -185,6 +260,7 @@ void setup_efi(void)
 	enable_apic();
 	enable_x2apic();
 	smp_init();
+	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0

