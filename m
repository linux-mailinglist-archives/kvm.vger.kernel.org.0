Return-Path: <kvm+bounces-23857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D444894EF42
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 16:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D51A01C21C6E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA2F17E902;
	Mon, 12 Aug 2024 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p8uP2XhY"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC6717E47A
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723472048; cv=none; b=quA6AEgarISkpCrOQfzN/NnjEl8KMPOHS851Is71USfOCN5Ei2i3iPbPMjYXBA3X58kfxLMmwCODaB/83r9eKHM/EpV4HgHMGrET1YVgSjeMGnqMPRK/ThIYKjSlvtlWB+ig7zgGrprIFSX1QvfLVHG3ocd5bQGgCYitnuODHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723472048; c=relaxed/simple;
	bh=Tly0u8fLrFMPiyltX8Q0BL6IV/kyYFKfA6dCoyLMmic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdDk08SCmCEHLYQepqQMfZsAn3BhEa3cClBqh2p5itxZeZzF+HLrfJDD+pGDbwbHOUFECpncAa7zkVhIjLVgKfK4jUmYVvew7qtAg/ytig6CfmwG7+SEZlrngRKqU2Tez+zVBbHro/j5x8bXUJ9vY7yuNpJXttlwTEPipgW8xeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p8uP2XhY; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723472044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iYX6kGglESM6CdwC18ttg651AtfAE9zmr/i9M+sIAk=;
	b=p8uP2XhYmr+8yOUvIajF9qHHC1XuadpXSoTvbqQR4rXIQXIteUeKclgbN/zQdR1H3dbd1k
	J64WM+xgmlC2Psy6LLJoAEy1onGq+YfKVGPdlMnQPug5fFrEEV2hVvL/vSffO0r6+W7HP9
	9Ip4juu9m2eP1n15YIeStTQGB7gqFWc=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 1/4] riscv: sbi: dbcn: Output return values
Date: Mon, 12 Aug 2024 16:13:56 +0200
Message-ID: <20240812141354.119889-7-andrew.jones@linux.dev>
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

When a test fails its nice to be able to see exactly what error code
it failed with in order to immediately start debug.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 93a79d8095f5..2393929b965d 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -299,7 +299,7 @@ static void check_dbcn(void)
 		num_calls++;
 	} while (num_bytes != 0 && ret.error == SBI_SUCCESS);
 
-	report(ret.error == SBI_SUCCESS, "write success");
+	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
 	report_info("%d sbi calls made", num_calls);
 
 	/* Bytes are read from memory and written to the console */
@@ -307,7 +307,7 @@ static void check_dbcn(void)
 		paddr = strtoull(getenv("INVALID_ADDR"), NULL, 0);
 		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
 		ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE, 1, base_addr_lo, base_addr_hi);
-		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address");
+		report(ret.error == SBI_ERR_INVALID_PARAM, "invalid parameter: address (error=%ld)", ret.error);
 	}
 
 	report_prefix_pop();
@@ -317,8 +317,8 @@ static void check_dbcn(void)
 	puts("DBCN_WRITE TEST CHAR: ");
 	ret = __dbcn_sbi_ecall(SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, (u8)DBCN_WRITE_BYTE_TEST_BYTE, 0, 0);
 	puts("\n");
-	report(ret.error == SBI_SUCCESS, "write success");
-	report(ret.value == 0, "expected ret.value");
+	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
+	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
 
 	report_prefix_pop();
 }
-- 
2.45.2


