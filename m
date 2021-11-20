Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E679457C4A
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 08:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbhKTHuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 02:50:44 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15844 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbhKTHuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 02:50:13 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hx5Fq45KYz9193;
        Sat, 20 Nov 2021 15:46:39 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 20 Nov 2021 15:47:02 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 15:47:01 +0800
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
Subject: [PATCH v1 07/12] target/riscv: Support setting external interrupt by KVM
Date:   Sat, 20 Nov 2021 15:46:39 +0800
Message-ID: <20211120074644.729-8-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211120074644.729-1-jiangyifei@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend riscv_cpu_update_mip() to support setting external interrupt
by KVM. It will call kvm_riscv_set_irq() to change the IRQ state in
the KVM module When kvm is enabled and the MIP_SEIP bit is set in "mask"

In addition, bacause target/riscv/cpu_helper.c is used to TCG, so move
riscv_cpu_update_mip() to target/riscv/cpu.c from target/riscv/cpu_helper.c

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/cpu.c        | 34 ++++++++++++++++++++++++++++++++++
 target/riscv/cpu_helper.c | 27 ---------------------------
 target/riscv/kvm-stub.c   |  5 +++++
 target/riscv/kvm.c        | 20 ++++++++++++++++++++
 target/riscv/kvm_riscv.h  |  1 +
 5 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index 1c944872a3..a464845c99 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -21,6 +21,7 @@
 #include "qemu/qemu-print.h"
 #include "qemu/ctype.h"
 #include "qemu/log.h"
+#include "qemu/main-loop.h"
 #include "cpu.h"
 #include "internals.h"
 #include "exec/exec-all.h"
@@ -131,6 +132,39 @@ static void set_feature(CPURISCVState *env, int feature)
     env->features |= (1ULL << feature);
 }
 
+#ifndef CONFIG_USER_ONLY
+uint32_t riscv_cpu_update_mip(RISCVCPU *cpu, uint32_t mask, uint32_t value)
+{
+    CPURISCVState *env = &cpu->env;
+    CPUState *cs = CPU(cpu);
+    uint32_t old = env->mip;
+    bool locked = false;
+
+    if (!qemu_mutex_iothread_locked()) {
+        locked = true;
+        qemu_mutex_lock_iothread();
+    }
+
+    env->mip = (env->mip & ~mask) | (value & mask);
+
+    if (kvm_enabled() && (mask & MIP_SEIP)) {
+        kvm_riscv_set_irq(RISCV_CPU(cpu), IRQ_S_EXT, value & MIP_SEIP);
+    }
+
+    if (env->mip) {
+        cpu_interrupt(cs, CPU_INTERRUPT_HARD);
+    } else {
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
+    }
+
+    if (locked) {
+        qemu_mutex_unlock_iothread();
+    }
+
+    return old;
+}
+#endif
+
 static void set_resetvec(CPURISCVState *env, target_ulong resetvec)
 {
 #ifndef CONFIG_USER_ONLY
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index 9eeed38c7e..5e36c35b15 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -286,33 +286,6 @@ int riscv_cpu_claim_interrupts(RISCVCPU *cpu, uint32_t interrupts)
     }
 }
 
-uint32_t riscv_cpu_update_mip(RISCVCPU *cpu, uint32_t mask, uint32_t value)
-{
-    CPURISCVState *env = &cpu->env;
-    CPUState *cs = CPU(cpu);
-    uint32_t old = env->mip;
-    bool locked = false;
-
-    if (!qemu_mutex_iothread_locked()) {
-        locked = true;
-        qemu_mutex_lock_iothread();
-    }
-
-    env->mip = (env->mip & ~mask) | (value & mask);
-
-    if (env->mip) {
-        cpu_interrupt(cs, CPU_INTERRUPT_HARD);
-    } else {
-        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
-    }
-
-    if (locked) {
-        qemu_mutex_unlock_iothread();
-    }
-
-    return old;
-}
-
 void riscv_cpu_set_rdtime_fn(CPURISCVState *env, uint64_t (*fn)(uint32_t),
                              uint32_t arg)
 {
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
index 7f3ffcc2b4..8da2648d1a 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -458,6 +458,26 @@ void kvm_riscv_reset_vcpu(RISCVCPU *cpu)
     env->satp = 0;
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

