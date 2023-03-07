Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9986ADD47
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCGL3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjCGL2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:54 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD573BDB6
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:49 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v16so11825534wrn.0
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRctlh9akpwrufJyXwUzP4xfjZlbVf4MGU45m1EN2tU=;
        b=Mlva9JTNZLWZRHBNBeHk+cT30qPYw6xL4GCywJpoKQ39cj61DvxQM5ST1EogoZ1AlT
         nO1YkZNmhHZ9TV/Sl4dUvWkWJl1a3Ngh41mCGAmsS5bKdeDG1yJMT2fJZDF4Og6vJ9jM
         2q6oUJd1Pikf0Rylc1HrDXP46aStPgMwWnbXp128aL1Dhnzv/u1XWh9t/am/xof0z/rE
         33SdVhqxUBG6q8eMzAJB8cY3GtJiHhzamD47sv9w9aqEP4rj7pfzfPqcLQOFlE0MjSGA
         oKcae72YlHbzJq8rRtNimGfhnK3CfnSUzE8/+j8d1X0C1so9X0Fi1VJUtPwsqE+5XjH5
         ClLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRctlh9akpwrufJyXwUzP4xfjZlbVf4MGU45m1EN2tU=;
        b=4AjyNn5VtqHCOAK5xesyAlcR/HYYMBrPrBo4pWrPTJ6GTtZKKlUFG4xfA8gJ2cylzr
         V0lDVrLv2CnO4UDWFv14lwmukUqq7n24kSxw+mfXKl3bv7kHtIvIRrATCot1k17JtBJv
         C8C+PhyfZX8EMC5jIAOJ88hVne8Fih9u9k4SlV2TYfWC6o65egcm/vCAoj8wpm0kUn7w
         gnconZNKU/Xki7I0Vig1Ies/yuOBoLDD+GmZivamvaCjYi7YHSrTT7tOZjb4EidYLbDQ
         /qVlljywRNrmeunAh+o3FwlEnmemP5S+2VtOcz+2vScG5AvmS47+DB8vs48gDXEutqEO
         gBZQ==
X-Gm-Message-State: AO0yUKXvdXaNI3CNf8WCnvltqgXPqfU20yaoZBmKSZ5ApCqHIcBOynor
        /1tQGHc4zMtru6rq9dxNpdngIA==
X-Google-Smtp-Source: AK7set9FcJugITuSwPRiEj5if60tsa2J7XWtF8M6GeAjABiE97903uGYfwt+UHM+cW+IBpbPvLHSCg==
X-Received: by 2002:a5d:614d:0:b0:2c7:d6a:cca9 with SMTP id y13-20020a5d614d000000b002c70d6acca9mr9240330wrt.23.1678188527744;
        Tue, 07 Mar 2023 03:28:47 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id r22-20020a05600c435600b003eae73ee4a1sm12716650wme.17.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:47 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 02F431FFBD;
        Tue,  7 Mar 2023 11:28:46 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v10 5/7] arm/locking-tests: add comprehensive locking test
Date:   Tue,  7 Mar 2023 11:28:43 +0000
Message-Id: <20230307112845.452053-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test has been written mainly to stress multi-threaded TCG behaviour
but will demonstrate failure by default on real hardware. The test takes
the following parameters:

  - "lock" use GCC's locking semantics
  - "atomic" use GCC's __atomic primitives
  - "wfelock" use WaitForEvent sleep
  - "excl" use load/store exclusive semantics

Also two more options allow the test to be tweaked

  - "noshuffle" disables the memory shuffling
  - "count=%ld" set your own per-CPU increment count

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20211118184650.661575-8-alex.bennee@linaro.org>

---
v9
  - move back to unittests.cfg, drop accel=tcg
  - s/printf/report_info
v10
  - dropped spare extra line in shuffle_memory
---
 arm/Makefile.common |   2 +-
 arm/locking-test.c  | 321 ++++++++++++++++++++++++++++++++++++++++++++
 arm/spinlock-test.c |  87 ------------
 arm/unittests.cfg   |  30 +++++
 4 files changed, 352 insertions(+), 88 deletions(-)
 create mode 100644 arm/locking-test.c
 delete mode 100644 arm/spinlock-test.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 2c4aad38..3089e3bf 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -5,7 +5,6 @@
 #
 
 tests-common  = $(TEST_DIR)/selftest.flat
-tests-common += $(TEST_DIR)/spinlock-test.flat
 tests-common += $(TEST_DIR)/pci-test.flat
 tests-common += $(TEST_DIR)/pmu.flat
 tests-common += $(TEST_DIR)/gic.flat
@@ -13,6 +12,7 @@ tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
 tests-common += $(TEST_DIR)/tlbflush-code.flat
+tests-common += $(TEST_DIR)/locking-test.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/locking-test.c b/arm/locking-test.c
new file mode 100644
index 00000000..a49c2fd1
--- /dev/null
+++ b/arm/locking-test.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Locking Test
+ *
+ * This test allows us to stress the various atomic primitives of a VM
+ * guest. A number of methods are available that use various patterns
+ * to implement a lock.
+ *
+ * Copyright (C) 2017 Linaro
+ * Author: Alex Bennée <alex.bennee@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#include <prng.h>
+
+#define MAX_CPUS 8
+
+/* Test definition structure
+ *
+ * A simple structure that describes the test name, expected pass and
+ * increment function.
+ */
+
+/* Function pointers for test */
+typedef void (*inc_fn)(int cpu);
+
+typedef struct {
+	const char *test_name;
+	bool  should_pass;
+	inc_fn main_fn;
+} test_descr_t;
+
+/* How many increments to do */
+static int increment_count = 1000000;
+static bool do_shuffle = true;
+
+/* Shared value all the tests attempt to safely increment using
+ * various forms of atomic locking and exclusive behaviour.
+ */
+static unsigned int shared_value;
+
+/* PAGE_SIZE * uint32_t means we span several pages */
+__attribute__((aligned(PAGE_SIZE))) static uint32_t memory_array[PAGE_SIZE];
+
+/* We use the alignment of the following to ensure accesses to locking
+ * and synchronisation primatives don't interfere with the page of the
+ * shared value
+ */
+__attribute__((aligned(PAGE_SIZE))) static unsigned int per_cpu_value[MAX_CPUS];
+__attribute__((aligned(PAGE_SIZE))) static cpumask_t smp_test_complete;
+__attribute__((aligned(PAGE_SIZE))) struct isaac_ctx prng_context[MAX_CPUS];
+
+/* Some of the approaches use a global lock to prevent contention. */
+static int global_lock;
+
+/* In any SMP setting this *should* fail due to cores stepping on
+ * each other updating the shared variable
+ */
+static void increment_shared(int cpu)
+{
+	(void)cpu;
+
+	shared_value++;
+}
+
+/* GCC __sync primitives are deprecated in favour of __atomic */
+static void increment_shared_with_lock(int cpu)
+{
+	(void)cpu;
+
+	while (__sync_lock_test_and_set(&global_lock, 1));
+
+	shared_value++;
+
+	__sync_lock_release(&global_lock);
+}
+
+/*
+ * In practice even __ATOMIC_RELAXED uses ARM's ldxr/stex exclusive
+ * semantics
+ */
+static void increment_shared_with_atomic(int cpu)
+{
+	(void)cpu;
+
+	__atomic_add_fetch(&shared_value, 1, __ATOMIC_SEQ_CST);
+}
+
+
+/*
+ * Load/store exclusive with WFE (wait-for-event)
+ *
+ * See ARMv8 ARM examples:
+ *   Use of Wait For Event (WFE) and Send Event (SEV) with locks
+ */
+
+static void increment_shared_with_wfelock(int cpu)
+{
+	(void)cpu;
+
+#if defined(__aarch64__)
+	asm volatile(
+	"	mov     w1, #1\n"
+	"       sevl\n"
+	"       prfm PSTL1KEEP, [%[lock]]\n"
+	"1:     wfe\n"
+	"	ldaxr	w0, [%[lock]]\n"
+	"	cbnz    w0, 1b\n"
+	"	stxr    w0, w1, [%[lock]]\n"
+	"	cbnz	w0, 1b\n"
+	/* lock held */
+	"	ldr	w0, [%[sptr]]\n"
+	"	add	w0, w0, #0x1\n"
+	"	str	w0, [%[sptr]]\n"
+	/* now release */
+	"	stlr	wzr, [%[lock]]\n"
+	: /* out */
+	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
+	: "w0", "w1", "cc");
+#else
+	asm volatile(
+	"	mov     r1, #1\n"
+	"1:	ldrex	r0, [%[lock]]\n"
+	"	cmp     r0, #0\n"
+	"	wfene\n"
+	"	strexeq r0, r1, [%[lock]]\n"
+	"	cmpeq	r0, #0\n"
+	"	bne	1b\n"
+	"	dmb\n"
+	/* lock held */
+	"	ldr	r0, [%[sptr]]\n"
+	"	add	r0, r0, #0x1\n"
+	"	str	r0, [%[sptr]]\n"
+	/* now release */
+	"	mov	r0, #0\n"
+	"	dmb\n"
+	"	str	r0, [%[lock]]\n"
+	"	dsb\n"
+	"	sev\n"
+	: /* out */
+	: [lock] "r" (&global_lock), [sptr] "r" (&shared_value) /* in */
+	: "r0", "r1", "cc");
+#endif
+}
+
+
+/*
+ * Hand-written version of the load/store exclusive
+ */
+static void increment_shared_with_excl(int cpu)
+{
+	(void)cpu;
+
+#if defined(__aarch64__)
+	asm volatile(
+	"1:	ldxr	w0, [%[sptr]]\n"
+	"	add     w0, w0, #0x1\n"
+	"	stxr	w1, w0, [%[sptr]]\n"
+	"	cbnz	w1, 1b\n"
+	: /* out */
+	: [sptr] "r" (&shared_value) /* in */
+	: "w0", "w1", "cc");
+#else
+	asm volatile(
+	"1:	ldrex	r0, [%[sptr]]\n"
+	"	add     r0, r0, #0x1\n"
+	"	strex	r1, r0, [%[sptr]]\n"
+	"	cmp	r1, #0\n"
+	"	bne	1b\n"
+	: /* out */
+	: [sptr] "r" (&shared_value) /* in */
+	: "r0", "r1", "cc");
+#endif
+}
+
+/* Test array */
+static test_descr_t tests[] = {
+	{ "none", false, increment_shared },
+	{ "lock", true, increment_shared_with_lock },
+	{ "atomic", true, increment_shared_with_atomic },
+	{ "wfelock", true, increment_shared_with_wfelock },
+	{ "excl", true, increment_shared_with_excl }
+};
+
+/* The idea of this is just to generate some random load/store
+ * activity which may or may not race with an un-barried incremented
+ * of the shared counter
+ */
+static void shuffle_memory(int cpu)
+{
+	int i;
+	uint32_t lspat = isaac_next_uint32(&prng_context[cpu]);
+	uint32_t seq = isaac_next_uint32(&prng_context[cpu]);
+	int count = seq & 0x1f;
+	uint32_t val = 0;
+
+	seq >>= 5;
+
+	for (i = 0; i < count; i++) {
+		int index = seq & ~PAGE_MASK;
+
+		if (lspat & 1)
+			val ^= memory_array[index];
+		else
+			memory_array[index] = val;
+
+		seq >>= PAGE_SHIFT;
+		seq ^= lspat;
+		lspat >>= 1;
+	}
+}
+
+static inc_fn increment_function;
+
+static void do_increment(void)
+{
+	int i;
+	int cpu = smp_processor_id();
+
+	report_info("CPU%d: online and ++ing", cpu);
+
+	for (i = 0; i < increment_count; i++) {
+		per_cpu_value[cpu]++;
+		increment_function(cpu);
+
+		if (do_shuffle)
+			shuffle_memory(cpu);
+	}
+
+	report_info("CPU%d: Done, %d incs\n", cpu, per_cpu_value[cpu]);
+
+	cpumask_set_cpu(cpu, &smp_test_complete);
+	if (cpu != 0)
+		halt();
+}
+
+static void setup_and_run_test(test_descr_t *test)
+{
+	unsigned int i, sum = 0;
+	int cpu, cpu_cnt = 0;
+
+	increment_function = test->main_fn;
+
+	/* fill our random page */
+	for (i = 0; i < PAGE_SIZE; i++)
+		memory_array[i] = isaac_next_uint32(&prng_context[0]);
+
+	for_each_present_cpu(cpu) {
+		uint32_t seed2 = isaac_next_uint32(&prng_context[0]);
+
+		cpu_cnt++;
+		if (cpu == 0)
+			continue;
+
+		isaac_init(&prng_context[cpu], (unsigned char *) &seed2, sizeof(seed2));
+		smp_boot_secondary(cpu, do_increment);
+	}
+
+	do_increment();
+
+	while (!cpumask_full(&smp_test_complete))
+		cpu_relax();
+
+	/* All CPUs done, do we add up */
+	for_each_present_cpu(cpu) {
+		sum += per_cpu_value[cpu];
+	}
+
+	if (test->should_pass)
+		report(sum == shared_value, "total incs %d", shared_value);
+	else
+		report_xfail(true, sum == shared_value, "total incs %d", shared_value);
+}
+
+int main(int argc, char **argv)
+{
+	static const unsigned char seed[] = "myseed";
+	test_descr_t *test = &tests[0];
+	int i;
+	unsigned int j;
+
+	isaac_init(&prng_context[0], &seed[0], sizeof(seed));
+
+	for (i = 0; i < argc; i++) {
+		char *arg = argv[i];
+
+		/* Check for test name */
+		for (j = 0; j < ARRAY_SIZE(tests); j++) {
+			if (strcmp(arg, tests[j].test_name) == 0)
+				test = &tests[j];
+		}
+
+		/* Test modifiers */
+		if (strcmp(arg, "noshuffle") == 0) {
+			do_shuffle = false;
+			report_prefix_push("noshuffle");
+		} else if (strstr(arg, "count=") != NULL) {
+			char *p = strstr(arg, "=");
+
+			increment_count = atol(p+1);
+		} else {
+			isaac_reseed(&prng_context[0], (unsigned char *) arg, strlen(arg));
+		}
+	}
+
+	if (test)
+		setup_and_run_test(test);
+	else
+		report(false, "Unknown test");
+
+	return report_summary();
+}
diff --git a/arm/spinlock-test.c b/arm/spinlock-test.c
deleted file mode 100644
index 73aea76a..00000000
--- a/arm/spinlock-test.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Spinlock test
- *
- * This code is based on code from the tcg_baremetal_tests.
- *
- * Copyright (C) 2015 Virtual Open Systems SAS
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <libcflat.h>
-#include <asm/smp.h>
-#include <asm/barrier.h>
-
-#define LOOP_SIZE 10000000
-
-struct lock_ops {
-	void (*lock)(int *v);
-	void (*unlock)(int *v);
-};
-static struct lock_ops lock_ops;
-
-static void gcc_builtin_lock(int *lock_var)
-{
-	while (__sync_lock_test_and_set(lock_var, 1));
-}
-static void gcc_builtin_unlock(int *lock_var)
-{
-	__sync_lock_release(lock_var);
-}
-static void none_lock(int *lock_var)
-{
-	while (*(volatile int *)lock_var != 0);
-	*(volatile int *)lock_var = 1;
-}
-static void none_unlock(int *lock_var)
-{
-	*(volatile int *)lock_var = 0;
-}
-
-static int global_a, global_b;
-static int global_lock;
-
-static void test_spinlock(void *data __unused)
-{
-	int i, errors = 0;
-	int cpu = smp_processor_id();
-
-	printf("CPU%d online\n", cpu);
-
-	for (i = 0; i < LOOP_SIZE; i++) {
-
-		lock_ops.lock(&global_lock);
-
-		if (global_a == (cpu + 1) % 2) {
-			global_a = 1;
-			global_b = 0;
-		} else {
-			global_a = 0;
-			global_b = 1;
-		}
-
-		if (global_a == global_b)
-			errors++;
-
-		lock_ops.unlock(&global_lock);
-	}
-	report(errors == 0, "CPU%d: Done - Errors: %d", cpu, errors);
-}
-
-int main(int argc, char **argv)
-{
-	report_prefix_push("spinlock");
-	if (argc > 1 && strcmp(argv[1], "bad") != 0) {
-		lock_ops.lock = gcc_builtin_lock;
-		lock_ops.unlock = gcc_builtin_unlock;
-	} else {
-		lock_ops.lock = none_lock;
-		lock_ops.unlock = none_unlock;
-	}
-
-	on_cpus(test_spinlock, NULL);
-
-	return report_summary();
-}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index ee21aef4..45ac61c8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -300,3 +300,33 @@ smp = $(($MAX_SMP>4?4:$MAX_SMP))
 extra_params = -append 'page self'
 groups = nodefault mttcg
 
+# Locking tests
+[locking::none]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+groups = nodefault mttcg locking
+
+[locking::lock]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'lock'
+groups = nodefault mttcg locking
+
+[locking::atomic]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'atomic'
+groups = nodefault mttcg locking
+
+[locking::wfelock]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'wfelock'
+groups = nodefault mttcg locking
+
+[locking::excl]
+file = locking-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'excl'
+groups = nodefault mttcg locking
+
-- 
2.39.2

