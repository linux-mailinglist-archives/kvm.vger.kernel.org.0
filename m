Return-Path: <kvm+bounces-29633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECD19AE537
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11E20B24729
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E3E1DAC99;
	Thu, 24 Oct 2024 12:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QNd36G+2"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142321D86C0
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773679; cv=none; b=a2Ko0MnCVVbODD1uQ+5lXTBhObjHvgmqWMmy4wEclbw1Df2YW6mUPllqQgepkuuV2slECkGS/0kOPZbRE469c+3ywQaHyTL//3gJPb6z5umVTir4uP4FEIand7iwAT4t4jZc34Uol9EmkohoP8ZYtdcHG6jqQ2e+psDTuAGgcLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773679; c=relaxed/simple;
	bh=0yWYBxQ5df5heNYs6MCkIVTWVPIq32aPHFEtoZs9WBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOr5owB9suqdNem0RDq+6Jknr89RXpq0IBw4TS51aaJj2UBHpMMo+LFMgZTXcrzlO6cwuTSUn2cfbm0M3kKh1sV/HZW0vtmzB+ku8R5g7MmS7eXFZroHRg6+JbgRA465yvXINc+K1cLigYzCxFmnSDDGZ6QfhIxAAD6onPZz9Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QNd36G+2; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729773675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnzhILkgt6W7qUGP952fPh9ASE4oX3Lkb/mnr8vnxOg=;
	b=QNd36G+2pIGqhfi7YKvRsKRGLVp+glMURAbY2rebwN6DcCMVhRPzJOSoNuoWe5K59MhPgA
	l1TRljSRsYJ6ZaMUWlBjguFVMngDBDVWQOQyiqxtwLgbspOyQUDG/U8Zsn88TroS5NAES+
	HFmHuLT1tCWu03JTT3wwIjX2znquRSg=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] riscv: sbi: Clean up env checking
Date: Thu, 24 Oct 2024 14:41:04 +0200
Message-ID: <20241024124101.73405-7-andrew.jones@linux.dev>
In-Reply-To: <20241024124101.73405-5-andrew.jones@linux.dev>
References: <20241024124101.73405-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a couple helpers to cleanup checking of test configuration
environment variables.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index d46befa1c6c1..1e7314ec8d98 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -74,6 +74,20 @@ static phys_addr_t get_highest_addr(void)
 	return highest_end - 1;
 }
 
+static bool env_enabled(const char *env)
+{
+	char *s = getenv(env);
+
+	return s && (*s == '1' || *s == 'y' || *s == 'Y');
+}
+
+static bool env_disabled(const char *env)
+{
+	char *s = getenv(env);
+
+	return !(s && (*s == '0' || *s == 'n' || *s == 'N'));
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
@@ -348,7 +362,6 @@ static void check_dbcn(void)
 	bool highmem_supported = true;
 	phys_addr_t paddr;
 	struct sbiret ret;
-	const char *tmp;
 	char *buf;
 
 	report_prefix_push("dbcn");
@@ -371,13 +384,11 @@ static void check_dbcn(void)
 	dbcn_write_test(&buf[PAGE_SIZE - num_bytes / 2], num_bytes, false);
 	report_prefix_pop();
 
-	tmp = getenv("SBI_HIGHMEM_NOT_SUPPORTED");
-	if (tmp && atol(tmp) != 0)
+	if (env_enabled("SBI_HIGHMEM_NOT_SUPPORTED"))
 		highmem_supported = false;
 
 	report_prefix_push("high boundary");
-	tmp = getenv("SBI_DBCN_SKIP_HIGH_BOUNDARY");
-	if (!tmp || atol(tmp) == 0)
+	if (env_disabled("SBI_DBCN_SKIP_HIGH_BOUNDARY"))
 		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes,
 				     HIGH_ADDR_BOUNDARY - PAGE_SIZE, PAGE_SIZE - num_bytes / 2,
 				     highmem_supported);
@@ -386,12 +397,8 @@ static void check_dbcn(void)
 	report_prefix_pop();
 
 	report_prefix_push("high page");
-	tmp = getenv("SBI_DBCN_SKIP_HIGH_PAGE");
-	if (!tmp || atol(tmp) == 0) {
-		paddr = HIGH_ADDR_BOUNDARY;
-		tmp = getenv("HIGH_PAGE");
-		if (tmp)
-			paddr = strtoull(tmp, NULL, 0);
+	if (env_disabled("SBI_DBCN_SKIP_HIGH_PAGE")) {
+		paddr = getenv("HIGH_PAGE") ? strtoull(getenv("HIGH_PAGE"), NULL, 0) : HIGH_ADDR_BOUNDARY;
 		dbcn_high_write_test(DBCN_WRITE_TEST_STRING, num_bytes, paddr, 0, highmem_supported);
 	} else {
 		report_skip("user disabled");
@@ -400,8 +407,7 @@ static void check_dbcn(void)
 
 	/* Bytes are read from memory and written to the console */
 	report_prefix_push("invalid parameter");
-	tmp = getenv("INVALID_ADDR_AUTO");
-	if (tmp && atol(tmp) == 1) {
+	if (env_enabled("INVALID_ADDR_AUTO")) {
 		paddr = get_highest_addr() + 1;
 		do_invalid_addr = true;
 	} else if (env_or_skip("INVALID_ADDR")) {
-- 
2.47.0


