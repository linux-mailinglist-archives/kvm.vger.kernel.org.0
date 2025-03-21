Return-Path: <kvm+bounces-41692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5799CA6C0AF
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 044497A8B7D
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BD222DF9F;
	Fri, 21 Mar 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IDzwI5Zg"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7922D798
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742576057; cv=none; b=qMb7/KBOxB4uRniqq3635MWFO5gF91TE5/mPEAKeHwOnGRbPJoNXqo07Xf3jBY7ofiSGdSAA/F8GoH4wtN1Ep8ttJTPaiGMD6PQd1pPHe6uuK1pTO+szAUPKiOi6YlYbxDorPkv3tyBgfvE5TedAZEcl2zZh9+8L+u0yj7d1LnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742576057; c=relaxed/simple;
	bh=LQy2BpsJNqJRQtLtOSIbjCqjkePGZ7+3X1JuspfVXM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLjsxDcAreHNEK3y3HlYL+I8Hetoj6eSuD3qNHlUjILoiIYXoALRvFZZQXRi5tejXr5kZxX9BpdbeLuHjzjGGYtNeW9dbslzCogrnfz1KIDb/T7Q8v8rWiWPJoSNtbaGd7uABnIhpB8PaYKrwtLCCBRxOGfAjREhSflj9f4a5c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IDzwI5Zg; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742576051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PKtK3T8rQ5Y+UYKn5E6rBhpv2qWXGv+TG0wqcWzYaf8=;
	b=IDzwI5ZgUb7t4iU+0juMWN+ZBm8S3yokyisfop8Qtzgb8Wr7GYhrpxH+LnDfn0c3pqVa/X
	9WmhoaQRycHK3P7IO16oaawvV+a9mCY6cNI0pUKXlm6K552hob1zsCeiaDkzMOsr6SMLBw
	c2iWC7DoHrTUJCW7OaEUswtPc9Eb33c=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: cleger@rivosinc.com,
	atishp@rivosinc.com,
	akshaybehl231@gmail.com
Subject: [kvm-unit-tests PATCH 2/3] riscv: sbi: Add kfail versions of sbiret_report functions
Date: Fri, 21 Mar 2025 17:54:06 +0100
Message-ID: <20250321165403.57859-7-andrew.jones@linux.dev>
In-Reply-To: <20250321165403.57859-5-andrew.jones@linux.dev>
References: <20250321165403.57859-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

report_kfail is useful for SBI testing to allowing CI to PASS even
when SBI implementations have known failures. Since sbiret_report
functions are frequently used by SBI tests, make kfail versions of
them too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/sbi-tests.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index ddfad7fef293..d5c4ae709632 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -39,7 +39,8 @@
 #include <libcflat.h>
 #include <asm/sbi.h>
 
-#define __sbiret_report(ret, expected_error, expected_value, has_value, expected_error_name, fmt, ...) ({	\
+#define __sbiret_report(kfail, ret, expected_error, expected_value,						\
+			has_value, expected_error_name, fmt, ...) ({						\
 	long ex_err = expected_error;										\
 	long ex_val = expected_value;										\
 	bool has_val = !!(has_value);										\
@@ -48,9 +49,9 @@
 	bool pass;												\
 														\
 	if (has_val)												\
-		pass = report(ch_err && ch_val, fmt, ##__VA_ARGS__);						\
+		pass = report_kfail(kfail, ch_err && ch_val, fmt, ##__VA_ARGS__);				\
 	else													\
-		pass = report(ch_err, fmt ": %s", ##__VA_ARGS__, expected_error_name);				\
+		pass = report_kfail(kfail, ch_err, fmt ": %s", ##__VA_ARGS__, expected_error_name);		\
 														\
 	if (!pass && has_val)											\
 		report_info(fmt ": expected (error: %ld, value: %ld), received: (error: %ld, value %ld)",	\
@@ -63,14 +64,23 @@
 })
 
 #define sbiret_report(ret, expected_error, expected_value, ...) \
-	__sbiret_report(ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
+	__sbiret_report(false, ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
 
 #define sbiret_report_error(ret, expected_error, ...) \
-	__sbiret_report(ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
+	__sbiret_report(false, ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
 
 #define sbiret_check(ret, expected_error, expected_value) \
 	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
 
+#define sbiret_kfail(kfail, ret, expected_error, expected_value, ...) \
+	__sbiret_report(kfail, ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
+
+#define sbiret_kfail_error(kfail, ret, expected_error, ...) \
+	__sbiret_report(kfail, ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
+
+#define sbiret_check_kfail(kfail, ret, expected_error, expected_value) \
+	sbiret_kfail(kfail, ret, expected_error, expected_value, "check sbi.error and sbi.value")
+
 static inline bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
-- 
2.48.1


