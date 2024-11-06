Return-Path: <kvm+bounces-30873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA4C9BE12C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5BDA1F241DC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8AC1D54D1;
	Wed,  6 Nov 2024 08:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sYAxvGel"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0017D3F4
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882374; cv=none; b=qpWbImTKKVpb+TM4U9scVzbI5iWZz36ATj3iKULQdnoSN2FZ6c9Va6fKtAGMEmHQ6cqCdp7lC2ovDmVcZH8VNi8qzy8ZewKfLfbzigl1Tv5/DcPm+xsC0aDboyRBrHLaK7NgMUzm//ZWnq1Hw4mC7lKgxWV3/7rFl9i2GUwGlo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882374; c=relaxed/simple;
	bh=FO2ifaA4FIs1iMGipAgqd1nFX9yYIQsGlR8BdAFDUN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E25pN7UGyzHb13M1PSf/frqif90mFknWuFxjUoggsXc2Kp8ZERzreT1L+DNzTlAy/cxjelKKlluaIuORqqVpsC7+l8jgRxjZvGtPUpgkfn0DPEZyBkf3zUgkNCwTzjShl5xezGTfb++CxjsavAPbMgmDfVNkn2kwL5j3rgy9Wqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sYAxvGel; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730882370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i29cIvXq/FeIo2TGOkd1TjVGAgWemdxZM+ncT1KUj9o=;
	b=sYAxvGelwggw7R0yIHMwh5CvNvNRSqOhnzul/iG7IXienNtp3fYH3A5MrjUMnxKhxJkoPs
	Ys/JHckiH+7hnTzuj8Dd16mCs9+OseGdY0ke8WfHICvdlDqtur8FDEaXW5TtvcBqYsW97b
	kEzd6yp9sTXr6jn6rlLE7eoIl0EWrzk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2] riscv: sbi: Improve spec version test
Date: Wed,  6 Nov 2024 09:39:27 +0100
Message-ID: <20241106083926.14595-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

SBI spec version states that bit 31 must be zero and, when xlen
is greater than 32, that bit 32 and higher must be zero. Check
these bits are zero in the expected value to ensure we test
appropriately.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/sbi.c |  2 +-
 riscv/sbi.c     | 13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 8972e765fea2..f25bde169490 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -107,7 +107,7 @@ long sbi_probe(int ext)
 	struct sbiret ret;
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
-	assert(!ret.error && ret.value >= 2);
+	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
 	assert(!ret.error);
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 52434e0ca86f..c081953c877c 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -105,18 +105,23 @@ static void check_base(void)
 	report_prefix_push("base");
 
 	ret = sbi_base(SBI_EXT_BASE_GET_SPEC_VERSION, 0);
-	if (ret.error || ret.value < 2) {
-		report_skip("SBI spec version 0.2 or higher required");
-		return;
-	}
 
 	report_prefix_push("spec_version");
 	if (env_or_skip("SBI_SPEC_VERSION")) {
 		expected = (long)strtoul(getenv("SBI_SPEC_VERSION"), NULL, 0);
+		assert_msg(!(expected & BIT(31)), "SBI spec version bit 31 must be zero");
+		assert_msg(__riscv_xlen == 32 || !(expected >> 32), "SBI spec version bits greater than 31 must be zero");
 		gen_report(&ret, 0, expected);
 	}
 	report_prefix_pop();
 
+	ret.value &= 0x7ffffffful;
+
+	if (ret.error || ret.value < 2) {
+		report_skip("SBI spec version 0.2 or higher required");
+		return;
+	}
+
 	report_prefix_push("impl_id");
 	if (env_or_skip("SBI_IMPL_ID")) {
 		expected = (long)strtoul(getenv("SBI_IMPL_ID"), NULL, 0);
-- 
2.47.0


