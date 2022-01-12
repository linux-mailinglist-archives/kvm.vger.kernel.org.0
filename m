Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973DA48BFA0
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 09:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351488AbiALIOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 03:14:00 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16704 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351487AbiALIN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 03:13:58 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JYgGh2ztFzZf9t;
        Wed, 12 Jan 2022 16:10:20 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 16:13:56 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 12 Jan
 2022 16:13:55 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup@brainfault.org>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>,
        Anup Patel <anup.patel@wdc.com>,
        Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH v5 11/13] target/riscv: Implement virtual time adjusting with vm state changing
Date:   Wed, 12 Jan 2022 16:13:27 +0800
Message-ID: <20220112081329.1835-12-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20220112081329.1835-1-jiangyifei@huawei.com>
References: <20220112081329.1835-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We hope that virtual time adjusts with vm state changing. When a vm
is stopped, guest virtual time should stop counting and kvm_timer
should be stopped. When the vm is resumed, guest virtual time should
continue to count and kvm_timer should be restored.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/kvm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index a43d5a2988..e6b7cb6d4d 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -41,6 +41,7 @@
 #include "sbi_ecall_interface.h"
 #include "chardev/char-fe.h"
 #include "migration/migration.h"
+#include "sysemu/runstate.h"
 
 static uint64_t kvm_riscv_reg_id(CPURISCVState *env, uint64_t type,
                                  uint64_t idx)
@@ -378,6 +379,18 @@ unsigned long kvm_arch_vcpu_id(CPUState *cpu)
     return cpu->cpu_index;
 }
 
+static void kvm_riscv_vm_state_change(void *opaque, bool running,
+                                      RunState state)
+{
+    CPUState *cs = opaque;
+
+    if (running) {
+        kvm_riscv_put_regs_timer(cs);
+    } else {
+        kvm_riscv_get_regs_timer(cs);
+    }
+}
+
 void kvm_arch_init_irq_routing(KVMState *s)
 {
 }
@@ -390,6 +403,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     CPURISCVState *env = &cpu->env;
     uint64_t id;
 
+    qemu_add_vm_change_state_handler(kvm_riscv_vm_state_change, cs);
+
     id = kvm_riscv_reg_id(env, KVM_REG_RISCV_CONFIG,
                           KVM_REG_RISCV_CONFIG_REG(isa));
     ret = kvm_get_one_reg(cs, id, &isa);
-- 
2.19.1

