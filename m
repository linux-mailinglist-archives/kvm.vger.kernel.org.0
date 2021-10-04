Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C14218AA
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbhJDUvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbhJDUvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315DDC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h1so4850031pfv.12
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hbxdixGOhL1Yj10MTwZ7tyD6Xe68ywa+lhDixo0V7Ik=;
        b=eE/lUlC8Qk4ZntL1lZgNtpW7yBFVp5VNLkyce3RlsS0iouQhyWKHANSE7JODg6yCFz
         zE+NsaTeM9gECYM5NdgwMvUUnnb6WkPqF6M/ifo7v4vQoX5jft9hdd5OLPhpNAli6u2L
         ISzr/iGWYUlD5AXcSM6Lve/xkd85rQD0/otYvxhMzqnNAv8T7madjERVT/DugioG3s5G
         q8+pb9fHRi6OTtgGeeveQIT5jkbDPqwEvU1VucyfNvhHtKUJ3IkZHNpCQpA8yKDRct8e
         glAHUpVcmy7uAEL8CH1HK9tuSEUzsyL6/MJ3P8T+wsxA73d91b6Ozwg4VRVn6PgFMxzY
         7nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hbxdixGOhL1Yj10MTwZ7tyD6Xe68ywa+lhDixo0V7Ik=;
        b=l5Roz+Wm+O/3EnpX4AagaAOxuPsMJUsjNiFzFF7NHDRTsz3ksOXpVBRBhcg2bdYiwC
         C6UGJbKS44yEg00GLu7tkH3y6Od1pI3b7LtMCUVI6nPm/It+502RmpAwwvR8o4n0s2hw
         GnCea0606gj/cWy21AMftEHf1B2uPvI56v/1QoayXAM21uRh/tNIoMw+4H8H6Ma6Jvho
         JdL84XqM4s1JkDLtukNvTn98vr36fvQIu9I2mzTpmxWhrM/AuQOTA7KyxCjMM9MhV6mn
         c/Ci2IJhglbS/2Lcp13GZAAyRKLtGr88C6ht3g1WgVyoswHt0wQ92izOZ8jIOGFWNpGQ
         AtoA==
X-Gm-Message-State: AOAM533DXOPYtJEIdxbAt+AVRSTe6PLFx6yaZD4s4YB1SPKj/xDiW/qw
        4yqUA0gsLciRzILYibDaX+jMZrs7RjLNAQ==
X-Google-Smtp-Source: ABdhPJx7XjC/+bV0xB9zEBZN7+IvrxbwzTdFAo88x3F39WXjVh2G5bsepVNfiNZs+VCFAZxVyNB/Jw==
X-Received: by 2002:a63:2361:: with SMTP id u33mr12588362pgm.369.1633380587301;
        Mon, 04 Oct 2021 13:49:47 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:46 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 09/17] x86 UEFI: Set up RSDP after UEFI boot up
Date:   Mon,  4 Oct 2021 13:49:23 -0700
Message-Id: <20211004204931.1537823-10-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

Root system description pointer (RSDP) is a data structure used in the
ACPI programming interface. In BIOS, RSDP is located within a
predefined memory area, so a program can scan the memory area and find
RSDP. But in UEFI, RSDP may not appear in that memory area, instead, a
program should find it in the EFI system table.

This commit provides RSDP set up code in UEFI:
   1. Read RSDP from EFI system table
   2. Pass RSDP pointer to find_acpi_table_attr() function

From this commit, the `x86/s3.c` test can run in UEFI and generates
similar output as in Seabios, note that:
   1. In its output, memory addresses are different than Seabios's, this
      is because EFI application starts from a dynamic runtime address,
      not a fixed predefined memory address
   2. There is a short delay (~5 secs) after the test case prints "PM1a
      event registers" line. This test case sleeps for a few seconds
      and then wakes up, so give it a few seconds to run.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/efi.c           | 15 +++++++++++++++
 lib/efi.h           |  1 +
 lib/linux/efi.h     | 15 +++++++++++++++
 lib/x86/acpi.c      | 38 +++++++++++++++++++++++++++++++-------
 lib/x86/acpi.h      | 11 +++++++++++
 lib/x86/asm/setup.h |  2 ++
 lib/x86/setup.c     | 13 +++++++++++++
 7 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index c1c3806..9506830 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -70,6 +70,21 @@ efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
 	return efi_bs_call(exit_boot_services, handle, mapkey);
 }
 
+efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table)
+{
+	size_t i;
+	efi_config_table_t *tables;
+
+	tables = (efi_config_table_t *)efi_system_table->tables;
+	for (i = 0; i < efi_system_table->nr_tables; i++) {
+		if (!memcmp(&table_guid, &tables[i].guid, sizeof(efi_guid_t))) {
+			*table = tables[i].table;
+			return EFI_SUCCESS;
+		}
+	}
+	return EFI_NOT_FOUND;
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
diff --git a/lib/efi.h b/lib/efi.h
index 0f1dafd..1b3abd0 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -16,6 +16,7 @@
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
 efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
+efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table);
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 
 #endif /* _EFI_H_ */
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 3d68c28..7ac1082 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -58,6 +58,21 @@ typedef guid_t efi_guid_t;
 	(b) & 0xff, ((b) >> 8) & 0xff,						\
 	(c) & 0xff, ((c) >> 8) & 0xff, d } }
 
+#define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+
+typedef struct {
+	efi_guid_t guid;
+	u32 table;
+} efi_config_table_32_t;
+
+typedef union {
+	struct {
+		efi_guid_t guid;
+		void *table;
+	};
+	efi_config_table_32_t mixed_mode;
+} efi_config_table_t;
+
 /*
  * Generic EFI table header
  */
diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
index 4373106..0f75d79 100644
--- a/lib/x86/acpi.c
+++ b/lib/x86/acpi.c
@@ -1,9 +1,37 @@
 #include "libcflat.h"
 #include "acpi.h"
 
+#ifdef TARGET_EFI
+struct rsdp_descriptor *efi_rsdp = NULL;
+
+void setup_efi_rsdp(struct rsdp_descriptor *rsdp) {
+	efi_rsdp = rsdp;
+}
+
+static struct rsdp_descriptor *get_rsdp(void) {
+	if (efi_rsdp == NULL) {
+		printf("Can't find RSDP from UEFI, maybe setup_efi_rsdp() was not called\n");
+	}
+	return efi_rsdp;
+}
+#else
+static struct rsdp_descriptor *get_rsdp(void) {
+    struct rsdp_descriptor *rsdp;
+    unsigned long addr;
+    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
+	rsdp = (void*)addr;
+	if (rsdp->signature == RSDP_SIGNATURE_8BYTE)
+          break;
+    }
+    if (addr == 0x100000) {
+        return NULL;
+    }
+    return rsdp;
+}
+#endif /* TARGET_EFI */
+
 void* find_acpi_table_addr(u32 sig)
 {
-    unsigned long addr;
     struct rsdp_descriptor *rsdp;
     struct rsdt_descriptor_rev1 *rsdt;
     void *end;
@@ -19,12 +47,8 @@ void* find_acpi_table_addr(u32 sig)
         return (void*)(ulong)fadt->firmware_ctrl;
     }
 
-    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
-	rsdp = (void*)addr;
-	if (rsdp->signature == 0x2052545020445352LL)
-          break;
-    }
-    if (addr == 0x100000) {
+    rsdp = get_rsdp();
+    if (rsdp == NULL) {
         printf("Can't find RSDP\n");
         return 0;
     }
diff --git a/lib/x86/acpi.h b/lib/x86/acpi.h
index 1b80374..db8ee56 100644
--- a/lib/x86/acpi.h
+++ b/lib/x86/acpi.h
@@ -11,6 +11,13 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
+
+#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
+	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |       \
+	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
+
+#define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
+
 struct rsdp_descriptor {        /* Root System Descriptor Pointer */
     u64 signature;              /* ACPI signature, contains "RSD PTR " */
     u8  checksum;               /* To make sum of struct == 0 */
@@ -101,4 +108,8 @@ struct facs_descriptor_rev1
 
 void* find_acpi_table_addr(u32 sig);
 
+#ifdef TARGET_EFI
+void setup_efi_rsdp(struct rsdp_descriptor *rsdp);
+#endif /* TARGET_EFI */
+
 #endif
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 3f0a870..ecfcd5c 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -6,6 +6,7 @@ unsigned long setup_tss(void);
 #endif /* __x86_64__ */
 
 #ifdef TARGET_EFI
+#include "x86/acpi.h"
 #include "x86/apic.h"
 #include "x86/smp.h"
 #include "efi.h"
@@ -19,6 +20,7 @@ unsigned long setup_tss(void);
 typedef struct {
 	phys_addr_t free_mem_start;
 	phys_addr_t free_mem_size;
+	struct rsdp_descriptor *rsdp;
 } efi_bootinfo_t;
 
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 90f95a3..6d81ab6 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -171,6 +171,7 @@ void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_bootinfo->free_mem_size = 0;
 	efi_bootinfo->free_mem_start = 0;
+	efi_bootinfo->rsdp = NULL;
 }
 
 static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
@@ -221,6 +222,11 @@ static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t
 	return EFI_SUCCESS;
 }
 
+static efi_status_t setup_pre_boot_rsdp(efi_bootinfo_t *efi_bootinfo)
+{
+	return efi_get_system_config_table(ACPI_TABLE_GUID, (void **)&efi_bootinfo->rsdp);
+}
+
 efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
@@ -239,6 +245,12 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
 		return status;
 	}
 
+	status = setup_pre_boot_rsdp(efi_bootinfo);
+	if (status != EFI_SUCCESS) {
+		printf("Cannot find RSDP in EFI system table\n");
+		return status;
+	}
+
 	return EFI_SUCCESS;
 }
 
@@ -261,6 +273,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	enable_x2apic();
 	smp_init();
 	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
+	setup_efi_rsdp(efi_bootinfo->rsdp);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0

