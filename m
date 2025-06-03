Return-Path: <kvm+bounces-48312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 639FAACCA85
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC10A3A5E7A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FA223C50C;
	Tue,  3 Jun 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="3EwLiwM5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DDA23C384
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748965643; cv=none; b=ck0+ZpyxmZug22+zR3+7Z+/oF1ibpsFQljiMoECK3O7+NIrPZZrCunsNq32L6KrHWMmcUDHQ0c9vEh8wl2AjOmM+mkxOYcD6XJqKlcUWrL9Omwz+B4F30/RmoEKt5bTJttCrQFQEenvEEWQU4QV7/HQAucUzCQhAaIXro9bo674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748965643; c=relaxed/simple;
	bh=Ybzz4yd5cQAPajhWK8HZTDSzl7TWEsCb4zn1J19A+Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g02EEfx3jN+LJnvfGVFLnRuDz5fiXtzQaJzFKr6l5OxNxTlNE2L6wQsZwYgR5RB88is/yUMiMuxLTNGYRocOnrqLYh+F6wYxTZRfCFwpzIxeiCOkY1wJ8ay9+nqAWSbhfqLT5qOMSAdGPO3A1OQxO9GerCAg0c/GT/Zn+AFEWIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=3EwLiwM5; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so5498786b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748965640; x=1749570440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yo/3tvwjFOO626619CjpvhLZRvOqcBCa1jAuaGABh0Q=;
        b=3EwLiwM5LU4K9IoFjIUVW7ArIR2it1nksiTP6zUEMmVElSnQGeSfDgFde4DJ6QTEXg
         aZIhIvTRNB6NZATF81IxzyZLWbO8o++UIHDPviFkbMZtDdWv5nq9Kui4kEz1accHycoq
         lqHUIu5gYf2/qwT/fiDOPyh23JlVAL1rChCj3Pl8TeyQCDDb9C0SzgzQY0uZXO14txsy
         zGK/ENBhuU7FxALbrBgqFzv9V7udH+a0QI+l1Py5YZT/Z/1oYKhb301GA3eEfro6NrEO
         GTlq2XZErIH+Si/0x6yVzGsoFjJdr0FOTPCnyBP6Z3AkHbxtEmJBd1dyi5EHzYOPidVj
         VZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748965640; x=1749570440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yo/3tvwjFOO626619CjpvhLZRvOqcBCa1jAuaGABh0Q=;
        b=uD/oZwK+b+lT4DvN8vWe0TIPfkq/DaYHO7ryZ+znHNef/1H+K1KJMgsBWvlkECIAG8
         3AxLYJnxskMAdRD1MPYBjPmC3wVmJz1blar04TnKdftX1fCc0S82L22SthvrDpmOliWo
         C7Nt1cyIT/qAE+GdAz98o+VQdS4+vBAqd1R8hwX5QJNop3EDsb5d0C5zbMIlbBJfKy85
         LMkApqNHdYNCYOjMmCHQaSO4AbkAidoOT8C+8RxjTlfGjfFYH3FsJlbXLJbyUHc6Ekt6
         pvei8vve81WV2oYfVNef+pQcLK5hWpedo4pUPzsH7rI9ZdpWdGRsOMJCl8yXzOr9p9MQ
         BINA==
X-Gm-Message-State: AOJu0Yx28eKk67qmhdWbQW72fZf4SgnXTtOtdNU1cB85K1ULkD8QJvZ0
	Jxssfrp6WEhy1iUw1VlEeiLr+1jzfa2APZapeRZNYqm0NmWRc2KN/fSJqTh9Dlqo50f5JaYjTAV
	YP3Vjik0=
X-Gm-Gg: ASbGncuXN3fHcg5a0SXjtKe6GJBdLwpDj69kBdXwMEiNFLHDm3rl7mvl2Uw0Z36kuSM
	JvICP2P5uFll/2kAiKbi7d3F70AJGD6rh66/khcGKFJlTaCl1V8zeAuotIhv2QKU5zznoriCjyo
	prwibRNDkTycqWDqoWUb2bN+QoNXq1oiIvPek1R4+71Hdaad1E5/N3RKy2rwOAeLgIRCgY6oDmB
	gIM5kCM0rkTLniuQY+QUXk2tb59VgK9zcW0ia3BN7hr+WTQBxyM3oapYsJ11VOIn1naVnWgiIDd
	m08UqkOk7j2PMZboPyDdvAMwULomejcBxj0Rx7w8cBKjynPQtvt2
X-Google-Smtp-Source: AGHT+IHAHTjzXFU0v2HzDxi0Y/7t33hwMRIFeU2hUk18fzwHy/DPqfc8qzxjHlntTiEpwOfPNHRLAA==
X-Received: by 2002:a05:6a21:b93:b0:218:1340:154 with SMTP id adf61e73a8af0-21d0cbe9868mr4205395637.15.1748965640201;
        Tue, 03 Jun 2025 08:47:20 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb9711asm6306066a12.57.2025.06.03.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 08:47:19 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [kvm-unit-tests v2 2/2] riscv: Add ISA double trap extension testing
Date: Tue,  3 Jun 2025 17:46:50 +0200
Message-ID: <20250603154652.1712459-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250603154652.1712459-1-cleger@rivosinc.com>
References: <20250603154652.1712459-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This test allows to test the double trap implementation of hardware as
well as the SBI FWFT and SSE support for double trap. The tests will try
to trigger double trap using various sequences and will test to receive
the SSE double trap event if supported.

It is provided as a separate test from the SBI one for two reasons:
- It isn't specifically testing SBI "per se".
- It ends up by trying to crash into in M-mode.

Currently, the test uses a page fault to raise a trap programatically.
Some concern was raised by a github user on the original branch [1]
saying that the spec doesn't mandate any trap to be delegatable and that
we would need a way to detect which ones are delegatable. I think we can
safely assume that PAGE FAULT is delegatable and if a hardware that does
not have support comes up then it will probably be the vendor
responsibility to provide a way to do so.

Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile            |   1 +
 lib/riscv/asm/csr.h       |   1 +
 lib/riscv/asm/processor.h |  10 ++
 riscv/isa-dbltrp.c        | 211 ++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg       |   4 +
 5 files changed, 227 insertions(+)
 create mode 100644 riscv/isa-dbltrp.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 11e68eae..d71c9d2e 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -14,6 +14,7 @@ tests =
 tests += $(TEST_DIR)/sbi.$(exe)
 tests += $(TEST_DIR)/selftest.$(exe)
 tests += $(TEST_DIR)/sieve.$(exe)
+tests += $(TEST_DIR)/isa-dbltrp.$(exe)
 
 all: $(tests)
 
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 3e4b5fca..6a8e0578 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -18,6 +18,7 @@
 
 #define SR_SIE			_AC(0x00000002, UL)
 #define SR_SPP			_AC(0x00000100, UL)
+#define SR_SDT			_AC(0x01000000, UL) /* Supervisor Double Trap */
 
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 40104272..87a41312 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -48,6 +48,16 @@ static inline void ipi_ack(void)
 	csr_clear(CSR_SIP, IE_SSIE);
 }
 
+static inline void local_dlbtrp_enable(void)
+{
+	csr_set(CSR_SSTATUS, SR_SDT);
+}
+
+static inline void local_dlbtrp_disable(void)
+{
+	csr_clear(CSR_SSTATUS, SR_SDT);
+}
+
 void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
 void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
 void do_handle_exception(struct pt_regs *regs);
diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
new file mode 100644
index 00000000..a4545096
--- /dev/null
+++ b/riscv/isa-dbltrp.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI verification
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <alloc.h>
+#include <alloc_page.h>
+#include <libcflat.h>
+#include <stdlib.h>
+
+#include <asm/csr.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <asm/sbi.h>
+
+#include <sbi-tests.h>
+
+static bool double_trap;
+static bool clear_sdt;
+
+#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
+
+#define GEN_TRAP()								\
+do {										\
+	void *ptr = NULL;							\
+	unsigned long value = 0;						\
+	asm volatile(								\
+	"	.option push\n"							\
+	"	.option arch,-c\n"						\
+	"	sw %0, 0(%1)\n"							\
+	"	.option pop\n"							\
+	: : "r" (value), "r" (ptr) : "memory");					\
+} while (0)
+
+static void pagefault_trap_handler(struct pt_regs *regs)
+{
+	if (READ_ONCE(clear_sdt))
+		local_dlbtrp_disable();
+
+	if (READ_ONCE(double_trap)) {
+		WRITE_ONCE(double_trap, false);
+		GEN_TRAP();
+	}
+
+	/* Skip trapping instruction */
+	regs->epc += 4;
+
+	local_dlbtrp_enable();
+}
+
+static bool sse_dbltrp_called;
+
+static void sse_dbltrp_handler(void *data, struct pt_regs *regs, unsigned int hartid)
+{
+	struct sbiret ret;
+	unsigned long flags;
+	unsigned long expected_flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP |
+				       SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT;
+
+	ret = sbi_sse_read_attrs(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 1,
+				 &flags);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Get double trap event flags");
+	report(flags == expected_flags, "SSE flags == 0x%lx", expected_flags);
+
+	WRITE_ONCE(sse_dbltrp_called, true);
+
+	/* Skip trapping instruction */
+	regs->epc += 4;
+}
+
+static int sse_double_trap(void)
+{
+	struct sbiret ret;
+	int err = 0;
+
+	struct sbi_sse_handler_arg handler_arg = {
+		.handler = sse_dbltrp_handler,
+		.stack = alloc_page() + PAGE_SIZE,
+	};
+
+	report_prefix_push("sse");
+
+	ret = sbi_sse_hart_unmask();
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok")) {
+		report_skip("Failed to unmask SSE events, skipping test");
+		goto out_free_page;
+	}
+
+	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SSE double trap event is not supported");
+		goto out_mask_sse;
+	}
+	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap register");
+
+	ret = sbi_sse_enable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable")) {
+		err = ret.error;
+		goto out_unregister;
+	}
+
+	/*
+	 * Generate a double crash so that an SSE event should be generated. The SPEC (ISA nor SBI)
+	 * does not explicitly tell that if supported it should generate an SSE event but that's
+	 * a reasonable assumption to do so if both FWFT and SSE are supported.
+	 */
+	WRITE_ONCE(clear_sdt, false);
+	WRITE_ONCE(double_trap, true);
+	GEN_TRAP();
+
+	report(READ_ONCE(sse_dbltrp_called), "SSE double trap event generated");
+
+	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
+	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
+
+out_unregister:
+	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
+	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");
+
+out_mask_sse:
+	sbi_sse_hart_mask();
+
+out_free_page:
+	free_page(handler_arg.stack - PAGE_SIZE);
+	report_prefix_pop();
+
+	return err;
+}
+
+static void check_double_trap(void)
+{
+	struct sbiret ret;
+
+	/* Disable double trap */
+	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 0, 0);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 0");
+	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
+	sbiret_report(&ret, SBI_SUCCESS, 0, "Get double trap enable feature value == 0");
+
+	install_exception_handler(EXC_STORE_PAGE_FAULT, pagefault_trap_handler);
+
+	WRITE_ONCE(clear_sdt, true);
+	WRITE_ONCE(double_trap, true);
+	GEN_TRAP();
+	report_pass("Double trap disabled, trap first time ok");
+
+	/* Enable double trap */
+	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 0);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
+	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
+	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
+		return;
+
+	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
+	WRITE_ONCE(clear_sdt, true);
+	WRITE_ONCE(double_trap, true);
+
+	GEN_TRAP();
+	report_pass("Trapped twice allowed ok");
+
+	if (sbi_probe(SBI_EXT_SSE)) {
+		if (sse_double_trap()) {
+			report_skip("Could not correctly unregister SSE event, skipping last test");
+			return;
+		}
+	} else {
+		report_skip("SSE double trap event will not be tested, extension is not available");
+	}
+
+	if (!env_or_skip("DOUBLE_TRAP_TEST_CRASH"))
+		return;
+
+	/*
+	 * Third time, keep the double trap flag (SDT) and generate another trap, this should
+	 * generate a double trap. Since there is no SSE handler registered, it should crash to
+	 * M-mode.
+	 */
+	WRITE_ONCE(clear_sdt, false);
+	WRITE_ONCE(double_trap, true);
+	report_info("Should generate a double trap and crash!");
+	GEN_TRAP();
+	report_fail("Should have crashed!");
+}
+
+int main(int argc, char **argv)
+{
+	struct sbiret ret;
+
+	report_prefix_push("dbltrp");
+
+	if (!sbi_probe(SBI_EXT_FWFT)) {
+		report_skip("FWFT extension is not available, can not enable double traps");
+		goto out;
+	}
+
+	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported!");
+		goto out;
+	}
+
+	if (sbiret_report_error(&ret, SBI_SUCCESS, "SBI_FWFT_DOUBLE_TRAP get value"))
+		check_double_trap();
+
+out:
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
index 2eb760ec..286e1cc7 100644
--- a/riscv/unittests.cfg
+++ b/riscv/unittests.cfg
@@ -18,3 +18,7 @@ groups = selftest
 file = sbi.flat
 smp = $MAX_SMP
 groups = sbi
+
+[dbltrp]
+file = isa-dbltrp.flat
+groups = isa sbi
-- 
2.49.0


