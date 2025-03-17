Return-Path: <kvm+bounces-41277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1664A65A41
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:18:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9168E3B03CB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36591A5BAD;
	Mon, 17 Mar 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="13NMucgk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011220370B
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231308; cv=none; b=m0ruhGEUMf83V3xI7fYVWHFdyKDpyVsoMDp2tASm6XeaW3yA7PiepImay/PC3fPU8bs0jc+bXMVDp+hLMd69i1khbfMIYAtCptXQ5OzNYIrUgxhdzswXwWoFEddKgCh+KeVum7XPJfkcg1NLLCotcVVEGnk3HGwKOHSLkIES7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231308; c=relaxed/simple;
	bh=qX5so5AU+yLLimNIkDktcyO1mUKmJ4t5Tli6ol780Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyM8dPGn1WV2ZSNgnuY0NLhz5VDIdYruWpRrJeXNguzCdFa96UMqgtBxdy97bi/92hqigMboZJCM2YP/gsbyDdtB2j+d3i3pfin2C3CgcejXq/ot4Wdpx5p8P8I1lOxGg/N860LTyoSVrGOT+9VG/Kd6cUi5MVIcvWGetXkrQqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=13NMucgk; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43d2d952eb1so12126535e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742231303; x=1742836103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKDplUA2XX/hbzyOxbYWLc7Q9RboQ/w3e3i+SZL4wNg=;
        b=13NMucgkidWjHq5gnUW9fA6sSEIzYtRYMC4HyXy9xKY0YomuVuFr+z/GlkUsGQA4ND
         4uSibDEfkbxBjN1lli2gMP3E1Lg1LF69srKx8Ltcl8cJr4uj5lVM+MIv2sTs9OEFM3zr
         VuJs3kP3iAMrf+xK1R95twOS6qH5n0UVISdzEofVojZTvPpl9ePNBs6TknVT9AZwUFpH
         nNSdem4QOAE64Uz1AjrR6PbMTnaLoD0ubnZtH4mTt5nNKCP2rjv7rmoaS2+Ik38FiXux
         Z6Iq05MGiguu6wKGemGStSk6dvfxmrQlsgYugZK2GxEQq5nmcsgcJeqDuDFHmb/iL49v
         e5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231303; x=1742836103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VKDplUA2XX/hbzyOxbYWLc7Q9RboQ/w3e3i+SZL4wNg=;
        b=QIyZJA3dvDObSXB3Vs5Z583EX7g4uguIE/O8D3J1hToPI6nCxKBd3C+enYM9Y1cA1q
         LvQs1/HUlk4uK/PK9w6QsGhGibRYZorbKgg+Lc9DUXDlPzr5fSMibksXlKqat/br8p+O
         vPPdTUy4CNcUWB5Us5HyualeY5P4wJixo8PmqSCDDbujrKdwspqSJwes77cLlDhsdy0e
         QPVnt/NMmm8GH6fvmsCDWfWYU+5xhLFAfDHVCf0L/fU/lKp2DyT6hnYTWM/UDt2ReBJq
         SQ1GgXxaviyUwE1NsgGuZLr1kMhCEPcrTE6+yQkxm8ANc/Ms7yN6v9ekcH/W5AnkHE+G
         wgcA==
X-Forwarded-Encrypted: i=1; AJvYcCUhO2QNOznEwfIdQIz6d3XU9pzNuaeHDWhJL2hRyFPpWcc+fGPbotWGwuP8njHO6FGhCZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyopcXhXGmUdunH/S7c/egFX0a5BuVR5Qxxrr0R253oeqZ9gp99
	cEfh6n7Lj0LycXSrCyxiLGMpPDt3UHn2Ihc6QNTNCxAHmcGjggi9tFO5s0bRpk0=
X-Gm-Gg: ASbGnct5M6UieQF/rHYiWmQMZHk8UubDkUrb/4V+xS2+Cm/l4TGhB/rNwigau0uEw+E
	A2T75nPrQ626W7qOKbj4pBWeFo4gwdAif2Zp0Cockfne0PD3zbF1UqpuBkCtsgO4qkxHiqP2Cy+
	5fXdsIeViNMCpvW0/B9llCsCpEp+Iifoa+wWuy7N8ocUulQ6xl9Na5cI1FKh8p7VuPj1QB8Akky
	cVPS/fyaAn48WUuwU+sOf0s9Y6A7W88/BY1ctow+QOZOMoG3odbC/CFH/cgXoB3cWusHH6uBsJC
	NMLJI6a8ePmHmjcWZrMmePBmOmdsx3Le109WoCMwL2BJTA==
X-Google-Smtp-Source: AGHT+IHYqakxMqLykAu8hVgungq+pEq9jN18lc5kC73JGVKr25cJlS/60mBYd+yEImb3bsX8Hv6BZA==
X-Received: by 2002:a05:600c:a00b:b0:43d:cc9:b09d with SMTP id 5b1f17b1804b1-43d3898770amr5615915e9.20.1742231302877;
        Mon, 17 Mar 2025 10:08:22 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d23cddb2asm96014505e9.39.2025.03.17.10.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 10:08:21 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4 14/18] selftests: riscv: add misaligned access testing
Date: Mon, 17 Mar 2025 18:06:20 +0100
Message-ID: <20250317170625.1142870-15-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250317170625.1142870-1-cleger@rivosinc.com>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the kernel can emulate misaligned access and control its
behavior, add a selftest for that. This selftest tests all the currently
emulated instruction (except for the RV32 compressed ones which are left
as a future exercise for a RV32 user). For the FPU instructions, all the
FPU registers are tested.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 .../selftests/riscv/misaligned/.gitignore     |   1 +
 .../selftests/riscv/misaligned/Makefile       |  12 +
 .../selftests/riscv/misaligned/common.S       |  33 +++
 .../testing/selftests/riscv/misaligned/fpu.S  | 180 +++++++++++++
 tools/testing/selftests/riscv/misaligned/gp.S | 103 +++++++
 .../selftests/riscv/misaligned/misaligned.c   | 254 ++++++++++++++++++
 6 files changed, 583 insertions(+)
 create mode 100644 tools/testing/selftests/riscv/misaligned/.gitignore
 create mode 100644 tools/testing/selftests/riscv/misaligned/Makefile
 create mode 100644 tools/testing/selftests/riscv/misaligned/common.S
 create mode 100644 tools/testing/selftests/riscv/misaligned/fpu.S
 create mode 100644 tools/testing/selftests/riscv/misaligned/gp.S
 create mode 100644 tools/testing/selftests/riscv/misaligned/misaligned.c

diff --git a/tools/testing/selftests/riscv/misaligned/.gitignore b/tools/testing/selftests/riscv/misaligned/.gitignore
new file mode 100644
index 000000000000..5eff15a1f981
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/.gitignore
@@ -0,0 +1 @@
+misaligned
diff --git a/tools/testing/selftests/riscv/misaligned/Makefile b/tools/testing/selftests/riscv/misaligned/Makefile
new file mode 100644
index 000000000000..1aa40110c50d
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 ARM Limited
+# Originally tools/testing/arm64/abi/Makefile
+
+CFLAGS += -I$(top_srcdir)/tools/include
+
+TEST_GEN_PROGS := misaligned
+
+include ../../lib.mk
+
+$(OUTPUT)/misaligned: misaligned.c fpu.S gp.S
+	$(CC) -g3 -static -o$@ -march=rv64imafdc $(CFLAGS) $(LDFLAGS) $^
diff --git a/tools/testing/selftests/riscv/misaligned/common.S b/tools/testing/selftests/riscv/misaligned/common.S
new file mode 100644
index 000000000000..8fa00035bd5d
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/common.S
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+
+.macro lb_sb temp, offset, src, dst
+	lb \temp, \offset(\src)
+	sb \temp, \offset(\dst)
+.endm
+
+.macro copy_long_to temp, src, dst
+	lb_sb \temp, 0, \src, \dst,
+	lb_sb \temp, 1, \src, \dst,
+	lb_sb \temp, 2, \src, \dst,
+	lb_sb \temp, 3, \src, \dst,
+	lb_sb \temp, 4, \src, \dst,
+	lb_sb \temp, 5, \src, \dst,
+	lb_sb \temp, 6, \src, \dst,
+	lb_sb \temp, 7, \src, \dst,
+.endm
+
+.macro sp_stack_prologue offset
+	addi sp, sp, -8
+	sub sp, sp, \offset
+.endm
+
+.macro sp_stack_epilogue offset
+	add sp, sp, \offset
+	addi sp, sp, 8
+.endm
diff --git a/tools/testing/selftests/riscv/misaligned/fpu.S b/tools/testing/selftests/riscv/misaligned/fpu.S
new file mode 100644
index 000000000000..d008bff58310
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/fpu.S
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+
+#include "common.S"
+
+#define CASE_ALIGN		4
+
+.macro fpu_load_inst fpreg, inst, precision, load_reg
+.align CASE_ALIGN
+	\inst \fpreg, 0(\load_reg)
+	fmv.\precision fa0, \fpreg
+	j 2f
+.endm
+
+#define flw(__fpreg) fpu_load_inst __fpreg, flw, s, s1
+#define fld(__fpreg) fpu_load_inst __fpreg, fld, d, s1
+#define c_flw(__fpreg) fpu_load_inst __fpreg, c.flw, s, s1
+#define c_fld(__fpreg) fpu_load_inst __fpreg, c.fld, d, s1
+#define c_fldsp(__fpreg) fpu_load_inst __fpreg, c.fldsp, d, sp
+
+.macro fpu_store_inst fpreg, inst, precision, store_reg
+.align CASE_ALIGN
+	fmv.\precision \fpreg, fa0
+	\inst \fpreg, 0(\store_reg)
+	j 2f
+.endm
+
+#define fsw(__fpreg) fpu_store_inst __fpreg, fsw, s, s1
+#define fsd(__fpreg) fpu_store_inst __fpreg, fsd, d, s1
+#define c_fsw(__fpreg) fpu_store_inst __fpreg, c.fsw, s, s1
+#define c_fsd(__fpreg) fpu_store_inst __fpreg, c.fsd, d, s1
+#define c_fsdsp(__fpreg) fpu_store_inst __fpreg, c.fsdsp, d, sp
+
+.macro fp_test_prologue
+	move s1, a1
+	/*
+	 * Compute jump offset to store the correct FP register since we don't
+	 * have indirect FP register access (or at least we don't use this
+	 * extension so that works on all archs)
+	 */
+	sll t0, a0, CASE_ALIGN
+	la t2, 1f
+	add t0, t0, t2
+	jr t0
+.align	CASE_ALIGN
+1:
+.endm
+
+.macro fp_test_prologue_compressed
+	/* FP registers for compressed instructions starts from 8 to 16 */
+	addi a0, a0, -8
+	fp_test_prologue
+.endm
+
+#define fp_test_body_compressed(__inst_func) \
+	__inst_func(f8); \
+	__inst_func(f9); \
+	__inst_func(f10); \
+	__inst_func(f11); \
+	__inst_func(f12); \
+	__inst_func(f13); \
+	__inst_func(f14); \
+	__inst_func(f15); \
+2:
+
+#define fp_test_body(__inst_func) \
+	__inst_func(f0); \
+	__inst_func(f1); \
+	__inst_func(f2); \
+	__inst_func(f3); \
+	__inst_func(f4); \
+	__inst_func(f5); \
+	__inst_func(f6); \
+	__inst_func(f7); \
+	__inst_func(f8); \
+	__inst_func(f9); \
+	__inst_func(f10); \
+	__inst_func(f11); \
+	__inst_func(f12); \
+	__inst_func(f13); \
+	__inst_func(f14); \
+	__inst_func(f15); \
+	__inst_func(f16); \
+	__inst_func(f17); \
+	__inst_func(f18); \
+	__inst_func(f19); \
+	__inst_func(f20); \
+	__inst_func(f21); \
+	__inst_func(f22); \
+	__inst_func(f23); \
+	__inst_func(f24); \
+	__inst_func(f25); \
+	__inst_func(f26); \
+	__inst_func(f27); \
+	__inst_func(f28); \
+	__inst_func(f29); \
+	__inst_func(f30); \
+	__inst_func(f31); \
+2:
+.text
+
+#define __gen_test_inst(__inst, __suffix) \
+.global test_ ## __inst; \
+test_ ## __inst:; \
+	fp_test_prologue ## __suffix; \
+	fp_test_body ## __suffix(__inst); \
+	ret
+
+#define gen_test_inst_compressed(__inst) \
+	.option arch,+c; \
+	__gen_test_inst(c_ ## __inst, _compressed)
+
+#define gen_test_inst(__inst) \
+	.balign 16; \
+	.option push; \
+	.option arch,-c; \
+	__gen_test_inst(__inst, ); \
+	.option pop
+
+.macro fp_test_prologue_load_compressed_sp
+	copy_long_to t0, a1, sp
+.endm
+
+.macro fp_test_epilogue_load_compressed_sp
+.endm
+
+.macro fp_test_prologue_store_compressed_sp
+.endm
+
+.macro fp_test_epilogue_store_compressed_sp
+	copy_long_to t0, sp, a1
+.endm
+
+#define gen_inst_compressed_sp(__inst, __type) \
+	.global test_c_ ## __inst ## sp; \
+	test_c_ ## __inst ## sp:; \
+		sp_stack_prologue a2; \
+		fp_test_prologue_## __type ## _compressed_sp; \
+		fp_test_prologue_compressed; \
+		fp_test_body_compressed(c_ ## __inst ## sp); \
+		fp_test_epilogue_## __type ## _compressed_sp; \
+		sp_stack_epilogue a2; \
+		ret
+
+#define gen_test_load_compressed_sp(__inst) gen_inst_compressed_sp(__inst, load)
+#define gen_test_store_compressed_sp(__inst) gen_inst_compressed_sp(__inst, store)
+
+/*
+ * float_fsw_reg - Set a FP register from a register containing the value
+ * a0 = FP register index to be set
+ * a1 = addr where to store register value
+ * a2 = address offset
+ * a3 = value to be store
+ */
+gen_test_inst(fsw)
+
+/*
+ * float_flw_reg - Get a FP register value and return it
+ * a0 = FP register index to be retrieved
+ * a1 = addr to load register from
+ * a2 = address offset
+ */
+gen_test_inst(flw)
+
+gen_test_inst(fsd)
+#ifdef __riscv_compressed
+gen_test_inst_compressed(fsd)
+gen_test_store_compressed_sp(fsd)
+#endif
+
+gen_test_inst(fld)
+#ifdef __riscv_compressed
+gen_test_inst_compressed(fld)
+gen_test_load_compressed_sp(fld)
+#endif
diff --git a/tools/testing/selftests/riscv/misaligned/gp.S b/tools/testing/selftests/riscv/misaligned/gp.S
new file mode 100644
index 000000000000..f53f4c6d81dd
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/gp.S
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+
+#include "common.S"
+
+.text
+
+.macro __gen_test_inst inst, src_reg
+	\inst a2, 0(\src_reg)
+	move a0, a2
+.endm
+
+.macro gen_func_header func_name, rvc
+	.option arch,\rvc
+	.global test_\func_name
+	test_\func_name:
+.endm
+
+.macro gen_test_inst inst
+	.option push
+	gen_func_header \inst, -c
+	__gen_test_inst \inst, a0
+	.option pop
+	ret
+.endm
+
+.macro __gen_test_inst_c name, src_reg
+	.option push
+	gen_func_header c_\name, +c
+	 __gen_test_inst c.\name, \src_reg
+	.option pop
+	ret
+.endm
+
+.macro gen_test_inst_c name
+ 	__gen_test_inst_c \name, a0
+.endm
+
+
+.macro gen_test_inst_load_c_sp name
+	.option push
+	gen_func_header c_\name\()sp, +c
+	sp_stack_prologue a1
+	copy_long_to t0, a0, sp
+	c.ldsp a0, 0(sp)
+	sp_stack_epilogue a1
+	.option pop
+	ret
+.endm
+
+.macro lb_sp_sb_a0 reg, offset
+	lb_sb \reg, \offset, sp, a0
+.endm
+
+.macro gen_test_inst_store_c_sp inst_name
+	.option push
+	gen_func_header c_\inst_name\()sp, +c
+	/* Misalign stack pointer */
+	sp_stack_prologue a1
+	/* Misalign access */
+	c.sdsp a2, 0(sp)
+	copy_long_to t0, sp, a0
+	sp_stack_epilogue a1
+	.option pop
+	ret
+.endm
+
+
+ /*
+ * a0 = addr to load from
+ * a1 = address offset
+ * a2 = value to be loaded
+ */
+gen_test_inst lh
+gen_test_inst lhu
+gen_test_inst lw
+gen_test_inst lwu
+gen_test_inst ld
+#ifdef __riscv_compressed
+gen_test_inst_c lw
+gen_test_inst_c ld
+gen_test_inst_load_c_sp ld
+#endif
+
+/*
+ * a0 = addr where to store value
+ * a1 = address offset
+ * a2 = value to be stored
+ */
+gen_test_inst sh
+gen_test_inst sw
+gen_test_inst sd
+#ifdef __riscv_compressed
+gen_test_inst_c sw
+gen_test_inst_c sd
+gen_test_inst_store_c_sp sd
+#endif
+
diff --git a/tools/testing/selftests/riscv/misaligned/misaligned.c b/tools/testing/selftests/riscv/misaligned/misaligned.c
new file mode 100644
index 000000000000..c66aa87ec03e
--- /dev/null
+++ b/tools/testing/selftests/riscv/misaligned/misaligned.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <linux/ptrace.h>
+#include "../../kselftest_harness.h"
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <float.h>
+#include <errno.h>
+#include <math.h>
+#include <string.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <inttypes.h>
+#include <ucontext.h>
+
+#include <sys/prctl.h>
+
+#define stringify(s) __stringify(s)
+#define __stringify(s) #s
+
+#define VAL16	0x1234
+#define VAL32	0xDEADBEEF
+#define VAL64	0x45674321D00DF789
+
+#define VAL_float	78951.234375
+#define VAL_double	567890.512396965789589290
+
+static bool float_equal(float a, float b)
+{
+	float scaled_epsilon;
+	float difference = fabsf(a - b);
+
+	// Scale to the largest value.
+	a = fabsf(a);
+	b = fabsf(b);
+	if (a > b)
+		scaled_epsilon = FLT_EPSILON * a;
+	else
+		scaled_epsilon = FLT_EPSILON * b;
+
+	return difference <= scaled_epsilon;
+}
+
+static bool double_equal(double a, double b)
+{
+	double scaled_epsilon;
+	double difference = fabsf(a - b);
+
+	// Scale to the largest value.
+	a = fabs(a);
+	b = fabs(b);
+	if (a > b)
+		scaled_epsilon = DBL_EPSILON * a;
+	else
+		scaled_epsilon = DBL_EPSILON * b;
+
+	return difference <= scaled_epsilon;
+}
+
+#define fpu_load_proto(__inst, __type) \
+extern __type test_ ## __inst(unsigned long fp_reg, void *addr, unsigned long offset, __type value)
+
+fpu_load_proto(flw, float);
+fpu_load_proto(fld, double);
+fpu_load_proto(c_flw, float);
+fpu_load_proto(c_fld, double);
+fpu_load_proto(c_fldsp, double);
+
+#define fpu_store_proto(__inst, __type) \
+extern void test_ ## __inst(unsigned long fp_reg, void *addr, unsigned long offset, __type value)
+
+fpu_store_proto(fsw, float);
+fpu_store_proto(fsd, double);
+fpu_store_proto(c_fsw, float);
+fpu_store_proto(c_fsd, double);
+fpu_store_proto(c_fsdsp, double);
+
+#define gp_load_proto(__inst, __type) \
+extern __type test_ ## __inst(void *addr, unsigned long offset, __type value)
+
+gp_load_proto(lh, uint16_t);
+gp_load_proto(lhu, uint16_t);
+gp_load_proto(lw, uint32_t);
+gp_load_proto(lwu, uint32_t);
+gp_load_proto(ld, uint64_t);
+gp_load_proto(c_lw, uint32_t);
+gp_load_proto(c_ld, uint64_t);
+gp_load_proto(c_ldsp, uint64_t);
+
+#define gp_store_proto(__inst, __type) \
+extern void test_ ## __inst(void *addr, unsigned long offset, __type value)
+
+gp_store_proto(sh, uint16_t);
+gp_store_proto(sw, uint32_t);
+gp_store_proto(sd, uint64_t);
+gp_store_proto(c_sw, uint32_t);
+gp_store_proto(c_sd, uint64_t);
+gp_store_proto(c_sdsp, uint64_t);
+
+#define TEST_GP_LOAD(__inst, __type_size)					\
+TEST(gp_load_ ## __inst)							\
+{										\
+	int offset, ret;							\
+	uint8_t buf[16] __attribute__((aligned(16)));				\
+										\
+	ret = prctl(PR_SET_UNALIGN, PR_UNALIGN_NOPRINT);			\
+	ASSERT_EQ(ret, 0);							\
+										\
+	for (offset = 1; offset < __type_size / 8; offset++) {			\
+		uint ## __type_size ## _t val = VAL ## __type_size;		\
+		uint ## __type_size ## _t *ptr = (uint ## __type_size ## _t *) (buf + offset); \
+		memcpy(ptr, &val, sizeof(val));					\
+		val = test_ ## __inst(ptr, offset, val);			\
+		EXPECT_EQ(VAL ## __type_size, val);				\
+	}									\
+}
+
+TEST_GP_LOAD(lh, 16);
+TEST_GP_LOAD(lhu, 16);
+TEST_GP_LOAD(lw, 32);
+TEST_GP_LOAD(lwu, 32);
+TEST_GP_LOAD(ld, 64);
+#ifdef __riscv_compressed
+TEST_GP_LOAD(c_lw, 32);
+TEST_GP_LOAD(c_ld, 64);
+TEST_GP_LOAD(c_ldsp, 64);
+#endif
+
+#define TEST_GP_STORE(__inst, __type_size)					\
+TEST(gp_load_ ## __inst)							\
+{										\
+	int offset, ret;							\
+	uint8_t buf[16] __attribute__((aligned(16)));				\
+										\
+	ret = prctl(PR_SET_UNALIGN, PR_UNALIGN_NOPRINT);			\
+	ASSERT_EQ(ret, 0);							\
+										\
+	for (offset = 1; offset < __type_size / 8; offset++) {			\
+		uint ## __type_size ## _t val = VAL ## __type_size;		\
+		uint ## __type_size ## _t *ptr = (uint ## __type_size ## _t *) (buf + offset); \
+		memset(ptr, 0, sizeof(val));					\
+		test_ ## __inst(ptr, offset, val);				\
+		memcpy(&val, ptr, sizeof(val));					\
+		EXPECT_EQ(VAL ## __type_size, val);				\
+	}									\
+}
+TEST_GP_STORE(sh, 16);
+TEST_GP_STORE(sw, 32);
+TEST_GP_STORE(sd, 64);
+#ifdef __riscv_compressed
+TEST_GP_STORE(c_sw, 32);
+TEST_GP_STORE(c_sd, 64);
+TEST_GP_STORE(c_sdsp, 64);
+#endif
+
+#define __TEST_FPU_LOAD(__type, __inst, __reg_start, __reg_end)			\
+TEST(fpu_load_ ## __inst)							\
+{										\
+	int i, ret, offset, fp_reg;						\
+	uint8_t buf[16] __attribute__((aligned(16)));				\
+										\
+	ret = prctl(PR_SET_UNALIGN, PR_UNALIGN_NOPRINT);			\
+	ASSERT_EQ(ret, 0);							\
+										\
+	for (fp_reg = __reg_start; fp_reg < __reg_end; fp_reg++) {		\
+		for (offset = 1; offset < 4; offset++) {			\
+			void *load_addr = (buf + offset);			\
+			__type val = VAL_ ## __type ;				\
+										\
+			memcpy(load_addr, &val, sizeof(val));			\
+			val = test_ ## __inst(fp_reg, load_addr, offset, val);	\
+			EXPECT_TRUE(__type ##_equal(val, VAL_## __type));	\
+		}								\
+	}									\
+}
+#define TEST_FPU_LOAD(__type, __inst) \
+	__TEST_FPU_LOAD(__type, __inst, 0, 32)
+#define TEST_FPU_LOAD_COMPRESSED(__type, __inst) \
+	__TEST_FPU_LOAD(__type, __inst, 8, 16)
+
+TEST_FPU_LOAD(float, flw)
+TEST_FPU_LOAD(double, fld)
+#ifdef __riscv_compressed
+TEST_FPU_LOAD_COMPRESSED(double, c_fld)
+TEST_FPU_LOAD_COMPRESSED(double, c_fldsp)
+#endif
+
+#define __TEST_FPU_STORE(__type, __inst, __reg_start, __reg_end)		\
+TEST(fpu_store_ ## __inst)							\
+{										\
+	int i, ret, offset, fp_reg;						\
+	uint8_t buf[16] __attribute__((aligned(16)));				\
+										\
+	ret = prctl(PR_SET_UNALIGN, PR_UNALIGN_NOPRINT);			\
+	ASSERT_EQ(ret, 0);							\
+										\
+	for (fp_reg = __reg_start; fp_reg < __reg_end; fp_reg++) {		\
+		for (offset = 1; offset < 4; offset++) {			\
+										\
+			void *store_addr = (buf + offset);			\
+			__type val = VAL_ ## __type ;				\
+										\
+			test_ ## __inst(fp_reg, store_addr, offset, val);	\
+			memcpy(&val, store_addr, sizeof(val));			\
+			EXPECT_TRUE(__type ## _equal(val, VAL_## __type));	\
+		}								\
+	}									\
+}
+#define TEST_FPU_STORE(__type, __inst) \
+	__TEST_FPU_STORE(__type, __inst, 0, 32)
+#define TEST_FPU_STORE_COMPRESSED(__type, __inst) \
+	__TEST_FPU_STORE(__type, __inst, 8, 16)
+
+TEST_FPU_STORE(float, fsw)
+TEST_FPU_STORE(double, fsd)
+#ifdef __riscv_compressed
+TEST_FPU_STORE_COMPRESSED(double, c_fsd)
+TEST_FPU_STORE_COMPRESSED(double, c_fsdsp)
+#endif
+
+TEST_SIGNAL(gen_sigbus, SIGBUS)
+{
+	uint32_t *ptr;
+	uint8_t buf[16] __attribute__((aligned(16)));
+	int ret;
+
+	ret = prctl(PR_SET_UNALIGN, PR_UNALIGN_SIGBUS);
+	ASSERT_EQ(ret, 0);
+
+	ptr = (uint32_t *)(buf + 1);
+	*ptr = 0xDEADBEEFULL;
+}
+
+int main(int argc, char **argv)
+{
+	int ret, val;
+
+	ret = prctl(PR_GET_UNALIGN, &val);
+	if (ret == -1 && errno == EINVAL)
+		ksft_exit_skip("SKIP GET_UNALIGN_CTL not supported\n");
+
+	exit(test_harness_run(argc, argv));
+}
-- 
2.47.2


