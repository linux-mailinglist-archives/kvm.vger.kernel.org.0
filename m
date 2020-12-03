Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2692CD570
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388901AbgLCMWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:22:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8622 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgLCMWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 07:22:05 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cmw0d67pXz15WyR;
        Thu,  3 Dec 2020 20:20:49 +0800 (CST)
Received: from huawei.com (10.174.186.236) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Dec 2020
 20:21:09 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <anup.patel@wdc.com>, <atish.patra@wdc.com>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pbonzini@redhat.com>
CC:     <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <victor.zhangxiaofeng@huawei.com>, <wu.wubin@huawei.com>,
        <zhang.zhanghailiang@huawei.com>, <dengkai1@huawei.com>,
        <yinyipeng1@huawei.com>, Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH RFC 3/3] RISC-V: KVM: Implement guest time scaling
Date:   Thu, 3 Dec 2020 20:18:39 +0800
Message-ID: <20201203121839.308-4-jiangyifei@huawei.com>
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

When time frequency needs to scale, RDTIME/RDTIMEH instruction in guest
doesn't work correctly. Because it still uses the host's time frequency.

To read correct time, the RDTIME/RDTIMEH instruction executed by guest
should trap to HS-mode. The TM bit of HCOUNTEREN CSR could control whether
these instructions are trapped to HS-mode. Therefore, we can implement guest
time scaling by setting TM bit in kvm_riscv_vcpu_timer_restore() and emulating
RDTIME/RDTIMEH instruction in system_opcode_insn().

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Yipeng Yin <yinyipeng1@huawei.com>
---
 arch/riscv/include/asm/csr.h            |  3 +++
 arch/riscv/include/asm/kvm_vcpu_timer.h |  1 +
 arch/riscv/kvm/vcpu_exit.c              | 35 +++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_timer.c             | 10 +++++++
 4 files changed, 49 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index bc825693e0e3..a4d8ca76cf1d 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -241,6 +241,9 @@
 #define IE_TIE		(_AC(0x1, UL) << RV_IRQ_TIMER)
 #define IE_EIE		(_AC(0x1, UL) << RV_IRQ_EXT)
 
+/* The counteren flag */
+#define CE_TM		1
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
index 41b5503de9e4..61384eb57334 100644
--- a/arch/riscv/include/asm/kvm_vcpu_timer.h
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -41,6 +41,7 @@ int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
 int kvm_riscv_guest_timer_init(struct kvm *kvm);
+u64 kvm_riscv_read_guest_time(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_riscv_need_scale(struct kvm_guest_timer *gt)
 {
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index f054406792a6..4beb9d25049a 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -18,6 +18,10 @@
 
 #define INSN_MASK_WFI		0xffffff00
 #define INSN_MATCH_WFI		0x10500000
+#define INSN_MASK_RDTIME	0xfff03000
+#define INSN_MATCH_RDTIME	0xc0102000
+#define INSN_MASK_RDTIMEH	0xfff03000
+#define INSN_MATCH_RDTIMEH	0xc8102000
 
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
@@ -138,6 +142,34 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int system_opcode_insn_rdtime(struct kvm_vcpu *vcpu,
+				     struct kvm_run *run,
+				     ulong insn)
+{
+#ifdef CONFIG_64BIT
+	if ((insn & INSN_MASK_RDTIME) == INSN_MATCH_RDTIME) {
+		u64 guest_time = kvm_riscv_read_guest_time(vcpu);
+		SET_RD(insn, &vcpu->arch.guest_context, guest_time);
+		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+		return 1;
+	}
+#else
+	if ((insn & INSN_MASK_RDTIME) == INSN_MATCH_RDTIME) {
+		u64 guest_time = kvm_riscv_read_guest_time(vcpu);
+		SET_RD(insn, &vcpu->arch.guest_context, (u32)guest_time);
+		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+		return 1;
+	}
+	if ((insn & INSN_MASK_RDTIMEH) == INSN_MATCH_RDTIMEH) {
+		u64 guest_time = kvm_riscv_read_guest_time(vcpu);
+		SET_RD(insn, &vcpu->arch.guest_context, (u32)(guest_time >> 32));
+		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+		return 1;
+	}
+#endif
+	return 0;
+}
+
 static int system_opcode_insn(struct kvm_vcpu *vcpu,
 			      struct kvm_run *run,
 			      ulong insn)
@@ -154,6 +186,9 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
+	if (system_opcode_insn_rdtime(vcpu, run, insn))
+		return 1;
+
 	return truly_illegal_insn(vcpu, run, insn);
 }
 
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 2d203660a7e9..2040dbe57ee6 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -49,6 +49,11 @@ static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
 	return kvm_riscv_scale_time(gt, host_time) + gt->time_delta;
 }
 
+u64 kvm_riscv_read_guest_time(struct kvm_vcpu *vcpu)
+{
+	return kvm_riscv_current_cycles(&vcpu->kvm->arch.timer);
+}
+
 static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
 				     struct kvm_guest_timer *gt,
 				     struct kvm_vcpu_timer *t)
@@ -241,6 +246,11 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 	csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
 	csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
 #endif
+
+	if (kvm_riscv_need_scale(gt))
+		csr_clear(CSR_HCOUNTEREN, 1UL << CE_TM);
+	else
+		csr_set(CSR_HCOUNTEREN, 1UL << CE_TM);
 }
 
 int kvm_riscv_guest_timer_init(struct kvm *kvm)
-- 
2.19.1

