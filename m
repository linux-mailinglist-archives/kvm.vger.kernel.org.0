Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED6824607F
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgHQIlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:41:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgHQIl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:41:29 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5AAED57CF9022F757412;
        Mon, 17 Aug 2020 16:41:22 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:41:15 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH 5/5] clocksource: arm_arch_timer: Use pvtime LPT
Date:   Mon, 17 Aug 2020 16:41:10 +0800
Message-ID: <20200817084110.2672-6-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable paravirtualized time to be used in a KVM guest if the host
supports it. This allows the guest to derive a counter which is clocked
at a persistent rate even when the guest is migrated.

If we discover that the system supports SMCCC v1.1 then we probe to
determine whether the hypervisor supports paravirtualized features and
finally whether it supports "Live Physical Time" reporting. If so a
shared structure is made available to the guest containing coefficients
to calculate the derived clock.

The guest kernel uses the coefficients to present a clock to user space
that is always clocked at the same rate whenever the guest is running
('live'), even if the physical clock changes (due to the guest being
migrated).

The existing workaround framework for CNTVCT is used to trap user space
accesses to the timer registers so we can present the derived clock.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/arch_timer.h  | 179 ++++++++++++++++++++++++++++++++---
 drivers/clocksource/arm_arch_timer.c |  59 +++++++-----
 2 files changed, 204 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9f0ec21..bbaecf1 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -10,6 +10,7 @@
 
 #include <asm/barrier.h>
 #include <asm/hwcap.h>
+#include <asm/pvclock-abi.h>
 #include <asm/sysreg.h>
 
 #include <linux/bug.h>
@@ -64,25 +65,178 @@ struct arch_timer_erratum_workaround {
 DECLARE_PER_CPU(const struct arch_timer_erratum_workaround *,
 		timer_unstable_counter_workaround);
 
+
+extern struct pvclock_vm_lpt_time *lpt_info;
+DECLARE_STATIC_KEY_FALSE(pvclock_lpt_key_enabled);
+
+/* LPT read/write base layer */
+
+#define lpt_read_base(target, trans, read) ({				\
+	__le64 _seq_begin, _seq_end;					\
+	u64 _nval, _pval;						\
+									\
+	do {								\
+		_seq_begin = READ_ONCE(lpt_info->sequence_number);	\
+		/* LPT structure can be treated as readonly device */	\
+		rmb();							\
+									\
+		_nval = read(target);					\
+		_pval = trans(_nval);					\
+									\
+		rmb();							\
+		_seq_end = READ_ONCE(lpt_info->sequence_number);	\
+	} while (unlikely(_seq_begin != _seq_end));			\
+									\
+	_pval;								\
+})
+
+#define lpt_write_base(val, target, trans, write) ({			\
+	__le64 _seq_begin, _seq_end;					\
+	u64 _pval = val;						\
+	u64 _nval;							\
+									\
+	do {								\
+		_seq_begin = READ_ONCE(lpt_info->sequence_number);	\
+		/* LPT structure can be treated as readonly device */	\
+		rmb();							\
+									\
+		_nval = trans(_pval);					\
+		write(_nval, target);					\
+									\
+		rmb();							\
+		_seq_end = READ_ONCE(lpt_info->sequence_number);	\
+	} while (unlikely(_seq_begin != _seq_end));			\
+})
+
+#define lpt_read(target, trans, read) ({				\
+	u64 _val;							\
+									\
+	if (static_branch_unlikely(&pvclock_lpt_key_enabled)) {		\
+		_val = lpt_read_base(target, trans, read);		\
+	} else {							\
+		_val = read(target);					\
+	}								\
+									\
+	_val;								\
+})
+
+#define lpt_write(val, target, trans, write) ({				\
+	if (static_branch_unlikely(&pvclock_lpt_key_enabled)) {		\
+		lpt_write_base(val, target, trans, write);		\
+	} else {							\
+		write(val, target);					\
+	}								\
+})
+
+/* LPT read/write layer for timer and count */
+
+static inline u64 native_to_pv_cycles(u64 cnt)
+{
+	u64 scale_mult = le64_to_cpu(lpt_info->scale_mult);
+	u32 fracbits = le32_to_cpu(lpt_info->fracbits);
+
+	return mul_u64_u64_shr(scale_mult, cnt, fracbits);
+}
+
+static inline u64 pv_to_native_cycles(u64 cnt)
+{
+	u64 rscale_mult = le64_to_cpu(lpt_info->rscale_mult);
+	u32 rfracbits = le32_to_cpu(lpt_info->rfracbits);
+
+	return mul_u64_u64_shr(rscale_mult, cnt, rfracbits);
+}
+
+#define arch_timer_read_mediated(reg) ({				\
+	lpt_read(reg, native_to_pv_cycles, read_sysreg);		\
+})
+
+#define arch_timer_write_mediated(val, reg) ({				\
+	u64 _val = val;							\
+	lpt_write(_val, reg, pv_to_native_cycles, write_sysreg);	\
+})
+
+#define mem_timer_read_mediated(addr) ({				\
+	lpt_read(addr, native_to_pv_cycles, readl_relaxed);		\
+})
+
+#define mem_timer_write_mediated(val, addr) ({				\
+	u64 _val = val;							\
+	lpt_write(_val, addr, pv_to_native_cycles, writel_relaxed);	\
+})
+
+/* LPT read/write layer for cntkctl_el1 */
+
+static inline int cntkctl_evnti_shift(void)
+{
+	u32 native_freq = le32_to_cpu(lpt_info->native_freq);
+	u32 pv_freq = le32_to_cpu(lpt_info->pv_freq);
+	int div, shift;
+
+	if (pv_freq >= native_freq)
+		div = pv_freq / native_freq;
+	else
+		div = native_freq / pv_freq;
+
+	/* Find the closest power of two to the divisor */
+	shift = fls(div);
+	if ((shift == 1) || (shift > 1 && !(shift & (1 << (shift - 2)))))
+		shift--;
+
+	return pv_freq >= native_freq ? shift : -shift;
+}
+
+static inline u64 parse_cntkctl(u64 val, bool native_to_pv)
+{
+	int evnti = (val >> ARCH_TIMER_EVT_TRIGGER_SHIFT) & 0xF;
+
+	if (native_to_pv)
+		evnti = evnti + cntkctl_evnti_shift();
+	else
+		evnti = evnti - cntkctl_evnti_shift();
+
+	evnti = min(15, max(0, evnti));
+	val &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+	val |= evnti << ARCH_TIMER_EVT_TRIGGER_SHIFT;
+
+	return val;
+}
+
+#define TRANS_CNTKCTL_N(nval) ({					\
+	parse_cntkctl(nval, true);					\
+})
+
+#define TRANS_CNTKCTL_P(pval) ({					\
+	parse_cntkctl(pval, false);					\
+})
+
+#define arch_timer_read_cntkctl_mediated() ({				\
+	lpt_read(cntkctl_el1, TRANS_CNTKCTL_N, read_sysreg);		\
+})
+
+#define arch_timer_write_cntkctl_mediated(val) ({			\
+	u64 _val = val;							\
+	lpt_write(_val, cntkctl_el1, TRANS_CNTKCTL_P, write_sysreg);	\
+})
+
 /* inline sysreg accessors that make erratum_handler() work */
 static inline notrace u32 arch_timer_read_cntp_tval_el0(void)
 {
-	return read_sysreg(cntp_tval_el0);
+	return arch_timer_read_mediated(cntp_tval_el0);
 }
 
 static inline notrace u32 arch_timer_read_cntv_tval_el0(void)
 {
-	return read_sysreg(cntv_tval_el0);
+	return arch_timer_read_mediated(cntv_tval_el0);
 }
 
 static inline notrace u64 arch_timer_read_cntpct_el0(void)
 {
-	return read_sysreg(cntpct_el0);
+	return arch_timer_read_mediated(cntpct_el0);
 }
 
 static inline notrace u64 arch_timer_read_cntvct_el0(void)
 {
-	return read_sysreg(cntvct_el0);
+	return arch_timer_read_mediated(cntvct_el0);
 }
 
 #define arch_timer_reg_read_stable(reg)					\
@@ -110,7 +264,7 @@ void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
 			write_sysreg(val, cntp_ctl_el0);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			write_sysreg(val, cntp_tval_el0);
+			arch_timer_write_mediated(val, cntp_tval_el0);
 			break;
 		}
 	} else if (access == ARCH_TIMER_VIRT_ACCESS) {
@@ -119,7 +273,7 @@ void arch_timer_reg_write_cp15(int access, enum arch_timer_reg reg, u32 val)
 			write_sysreg(val, cntv_ctl_el0);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			write_sysreg(val, cntv_tval_el0);
+			arch_timer_write_mediated(val, cntv_tval_el0);
 			break;
 		}
 	}
@@ -151,17 +305,20 @@ u32 arch_timer_reg_read_cp15(int access, enum arch_timer_reg reg)
 
 static inline u32 arch_timer_get_cntfrq(void)
 {
-	return read_sysreg(cntfrq_el0);
+	if (static_branch_unlikely(&pvclock_lpt_key_enabled))
+		return le32_to_cpu(lpt_info->pv_freq);
+	else
+		return read_sysreg(cntfrq_el0);
 }
 
 static inline u32 arch_timer_get_cntkctl(void)
 {
-	return read_sysreg(cntkctl_el1);
+	return arch_timer_read_cntkctl_mediated();
 }
 
 static inline void arch_timer_set_cntkctl(u32 cntkctl)
 {
-	write_sysreg(cntkctl, cntkctl_el1);
+	arch_timer_write_cntkctl_mediated(cntkctl);
 	isb();
 }
 
@@ -199,7 +356,7 @@ static __always_inline u64 __arch_counter_get_cntpct(void)
 	u64 cnt;
 
 	isb();
-	cnt = read_sysreg(cntpct_el0);
+	cnt = arch_timer_read_mediated(cntpct_el0);
 	arch_counter_enforce_ordering(cnt);
 	return cnt;
 }
@@ -219,7 +376,7 @@ static __always_inline u64 __arch_counter_get_cntvct(void)
 	u64 cnt;
 
 	isb();
-	cnt = read_sysreg(cntvct_el0);
+	cnt = arch_timer_read_mediated(cntvct_el0);
 	arch_counter_enforce_ordering(cnt);
 	return cnt;
 }
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index eb2e57a..28277b0 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -26,7 +26,6 @@
 #include <linux/acpi.h>
 
 #include <asm/arch_timer.h>
-#include <asm/pvclock-abi.h>
 #include <asm/virt.h>
 
 #include <clocksource/arm_arch_timer.h>
@@ -137,11 +136,24 @@ static int pvclock_lpt_init(void)
 	pr_info("Using pvclock LPT\n");
 	return 0;
 }
+
+static bool pvclock_lpt_enabled(void)
+{
+	return static_branch_unlikely(&pvclock_lpt_key_enabled);
+}
 #else /* CONFIG_ARM64 */
 static int pvclock_lpt_init(void)
 {
 	return 0;
 }
+
+static bool pvclock_lpt_enabled(void)
+{
+	return false;
+}
+
+#define mem_timer_read_mediated(val, addr) (readl_relaxed(val, addr))
+#define mem_timer_write_mediated(val, addr) (writel_relaxed(val, addr))
 #endif /* CONFIG_ARM64 */
 
 
@@ -160,7 +172,7 @@ void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
 			writel_relaxed(val, timer->base + CNTP_CTL);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			writel_relaxed(val, timer->base + CNTP_TVAL);
+			mem_timer_write_mediated(val, timer->base + CNTP_TVAL);
 			break;
 		}
 	} else if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
@@ -170,7 +182,7 @@ void arch_timer_reg_write(int access, enum arch_timer_reg reg, u32 val,
 			writel_relaxed(val, timer->base + CNTV_CTL);
 			break;
 		case ARCH_TIMER_REG_TVAL:
-			writel_relaxed(val, timer->base + CNTV_TVAL);
+			mem_timer_write_mediated(val, timer->base + CNTV_TVAL);
 			break;
 		}
 	} else {
@@ -279,8 +291,8 @@ struct ate_acpi_oem_info {
 	int _retries = 200;				\
 							\
 	do {						\
-		_old = read_sysreg(reg);		\
-		_new = read_sysreg(reg);		\
+		_old = arch_timer_read_mediated(reg);	\
+		_new = arch_timer_read_mediated(reg);	\
 		_retries--;				\
 	} while (unlikely(_old != _new) && _retries);	\
 							\
@@ -325,8 +337,8 @@ static u64 notrace fsl_a008585_read_cntvct_el0(void)
 	int _retries = 50;					\
 								\
 	do {							\
-		_old = read_sysreg(reg);			\
-		_new = read_sysreg(reg);			\
+		_old = arch_timer_read_mediated(reg);		\
+		_new = arch_timer_read_mediated(reg);		\
 		_retries--;					\
 	} while (unlikely((_new - _old) >> 5) && _retries);	\
 								\
@@ -383,8 +395,8 @@ static u64 notrace arm64_858921_read_cntpct_el0(void)
 {
 	u64 old, new;
 
-	old = read_sysreg(cntpct_el0);
-	new = read_sysreg(cntpct_el0);
+	old = arch_timer_read_mediated(cntpct_el0);
+	new = arch_timer_read_mediated(cntpct_el0);
 	return (((old ^ new) >> 32) & 1) ? old : new;
 }
 
@@ -392,8 +404,8 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 {
 	u64 old, new;
 
-	old = read_sysreg(cntvct_el0);
-	new = read_sysreg(cntvct_el0);
+	old = arch_timer_read_mediated(cntvct_el0);
+	new = arch_timer_read_mediated(cntvct_el0);
 	return (((old ^ new) >> 32) & 1) ? old : new;
 }
 #endif
@@ -411,7 +423,7 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 	int _retries = 150;						\
 									\
 	do {								\
-		_val = read_sysreg(reg);				\
+		_val = arch_timer_read_mediated(reg);			\
 		_retries--;						\
 	} while (((_val + 1) & GENMASK(9, 0)) <= 1 && _retries);	\
 									\
@@ -431,12 +443,14 @@ static u64 notrace sun50i_a64_read_cntvct_el0(void)
 
 static u32 notrace sun50i_a64_read_cntp_tval_el0(void)
 {
-	return read_sysreg(cntp_cval_el0) - sun50i_a64_read_cntpct_el0();
+	return arch_timer_read_mediated(cntp_cval_el0) -
+	       sun50i_a64_read_cntpct_el0();
 }
 
 static u32 notrace sun50i_a64_read_cntv_tval_el0(void)
 {
-	return read_sysreg(cntv_cval_el0) - sun50i_a64_read_cntvct_el0();
+	return arch_timer_read_mediated(cntv_cval_el0) -
+	       sun50i_a64_read_cntvct_el0();
 }
 #endif
 
@@ -458,10 +472,10 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
 
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
 		cval = evt + arch_counter_get_cntpct();
-		write_sysreg(cval, cntp_cval_el0);
+		arch_timer_write_mediated(cval, cntp_cval_el0);
 	} else {
 		cval = evt + arch_counter_get_cntvct();
-		write_sysreg(cval, cntv_cval_el0);
+		arch_timer_write_mediated(cval, cntv_cval_el0);
 	}
 
 	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
@@ -906,12 +920,11 @@ static void arch_counter_set_user_access(void)
 			| ARCH_TIMER_VIRT_EVT_EN
 			| ARCH_TIMER_USR_PCT_ACCESS_EN);
 
-	/*
-	 * Enable user access to the virtual counter if it doesn't
-	 * need to be workaround. The vdso may have been already
+	/* Trap user access to the virtual counter if we support LPT
+	 * or it needs to be workaround. The vdso may have been already
 	 * disabled though.
 	 */
-	if (arch_timer_this_cpu_has_cntvct_wa())
+	if (pvclock_lpt_enabled() || arch_timer_this_cpu_has_cntvct_wa())
 		pr_info("CPU%d: Trapping CNTVCT access\n", smp_processor_id());
 	else
 		cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
@@ -1029,9 +1042,9 @@ static u64 arch_counter_get_cntvct_mem(void)
 	u32 vct_lo, vct_hi, tmp_hi;
 
 	do {
-		vct_hi = readl_relaxed(arch_counter_base + CNTVCT_HI);
-		vct_lo = readl_relaxed(arch_counter_base + CNTVCT_LO);
-		tmp_hi = readl_relaxed(arch_counter_base + CNTVCT_HI);
+		vct_hi = mem_timer_read_mediated(arch_counter_base + CNTVCT_HI);
+		vct_lo = mem_timer_read_mediated(arch_counter_base + CNTVCT_LO);
+		tmp_hi = mem_timer_read_mediated(arch_counter_base + CNTVCT_HI);
 	} while (vct_hi != tmp_hi);
 
 	return ((u64) vct_hi << 32) | vct_lo;
-- 
1.8.3.1

