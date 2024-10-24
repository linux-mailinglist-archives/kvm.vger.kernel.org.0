Return-Path: <kvm+bounces-29632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDBD9AE536
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAFB5B246FF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C391D9A7F;
	Thu, 24 Oct 2024 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RalBmRza"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9943E1D63F0
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773677; cv=none; b=L342hsq3rq4InqC0UiJmn3nHRCH4FKOY/ZKvwzDgDTFc+zgL/gR3VbmQKo5FkVF34YIeesIMRFCdfWwx/gCDg6opqFmS0zSmipdXLkQobBiR4dZyi5xeF64X9RZX7tFAuGlkCaHDCh4jhkIuI/o+TIJ1tPBLbJrAvtRFq7hcIno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773677; c=relaxed/simple;
	bh=sS1G6Nk4pGQxmkJrOwfurmm8+/7rtOxMqMbwfX80IR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHH4gW+wsDa4F9ZA4J6/sUrZt6yi4JbpjPI8/bExIo9pGprXngz9beLXwXO+QBCTo3oJSjdkWLXp587ahxwRrN+H/2QaM56GnqCksj1XR2utfM7xE2DqBgE8YczKi6DFZQOkMrYHRJMwTty4U2b6bAGPVlumWBjYn1Y+6sY50cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RalBmRza; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729773672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ZH0HhhOm4eyVQFwXhRo2Jpmjl4zZD4HQBsv6A3Z8QE=;
	b=RalBmRzaadKIhBrisYclsaldrwNNnUcQD9OLFQjMBO1vSdYam9tV+O1ppVBCPurh47B5yB
	b7HksLvB+CkhQONRnGtVAope9E3GzQyvCepWFULsmI8qkvX3IZwJCtw391v41REdl6h8P5
	ZaXIvMIfYO0BZYoQez/wviu47s2yfNs=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/3] riscv: Implement setjmp/longjmp
Date: Thu, 24 Oct 2024 14:41:03 +0200
Message-ID: <20241024124101.73405-6-andrew.jones@linux.dev>
In-Reply-To: <20241024124101.73405-5-andrew.jones@linux.dev>
References: <20241024124101.73405-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Being able to do setjmp and longjmp can be quite useful for tests.
Implement the functions for riscv.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/setjmp.S | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/setjmp.h       |  4 ++++
 riscv/Makefile     |  1 +
 3 files changed, 55 insertions(+)
 create mode 100644 lib/riscv/setjmp.S

diff --git a/lib/riscv/setjmp.S b/lib/riscv/setjmp.S
new file mode 100644
index 000000000000..38b0f1cab576
--- /dev/null
+++ b/lib/riscv/setjmp.S
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#define __ASSEMBLY__
+#include <asm/asm.h>
+
+.section .text
+
+.balign 4
+.global setjmp
+setjmp:
+	REG_S	ra, (0 * SZREG)(a0)
+	REG_S	s0, (1 * SZREG)(a0)
+	REG_S	s1, (2 * SZREG)(a0)
+	REG_S	s2, (3 * SZREG)(a0)
+	REG_S	s3, (4 * SZREG)(a0)
+	REG_S	s4, (5 * SZREG)(a0)
+	REG_S	s5, (6 * SZREG)(a0)
+	REG_S	s6, (7 * SZREG)(a0)
+	REG_S	s7, (8 * SZREG)(a0)
+	REG_S	s8, (9 * SZREG)(a0)
+	REG_S	s9, (10 * SZREG)(a0)
+	REG_S	s10, (11 * SZREG)(a0)
+	REG_S	s11, (12 * SZREG)(a0)
+	REG_S	sp, (13 * SZREG)(a0)
+	REG_S	gp, (14 * SZREG)(a0)
+	REG_S	tp, (15 * SZREG)(a0)
+	li	a0, 0
+	ret
+
+.balign 4
+.global longjmp
+longjmp:
+	REG_L	ra, (0 * SZREG)(a0)
+	REG_L	s0, (1 * SZREG)(a0)
+	REG_L	s1, (2 * SZREG)(a0)
+	REG_L	s2, (3 * SZREG)(a0)
+	REG_L	s3, (4 * SZREG)(a0)
+	REG_L	s4, (5 * SZREG)(a0)
+	REG_L	s5, (6 * SZREG)(a0)
+	REG_L	s6, (7 * SZREG)(a0)
+	REG_L	s7, (8 * SZREG)(a0)
+	REG_L	s8, (9 * SZREG)(a0)
+	REG_L	s9, (10 * SZREG)(a0)
+	REG_L	s10, (11 * SZREG)(a0)
+	REG_L	s11, (12 * SZREG)(a0)
+	REG_L	sp, (13 * SZREG)(a0)
+	REG_L	gp, (14 * SZREG)(a0)
+	REG_L	tp, (15 * SZREG)(a0)
+	seqz	a0, a1
+	add	a0, a0, a1
+	ret
diff --git a/lib/setjmp.h b/lib/setjmp.h
index 6afdf665681a..f878ad81c645 100644
--- a/lib/setjmp.h
+++ b/lib/setjmp.h
@@ -8,7 +8,11 @@
 #define _LIBCFLAT_SETJMP_H_
 
 typedef struct jmp_buf_tag {
+#if defined(__i386__) || defined(__x86_64__)
 	long int regs[8];
+#elif defined(__riscv)
+	long int regs[16];
+#endif
 } jmp_buf[1];
 
 extern int setjmp (struct jmp_buf_tag env[1]);
diff --git a/riscv/Makefile b/riscv/Makefile
index 734441f94dad..28b04156bfd5 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -36,6 +36,7 @@ cflatobjs += lib/riscv/isa.o
 cflatobjs += lib/riscv/mmu.o
 cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
+cflatobjs += lib/riscv/setjmp.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 cflatobjs += lib/riscv/stack.o
-- 
2.47.0


