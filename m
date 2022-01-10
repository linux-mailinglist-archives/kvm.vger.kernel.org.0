Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530F8488E2B
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 02:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbiAJBjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 20:39:54 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:34889 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbiAJBjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 20:39:20 -0500
Received: from kwepemi100003.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JXGgg6lL1zcbpl;
        Mon, 10 Jan 2022 09:38:39 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100003.china.huawei.com (7.221.188.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 09:39:17 +0800
Received: from huawei.com (10.174.186.236) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 10 Jan
 2022 09:39:15 +0800
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
Subject: [PATCH v4 12/12] target/riscv: Support virtual time context synchronization
Date:   Mon, 10 Jan 2022 09:38:31 +0800
Message-ID: <20220110013831.1594-13-jiangyifei@huawei.com>
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

Add virtual time context description to vmstate_kvmtimer. After cpu being
loaded, virtual time context is updated to KVM.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
---
 target/riscv/machine.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/riscv/machine.c b/target/riscv/machine.c
index ad8248ebfd..95eb82792a 100644
--- a/target/riscv/machine.c
+++ b/target/riscv/machine.c
@@ -164,6 +164,35 @@ static const VMStateDescription vmstate_pointermasking = {
     }
 };
 
+static bool kvmtimer_needed(void *opaque)
+{
+    return kvm_enabled();
+}
+
+static int cpu_post_load(void *opaque, int version_id)
+{
+    RISCVCPU *cpu = opaque;
+    CPURISCVState *env = &cpu->env;
+
+    env->kvm_timer_dirty = true;
+    return 0;
+}
+
+static const VMStateDescription vmstate_kvmtimer = {
+    .name = "cpu/kvmtimer",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = kvmtimer_needed,
+    .post_load = cpu_post_load,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
+        VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
+        VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
+
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 const VMStateDescription vmstate_riscv_cpu = {
     .name = "cpu",
     .version_id = 3,
@@ -218,6 +247,7 @@ const VMStateDescription vmstate_riscv_cpu = {
         &vmstate_hyper,
         &vmstate_vector,
         &vmstate_pointermasking,
+        &vmstate_kvmtimer,
         NULL
     }
 };
-- 
2.19.1

