Return-Path: <kvm+bounces-62652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC806C49C1D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99B24188A983
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35198340A7A;
	Mon, 10 Nov 2025 23:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J5jS/2vT"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F15339B58
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817238; cv=none; b=H649MCfqB5dOr2IOrK7U+GBFnz4/Zx1W0PeeSqgAroyUaPjJEJpU1rvNoR0SRFKRPeobVIwilcJTv37K5Nfx4u4FtCVPvzkmfTFlKDxqBF20JpmijJiYecX3FCh0NG80H5zePb5jF4ZUNP52WSEMfeHOzL8Zhbjr4A6nvqRQFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817238; c=relaxed/simple;
	bh=rpfDgqidyPWkJvbfQrUH3FWWbV73z2PcFhtllZsBmRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIWPl5a5ChS+SgrOGLGPeZXJtZR1fNcgLynsTZXlug1ibHeQXweGECUTNExL0S6V0QiAL9QUnsfTt8o0ANr9hy0h19nrZyJoVB/kMVkp17Ak+kiMK7jIyb/2PdoqWmScuMsJONRCNZhBvqI3L2rwWSb9PmS/B9reig5URf+ZDEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J5jS/2vT; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NvxWO7Z2fxzmqFnB8S5HGEATExYEtFR4E6TDw6nRLGY=;
	b=J5jS/2vT82L5axIpJdFLpzwfBt4l6S2a3lqbXcGNYf0Kweua6Jw3qLOzmvat+qL3KdDeF7
	tTj+P0T9jh8E6ZEd7Cuttf4O1caGv7Ss28oBCAwvcanKeZgOWpx/7Va+c+QY6LikR1ELLE
	KGLOwHkhBkaDR43Ik0/NnSreZU7jh7I=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 08/14] x86/svm: Print SVM test names before running tests
Date: Mon, 10 Nov 2025 23:26:36 +0000
Message-ID: <20251110232642.633672-9-yosry.ahmed@linux.dev>
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

When SVM tests are run, the log is a see of PASS/FAIL/SKIPs that are not
clearly separated by test. Sometimes it's hard to attribute a failure to
a specific test (e.g. if the same helper is reused by multiple tests).

Print the test name before running each test.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/svm.c b/x86/svm.c
index 5015339ddb657..de9eb19443caa 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -407,6 +407,7 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 			report_skip("%s (not supported)", svm_tests[i].name);
 			continue;
 		}
+		printf("SVM test: %s\n", svm_tests[i].name);
 		if (svm_tests[i].v2 == NULL) {
 			if (svm_tests[i].on_vcpu) {
 				if (cpu_count() <= svm_tests[i].on_vcpu)
-- 
2.51.2.1041.gc1ab5b90ca-goog


