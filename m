Return-Path: <kvm+bounces-40968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B0BA5FD2B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ACB23A60BB
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F4E269D1B;
	Thu, 13 Mar 2025 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P0BUncPr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF601153801
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741885984; cv=none; b=UzVniKnDYceuQ2FtaLbBH6WqoN74eMl8mJBGN+vhZvdG4oRIZX9ikTBF+0R71BptKyp5ZtQ7pTMSdo9y3mLbtlkEODEJtTsjZ1Wqv67z3E+b8GP9CtJOE5Eqme+riwBAYN/2lQzlsttMs9T4zt+NVTOZ8w7ZLZLxo35jONxLuWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741885984; c=relaxed/simple;
	bh=63WGMrgE8742RS2vSZX0b1VjBXEsC5nWCRHw+mmlcEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aPfDadl6QGx5R86SrGV5Dm4eVxo99gug0TPA8JSVYs1UY0wY9i9qIZe6YVLc0ZcstCURg5z4tqhuENK+AO3eopqMGIQkx/jkmTboIgWGik+tKTuzOY3jGSSyXS4fYWZ9VBOiVW/84QUrTG4riCp6KhgpbD/IRu1FHiVwh3TE8Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P0BUncPr; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fee4d9c2efso2274159a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 10:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741885982; x=1742490782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Xm0BsWn1WY6WuthcZfVhLUHtjthjOY7BniBvnviaHc=;
        b=P0BUncPrLCcEkrOSox5u1QsmYQzfb+eUvXelt4XAF8W+8c5spjpFPWtP5wQjYwxitu
         JILEzGzh9RVCfOnT6tZE7n7Wr+1FiBe8bTkolYTloPgRtVx4+WR0LHRBRUCpugBSfD3H
         Yg3gTzbERHJ9U4qJd8u6H1Bj/dqwvRfx4wTFFgUsDVyu/7mckNVKazPVJTCMtyJ4wper
         1C3VjChFdEQGJ47UsJdH7RxMBDcqiY5AKVSDV866EmLCwUOH63yT9N3VGbWKiid0e0jY
         1kyG9iipYGW8Sbdvyl1spL0v5jZ0T26J/etHEuvFBx3Q8xeXaeLMSxdDeVdSiNukQOxz
         6Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741885982; x=1742490782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Xm0BsWn1WY6WuthcZfVhLUHtjthjOY7BniBvnviaHc=;
        b=rchGDXoA5okagAeMNz66oWFS9FpzxdntgQknfg96W28eAu7EHEIzZz0WUDCNMVS8og
         Pdj2cEbtOYDBJzO8F8PgZgmlQy79kYPcmrdf87yhdmaVGgx05T3skHnMDi+UtUwhk9wU
         FdqHH9hYkCLN8u7ENh70MRF9mMtQJG1NpwGnT55lamMu9j/SpGdl/fa95ZrGny7HuWvP
         vrfU0gv3cVHJ78U1CirV5TQv2quCjc0Lm5UNTYXYuUWNe7NRGw0zE/dfPrDiQq3n9cIF
         a2o+VL0NBfyep1jocc1U7Ao3M2IyZ+PsO9ZHGswHrp2Z5TlRTXarKKVtAnjBY8tFjTXZ
         HCQw==
X-Gm-Message-State: AOJu0YyQNr6nuint0kR+X7t0RzGdlhvJn/KVaXu2IAzotxHAGjzA84S3
	6nLkM2htonTCzmwYHPopSsp1OOLukHWv2rqBvhh891RU2tBQeEY4uBwwwReMTRU=
X-Gm-Gg: ASbGncswuKl9I6O4s7qqW7m/YMG5LZGSer/5UlkRxB+x0wWQviModx/s9AEOZl//qqA
	mM2FX9lYOQfOte59zsIQ95Cm5nq8P+s7Wo6vIUITIOeqfpimz8MYfXvTx06UhVkGFjVCXbFKQym
	2NwZ1yizBVa+vGm9E+oahV/lpwnxm1WgesZfLZPVNafuDtCz7o1wMg3yp9aKNMDrXj0gLbyFec0
	SXU/5K5iHPeHsBzMDXZEOziOfnkulty8X+sWJ8Kiot+2C814b/vOoDWhX4S/xGp8EGP+5DBPuaD
	1FGYcYI6XxCwiBfSiajJ5EZQfnMRVmppl8CTCf+s/PyF8oRuCo0rabGpjvwI
X-Google-Smtp-Source: AGHT+IGPJDKbQMJtWg0vTfejXTuz/ev0Zb0+4f0+lDnvj30WMFy67e4d1PveMV8dbMzROaMev1XgaQ==
X-Received: by 2002:a17:90b:5246:b0:2ee:e518:c1cb with SMTP id 98e67ed59e1d1-3014e8212f8mr412036a91.7.1741885981519;
        Thu, 13 Mar 2025 10:13:01 -0700 (PDT)
Received: from pop-os.. ([2401:4900:1cd6:1271:416a:a7f4:64eb:439f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba723fsm15743445ad.107.2025.03.13.10.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 10:13:00 -0700 (PDT)
From: Akshay Behl <akshaybehl231@gmail.com>
To: kvm@vger.kernel.org
Cc: andrew.jones@linux.dev,
	cleger@rivosinc.com,
	atishp@rivosinc.com,
	Akshay Behl <akshaybehl231@gmail.com>
Subject: [RFC kvm-unit-tests PATCH v2] riscv: Refactoring sbi fwft tests
Date: Thu, 13 Mar 2025 22:42:23 +0530
Message-Id: <20250313171223.551383-1-akshaybehl231@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250313075845.411130-1-akshaybehl231@gmail.com>
References: <20250313075845.411130-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch refactors the current sbi fwft tests
(pte_ad_hw_updating, misaligned_exc_deleg)

v2:
 - Made env_or_skip and env_enabled methods shared by adding
   them to sbi-tests.h
 - Used env_enabled check instead of env_or_skip for
   platform support
 - Added the reset to 0/1 test back for pte_ad_hw_updating
 - Made other suggested changes

Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
---
 riscv/sbi-tests.h | 22 ++++++++++++++++++++++
 riscv/sbi-fwft.c  | 38 +++++++++++++++++++++++++++-----------
 riscv/sbi.c       | 17 -----------------
 3 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index b081464d..91eba7b7 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -70,6 +70,28 @@
 #define sbiret_check(ret, expected_error, expected_value) \
 	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
 
+/**
+ * Check if environment variable exists, skip test if missing
+ *
+ * @param env The environment variable name to check
+ * @return true if environment variable exists, false otherwise
+ */
+static inline bool env_or_skip(const char *env)
+{
+	if (!getenv(env)) {
+		report_skip("missing %s environment variable", env);
+		return false;
+	}
+	return true;
+}
+
+static inline bool env_enabled(const char *env)
+{
+	char *s = getenv(env);
+
+	return s && (*s == '1' || *s == 'y' || *s == 'Y');
+}
+
 void sbi_bad_fid(int ext);
 
 #endif /* __ASSEMBLER__ */
diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
index ac2e3486..581cbf6b 100644
--- a/riscv/sbi-fwft.c
+++ b/riscv/sbi-fwft.c
@@ -66,6 +66,14 @@ static void fwft_check_reserved(unsigned long id)
 	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
 }
 
+/* Must be called before any fwft_set() call is made for @feature */
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
@@ -99,18 +107,28 @@ static struct sbiret fwft_misaligned_exc_get(void)
 static void fwft_check_misaligned_exc_deleg(void)
 {
 	struct sbiret ret;
+	unsigned long expected;
 
 	report_prefix_push("misaligned_exc_deleg");
 
 	ret = fwft_misaligned_exc_get();
-	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
-		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
+	if (ret.error != SBI_SUCCESS) {
+		if (env_enabled("SBI_HAVE_FWFT_MISALIGNED_EXC_DELEG")) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
+			return;
+		}
+		report_skip("not supported by platform");
 		return;
 	}
 
 	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Get misaligned deleg feature"))
 		return;
 
+	if (env_or_skip("MISALIGNED_EXC_DELEG_RESET")) {
+		expected = strtoul(getenv("MISALIGNED_EXC_DELEG_RESET"), NULL, 0);
+		fwft_check_reset(SBI_FWFT_MISALIGNED_EXC_DELEG, expected);
+	}
+
 	ret = fwft_misaligned_exc_set(2, 0);
 	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
 			    "Set misaligned deleg feature invalid value 2");
@@ -129,16 +147,10 @@ static void fwft_check_misaligned_exc_deleg(void)
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
 
@@ -261,7 +273,11 @@ static void fwft_check_pte_ad_hw_updating(void)
 	report_prefix_push("pte_ad_hw_updating");
 
 	ret = fwft_get(SBI_FWFT_PTE_AD_HW_UPDATING);
-	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+	if (ret.error != SBI_SUCCESS) {
+		if (env_enabled("SBI_HAVE_FWFT_PTE_AD_HW_UPDATING")) {
+			sbiret_report_error(&ret, SBI_SUCCESS, "supported");
+			return;
+		}
 		report_skip("not supported by platform");
 		return;
 	} else if (!sbiret_report_error(&ret, SBI_SUCCESS, "get")) {
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 0404bb81..219f7187 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -131,23 +131,6 @@ static phys_addr_t get_highest_addr(void)
 	return highest_end - 1;
 }
 
-static bool env_enabled(const char *env)
-{
-	char *s = getenv(env);
-
-	return s && (*s == '1' || *s == 'y' || *s == 'Y');
-}
-
-static bool env_or_skip(const char *env)
-{
-	if (!getenv(env)) {
-		report_skip("missing %s environment variable", env);
-		return false;
-	}
-
-	return true;
-}
-
 static bool get_invalid_addr(phys_addr_t *paddr, bool allow_default)
 {
 	if (env_enabled("INVALID_ADDR_AUTO")) {
-- 
2.34.1


