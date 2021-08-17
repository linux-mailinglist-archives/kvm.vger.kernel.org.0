Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214093EE4FF
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 05:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhHQDZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 23:25:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbhHQDZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 23:25:36 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gpbs85Mr8z86XM;
        Tue, 17 Aug 2021 11:21:00 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:25:02 +0800
Received: from huawei.com (10.174.186.236) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 17 Aug
 2021 11:25:01 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <wu.wubin@huawei.com>,
        <fanliang@huawei.com>, <wanghaibin.wang@huawei.com>,
        <limingwang@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH RFC v6 02/12] target/riscv: Add target/riscv/kvm.c to place the public kvm interface
Date:   Tue, 17 Aug 2021 11:24:37 +0800
Message-ID: <20210817032447.2055-3-jiangyifei@huawei.com>
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

Add target/riscv/kvm.c to place kvm_arch_* function needed by
kvm/kvm-all.c. Meanwhile, add kvm support in meson.build file.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 meson.build              |   2 +
 target/riscv/kvm.c       | 133 +++++++++++++++++++++++++++++++++++++++
 target/riscv/meson.build |   1 +
 3 files changed, 136 insertions(+)
 create mode 100644 target/riscv/kvm.c

diff --git a/meson.build b/meson.build
index f2e148eaf9..8ad009ceb6 100644
--- a/meson.build
+++ b/meson.build
@@ -72,6 +72,8 @@ elif cpu in ['ppc', 'ppc64']
   kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
 elif cpu in ['mips', 'mips64']
   kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
+elif cpu in ['riscv32', 'riscv64']
+  kvm_targets = ['riscv32-softmmu', 'riscv64-softmmu']
 else
   kvm_targets = []
 endif
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
new file mode 100644
index 0000000000..687dd4b621
--- /dev/null
+++ b/target/riscv/kvm.c
@@ -0,0 +1,133 @@
+/*
+ * RISC-V implementation of KVM hooks
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
+#include "qemu/osdep.h"
+#include <sys/ioctl.h>
+
+#include <linux/kvm.h>
+
+#include "qemu-common.h"
+#include "qemu/timer.h"
+#include "qemu/error-report.h"
+#include "qemu/main-loop.h"
+#include "sysemu/sysemu.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_int.h"
+#include "cpu.h"
+#include "trace.h"
+#include "hw/pci/pci.h"
+#include "exec/memattrs.h"
+#include "exec/address-spaces.h"
+#include "hw/boards.h"
+#include "hw/irq.h"
+#include "qemu/log.h"
+#include "hw/loader.h"
+
+const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
+    KVM_CAP_LAST_INFO
+};
+
+int kvm_arch_get_registers(CPUState *cs)
+{
+    return 0;
+}
+
+int kvm_arch_put_registers(CPUState *cs, int level)
+{
+    return 0;
+}
+
+int kvm_arch_release_virq_post(int virq)
+{
+    return 0;
+}
+
+int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
+                             uint64_t address, uint32_t data, PCIDevice *dev)
+{
+    return 0;
+}
+
+int kvm_arch_destroy_vcpu(CPUState *cs)
+{
+    return 0;
+}
+
+unsigned long kvm_arch_vcpu_id(CPUState *cpu)
+{
+    return cpu->cpu_index;
+}
+
+void kvm_arch_init_irq_routing(KVMState *s)
+{
+}
+
+int kvm_arch_init_vcpu(CPUState *cs)
+{
+    return 0;
+}
+
+int kvm_arch_msi_data_to_gsi(uint32_t data)
+{
+    abort();
+}
+
+int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
+                                int vector, PCIDevice *dev)
+{
+    return 0;
+}
+
+int kvm_arch_init(MachineState *ms, KVMState *s)
+{
+    return 0;
+}
+
+int kvm_arch_irqchip_create(KVMState *s)
+{
+    return 0;
+}
+
+int kvm_arch_process_async_events(CPUState *cs)
+{
+    return 0;
+}
+
+void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
+{
+}
+
+MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
+{
+    return MEMTXATTRS_UNSPECIFIED;
+}
+
+bool kvm_arch_stop_on_emulation_error(CPUState *cs)
+{
+    return true;
+}
+
+int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
+{
+    return 0;
+}
+
+bool kvm_arch_cpu_check_are_resettable(void)
+{
+    return true;
+}
diff --git a/target/riscv/meson.build b/target/riscv/meson.build
index d5e0bc93ea..2faf08a941 100644
--- a/target/riscv/meson.build
+++ b/target/riscv/meson.build
@@ -19,6 +19,7 @@ riscv_ss.add(files(
   'bitmanip_helper.c',
   'translate.c',
 ))
+riscv_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 riscv_softmmu_ss = ss.source_set()
 riscv_softmmu_ss.add(files(
-- 
2.19.1

