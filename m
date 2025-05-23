Return-Path: <kvm+bounces-47530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B441DAC1DF7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 616804E7038
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 07:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459C6286425;
	Fri, 23 May 2025 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BnvbzteU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2E28369A
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 07:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747986914; cv=none; b=oOtVoZWFzpNjilick6fw0e1gmNLMNa9kyCsH4ZIiNn/CShM4PKK0Nj00A3N3gGOjMHJbYGjbCXjnaFuKS3QCQo1vVsMsQSm5CsFZucByLDYt36ygERjOn+hrnKmkowB+O77hxgfGn8JDJ3zZfSOuImJLyzOvGSwrBSRTL4sOO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747986914; c=relaxed/simple;
	bh=h0qBN3wboDfmA8JNgMgjqZsUmuvhvXgWljcJd/JmLXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPFKzQRz1ebrgHZLRO3dNwbow92jcra7Qqu5/ABDCKcznZidSsBgjzhK81gSQEM5ZTc8RtA0SdN31ONtVaJWaAO3DUaafqD9lnbpSdsW9lA0mDhCejhsi2bG5NykoqpVXP9vFLPWCqdvbsojw5VWBZkw9lltNRAe2Lvo/nmzo1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BnvbzteU; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-231c86bffc1so90158135ad.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747986911; x=1748591711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxzqQKMOJ7+1lap2SHx+5+EMFITY8vpqy2IDV73v588=;
        b=BnvbzteU0ls+GRGrRWWqn1w7ECBDlaZQyrILdxsZnhBfYDhQRkmhHgJ0rlI8RsiSmt
         6WN98pE8eQKEU15dZeM0DzhGbSnHfd741UdhBzIlrqoe26SsG6YJLAFnFPPm4GgAEwvO
         PbqxkQIw04w6nwCl4tgYLzyW18y5liAvfZnrD5S07phLaGuTFaOan/na6Dvjj1Lwxmw3
         UWsOpGAFg+9Uxemxa53FeY1rCt8h6X/oCZA+xdjf2mjoMprg7X/VIvewEsQYaaPWa4hn
         hw+TgUbYBrjMmJ74GJadtq7C72sMBSqkYj1kHt7+PosXRETb8uM5uaLTL8nwsqU4hZnp
         4xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747986911; x=1748591711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxzqQKMOJ7+1lap2SHx+5+EMFITY8vpqy2IDV73v588=;
        b=viYDSIA29StJOaYV7Jp1ouagiu3NxUUEztYStVQABiomEuTqF0uGR/36pZSiJBAV2q
         v7uUt+gO89uli6iWefAvKQ/iShXt3j6c3INTbUx4xS0UciD2Y4klHb9E/4wbgZokjwFE
         PBJksv/rQgDGrGfFezcPsR/ZPFWXgcybR8/HItA+Yc0DtwgfGMDF8HzZV8dI/xi3KZ7v
         ZS4SuOjz3lL/gknqPlnMfFhl/ycp3vl1IMdyFXfiwU+Bogy4WxbEQNWA/O/qaeeQ7qMA
         99maX/BHaxaIedLCBNEGv1EPcdiGWEmDGeGZvavVVtAZnA1SzKRUAjHOhnGI2JnhCri3
         10PQ==
X-Gm-Message-State: AOJu0Yz32i6epsb6MQ6baKzRaDvrzeV5DnjP/+SQOQquYmwJKPTBIbsx
	0c5dF5/vFRkk3cKioNm/8zHfU73AJqrnv2iYb1ZCQC3j6ToIhHfdlOKSgLo+qqokv1yPEdqPxbs
	1Q8sgrYc=
X-Gm-Gg: ASbGnctDTqihjYz+TRqlNqJtsgdLphi28zZIb3n1rq+hYT59OIERminAmGiJ4X8+3Fb
	1VE+rzsR5S4YkUbW1/tdwlSCAUxfXmP9OKwyoL3rSz+SfP8ghmYPjtAhjydU7QAV4W0zFAFHOPI
	xE5Xl4QsY6vFIosg5Sx/JabYj02GSXiAZglONy0VHuOz6ch5cYiYxvJ8WnCZ2W9aofjqEGKtVU0
	lkdsm3Ha3Revg1W1f+bN+KcjyoKc4PsYAG4do1YsiY3/MHRRwcAqcvau6MvqwQjw3mbYdVI2bxx
	7Nn9fjDF5VOhVEsXqBaofvrF6Q2O8gU640BU1gJEYiYsS2XfNPLqTdp6CouyEuk=
X-Google-Smtp-Source: AGHT+IFsCaQmmtn/D65KR060IPvzSK50zSGXf48LGomWrpC+b3XUenXh9CU65SIwoVkuKdwTJQU3NA==
X-Received: by 2002:a17:903:2284:b0:22e:663f:c4b with SMTP id d9443c01a7336-231de36bb60mr361017045ad.26.1747986911225;
        Fri, 23 May 2025 00:55:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36513bb7sm6767204a91.46.2025.05.23.00.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 00:55:10 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [PATCH 3/3] riscv: Add ISA double trap extension testing
Date: Fri, 23 May 2025 09:53:10 +0200
Message-ID: <20250523075341.1355755-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523075341.1355755-1-cleger@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
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
safely assume that PAGE FAULT is delagatable and if a hardware that does
not have support comes up then it will probably be the vendor
responsibility to provide a way to do so.

Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile      |   1 +
 lib/riscv/asm/csr.h |   1 +
 riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/unittests.cfg |   5 ++
 4 files changed, 196 insertions(+)
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
diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
new file mode 100644
index 00000000..174aee2a
--- /dev/null
+++ b/riscv/isa-dbltrp.c
@@ -0,0 +1,189 @@
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
+static bool set_sdt = true;
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
+	: : "r"(value), "r"(ptr) : "memory");					\
+} while (0)
+
+static void syscall_trap_handler(struct pt_regs *regs)
+{
+	if (set_sdt)
+		csr_set(CSR_SSTATUS, SR_SDT);
+
+	if (double_trap) {
+		double_trap = false;
+		GEN_TRAP();
+	}
+
+	/* Skip trapping instruction */
+	regs->epc += 4;
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
+	sse_dbltrp_called = true;
+
+	/* Skip trapping instruction */
+	regs->epc += 4;
+}
+
+static void sse_double_trap(void)
+{
+	struct sbiret ret;
+
+	struct sbi_sse_handler_arg handler_arg = {
+		.handler = sse_dbltrp_handler,
+		.stack = alloc_page() + PAGE_SIZE,
+	};
+
+	report_prefix_push("sse");
+
+	ret = sbi_sse_hart_unmask();
+	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok"))
+		goto out;
+
+	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SSE double trap event is not supported");
+		goto out;
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
+	set_sdt = true;
+	double_trap = true;
+	GEN_TRAP();
+
+	report(sse_dbltrp_called, "SSE double trap event generated");
+
+	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
+	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
+out_unregister:
+	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
+	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");
+
+out:
+	sbi_sse_hart_mask();
+	free_page(handler_arg.stack - PAGE_SIZE);
+
+	report_prefix_pop();
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
+	install_exception_handler(EXC_STORE_PAGE_FAULT, syscall_trap_handler);
+
+	double_trap = true;
+	GEN_TRAP();
+	report_pass("Double trap disabled, trap first time ok");
+
+	/* Enable double trap */
+	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 1);
+	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
+	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
+	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
+		return;
+
+	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
+	set_sdt = false;
+	double_trap = true;
+	GEN_TRAP();
+	report_pass("Trapped twice allowed ok");
+
+	if (sbi_probe(SBI_EXT_SSE))
+		sse_double_trap();
+	else
+		report_skip("SSE double trap event will not be tested, extension is not available");
+
+	/*
+	 * Second time, keep the double trap flag (SDT) and generate another trap, this should
+	 * generate a double trap. Since there is no SSE handler registered, it should crash to
+	 * M-mode.
+	 */
+	set_sdt = true;
+	double_trap = true;
+	report_info("Should generate a double trap and crash !");
+	GEN_TRAP();
+	report_fail("Should have crashed !");
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
+	if (ret.value == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported !");
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
index 2eb760ec..757e6027 100644
--- a/riscv/unittests.cfg
+++ b/riscv/unittests.cfg
@@ -18,3 +18,8 @@ groups = selftest
 file = sbi.flat
 smp = $MAX_SMP
 groups = sbi
+
+[dbltrp]
+file = isa-dbltrp.flat
+smp = $MAX_SMP
+groups = isa
-- 
2.49.0


