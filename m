Return-Path: <kvm+bounces-41740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F46A6C893
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFE0B7A9742
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 09:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195161D89E3;
	Sat, 22 Mar 2025 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rsz4Cxs+"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005ED78F3B
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 09:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742635009; cv=none; b=kcLKNUhQ/MUXmBnW52Id9QJYCxvy8JcQfykFzN+LfzoXsiJG+qOilNXABV4r4KvIEbpCFkmGpLGqDJv7hLTV9/aCqKKOTAuD4QJXWzt37IZEH83TTuaS4VYLT7SNjii505IYuoPF7UemJxrS37FSmcJfU/7TU4xP+0MKEPw1eEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742635009; c=relaxed/simple;
	bh=ZwVnVY8GtJ2J1rJ2SQxNfYvRDICNGLcB5MXa4fTK8Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVxWoEW0WITQABc9mVUkF+GyUFYxtDqxAVT1mT9y6minrnfhXhissQPlGIJoV07ksTv3OaowM7WXe2K500UKs/xvAuUdsE+V2C/5TKUAIiaP+cogINGybxnWmI37p5kCRHMMVWMGULwE9plruw3ptfusBSvnCzpuugMhjxs0Wf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rsz4Cxs+; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742635003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gVgx0cRRUKvntWV/RJDF7xOmSjY2mvm2fdaOU/vu1g4=;
	b=Rsz4Cxs+a5K7AH+RcBNR6uXKSixGOPpXDEjnbRPv7H7Ipi0fY1IG8dfFfJG7/W9r1Y0wN0
	fs6Hy48BfMbqGSNbdRM47/cS13LFdOvtGb0Swa8OLH+8mw9XEhmHK2vJx75uCDjIIXxVi4
	FQWwEa8K4Z3RzFqccijnck68HQoF6I4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org
Cc: samuel.holland@sifive.com
Subject: [kvm-unit-tests PATCH 4/3] riscv: Support using SBI DBCN for the console
Date: Sat, 22 Mar 2025 10:16:41 +0100
Message-ID: <20250322091640.161511-2-andrew.jones@linux.dev>
In-Reply-To: <20241210044442.91736-1-samuel.holland@sifive.com>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't want to add support for lots of UARTs nor lots of support
for UARTs. Thankfully SBI may have the DBCN extension, allowing us
to use that instead when our simple UART support is insufficient.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure      | 17 +++++++++++------
 lib/riscv/io.c | 16 ++++++++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/configure b/configure
index 06532a89f9c7..52904d3aa45b 100755
--- a/configure
+++ b/configure
@@ -31,6 +31,7 @@ gen_se_header=
 enable_dump=no
 page_size=
 earlycon=
+console=
 efi=
 efi_direct=
 
@@ -78,7 +79,7 @@ usage() {
 	                           4k [default], 16k, 64k for arm64.
 	                           4k [default], 64k for ppc64.
 	    --earlycon=EARLYCON
-				   Specify the UART name, type and address (optional).
+	                           Specify the UART name, type and address used for the earlycon (optional).
 	                           The specified address will overwrite the UART address set by
 	                           the --target option. EARLYCON can be one of (case sensitive):
 	               uart[8250],mmio,ADDR
@@ -89,6 +90,9 @@ usage() {
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
 	                           (arm/arm64 and riscv32/riscv64 only)
+	    --console=CONSOLE
+	                           Specify the device used for output (optional).
+	               sbi         Use SBI DBCN (riscv only)
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
 	    --[enable|disable]-werror
 	                           Select whether to compile with the -Werror compiler flag
@@ -175,6 +179,9 @@ while [[ $optno -le $argc ]]; do
 	--earlycon)
 	    earlycon="$arg"
 	    ;;
+	--console)
+	    console="$arg"
+	    ;;
 	--enable-efi)
 	    efi=y
 	    ;;
@@ -503,10 +510,8 @@ cat <<EOF >> lib/config.h
 
 EOF
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
-cat <<EOF >> lib/config.h
-
-#define CONFIG_UART_EARLY_BASE ${uart_early_addr}
-
-EOF
+    echo "#define CONFIG_UART_EARLY_BASE ${uart_early_addr}" >> lib/config.h
+    [ "$console" = "sbi" ] && echo "#define CONFIG_SBI_CONSOLE" >> lib/config.h
+    echo >> lib/config.h
 fi
 echo "#endif" >> lib/config.h
diff --git a/lib/riscv/io.c b/lib/riscv/io.c
index 011b5b1dc1d4..c8ebfa1c7bb8 100644
--- a/lib/riscv/io.c
+++ b/lib/riscv/io.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
 #include <config.h>
 #include <devicetree.h>
 #include <asm/io.h>
@@ -29,6 +30,7 @@ static u32 uart0_reg_shift = 1;
 static u32 uart0_reg_width = 1;
 static struct spinlock uart_lock;
 
+#ifndef CONFIG_SBI_CONSOLE
 static u32 uart0_read(u32 num)
 {
 	u32 offset = num << uart0_reg_shift;
@@ -52,6 +54,7 @@ static void uart0_write(u32 num, u32 val)
 	else
 		writel(val, uart0_base + offset);
 }
+#endif
 
 static void uart0_init_fdt(void)
 {
@@ -113,6 +116,18 @@ void io_init(void)
 	}
 }
 
+#ifdef CONFIG_SBI_CONSOLE
+void puts(const char *s)
+{
+	phys_addr_t addr = virt_to_phys((void *)s);
+	unsigned long hi = upper_32_bits(addr);
+	unsigned long lo = lower_32_bits(addr);
+
+	spin_lock(&uart_lock);
+	sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE, strlen(s), lo, hi, 0, 0, 0);
+	spin_unlock(&uart_lock);
+}
+#else
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);
@@ -123,6 +138,7 @@ void puts(const char *s)
 	}
 	spin_unlock(&uart_lock);
 }
+#endif
 
 /*
  * Defining halt to take 'code' as an argument guarantees that it will
-- 
2.48.1


