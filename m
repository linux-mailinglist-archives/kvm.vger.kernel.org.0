Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBD6437D9
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbfFMPBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732546AbfFMOgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:36:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A63B30860C9;
        Thu, 13 Jun 2019 14:35:56 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BA9A1001B2A;
        Thu, 13 Jun 2019 14:35:49 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v2 07/20] hw/i386/pc: Extract e820 memory layout code
Date:   Thu, 13 Jun 2019 16:34:33 +0200
Message-Id: <20190613143446.23937-8-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 13 Jun 2019 14:36:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/Makefile.objs        |  2 +-
 hw/i386/e820_memory_layout.c | 60 ++++++++++++++++++++++++++++
 hw/i386/e820_memory_layout.h | 76 ++++++++++++++++++++++++++++++++++++
 hw/i386/pc.c                 | 62 +----------------------------
 include/hw/i386/pc.h         | 48 -----------------------
 target/i386/kvm.c            |  1 +
 6 files changed, 139 insertions(+), 110 deletions(-)
 create mode 100644 hw/i386/e820_memory_layout.c
 create mode 100644 hw/i386/e820_memory_layout.h

diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
index 5d9c9efd5f..d3374e0831 100644
--- a/hw/i386/Makefile.objs
+++ b/hw/i386/Makefile.objs
@@ -1,5 +1,5 @@
 obj-$(CONFIG_KVM) += kvm/
-obj-y += multiboot.o
+obj-y += e820_memory_layout.o multiboot.o
 obj-y += pc.o
 obj-$(CONFIG_I440FX) += pc_piix.o
 obj-$(CONFIG_Q35) += pc_q35.o
diff --git a/hw/i386/e820_memory_layout.c b/hw/i386/e820_memory_layout.c
new file mode 100644
index 0000000000..240eafff02
--- /dev/null
+++ b/hw/i386/e820_memory_layout.c
@@ -0,0 +1,60 @@
+/*
+ * QEMU BIOS e820 routines
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
+ *
+ * SPDX-License-Identifier: MIT
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/bswap.h"
+#include "e820_memory_layout.h"
+
+static size_t e820_entries;
+struct e820_table e820_reserve;
+struct e820_entry *e820_table;
+
+ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type)
+{
+    unsigned int index = le32_to_cpu(e820_reserve.count);
+    struct e820_entry *entry;
+
+    if (type != E820_RAM) {
+        /* old FW_CFG_E820_TABLE entry -- reservations only */
+        if (index >= E820_NR_ENTRIES) {
+            return -EBUSY;
+        }
+        entry = &e820_reserve.entry[index++];
+
+        entry->address = cpu_to_le64(address);
+        entry->length = cpu_to_le64(length);
+        entry->type = cpu_to_le32(type);
+
+        e820_reserve.count = cpu_to_le32(index);
+    }
+
+    /* new "etc/e820" file -- include ram too */
+    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
+    e820_table[e820_entries].address = cpu_to_le64(address);
+    e820_table[e820_entries].length = cpu_to_le64(length);
+    e820_table[e820_entries].type = cpu_to_le32(type);
+    e820_entries++;
+
+    return e820_entries;
+}
+
+size_t e820_get_num_entries(void)
+{
+    return e820_entries;
+}
+
+bool e820_get_entry(unsigned int idx, E820Type type,
+                    uint64_t *address, uint64_t *length)
+{
+    if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
+        *address = le64_to_cpu(e820_table[idx].address);
+        *length = le64_to_cpu(e820_table[idx].length);
+        return true;
+    }
+    return false;
+}
diff --git a/hw/i386/e820_memory_layout.h b/hw/i386/e820_memory_layout.h
new file mode 100644
index 0000000000..64e88e4772
--- /dev/null
+++ b/hw/i386/e820_memory_layout.h
@@ -0,0 +1,76 @@
+/*
+ * QEMU BIOS e820 routines
+ *
+ * Copyright (c) 2003-2004 Fabrice Bellard
+ *
+ * SPDX-License-Identifier: MIT
+ */
+
+#ifndef HW_I386_E820_H
+#define HW_I386_E820_H
+
+/**
+ * E820Type: Type of the e820 address range.
+ */
+typedef enum {
+    E820_RAM        = 1,
+    E820_RESERVED   = 2,
+    E820_ACPI       = 3,
+    E820_NVS        = 4,
+    E820_UNUSABLE   = 5
+} E820Type;
+
+#define E820_NR_ENTRIES 16
+
+struct e820_entry {
+    uint64_t address;
+    uint64_t length;
+    uint32_t type;
+} QEMU_PACKED __attribute((__aligned__(4)));
+
+struct e820_table {
+    uint32_t count;
+    struct e820_entry entry[E820_NR_ENTRIES];
+} QEMU_PACKED __attribute((__aligned__(4)));
+
+extern struct e820_table e820_reserve;
+extern struct e820_entry *e820_table;
+
+/**
+ * e820_add_entry: Add an #e820_entry to the @e820_table.
+ *
+ * Returns the number of entries of the e820_table on success,
+ *         or a negative errno otherwise.
+ *
+ * @address: The base address of the structure which the BIOS is to fill in.
+ * @length: The length in bytes of the structure passed to the BIOS.
+ * @type: The #E820Type of the address range.
+ */
+ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type);
+
+/**
+ * e820_get_num_entries: The number of entries of the @e820_table.
+ *
+ * Returns the number of entries of the e820_table.
+ */
+size_t e820_get_num_entries(void);
+
+/**
+ * e820_get_entry: Get the address/length of an #e820_entry.
+ *
+ * If the #e820_entry stored at @index is of #E820Type @type, fills @address
+ * and @length with the #e820_entry values and return @true.
+ * Return @false otherwise.
+ *
+ * @index: The index of the #e820_entry to get values.
+ * @type: The @E820Type of the address range expected.
+ * @address: Pointer to the base address of the #e820_entry structure to
+ *           be filled.
+ * @length: Pointer to the length (in bytes) of the #e820_entry structure
+ *          to be filled.
+ * @return: true if the entry was found, false otherwise.
+ */
+bool e820_get_entry(unsigned int index, E820Type type,
+                    uint64_t *address, uint64_t *length);
+
+#endif
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index d9589eb771..c5c96a2e10 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -79,6 +79,7 @@
 #include "hw/i386/intel_iommu.h"
 #include "hw/net/ne2000-isa.h"
 #include "standard-headers/asm-x86/bootparam.h"
+#include "e820_memory_layout.h"
 
 /* debug PC/ISA interrupts */
 //#define DEBUG_IRQ
@@ -90,22 +91,6 @@
 #define DPRINTF(fmt, ...)
 #endif
 
-#define E820_NR_ENTRIES		16
-
-struct e820_entry {
-    uint64_t address;
-    uint64_t length;
-    uint32_t type;
-} QEMU_PACKED __attribute((__aligned__(4)));
-
-struct e820_table {
-    uint32_t count;
-    struct e820_entry entry[E820_NR_ENTRIES];
-} QEMU_PACKED __attribute((__aligned__(4)));
-
-static struct e820_table e820_reserve;
-static struct e820_entry *e820_table;
-static size_t e820_entries;
 struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
 
 /* Physical Address of PVH entry point read from kernel ELF NOTE */
@@ -872,51 +857,6 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
     x86_cpu_set_a20(cpu, level);
 }
 
-ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type)
-{
-    unsigned int index = le32_to_cpu(e820_reserve.count);
-    struct e820_entry *entry;
-
-    if (type != E820_RAM) {
-        /* old FW_CFG_E820_TABLE entry -- reservations only */
-        if (index >= E820_NR_ENTRIES) {
-            return -EBUSY;
-        }
-        entry = &e820_reserve.entry[index++];
-
-        entry->address = cpu_to_le64(address);
-        entry->length = cpu_to_le64(length);
-        entry->type = cpu_to_le32(type);
-
-        e820_reserve.count = cpu_to_le32(index);
-    }
-
-    /* new "etc/e820" file -- include ram too */
-    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
-    e820_table[e820_entries].address = cpu_to_le64(address);
-    e820_table[e820_entries].length = cpu_to_le64(length);
-    e820_table[e820_entries].type = cpu_to_le32(type);
-    e820_entries++;
-
-    return e820_entries;
-}
-
-size_t e820_get_num_entries(void)
-{
-    return e820_entries;
-}
-
-bool e820_get_entry(unsigned int idx, E820Type type,
-                    uint64_t *address, uint64_t *length)
-{
-    if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
-        *address = le64_to_cpu(e820_table[idx].address);
-        *length = le64_to_cpu(e820_table[idx].length);
-        return true;
-    }
-    return false;
-}
-
 /* Enables contiguous-apic-ID mode, for compatibility */
 static bool compat_apic_id_mode;
 
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index fc66b61ff8..7a88768e76 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -282,54 +282,6 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
                        const CPUArchIdList *apic_ids, GArray *entry);
 
-/**
- * E820Type: Type of the e820 address range.
- */
-typedef enum {
-    E820_RAM        = 1,
-    E820_RESERVED   = 2,
-    E820_ACPI       = 3,
-    E820_NVS        = 4,
-    E820_UNUSABLE   = 5
-} E820Type;
-
-/**
- * e820_add_entry: Add an #e820_entry to the @e820_table.
- *
- * Returns the number of entries of the e820_table on success,
- *         or a negative errno otherwise.
- *
- * @address: The base address of the structure which the BIOS is to fill in.
- * @length: The length in bytes of the structure passed to the BIOS.
- * @type: The #E820Type of the address range.
- */
-ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type);
-
-/**
- * e820_get_num_entries: The number of entries of the @e820_table.
- *
- * Returns the number of entries of the e820_table.
- */
-size_t e820_get_num_entries(void);
-
-/**
- * e820_get_entry: Get the address/length of an #e820_entry.
- *
- * If the #e820_entry stored at @index is of #E820Type @type, fills @address
- * and @length with the #e820_entry values and return @true.
- * Return @false otherwise.
- *
- * @index: The index of the #e820_entry to get values.
- * @type: The @E820Type of the address range expected.
- * @address: Pointer to the base address of the #e820_entry structure to
- *           be filled.
- * @length: Pointer to the length (in bytes) of the #e820_entry structure
- *          to be filled.
- * @return: true if the entry was found, false otherwise.
- */
-bool e820_get_entry(unsigned int index, E820Type type,
-                    uint64_t *address, uint64_t *length);
-
 extern GlobalProperty pc_compat_4_0_1[];
 extern const size_t pc_compat_4_0_1_len;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6899061b4e..73964fc63c 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -38,6 +38,7 @@
 #include "hw/i386/apic-msidef.h"
 #include "hw/i386/intel_iommu.h"
 #include "hw/i386/x86-iommu.h"
+#include "hw/i386/e820_memory_layout.h"
 
 #include "hw/pci/pci.h"
 #include "hw/pci/msi.h"
-- 
2.20.1

