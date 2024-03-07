Return-Path: <kvm+bounces-11323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D048875637
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 766AE280F4D
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ECCD13664B;
	Thu,  7 Mar 2024 18:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hgZWHcto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C30135A50
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836802; cv=none; b=KedmMg8OiePlqpUVPQKeAMXD8eousQW+w+n/2JM7D5LgqXk6IYecgscP0XZEOUrG51rTy/RZrlXJqwOEkrJSaIetDIET2hl/e/bqmqw6Wnc346uBEUXLBRAdjJoxS04HDe3JvATcJrr2dnyql4j/dc6jjsDnfEVghSY2tORLgdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836802; c=relaxed/simple;
	bh=aUUn4nt1HDmM5NVSCujtBuBrcT6AKQUJlsy9s0OAxcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BqOaX5tkVYSl4E/FxNkjhW3K7p4H9YGJTuSRptT9szbDcIjuPh4W1KTSyGMBGes89OkrwNTSjx8HrhsrBbGUHujY41FNIN9UAgUthW79eeDi9VMm3ENvsoqzKoLJwtTrsrpwHC6pJ8IA8ULwsnRjxfDk9F6cNJsEpEBY6OvV8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hgZWHcto; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-609f2920b53so15191427b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 10:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836797; x=1710441597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PVoMURIjZ2BBDW3wWtRbCVJ1uQ9BkVAKjTfM+l9QFOk=;
        b=hgZWHctoUrW0Ievb2HG6vOanAHsCLisXnh/hTRzSSB19dReduqr0X/44RQMjpNXJvM
         ySF9mFMl+Jagi2xpSMpj97cLiZFow1Sh44YIGHUaQt+plfDZ9WFcnV9v7eS2HYeQ6GOa
         HA2XfzX0hnVC3q/u65/CUgrZs6s3ec/fACERwV1/5nOrv/nwNJdKCkY92548uUX1TE6X
         +vUtNwwDbku3C15s5C6ysQZClYwCax+Xuza6okSiR1KLV7a+VJGexYHmCUNiBuy8Ng7c
         j1RipQnV2T420c8l5HB9GWiH7KfLt2XwKavZ+5oE2E8lwA1apDIJJVMNfxzkk/7+Ipub
         OWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836797; x=1710441597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVoMURIjZ2BBDW3wWtRbCVJ1uQ9BkVAKjTfM+l9QFOk=;
        b=wKxAOZffnbOcE4EZQjzu5LmUKDDR++Q/6riQKUAO3q0QvcagxLi004wssMM24xy7+D
         mwYcmz1P13/SFIjGCyPI0KV22JZ2VX2fNadiyA1ZCJoeW3qTEeCCzhCmNivMifCKCUCm
         Lq0SJV9T9OpXIh82TrQk2OnqyoqPeYmdzoRObuuSENKBUa9Xi3HFGT7L82wiuR/q+5hR
         SxLazCWKxsiiuS9yBUjcDga/jJD/BJo/3S7V6kKxvrYRK5D3Owf4u6Ls8JveWvXWuBtE
         aAmdFFoLrMy/z9MBjvVlKebdry5D31gmOCNCPl2JJHWmkAcKwpkPK3z/qmHixG7h0gA2
         z3og==
X-Gm-Message-State: AOJu0YzGBK2UDgZRcCtqekS0Tmy+JbuFCjPF3RqfqlZluKXeFVUPwy9W
	W22UYbPDdi1wa6eJ+piBmSNRQgpw20ZjmhDvEvnrMF8oBJnK5m7L1abYB83nYikiiKjx6K+Zj8g
	6nFm0S/XrijrW9P2fTUBbukghwslRH6KQVBFbvn+Q177w5hcCjoZagGg05Zwlx8QH4WPwaYe1mx
	QantdeJvXewMM7/UhQZLtoh4k6hh4CJiV71iszJfLbFo2HNu2XueBMm7M=
X-Google-Smtp-Source: AGHT+IEFH9bVVOtAe6MI1MxDU8SYvK+PdeOEIMrpDmONI3R1So6xUnW/Qhm4IrEoEWWcEUlB00jN+ZGSiDD7oGqSxw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1249:b0:dbe:d0a9:2be8 with
 SMTP id t9-20020a056902124900b00dbed0a92be8mr784834ybu.0.1709836797401; Thu,
 07 Mar 2024 10:39:57 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:07 +0000
In-Reply-To: <20240307183907.1184775-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307183907.1184775-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-4-coltonlewis@google.com>
Subject: [PATCH v4 3/3] KVM: arm64: selftests: Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new arch_timer_edge_cases selftests that validates:

- timers above the max TVAL value
- timers in the past
- moving counters ahead and behind pending timers
- reprograming timers
- timers fired multiple times
- masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

Co-developed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1102 +++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 3 files changed, 1120 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 492e937fab00..fd9468d19ba4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/aarch32_id_regs
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
+TEST_GEN_PROGS_aarch64 += aarch64/arch_timer_edge_cases
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
new file mode 100644
index 000000000000..befe379e3354
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c
@@ -0,0 +1,1102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * arch_timer_edge_cases.c - Tests the aarch64 timer IRQ functionality.
+ *
+ * The test validates some edge cases related to the arch-timer:
+ * - timers above the max TVAL value.
+ * - timers in the past
+ * - moving counters ahead and behind pending timers.
+ * - reprograming timers.
+ * - timers fired multiple times.
+ * - masking/unmasking using the timer control mask.
+ *
+ * Copyright (c) 2021, Google LLC.
+ */
+
+#define _GNU_SOURCE
+
+#include <stdlib.h>
+#include <pthread.h>
+#include <linux/kvm.h>
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/sizes.h>
+#include <sched.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "delay.h"
+#include "arch_timer.h"
+#include "gic.h"
+#include "vgic.h"
+
+#define ASSERT_IRQS_HANDLED(_nr, _args...) do {				\
+		int _h = atomic_read(&shared_data.handled);		\
+		__GUEST_ASSERT(_h == (_nr), "Handled %d IRQS but expected %d", _h, _nr, ##_args); \
+	} while (0)
+
+const uint64_t CVAL_MAX = ~0ULL;
+/* tval is a signed 32-bit int. */
+const int32_t TVAL_MAX = INT_MAX;
+const int32_t TVAL_MIN = INT_MIN;
+
+/* After how much time we say there is no IRQ. */
+const uint32_t TIMEOUT_NO_IRQ_US = 50000;
+
+/* A nice counter value to use as the starting one for most tests. */
+const uint64_t DEF_CNT = (CVAL_MAX / 2);
+
+/* Number of runs. */
+const uint32_t NR_TEST_ITERS_DEF = 5;
+
+/* Default wait test time in ms. */
+const uint32_t WAIT_TEST_MS = 10;
+
+/* Default "long" wait test time in ms. */
+const uint32_t LONG_WAIT_TEST_MS = 100;
+
+/* Shared with IRQ handler. */
+struct test_vcpu_shared_data {
+	atomic_t handled;
+	atomic_t spurious;
+} shared_data;
+
+struct test_args {
+	/* Virtual or physical timer and counter tests. */
+	enum arch_timer timer;
+	/* Delay used for most timer tests. */
+	uint64_t wait_ms;
+	/* Delay used in the test_long_timer_delays test. */
+	uint64_t long_wait_ms;
+	/* Number of iterations. */
+	int iterations;
+	/* Whether to test the physical timer. */
+	bool test_physical;
+	/* Whether to test the virtual timer. */
+	bool test_virtual;
+};
+
+struct test_args test_args = {
+	.wait_ms = WAIT_TEST_MS,
+	.long_wait_ms = LONG_WAIT_TEST_MS,
+	.iterations = NR_TEST_ITERS_DEF,
+	.test_physical = true,
+	.test_virtual = true,
+};
+
+static int vtimer_irq, ptimer_irq;
+
+enum sync_cmd {
+	SET_COUNTER_VALUE = 100001,
+	USERSPACE_USLEEP,
+	USERSPACE_SCHED_YIELD,
+	USERSPACE_MIGRATE_SELF,
+	NO_USERSPACE_CMD,
+};
+
+typedef void (*sleep_method_t)(enum arch_timer timer, uint64_t usec);
+
+static void sleep_poll(enum arch_timer timer, uint64_t usec);
+static void sleep_sched_poll(enum arch_timer timer, uint64_t usec);
+static void sleep_in_userspace(enum arch_timer timer, uint64_t usec);
+static void sleep_migrate(enum arch_timer timer, uint64_t usec);
+
+sleep_method_t sleep_method[] = {
+	sleep_poll,
+	sleep_sched_poll,
+	sleep_migrate,
+	sleep_in_userspace,
+};
+
+typedef void (*irq_wait_method_t)(void);
+
+static void wait_for_non_spurious_irq(void);
+static void wait_poll_for_irq(void);
+static void wait_sched_poll_for_irq(void);
+static void wait_migrate_poll_for_irq(void);
+
+irq_wait_method_t irq_wait_method[] = {
+	wait_for_non_spurious_irq,
+	wait_poll_for_irq,
+	wait_sched_poll_for_irq,
+	wait_migrate_poll_for_irq,
+};
+
+enum timer_view {
+	TIMER_CVAL,
+	TIMER_TVAL,
+};
+
+static int64_t msecs_to_usecs(int64_t msecs)
+{
+	return msecs * 1000LL;
+}
+
+static void userspace_cmd(uint64_t cmd)
+{
+	GUEST_SYNC_ARGS(cmd, 0, 0, 0, 0);
+}
+
+static void userspace_migrate_vcpu(void)
+{
+	userspace_cmd(USERSPACE_MIGRATE_SELF);
+}
+
+static void userspace_sleep(uint64_t usecs)
+{
+	GUEST_SYNC_ARGS(USERSPACE_USLEEP, usecs, 0, 0, 0);
+}
+
+static void set_counter(enum arch_timer timer, uint64_t counter)
+{
+	GUEST_SYNC_ARGS(SET_COUNTER_VALUE, counter, timer, 0, 0);
+}
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	unsigned int intid = gic_get_and_ack_irq();
+	enum arch_timer timer;
+	uint64_t cnt, cval;
+	uint32_t ctl;
+	bool timer_condition, istatus;
+
+	if (intid == IAR_SPURIOUS) {
+		atomic_inc(&shared_data.spurious);
+		goto out;
+	}
+
+	if (intid == ptimer_irq)
+		timer = PHYSICAL;
+	else if (intid == vtimer_irq)
+		timer = VIRTUAL;
+	else
+		goto out;
+
+	ctl = timer_get_ctl(timer);
+	cval = timer_get_cval(timer);
+	cnt = timer_get_cntct(timer);
+	timer_condition = cnt >= cval;
+	istatus = (ctl & CTL_ISTATUS) && (ctl & CTL_ENABLE);
+	GUEST_ASSERT_EQ(timer_condition, istatus);
+
+	/* Disable and mask the timer. */
+	timer_set_ctl(timer, CTL_IMASK);
+
+	atomic_inc(&shared_data.handled);
+
+out:
+	gic_set_eoi(intid);
+}
+
+static void set_cval_irq(enum arch_timer timer, uint64_t cval_cycles,
+			 uint32_t ctl)
+{
+	atomic_set(&shared_data.handled, 0);
+	atomic_set(&shared_data.spurious, 0);
+	timer_set_cval(timer, cval_cycles);
+	timer_set_ctl(timer, ctl);
+}
+
+static void set_tval_irq(enum arch_timer timer, uint64_t tval_cycles,
+			 uint32_t ctl)
+{
+	atomic_set(&shared_data.handled, 0);
+	atomic_set(&shared_data.spurious, 0);
+	timer_set_tval(timer, tval_cycles);
+	timer_set_ctl(timer, ctl);
+}
+
+static void set_xval_irq(enum arch_timer timer, uint64_t xval, uint32_t ctl,
+			 enum timer_view tv)
+{
+	switch (tv) {
+	case TIMER_CVAL:
+		set_cval_irq(timer, xval, ctl);
+		break;
+	case TIMER_TVAL:
+		set_tval_irq(timer, xval, ctl);
+		break;
+	default:
+		GUEST_FAIL("Could not get timer %d", timer);
+	}
+}
+
+/*
+ * Should be called with IRQs masked.
+ *
+ * Note that this can theoretically hang forever, so we rely on having
+ * a timeout mechanism in the "runner", like:
+ * tools/testing/selftests/kselftest/runner.sh.
+ */
+static void wait_for_non_spurious_irq(void)
+{
+	int h;
+
+	for (h = atomic_read(&shared_data.handled); h == atomic_read(&shared_data.handled);) {
+		gic_wfi();
+		local_irq_enable();
+		isb(); /* handle IRQ */
+		local_irq_disable();
+	}
+}
+
+/*
+ * Wait for an non-spurious IRQ by polling in the guest or in
+ * userspace (e.g. userspace_cmd=USERSPACE_SCHED_YIELD).
+ *
+ * Should be called with IRQs masked. Not really needed like the wfi above, but
+ * it should match the others.
+ *
+ * Note that this can theoretically hang forever, so we rely on having
+ * a timeout mechanism in the "runner", like:
+ * tools/testing/selftests/kselftest/runner.sh.
+ */
+static void poll_for_non_spurious_irq(enum sync_cmd usp_cmd)
+{
+	int h;
+
+	h = atomic_read(&shared_data.handled);
+
+	local_irq_enable();
+	while (h == atomic_read(&shared_data.handled)) {
+		if (usp_cmd == NO_USERSPACE_CMD)
+			cpu_relax();
+		else
+			userspace_cmd(usp_cmd);
+	}
+	local_irq_disable();
+}
+
+static void wait_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(NO_USERSPACE_CMD);
+}
+
+static void wait_sched_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(USERSPACE_SCHED_YIELD);
+}
+
+static void wait_migrate_poll_for_irq(void)
+{
+	poll_for_non_spurious_irq(USERSPACE_MIGRATE_SELF);
+}
+
+/*
+ * Sleep for usec microseconds by polling in the guest or in
+ * userspace (e.g. userspace_cmd=USERSPACE_SCHEDULE).
+ */
+static void guest_poll(enum arch_timer test_timer, uint64_t usec,
+		       enum sync_cmd usp_cmd)
+{
+	uint64_t cycles = usec_to_cycles(usec);
+	/* Whichever timer we are testing with, sleep with the other. */
+	enum arch_timer sleep_timer = 1 - test_timer;
+	uint64_t start = timer_get_cntct(sleep_timer);
+
+	while ((timer_get_cntct(sleep_timer) - start) < cycles) {
+		if (usp_cmd == NO_USERSPACE_CMD)
+			cpu_relax();
+		else
+			userspace_cmd(usp_cmd);
+	}
+}
+
+static void sleep_poll(enum arch_timer timer, uint64_t usec)
+{
+	guest_poll(timer, usec, NO_USERSPACE_CMD);
+}
+
+static void sleep_sched_poll(enum arch_timer timer, uint64_t usec)
+{
+	guest_poll(timer, usec, USERSPACE_SCHED_YIELD);
+}
+
+static void sleep_migrate(enum arch_timer timer, uint64_t usec)
+{
+	guest_poll(timer, usec, USERSPACE_MIGRATE_SELF);
+}
+
+static void sleep_in_userspace(enum arch_timer timer, uint64_t usec)
+{
+	userspace_sleep(usec);
+}
+
+/*
+ * Reset the timer state to some nice values like the counter not being close
+ * to the edge, and the control register masked and disabled.
+ */
+static void reset_timer_state(enum arch_timer timer, uint64_t cnt)
+{
+	set_counter(timer, cnt);
+	timer_set_ctl(timer, CTL_IMASK);
+}
+
+static void test_timer_xval(enum arch_timer timer, uint64_t xval,
+			    enum timer_view tv, irq_wait_method_t wm, bool reset_state,
+			    uint64_t reset_cnt)
+{
+	local_irq_disable();
+
+	if (reset_state)
+		reset_timer_state(timer, reset_cnt);
+
+	set_xval_irq(timer, xval, CTL_ENABLE, tv);
+	wm();
+
+	ASSERT_IRQS_HANDLED(1, tv, wm);
+	local_irq_enable();
+}
+
+/*
+ * The test_timer_* functions will program the timer, wait for it, and assert
+ * the firing of the correct IRQ.
+ *
+ * These functions don't have a timeout and return as soon as they receive an
+ * IRQ. They can hang (forever), so we rely on having a timeout mechanism in
+ * the "runner", like: tools/testing/selftests/kselftest/runner.sh.
+ */
+
+static void test_timer_cval(enum arch_timer timer, uint64_t cval,
+			    irq_wait_method_t wm, bool reset_state,
+			    uint64_t reset_cnt)
+{
+	test_timer_xval(timer, cval, TIMER_CVAL, wm, reset_state, reset_cnt);
+}
+
+static void test_timer_tval(enum arch_timer timer, int32_t tval,
+			    irq_wait_method_t wm, bool reset_state,
+			    uint64_t reset_cnt)
+{
+	test_timer_xval(timer, (uint64_t) tval, TIMER_TVAL, wm, reset_state,
+			reset_cnt);
+}
+
+static void test_xval_check_no_irq(enum arch_timer timer, uint64_t xval,
+				   uint64_t usec, enum timer_view timer_view,
+				   sleep_method_t guest_sleep)
+{
+	local_irq_disable();
+
+	set_xval_irq(timer, xval, CTL_ENABLE | CTL_IMASK, timer_view);
+	guest_sleep(timer, usec);
+
+	local_irq_enable();
+	isb();
+
+	/* Assume success (no IRQ) after waiting usec microseconds */
+	ASSERT_IRQS_HANDLED(0);
+}
+
+static void test_cval_no_irq(enum arch_timer timer, uint64_t cval,
+			     uint64_t usec, sleep_method_t wm)
+{
+	test_xval_check_no_irq(timer, cval, usec, TIMER_CVAL, wm);
+}
+
+static void test_tval_no_irq(enum arch_timer timer, int32_t tval, uint64_t usec,
+			     sleep_method_t wm)
+{
+	/* tval will be cast to an int32_t in test_xval_check_no_irq */
+	test_xval_check_no_irq(timer, (uint64_t) tval, usec, TIMER_TVAL, wm);
+}
+
+/* Test masking/unmasking a timer using the timer mask (not the IRQ mask). */
+static void test_timer_control_mask_then_unmask(enum arch_timer timer)
+{
+	reset_timer_state(timer, DEF_CNT);
+	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
+
+	/* Unmask the timer, and then get an IRQ. */
+	local_irq_disable();
+	timer_set_ctl(timer, CTL_ENABLE);
+	wait_for_non_spurious_irq();
+
+	ASSERT_IRQS_HANDLED(1);
+	local_irq_enable();
+}
+
+/* Check that timer control masks actually mask a timer being fired. */
+static void test_timer_control_masks(enum arch_timer timer)
+{
+	reset_timer_state(timer, DEF_CNT);
+
+	/* Local IRQs are not masked at this point. */
+
+	set_tval_irq(timer, -1, CTL_ENABLE | CTL_IMASK);
+
+	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
+	sleep_poll(timer, TIMEOUT_NO_IRQ_US);
+
+	ASSERT_IRQS_HANDLED(0);
+	timer_set_ctl(timer, CTL_IMASK);
+}
+
+static void test_fire_a_timer_multiple_times(enum arch_timer timer,
+					     irq_wait_method_t wm, int num)
+{
+	int i;
+
+	local_irq_disable();
+	reset_timer_state(timer, DEF_CNT);
+
+	set_tval_irq(timer, 0, CTL_ENABLE);
+
+	for (i = 1; i <= num; i++) {
+		wm();
+
+		/* The IRQ handler masked and disabled the timer.
+		 * Enable and unmmask it again.
+		 */
+		timer_set_ctl(timer, CTL_ENABLE);
+
+		ASSERT_IRQS_HANDLED(i);
+	}
+
+	local_irq_enable();
+}
+
+static void test_timers_fired_multiple_times(enum arch_timer timer)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++)
+		test_fire_a_timer_multiple_times(timer, irq_wait_method[i], 10);
+}
+
+/*
+ * Set a timer for tval=delta_1_ms then reprogram it to
+ * tval=delta_2_ms. Check that we get the timer fired. There is no
+ * timeout for the wait: we use the wfi instruction.
+ */
+static void test_reprogramming_timer(enum arch_timer timer, irq_wait_method_t wm,
+				     int32_t delta_1_ms, int32_t delta_2_ms)
+{
+	local_irq_disable();
+	reset_timer_state(timer, DEF_CNT);
+
+	/* Program the timer to DEF_CNT + delta_1_ms. */
+	set_tval_irq(timer, msec_to_cycles(delta_1_ms), CTL_ENABLE);
+
+	/* Reprogram the timer to DEF_CNT + delta_2_ms. */
+	timer_set_tval(timer, msec_to_cycles(delta_2_ms));
+
+	wm();
+
+	/* The IRQ should arrive at DEF_CNT + delta_2_ms (or after). */
+	GUEST_ASSERT(timer_get_cntct(timer) >=
+		     DEF_CNT + msec_to_cycles(delta_2_ms));
+
+	local_irq_enable();
+	ASSERT_IRQS_HANDLED(1, wm);
+};
+
+/*
+ * Set a timer for tval=delta_1_ms then reprogram it to
+ * tval=delta_2_ms. Check that we get the timer fired in delta_2_ms.
+ */
+static void test_reprogramming_timer_with_timeout(enum arch_timer timer,
+						  sleep_method_t guest_sleep,
+						  int32_t delta_1_ms,
+						  int32_t delta_2_ms)
+{
+	local_irq_disable();
+	reset_timer_state(timer, DEF_CNT);
+
+	set_tval_irq(timer, msec_to_cycles(delta_1_ms), CTL_ENABLE);
+
+	/* Reprogram the timer. */
+	timer_set_tval(timer, msec_to_cycles(delta_2_ms));
+
+	guest_sleep(timer, msecs_to_usecs(delta_2_ms) + TIMEOUT_NO_IRQ_US);
+
+	local_irq_enable();
+	isb();
+	ASSERT_IRQS_HANDLED(1);
+};
+
+static void test_reprogram_timers(enum arch_timer timer)
+{
+	int i;
+	uint64_t base_wait = test_args.wait_ms;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		/*
+		 * Ensure reprogramming works whether going from a
+		 * longer time to a shorter or vice versa.
+		 */
+		test_reprogramming_timer(timer, irq_wait_method[i], 2 * base_wait,
+					 base_wait);
+		test_reprogramming_timer(timer, irq_wait_method[i], base_wait,
+					 2 * base_wait);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		test_reprogramming_timer_with_timeout(timer, sleep_method[i],
+						      2 * base_wait, base_wait);
+		test_reprogramming_timer_with_timeout(timer, sleep_method[i],
+						      base_wait, 2 * base_wait);
+	}
+}
+
+static void test_basic_functionality(enum arch_timer timer)
+{
+	int32_t tval = (int32_t) msec_to_cycles(test_args.wait_ms);
+	uint64_t cval;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		irq_wait_method_t wm = irq_wait_method[i];
+
+		cval = DEF_CNT + msec_to_cycles(test_args.wait_ms);
+
+		test_timer_cval(timer, cval, wm, true, DEF_CNT);
+		test_timer_tval(timer, tval, wm, true, DEF_CNT);
+	}
+}
+
+/*
+ * This test checks basic timer behavior without actually firing timers, things
+ * like: the relationship between cval and tval, tval down-counting.
+ */
+static void timers_sanity_checks(enum arch_timer timer, bool use_sched)
+{
+	reset_timer_state(timer, DEF_CNT);
+
+	local_irq_disable();
+
+	/* cval in the past */
+	timer_set_cval(timer,
+		       timer_get_cntct(timer) -
+		       msec_to_cycles(test_args.wait_ms));
+	if (use_sched)
+		userspace_migrate_vcpu();
+	GUEST_ASSERT(timer_get_tval(timer) < 0);
+
+	/* tval in the past */
+	timer_set_tval(timer, -1);
+	if (use_sched)
+		userspace_migrate_vcpu();
+	GUEST_ASSERT(timer_get_cval(timer) < timer_get_cntct(timer));
+
+	/* tval larger than TVAL_MAX. This requires programming with
+	 * timer_set_cval instead so the value is expressible
+	 */
+	timer_set_cval(timer,
+		       timer_get_cntct(timer) + TVAL_MAX +
+		       msec_to_cycles(test_args.wait_ms));
+	if (use_sched)
+		userspace_migrate_vcpu();
+	GUEST_ASSERT(timer_get_tval(timer) <= 0);
+
+	/*
+	 * tval larger than 2 * TVAL_MAX.
+	 * Twice the TVAL_MAX completely loops around the TVAL.
+	 */
+	timer_set_cval(timer,
+		       timer_get_cntct(timer) + 2ULL * TVAL_MAX +
+		       msec_to_cycles(test_args.wait_ms));
+	if (use_sched)
+		userspace_migrate_vcpu();
+	GUEST_ASSERT(timer_get_tval(timer) <=
+		       msec_to_cycles(test_args.wait_ms));
+
+	/* negative tval that rollovers from 0. */
+	set_counter(timer, msec_to_cycles(1));
+	timer_set_tval(timer, -1 * msec_to_cycles(test_args.wait_ms));
+	if (use_sched)
+		userspace_migrate_vcpu();
+	GUEST_ASSERT(timer_get_cval(timer) >= (CVAL_MAX - msec_to_cycles(test_args.wait_ms)));
+
+	/* tval should keep down-counting from 0 to -1. */
+	timer_set_tval(timer, 0);
+	sleep_poll(timer, 1);
+	GUEST_ASSERT(timer_get_tval(timer) < 0);
+
+	local_irq_enable();
+
+	/* Mask and disable any pending timer. */
+	timer_set_ctl(timer, CTL_IMASK);
+}
+
+static void test_timers_sanity_checks(enum arch_timer timer)
+{
+	timers_sanity_checks(timer, false);
+	/* Check how KVM saves/restores these edge-case values. */
+	timers_sanity_checks(timer, true);
+}
+
+static void test_set_cnt_after_tval_max(enum arch_timer timer, irq_wait_method_t wm)
+{
+	local_irq_disable();
+	reset_timer_state(timer, DEF_CNT);
+
+	set_cval_irq(timer,
+		     (uint64_t) TVAL_MAX +
+		     msec_to_cycles(test_args.wait_ms) / 2, CTL_ENABLE);
+
+	set_counter(timer, TVAL_MAX);
+	wm();
+
+	ASSERT_IRQS_HANDLED(1, wm);
+	local_irq_enable();
+}
+
+/* Test timers set for: cval = now + TVAL_MAX + wait_ms / 2 */
+static void test_timers_above_tval_max(enum arch_timer timer)
+{
+	uint64_t cval;
+	int i;
+
+	/*
+	 * Test that the system is not implementing cval in terms of
+	 * tval.  If that was the case, setting a cval to "cval = now
+	 * + TVAL_MAX + wait_ms" would wrap to "cval = now +
+	 * wait_ms / 2", and the timer would fire immediately. Test that it
+	 * doesn't.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		reset_timer_state(timer, DEF_CNT);
+		cval =
+		    timer_get_cntct(timer) + TVAL_MAX +
+		    msec_to_cycles(test_args.wait_ms) / 2;
+		test_cval_no_irq(timer, cval,
+				 msecs_to_usecs(test_args.wait_ms) / 2 +
+				 TIMEOUT_NO_IRQ_US, sleep_method[i]);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		/* Get the IRQ by moving the counter forward. */
+		test_set_cnt_after_tval_max(timer, irq_wait_method[i]);
+	}
+}
+
+/*
+ * Template function to be used by the test_move_counter_ahead_* tests.  It
+ * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
+ * then waits for an IRQ.
+ */
+static void test_set_cnt_after_xval(enum arch_timer timer, uint64_t cnt_1,
+				    uint64_t xval, uint64_t cnt_2,
+				    irq_wait_method_t wm, enum timer_view tv)
+{
+	local_irq_disable();
+
+	set_counter(timer, cnt_1);
+	timer_set_ctl(timer, CTL_IMASK);
+
+	set_xval_irq(timer, xval, CTL_ENABLE, tv);
+	set_counter(timer, cnt_2);
+	wm();
+
+	ASSERT_IRQS_HANDLED(1);
+	local_irq_enable();
+}
+
+/*
+ * Template function to be used by the test_move_counter_ahead_* tests.  It
+ * sets the counter to cnt_1, the [c|t]val, the counter to cnt_2, and
+ * then waits for an IRQ.
+ */
+static void test_set_cnt_after_xval_no_irq(enum arch_timer timer,
+					   uint64_t cnt_1, uint64_t xval,
+					   uint64_t cnt_2,
+					   sleep_method_t guest_sleep,
+					   enum timer_view tv)
+{
+	local_irq_disable();
+
+	set_counter(timer, cnt_1);
+	timer_set_ctl(timer, CTL_IMASK);
+
+	set_xval_irq(timer, xval, CTL_ENABLE, tv);
+	set_counter(timer, cnt_2);
+	guest_sleep(timer, TIMEOUT_NO_IRQ_US);
+
+	local_irq_enable();
+	isb();
+
+	/* Assume no IRQ after waiting TIMEOUT_NO_IRQ_US microseconds */
+	ASSERT_IRQS_HANDLED(0);
+	timer_set_ctl(timer, CTL_IMASK);
+}
+
+static void test_set_cnt_after_tval(enum arch_timer timer, uint64_t cnt_1,
+				    int32_t tval, uint64_t cnt_2,
+				    irq_wait_method_t wm)
+{
+	test_set_cnt_after_xval(timer, cnt_1, tval, cnt_2, wm, TIMER_TVAL);
+}
+
+static void test_set_cnt_after_cval(enum arch_timer timer, uint64_t cnt_1,
+				    uint64_t cval, uint64_t cnt_2,
+				    irq_wait_method_t wm)
+{
+	test_set_cnt_after_xval(timer, cnt_1, cval, cnt_2, wm, TIMER_CVAL);
+}
+
+static void test_set_cnt_after_tval_no_irq(enum arch_timer timer,
+					   uint64_t cnt_1, int32_t tval,
+					   uint64_t cnt_2, sleep_method_t wm)
+{
+	test_set_cnt_after_xval_no_irq(timer, cnt_1, tval, cnt_2, wm,
+				       TIMER_TVAL);
+}
+
+static void test_set_cnt_after_cval_no_irq(enum arch_timer timer,
+					   uint64_t cnt_1, uint64_t cval,
+					   uint64_t cnt_2, sleep_method_t wm)
+{
+	test_set_cnt_after_xval_no_irq(timer, cnt_1, cval, cnt_2, wm,
+				       TIMER_CVAL);
+}
+
+/* Set a timer and then move the counter ahead of it. */
+static void test_move_counters_ahead_of_timers(enum arch_timer timer)
+{
+	int i;
+	int32_t tval;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		irq_wait_method_t wm = irq_wait_method[i];
+
+		test_set_cnt_after_cval(timer, 0, DEF_CNT, DEF_CNT + 1, wm);
+		test_set_cnt_after_cval(timer, CVAL_MAX, 1, 2, wm);
+
+		/* Move counter ahead of negative tval. */
+		test_set_cnt_after_tval(timer, 0, -1, DEF_CNT + 1, wm);
+		test_set_cnt_after_tval(timer, 0, -1, TVAL_MAX, wm);
+		tval = TVAL_MAX;
+		test_set_cnt_after_tval(timer, 0, tval, (uint64_t) tval + 1,
+					wm);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		sleep_method_t sm = sleep_method[i];
+
+		test_set_cnt_after_cval_no_irq(timer, 0, DEF_CNT, CVAL_MAX, sm);
+	}
+}
+
+/*
+ * Program a timer, mask it, and then change the tval or counter to cancel it.
+ * Unmask it and check that nothing fires.
+ */
+static void test_move_counters_behind_timers(enum arch_timer timer)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		sleep_method_t sm = sleep_method[i];
+
+		test_set_cnt_after_cval_no_irq(timer, DEF_CNT, DEF_CNT - 1, 0,
+					       sm);
+		test_set_cnt_after_tval_no_irq(timer, DEF_CNT, -1, 0, sm);
+	}
+}
+
+static void test_timers_in_the_past(enum arch_timer timer)
+{
+	int32_t tval = -1 * (int32_t) msec_to_cycles(test_args.wait_ms);
+	uint64_t cval;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		irq_wait_method_t wm = irq_wait_method[i];
+
+		/* set a timer wait_ms the past. */
+		cval = DEF_CNT - msec_to_cycles(test_args.wait_ms);
+		test_timer_cval(timer, cval, wm, true, DEF_CNT);
+		test_timer_tval(timer, tval, wm, true, DEF_CNT);
+
+		/* Set a timer to counter=0 (in the past) */
+		test_timer_cval(timer, 0, wm, true, DEF_CNT);
+
+		/* Set a time for tval=0 (now) */
+		test_timer_tval(timer, 0, wm, true, DEF_CNT);
+
+		/* Set a timer to as far in the past as possible */
+		test_timer_tval(timer, TVAL_MIN, wm, true, DEF_CNT);
+	}
+
+	/*
+	 * Set the counter to wait_ms, and a tval to -wait_ms. There should be no
+	 * timer as that tval means cval=CVAL_MAX-wait_ms.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		sleep_method_t sm = sleep_method[i];
+
+		set_counter(timer, msec_to_cycles(test_args.wait_ms));
+		test_tval_no_irq(timer, tval, TIMEOUT_NO_IRQ_US, sm);
+	}
+}
+
+static void test_long_timer_delays(enum arch_timer timer)
+{
+	int32_t tval = (int32_t) msec_to_cycles(test_args.long_wait_ms);
+	uint64_t cval;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(irq_wait_method); i++) {
+		irq_wait_method_t wm = irq_wait_method[i];
+
+		cval = DEF_CNT + msec_to_cycles(test_args.long_wait_ms);
+		test_timer_cval(timer, cval, wm, true, DEF_CNT);
+		test_timer_tval(timer, tval, wm, true, DEF_CNT);
+	}
+}
+
+static void guest_run_iteration(enum arch_timer timer)
+{
+	test_basic_functionality(timer);
+	test_timers_sanity_checks(timer);
+
+	test_timers_above_tval_max(timer);
+	test_timers_in_the_past(timer);
+
+	test_move_counters_ahead_of_timers(timer);
+	test_move_counters_behind_timers(timer);
+	test_reprogram_timers(timer);
+
+	test_timers_fired_multiple_times(timer);
+
+	test_timer_control_mask_then_unmask(timer);
+	test_timer_control_masks(timer);
+}
+
+static void guest_code(enum arch_timer timer)
+{
+	int i;
+
+	local_irq_disable();
+
+	gic_init(GIC_V3, 1);
+
+	timer_set_ctl(VIRTUAL, CTL_IMASK);
+	timer_set_ctl(PHYSICAL, CTL_IMASK);
+
+	gic_irq_enable(vtimer_irq);
+	gic_irq_enable(ptimer_irq);
+	local_irq_enable();
+
+	for (i = 0; i < test_args.iterations; i++) {
+		GUEST_SYNC(i);
+		guest_run_iteration(timer);
+	}
+
+	test_long_timer_delays(timer);
+	GUEST_DONE();
+}
+
+static uint32_t next_pcpu(void)
+{
+	uint32_t max = get_nprocs();
+	uint32_t cur = sched_getcpu();
+	uint32_t next = cur;
+	cpu_set_t cpuset;
+
+	TEST_ASSERT(max > 1, "Need at least two physical cpus");
+
+	sched_getaffinity(0, sizeof(cpuset), &cpuset);
+
+	do {
+		next = (next + 1) % CPU_SETSIZE;
+	} while (!CPU_ISSET(next, &cpuset));
+
+	return next;
+}
+
+static void migrate_self(uint32_t new_pcpu)
+{
+	int ret;
+	cpu_set_t cpuset;
+	pthread_t thread;
+
+	thread = pthread_self();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+
+	pr_debug("Migrating from %u to %u\n", sched_getcpu(), new_pcpu);
+
+	ret = pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset);
+
+	TEST_ASSERT(ret == 0, "Failed to migrate to pCPU: %u; ret: %d\n",
+		    new_pcpu, ret);
+}
+
+static void kvm_set_cntxct(struct kvm_vcpu *vcpu, uint64_t cnt,
+			   enum arch_timer timer)
+{
+	if (timer == PHYSICAL)
+		vcpu_set_reg(vcpu, KVM_REG_ARM_PTIMER_CNT, cnt);
+	else
+		vcpu_set_reg(vcpu, KVM_REG_ARM_TIMER_CNT, cnt);
+}
+
+static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	enum sync_cmd cmd = uc->args[1];
+	uint64_t val = uc->args[2];
+	enum arch_timer timer = uc->args[3];
+
+	switch (cmd) {
+	case SET_COUNTER_VALUE:
+		kvm_set_cntxct(vcpu, val, timer);
+		break;
+	case USERSPACE_USLEEP:
+		usleep(val);
+		break;
+	case USERSPACE_SCHED_YIELD:
+		sched_yield();
+		break;
+	case USERSPACE_MIGRATE_SELF:
+		migrate_self(next_pcpu());
+		break;
+	default:
+		break;
+	}
+}
+
+static void test_run(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	/* Start on CPU 0 */
+	migrate_self(0);
+
+	while (true) {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			handle_sync(vcpu, &uc);
+			break;
+		case UCALL_DONE:
+			goto out;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			goto out;
+		default:
+			TEST_FAIL("Unexpected guest exit\n");
+		}
+	}
+
+ out:
+	return;
+}
+
+static void test_init_timer_irq(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
+			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
+	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
+			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
+
+	sync_global_to_guest(vm, ptimer_irq);
+	sync_global_to_guest(vm, vtimer_irq);
+
+	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
+}
+
+static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
+			   enum arch_timer timer)
+{
+	*vm = vm_create_with_one_vcpu(vcpu, guest_code);
+	TEST_ASSERT(*vm, "Failed to create the test VM\n");
+
+	vm_init_descriptor_tables(*vm);
+	vm_install_exception_handler(*vm, VECTOR_IRQ_CURRENT,
+				     guest_irq_handler);
+
+	vcpu_init_descriptor_tables(*vcpu);
+	vcpu_args_set(*vcpu, 1, timer);
+
+	test_init_timer_irq(*vm, *vcpu);
+	vgic_v3_setup(*vm, 1, 64);
+	sync_global_to_guest(*vm, test_args);
+}
+
+static void test_print_help(char *name)
+{
+	pr_info("Usage: %s [-h] [-b] [-i iterations] [-l long_wait_ms] [-p] [-v]\n"
+		, name);
+	pr_info("\t-i: Number of iterations (default: %u)\n",
+		NR_TEST_ITERS_DEF);
+	pr_info("\t-b: Test both physical and virtual timers (default: true)\n");
+	pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
+	     LONG_WAIT_TEST_MS);
+	pr_info("\t-l: Delta (in ms) used for wait times (default: %u)\n",
+		WAIT_TEST_MS);
+	pr_info("\t-p: Test physical timer (default: true)\n");
+	pr_info("\t-v: Test virtual timer (default: true)\n");
+	pr_info("\t-h: Print this help message\n");
+}
+
+static bool parse_args(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "bhi:l:pvw:")) != -1) {
+		switch (opt) {
+		case 'b':
+			test_args.test_physical = true;
+			test_args.test_virtual = true;
+			break;
+		case 'i':
+			test_args.iterations =
+			    atoi_positive("Number of iterations", optarg);
+			break;
+		case 'l':
+			test_args.long_wait_ms =
+			    atoi_positive("Long wait time", optarg);
+			break;
+		case 'p':
+			test_args.test_physical = true;
+			test_args.test_virtual = false;
+			break;
+		case 'v':
+			test_args.test_virtual = true;
+			test_args.test_physical = false;
+			break;
+		case 'w':
+			test_args.wait_ms = atoi_positive("Wait time", optarg);
+			break;
+		case 'h':
+		default:
+			goto err;
+		}
+	}
+
+	return true;
+
+ err:
+	test_print_help(argv[0]);
+	return false;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	if (!parse_args(argc, argv))
+		exit(KSFT_SKIP);
+
+	if (test_args.test_virtual) {
+		test_vm_create(&vm, &vcpu, VIRTUAL);
+		test_run(vm, vcpu);
+		kvm_vm_free(vm);
+	}
+
+	if (test_args.test_physical) {
+		test_vm_create(&vm, &vcpu, PHYSICAL);
+		test_run(vm, vcpu);
+		kvm_vm_free(vm);
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index b3e97525cb55..bf461de34785 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_FAIL("Could not get timer %d\n", timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.44.0.278.ge034bb2e1d-goog


