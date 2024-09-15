Return-Path: <kvm+bounces-26947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C6A597981D
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 20:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A601F2161F
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 18:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773091C9ED5;
	Sun, 15 Sep 2024 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORMi8w+x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15331C9ECF
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726425313; cv=none; b=jXtYThInIhVEPT6igXmY0/c3dL5/sIxEYsaWt9rcrDl5kRTdiA1ad4aYJ9BeE8NSdbz/OWSEuWD4vXwgLx7O1hZylpdFkMkUQUW/JoiAn8rXG7HKnc/SLm7anyIWV4++xNV4EtPzDYqbzZw6AbEcmpgyxNxHwIyktyYzMyTBq7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726425313; c=relaxed/simple;
	bh=uxyOVT2We6RxS5pitF5CRwoCJA7t9IkhBPykbJPGItc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZqunGjOQZD+lyPDNsxORLJYdoAI7n+zIYBYRLNSzkgZMtmjEYbqN9bumH8xhhJQ/F8HcH5i3hZlYY249XeQ4WsgYzqPdjqnVteX+JzexAXnPXuTi+IBOHYQaOrJF33yf3sBMrN8ZCa0hwP5hdW2DFQxa4FIzLtjvOWSWHCtcE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORMi8w+x; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-206e614953aso37824915ad.1
        for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 11:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726425310; x=1727030110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8eKKClr8hTX6nllVRY4mm+euC3yi1At6P9UopPGjNo=;
        b=ORMi8w+xlhy1GTf6G64n4D/r4ARtT9InjrWko9VDopMQPI/kUDx9PONuBNti5+hxnO
         zMsEBJIb6mA0q0jl2S/jixhWw+fBjTxDseiPXX4cnSiOEcwsNrDfn+iqLKz91O8YJzul
         xFpoWmPwKVjBmMPF60gkoVZGXoGTq4yRI/OKVPQdVlcerQVtJvk2QKmHkQba9ikLDeuE
         Jtmvy0iuzlf4GyvQhBAID5t0A/AuxCrxRPskMXZkj+U79Py+ly1G6w53K7srL13REu4V
         FlioqOkpyKgA9P8zj5x1eu5kUnHv10KscdRcPvIO3+Co0vMIqHwAxD0bHMKQ7mTRaVPs
         wWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726425310; x=1727030110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8eKKClr8hTX6nllVRY4mm+euC3yi1At6P9UopPGjNo=;
        b=RnYEe4A84Q+j3NsGIwCFYlkb/+ubs+5bmSN8IXY5iM48TXItjQtH6eIN0uecFqLpa8
         vdK+BfF909SQYFSQ+n9PtPiizoAYnrrjaUIL0uQIXY2UgOWp9r2akJlTF/fBO9ZCJLrP
         hXDBCy8VP2Nfxnu9UWWHUipj4eVWIFpotp+s5Hr+bsNXRVpwwFZfpeBaUTv4t47acwoA
         ElUm00d1GBiYI8KoLS0gKd1SvRwhdxEqFie0wAirt/5PTRYhqOnf5dY5sIrP1QpiVe3t
         QiotzrDBDBYnQLbN2XnlqPDEMEtYgeIlzbeGcM8I00HncSiIVM/HrwcwttZXohvRSOB8
         b19A==
X-Gm-Message-State: AOJu0YzzuogoSMzIAy+FEmug3aIuDvfbvb0kKaqFa/9LhKl4RPcIG9bo
	f5USw+mLB4POvrhu4NA7vj0yGn5dyQX3Gj7C9N9XcRFZpv4r+neY6NdXJIb+
X-Google-Smtp-Source: AGHT+IERlGyinzWkYeJZs6CL7cbjZaj2sacdNUYLb4P0s//oRjUVqjuIKKypmeTYSCNVv0ctXgkQQw==
X-Received: by 2002:a17:903:230e:b0:205:937f:3ac6 with SMTP id d9443c01a7336-2076e31f03fmr190893975ad.1.1726425310008;
        Sun, 15 Sep 2024 11:35:10 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db498de2d5sm2358874a12.15.2024.09.15.11.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 11:35:09 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 2/3] riscv: sbi: Provide entry point for HSM tests
Date: Mon, 16 Sep 2024 02:34:58 +0800
Message-ID: <20240915183459.52476-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240915183459.52476-1-jamestiotio@gmail.com>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
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
index a7abc08c..d4dfd48e 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -18,6 +18,7 @@
 #include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 
@@ -288,6 +289,10 @@ static void check_time(void)
 	report_prefix_popn(2);
 }
 
+unsigned char sbi_hsm_stop_hart[NR_CPUS];
+unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
+unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
 #define DBCN_WRITE_BYTE_TEST_BYTE	((u8)'a')
 
-- 
2.43.0


