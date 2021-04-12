Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3511635BA64
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 08:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhDLGyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 02:54:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16442 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhDLGyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 02:54:04 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FJfXg3lygzqTLh;
        Mon, 12 Apr 2021 14:51:31 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Mon, 12 Apr 2021
 14:53:37 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v5 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Date:   Mon, 12 Apr 2021 14:52:44 +0800
Message-ID: <20210412065246.1853-11-jiangyifei@huawei.com>
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

Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
from KVM.

To set register of RISCV_TIMER_REG(state) will occur a error from KVM
on kvm_timer_state == 0. It's better to adapt in KVM, but it doesn't matter
that adaping in QEMU.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 target/riscv/cpu.h |  6 ++++
 target/riscv/kvm.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index 3ca3dad341..b043881bb1 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -247,6 +247,12 @@ struct CPURISCVState {
 
     hwaddr kernel_addr;
     hwaddr fdt_addr;
+
+    /* kvm timer */
+    bool kvm_timer_dirty;
+    uint64_t kvm_timer_time;
+    uint64_t kvm_timer_compare;
+    uint64_t kvm_timer_state;
 };
 
 OBJECT_DECLARE_TYPE(RISCVCPU, RISCVCPUClass,
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index f9707157e7..ec693795ce 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -59,6 +59,9 @@ static __u64 kvm_riscv_reg_id(CPURISCVState *env, __u64 type, __u64 idx)
 #define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
                  KVM_REG_RISCV_CSR_REG(name))
 
+#define RISCV_TIMER_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_TIMER, \
+                 KVM_REG_RISCV_TIMER_REG(name))
+
 #define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
 
 #define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
@@ -306,6 +309,75 @@ static int kvm_riscv_put_regs_fp(CPUState *cs)
     return ret;
 }
 
+static void kvm_riscv_get_regs_timer(CPUState *cs)
+{
+    int ret;
+    uint64_t reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (env->kvm_timer_dirty) {
+        return;
+    }
+
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, time), &reg);
+    if (ret) {
+        abort();
+    }
+    env->kvm_timer_time = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, compare), &reg);
+    if (ret) {
+        abort();
+    }
+    env->kvm_timer_compare = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(env, state), &reg);
+    if (ret) {
+        abort();
+    }
+    env->kvm_timer_state = reg;
+
+    env->kvm_timer_dirty = true;
+}
+
+static void kvm_riscv_put_regs_timer(CPUState *cs)
+{
+    int ret;
+    uint64_t reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (!env->kvm_timer_dirty) {
+        return;
+    }
+
+    reg = env->kvm_timer_time;
+    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, time), &reg);
+    if (ret) {
+        abort();
+    }
+
+    reg = env->kvm_timer_compare;
+    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, compare), &reg);
+    if (ret) {
+        abort();
+    }
+
+    /*
+     * To set register of RISCV_TIMER_REG(state) will occur a error from KVM
+     * on env->kvm_timer_state == 0, It's better to adapt in KVM, but it
+     * doesn't matter that adaping in QEMU now.
+     * TODO If KVM changes, adapt here.
+     */
+    if (env->kvm_timer_state) {
+        reg = env->kvm_timer_state;
+        ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(env, state), &reg);
+        if (ret) {
+            abort();
+        }
+    }
+
+    env->kvm_timer_dirty = false;
+}
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
-- 
2.19.1

