Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E433EE501
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 05:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHQDZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 23:25:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236898AbhHQDZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 23:25:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GpbsY2295zdZdc;
        Tue, 17 Aug 2021 11:21:21 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:25:04 +0800
Received: from huawei.com (10.174.186.236) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 17 Aug
 2021 11:25:04 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <wu.wubin@huawei.com>,
        <fanliang@huawei.com>, <wanghaibin.wang@huawei.com>,
        <limingwang@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH RFC v6 04/12] target/riscv: Implement kvm_arch_get_registers
Date:   Tue, 17 Aug 2021 11:24:39 +0800
Message-ID: <20210817032447.2055-5-jiangyifei@huawei.com>
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

Get GPR CSR and FP registers from kvm by KVM_GET_ONE_REG ioctl.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/kvm.c | 150 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 149 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index dd3bbd7ceb..128a9922e8 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -50,13 +50,161 @@ static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx
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
+    target_ulong reg;
+    CPURISCVState *env = &RISCV_CPU(cs)->env;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sstatus), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->mstatus = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sie), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->mie = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stvec), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->stvec = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sscratch), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->sscratch = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sepc), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->sepc = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, scause), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->scause = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, stval), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->stval = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, sip), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->mip = reg;
+
+    ret = kvm_get_one_reg(cs, RISCV_CSR_REG(env, satp), &reg);
+    if (ret) {
+        return ret;
+    }
+    env->satp = reg;
+
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

