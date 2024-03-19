Return-Path: <kvm+bounces-12102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5366487F8BE
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C68FA1F219B6
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D067CF30;
	Tue, 19 Mar 2024 08:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idcJbEge"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4A31E536
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835284; cv=none; b=Y95rCm6q3muj3NQ0mur+ytwrm5l8aAsHzdnV2imkm5yVpEBGZTpFxe2VTkwWxMb8g0mExHGzyAnJOOSWllIuO37h2aNLCijm6gVsZfw5ECIDvSHUC2NMzT1z6CuTpWKq2hwHeafq5+Z0wMsNrH5OEqqSd1ApJOjUlHneP95V16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835284; c=relaxed/simple;
	bh=u+hJeqxQ6np/nD0NLg0dKerFiKeVuXF1i0ZM853Acw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6TE/jkasXt04tLKxJq9OYEEYZ9IUPf4qbma+GqKCkO/8BmaraNfa3p7nODM7EH2w6m2G6RmLNkrdEwzgnjaIEsN+/p4MoNtIyiW1CjVxbRX6u43grZN6qzSqbxfI76HcyIhn4WUYMec/40iqtPnMuuUBM4l3xDqLm3vFFyF6rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idcJbEge; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e6b5432439so5042121b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835281; x=1711440081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KASY5yJX/YZElgAuA5smCL49JGSesaeXw9ivSKaFgEo=;
        b=idcJbEgemrDBqM1lkeUNkbThZVBGrBOZS023Z+KlMnAA0Ktab2DnzegSjqFWEJtU41
         MBmzBu6OcSCowRFcXBV48Gf5qtxVLr/X64ct+DQOuV5APizKOjtdUqZP0iqTY8aGwAwL
         LyQ/9cxrQa+gonXE6yONh27HRwhnGLLS4bkYi0ta1CZhnkZzlajVGIRlfnT4B2WwPDnt
         eey7/JvFN48A+5+blsyj681kzFdgfKMwn19ctxZl3Mz7iczQfN/MMkte/pwerqzyLMZD
         VtBDlh6k/yDZ8dL3KXqNh2kgcwBshwCndBDUeoJkEm1NL7J9Mj6b5MEml4b4y1qvDjVH
         NGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835281; x=1711440081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KASY5yJX/YZElgAuA5smCL49JGSesaeXw9ivSKaFgEo=;
        b=mGKFgPnVOS8Ni5KbWAEL7yD5Oi5RYiUElBSDRzFH+bLOAvDDFNTUTevqLr0K2OF9XB
         3KQ93fzbZvlQYPuimg5VohWdUgeDhxhMFtCSVHmW9Y6gbGTPi5MuStghwCh/k4S/HhqQ
         UuskC56BPNDREWdVoVjWOye7aJTf/QHFDUOWcOMNhXnnLTHAmNHHoPZSMM25V+8ovEj9
         gf1BjG/zavx/y5OusKS28PnadC5ohQyritOH648uY+uYAkLKzHeuyXdL1fUMlt1bNhNN
         2KFo/MQkbXomL1wACPVoK2+Sj7SVvIHQeyrPqpcEqMmLvCzAy/rs+Br7GQV0EscVT+5c
         051A==
X-Forwarded-Encrypted: i=1; AJvYcCVgPGGbBRHwOKsV5OE+IWOPcXhIeJISXqVAhBpOK/Z4/6XPy4KozRGXJDlxawM+kFc/x3JdJC3q0i/QZgjvDcluisMM
X-Gm-Message-State: AOJu0YxRnowU4syMUMgMxViNUshxSyCooKBsvelVEk0Aey3oIlU3Hkr1
	iQjI6OHlOidI8ueaE9VBZpg3US/t73/JSt52l3a1WJZVkAsHW7k6
X-Google-Smtp-Source: AGHT+IGHBD/AyBj1T6HpHC7VcH1ci3Ci5qkdmGQasHq5ScsNDCs4FIGaxahBV7TI4fEAydcN0ZZ/DA==
X-Received: by 2002:a05:6a00:4fd5:b0:6e6:946b:a983 with SMTP id le21-20020a056a004fd500b006e6946ba983mr17989675pfb.10.1710835281431;
        Tue, 19 Mar 2024 01:01:21 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:21 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 26/35] powerpc: Add timebase tests
Date: Tue, 19 Mar 2024 17:59:17 +1000
Message-ID: <20240319075926.2422707-27-npiggin@gmail.com>
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

This has a known failure on QEMU TCG machines where the decrementer
interrupt is not lowered when the DEC wraps from -ve to +ve.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/reg.h   |   1 +
 powerpc/Makefile.common |   1 +
 powerpc/timebase.c      | 329 ++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg   |   8 +
 4 files changed, 339 insertions(+)
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
index 000000000..1908ca838
--- /dev/null
+++ b/powerpc/timebase.c
@@ -0,0 +1,329 @@
+/* SPDX-License-Identifier: LGPL-2.0-only */
+/*
+ * Test Timebase
+ *
+ * Copyright 2024 Nicholas Piggin, IBM Corp.
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
index 803a636cb..0be787f67 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -97,6 +97,14 @@ machine = pseries
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


