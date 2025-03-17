Return-Path: <kvm+bounces-41201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B641A649CE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B04D3AB88F
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808AA243369;
	Mon, 17 Mar 2025 10:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="GYgTgX7+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE5023DEAD
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206822; cv=none; b=K2M/E6XEaCe1esxSkFjlwFuoJq4Dxj1UfZiP0IBCzd0RRQQcCdpUTF2nFkHy3t9D0li/46o5vl/RdpeJ/rQRJinrNPSEE8NTF5r64VFiGT9H/SLlgzdNpFrGgwCC5bmfwpxHS+EcsufTb1KT9yJ+ptHnM5R/Y+mcGdqy7/gZh8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206822; c=relaxed/simple;
	bh=WEMDMsJ3pMpSkkhYnYUVUdye7hyvGlHhjXRjizJ6pu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=obNwoOQ6yIdnETi6iBl/yl1eirZ2EJy++VShT+mspdRkkYSqnToBMv3OHipx8TjTuGyHSBi3LuTlCh4gQZSSZiR0GWf0VnuFKCHp4y7JZQwelWrCET7xCfOKKsrPyh0fGX9UcgcACZJM2UJAsXr3rcZQ1bEpOngFkwQUCitOn/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=GYgTgX7+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3913cf69784so3589584f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742206817; x=1742811617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAJmlw7Q9esJ4nCrwzQ9ztaJG1c06fAXoECDlzb+vVU=;
        b=GYgTgX7+bR4UMSQl2UTjlGOET9HkMQkwV4qU32tkmKonVig/9eo746jjBSOF0BOjBv
         F1XNEYMTTVaKKDfMHUyiCd9cv5XuP45CGNIbM/VJuxdIUbwxv33bdJLZOWAUcwLpKq0E
         zs05aeXCwjOAfapX0VyMWIEEs1wVVh318DAvIvzAmBoshQ2z8fbiifdyNf8Kc8jsPeJO
         T90Ez+k6o4VayFpjzJ0A7hPmlukO/8Gam/U6aC38CkMdo6ScRZ0cvAJ/IOYKcJ64VG04
         L+mJXklPDtVkfjFF0C8LpI8n8P/EAnqXD8RVbCTTM3H+8O4IUXDGQzkWcrqd9YmVJ74N
         l/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742206817; x=1742811617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAJmlw7Q9esJ4nCrwzQ9ztaJG1c06fAXoECDlzb+vVU=;
        b=a2FJWIWgldnsdRvRoZVmITez45SFwX5H1JC9kJffAHSnUTw3YqpGUTi1ZOLs7u/w+Q
         mOoG2i6hBY9yI4iOVVEp+CvyvsXIjpYQ1jXKdSVMxeAgKuL6meq+0h0nt1zDc8/SNWma
         8Zj5QqOCk1t9fAuVCY7P1Tx2iFXHynECKvHlKjhr3G+QNJYIhH/QpBiRAJRvmtrNruls
         s8LL51utPpkvYQeTWfW9Im/LWkmT+tsa0Ssa/3vaLPlRCLMbipccl5sO577xNjPsulUu
         reAA1da+zHI4Xq6pNgaD5lPhJBlSAcvX8NPbNvwUnIPo5FsG2DFc1wcz18tO8kn6MVco
         dDKQ==
X-Gm-Message-State: AOJu0YwqDIWb+rkiDY4fRcb5i+Akn1p7Mo7gEKjwnH0knDRvoXZYQTGq
	O33muyUMQ8Jbcp/+W/b7/Bq4gaUx/EufLv6sOJkJgT8cYZ4kia2LujEyzVmWIe5V+VJaG3GJQgg
	/aFg=
X-Gm-Gg: ASbGncty2YJl2caY6qjHVB/nX14/ngQ4kkG/2Lsmu1m626q6iQBWSax1WKO3dciLl0C
	7kDttFDEhewge3PZnCmbEDjPmoS3HjG92Vr1NZ8fiO5DRKo0QJrroBoSEO3e6orjWlYSNwBhflK
	ZAQxPMHboH/38QPhUBoEdPxeyE3Cen4+9bbEh0D+W+VYv9pdw4g8dSt/TR8U3TczloipIO0sdOP
	sW/CuwjYXFt81JELkAzvXV7znBXXoIbxJgMqmuezYrRu1NbKeLkuMXIXUYvnOfxtrfnZcC4kBLD
	NcsDqOY7F9gyD+pjfpshgiB5QTp8TdmA32KCpz9UiUQgRA==
X-Google-Smtp-Source: AGHT+IGHPyICF1lXBVAkOJNuZX8TdLhNg0EBZPfUSrlqplL9OrDNEWjqmBCLDygtDKPaS+Usvkk3CA==
X-Received: by 2002:a5d:648b:0:b0:390:e7c1:59c4 with SMTP id ffacd0b85a97d-3971e2ad603mr14303927f8f.13.1742206817110;
        Mon, 17 Mar 2025 03:20:17 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebe3csm14749824f8f.99.2025.03.17.03.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 03:20:16 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v10 8/8] riscv: sbi: Add SSE extension tests
Date: Mon, 17 Mar 2025 11:19:54 +0100
Message-ID: <20250317101956.526834-9-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317101956.526834-1-cleger@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
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
- Hart mask/unmask events

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile    |    1 +
 riscv/sbi-tests.h |    1 +
 riscv/sbi-sse.c   | 1280 +++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c       |    2 +
 4 files changed, 1284 insertions(+)
 create mode 100644 riscv/sbi-sse.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 16fc125b..4fe2f1bb 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -18,6 +18,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
 all: $(tests)
 
 $(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o
+$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index b081464d..a71da809 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -71,6 +71,7 @@
 	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
 
 void sbi_bad_fid(int ext);
+void check_sse(void);
 
 #endif /* __ASSEMBLER__ */
 #endif /* _RISCV_SBI_TESTS_H_ */
diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
new file mode 100644
index 00000000..d6d313b2
--- /dev/null
+++ b/riscv/sbi-sse.c
@@ -0,0 +1,1280 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI SSE testsuite
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <alloc.h>
+#include <alloc_page.h>
+#include <bitops.h>
+#include <cpumask.h>
+#include <libcflat.h>
+#include <on-cpus.h>
+#include <stdlib.h>
+
+#include <asm/barrier.h>
+#include <asm/delay.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/sbi.h>
+#include <asm/setup.h>
+#include <asm/timer.h>
+
+#include "sbi-tests.h"
+
+#define SSE_STACK_SIZE	PAGE_SIZE
+
+struct sse_event_info {
+	uint32_t event_id;
+	const char *name;
+	bool can_inject;
+};
+
+static struct sse_event_info sse_event_infos[] = {
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS,
+		.name = "local_high_prio_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP,
+		.name = "double_trap",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,
+		.name = "global_high_prio_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,
+		.name = "local_pmu_overflow",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,
+		.name = "local_low_prio_ras",
+	},
+	{
+		.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS,
+		.name = "global_low_prio_ras",
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
+	[SBI_SSE_ATTR_STATUS] =			"status",
+	[SBI_SSE_ATTR_PRIORITY] =		"priority",
+	[SBI_SSE_ATTR_CONFIG] =			"config",
+	[SBI_SSE_ATTR_PREFERRED_HART] =		"preferred_hart",
+	[SBI_SSE_ATTR_ENTRY_PC] =		"entry_pc",
+	[SBI_SSE_ATTR_ENTRY_ARG] =		"entry_arg",
+	[SBI_SSE_ATTR_INTERRUPTED_SEPC] =	"interrupted_sepc",
+	[SBI_SSE_ATTR_INTERRUPTED_FLAGS] =	"interrupted_flags",
+	[SBI_SSE_ATTR_INTERRUPTED_A6] =		"interrupted_a6",
+	[SBI_SSE_ATTR_INTERRUPTED_A7] =		"interrupted_a7",
+};
+
+static const unsigned long ro_attrs[] = {
+	SBI_SSE_ATTR_STATUS,
+	SBI_SSE_ATTR_ENTRY_PC,
+	SBI_SSE_ATTR_ENTRY_ARG,
+};
+
+static const unsigned long interrupted_attrs[] = {
+	SBI_SSE_ATTR_INTERRUPTED_SEPC,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS,
+	SBI_SSE_ATTR_INTERRUPTED_A6,
+	SBI_SSE_ATTR_INTERRUPTED_A7,
+};
+
+static const unsigned long interrupted_flags[] = {
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPELP,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV,
+	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP,
+};
+
+static struct sse_event_info *sse_event_get_info(uint32_t event_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		if (sse_event_infos[i].event_id == event_id)
+			return &sse_event_infos[i];
+	}
+
+	assert_msg(false, "Invalid event id: %d", event_id);
+}
+
+static const char *sse_event_name(uint32_t event_id)
+{
+	return sse_event_get_info(event_id)->name;
+}
+
+static bool sse_event_can_inject(uint32_t event_id)
+{
+	return sse_event_get_info(event_id)->can_inject;
+}
+
+static struct sbiret sse_get_event_status_field(uint32_t event_id, unsigned long mask,
+						unsigned long shift, unsigned long *value)
+{
+	struct sbiret ret;
+	unsigned long status;
+
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
+	if (ret.error) {
+		sbiret_report_error(&ret, SBI_SUCCESS, "Get event status");
+		return ret;
+	}
+
+	*value = (status & mask) >> shift;
+
+	return ret;
+}
+
+static struct sbiret sse_event_get_state(uint32_t event_id, enum sbi_sse_state *state)
+{
+	unsigned long status = 0;
+	struct sbiret ret;
+
+	ret = sse_get_event_status_field(event_id, SBI_SSE_ATTR_STATUS_STATE_MASK,
+					  SBI_SSE_ATTR_STATUS_STATE_OFFSET, &status);
+	*state = status;
+
+	return ret;
+}
+
+static unsigned long sse_global_event_set_current_hart(uint32_t event_id)
+{
+	struct sbiret ret;
+	unsigned long current_hart = current_thread_info()->hartid;
+
+	assert(sbi_sse_event_is_global(event_id));
+
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &current_hart);
+	if (sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
+		return ret.error;
+
+	return 0;
+}
+
+static bool sse_check_state(uint32_t event_id, unsigned long expected_state)
+{
+	struct sbiret ret;
+	enum sbi_sse_state state;
+
+	ret = sse_event_get_state(event_id, &state);
+	if (ret.error)
+		return false;
+
+	return report(state == expected_state, "event status == %ld", expected_state);
+}
+
+static bool sse_event_pending(uint32_t event_id)
+{
+	bool pending = 0;
+
+	sse_get_event_status_field(event_id, BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET),
+		SBI_SSE_ATTR_STATUS_PENDING_OFFSET, (unsigned long *)&pending);
+
+	return pending;
+}
+
+static void *sse_alloc_stack(void)
+{
+	/*
+	 * We assume that SSE_STACK_SIZE always fit in one page. This page will
+	 * always be decremented before storing anything on it in sse-entry.S.
+	 */
+	assert(SSE_STACK_SIZE <= PAGE_SIZE);
+
+	return (alloc_page() + SSE_STACK_SIZE);
+}
+
+static void sse_free_stack(void *stack)
+{
+	free_page(stack - SSE_STACK_SIZE);
+}
+
+static void sse_read_write_test(uint32_t event_id, unsigned long attr, unsigned long attr_count,
+				unsigned long *value, long expected_error, const char *str)
+{
+	struct sbiret ret;
+
+	ret = sbi_sse_read_attrs(event_id, attr, attr_count, value);
+	sbiret_report_error(&ret, expected_error, "Read %s error", str);
+
+	ret = sbi_sse_write_attrs(event_id, attr, attr_count, value);
+	sbiret_report_error(&ret, expected_error, "Write %s error", str);
+}
+
+#define ALL_ATTRS_COUNT	(SBI_SSE_ATTR_INTERRUPTED_A7 + 1)
+
+static void sse_test_attrs(uint32_t event_id)
+{
+	unsigned long value = 0;
+	struct sbiret ret;
+	void *ptr;
+	unsigned long values[ALL_ATTRS_COUNT];
+	unsigned int i;
+	const char *invalid_hart_str;
+	const char *attr_name;
+
+	report_prefix_push("attrs");
+
+	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
+		ret = sbi_sse_write_attrs(event_id, ro_attrs[i], 1, &value);
+		sbiret_report_error(&ret, SBI_ERR_DENIED, "RO attribute %s not writable",
+				    attr_names[ro_attrs[i]]);
+	}
+
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, ALL_ATTRS_COUNT, values);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Read multiple attributes");
+
+	for (i = SBI_SSE_ATTR_STATUS; i <= SBI_SSE_ATTR_INTERRUPTED_A7; i++) {
+		ret = sbi_sse_read_attrs(event_id, i, 1, &value);
+		attr_name = attr_names[i];
+
+		sbiret_report_error(&ret, SBI_SUCCESS, "Read single attribute %s", attr_name);
+		if (values[i] != value)
+			report_fail("Attribute 0x%x single value read (0x%lx) differs from the one read with multiple attributes (0x%lx)",
+				    i, value, values[i]);
+		/*
+		 * Preferred hart reset value is defined by SBI vendor
+		 */
+		if (i != SBI_SSE_ATTR_PREFERRED_HART) {
+			/*
+			 * Specification states that injectable bit is implementation dependent
+			 * but other bits are zero-initialized.
+			 */
+			if (i == SBI_SSE_ATTR_STATUS)
+				value &= ~BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET);
+			report(value == 0, "Attribute %s reset value is 0, found %lx", attr_name, value);
+		}
+	}
+
+#if __riscv_xlen > 32
+	value = BIT(32);
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Write invalid prio > 0xFFFFFFFF error");
+#endif
+
+	value = ~SBI_SSE_ATTR_CONFIG_ONESHOT;
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Write invalid config value error");
+
+	if (sbi_sse_event_is_global(event_id)) {
+		invalid_hart_str = getenv("INVALID_HART_ID");
+		if (!invalid_hart_str)
+			value = 0xFFFFFFFFUL;
+		else
+			value = strtoul(invalid_hart_str, NULL, 0);
+
+		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
+		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
+	} else {
+		/* Set Hart on local event -> RO */
+		value = current_thread_info()->hartid;
+		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
+		sbiret_report_error(&ret, SBI_ERR_DENIED,
+				    "Set hart id on local event error");
+	}
+
+	/* Set/get flags, sepc, a6, a7 */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		attr_name = attr_names[interrupted_attrs[i]];
+		ret = sbi_sse_read_attrs(event_id, interrupted_attrs[i], 1, &value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted %s", attr_name);
+
+		value = ARRAY_SIZE(interrupted_attrs) - i;
+		ret = sbi_sse_write_attrs(event_id, interrupted_attrs[i], 1, &value);
+		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE,
+				    "Set attribute %s invalid state error", attr_name);
+	}
+
+	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, 0, &value, SBI_ERR_INVALID_PARAM,
+			    "attribute attr_count == 0");
+	sse_read_write_test(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, 1, &value, SBI_ERR_BAD_RANGE,
+			    "invalid attribute");
+
+	/* Misaligned pointer address */
+	ptr = (void *)&value;
+	ptr += 1;
+	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, 1, ptr, SBI_ERR_INVALID_ADDRESS,
+		"attribute with invalid address");
+
+	report_prefix_pop();
+}
+
+static void sse_test_register_error(uint32_t event_id)
+{
+	struct sbiret ret;
+
+	report_prefix_push("register");
+
+	ret = sbi_sse_unregister(event_id);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "unregister non-registered event");
+
+	ret = sbi_sse_register_raw(event_id, 0x1, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "register misaligned entry");
+
+	ret = sbi_sse_register(event_id, NULL);
+	sbiret_report_error(&ret, SBI_SUCCESS, "register");
+	if (ret.error)
+		goto done;
+
+	ret = sbi_sse_register(event_id, NULL);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "register used event failure");
+
+	ret = sbi_sse_unregister(event_id);
+	sbiret_report_error(&ret, SBI_SUCCESS, "unregister");
+
+done:
+	report_prefix_pop();
+}
+
+struct sse_simple_test_arg {
+	bool done;
+	unsigned long expected_a6;
+	uint32_t event_id;
+};
+
+#if __riscv_xlen > 32
+
+struct alias_test_params {
+	unsigned long event_id;
+	unsigned long attr_id;
+	unsigned long attr_count;
+	const char *str;
+};
+
+static void test_alias(uint32_t event_id)
+{
+	struct alias_test_params *write, *read;
+	unsigned long write_value, read_value;
+	struct sbiret ret;
+	bool err = false;
+	int r, w;
+	struct alias_test_params params[] = {
+		{event_id, SBI_SSE_ATTR_INTERRUPTED_A6, 1, "non aliased"},
+		{BIT(32) + event_id, SBI_SSE_ATTR_INTERRUPTED_A6, 1, "aliased event_id"},
+		{event_id, BIT(32) + SBI_SSE_ATTR_INTERRUPTED_A6, 1, "aliased attr_id"},
+		{event_id, SBI_SSE_ATTR_INTERRUPTED_A6, BIT(32) + 1, "aliased attr_count"},
+	};
+
+	report_prefix_push("alias");
+	for (w = 0; w < ARRAY_SIZE(params); w++) {
+		write = &params[w];
+
+		write_value = 0xDEADBEEF + w;
+		ret = sbi_sse_write_attrs(write->event_id, write->attr_id, write->attr_count, &write_value);
+		if (ret.error)
+			sbiret_report_error(&ret, SBI_SUCCESS, "Write %s, event 0x%lx attr 0x%lx, attr count 0x%lx",
+					    write->str, write->event_id, write->attr_id, write->attr_count);
+
+		for (r = 0; r < ARRAY_SIZE(params); r++) {
+			read = &params[r];
+			read_value = 0;
+			ret = sbi_sse_read_attrs(read->event_id, read->attr_id, read->attr_count, &read_value);
+			if (ret.error)
+				sbiret_report_error(&ret, SBI_SUCCESS,
+						    "Read %s, event 0x%lx attr 0x%lx, attr count 0x%lx",
+						    read->str, read->event_id, read->attr_id, read->attr_count);
+
+			/* Do not spam output with a lot of reports */
+			if (write_value != read_value) {
+				err = true;
+				report_fail("Write %s, event 0x%lx attr 0x%lx, attr count 0x%lx value %lx =="
+					    "Read %s, event 0x%lx attr 0x%lx, attr count 0x%lx value %lx",
+					    write->str, write->event_id, write->attr_id,
+					    write->attr_count, write_value, read->str,
+					    read->event_id, read->attr_id, read->attr_count,
+					    read_value);
+			}
+		}
+	}
+
+	report(!err, "BIT(32) aliasing tests");
+	report_prefix_pop();
+}
+#endif
+
+static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	struct sse_simple_test_arg *arg = data;
+	int i;
+	struct sbiret ret;
+	const char *attr_name;
+	uint32_t event_id = READ_ONCE(arg->event_id), attr;
+	unsigned long value, prev_value, flags;
+	unsigned long interrupted_state[ARRAY_SIZE(interrupted_attrs)];
+	unsigned long modified_state[ARRAY_SIZE(interrupted_attrs)] = {4, 3, 2, 1};
+	unsigned long tmp_state[ARRAY_SIZE(interrupted_attrs)];
+
+	report((regs->status & SR_SPP) == SR_SPP, "Interrupted S-mode");
+	report(hartid == current_thread_info()->hartid, "Hartid correctly passed");
+	sse_check_state(event_id, SBI_SSE_STATE_RUNNING);
+	report(!sse_event_pending(event_id), "Event not pending");
+
+	/* Read full interrupted state */
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
+				 ARRAY_SIZE(interrupted_attrs), interrupted_state);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Save full interrupted state from handler");
+
+	/* Write full modified state and read it */
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
+				  ARRAY_SIZE(modified_state), modified_state);
+	sbiret_report_error(&ret, SBI_SUCCESS,
+			    "Write full interrupted state from handler");
+
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
+				ARRAY_SIZE(tmp_state), tmp_state);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Read full modified state from handler");
+
+	report(memcmp(tmp_state, modified_state, sizeof(modified_state)) == 0,
+	       "Full interrupted state successfully written");
+
+#if __riscv_xlen > 32
+	test_alias(event_id);
+#endif
+
+	/* Restore full saved state */
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
+				  ARRAY_SIZE(interrupted_attrs), interrupted_state);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Full interrupted state restore from handler");
+
+	/* We test SBI_SSE_ATTR_INTERRUPTED_FLAGS below with specific flag values */
+	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
+		attr = interrupted_attrs[i];
+		if (attr == SBI_SSE_ATTR_INTERRUPTED_FLAGS)
+			continue;
+
+		attr_name = attr_names[attr];
+
+		ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s", attr_name);
+
+		value = 0xDEADBEEF + i;
+		ret = sbi_sse_write_attrs(event_id, attr, 1, &value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Set attr %s", attr_name);
+
+		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s", attr_name);
+		report(value == 0xDEADBEEF + i, "Get attr %s, value: 0x%lx", attr_name, value);
+
+		ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Restore attr %s value", attr_name);
+	}
+
+	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS */
+	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
+	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags");
+
+	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
+		flags = interrupted_flags[i];
+		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
+		sbiret_report_error(&ret, SBI_SUCCESS,
+				    "Set interrupted flags bit 0x%lx value", flags);
+		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
+		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set");
+		report(value == flags, "interrupted flags modified value: 0x%lx", value);
+	}
+
+	/* Write invalid bit in flag register */
+	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
+	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
+			    flags);
+
+	flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);
+	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
+			    flags);
+
+	ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Restore interrupted flags");
+
+	/* Try to change HARTID/Priority while running */
+	if (sbi_sse_event_is_global(event_id)) {
+		value = current_thread_info()->hartid;
+		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
+		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set hart id while running error");
+	}
+
+	value = 0;
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set priority while running error");
+
+	value = READ_ONCE(arg->expected_a6);
+	report(interrupted_state[2] == value, "Interrupted state a6, expected 0x%lx, got 0x%lx",
+	       value, interrupted_state[2]);
+
+	report(interrupted_state[3] == SBI_EXT_SSE,
+	       "Interrupted state a7, expected 0x%x, got 0x%lx", SBI_EXT_SSE,
+	       interrupted_state[3]);
+
+	WRITE_ONCE(arg->done, true);
+}
+
+static void sse_test_inject_simple(uint32_t event_id)
+{
+	unsigned long value, error;
+	struct sbiret ret;
+	enum sbi_sse_state state = SBI_SSE_STATE_UNUSED;
+	struct sse_simple_test_arg test_arg = {.event_id = event_id};
+	struct sbi_sse_handler_arg args = {
+		.handler = sse_simple_handler,
+		.handler_data = (void *)&test_arg,
+		.stack = sse_alloc_stack(),
+	};
+
+	report_prefix_push("simple");
+
+	if (!sse_check_state(event_id, SBI_SSE_STATE_UNUSED))
+		goto cleanup;
+
+	ret = sbi_sse_register(event_id, &args);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "register"))
+		goto cleanup;
+
+	state = SBI_SSE_STATE_REGISTERED;
+
+	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
+		goto cleanup;
+
+	if (sbi_sse_event_is_global(event_id)) {
+		/* Be sure global events are targeting the current hart */
+		error = sse_global_event_set_current_hart(event_id);
+		if (error)
+			goto cleanup;
+	}
+
+	ret = sbi_sse_enable(event_id);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "enable"))
+		goto cleanup;
+
+	state = SBI_SSE_STATE_ENABLED;
+	if (!sse_check_state(event_id, SBI_SSE_STATE_ENABLED))
+		goto cleanup;
+
+	ret = sbi_sse_hart_mask();
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "hart mask"))
+		goto cleanup;
+
+	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "injection masked")) {
+		sbi_sse_hart_unmask();
+		goto cleanup;
+	}
+
+	report(READ_ONCE(test_arg.done) == 0, "event masked not handled");
+
+	/*
+	 * When unmasking the SSE events, we expect it to be injected
+	 * immediately so a6 should be SBI_EXT_SBI_SSE_HART_UNMASK
+	 */
+	WRITE_ONCE(test_arg.expected_a6, SBI_EXT_SSE_HART_UNMASK);
+	ret = sbi_sse_hart_unmask();
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "hart unmask"))
+		goto cleanup;
+
+	report(READ_ONCE(test_arg.done) == 1, "event unmasked handled");
+	WRITE_ONCE(test_arg.done, 0);
+	WRITE_ONCE(test_arg.expected_a6, SBI_EXT_SSE_INJECT);
+
+	/* Set as oneshot and verify it is disabled */
+	ret = sbi_sse_disable(event_id);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Disable event")) {
+		/* Nothing we can really do here, event can not be disabled */
+		goto cleanup;
+	}
+	state = SBI_SSE_STATE_REGISTERED;
+
+	value = SBI_SSE_ATTR_CONFIG_ONESHOT;
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set event attribute as ONESHOT"))
+		goto cleanup;
+
+	ret = sbi_sse_enable(event_id);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
+		goto cleanup;
+	state = SBI_SSE_STATE_ENABLED;
+
+	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "second injection"))
+		goto cleanup;
+
+	report(READ_ONCE(test_arg.done) == 1, "event handled");
+	WRITE_ONCE(test_arg.done, 0);
+
+	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
+		goto cleanup;
+	state = SBI_SSE_STATE_REGISTERED;
+
+	/* Clear ONESHOT FLAG */
+	value = 0;
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Clear CONFIG.ONESHOT flag"))
+		goto cleanup;
+
+	ret = sbi_sse_unregister(event_id);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "unregister"))
+		goto cleanup;
+	state = SBI_SSE_STATE_UNUSED;
+
+	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
+
+cleanup:
+	switch (state) {
+	case SBI_SSE_STATE_ENABLED:
+		ret = sbi_sse_disable(event_id);
+		if (ret.error) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "disable event 0x%x", event_id);
+			break;
+		}
+	case SBI_SSE_STATE_REGISTERED:
+		sbi_sse_unregister(event_id);
+		if (ret.error)
+			sbiret_report_error(&ret, SBI_SUCCESS, "unregister event 0x%x", event_id);
+	default:
+	}
+
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct sse_foreign_cpu_test_arg {
+	bool done;
+	unsigned int expected_cpu;
+	uint32_t event_id;
+};
+
+static void sse_foreign_cpu_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	struct sse_foreign_cpu_test_arg *arg = data;
+	unsigned int expected_cpu;
+
+	/* For arg content to be visible */
+	smp_rmb();
+	expected_cpu = READ_ONCE(arg->expected_cpu);
+	report(expected_cpu == current_thread_info()->cpu,
+	       "Received event on CPU (%d), expected CPU (%d)", current_thread_info()->cpu,
+	       expected_cpu);
+
+	WRITE_ONCE(arg->done, true);
+	/* For arg update to be visible for other CPUs */
+	smp_wmb();
+}
+
+struct sse_local_per_cpu {
+	struct sbi_sse_handler_arg args;
+	struct sbiret ret;
+	struct sse_foreign_cpu_test_arg handler_arg;
+	enum sbi_sse_state state;
+};
+
+static void sse_register_enable_local(void *data)
+{
+	struct sbiret ret;
+	struct sse_local_per_cpu *cpu_args = data;
+	struct sse_local_per_cpu *cpu_arg = &cpu_args[current_thread_info()->cpu];
+	uint32_t event_id = cpu_arg->handler_arg.event_id;
+
+	ret = sbi_sse_register(event_id, &cpu_arg->args);
+	WRITE_ONCE(cpu_arg->ret, ret);
+	if (ret.error)
+		return;
+	cpu_arg->state = SBI_SSE_STATE_REGISTERED;
+
+	ret = sbi_sse_enable(event_id);
+	WRITE_ONCE(cpu_arg->ret, ret);
+	if (ret.error)
+		return;
+	cpu_arg->state = SBI_SSE_STATE_ENABLED;
+}
+
+static void sbi_sse_disable_unregister_local(void *data)
+{
+	struct sbiret ret;
+	struct sse_local_per_cpu *cpu_args = data;
+	struct sse_local_per_cpu *cpu_arg = &cpu_args[current_thread_info()->cpu];
+	uint32_t event_id = cpu_arg->handler_arg.event_id;
+
+	switch (cpu_arg->state) {
+	case SBI_SSE_STATE_ENABLED:
+		ret = sbi_sse_disable(event_id);
+		WRITE_ONCE(cpu_arg->ret, ret);
+		if (ret.error)
+			return;
+	case SBI_SSE_STATE_REGISTERED:
+		ret = sbi_sse_unregister(event_id);
+		WRITE_ONCE(cpu_arg->ret, ret);
+	default:
+	}
+}
+
+static uint64_t sse_event_get_complete_timeout(void)
+{
+	char *event_complete_timeout_str;
+	uint64_t timeout;
+
+	event_complete_timeout_str = getenv("SSE_EVENT_COMPLETE_TIMEOUT");
+	if (!event_complete_timeout_str)
+		timeout = 1000;
+	else
+		timeout = strtoul(event_complete_timeout_str, NULL, 0);
+
+	return timer_get_cycles() + usec_to_cycles(timeout);
+}
+
+static void sse_test_inject_local(uint32_t event_id)
+{
+	int cpu;
+	uint64_t timeout;
+	struct sbiret ret;
+	struct sse_local_per_cpu *cpu_args, *cpu_arg;
+	struct sse_foreign_cpu_test_arg *handler_arg;
+
+	cpu_args = calloc(NR_CPUS, sizeof(struct sbi_sse_handler_arg));
+
+	report_prefix_push("local_dispatch");
+	for_each_online_cpu(cpu) {
+		cpu_arg = &cpu_args[cpu];
+		cpu_arg->handler_arg.event_id = event_id;
+		cpu_arg->args.stack = sse_alloc_stack();
+		cpu_arg->args.handler = sse_foreign_cpu_handler;
+		cpu_arg->args.handler_data = (void *)&cpu_arg->handler_arg;
+		cpu_arg->state = SBI_SSE_STATE_UNUSED;
+	}
+
+	on_cpus(sse_register_enable_local, cpu_args);
+	for_each_online_cpu(cpu) {
+		cpu_arg = &cpu_args[cpu];
+		ret = cpu_arg->ret;
+		if (ret.error) {
+			report_fail("CPU failed to register/enable event: %ld", ret.error);
+			goto cleanup;
+		}
+
+		handler_arg = &cpu_arg->handler_arg;
+		WRITE_ONCE(handler_arg->expected_cpu, cpu);
+		/* For handler_arg content to be visible for other CPUs */
+		smp_wmb();
+		ret = sbi_sse_inject(event_id, cpus[cpu].hartid);
+		if (ret.error) {
+			report_fail("CPU failed to inject event: %ld", ret.error);
+			goto cleanup;
+		}
+	}
+
+	for_each_online_cpu(cpu) {
+		handler_arg = &cpu_args[cpu].handler_arg;
+		smp_rmb();
+
+		timeout = sse_event_get_complete_timeout();
+		while (!READ_ONCE(handler_arg->done) && timer_get_cycles() < timeout) {
+			/* For handler_arg update to be visible */
+			smp_rmb();
+			cpu_relax();
+		}
+		report(READ_ONCE(handler_arg->done), "Event handled");
+		WRITE_ONCE(handler_arg->done, false);
+	}
+
+cleanup:
+	on_cpus(sbi_sse_disable_unregister_local, cpu_args);
+	for_each_online_cpu(cpu) {
+		cpu_arg = &cpu_args[cpu];
+		ret = READ_ONCE(cpu_arg->ret);
+		if (ret.error)
+			report_fail("CPU failed to disable/unregister event: %ld", ret.error);
+	}
+
+	for_each_online_cpu(cpu) {
+		cpu_arg = &cpu_args[cpu];
+		sse_free_stack(cpu_arg->args.stack);
+	}
+
+	report_prefix_pop();
+}
+
+static void sse_test_inject_global_cpu(uint32_t event_id, unsigned int cpu,
+				       struct sse_foreign_cpu_test_arg *test_arg)
+{
+	unsigned long value;
+	struct sbiret ret;
+	uint64_t timeout;
+	enum sbi_sse_state state;
+
+	WRITE_ONCE(test_arg->expected_cpu, cpu);
+	/* For test_arg content to be visible for other CPUs */
+	smp_wmb();
+	value = cpu;
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
+		return;
+
+	ret = sbi_sse_enable(event_id);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
+		return;
+
+	ret = sbi_sse_inject(event_id, cpu);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Inject event"))
+		goto disable;
+
+	smp_rmb();
+	timeout = sse_event_get_complete_timeout();
+	while (!READ_ONCE(test_arg->done) && timer_get_cycles() < timeout) {
+		/* For shared test_arg structure */
+		smp_rmb();
+		cpu_relax();
+	}
+
+	report(READ_ONCE(test_arg->done), "event handler called");
+	WRITE_ONCE(test_arg->done, false);
+
+	timeout = sse_event_get_complete_timeout();
+	/* Wait for event to be back in ENABLED state */
+	do {
+		ret = sse_event_get_state(event_id, &state);
+		if (ret.error)
+			goto disable;
+		cpu_relax();
+	} while (state != SBI_SSE_STATE_ENABLED && timer_get_cycles() < timeout);
+
+	report(state == SBI_SSE_STATE_ENABLED, "Event in enabled state");
+
+disable:
+	ret = sbi_sse_disable(event_id);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Disable event");
+}
+
+static void sse_test_inject_global(uint32_t event_id)
+{
+	struct sbiret ret;
+	unsigned int cpu;
+	struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
+	struct sbi_sse_handler_arg args = {
+		.handler = sse_foreign_cpu_handler,
+		.handler_data = (void *)&test_arg,
+		.stack = sse_alloc_stack(),
+	};
+
+	report_prefix_push("global_dispatch");
+
+	ret = sbi_sse_register(event_id, &args);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Register event"))
+		goto err;
+
+	for_each_online_cpu(cpu)
+		sse_test_inject_global_cpu(event_id, cpu, &test_arg);
+
+	ret = sbi_sse_unregister(event_id);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Unregister event");
+
+err:
+	sse_free_stack(args.stack);
+	report_prefix_pop();
+}
+
+struct priority_test_arg {
+	uint32_t event_id;
+	bool called;
+	u32 prio;
+	enum sbi_sse_state state; /* Used for error handling */
+	struct priority_test_arg *next_event_arg;
+	void (*check_func)(struct priority_test_arg *arg);
+};
+
+static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
+					 unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_event_arg;
+
+	targ->called = true;
+	if (next) {
+		sbi_sse_inject(next->event_id, current_thread_info()->hartid);
+
+		report(!sse_event_pending(next->event_id), "Higher priority event is not pending");
+		report(next->called, "Higher priority event was handled");
+	}
+}
+
+static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
+					  unsigned int hartid)
+{
+	struct priority_test_arg *targ = arg;
+	struct priority_test_arg *next = targ->next_event_arg;
+
+	targ->called = true;
+
+	if (next) {
+		sbi_sse_inject(next->event_id, current_thread_info()->hartid);
+
+		report(sse_event_pending(next->event_id), "Lower priority event is pending");
+		report(!next->called, "Lower priority event %s was not handled before %s",
+		       sse_event_name(next->event_id), sse_event_name(targ->event_id));
+	}
+}
+
+static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
+					    unsigned int in_args_size,
+					    sbi_sse_handler_fn handler,
+					    const char *test_name)
+{
+	unsigned int i;
+	unsigned long value, uret;
+	struct sbiret ret;
+	uint32_t event_id;
+	struct priority_test_arg *arg;
+	unsigned int args_size = 0;
+	struct sbi_sse_handler_arg event_args[in_args_size];
+	struct priority_test_arg *args[in_args_size];
+	void *stack;
+	struct sbi_sse_handler_arg *event_arg;
+
+	report_prefix_push(test_name);
+
+	for (i = 0; i < in_args_size; i++) {
+		arg = &in_args[i];
+		arg->state = SBI_SSE_STATE_UNUSED;
+		event_id = arg->event_id;
+		if (!sse_event_can_inject(event_id))
+			continue;
+
+		args[args_size] = arg;
+		args_size++;
+		event_args->stack = 0;
+	}
+
+	if (!args_size) {
+		report_skip("No injectable events");
+		goto skip;
+	}
+
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->event_id;
+		stack = sse_alloc_stack();
+
+		event_arg = &event_args[i];
+		event_arg->handler = handler;
+		event_arg->handler_data = (void *)arg;
+		event_arg->stack = stack;
+
+		if (i < (args_size - 1))
+			arg->next_event_arg = args[i + 1];
+		else
+			arg->next_event_arg = NULL;
+
+		/* Be sure global events are targeting the current hart */
+		if (sbi_sse_event_is_global(event_id)) {
+			uret = sse_global_event_set_current_hart(event_id);
+			if (uret)
+				goto err;
+		}
+
+		ret = sbi_sse_register(event_id, event_arg);
+		if (ret.error) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "register event %s",
+					    sse_event_name(event_id));
+			goto err;
+		}
+		arg->state = SBI_SSE_STATE_REGISTERED;
+
+		value = arg->prio;
+		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
+		if (ret.error) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "set event %s priority",
+					    sse_event_name(event_id));
+			goto err;
+		}
+		ret = sbi_sse_enable(event_id);
+		if (ret.error) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "enable event %s",
+					    sse_event_name(event_id));
+			goto err;
+		}
+		arg->state = SBI_SSE_STATE_ENABLED;
+	}
+
+	/* Inject first event */
+	ret = sbi_sse_inject(args[0]->event_id, current_thread_info()->hartid);
+	sbiret_report_error(&ret, SBI_SUCCESS, "injection");
+
+	/* Check that all handlers have been called */
+	for (i = 0; i < args_size; i++)
+		report(arg->called, "Event %s handler called", sse_event_name(args[i]->event_id));
+
+err:
+	for (i = 0; i < args_size; i++) {
+		arg = args[i];
+		event_id = arg->event_id;
+
+		switch (arg->state) {
+		case SBI_SSE_STATE_ENABLED:
+			ret = sbi_sse_disable(event_id);
+			if (ret.error) {
+				sbiret_report_error(&ret, SBI_SUCCESS, "disable event 0x%x",
+						    event_id);
+				break;
+			}
+		case SBI_SSE_STATE_REGISTERED:
+			sbi_sse_unregister(event_id);
+			if (ret.error)
+				sbiret_report_error(&ret, SBI_SUCCESS, "unregister event 0x%x",
+						event_id);
+		default:
+		}
+
+		event_arg = &event_args[i];
+		if (event_arg->stack)
+			sse_free_stack(event_arg->stack);
+	}
+
+skip:
+	report_prefix_pop();
+}
+
+static struct priority_test_arg hi_prio_args[] = {
+	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP},
+	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS},
+};
+
+static struct priority_test_arg low_prio_args[] = {
+	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW},
+	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS},
+	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
+};
+
+static struct priority_test_arg prio_args[] = {
+	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,		.prio = 5},
+	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,		.prio = 10},
+	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,		.prio = 12},
+	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,		.prio = 15},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,	.prio = 20},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS,		.prio = 22},
+	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS,		.prio = 25},
+};
+
+static struct priority_test_arg same_prio_args[] = {
+	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,		.prio = 0},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS,		.prio = 0},
+	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS,		.prio = 10},
+	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,		.prio = 10},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,		.prio = 10},
+	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,	.prio = 20},
+	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,		.prio = 20},
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
+static void test_invalid_event_id(unsigned long event_id)
+{
+	struct sbiret ret;
+	unsigned long value = 0;
+
+	ret = sbi_sse_register_raw(event_id, (unsigned long) sbi_sse_entry, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "register event_id 0x%lx", event_id);
+
+	ret = sbi_sse_unregister(event_id);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			"unregister event_id 0x%lx", event_id);
+
+	ret = sbi_sse_enable(event_id);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "enable event_id 0x%lx", event_id);
+
+	ret = sbi_sse_disable(event_id);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "disable event_id 0x%lx", event_id);
+
+	ret = sbi_sse_inject(event_id, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "inject event_id 0x%lx", event_id);
+
+	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "write attr event_id 0x%lx", event_id);
+
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "read attr event_id 0x%lx", event_id);
+}
+
+static void sse_test_invalid_event_id(void)
+{
+
+	report_prefix_push("event_id");
+
+	test_invalid_event_id(SBI_SSE_EVENT_LOCAL_RESERVED_0_START);
+
+	report_prefix_pop();
+}
+
+static void sse_check_event_availability(uint32_t event_id, bool *can_inject, bool *supported)
+{
+	unsigned long status;
+	struct sbiret ret;
+
+	*can_inject = false;
+	*supported = false;
+
+	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
+	if (ret.error != SBI_SUCCESS && ret.error != SBI_ERR_NOT_SUPPORTED) {
+		report_fail("Get event status != SBI_SUCCESS && != SBI_ERR_NOT_SUPPORTED: %ld",
+			    ret.error);
+		return;
+	}
+	if (ret.error == SBI_ERR_NOT_SUPPORTED)
+		return;
+
+	*supported = true;
+	*can_inject = (status >> SBI_SSE_ATTR_STATUS_INJECT_OFFSET) & 1;
+}
+
+static void sse_secondary_boot_and_unmask(void *data)
+{
+	sbi_sse_hart_unmask();
+}
+
+static void sse_check_mask(void)
+{
+	struct sbiret ret;
+
+	/* Upon boot, event are masked, check that */
+	ret = sbi_sse_hart_mask();
+	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "hart mask at boot time");
+
+	ret = sbi_sse_hart_unmask();
+	sbiret_report_error(&ret, SBI_SUCCESS, "hart unmask");
+	ret = sbi_sse_hart_unmask();
+	sbiret_report_error(&ret, SBI_ERR_ALREADY_STARTED, "hart unmask twice error");
+
+	ret = sbi_sse_hart_mask();
+	sbiret_report_error(&ret, SBI_SUCCESS, "hart mask");
+	ret = sbi_sse_hart_mask();
+	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "hart mask twice");
+}
+
+static void run_inject_test(struct sse_event_info *info)
+{
+	unsigned long event_id = info->event_id;
+
+	if (!info->can_inject) {
+		report_skip("Event does not support injection, skipping injection tests");
+		return;
+	}
+
+	sse_test_inject_simple(event_id);
+
+	if (sbi_sse_event_is_global(event_id))
+		sse_test_inject_global(event_id);
+	else
+		sse_test_inject_local(event_id);
+}
+
+void check_sse(void)
+{
+	struct sse_event_info *info;
+	unsigned long i, event_id;
+	bool sbi_skip_inject = false;
+	struct sbiret ret;
+	bool supported;
+
+	report_prefix_push("sse");
+
+	if (!sbi_probe(SBI_EXT_SSE)) {
+		report_skip("extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	sse_check_mask();
+
+	/*
+	 * Dummy wakeup of all processors since some of them will be targeted
+	 * by global events without going through the wakeup call as well as
+	 * unmasking SSE events on all harts
+	 */
+	on_cpus(sse_secondary_boot_and_unmask, NULL);
+
+	/* Check for OpenSBI to support injection */
+	if (sbi_check_impl(SBI_IMPL_OPENSBI)) {
+		ret = sbi_get_imp_version();
+		if (!ret.error && ret.value < sbi_impl_opensbi_mk_version(1, 6)) {
+			/*
+			 * OpenSBI < v1.6 crashes kvm-unit-tests upon injection since injection
+			 * arguments (a6/a7) were reversed. Skip injection tests.
+			 */
+			report_skip("OpenSBI < v1.6 detected, skipping injection tests");
+			sbi_skip_inject = true;
+		}
+	}
+
+	sse_test_invalid_event_id();
+
+	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
+		info = &sse_event_infos[i];
+		event_id = info->event_id;
+		report_prefix_push(info->name);
+		sse_check_event_availability(event_id, &info->can_inject, &supported);
+		if (!supported) {
+			report_skip("Event is not supported, skipping tests");
+			report_prefix_pop();
+			continue;
+		}
+
+		sse_test_attrs(event_id);
+		sse_test_register_error(event_id);
+
+		if (!sbi_skip_inject)
+			run_inject_test(info);
+
+		report_prefix_pop();
+	}
+
+	if (!sbi_skip_inject)
+		sse_test_injection_priority();
+
+	report_prefix_pop();
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 0404bb81..478cb35d 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,7 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_sse(void);
 void check_fwft(void);
 
 static long __labs(long a)
@@ -1567,6 +1568,7 @@ int main(int argc, char **argv)
 	check_hsm();
 	check_dbcn();
 	check_susp();
+	check_sse();
 	check_fwft();
 
 	return report_summary();
-- 
2.47.2


