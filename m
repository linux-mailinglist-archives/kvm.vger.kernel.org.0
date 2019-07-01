Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A165BD06
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 15:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfGANfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 09:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfGANfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 09:35:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F1DE4DB11;
        Mon,  1 Jul 2019 13:35:54 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 116F0608C2;
        Mon,  1 Jul 2019 13:35:50 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v3 02/15] hw/i386/pc: Extract e820 memory layout code
Date:   Mon,  1 Jul 2019 15:35:23 +0200
Message-Id: <20190701133536.28946-3-philmd@redhat.com>
In-Reply-To: <20190701133536.28946-1-philmd@redhat.com>
References: <20190701133536.28946-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 01 Jul 2019 13:35:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
v3: KISS, do not use unsigned, do not add broken documentation
---
 hw/i386/Makefile.objs        |  2 +-
 hw/i386/e820_memory_layout.c | 59 ++++++++++++++++++++++++++++++++++
 hw/i386/e820_memory_layout.h | 42 +++++++++++++++++++++++++
 hw/i386/pc.c                 | 61 +-----------------------------------
 include/hw/i386/pc.h         | 11 -------
 target/i386/kvm.c            |  1 +
 6 files changed, 104 insertions(+), 72 deletions(-)
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
index 0000000000..bcf9eaf837
--- /dev/null
+++ b/hw/i386/e820_memory_layout.c
@@ -0,0 +1,59 @@
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
+int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+{
+    int index = le32_to_cpu(e820_reserve.count);
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
+int e820_get_num_entries(void)
+{
+    return e820_entries;
+}
+
+bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
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
index 0000000000..2a0ceb8b9c
--- /dev/null
+++ b/hw/i386/e820_memory_layout.h
@@ -0,0 +1,42 @@
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
+/* e820 types */
+#define E820_RAM        1
+#define E820_RESERVED   2
+#define E820_ACPI       3
+#define E820_NVS        4
+#define E820_UNUSABLE   5
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
+int e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
+int e820_get_num_entries(void);
+bool e820_get_entry(int index, uint32_t type,
+                    uint64_t *address, uint64_t *length);
+
+
+
+#endif
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 691726b85b..8ac85eadf1 100644
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
-static unsigned e820_entries;
 struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
 
 /* Physical Address of PVH entry point read from kernel ELF NOTE */
@@ -869,50 +854,6 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
     x86_cpu_set_a20(cpu, level);
 }
 
-int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
-{
-    int index = le32_to_cpu(e820_reserve.count);
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
-int e820_get_num_entries(void)
-{
-    return e820_entries;
-}
-
-bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
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
index c54cc54a47..99b0a2e705 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -282,17 +282,6 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
                        const CPUArchIdList *apic_ids, GArray *entry);
 
-/* e820 types */
-#define E820_RAM        1
-#define E820_RESERVED   2
-#define E820_ACPI       3
-#define E820_NVS        4
-#define E820_UNUSABLE   5
-
-int e820_add_entry(uint64_t, uint64_t, uint32_t);
-int e820_get_num_entries(void);
-bool e820_get_entry(int, uint32_t, uint64_t *, uint64_t *);
-
 extern GlobalProperty pc_compat_4_0[];
 extern const size_t pc_compat_4_0_len;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index e4b4f5756a..cd4eb1ed0d 100644
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

