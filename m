Return-Path: <kvm+bounces-26502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8409750E5
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B47181F22CAD
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512B0188A14;
	Wed, 11 Sep 2024 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LJ2/ylCb"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2758191F82
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 11:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726054429; cv=none; b=KSOTK0U6mOlpyj3awYj2/MW90vEw1Yvu6YQz4/pUwDKzo3ZU1mJ96230T5tZ6JXEr0zZ/i6MJ3sw9tOwxevxz2/pPyNuf+RbbDpt7x7v1S8fi436j74RfqIMusc8Re7G4ScoEIIoO2TNm8sP/xcrnaKLPctc/7wPMnIG7CnaQZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726054429; c=relaxed/simple;
	bh=jOPkwIeIRNma8QU1tLX23XTm2I6skaXAWmOFQNnD+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo9+cnCkGDk2MW8OrfHguImN2feNRMZEEUNKz2Jtb+jIhuV5+TowQdLCJ0Uxh5vLPJ6nhCxOVegbfoJhaFbb4f8L22NJCsele2VIEctcqwzAXMtLKJgsZ9FazIEMJvbE1q40CGqLGLmR3GUHJgnZELHULTg8udPyfTf1CnN+EmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LJ2/ylCb; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726054424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gBmiCmcqbljsNZT/u+6f2NIjy3RBdVTjXQpgbf8WLZc=;
	b=LJ2/ylCbFrLTQ50OfizVDoVBNlDKNw9gQNj0wrPsEHD6+z+Yfb4mSl5s4SR3PPBm/UVTgg
	emWoL6ykzNFQdjOX9NNEiiI2+2VtNNQ4mYypgOTkUdBXYHRVJDZgldI60+YX8i/pg8Zz/K
	ysrMIwmel0QALNI6PM7yp8le5RDtaW4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/2] riscv: sbi: Highmem isn't always supported
Date: Wed, 11 Sep 2024 13:33:40 +0200
Message-ID: <20240911113338.156844-5-andrew.jones@linux.dev>
In-Reply-To: <20240911113338.156844-4-andrew.jones@linux.dev>
References: <20240911113338.156844-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When an SBI implementation has opted not to support memory accesses
above 4G (highmem), such as 32-bit OpenSBI, then report failures to
access that memory as "expected failures". Use yet another
environment variable to inform the testsuite of this SBI
implementation behavior.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 093c20a096da..300d5ae63084 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -288,7 +288,7 @@ static void check_time(void)
 #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
 #define DBCN_WRITE_BYTE_TEST_BYTE	((u8)'a')
 
-static void dbcn_write_test(const char *s, unsigned long num_bytes)
+static void dbcn_write_test(const char *s, unsigned long num_bytes, bool xfail)
 {
 	unsigned long base_addr_lo, base_addr_hi;
 	phys_addr_t paddr = virt_to_phys((void *)s);
@@ -305,12 +305,13 @@ static void dbcn_write_test(const char *s, unsigned long num_bytes)
 		num_calls++;
 	} while (num_bytes != 0 && ret.error == SBI_SUCCESS);
 
-	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
+	report_xfail(xfail, ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
 	report_info("%d sbi calls made", num_calls);
 }
 
 static void dbcn_high_write_test(const char *s, unsigned long num_bytes,
-				 phys_addr_t page_addr, size_t page_offset)
+				 phys_addr_t page_addr, size_t page_offset,
+				 bool highmem_supported)
 {
 	int nr_pages = page_offset ? 2 : 1;
 	void *vaddr;
@@ -326,7 +327,7 @@ static void dbcn_high_write_test(const char *s, unsigned long num_bytes,
 	for (int i = 0; i < nr_pages; ++i)
 		install_page(current_pgtable(), page_addr + i * PAGE_SIZE, vaddr + i * PAGE_SIZE);
 	memcpy(vaddr + page_offset, DBCN_WRITE_TEST_STRING, num_bytes);
-	dbcn_write_test(vaddr + page_offset, num_bytes);
+	dbcn_write_test(vaddr + page_offset, num_bytes, !highmem_supported);
 }
 
 /*
@@ -338,6 +339,7 @@ static void check_dbcn(void)
 	unsigned long num_bytes = strlen(DBCN_WRITE_TEST_STRING);
 	unsigned long base_addr_lo, base_addr_hi;
 	bool do_invalid_addr = false;
+	bool highmem_supported = true;
 	phys_addr_t paddr;
 	struct sbiret ret;
 	const char *tmp;
@@ -353,21 +355,26 @@ static void check_dbcn(void)
 
 	report_prefix_push("write");
 
-	dbcn_write_test(DBCN_WRITE_TEST_STRING, num_bytes);
+	dbcn_write_test(DBCN_WRITE_TEST_STRING, num_bytes, false);
 
 	assert(num_bytes < PAGE_SIZE);
 
 	report_prefix_push("page boundary");
 	buf = alloc_pages(1);
 	memcpy(&buf[PAGE_SIZE - num_bytes / 2], DBCN_WRITE_TEST_STRING, num_bytes);
-	dbcn_write_test(&buf[PAGE_SIZE - num_bytes / 2], num_bytes);
+	dbcn_write_test(&buf[PAGE_SIZE - num_bytes / 2], num_bytes, false);
 	report_prefix_pop();
 
+	tmp = getenv("SBI_HIGHMEM_NOT_SUPPORTED");
+	if (tmp && atol(tmp) != 0)
+		highmem_supported = false;
+
 	report_prefix_push("high boundary");
 	tmp = getenv("SBI_DBCN_SKIP_HIGH_BOUNDARY");
 	if (!tmp || atol(tmp) == 0)
 		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes,
-				     HIGH_ADDR_BOUNDARY - PAGE_SIZE, PAGE_SIZE - num_bytes / 2);
+				     HIGH_ADDR_BOUNDARY - PAGE_SIZE, PAGE_SIZE - num_bytes / 2,
+				     highmem_supported);
 	else
 		report_skip("user disabled");
 	report_prefix_pop();
@@ -379,7 +386,7 @@ static void check_dbcn(void)
 		tmp = getenv("HIGH_PAGE");
 		if (tmp)
 			paddr = strtoull(tmp, NULL, 0);
-		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes, paddr, 0);
+		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes, paddr, 0, highmem_supported);
 	} else {
 		report_skip("user disabled");
 	}
-- 
2.46.0


