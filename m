Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146623BF312
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhGHA6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696083"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696083"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770056"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 21/44] i386/tdx: Create the TD HOB list upon machine init done
Date:   Wed,  7 Jul 2021 17:54:51 -0700
Message-Id: <f2e723916bb2875ae701510d22a8d9896ba15f51.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Build the TD HOB during machine late initialization, i.e. once guest
memory is fully defined.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/meson.build   |   2 +-
 hw/i386/tdvf-hob.c    | 166 ++++++++++++++++++++++++++++++++++++++++++
 hw/i386/tdvf-hob.h    |  20 +++++
 target/i386/kvm/tdx.c |  19 +++++
 4 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h

diff --git a/hw/i386/meson.build b/hw/i386/meson.build
index 945e805525..8175c3c638 100644
--- a/hw/i386/meson.build
+++ b/hw/i386/meson.build
@@ -24,7 +24,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
   'pc_sysfw.c',
   'acpi-build.c',
   'port92.c'))
-i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
+i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c', 'tdvf-hob.c'))
 
 subdir('kvm')
 subdir('xen')
diff --git a/hw/i386/tdvf-hob.c b/hw/i386/tdvf-hob.c
new file mode 100644
index 0000000000..5e0bf807f7
--- /dev/null
+++ b/hw/i386/tdvf-hob.c
@@ -0,0 +1,166 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0-or-later
+
+ * Copyright (c) 2020 Intel Corporation
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/log.h"
+#include "e820_memory_layout.h"
+#include "hw/i386/x86.h"
+#include "sysemu/tdx.h"
+#include "tdvf-hob.h"
+#include "uefi.h"
+
+typedef struct TdvfHob {
+    hwaddr hob_addr;
+    void *ptr;
+    int size;
+
+    /* working area */
+    void *current;
+    void *end;
+} TdvfHob;
+
+static uint64_t tdvf_current_guest_addr(const TdvfHob *hob)
+{
+    return hob->hob_addr + (hob->current - hob->ptr);
+}
+
+static void tdvf_align(TdvfHob *hob, size_t align)
+{
+    hob->current = QEMU_ALIGN_PTR_UP(hob->current, align);
+}
+
+static void *tdvf_get_area(TdvfHob *hob, uint64_t size)
+{
+    void *ret;
+
+    if (hob->current + size > hob->end) {
+        error_report("TD_HOB overrun, size = 0x%" PRIx64, size);
+        exit(1);
+    }
+
+    ret = hob->current;
+    hob->current += size;
+    tdvf_align(hob, 8);
+    return ret;
+}
+
+static int tdvf_e820_compare(const void *lhs_, const void* rhs_)
+{
+    const struct e820_entry *lhs = lhs_;
+    const struct e820_entry *rhs = rhs_;
+
+    if (lhs->address == rhs->address) {
+        return 0;
+    }
+    if (le64_to_cpu(lhs->address) > le64_to_cpu(rhs->address)) {
+        return 1;
+    }
+    return -1;
+}
+
+static void tdvf_hob_add_memory_resources(TdvfHob *hob)
+{
+    EFI_HOB_RESOURCE_DESCRIPTOR *region;
+    EFI_RESOURCE_ATTRIBUTE_TYPE attr;
+    EFI_RESOURCE_TYPE resource_type;
+
+    struct e820_entry *e820_entries, *e820_entry;
+    int nr_e820_entries, i;
+
+    nr_e820_entries = e820_get_num_entries();
+    e820_entries = g_new(struct e820_entry, nr_e820_entries);
+
+    /* Copy and sort the e820 tables to add them to the HOB. */
+    memcpy(e820_entries, e820_table,
+           nr_e820_entries * sizeof(struct e820_entry));
+    qsort(e820_entries, nr_e820_entries, sizeof(struct e820_entry),
+          &tdvf_e820_compare);
+
+    for (i = 0; i < nr_e820_entries; i++) {
+        e820_entry = &e820_entries[i];
+
+        if (le32_to_cpu(e820_entry->type) == E820_RAM) {
+            resource_type = EFI_RESOURCE_SYSTEM_MEMORY;
+            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED;
+        } else {
+            resource_type = EFI_RESOURCE_MEMORY_RESERVED;
+            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE;
+        }
+
+        region = tdvf_get_area(hob, sizeof(*region));
+        *region = (EFI_HOB_RESOURCE_DESCRIPTOR) {
+            .Header = {
+                .HobType = EFI_HOB_TYPE_RESOURCE_DESCRIPTOR,
+                .HobLength = cpu_to_le16(sizeof(*region)),
+                .Reserved = cpu_to_le32(0),
+            },
+            .Owner = EFI_HOB_OWNER_ZERO,
+            .ResourceType = cpu_to_le32(resource_type),
+            .ResourceAttribute = cpu_to_le32(attr),
+            .PhysicalStart = e820_entry->address,
+            .ResourceLength = e820_entry->length,
+        };
+    }
+
+    g_free(e820_entries);
+}
+
+void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *hob_entry)
+{
+    TdvfHob hob = {
+        .hob_addr = hob_entry->address,
+        .ptr = hob_entry->mem_ptr,
+        .size = hob_entry->size,
+
+        .current = hob_entry->mem_ptr,
+        .end = hob_entry->mem_ptr + hob_entry->size,
+    };
+
+    EFI_HOB_GENERIC_HEADER *last_hob;
+    EFI_HOB_HANDOFF_INFO_TABLE *hit;
+
+    /* Note, Efi{Free}Memory{Bottom,Top} are ignored, leave 'em zeroed. */
+    hit = tdvf_get_area(&hob, sizeof(*hit));
+    *hit = (EFI_HOB_HANDOFF_INFO_TABLE) {
+        .Header = {
+            .HobType = EFI_HOB_TYPE_HANDOFF,
+            .HobLength = cpu_to_le16(sizeof(*hit)),
+            .Reserved = cpu_to_le32(0),
+        },
+        .Version = cpu_to_le32(EFI_HOB_HANDOFF_TABLE_VERSION),
+        .BootMode = cpu_to_le32(0),
+        .EfiMemoryTop = cpu_to_le64(0),
+        .EfiMemoryBottom = cpu_to_le64(0),
+        .EfiFreeMemoryTop = cpu_to_le64(0),
+        .EfiFreeMemoryBottom = cpu_to_le64(0),
+        .EfiEndOfHobList = cpu_to_le64(0), /* initialized later */
+    };
+
+    tdvf_hob_add_memory_resources(&hob);
+
+    last_hob = tdvf_get_area(&hob, sizeof(*last_hob));
+    *last_hob =  (EFI_HOB_GENERIC_HEADER) {
+        .HobType = EFI_HOB_TYPE_END_OF_HOB_LIST,
+        .HobLength = cpu_to_le16(sizeof(*last_hob)),
+        .Reserved = cpu_to_le32(0),
+    };
+    hit->EfiEndOfHobList = tdvf_current_guest_addr(&hob);
+}
diff --git a/hw/i386/tdvf-hob.h b/hw/i386/tdvf-hob.h
new file mode 100644
index 0000000000..c6c5c1d564
--- /dev/null
+++ b/hw/i386/tdvf-hob.h
@@ -0,0 +1,20 @@
+#ifndef HW_I386_TD_HOB_H
+#define HW_I386_TD_HOB_H
+
+#include "hw/i386/tdvf.h"
+#include "target/i386/kvm/tdx.h"
+
+void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *hob_entry);
+
+#define EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE     \
+    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
+     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
+     EFI_RESOURCE_ATTRIBUTE_ENCRYPTED |         \
+     EFI_RESOURCE_ATTRIBUTE_TESTED)
+
+#define EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED  \
+    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
+     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
+     EFI_RESOURCE_ATTRIBUTE_UNACCEPTED)
+
+#endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 48c04d344d..12b2e02fa2 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "cpu.h"
 #include "kvm_i386.h"
 #include "hw/boards.h"
+#include "hw/i386/tdvf-hob.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
@@ -67,8 +68,26 @@ static void __tdx_ioctl(void *state, int ioctl_no, const char *ioctl_name,
 #define tdx_ioctl(ioctl_no, metadata, data) \
         _tdx_ioctl(kvm_state, ioctl_no, metadata, data)
 
+static TdxFirmwareEntry *tdx_get_hob_entry(TdxGuest *tdx)
+{
+    TdxFirmwareEntry *entry;
+
+    for_each_fw_entry(&tdx->fw, entry) {
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB) {
+            return entry;
+        }
+    }
+    error_report("TDVF metadata doesn't specify TD_HOB location.");
+    exit(1);
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
+    MachineState *ms = MACHINE(qdev_get_machine());
+    TdxGuest *tdx = TDX_GUEST(ms->cgs);
+
+    tdvf_hob_create(tdx, tdx_get_hob_entry(tdx));
+
     tdx_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
 }
 
-- 
2.25.1

