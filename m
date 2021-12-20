Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79C347AA2A
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhLTNJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:09:47 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33880 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhLTNJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:09:46 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHg0M0Rhszcc6Q;
        Mon, 20 Dec 2021 21:09:23 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:09:44 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 21:09:43 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>
Subject: [PATCH v3 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Date:   Mon, 20 Dec 2021 21:09:17 +0800
Message-ID: <20211220130919.413-11-jiangyifei@huawei.com>
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

Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
from KVM.

To set register of RISCV_TIMER_REG(state) will occur a error from KVM
on kvm_timer_state == 0. It's better to adapt in KVM, but it doesn't matter
that adaping in QEMU.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
---
 target/riscv/cpu.h |  7 +++++
 target/riscv/kvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index e7dba35acb..c892a2c8b7 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -259,6 +259,13 @@ struct CPURISCVState {
 
     hwaddr kernel_addr;
     hwaddr fdt_addr;
+
+    /* kvm timer */
+    bool kvm_timer_dirty;
+    uint64_t kvm_timer_time;
+    uint64_t kvm_timer_compare;
+    uint64_t kvm_timer_state;
+    uint64_t kvm_timer_frequency;
 };
 
 OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 4d08669c81..3c20ec5ad3 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -41,6 +41,7 @@
 #include "sbi_ecall_interface.h"
 #include "chardev/char-fe.h"
 #include "semihosting/console.h"
+#include "migration/migration.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
 {
@@ -65,6 +66,9 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
 #define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
                  KVM_REG_RISCV_CSR_REG(name))
 
+#define RISCV_TIMER_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_TIMER, \
+                 KVM_REG_RISCV_TIMER_REG(name))
+
 #define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
 
 #define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
@@ -85,6 +89,22 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
         } \
     } while(0)
 
+#define KVM_RISCV_GET_TIMER(cs, env, name, reg) \
+    do { \
+        int ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, name), &reg); \
+        if (ret) { \
+            abort(); \
+        } \
+    } while(0)
+
+#define KVM_RISCV_SET_TIMER(cs, env, name, reg) \
+    do { \
+        int ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg); \
+        if (ret) { \
+            abort(); \
+        } \
+    } while (0)
+
 static int kvm_riscv_get_regs_core(CPUState *cs)
 {
     int ret = 0;
@@ -236,6 +256,58 @@ static int kvm_riscv_put_regs_fp(CPUState *cs)
     return ret;
 }
 
+static void kvm_riscv_get_regs_timer(CPUState *cs)
+{
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (env->kvm_timer_dirty) {
+        return;
+    }
+
+    KVM_RISCV_GET_TIMER(cs, env, time, env->kvm_timer_time);
+    KVM_RISCV_GET_TIMER(cs, env, compare, env->kvm_timer_compare);
+    KVM_RISCV_GET_TIMER(cs, env, state, env->kvm_timer_state);
+    KVM_RISCV_GET_TIMER(cs, env, frequency, env->kvm_timer_frequency);
+
+    env->kvm_timer_dirty = true;
+}
+
+static void kvm_riscv_put_regs_timer(CPUState *cs)
+{
+    uint64_t reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (!env->kvm_timer_dirty) {
+        return;
+    }
+
+    KVM_RISCV_SET_TIMER(cs, env, time, env->kvm_timer_time);
+    KVM_RISCV_SET_TIMER(cs, env, compare, env->kvm_timer_compare);
+
+    /*
+     * To set register of RISCV_TIMER_REG(state) will occur a error from KVM
+     * on env->kvm_timer_state == 0, It's better to adapt in KVM, but it
+     * doesn't matter that adaping in QEMU now.
+     * TODO If KVM changes, adapt here.
+     */
+    if (env->kvm_timer_state) {
+        KVM_RISCV_SET_TIMER(cs, env, state, env->kvm_timer_state);
+    }
+
+    /*
+     * For now, migration will not work between Hosts with different timer
+     * frequency. Therefore, we should check whether they are the same here
+     * during the migration.
+     */
+    if (migration_is_running(migrate_get_current()->state)) {
+        KVM_RISCV_GET_TIMER(cs, env, frequency, reg);
+        if (reg != env->kvm_timer_frequency) {
+            error_report("Dst Hosts timer frequency != Src Hosts");
+        }
+    }
+
+    env->kvm_timer_dirty = false;
+}
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
-- 
2.19.1

