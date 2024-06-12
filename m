Return-Path: <kvm+bounces-19396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81448904AC9
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:23:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5585DB224CC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F74381D9;
	Wed, 12 Jun 2024 05:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQwl4idk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287B381D1
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169820; cv=none; b=VSFghVtQ9mqmBBbO0rRJ6Pkd0lY47qhqWx6amWUAQsczE50jn8QXZ3gbVPJ0nhGW56uTgZ7KjxU3Qz+AZd55xTghxSRzzHxW+z2XmaUOcGURCswQ90sULYCTaQX31EreUmLQrtb3RcmKpxaLgZvx8nJoHhtyUFLoGnkLMjZJldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169820; c=relaxed/simple;
	bh=+ScCurVEWUKotJeooFkjjvzfCuuU2ogVvfsP+wsN+w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GziWpHw6BIDeAL6zHCWI8sGTZdO1z8mLCvTz9e7wBwg9DP2MXcReBKNWgRZKBqWQkScplDndSWyrT8xyeZ/q980nY4hs889cwtxytAmZWOCSLmmJ3Zev7zXHLrhlk+9KR2MRTANixBYBG6nzZ10ld9Q5lfYpCGVNBqJ2RO3wOX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQwl4idk; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f70131063cso15954985ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169818; x=1718774618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6o6vcMPhrMsQvHR0Sulq6bI+NxqfPhtmmQVrS2XJ3c=;
        b=lQwl4idkhEezbV01rFxypUcarkZ81Jp4wYV0LievfDUEn5fNAsBCexGAz/ki1Xb6Ej
         K/yRxvfBAcFy/qjVJ4O51sA735MsEN1+87an29v1p0hxy2368q6Iy4J0JRPHxtEgLeIN
         PtaxI/DlgU9lGutf5goccg0k3ZkhycRHJpKMeUhIeW8Z9eP7AebxSpRicX2ZreTNblCZ
         0o5YOwOpkEzcpRbrwrh/TB0p+dzCUzukYY7EiNDgpoX3lGsgvG/I5tJWEKi0oQ+NlMQO
         iJGJGKbFgBYH1BJrEovBoZQROmaoKrftAuxzeTSwnmoxo5qw/h4lIMaJsjfcsT+OZYDS
         M+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169818; x=1718774618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6o6vcMPhrMsQvHR0Sulq6bI+NxqfPhtmmQVrS2XJ3c=;
        b=SlvSAPDhiy28pTOg5PchJX1zuiNn67zt+Dnd3rImo1hHxYU9yANgj5kybKKQbndBWs
         1Ak8Qx2gkkFnbYwT1jvQM4wOBebcHLGI/ksusp2ZVs48oEBV95VocMXhN10OY37PVK57
         xQulBMSdQ3YtWjWcfcizCqD/lUUE2woKjfX5auq7h+s+7SGjmgCkp8YbUH/0ck7iCUli
         iqXGY0vn1pqohRtYx1f7fYvn36iXN/17/8sHKibrfA8/0ajBFyrKQBztG7vukOiz0C4R
         nDz8i+LyYJeCdf6TfA7AUiUTZdleW5DWY6n48GObD5CNH1bqJjP7XzlFgFiyDBSffyb/
         rVvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiCxcFUr33j5FC7drtRQPDWhGYt/vQLd4It8/eIHNV1FRP7nUSK6XstI30Vc5vQTW/WI5bzAnqWGdfmWYjNgA2e0BG
X-Gm-Message-State: AOJu0Yx3wEdMQPp06A4fsN0HPPJSHK2jSIhQjSmLpkho5MaTm5rYIIrj
	uMGQtzdC+3ZY8VtXCk/zuUJ/cmz8NGYyhvlhHtrK6KFlhGnUB05Q
X-Google-Smtp-Source: AGHT+IG5VgiIxFWxzOA75TpFCafQj3g9NocE+hXCOTXILYOOMpRJ+OKI0SRDda6pn31WxBLaFGBXiA==
X-Received: by 2002:a17:902:654e:b0:1f7:1a9:bf0c with SMTP id d9443c01a7336-1f83b713856mr7027815ad.52.1718169817948;
        Tue, 11 Jun 2024 22:23:37 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:37 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 02/15] powerpc: Add atomics tests
Date: Wed, 12 Jun 2024 15:23:07 +1000
Message-ID: <20240612052322.218726-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some tests for larx/stcx. operations for certain edge cases including
migration, as well as some simple performance tests.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common |   1 +
 powerpc/atomics.c       | 386 ++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg   |  10 ++
 3 files changed, 397 insertions(+)
 create mode 100644 powerpc/atomics.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 16f14577e..b52037c0d 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -11,6 +11,7 @@ tests-common = \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
+	$(TEST_DIR)/atomics.elf \
 	$(TEST_DIR)/tm.elf \
 	$(TEST_DIR)/smp.elf \
 	$(TEST_DIR)/sprs.elf \
diff --git a/powerpc/atomics.c b/powerpc/atomics.c
new file mode 100644
index 000000000..abbfff4b4
--- /dev/null
+++ b/powerpc/atomics.c
@@ -0,0 +1,386 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test some powerpc instructions
+ *
+ * Copyright 2024 Nicholas Piggin, IBM Corp.
+ */
+#include <stdint.h>
+#include <libcflat.h>
+#include <migrate.h>
+#include <asm/processor.h>
+#include <asm/time.h>
+#include <asm/atomic.h>
+#include <asm/setup.h>
+#include <asm/barrier.h>
+#include <asm/smp.h>
+
+static bool do_migrate;
+static bool do_record;
+
+#define RSV_SIZE 128
+
+static uint8_t granule[RSV_SIZE] __attribute((__aligned__(RSV_SIZE)));
+
+static void spin_lock(unsigned int *lock)
+{
+	unsigned int old;
+
+	asm volatile ("1:"
+		      "lwarx	%0,0,%2;"
+		      "cmpwi	%0,0;"
+		      "bne	1b;"
+		      "stwcx.	%1,0,%2;"
+		      "bne-	1b;"
+		      "lwsync;"
+		      : "=&r"(old) : "r"(1), "r"(lock) : "cr0", "memory");
+}
+
+static void spin_unlock(unsigned int *lock)
+{
+	asm volatile("lwsync;"
+		     "stw	%1,%0;"
+		     : "+m"(*lock) : "r"(0) : "memory");
+}
+
+static volatile bool got_interrupt;
+static volatile struct pt_regs recorded_regs;
+
+static void interrupt_handler(struct pt_regs *regs, void *opaque)
+{
+	assert(!got_interrupt);
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs_advance_insn(regs);
+}
+
+static void test_lwarx_stwcx(int argc, char *argv[])
+{
+	unsigned int *var = (unsigned int *)granule;
+	unsigned int old;
+	unsigned int result;
+
+	*var = 0;
+	asm volatile ("1:"
+		      "lwarx	%0,0,%2;"
+		      "stwcx.	%1,0,%2;"
+		      "bne-	1b;"
+		      : "=&r"(old) : "r"(1), "r"(var) : "cr0", "memory");
+	report(old == 0 && *var == 1, "simple update");
+
+	*var = 0;
+	asm volatile ("li	%0,0;"
+		      "stwcx.	%1,0,%2;"
+		      "stwcx.	%1,0,%2;"
+		      "bne-	1f;"
+		      "li	%0,1;"
+		      "1:"
+		      : "=&r"(result)
+		      : "r"(1), "r"(var) : "cr0", "memory");
+	report(result == 0 && *var == 0, "failed stwcx. (no reservation)");
+
+	*var = 0;
+	asm volatile ("li	%0,0;"
+		      "lwarx	%1,0,%4;"
+		      "stw	%3,0(%4);"
+		      "stwcx.	%2,0,%4;"
+		      "bne-	1f;"
+		      "li	%0,1;"
+		      "1:"
+		      : "=&r"(result), "=&r"(old)
+		      : "r"(1), "r"(2), "r"(var) : "cr0", "memory");
+	/* This is implementation specific, so don't fail */
+	if (result == 0 && *var == 2)
+		report(true, "failed stwcx. (intervening store)");
+	else
+		report(true, "succeeded stwcx. (intervening store)");
+
+	handle_exception(0x600, interrupt_handler, NULL);
+	handle_exception(0x700, interrupt_handler, NULL);
+
+	/* Implementations may not necessarily invoke the alignment interrupt */
+	old = 10;
+	*var = 0;
+	asm volatile (
+		      "lwarx	%0,0,%1;"
+		      : "+&r"(old) : "r"((char *)var + 1));
+	report(old == 10 && got_interrupt && recorded_regs.trap == 0x600,
+	       "unaligned lwarx causes fault");
+	got_interrupt = false;
+
+	/*
+	 * Unaligned stwcx. is more difficult to test, at least under QEMU,
+	 * the store does not proceed if there is no matching reservation, so
+	 * the alignment handler does not get invoked. This is okay according
+	 * to the Power ISA (unalignment does not necessarily invoke the
+	 * alignment interrupt). But POWER CPUs do cause alignment interrupt.
+	 */
+	*var = 0;
+	asm volatile (
+		      "lwarx	%0,0,%2;"
+		      "stwcx.	%1,0,%3;"
+		      : "=&r"(old) : "r"(1), "r"(var), "r"((char *)var+1)
+		      : "cr0", "memory");
+	/*
+	 * An unaligned larx/stcx. is not required by the ISA to cause an
+	 * exception, and in TCG the stcx does not though it does on POWER CPUs.
+	 */
+	report_kfail(host_is_tcg, old == 0 && *var == 0 &&
+				  got_interrupt && recorded_regs.trap == 0x600,
+		     "unaligned stwcx. causes fault");
+	got_interrupt = false;
+
+	handle_exception(0x600, NULL, NULL);
+
+}
+
+static void test_lqarx_stqcx(int argc, char *argv[])
+{
+	union {
+		__int128_t var;
+		struct {
+#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+			unsigned long var1;
+			unsigned long var2;
+#else
+			unsigned long var2;
+			unsigned long var1;
+#endif
+		};
+	} var __attribute__((aligned(16)));
+	register unsigned long new1 asm("r8");
+	register unsigned long new2 asm("r9");
+	register unsigned long old1 asm("r10");
+	register unsigned long old2 asm("r11");
+	unsigned int result;
+
+	var.var1 = 1;
+	var.var2 = 2;
+
+	(void)new2;
+	(void)old2;
+
+	old1 = 0;
+	old2 = 0;
+	new1 = 3;
+	new2 = 4;
+	asm volatile ("1:"
+		      "lqarx	%0,0,%4;"
+		      "stqcx.	%2,0,%4;"
+		      "bne-	1b;"
+		      : "=&r"(old1), "=&r"(old2)
+		      : "r"(new1), "r"(new2), "r"(&var)
+		      : "cr0", "memory");
+
+	report(old1 == 2 && old2 == 1 && var.var1 == 4 && var.var2 == 3,
+	       "simple update");
+
+	var.var1 = 1;
+	var.var2 = 2;
+	new1 = 3;
+	new2 = 4;
+	asm volatile ("li	%0,0;"
+		      "stqcx.	%1,0,%3;"
+		      "stqcx.	%1,0,%3;"
+		      "bne-	1f;"
+		      "li	%0,1;"
+		      "1:"
+		      : "=&r"(result)
+		      : "r"(new1), "r"(new2), "r"(&var)
+		      : "cr0", "memory");
+	report(result == 0 && var.var1 == 1 && var.var2 == 2,
+	       "failed stqcx. (no reservation)");
+
+	var.var1 = 1;
+	var.var2 = 2;
+	new1 = 3;
+	new2 = 4;
+	asm volatile ("li	%0,0;"
+		      "lqarx	%1,0,%6;"
+		      "std	%5,0(%6);"
+		      "stqcx.	%3,0,%6;"
+		      "bne-	1f;"
+		      "li	%0,1;"
+		      "1:"
+		      : "=&r"(result), "=&r"(old1), "=&r"(old2)
+		      : "r"(new1), "r"(new2), "r"(0), "r"(&var)
+		      : "cr0", "memory");
+	/* This is implementation specific, so don't fail */
+	if (result == 0 && (var.var1 == 0 || var.var2 == 0))
+		report(true, "failed stqcx. (intervening store)");
+	else
+		report(true, "succeeded stqcx. (intervening store)");
+}
+
+static void test_migrate_reserve(int argc, char *argv[])
+{
+	unsigned int *var = (unsigned int *)granule;
+	unsigned int old;
+	int i;
+	int succeed = 0;
+
+	if (!do_migrate)
+		return;
+
+	for (i = 0; i < 10; i++) {
+		*var = 0x12345;
+		asm volatile ("lwarx	%0,0,%1" : "=&r"(old) : "r"(var) : "memory");
+		migrate_quiet();
+		asm volatile ("stwcx.	%0,0,%1" : : "r"(0xf00d), "r"(var) : "cr0", "memory");
+		if (*var == 0xf00d)
+			succeed++;
+	}
+
+	if (do_record) {
+		/*
+		 * Running under TCG record-replay, reservations must not
+		 * be lost by migration
+		 */
+		report(succeed > 0, "migrated reservation is not lost");
+	} else {
+		report(succeed == 0, "migrated reservation is lost");
+	}
+
+	report_prefix_pop();
+}
+
+#define ITERS 10000000
+static int test_counter = 0;
+static void test_inc_perf(int argc, char *argv[])
+{
+	int i;
+	uint64_t tb1, tb2;
+
+	tb1 = get_tb();
+	for (i = 0; i < ITERS; i++)
+		__atomic_fetch_add(&test_counter, 1, __ATOMIC_RELAXED);
+	tb2 = get_tb();
+	report(true, "atomic add takes %ldns",
+		    (tb2 - tb1) * 1000000000 / ITERS / tb_hz);
+
+	tb1 = get_tb();
+	for (i = 0; i < ITERS; i++)
+		__atomic_fetch_add(&test_counter, 1, __ATOMIC_SEQ_CST);
+	tb2 = get_tb();
+	report(true, "sequentially conssistent atomic add takes %ldns",
+	       (tb2 - tb1) * 1000000000 / ITERS / tb_hz);
+}
+
+static long smp_inc_counter = 0;
+static int smp_inc_started;
+
+static void smp_inc_fn(int cpu_id)
+{
+	long i;
+
+	atomic_fetch_inc(&smp_inc_started);
+	while (smp_inc_started < nr_cpus_present)
+		cpu_relax();
+
+	for (i = 0; i < ITERS; i++)
+		atomic_fetch_inc(&smp_inc_counter);
+	atomic_fetch_dec(&smp_inc_started);
+}
+
+static void test_smp_inc(int argc, char **argv)
+{
+	if (nr_cpus_present < 2)
+		return;
+
+	if (!start_all_cpus(smp_inc_fn))
+		report_abort("Failed to start secondary cpus");
+
+	while (smp_inc_started < nr_cpus_present - 1)
+		cpu_relax();
+	smp_inc_fn(smp_processor_id());
+	while (smp_inc_started > 0)
+		cpu_relax();
+
+	stop_all_cpus();
+
+	report(smp_inc_counter == nr_cpus_present * ITERS,
+	       "counter lost no increments");
+}
+
+static long smp_lock_counter __attribute__((aligned(128))) = 0;
+static unsigned int smp_lock __attribute__((aligned(128)));
+static int smp_lock_started;
+
+static void smp_lock_fn(int cpu_id)
+{
+	long i;
+
+	atomic_fetch_inc(&smp_lock_started);
+	while (smp_lock_started < nr_cpus_present)
+		cpu_relax();
+
+	for (i = 0; i < ITERS; i++) {
+		spin_lock(&smp_lock);
+		smp_lock_counter++;
+		spin_unlock(&smp_lock);
+	}
+	atomic_fetch_dec(&smp_lock_started);
+}
+
+static void test_smp_lock(int argc, char **argv)
+{
+	if (nr_cpus_present < 2)
+		return;
+
+	if (!start_all_cpus(smp_lock_fn))
+		report_abort("Failed to start secondary cpus");
+
+	while (smp_lock_started < nr_cpus_present - 1)
+		cpu_relax();
+	smp_lock_fn(smp_processor_id());
+	while (smp_lock_started > 0)
+		cpu_relax();
+
+	stop_all_cpus();
+
+	report(smp_lock_counter == nr_cpus_present * ITERS,
+	       "counter lost no increments");
+}
+
+struct {
+	const char *name;
+	void (*func)(int argc, char **argv);
+} hctests[] = {
+	{ "lwarx/stwcx", test_lwarx_stwcx },
+	{ "lqarx/stqcx", test_lqarx_stqcx },
+	{ "migration", test_migrate_reserve },
+	{ "performance", test_inc_perf },
+	{ "SMP-atomic", test_smp_inc },
+	{ "SMP-lock", test_smp_lock },
+	{ NULL, NULL }
+};
+
+int main(int argc, char **argv)
+{
+	int i;
+	int all;
+
+	all = argc == 1 || !strcmp(argv[1], "all");
+
+	for (i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "-r") == 0) {
+			do_record = true;
+		}
+		if (strcmp(argv[i], "-m") == 0) {
+			do_migrate = true;
+		}
+	}
+
+	report_prefix_push("atomics");
+
+	for (i = 0; hctests[i].name != NULL; i++) {
+		if (all || strcmp(argv[1], hctests[i].name) == 0) {
+			report_prefix_push(hctests[i].name);
+			hctests[i].func(argc, argv);
+			report_prefix_pop();
+		}
+	}
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 5c458996b..407090ac4 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -83,6 +83,16 @@ file = smp.elf
 smp = 8,threads=4
 accel = tcg,thread=single
 
+[atomics]
+file = atomics.elf
+smp = 2
+
+[atomics-migration]
+file = atomics.elf
+machine = pseries
+extra_params = -append "migration -m"
+groups = migration
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.45.1


