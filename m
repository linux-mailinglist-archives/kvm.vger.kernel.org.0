Return-Path: <kvm+bounces-62647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90247C49BF1
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AE8B94E1FFC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14C422FE11;
	Mon, 10 Nov 2025 23:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cvuAuyIC"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFBD305967
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817232; cv=none; b=nm3tWXbIIbjuueLoZ8lo7Jb5UhDYLblP2YPR+Mtlk2EHru9og2QAbTaY+AUuNRGcjCcB6wt3rK+eFJGZCH+qgptmA1HPq7LP0paUHmpGRcQ6aqJebXBvbPvaq23Bicdl0Uqs2KOugHl8JDzMrQuD7z44xUYODNCjJx/blYLhtN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817232; c=relaxed/simple;
	bh=W3C5pdfYZHFgFeUhnokR+M97vge8GX96579aJ4+GEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCpvf3d8W6c4WaPBaKEFpN4Ah63U9Ex4/etdp7fflpU2OOhuh+6D5QhiETkctYn/xIlLYdEEJDCdSNDovi/PTCzJSKzqCmvmXxGEPWu5aCxwEO/Sml+LOuYkq081C9WGV07PXG7/CJo43EvexdHUWclUYplgEUT8CkVd121sr9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cvuAuyIC; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LI9P4e9el9mzpi8j8pU9wIB0bj2YpZyb/opoDXE9K3I=;
	b=cvuAuyICT18IiC/H6nEpoq6wYr5k6ivn5bImotxalcbKS02aiQA0JxpOchknWf3M6RQo+a
	+kIXKTk6SwMb9rGtwgqkeExgVr7PuGD5m7u9ck8zwZzlu/ShGPU7ubabOGW2iljpzJ517Z
	KUsZuWKQpNuFEd90jxKpJP2aKAdquxM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 04/14] x86/svm: Move CR0 selective write intercept test near CR3 intercept
Date: Mon, 10 Nov 2025 23:26:32 +0000
Message-ID: <20251110232642.633672-5-yosry.ahmed@linux.dev>
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

It makes more semantic sense for these tests to be in close proximity.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 64 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e911659194b3d..feeb27d61435b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -112,6 +112,35 @@ static bool finished_rsm_intercept(struct svm_test *test)
 	return get_test_stage(test) == 2;
 }
 
+static void prepare_sel_cr0_intercept(struct svm_test *test)
+{
+	vmcb->save.cr0 &= ~X86_CR0_CD;
+	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
+}
+
+static void test_sel_cr0_write_intercept(struct svm_test *test)
+{
+	unsigned long cr0;
+
+	/* read cr0, set CD, and write back */
+	cr0  = read_cr0();
+	cr0 |= X86_CR0_CD;
+	write_cr0(cr0);
+
+	/*
+	 * If we are here the test failed, not sure what to do now because we
+	 * are not in guest-mode anymore so we can't trigger an intercept.
+	 * Trigger a tripple-fault for now.
+	 */
+	report_fail("sel_cr0 test. Can not recover from this - exiting");
+	exit(report_summary());
+}
+
+static bool check_sel_cr0_intercept(struct svm_test *test)
+{
+	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
+}
+
 static void prepare_cr3_intercept(struct svm_test *test)
 {
 	default_prepare(test);
@@ -793,35 +822,6 @@ static bool check_asid_zero(struct svm_test *test)
 	return vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
-static void prepare_sel_cr0_intercept(struct svm_test *test)
-{
-	vmcb->save.cr0 &= ~X86_CR0_CD;
-	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
-}
-
-static void test_sel_cr0_write_intercept(struct svm_test *test)
-{
-	unsigned long cr0;
-
-	/* read cr0, set CD, and write back */
-	cr0  = read_cr0();
-	cr0 |= X86_CR0_CD;
-	write_cr0(cr0);
-
-	/*
-	 * If we are here the test failed, not sure what to do now because we
-	 * are not in guest-mode anymore so we can't trigger an intercept.
-	 * Trigger a tripple-fault for now.
-	 */
-	report_fail("sel_cr0 test. Can not recover from this - exiting");
-	exit(report_summary());
-}
-
-static bool check_sel_cr0_intercept(struct svm_test *test)
-{
-	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
-}
-
 #define TSC_ADJUST_VALUE    (1ll << 32)
 #define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
@@ -3458,6 +3458,9 @@ struct svm_test svm_tests[] = {
 	{ "rsm", default_supported,
 	  prepare_rsm_intercept, default_prepare_gif_clear,
 	  test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
+	{ "sel cr0 write intercept", default_supported,
+	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
+	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
 	{ "cr3 read intercept", default_supported,
 	  prepare_cr3_intercept, default_prepare_gif_clear,
 	  test_cr3_intercept, default_finished, check_cr3_intercept },
@@ -3482,9 +3485,6 @@ struct svm_test svm_tests[] = {
 	{ "asid_zero", default_supported, prepare_asid_zero,
 	  default_prepare_gif_clear, test_asid_zero,
 	  default_finished, check_asid_zero },
-	{ "sel cr0 write intercept", default_supported,
-	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
-	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
 	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
 	  default_prepare_gif_clear, tsc_adjust_test,
 	  default_finished, tsc_adjust_check },
-- 
2.51.2.1041.gc1ab5b90ca-goog


