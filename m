Return-Path: <kvm+bounces-32427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7469A9D84E3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07A27168D1B
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D03B194147;
	Mon, 25 Nov 2024 11:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wsjrKRMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD7F19CC2D
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535751; cv=none; b=ICc2v2yneSIYMyRCF/qVcY7Ktr/gaKdxcy5pdfcHEYd1nZiltyJKMXdgxd/9X9wRd+ENvNtKN5IVfk+ZuCARfHo3o8UmF1BgP4OLjtX1mvfRfOUv8cudTdU/LwNnjU+hF79TgCJIMwXqj6feqX/JcidbJMQXNq7Pay9OJTnOo3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535751; c=relaxed/simple;
	bh=U0j/4m03LrQWNU+F19IMmGQSwEN+ltA+hSnk3LnEx8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cl6qbL582RW486bqr2q4gVNC/CVwO/mWTWLY5U+oO5eCQUFWpids4ZguhvBDToqOw4GsF50X+O+9FPqY0CU1Iu7mwERgalnGD4GISiyNx0+/w6oHrVX+XNflSC0jNOUmN+bkqXFgB4fafNwUsy87+NTfLQPUsPms7fOXiwoZOL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wsjrKRMe; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-382423e1f7aso3071554f8f.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 03:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732535747; x=1733140547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0pL7DZeVqFb0E46nCkbY+Ov7yPQu6RWmvxXHMwPvAc=;
        b=wsjrKRMeh1Zc9Bjt7AUw1lOqr7rDYsSObA7GH4ZMb/ozbRk6v4qP/7zSwEulFQTg7q
         Qxx0kGzjNpO4NcVeAG8yh5rCw2vvfbyuLYwJ8bf8fJ9D/ZT0kUyHkytE/umCDzgrgdST
         SH6w385FCkNJOT0Ajtydo+nw2MzA2kwQD6k169AOI0DqNX5hiXiaucQMo9ite7TLLjBR
         qY3DoSctS7o+wmVT5bYUZ8TjDERUveMOTzg8u3/mw8JwPbmuprIHGTgaY5C6967Yu7kN
         k/L5gpGjJ8xcDfpvzjCMsVBNLkc+Wb0UCOULMbeds8zYNgqYbAufkVCSw+JsvPdABw5y
         MqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535747; x=1733140547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0pL7DZeVqFb0E46nCkbY+Ov7yPQu6RWmvxXHMwPvAc=;
        b=Qxef/4soLpn7bl690dGj67SqtqEqBFzmqecMuglMOUbjuzg61NM1AW2z0XILT7C6lq
         p0LgWVAq2ui05AsHEqgonyGXXIOd28aWR83ezIK1EnZ45vkKRxXPy7Iqu95CWJd0Vg3h
         dJLo9JpixluOST2toXSbSeemU/YNvlAAblXOUcw0mC5ueEE21fhH0zBJuLRW5HTPWI30
         ci4lNVSqAeBEFlB930P2ukBAH7ktyLyktVMs6KFXdSv4AZvZVsYA76CP9U7yiGYfHkwF
         oQi2oydlmpfIPr8lZVbBwTpQnB0eByunNdqTBcJEC6+WHeEtImEo+UZwWgPudP17Hx1Y
         c+eA==
X-Gm-Message-State: AOJu0YwsLJP9DcmYYRcxxH+D4gcrwNTCbF7RHwjv6IlbEasptSBAFWQk
	lpqPs6+Tu8kyz+47tCeVgT9rvk65GBkY6dH2acf2LEfGeN6oo9TE7Q5RuyJV2cDviz1IHc/c3AI
	C
X-Gm-Gg: ASbGncscXMk3IPeHw5Wmw3c+za4R5u6jHf3D2IuqcMMZmYV4c5Hwb77d+XMdLTfBGPX
	f2OHBCglWDUWU96TPhp+4P44N4M5hTKs05hXKT4l6djelqbJunlymYtvnEGF0OAVtpQ9RYtpzCa
	ytnR9qB9ppyVRYJxlbjU7hScGFcxfFwaZqnp8hqos7JI0VKu3mXpIUl+tT1qzsXt/96iR7DzBbI
	tFW6ZFOiCmJ63Jvl70NTARQnR7XktVTXFNk7h8KNLHFR/wTqpQ=
X-Google-Smtp-Source: AGHT+IHGm4wPmy7o0WP1T/lSMvy50LCOdpTo7KB6T7cXN02HfKrLI6HA2XfsbLaUCHmLG4dL2T7f6w==
X-Received: by 2002:a5d:6da8:0:b0:382:5137:30eb with SMTP id ffacd0b85a97d-38260b44b6amr7941202f8f.8.1732535747011;
        Mon, 25 Nov 2024 03:55:47 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3dfasm10546938f8f.76.2024.11.25.03.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 03:55:45 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v3 3/4] riscv: lib: Add SSE assembly entry handling
Date: Mon, 25 Nov 2024 12:54:47 +0100
Message-ID: <20241125115452.1255745-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115452.1255745-1-cleger@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a SSE entry assembly code to handle SSE events. Events should be
registered with a struct sse_handler_arg containing a correct stack and
handler function.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 riscv/Makefile          |   1 +
 lib/riscv/asm/sse.h     |  16 +++++++
 lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/asm-offsets.c |   9 ++++
 4 files changed, 126 insertions(+)
 create mode 100644 lib/riscv/asm/sse.h
 create mode 100644 lib/riscv/sse-entry.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 5b5e157c..c278ec5c 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -41,6 +41,7 @@ cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setjmp.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
+cflatobjs += lib/riscv/sse-entry.o
 cflatobjs += lib/riscv/stack.o
 cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
new file mode 100644
index 00000000..557f6680
--- /dev/null
+++ b/lib/riscv/asm/sse.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_SSE_H_
+#define _ASMRISCV_SSE_H_
+
+typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
+
+struct sse_handler_arg {
+	unsigned long reg_tmp;
+	sse_handler_fn handler;
+	void *handler_data;
+	void *stack;
+};
+
+extern void sse_entry(void);
+
+#endif /* _ASMRISCV_SSE_H_ */
diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
new file mode 100644
index 00000000..f1244e17
--- /dev/null
+++ b/lib/riscv/sse-entry.S
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * SBI SSE entry code
+ *
+ * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+
+.global sse_entry
+sse_entry:
+	/* Save stack temporarily */
+	REG_S sp, SSE_REG_TMP(a7)
+	/* Set entry stack */
+	REG_L sp, SSE_HANDLER_STACK(a7)
+
+	addi sp, sp, -(PT_SIZE)
+	REG_S ra, PT_RA(sp)
+	REG_S s0, PT_S0(sp)
+	REG_S s1, PT_S1(sp)
+	REG_S s2, PT_S2(sp)
+	REG_S s3, PT_S3(sp)
+	REG_S s4, PT_S4(sp)
+	REG_S s5, PT_S5(sp)
+	REG_S s6, PT_S6(sp)
+	REG_S s7, PT_S7(sp)
+	REG_S s8, PT_S8(sp)
+	REG_S s9, PT_S9(sp)
+	REG_S s10, PT_S10(sp)
+	REG_S s11, PT_S11(sp)
+	REG_S tp, PT_TP(sp)
+	REG_S t0, PT_T0(sp)
+	REG_S t1, PT_T1(sp)
+	REG_S t2, PT_T2(sp)
+	REG_S t3, PT_T3(sp)
+	REG_S t4, PT_T4(sp)
+	REG_S t5, PT_T5(sp)
+	REG_S t6, PT_T6(sp)
+	REG_S gp, PT_GP(sp)
+	REG_S a0, PT_A0(sp)
+	REG_S a1, PT_A1(sp)
+	REG_S a2, PT_A2(sp)
+	REG_S a3, PT_A3(sp)
+	REG_S a4, PT_A4(sp)
+	REG_S a5, PT_A5(sp)
+	csrr a1, CSR_SEPC
+	REG_S a1, PT_EPC(sp)
+	csrr a2, CSR_SSTATUS
+	REG_S a2, PT_STATUS(sp)
+
+	REG_L a0, SSE_REG_TMP(a7)
+	REG_S a0, PT_SP(sp)
+
+	REG_L t0, SSE_HANDLER(a7)
+	REG_L a0, SSE_HANDLER_DATA(a7)
+	mv a1, sp
+	mv a2, a6
+	jalr t0
+
+
+	REG_L a1, PT_EPC(sp)
+	REG_L a2, PT_STATUS(sp)
+	csrw CSR_SEPC, a1
+	csrw CSR_SSTATUS, a2
+
+	REG_L ra, PT_RA(sp)
+	REG_L s0, PT_S0(sp)
+	REG_L s1, PT_S1(sp)
+	REG_L s2, PT_S2(sp)
+	REG_L s3, PT_S3(sp)
+	REG_L s4, PT_S4(sp)
+	REG_L s5, PT_S5(sp)
+	REG_L s6, PT_S6(sp)
+	REG_L s7, PT_S7(sp)
+	REG_L s8, PT_S8(sp)
+	REG_L s9, PT_S9(sp)
+	REG_L s10, PT_S10(sp)
+	REG_L s11, PT_S11(sp)
+	REG_L tp, PT_TP(sp)
+	REG_L t0, PT_T0(sp)
+	REG_L t1, PT_T1(sp)
+	REG_L t2, PT_T2(sp)
+	REG_L t3, PT_T3(sp)
+	REG_L t4, PT_T4(sp)
+	REG_L t5, PT_T5(sp)
+	REG_L t6, PT_T6(sp)
+	REG_L gp, PT_GP(sp)
+	REG_L a0, PT_A0(sp)
+	REG_L a1, PT_A1(sp)
+	REG_L a2, PT_A2(sp)
+	REG_L a3, PT_A3(sp)
+	REG_L a4, PT_A4(sp)
+	REG_L a5, PT_A5(sp)
+
+	REG_L sp, PT_SP(sp)
+
+	li a7, ASM_SBI_EXT_SSE
+	li a6, ASM_SBI_EXT_SSE_COMPLETE
+	ecall
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 6c511c14..b3465eeb 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -3,7 +3,9 @@
 #include <elf.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
+#include <asm/sbi.h>
 #include <asm/smp.h>
+#include <asm/sse.h>
 
 int main(void)
 {
@@ -63,5 +65,12 @@ int main(void)
 	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
 	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
 
+	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
+	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
+	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
+	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
+	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
+	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
+
 	return 0;
 }
-- 
2.45.2


