Return-Path: <kvm+bounces-61352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B64CC17285
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 09490352210
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCC8357A5D;
	Tue, 28 Oct 2025 22:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ni25ZmVj"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296FB3570D4
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689566; cv=none; b=Nb+1JMiSORt87T2aWNYnp5kpLGi/Rta0F7pNlIz5CFk4ooYg7h6cSQ9bY5lRThdQlwxQMAQDQ/q/jc6vKCguYplQ7JtF37QGtEAuZKUXlEt+VbD+/SnKZxHyTiIOMDXLIY83j9gwufO8jYeRxaGbF5wIUWaZHNm3fFzqWncps/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689566; c=relaxed/simple;
	bh=vJh+S3CgEPIc6Aa6El12XCOuqGg4J1P9NaFdpLOjBXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ny14vQnuPxm990Xa0eucloWJaZ3D9uw3J/RrK6zyISy0RxF+XSUbQyhz8MIbWIiaiUYcNwxcGfXT9GUz/4CbHL4muGAcfLcqFoVhFAZYUzDld1OCGVsZOfaBp3cAMIqyJ+2wsnGLhzrM5b7UEoXjodBdgvDO21LuvQK3T808/B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ni25ZmVj; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1kVP3FxBT54Ty/cM/5sjNG3Lv4LKxVmh1cwe5DD5L7w=;
	b=Ni25ZmVj6fZoxDElrOQFIS2aUbwBOJMhb6EYORMWCMoTee/RIggEnSFBZKwKpYG3hOqKmi
	mreesfxOpbtwXB3iJuLRvSX3H6odJuLkzpJZmVjaCUbGZWHjeRc29lf0D9KdzysPwpFpCe
	ltBFF7fqb3ZVaaOqg8+EzICZQoQtl5g=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 2/8] x86/svm: Cleanup selective cr0 write intercept test
Date: Tue, 28 Oct 2025 22:12:07 +0000
Message-ID: <20251028221213.1937120-3-yosry.ahmed@linux.dev>
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
2.51.1.851.g4ebd6896fd-goog


