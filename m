Return-Path: <kvm+bounces-12101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C158C87F8BC
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7253D2829FE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FE364CF7;
	Tue, 19 Mar 2024 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EejKrJ8/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816B31E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835280; cv=none; b=UkGcoykMtFE5xuV5z1cNvNQ0sUoWFYmwFcsWU+UAojWk1lqC1EygttO7saNcQJzSsET0pS1rHc7m/4EsYWfVF8ufpKHMXUSc8zMTkMK9QJVVSbBJMBnNdP+CTllWNocPFl4e8ltDR6koTpO27dSgKDy+jXlwaqdY3LILtv6OYz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835280; c=relaxed/simple;
	bh=yQKonh9MN9iqeUoktXbZy+IAddR5THJWdeUPvqVih3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuO9IcljVNrHDLMfZ2Nf70gPIsU2uWFX2L0g5WV3ERuKyDjtsiAMjCWNfwFRAu/cr04GMNsz7xiVcAuQgVLTn2YgSbe4hKIctxJRe7RQvTFeLEuFjU5uiyQq6Mxx82lBP/orr9DmlyH/dDxrr7zrTAAdlRzYkIoKcTngz+GYKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EejKrJ8/; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso3054698b3a.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835278; x=1711440078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKEBox+vdt7TX5zGaH92d+WWNZbgSBw4KxF++MKBLcs=;
        b=EejKrJ8/9ZWM4aArWJokeABfQ1BA9IQ1aHmK+0HqcxGrhiit3cqN5Q4ERIcKqKVxYT
         jFE7QNQwlMteNJqYyXTgh8q/AhWrvTObJuaxiR8D9K29eSTj8eIAJzfzmEsQy9GMzLoF
         F6pl/9cwGpqQdLuHepZC7JsxvEHuoqFE8P2wIIjxFhXRjhBNEJz0Y2U9aCSk73gOlhNX
         rkQRpIEvmeLiI6HfDNUUdxvOYI7OvvZD9ucgqcHiaPcX1CHV3tiGUgXaE/EU04jF7eWR
         eR0fDjpOcEfD3FPfWwe93BqtQmoOmhlnX1t2mgO0kjGuDzbPJapSgi1BYPJgIC43Au9h
         mJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835278; x=1711440078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EKEBox+vdt7TX5zGaH92d+WWNZbgSBw4KxF++MKBLcs=;
        b=EayVoGTKodDenkz3lkRhY2ycP7wpSqa60AZXvbjog4wbbajp0Qs9q7eUgUD5ujBIOH
         A6hRiB3qeD3NvsTHhCnte3SZd5N+/A6+fRPKwOnDviV0tWbJdpaDSDz+5OagEeI3rHwg
         nF3TTzsYNwrEzPLYv/KXhmHdnrpTQU6lAT/ZT70NyHQggVOgkoVOr0YSrU1Sotj+tbKI
         ERgDmV2p9oiPoumZT2in+08NEmNfiqd2yQP4C8WU2yDnAGmPlf6fSXjA+op+otjoDxeb
         KNXraCrh6e6jAIg9gpWGyX9q+OXxW0I5O7IJbajt6fuKGD4rutShsV2+wdenHRGWmxqe
         1zCA==
X-Forwarded-Encrypted: i=1; AJvYcCXgLYayjpp5GgGeTGyl69onwRhImXqr9mO3Q2+O1t6JBUuY0WM4U59UiXpNvgxWlyUp5wzNvocrzz2+DUk0KGqmd3oF
X-Gm-Message-State: AOJu0Yw/rkuN7/m+oF1YRfl077GFK9cAMJBc6HPWSU52yJMao2w7ifR4
	oFD92Aff3uoPfOPU/qa/EYAlcG+8tA7PeFGGO6zO4XqCA7BljU5XIKSA7EbX3mY=
X-Google-Smtp-Source: AGHT+IETtMoSfTs/sCtASEGTW8OsW81ComWtRGXeNLihqpIqSFxLmEv5BeRairFKKzRsTA71IzZfRw==
X-Received: by 2002:aa7:88cf:0:b0:6e7:2154:72ec with SMTP id k15-20020aa788cf000000b006e7215472ecmr2191188pff.17.1710835277711;
        Tue, 19 Mar 2024 01:01:17 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:17 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 25/35] powerpc: Add atomics tests
Date: Tue, 19 Mar 2024 17:59:16 +1000
Message-ID: <20240319075926.2422707-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/Makefile.common |   1 +
 powerpc/atomics.c       | 374 ++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg   |   9 +
 3 files changed, 384 insertions(+)
 create mode 100644 powerpc/atomics.c

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 02af54b83..b6f9b3b85 100644
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
index 000000000..c3d1cef52
--- /dev/null
+++ b/powerpc/atomics.c
@@ -0,0 +1,374 @@
+/* SPDX-License-Identifier: LGPL-2.0-only */
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
+	report(old == 10 && got_interrupt && recorded_regs.trap == 0x600, "unaligned lwarx causes fault");
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
+		      : "=&r"(old) : "r"(1), "r"(var), "r"((char *)var+1) : "cr0", "memory");
+	report(old == 0 && *var == 0 && got_interrupt && recorded_regs.trap == 0x600, "unaligned stwcx. causes fault");
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
+			"simple update");
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
+			"failed stqcx. (no reservation)");
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
+	report(true, "atomic add takes %ldns", (tb2 - tb1) * 1000000000 / ITERS / tb_hz);
+
+	tb1 = get_tb();
+	for (i = 0; i < ITERS; i++)
+		__atomic_fetch_add(&test_counter, 1, __ATOMIC_SEQ_CST);
+	tb2 = get_tb();
+	report(true, "sequentially conssistent atomic add takes %ldns", (tb2 - tb1) * 1000000000 / ITERS / tb_hz);
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
+	report(smp_inc_counter == nr_cpus_present * ITERS, "counter lost no increments");
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
+	report(smp_lock_counter == nr_cpus_present * ITERS, "counter lost no increments");
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
index 71bfc935d..803a636cb 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -88,6 +88,15 @@ file = smp.elf
 smp = 8,threads=4
 accel = tcg,thread=single
 
+[atomics]
+file = atomics.elf
+
+[atomics-migration]
+file = atomics.elf
+machine = pseries
+extra_params = -append "'migration -m'"
+groups = migration
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.42.0


