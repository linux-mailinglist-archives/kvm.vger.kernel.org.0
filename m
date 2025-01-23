Return-Path: <kvm+bounces-36408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E33DA1A831
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:54:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6EC9188CBEC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CA319066D;
	Thu, 23 Jan 2025 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OmQfebhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F09B14659D
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651259; cv=none; b=tFPCxHBzNmiX383ndTtRKlaekknwcgxsS7wyT/YUcBN+AqzIBFuNYXmE8BppORqxvReIYXp+6305ILYYUSrISzrdRvM2XfcYNxOvgnX//IMSX6fwZU8Ht2fDFy/bgfDzUgpHIKXMn9UrnCSM8cQ/9iXgzJpM/5uDPgsRSJPsZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651259; c=relaxed/simple;
	bh=V9LX8rAf7k2nqUiVkk7zRq79s5hcKhKCxJCyZKAvpG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kD5LtoJkCEjaCO+ofB2hwKCpjgOMREXMetwZN5V0byaHmrz6ngo5cH2akEysThdhoXYNR/5yfMjJT64tIBKypxoKKcA6BPx0FDeibjrcHTsqySseSGrpG4LzoJBd7gRg4OH3Ydl6CcpKed1bRFiNovB0jUBEqi5jqoWgkURmcG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OmQfebhR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so12156935e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737651255; x=1738256055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVDp9Ql5LJQN7y/vdHOYoVfAPdMK4D2GWQLXSd/2Fco=;
        b=OmQfebhREIZcuzMHHo6ZhgUGgVA2bXX/W/O7YgWeijRceQVL9xMIQBbuIiQ5rxJKlD
         7ny6my9HFvZS5RC+loQVcYcqJK69QSn6CW1oyAiz+fHsHkKGQSLDwOYegipjVC76vyV3
         xQ6p0REgnKR0VijO3jt6lK3Jp9BJT0slw/+O6wd6Es5ExWPW6VJJGX1HViOKxE6qOVgH
         0GVdriUf1rXPxNHNanh0YY4ZILMFU5iG3KXZYKzpVkwon2hVs3qTYNBbVQquw7RT1WB1
         cLS9ERzEz/4GMUbgByVGhe0oiygHNgVZtDMDypr91Hn4SSSODBWjoT/D7w4UITOEP0V3
         WgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737651255; x=1738256055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVDp9Ql5LJQN7y/vdHOYoVfAPdMK4D2GWQLXSd/2Fco=;
        b=IIxhO/zPXi53xOjJUJgWwYGXPMp6jiaCuGbwGk8oJhDQjzfyto/nhTOr0w80ApP7QN
         tFd3sGsg4gnp7mSSzIiKsP7q0jDk618Pawj5n6EtoxeOrf5VBznBcVK6G+YaRy98sKW8
         n3FPOj1DyL49hKx6p757vJphrKhQFV2K72W4+2wcoueR0y6RBXnV8bg3H4SUBCCA00dn
         tM/yr2O8aX2PLE5bU7t6XV7QHkOGBBocN+Qk2AR6yNSxt97dHqs7YMvgdaF3pP3C6bj2
         yF96XaRyIhKmd0fFE8lk7EJqY5cKPjXu78N1bBzcnkIrI2uWS/zSGmMVlKO99H0mKZ6g
         i0sw==
X-Gm-Message-State: AOJu0YxEICI0di/yH0WHSIMMzOpD5C3PTKeIBC7QBypmmZHJpOVqU4ks
	1h/KadDsrEFuniZ7r0+QB7QeVpo8e6PLseSNB0nbvAzAJNzvueCZJsaHjGNJT/BUdYb3AJupt2V
	R
X-Gm-Gg: ASbGncseEoqCJFHyaqXtV0ueWrVC66By/jLax74Rz7hjTfycgZ6mx9D8XzRJgjxDlNQ
	so1AqALsNy865kezZppOoNxDYLYetJBWLC8PUGU8PQrCt232gEsC4Fh4W3w8+3J9AL05yhUgTqR
	Osj3UUhprAwUWVriVbUSy/Me9WWYJo35SWczL4BU0f/3QeNz2mf7ZsrS6/qUcYUAXwMBqa5Fwix
	EzPXzcsrVkywH0RJR17xTlrvs6EPIHyHRG60YqXMRujeZb2m1A1CI1vkiS7dSqprZlaB5EuvSd9
	9I+qNA==
X-Google-Smtp-Source: AGHT+IEsxAp3Krd6vt7hO9SQP/tfbkDk9IoBz4RoRtO7d0duLmPO/Wrd5W9MinTfXkcEfrKmpWvpWA==
X-Received: by 2002:a05:600c:468d:b0:434:a75b:5f59 with SMTP id 5b1f17b1804b1-438913bdb19mr228898385e9.3.1737651255076;
        Thu, 23 Jan 2025 08:54:15 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bbc8dsm165695f8f.72.2025.01.23.08.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 08:54:13 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v2 2/2] riscv: Add tests for SBI FWFT extension
Date: Thu, 23 Jan 2025 17:54:04 +0100
Message-ID: <20250123165405.3524478-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123165405.3524478-1-cleger@rivosinc.com>
References: <20250123165405.3524478-1-cleger@rivosinc.com>
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
 riscv/sbi-fwft.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c         |   3 +
 4 files changed, 227 insertions(+), 1 deletion(-)
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
index 00000000..7866a917
--- /dev/null
+++ b/riscv/sbi-fwft.c
@@ -0,0 +1,189 @@
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
+
+static struct sbiret fwft_set_raw(unsigned long feature_id, unsigned long value,
+				  unsigned long flags)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature_id, value,
+			 flags, 0, 0, 0);
+}
+
+static struct sbiret fwft_set(uint32_t feature_id, unsigned long value,
+			      unsigned long flags)
+{
+	return fwft_set_raw(feature_id, value, flags);
+}
+
+static struct sbiret fwft_get_raw(unsigned long feature_id)
+{
+	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature_id, 0, 0, 0, 0,
+			 0);
+}
+
+static struct sbiret fwft_get(uint32_t feature_id)
+{
+	return fwft_get_raw(feature_id);
+}
+
+static void fwft_check_reserved(unsigned long id)
+{
+	struct sbiret ret;
+
+	ret = fwft_get(id);
+	report(ret.error == SBI_ERR_DENIED,
+	       "get reserved feature 0x%lx error == SBI_ERR_DENIED", id);
+
+	ret = fwft_set(id, 1, 0);
+	report(ret.error == SBI_ERR_DENIED,
+	       "set reserved feature 0x%lx error == SBI_ERR_DENIED", id);
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
+		report(ret.error == SBI_ERR_INVALID_PARAM,
+		"get feature 0x%lx error == SBI_ERR_INVALID_PARAM", BIT(32));
+
+		ret = fwft_set_raw(BIT(32), 0, 0);
+		report(ret.error == SBI_ERR_INVALID_PARAM,
+		"set feature 0x%lx error == SBI_ERR_INVALID_PARAM", BIT(32));
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
+static void fwft_check_misaligned_exc_deleg(void)
+{
+	struct sbiret ret;
+
+	report_prefix_push("misaligned_exc_deleg");
+
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
+		return;
+	}
+	report(!ret.error, "Get misaligned deleg feature no error: %lx",
+	       ret.error);
+	if (ret.error)
+		return;
+
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 2, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "Set misaligned deleg feature invalid value error");
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0xFFFFFFFF, 0);
+	report(ret.error == SBI_ERR_INVALID_PARAM,
+	       "Set misaligned deleg feature invalid value error");
+
+	if (__riscv_xlen > 32) {
+		ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, BIT(32), 0);
+		report(ret.error == SBI_ERR_INVALID_PARAM,
+		       "Set misaligned deleg with value > 32bits invalid param error");
+
+		ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, BIT(32));
+		report(ret.error == SBI_ERR_INVALID_PARAM,
+		       "Set misaligned deleg with flag > 32bits invalid param error");
+	}
+
+	/* Set to 0 and check after with get */
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
+	report(!ret.error, "Set misaligned deleg feature value no error");
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+	if (ret.error)
+		report_fail("Get misaligned deleg feature after set: %lx",
+			    ret.error);
+	else
+		report(ret.value == 0, "Set misaligned deleg feature value 0");
+
+	/* Set to 1 and check after with get */
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
+	report(!ret.error, "Set misaligned deleg feature value no error");
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+	if (ret.error)
+		report_fail("Get misaligned deleg feature after set: %lx",
+			    ret.error);
+	else
+		report(ret.value == 1, "Set misaligned deleg feature value 1");
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
+	if (!misaligned_handled)
+		report_skip("Verify misaligned load exception trap in supervisor");
+	else
+		report_pass("Verify misaligned load exception trap in supervisor");
+
+	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
+
+	/* Lock the feature */
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, SBI_FWFT_SET_FLAG_LOCK);
+	report(!ret.error, "Set misaligned deleg feature value 0 and lock no error");
+	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
+	report(ret.error == SBI_ERR_LOCKED,
+	       "Set misaligned deleg feature value 0 and lock no error");
+	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
+	report(!ret.error, "Get misaligned deleg locked value no error");
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


