Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04794662D8
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357491AbhLBL52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357464AbhLBL50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 06:57:26 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEA8C061757
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 03:54:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n33-20020a05600c502100b0032fb900951eso2078526wmr.4
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 03:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YvIcgLxrIDvH3u3VEeMqsMbudoeAwAVc7Uo9Je5NGBY=;
        b=pSIzMsaslA9EVJaNgs3xMkTko2prnzFfJrTevKg9mX+roOdF4fP23gzHkQ7VCvZ1g0
         oXNEXmhJubYKXuBnlwEy9cd52uqnFBx/25KkRfIJR5l0JZRphzKsuCbdFWZcoNfMzUy+
         CO3dnMWYWkSIVVgH9k752Npsn0zGo4GpbsD+WvWEu55Zt2TWrDSqx9ameh7tEUfyWwgl
         YpFEtLFr9eCVF8AETZ/3Bxe+OC3+Jd7X+Sz1mRRZKZHLrkbWghexJcz6gmLw10nfcZee
         3PBb0KzQE0DyI2EwZ6neSRND9T+8PNb2i6npDxjbspj19dB7rzjnhVyv/F4WhJ/QF1Y8
         XYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YvIcgLxrIDvH3u3VEeMqsMbudoeAwAVc7Uo9Je5NGBY=;
        b=MR1paeXMnj4xIvCeUXh/WflBk38LR5NotIw/ly5KbO4t0pP0HNk7/mOB0fCeEckmN3
         uQs7bkj0IbmQKGyFEAWLiX1tilFvRVKtKfsyIJkuuwN6sSefOcSi7ecHi63PMM17ApY3
         9FeQRHMsUiTKikJ9RHOkt+KYquRlbCBgPp8Uc+iP+MNAuleMTf2V0zqhvzTfyOZq9Wxz
         /PUyhseRJB+HOcEupwpKhwglsDBbkJaE3wdB1bKU5Wh5phhWPtygP8arDwlAFokti6n3
         6Xg4V5tOwmIVDAwe+ReMxaVny7gBjXs7DfHo+DxibQqrhvToqVnzmiqOnGAPZyJDQBjE
         lTzw==
X-Gm-Message-State: AOAM531xYqd0ijVFll9A6fxXDNgYGotmsodzEFavQlewxrWm3d2BBOZ7
        GPSHM7Y7MmuPVjQmL/TLgXa3F5Rcw32Xgw==
X-Google-Smtp-Source: ABdhPJwWre1np96zYEEAG1G85CB6tdS9Z4+KdP/oDY6HW2w48L0J621+a9wJdSQ0VjBOVUC06fo7UA==
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr5860807wmq.68.1638446042164;
        Thu, 02 Dec 2021 03:54:02 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id n32sm2101850wms.1.2021.12.02.03.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 03:53:59 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id CA4531FF9C;
        Thu,  2 Dec 2021 11:53:52 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [kvm-unit-tests PATCH v9 5/9] arm/tlbflush-code: TLB flush during code execution
Date:   Thu,  2 Dec 2021 11:53:48 +0000
Message-Id: <20211202115352.951548-6-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211202115352.951548-1-alex.bennee@linaro.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 99bcf3fc..e3f04f2d 100644
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
index 945c2d07..34c8a95b 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -241,3 +241,28 @@ arch = arm64
 file = cache.flat
 arch = arm64
 groups = cache
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
2.30.2

