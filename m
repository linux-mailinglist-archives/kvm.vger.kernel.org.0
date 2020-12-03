Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307DB2CD56F
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388846AbgLCMWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:22:03 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8623 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbgLCMWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:22:02 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cmw0d6T1hz15Wyd;
        Thu,  3 Dec 2020 20:20:49 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:21:07 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <anup.patel@wdc.com>, <atish.patra@wdc.com>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pbonzini@redhat.com>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC 2/3] RISC-V: KVM: Support dynamic time frequency from userspace
Date:   Thu, 3 Dec 2020 20:18:38 +0800
Message-ID: <20201203121839.308-3-jiangyifei@huawei.com>
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

This patch implements KVM_S/GET_ONE_REG of time frequency to support
setting dynamic time frequency from userspace. When the time frequency
specified by userspace is inconsistent with host 'riscv_timebase',
it will use scale_mult and scale_shift to calculate guest scaling time.

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 arch/riscv/include/asm/kvm_vcpu_timer.h |  9 ++++++
 arch/riscv/kvm/vcpu_timer.c             | 40 +++++++++++++++++++++----
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
index 87e00d878999..41b5503de9e4 100644
--- a/arch/riscv/include/asm/kvm_vcpu_timer.h
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -12,6 +12,10 @@
 #include <linux/hrtimer.h>
 
 struct kvm_guest_timer {
+	u64 frequency;
+	bool need_scale;
+	u64 scale_mult;
+	u64 scale_shift;
 	/* Time delta value */
 	u64 time_delta;
 };
@@ -38,4 +42,9 @@ int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
 int kvm_riscv_guest_timer_init(struct kvm *kvm);
 
+static inline bool kvm_riscv_need_scale(struct kvm_guest_timer *gt)
+{
+	return gt->need_scale;
+}
+
 #endif
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index f6b35180199a..2d203660a7e9 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -15,9 +15,38 @@
 #include <asm/delay.h>
 #include <asm/kvm_vcpu_timer.h>
 
+#define SCALE_SHIFT_VALUE 48
+#define SCALE_TOLERANCE_HZ 1000
+
+static void kvm_riscv_set_time_freq(struct kvm_guest_timer *gt, u64 freq)
+{
+	/*
+	 * Guest time frequency and Host time frequency are identical
+	 * if the error between them is limited within SCALE_TOLERANCE_HZ.
+	 */
+	u64 diff = riscv_timebase > freq ?
+		   riscv_timebase - freq : freq - riscv_timebase;
+	gt->need_scale = (diff >= SCALE_TOLERANCE_HZ);
+	if (gt->need_scale) {
+		gt->scale_shift = SCALE_SHIFT_VALUE;
+		gt->scale_mult = mul_u64_u32_div(1ULL << gt->scale_shift,
+				 freq, riscv_timebase);
+	}
+	gt->frequency = freq;
+}
+
+static u64 kvm_riscv_scale_time(struct kvm_guest_timer *gt, u64 time)
+{
+	if (kvm_riscv_need_scale(gt))
+		return mul_u64_u64_shr(time, gt->scale_mult, gt->scale_shift);
+
+	return time;
+}
+
 static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
 {
-	return get_cycles64() + gt->time_delta;
+	u64 host_time = get_cycles64();
+	return kvm_riscv_scale_time(gt, host_time) + gt->time_delta;
 }
 
 static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
@@ -33,7 +62,7 @@ static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
 		cycles_delta = cycles - cycles_now;
 	else
 		cycles_delta = 0;
-	delta_ns = mul_u64_u64_div_u64(cycles_delta, NSEC_PER_SEC, riscv_timebase);
+	delta_ns = mul_u64_u64_div_u64(cycles_delta, NSEC_PER_SEC, gt->frequency);
 	local_irq_restore(flags);
 
 	return delta_ns;
@@ -106,7 +135,7 @@ int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_TIMER_REG(frequency):
-		reg_val = riscv_timebase;
+		reg_val = gt->frequency;
 		break;
 	case KVM_REG_RISCV_TIMER_REG(time):
 		reg_val = kvm_riscv_current_cycles(gt);
@@ -150,10 +179,10 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_TIMER_REG(frequency):
-		ret = -EOPNOTSUPP;
+		kvm_riscv_set_time_freq(gt, reg_val);
 		break;
 	case KVM_REG_RISCV_TIMER_REG(time):
-		gt->time_delta = reg_val - get_cycles64();
+		gt->time_delta = reg_val - kvm_riscv_scale_time(gt, get_cycles64());
 		break;
 	case KVM_REG_RISCV_TIMER_REG(compare):
 		t->next_cycles = reg_val;
@@ -219,6 +248,7 @@ int kvm_riscv_guest_timer_init(struct kvm *kvm)
 	struct kvm_guest_timer *gt = &kvm->arch.timer;
 
 	gt->time_delta = -get_cycles64();
+	gt->frequency = riscv_timebase;
 
 	return 0;
 }
-- 
2.19.1

