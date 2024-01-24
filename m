Return-Path: <kvm+bounces-6787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B64E283A2B3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2DA28C82B
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22871757E;
	Wed, 24 Jan 2024 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VGVo7iYD"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE51756D
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080722; cv=none; b=L4EzNzfqA4Yzx8lJ5O92YRecsvWX9qIVir8sUIAfj8/DOMcfN6xW5C6wau4tEbcXF9BeBmHf9sELYv0v2qZEZ5QM7k7BMXljphsQad6gdAqBQ7El3uAUSrMrP8iOeI7+TNJGZ/sJYNpWQr1Y+jtQ/SlM3aqs3j+B1qfiglXGbdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080722; c=relaxed/simple;
	bh=jMSyGEU3NseQ1xsGQ2ONLx6H7J2bTeO1mZHswpf4wzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=StaD1l5s1Vb1OFPwNbexwIvORoApQctUV+d3pOz22PnLQwmfDNC7UFBRNOptgBOLapkrHz8vXOGHwRXJPCJO5VuE5fNt0mipLTAzghOsk4gjFTeMPdVpelFTl8nMvdm3PnumhM13QGGAzdFJtU9PJ7XKmmbGcli2H+/ol9Ew4ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VGVo7iYD; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaE7etfLQv9qAywqbxK4WpADuHUIgZZmBj5zPMxwf9E=;
	b=VGVo7iYDLzcqqJjGtZR/E+EpgHDeI4l7/s6x7BCPT9giUgY3EU+TYkuF4NmV3sUbUEJ6JQ
	j9gI8CQrDMfoYbYLI3zPY/0Y8KXUx1bdczJrwvc+wfezkplz9hbciaePneTjTBmdmrO2Uo
	/ZOsn1JO8JYM9E8bNYXI2yto5UADp/s=
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
Subject: [kvm-unit-tests PATCH 08/24] riscv: Add riscv32 support
Date: Wed, 24 Jan 2024 08:18:24 +0100
Message-ID: <20240124071815.6898-34-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Make a few tweaks to allow also building and running riscv32.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/elf.h               | 11 +++++++++++
 lib/ldiv32.c            | 16 ++++++++++++++++
 lib/riscv/asm-offsets.c | 11 +++++++++++
 riscv/Makefile          |  3 +++
 riscv/cstart.S          | 35 +++++++++++++++++++++--------------
 5 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/lib/elf.h b/lib/elf.h
index abd5cf4beaad..7a7db57774cd 100644
--- a/lib/elf.h
+++ b/lib/elf.h
@@ -8,6 +8,11 @@
 
 #include <libcflat.h>
 
+/* 32-bit ELF base types. */
+typedef u32	Elf32_Addr;
+typedef u32	Elf32_Xword;
+typedef s32	Elf32_Sxword;
+
 /* 64-bit ELF base types. */
 typedef u64	Elf64_Addr;
 typedef u64	Elf64_Xword;
@@ -26,6 +31,12 @@ typedef struct elf64_rel {
 	Elf64_Xword r_info;     /* index and type of relocation */
 } Elf64_Rel;
 
+typedef struct elf32_rela {
+	Elf32_Addr r_offset;    /* Location at which to apply the action */
+	Elf32_Xword r_info;     /* index and type of relocation */
+	Elf32_Sxword r_addend;  /* Constant addend used to compute value */
+} Elf32_Rela;
+
 typedef struct elf64_rela {
 	Elf64_Addr r_offset;    /* Location at which to apply the action */
 	Elf64_Xword r_info;     /* index and type of relocation */
diff --git a/lib/ldiv32.c b/lib/ldiv32.c
index 897a4b9cd39e..9ce2a6a1faf0 100644
--- a/lib/ldiv32.c
+++ b/lib/ldiv32.c
@@ -1,5 +1,21 @@
 #include <stdint.h>
 
+#if __riscv_xlen == 32
+int __clzdi2(unsigned long);
+
+int __clzdi2(unsigned long a)
+{
+	int n = 0;
+
+	while (a) {
+		++n;
+		a >>= 1;
+	}
+
+	return 32 - n;
+}
+#endif
+
 extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
 extern int64_t __divmoddi4(int64_t num, int64_t den, int64_t *p_rem);
 extern int64_t __moddi3(int64_t num, int64_t den);
diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 4a74df9e4a09..eb337b7547b8 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -1,6 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <kbuild.h>
+#include <elf.h>
 
 int main(void)
 {
+#if __riscv_xlen == 32
+	OFFSET(ELF_RELA_OFFSET, elf32_rela, r_offset);
+	OFFSET(ELF_RELA_ADDEND, elf32_rela, r_addend);
+	DEFINE(ELF_RELA_SIZE, sizeof(struct elf32_rela));
+#elif __riscv_xlen == 64
+	OFFSET(ELF_RELA_OFFSET, elf64_rela, r_offset);
+	OFFSET(ELF_RELA_ADDEND, elf64_rela, r_addend);
+	DEFINE(ELF_RELA_SIZE, sizeof(struct elf64_rela));
+#endif
 	return 0;
 }
diff --git a/riscv/Makefile b/riscv/Makefile
index 4e7fcc538ba1..fb97e678a456 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -29,6 +29,9 @@ cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
+ifeq ($(ARCH),riscv32)
+cflatobjs += lib/ldiv32.o
+endif
 
 ########################################
 
diff --git a/riscv/cstart.S b/riscv/cstart.S
index a28d75e8021e..6ec2231e5812 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -4,11 +4,23 @@
  *
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
+#include <asm/asm-offsets.h>
 #include <asm/csr.h>
 
+#if __riscv_xlen == 64
+#define __REG_SEL(a, b) a
+#elif __riscv_xlen == 32
+#define __REG_SEL(a, b) b
+#else
+#error "Unexpected __riscv_xlen"
+#endif
+
+#define REG_L	__REG_SEL(ld, lw)
+#define REG_S	__REG_SEL(sd, sw)
+
 .macro zero_range, tmp1, tmp2
 9998:	beq	\tmp1, \tmp2, 9997f
-	sd	zero, 0(\tmp1)
+	REG_S	zero, 0(\tmp1)
 	addi	\tmp1, \tmp1, 8
 	j	9998b
 9997:
@@ -33,26 +45,20 @@ start:
 
 	/*
 	 * Update all R_RISCV_RELATIVE relocations using the table
-	 * of Elf64_Rela entries between reloc_start/end. The build
-	 * will not emit other relocation types.
-	 *
-	 * struct Elf64_Rela {
-	 * 	uint64_t r_offset;
-	 * 	uint64_t r_info;
-	 * 	int64_t  r_addend;
-	 * }
+	 * of Elf32_Rela/Elf64_Rela entries between reloc_start/end.
+	 * The build will not emit other relocation types.
 	 */
 	la	a1, reloc_start
 	la	a2, reloc_end
 	la	a3, start			// base
 1:
 	bge	a1, a2, 1f
-	ld	a4, 0(a1)			// r_offset
-	ld	a5, 16(a1)			// r_addend
+	REG_L	a4, ELF_RELA_OFFSET(a1)		// r_offset
+	REG_L	a5, ELF_RELA_ADDEND(a1)		// r_addend
 	add	a4, a3, a4			// addr = base + r_offset
 	add	a5, a3, a5			// val = base + r_addend
-	sd	a5, 0(a4)			// *addr = val
-	addi	a1, a1, 24
+	REG_S	a5, 0(a4)			// *addr = val
+	addi	a1, a1, ELF_RELA_SIZE
 	j	1b
 
 1:
@@ -72,11 +78,12 @@ start:
 
 	/* complete setup */
 	la	a1, stacktop			// a1 is the base of free memory
+	mv	a2, zero			// clear a2 for xlen=32
 	call	setup				// a0 is the addr of the dtb
 
 	/* run the test */
 	la	a0, __argc
-	ld	a0, 0(a0)
+	REG_L	a0, 0(a0)
 	la	a1, __argv
 	la	a2, __environ
 	call	main
-- 
2.43.0


