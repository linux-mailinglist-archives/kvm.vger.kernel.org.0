Return-Path: <kvm+bounces-34613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45636A02CA7
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907B53A6FC6
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B448158525;
	Mon,  6 Jan 2025 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vqxnTuU/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C913BC39
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178832; cv=none; b=fHo/FQtQAQTCav1BUY8lyp0zCh+DTIfFvbm1mlEsN5lvct2xza7frKmrache98dG0WzvcGrN61Zs+w5uXzqyQ3gAEsXGe9l5EHDVjkT1LILHNmPjDbMXY9GGSg96iHblizMoJ0RUEa/Ttwdg5sqEOiGXR3EmMqHL9l3QVe7Kd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178832; c=relaxed/simple;
	bh=fMAMk7yDvGWunGZgStqZdz9gK7htkALQbc8cvBZf7T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8PD6gSEfoYpZSAIItDLIzp0URDlquc+8d+/YQqToA1jvBsvNu7d0pp68MbC6gBwVTAg6XeskfFV+zt60hKLUxfhdR1aKTpabeC7LQRyWmNJpUdbwHDOCwGbpJwRDXRfvk4nAhcp5MXebGwxdqisBpujP5509HWDfa2nYcWWi8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vqxnTuU/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21634338cfdso11263915ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178829; x=1736783629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/ViT1gefkshRNrQJ4/dNFDRxngEPyJOOTs3jTGg9tk=;
        b=vqxnTuU/H1eUpkcnKrzP0SDAJ3npHjqDb7XB/ae5TiBMr+CmpUWl1yxQkVZX39U2Bh
         TrKwJyzR8rha2KwnLz6610p6eS07kw3HadW02ToIzVXJixx1+XjoXELW4s4BZFio+XZK
         5EWO1p4UbW7bjc7VsTv3fXO4J/cBKWxolwVAdfw/KBaJEeKp3KHLL1B6QHH3Akcvd2mY
         BtrTFSxMqLMatkx5kQL3VoOHVzaU3vd6bKPYSnx9XS5S8FkZwypxhWNU2hXnFrRUy7BZ
         LdNMqLqScsm62NhX/fWLITxOad/Ej0RZAA5Nyep0txGX7JomhfhG91gWXXHRGIGflmaE
         nuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178829; x=1736783629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/ViT1gefkshRNrQJ4/dNFDRxngEPyJOOTs3jTGg9tk=;
        b=BlngAL7c9M3bT2BBMXuTGPZf4ulzXVcEwaB3BKhM/Hwn7MHJ2wEeBe9g2y3lp3rpiJ
         rQmpZvSXqcuqV8x8tL3BKEuBxAtfvdDQwDOHa4Gohr9hSSnLPIJzPtP/WlBi0Bpc8H0L
         FjlB/y4TVL/wYMcVtKxEmXYBJHoPDh1BbCX8IbRjlYcbqCIwiPRSi1W9QYX6XS94gIb3
         YxAiEUsYtXsX5sr8rlFQpFvD+PZL6W7jh+V53YnTKJG5pxj3QmIsOi++NCXp7LMcD9CD
         aZVTklpO45hXZS4kotEYeGB06snv3RS4XLbfJlm3pNm3Bfu4cHa6gxfrINF1gkqwy0nH
         9S8w==
X-Gm-Message-State: AOJu0Yw2pR5GCEmvFCXncwsZCIDfeFQRvSnwrAFmfKQN56G2/ZFgoopm
	dpyn6ff0jAx8qJsQRVL+Vkh+L+oeb+WiKGO4be76LxtMZTp4slBazDw4jjURYhu1BBk74DbDeFb
	F
X-Gm-Gg: ASbGncv4539/6ITVt609eqYv1Xo9nqyyqtuaQouYlE0zO0GuPZ7xi7JOCgqKJCbIIs8
	pur925Kb+8AVZt+e1rqbyjtcbDvxN12tvEe06LzPERAJoqAGvHa7qN+48BsSUZm0advCwSMBz12
	/55VdLXEc8j57LlAmb+lhjDrB0O2EIInvv/MGcsWb9pGLv4B9Avi6kyT10zjAWDhm1fwu/I6GzA
	uhF8glPclGx4cFu7O2Re4TzeaXkZY7hMjHuiBz12ZlWED1VqyDmhWp46g==
X-Google-Smtp-Source: AGHT+IFwx3Bye5GMLDp92fK7LcgEnFE3NPjMHj7cTO1S9Dp8qSV+ymbPozkUpxgwu4DvznFVu34FOQ==
X-Received: by 2002:a05:6a21:789b:b0:1e1:a75e:690b with SMTP id adf61e73a8af0-1e5e0815b11mr90022286637.44.1736178829475;
        Mon, 06 Jan 2025 07:53:49 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b8e867ccsm28950200a12.47.2025.01.06.07.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:53:48 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 2/2] riscv: Add tests for SBI FWFT extension
Date: Mon,  6 Jan 2025 16:53:20 +0100
Message-ID: <20250106155321.1109586-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106155321.1109586-1-cleger@rivosinc.com>
References: <20250106155321.1109586-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This commit add tests for a the FWFT SBI extension. Currently, only
the reserved range as well as the misaligned exception delegation.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile      |   2 +-
 lib/riscv/asm/sbi.h |  31 +++++++++
 riscv/sbi-fwft.c    | 153 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 188 insertions(+), 1 deletion(-)
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
index 98a9b097..27e6fcdb 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -11,6 +11,9 @@
 #define SBI_ERR_ALREADY_AVAILABLE	-6
 #define SBI_ERR_ALREADY_STARTED		-7
 #define SBI_ERR_ALREADY_STOPPED		-8
+#define SBI_ERR_NO_SHMEM		-9
+#define SBI_ERR_INVALID_STATE		-10
+#define SBI_ERR_BAD_RANGE		-11
 
 #ifndef __ASSEMBLY__
 #include <cpumask.h>
@@ -23,6 +26,7 @@ enum sbi_ext_id {
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_SUSP = 0x53555350,
+	SBI_EXT_FWFT = 0x46574654,
 };
 
 enum sbi_ext_base_fid {
@@ -71,6 +75,33 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
 };
 
+/* SBI function IDs for FW feature extension */
+#define SBI_EXT_FWFT_SET		0x0
+#define SBI_EXT_FWFT_GET		0x1
+
+enum sbi_fwft_feature_t {
+	SBI_FWFT_MISALIGNED_EXC_DELEG		= 0x0,
+	SBI_FWFT_LANDING_PAD			= 0x1,
+	SBI_FWFT_SHADOW_STACK			= 0x2,
+	SBI_FWFT_DOUBLE_TRAP			= 0x3,
+	SBI_FWFT_PTE_AD_HARDWARE_UPDATE		= 0x4,
+	SBI_FWFT_POINTER_MASKING_PMLEN		= 0x5,
+	SBI_FWFT_LOCAL_RESERVED_START		= 0x6,
+	SBI_FWFT_LOCAL_RESERVED_END		= 0x3fffffff,
+	SBI_FWFT_LOCAL_PLATFORM_START		= 0x40000000,
+	SBI_FWFT_LOCAL_PLATFORM_END		= 0x7fffffff,
+
+	SBI_FWFT_GLOBAL_RESERVED_START		= 0x80000000,
+	SBI_FWFT_GLOBAL_RESERVED_END		= 0xbfffffff,
+	SBI_FWFT_GLOBAL_PLATFORM_START		= 0xc0000000,
+	SBI_FWFT_GLOBAL_PLATFORM_END		= 0xffffffff,
+};
+
+#define SBI_FWFT_PLATFORM_FEATURE_BIT		(1 << 30)
+#define SBI_FWFT_GLOBAL_FEATURE_BIT		(1 << 31)
+
+#define SBI_FWFT_SET_FLAG_LOCK			(1 << 0)
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
new file mode 100644
index 00000000..8a7f2070
--- /dev/null
+++ b/riscv/sbi-fwft.c
@@ -0,0 +1,153 @@
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
+void check_fwft(void);
+
+static int fwft_set(unsigned long feature_id, unsigned long value,
+		       unsigned long flags)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
+				      feature_id, value, flags, 0, 0, 0);
+
+	return ret.error;
+}
+
+static int fwft_get(unsigned long feature_id, unsigned long *value)
+{
+	struct sbiret ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET,
+				      feature_id, 0, 0, 0, 0, 0);
+
+	*value = ret.value;
+
+	return ret.error;
+}
+
+static void fwft_check_reserved(unsigned long id)
+{
+	int ret;
+	bool pass = true;
+	unsigned long value;
+
+	ret = fwft_get(id, &value);
+	if (ret != SBI_ERR_DENIED)
+		pass = false;
+
+	ret = fwft_set(id, 1, 0);
+	if (ret != SBI_ERR_DENIED)
+		pass = false;
+
+	report(pass, "get/set reserved feature 0x%lx error == SBI_ERR_DENIED", id);
+}
+
+static void fwft_check_denied(void)
+{
+	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_START);
+	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_END);
+	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_START);
+	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_END);
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
+static void fwft_check_misaligned(void)
+{
+	int ret;
+	unsigned long value;
+
+	report_prefix_push("misaligned_deleg");
+
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
+	if (ret == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
+		return;
+	}
+	report(!ret, "Get misaligned deleg feature no error");
+	if (ret)
+		return;
+
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 2, 0);
+	report(ret == SBI_ERR_INVALID_PARAM, "Set misaligned deleg feature invalid value error");
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0xFFFFFFFF, 0);
+	report(ret == SBI_ERR_INVALID_PARAM, "Set misaligned deleg feature invalid value error");
+
+	/* Set to 0 and check after with get */
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
+	report(!ret, "Set misaligned deleg feature value no error");
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
+	if (ret)
+		report_fail("Get misaligned deleg feature after set");
+	else
+		report(value == 0, "Set misaligned deleg feature value 0");
+
+	/* Set to 1 and check after with get */
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
+	report(!ret, "Set misaligned deleg feature value no error");
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
+	if (ret)
+		report_fail("Get misaligned deleg feature after set");
+	else
+		report(value == 1, "Set misaligned deleg feature value 1");
+
+	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
+
+	asm volatile (
+		".option norvc\n"
+		"lw %[val], 1(%[val_addr])"
+		: [val] "+r" (value)
+		: [val_addr] "r" (&value)
+		: "memory");
+
+	if (!misaligned_handled)
+		report_skip("Verify misaligned load exception trap in supervisor");
+	else
+		report_pass("Verify misaligned load exception trap in supervisor");
+
+	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
+
+	report_prefix_pop();
+}
+
+void check_fwft(void)
+{
+	struct sbiret ret;
+
+	report_prefix_push("fwft");
+
+	if (!sbi_probe(SBI_EXT_FWFT)) {
+		report_skip("FWFT extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, SBI_EXT_FWFT, 0, 0, 0, 0, 0);
+	report(!ret.error, "FWFT extension probing no error");
+	if (ret.error)
+		goto done;
+
+	if (ret.value == 0) {
+		report_skip("FWFT extension is not present");
+		goto done;
+	}
+
+	fwft_check_denied();
+	fwft_check_misaligned();
+done:
+	report_prefix_pop();
+}
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6f4ddaf1..8600e38e 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,8 @@
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
+void check_fwft(void);
+
 static long __labs(long a)
 {
 	return __builtin_labs(a);
@@ -1451,6 +1453,7 @@ int main(int argc, char **argv)
 	check_hsm();
 	check_dbcn();
 	check_susp();
+	check_fwft();
 
 	return report_summary();
 }
-- 
2.47.1


