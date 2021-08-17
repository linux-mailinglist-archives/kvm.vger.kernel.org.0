Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CDC3EE504
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 05:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhHQDZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 23:25:52 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14221 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236783AbhHQDZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 23:25:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GpbxW2wvlz1CXdQ;
        Tue, 17 Aug 2021 11:24:47 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:25:07 +0800
Received: from huawei.com (10.174.186.236) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 17 Aug
 2021 11:25:06 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <wu.wubin@huawei.com>,
        <fanliang@huawei.com>, <wanghaibin.wang@huawei.com>,
        <limingwang@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH RFC v6 06/12] target/riscv: Support start kernel directly by KVM
Date:   Tue, 17 Aug 2021 11:24:41 +0800
Message-ID: <20210817032447.2055-7-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20210817032447.2055-1-jiangyifei@huawei.com>
References: <20210817032447.2055-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm000001.china.huawei.com (7.185.36.245)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get kernel and fdt start address in virt.c, and pass them to KVM
when cpu reset. In addition, add kvm_riscv.h to place riscv specific
interface.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 hw/riscv/boot.c          | 11 +++++++++++
 hw/riscv/virt.c          |  7 +++++++
 include/hw/riscv/boot.h  |  1 +
 target/riscv/cpu.c       |  8 ++++++++
 target/riscv/cpu.h       |  3 +++
 target/riscv/kvm-stub.c  | 25 +++++++++++++++++++++++++
 target/riscv/kvm.c       | 14 ++++++++++++++
 target/riscv/kvm_riscv.h | 24 ++++++++++++++++++++++++
 target/riscv/meson.build |  2 +-
 9 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 target/riscv/kvm-stub.c
 create mode 100644 target/riscv/kvm_riscv.h

diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
index 993bf89064..920132d078 100644
--- a/hw/riscv/boot.c
+++ b/hw/riscv/boot.c
@@ -292,3 +292,14 @@ void riscv_setup_rom_reset_vec(MachineState *machine, RISCVHartArrayState *harts
 
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
index 4a3cd2599a..cdc27d6498 100644
--- a/hw/riscv/virt.c
+++ b/hw/riscv/virt.c
@@ -736,6 +736,13 @@ static void virt_machine_init(MachineState *machine)
                               virt_memmap[VIRT_MROM].size, kernel_entry,
                               fdt_load_addr, machine->fdt);
 
+    /*
+     * Only direct boot kernel is currently supported for KVM VM,
+     * So here setup kernel start address and fdt address.
+     * TODO:Support firmware loading and integrate to TCG start
+     */
+    riscv_setup_direct_kernel(kernel_entry, fdt_load_addr);
+
     /* SiFive Test MMIO device */
     sifive_test_create(memmap[VIRT_TEST].base);
 
diff --git a/include/hw/riscv/boot.h b/include/hw/riscv/boot.h
index 0e89400b09..bcad5b11b1 100644
--- a/include/hw/riscv/boot.h
+++ b/include/hw/riscv/boot.h
@@ -56,5 +56,6 @@ void riscv_rom_copy_firmware_info(MachineState *machine, hwaddr rom_base,
                                   hwaddr rom_size,
                                   uint32_t reset_vec_size,
                                   uint64_t kernel_entry);
+void riscv_setup_direct_kernel(hwaddr kernel_addr, hwaddr fdt_addr);
 
 #endif /* RISCV_BOOT_H */
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 991a6bb760..764fd39928 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -29,6 +29,8 @@
 #include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "fpu/softfloat-helpers.h"
+#include "sysemu/kvm.h"
+#include "kvm_riscv.h"
 
 /* RISC-V CPU definitions */
 
@@ -374,6 +376,12 @@ static void riscv_cpu_reset(DeviceState *dev)
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
index bf1c899c00..3d3bdc2816 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -243,6 +243,9 @@ struct CPURISCVState {
 
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
index 55b117aff1..ee76371116 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -37,6 +37,7 @@
 #include "hw/irq.h"
 #include "qemu/log.h"
 #include "hw/loader.h"
+#include "kvm_riscv.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
 {
@@ -439,6 +440,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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

