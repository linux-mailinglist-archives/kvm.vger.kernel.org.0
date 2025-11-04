Return-Path: <kvm+bounces-62016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B234C32D0D
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 20:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0ECCD4F9538
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 19:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E24E2E8B9E;
	Tue,  4 Nov 2025 19:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e4bKQDvR"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6D2DF138
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 19:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762284682; cv=none; b=jdYwRoLdBMf5xJ0j99CcRYz8TweDijQI7BEZcfZxcHUIaZyi/9gx7nLZCn0nHxzLuq0aOKlL0pBQ+cRMD+Extzz22FtcvipE8NLiO1xi5FGclP5GFugGlKtAIMoTJSKV5UsFGB8INImIZls2OeMRhq+0vGhMgRraxCnZxOYF4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762284682; c=relaxed/simple;
	bh=kt678DbU1qxWHIB0EdWESp0hwR1eDkZu5lvd3m8VPAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMEJVrLZzwPNLl9J/nf7vIcFmIlE1UIBVRLe+G+VFtxot4e2Zqu0sK6vXccjDIoN2u6pgh8DMjd+HzeEhTWSU1QF/lmgtWFG9AKiXhK4sGyFiPwvwwWa3bLsyUe9AmIJPvkYDILcQ1ZGJ0f2YdMyq8+VYNI5rPTBhjT04BHmnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e4bKQDvR; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762284679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3L/cBhwg47T+kUAQUIyvUlpW3xHKx07/9p0yryhRDOY=;
	b=e4bKQDvR+p/mKAV3Nfe+qHm6Dk52w4rpjOyqSGhxu8Egi1T9vp/SgSuR4P2lnm2J0IIrHw
	KazOn7Ih8TJup/tcuYQFarywnLvOoJvwF0tkwMGcMeqiHTMFaE76JZTpY+DNy/JnJTLc0d
	KQRIX4DXcFv7sbSqBXelorVwouY24t8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests 3/4] x86/svm: Replace #UD on failure in LBRV tests with proper report()s
Date: Tue,  4 Nov 2025 19:30:15 +0000
Message-ID: <20251104193016.3408754-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251104193016.3408754-1-yosry.ahmed@linux.dev>
References: <20251104193016.3408754-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In LBRV tests, failures in the guest trigger a #UD and does not convey
useful debugging info (i.e. expected and actual values of MSRs). Replace
them with proper report() calls.

Admittedly, it is unclear why the choice of #UD was made given that
report() works fine in the guest.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 2981f459032cb..8d309860e76e5 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3017,16 +3017,17 @@ do {											\
 	TEST_EXPECT_EQ((u64)to_expected, amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP));	\
 } while (0)
 
-/*
- * FIXME: Do something other than generate an exception to communicate failure.
- * Debugging without expected vs. actual is an absolute nightmare.
- */
 #define GUEST_CHECK_LBR(from_expected, to_expected)				\
 do {										\
-	if ((u64)(from_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP))	\
-		asm volatile("ud2");						\
-	if ((u64)(to_expected) != amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP))	\
-		asm volatile("ud2");						\
+	u64 from_ip = amd_get_lbr_rip(MSR_IA32_LASTBRANCHFROMIP);		\
+	u64 to_ip = amd_get_lbr_rip(MSR_IA32_LASTBRANCHTOIP);			\
+										\
+	report((u64)(from_expected) == from_ip,					\
+	       "Expected MSR_IA32_LASTBRANCHFROMIP: 0x%lx, found: 0x%lx",	\
+	       (u64)from_expected, from_ip);					\
+	report((u64)(to_expected) == to_ip,					\
+	       "Expected MSR_IA32_LASTBRANCHTOIP: 0x%lx, found: 0x%lx",		\
+	       (u64)to_expected, to_ip);					\
 } while (0)
 
 #define REPORT_GUEST_LBR_ERROR(vmcb)						\
-- 
2.51.2.1026.g39e6a42477-goog


