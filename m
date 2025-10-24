Return-Path: <kvm+bounces-61065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A5EC07F70
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:51:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00CCA403CCB
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E032E2DC785;
	Fri, 24 Oct 2025 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i3U737rN"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151222D877C;
	Fri, 24 Oct 2025 19:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335391; cv=none; b=X0UGzJ+BzqgYksDx4F9V3EJz2FWi53IY63hJifmcnufQinnWb/8RHWOAZ0aBuESIrjOi/hgkBGbof+QAvLIcsYlHDqpkb9THtdz1Fa+lEjpmYijRR7BQEo1/i+4XSp3zunfK8usSX5NZpSVIjyWoj3K0xoiDaW+BRRklct3GJHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335391; c=relaxed/simple;
	bh=+F7ij+vEsbAm2wdn42Abhvi+JQ8gS80qyP155wctWD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWhhOt1tF/YKi44T4EFHEkZyZijEOLwh5L3ZGuK15c+jLTAjUrNYb8fbTQQNpeFr8icJVmw8AWgfDY/LW7ZEvXm/uNQUrlHh68MaCycbHui8sIyItPfyqBtW8EwdS726t2WzaCCT/v1HRY4NNc2BdNN7tTtbUCLcuQzYNlS5cQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i3U737rN; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761335388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pr2b/97PTZcMzhNxqU5YG5YL4UQWiEMP6139KzQTUy8=;
	b=i3U737rNACxpeGjwiC75NITgX9iA+Zr5U/Zf8mWyELLxd9CGPkiAcckzj2HBEwJvWCOEgY
	BNd6J6pSUGAPRaZkh0Ke0wg1ep9nztlCOTqc7IyJCIt+mY67vP0J2jwZk87VDKZoScD5Zd
	M4nIleYYlLtTqMfcsIVIp7+T5d0wbMY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [kvm-unit-tests 5/7] x86/svm: Move report_svm_guest() to the top of svm_tests.c
Date: Fri, 24 Oct 2025 19:49:23 +0000
Message-ID: <20251024194925.3201933-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251024194925.3201933-1-yosry.ahmed@linux.dev>
References: <20251024194925.3201933-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Move the macro ahead of other tests that will start using it.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 x86/svm_tests.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index feeb27d6..61ab63db 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -37,6 +37,21 @@ u64 latclgi_max;
 u64 latclgi_min;
 u64 runs;
 
+/*
+ * Report failures from SVM guest code, and on failure, set the stage to -1 and
+ * do VMMCALL to terminate the test (host side must treat -1 as "finished").
+ * TODO: fix the tests that don't play nice with a straight report, e.g. the
+ * V_TPR test fails if report() is invoked.
+ */
+#define report_svm_guest(cond, test, fmt, args...)	\
+do {							\
+	if (!(cond)) {					\
+		report_fail(fmt, ##args);		\
+		set_test_stage(test, -1);		\
+		vmmcall();				\
+	}						\
+} while (0)
+
 static void null_test(struct svm_test *test)
 {
 }
@@ -1074,21 +1089,6 @@ static bool lat_svm_insn_check(struct svm_test *test)
 	return true;
 }
 
-/*
- * Report failures from SVM guest code, and on failure, set the stage to -1 and
- * do VMMCALL to terminate the test (host side must treat -1 as "finished").
- * TODO: fix the tests that don't play nice with a straight report, e.g. the
- * V_TPR test fails if report() is invoked.
- */
-#define report_svm_guest(cond, test, fmt, args...)	\
-do {							\
-	if (!(cond)) {					\
-		report_fail(fmt, ##args);		\
-		set_test_stage(test, -1);		\
-		vmmcall();				\
-	}						\
-} while (0)
-
 bool pending_event_ipi_fired;
 bool pending_event_guest_run;
 
-- 
2.51.1.821.gb6fe4d2222-goog


