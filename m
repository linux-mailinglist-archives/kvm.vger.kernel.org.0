Return-Path: <kvm+bounces-61064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 269E6C07F6D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B617A507C21
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992862D97B8;
	Fri, 24 Oct 2025 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sbPXDR6Q"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350742D7812
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761335390; cv=none; b=OvQ3geYLfuVe6wu7uMnCJp0pwGxzV+XD3kbXGBsAiM7ptB71xdsGEfSTeKtdsbRP950GwTJa+6OPzocH9VDICdwgiCZLwfvjYcP2WXkd58Q1o7rlQzvyX1TgZStsinMQwe8Oq3SJaNJ7H6/cby63IQjaIQWhHDd8Bs2FERGo3w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761335390; c=relaxed/simple;
	bh=4ozopBQCOr+4A4xunh8wzuEkxCFaoeLGgcagJMJZYsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/+CnHGscDSvKCr/0U0mnhH5fJ0HRNU8uvC2MNKgqDDhaWpKPsRTNqCOX3qHH9Qs4gLj+tzmEKn/cbzD9sVJtsAM/JUPpeBXZ0wOnjCtxZ/7jzNmtr/8VvQcWatZU5jPsux5nlbUaRiXNz6w8NO6qHLq85SQoZ3tbtcSznT7+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sbPXDR6Q; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761335386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nN1soDEyI2u6t2kSBSe7sxou7WUwrfYHXJmCe3aJNpQ=;
	b=sbPXDR6QgPwMtZRcjVD2Uhj3B+9PbYBPOTQRklo4Y9qmtk2Mcj1qjSQxTf5aVNsypW2VF0
	AmA+DYVHiUeFhJ6JvivnJVf2nvFT/PFNhbMCLeBmZvxTpYX9ndFG0vLCPfE0QSKiHIPX0Y
	ZIC4fDnpxbJsb+6Wj0mn6dvQIPcElmY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [kvm-unit-tests 4/7] x86/svm: Report unsupported SVM tests
Date: Fri, 24 Oct 2025 19:49:22 +0000
Message-ID: <20251024194925.3201933-5-yosry.ahmed@linux.dev>
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

Print a message when a test is skipped due to being unsupported for
better visibility.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 x86/svm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 035367a1..5015339d 100644
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
2.51.1.821.gb6fe4d2222-goog


