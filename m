Return-Path: <kvm+bounces-61062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1E4C07F58
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ED7C2505A5F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E112D5937;
	Fri, 24 Oct 2025 19:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EF7LmO6p"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACA22C3266
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335386; cv=none; b=MlIcCopOHRL08TfoxrTYl0VzTqHVWsnRuptFFbqSTF5F/HtFTrARF1vkUSf5C6hWZq+yE3iTDiQXjU2KuXCe95N8Pz+4bvCKTNEjPYFv91GI2f3Fhprm1woHiP99ON4va2x53g+J9z8d/+3MWFVkOCrpp05j8sFGlXqpLBQZh2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335386; c=relaxed/simple;
	bh=7eVLdnWog4oNMoNDToK8BFBIsLxBRoXrAGcaOu0s5pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2UBiz+dl/+m3enTXYWLKjZlWWI9lxA6CMyfz8EX2VW3UG7p0Ydgj6uX9v97uwwS80HSHfup4OGM68uJCGy0bDLOJGTioDVZDpNBbLlFkyArDL2XCIdAP5vfhN6IYpAxUHDjQQ37uT0xqnGOMKL5Fi5xfzKhXpuTa7mNkoHyk/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EF7LmO6p; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761335382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VCd85GkbXnF6v6GDXBj+7W6E44YyBkTjCVDJUwJsyIc=;
	b=EF7LmO6pNk/NUI781PWL0iBj0kVnAhPlBNLM+hhv1y01XJRka2Q2yKfJWt2d4UFsenIERq
	FI1TpFtNn61UVExdqn7QlGk98ZcnaTqznTBpPlBYKTMArqFOcoVlL4qp9dlI5cmVjA4rWW
	Z0lSyND3vmd0ISw7xs3BF68tPScThp8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [kvm-unit-tests 2/7] x86/svm: Move CR0 selective write intercept test near CR3 intercept
Date: Fri, 24 Oct 2025 19:49:20 +0000
Message-ID: <20251024194925.3201933-3-yosry.ahmed@linux.dev>
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

It makes more semantic sense for these tests to be in close proximity.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 x86/svm_tests.c | 64 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e9116591..feeb27d6 100644
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
2.51.1.821.gb6fe4d2222-goog


