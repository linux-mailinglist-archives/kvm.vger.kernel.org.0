Return-Path: <kvm+bounces-61355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B29C172B7
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E629B3A6A9D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF2A3590C8;
	Tue, 28 Oct 2025 22:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mVZDqsZ0"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835D3587C6
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689572; cv=none; b=jsJnOe+bdSzxOI+wLQtCz73ttPjnPn1FHRYa2ZCw0gh46srAHbh1RG6Py5DyisTm5g6kdC6TIj0aoYYZkGwkVjJ31dVHwk3brC7vY41XI3CoclVD0WGWJMzynx5NurZqKtX8EwTmxs8HSTQUcOZqFWjKU9AqEhy4hkyeUvHbtbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689572; c=relaxed/simple;
	bh=9WJOVfUVt6JAy1/UQov7Gl5mNjlNFcOn/orYhjsBu8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmtL5bQ3PttKOcyOHkXyX7mDtySWe4QRcMBf031jEM2vfjJFetgisJ+EVxEeUBf0nIkes23cVJ/u/RUomzrXfTNhZf/1UO7lhtbscQiLUmDQvSxBliZ6l7viQYWf/Y2qLS2PfELBO2fDIp6XUoiOQSaNR/P53dfeDd8ZnJF0ifw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mVZDqsZ0; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761689568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pghCsaBoSG4WPtJyc67VHSNRWgOinnAutbnbmUGrr2A=;
	b=mVZDqsZ0MItI0fecjzUjLd9vzB5MALq7VxBkc+C8PpRZSkxnKgHFLyAgRWOotQcdKkE91J
	IyYYdKZlM536l4jtEIuaAFreIUKffsaP/geDWTJbRvu36EMzWYv/RGIQDLXnaJ6IKtxG5W
	Axv/H7mErzgAdQ7A0npYN7Mkx2OusRs=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [kvm-unit-tests v2 5/8] x86/svm: Report unsupported SVM tests
Date: Tue, 28 Oct 2025 22:12:10 +0000
Message-ID: <20251028221213.1937120-6-yosry.ahmed@linux.dev>
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

Print a message when a test is skipped due to being unsupported for
better visibility.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 035367a1e90cf..5015339ddb657 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -403,8 +403,10 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 	for (; svm_tests[i].name != NULL; i++) {
 		if (!test_wanted(svm_tests[i].name, av, ac))
 			continue;
-		if (svm_tests[i].supported && !svm_tests[i].supported())
+		if (svm_tests[i].supported && !svm_tests[i].supported()) {
+			report_skip("%s (not supported)", svm_tests[i].name);
 			continue;
+		}
 		if (svm_tests[i].v2 == NULL) {
 			if (svm_tests[i].on_vcpu) {
 				if (cpu_count() <= svm_tests[i].on_vcpu)
-- 
2.51.1.851.g4ebd6896fd-goog


