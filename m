Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8AC2CD5D5
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389004AbgLCMsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:48:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8627 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388928AbgLCMsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:48:35 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CmwbK0by7z15X07;
        Thu,  3 Dec 2020 20:47:25 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:47:42 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-riscv@nongnu.org>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <libvir-list@redhat.com>, <anup.patel@wdc.com>,
        <palmer@dabbelt.com>, <Alistair.Francis@wdc.com>,
        <sagark@eecs.berkeley.edu>, <kbastian@mail.uni-paderborn.de>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC v4 15/15] target/riscv: Add time frequency migration support
Date:   Thu, 3 Dec 2020 20:47:03 +0800
Message-ID: <20201203124703.168-16-jiangyifei@huawei.com>
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

If vcpu's time frequency is not specified by CPU option 'time-frequency'
on the destination, the time frequency of destination will follow
the source.

If vcpu's time frequency specified by CPU option 'time-frequency' on the
destination is different from migrated time frequency. The migration
will be abort.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 target/riscv/machine.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/riscv/machine.c b/target/riscv/machine.c
index ef2d5395a8..6955542fef 100644
--- a/target/riscv/machine.c
+++ b/target/riscv/machine.c
@@ -144,6 +144,13 @@ static int cpu_post_load(void *opaque, int version_id)
     CPURISCVState *env = &cpu->env;
 
     env->kvm_timer_dirty = true;
+
+    if (env->user_frequency && env->user_frequency != env->frequency) {
+        error_report("Mismatch between user-specified time frequency and "
+                     "migrated time frequency");
+        return -EINVAL;
+    }
+
     return 0;
 }
 
@@ -198,6 +205,7 @@ const VMStateDescription vmstate_riscv_cpu = {
         VMSTATE_UINT64(env.kvm_timer_time, RISCVCPU),
         VMSTATE_UINT64(env.kvm_timer_compare, RISCVCPU),
         VMSTATE_UINT64(env.kvm_timer_state, RISCVCPU),
+        VMSTATE_UINT64(env.frequency, RISCVCPU),
 
         VMSTATE_END_OF_LIST()
     },
-- 
2.19.1

