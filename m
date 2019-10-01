Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CEC3142
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbfJAKYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:24:01 -0400
Received: from foss.arm.com ([217.140.110.172]:46020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbfJAKYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:24:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33DAD1000;
        Tue,  1 Oct 2019 03:24:00 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ECFBB3F739;
        Tue,  1 Oct 2019 03:23:58 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 15/19] arm64: timer: Add test for EL2 timers
Date:   Tue,  1 Oct 2019 11:23:19 +0100
Message-Id: <20191001102323.27628-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When VHE is available, EL2 has two extra timers, the physical and virtual
EL2 timers. Extend the timer test to include them.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/sysreg.h |   8 +++
 arm/timer.c            | 150 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 154 insertions(+), 4 deletions(-)

diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index ed407f93330d..02054fbe2763 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -19,6 +19,14 @@
 #define SYS_CNTV_CTL_EL02	sys_reg(3, 5, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL02	sys_reg(3, 5, 14, 3, 2)
 
+#define SYS_CNTHP_TVAL_EL2	sys_reg(3, 4, 14, 2, 0)
+#define SYS_CNTHP_CTL_EL2	sys_reg(3, 4, 14, 2, 1)
+#define SYS_CNTHP_CVAL_EL2	sys_reg(3, 4, 14, 2, 2)
+
+#define SYS_CNTHV_TVAL_EL2	sys_reg(3, 4, 14, 3, 0)
+#define SYS_CNTHV_CTL_EL2	sys_reg(3, 4, 14, 3, 1)
+#define SYS_CNTHV_CVAL_EL2	sys_reg(3, 4, 14, 3, 2)
+
 #ifdef __ASSEMBLY__
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
 	.equ	.L__reg_num_x\num, \num
diff --git a/arm/timer.c b/arm/timer.c
index 29477ee65878..faab671d0fb1 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -23,6 +23,8 @@ static void *gic_icenabler;
 
 static bool ptimer_unsupported;
 
+static int current_el;
+
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
 {
 	ptimer_unsupported = true;
@@ -159,6 +161,66 @@ static void write_ptimer_ctl_vhe(u64 val)
 	write_sysreg_s(val, SYS_CNTP_CTL_EL02);
 }
 
+static u64 read_hvtimer_cval(void)
+{
+	return read_sysreg_s(SYS_CNTHV_CVAL_EL2);
+}
+
+static void write_hvtimer_cval(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTHV_CVAL_EL2);
+}
+
+static s32 read_hvtimer_tval(void)
+{
+	return read_sysreg_s(SYS_CNTHV_TVAL_EL2);
+}
+
+static void write_hvtimer_tval(s32 val)
+{
+	write_sysreg_s(val, SYS_CNTHV_TVAL_EL2);
+}
+
+static u64 read_hvtimer_ctl(void)
+{
+	return read_sysreg_s(SYS_CNTHV_CTL_EL2);
+}
+
+static void write_hvtimer_ctl(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTHV_CTL_EL2);
+}
+
+static u64 read_hptimer_cval(void)
+{
+	return read_sysreg_s(SYS_CNTHP_CVAL_EL2);
+}
+
+static void write_hptimer_cval(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTHP_CVAL_EL2);
+}
+
+static s32 read_hptimer_tval(void)
+{
+	return read_sysreg_s(SYS_CNTHP_TVAL_EL2);
+}
+
+static void write_hptimer_tval(s32 val)
+{
+	write_sysreg_s(val, SYS_CNTHP_TVAL_EL2);
+}
+
+static u64 read_hptimer_ctl(void)
+{
+	return read_sysreg_s(SYS_CNTHP_CTL_EL2);
+}
+
+static void write_hptimer_ctl(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTHP_CTL_EL2);
+}
+
 struct timer_info {
 	u32 irq;
 	u32 irq_flags;
@@ -216,7 +278,29 @@ static struct timer_info ptimer_info_vhe = {
 	.write_ctl = write_ptimer_ctl_vhe,
 };
 
-static struct timer_info *vtimer, *ptimer;
+static struct timer_info hvtimer_info = {
+	.irq_received = false,
+	.read_counter = read_vtimer_counter,
+	.read_cval = read_hvtimer_cval,
+	.write_cval = write_hvtimer_cval,
+	.read_tval = read_hvtimer_tval,
+	.write_tval = write_hvtimer_tval,
+	.read_ctl = read_hvtimer_ctl,
+	.write_ctl = write_hvtimer_ctl,
+};
+
+static struct timer_info hptimer_info = {
+	.irq_received = false,
+	.read_counter = read_ptimer_counter,
+	.read_cval = read_hptimer_cval,
+	.write_cval = write_hptimer_cval,
+	.read_tval = read_hptimer_tval,
+	.write_tval = write_hptimer_tval,
+	.read_ctl = read_hptimer_ctl,
+	.write_ctl = write_hptimer_ctl,
+};
+
+static struct timer_info *vtimer, *ptimer, *hvtimer, *hptimer;
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
@@ -241,6 +325,10 @@ static void irq_handler(struct pt_regs *regs)
 		info = vtimer;
 	} else if (irqnr == PPI(ptimer->irq)) {
 		info = ptimer;
+	} else if (current_el == CurrentEL_EL2 && irqnr == PPI(hptimer->irq)) {
+		info = hptimer;
+	} else if (current_el == CurrentEL_EL2 && irqnr == PPI(hvtimer->irq)) {
+		info = hvtimer;
 	} else {
 		report_info("Unexpected interrupt: %d\n", irqnr);
 		return;
@@ -362,6 +450,20 @@ static void test_ptimer(void)
 	report_prefix_pop();
 }
 
+static void test_hvtimer(void)
+{
+	report_prefix_push("hvtimer-busy-loop");
+	test_timer(hvtimer);
+	report_prefix_pop();
+}
+
+static void test_hptimer(void)
+{
+	report_prefix_push("hptimer-busy-loop");
+	test_timer(hptimer);
+	report_prefix_pop();
+}
+
 static void test_init(void)
 {
 	const struct fdt_property *prop;
@@ -369,12 +471,14 @@ static void test_init(void)
 	int node, len;
 	u32 *data;
 
-	if (current_level() == CurrentEL_EL1) {
+	if (current_el == CurrentEL_EL1) {
 		vtimer = &vtimer_info;
 		ptimer = &ptimer_info;
 	} else {
 		vtimer = &vtimer_info_vhe;
 		ptimer = &ptimer_info_vhe;
+		hvtimer = &hvtimer_info;
+		hptimer = &hptimer_info;
 	}
 
 	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
@@ -390,6 +494,19 @@ static void test_init(void)
 	vtimer->irq = fdt32_to_cpu(data[7]);
 	vtimer->irq_flags = fdt32_to_cpu(data[8]);
 
+	if (current_el == CurrentEL_EL2) {
+		assert(fdt32_to_cpu(data[9]) == 1);
+		hptimer->irq = fdt32_to_cpu(data[10]);
+		hptimer->irq_flags = fdt32_to_cpu(data[11]);
+		/* The hvtimer is not in the DT, assume KVM default. */
+		hvtimer->irq = 28;
+		/*
+		 * With VHE, accesses to the vtimer are redirected to the
+		 * hvtimer. They should have the same interrupt properties.
+		 */
+		hvtimer->irq_flags = vtimer->irq_flags;
+	}
+
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
 	ptimer->read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
@@ -433,12 +550,22 @@ static void print_timer_info(void)
 	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer->read_counter());
 	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer->read_ctl());
 	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer->read_cval());
+
+	if (current_el == CurrentEL_EL2) {
+		printf("CNTHP_CTL_EL0 : 0x%016lx\n", hptimer->read_ctl());
+		printf("CNTHP_CVAL_EL0: 0x%016lx\n", hptimer->read_cval());
+
+		printf("CNTHV_CTL_EL0 : 0x%016lx\n", hvtimer->read_ctl());
+		printf("CNTHV_CVAL_EL0: 0x%016lx\n", hvtimer->read_cval());
+	}
 }
 
 int main(int argc, char **argv)
 {
 	int i;
 
+	current_el = current_level();
+
 	test_init();
 
 	print_timer_info();
@@ -446,13 +573,28 @@ int main(int argc, char **argv)
 	if (argc == 1) {
 		test_vtimer();
 		test_ptimer();
+		if (current_el == CurrentEL_EL2) {
+			test_hvtimer();
+			test_hptimer();
+		}
 	}
 
 	for (i = 1; i < argc; ++i) {
-		if (strcmp(argv[i], "vtimer") == 0)
+		if (strcmp(argv[i], "vtimer") == 0) {
 			test_vtimer();
-		if (strcmp(argv[i], "ptimer") == 0)
+		} if (strcmp(argv[i], "ptimer") == 0) {
 			test_ptimer();
+		} if (strcmp(argv[i], "hvtimer") == 0) {
+			if (current_el == CurrentEL_EL1)
+				report_info("Skipping hvtimer tests. Boot at EL2 to enable.");
+			else
+				test_hvtimer();
+		} if (strcmp(argv[i], "hptimer") == 0) {
+			if (current_el == CurrentEL_EL1)
+				report_info("Skipping hptimer tests. Boot at EL2 to enable.");
+			else
+				test_hptimer();
+		}
 	}
 
 	return report_summary();
-- 
2.20.1

