Return-Path: <kvm+bounces-9826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FE18670FD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 312E11F2AE49
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F2F5F46C;
	Mon, 26 Feb 2024 10:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJfWJUaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B235EE89
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942447; cv=none; b=fMG/OncbSn5rKz0pai88N1qj5Lejt9qkGAo1nnYVHoh4xUU6D8eQ+v0KoEd3x7zg+l3hH9bDRbdaf94374R+FCMizWTMvu2AwR+75Ys8KXpq6GdK7XgNGmlSwsE+GFLseb1IfgLuBaRbJqYomU7TZ9irDYRpzujEADKx/euuZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942447; c=relaxed/simple;
	bh=o/91B81KXuByL/SH02TwZZ+mfmygZKKAt/SdUf8t08c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V43Xj4yq0dZtmNYNHo9JClrVRxWNmtSNzgDFjLVNdAWzX9qUtsBDFfFzYXW3PDlXKz/Q0ShDamvfyM+o7tiTw9WwBZya+V4DTkLJd8M7/QQtsyawxh7EE3BJ/NF0xKTBqJG3L0twEaFEFZ43zhNcHOXhRXXkYTKaD8tAzZT1tsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJfWJUaV; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5dca1efad59so2857661a12.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942445; x=1709547245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6pHJaaTBrGzeZZNl7/Rw9N+u8KW2C9dFJDrrfkdDXc=;
        b=aJfWJUaVIIiMPvcrwjyPFfoko2qDsi0WME/i5XI4CCLryrRzM/2hbAC6o341pqm3OD
         dW+jJOj0nCwDCR7H2i3fR4IteIVENrt7hCofZa91zzG/2/ZYZlhQcDoDb9QHClgnIUWU
         gkmOfk8JxhgLnZp3DGhJERdx6N30FXEeA4128H0JLruPdMKwcY46OPqjyv5zUI+sXJea
         sm8p1EQJgrjofp1fQljKonYf8YrXn1CkrPjdRnmLtouHQbcK44qH0kqYN9+VAxC8E9//
         /Qom2KMfuBeRcZij96FM4UFdYAGCUZF3mQCvSpaP4miFxStbyJJlChXNrgij7hK4Y4xB
         sJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942445; x=1709547245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6pHJaaTBrGzeZZNl7/Rw9N+u8KW2C9dFJDrrfkdDXc=;
        b=UOOTj9BnU74eHUlJqX4P9vJzH6qgZ6f5LARRNJsD5YT4FLiz3lv8ZMCnZcyyY04RXX
         DIcyrpepGLAEcDCyo6BMp0qrYG1c0SoD1SbsivNXmr7wOtajvSfYVIFlz3tdUa9dsXJx
         O63S+WzCECuYxkIUe+0r9WOsws6juX1ahmU1wBlch1arWNQN3APn9vVV3yReXaW9iO/N
         Se0+HIkwmlmXfAufQNk7YA9xoyAFGEL21NPPVXWt8JSd71vV5WTryiLoRhwQ0FdDqVUr
         Nt2ZviPImqlsFoPkKvKdOjgr4zJZJo3upugy04sE/zWl9GxmqKs9nQ4PgBBzZKPu0PB/
         CxBg==
X-Forwarded-Encrypted: i=1; AJvYcCWjDc5eXr6oOBk4uZs/HNlIq6S0l91rMrPMXUOnmr7W+W+pWcG3UJXUWzNpHTTj6AVlbGqecBspzrNttRSpk6+26aqT
X-Gm-Message-State: AOJu0Yxf4iJLISzFKCz4+I3ua+DkNG1SDBRpe7Gik/jP8xqZtrr/5Pp0
	ZJDX5DIQYpqCXxK3tbhNL+U9SMeWTrjaN+iVtWt2hXRMaa3zi6+h
X-Google-Smtp-Source: AGHT+IHVqx6V/WarEWxmib3Qjr8IfmZHnp3AATCdLVVs4i0jp4vT1KsyViN7rHLhDrSFHf+ZzjEFpA==
X-Received: by 2002:a05:6a20:de1b:b0:19e:aa16:2189 with SMTP id kz27-20020a056a20de1b00b0019eaa162189mr4034075pzb.42.1708942445119;
        Mon, 26 Feb 2024 02:14:05 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:04 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 22/32] powerpc: Add timebase tests
Date: Mon, 26 Feb 2024 20:12:08 +1000
Message-ID: <20240226101218.1472843-23-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has a known failure on QEMU TCG machines where the decrementer
interrupt is not lowered when the DEC wraps from -ve to +ve.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/reg.h   |   1 +
 powerpc/Makefile.common |   1 +
 powerpc/timebase.c      | 330 ++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg   |   8 +
 4 files changed, 340 insertions(+)
 create mode 100644 powerpc/timebase.c

diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
index d2ca964c4..12f9e8ac6 100644
--- a/lib/powerpc/asm/reg.h
+++ b/lib/powerpc/asm/reg.h
@@ -35,6 +35,7 @@
 #define SPR_HSRR1	0x13b
 #define SPR_LPCR	0x13e
 #define   LPCR_HDICE		UL(0x1)
+#define   LPCR_LD		UL(0x20000)
 #define SPR_HEIR	0x153
 #define SPR_MMCR0	0x31b
 #define   MMCR0_FC		UL(0x80000000)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index b6f9b3b85..1348f658b 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -15,6 +15,7 @@ tests-common = \
 	$(TEST_DIR)/tm.elf \
 	$(TEST_DIR)/smp.elf \
 	$(TEST_DIR)/sprs.elf \
+	$(TEST_DIR)/timebase.elf \
 	$(TEST_DIR)/interrupts.elf
 
 tests-all = $(tests-common) $(tests)
diff --git a/powerpc/timebase.c b/powerpc/timebase.c
new file mode 100644
index 000000000..6d8d54cb1
--- /dev/null
+++ b/powerpc/timebase.c
@@ -0,0 +1,330 @@
+/*
+ * Test Timebase
+ *
+ * Copyright 2024 Nicholas Piggin, IBM Corp.
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ *
+ * This contains tests of timebase facility, TB, DEC, etc.
+ */
+#include <libcflat.h>
+#include <util.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/handlers.h>
+#include <devicetree.h>
+#include <asm/hcall.h>
+#include <asm/processor.h>
+#include <asm/time.h>
+#include <asm/barrier.h>
+
+static int dec_bits = 0;
+
+static void cpu_dec_bits(int fdtnode, u64 regval __unused, void *arg __unused)
+{
+	const struct fdt_property *prop;
+	int plen;
+
+	prop = fdt_get_property(dt_fdt(), fdtnode, "ibm,dec-bits", &plen);
+	if (!prop) {
+		dec_bits = 32;
+		return;
+	}
+
+	/* Sanity check for the property layout (first two bytes are header) */
+	assert(plen == 4);
+
+	dec_bits = fdt32_to_cpu(*(uint32_t *)prop->data);
+}
+
+/* Check amount of CPUs nodes that have the TM flag */
+static int find_dec_bits(void)
+{
+	int ret;
+
+	ret = dt_for_each_cpu_node(cpu_dec_bits, NULL);
+	if (ret < 0)
+		return ret;
+
+	return dec_bits;
+}
+
+
+static bool do_migrate = false;
+static volatile bool got_interrupt;
+static volatile struct pt_regs recorded_regs;
+
+static uint64_t dec_max;
+static uint64_t dec_min;
+
+static void test_tb(int argc, char **argv)
+{
+	uint64_t tb;
+
+	tb = get_tb();
+	if (do_migrate)
+		migrate();
+	report(get_tb() >= tb, "timebase is incrementing");
+}
+
+static void dec_stop_handler(struct pt_regs *regs, void *data)
+{
+	mtspr(SPR_DEC, dec_max);
+}
+
+static void dec_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs->msr &= ~MSR_EE;
+}
+
+static void test_dec(int argc, char **argv)
+{
+	uint64_t tb1, tb2, dec;
+	int i;
+
+	handle_exception(0x900, &dec_handler, NULL);
+
+	for (i = 0; i < 100; i++) {
+		tb1 = get_tb();
+		mtspr(SPR_DEC, dec_max);
+		dec = mfspr(SPR_DEC);
+		tb2 = get_tb();
+		if (tb2 - tb1 < dec_max - dec)
+			break;
+	}
+	report(tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after mtDEC");
+
+	tb1 = get_tb();
+	mtspr(SPR_DEC, dec_max);
+	mdelay(1000);
+	dec = mfspr(SPR_DEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after 1s");
+
+	mtspr(SPR_DEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	if (mfspr(SPR_DEC) <= dec_max) {
+		report(!got_interrupt, "no interrupt on decrementer positive");
+	}
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, 1);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer underflow");
+	got_interrupt = false;
+
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer still underflown");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, 0);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "DEC deal with set to 0");
+	got_interrupt = false;
+
+	/* Test for level-triggered decrementer */
+	mtspr(SPR_DEC, -1ULL);
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer write MSB");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, dec_max);
+	local_irq_enable();
+	if (do_migrate)
+		migrate();
+	mtspr(SPR_DEC, -1);
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer write MSB with irqs on");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, dec_min + 1);
+	mdelay(100);
+	local_irq_enable();
+	local_irq_disable();
+	report(!got_interrupt, "no interrupt after wrap to positive");
+	got_interrupt = false;
+
+	handle_exception(0x900, NULL, NULL);
+}
+
+static void test_hdec(int argc, char **argv)
+{
+	uint64_t tb1, tb2, hdec;
+
+	if (!machine_is_powernv()) {
+		report_skip("skipping on !powernv machine");
+		return;
+	}
+
+	handle_exception(0x900, &dec_stop_handler, NULL);
+	handle_exception(0x980, &dec_handler, NULL);
+
+	mtspr(SPR_HDEC, dec_max);
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_HDICE);
+
+	tb1 = get_tb();
+	mtspr(SPR_HDEC, dec_max);
+	hdec = mfspr(SPR_HDEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - hdec, "hdecrementer remains within TB");
+
+	tb1 = get_tb();
+	mtspr(SPR_HDEC, dec_max);
+	mdelay(1000);
+	hdec = mfspr(SPR_HDEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - hdec, "hdecrementer remains within TB after 1s");
+
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	if (mfspr(SPR_HDEC) <= dec_max) {
+		report(!got_interrupt, "no interrupt on decrementer positive");
+	}
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, 1);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	/* HDEC is edge triggered so ensure it still fires */
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on hdecrementer underflow");
+	got_interrupt = false;
+
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(!got_interrupt, "no interrupt on hdecrementer still underflown");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, -1ULL);
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "no interrupt on hdecrementer underflown write MSB");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, 0);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	/* HDEC is edge triggered so ensure it still fires */
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "HDEC deal with set to 0");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	if (do_migrate)
+		migrate();
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_disable();
+	report(got_interrupt, "interrupt on hdecrementer write MSB with irqs on");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, dec_max);
+	got_interrupt = false;
+	mtspr(SPR_HDEC, dec_min + 1);
+	if (do_migrate)
+		migrate();
+	mdelay(100);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "got interrupt after wrap to positive");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_enable();
+	local_irq_disable();
+	got_interrupt = false;
+	mtspr(SPR_HDEC, dec_min + 1000000);
+	if (do_migrate)
+		migrate();
+	mdelay(100);
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "edge re-armed after wrap to positive");
+	got_interrupt = false;
+
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) & ~LPCR_HDICE);
+
+	handle_exception(0x900, NULL, NULL);
+	handle_exception(0x980, NULL, NULL);
+}
+
+struct {
+	const char *name;
+	void (*func)(int argc, char **argv);
+} hctests[] = {
+	{ "tb", test_tb },
+	{ "dec", test_dec },
+	{ "hdec", test_hdec },
+	{ NULL, NULL }
+};
+
+int main(int argc, char **argv)
+{
+	bool all;
+	int i;
+
+	all = argc == 1 || !strcmp(argv[1], "all");
+
+	for (i = 1; i < argc; i++) {
+		if (!strcmp(argv[i], "-w")) {
+			do_migrate = true;
+			if (!all && argc == 2)
+				all = true;
+		}
+	}
+
+	find_dec_bits();
+	dec_max = (1ULL << (dec_bits - 1)) - 1;
+	dec_min = (1ULL << (dec_bits - 1));
+
+	if (machine_is_powernv() && dec_bits > 32) {
+		mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_LD);
+	}
+
+	report_prefix_push("timebase");
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
+	if (machine_is_powernv() && dec_bits > 32) {
+		mtspr(SPR_LPCR, mfspr(SPR_LPCR) & ~LPCR_LD);
+	}
+
+	return report_summary();
+}
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index f8d43c220..3ebdf9dd3 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -112,6 +112,14 @@ machine = pseries
 extra_params = -append "'migration -m'"
 groups = migration
 
+[timebase]
+file = timebase.elf
+
+[timebase-icount]
+file = timebase.elf
+accel = tcg
+extra_params = -icount shift=5
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.42.0


