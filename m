Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B252541F4
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 11:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgH0JXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 05:23:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55864 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728406AbgH0JWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 05:22:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8300F5FA69D5CDAF46A;
        Thu, 27 Aug 2020 17:22:42 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 17:22:35 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v3 12/14] target/riscv: Add kvm_riscv_get/put_regs_timer
Date:   Thu, 27 Aug 2020 17:21:35 +0800
Message-ID: <20200827092137.479-13-jiangyifei@huawei.com>
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

Add kvm_riscv_get/put_regs_timer to synchronize virtual time context
from KVM. The frequency of virtual time is not supported by KVM_SET_ONE_REG,
So it's useless to synchronize the frequency of virtual time.

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
index 7795e7ae13..b735258f27 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -233,6 +233,12 @@ struct CPURISCVState {
 
     hwaddr kernel_addr;
     hwaddr fdt_addr;
+
+    /* kvm timer */
+    bool kvm_timer_dirty;
+    uint64_t kvm_timer_time;
+    uint64_t kvm_timer_compare;
+    uint64_t kvm_timer_state;
 };
 
 #define RISCV_CPU_CLASS(klass) \
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index b49df6dd9c..59c537b1cb 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -59,6 +59,9 @@ static __u64 kvm_riscv_reg_id(__u64 type, __u64 idx)
 #define RISCV_CSR_REG(name)  kvm_riscv_reg_id(KVM_REG_RISCV_CSR, \
                  KVM_REG_RISCV_CSR_REG(name))
 
+#define RISCV_TIMER_REG(name)  kvm_riscv_reg_id(KVM_REG_RISCV_TIMER, \
+                 KVM_REG_RISCV_TIMER_REG(name))
+
 #define RISCV_FP_F_REG(idx)  kvm_riscv_reg_id(KVM_REG_RISCV_FP_F, idx)
 
 #define RISCV_FP_D_REG(idx)  kvm_riscv_reg_id(KVM_REG_RISCV_FP_D, idx)
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
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(time), &reg);
+    if (ret) {
+        abort();
+    }
+    env->kvm_timer_time = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(compare), &reg);
+    if (ret) {
+        abort();
+    }
+    env->kvm_timer_compare = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(state), &reg);
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
+    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(time), &reg);
+    if (ret) {
+        abort();
+    }
+
+    reg = env->kvm_timer_compare;
+    ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(compare), &reg);
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
+        ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(state), &reg);
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


