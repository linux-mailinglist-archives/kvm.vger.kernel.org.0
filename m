Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19F6ADD45
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCGL3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCGL2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:51 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C03B67F
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p26so7516320wmc.4
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnIjeSc1FJePfsNSVfRIwqJW9N48Tra8RDl/0gXoxhE=;
        b=wGDT+w35u+rBSYyqsw8q1e/mzbhczTfQ89KcObYUmTM4dZQP0PRQ0X6eBIa4BW6Nq6
         vNvCvwKIwU0G+kIp9k4/LEnq6kqPVpXRfDkXeVwEXsPvOtCQr/f11WUsVI2/lExCf0jI
         QQbytxW5o05sxcYaQz/NIwwGiECj0IfYHs8ReNZGKRaDog9Kk+LAJETKm+Fs6eNE8yaM
         Kt/zzm4cZI6unJ+oD3RGlAdkio+8Oi7u7aSod6hkIA5iZPI34ikslCzW22+0aIYgiP7Y
         bkdAKK5qBvT0oA9tpP5U/JANZ0wVZs0ofqJpBiCpG+HV0/IiClkxfMG+SUDI2R0MmUJT
         3oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnIjeSc1FJePfsNSVfRIwqJW9N48Tra8RDl/0gXoxhE=;
        b=G8MQPCx6MnBvPIpfw+VjwSepoBAwWYeim9+eoq+gesmGKeBF8qVeD4rT4vQDWDhBTe
         6A613NC1lbQUt97b0CQknxkcKyjk8dqlR8gEtApFeYNLT/dQUMXLeQEitZvJzUayFIqc
         F7L7I59x7AtphdtdC1H2dyhJO3U2EmIH+gPQQGkqmXFvRmSjE44hPkSklB/4QlUDSTkX
         CPRWW1SE80xr+8KpYtVVWY/ExcM2WO6ztK2x7r61BU9lJRCTcwCrob37iw7gdkTFx3bF
         1vSVLZTE2h8FZJPUhOU7CuGb1vYNqKz1jPo6gqswLGQyIFVQJZEiYjX16Z05BGOI+T7r
         Iifg==
X-Gm-Message-State: AO0yUKUAQAiz6y8ord2k+/qHKhqJY7bOl6wmGYfyB1Lu7fFJhSjbfgbe
        A9V4rlGsMvaKCPSR/rgDXWsuoQ==
X-Google-Smtp-Source: AK7set+k6lkDLloBeMsu6SpyszyLxRsEcP3kJX2xB4D4Q/fR0vdjO4ZVACpYM9hl4FN3UxHNDeAjDg==
X-Received: by 2002:a05:600c:548b:b0:3eb:39e7:3607 with SMTP id iv11-20020a05600c548b00b003eb39e73607mr13094175wmb.4.1678188527307;
        Tue, 07 Mar 2023 03:28:47 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c47d500b003e11ad0750csm12337353wmo.47.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:46 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E11201FFBC;
        Tue,  7 Mar 2023 11:28:45 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush during code execution
Date:   Tue,  7 Mar 2023 11:28:42 +0000
Message-Id: <20230307112845.452053-5-alex.bennee@linaro.org>
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

This adds a fairly brain dead torture test for TLB flushes intended
for stressing the MTTCG QEMU build. It takes the usual -smp option for
multiple CPUs.

By default it CPU0 will do a TLBIALL flush after each cycle. You can
pass options via -append to control additional aspects of the test:

  - "page" flush each page in turn (one per function)
  - "self" do the flush after each computation cycle
  - "verbose" report progress on each computation cycle

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>
Message-Id: <20211118184650.661575-7-alex.bennee@linaro.org>

---
v9
  - move tests back into unittests.cfg (with nodefault mttcg)
  - replace printf with report_info
  - drop accel = tcg
---
 arm/Makefile.common |   1 +
 arm/tlbflush-code.c | 209 ++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg   |  25 ++++++
 3 files changed, 235 insertions(+)
 create mode 100644 arm/tlbflush-code.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 16f8c6df..2c4aad38 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
+tests-common += $(TEST_DIR)/tlbflush-code.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/tlbflush-code.c b/arm/tlbflush-code.c
new file mode 100644
index 00000000..bf9eb111
--- /dev/null
+++ b/arm/tlbflush-code.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TLB Flush Race Tests
+ *
+ * These tests are designed to test for incorrect TLB flush semantics
+ * under emulation. The initial CPU will set all the others working a
+ * compuation task and will then trigger TLB flushes across the
+ * system. It doesn't actually need to re-map anything but the flushes
+ * themselves will trigger QEMU's TCG self-modifying code detection
+ * which will invalidate any generated  code causing re-translation.
+ * Eventually the code buffer will fill and a general tb_lush() will
+ * be triggered.
+ *
+ * Copyright (C) 2016-2021, Linaro, Alex Bennée <alex.bennee@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#define SEQ_LENGTH 10
+#define SEQ_HASH 0x7cd707fe
+
+static cpumask_t smp_test_complete;
+static int flush_count = 1000000;
+static bool flush_self;
+static bool flush_page;
+static bool flush_verbose;
+
+/*
+ * Work functions
+ *
+ * These work functions need to be:
+ *
+ *  - page aligned, so we can flush one function at a time
+ *  - have branches, so QEMU TCG generates multiple basic blocks
+ *  - call across pages, so we exercise the TCG basic block slow path
+ */
+
+/* Adler32 */
+__attribute__((aligned(PAGE_SIZE))) static
+uint32_t hash_array(const void *buf, size_t buflen)
+{
+	const uint8_t *data = (uint8_t *) buf;
+	uint32_t s1 = 1;
+	uint32_t s2 = 0;
+
+	for (size_t n = 0; n < buflen; n++) {
+		s1 = (s1 + data[n]) % 65521;
+		s2 = (s2 + s1) % 65521;
+	}
+	return (s2 << 16) | s1;
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+void create_fib_sequence(int length, unsigned int *array)
+{
+	int i;
+
+	/* first two values */
+	array[0] = 0;
+	array[1] = 1;
+	for (i = 2; i < length; i++)
+		array[i] = array[i-2] + array[i-1];
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+unsigned long long factorial(unsigned int n)
+{
+	unsigned int i;
+	unsigned long long fac = 1;
+
+	for (i = 1; i <= n; i++)
+		fac = fac * i;
+	return fac;
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+void factorial_array(unsigned int n, unsigned int *input,
+		     unsigned long long *output)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		output[i] = factorial(input[i]);
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+unsigned int do_computation(void)
+{
+	unsigned int fib_array[SEQ_LENGTH];
+	unsigned long long facfib_array[SEQ_LENGTH];
+	uint32_t fib_hash, facfib_hash;
+
+	create_fib_sequence(SEQ_LENGTH, &fib_array[0]);
+	fib_hash = hash_array(&fib_array[0], sizeof(fib_array));
+	factorial_array(SEQ_LENGTH, &fib_array[0], &facfib_array[0]);
+	facfib_hash = hash_array(&facfib_array[0], sizeof(facfib_array));
+
+	return (fib_hash ^ facfib_hash);
+}
+
+/* This provides a table of the work functions so we can flush each
+ * page individually
+ */
+static void *pages[] = {&hash_array, &create_fib_sequence, &factorial,
+			&factorial_array, &do_computation};
+
+static void do_flush(int i)
+{
+	if (flush_page)
+		flush_tlb_page((unsigned long)pages[i % ARRAY_SIZE(pages)]);
+	else
+		flush_tlb_all();
+}
+
+
+static void just_compute(void)
+{
+	int i, errors = 0;
+	int cpu = smp_processor_id();
+
+	uint32_t result;
+
+	report_info("CPU%d online", cpu);
+
+	for (i = 0 ; i < flush_count; i++) {
+		result = do_computation();
+
+		if (result != SEQ_HASH) {
+			errors++;
+			report_info("CPU%d: seq%d 0x%"PRIx32"!=0x%x",
+				    cpu, i, result, SEQ_HASH);
+		}
+
+		if (flush_verbose && (i % 1000) == 0)
+			report_info("CPU%d: seq%d", cpu, i);
+
+		if (flush_self)
+			do_flush(i);
+	}
+
+	report(errors == 0, "CPU%d: Done - Errors: %d", cpu, errors);
+
+	cpumask_set_cpu(cpu, &smp_test_complete);
+	if (cpu != 0)
+		halt();
+}
+
+static void just_flush(void)
+{
+	int cpu = smp_processor_id();
+	int i = 0;
+
+	/*
+	 * Set our CPU as done, keep flushing until everyone else
+	 * finished
+	 */
+	cpumask_set_cpu(cpu, &smp_test_complete);
+
+	while (!cpumask_full(&smp_test_complete))
+		do_flush(i++);
+
+	report_info("CPU%d: Done - Triggered %d flushes", cpu, i);
+}
+
+int main(int argc, char **argv)
+{
+	int cpu, i;
+	char prefix[100];
+
+	for (i = 0; i < argc; i++) {
+		char *arg = argv[i];
+
+		if (strcmp(arg, "page") == 0)
+			flush_page = true;
+
+		if (strcmp(arg, "self") == 0)
+			flush_self = true;
+
+		if (strcmp(arg, "verbose") == 0)
+			flush_verbose = true;
+	}
+
+	snprintf(prefix, sizeof(prefix), "tlbflush_%s_%s",
+		 flush_page ? "page" : "all",
+		 flush_self ? "self" : "other");
+	report_prefix_push(prefix);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		smp_boot_secondary(cpu, just_compute);
+	}
+
+	if (flush_self)
+		just_compute();
+	else
+		just_flush();
+
+	while (!cpumask_full(&smp_test_complete))
+		cpu_relax();
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b558..ee21aef4 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -275,3 +275,28 @@ file = debug.flat
 arch = arm64
 extra_params = -append 'ss-migration'
 groups = debug migration
+
+# TLB Torture Tests
+[tlbflush-code::all_other]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+groups = nodefault mttcg
+
+[tlbflush-code::page_other]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'page'
+groups = nodefault mttcg
+
+[tlbflush-code::all_self]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'self'
+groups = nodefault mttcg
+
+[tlbflush-code::page_self]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'page self'
+groups = nodefault mttcg
+
-- 
2.39.2

