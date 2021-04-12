Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E4735BA61
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 08:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhDLGyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 02:54:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16439 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236635AbhDLGx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 02:53:59 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FJfXZ2lt0zqTC7;
        Mon, 12 Apr 2021 14:51:26 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Mon, 12 Apr 2021
 14:53:32 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v5 07/12] hw/riscv: PLIC update external interrupt by KVM when kvm enabled
Date:   Mon, 12 Apr 2021 14:52:41 +0800
Message-ID: <20210412065246.1853-8-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20210412065246.1853-1-jiangyifei@huawei.com>
References: <20210412065246.1853-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only support supervisor external interrupt currently.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 hw/intc/sifive_plic.c    | 29 ++++++++++++++++++++---------
 target/riscv/kvm-stub.c  |  5 +++++
 target/riscv/kvm.c       | 20 ++++++++++++++++++++
 target/riscv/kvm_riscv.h |  1 +
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/hw/intc/sifive_plic.c b/hw/intc/sifive_plic.c
index 97a1a27a9a..2746eb7a05 100644
--- a/hw/intc/sifive_plic.c
+++ b/hw/intc/sifive_plic.c
@@ -31,6 +31,8 @@
 #include "target/riscv/cpu.h"
 #include "sysemu/sysemu.h"
 #include "migration/vmstate.h"
+#include "sysemu/kvm.h"
+#include "kvm_riscv.h"
 
 #define RISCV_DEBUG_PLIC 0
 
@@ -147,15 +149,24 @@ static void sifive_plic_update(SiFivePLICState *plic)
             continue;
         }
         int level = sifive_plic_irqs_pending(plic, addrid);
-        switch (mode) {
-        case PLICMode_M:
-            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_MEIP, BOOL_TO_MASK(level));
-            break;
-        case PLICMode_S:
-            riscv_cpu_update_mip(RISCV_CPU(cpu), MIP_SEIP, BOOL_TO_MASK(level));
-            break;
-        default:
-            break;
+        if (kvm_enabled()) {
+            if (mode == PLICMode_M) {
+                continue;
+            }
+            kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, level);
+        } else {
+            switch (mode) {
+            case PLICMode_M:
+                riscv_cpu_update_mip(RISCV_CPU(cpu),
+                                     MIP_MEIP, BOOL_TO_MASK(level));
+                break;
+            case PLICMode_S:
+                riscv_cpu_update_mip(RISCV_CPU(cpu),
+                                     MIP_SEIP, BOOL_TO_MASK(level));
+                break;
+            default:
+                break;
+            }
         }
     }
 
diff --git a/target/riscv/kvm-stub.c b/target/riscv/kvm-stub.c
index 39b96fe3f4..4e8fc31a21 100644
--- a/target/riscv/kvm-stub.c
+++ b/target/riscv/kvm-stub.c
@@ -23,3 +23,8 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
 {
     abort();
 }
+
+void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
+{
+    abort();
+}
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 79c931acb4..da63535812 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -453,6 +453,26 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
     env->gpr[11] = cpu->env.fdt_addr;          /* a1 */
 }
 
+void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level)
+{
+    int ret;
+    unsigned virq = level ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
+
+    if (irq != IRQ_S_EXT) {
+        return;
+    }
+
+    if (!kvm_enabled()) {
+        return;
+    }
+
+    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_INTERRUPT, &virq);
+    if (ret < 0) {
+        perror("Set irq failed");
+        abort();
+    }
+}
+
 bool kvm_arch_cpu_check_are_resettable(void)
 {
     return true;
diff --git a/target/riscv/kvm_riscv.h b/target/riscv/kvm_riscv.h
index f38c82bf59..ed281bdce0 100644
--- a/target/riscv/kvm_riscv.h
+++ b/target/riscv/kvm_riscv.h
@@ -20,5 +20,6 @@
 #define QEMU_KVM_RISCV_H
 
 void kvm_riscv_reset_vcpu(RISCVCPU *cpu);
+void kvm_riscv_set_irq(RISCVCPU *cpu, int irq, int level);
 
 #endif
-- 
2.19.1

