Return-Path: <kvm+bounces-49603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E8EADAFA6
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B1901894391
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365672DF3CF;
	Mon, 16 Jun 2025 11:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Fmf6nd9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045282DBF73
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 11:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750075169; cv=none; b=MgaV7U/oaTsh730Z+H770ctc0BhX0r9Cs0Qhuhzf4V42+S/PhDX72ALkNl3udHtXg8Ct9p3QsDA+luRMT9qcj7gY3pdpWKv9tc4Z3k1kcWLTZUAHIC2zK45PGI8dobItUo3ADqIkr1SBn6+hAN9QNBAuWUNkRcwi0d7NO7Ff6MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750075169; c=relaxed/simple;
	bh=FGf3NHdxZ2mRw2NyZFUC6x5nmqljaDu3bsxYO6S0+W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2yV0IbOdfDPdzXhyLPfKFso641+iilxywRQm+/P863ph83rMQB7L8KEejVq2U7QsUX3QE4fHsUUKH46RwUG2KYfqwEm2zgk4RqI2aQXImBN4zHHrnENbv9l+1NAus8Hg4Wsp/A4JwNYCm+rQhB97icmkoCAUIq3obJh+CxBscs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Fmf6nd9q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-450cfb6a794so25385855e9.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 04:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750075165; x=1750679965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cye7PXzhbzz2DFhSuuYS6sqTO6mx6+eXlV2+iZi41ZQ=;
        b=Fmf6nd9qmOMHbBBH1hqh71hINxcZZn0BWT/LfWWhaT11wX8rpyfYN0xpAN87tp1iIj
         Psr5NxAeEMuZqStwFIgQCcNuRgKMJmLVJAemlwlgEKneiS+ZHxdCRmstpjAOxLiyCDQV
         ZGG2pS3EAfHqKY2uwxJBdC2DWHAEaJC+ywpUoM20rv7MKAk3y1rjg/SkFA3mKIV83onz
         y7kwYaTpzHjjUi7oHF2yNrebQK5KwSD0ACnNzE4XhtehUYGhUxFb8AIkAi2Dm1j6e1GE
         ORYSZRLKXG3PIwJZJzFTK1v869znH9VoYpZrUej6NXEdxFRt/PbIUyldzwS5WExu/VoC
         FbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750075165; x=1750679965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cye7PXzhbzz2DFhSuuYS6sqTO6mx6+eXlV2+iZi41ZQ=;
        b=n4WuomFK78N+FoykeHQQe6FTmlEHLeJ9aHPFuSIyBPeCRSFPFQMMk1j1swyNQjBPea
         Wp1nP5Zp/wkFHxA7vp0eoa2Pokzs1Ety5xt/P/tASBEtE3beSzoV1UPB+Opc124kV9ib
         tsbDwaXZKnedPM56MilaiUA9RYi5C6kHqw4aXeksmjO5X2cvTI4GXIe/4eGJK5BY4KQN
         4OrK/jpbNO44mEBJjUFsOvg2uQegqkw442poM/F0cq97qwPPibX2PMAZZUsE/3vVfs8T
         mmC7uLjCZ9+bu7kAmn4673YveaGsuZZgVTW9Ck/ZGZLtZnYjzANu3e0AsUsTp/0qM9Hp
         oweA==
X-Gm-Message-State: AOJu0YyioXM83wrXYaVp+lACh1yhVQqNnQqJzKS2SBTCssyt4FazqmiH
	81yqIa48LC7z2G7IFhOgwOWZg3piuqlzrznGEX7nO3+0o2NYVYRYRW7PRrXOGHrF+t03Mrnun1j
	jW+lJNdA=
X-Gm-Gg: ASbGncsKLGa9TGN4CwkeIfLj1df6zEebU41w69qFk++VX9Uf2Nx6ijfhmL4MMoCo7YH
	dt0ml5XZ/KzMBqtyR4jodFxPOgJhyeZMXyw0hDACukIttXIVddMTdIMdxgrK/SNLJRCx9ci6jMb
	2JFW0CjwT7nAWStRD/jncPD4sl2+OI74F9RLgsGx4D73Rw236AQmmF0JUB/0o0Frz34xt6ZSNZG
	BbndXgCevec1sXVuFT/dLTjfyTFFar9rXW68YQ0cqWCEc+rXh6sQOVA/I2+hV2OdMdTmWBQo0Bg
	IBBQjGc4j+Qt/qZANpROr5fbJEOl2aC15xKi4B35XlFl5wMnuQQmCFet5g1Wpjg=
X-Google-Smtp-Source: AGHT+IGlYlJ7/PW92T0FNmuuRD+z5ejc1JPwbNkJ1ADXlQ9ySLQsGT6biEM2mdHNwwyzoVxGztqvww==
X-Received: by 2002:a05:600c:5396:b0:43d:172:50b1 with SMTP id 5b1f17b1804b1-4533cac8fdbmr78663865e9.29.1750075164886;
        Mon, 16 Jun 2025 04:59:24 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a579808c24sm6198786f8f.43.2025.06.16.04.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 04:59:24 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [kvm-unit-tests v3 2/2] riscv: Add ISA double trap extension testing
Date: Mon, 16 Jun 2025 13:59:00 +0200
Message-ID: <20250616115900.957266-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250616115900.957266-1-cleger@rivosinc.com>
References: <20250616115900.957266-1-cleger@rivosinc.com>
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
 riscv/isa-dbltrp.c        | 210 ++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg       |   4 +
 5 files changed, 226 insertions(+)
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
index 631ce226..a3dab064 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -50,6 +50,16 @@ static inline void ipi_ack(void)
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
index 00000000..dcfa66da
--- /dev/null
+++ b/riscv/isa-dbltrp.c
@@ -0,0 +1,210 @@
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
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable"))
+		goto out_unregister;
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
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister"))
+		err = ret.error;
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


