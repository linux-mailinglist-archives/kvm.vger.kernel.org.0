Return-Path: <kvm+bounces-9808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D778670DA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5618A1C2863B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BAA5B5BF;
	Mon, 26 Feb 2024 10:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f20sk4WN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFE15B1F2
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942372; cv=none; b=bMwRAHsYkD1cOUWoHnKmZOn/UTvWO0N0SL3FaCyZ3nOuMBe7ei4H7ItoW4V3qypWq4OK/espmCB2/tqaHtMmMb7Dq3wCFjW71T0rAA/w/h1XqXzJPZEARtDTfCwh5GqDu5KzfBJlJt//cpD3TO16yd4iIfNoqYvTzmNX6snFcQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942372; c=relaxed/simple;
	bh=MSN0YC1+feeVN7Zt2LmnOYnScKJ6lqtFSZWjeKj4Wtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOle2SAMo1B+IvLm3YS/nGaXO35mckLvn744FFdDoITB+ChafGfuPfEvbq2AWIMu2W7jWSG7rBrYcK7TyXAr3JuhCEj77/1ucOYwmEFraL60OHcUvnp5roqLy7LrTTZ2ZjLgpHQWvB67zrv1GI9BMssLLERysrnwIv02hFjJKLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f20sk4WN; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e432514155so1380266a34.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942370; x=1709547170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlPzJOA7yG26HKy83xR6jHIo02HYDiPlSn1sSTNjdtM=;
        b=f20sk4WNObXo3KKlAMU8Kpy9oqQ/s4Qxu7PtTuLPX7vVVmOay2A8HGx7n+s+PQkene
         iKhbISAa4PLzPBqklwhDDMSC0j5p4Pa+ymHt4h+gNLafPdVWmUiRo/SCjw7tZWaLcbP5
         4KmQC1zVBzYOlS8x0ue7j1BbBp5K5Ns9zJWXY5oBPA03GqjZwsrDsLQKsKxPJqNdeZdj
         itVZ3eVLb4q3pIGkJF4DOb9jeJ6tj6L18Vist88T1oLSPQTOraCAXeuhlaIpy2+XGLD6
         VcZUCXWPPAXKzsDVEZN2BWeFJfO+PD7V64sb/B2CdNPxaFXGGdoxX8Ud0e3Ipd0kDat0
         frJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942370; x=1709547170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlPzJOA7yG26HKy83xR6jHIo02HYDiPlSn1sSTNjdtM=;
        b=KsUx21a9SYueMLVO4R1WGKbmSXPnsbsNJUCzSl5/ILQxROWJEgDW4Gi0vbed56axnv
         Be8HclfCj178aYnPx0JwjtefcB702Hbk4MaFaAmrWEZw29QlDyaNE58wRKRpCwbS4han
         IOXhvOuKcpFutcC5t7Rl2g5hVsVfg0JFIGCALnu5CmHZZX8V48YIFPwNADmm/OjV7rIC
         y3Lkb/jQaSpLltvmVr+JEAHpJb55QMgIOYeuTjQgdHyZxFo7i+d3GVDMMem6Cuwvjs1h
         w8O8ZpNaGuDYB1BHotuUSOkY0qpGohwXRHMqkUw/6x2a8SJVbB+zQTt1ntwXE88xSyds
         Pe2g==
X-Forwarded-Encrypted: i=1; AJvYcCUT11PpKGxtFNNiUnZcW4N+jRIj6vNqgyAbuSeFNmN1npsilZUvNYwT3sYAmlhQagiAcXogSLBUwjWVIvYcGi8CYIsK
X-Gm-Message-State: AOJu0YyTNT0RJqJcPcKje7mVaxSpi/4uWyCS2ZaIkvbeUNuQOLrYDfcN
	p+U+iqUEefwVdf+Pmddxdbw44/yNbClNxmCK3UEnDD6cQ4TQuoJv
X-Google-Smtp-Source: AGHT+IFBfl5Q5KisBGtiG/T5CPUrvfqxr0lnt67lRLOeWbmF4Tvfx58+qKE4sX88mI7p9rwb+lsj4Q==
X-Received: by 2002:a05:6358:6422:b0:178:b97c:f087 with SMTP id f34-20020a056358642200b00178b97cf087mr8211946rwh.15.1708942369673;
        Mon, 26 Feb 2024 02:12:49 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:12:49 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 04/32] powerpc: interrupt stack backtracing
Date: Mon, 26 Feb 2024 20:11:50 +1000
Message-ID: <20240226101218.1472843-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for backtracing across interrupt stacks, and
add interrupt frame backtrace for unhandled interrupts.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/processor.c |  4 ++-
 lib/ppc64/asm/stack.h   |  3 +++
 lib/ppc64/stack.c       | 55 +++++++++++++++++++++++++++++++++++++++++
 powerpc/Makefile.ppc64  |  1 +
 powerpc/cstart64.S      |  7 ++++--
 5 files changed, 67 insertions(+), 3 deletions(-)
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
index 000000000..fcb7fa860
--- /dev/null
+++ b/lib/ppc64/stack.c
@@ -0,0 +1,55 @@
+#include <libcflat.h>
+#include <asm/ptrace.h>
+#include <stack.h>
+
+extern char exception_stack_marker[];
+
+int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
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
+	bp = (unsigned long *)bp[0];
+	return_addr = (void *)bp[2];
+
+	for (depth = 0; bp && depth < max_depth; depth++) {
+		return_addrs[depth] = return_addr;
+		if (return_addrs[depth] == 0)
+			break;
+		if (return_addrs[depth] == exception_stack_marker) {
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
+
+int backtrace(const void **return_addrs, int max_depth)
+{
+	return backtrace_frame(__builtin_frame_address(0), return_addrs,
+			       max_depth);
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
index 14ab0c6c8..278af84a6 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -188,6 +188,7 @@ call_handler:
 	.endr
 	mfsprg1	r0
 	std	r0,GPR1(r1)
+	std	r0,0(r1)
 
 	/* lr, xer, ccr */
 
@@ -206,12 +207,12 @@ call_handler:
 	subi	r31, r31, 0b - start_text
 	ld	r2, (p_toc_text - start_text)(r31)
 
-	/* FIXME: build stack frame */
-
 	/* call generic handler */
 
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	do_handle_exception
+	.global exception_stack_marker
+exception_stack_marker:
 
 	/* restore context */
 
@@ -321,6 +322,7 @@ handler_trampoline:
 	/* nip and msr */
 	mfsrr0	r0
 	std	r0, _NIP(r1)
+	std	r0, INT_FRAME_SIZE+16(r1)
 
 	mfsrr1	r0
 	std	r0, _MSR(r1)
@@ -337,6 +339,7 @@ handler_htrampoline:
 	/* nip and msr */
 	mfspr	r0, SPR_HSRR0
 	std	r0, _NIP(r1)
+	std	r0, INT_FRAME_SIZE+16(r1)
 
 	mfspr	r0, SPR_HSRR1
 	std	r0, _MSR(r1)
-- 
2.42.0


