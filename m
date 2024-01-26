Return-Path: <kvm+bounces-7151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAC283DBAC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11B2B283A97
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D8D1D529;
	Fri, 26 Jan 2024 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RnohD1NB"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502F1CFB4
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279033; cv=none; b=PwPFw5hpxH4JpXiK6GXouCb+Z7/aw/WLiigjQsoFdfPRrVGr4hV86nvAO/4kNi9vrniMNUcaYZNKEiYWMGWnvAlkGtObnXYMBCm85Eo/YLNi8RqHjXJPZeqoqWADYShaB+wO3ZH6xRLgY6hYqlaTL29utX014eyMmVAaVXGYdhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279033; c=relaxed/simple;
	bh=4UQoi4njaeFjOf/QXwERiOoLZlO+Oj+PvN4qoHRq6sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=duIqjmt+9EfIYbpp1Sj3bO6bIlQ5gcFCOnHLVSih/h3wLbVBgVfBcxgVAff8h1BgKEcbTvk//WqeNtjHCHW0Cm2YXwbk0aiNVrdF91Ndnc1gWMsRDi9yjzyyxG+7MYbAeR9W0iawWvsOvTIkyncbPZ5ANjRxH+UorX0lPI60IVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RnohD1NB; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XALcCOhBRhRS90DS1bmFvcQjoN6qf84gpDsgMJgZLT4=;
	b=RnohD1NBHgs96YT9EXzNQrPNnN1yI478tFsv4qqj2PdiqKUyqI0vOHISV/++hn0XuGmTre
	CDlG6LJj20Gi/8o8IRHlBOEO/QKp6mIQfplcU1KsiJHf27laWQpF5Ugj0zM/JgYd8lOzI3
	4rwoXW0yLyNB8a7VIThi3rGHr2nWmYU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 06/24] riscv: Add initial SBI support
Date: Fri, 26 Jan 2024 15:23:31 +0100
Message-ID: <20240126142324.66674-32-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add an SBI call function and immediately apply it to properly
exiting the test (instead of hanging) by invoking SBI shutdown
from exit(). Also seed an SBI test file with a simple SBI test
that checks mvendorid is correctly extracted.

Run with e.g.
  qemu-system-riscv64 -nographic -M virt \
      -kernel riscv/sbi.flat \
      -cpu rv64,mvendorid=45 \
      -initrd sbi-env

and be happy that ctrl-a c q is no longer necessary to return to
the shell prompt. sbi-env has MVENDORID=45 in it.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/sbi.h | 32 ++++++++++++++++++++++++++++++++
 lib/riscv/io.c      |  2 ++
 lib/riscv/sbi.c     | 35 +++++++++++++++++++++++++++++++++++
 riscv/Makefile      |  2 ++
 riscv/sbi.c         | 41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+)
 create mode 100644 lib/riscv/asm/sbi.h
 create mode 100644 lib/riscv/sbi.c
 create mode 100644 riscv/sbi.c

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
new file mode 100644
index 000000000000..aeff07f6f1a8
--- /dev/null
+++ b/lib/riscv/asm/sbi.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_SBI_H_
+#define _ASMRISCV_SBI_H_
+
+enum sbi_ext_id {
+	SBI_EXT_BASE = 0x10,
+	SBI_EXT_SRST = 0x53525354,
+};
+
+enum sbi_ext_base_fid {
+	SBI_EXT_BASE_GET_SPEC_VERSION = 0,
+	SBI_EXT_BASE_GET_IMP_ID,
+	SBI_EXT_BASE_GET_IMP_VERSION,
+	SBI_EXT_BASE_PROBE_EXT,
+	SBI_EXT_BASE_GET_MVENDORID,
+	SBI_EXT_BASE_GET_MARCHID,
+	SBI_EXT_BASE_GET_MIMPID,
+};
+
+struct sbiret {
+	long error;
+	long value;
+};
+
+struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
+			unsigned long arg1, unsigned long arg2,
+			unsigned long arg3, unsigned long arg4,
+			unsigned long arg5);
+
+void sbi_shutdown(void);
+
+#endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index aeda74be61ee..b3f587bb68ca 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -9,6 +9,7 @@
 #include <config.h>
 #include <devicetree.h>
 #include <asm/io.h>
+#include <asm/sbi.h>
 #include <asm/setup.h>
 #include <asm/spinlock.h>
 
@@ -90,6 +91,7 @@ void halt(int code);
 void exit(int code)
 {
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
+	sbi_shutdown();
 	halt(code);
 	__builtin_unreachable();
 }
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
new file mode 100644
index 000000000000..fd758555b888
--- /dev/null
+++ b/lib/riscv/sbi.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <libcflat.h>
+#include <asm/sbi.h>
+
+struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
+			unsigned long arg1, unsigned long arg2,
+			unsigned long arg3, unsigned long arg4,
+			unsigned long arg5)
+{
+	register uintptr_t a0 asm ("a0") = (uintptr_t)(arg0);
+	register uintptr_t a1 asm ("a1") = (uintptr_t)(arg1);
+	register uintptr_t a2 asm ("a2") = (uintptr_t)(arg2);
+	register uintptr_t a3 asm ("a3") = (uintptr_t)(arg3);
+	register uintptr_t a4 asm ("a4") = (uintptr_t)(arg4);
+	register uintptr_t a5 asm ("a5") = (uintptr_t)(arg5);
+	register uintptr_t a6 asm ("a6") = (uintptr_t)(fid);
+	register uintptr_t a7 asm ("a7") = (uintptr_t)(ext);
+	struct sbiret ret;
+
+	asm volatile (
+		"ecall"
+		: "+r" (a0), "+r" (a1)
+		: "r" (a2), "r" (a3), "r" (a4), "r" (a5), "r" (a6), "r" (a7)
+		: "memory");
+	ret.error = a0;
+	ret.value = a1;
+
+	return ret;
+}
+
+void sbi_shutdown(void)
+{
+	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
+	puts("SBI shutdown failed!\n");
+}
diff --git a/riscv/Makefile b/riscv/Makefile
index ddf2a0e016a8..4e7fcc538ba1 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -11,6 +11,7 @@ exe = flat
 endif
 
 tests =
+tests += $(TEST_DIR)/sbi.$(exe)
 tests += $(TEST_DIR)/selftest.$(exe)
 #tests += $(TEST_DIR)/sieve.$(exe)
 
@@ -25,6 +26,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
+cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 
diff --git a/riscv/sbi.c b/riscv/sbi.c
new file mode 100644
index 000000000000..ffb07a256ff6
--- /dev/null
+++ b/riscv/sbi.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * SBI verification
+ *
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <libcflat.h>
+#include <stdlib.h>
+#include <asm/sbi.h>
+
+static void help(void)
+{
+	puts("Test SBI\n");
+	puts("An environ must be provided where expected values are given.\n");
+}
+
+int main(int argc, char **argv)
+{
+	struct sbiret ret;
+	long expected;
+
+	if (argc > 1 && !strcmp(argv[1], "-h")) {
+		help();
+		exit(0);
+	}
+
+	report_prefix_push("sbi");
+
+	if (!getenv("MVENDORID")) {
+		report_skip("mvendorid: missing MVENDORID environment variable");
+		goto done;
+	}
+	expected = strtol(getenv("MVENDORID"), NULL, 0);
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_MVENDORID, 0, 0, 0, 0, 0, 0);
+	report(!ret.error, "mvendorid: no error");
+	report(ret.value == expected, "mvendorid");
+
+done:
+	return report_summary();
+}
-- 
2.43.0


