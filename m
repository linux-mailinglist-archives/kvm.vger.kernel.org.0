Return-Path: <kvm+bounces-12086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E318087F8A8
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12F911C21952
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9034554776;
	Tue, 19 Mar 2024 08:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G1whO2Ub"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D72B537E5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835213; cv=none; b=rxbA49kMK7kBOxLfeGT/sQ0o0e8UQLJb6S7aec4R4wEyqiEEWHYIBe09CvIDcrfKsELrS3/bjjO4zdAef1TSVqFBBfnFI/5BpPk1MSiLAW+joa8xCwDXSUe32myoatgX1kA/x3FqYs0oJSMsOiIEMNL/j+veRwtuI7gyZAI55aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835213; c=relaxed/simple;
	bh=qF/JNCdfCxstOUeyoHkpVuI+YCE8DPd24snj588zLeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bapi351dtEmSX0WVn7iSN3JtyPuAINt4K7VtLv+f/ENH6jFysEGLzEcDPzsZXjSvanhKZmGLwg9A7uAITyVZsDPNnVEe5ZZcyA8KFTS00w/0oj3eitaySejiTH+wlD6LHMGVaeUv7Pmp/U6hhuoR9Lr4KVkth6UgyDvXg0gCpvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G1whO2Ub; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e703e0e5deso2311891b3a.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835212; x=1711440012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Id22OkJ20G4vUjLZJ8P1mh+xH6ux/SpttyO50Hmp/l8=;
        b=G1whO2UbCGGei1sNMDMAHRaXOM39PEgq9oItoqzzgRfAB9RKzp8zJc3Xld3Ewmji+Q
         EcjJvA8IWZ4lwbl4am7RudLgDXX93Eqo90VcTGjo4dilXeuyuc8hPqOdAK5sSEFkLk7d
         WpQD8EZ4v2sfC/qoHOZ60PHe+nGj6tNT13A5o437l0TuefVgqqKwskqg37rdF5/G3yg7
         tDLQ/mysK0GcPlObkT+n5rsWlqtciTVrFSbTeWVid+sGS8V9LXMPPPoxr86ZKLP/JzZV
         nJoSLieMlCB2uhkY5Ygm9qByC1vBXNtW7Rb91h0mKM1iLvSSWkP9dhCa+BaV91w563z5
         cDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835212; x=1711440012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id22OkJ20G4vUjLZJ8P1mh+xH6ux/SpttyO50Hmp/l8=;
        b=TY/eU0mub5XTXIAKVe207wXPTCfFRyALNsO3nE9zqFkTCd+Blt8LOGuX12cYDEakKW
         +kpGS+XS1FZHEJWoDe6Z/cGIGn2PpAh08gC4u22wT360jxYMpNs5Oar8skkfA0aD6zKA
         Z01T0ZiP1DH+jm+7bFwL5KsZ4d+RfYUqR7NyT/zKARIU2u3BkD100dE3nYPKZB34YaPj
         fWtAgPvFNF2FbSSdDcfLe2eTTE6+kpMfir/upYpB+aFugOwQMYtcY82LTQkiTGRsAXAo
         AIyLmrBKjTy0HTpJsOQq3PYu48+b+9Q6Yi3PGAUKOzhuS13i6m1ZLaVnXgZ9P3evkP8i
         dcqw==
X-Forwarded-Encrypted: i=1; AJvYcCVgqVyOZAvtW5eMLey8OPmB5RlQmOQALg4ALjn9cmWG2ERkZ5mn1HhKTcQxsekwC2eUhQgL8oZp+kccp27HlU29em/q
X-Gm-Message-State: AOJu0YxujDrYaERL3BLxJwSchecN2VYKYUFvVhg0WQzYlGZoT89D9uO7
	lQ4EgRDdKCgNAMw6UowGDE9yTXbAk2ZDPuebDrbwoe2qiMiz+W+/qlN6maPeXjU=
X-Google-Smtp-Source: AGHT+IGSKzI6HlMM56ySu6oApKoM2roAqmMSDxssn9agceD2FwP7QjLSmoGGDgkqwBmJ7cIf+3cy2A==
X-Received: by 2002:aa7:8883:0:b0:6e6:b32c:501d with SMTP id z3-20020aa78883000000b006e6b32c501dmr15756831pfe.19.1710835211651;
        Tue, 19 Mar 2024 01:00:11 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:00:11 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 10/35] powerpc: interrupt stack backtracing
Date: Tue, 19 Mar 2024 17:59:01 +1000
Message-ID: <20240319075926.2422707-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
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
2.42.0


