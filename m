Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABE43EE500
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 05:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhHQDZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 23:25:47 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14219 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbhHQDZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 23:25:37 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GpbxP5mw9z1CXYB;
        Tue, 17 Aug 2021 11:24:41 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 11:25:03 +0800
Received: from huawei.com (10.174.186.236) by dggpemm000001.china.huawei.com
 (7.185.36.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 17 Aug
 2021 11:25:02 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <wu.wubin@huawei.com>,
        <fanliang@huawei.com>, <wanghaibin.wang@huawei.com>,
        <limingwang@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH RFC v6 03/12] target/riscv: Implement function kvm_arch_init_vcpu
Date:   Tue, 17 Aug 2021 11:24:38 +0800
Message-ID: <20210817032447.2055-4-jiangyifei@huawei.com>
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

Get isa info from kvm while kvm init.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/kvm.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 687dd4b621..dd3bbd7ceb 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -38,6 +38,18 @@
 #include "qemu/log.h"
 #include "hw/loader.h"
 
+static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type, uint64_t idx)
+{
+    uint64_t id = KVM_REG_RISCV | type | idx;
+
+    if (riscv_cpu_is_32bit(env)) {
+        id |= KVM_REG_SIZE_U32;
+    } else {
+        id |= KVM_REG_SIZE_U64;
+    }
+    return id;
+}
+
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
 };
@@ -79,7 +91,20 @@ void kvm_arch_init_irq_routing(KVMState *s)
 
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
+    env->misa |= isa;
+
+    return ret;
 }
 
 int kvm_arch_msi_data_to_gsi(uint32_t data)
-- 
2.19.1

