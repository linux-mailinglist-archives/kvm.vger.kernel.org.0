Return-Path: <kvm+bounces-62651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D6FC49C15
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0545C188A3A3
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0AE33F398;
	Mon, 10 Nov 2025 23:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EhjnLSZi"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF779303CB2
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817237; cv=none; b=o0elpfk+NaoIkOWbAriwn39tGp94yABL8Eot8xVvbXN6lCjjclHs+mPrFS1eYhaVdaDXCyNCyOiFJRKHyBPrvK1cVm+fAMECuEAhorsoFqFDtZHo75PMvDiujb5gJxqYP5ZtBnbyu0RdWA8HHL6P5ACjvdST6EHkUclx3pSmvZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817237; c=relaxed/simple;
	bh=Tf2WOo+nTdA0kHa5juQ5OUWkXPxlWSD/okXr3AMAQic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNxov4IvLuJHAcVJcr3qfjGTdNw6/fHmcX1tlPEI39wLgBCCIx57D9camMgy6astZdOderKPX3+41dhHDdxIr3P+2O+7FTSntOj8640xUj30UsbpKHmXz6HE+AQbYe/veZsz9tdfdZn7F8LttDqfGRJ3ZK8gWoHOwAEMHCF1nGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EhjnLSZi; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QN+Jb/sMTKw705goXC8AQxOha75Fi5974iJiM9D+sAM=;
	b=EhjnLSZi2hbQf2TDrsHHuE9WjfYeOq6pvHrlli78ZzLZedUwedLtc62AsQtHF8jSX5yKc7
	/baZJOjHuJIbiRT2n8WyF0nyvLR7L7ZZzySy7WQkO1WqkM/NnpHQm1jYE7xRIjxRp5aHA0
	VgqmHjm6h85AIOgtzRjvnEJXaiKMIbA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 07/14] x86/svm: Move report_svm_guest() to the top of svm_tests.c
Date: Mon, 10 Nov 2025 23:26:35 +0000
Message-ID: <20251110232642.633672-8-yosry.ahmed@linux.dev>
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the macro ahead of other tests that will start using it.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index feeb27d61435b..61ab63db462dc 100644
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
2.51.2.1041.gc1ab5b90ca-goog


