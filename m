Return-Path: <kvm+bounces-32361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 518029D601E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10AFC2815BF
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 14:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574696F099;
	Fri, 22 Nov 2024 14:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vAGunA7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2192D638
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732284328; cv=none; b=ugBY/T7q9Sk6zD0x93TiI+RUxFg9ynmzbutdavF0/p0mQLM/eDFBCd1vBVp4phVuOlNhJ1agZgQDlTYU5VB6V59LdCJxz7Jcs7wF/UprGb/uk9uhKppQ1KLnyp4tJ6L+b5WVFh8CX9HMysHrreuz2YdalX0kwFOoSUPrkTkjn6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732284328; c=relaxed/simple;
	bh=bbpGAcDiqxV2EuR31qx9/tFH64tju+uAETnFe+Thqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6FmnNt2xx/CeN+XRuTSF/F0yX0MNo+cf5vZfxjTf9NMHzjpplqHv1NaZaovbNjMF8TiA4q7mS8HB/eddPyLxHgUqPqnPz7cje9h5CdT4bClRqJCQHbgsUP5yNTVNOFSH8xcE0MxTcLZEEZtMBOi0WduGOsn5MqvqOCV035pbiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vAGunA7j; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ea4e9e6ef2so1731436a91.1
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 06:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732284325; x=1732889125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O4OIEUQmgXgTu/PFerCWC+6K9d8N2ABOucwqNnJ620=;
        b=vAGunA7jmFDtulH4ey5uH10WScnG9+1ZSlO+yuH060I7315NfXr5In7rOMihVeMaCH
         ajNyMBEvRQINFHehvvExtQ2cmaB3fd0tVTGupX6YHps1AA4NEKp7dkZtaJe1eLK5Vd8/
         V6JbmmQel6j1KNVYNTG01076SxhSoWzluPOG0cRxeG0F0b1+it6LIn8qCZNVXTpClPSB
         ITm5GRidHJ+ofOZdOi077sugv+oZpbWEVAcudDX8qld5dO1QNCbFviX1P4b5ufrp8Pef
         2R9MAdv50Nj6cQm/uVQVXIcmzVNicCkEYJQvn2gDo+5BEI+67VkqLZQcpQQlGQuFrH2A
         qCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732284325; x=1732889125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3O4OIEUQmgXgTu/PFerCWC+6K9d8N2ABOucwqNnJ620=;
        b=apjw6ndwyiAYK6Iq+k31TsgofU6TXGeZYU7jdpPItWv3dWKMNSLpeAWt1XrDRozP3o
         BGZEYowRkczPFAsoX5jlkww/xnMcVdwZKvVO9+8Sx1dcmYkPVR5Zz0iZRZ7LfhfmuptQ
         Vro0QmYcHXdH3BjmXusRB+DifvH96IZOZ0eq3tG64nYO2WOKLlJPPnnRp3y6YNUrZezU
         XRWQm+OKNN/FLH7a9qlDdPxmE3IQXu/thcCTLlu8S3Wghmt54eLYnIRlOgaGxOdhV60E
         fKCmVqpYO7FYInwjLIRJqDxtfVgt8Sk141+1SAtHXucMlo2zNd1TAoHd3hudfiJAW0Sh
         bGhQ==
X-Gm-Message-State: AOJu0Yx+RmM53Lt9PDh2oGoBy+4jTESr8rd5gLcTcHOhPsNZ+8AyYx6f
	ZE2NFgpuEoVOEDTayNXfheF+tH0qflwJjCwpaVYeUX5POJYMW1Jsczd4vuFXnW06N1WWFkTszcK
	A
X-Gm-Gg: ASbGnculy7MQ7r5Sv3CViP30KhP6vKDoPUYp9O+ToRgt4vjHMzNXqTJsFO4SEKqSvdi
	/hwMMYkVg0cTqQM6VdvULPFcnGJHmzcUAZYxmBpDIXbhxw3jKhFprZGtisoIur52ng/Zy/Wt6CZ
	8oXq/L/AjHOqv2SSdQVC9YvM7yGfxtX6iQgJvTa+ym2aomO48D+XpUizQvEMa6Pa7XAkMlx+YEk
	+29Fi2u+y8hnVtOo+wt1LyDCKNpAPFcqU3yxl6KC96ppv2C/CY=
X-Google-Smtp-Source: AGHT+IGxyigCrewnxXGmvhZ1ihtxeyzR+aqWkPSkcJO9wwAx707Bl/gllEwZ14wNE9hE/4cOR3X62w==
X-Received: by 2002:a17:90b:1651:b0:2ea:819e:9140 with SMTP id 98e67ed59e1d1-2eb0e85cd89mr3286093a91.24.1732284325142;
        Fri, 22 Nov 2024 06:05:25 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ead04d2b9dsm5153370a91.33.2024.11.22.06.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 06:05:24 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH v2 2/3] riscv: lib: Add SSE assembly entry handling
Date: Fri, 22 Nov 2024 15:04:56 +0100
Message-ID: <20241122140459.566306-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122140459.566306-1-cleger@rivosinc.com>
References: <20241122140459.566306-1-cleger@rivosinc.com>
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
index 28b04156..e50621ad 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -39,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
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
index 00000000..bedc47e9
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
+	REG_S sp, SSE_REG_TMP(a6)
+	/* Set entry stack */
+	REG_L sp, SSE_HANDLER_STACK(a6)
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
+	REG_L a0, SSE_REG_TMP(a6)
+	REG_S a0, PT_SP(sp)
+
+	REG_L t0, SSE_HANDLER(a6)
+	REG_L a0, SSE_HANDLER_DATA(a6)
+	move a1, sp
+	move a2, a7
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


