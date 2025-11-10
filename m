Return-Path: <kvm+bounces-62654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E472C49C0C
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A7A1B34BBE0
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E79B304BBD;
	Mon, 10 Nov 2025 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VTrWYeak"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74BE34165B
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817242; cv=none; b=ceyUx60vHcHOyGdCi9mDSqVQAahrkvY9Oq/jnZT+zbGirJBtGzwRIJa9di+VIdg+KHBOBqZS7ZS0e17ZZTjgNnIDrIaL14etxDFyHHx8FY3QVhV/OEVLPd8iEnftuZHs52xiv3rJkb+h3GfIOfoFDlyfdqC9OOfR49rDy1lVxHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817242; c=relaxed/simple;
	bh=kuLUgZpETFRjmpsSenbVTCVPBEIi0OzIVA9pTK+b1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqbIxbr+B4Qiat6aL9RztRKlFyqfFWWRfB5EuloehtOpnmJrk9H5kym2dAfYg8WZ+DMWirkZZ2F0bo8TdJlM452UVihGmM+srib9UftcyjEUe4RtHsR6Z9P6ylnIzZXZ+YD72sjmYIIV4iDKBEUHHvEi22EXWXEeIW+9gWu2EGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VTrWYeak; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4JXklTZXG2BQ9ptOoEb+PXLCGrKmuijPP72hNX/U+YI=;
	b=VTrWYeakq+VPHDdVm62Sd2Wqma0TNFEzuPwDO4ZzWfNmeaFHWJB68JF/ZUNsuZ3c4vfMHI
	o27aGU1gF2DdgaV7cuA0VqhNI3EncyGO40TwQwwJ4tXxmRP1egxFS4LOtK3WqsLdL9dmwi
	eEn703H+Yig+ZVZRgLLIdh8YINVXmJQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 10/14] x86/svm: Generalize and improve selective CR0 write intercept test
Date: Mon, 10 Nov 2025 23:26:38 +0000
Message-ID: <20251110232642.633672-11-yosry.ahmed@linux.dev>
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

In preparation for adding more test cases, make the test easier to
extend. Create a generic helper that sets an arbitrary bit in CR0,
optionally using FEP. The helper also stores the value to be written in
test->scratch, making it possible to double check if the write was
actually executed or not.

Use report_svm_guest() instead of report_fail() + exit().

Make test_sel_cr0_write_intercept() use the generic helper, and add
another test case that sets FEP to exercise the interception path in the
emulator.

Finally, in check_sel_cr0_intercept() also check that the write was not
executed by comparing CR0 value in the VMCB12 with the
value-to-be-written stored in test->scratch.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1e7556a37adec..7e292a9a7b4ec 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -133,27 +133,36 @@ static void prepare_sel_cr0_intercept(struct svm_test *test)
 	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
-static void test_sel_cr0_write_intercept(struct svm_test *test)
+static void __test_cr0_write_bit(struct svm_test *test, unsigned long bit,
+				 bool intercept, bool fep)
 {
 	unsigned long cr0;
 
-	/* read cr0, set CD, and write back */
-	cr0  = read_cr0();
-	cr0 |= X86_CR0_CD;
-	write_cr0(cr0);
+	cr0 = read_cr0();
+	cr0 |= bit;
+	test->scratch = cr0;
 
-	/*
-	 * If we are here the test failed, not sure what to do now because we
-	 * are not in guest-mode anymore so we can't trigger an intercept.
-	 * Trigger a tripple-fault for now.
-	 */
-	report_fail("sel_cr0 test. Can not recover from this - exiting");
-	exit(report_summary());
+	asm_conditional_fep_safe(fep, "mov %0,%%cr0", "r"(cr0));
+
+	/* This code should be unreachable when an intercept is expected */
+	report_svm_guest(!intercept, test, "Expected intercept on CR0 write");
+}
+
+/* MOV-to-CR0 updating CR0.CD is intercepted by the selective intercept */
+static void test_sel_cr0_write_intercept(struct svm_test *test)
+{
+	__test_cr0_write_bit(test, X86_CR0_CD, true, false);
+}
+
+static void test_sel_cr0_write_intercept_emul(struct svm_test *test)
+{
+	__test_cr0_write_bit(test, X86_CR0_CD, true, true);
 }
 
 static bool check_sel_cr0_intercept(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
+	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE &&
+		vmcb->save.cr0 != test->scratch;
 }
 
 static void prepare_cr3_intercept(struct svm_test *test)
@@ -3461,6 +3470,9 @@ struct svm_test svm_tests[] = {
 	{ "sel cr0 write intercept", default_supported,
 	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
 	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
+	{ "sel cr0 write intercept emulate", fep_supported,
+	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
+	  test_sel_cr0_write_intercept_emul, default_finished, check_sel_cr0_intercept},
 	{ "cr3 read intercept", default_supported,
 	  prepare_cr3_intercept, default_prepare_gif_clear,
 	  test_cr3_intercept, default_finished, check_cr3_intercept },
-- 
2.51.2.1041.gc1ab5b90ca-goog


