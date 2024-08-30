Return-Path: <kvm+bounces-25540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C684966627
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7086E1C23617
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA131B81A2;
	Fri, 30 Aug 2024 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dYTcmWmF"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E105A1B81D9
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033229; cv=none; b=J7TlPH0Z8eR/e1a/aD7iwosETFHrdeESDoTQfMGO9NVhfj0m+g6gL6U75X1aW5cyDyBmAg0t8GfF5uUvNgJTy0dMt3FRd50YNmSK65DvxwFUWdtiLq5OZCq4fCDVMqNzRATR/Rsw9+kdMTsOBrGmPq3Izbli5MkP+JxGIMY6Ixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033229; c=relaxed/simple;
	bh=gpFSyCvgrpx0Oj3e+0dxQBX+It0A2DwlY5+VK2vkdvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIhgKsQ+Sfkqt/VNA+rXg2HWS4KJenHAawXVNgCdMLDwWZos4B6Sr+BcP34M+guYOvOtQtIggNOB7LRF8TO8SeD6lFAvdDFyZ8W1tdjV+uXfgJYbfZugH3j3tOjhWs9Wt147o1HpxCZBEmlLY7LIA9lasmFpE6dLiJ72kGOTltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dYTcmWmF; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725033224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLtlltP/W1dYapl9HluIcmIbLG5POT2yhvwdk7T+m/E=;
	b=dYTcmWmFyKsVD81wXOo/9HYbB0xRWD/Qf+Lcimb84ibmpzR/TuK2xQeBWR+nqSjPq8GQnL
	JSkeRCoHB0X8m/0kr8RVETeKLq9YOqQiOQU+APnH9rQaBbeI0drH3bgkIqhC0rUSUfaRf+
	Z/GvZ96pmEJaRg9cjkbRc5715IZeDqo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/2] sbi: Rename __*_sbi_ecall to sbi_*
Date: Fri, 30 Aug 2024 17:53:39 +0200
Message-ID: <20240830155337.335534-5-andrew.jones@linux.dev>
In-Reply-To: <20240830155337.335534-4-andrew.jones@linux.dev>
References: <20240830155337.335534-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Let's name all SBI ecall wrappers with the same pattern of sbi_<ext>
and sbi_<ext>_<func>, even those that are local to the SBI tests.
This is good for consistency and if those functions are ever promoted
to the library then we won't have to change all their invocations.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 85cb7e589bdc..907bfbe5bb69 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -30,14 +30,21 @@ static void help(void)
 	puts("An environ must be provided where expected values are given.\n");
 }
 
-static struct sbiret __base_sbi_ecall(int fid, unsigned long arg0)
+static struct sbiret sbi_base(int fid, unsigned long arg0)
 {
 	return sbi_ecall(SBI_EXT_BASE, fid, arg0, 0, 0, 0, 0, 0);
 }
 
-static struct sbiret __dbcn_sbi_ecall(int fid, unsigned long arg0, unsigned long arg1, unsigned long arg2)
+static struct sbiret sbi_dbcn_write(unsigned long num_bytes, unsigned long base_addr_lo,
+				    unsigned long base_addr_hi)
 {
-	return sbi_ecall(SBI_EXT_DBCN, fid, arg0, arg1, arg2, 0, 0, 0);
+	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE,
+			 num_bytes, base_addr_lo, base_addr_hi, 0, 0, 0);
+}
+
+static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
+{
+	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
 }
 
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
@@ -98,7 +105,7 @@ static void check_base(void)
 
 	report_prefix_push("base");
 
-	ret = __base_sbi_ecall(SBI_EXT_BASE_GET_SPEC_VERSION, 0);
+	ret = sbi_base(SBI_EXT_BASE_GET_SPEC_VERSION, 0);
 	if (ret.error || ret.value < 2) {
 		report_skip("SBI spec version 0.2 or higher required");
 		return;
@@ -114,7 +121,7 @@ static void check_base(void)
 	report_prefix_push("impl_id");
 	if (env_or_skip("SBI_IMPL_ID")) {
 		expected = (long)strtoul(getenv("SBI_IMPL_ID"), NULL, 0);
-		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_ID, 0);
+		ret = sbi_base(SBI_EXT_BASE_GET_IMP_ID, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
@@ -122,17 +129,17 @@ static void check_base(void)
 	report_prefix_push("impl_version");
 	if (env_or_skip("SBI_IMPL_VERSION")) {
 		expected = (long)strtoul(getenv("SBI_IMPL_VERSION"), NULL, 0);
-		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_IMP_VERSION, 0);
+		ret = sbi_base(SBI_EXT_BASE_GET_IMP_VERSION, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
 	report_prefix_push("probe_ext");
 	expected = getenv("SBI_PROBE_EXT") ? (long)strtoul(getenv("SBI_PROBE_EXT"), NULL, 0) : 1;
-	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_BASE);
+	ret = sbi_base(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_BASE);
 	gen_report(&ret, 0, expected);
 	report_prefix_push("unavailable");
-	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, 0xb000000);
+	ret = sbi_base(SBI_EXT_BASE_PROBE_EXT, 0xb000000);
 	gen_report(&ret, 0, 0);
 	report_prefix_pop();
 	report_prefix_pop();
@@ -141,7 +148,7 @@ static void check_base(void)
 	if (env_or_skip("MVENDORID")) {
 		expected = (long)strtoul(getenv("MVENDORID"), NULL, 0);
 		assert(__riscv_xlen == 32 || !(expected >> 32));
-		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MVENDORID, 0);
+		ret = sbi_base(SBI_EXT_BASE_GET_MVENDORID, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
@@ -149,7 +156,7 @@ static void check_base(void)
 	report_prefix_push("marchid");
 	if (env_or_skip("MARCHID")) {
 		expected = (long)strtoul(getenv("MARCHID"), NULL, 0);
-		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MARCHID, 0);
+		ret = sbi_base(SBI_EXT_BASE_GET_MARCHID, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
@@ -157,7 +164,7 @@ static void check_base(void)
 	report_prefix_push("mimpid");
 	if (env_or_skip("MIMPID")) {
 		expected = (long)strtoul(getenv("MIMPID"), NULL, 0);
-		ret = __base_sbi_ecall(SBI_EXT_BASE_GET_MIMPID, 0);
+		ret = sbi_base(SBI_EXT_BASE_GET_MIMPID, 0);
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
@@ -292,7 +299,7 @@ static void dbcn_write_test(const char *s, unsigned long num_bytes)
 	split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
 
 	do {
-		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, num_bytes, base_addr_lo, base_addr_hi);
+		ret = sbi_dbcn_write(num_bytes, base_addr_lo, base_addr_hi);
 		num_bytes -= ret.value;
 		paddr += ret.value;
 		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
@@ -325,7 +332,7 @@ static void dbcn_high_write_test(const char *s, unsigned long num_bytes,
 
 /*
  * Only the write functionality is tested here. There's no easy way to
- * non-interactively test the read functionality.
+ * non-interactively test SBI_EXT_DBCN_CONSOLE_READ.
  */
 static void check_dbcn(void)
 {
@@ -339,8 +346,7 @@ static void check_dbcn(void)
 
 	report_prefix_push("dbcn");
 
-	ret = __base_sbi_ecall(SBI_EXT_BASE_PROBE_EXT, SBI_EXT_DBCN);
-	if (!ret.value) {
+	if (!sbi_probe(SBI_EXT_DBCN)) {
 		report_skip("DBCN extension unavailable");
 		report_prefix_pop();
 		return;
@@ -393,7 +399,7 @@ static void check_dbcn(void)
 
 	if (do_invalid_addr) {
 		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
-		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
+		ret = sbi_dbcn_write(1, base_addr_lo, base_addr_hi);
 		report(ret.error == SBI_ERR_INVALID_PARAM, "address (error=%ld)", ret.error);
 	}
 	report_prefix_pop();
@@ -402,7 +408,7 @@ static void check_dbcn(void)
 	report_prefix_push("write_byte");
 
 	puts("DBCN_WRITE TEST CHAR: ");
-	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
+	ret = sbi_dbcn_write_byte(DBCN_WRITE_BYTE_TEST_BYTE);
 	puts("\n");
 	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
 	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
-- 
2.45.2


