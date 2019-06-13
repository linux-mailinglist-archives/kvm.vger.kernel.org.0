Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7437B437CF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733013AbfFMPBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732561AbfFMOhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:37:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 309C0C05FBD7;
        Thu, 13 Jun 2019 14:37:07 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD48D1001B0F;
        Thu, 13 Jun 2019 14:37:02 +0000 (UTC)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v2 20/20] hw/i386/pc: Extract the x86 generic fw_cfg code
Date:   Thu, 13 Jun 2019 16:34:46 +0200
Message-Id: <20190613143446.23937-21-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 13 Jun 2019 14:37:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract all the functions that are not PC-machine specific into
the (arch-specific) fw_cfg.c file. This will allow other X86-machine
to reuse these functions.

Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/fw_cfg.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++
 hw/i386/fw_cfg.h |   8 +++
 hw/i386/pc.c     | 130 +-------------------------------------------
 3 files changed, 146 insertions(+), 129 deletions(-)

diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 380a819230..b033d99bc4 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -13,8 +13,15 @@
  */
 
 #include "qemu/osdep.h"
+#include "sysemu/numa.h"
+#include "hw/acpi/acpi.h"
+#include "hw/firmware/smbios.h"
+#include "hw/i386/pc.h"
 #include "hw/i386/fw_cfg.h"
+#include "hw/timer/hpet.h"
 #include "hw/nvram/fw_cfg.h"
+#include "e820_memory_layout.h"
+#include "kvm_i386.h"
 
 const char *fw_cfg_arch_key_name(uint16_t key)
 {
@@ -36,3 +43,133 @@ const char *fw_cfg_arch_key_name(uint16_t key)
     }
     return NULL;
 }
+
+FWCfgState *fw_cfg_arch_create(MachineState *ms,
+                               const CPUArchIdList *cpus,
+                               uint16_t boot_cpus,
+                               uint16_t apic_id_limit)
+{
+    FWCfgState *fw_cfg;
+    uint64_t *numa_fw_cfg;
+    int i;
+
+    fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
+                                &address_space_memory);
+    fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, boot_cpus);
+
+    /*
+     * FW_CFG_MAX_CPUS is a bit confusing/problematic on x86:
+     *
+     * For machine types prior to 1.8, SeaBIOS needs FW_CFG_MAX_CPUS for
+     * building MPTable, ACPI MADT, ACPI CPU hotplug and ACPI SRAT table,
+     * that tables are based on xAPIC ID and QEMU<->SeaBIOS interface
+     * for CPU hotplug also uses APIC ID and not "CPU index".
+     * This means that FW_CFG_MAX_CPUS is not the "maximum number of CPUs",
+     * but the "limit to the APIC ID values SeaBIOS may see".
+     *
+     * So for compatibility reasons with old BIOSes we are stuck with
+     * "etc/max-cpus" actually being apic_id_limit
+     */
+    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, apic_id_limit);
+    fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)ram_size);
+    fw_cfg_add_bytes(fw_cfg, FW_CFG_ACPI_TABLES,
+                     acpi_tables, acpi_tables_len);
+    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
+
+    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
+                     &e820_reserve, sizeof(e820_reserve));
+    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
+                    sizeof(struct e820_entry) * e820_get_num_entries());
+
+    fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
+    /*
+     * allocate memory for the NUMA channel: one (64bit) word for the number
+     * of nodes, one word for each VCPU->node and one word for each node to
+     * hold the amount of memory.
+     */
+    numa_fw_cfg = g_new0(uint64_t, 1 + apic_id_limit + nb_numa_nodes);
+    numa_fw_cfg[0] = cpu_to_le64(nb_numa_nodes);
+    for (i = 0; i < cpus->len; i++) {
+        unsigned int apic_id = cpus->cpus[i].arch_id;
+        assert(apic_id < apic_id_limit);
+        numa_fw_cfg[apic_id + 1] = cpu_to_le64(cpus->cpus[i].props.node_id);
+    }
+    for (i = 0; i < nb_numa_nodes; i++) {
+        numa_fw_cfg[apic_id_limit + 1 + i] =
+            cpu_to_le64(numa_info[i].node_mem);
+    }
+    fw_cfg_add_bytes(fw_cfg, FW_CFG_NUMA, numa_fw_cfg,
+                     (1 + apic_id_limit + nb_numa_nodes) *
+                     sizeof(*numa_fw_cfg));
+
+    return fw_cfg;
+}
+
+void fw_cfg_build_smbios(MachineState *ms, FWCfgState *fw_cfg)
+{
+    uint8_t *smbios_tables, *smbios_anchor;
+    size_t smbios_tables_len, smbios_anchor_len;
+    struct smbios_phys_mem_area *mem_array;
+    unsigned i, array_count;
+    X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
+
+    /* tell smbios about cpuid version and features */
+    smbios_set_cpuid(cpu->env.cpuid_version, cpu->env.features[FEAT_1_EDX]);
+
+    smbios_tables = smbios_get_table_legacy(&smbios_tables_len);
+    if (smbios_tables) {
+        fw_cfg_add_bytes(fw_cfg, FW_CFG_SMBIOS_ENTRIES,
+                         smbios_tables, smbios_tables_len);
+    }
+
+    /* build the array of physical mem area from e820 table */
+    mem_array = g_malloc0(sizeof(*mem_array) * e820_get_num_entries());
+    for (i = 0, array_count = 0; i < e820_get_num_entries(); i++) {
+        uint64_t addr, len;
+
+        if (e820_get_entry(i, E820_RAM, &addr, &len)) {
+            mem_array[array_count].address = addr;
+            mem_array[array_count].length = len;
+            array_count++;
+        }
+    }
+    smbios_get_tables(mem_array, array_count,
+                      &smbios_tables, &smbios_tables_len,
+                      &smbios_anchor, &smbios_anchor_len);
+    g_free(mem_array);
+
+    if (smbios_anchor) {
+        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-tables",
+                        smbios_tables, smbios_tables_len);
+        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-anchor",
+                        smbios_anchor, smbios_anchor_len);
+    }
+}
+
+void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg)
+{
+    X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
+    CPUX86State *env = &cpu->env;
+    uint32_t unused, ecx, edx;
+    uint64_t feature_control_bits = 0;
+    uint64_t *val;
+
+    cpu_x86_cpuid(env, 1, 0, &unused, &unused, &ecx, &edx);
+    if (ecx & CPUID_EXT_VMX) {
+        feature_control_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
+    }
+
+    if ((edx & (CPUID_EXT2_MCE | CPUID_EXT2_MCA)) ==
+        (CPUID_EXT2_MCE | CPUID_EXT2_MCA) &&
+        (env->mcg_cap & MCG_LMCE_P)) {
+        feature_control_bits |= FEATURE_CONTROL_LMCE;
+    }
+
+    if (!feature_control_bits) {
+        return;
+    }
+
+    val = g_malloc(sizeof(*val));
+    *val = cpu_to_le64(feature_control_bits | FEATURE_CONTROL_LOCKED);
+    fw_cfg_add_file(fw_cfg, "etc/msr_feature_control", val, sizeof(*val));
+}
diff --git a/hw/i386/fw_cfg.h b/hw/i386/fw_cfg.h
index 17a4bc32f2..f9047a74e8 100644
--- a/hw/i386/fw_cfg.h
+++ b/hw/i386/fw_cfg.h
@@ -9,6 +9,7 @@
 #ifndef HW_I386_FW_CFG_H
 #define HW_I386_FW_CFG_H
 
+#include "hw/boards.h"
 #include "hw/nvram/fw_cfg.h"
 
 #define FW_CFG_ACPI_TABLES      (FW_CFG_ARCH_LOCAL + 0)
@@ -17,4 +18,11 @@
 #define FW_CFG_E820_TABLE       (FW_CFG_ARCH_LOCAL + 3)
 #define FW_CFG_HPET             (FW_CFG_ARCH_LOCAL + 4)
 
+FWCfgState *fw_cfg_arch_create(MachineState *ms,
+                               const CPUArchIdList *cpus,
+                               uint16_t boot_cpus,
+                               uint16_t apic_id_limit);
+void fw_cfg_build_smbios(MachineState *ms, FWCfgState *fw_cfg);
+void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg);
+
 #endif
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index d96328d8db..58b60cb538 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -80,6 +80,7 @@
 #include "hw/net/ne2000-isa.h"
 #include "standard-headers/asm-x86/bootparam.h"
 #include "e820_memory_layout.h"
+#include "fw_cfg.h"
 
 /* debug PC/ISA interrupts */
 //#define DEBUG_IRQ
@@ -890,106 +891,6 @@ static uint32_t x86_cpu_apic_id_from_index(unsigned int cpu_index)
     }
 }
 
-static void fw_cfg_build_smbios(MachineState *ms, FWCfgState *fw_cfg)
-{
-    uint8_t *smbios_tables, *smbios_anchor;
-    size_t smbios_tables_len, smbios_anchor_len;
-    struct smbios_phys_mem_area *mem_array;
-    unsigned i, array_count;
-    X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
-
-    /* tell smbios about cpuid version and features */
-    smbios_set_cpuid(cpu->env.cpuid_version, cpu->env.features[FEAT_1_EDX]);
-
-    smbios_tables = smbios_get_table_legacy(&smbios_tables_len);
-    if (smbios_tables) {
-        fw_cfg_add_bytes(fw_cfg, FW_CFG_SMBIOS_ENTRIES,
-                         smbios_tables, smbios_tables_len);
-    }
-
-    /* build the array of physical mem area from e820 table */
-    mem_array = g_malloc0(sizeof(*mem_array) * e820_get_num_entries());
-    for (i = 0, array_count = 0; i < e820_get_num_entries(); i++) {
-        uint64_t addr, len;
-
-        if (e820_get_entry(i, E820_RAM, &addr, &len)) {
-            mem_array[array_count].address = addr;
-            mem_array[array_count].length = len;
-            array_count++;
-        }
-    }
-    smbios_get_tables(mem_array, array_count,
-                      &smbios_tables, &smbios_tables_len,
-                      &smbios_anchor, &smbios_anchor_len);
-    g_free(mem_array);
-
-    if (smbios_anchor) {
-        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-tables",
-                        smbios_tables, smbios_tables_len);
-        fw_cfg_add_file(fw_cfg, "etc/smbios/smbios-anchor",
-                        smbios_anchor, smbios_anchor_len);
-    }
-}
-
-static FWCfgState *fw_cfg_arch_create(MachineState *ms,
-                                      const CPUArchIdList *cpus,
-                                      uint16_t boot_cpus,
-                                      uint16_t apic_id_limit)
-{
-    FWCfgState *fw_cfg;
-    uint64_t *numa_fw_cfg;
-    int i;
-
-    fw_cfg = fw_cfg_init_io_dma(FW_CFG_IO_BASE, FW_CFG_IO_BASE + 4,
-                                &address_space_memory);
-    fw_cfg_add_i16(fw_cfg, FW_CFG_NB_CPUS, boot_cpus);
-
-    /* FW_CFG_MAX_CPUS is a bit confusing/problematic on x86:
-     *
-     * For machine types prior to 1.8, SeaBIOS needs FW_CFG_MAX_CPUS for
-     * building MPTable, ACPI MADT, ACPI CPU hotplug and ACPI SRAT table,
-     * that tables are based on xAPIC ID and QEMU<->SeaBIOS interface
-     * for CPU hotplug also uses APIC ID and not "CPU index".
-     * This means that FW_CFG_MAX_CPUS is not the "maximum number of CPUs",
-     * but the "limit to the APIC ID values SeaBIOS may see".
-     *
-     * So for compatibility reasons with old BIOSes we are stuck with
-     * "etc/max-cpus" actually being apic_id_limit
-     */
-    fw_cfg_add_i16(fw_cfg, FW_CFG_MAX_CPUS, apic_id_limit);
-    fw_cfg_add_i64(fw_cfg, FW_CFG_RAM_SIZE, (uint64_t)ram_size);
-    fw_cfg_add_bytes(fw_cfg, FW_CFG_ACPI_TABLES,
-                     acpi_tables, acpi_tables_len);
-    fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
-
-    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
-                     &e820_reserve, sizeof(e820_reserve));
-    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
-                    sizeof(struct e820_entry) * e820_get_num_entries());
-
-    fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
-    /* allocate memory for the NUMA channel: one (64bit) word for the number
-     * of nodes, one word for each VCPU->node and one word for each node to
-     * hold the amount of memory.
-     */
-    numa_fw_cfg = g_new0(uint64_t, 1 + apic_id_limit + nb_numa_nodes);
-    numa_fw_cfg[0] = cpu_to_le64(nb_numa_nodes);
-    for (i = 0; i < cpus->len; i++) {
-        unsigned int apic_id = cpus->cpus[i].arch_id;
-        assert(apic_id < apic_id_limit);
-        numa_fw_cfg[apic_id + 1] = cpu_to_le64(cpus->cpus[i].props.node_id);
-    }
-    for (i = 0; i < nb_numa_nodes; i++) {
-        numa_fw_cfg[apic_id_limit + 1 + i] =
-            cpu_to_le64(numa_info[i].node_mem);
-    }
-    fw_cfg_add_bytes(fw_cfg, FW_CFG_NUMA, numa_fw_cfg,
-                     (1 + apic_id_limit + nb_numa_nodes) *
-                     sizeof(*numa_fw_cfg));
-
-    return fw_cfg;
-}
-
 static long get_file_size(FILE *f)
 {
     long where, size;
@@ -1521,35 +1422,6 @@ void pc_cpus_init(PCMachineState *pcms)
     }
 }
 
-static void fw_cfg_build_feature_control(MachineState *ms,
-                                         FWCfgState *fw_cfg)
-{
-    X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
-    CPUX86State *env = &cpu->env;
-    uint32_t unused, ecx, edx;
-    uint64_t feature_control_bits = 0;
-    uint64_t *val;
-
-    cpu_x86_cpuid(env, 1, 0, &unused, &unused, &ecx, &edx);
-    if (ecx & CPUID_EXT_VMX) {
-        feature_control_bits |= FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
-    }
-
-    if ((edx & (CPUID_EXT2_MCE | CPUID_EXT2_MCA)) ==
-        (CPUID_EXT2_MCE | CPUID_EXT2_MCA) &&
-        (env->mcg_cap & MCG_LMCE_P)) {
-        feature_control_bits |= FEATURE_CONTROL_LMCE;
-    }
-
-    if (!feature_control_bits) {
-        return;
-    }
-
-    val = g_malloc(sizeof(*val));
-    *val = cpu_to_le64(feature_control_bits | FEATURE_CONTROL_LOCKED);
-    fw_cfg_add_file(fw_cfg, "etc/msr_feature_control", val, sizeof(*val));
-}
-
 static void rtc_set_cpus_count(ISADevice *rtc, uint16_t cpus_count)
 {
     if (cpus_count > 0xff) {
-- 
2.20.1

