Return-Path: <kvm+bounces-16565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C86A8BBB36
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B99F282B85
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DE0224CC;
	Sat,  4 May 2024 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbMaUQJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91711C695
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825741; cv=none; b=lzUsnvfgRKuweK9SDF3jfwu6oOxhazHw4TbWmRYTUwiB/oyWRN1Z+GhG42EN47pJ0aECr8GHcS3halIyEGva/ehA5apk4bQrcILmv5ZdVrYrL1H3X/cmRVGZk3LujrOm8jxNyIdz8EEb4n5xZDcGe+aBkdLmMUMl5Vn3jwnAVcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825741; c=relaxed/simple;
	bh=JxGbPCZm/rRgC3arpm8MHbNYm8NIMZitHsK9hQG8tY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Las3QAW4/+cClza4ctlMxBtXGaf4iAWHEXW+lrgZgDirnsncsGbqpXq40hvo0ctif+2a0zAysBCBf6eX1ars6huOrxMnGqY2nVXVKUhaF5mRXjd30HlfPgdNaVG3ctXcQfSJSbV/SASIKbCgcCsrP0ao/nb0il0P+SOSzXMfbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbMaUQJ3; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f447260f9dso443623b3a.0
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825739; x=1715430539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRZJRuRRFLhuP09XIFiRVicmhI/6wcE/f1lbmYTsJ8g=;
        b=SbMaUQJ36cx3tmWQ3Io/zxEBktMkVbGWRPlosnxgK87x6gzxs/d6kJAEVSiT521qGU
         IbWyiXOfD6M6BJWNuUu/EXelQfc07cHX0J0bQM2GzHNYeKl7VfDb3+HPmKyMJ3QNfHO4
         NsQF8AUCybw6qT2ChtJud6+ieGZlKxqet6GWnUlGc3rvyf3ldZsX8CMdAZuUn+71b6Dy
         HQw7BTmFw0laiLoQhprLBqZ6wRDdPnvZj5nELcEy8it+MZG2wNMf7+ZFYu7PIcD3cwP2
         ymPP2d5O+OltnANtbPiKTWDCC8Cb7mkrxvJxuYtDYCzbd8Ij9nfaSm5Tvx1wGaFDv0JV
         eTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825739; x=1715430539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRZJRuRRFLhuP09XIFiRVicmhI/6wcE/f1lbmYTsJ8g=;
        b=n9KGpFSzLXuS2oflNr+gjie/rfNN5WOIogkDG6RpZ9dCXBDteLPQbGXusArYvYacqc
         NRR1YTTF9pPXHDfgdPd4t4GaPxJjbkXdxhPLxdRZdOsl+l1VaFy0oKbvVcOsvijYQ/so
         90LDiM/zLPkD8FSRzfVD5FDUmUAtI7bYDh2IUhBXhHCJljrH6/az02YuOJJCFnrYFsSC
         cGCLs9iILl3XFoWh+B8OyXq0qkNBvUkoHsHeI73oKPTae5PDX7vbR4AYhGtZWXkYUpxL
         0h0PDyAkRMt4xoUBxkQYOUysmW/YJ+YYdW5vGLibjcirbrawsrZlWpJeLEJC8WDV6MCR
         Uq0g==
X-Forwarded-Encrypted: i=1; AJvYcCUmNYE6v1FZ7/oYOwCXDA9D3i3o/MMyNB0I//BhgLndFLl1iH+slCcWEqpkwpJrfElOj4oIHizK9RfsfwEJcvpAUb1z
X-Gm-Message-State: AOJu0YzRF1nSluKQNYWdvciy6I4zdARLQ4YSr0/oplpm7YR7j8lVFTpg
	M7IPLT6JwjXZvBjXbxNlgqUAB+wuSLe2LxLx0uJ1II2EhSc9tC/7
X-Google-Smtp-Source: AGHT+IFTNbNHpMpZNjRXGh0JKa5s+AXqP40FKU9v2kc69wA5Y0uIM7vdJmn5XaSEQllotSM8lvtZ3g==
X-Received: by 2002:a05:6a00:2da6:b0:6ed:e1c:1034 with SMTP id fb38-20020a056a002da600b006ed0e1c1034mr5646333pfb.34.1714825739079;
        Sat, 04 May 2024 05:28:59 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:28:58 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 02/31] report: Add known failure reporting option
Date: Sat,  4 May 2024 22:28:08 +1000
Message-ID: <20240504122841.1177683-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are times we would like to test a function that is known to fail
in some conditions due to a bug in implementation (QEMU, KVM, or even
hardware). It would be nice to count these as known failures and not
report a summary failure.

xfail is not the same thing, xfail means failure is required and a pass
causes the test to fail. So add kfail for known failures.

Mark the failing ppc64 h_cede_tm and spapr_vpa tests as kfail.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/libcflat.h |  2 ++
 lib/report.c   | 33 +++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 700f43527..ae3c2c6d0 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -100,6 +100,8 @@ extern void report(bool pass, const char *msg_fmt, ...)
 		__attribute__((format(printf, 2, 3), nonnull(2)));
 extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
 		__attribute__((format(printf, 3, 4), nonnull(3)));
+extern void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
+		__attribute__((format(printf, 3, 4), nonnull(3)));
 extern void report_abort(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)))
 					__attribute__((noreturn));
diff --git a/lib/report.c b/lib/report.c
index 8e9bff5b8..7f3c4f059 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -13,7 +13,7 @@
 #include "libcflat.h"
 #include "asm/spinlock.h"
 
-static unsigned int tests, failures, xfailures, skipped;
+static unsigned int tests, failures, xfailures, kfailures, skipped;
 static char prefixes[256];
 static struct spinlock lock;
 
@@ -81,11 +81,12 @@ void report_prefix_pop(void)
 }
 
 static void va_report(const char *msg_fmt,
-		bool pass, bool xfail, bool skip, va_list va)
+		bool pass, bool xfail, bool kfail, bool skip, va_list va)
 {
 	const char *prefix = skip ? "SKIP"
 				  : xfail ? (pass ? "XPASS" : "XFAIL")
-					  : (pass ? "PASS"  : "FAIL");
+				          : kfail ? (pass ? "PASS" : "KFAIL")
+					          : (pass ? "PASS"  : "FAIL");
 
 	spin_lock(&lock);
 
@@ -98,6 +99,8 @@ static void va_report(const char *msg_fmt,
 		skipped++;
 	else if (xfail && !pass)
 		xfailures++;
+	else if (kfail && !pass)
+		kfailures++;
 	else if (xfail || !pass)
 		failures++;
 
@@ -108,7 +111,7 @@ void report(bool pass, const char *msg_fmt, ...)
 {
 	va_list va;
 	va_start(va, msg_fmt);
-	va_report(msg_fmt, pass, false, false, va);
+	va_report(msg_fmt, pass, false, false, false, va);
 	va_end(va);
 }
 
@@ -117,7 +120,7 @@ void report_pass(const char *msg_fmt, ...)
 	va_list va;
 
 	va_start(va, msg_fmt);
-	va_report(msg_fmt, true, false, false, va);
+	va_report(msg_fmt, true, false, false, false, va);
 	va_end(va);
 }
 
@@ -126,7 +129,7 @@ void report_fail(const char *msg_fmt, ...)
 	va_list va;
 
 	va_start(va, msg_fmt);
-	va_report(msg_fmt, false, false, false, va);
+	va_report(msg_fmt, false, false, false, false, va);
 	va_end(va);
 }
 
@@ -134,7 +137,19 @@ void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
 {
 	va_list va;
 	va_start(va, msg_fmt);
-	va_report(msg_fmt, pass, xfail, false, va);
+	va_report(msg_fmt, pass, xfail, false, false, va);
+	va_end(va);
+}
+
+/*
+ * kfail is known failure. If kfail is true then test will succeed
+ * regardless of pass.
+ */
+void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
+{
+	va_list va;
+	va_start(va, msg_fmt);
+	va_report(msg_fmt, pass, false, kfail, false, va);
 	va_end(va);
 }
 
@@ -142,7 +157,7 @@ void report_skip(const char *msg_fmt, ...)
 {
 	va_list va;
 	va_start(va, msg_fmt);
-	va_report(msg_fmt, false, false, true, va);
+	va_report(msg_fmt, false, false, false, true, va);
 	va_end(va);
 }
 
@@ -168,6 +183,8 @@ int report_summary(void)
 	printf("SUMMARY: %d tests", tests);
 	if (failures)
 		printf(", %d unexpected failures", failures);
+	if (kfailures)
+		printf(", %d known failures", kfailures);
 	if (xfailures)
 		printf(", %d expected failures", xfailures);
 	if (skipped)
-- 
2.43.0


