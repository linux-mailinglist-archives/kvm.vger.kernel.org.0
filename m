Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF9BC817
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395313AbfIXMpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:45:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395292AbfIXMpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:45:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE74030860CB;
        Tue, 24 Sep 2019 12:45:10 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8135160852;
        Tue, 24 Sep 2019 12:45:04 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 1/8] hw/i386: Factorize PVH related functions
Date:   Tue, 24 Sep 2019 14:44:26 +0200
Message-Id: <20190924124433.96810-2-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 24 Sep 2019 12:45:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract PVH related functions from pc.c, and put them in pvh.c, so
they can be shared with other components.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 hw/i386/Makefile.objs |   1 +
 hw/i386/pc.c          | 120 +++++-------------------------------------
 hw/i386/pvh.c         | 113 +++++++++++++++++++++++++++++++++++++++
 hw/i386/pvh.h         |  10 ++++
 4 files changed, 136 insertions(+), 108 deletions(-)
 create mode 100644 hw/i386/pvh.c
 create mode 100644 hw/i386/pvh.h

diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
index 5d9c9efd5f..c5f20bbd72 100644
--- a/hw/i386/Makefile.objs
+++ b/hw/i386/Makefile.objs
@@ -1,5 +1,6 @@
 obj-$(CONFIG_KVM) += kvm/
 obj-y += multiboot.o
+obj-y += pvh.o
 obj-y += pc.o
 obj-$(CONFIG_I440FX) += pc_piix.o
 obj-$(CONFIG_Q35) += pc_q35.o
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index bad866fe44..10e4ced0c6 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -42,6 +42,7 @@
 #include "elf.h"
 #include "migration/vmstate.h"
 #include "multiboot.h"
+#include "pvh.h"
 #include "hw/timer/mc146818rtc.h"
 #include "hw/dma/i8257.h"
 #include "hw/timer/i8254.h"
@@ -116,9 +117,6 @@ static struct e820_entry *e820_table;
 static unsigned e820_entries;
 struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
 
-/* Physical Address of PVH entry point read from kernel ELF NOTE */
-static size_t pvh_start_addr;
-
 GlobalProperty pc_compat_4_1[] = {};
 const size_t pc_compat_4_1_len = G_N_ELEMENTS(pc_compat_4_1);
 
@@ -1076,109 +1074,6 @@ struct setup_data {
     uint8_t data[0];
 } __attribute__((packed));
 
-
-/*
- * The entry point into the kernel for PVH boot is different from
- * the native entry point.  The PVH entry is defined by the x86/HVM
- * direct boot ABI and is available in an ELFNOTE in the kernel binary.
- *
- * This function is passed to load_elf() when it is called from
- * load_elfboot() which then additionally checks for an ELF Note of
- * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
- * parse the PVH entry address from the ELF Note.
- *
- * Due to trickery in elf_opts.h, load_elf() is actually available as
- * load_elf32() or load_elf64() and this routine needs to be able
- * to deal with being called as 32 or 64 bit.
- *
- * The address of the PVH entry point is saved to the 'pvh_start_addr'
- * global variable.  (although the entry point is 32-bit, the kernel
- * binary can be either 32-bit or 64-bit).
- */
-static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
-{
-    size_t *elf_note_data_addr;
-
-    /* Check if ELF Note header passed in is valid */
-    if (arg1 == NULL) {
-        return 0;
-    }
-
-    if (is64) {
-        struct elf64_note *nhdr64 = (struct elf64_note *)arg1;
-        uint64_t nhdr_size64 = sizeof(struct elf64_note);
-        uint64_t phdr_align = *(uint64_t *)arg2;
-        uint64_t nhdr_namesz = nhdr64->n_namesz;
-
-        elf_note_data_addr =
-            ((void *)nhdr64) + nhdr_size64 +
-            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
-    } else {
-        struct elf32_note *nhdr32 = (struct elf32_note *)arg1;
-        uint32_t nhdr_size32 = sizeof(struct elf32_note);
-        uint32_t phdr_align = *(uint32_t *)arg2;
-        uint32_t nhdr_namesz = nhdr32->n_namesz;
-
-        elf_note_data_addr =
-            ((void *)nhdr32) + nhdr_size32 +
-            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
-    }
-
-    pvh_start_addr = *elf_note_data_addr;
-
-    return pvh_start_addr;
-}
-
-static bool load_elfboot(const char *kernel_filename,
-                   int kernel_file_size,
-                   uint8_t *header,
-                   size_t pvh_xen_start_addr,
-                   FWCfgState *fw_cfg)
-{
-    uint32_t flags = 0;
-    uint32_t mh_load_addr = 0;
-    uint32_t elf_kernel_size = 0;
-    uint64_t elf_entry;
-    uint64_t elf_low, elf_high;
-    int kernel_size;
-
-    if (ldl_p(header) != 0x464c457f) {
-        return false; /* no elfboot */
-    }
-
-    bool elf_is64 = header[EI_CLASS] == ELFCLASS64;
-    flags = elf_is64 ?
-        ((Elf64_Ehdr *)header)->e_flags : ((Elf32_Ehdr *)header)->e_flags;
-
-    if (flags & 0x00010004) { /* LOAD_ELF_HEADER_HAS_ADDR */
-        error_report("elfboot unsupported flags = %x", flags);
-        exit(1);
-    }
-
-    uint64_t elf_note_type = XEN_ELFNOTE_PHYS32_ENTRY;
-    kernel_size = load_elf(kernel_filename, read_pvh_start_addr,
-                           NULL, &elf_note_type, &elf_entry,
-                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
-                           0, 0);
-
-    if (kernel_size < 0) {
-        error_report("Error while loading elf kernel");
-        exit(1);
-    }
-    mh_load_addr = elf_low;
-    elf_kernel_size = elf_high - elf_low;
-
-    if (pvh_start_addr == 0) {
-        error_report("Error loading uncompressed kernel without PVH ELF Note");
-        exit(1);
-    }
-    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
-    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
-    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
-
-    return true;
-}
-
 static void load_linux(PCMachineState *pcms,
                        FWCfgState *fw_cfg)
 {
@@ -1218,6 +1113,9 @@ static void load_linux(PCMachineState *pcms,
     if (ldl_p(header+0x202) == 0x53726448) {
         protocol = lduw_p(header+0x206);
     } else {
+        size_t pvh_start_addr;
+        uint32_t mh_load_addr = 0;
+        uint32_t elf_kernel_size = 0;
         /*
          * This could be a multiboot kernel. If it is, let's stop treating it
          * like a Linux kernel.
@@ -1235,10 +1133,16 @@ static void load_linux(PCMachineState *pcms,
          * If load_elfboot() is successful, populate the fw_cfg info.
          */
         if (pcmc->pvh_enabled &&
-            load_elfboot(kernel_filename, kernel_size,
-                         header, pvh_start_addr, fw_cfg)) {
+            pvh_load_elfboot(kernel_filename,
+                             &mh_load_addr, &elf_kernel_size)) {
             fclose(f);
 
+            pvh_start_addr = pvh_get_start_addr();
+
+            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
+            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
+            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
+
             fw_cfg_add_i32(fw_cfg, FW_CFG_CMDLINE_SIZE,
                 strlen(kernel_cmdline) + 1);
             fw_cfg_add_string(fw_cfg, FW_CFG_CMDLINE_DATA, kernel_cmdline);
diff --git a/hw/i386/pvh.c b/hw/i386/pvh.c
new file mode 100644
index 0000000000..1c81727811
--- /dev/null
+++ b/hw/i386/pvh.c
@@ -0,0 +1,113 @@
+/*
+ * PVH Boot Helper
+ *
+ * Copyright (C) 2019 Oracle
+ * Copyright (C) 2019 Red Hat, Inc
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/units.h"
+#include "qemu/error-report.h"
+#include "hw/loader.h"
+#include "cpu.h"
+#include "elf.h"
+#include "pvh.h"
+
+static size_t pvh_start_addr;
+
+size_t pvh_get_start_addr(void)
+{
+    return pvh_start_addr;
+}
+
+/*
+ * The entry point into the kernel for PVH boot is different from
+ * the native entry point.  The PVH entry is defined by the x86/HVM
+ * direct boot ABI and is available in an ELFNOTE in the kernel binary.
+ *
+ * This function is passed to load_elf() when it is called from
+ * load_elfboot() which then additionally checks for an ELF Note of
+ * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
+ * parse the PVH entry address from the ELF Note.
+ *
+ * Due to trickery in elf_opts.h, load_elf() is actually available as
+ * load_elf32() or load_elf64() and this routine needs to be able
+ * to deal with being called as 32 or 64 bit.
+ *
+ * The address of the PVH entry point is saved to the 'pvh_start_addr'
+ * global variable.  (although the entry point is 32-bit, the kernel
+ * binary can be either 32-bit or 64-bit).
+ */
+
+static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
+{
+    size_t *elf_note_data_addr;
+
+    /* Check if ELF Note header passed in is valid */
+    if (arg1 == NULL) {
+        return 0;
+    }
+
+    if (is64) {
+        struct elf64_note *nhdr64 = (struct elf64_note *)arg1;
+        uint64_t nhdr_size64 = sizeof(struct elf64_note);
+        uint64_t phdr_align = *(uint64_t *)arg2;
+        uint64_t nhdr_namesz = nhdr64->n_namesz;
+
+        elf_note_data_addr =
+            ((void *)nhdr64) + nhdr_size64 +
+            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
+    } else {
+        struct elf32_note *nhdr32 = (struct elf32_note *)arg1;
+        uint32_t nhdr_size32 = sizeof(struct elf32_note);
+        uint32_t phdr_align = *(uint32_t *)arg2;
+        uint32_t nhdr_namesz = nhdr32->n_namesz;
+
+        elf_note_data_addr =
+            ((void *)nhdr32) + nhdr_size32 +
+            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
+    }
+
+    pvh_start_addr = *elf_note_data_addr;
+
+    return pvh_start_addr;
+}
+
+bool pvh_load_elfboot(const char *kernel_filename,
+                      uint32_t *mh_load_addr,
+                      uint32_t *elf_kernel_size)
+{
+    uint64_t elf_entry;
+    uint64_t elf_low, elf_high;
+    int kernel_size;
+    uint64_t elf_note_type = XEN_ELFNOTE_PHYS32_ENTRY;
+
+    kernel_size = load_elf(kernel_filename, read_pvh_start_addr,
+                           NULL, &elf_note_type, &elf_entry,
+                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
+                           0, 0);
+
+    if (kernel_size < 0) {
+        error_report("Error while loading elf kernel");
+        return false;
+    }
+
+    if (pvh_start_addr == 0) {
+        error_report("Error loading uncompressed kernel without PVH ELF Note");
+        return false;
+    }
+
+    if (mh_load_addr) {
+        *mh_load_addr = elf_low;
+    }
+
+    if (elf_kernel_size) {
+        *elf_kernel_size = elf_high - elf_low;
+    }
+
+    return true;
+}
diff --git a/hw/i386/pvh.h b/hw/i386/pvh.h
new file mode 100644
index 0000000000..ada67ff6e8
--- /dev/null
+++ b/hw/i386/pvh.h
@@ -0,0 +1,10 @@
+#ifndef HW_I386_PVH_H
+#define HW_I386_PVH_H
+
+size_t pvh_get_start_addr(void);
+
+bool pvh_load_elfboot(const char *kernel_filename,
+                      uint32_t *mh_load_addr,
+                      uint32_t *elf_kernel_size);
+
+#endif
-- 
2.21.0

