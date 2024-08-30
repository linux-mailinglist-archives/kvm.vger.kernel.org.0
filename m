Return-Path: <kvm+bounces-25541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D92966628
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DB9A1F21546
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C531B86E1;
	Fri, 30 Aug 2024 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pK52v/su"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90021B86DD
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033233; cv=none; b=Wc6XXBiYl07CSX3yj2+yiF9qNSiA7dpxgig5me+bbjdoVu3SCUEtaKWrBHaMuGRc+mSPsm1HbUN08vPGt02VvJ/XHtE0Sus3AwEZ9FuyDdzW2evyI25Qf0tYErFMv5ie+1gAg2OAx9GIT3gsEPgHQuu5FxpGqeGKvby8oljuD3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033233; c=relaxed/simple;
	bh=B5Ptou+38oFmlHLIFp7fejSG33MAYNMakwm6qsa+/do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUmJvOExZYCXX0ieyqesQhR1fJSEQd93tVM+4dgZA/Ou7Kw8zHcUI/iIXqeAIC4dEQcOw/W9h1u+EhG1xg9qPd5BNAocM5RVHSa2WRhGy3uX6fgtmaASrRo5AoLat5A2LlfBAHSV44U18JNj0808ClKvNYa1B+IOsdRjX0isSrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pK52v/su; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725033229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jADyrI0MHQc0Ju+AG9jA0SQN7WaEFObFU45pTMK0mDM=;
	b=pK52v/suf/DcHSXj5RvlNslsyqhUzbxgkMH5xbuC0yZXGPx2YHeUSHYS5sYZ5xz5LVGuDL
	wJ/ozEtdmiijAU4GtzAsgYotSIZi1+kjch+sxb+PCheoaD0xtFKxHfV5POEr59PgMjBJ8x
	BYNmr5BHox4jXo9BHeMYhhnKETTB+00=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/2] sbi: dbcn: Add write-byte test with more than byte given
Date: Fri, 30 Aug 2024 17:53:40 +0200
Message-ID: <20240830155337.335534-6-andrew.jones@linux.dev>
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

Try the write-byte function, but with a word full of characters. We
should still get 'a' since that's in the least-significant byte.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 907bfbe5bb69..a1c97b93cdd0 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -407,12 +407,18 @@ static void check_dbcn(void)
 	report_prefix_pop();
 	report_prefix_push("write_byte");
 
-	puts("DBCN_WRITE TEST CHAR: ");
+	puts("DBCN_WRITE_BYTE TEST BYTE: ");
 	ret = sbi_dbcn_write_byte(DBCN_WRITE_BYTE_TEST_BYTE);
 	puts("\n");
 	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
 	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
 
+	puts("DBCN_WRITE_BYTE TEST WORD: "); /* still expect 'a' in the output */
+	ret = sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, 0x64636261, 0, 0, 0, 0, 0);
+	puts("\n");
+	report(ret.error == SBI_SUCCESS, "write success (error=%ld)", ret.error);
+	report(ret.value == 0, "expected ret.value (%ld)", ret.value);
+
 	report_prefix_pop();
 	report_prefix_pop();
 }
-- 
2.45.2


