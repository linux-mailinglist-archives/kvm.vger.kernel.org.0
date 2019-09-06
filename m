Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3072DAB415
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389225AbfIFIdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:33:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46460 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388218AbfIFIdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:33:24 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BA96F2422365D44913A1;
        Fri,  6 Sep 2019 16:33:20 +0800 (CST)
Received: from HGHY1z004218071.china.huawei.com (10.177.29.32) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 16:33:13 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <zhengxiang9@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: [PATCH v18 6/6] target-arm: kvm64: handle SIGBUS signal from kernel or KVM
Date:   Fri, 6 Sep 2019 16:31:52 +0800
Message-ID: <20190906083152.25716-7-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
In-Reply-To: <20190906083152.25716-1-zhengxiang9@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
translates the host VA delivered by host to guest PA, then fills this PA
to guest APEI GHES memory, then notifies guest according to the SIGBUS
type.

If guest accesses the poisoned memory, it generates Synchronous External
Abort(SEA). Then host kernel gets an APEI notification and calls
memory_failure() to unmapped the affected page in stage 2, finally
returns to guest.

Guest continues to access PG_hwpoison page, it will trap to KVM as
stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
Qemu, Qemu records this error address into guest APEI GHES memory and
notifes guest using Synchronous-External-Abort(SEA).

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 hw/acpi/acpi_ghes.c         | 252 ++++++++++++++++++++++++++++++++++++
 include/hw/acpi/acpi_ghes.h |  40 ++++++
 include/sysemu/kvm.h        |   2 +-
 target/arm/kvm64.c          |  39 ++++++
 4 files changed, 332 insertions(+), 1 deletion(-)

diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
index 20c45179ff..2d17c88045 100644
--- a/hw/acpi/acpi_ghes.c
+++ b/hw/acpi/acpi_ghes.c
@@ -26,6 +26,168 @@
 #include "sysemu/sysemu.h"
 #include "qemu/error-report.h"
 
+/* Total size for Generic Error Status Block
+ * ACPI 6.2: 18.3.2.7.1 Generic Error Data,
+ * Table 18-380 Generic Error Status Block
+ */
+#define ACPI_GHES_GESB_SIZE                 20
+/* The offset of Data Length in Generic Error Status Block */
+#define ACPI_GHES_GESB_DATA_LENGTH_OFFSET   12
+
+/* Record the value of data length for each error status block to avoid getting
+ * this value from guest.
+ */
+static uint32_t acpi_ghes_data_length[ACPI_GHES_ERROR_SOURCE_COUNT];
+
+/* Generic Error Data Entry
+ * ACPI 6.1: 18.3.2.7.1 Generic Error Data
+ */
+static void acpi_ghes_generic_error_data(GArray *table, QemuUUID section_type,
+                uint32_t error_severity, uint16_t revision,
+                uint8_t validation_bits, uint8_t flags,
+                uint32_t error_data_length, QemuUUID fru_id,
+                uint8_t *fru_text, uint64_t time_stamp)
+{
+    QemuUUID uuid_le;
+
+    /* Section Type */
+    uuid_le = qemu_uuid_bswap(section_type);
+    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
+
+    /* Error Severity */
+    build_append_int_noprefix(table, error_severity, 4);
+    /* Revision */
+    build_append_int_noprefix(table, revision, 2);
+    /* Validation Bits */
+    build_append_int_noprefix(table, validation_bits, 1);
+    /* Flags */
+    build_append_int_noprefix(table, flags, 1);
+    /* Error Data Length */
+    build_append_int_noprefix(table, error_data_length, 4);
+
+    /* FRU Id */
+    uuid_le = qemu_uuid_bswap(fru_id);
+    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
+
+    /* FRU Text */
+    g_array_append_vals(table, fru_text, 20);
+    /* Timestamp */
+    build_append_int_noprefix(table, time_stamp, 8);
+}
+
+/* Generic Error Status Block
+ * ACPI 6.1: 18.3.2.7.1 Generic Error Data
+ */
+static void acpi_ghes_generic_error_status(GArray *table, uint32_t block_status,
+                uint32_t raw_data_offset, uint32_t raw_data_length,
+                uint32_t data_length, uint32_t error_severity)
+{
+    /* Block Status */
+    build_append_int_noprefix(table, block_status, 4);
+    /* Raw Data Offset */
+    build_append_int_noprefix(table, raw_data_offset, 4);
+    /* Raw Data Length */
+    build_append_int_noprefix(table, raw_data_length, 4);
+    /* Data Length */
+    build_append_int_noprefix(table, data_length, 4);
+    /* Error Severity */
+    build_append_int_noprefix(table, error_severity, 4);
+}
+
+/* UEFI 2.6: N.2.5 Memory Error Section */
+static void acpi_ghes_build_append_mem_cper(GArray *table,
+                                            uint64_t error_physical_addr)
+{
+    /*
+     * Memory Error Record
+     */
+
+    /* Validation Bits */
+    build_append_int_noprefix(table,
+                              (1UL << 14) | /* Type Valid */
+                              (1UL << 1) /* Physical Address Valid */,
+                              8);
+    /* Error Status */
+    build_append_int_noprefix(table, 0, 8);
+    /* Physical Address */
+    build_append_int_noprefix(table, error_physical_addr, 8);
+    /* Skip all the detailed information normally found in such a record */
+    build_append_int_noprefix(table, 0, 48);
+    /* Memory Error Type */
+    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
+    /* Skip all the detailed information normally found in such a record */
+    build_append_int_noprefix(table, 0, 7);
+}
+
+static int acpi_ghes_record_mem_error(uint64_t error_block_address,
+                                      uint64_t error_physical_addr,
+                                      uint32_t data_length)
+{
+    GArray *block;
+    uint64_t current_block_length;
+    /* Memory Error Section Type */
+    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;
+    QemuUUID fru_id = {0};
+    uint8_t fru_text[20] = {0};
+
+    /* Generic Error Status Block
+     * | +---------------------+
+     * | |     block_status    |
+     * | +---------------------+
+     * | |    raw_data_offset  |
+     * | +---------------------+
+     * | |    raw_data_length  |
+     * | +---------------------+
+     * | |     data_length     |
+     * | +---------------------+
+     * | |   error_severity    |
+     * | +---------------------+
+     */
+    block = g_array_new(false, true /* clear */, 1);
+
+    /* The current whole length of the generic error status block */
+    current_block_length = ACPI_GHES_GESB_SIZE + data_length;
+
+    /* This is the length if adding a new generic error data entry*/
+    data_length += ACPI_GHES_DATA_LENGTH;
+    data_length += ACPI_GHES_MEM_CPER_LENGTH;
+
+    /* Check whether it will run out of the preallocated memory if adding a new
+     * generic error data entry
+     */
+    if ((data_length + ACPI_GHES_GESB_SIZE) > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
+        error_report("Record CPER out of boundary!!!");
+        return ACPI_GHES_CPER_FAIL;
+    }
+
+    /* Build the new generic error status block header */
+    acpi_ghes_generic_error_status(block, cpu_to_le32(ACPI_GEBS_UNCORRECTABLE),
+        0, 0, cpu_to_le32(data_length), cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE));
+
+    /* Write back above generic error status block header to guest memory */
+    cpu_physical_memory_write(error_block_address, block->data,
+                              block->len);
+
+    /* Add a new generic error data entry */
+
+    data_length = block->len;
+    /* Build this new generic error data entry header */
+    acpi_ghes_generic_error_data(block, mem_section_id_le,
+        cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE), cpu_to_le32(0x300), 0, 0,
+        cpu_to_le32(ACPI_GHES_MEM_CPER_LENGTH), fru_id, fru_text, 0);
+
+    /* Build the memory section CPER for above new generic error data entry */
+    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
+
+    /* Write back above this new generic error data entry to guest memory */
+    cpu_physical_memory_write(error_block_address + current_block_length,
+        block->data + data_length, block->len - data_length);
+
+    g_array_free(block, true);
+
+    return ACPI_GHES_CPER_OK;
+}
+
 /* Hardware Error Notification
  * ACPI 4.0: 17.3.2.7 Hardware Error Notification
  */
@@ -208,3 +370,93 @@ void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
     fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
         NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
 }
+
+bool acpi_ghes_record_errors(uint32_t notify, uint64_t physical_address)
+{
+    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
+    int loop = 0;
+    uint64_t start_addr = le64_to_cpu(ges.ghes_addr_le);
+    bool ret = ACPI_GHES_CPER_FAIL;
+    uint8_t source_id;
+    const uint8_t error_source_id[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+                                        0xff, 0xff,    0, 0xff, 0xff, 0xff};
+
+    /*
+     * | +---------------------+ ges.ghes_addr_le
+     * | |error_block_address0 |
+     * | +---------------------+ --+--
+     * | |    .............    | ACPI_GHES_ADDRESS_SIZE
+     * | +---------------------+ --+--
+     * | |error_block_addressN |
+     * | +---------------------+
+     * | | read_ack_register0  |
+     * | +---------------------+ --+--
+     * | |   .............     | ACPI_GHES_ADDRESS_SIZE
+     * | +---------------------+ --+--
+     * | | read_ack_registerN  |
+     * | +---------------------+ --+--
+     * | |      CPER           |   |
+     * | |      ....           | ACPI_GHES_MAX_RAW_DATA_LENGT
+     * | |      CPER           |   |
+     * | +---------------------+ --+--
+     * | |    ..........       |
+     * | +---------------------+
+     * | |      CPER           |
+     * | |      ....           |
+     * | |      CPER           |
+     * | +---------------------+
+     */
+    if (physical_address && notify < ACPI_GHES_NOTIFY_RESERVED) {
+        /* Find and check the source id for this new CPER */
+        source_id = error_source_id[notify];
+        if (source_id != 0xff) {
+            start_addr += source_id * ACPI_GHES_ADDRESS_SIZE;
+        } else {
+            goto out;
+        }
+
+        cpu_physical_memory_read(start_addr, &error_block_addr,
+                                 ACPI_GHES_ADDRESS_SIZE);
+
+        read_ack_register_addr = start_addr +
+            ACPI_GHES_ERROR_SOURCE_COUNT * ACPI_GHES_ADDRESS_SIZE;
+retry:
+        cpu_physical_memory_read(read_ack_register_addr,
+                                 &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
+
+        /* zero means OSPM does not acknowledge the error */
+        if (!read_ack_register) {
+            if (loop < 3) {
+                usleep(100 * 1000);
+                loop++;
+                goto retry;
+            } else {
+                error_report("OSPM does not acknowledge previous error,"
+                    " so can not record CPER for current error, forcibly"
+                    " acknowledge previous error to avoid blocking next time"
+                    " CPER record! Exit");
+                read_ack_register = 1;
+                cpu_physical_memory_write(read_ack_register_addr,
+                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
+            }
+        } else {
+            if (error_block_addr) {
+                read_ack_register = 0;
+                /* Clear the Read Ack Register, OSPM will write it to 1 when
+                 * acknowledge this error.
+                 */
+                cpu_physical_memory_write(read_ack_register_addr,
+                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);
+                ret = acpi_ghes_record_mem_error(error_block_addr,
+                          physical_address, acpi_ghes_data_length[source_id]);
+                if (ret == ACPI_GHES_CPER_OK) {
+                    acpi_ghes_data_length[source_id] +=
+                        (ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH);
+                }
+            }
+        }
+    }
+
+out:
+    return ret;
+}
diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
index 69747ba3d7..96f932c207 100644
--- a/include/hw/acpi/acpi_ghes.h
+++ b/include/hw/acpi/acpi_ghes.h
@@ -34,6 +34,35 @@
 /* The max size in bytes for one error block */
 #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
 
+/* The total size of Generic Error Data Entry
+ * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
+ * Table 18-343 Generic Error Data Entry
+ */
+#define ACPI_GHES_DATA_LENGTH               72
+
+/* The memory section CPER size,
+ * UEFI 2.6: N.2.5 Memory Error Section
+ */
+#define ACPI_GHES_MEM_CPER_LENGTH           80
+
+#define ACPI_GHES_CPER_OK                   1
+#define ACPI_GHES_CPER_FAIL                 0
+
+/*
+ * Masks for block_status flags above
+ */
+#define ACPI_GEBS_UNCORRECTABLE         1
+
+/*
+ * Values for error_severity field above
+ */
+enum AcpiGenericErrorSeverity {
+    ACPI_CPER_SEV_RECOVERABLE,
+    ACPI_CPER_SEV_FATAL,
+    ACPI_CPER_SEV_CORRECTED,
+    ACPI_CPER_SEV_NONE,
+};
+
 /* Now only support ARMv8 SEA notification type error source
  */
 #define ACPI_GHES_ERROR_SOURCE_COUNT        1
@@ -67,6 +96,16 @@ enum AcpiGhesNotifyType {
     ACPI_GHES_NOTIFY_RESERVED = 12 /* 12 and greater are reserved */
 };
 
+#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)        \
+    {{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+    ((b) >> 8) & 0xff, (b) & 0xff,                   \
+    ((c) >> 8) & 0xff, (c) & 0xff,                    \
+    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }
+
+#define UEFI_CPER_SEC_PLATFORM_MEM                   \
+    UUID_BE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
+    0xED, 0x7C, 0x83, 0xB1)
+
 /*
  * | +--------------------------+ 0
  * | |        Header            |
@@ -100,4 +139,5 @@ void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
 
 void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker);
 void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
+bool acpi_ghes_record_errors(uint32_t notify, uint64_t error_physical_addr);
 #endif
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 909bcd77cf..5f57e4ed43 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -378,7 +378,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef TARGET_I386
+#if defined(TARGET_I386) || defined(TARGET_AARCH64)
 #define KVM_HAVE_MCE_INJECTION 1
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 #endif
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index bf6edaa3f6..186d855522 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -28,6 +28,8 @@
 #include "kvm_arm.h"
 #include "hw/boards.h"
 #include "internals.h"
+#include "hw/acpi/acpi.h"
+#include "hw/acpi/acpi_ghes.h"
 
 static bool have_guest_debug;
 
@@ -1070,6 +1072,43 @@ int kvm_arch_get_registers(CPUState *cs)
     return ret;
 }
 
+void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
+{
+    ram_addr_t ram_addr;
+    hwaddr paddr;
+
+    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
+
+    if (acpi_enabled && addr &&
+            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
+        ram_addr = qemu_ram_addr_from_host(addr);
+        if (ram_addr != RAM_ADDR_INVALID &&
+            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            kvm_hwpoison_page_add(ram_addr);
+            /* Asynchronous signal will be masked by main thread, so
+             * only handle synchronous signal.
+             */
+            if (code == BUS_MCEERR_AR) {
+                kvm_cpu_synchronize_state(c);
+                if (ACPI_GHES_CPER_FAIL !=
+                    acpi_ghes_record_errors(ACPI_GHES_NOTIFY_SEA, paddr)) {
+                    kvm_inject_arm_sea(c);
+                } else {
+                    fprintf(stderr, "failed to record the error\n");
+                }
+            }
+            return;
+        }
+        fprintf(stderr, "Hardware memory error for memory used by "
+                "QEMU itself instead of guest system!\n");
+    }
+
+    if (code == BUS_MCEERR_AR) {
+        fprintf(stderr, "Hardware memory error!\n");
+        exit(1);
+    }
+}
+
 /* C6.6.29 BRK instruction */
 static const uint32_t brk_insn = 0xd4200000;
 
-- 
2.19.1


