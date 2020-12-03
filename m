Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B6A2CD5D4
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbgLCMsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:48:33 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9368 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgLCMsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:48:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CmwbD30yNz777t;
        Thu,  3 Dec 2020 20:47:20 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:47:40 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v4 14/15] target/riscv: Synchronize vcpu's frequency with KVM
Date:   Thu, 3 Dec 2020 20:47:02 +0800
Message-ID: <20201203124703.168-15-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20201203124703.168-1-jiangyifei@huawei.com>
References: <20201203124703.168-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If vcpu's frequency is specified by cpu option 'frequency', it
will be set into KVM by KVM_SET_ONE_REG ioctl. Otherwise, vcpu's
frequency will follow KVM by KVM_GET_ONE_REG ioctl.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 target/riscv/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 1e16d24544..3499efd4eb 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -409,6 +409,8 @@ int kvm_arch_get_registers(CPUState *cs)
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
     int ret = 0;
+    RISCVCPU *cpu = RISCV_CPU(cs);
+    CPURISCVState *env = &cpu->env;
 
     ret = kvm_riscv_put_regs_core(cs);
     if (ret) {
@@ -425,6 +427,10 @@ int kvm_arch_put_registers(CPUState *cs, int level)
         return ret;
     }
 
+    if (env->frequency) {
+        ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(frequency), &env->frequency);
+    }
+
     return ret;
 }
 
@@ -481,6 +487,17 @@ int kvm_arch_init_vcpu(CPUState *cs)
     }
     env->misa = isa;
 
+    /*
+     * Synchronize vcpu's frequency with KVM. If vcpu's frequency is specified
+     * by cpu option 'frequency', this will be set to KVM. Otherwise, vcpu's
+     * frequency will follow KVM.
+     */
+    if (env->user_frequency) {
+        ret = kvm_set_one_reg(cs, RISCV_TIMER_REG(frequency), &env->frequency);
+    } else {
+        ret = kvm_get_one_reg(cs, RISCV_TIMER_REG(frequency), &env->frequency);
+    }
+
     return ret;
 }
 
-- 
2.19.1

