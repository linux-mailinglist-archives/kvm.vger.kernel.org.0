Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182DF457C4E
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 08:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhKTHvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 02:51:02 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28163 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhKTHuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 02:50:16 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hx5DP4Qwnz8vTQ;
        Sat, 20 Nov 2021 15:45:25 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 20 Nov 2021 15:47:12 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 15:47:11 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <bin.meng@windriver.com>, <fanliang@huawei.com>,
        <wu.wubin@huawei.com>, <wanghaibin.wang@huawei.com>,
        <wanbo13@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>,
        Mingwang Li <limingwang@huawei.com>
Subject: [PATCH v1 12/12] target/riscv: Support virtual time context synchronization
Date:   Sat, 20 Nov 2021 15:46:44 +0800
Message-ID: <20211120074644.729-13-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20211120074644.729-1-jiangyifei@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add virtual time context description to vmstate_riscv_cpu. After cpu being
loaded, virtual time context is updated to KVM.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
---
 target/riscv/machine.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/riscv/machine.c b/target/riscv/machine.c
index ad8248ebfd..153215549b 100644
--- a/target/riscv/machine.c
+++ b/target/riscv/machine.c
@@ -164,10 +164,20 @@ static const VMStateDescription vmstate_pointermasking = {
     }
 };
 
+static int cpu_post_load(void *opaque, int version_id)
+{
+    RISCVCPU *cpu = opaque;
+    CPURISCVState *env = &cpu->env;
+
+    env->kvm_timer_dirty = true;
+    return 0;
+}
+
 const VMStateDescription vmstate_riscv_cpu = {
     .name = "cpu",
     .version_id = 3,
     .minimum_version_id = 3,
+    .post_load = cpu_post_load,
     .fields = (VMStateField[]) {
         VMSTATE_UINTTL_ARRAY(env.gpr, RISCVCPU, 32),
         VMSTATE_UINT64_ARRAY(env.fpr, RISCVCPU, 32),
@@ -211,6 +221,10 @@ const VMStateDescription vmstate_riscv_cpu = {
         VMSTATE_UINT64(env.mtohost, RISCVCPU),
         VMSTATE_UINT64(env.timecmp, RISCVCPU),
 
+        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
+        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
+        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
+
         VMSTATE_END_OF_LIST()
     },
     .subsections = (const VMStateDescription * []) {
-- 
2.19.1

