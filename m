Return-Path: <kvm+bounces-36770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8714A20BD6
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D39BE3A63AB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0861AAA1B;
	Tue, 28 Jan 2025 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aW2oyfww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A235C19CCEC
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738073789; cv=none; b=QRR56XU6FNPdIW7Py3/5fLDF85+9QqFQB5+Sy7QO72ashJqH2+Ez5EXrSn2JE7aNB57MggVNuDeOCSnPsuiC0UoJOT+NVZp3SaNNxrV9RatMtcfBaF3fiayXNSJh1vVjQkvKpvVoKo2Rjs/TkUm893fomOkoIP7NKsBs1LrprhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738073789; c=relaxed/simple;
	bh=27VYP1Q7AHuItKXrAtpbQfztGJX14xvtG6PbUk7X9QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HD7orb9djwSesijxxCc6TUDy6KTQxpwP+qq3SM0EPWHuYfBm4KvJmS1a6u6dpnUOyRfstcywf0TES1+un+HQJGcgIVca7u2vuQD/8JUqs9Xw8IBJzIAxsbvWKZNlib0BtQanNmi9V/V4N7HnEVnqcs5IMiDgWxEP2Ah94/3hDf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aW2oyfww; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38634c35129so5163820f8f.3
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738073785; x=1738678585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGVz/XzTns9comkvZkYFzby9ARPE573E1babQQFKqgk=;
        b=aW2oyfwwVlavltPbFb7wqUOag2RIpzWIRNQvuoWxJXjtdpc0t/cQPwWlAtH54OsqPU
         clVUDiemesmiIu3HNHIW+6kT2xR8wvly0nAZv0kL2VRxsBw4qFuV4RdUade4x2fxGPBs
         L7oJTjCzL82v38F4ZQNHJ/zHvRWNNqYaQS3KElWdcnNaW2A0jQOuBycWAhK9NL15GTWd
         4hKopDQLue3YUX2NJ4CIMhwI8QPmpYuTDvNfiGHMa3euzWvtMOIXP2xjGus94MLDNHI0
         EL8ewfVGa6+fCzYO0yL0dJeRztxr7xB12AaqKrshk8pYys72FX2GfMtcf11YhugRq3F+
         eriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738073785; x=1738678585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGVz/XzTns9comkvZkYFzby9ARPE573E1babQQFKqgk=;
        b=CEBjFY5//DXkK8wFQUMHll7vUQRYUIuxMn6cRlyJY3XmlFLtUQ0PZCxDVSaSHNs98W
         MTw5nDiizv+OdImUsGT0bwkC1RHfT7VFzfbDZ7JkRj/W1zXPWjVF4Jyc0YyQe/zHtk3k
         O12Jm+jgx7aXQswUZVRXcMtx7l3a8xaFznedo7xKrRhWdD8d/5weP+Ayzd9zJJeVCFsw
         JcXdY6EzYaKfT263hT4Ivh+SuJjBMfuJCgVdx4yt92IaxX+oC5Ifa0An8sYg3M5O8ucz
         6UAUv3r8MLnn92V8pRiTY5QAk5eezjixyA3rG1vxyEIJ3EQHMNAZST59SAju/VY18d41
         WOdA==
X-Gm-Message-State: AOJu0Yyi+YP+zcgdQJbJd0lwMpebLInwWWgUTWynpimBFElzzrnBtHLt
	3bkkdqrn6YeeFOKLvDeos4F7xzuzsQsB+H/dnBm8NpzItOwXKrwONE+i0Xc2N3Llti+b92OMO/g
	M4/g=
X-Gm-Gg: ASbGncs6tvCPAXYdjw4fe9o7XsNBml2OPolbZr2s9/ofq1Q239gHvAVkFE9twMInkNR
	dsp5DQawAO5NfUcmMAGWqyAOAMz7nM8jq1cpCz/FxSIBjavcFoXAMO5YGLh4aHQovvWw6GafbUR
	QkHVistm0yRKzNbxogFoM3QNvaa9mKDhX3A5otxo7ryMIbtPA5FbM+wyhzXJUFvcQalyOzdPe26
	tid7YJw7gUB73OJXAeLaZ04MD0418+zE7yGvvPkPnIS92Tuq8dnLymOwxppN5aNZm5owljZgp5Q
	ZzhKChRBiqPNehOI
X-Google-Smtp-Source: AGHT+IFlhvdZDW4/XWlnF9ZleausaIxe9TN04H+/lyEgTBbrrnpkoTdU51ogZrUoOd9ptLfUiPiW6w==
X-Received: by 2002:a05:6000:1947:b0:386:3835:9fec with SMTP id ffacd0b85a97d-38bf58e8b7fmr32599307f8f.44.1738073785564;
        Tue, 28 Jan 2025 06:16:25 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1c402esm14435772f8f.97.2025.01.28.06.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 06:16:24 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 2/2] riscv: Add tests for SBI FWFT extension
Date: Tue, 28 Jan 2025 15:15:42 +0100
Message-ID: <20250128141543.1338677-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128141543.1338677-1-cleger@rivosinc.com>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add tests for the FWFT SBI extension. Currently, only the reserved range
as well as the misaligned exception delegation are used.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile      |   2 +-
 lib/riscv/asm/sbi.h |  34 ++++++++
 riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 228 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi-fwft.c

diff --git a/riscv/Makefile b/riscv/Makefile
index 5b5e157c..52718f3f 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -17,7 +17,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
+$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 98a9b097..397400f2 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,12 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
+#define SBI_ERR_TIMEOUT			-12
+#define SBI_ERR_IO			-13
+#define SBI_ERR_LOCKED			-14
 
 #ifndef __ASSEMBLY__
 #include <cpumask.h>
@@ -23,6 +29,7 @@ enum sbi_ext_id {
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
+	SBI_EXT_FWFT = 0x46574654,
 };
 
 enum sbi_ext_base_fid {
@@ -71,6 +78,33 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
+
+enum sbi_ext_fwft_fid {
+	SBI_EXT_FWFT_SET = 0,
+	SBI_EXT_FWFT_GET,
+};
+
+#define SBI_FWFT_MISALIGNED_EXC_DELEG		0x0
+#define SBI_FWFT_LANDING_PAD			0x1
+#define SBI_FWFT_SHADOW_STACK			0x2
+#define SBI_FWFT_DOUBLE_TRAP			0x3
+#define SBI_FWFT_PTE_AD_HW_UPDATING		0x4
+#define SBI_FWFT_POINTER_MASKING_PMLEN		0x5
+#define SBI_FWFT_LOCAL_RESERVED_START		0x6
+#define SBI_FWFT_LOCAL_RESERVED_END		0x3fffffff
+#define SBI_FWFT_LOCAL_PLATFORM_START		0x40000000
+#define SBI_FWFT_LOCAL_PLATFORM_END		0x7fffffff
+
+#define SBI_FWFT_GLOBAL_RESERVED_START		0x80000000
+#define SBI_FWFT_GLOBAL_RESERVED_END		0xbfffffff
+#define SBI_FWFT_GLOBAL_PLATFORM_START		0xc0000000
+#define SBI_FWFT_GLOBAL_PLATFORM_END		0xffffffff
+
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
new file mode 100644
index 00000000..c9292cfb
--- /dev/null
+++ b/riscv/sbi-fwft.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI verification
+ *
+ * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <libcflat.h>
+#include <stdlib.h>
+
+#include <asm/csr.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <asm/sbi.h>
+
+#include "sbi-tests.h"
+
+void check_fwft(void);
+
+
+static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature, value, flags, 0, 0, 0);
+}
+
+static struct sbiret fwft_set(uint32_t feature, unsigned long value, unsigned long flags)
+{
+	return fwft_set_raw(feature, value, flags);
+}
+
+static struct sbiret fwft_get_raw(unsigned long feature)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature, 0, 0, 0, 0, 0);
+}
+
+static struct sbiret fwft_get(uint32_t feature)
+{
+	return fwft_get_raw(feature);
+}
+
+static void fwft_check_reserved(unsigned long id)
+{
+	struct sbiret ret;
+
+	ret = fwft_get(id);
+	sbiret_report_error(&ret, SBI_ERR_DENIED, "get reserved feature 0x%lx", id);
+
+	ret = fwft_set(id, 1, 0);
+	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
+}
+
+static void fwft_check_base(void)
+{
+	struct sbiret ret;
+
+	report_prefix_push("base");
+
+	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_START);
+	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_END);
+	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_START);
+	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_END);
+
+	/* Check id > 32 bits */
+	if (__riscv_xlen > 32) {
+		ret = fwft_get_raw(BIT(32));
+		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+				    "get feature 0x%lx error", BIT(32));
+
+		ret = fwft_set_raw(BIT(32), 0, 0);
+		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+				    "set feature 0x%lx error", BIT(32));
+	}
+
+	report_prefix_pop();
+}
+
+static bool misaligned_handled;
+
+static void misaligned_handler(struct pt_regs *regs)
+{
+	misaligned_handled = true;
+	regs->epc += 4;
+}
+
+static struct sbiret fwft_misaligned_exc_set(unsigned long value, unsigned long flags)
+{
+	return fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, value, flags);
+}
+
+static struct sbiret fwft_misaligned_exc_get(void)
+{
+	return fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+}
+
+static void fwft_check_misaligned_exc_deleg(void)
+{
+	struct sbiret ret;
+
+	report_prefix_push("misaligned_exc_deleg");
+
+	ret = fwft_misaligned_exc_get();
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
+		return;
+	}
+
+	if (!sbiret_report_error(&ret, 0, "Get misaligned deleg feature no error"))
+		return;
+
+	ret = fwft_misaligned_exc_set(2, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "Set misaligned deleg feature invalid value 2");
+	ret = fwft_misaligned_exc_set(0xFFFFFFFF, 0);
+	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+			    "Set misaligned deleg feature invalid value 0xFFFFFFFF");
+
+	if (__riscv_xlen > 32) {
+		ret = fwft_misaligned_exc_set(BIT(32), 0);
+		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+				    "Set misaligned deleg with invalid value > 32bits");
+
+		ret = fwft_misaligned_exc_set(0, BIT(32));
+		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
+				    "Set misaligned deleg with invalid flag > 32bits");
+	}
+
+	/* Set to 0 and check after with get */
+	ret = fwft_misaligned_exc_set(0, 0);
+	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 0 no error");
+	ret = fwft_misaligned_exc_get();
+	sbiret_report(&ret, 0, 0, "Get misaligned deleg feature expected value 0");
+
+	/* Set to 1 and check after with get */
+	ret = fwft_misaligned_exc_set(1, 0);
+	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 1 no error");
+	ret = fwft_misaligned_exc_get();
+	sbiret_report(&ret, 0, 1, "Get misaligned deleg feature expected value 1");
+
+	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
+
+	asm volatile (
+		".option push\n"
+		/*
+		 * Disable compression so the lw takes exactly 4 bytes and thus
+		 * can be skipped reliably from the exception handler.
+		 */
+		".option arch,-c\n"
+		"lw %[val], 1(%[val_addr])\n"
+		".option pop\n"
+		: [val] "+r" (ret.value)
+		: [val_addr] "r" (&ret.value)
+		: "memory");
+
+	/*
+	 * Even though the SBI delegated the misaligned exception to S-mode, it might not trap on
+	 * misaligned load/store access, report that during tests.
+	 */
+	if (!misaligned_handled)
+		report_skip("Misaligned load exception does not trap in S-mode");
+	else
+		report_pass("Misaligned load exception trap in S-mode");
+
+	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
+
+	/* Lock the feature */
+	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
+	sbiret_report_error(&ret, 0, "Set misaligned deleg feature value 0 and lock no error");
+	ret = fwft_misaligned_exc_set(1, 0);
+	sbiret_report_error(&ret, SBI_ERR_LOCKED,
+			    "Set misaligned deleg feature value 0 and lock no error");
+	ret = fwft_misaligned_exc_get();
+	sbiret_report(&ret, 0, 0, "Get misaligned deleg locked value 0 no error");
+
+	report_prefix_pop();
+}
+
+void check_fwft(void)
+{
+	report_prefix_push("fwft");
+
+	if (!sbi_probe(SBI_EXT_FWFT)) {
+		report_skip("FWFT extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	fwft_check_base();
+	fwft_check_misaligned_exc_deleg();
+
+	report_prefix_pop();
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 3eca8c7e..7c7a2d2d 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,8 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_fwft(void);
+
 static long __labs(long a)
 {
 	return __builtin_labs(a);
@@ -1437,6 +1439,7 @@ int main(int argc, char **argv)
 	check_hsm();
 	check_dbcn();
 	check_susp();
+	check_fwft();
 
 	return report_summary();
 }
-- 
2.47.1


