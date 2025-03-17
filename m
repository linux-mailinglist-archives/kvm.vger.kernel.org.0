Return-Path: <kvm+bounces-41256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64956A65944
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE7763B8B76
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61603201278;
	Mon, 17 Mar 2025 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IIrLA7Hc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DEC1FDA97
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742230189; cv=none; b=Ke9eB8Y+ZH+fczqXXFhSFVFkT9D40Ogh18nQhjg+OvsbaS1GgyNzO2BrAvJ0PbCDZHYZ2w11F6bJHNfrxwiP/e1ctM2HH+GJv8T8vw2WEil6dHd2WspK/omCHSpwfOTblm2MPQfFV8M8MWfzekI1YmfDTdYQDSVkERGk+bSS7Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742230189; c=relaxed/simple;
	bh=uF3mfZjmnDnZaGpIFDZ5IDryR0AoTzZib3uhCPDmK74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urPRgBrJHdiVtbJqxohNPeqSxnqnpK1rLxopcp4H1OyHwvnjtCHjMKlBd4jCOgockYe4F+TV7GrEitNi6NK//p9M8V/afrmmmUf8+KE1EKOJep+bgvyYGFt+Ufk29tJh7pXHHwWTxjEdaNoyI3tKHxWvmMQCZgycKcRAYlS8l3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IIrLA7Hc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3996af42857so262211f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742230185; x=1742834985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYexuJef8iSxQJs9u8LwoW6NNtTyZSJjbz+yXgK8VL0=;
        b=IIrLA7Hc4t0NiO/VQGn+bOyca/BWzsb88m1x0iFs4tc4w/YfYNT+Ff9dvkO8j4dBTM
         9DH9AEjsvtCdB/kIPr29zFstfVwCuRluWOl8FC8zLyfoJ0BVzgK61EIHVTfcGuAKhiaD
         8oEaoRGAcFExWimW2xY+RbYEi1osEk2pr5vXcoEsYtHU0SkppCNdTl8WB0Oe6Tqhbjrt
         zlv8KFYtYAcXxr+PboqSsk/ulKMdILl+oHVBnLKhmy23xzCOFLS5vlIzMT4GNQl+U+zU
         SZONlPfIvGHdobeAH9vlaMCg6q8AHpeUSkoRTjr3pKYj38tjgPIMRQVXtK6cYJ772djr
         I4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742230185; x=1742834985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYexuJef8iSxQJs9u8LwoW6NNtTyZSJjbz+yXgK8VL0=;
        b=dAJrhNL7ZBhvnYbOnT2Iy9YquxFRmVahu2gpu/uBbvz9Lh3WHbz3UCkEZitgwzqAbl
         JJtpk61mT7Ii1cM3ujBt37pyKdzxTetqUPUAvr2QBnEmemmIviGuyZ1KPsizUC7QnOBp
         jnTKoHLAqy6TcbbMsBTNs+QUJCzpAqVXZP25kOT1JCwBgVQ6EKZj2+uU/A+1grfeG1nt
         yECbsLtgcTc9a0kZL4Hr1WQVDfR6GhxO3/jrYJg+3SVvzxieCS/hCd6UxnmePAlrbASa
         /3qF7iYKyeHQGxW4QZLf4SFEQ/VVYW/U/o/gDscOVtKLGAzgNyHvCgP40MC1tRlQHvje
         NUfA==
X-Gm-Message-State: AOJu0YyWM9RjYw5OVK3tXBFomABwBLnrl2RllaLv2Hw8ihtHQf4yihzY
	lAea8wKMSx7K+2lbz+5gqtCx3kSZtTJ5CEmT8v4+zbRDkPfg4NKSSodsNmtA+8wRb0Fr/jY2Pon
	kFEs=
X-Gm-Gg: ASbGnctdIWBTy/zys51ByaOkFxlXZ4xENcHUjOwJDnb6Wmecr8bHfvtcg/TvBAULVgS
	45kZ5GIlJlw3l1tMVdcVrnmhOtV0ftS+ItbvWvJR7U57d+NUqQcZaeX5AvjqM0nnw/f/ILa/xEp
	mHIun2sBQbk+eil88iRz/hf7bpDrRnmhmzVdCJKRox7Vc3/At6zWpeAwmvcajqIDzNolQlKyfME
	5cKAf1uMvbsa1DRE73Ct5GmAZqXFQWOkVWacWa2WRSEJ5NtplXWxXoBGGlesn8geLC9/MNIh3jX
	08Yikt09K8u1gVFP18zJDrLkfwMsYEQvFHbwifxHq/eMSQ==
X-Google-Smtp-Source: AGHT+IHHFiR8TDVO8Z0utZLApLX2q2XNoVKpFETrQAX7c+Rzmg/kSdXRX15MyZnZfeoC2Ui+sqxbsA==
X-Received: by 2002:a5d:64a9:0:b0:390:f116:d220 with SMTP id ffacd0b85a97d-3996ba4a335mr151219f8f.17.1742230185409;
        Mon, 17 Mar 2025 09:49:45 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a80sm15785845f8f.61.2025.03.17.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 09:49:44 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH v11 7/8] lib: riscv: Add SBI SSE support
Date: Mon, 17 Mar 2025 17:46:52 +0100
Message-ID: <20250317164655.1120015-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for registering and handling SSE events. This will be used
for sbi tests as well as upcoming double trap tests.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile          |   1 +
 lib/riscv/asm/csr.h     |   1 +
 lib/riscv/asm/sbi.h     |  36 ++++++++++++++
 lib/riscv/sbi-sse-asm.S | 102 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/asm-offsets.c |   9 ++++
 lib/riscv/sbi.c         |  76 ++++++++++++++++++++++++++++++
 6 files changed, 225 insertions(+)
 create mode 100644 lib/riscv/sbi-sse-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 02d2ac39..16fc125b 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
 cflatobjs += lib/riscv/stack.o
 cflatobjs += lib/riscv/timer.o
+cflatobjs += lib/riscv/sbi-sse-asm.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index c7fc87a9..3e4b5fca 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -17,6 +17,7 @@
 #define CSR_TIME		0xc01
 
 #define SR_SIE			_AC(0x00000002, UL)
+#define SR_SPP			_AC(0x00000100, UL)
 
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 887a4cd4..ad5f50de 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -265,5 +265,41 @@ unsigned long sbi_get_imp_version(void);
 unsigned long sbi_get_imp_id(void);
 long sbi_probe(int ext);
 
+typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
+
+struct sbi_sse_handler_arg {
+	unsigned long reg_tmp;
+	sbi_sse_handler_fn handler;
+	void *handler_data;
+	void *stack;
+};
+
+extern void sbi_sse_entry(void);
+
+static inline bool sbi_sse_event_is_global(uint32_t event_id)
+{
+	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
+}
+
+struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				     unsigned long attr_count, unsigned long phys_lo,
+				     unsigned long phys_hi);
+struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
+				 unsigned long attr_count, unsigned long *values);
+struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				      unsigned long attr_count, unsigned long phys_lo,
+				      unsigned long phys_hi);
+struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
+				  unsigned long attr_count, unsigned long *values);
+struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
+				   unsigned long entry_arg);
+struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg);
+struct sbiret sbi_sse_unregister(unsigned long event_id);
+struct sbiret sbi_sse_enable(unsigned long event_id);
+struct sbiret sbi_sse_disable(unsigned long event_id);
+struct sbiret sbi_sse_hart_mask(void);
+struct sbiret sbi_sse_hart_unmask(void);
+struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
+
 #endif /* !__ASSEMBLER__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi-sse-asm.S b/lib/riscv/sbi-sse-asm.S
new file mode 100644
index 00000000..b9e951f5
--- /dev/null
+++ b/lib/riscv/sbi-sse-asm.S
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * RISC-V SSE events entry point.
+ *
+ * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
+ */
+#include <asm/asm.h>
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+#include <generated/sbi-asm-offsets.h>
+
+.section .text
+.global sbi_sse_entry
+sbi_sse_entry:
+	/* Save stack temporarily */
+	REG_S	sp, SBI_SSE_REG_TMP(a7)
+	/* Set entry stack */
+	REG_L	sp, SBI_SSE_HANDLER_STACK(a7)
+
+	addi	sp, sp, -(PT_SIZE)
+	REG_S	ra, PT_RA(sp)
+	REG_S	s0, PT_S0(sp)
+	REG_S	s1, PT_S1(sp)
+	REG_S	s2, PT_S2(sp)
+	REG_S	s3, PT_S3(sp)
+	REG_S	s4, PT_S4(sp)
+	REG_S	s5, PT_S5(sp)
+	REG_S	s6, PT_S6(sp)
+	REG_S	s7, PT_S7(sp)
+	REG_S	s8, PT_S8(sp)
+	REG_S	s9, PT_S9(sp)
+	REG_S	s10, PT_S10(sp)
+	REG_S	s11, PT_S11(sp)
+	REG_S	tp, PT_TP(sp)
+	REG_S	t0, PT_T0(sp)
+	REG_S	t1, PT_T1(sp)
+	REG_S	t2, PT_T2(sp)
+	REG_S	t3, PT_T3(sp)
+	REG_S	t4, PT_T4(sp)
+	REG_S	t5, PT_T5(sp)
+	REG_S	t6, PT_T6(sp)
+	REG_S	gp, PT_GP(sp)
+	REG_S	a0, PT_A0(sp)
+	REG_S	a1, PT_A1(sp)
+	REG_S	a2, PT_A2(sp)
+	REG_S	a3, PT_A3(sp)
+	REG_S	a4, PT_A4(sp)
+	REG_S	a5, PT_A5(sp)
+	csrr	a1, CSR_SEPC
+	REG_S	a1, PT_EPC(sp)
+	csrr	a2, CSR_SSTATUS
+	REG_S	a2, PT_STATUS(sp)
+
+	REG_L	a0, SBI_SSE_REG_TMP(a7)
+	REG_S	a0, PT_SP(sp)
+
+	REG_L	t0, SBI_SSE_HANDLER(a7)
+	REG_L	a0, SBI_SSE_HANDLER_DATA(a7)
+	mv	a1, sp
+	mv	a2, a6
+	jalr	t0
+
+	REG_L	a1, PT_EPC(sp)
+	REG_L	a2, PT_STATUS(sp)
+	csrw	CSR_SEPC, a1
+	csrw	CSR_SSTATUS, a2
+
+	REG_L	ra, PT_RA(sp)
+	REG_L	s0, PT_S0(sp)
+	REG_L	s1, PT_S1(sp)
+	REG_L	s2, PT_S2(sp)
+	REG_L	s3, PT_S3(sp)
+	REG_L	s4, PT_S4(sp)
+	REG_L	s5, PT_S5(sp)
+	REG_L	s6, PT_S6(sp)
+	REG_L	s7, PT_S7(sp)
+	REG_L	s8, PT_S8(sp)
+	REG_L	s9, PT_S9(sp)
+	REG_L	s10, PT_S10(sp)
+	REG_L	s11, PT_S11(sp)
+	REG_L	tp, PT_TP(sp)
+	REG_L	t0, PT_T0(sp)
+	REG_L	t1, PT_T1(sp)
+	REG_L	t2, PT_T2(sp)
+	REG_L	t3, PT_T3(sp)
+	REG_L	t4, PT_T4(sp)
+	REG_L	t5, PT_T5(sp)
+	REG_L	t6, PT_T6(sp)
+	REG_L	gp, PT_GP(sp)
+	REG_L	a0, PT_A0(sp)
+	REG_L	a1, PT_A1(sp)
+	REG_L	a2, PT_A2(sp)
+	REG_L	a3, PT_A3(sp)
+	REG_L	a4, PT_A4(sp)
+	REG_L	a5, PT_A5(sp)
+
+	REG_L	sp, PT_SP(sp)
+
+	li	a7, ASM_SBI_EXT_SSE
+	li	a6, ASM_SBI_EXT_SSE_COMPLETE
+	ecall
+
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 6c511c14..a96c6e97 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -3,6 +3,7 @@
 #include <elf.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
+#include <asm/sbi.h>
 #include <asm/smp.h>
 
 int main(void)
@@ -63,5 +64,13 @@ int main(void)
 	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
 	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
 
+	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
+	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
+
+	OFFSET(SBI_SSE_REG_TMP, sbi_sse_handler_arg, reg_tmp);
+	OFFSET(SBI_SSE_HANDLER, sbi_sse_handler_arg, handler);
+	OFFSET(SBI_SSE_HANDLER_DATA, sbi_sse_handler_arg, handler_data);
+	OFFSET(SBI_SSE_HANDLER_STACK, sbi_sse_handler_arg, stack);
+
 	return 0;
 }
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index ab032e3e..53d25489 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -2,6 +2,7 @@
 #include <libcflat.h>
 #include <cpumask.h>
 #include <limits.h>
+#include <asm/io.h>
 #include <asm/sbi.h>
 #include <asm/setup.h>
 
@@ -31,6 +32,81 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 	return ret;
 }
 
+struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				     unsigned long attr_count, unsigned long phys_lo,
+				     unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
+				 unsigned long attr_count, unsigned long *values)
+{
+	phys_addr_t p = virt_to_phys(values);
+
+	return sbi_sse_read_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
+				      upper_32_bits(p));
+}
+
+struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
+				      unsigned long attr_count, unsigned long phys_lo,
+				      unsigned long phys_hi)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
+			 phys_lo, phys_hi, 0);
+}
+
+struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
+				  unsigned long attr_count, unsigned long *values)
+{
+	phys_addr_t p = virt_to_phys(values);
+
+	return sbi_sse_write_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
+				       upper_32_bits(p));
+}
+
+struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
+				   unsigned long entry_arg)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, entry_pc, entry_arg, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg)
+{
+	return sbi_sse_register_raw(event_id, (unsigned long)sbi_sse_entry, (unsigned long)arg);
+}
+
+struct sbiret sbi_sse_unregister(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_enable(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_disable(unsigned long event_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_hart_mask(void)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_hart_unmask(void)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
+{
+	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
+}
+
 void sbi_shutdown(void)
 {
 	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
-- 
2.47.2


