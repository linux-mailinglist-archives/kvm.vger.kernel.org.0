Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75647AA2F
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 14:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhLTNKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 08:10:34 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16836 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhLTNJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 08:09:34 -0500
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JHfzc0Czcz91Px;
        Mon, 20 Dec 2021 21:08:44 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 21:09:32 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 20 Dec
 2021 21:09:31 +0800
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
Subject: [PATCH v3 04/12] target/riscv: Implement kvm_arch_get_registers
Date:   Mon, 20 Dec 2021 21:09:11 +0800
Message-ID: <20211220130919.413-5-jiangyifei@huawei.com>
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

Get GPR CSR and FP registers from kvm by KVM_GET_ONE_REG ioctl.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
---
 target/riscv/kvm.c | 112 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index ccf3753048..6d4df0ef6d 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -55,13 +55,123 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
     return id;
 }
 
+#define RISCV_CORE_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, \
+                 KVM_REG_RISCV_CORE_REG(name))
+
+#define RISCV_CSR_REG(env, name)  kvm_riscv_reg_id(env, KVM_REG_RISCV_CSR, \
+                 KVM_REG_RISCV_CSR_REG(name))
+
+#define RISCV_FP_F_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_F, idx)
+
+#define RISCV_FP_D_REG(env, idx)  kvm_riscv_reg_id(env, KVM_REG_RISCV_FP_D, idx)
+
+#define KVM_RISCV_GET_CSR(cs, env, csr, reg) \
+    do { \
+        int ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, csr), &reg); \
+        if (ret) { \
+            return ret; \
+        } \
+    } while(0)
+
+static int kvm_riscv_get_regs_core(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    target_ulong reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    ret = kvm_get_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->pc = reg;
+
+    for (i = 1; i < 32; i++) {
+        uint64_t id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
+        ret = kvm_get_one_reg(cs, id, &reg);
+        if (ret) {
+            return ret;
+        }
+        env->gpr[i] = reg;
+    }
+
+    return ret;
+}
+
+static int kvm_riscv_get_regs_csr(CPUState *cs)
+{
+    int ret = 0;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    KVM_RISCV_GET_CSR(cs, env, sstatus, env->mstatus);
+    KVM_RISCV_GET_CSR(cs, env, sie, env->mie);
+    KVM_RISCV_GET_CSR(cs, env, stvec, env->stvec);
+    KVM_RISCV_GET_CSR(cs, env, sscratch, env->sscratch);
+    KVM_RISCV_GET_CSR(cs, env, sepc, env->sepc);
+    KVM_RISCV_GET_CSR(cs, env, scause, env->scause);
+    KVM_RISCV_GET_CSR(cs, env, stval, env->stval);
+    KVM_RISCV_GET_CSR(cs, env, sip, env->mip);
+    KVM_RISCV_GET_CSR(cs, env, satp, env->satp);
+    return ret;
+}
+
+static int kvm_riscv_get_regs_fp(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (riscv_has_ext(env, RVD)) {
+        uint64_t reg;
+        for (i = 0; i < 32; i++) {
+            ret = kvm_get_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
+            if (ret) {
+                return ret;
+            }
+            env->fpr[i] = reg;
+        }
+        return ret;
+    }
+
+    if (riscv_has_ext(env, RVF)) {
+        uint32_t reg;
+        for (i = 0; i < 32; i++) {
+            ret = kvm_get_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
+            if (ret) {
+                return ret;
+            }
+            env->fpr[i] = reg;
+        }
+        return ret;
+    }
+
+    return ret;
+}
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    return 0;
+    int ret = 0;
+
+    ret = kvm_riscv_get_regs_core(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_riscv_get_regs_csr(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_riscv_get_regs_fp(cs);
+    if (ret) {
+        return ret;
+    }
+
+    return ret;
 }
 
 int kvm_arch_put_registers(CPUState *cs, int level)
-- 
2.19.1

