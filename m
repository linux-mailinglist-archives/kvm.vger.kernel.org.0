Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886562541EF
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 11:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgH0JWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 05:22:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56642 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728380AbgH0JWm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 05:22:42 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A7D9F68216606540F837;
        Thu, 27 Aug 2020 17:22:40 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 17:22:31 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v3 07/14] hw/riscv: PLIC update external interrupt by KVM when kvm enabled
Date:   Thu, 27 Aug 2020 17:21:30 +0800
Message-ID: <20200827092137.479-8-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200827092137.479-1-jiangyifei@huawei.com>
References: <20200827092137.479-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only support supervisor external interrupt currently.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 hw/riscv/sifive_plic.c   | 31 ++++++++++++++++++++++---------
 target/riscv/kvm.c       | 19 +++++++++++++++++++
 target/riscv/kvm_riscv.h |  1 +
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/hw/riscv/sifive_plic.c b/hw/riscv/sifive_plic.c
index c20c192034..9c5a131e0f 100644
--- a/hw/riscv/sifive_plic.c
+++ b/hw/riscv/sifive_plic.c
@@ -30,6 +30,8 @@
 #include "target/riscv/cpu.h"
 #include "sysemu/sysemu.h"
 #include "hw/riscv/sifive_plic.h"
+#include "sysemu/kvm.h"
+#include "kvm_riscv.h"
 
 #define RISCV_DEBUG_PLIC 0
 
@@ -146,15 +148,26 @@ static void sifive_plic_update(SiFivePLICState *plic)
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
+#ifdef CONFIG_KVM
+            kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, level);
+#endif
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
 
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 69217add16..d510d23da1 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -452,3 +452,22 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
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


