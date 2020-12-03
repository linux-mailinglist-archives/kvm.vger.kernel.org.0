Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E39A2CD56C
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbgLCMV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:21:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9098 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730455AbgLCMVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:21:55 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cmw0N6GcxzLywj;
        Thu,  3 Dec 2020 20:20:36 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:21:05 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <anup.patel@wdc.com>, <atish.patra@wdc.com>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pbonzini@redhat.com>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC 1/3] RISC-V: KVM: Change the method of calculating cycles to nanoseconds
Date:   Thu, 3 Dec 2020 20:18:37 +0800
Message-ID: <20201203121839.308-2-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20201203121839.308-1-jiangyifei@huawei.com>
References: <20201203121839.308-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.186.236]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because we will introduce the dynamic guest frequency later, we
can't use the fixed mult and shift to calculate nanoseconds.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 arch/riscv/include/asm/kvm_vcpu_timer.h | 3 ---
 arch/riscv/kvm/vcpu_timer.c             | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
index 375281eb49e0..87e00d878999 100644
--- a/arch/riscv/include/asm/kvm_vcpu_timer.h
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -12,9 +12,6 @@
 #include <linux/hrtimer.h>
 
 struct kvm_guest_timer {
-	/* Mult & Shift values to get nanoseconds from cycles */
-	u32 nsec_mult;
-	u32 nsec_shift;
 	/* Time delta value */
 	u64 time_delta;
 };
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index ddd0ce727b83..f6b35180199a 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -33,7 +33,7 @@ static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
 		cycles_delta = cycles - cycles_now;
 	else
 		cycles_delta = 0;
-	delta_ns = (cycles_delta * gt->nsec_mult) >> gt->nsec_shift;
+	delta_ns = mul_u64_u64_div_u64(cycles_delta, NSEC_PER_SEC, riscv_timebase);
 	local_irq_restore(flags);
 
 	return delta_ns;
@@ -218,7 +218,6 @@ int kvm_riscv_guest_timer_init(struct kvm *kvm)
 {
 	struct kvm_guest_timer *gt = &kvm->arch.timer;
 
-	riscv_cs_get_mult_shift(&gt->nsec_mult, &gt->nsec_shift);
 	gt->time_delta = -get_cycles64();
 
 	return 0;
-- 
2.19.1

