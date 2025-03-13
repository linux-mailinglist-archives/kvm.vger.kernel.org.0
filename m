Return-Path: <kvm+bounces-40905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2132BA5ED73
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5681417284E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA25E260361;
	Thu, 13 Mar 2025 07:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b9WoviTd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3D1F755B
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741852735; cv=none; b=lVt2yLqvUNzMBfgLJljvFmNPkWDbPOY9jUtks0nrkyRYX5dP/63+BgaYMBwaQs2plcMepxfScgmRuzoxtwWeY5Qea16A7BdthcwGZpXjqsTlpA7tSvxoKiLugpcfLxq+8Eq6ACPd8SsEFwaRu5hmJUY9N+FAO3x47fPZbmF2Oq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741852735; c=relaxed/simple;
	bh=9qFPkYnZNelQtGHzve+Fz45RovYY07Pq8IVUZNyTEYg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pRNeD/HhbOdzQUG/pE2ljpXa/nDlDsAxIpk/RuOcApz5kgG3Quxis01s/+ZjzB0JB0EiLCJin8oCkA/+jSVejWvtfIRg7sMO8C5ydaGjU1knW7h3uUMgXbkQdCAX/KkZIN02hA3Tyjb3NWuchnF26c8jk+NKWnT2c3HWpEzXtdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b9WoviTd; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ff694d2d4dso1231425a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 00:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741852733; x=1742457533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s6k2Fa6so7O4oxSKWMYnFD8fKUfqpdwMhofImMQ3pNc=;
        b=b9WoviTdHQg1RcAXGwvheDblyvUb3HpUIblELlHj1vrwr9iGvF40sibnd/FYDE8XLZ
         sOzhqoB+XN9+4ornsFZWLom2UHPvmpjklty8c3FyTEcKPdnMfo5Pq4xNgPBaojTwy1by
         1EqgA4dotTslEt5q6ciiOuJKMYnA1V80WSQV+87ghnEYuW8VASsS9ZdzNqVGJ5Vkfwy8
         I9hsPnyJ+Uqww4k98uocn+Gd6E0V8lokuMU2E9O92LcpjhGcyoG3sbNFRjSyHpH8MqUF
         r/lzDdyRKnXueBmqwmRn3/YM6XzIotXHmHZkSjeEltGN7zKiPr+/QaB8Y63PahWmuaIE
         w62g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741852733; x=1742457533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6k2Fa6so7O4oxSKWMYnFD8fKUfqpdwMhofImMQ3pNc=;
        b=PAWaJkAZqcZYqRqpvlcUzDnEE/JOq0zSHLzdIPcYknGxRROi1VhePVeh53sBunmCNG
         RHQkcKCdyvkfWHMM1QTwwsFbuI99BHFr3KWmi0llenZqZ6cdHLDenSvmqk90Er4rZRyy
         pmFWlYDzYmQWQZgUDIajV3JfOlppxMTz+LOelCm8ZFTek19J/EL2Kq95KvEsm04mhLe5
         fYFHbdoNKC2EVNtlFy4dYS49WyTykUpY52sjCYT3KcC2sxWveSKYnGojFzX9UsPo6HXT
         ZoErx/jJEfKOGCa2iUN2Rb77E/zxLX4ut7AwXp/mO2RoIwTfJUE7/iUDzEKnyyebxejT
         NLNg==
X-Gm-Message-State: AOJu0YwmZWGpolv/y0EjtCqpiwrU2RPHasdGFGOCnAR9055LepZlVuys
	SuAMFZ81soGsubw9mZ20twfibPX/tFZKXchiDb6JJkeDCK1QHri9LOphlXDhv76wEQ==
X-Gm-Gg: ASbGncsIeG3H/x+9mUI73drkEqIlZqDs51AtLvwCmeE7d/ze4BKAxJE2Kp1/ya1IQGC
	Diw53yIFKpBhHJ1S1Y0F/I7Gx5FSaeNr6MZgAlfwl87O8dk9PpvPyyyHZ0HHvjjxq4W9nwmWH8Y
	iBQjVKmfQ6r2wsvDimEWwk5g3M8KLUJzVFeL/vNufIRYBmhn4HzBAcQ6FhKTL5VEKcvR7DYMXBJ
	7BtlB6yaA14EvN2rbDy2GpebWfu2YEvtizfFdO/jh534wSe9oKWF014sW1iUegYoU4cWyADHcxH
	/uycvKmEQJzzO0egZosuG2ffSL/KmN3uRb5i2Q+G7qNpiWVWeQ==
X-Google-Smtp-Source: AGHT+IGCbbBulauOZ03PRW5JxL+BoT5PjfjWg69Xz4th7ioVMWiqzQLCQJ05egeHukSQpEE5KtVxjQ==
X-Received: by 2002:a17:90b:3d8a:b0:2ee:f076:20f1 with SMTP id 98e67ed59e1d1-2ff7cd44ab7mr43037542a91.0.1741852732655;
        Thu, 13 Mar 2025 00:58:52 -0700 (PDT)
Received: from pop-os.. ([2401:4900:1cd6:1271:fb41:44a1:f675:aab0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301027087b3sm2409875a91.0.2025.03.13.00.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 00:58:52 -0700 (PDT)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: andrew.jones@linux.dev,
	cleger@rivosinc.com,
	atishp@rivosinc.com,
	Akshay Behl <akshaybehl231@gmail.com>
Subject: [RFC kvm-unit-tests PATCH] riscv: Refactoring sbi fwft tests
Date: Thu, 13 Mar 2025 13:28:45 +0530
Message-Id: <20250313075845.411130-1-akshaybehl231@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch refactors the current sbi fwft tests
(pte_ad_hw_updating, misaligned_exc_deleg)

Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
---
 riscv/sbi-fwft.c | 58 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index ac2e3486..bf735f62 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -19,6 +19,15 @@
 
 void check_fwft(void);
 
+static bool env_or_skip(const char *env)
+{
+	if (!getenv(env)) {
+		report_skip("missing %s environment variable", env);
+		return false;
+	}
+
+	return true;
+}
 
 static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
 {
@@ -66,6 +75,13 @@ static void fwft_check_reserved(unsigned long id)
 	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
 }
 
+static void fwft_check_reset(uint32_t feature, unsigned long reset)
+{
+	struct sbiret ret = fwft_get(feature);
+
+	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
+}
+
 static void fwft_check_base(void)
 {
 	report_prefix_push("base");
@@ -99,18 +115,32 @@ static struct sbiret fwft_misaligned_exc_get(void)
 static void fwft_check_misaligned_exc_deleg(void)
 {
 	struct sbiret ret;
+	unsigned long expected;
 
 	report_prefix_push("misaligned_exc_deleg");
 
 	ret = fwft_misaligned_exc_get();
-	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
-		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
+	if (ret.error != SBI_SUCCESS) {
+		if (env_or_skip("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG")) {
+			expected = (unsigned long)strtoul(getenv("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG"), NULL, 0);
+			if (expected == 1)
+			{
+				report_fail("not supported by platform");
+				return;
+			}
+		}
+		report_skip("not supported by platform");
 		return;
 	}
 
 	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Get misaligned deleg feature"))
 		return;
 
+	if (env_or_skip("MISALIGNED_EXC_DELEG_RESET")) {
+		expected = (unsigned long)strtoul(getenv("MISALIGNED_EXC_DELEG_RESET"), NULL, 0);
+		fwft_check_reset(SBI_FWFT_MISALIGNED_EXC_DELEG, expected);
+	}
+
 	ret = fwft_misaligned_exc_set(2, 0);
 	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
 			    "Set misaligned deleg feature invalid value 2");
@@ -129,16 +159,10 @@ static void fwft_check_misaligned_exc_deleg(void)
 #endif
 
 	/* Set to 0 and check after with get */
-	ret = fwft_misaligned_exc_set(0, 0);
-	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0");
-	ret = fwft_misaligned_exc_get();
-	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg feature expected value 0");
+	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
 
 	/* Set to 1 and check after with get */
-	ret = fwft_misaligned_exc_set(1, 0);
-	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 1");
-	ret = fwft_misaligned_exc_get();
-	sbiret_report(&ret, SBI_SUCCESS, 1, "Get misaligned deleg feature expected value 1");
+	fwft_set_and_check_raw("", SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
 
 	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
 
@@ -257,11 +281,20 @@ static void fwft_check_pte_ad_hw_updating(void)
 {
 	struct sbiret ret;
 	bool enabled;
+	unsigned long expected;
 
 	report_prefix_push("pte_ad_hw_updating");
 
 	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
-	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+	if (ret.error != SBI_SUCCESS) {
+		if (env_or_skip("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
+			expected = (unsigned long)strtoul(getenv("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING"), NULL, 0);
+			if (expected == 1)
+			{
+				report_fail("not supported by platform");
+				return;
+			}
+		}
 		report_skip("not supported by platform");
 		return;
 	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get")) {
@@ -269,10 +302,9 @@ static void fwft_check_pte_ad_hw_updating(void)
 		return;
 	}
 
-	report(ret.value == 0 || ret.value == 1, "first get value is 0/1");
+	fwft_check_reset(SBI_FWFT_PTE_AD_HW_UPDATING, 1);
 
 	enabled = ret.value;
-	report_kfail(true, !enabled, "resets to 0");
 
 	install_exception_handler(EXC_LOAD_PAGE_FAULT, adue_read_handler);
 	install_exception_handler(EXC_STORE_PAGE_FAULT, adue_write_handler);
-- 
2.34.1


