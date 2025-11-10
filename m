Return-Path: <kvm+bounces-62646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CB7C49BEE
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B5164E1363
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10FC303A3D;
	Mon, 10 Nov 2025 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qD897F/J"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35765303CBE
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817230; cv=none; b=up6/wPcfoX/TVrmwrBIoYslgz+4oxFWAY6XBztBu4Lj2KaeRvik6DEInYTpK4Ais3dCavvXiURJCDcuPAK0jFvWkdtKpVtS/TrUPkb0sISP/2XFvRfzEZmtXVunnu4Y9rRWvuSLsQLnTrh5NfdN3yd5i7eIYSucFR88gE3MYWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817230; c=relaxed/simple;
	bh=Mnvx0hvs+X8gRCu7TxR7gtRn1tc4Bkv+4aQoILE9RMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgL5iWCKekrT/hHrndAgZ9fTQimIUvciuoLb/kSzFRR42EkwUrhFwiGV+4TZoaXfKTflJzHgM13OItv4EEgwr+9evC5Sgxnk+BBf7ac3oMs9XXveVyEPItwqdCEz/VE+ddRdgTlvWNuGy1nJ9jpcpRmBUeSJOS+mmVeqgZVDtHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qD897F/J; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+DfU+HZfq/Y/VdBhssZivagiWWiLFSSbh8BkuTuFpM=;
	b=qD897F/J0lFsuw3FMA6LT56+YEcgSzV/4GMunaliLSQOUbf6NSz3F7FP1N5rhFdiwO3mgj
	S1lbQzn1USbJ++XvzXRry7G0fv+10S0JvorjiVsdTrQR7q81LIb87Zz5j5SviR8wYmxvx6
	30f75FpPtnYDYskAwiUB0ldFGs/RXyQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 03/14] x86/svm: Cleanup selective cr0 write intercept test
Date: Mon, 10 Nov 2025 23:26:31 +0000
Message-ID: <20251110232642.633672-4-yosry.ahmed@linux.dev>
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

Rename the test and functions to more general names describing the test
more accurately. Use X86_CR0_CD instead of hardcoding the bitmask, and
explicitly clear the bit in the prepare() function to make it clearer
that it would only be set by the test.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 80d5aeb108650..e911659194b3d 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -793,23 +793,19 @@ static bool check_asid_zero(struct svm_test *test)
 	return vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
-static void sel_cr0_bug_prepare(struct svm_test *test)
+static void prepare_sel_cr0_intercept(struct svm_test *test)
 {
+	vmcb->save.cr0 &= ~X86_CR0_CD;
 	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
-static bool sel_cr0_bug_finished(struct svm_test *test)
-{
-	return true;
-}
-
-static void sel_cr0_bug_test(struct svm_test *test)
+static void test_sel_cr0_write_intercept(struct svm_test *test)
 {
 	unsigned long cr0;
 
-	/* read cr0, clear CD, and write back */
+	/* read cr0, set CD, and write back */
 	cr0  = read_cr0();
-	cr0 |= (1UL << 30);
+	cr0 |= X86_CR0_CD;
 	write_cr0(cr0);
 
 	/*
@@ -821,7 +817,7 @@ static void sel_cr0_bug_test(struct svm_test *test)
 	exit(report_summary());
 }
 
-static bool sel_cr0_bug_check(struct svm_test *test)
+static bool check_sel_cr0_intercept(struct svm_test *test)
 {
 	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
 }
@@ -3486,9 +3482,9 @@ struct svm_test svm_tests[] = {
 	{ "asid_zero", default_supported, prepare_asid_zero,
 	  default_prepare_gif_clear, test_asid_zero,
 	  default_finished, check_asid_zero },
-	{ "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
-	  default_prepare_gif_clear, sel_cr0_bug_test,
-	  sel_cr0_bug_finished, sel_cr0_bug_check },
+	{ "sel cr0 write intercept", default_supported,
+	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
+	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
 	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
 	  default_prepare_gif_clear, tsc_adjust_test,
 	  default_finished, tsc_adjust_check },
-- 
2.51.2.1041.gc1ab5b90ca-goog


