Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D202D7D185E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbjJTVlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345380AbjJTVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB20F10DB
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7ba10cb90so18136197b3.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838068; x=1698442868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yld4xw6ygDTLiQeJhDYRyipnE2241mvDIU0DEAajDU0=;
        b=0Fzc8To2TO/9oIHrdq1tjNgmOsF7xrfle/uMUxVu2vLmQdy+2WlA2nMljbCZRVA49o
         F9MwxK6CrncyB5bIROUOvMlXxH8PEA3s6NoysW3ICSH4NiF/bmUpAkvV6VGQvI0co4YX
         XPCQutrFXJzxuhGMH+wpfs3QL61xwCqqdizxmC1cTD/PlGmvqgrb2QgPMsngXK03eNrJ
         RmYil82ZbsbYV4XRdvb5UKBLVyFWWtFQP8gwJIReIeKf+MPv6d+lpJLNo79edFg7hDqm
         A7v9Srqn5B8CZEKcqEJqr6MwSDqVuf2MzxpuTsTMxYfUxtvIT3AIudmZoIFKUuwE3U+y
         cMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838068; x=1698442868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yld4xw6ygDTLiQeJhDYRyipnE2241mvDIU0DEAajDU0=;
        b=T2iawBbjRkUmZ/GIxeBKQFdZvQEbGKFHdTiGm5dXolP/T0FAMfSgKCG/L+AOFS4G6J
         aWjE+FuSmtSTMYpEHdmRlmQNjjbo4RIQKkEKej3mf/cqTpjW/Zu1/jFPmdIpFOtXt8hL
         U3fyyOM5Vr4EV63/bch4oEmvtvei8vHo8d0trAqMvQgJyivWPb2/v1++/2C+3PHofTzo
         KyQh2YJFe8CjQ+v51AS0i9vpn84M/85GhynRIELlQBoshmkAfrtrmdAiY1vmQBTxtu/B
         0SKtbw6O+MjqiuKXmb7i7ifj8r1YJVG61TI//c0oyKI9LtsNf9QnUDvX+GRFa/L75IiP
         hJ/g==
X-Gm-Message-State: AOJu0YwOX+2dcXEXamd3Y8mSk4euGJlYMVU9+uducjFFU+XyIn/yv/aU
        eT1P3MkjdzkrjTusdHj0vxXkg5bGaFiZ
X-Google-Smtp-Source: AGHT+IG3elVDzJ0rCvoizFz2sbhK4alUsCTZL8FHrBvHJvUWN+umMa75p2/jkYwKJPEELVGrOk8Dxz3MWvss
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a0d:d685:0:b0:5a1:d0cf:b65d with SMTP id
 y127-20020a0dd685000000b005a1d0cfb65dmr90598ywd.5.1697838067968; Fri, 20 Oct
 2023 14:41:07 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:51 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-12-rananta@google.com>
Subject: [PATCH v8 11/13] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

Add a new test case to the vpmu_counter_access test to check
if PMU registers or their bits for unimplemented counters are not
accessible or are RAZ, as expected.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 93 +++++++++++++++++--
 .../selftests/kvm/include/aarch64/processor.h |  1 +
 2 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index a579286b6f116..d5143925690db 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,8 +5,9 @@
  * Copyright (c) 2023 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
- * those counters.
+ * counters (PMCR_EL0.N) that userspace sets, if the guest can access
+ * those counters, and if the guest is prevented from accessing any
+ * other counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -287,25 +288,85 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
 }
 
+#define INVALID_EC	(-1ul)
+uint64_t expected_ec = INVALID_EC;
+uint64_t op_end_addr;
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
 
 	esr = read_sysreg(esr_el1);
 	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
-	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
+
+	__GUEST_ASSERT(op_end_addr && (expected_ec == ec),
+			"PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx; EC expected: 0x%lx",
+			regs->pc, esr, ec, expected_ec);
+
+	/* Will go back to op_end_addr after the handler exits */
+	regs->pc = op_end_addr;
+
+	/*
+	 * Clear op_end_addr, and set expected_ec to INVALID_EC
+	 * as a sign that an exception has occurred.
+	 */
+	op_end_addr = 0;
+	expected_ec = INVALID_EC;
+}
+
+/*
+ * Run the given operation that should trigger an exception with the
+ * given exception class. The exception handler (guest_sync_handler)
+ * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
+ * will come back to the instruction at the @done_label.
+ * The @done_label must be a unique label in this test program.
+ */
+#define TEST_EXCEPTION(ec, ops, done_label)		\
+{							\
+	extern int done_label;				\
+							\
+	WRITE_ONCE(op_end_addr, (uint64_t)&done_label);	\
+	GUEST_ASSERT(ec != INVALID_EC);			\
+	WRITE_ONCE(expected_ec, ec);			\
+	dsb(ish);					\
+	ops;						\
+	asm volatile(#done_label":");			\
+	GUEST_ASSERT(!op_end_addr);			\
+	GUEST_ASSERT(expected_ec == INVALID_EC);	\
+}
+
+/*
+ * Tests for reading/writing registers for the unimplemented event counter
+ * specified by @pmc_idx (>= PMCR_EL0.N).
+ */
+static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
+{
+	/*
+	 * Reading/writing the event count/type registers should cause
+	 * an UNDEFINED exception.
+	 */
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
+	/*
+	 * The bit corresponding to the (unimplemented) counter in
+	 * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers should be RAZ.
+	 */
+	test_bitmap_pmu_regs(pmc_idx, 1);
+	test_bitmap_pmu_regs(pmc_idx, 0);
 }
 
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
  * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
- * if reading/writing PMU registers for implemented counters works
- * as expected.
+ * if reading/writing PMU registers for implemented or unimplemented
+ * counters works as expected.
  */
 static void guest_code(uint64_t expected_pmcr_n)
 {
-	uint64_t pmcr, pmcr_n;
+	uint64_t pmcr, pmcr_n, unimp_mask;
 	int i, pmc;
 
 	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
@@ -320,15 +381,33 @@ static void guest_code(uint64_t expected_pmcr_n)
 			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
 			expected_pmcr_n, pmcr_n);
 
+	/*
+	 * Make sure that (RAZ) bits corresponding to unimplemented event
+	 * counters in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers are reset
+	 * to zero.
+	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
+	 */
+	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
+	check_bitmap_pmu_regs(unimp_mask, false);
+
 	/*
 	 * Tests for reading/writing PMU registers for implemented counters.
-	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
 	 */
 	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
 		for (pmc = 0; pmc < pmcr_n; pmc++)
 			test_access_pmc_regs(&pmc_accessors[i], pmc);
 	}
 
+	/*
+	 * Tests for reading/writing PMU registers for unimplemented counters.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
+			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
+	}
+
 	GUEST_DONE();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cb537253a6b9c..c42d683102c7a 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -104,6 +104,7 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_UNKNOWN		0x0
 #define ESR_EC_SVC64		0x15
 #define ESR_EC_IABT		0x21
 #define ESR_EC_DABT		0x25
-- 
2.42.0.655.g421f12c284-goog

