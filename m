Return-Path: <kvm+bounces-13650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE628997F7
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 10:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F420F287BE8
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 08:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CE115FD04;
	Fri,  5 Apr 2024 08:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftS9UFg1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23FC145B09
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 08:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712306190; cv=none; b=BNctnuRI5tY+qPmwlC0U28n4Kf7p2F9Tp03tMJlx2g9tBrSBDAz+FUywag7jqJeGu36lKMpNilbifoypwNCWY5CDiiytpNZJPKUBWTNQVBNMxmea5Qt0zi+b+MYo8GqlaP18VAXzwQB0Jto89U2PLhqMFut/L0MApWPrlpCE3Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712306190; c=relaxed/simple;
	bh=LM4yg8PS/G1+nLuttH6U9oZu4Zc4Wveo5hTXrI3l1fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlxBTKkmgfokHitTW/nGdhAHuoVBPGhdWSfu0Wph00HPQP3vdf5+hRh+XGcB1c3wxc0tsqd/+cEqrkK2Ekmf53gyuLeOtax8Vfzs8fpBn7BRoqVNJ2pJooIVgOBHRjnwGECufPv4+6PhQm1gDxwF2Xn2ddeInAKZNp4ujc1wrbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftS9UFg1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e6b22af648so2270940b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 01:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712306188; x=1712910988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojc5Jzo7lufTrgoyK+GArsWzgBJsqMRvJtb4QkYd9p0=;
        b=ftS9UFg154ebzaooLDw0hMebjIrX4nIn6073CL4UtzSGOPdZ2jh7u4X0Fdcupnjfvn
         6BIkSnxrhN+2QLEY696Mxb1hTHYdh0vN3OII7Ntb22N8KZX0A1DQg7C7NVrp/u6qlila
         Ab+5idpb4aF0CzxlglL+zIOVyGGxTTsBqxn2vck2OYtlUi9JVCV21NIsljaOTeJbLFj1
         ohKGIRILNnH+CeYssKBVSLK1o8l3AgBdUPJb25fx9fpL1kL9TcX86p6N2b8wW/cZ5lHx
         15cXE+2nYEMzITgV2fe+TsXLKxpls/+V+p0aZ9GATdAFpFUht9cJiTH7QYdyrslKAatn
         Gwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712306188; x=1712910988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojc5Jzo7lufTrgoyK+GArsWzgBJsqMRvJtb4QkYd9p0=;
        b=R2XeO7m3ud6AEK6wlNdxo5T2FAS8c5inGOfkUpgMNqHdeZHfwGjtNILb756ZhTM/+s
         mLicoTIzfy3tNw84ln1R6yHdIxqMxYt8NtdvfnkqPj6JfdwYTGqEj6ulez7cQMtZ3xrY
         HtOZJhp42/mDciIx4ragCfoX8wt5CU/lE/vflKZwkJZBTgI8OEYQEvzCH3aMCjosFe4N
         87K7cB02zIF4M5eALAnqMUlTGQog1iVwVMrIQL2d3XDsS5ABJxAUzPLT064YniF4bZIB
         kjf8fCf7TVulRQdTqKmPxHMzv1knoTb2X2f0rKdb7Wh2U5j40fyGo4MzGJQjeD0NvnCA
         PIZg==
X-Forwarded-Encrypted: i=1; AJvYcCXoTocuxcmKqTLgdpyCKiD4KVYFnTexQ3dlod2X10wve6AVUbXZA37A0VvujI+zZ/k/hL19nFBYK/bQmhBTvPHEhMKP
X-Gm-Message-State: AOJu0YzPJdZy/0mja7cZYo3e/SDTQZtwZxL0u6CgrUAiTk+Acf+PLgfz
	G1AlLGB5Bur7zcZV5XzcVLJA8BZVj7bICmmasQxj7bmfbxFAz5PC
X-Google-Smtp-Source: AGHT+IHhkgehUTWXHc9Epdp8neXLEfg0Xxtzigufux5Yi09dT9q7r3Cj5bfLmMhAMIPs13Ja1RKsAA==
X-Received: by 2002:a05:6a21:7888:b0:1a3:a821:f297 with SMTP id bf8-20020a056a21788800b001a3a821f297mr1328214pzc.2.1712306187838;
        Fri, 05 Apr 2024 01:36:27 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id y7-20020a63de47000000b005e838b99c96sm808638pgi.80.2024.04.05.01.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 01:36:27 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 10/35] powerpc: interrupt stack backtracing
Date: Fri,  5 Apr 2024 18:35:11 +1000
Message-ID: <20240405083539.374995-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405083539.374995-1-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for backtracing across interrupt stacks, and add
interrupt frame backtrace for unhandled interrupts.

This requires a back-chain created from initial interrupt stack
frame to the r1 value of the interrupted context. A label is
added at the return location of the exception handler call, so
the unwinder can recognize the initial interrupt frame.

The additional cstart entry-frame is no longer required because
the unwinder now looks for frame == 0 as well as address == 0.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/processor.c |  4 +++-
 lib/ppc64/asm/stack.h   |  3 +++
 lib/ppc64/stack.c       | 53 +++++++++++++++++++++++++++++++++++++++++
 powerpc/Makefile.ppc64  |  1 +
 powerpc/cstart64.S      | 15 +++---------
 5 files changed, 63 insertions(+), 13 deletions(-)
 create mode 100644 lib/ppc64/stack.c

diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index ad0d95666..114584024 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -51,7 +51,9 @@ void do_handle_exception(struct pt_regs *regs)
 		return;
 	}
 
-	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n", regs->trap, regs->nip, regs->msr);
+	printf("Unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",
+			regs->trap, regs->nip, regs->msr);
+	dump_frame_stack((void *)regs->nip, (void *)regs->gpr[1]);
 	abort();
 }
 
diff --git a/lib/ppc64/asm/stack.h b/lib/ppc64/asm/stack.h
index 9734bbb8f..94fd1021c 100644
--- a/lib/ppc64/asm/stack.h
+++ b/lib/ppc64/asm/stack.h
@@ -5,4 +5,7 @@
 #error Do not directly include <asm/stack.h>. Just use <stack.h>.
 #endif
 
+#define HAVE_ARCH_BACKTRACE
+#define HAVE_ARCH_BACKTRACE_FRAME
+
 #endif
diff --git a/lib/ppc64/stack.c b/lib/ppc64/stack.c
new file mode 100644
index 000000000..e6f259de7
--- /dev/null
+++ b/lib/ppc64/stack.c
@@ -0,0 +1,53 @@
+#include <libcflat.h>
+#include <asm/ptrace.h>
+#include <stack.h>
+
+extern char do_handle_exception_return[];
+
+int arch_backtrace_frame(const void *frame, const void **return_addrs,
+			 int max_depth, bool current_frame)
+{
+	static int walking;
+	int depth = 0;
+	const unsigned long *bp = (unsigned long *)frame;
+	void *return_addr;
+
+	asm volatile("" ::: "lr"); /* Force it to save LR */
+
+	if (walking) {
+		printf("RECURSIVE STACK WALK!!!\n");
+		return 0;
+	}
+	walking = 1;
+
+	if (current_frame)
+		bp = __builtin_frame_address(0);
+
+	bp = (unsigned long *)bp[0];
+	return_addr = (void *)bp[2];
+
+	for (depth = 0; bp && depth < max_depth; depth++) {
+		return_addrs[depth] = return_addr;
+		if (return_addrs[depth] == 0)
+			break;
+		if (return_addrs[depth] == do_handle_exception_return) {
+			struct pt_regs *regs;
+
+			regs = (void *)bp + STACK_FRAME_OVERHEAD;
+			bp = (unsigned long *)bp[0];
+			/* Represent interrupt frame with vector number */
+			return_addr = (void *)regs->trap;
+			if (depth + 1 < max_depth) {
+				depth++;
+				return_addrs[depth] = return_addr;
+				return_addr = (void *)regs->nip;
+			}
+		} else {
+			bp = (unsigned long *)bp[0];
+			return_addr = (void *)bp[2];
+		}
+	}
+
+	walking = 0;
+	return depth;
+}
diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
index b0ed2b104..eb682c226 100644
--- a/powerpc/Makefile.ppc64
+++ b/powerpc/Makefile.ppc64
@@ -17,6 +17,7 @@ cstart.o = $(TEST_DIR)/cstart64.o
 reloc.o  = $(TEST_DIR)/reloc64.o
 
 OBJDIRS += lib/ppc64
+cflatobjs += lib/ppc64/stack.o
 
 # ppc64 specific tests
 tests = $(TEST_DIR)/spapr_vpa.elf
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 80baabe8f..07d297f61 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -51,16 +51,6 @@ start:
 	std	r0,0(r1)
 	std	r0,16(r1)
 
-	/*
-	 * Create entry frame of 64-bytes, same as the initial frame. A callee
-	 * may use the caller frame to store LR, and backtrace() termination
-	 * looks for return address == NULL, so the initial stack frame can't
-	 * be used to call C or else it could overwrite the zeroed LR save slot
-	 * and break backtrace termination.  This frame would be unnecessary if
-	 * backtrace looked for a zeroed frame address.
-	 */
-	stdu	r1,-64(r1)
-
 	/* save DTB pointer */
 	std	r3, 56(r1)
 
@@ -195,6 +185,7 @@ call_handler:
 	.endr
 	mfsprg1	r0
 	std	r0,GPR1(r1)
+	std	r0,0(r1) /* Backchain from interrupt stack to regular stack */
 
 	/* lr, xer, ccr */
 
@@ -213,12 +204,12 @@ call_handler:
 	subi	r31, r31, 0b - start_text
 	ld	r2, (p_toc_text - start_text)(r31)
 
-	/* FIXME: build stack frame */
-
 	/* call generic handler */
 
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_handle_exception
+	.global do_handle_exception_return
+do_handle_exception_return:
 
 	/* restore context */
 
-- 
2.43.0


