Return-Path: <kvm+bounces-61353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AE3C1728E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3AA94050B9
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3FC3587B7;
	Tue, 28 Oct 2025 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="doL6rfXw"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEC4357A52
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689568; cv=none; b=B/g5TQP5Fy1amM1HHMBUaxo4VWiGeX2XsoiNExm0fn/rRW9wkJjBxK9cVmzQe7Wkn8wP1oBlfSV7T8MVdperrj/HYV5w9HytLNIJXzRXIb0AoDEmWdEldkhUjWRiU9Ji7ejixf6Wv9GyF8A6WUPwwr/vfFdH4YnlqKLVMpfAz5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689568; c=relaxed/simple;
	bh=3AsyydydOXbsdoj9A11Lj94OBCmTJtyHkTud6c3h9r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhHSbZsqyC0rILErudSKv9/TWUHP7EZoHuv2494goukpUJiDiwPtI8YYKJzNqVOKY6EzEGSrCd5oAaPTNvX3AE/efnjK58pdbKz5R/FhcZqJLh7x50uKjjkFdXtYlZsRG6N62rCw1gTIrywSRJijR0paasQO2GDhAUGHjm+xsGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=doL6rfXw; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h0602KOF+ye2x1sgP+VcEDcnugWogmMFJ8XHS655fQ4=;
	b=doL6rfXwwNmzZn55GInLQCxRxSjQetUx9M/mUh3urkjNYmViem62/1zi5OXMBiOzQNsZ1F
	EUh0EkGPhBD0NF3WGy5Zd9skD6tzkdPJsmc6rsSsMwl/3mFdwfCIiDrnNInyZngmLM+tcR
	AS0Rs1w2+x5Z1tok/kxiUHABoLSGfLg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 3/8] x86/svm: Move CR0 selective write intercept test near CR3 intercept
Date: Tue, 28 Oct 2025 22:12:08 +0000
Message-ID: <20251028221213.1937120-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
References: <20251028221213.1937120-1-yosry.ahmed@linux.dev>
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
2.51.1.851.g4ebd6896fd-goog


