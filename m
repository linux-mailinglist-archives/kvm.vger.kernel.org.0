Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D143F92B4
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244130AbhH0DN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:27 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEA8C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:39 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id h14-20020a62b40e0000b02903131bc4a1acso1016423pfn.4
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wafX0J1iAcDNb1VM5RGEmbl1J6prBNTEbq3Ps4I44sY=;
        b=SaQjJDSXhq8hvX6H3FNhakkb3egG/AqIipM5x2jQke8kQ+wlnP2WsD7e795fYKVOI1
         QdSrBxWzQHR4A4uoEu/W5fs6f3iEvum8dmxoRsI59zU1DnvJvnu/QLsgCBi5PLQMTv6Z
         OCoTMLr5/W51PNs/WBQJVjz4LOvGN/0Tqrsyd8cJZeybhWt19eI06SSWgRgAQqYTToD+
         jRbXjgGzlfRfLsBSmlSqh0VLEXov577KXfziNSLDXP9xz4K5o7yU4SKIcM5VYT+UyYwJ
         FNql+2Nk9NrKhgBxXpcsnTYJ8XOpKnLV69OSm2J3QRoqEkCHDEvbhDz/71yg8V3Kk+qt
         Rjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wafX0J1iAcDNb1VM5RGEmbl1J6prBNTEbq3Ps4I44sY=;
        b=XMYugRZNC2vnO2xYF4VIo7EzgmUIUKt86CZWkhM5Y9HxzrTNq5O8riwVBzV4hXWi2F
         Qa547yKVx1z95BRO7JCUl+/wCInq2lzeWf12SfnzJxo3bT9lhAProtELYSkM23fozsY6
         CfxL5QxnjnMbMm0J+jApzB32qaJVdbAzofF7OHpTe6SctqykbaxKo8M0FCwgYciHqkc8
         dbg7RbztIA8B2w6YWK/TRw1ZSYQr2JS209AzzGLmlgqHuAflBXJP2PSkgSH+A5qHp7Vo
         PinUKdZcL3rkiRKJ7EbWYmMmvvtDGXVY4lnW/lUQbwSFCGgjrfgAzbuZrtwYRzC8JKV4
         RfXg==
X-Gm-Message-State: AOAM532rnS8j6XtZ1kv/Pq6SW62goB0QbLGB7hYUWyMf79KCYHMTPMfG
        ONKTmarlycH7JvXmL3IfotYlwQzLUHBg4M7G8WxUNiifXQJpcRXkebmKsTYAmulVYoRFIwieSiD
        S5CIALCW83+N9IPpH0Kk3UYp4LEyU6VCunVOzemSI4K7Jm94HJQYMpTi5LbQPEIXWNJ8x
X-Google-Smtp-Source: ABdhPJwAveJ4bj0cPWLrYTnNHCsbW/hoo27bHQfyQmw+3XMveZgp1gedd5W8VlxFY/rqvPRzbRoUP9g3xFj4qTpt
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6a00:10cb:b029:3c6:8cc9:5098 with
 SMTP id d11-20020a056a0010cbb02903c68cc95098mr6983523pfu.41.1630033959005;
 Thu, 26 Aug 2021 20:12:39 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:13 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-9-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 08/17] x86 UEFI: Set up RSDP after UEFI boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 lib/linux/uefi.h    | 15 +++++++++++++++
 lib/x86/acpi.c      | 38 +++++++++++++++++++++++++++++++-------
 lib/x86/acpi.h      | 11 +++++++++++
 lib/x86/asm/setup.h |  2 ++
 lib/x86/setup.c     | 13 +++++++++++++
 7 files changed, 88 insertions(+), 7 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index b7a69d3..a0d4476 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -69,6 +69,21 @@ efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey)
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
index 2d3772c..dbb8159 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -12,6 +12,7 @@
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_status_t efi_get_memory_map(struct efi_boot_memmap *map);
 efi_status_t efi_exit_boot_services(void *handle, unsigned long mapkey);
+efi_status_t efi_get_system_config_table(efi_guid_t table_guid, void **table);
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 
 #endif /* _EFI_H_ */
diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
index 9adc7ab..d1d599f 100644
--- a/lib/linux/uefi.h
+++ b/lib/linux/uefi.h
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
index 8ff31ef..40fd963 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -2,6 +2,7 @@
 #define _X86_ASM_SETUP_H_
 
 #ifdef TARGET_EFI
+#include "x86/acpi.h"
 #include "x86/apic.h"
 #include "x86/smp.h"
 #include "efi.h"
@@ -15,6 +16,7 @@
 typedef struct {
 	phys_addr_t free_mem_start;
 	phys_addr_t free_mem_size;
+	struct rsdp_descriptor *rsdp;
 } efi_bootinfo_t;
 
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index a49e0d4..1ddfb8c 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -135,6 +135,7 @@ void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_bootinfo->free_mem_size = 0;
 	efi_bootinfo->free_mem_start = 0;
+	efi_bootinfo->rsdp = NULL;
 }
 
 static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t *efi_bootinfo)
@@ -185,6 +186,11 @@ static efi_status_t setup_pre_boot_memory(unsigned long *mapkey, efi_bootinfo_t
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
@@ -203,6 +209,12 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
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
 
@@ -255,6 +267,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	enable_x2apic();
 	smp_init();
 	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
+	setup_efi_rsdp(efi_bootinfo->rsdp);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0.259.gc128427fd7-goog

