Return-Path: <kvm+bounces-32428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A285F9D84E4
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 278CF162A3C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D5B1A3042;
	Mon, 25 Nov 2024 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kXXL21rU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873FF156F5D
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535753; cv=none; b=fKpu442wpXw4+cDNGMBFZu6KDuT6uwVpyJYqb9QsBlaaSQs5otM86q0CNxiUPCOYcUnlTlvYQd4EDy+HG2OoW8Kx64AY6PxjMJZV6wQVmZGRLMOqSYXgiJkzAHEVgdyE/hhok0yXypBqFthPtO+QvBcesEFJ47gJv+Y9tCYu4FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535753; c=relaxed/simple;
	bh=URCmWT6V/SgxfPPesAxj7WRe0RcHm6WUOh7lRvPaVjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kpkq3s/dthtEh3ZDxhgztjN+eJlQG2oZLK4+eoe7L7/P3jofQlcavHPqljnbPB342w0C8Bf/oxXZRZdIKLZBRFpMLLOGoUx320SfEoRxUu6lsSony0YmPQbxwbNHoPDatyjsI3XzxCN1HqKmLVjJmZwO78lfFLIyYSiobAtvcFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kXXL21rU; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43152b79d25so39620045e9.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732535748; x=1733140548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UcHnBisRSnbeh0MNtChNkmdWv3LXfdzUaFxzsJImrRs=;
        b=kXXL21rUfE9rjBbuYTIAq5lRVa53YpmIJBZA77tDOe/4d11CGpeJMq2lCUKmPAAu1I
         R6rpmd75iI0vXkf3rhsEYelqrir4a1Q9hTCVnQ+n/8urB21fdMHxX7laFSUuUP3Mpyj3
         92INzMlEe4jgXr8KMP+ASMbyDAqIXcTZauqxm7lnXMeb1uYp9z3F3TgqTQGJENcEZl7F
         KlYjkbIK9S2i7lzf/bFlaEUVWJ7oTH8OQ7V3GEouqD0DuEgwM3dKfpoE8/VOYWmhDLne
         rR7YmahALoNo6H9zOE5H2Zk+0Oik4wyHsF0qhxM+en0aNifsKm1BiLDoE/7UPJeAhQ2B
         Cf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535748; x=1733140548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UcHnBisRSnbeh0MNtChNkmdWv3LXfdzUaFxzsJImrRs=;
        b=MefRKJaJVEIAfnPt9pWWXdO2jDBof3CmniYyjUY273DmP2tMKeKbWFJUkYPkeXvWBe
         6yPhtNB7qp57EBBD+irmi4qhJyl/Rj3HWdHVLhZ4cj7pMMj2l+jAVZ7JrVFQKpMjOkHD
         1o+T71CwLx6S356xBQOHJidRcwP/jV6wWv/3z5SvtupDJpKd1NJm5v1GC2rHofR+OAs1
         9B+FBwdyvy88pXTqljIwWQcMK7MxHYXrsYzTB3uOTTHt6DSW8bq8sYxSabYX8yKXwoCK
         7Ljfl00mFp+aoLX/BbpnF5PCOzp/WaqtoJ1BSSWtDWKezgOgRzbObgI4i/puKnIKT1lk
         Nq5w==
X-Gm-Message-State: AOJu0Yy4HYWhFTwqS09zTWmFAh/kCDaEqGGa6yRhi/iRZIwO5UlQSNzj
	MOAzuD45MB645Zl0buVTKOtw79E12jDPGx/8C6gAcp79Wp6H2sT4Rv5eFThlWjhSCPnwo+NxUaI
	t
X-Gm-Gg: ASbGncuz+j8Ue+X6w6uzK7vN52G/GUjQvBVuRYfasLrtwHQXsaVdlw5Jb8z75mPfaBU
	ZUWfu4UxSEdUjhbetdHLosKw6mGKPl7L0SjK6sGeWYObzMGxR/OUG25vgaNxyj/s1/S1hnnF3ue
	btkTiCziKMZqO3gxzT+Zajm2NP9PiJliFAfkdAfvbI+zyn5BaJbG/Vs/2WY3iKIqVeem7U5WF32
	Mi7XJScVOJ0InjUTZvYVmwHIuQCNgJrvB+c/Uvl1gAB6gK7H/w=
X-Google-Smtp-Source: AGHT+IF0v9FOftGeJyHcaQZyg+UXiEAL6ZiAuZxz1XCgp2rsKA1pMpKsxRCpxiA14xKc9N+FZBgMhw==
X-Received: by 2002:a5d:6d0d:0:b0:382:496e:87a3 with SMTP id ffacd0b85a97d-38260b5b76dmr11476661f8f.15.1732535748432;
        Mon, 25 Nov 2024 03:55:48 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3dfasm10546938f8f.76.2024.11.25.03.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 03:55:47 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 4/4] riscv: sbi: Add SSE extension tests
Date: Mon, 25 Nov 2024 12:54:48 +0100
Message-ID: <20241125115452.1255745-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115452.1255745-1-cleger@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add SBI SSE extension tests for the following features:
- Test attributes errors (invalid values, RO, etc)
- Registration errors
- Simple events (register, enable, inject)
- Events with different priorities
- Global events dispatch on different harts
- Local events on all harts

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile      |    2 +-
 lib/riscv/asm/csr.h |    2 +
 riscv/sbi-sse.c     | 1043 +++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |    3 +
 4 files changed, 1049 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi-sse.c

diff --git a/riscv/Makefile b/riscv/Makefile
index c278ec5c..81b75ad5 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -17,7 +17,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
+$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-sse.o
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 16f5ddd7..06831380 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -21,6 +21,8 @@
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
 
+#define SSTATUS_SPP		_AC(0x00000100, UL) /* Previously Supervisor */
+
 /* Exception causes */
 #define EXC_INST_MISALIGNED	0
 #define EXC_INST_ACCESS		1
diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
new file mode 100644
index 00000000..a230c600
--- /dev/null
+++ b/riscv/sbi-sse.c
@@ -0,0 +1,1043 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI SSE testsuite
+ *
+ * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <alloc.h>
+#include <alloc_page.h>
+#include <bitops.h>
+#include <cpumask.h>
+#include <libcflat.h>
+#include <on-cpus.h>
+
+#include <asm/barrier.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/sbi.h>
+#include <asm/setup.h>
+#include <asm/sse.h>
+
+#include "sbi-tests.h"
+
+#define SSE_STACK_SIZE	PAGE_SIZE
+
+void check_sse(void);
+
+struct sse_event_info {
+	unsigned long event_id;
+	const char *name;
+	bool can_inject;
+};
+
+static struct sse_event_info sse_event_infos[] = {
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_RAS,
+		.name = "local_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP,
+		.name = "double_trap",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_RAS,
+		.name = "global_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_PMU,
+		.name = "local_pmu",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,
+		.name = "local_software",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,
+		.name = "global_software",
+	},
+};
+
+static const char *const attr_names[] = {
+	[SBI_SSE_ATTR_STATUS] = "status",
+	[SBI_SSE_ATTR_PRIORITY] = "prio",
+	[SBI_SSE_ATTR_CONFIG] = "config",
+	[SBI_SSE_ATTR_PREFERRED_HART] = "preferred_hart",
+	[SBI_SSE_ATTR_ENTRY_PC] = "entry_pc",
+	[SBI_SSE_ATTR_ENTRY_ARG] = "entry_arg",
+	[SBI_SSE_ATTR_INTERRUPTED_SEPC] = "interrupted_pc",
+	[SBI_SSE_ATTR_INTERRUPTED_FLAGS] = "interrupted_flags",
+	[SBI_SSE_ATTR_INTERRUPTED_A6] = "interrupted_a6",
+	[SBI_SSE_ATTR_INTERRUPTED_A7] = "interrupted_a7",
+};
+
+static const unsigned long ro_attrs[] = {
+	SBI_SSE_ATTR_STATUS,
+	SBI_SSE_ATTR_ENTRY_PC,
+	SBI_SSE_ATTR_ENTRY_ARG,
+};
+
+static const unsigned long interrupted_attrs[] = {
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS,
+	SBI_SSE_ATTR_INTERRUPTED_SEPC,
+	SBI_SSE_ATTR_INTERRUPTED_A6,
+	SBI_SSE_ATTR_INTERRUPTED_A7,
+};
+
+static const unsigned long interrupted_flags[] = {
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP,
+};
+
+static struct sse_event_info *sse_evt_get_infos(unsigned long event_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		if (sse_event_infos[i].event_id == event_id)
+			return &sse_event_infos[i];
+	}
+
+	assert_msg(false, "Invalid event id: %ld", event_id);
+}
+
+static const char *sse_evt_name(unsigned long event_id)
+{
+	struct sse_event_info *infos = sse_evt_get_infos(event_id);
+
+	return infos->name;
+}
+
+static bool sse_evt_can_inject(unsigned long event_id)
+{
+	struct sse_event_info *infos = sse_evt_get_infos(event_id);
+
+	return infos->can_inject;
+}
+
+static bool sse_event_is_global(unsigned long event_id)
+{
+	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
+}
+
+static struct sbiret sse_event_get_attr_raw(unsigned long event_id,
+					    unsigned long base_attr_id,
+					    unsigned long attr_count,
+					    unsigned long phys_lo,
+					    unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id,
+			base_attr_id, attr_count, phys_lo, phys_hi, 0);
+}
+
+static unsigned long sse_event_get_attrs(unsigned long event_id, unsigned long attr_id,
+					 unsigned long *values, unsigned int attr_count)
+{
+	struct sbiret ret;
+
+	ret = sse_event_get_attr_raw(event_id, attr_id, attr_count, (unsigned long)values, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_get_attr(unsigned long event_id, unsigned long attr_id,
+					unsigned long *value)
+{
+	return sse_event_get_attrs(event_id, attr_id, value, 1);
+}
+
+static struct sbiret sse_event_set_attr_raw(unsigned long event_id, unsigned long base_attr_id,
+					    unsigned long attr_count, unsigned long phys_lo,
+					    unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+static unsigned long sse_event_set_attr(unsigned long event_id, unsigned long attr_id,
+					unsigned long value)
+{
+	struct sbiret ret;
+
+	ret = sse_event_set_attr_raw(event_id, attr_id, 1, (unsigned long)&value, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_register_raw(unsigned long event_id, void *entry_pc, void *entry_arg)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)entry_pc,
+			(unsigned long)entry_arg, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_register(unsigned long event_id, struct sse_handler_arg *arg)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)sse_entry,
+			(unsigned long)arg, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_unregister(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_enable(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_hart_mask(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_hart_unmask(void)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_inject(unsigned long event_id, unsigned long hart_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+static unsigned long sse_event_disable(unsigned long event_id)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
+
+	return ret.error;
+}
+
+
+static int sse_get_state(unsigned long event_id, enum sbi_sse_state *state)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	if (ret) {
+		report_fail("Failed to get SSE event status");
+		return -1;
+	}
+
+	*state = status & SBI_SSE_ATTR_STATUS_STATE_MASK;
+
+	return 0;
+}
+
+static void sse_global_event_set_current_hart(unsigned long event_id)
+{
+	int ret;
+
+	if (!sse_event_is_global(event_id))
+		return;
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+				 current_thread_info()->hartid);
+	if (ret)
+		report_abort("set preferred hart failure");
+}
+
+static int sse_check_state(unsigned long event_id, unsigned long expected_state)
+{
+	int ret;
+	enum sbi_sse_state state;
+
+	ret = sse_get_state(event_id, &state);
+	if (ret)
+		return 1;
+	report(state == expected_state, "SSE event status == %ld", expected_state);
+
+	return state != expected_state;
+}
+
+static bool sse_event_pending(unsigned long event_id)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	if (ret) {
+		report_fail("Failed to get SSE event status");
+		return false;
+	}
+
+	return !!(status & BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET));
+}
+
+static void *sse_alloc_stack(void)
+{
+	return (alloc_page() + SSE_STACK_SIZE);
+}
+
+static void sse_free_stack(void *stack)
+{
+	free_page(stack - SSE_STACK_SIZE);
+}
+
+static void sse_test_attr(unsigned long event_id)
+{
+	unsigned long ret, value = 0;
+	unsigned long values[ARRAY_SIZE(ro_attrs)];
+	struct sbiret sret;
+	unsigned int i;
+
+	report_prefix_push("attrs");
+
+	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
+		ret = sse_event_set_attr(event_id, ro_attrs[i], value);
+		report(ret == SBI_ERR_BAD_RANGE, "RO attribute %s not writable",
+		       attr_names[ro_attrs[i]]);
+	}
+
+	for (i = SBI_SSE_ATTR_STATUS; i <= SBI_SSE_ATTR_INTERRUPTED_A7; i++) {
+		ret = sse_event_get_attr(event_id, i, &value);
+		report(ret == SBI_SUCCESS, "Read single attribute %s", attr_names[i]);
+		/* Preferred Hart reset value is defined by SBI vendor and status injectable bit
+		 * also depends on the SBI implementation
+		 */
+		if (i != SBI_SSE_ATTR_STATUS && i != SBI_SSE_ATTR_PREFERRED_HART)
+			report(value == 0, "Attribute %s reset value is 0", attr_names[i]);
+	}
+
+	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_STATUS, values,
+				  SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_STATUS);
+	report(ret == SBI_SUCCESS, "Read multiple attributes");
+
+#if __riscv_xlen > 32
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, 0xFFFFFFFFUL + 1UL);
+	report(ret == SBI_ERR_INVALID_PARAM, "Write prio > 0xFFFFFFFF error");
+#endif
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, ~SBI_SSE_ATTR_CONFIG_ONESHOT);
+	report(ret == SBI_ERR_INVALID_PARAM, "Write invalid config error");
+
+	if (sse_event_is_global(event_id)) {
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, 0xFFFFFFFFUL);
+		report(ret == SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
+	} else {
+		/* Set Hart on local event -> RO */
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+					 current_thread_info()->hartid);
+		report(ret == SBI_ERR_BAD_RANGE, "Set hart id on local event error");
+	}
+
+	/* Set/get flags, sepc, a6, a7 */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		ret = sse_event_get_attr(event_id, interrupted_attrs[i], &value);
+		report(ret == 0, "Get interrupted %s no error", attr_names[interrupted_attrs[i]]);
+
+		/* 0x1 is a valid value for all the interrupted attributes */
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 0x1);
+		report(ret == SBI_ERR_INVALID_STATE, "Set interrupted flags invalid state error");
+	}
+
+	/* Attr_count == 0 */
+	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
+	report(sret.error == SBI_ERR_INVALID_PARAM, "Read attribute attr_count == 0 error");
+
+	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
+	report(sret.error == SBI_ERR_INVALID_PARAM, "Write attribute attr_count == 0 error");
+
+	/* Invalid attribute id */
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, &value);
+	report(ret == SBI_ERR_BAD_RANGE, "Read invalid attribute error");
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, value);
+	report(ret == SBI_ERR_BAD_RANGE, "Write invalid attribute error");
+
+	/* Misaligned phys address */
+	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
+				      ((unsigned long) &value | 0x1), 0);
+	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Read attribute with invalid address error");
+	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
+				      ((unsigned long) &value | 0x1), 0);
+	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Write attribute with invalid address error");
+
+	report_prefix_pop();
+}
+
+static void sse_test_register_error(unsigned long event_id)
+{
+	unsigned long ret;
+
+	report_prefix_push("register");
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_ERR_INVALID_STATE, "SSE unregister non registered event");
+
+	ret = sse_event_register_raw(event_id, (void *) 0x1, NULL);
+	report(ret == SBI_ERR_INVALID_PARAM, "SSE register misaligned entry");
+
+	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
+	report(ret == SBI_SUCCESS, "SSE register ok");
+	if (ret)
+		goto done;
+
+	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
+	report(ret == SBI_ERR_INVALID_STATE, "SSE register twice failure");
+	if (!ret)
+		goto done;
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_SUCCESS, "SSE unregister ok");
+
+done:
+	report_prefix_pop();
+}
+
+struct sse_simple_test_arg {
+	bool done;
+	unsigned long expected_a6;
+	unsigned long event_id;
+};
+
+static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	volatile struct sse_simple_test_arg *arg = data;
+	int ret, i;
+	const char *attr_name;
+	unsigned long event_id = arg->event_id, value, prev_value, flags, attr;
+	const unsigned long regs_len = (SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_INTERRUPTED_A6) +
+				       1;
+	unsigned long interrupted_state[regs_len];
+
+	if ((regs->status & SSTATUS_SPP) == 0)
+		report_fail("Interrupted S-mode");
+
+	if (hartid != current_thread_info()->hartid)
+		report_fail("Hartid correctly passed");
+
+	sse_check_state(event_id, SBI_SSE_STATE_RUNNING);
+	if (sse_event_pending(event_id))
+		report_fail("Event is not pending");
+
+	/* Set a6, a7, sepc, flags while running */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		attr = interrupted_attrs[i];
+		attr_name = attr_names[attr];
+
+		ret = sse_event_get_attr(event_id, attr, &prev_value);
+		report(ret == 0, "Get attr %s no error", attr_name);
+
+		/* We test SBI_SSE_ATTR_INTERRUPTED_FLAGS below with specific flag values */
+		if (attr == SBI_SSE_ATTR_INTERRUPTED_FLAGS)
+			continue;
+
+		ret = sse_event_set_attr(event_id, attr, 0xDEADBEEF + i);
+		report(ret == 0, "Set attr %s invalid state no error", attr_name);
+
+		ret = sse_event_get_attr(event_id, attr, &value);
+		report(ret == 0, "Get attr %s modified value no error", attr_name);
+		report(value == 0xDEADBEEF + i, "Get attr %s modified value ok", attr_name);
+
+		ret = sse_event_set_attr(event_id, attr, prev_value);
+		report(ret == 0, "Restore attr %s value no error", attr_name);
+	}
+
+	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS*/
+	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
+	attr_name = attr_names[attr];
+	ret = sse_event_get_attr(event_id, attr, &prev_value);
+	report(ret == 0, "Get attr %s no error", attr_name);
+
+	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
+		flags = interrupted_flags[i];
+		ret = sse_event_set_attr(event_id, attr, flags);
+		report(ret == 0, "Set interrupted %s value no error", attr_name);
+		ret = sse_event_get_attr(event_id, attr, &value);
+		report(value == flags, "Get attr %s modified value ok", attr_name);
+	}
+
+	ret = sse_event_set_attr(event_id, attr, prev_value);
+		report(ret == 0, "Restore attr %s value no error", attr_name);
+
+	/* Try to change HARTID/Priority while running */
+	if (sse_event_is_global(event_id)) {
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
+					 current_thread_info()->hartid);
+		report(ret == SBI_ERR_INVALID_STATE, "Set hart id while running error");
+	}
+
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, 0);
+	report(ret == SBI_ERR_INVALID_STATE, "Set priority while running error");
+
+	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_A6, interrupted_state,
+				  regs_len);
+	report(ret == SBI_SUCCESS, "Read interrupted context from SSE handler ok");
+	if (interrupted_state[0] != arg->expected_a6)
+		report_fail("Interrupted state a6 check ok");
+	if (interrupted_state[1] != SBI_EXT_SSE)
+		report_fail("Interrupted state a7 check ok");
+
+	arg->done = true;
+}
+
+static void sse_test_inject_simple(unsigned long event_id)
+{
+	unsigned long ret;
+	struct sse_handler_arg args;
+	volatile struct sse_simple_test_arg test_arg = {.event_id = event_id, .done = 0};
+
+	args.handler = sse_simple_handler;
+	args.handler_data = (void *) &test_arg;
+	args.stack = sse_alloc_stack();
+
+	report_prefix_push("simple");
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
+	if (ret)
+		goto done;
+
+	ret = sse_event_register(event_id, &args);
+	report(ret == SBI_SUCCESS, "SSE register no error");
+	if (ret)
+		goto done;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
+	if (ret)
+		goto done;
+
+	/* Be sure global events are targeting the current hart */
+	sse_global_event_set_current_hart(event_id);
+
+	ret = sse_event_enable(event_id);
+	report(ret == SBI_SUCCESS, "SSE enable no error");
+	if (ret)
+		goto done;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_ENABLED);
+	if (ret)
+		goto done;
+
+	ret = sse_hart_mask();
+	report(ret == SBI_SUCCESS, "SSE hart mask no error");
+
+	ret = sse_event_inject(event_id, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection masked no error");
+	if (ret)
+		goto done;
+
+	barrier();
+	report(test_arg.done == 0, "SSE event masked not handled");
+
+	/*
+	 * When unmasking the SSE events, we expect it to be injected
+	 * immediately so a6 should be SBI_EXT_SSE_HART_UNMASK
+	 */
+	test_arg.expected_a6 = SBI_EXT_SSE_HART_UNMASK;
+	ret = sse_hart_unmask();
+	report(ret == SBI_SUCCESS, "SSE hart unmask no error");
+
+	barrier();
+	report(test_arg.done == 1, "SSE event unmasked handled");
+	test_arg.done = 0;
+	test_arg.expected_a6 = SBI_EXT_SSE_INJECT;
+
+	/* Set as oneshot and verify it is disabled */
+	ret = sse_event_disable(event_id);
+	report(ret == 0, "Disable event ok");
+	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, SBI_SSE_ATTR_CONFIG_ONESHOT);
+	report(ret == 0, "Set event attribute as ONESHOT");
+	ret = sse_event_enable(event_id);
+	report(ret == 0, "Enable event ok");
+
+	ret = sse_event_inject(event_id, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection 2 no error");
+	if (ret)
+		goto done;
+
+	barrier();
+	report(test_arg.done == 1, "SSE event handled ok");
+	test_arg.done = 0;
+
+	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
+	if (ret)
+		goto done;
+
+	/* Clear ONESHOT FLAG */
+	sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, 0);
+
+	ret = sse_event_unregister(event_id);
+	report(ret == SBI_SUCCESS, "SSE unregister no error");
+	if (ret)
+		goto done;
+
+	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
+
+done:
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct sse_foreign_cpu_test_arg {
+	bool done;
+	unsigned int expected_cpu;
+	unsigned long event_id;
+};
+
+static void sse_foreign_cpu_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	volatile struct sse_foreign_cpu_test_arg *arg = data;
+
+	/* For arg content to be visible */
+	smp_rmb();
+	if (arg->expected_cpu != current_thread_info()->cpu)
+		report_fail("Received event on CPU (%d), expected CPU (%d)",
+			    current_thread_info()->cpu, arg->expected_cpu);
+
+	arg->done = true;
+	/* For arg update to be visible for other CPUs */
+	smp_wmb();
+}
+
+struct sse_local_per_cpu {
+	struct sse_handler_arg args;
+	unsigned long ret;
+};
+
+struct sse_local_data {
+	unsigned long event_id;
+	struct sse_local_per_cpu *cpu_args[NR_CPUS];
+};
+
+static void sse_register_enable_local(void *data)
+{
+	struct sse_local_data *local_data = data;
+	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
+
+	cpu_arg->ret = sse_event_register(local_data->event_id, &cpu_arg->args);
+	if (cpu_arg->ret)
+		return;
+
+	cpu_arg->ret = sse_event_enable(local_data->event_id);
+}
+
+static void sse_disable_unregister_local(void *data)
+{
+	struct sse_local_data *local_data = data;
+	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
+
+	cpu_arg->ret = sse_event_disable(local_data->event_id);
+	if (cpu_arg->ret)
+		return;
+
+	cpu_arg->ret = sse_event_unregister(local_data->event_id);
+}
+
+static void sse_test_inject_local(unsigned long event_id)
+{
+	int cpu;
+	unsigned long ret;
+	struct sse_local_data local_data;
+	struct sse_local_per_cpu *cpu_arg;
+	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
+
+	report_prefix_push("local_dispatch");
+	local_data.event_id = event_id;
+
+	for_each_online_cpu(cpu) {
+		cpu_arg = calloc(1, sizeof(struct sse_handler_arg));
+
+		cpu_arg->args.stack = sse_alloc_stack();
+		cpu_arg->args.handler = sse_foreign_cpu_handler;
+		cpu_arg->args.handler_data = (void *)&test_arg;
+		local_data.cpu_args[cpu] = cpu_arg;
+	}
+
+	on_cpus(sse_register_enable_local, &local_data);
+	for_each_online_cpu(cpu) {
+		if (local_data.cpu_args[cpu]->ret)
+			report_abort("CPU failed to register/enable SSE event");
+
+		test_arg.expected_cpu = cpu;
+		/* For test_arg content to be visible for other CPUs */
+		smp_wmb();
+		ret = sse_event_inject(event_id, cpus[cpu].hartid);
+		if (ret)
+			report_abort("CPU failed to register/enable SSE event");
+
+		while (!test_arg.done) {
+			/* For test_arg update to be visible */
+			smp_rmb();
+		}
+
+		test_arg.done = false;
+	}
+
+	on_cpus(sse_disable_unregister_local, &local_data);
+	for_each_online_cpu(cpu) {
+		if (local_data.cpu_args[cpu]->ret)
+			report_abort("CPU failed to disable/unregister SSE event");
+	}
+
+	for_each_online_cpu(cpu) {
+		cpu_arg = local_data.cpu_args[cpu];
+
+		sse_free_stack(cpu_arg->args.stack);
+	}
+
+	report_pass("local event dispatch on all CPUs");
+	report_prefix_pop();
+
+}
+
+static void sse_test_inject_global(unsigned long event_id)
+{
+	unsigned long ret;
+	unsigned int cpu;
+	struct sse_handler_arg args;
+	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
+	enum sbi_sse_state state;
+
+	args.handler = sse_foreign_cpu_handler;
+	args.handler_data = (void *)&test_arg;
+	args.stack = sse_alloc_stack();
+
+	report_prefix_push("global_dispatch");
+
+	ret = sse_event_register(event_id, &args);
+	if (ret)
+		goto done;
+
+	for_each_online_cpu(cpu) {
+		test_arg.expected_cpu = cpu;
+		/* For test_arg content to be visible for other CPUs */
+		smp_wmb();
+		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, cpu);
+		if (ret) {
+			report_fail("Failed to set preferred hart");
+			goto done;
+		}
+
+		ret = sse_event_enable(event_id);
+		if (ret) {
+			report_fail("Failed to enable SSE event");
+			goto done;
+		}
+
+		ret = sse_event_inject(event_id, cpu);
+		if (ret) {
+			report_fail("Failed to inject event");
+			goto done;
+		}
+
+		while (!test_arg.done) {
+			/* For shared test_arg structure */
+			smp_rmb();
+		}
+
+		test_arg.done = false;
+
+		/* Wait for event to be in ENABLED state */
+		do {
+			ret = sse_get_state(event_id, &state);
+			if (ret) {
+				report_fail("Failed to get event state");
+				goto done;
+			}
+		} while (state != SBI_SSE_STATE_ENABLED);
+
+		ret = sse_event_disable(event_id);
+		if (ret) {
+			report_fail("Failed to disable SSE event");
+			goto done;
+		}
+
+		report_pass("Global event on CPU %d", cpu);
+	}
+
+done:
+	ret = sse_event_unregister(event_id);
+	if (ret)
+		report_fail("Failed to unregister event");
+
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct priority_test_arg {
+	unsigned long evt;
+	bool called;
+	u32 prio;
+	struct priority_test_arg *next_evt_arg;
+	void (*check_func)(struct priority_test_arg *arg);
+};
+
+static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
+					 unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_evt_arg;
+
+	targ->called = 1;
+	if (next) {
+		sse_event_inject(next->evt, current_thread_info()->hartid);
+		if (sse_event_pending(next->evt))
+			report_fail("Higher priority event is pending");
+		if (!next->called)
+			report_fail("Higher priority event was not handled");
+	}
+}
+
+static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
+					  unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_evt_arg;
+
+	targ->called = 1;
+
+	if (next) {
+		sse_event_inject(next->evt, current_thread_info()->hartid);
+
+		if (!sse_event_pending(next->evt))
+			report_fail("Lower priority event is pending");
+
+		if (next->called)
+			report_fail("Lower priority event %s was handle before %s",
+			      sse_evt_name(next->evt), sse_evt_name(targ->evt));
+	}
+}
+
+static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
+					    unsigned int in_args_size,
+					    sse_handler_fn handler,
+					    const char *test_name)
+{
+	unsigned int i;
+	int ret;
+	unsigned long event_id;
+	struct priority_test_arg *arg;
+	unsigned int args_size = 0;
+	struct sse_handler_arg event_args[in_args_size];
+	struct priority_test_arg *args[in_args_size];
+	void *stack;
+	struct sse_handler_arg *event_arg;
+
+	report_prefix_push(test_name);
+
+	for (i = 0; i < in_args_size; i++) {
+		arg = &in_args[i];
+		event_id = arg->evt;
+		if (!sse_evt_can_inject(event_id))
+			continue;
+
+		args[args_size] = arg;
+		args_size++;
+	}
+
+	if (!args_size) {
+		report_skip("No event injectable");
+		report_prefix_pop();
+		goto skip;
+	}
+
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->evt;
+		stack = sse_alloc_stack();
+
+		event_arg = &event_args[i];
+		event_arg->handler = handler;
+		event_arg->handler_data = (void *)arg;
+		event_arg->stack = stack;
+
+		if (i < (args_size - 1))
+			arg->next_evt_arg = args[i + 1];
+		else
+			arg->next_evt_arg = NULL;
+
+		/* Be sure global events are targeting the current hart */
+		sse_global_event_set_current_hart(event_id);
+
+		sse_event_register(event_id, event_arg);
+		sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIORITY, arg->prio);
+		sse_event_enable(event_id);
+	}
+
+	/* Inject first event */
+	ret = sse_event_inject(args[0]->evt, current_thread_info()->hartid);
+	report(ret == SBI_SUCCESS, "SSE injection no error");
+
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->evt;
+
+		if (!arg->called)
+			report_fail("Event %s handler called", sse_evt_name(arg->evt));
+
+		sse_event_disable(event_id);
+		sse_event_unregister(event_id);
+
+		event_arg = &event_args[i];
+		sse_free_stack(event_arg->stack);
+	}
+
+skip:
+	report_prefix_pop();
+}
+
+static struct priority_test_arg hi_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
+};
+
+static struct priority_test_arg low_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+};
+
+static struct priority_test_arg prio_args[] = {
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 5},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 15},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 25},
+};
+
+static struct priority_test_arg same_prio_args[] = {
+	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 0},
+	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 10},
+	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 10},
+	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
+};
+
+static void sse_test_injection_priority(void)
+{
+	report_prefix_push("prio");
+
+	sse_test_injection_priority_arg(hi_prio_args, ARRAY_SIZE(hi_prio_args),
+					sse_hi_priority_test_handler, "high");
+
+	sse_test_injection_priority_arg(low_prio_args, ARRAY_SIZE(low_prio_args),
+					sse_low_priority_test_handler, "low");
+
+	sse_test_injection_priority_arg(prio_args, ARRAY_SIZE(prio_args),
+					sse_low_priority_test_handler, "changed");
+
+	sse_test_injection_priority_arg(same_prio_args, ARRAY_SIZE(same_prio_args),
+					sse_low_priority_test_handler, "same_prio_args");
+
+	report_prefix_pop();
+}
+
+static bool sse_can_inject(unsigned long event_id)
+{
+	int ret;
+	unsigned long status;
+
+	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
+	report(ret == 0, "SSE get attr status no error");
+	if (ret)
+		return 0;
+
+	return !!(status & BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET));
+}
+
+static void boot_secondary(void *data)
+{
+	sse_hart_unmask();
+}
+
+static void sse_check_mask(void)
+{
+	int ret;
+
+	/* Upon boot, event are masked, check that */
+	ret = sse_hart_mask();
+	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask at boot time ok");
+
+	ret = sse_hart_unmask();
+	report(ret == SBI_SUCCESS, "SSE hart no error ok");
+	ret = sse_hart_unmask();
+	report(ret == SBI_ERR_ALREADY_STOPPED, "SSE hart unmask twice error ok");
+
+	ret = sse_hart_mask();
+	report(ret == SBI_SUCCESS, "SSE hart mask no error");
+	ret = sse_hart_mask();
+	report(ret == SBI_ERR_ALREADY_STARTED, "SSE hart mask twice ok");
+}
+
+void check_sse(void)
+{
+	unsigned long i, event;
+
+	report_prefix_push("sse");
+	sse_check_mask();
+
+	/*
+	 * Dummy wakeup of all processors since some of them will be targeted
+	 * by global events without going through the wakeup call as well as
+	 * unmasking all 
+	 */
+	on_cpus(boot_secondary, NULL);
+
+	if (!sbi_probe(SBI_EXT_SSE)) {
+		report_skip("SSE extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		event = sse_event_infos[i].event_id;
+		report_prefix_push(sse_event_infos[i].name);
+		if (!sse_can_inject(event)) {
+			report_skip("Event does not support injection");
+			report_prefix_pop();
+			continue;
+		} else {
+			sse_event_infos[i].can_inject = true;
+		}
+		sse_test_attr(event);
+		sse_test_register_error(event);
+		sse_test_inject_simple(event);
+		if (sse_event_is_global(event))
+			sse_test_inject_global(event);
+		else
+			sse_test_inject_local(event);
+
+		report_prefix_pop();
+	}
+
+	sse_test_injection_priority();
+
+	report_prefix_pop();
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6f4ddaf1..33d5e40d 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,8 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_sse(void);
+
 static long __labs(long a)
 {
 	return __builtin_labs(a);
@@ -1451,6 +1453,7 @@ int main(int argc, char **argv)
 	check_hsm();
 	check_dbcn();
 	check_susp();
+	check_sse();
 
 	return report_summary();
 }
-- 
2.45.2


