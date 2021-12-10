Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7303F46FE6F
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbhLJKLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:11:20 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29119 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbhLJKLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:11:19 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J9RN24p3Bz1DLfF;
        Fri, 10 Dec 2021 18:04:50 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:07:43 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 10 Dec
 2021 18:07:42 +0800
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
Subject: [PATCH v2 03/12] target/riscv: Implement function kvm_arch_init_vcpu
Date:   Fri, 10 Dec 2021 18:07:23 +0800
Message-ID: <20211210100732.1080-4-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211210100732.1080-1-jiangyifei@huawei.com>
References: <20211210100732.1080-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get isa info from kvm while kvm init.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/kvm.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 687dd4b621..ccf3753048 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -38,6 +38,23 @@
 #include "qemu/log.h"
 #include "hw/loader.h"
 
+static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
+{
+    uint64_t id = KVM_REG_RISCV | type | idx;
+
+    switch (riscv_cpu_mxl(env)) {
+    case MXL_RV32:
+        id |= KVM_REG_SIZE_U32;
+        break;
+    case MXL_RV64:
+        id |= KVM_REG_SIZE_U64;
+        break;
+    default:
+        g_assert_not_reached();
+    }
+    return id;
+}
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
@@ -79,7 +96,20 @@ void kvm_arch_init_irq_routing(KVMState *s)
 
 int kvm_arch_init_vcpu(CPUState *cs)
 {
-    return 0;
+    int ret = 0;
+    target_ulong isa;
+    RISCVCPU *cpu = RISCV_CPU(cs);
+    CPURISCVState *env = &cpu->env;
+    uint64_t id;
+
+    id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG, KVM_REG_RISCV_CONFIG_REG(isa));
+    ret = kvm_get_one_reg(cs, id, &isa);
+    if (ret) {
+        return ret;
+    }
+    env->misa_ext = isa;
+
+    return ret;
 }
 
 int kvm_arch_msi_data_to_gsi(uint32_t data)
-- 
2.19.1

