Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA16F8DF6
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 04:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjEFCYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 22:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjEFCYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 22:24:35 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C274D5FDA
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 19:24:33 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxGupgulVkFIoFAA--.9084S3;
        Sat, 06 May 2023 10:24:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxOLZXulVkj9RMAA--.9112S10;
        Sat, 06 May 2023 10:24:32 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v3 8/9] target/loongarch: Implement set vcpu intr for kvm
Date:   Sat,  6 May 2023 10:24:21 +0800
Message-Id: <20230506022422.59442-9-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230506022422.59442-1-zhaotianrui@loongson.cn>
References: <20230506022422.59442-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxOLZXulVkj9RMAA--.9112S10
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxJFyUZr1rZF15WF4DAF1DZFb_yoWrWryxpF
        ZruF98Kr48JrZrJ3Z3Z3Z8Xrs8X3yfCrsF9ayIk34xCr47XryUXF1vq3srXF15G3yUWry0
        qF1Fyr15WF18Xw7anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b48Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
        kF7I0E14v26r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRR5l1PUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch kvm set vcpu interrupt interface,
when a irq is set in vcpu, we use the KVM_INTERRUPT
ioctl to set intr into kvm.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/cpu.c           | 18 +++++++++++++-----
 target/loongarch/kvm-stub.c      | 11 +++++++++++
 target/loongarch/kvm.c           | 16 ++++++++++++++++
 target/loongarch/kvm_loongarch.h | 13 +++++++++++++
 target/loongarch/trace-events    |  1 +
 5 files changed, 54 insertions(+), 5 deletions(-)
 create mode 100644 target/loongarch/kvm-stub.c
 create mode 100644 target/loongarch/kvm_loongarch.h

diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index f20345de34..fb4bb3ede7 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -18,6 +18,11 @@
 #include "cpu-csr.h"
 #include "sysemu/reset.h"
 #include "tcg/tcg.h"
+#include "sysemu/kvm.h"
+#include "kvm_loongarch.h"
+#ifdef CONFIG_KVM
+#include <linux/kvm.h>
+#endif
 
 const char * const regnames[32] = {
     "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
@@ -104,12 +109,15 @@ void loongarch_cpu_set_irq(void *opaque, int irq, int level)
         return;
     }
 
-    env->CSR_ESTAT = deposit64(env->CSR_ESTAT, irq, 1, level != 0);
-
-    if (FIELD_EX64(env->CSR_ESTAT, CSR_ESTAT, IS)) {
-        cpu_interrupt(cs, CPU_INTERRUPT_HARD);
+    if (kvm_enabled()) {
+        kvm_loongarch_set_interrupt(cpu, irq, level);
     } else {
-        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
+        env->CSR_ESTAT = deposit64(env->CSR_ESTAT, irq, 1, level != 0);
+        if (FIELD_EX64(env->CSR_ESTAT, CSR_ESTAT, IS)) {
+            cpu_interrupt(cs, CPU_INTERRUPT_HARD);
+        } else {
+            cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
+        }
     }
 }
 
diff --git a/target/loongarch/kvm-stub.c b/target/loongarch/kvm-stub.c
new file mode 100644
index 0000000000..9965c1f119
--- /dev/null
+++ b/target/loongarch/kvm-stub.c
@@ -0,0 +1,11 @@
+/*
+ * QEMU KVM LoongArch specific function stubs
+ *
+ * Copyright (c) 2023 Loongson Technology Corporation Limited
+ */
+#include "cpu.h"
+
+void kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level)
+{
+   g_assert_not_reached();
+}
diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
index 6554013a9d..ec6a962e18 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -525,6 +525,22 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     return ret;
 }
 
+int kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level)
+{
+    struct kvm_loongarch_interrupt intr;
+    CPUState *cs = CPU(cpu);
+
+    intr.cpu = cs->cpu_index;
+    if (level) {
+        intr.irq = irq;
+    } else {
+        intr.irq = -irq;
+    }
+
+    trace_kvm_set_intr(irq, level);
+    return kvm_vcpu_ioctl(cs, KVM_INTERRUPT, &intr);
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
 }
diff --git a/target/loongarch/kvm_loongarch.h b/target/loongarch/kvm_loongarch.h
new file mode 100644
index 0000000000..cdef980eec
--- /dev/null
+++ b/target/loongarch/kvm_loongarch.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * QEMU LoongArch kvm interface
+ *
+ * Copyright (c) 2023 Loongson Technology Corporation Limited
+ */
+
+#ifndef QEMU_KVM_LOONGARCH_H
+#define QEMU_KVM_LOONGARCH_H
+
+int  kvm_loongarch_set_interrupt(LoongArchCPU *cpu, int irq, int level);
+
+#endif
diff --git a/target/loongarch/trace-events b/target/loongarch/trace-events
index c79e01663a..2673e43bfd 100644
--- a/target/loongarch/trace-events
+++ b/target/loongarch/trace-events
@@ -12,3 +12,4 @@ kvm_failed_put_mpstate(const char *msg) "Failed to put mp_state into KVM: %s"
 kvm_failed_get_counter(const char *msg) "Failed to get counter from KVM: %s"
 kvm_failed_put_counter(const char *msg) "Failed to put counter into KVM: %s"
 kvm_arch_handle_exit(int num) "kvm arch handle exit, the reason number: %d"
+kvm_set_intr(int irq, int level) "kvm set interrupt, irq num: %d, level: %d"
-- 
2.31.1

