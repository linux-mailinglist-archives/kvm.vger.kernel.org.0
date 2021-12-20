Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A347AA26
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhLTNJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:09:41 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30079 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhLTNJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:09:39 -0500
Received: from kwepemi100006.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JHfx25gQKz1DK9y;
        Mon, 20 Dec 2021 21:06:30 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100006.china.huawei.com (7.221.188.165) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:09:37 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 21:09:35 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v3 06/12] target/riscv: Support start kernel directly by KVM
Date:   Mon, 20 Dec 2021 21:09:13 +0800
Message-ID: <20211220130919.413-7-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211220130919.413-1-jiangyifei@huawei.com>
References: <20211220130919.413-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get kernel and fdt start address in virt.c, and pass them to KVM
when cpu reset. Add kvm_riscv.h to place riscv specific interface.

In addition, PLIC is created without M-mode PLIC contexts when KVM
is enabled.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 hw/intc/sifive_plic.c    |  8 +++-
 hw/riscv/boot.c          | 16 +++++++-
 hw/riscv/virt.c          | 87 ++++++++++++++++++++++++++++------------
 include/hw/riscv/boot.h  |  1 +
 target/riscv/cpu.c       |  8 ++++
 target/riscv/cpu.h       |  3 ++
 target/riscv/kvm-stub.c  | 25 ++++++++++++
 target/riscv/kvm.c       | 14 +++++++
 target/riscv/kvm_riscv.h | 24 +++++++++++
 target/riscv/meson.build |  2 +-
 10 files changed, 159 insertions(+), 29 deletions(-)
 create mode 100644 target/riscv/kvm-stub.c
 create mode 100644 target/riscv/kvm_riscv.h

diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
index 877e76877c..1b2b4cc25e 100644
--- a/hw/intc/sifive_plic.c
+++ b/hw/intc/sifive_plic.c
@@ -30,6 +30,7 @@
 #include "target/riscv/cpu.h"
 #include "migration/vmstate.h"
 #include "hw/irq.h"
+#include "sysemu/kvm.h"
 
 #define RISCV_DEBUG_PLIC 0
 
@@ -555,8 +556,11 @@ DeviceState *sifive_plic_create(hwaddr addr, char *hart_config,
 
         qdev_connect_gpio_out(dev, i,
                               qdev_get_gpio_in(DEVICE(cpu), IRQ_S_EXT));
-        qdev_connect_gpio_out(dev, num_harts + i,
-                              qdev_get_gpio_in(DEVICE(cpu), IRQ_M_EXT));
+
+        if (!kvm_enabled()) {
+            qdev_connect_gpio_out(dev, num_harts + i,
+                                  qdev_get_gpio_in(DEVICE(cpu), IRQ_M_EXT));
+        }
     }
 
     return dev;
diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
index 519fa455a1..ccff662d89 100644
--- a/hw/riscv/boot.c
+++ b/hw/riscv/boot.c
@@ -30,6 +30,7 @@
 #include "elf.h"
 #include "sysemu/device_tree.h"
 #include "sysemu/qtest.h"
+#include "sysemu/kvm.h"
 
 #include <libfdt.h>
 
@@ -51,7 +52,9 @@ char *riscv_plic_hart_config_string(int hart_count)
         CPUState *cs = qemu_get_cpu(i);
         CPURISCVState *env = &RISCV_CPU(cs)->env;
 
-        if (riscv_has_ext(env, RVS)) {
+        if (kvm_enabled()) {
+            vals[i] = "S";
+        } else if (riscv_has_ext(env, RVS)) {
             vals[i] = "MS";
         } else {
             vals[i] = "M";
@@ -317,3 +320,14 @@ void riscv_setup_rom_reset_vec(MachineState *machine, RISCVHartArrayState *harts
 
     return;
 }
+
+void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr)
+{
+    CPUState *cs;
+
+    for (cs = first_cpu; cs; cs = CPU_NEXT(cs)) {
+        RISCVCPU *riscv_cpu = RISCV_CPU(cs);
+        riscv_cpu->env.kernel_addr = kernel_addr;
+        riscv_cpu->env.fdt_addr = fdt_addr;
+    }
+}
diff --git a/hw/riscv/virt.c b/hw/riscv/virt.c
index 3af074148e..cc1a03f284 100644
--- a/hw/riscv/virt.c
+++ b/hw/riscv/virt.c
@@ -38,6 +38,7 @@
 #include "chardev/char.h"
 #include "sysemu/device_tree.h"
 #include "sysemu/sysemu.h"
+#include "sysemu/kvm.h"
 #include "hw/pci/pci.h"
 #include "hw/pci-host/gpex.h"
 #include "hw/display/ramfb.h"
@@ -50,7 +51,11 @@ static const MemMapEntry virt_memmap[] = {
     [VIRT_CLINT] =       {  0x2000000,       0x10000 },
     [VIRT_ACLINT_SSWI] = {  0x2F00000,        0x4000 },
     [VIRT_PCIE_PIO] =    {  0x3000000,       0x10000 },
+#if defined(CONFIG_KVM)
+    [VIRT_PLIC] =        {  0xc000000, VIRT_PLIC_SIZE(VIRT_CPUS_MAX * 1) },
+#else
     [VIRT_PLIC] =        {  0xc000000, VIRT_PLIC_SIZE(VIRT_CPUS_MAX * 2) },
+#endif
     [VIRT_UART0] =       { 0x10000000,         0x100 },
     [VIRT_VIRTIO] =      { 0x10001000,        0x1000 },
     [VIRT_FW_CFG] =      { 0x10100000,          0x18 },
@@ -372,13 +377,22 @@ static void create_fdt_socket_plic(RISCVVirtState *s,
         "sifive,plic-1.0.0", "riscv,plic0"
     };
 
-    plic_cells = g_new0(uint32_t, s->soc[socket].num_harts * 4);
+    if (kvm_enabled()) {
+        plic_cells = g_new0(uint32_t, s->soc[socket].num_harts * 2);
+    } else {
+        plic_cells = g_new0(uint32_t, s->soc[socket].num_harts * 4);
+    }
 
     for (cpu = 0; cpu < s->soc[socket].num_harts; cpu++) {
-        plic_cells[cpu * 4 + 0] = cpu_to_be32(intc_phandles[cpu]);
-        plic_cells[cpu * 4 + 1] = cpu_to_be32(IRQ_M_EXT);
-        plic_cells[cpu * 4 + 2] = cpu_to_be32(intc_phandles[cpu]);
-        plic_cells[cpu * 4 + 3] = cpu_to_be32(IRQ_S_EXT);
+        if (kvm_enabled()) {
+            plic_cells[cpu * 2 + 0] = cpu_to_be32(intc_phandles[cpu]);
+            plic_cells[cpu * 2 + 1] = cpu_to_be32(IRQ_S_EXT);
+        } else {
+            plic_cells[cpu * 4 + 0] = cpu_to_be32(intc_phandles[cpu]);
+            plic_cells[cpu * 4 + 1] = cpu_to_be32(IRQ_M_EXT);
+            plic_cells[cpu * 4 + 2] = cpu_to_be32(intc_phandles[cpu]);
+            plic_cells[cpu * 4 + 3] = cpu_to_be32(IRQ_S_EXT);
+        }
     }
 
     plic_phandles[socket] = (*phandle)++;
@@ -436,10 +450,12 @@ static void create_fdt_sockets(RISCVVirtState *s, const MemMapEntry *memmap,
 
         create_fdt_socket_memory(s, memmap, socket);
 
-        if (s->have_aclint) {
-            create_fdt_socket_aclint(s, memmap, socket, intc_phandles);
-        } else {
-            create_fdt_socket_clint(s, memmap, socket, intc_phandles);
+        if (!kvm_enabled()) {
+            if (s->have_aclint) {
+                create_fdt_socket_aclint(s, memmap, socket, intc_phandles);
+            } else {
+                create_fdt_socket_clint(s, memmap, socket, intc_phandles);
+            }
         }
 
         create_fdt_socket_plic(s, memmap, socket, phandle,
@@ -801,23 +817,25 @@ static void virt_machine_init(MachineState *machine)
                                 hart_count, &error_abort);
         sysbus_realize(SYS_BUS_DEVICE(&s->soc[i]), &error_abort);
 
-        /* Per-socket CLINT */
-        riscv_aclint_swi_create(
-            memmap[VIRT_CLINT].base + i * memmap[VIRT_CLINT].size,
-            base_hartid, hart_count, false);
-        riscv_aclint_mtimer_create(
-            memmap[VIRT_CLINT].base + i * memmap[VIRT_CLINT].size +
-                RISCV_ACLINT_SWI_SIZE,
-            RISCV_ACLINT_DEFAULT_MTIMER_SIZE, base_hartid, hart_count,
-            RISCV_ACLINT_DEFAULT_MTIMECMP, RISCV_ACLINT_DEFAULT_MTIME,
-            RISCV_ACLINT_DEFAULT_TIMEBASE_FREQ, true);
-
-        /* Per-socket ACLINT SSWI */
-        if (s->have_aclint) {
+        if (!kvm_enabled()) {
+            /* Per-socket CLINT */
             riscv_aclint_swi_create(
-                memmap[VIRT_ACLINT_SSWI].base +
-                    i * memmap[VIRT_ACLINT_SSWI].size,
-                base_hartid, hart_count, true);
+                memmap[VIRT_CLINT].base + i * memmap[VIRT_CLINT].size,
+                base_hartid, hart_count, false);
+            riscv_aclint_mtimer_create(
+                memmap[VIRT_CLINT].base + i * memmap[VIRT_CLINT].size +
+                    RISCV_ACLINT_SWI_SIZE,
+                RISCV_ACLINT_DEFAULT_MTIMER_SIZE, base_hartid, hart_count,
+                RISCV_ACLINT_DEFAULT_MTIMECMP, RISCV_ACLINT_DEFAULT_MTIME,
+                RISCV_ACLINT_DEFAULT_TIMEBASE_FREQ, true);
+
+            /* Per-socket ACLINT SSWI */
+            if (s->have_aclint) {
+                riscv_aclint_swi_create(
+                    memmap[VIRT_ACLINT_SSWI].base +
+                        i * memmap[VIRT_ACLINT_SSWI].size,
+                    base_hartid, hart_count, true);
+            }
         }
 
         /* Per-socket PLIC hart topology configuration string */
@@ -884,6 +902,16 @@ static void virt_machine_init(MachineState *machine)
     memory_region_add_subregion(system_memory, memmap[VIRT_MROM].base,
                                 mask_rom);
 
+    /*
+     * Only direct boot kernel is currently supported for KVM VM,
+     * so the "-bios" parameter is ignored and treated like "-bios none"
+     * when KVM is enabled.
+     */
+    if (kvm_enabled()) {
+        g_free(machine->firmware);
+        machine->firmware = g_strdup("none");
+    }
+
     if (riscv_is_32bit(&s->soc[0])) {
         firmware_end_addr = riscv_find_and_load_firmware(machine,
                                     RISCV32_BIOS_BIN, start_addr, NULL);
@@ -941,6 +969,15 @@ static void virt_machine_init(MachineState *machine)
                               virt_memmap[VIRT_MROM].size, kernel_entry,
                               fdt_load_addr, machine->fdt);
 
+    /*
+     * Only direct boot kernel is currently supported for KVM VM,
+     * So here setup kernel start address and fdt address.
+     * TODO:Support firmware loading and integrate to TCG start
+     */
+    if (kvm_enabled()) {
+        riscv_setup_direct_kernel(kernel_entry, fdt_load_addr);
+    }
+
     /* SiFive Test MMIO device */
     sifive_test_create(memmap[VIRT_TEST].base);
 
diff --git a/include/hw/riscv/boot.h b/include/hw/riscv/boot.h
index baff11dd8a..5834c234aa 100644
--- a/include/hw/riscv/boot.h
+++ b/include/hw/riscv/boot.h
@@ -58,5 +58,6 @@ void riscv_rom_copy_firmware_info(MachineState *machine, hwaddr rom_base,
                                   hwaddr rom_size,
                                   uint32_t reset_vec_size,
                                   uint64_t kernel_entry);
+void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr);
 
 #endif /* RISCV_BOOT_H */
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index f812998123..1c944872a3 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -29,6 +29,8 @@
 #include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "fpu/softfloat-helpers.h"
+#include "sysemu/kvm.h"
+#include "kvm_riscv.h"
 
 /* RISC-V CPU definitions */
 
@@ -380,6 +382,12 @@ static void riscv_cpu_reset(DeviceState *dev)
     cs->exception_index = RISCV_EXCP_NONE;
     env->load_res = -1;
     set_default_nan_mode(1, &env->fp_status);
+
+#ifndef CONFIG_USER_ONLY
+    if (kvm_enabled()) {
+        kvm_riscv_reset_vcpu(cpu);
+    }
+#endif
 }
 
 static void riscv_cpu_disas_set_info(CPUState *s, disassemble_info *info)
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 0760c0af93..2807eb1bcb 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -255,6 +255,9 @@ struct CPURISCVState {
 
     /* Fields from here on are preserved across CPU reset. */
     QEMUTimer *timer; /* Internal timer */
+
+    hwaddr kernel_addr;
+    hwaddr fdt_addr;
 };
 
 OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
new file mode 100644
index 0000000000..39b96fe3f4
--- /dev/null
+++ b/target/riscv/kvm-stub.c
@@ -0,0 +1,25 @@
+/*
+ * QEMU KVM RISC-V specific function stubs
+ *
+ * Copyright (c) 2020 Huawei Technologies Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include "qemu/osdep.h"
+#include "cpu.h"
+#include "kvm_riscv.h"
+
+void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
+{
+    abort();
+}
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index e695b91dc7..db6d8a5b6e 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -37,6 +37,7 @@
 #include "hw/irq.h"
 #include "qemu/log.h"
 #include "hw/loader.h"
+#include "kvm_riscv.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
 {
@@ -369,6 +370,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     return 0;
 }
 
+void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
+{
+    CPURISCVState *env = &cpu->env;
+
+    if (!kvm_enabled()) {
+        return;
+    }
+    env->pc = cpu->env.kernel_addr;
+    env->gpr[10] = kvm_arch_vcpu_id(CPU(cpu)); /* a0 */
+    env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
+    env->satp = 0;
+}
+
 bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
new file mode 100644
index 0000000000..f38c82bf59
--- /dev/null
+++ b/target/riscv/kvm_riscv.h
@@ -0,0 +1,24 @@
+/*
+ * QEMU KVM support -- RISC-V specific functions.
+ *
+ * Copyright (c) 2020 Huawei Technologies Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef QEMU_KVM_RISCV_H
+#define QEMU_KVM_RISCV_H
+
+void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
+
+#endif
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index 2faf08a941..fe41cc5805 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -19,7 +19,7 @@ riscv_ss.add(files(
   'bitmanip_helper.c',
   'translate.c',
 ))
-riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
+riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
 
 riscv_softmmu_ss = ss.source_set()
 riscv_softmmu_ss.add(files(
-- 
2.19.1

