Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9729470687
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbhLJRBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 12:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhLJRBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 12:01:45 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F10C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:10 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m20-20020a17090aab1400b001ad6e2148ccso5223026pjq.1
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LZscy7U5ALfD1frMqggail4BJIPnE2PJTdnWpLXa2lE=;
        b=CNkTVZU3LmW/KWRri1WJ75uAagDZAHpc8l3vgZWAb/hV2Rq5RPv06ZFdGb62Arr1/n
         4NaEfwOq/zNDBOkqQEpXAg8rm7QMFLXsDJuHefdcWA59BRjJFR53btYm2FlsVXlIv6Qc
         Q/1vOy0IT9lke/lvbpyPq7Nu9sb+v/bXqlDT5K24PS/usYboNyr+urLM5OFCRZT8WgzW
         d5z2D3pCNVQ8IsRC9Hv0Bte0k1mokiHlLsJ+AJdHosbFdr06xQX4E6WaShlqWJjiab0p
         Z7ZssV5VHyY1boAT9f78kErgcqxs0bbpO6gAh+XucdBqVPP2fmi9CROmMkP2yQo5Nnnh
         x8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LZscy7U5ALfD1frMqggail4BJIPnE2PJTdnWpLXa2lE=;
        b=CBTkWc/b5Ae2tvX8DtkBA74BVX++Q2JBsUtVZUXrXFs9tPx98UZOnkpz9oeBU9xoO3
         zJYjyaKBBBUazyLMjv+SQZCscMLFfqyrq6/2FrhtILYuy1JMEELdsrP1+VZuF530JUAx
         +9Z525jV82j7gGe6AucaxUn8eowIlmkbexpoARvkZEHtwMXGeHzYsYzydNEhQBCB5faJ
         9P7i8WHqFmXHSkzuY902W6sBxRz9U2NSTrfPfVqGSM2RGi7NiHwo9XjZCqbp26oZtSAx
         MRi4Pf0WX8h9qXPrtjm9XEq77Ki3jtvjsXMK2EagSWdzOH3gFJ5nWipwn9hzPdLsZmX/
         ECgA==
X-Gm-Message-State: AOAM531NDG2QPgb2smDV+mP8qmHO14VPdL7HWJrwbcydWgaEgFz26SOc
        c1726i5m4GYahFe4Gt1VXla7DxQc5Am1qLmxqA5gbosvcY37pBVfEzivQGnnX1IwI+8hVFPpqss
        GcRG0l95uM0aRgsBx4S9ydLagaCmQ0gQi5NieJ2V3NNIBoWz+SU3rvy/e0N/Vjzc=
X-Google-Smtp-Source: ABdhPJzxiCvCCA3XBnLd+t5as/ENSdXbNnNht3YNFEzu+8LRgj11KF9OaX8kOm290lw6r7aP3p0aUZAQ+tEXpQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8f97:b0:143:88c2:e2d5 with SMTP
 id z23-20020a1709028f9700b0014388c2e2d5mr77191442plo.70.1639155489691; Fri,
 10 Dec 2021 08:58:09 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:58:02 -0800
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Message-Id: <20211210165804.1623253-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20211210165804.1623253-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 1/3] arm64: debug: add a migration test for
 breakpoint state
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the migration of breakpoint state. Program as many breakpoitns as
possible, migrate, and check that we get the corresponding exceptions.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/Makefile.arm64 |   1 +
 arm/debug.c        | 209 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  13 +++
 3 files changed, 223 insertions(+)
 create mode 100644 arm/debug.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index e8a38d7..6feac76 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -31,6 +31,7 @@ OBJDIRS += lib/arm64
 tests = $(TEST_DIR)/timer.flat
 tests += $(TEST_DIR)/micro-bench.flat
 tests += $(TEST_DIR)/cache.flat
+tests += $(TEST_DIR)/debug.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/debug.c b/arm/debug.c
new file mode 100644
index 0000000..fedf4ab
--- /dev/null
+++ b/arm/debug.c
@@ -0,0 +1,209 @@
+#include <libcflat.h>
+#include <errata.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/delay.h>
+#include <asm/smp.h>
+#include <asm/barrier.h>
+#include <asm/io.h>
+
+#define MDSCR_KDE		(1 << 13)
+#define MDSCR_MDE		(1 << 15)
+
+#define DBGBCR_LEN8		(0xff << 5)
+#define DBGBCR_EXEC		(0x0 << 3)
+#define DBGBCR_EL1		(0x1 << 1)
+#define DBGBCR_E		(0x1 << 0)
+
+#define SPSR_D			(1 << 9)
+
+#define ESR_EC_HW_BP_CURRENT    0x31
+
+#define ID_AA64DFR0_BRPS_SHIFT	12
+#define ID_AA64DFR0_BRPS_MASK	0xf
+
+static volatile uint64_t hw_bp_idx, hw_bp_addr[16];
+
+static void hw_bp_handler(struct pt_regs *regs, unsigned int esr)
+{
+	hw_bp_addr[hw_bp_idx++] = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static int get_num_hw_bp(void)
+{
+	uint64_t reg = read_sysreg(id_aa64dfr0_el1);
+	/* Number of breakpoints, minus 1 */
+	uint8_t brps = (reg >> ID_AA64DFR0_BRPS_SHIFT) & ID_AA64DFR0_BRPS_MASK;
+
+	return brps + 1;
+}
+
+static void write_dbgbcr(int n, uint32_t bcr)
+{
+	switch (n) {
+	case 0:
+		write_sysreg(bcr, dbgbcr0_el1); break;
+	case 1:
+		write_sysreg(bcr, dbgbcr1_el1); break;
+	case 2:
+		write_sysreg(bcr, dbgbcr2_el1); break;
+	case 3:
+		write_sysreg(bcr, dbgbcr3_el1); break;
+	case 4:
+		write_sysreg(bcr, dbgbcr4_el1); break;
+	case 5:
+		write_sysreg(bcr, dbgbcr5_el1); break;
+	case 6:
+		write_sysreg(bcr, dbgbcr6_el1); break;
+	case 7:
+		write_sysreg(bcr, dbgbcr7_el1); break;
+	case 8:
+		write_sysreg(bcr, dbgbcr8_el1); break;
+	case 9:
+		write_sysreg(bcr, dbgbcr9_el1); break;
+	case 10:
+		write_sysreg(bcr, dbgbcr10_el1); break;
+	case 11:
+		write_sysreg(bcr, dbgbcr11_el1); break;
+	case 12:
+		write_sysreg(bcr, dbgbcr12_el1); break;
+	case 13:
+		write_sysreg(bcr, dbgbcr13_el1); break;
+	case 14:
+		write_sysreg(bcr, dbgbcr14_el1); break;
+	case 15:
+		write_sysreg(bcr, dbgbcr15_el1); break;
+	default:
+		report_abort("Invalid bcr");
+	}
+}
+
+static void write_dbgbvr(int n, uint64_t bvr)
+{
+	switch (n) {
+	case 0:
+		write_sysreg(bvr, dbgbvr0_el1); break;
+	case 1:
+		write_sysreg(bvr, dbgbvr1_el1); break;
+	case 2:
+		write_sysreg(bvr, dbgbvr2_el1); break;
+	case 3:
+		write_sysreg(bvr, dbgbvr3_el1); break;
+	case 4:
+		write_sysreg(bvr, dbgbvr4_el1); break;
+	case 5:
+		write_sysreg(bvr, dbgbvr5_el1); break;
+	case 6:
+		write_sysreg(bvr, dbgbvr6_el1); break;
+	case 7:
+		write_sysreg(bvr, dbgbvr7_el1); break;
+	case 8:
+		write_sysreg(bvr, dbgbvr8_el1); break;
+	case 9:
+		write_sysreg(bvr, dbgbvr9_el1); break;
+	case 10:
+		write_sysreg(bvr, dbgbvr10_el1); break;
+	case 11:
+		write_sysreg(bvr, dbgbvr11_el1); break;
+	case 12:
+		write_sysreg(bvr, dbgbvr12_el1); break;
+	case 13:
+		write_sysreg(bvr, dbgbvr13_el1); break;
+	case 14:
+		write_sysreg(bvr, dbgbvr14_el1); break;
+	case 15:
+		write_sysreg(bvr, dbgbvr15_el1); break;
+	default:
+		report_abort("invalid bvr");
+	}
+}
+
+static void reset_debug_state(void)
+{
+	int i, num_bp = get_num_hw_bp();
+
+	asm volatile("msr daifset, #8");
+
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
+	isb();
+
+	write_sysreg(0, mdscr_el1);
+	for (i = 0; i < num_bp; i++) {
+		write_dbgbvr(i, 0);
+		write_dbgbcr(i, 0);
+	}
+	isb();
+}
+
+static void do_migrate(void)
+{
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+}
+
+static void test_hw_bp(bool migrate)
+{
+	extern unsigned char hw_bp0;
+	uint32_t bcr;
+	uint32_t mdscr;
+	uint64_t addr;
+	int num_bp = get_num_hw_bp();
+	int i;
+
+	install_exception_handler(EL1H_SYNC, ESR_EC_HW_BP_CURRENT, hw_bp_handler);
+
+	reset_debug_state();
+
+	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
+	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4) {
+		write_dbgbcr(i, bcr);
+		write_dbgbvr(i, addr);
+	}
+	isb();
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr, mdscr_el1);
+	isb();
+
+	if (migrate) {
+		do_migrate();
+		report(num_bp == get_num_hw_bp(), "brps match after migrate");
+	}
+
+	hw_bp_idx = 0;
+
+	/* Trap on up to 16 debug exception unmask instructions. */
+	asm volatile("hw_bp0:\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n");
+
+	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4)
+		report(hw_bp_addr[i] == addr, "hw breakpoint: %d", i);
+}
+
+int main(int argc, char **argv)
+{
+	if (argc < 2)
+		report_abort("no test specified");
+
+	if (strcmp(argv[1], "bp") == 0) {
+		report_prefix_push(argv[1]);
+		test_hw_bp(false);
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "bp-migration") == 0) {
+		report_prefix_push(argv[1]);
+		test_hw_bp(true);
+		report_prefix_pop();
+	} else {
+		report_abort("Unknown subtest '%s'", argv[1]);
+	}
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 945c2d0..896ff87 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -241,3 +241,16 @@ arch = arm64
 file = cache.flat
 arch = arm64
 groups = cache
+
+# Debug tests
+[debug-bp]
+file = debug.flat
+arch = arm64
+extra_params = -append 'bp'
+groups = debug
+
+[debug-bp-migration]
+file = debug.flat
+arch = arm64
+extra_params = -append 'bp-migration'
+groups = debug migration
-- 
2.34.1.173.g76aa8bc2d0-goog

