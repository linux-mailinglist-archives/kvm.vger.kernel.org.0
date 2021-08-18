Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31623EF68B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhHRAKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhHRAKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:01 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF444C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:27 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z8-20020a0ce9880000b02903528f1b338aso845367qvn.6
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g0ugafo/gUmvuwtrV/a6ZJmlYkw6uUwS8zsNWjEaaDU=;
        b=ql+OcfqXf3UoDxTPD21Lj4In/qPc/zwsSRkh0wXw6SREQQfFMC+81Eib+fTuKRCb/U
         eyNyO6V/LAPiG4MTeW4Kah5YVTSDN2PFJ6roYDgp/r56pfr6i9wsY7asixxSx6tHo4qs
         vOoLK7dKKpHFeyt9SxbUz0F7rL8LP41x6DPEIY6b6ZV3WFtm4vsV8LICA4sxxy4f0zyZ
         okLP8JqC/9yIjrc9/8KepfGlezV+Oy+y8iOVmDWlqWbwFbrV+LWX4NzkpStcuHZcxp6Z
         kpeA2qT47zZqRBlmdZESba9hKNaL58/8Lu76Z+IpXVfKp6VyyU+FzQI8QlFERUw6hYhM
         qQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g0ugafo/gUmvuwtrV/a6ZJmlYkw6uUwS8zsNWjEaaDU=;
        b=i2J5EhL9+vbu8Fs2A1fxMo+y0BilOuTi9yI1n/b1ZFQF+Z0XdF69/h2D/JL4mhydE9
         GYDk+dPv+IPAxp0IiMurkNKyA3yhSG+NIDhm4qQxUrCizZxu2kPa5yU1FXYVeghkty4J
         qt8i4okYnjnH7OVuVO4/b6ULo4mwScoXzkCP/L56YWSOfljgJaV7cbFOwwwyjqTzXCEX
         zQ5lc7T8sfV2eHkzwVc7ROEg68yxzngkg1IiLjCAZP0uIuU0QJ2bht2WCivq+Kkg+V5h
         C3sLSZmcX3g1dYX1R1cR/QcayaxiqmYQ6+ZDQQTde9DZ3MJTZtKN3W3BbBNgKkGBCwf2
         EXaA==
X-Gm-Message-State: AOAM5331ERjGwXtmExsMomdBL2tgMf2yjTQT+/yb7H4ZE+w9wVFendAX
        fbtSwXQl1My5dZ+deMSi1cKIepX5QGIWZwlb2/Od8s5E4vEIlDpuDC4Hhmso/btFcaMXsAr6+Hv
        T/ZILlMmMdF1tXHwW+YPb6ecMOqZsY5AoUgRQFVc2g7L+G4Fhj0omkvvSu+wFuq0D3ItO
X-Google-Smtp-Source: ABdhPJzPZj5KBH4+4PwwbO5ST8nTm5mfYKEdyfhvJrS53XpfyAWmwBioEYi1MBWe6jpJR/duQXbriir4BgzUtHX2
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:10e6:: with SMTP id
 q6mr6169224qvt.11.1629245366661; Tue, 17 Aug 2021 17:09:26 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:56 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-8-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 07/16] x86 UEFI: Set up RSDP after UEFI boot up
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
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
 lib/x86/acpi.c      | 38 +++++++++++++++++++++++++++++++-------
 lib/x86/acpi.h      |  4 ++++
 lib/x86/asm/setup.h |  2 ++
 lib/x86/setup.c     | 13 +++++++++++++
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
index 4373106..4b7dc60 100644
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
+		printf("Can't find RSDP from UEFI, maybe setup_efi_rsdp() is not called\n");
+	}
+	return efi_rsdp;
+}
+#else
+static struct rsdp_descriptor *get_rsdp(void) {
+    struct rsdp_descriptor *rsdp;
+    unsigned long addr;
+    for(addr = 0xf0000; addr < 0x100000; addr += 16) {
+	rsdp = (void*)addr;
+	if (rsdp->signature == 0x2052545020445352LL)
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
index 1b80374..da57043 100644
--- a/lib/x86/acpi.h
+++ b/lib/x86/acpi.h
@@ -101,4 +101,8 @@ struct facs_descriptor_rev1
 
 void* find_acpi_table_addr(u32 sig);
 
+#ifdef TARGET_EFI
+void setup_efi_rsdp(struct rsdp_descriptor *rsdp);
+#endif /* TARGET_EFI */
+
 #endif
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index c22c999..2115a75 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -2,6 +2,7 @@
 #define _X86_ASM_SETUP_H_
 
 #ifdef TARGET_EFI
+#include "x86/acpi.h"
 #include "x86/apic.h"
 #include "x86/smp.h"
 
@@ -19,6 +20,7 @@
 typedef struct {
 	phys_addr_t free_mem_start;
 	phys_addr_t free_mem_size;
+	struct rsdp_descriptor *rsdp;
 } efi_bootinfo_t;
 
 void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 0f6e376..3695c4a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -134,6 +134,7 @@ void setup_efi_bootinfo(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_bootinfo->free_mem_size = 0;
 	efi_bootinfo->free_mem_start = 0;
+	efi_bootinfo->rsdp = NULL;
 }
 
 static EFI_STATUS setup_pre_boot_memory(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
@@ -181,6 +182,11 @@ static EFI_STATUS setup_pre_boot_memory(UINTN *mapkey, efi_bootinfo_t *efi_booti
 	return EFI_SUCCESS;
 }
 
+static EFI_STATUS setup_pre_boot_rsdp(efi_bootinfo_t *efi_bootinfo)
+{
+	return LibGetSystemConfigurationTable(&AcpiTableGuid, (VOID **)&efi_bootinfo->rsdp);
+}
+
 EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
 {
 	EFI_STATUS status;
@@ -202,6 +208,12 @@ EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
+	status = setup_pre_boot_rsdp(efi_bootinfo);
+	if (EFI_ERROR(status)) {
+		printf("Cannot find RSDP in EFI system table\n");
+		return status;
+	}
+
 	return EFI_SUCCESS;
 }
 
@@ -255,6 +267,7 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	smp_init();
 	phys_alloc_init(efi_bootinfo->free_mem_start,
 			efi_bootinfo->free_mem_size);
+	setup_efi_rsdp(efi_bootinfo->rsdp);
 }
 
 #endif /* TARGET_EFI */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

