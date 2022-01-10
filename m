Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F395488E29
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 02:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbiAJBjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 20:39:51 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30266 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbiAJBjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 20:39:15 -0500
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JXGgb6W4ZzQj7k;
        Mon, 10 Jan 2022 09:38:35 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 09:39:02 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 10 Jan
 2022 09:39:00 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup@brainfault.org>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v4 05/12] target/riscv: Implement kvm_arch_put_registers
Date:   Mon, 10 Jan 2022 09:38:24 +0800
Message-ID: <20220110013831.1594-6-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20220110013831.1594-1-jiangyifei@huawei.com>
References: <20220110013831.1594-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Put GPR CSR and FP registers to kvm by KVM_SET_ONE_REG ioctl

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
---
 target/riscv/kvm.c | 104 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 6d4df0ef6d..e695b91dc7 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -73,6 +73,14 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
         } \
     } while(0)
 
+#define KVM_RISCV_SET_CSR(cs, env, csr, reg) \
+    do { \
+        int ret = kvm_set_one_reg(cs, RISCV_CSR_REG(env, csr), &reg); \
+        if (ret) { \
+            return ret; \
+        } \
+    } while(0)
+
 static int kvm_riscv_get_regs_core(CPUState *cs)
 {
     int ret = 0;
@@ -98,6 +106,31 @@ static int kvm_riscv_get_regs_core(CPUState *cs)
     return ret;
 }
 
+static int kvm_riscv_put_regs_core(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    target_ulong reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    reg = env->pc;
+    ret = kvm_set_one_reg(cs, RISCV_CORE_REG(env, regs.pc), &reg);
+    if (ret) {
+        return ret;
+    }
+
+    for (i = 1; i < 32; i++) {
+        uint64_t id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CORE, i);
+        reg = env->gpr[i];
+        ret = kvm_set_one_reg(cs, id, &reg);
+        if (ret) {
+            return ret;
+        }
+    }
+
+    return ret;
+}
+
 static int kvm_riscv_get_regs_csr(CPUState *cs)
 {
     int ret = 0;
@@ -115,6 +148,24 @@ static int kvm_riscv_get_regs_csr(CPUState *cs)
     return ret;
 }
 
+static int kvm_riscv_put_regs_csr(CPUState *cs)
+{
+    int ret = 0;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    KVM_RISCV_SET_CSR(cs, env, sstatus, env->mstatus);
+    KVM_RISCV_SET_CSR(cs, env, sie, env->mie);
+    KVM_RISCV_SET_CSR(cs, env, stvec, env->stvec);
+    KVM_RISCV_SET_CSR(cs, env, sscratch, env->sscratch);
+    KVM_RISCV_SET_CSR(cs, env, sepc, env->sepc);
+    KVM_RISCV_SET_CSR(cs, env, scause, env->scause);
+    KVM_RISCV_SET_CSR(cs, env, stval, env->stval);
+    KVM_RISCV_SET_CSR(cs, env, sip, env->mip);
+    KVM_RISCV_SET_CSR(cs, env, satp, env->satp);
+
+    return ret;
+}
+
 static int kvm_riscv_get_regs_fp(CPUState *cs)
 {
     int ret = 0;
@@ -148,6 +199,40 @@ static int kvm_riscv_get_regs_fp(CPUState *cs)
     return ret;
 }
 
+static int kvm_riscv_put_regs_fp(CPUState *cs)
+{
+    int ret = 0;
+    int i;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    if (riscv_has_ext(env, RVD)) {
+        uint64_t reg;
+        for (i = 0; i < 32; i++) {
+            reg = env->fpr[i];
+            ret = kvm_set_one_reg(cs, RISCV_FP_D_REG(env, i), &reg);
+            if (ret) {
+                return ret;
+            }
+        }
+        return ret;
+    }
+
+    if (riscv_has_ext(env, RVF)) {
+        uint32_t reg;
+        for (i = 0; i < 32; i++) {
+            reg = env->fpr[i];
+            ret = kvm_set_one_reg(cs, RISCV_FP_F_REG(env, i), &reg);
+            if (ret) {
+                return ret;
+            }
+        }
+        return ret;
+    }
+
+    return ret;
+}
+
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
@@ -176,7 +261,24 @@ int kvm_arch_get_registers(CPUState *cs)
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    return 0;
+    int ret = 0;
+
+    ret = kvm_riscv_put_regs_core(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_riscv_put_regs_csr(cs);
+    if (ret) {
+        return ret;
+    }
+
+    ret = kvm_riscv_put_regs_fp(cs);
+    if (ret) {
+        return ret;
+    }
+
+    return ret;
 }
 
 int kvm_arch_release_virq_post(int virq)
-- 
2.19.1

