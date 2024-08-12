Return-Path: <kvm+bounces-23860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 702D994EF45
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2726F2834D1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A6D17F4F5;
	Mon, 12 Aug 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sPkIH0pc"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC0F17F4FE
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472056; cv=none; b=iBrkEPiXt4/q923+izdH8DpbCOvZy0RmlKdU3MOxdw+Xy+XHTWkdiKc09qxcCjJA6yYQ2CeJctgcNMoxLrMi8TO8ezbZKC6GBzaRvEQGXC0/hFfPL4YIBRleXJ3N8yeQn1Z93yu7+j3VJ9Eg+2CUiJUje9g9sJ2yCguj3g1Ub4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472056; c=relaxed/simple;
	bh=/oXneKmBI71xPFEUA6gBJcDJ67LESGlBq6GBLKcTl64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6TsAKUJ4b+ShuJyNk7SPbFeeYfYs3Afb2jzTFo9kVR4JL2648TrlFLEhRgsqHeuF3B5eNGpsWMCixPFTVusebl+TQn5iAYUFfsMXVHb3dpN9lfIXRAtZIdNaYM6FTlSeDU2iNya4x8L4jiNOwyL/kMQxWtSSp4nym/stYQWfkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sPkIH0pc; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uxDUAgwyU7LZpMoLOtgb1JYYiYJmCsjV9g+S3q6q5t0=;
	b=sPkIH0pcIOYjgfqFJqLk8SM0SHovIHM6PcSps5yh4S0ocoeZvccTjSpAzHg86UmEhgTjMF
	u0OW3de8vGFvbKuKFE8DVaCGZADAD2TFTyusNSBNBJHA2Nnq1zfxWRWYAZWg7nwKeZyJgG
	zXzKFYACpgKZBDahttngtYEpqa/WLZM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 4/4] riscv: sbi: dbcn: Add high address tests
Date: Mon, 12 Aug 2024 16:13:59 +0200
Message-ID: <20240812141354.119889-10-andrew.jones@linux.dev>
In-Reply-To: <20240812141354.119889-6-andrew.jones@linux.dev>
References: <20240812141354.119889-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On platforms where we have high memory (above 4G) such as on the QEMU
virt machine model with over 2G of RAM configured, then we can test
DBCN with addresses above 4G on 32-bit and on both 32-bit and 64-bit
we can try crossing page boundaries both below 4G and from below 4G
into 4G. Add those tests along with a bit of refactoring and the
introduction of a couple helpers to find and check high addresses.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 134 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 116 insertions(+), 18 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 3f7ca6a78cfc..4f1e65dd3be6 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -5,18 +5,25 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <alloc_page.h>
 #include <stdlib.h>
+#include <string.h>
 #include <limits.h>
+#include <vmalloc.h>
+#include <memregions.h>
 #include <asm/barrier.h>
 #include <asm/csr.h>
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/isa.h>
+#include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 
+#define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
+
 static void help(void)
 {
 	puts("Test SBI\n");
@@ -46,6 +53,25 @@ static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long
 		*hi = (unsigned long)(paddr >> 32);
 }
 
+static bool check_addr(phys_addr_t start, phys_addr_t size)
+{
+	struct mem_region *r = memregions_find(start);
+	return r && r->end - start >= size && r->flags == MR_F_UNUSED;
+}
+
+static phys_addr_t get_highest_addr(void)
+{
+	phys_addr_t highest_end = 0;
+	struct mem_region *r;
+
+	for (r = mem_regions; r->end; ++r) {
+		if (r->end > highest_end)
+			highest_end = r->end;
+	}
+
+	return highest_end - 1;
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -266,16 +292,60 @@ static void check_time(void)
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
 #define DBCN_WRITE_BYTE_TEST_BYTE	(u8)'a'
 
+static void dbcn_write_test(const char *s, unsigned long num_bytes)
+{
+	unsigned long base_addr_lo, base_addr_hi;
+	phys_addr_t paddr = virt_to_phys((void *)s);
+	int num_calls = 0;
+	struct sbiret ret;
+
+	split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
+
+	do {
+		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+		num_bytes -= ret.value;
+		paddr += ret.value;
+		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
+		num_calls++;
+	} while (num_bytes != 0 && ret.error == SBI_SUCCESS);
+
+	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
+	report_info("%d sbi calls made", num_calls);
+}
+
+static void dbcn_high_write_test(const char *s, unsigned long num_bytes,
+				 phys_addr_t page_addr, size_t page_offset)
+{
+	int nr_pages = page_offset ? 2 : 1;
+	void *vaddr;
+
+	if (page_addr != PAGE_ALIGN(page_addr) || page_addr + PAGE_SIZE < HIGH_ADDR_BOUNDARY ||
+	    !check_addr(page_addr, nr_pages * PAGE_SIZE)) {
+		report_skip("Memory above 4G required");
+		return;
+	}
+
+	vaddr = alloc_vpages(nr_pages);
+
+	for (int i = 0; i < nr_pages; ++i)
+		install_page(current_pgtable(), page_addr + i * PAGE_SIZE, vaddr + i * PAGE_SIZE);
+	memcpy(vaddr + page_offset, DBCN_WRITE_TEST_STRING, num_bytes);
+	dbcn_write_test(vaddr + page_offset, num_bytes);
+}
+
 /*
  * Only the write functionality is tested here. There's no easy way to
  * non-interactively test the read functionality.
  */
 static void check_dbcn(void)
 {
-	unsigned long num_bytes, base_addr_lo, base_addr_hi;
+	unsigned long num_bytes = strlen(DBCN_WRITE_TEST_STRING);
+	unsigned long base_addr_lo, base_addr_hi;
+	bool do_invalid_addr = false;
 	phys_addr_t paddr;
-	int num_calls = 0;
 	struct sbiret ret;
+	const char *tmp;
+	char *buf;
 
 	report_prefix_push("dbcn");
 
@@ -286,33 +356,61 @@ static void check_dbcn(void)
 		return;
 	}
 
-	num_bytes = strlen(DBCN_WRITE_TEST_STRING);
-	paddr = virt_to_phys((void *)&DBCN_WRITE_TEST_STRING);
-	split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
-
 	report_prefix_push("write");
 
-	do {
-		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
-		num_bytes -= ret.value;
-		paddr += ret.value;
-		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
-		num_calls++;
-	} while (num_bytes != 0 && ret.error == SBI_SUCCESS);
+	dbcn_write_test(DBCN_WRITE_TEST_STRING, num_bytes);
 
-	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
-	report_info("%d sbi calls made", num_calls);
+	assert(num_bytes < PAGE_SIZE);
+
+	report_prefix_push("page boundary");
+	buf = alloc_pages(1);
+	memcpy(&buf[PAGE_SIZE - num_bytes / 2], DBCN_WRITE_TEST_STRING, num_bytes);
+	dbcn_write_test(&buf[PAGE_SIZE - num_bytes / 2], num_bytes);
+	report_prefix_pop();
+
+	report_prefix_push("high boundary");
+	tmp = getenv("SBI_DBCN_SKIP_HIGH_BOUNDARY");
+	if (!tmp || atol(tmp) == 0)
+		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes,
+				     HIGH_ADDR_BOUNDARY - PAGE_SIZE, PAGE_SIZE - num_bytes / 2);
+	else
+		report_skip("user disabled");
+	report_prefix_pop();
+
+	if (__riscv_xlen == 32) {
+		report_prefix_push("high page");
+		tmp = getenv("SBI_DBCN_SKIP_HIGH_PAGE");
+		if (!tmp || atol(tmp) == 0) {
+			paddr = HIGH_ADDR_BOUNDARY;
+			tmp = getenv("HIGH_PAGE");
+			if (tmp)
+				paddr = strtoull(tmp, NULL, 0);
+			dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes, paddr, 0);
+		} else {
+			report_skip("user disabled");
+		}
+		report_prefix_pop();
+	}
 
 	/* Bytes are read from memory and written to the console */
-	if (env_or_skip("INVALID_ADDR")) {
+	report_prefix_push("invalid parameter");
+	tmp = getenv("INVALID_ADDR_AUTO");
+	if (tmp && atol(tmp) == 1) {
+		paddr = get_highest_addr() + 1;
+		do_invalid_addr = true;
+	} else if (env_or_skip("INVALID_ADDR")) {
 		paddr = strtoull(getenv("INVALID_ADDR"), NULL, 0);
+		do_invalid_addr = true;
+	}
+
+	if (do_invalid_addr) {
 		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
 		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
-		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address (error=%ld)", ret.error);
+		report(ret.error == SBI_ERR_INVALID_PARAM, "address (error=%ld)", ret.error);
 	}
-
 	report_prefix_pop();
 
+	report_prefix_pop();
 	report_prefix_push("write_byte");
 
 	puts("DBCN_WRITE TEST CHAR: ");
-- 
2.45.2


