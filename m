Return-Path: <kvm+bounces-27238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B5497DCCC
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 12:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C6E1C20DF7
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 10:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203B416F265;
	Sat, 21 Sep 2024 10:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRXBgqdk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA0D7462
	for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 10:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913320; cv=none; b=Vm4U2Oni6Uj4UNksEJHDC5WUJK+eMnWObFjnYirYRO7uYC2f/u9hoY/dquipMEeqX/L7kV6dPyKGUm3Em7hRojNk+cMipENIb9bsfRaUClxqSsZOLPppOtV2DzQaPoEgYsy54It6xfxn32cjWhf4NshojGziFEslSlmf0ob3umM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913320; c=relaxed/simple;
	bh=pnN0wsT5QO1IWAGer83Fj0sSV3v3Hf7B4cXSIPuDRcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjfhdlBbiOblgxS9+1vDNP6WL4wQaW+92Jnfkxn+y8XYZIRz5GGyxCKVMRfh65eAPDkNY7lKluppvMxF+GulKty+WCc2bgkSbeG+96rwOi5WB2prM2ZbdUtfTcwz41coGSi93cRCJwosDu95UKu3oZIT9Y3KI9GoSmNBXYH3jrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRXBgqdk; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7cf5e179b68so2427318a12.1
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 03:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726913317; x=1727518117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJdVfx/CtG7GsoMRDoYaQc5sG4VZUAB77/RAuJ5eHsk=;
        b=BRXBgqdkp/j402MD2Ne927mj6p4NPGhf0gv8ZMUyvdMjZYFhuLe+6fWNWOeWqgU9MB
         BpT9SJU5vNaRDjqjTTzzxc1FzZ4CznkGZWvGLPkgot5zXw1Zf8JIis9gcVwurttChVHc
         KQwhtJKe2gG3suKJYQZQ12ziR3YX8URUVN01D9EleXzbK+1baprbIjMd3810XIIUTiMt
         PKtsNE8iNFpRWUBHrEt74Ti91MwLdgpPCW4908BB4GOIx0QvnRHxhNJL3Ijs0MlPF0EU
         rkolHfF5373VQbnFIl8Mefp4WnvW0RFcmb6VbjV8UDC8AmD6qrYaBkVH265drs6/OVEO
         tEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726913317; x=1727518117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJdVfx/CtG7GsoMRDoYaQc5sG4VZUAB77/RAuJ5eHsk=;
        b=M8uG3foZZ6I5bq0hZj+2klleDCZaVcth2paQEWQWaBAy38gsbJrQ2vOzqu+Hql3649
         x07+MnnMVgLozkxXyYn6pP2RMjP3hvY86Y56pU8yS08unDFJobS4V6PUw/i1LIMFcryt
         MrSGlZvHlcVPbYwF/feho6QQpKEReaqgsObWQrOzEDmJFCozfnXOPqMicYmeb6vUHrnv
         wEiHECnZYLxBK+W9ck/jng1F+4EqnyNdNpmshubtdEfR8CcKNoJL4k3lyw4xGoUGkhLf
         6AiBaLJgW+SBXBPYzI7TB2loV6ZnRxYpV/EfJaOH+TLreHyNQtbL/CwjlCNkZJVxwL65
         f4vA==
X-Gm-Message-State: AOJu0YzZn5iaG4QoTwD8PdrQbe87KMDWS+H1hoPORE9wxOdOWHQutWzX
	HS7Xsg1Eq4Q9ZS7xLxZTuHLWx9xezSoaBWXW7XKMHfvZNkOUyw9F4PXsqH2GG+Y=
X-Google-Smtp-Source: AGHT+IFtu3T1HLYQLvnDw2+j7zkRNFc+AqSVwVetbu/CGynIPlNRQSNPqI6+AkVybKDGMUU1fCsCZA==
X-Received: by 2002:a17:90b:1286:b0:2d8:7a63:f9c8 with SMTP id 98e67ed59e1d1-2dd6ce9b501mr14726309a91.14.1726913317187;
        Sat, 21 Sep 2024 03:08:37 -0700 (PDT)
Received: from JRT-PC.. ([203.116.176.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee7c03fsm5680024a91.11.2024.09.21.03.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 03:08:36 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 2/5] riscv: sbi: Provide entry point for HSM tests
Date: Sat, 21 Sep 2024 18:08:20 +0800
Message-ID: <20240921100824.151761-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240921100824.151761-1-jamestiotio@gmail.com>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The HSM tests will need to test HSM start and resumption from HSM
suspend. Provide an entry point written in assembly that doesn't
use a stack for this. Results of the test are written to global
per-hart arrays to be checked by the main SBI HSM test function. The
started/resumed hart does its checks and then just loops until it
gets a signal from the main SBI HSM test function to invoke HSM stop.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
Co-developed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile    |  3 +-
 riscv/sbi-tests.h | 10 +++++++
 riscv/sbi-asm.S   | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 riscv/sbi.c       |  5 ++++
 4 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi-tests.h
 create mode 100644 riscv/sbi-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 2ee7c5bb..4676d262 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
+cflatobjs += riscv/sbi-asm.o
 
 ########################################
 
@@ -80,7 +81,7 @@ CFLAGS += -mcmodel=medany
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
+CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
new file mode 100644
index 00000000..f5cc8635
--- /dev/null
+++ b/riscv/sbi-tests.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _RISCV_SBI_TESTS_H_
+#define _RISCV_SBI_TESTS_H_
+
+#define SBI_HSM_TEST_DONE	(1 << 0)
+#define SBI_HSM_TEST_HARTID_A1	(1 << 1)
+#define SBI_HSM_TEST_SATP	(1 << 2)
+#define SBI_HSM_TEST_SIE	(1 << 3)
+
+#endif /* _RISCV_SBI_TESTS_H_ */
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
new file mode 100644
index 00000000..f165f9da
--- /dev/null
+++ b/riscv/sbi-asm.S
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper assembly code routines for RISC-V SBI extension tests.
+ *
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#define __ASSEMBLY__
+#include <asm/csr.h>
+
+#include "sbi-tests.h"
+
+.section .text
+
+/*
+ * sbi_hsm_check
+ *   a0 and a1 are set by SBI HSM start/suspend
+ *   s1 is the address of the results array
+ * Doesn't return.
+ *
+ * This function is only called from HSM start and on resumption
+ * from HSM suspend which means we can do whatever we like with
+ * all registers. So, to avoid complicated register agreements with
+ * other assembly functions called, we just always use the saved
+ * registers for anything that should be maintained across calls.
+ */
+#define RESULTS_ARRAY	s1
+#define RESULTS_MAP	s2
+#define CPU_INDEX	s3
+.balign 4
+sbi_hsm_check:
+	li	RESULTS_MAP, 0
+	bne	a0, a1, 1f
+	ori	RESULTS_MAP, RESULTS_MAP, SBI_HSM_TEST_HARTID_A1
+1:	csrr	t0, CSR_SATP
+	bnez	t0, 2f
+	ori	RESULTS_MAP, RESULTS_MAP, SBI_HSM_TEST_SATP
+2:	csrr	t0, CSR_SSTATUS
+	andi	t0, t0, SR_SIE
+	bnez	t0, 3f
+	ori	RESULTS_MAP, RESULTS_MAP, SBI_HSM_TEST_SIE
+3:	call	hartid_to_cpu
+	mv	CPU_INDEX, a0
+	li	t0, -1
+	bne	CPU_INDEX, t0, 5f
+4:	pause
+	j	4b
+5:	ori	RESULTS_MAP, RESULTS_MAP, SBI_HSM_TEST_DONE
+	add	t0, RESULTS_ARRAY, CPU_INDEX
+	sb	RESULTS_MAP, 0(t0)
+	la	t1, sbi_hsm_stop_hart
+	add	t1, t1, CPU_INDEX
+6:	lb	t0, 0(t1)
+	pause
+	beqz	t0, 6b
+	li	a7, 0x48534d	/* SBI_EXT_HSM */
+	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
+	ecall
+7:	pause
+	j	7b
+
+.balign 4
+.global sbi_hsm_check_hart_start
+sbi_hsm_check_hart_start:
+	la	RESULTS_ARRAY, sbi_hsm_hart_start_checks
+	j	sbi_hsm_check
+
+.balign 4
+.global sbi_hsm_check_non_retentive_suspend
+sbi_hsm_check_non_retentive_suspend:
+	la	RESULTS_ARRAY, sbi_hsm_non_retentive_hart_suspend_checks
+	j	sbi_hsm_check
diff --git a/riscv/sbi.c b/riscv/sbi.c
index a7abc08c..b5147dee 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -18,6 +18,7 @@
 #include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 
@@ -429,6 +430,10 @@ static void check_dbcn(void)
 	report_prefix_popn(2);
 }
 
+unsigned char sbi_hsm_stop_hart[NR_CPUS];
+unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
+unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
-- 
2.43.0


