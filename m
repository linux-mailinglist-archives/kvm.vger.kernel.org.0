Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B5B4562D8
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhKRSuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbhKRSuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:50:04 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6876C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:03 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so5585672wmd.1
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=89AsjvVNV/Rc4mz/t7QuZ/hAkSNPw+08m1IGT1ip1xI=;
        b=YcUQsR9goVIG1cmb6wDmmWszFwkT6J/HHGiLzSBZCLy0uob/O1PfkIr4PpOwAx+KgW
         HaKAroxgCFxbwTMHiQA8IY6i96JGwbqkSqGRpXPvR5wscq7oNhSXr0odBxjpwa1mEryy
         IkZmujQJ9t9yD+iFr1IUEP2fYF/cpXP9ezCt/4vLX5zy0SslfxPs9A9Zv7vHCEXpA7OM
         YTseNLdkFx+mhqhIs21GMIbDAiW/FBICBHtsu4sl6G0kB7xs4g+u05l0aEoVbVGQmUTP
         fjdQFcnhCOD8rYSHGOqec7PMForlDrkFPb0bdfU04Rixd+W0UmVcOiBQGPhTL9a6hauU
         FLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89AsjvVNV/Rc4mz/t7QuZ/hAkSNPw+08m1IGT1ip1xI=;
        b=a6/iSOlS9CPt61B/VEirQQ05NOyrdS1VwqgU+hU/As6mmpOT+Qy080e4tZOhFXAmmL
         MBUZqp58dcJwh+htS0GZTxi/qh9xnRhzMfeY9RgInVtNlzlWmI2GAxfTCBk3gduz5Wgn
         qHmiYdofJqBRlcGhStL0jrKsDiQN72DTqK/wGSyfQAQoVA8ypi6I6Qqr0WlLBq6Lw3qp
         rCjPdEIGu8rwEthYq6pNEUbOuj10wvMaOx8Dq6lqthaoTrxh9a6Mh9AsxXLsoQcOFNGt
         zUf+E6iB4jEy4ARe57VOXOdEdlmKYWT74XaZCmZSTgInUmDNW5hhfSThG1E8QfwF5Tnd
         6/4A==
X-Gm-Message-State: AOAM530uYworrt6NvgFHWdwodvIG/fA/LKQ3eBiyZ1XFhax7SYcpCeK3
        z8FXC5CKEvtiQjXoAY7kZ+Le3w==
X-Google-Smtp-Source: ABdhPJxtJMfw1VaJ9apSMOVnKg6iVLS/xnIsuT0Gx51E7pogEWTJyMokYRVchlu/236t/dIVufjhmA==
X-Received: by 2002:a05:600c:4f02:: with SMTP id l2mr12707960wmq.26.1637261222298;
        Thu, 18 Nov 2021 10:47:02 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id b11sm9637580wmj.35.2021.11.18.10.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:55 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 78D701FF9F;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [kvm-unit-tests PATCH v8 08/10] arm/barrier-litmus-tests: add simple mp and sal litmus tests
Date:   Thu, 18 Nov 2021 18:46:48 +0000
Message-Id: <20211118184650.661575-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a framework for adding simple barrier litmus tests against
ARM. The litmus tests aren't as comprehensive as the academic exercises
which will attempt to do all sorts of things to keep racing CPUs synced
up. These tests do honour the "sync" parameter to do a poor-mans
equivalent.

The two litmus tests are:
  - message passing
  - store-after-load

They both have case that should fail (although won't on single-threaded
TCG setups). If barriers aren't working properly the store-after-load
test will fail even on an x86 backend as x86 allows re-ording of non
aliased stores.

I've imported a few more of the barrier primatives from the Linux source
tree so we consistently use macros.

The arm64 barrier primitives trip up on -Wstrict-aliasing so this is
disabled in the Makefile.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Will Deacon <will@kernel.org>

---
v8
  - move to mttcgtests.cfg
  - fix checkpatch issues
  - fix report usage
v7
  - merge in store-after-load
  - clean-up sync-up code
  - use new counter api
  - fix xfail for sal test
v6
  - add a unittest.cfg
  - -fno-strict-aliasing
---
 arm/Makefile.common       |   1 +
 lib/arm/asm/barrier.h     |  61 ++++++
 lib/arm64/asm/barrier.h   |  50 +++++
 arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
 arm/mttcgtests.cfg        |  33 +++
 5 files changed, 595 insertions(+)
 create mode 100644 arm/barrier-litmus-test.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index f905971..861e5c7 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -13,6 +13,7 @@ tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
 tests-common += $(TEST_DIR)/tlbflush-code.flat
 tests-common += $(TEST_DIR)/locking-test.flat
+tests-common += $(TEST_DIR)/barrier-litmus-test.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/lib/arm/asm/barrier.h b/lib/arm/asm/barrier.h
index 7f86831..2870080 100644
--- a/lib/arm/asm/barrier.h
+++ b/lib/arm/asm/barrier.h
@@ -8,6 +8,8 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#include <stdint.h>
+
 #define sev()		asm volatile("sev" : : : "memory")
 #define wfe()		asm volatile("wfe" : : : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
@@ -25,4 +27,63 @@
 #define smp_rmb()	smp_mb()
 #define smp_wmb()	dmb(ishst)
 
+extern void abort(void);
+
+static inline void __write_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(volatile uint8_t *)p = *(uint8_t *)res; break;
+	case 2: *(volatile uint16_t *)p = *(uint16_t *)res; break;
+	case 4: *(volatile uint32_t *)p = *(uint32_t *)res; break;
+	case 8: *(volatile uint64_t *)p = *(uint64_t *)res; break;
+	default:
+		/* unhandled case */
+		abort();
+	}
+}
+
+#define WRITE_ONCE(x, val) \
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =	\
+		{ .__val = (typeof(x)) (val) }; \
+	__write_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+
+static inline
+void __read_once_size(const volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(uint8_t *)res = *(volatile uint8_t *)p; break;
+	case 2: *(uint16_t *)res = *(volatile uint16_t *)p; break;
+	case 4: *(uint32_t *)res = *(volatile uint32_t *)p; break;
+	case 8: *(uint64_t *)res = *(volatile uint64_t *)p; break;
+	default:
+		/* unhandled case */
+		abort();
+	}
+}
+
+#define READ_ONCE(x)							\
+({									\
+	union { typeof(x) __val; char __c[1]; } __u;			\
+	__read_once_size(&(x), __u.__c, sizeof(x));			\
+	__u.__val;							\
+})
+
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = READ_ONCE(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* _ASMARM_BARRIER_H_ */
diff --git a/lib/arm64/asm/barrier.h b/lib/arm64/asm/barrier.h
index 0e1904c..5e40519 100644
--- a/lib/arm64/asm/barrier.h
+++ b/lib/arm64/asm/barrier.h
@@ -24,4 +24,54 @@
 #define smp_rmb()	dmb(ishld)
 #define smp_wmb()	dmb(ishst)
 
+#define smp_store_release(p, v)						\
+do {									\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile ("stlrb %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 2:								\
+		asm volatile ("stlrh %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 4:								\
+		asm volatile ("stlr %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("stlr %1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	union { typeof(*p) __val; char __c[1]; } __u;			\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile ("ldarb %w0, %1"				\
+			: "=r" (*(u8 *)__u.__c)				\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile ("ldarh %w0, %1"				\
+			: "=r" (*(u16 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile ("ldar %w0, %1"				\
+			: "=r" (*(u32 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 8:								\
+		asm volatile ("ldar %0, %1"				\
+			: "=r" (*(u64 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	}								\
+	__u.__val;							\
+})
+
 #endif /* _ASMARM64_BARRIER_H_ */
diff --git a/arm/barrier-litmus-test.c b/arm/barrier-litmus-test.c
new file mode 100644
index 0000000..e90f6dd
--- /dev/null
+++ b/arm/barrier-litmus-test.c
@@ -0,0 +1,450 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ARM Barrier Litmus Tests
+ *
+ * This test provides a framework for testing barrier conditions on
+ * the processor. It's simpler than the more involved barrier testing
+ * frameworks as we are looking for simple failures of QEMU's TCG not
+ * weird edge cases the silicon gets wrong.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#define MAX_CPUS 8
+
+/* Array size and access controls */
+static int array_size = 100000;
+static int wait_if_ahead;
+
+static cpumask_t cpu_mask;
+
+/*
+ * These test_array_* structures are a contiguous array modified by two or more
+ * competing CPUs. The padding is to ensure the variables do not share
+ * cache lines.
+ *
+ * All structures start zeroed.
+ */
+
+typedef struct test_array {
+	volatile unsigned int x;
+	uint8_t dummy[64];
+	volatile unsigned int y;
+	uint8_t dummy2[64];
+	volatile unsigned int r[MAX_CPUS];
+} test_array;
+
+volatile test_array *array;
+
+/* Test definition structure
+ *
+ * The first function will always run on the primary CPU, it is
+ * usually the one that will detect any weirdness and trigger the
+ * failure of the test.
+ */
+
+typedef void (*test_fn)(void);
+
+typedef struct {
+	const char *test_name;
+	bool  should_pass;
+	test_fn main_fn;
+	test_fn secondary_fns[MAX_CPUS-1];
+} test_descr_t;
+
+/* Litmus tests */
+
+static unsigned long sync_start(void)
+{
+	const unsigned long gate_mask = ~0x3ffff;
+	unsigned long gate, now;
+
+	gate = get_cntvct() & gate_mask;
+	do {
+		now = get_cntvct();
+	} while ((now & gate_mask) == gate);
+
+	return now;
+}
+
+/* Simple Message Passing
+ *
+ * x is the message data
+ * y is the flag to indicate the data is ready
+ *
+ * Reading x == 0 when y == 1 is a failure.
+ */
+
+static void message_passing_write(void)
+{
+	int i;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		entry->y = 1;
+	}
+
+	halt();
+}
+
+static void message_passing_read(void)
+{
+	int i;
+	int errors = 0, ready = 0;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = entry->y;
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+		ready += y;
+	}
+
+	/*
+	 * We expect this to fail but with STO backends you often get
+	 * way with it. Fudge xfail if we did actually pass.
+	 */
+	report_xfail(errors == 0 ? false : true, errors == 0,
+		     "mp: %d errors, %d ready", errors, ready);
+}
+
+/* Simple Message Passing with barriers */
+static void message_passing_write_barrier(void)
+{
+	int i;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		smp_wmb();
+		entry->y = 1;
+	}
+
+	halt();
+}
+
+static void message_passing_read_barrier(void)
+{
+	int i;
+	int errors = 0, ready = 0, not_ready = 0;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = entry->y;
+		smp_rmb();
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+
+		if (y) {
+			ready++;
+		} else {
+			not_ready++;
+
+			if (not_ready > 2) {
+				entry = &array[i+1];
+				do {
+					not_ready = 0;
+				} while (wait_if_ahead && !entry->y);
+			}
+		}
+	}
+
+	report(errors == 0, "mp barrier: %d errors, %d ready", errors, ready);
+}
+
+/* Simple Message Passing with Acquire/Release */
+static void message_passing_write_release(void)
+{
+	int i;
+
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		smp_store_release(&entry->y, 1);
+	}
+
+	halt();
+}
+
+static void message_passing_read_acquire(void)
+{
+	int i;
+	int errors = 0, ready = 0, not_ready = 0;
+
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = smp_load_acquire(&entry->y);
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+
+		if (y) {
+			ready++;
+		} else {
+			not_ready++;
+
+			if (not_ready > 2) {
+				entry = &array[i+1];
+				do {
+					not_ready = 0;
+				} while (wait_if_ahead && !entry->y);
+			}
+		}
+	}
+
+	report(errors == 0, "mp acqrel: %d errors, %d ready", errors, ready);
+}
+
+/*
+ * Store after load
+ *
+ * T1: write 1 to x, load r from y
+ * T2: write 1 to y, load r from x
+ *
+ * Without memory fence r[0] && r[1] == 0
+ * With memory fence both == 0 should be impossible
+ */
+
+static void check_store_and_load_results(const char *name, int thread,
+					 bool xfail, unsigned long start,
+					 unsigned long end)
+{
+	int i;
+	int neither = 0;
+	int only_first = 0;
+	int only_second = 0;
+	int both = 0;
+
+	for ( i= 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		if (entry->r[0] == 0 &&
+		    entry->r[1] == 0)
+			neither++;
+		else if (entry->r[0] &&
+			entry->r[1])
+			both++;
+		else if (entry->r[0])
+			only_first++;
+		else
+			only_second++;
+	}
+
+	printf("T%d: %08lx->%08lx neither=%d only_t1=%d only_t2=%d both=%d\n", thread,
+		start, end, neither, only_first, only_second, both);
+
+	if (thread == 1)
+		report_xfail(xfail, neither==0, "%s: errors=%d", name, neither);
+
+}
+
+/*
+ * This attempts to synchronise the start of both threads to roughly
+ * the same time. On real hardware there is a little latency as the
+ * secondary vCPUs are powered up however this effect it much more
+ * exaggerated on a TCG host.
+ *
+ * Busy waits until the we pass a future point in time, returns final
+ * start time.
+ */
+
+static void store_and_load_1(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->x = 1;
+		r = entry->y;
+		entry->r[0] = r;
+	}
+	end = get_cntvct();
+
+	smp_mb();
+
+	while (!cpumask_test_cpu(1, &cpu_mask))
+		cpu_relax();
+
+	check_store_and_load_results("sal", 1, true, start, end);
+}
+
+static void store_and_load_2(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->y = 1;
+		r = entry->x;
+		entry->r[1] = r;
+	}
+	end = get_cntvct();
+
+	check_store_and_load_results("sal", 2, true, start, end);
+
+	cpumask_set_cpu(1, &cpu_mask);
+
+	halt();
+}
+
+static void store_and_load_barrier_1(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->x = 1;
+		smp_mb();
+		r = entry->y;
+		entry->r[0] = r;
+	}
+	end = get_cntvct();
+
+	smp_mb();
+
+	while (!cpumask_test_cpu(1, &cpu_mask))
+		cpu_relax();
+
+	check_store_and_load_results("sal_barrier", 1, false, start, end);
+}
+
+static void store_and_load_barrier_2(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->y = 1;
+		smp_mb();
+		r = entry->x;
+		entry->r[1] = r;
+	}
+	end = get_cntvct();
+
+	check_store_and_load_results("sal_barrier", 2, false, start, end);
+
+	cpumask_set_cpu(1, &cpu_mask);
+
+	halt();
+}
+
+
+/* Test array */
+static test_descr_t tests[] = {
+
+	{ "mp",         false,
+	  message_passing_read,
+	  { message_passing_write }
+	},
+
+	{ "mp_barrier", true,
+	  message_passing_read_barrier,
+	  { message_passing_write_barrier }
+	},
+
+	{ "mp_acqrel", true,
+	  message_passing_read_acquire,
+	  { message_passing_write_release }
+	},
+
+	{ "sal",       false,
+	  store_and_load_1,
+	  { store_and_load_2 }
+	},
+
+	{ "sal_barrier", true,
+	  store_and_load_barrier_1,
+	  { store_and_load_barrier_2 }
+	},
+};
+
+
+static void setup_and_run_litmus(test_descr_t *test)
+{
+	array = calloc(array_size, sizeof(test_array));
+
+	if (array) {
+		int i = 0;
+
+		printf("Allocated test array @ %p\n", array);
+
+		while (test->secondary_fns[i]) {
+			smp_boot_secondary(i+1, test->secondary_fns[i]);
+			i++;
+		}
+
+		test->main_fn();
+	} else
+		report(false, "%s: failed to allocate memory", test->test_name);
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+	unsigned int j;
+	test_descr_t *test = NULL;
+
+	for (i = 0; i < argc; i++) {
+		char *arg = argv[i];
+
+		for (j = 0; j < ARRAY_SIZE(tests); j++) {
+			if (strcmp(arg, tests[j].test_name) == 0)
+				test = &tests[j];
+		}
+
+		/* Test modifiers */
+		if (strstr(arg, "count=") != NULL) {
+			char *p = strstr(arg, "=");
+
+			array_size = atol(p+1);
+		} else if (strcmp(arg, "wait") == 0) {
+			wait_if_ahead = 1;
+		}
+	}
+
+	if (test)
+		setup_and_run_litmus(test);
+	else
+		report(false, "Unknown test");
+
+	return report_summary();
+}
diff --git a/arm/mttcgtests.cfg b/arm/mttcgtests.cfg
index 46fcb57..2b46756 100644
--- a/arm/mttcgtests.cfg
+++ b/arm/mttcgtests.cfg
@@ -57,3 +57,36 @@ file = locking-test.flat
 smp = $(($MAX_SMP>4?4:$MAX_SMP))
 extra_params = -append 'excl'
 groups = locking
+
+# Barrier Litmus tests
+[barrier-litmus::mp]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp'
+groups = barrier
+
+[barrier-litmus::mp-barrier]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp_barrier'
+groups = barrier
+
+[barrier-litmus::mp-acqrel]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp_acqrel'
+groups = barrier
+
+[barrier-litmus::sal]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'sal'
+groups = barrier
+accel = tcg
+
+[barrier-litmus::sal-barrier]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'sal_barrier'
+groups = barrier
+
-- 
2.30.2

