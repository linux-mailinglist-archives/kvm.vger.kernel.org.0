Return-Path: <kvm+bounces-7156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8142483DBB1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 374B11F24AA5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E841DA4F;
	Fri, 26 Jan 2024 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="McD7kM83"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F771D6BC
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279043; cv=none; b=k63GlX9cB3chR4FGTNDEk9MnqCbcE0Ut1GYmZ+WhvwnUSkXInB1CP3uaXAlsf63bKpgmxBwtBTxIhXw6NR2girvAHn3eKb4NMJ6LeW3zgqJ+tfWZVDyaN+GiZ/xuqqUdp/5Z99HYLL2L5zW7WZAkhxXUkDoU5jTtxwVq6StTbMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279043; c=relaxed/simple;
	bh=dCRo9Z42uAYaZnP6LDAlIkasBkSut6shed6es4iUdMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=UL0/awwxqTVDDiiXwZoTah6FcgDjAvnGaHSaxhnvZvlgkiX0HcqEqyrieiqzdG7WonBuMQVGYTglxuUXXC7ff80ofwUolX6FdWGBoDhETJGTZ8hh8XCm9HASnBl/EKFMjIqW63PnAN/IFBfkVT52+51crCvH3x8K6coKTBhsXg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=McD7kM83; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N8NSf9/9YF3U0eKArqRbhDi8OHjkvQY7SWrNffsN93k=;
	b=McD7kM83dy6tfhcm3ADn485vzWr9SPdtIixVPDThiRRn021LDvcBh3S4ZBICOdRGXbtUQV
	bsc2+CG183SPCLZ7Twc6msNi7HN0fvOhigZV4R4yABqatMDUkr8kt/X4QOxepw8kwmLXUG
	L3kbESegONehLBUjKThczCK/fy0GRKo=
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
Subject: [kvm-unit-tests PATCH v2 10/24] riscv: Add backtrace support
Date: Fri, 26 Jan 2024 15:23:35 +0100
Message-ID: <20240126142324.66674-36-andrew.jones@linux.dev>
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

Enable stack unwinding, even when going through an exception, by
implementing backtrace() and pushing a frame pointer on the stack
in exception_vectors.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/stack.h |  3 +++
 lib/riscv/stack.c     | 32 ++++++++++++++++++++++++++++++++
 riscv/Makefile        |  1 +
 riscv/cstart.S        | 28 ++++++++++++++++++++++++++--
 4 files changed, 62 insertions(+), 2 deletions(-)
 create mode 100644 lib/riscv/stack.c

diff --git a/lib/riscv/asm/stack.h b/lib/riscv/asm/stack.h
index d081d0716d7b..f003ca37c913 100644
--- a/lib/riscv/asm/stack.h
+++ b/lib/riscv/asm/stack.h
@@ -6,4 +6,7 @@
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
 #endif
 
+#define HAVE_ARCH_BACKTRACE_FRAME
+#define HAVE_ARCH_BACKTRACE
+
 #endif
diff --git a/lib/riscv/stack.c b/lib/riscv/stack.c
new file mode 100644
index 000000000000..712a5478d547
--- /dev/null
+++ b/lib/riscv/stack.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <libcflat.h>
+#include <stack.h>
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
+{
+	static bool walking;
+	const unsigned long *fp = (unsigned long *)frame;
+	int depth;
+
+	if (walking) {
+		printf("RECURSIVE STACK WALK!!!\n");
+		return 0;
+	}
+	walking = true;
+
+	for (depth = 0; fp && depth < max_depth; ++depth) {
+		return_addrs[depth] = (void *)fp[-1];
+		if (return_addrs[depth] == 0)
+			break;
+		fp = (unsigned long *)fp[-2];
+	}
+
+	walking = false;
+	return depth;
+}
+
+int backtrace(const void **return_addrs, int max_depth)
+{
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
+}
diff --git a/riscv/Makefile b/riscv/Makefile
index 1243be125c00..4a83f27f7df2 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -30,6 +30,7 @@ cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
+cflatobjs += lib/riscv/stack.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/riscv/cstart.S b/riscv/cstart.S
index b3842d667309..2066e37d1ef6 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -17,6 +17,22 @@
 
 #define REG_L	__REG_SEL(ld, lw)
 #define REG_S	__REG_SEL(sd, sw)
+#define SZREG	__REG_SEL(8, 4)
+
+#define FP_SIZE 16
+
+.macro push_fp, ra=ra
+	addi	sp, sp, -FP_SIZE
+	REG_S	\ra, (FP_SIZE - SZREG)(sp)
+	REG_S	fp, (FP_SIZE - 2*SZREG)(sp)
+	addi	fp, sp, FP_SIZE
+.endm
+
+.macro pop_fp
+	REG_L	ra, (FP_SIZE - SZREG)(sp)
+	REG_L	fp, (FP_SIZE - 2*SZREG)(sp)
+	addi	sp, sp, FP_SIZE
+.endm
 
 .macro zero_range, tmp1, tmp2
 9998:	beq	\tmp1, \tmp2, 9997f
@@ -73,6 +89,7 @@ start:
 	li	a1, -8192
 	add	a1, sp, a1
 	zero_range a1, sp
+	mv	fp, zero			// Ensure fp starts out as zero
 
 	/* set up exception handling */
 	la	a1, exception_vectors
@@ -200,9 +217,16 @@ halt:
 .balign 4
 .global exception_vectors
 exception_vectors:
-	REG_S	a0, (-PT_SIZE + PT_ORIG_A0)(sp)
-	addi	a0, sp, -PT_SIZE
+	REG_S	a0, (-PT_SIZE - FP_SIZE + PT_ORIG_A0)(sp)
+	addi	a0, sp, -PT_SIZE - FP_SIZE
 	save_context
+	/*
+	 * Set a frame pointer "ra" which points to the last instruction.
+	 * Add 1 to it, because pretty_print_stacks.py subtracts 1.
+	 */
+	REG_L	a1, PT_EPC(a0)
+	addi	a1, a1, 1
+	push_fp	a1
 	mv	sp, a0
 	call	do_handle_exception
 	mv	a0, sp
-- 
2.43.0


