Return-Path: <kvm+bounces-62653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C61C49C2E
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E7741885787
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8995342151;
	Mon, 10 Nov 2025 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oCpHJD1S"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3379B305E1B
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817241; cv=none; b=OuoiUMcdzhEH3AL0RT9UtgE3kmgiNT1hNjUYntjz+7WwdDKHOgejs466t12SlGhbZHXRenhyEo5HQS42O/n/GWWfbcITDIqH804SeLlETz1DuhATRyTHEqp5ELVDAAPBrtZNWY+8es4lfyRsbQeyQov5YrGK7NkCrAN6PFuvpL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817241; c=relaxed/simple;
	bh=R7zwZuvyaSOI5TNY55HsmjnEMbQF0WWfdkvp2+Cwf+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDP8GNn+LFEIUHMnAuLZvz6YvaK4G5ROwDd6Fo09RgbJvl/7awW6w9wHBH8fCqRGrAle47Aw2qygLYmqIr6LLDzjNHfyWFwbD972io7A1SHA6H7tiBrjYWZThHnyn+sfdze5ik80GamUCDEnmFa+S7LiH3KtVzDQoBVkzBhx8aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oCpHJD1S; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1i62BQEu9bU1+io1BGBNbqeSmq/IONYQhgqd3tEle5Y=;
	b=oCpHJD1StdepXk6QzIESZYYG4zkbkr67kzg1YI1uHG6SP0OQ7rMMyrfGrOfd6nskUGHGek
	cg0ejxSFJeDkVO/SSJf4/Bo+IqF0CptE9wS1MTl3SfhcaO8064YDeRqCvwBSiY/nC92N3d
	QlRa5PD/XQ3yPGaN7fdtp2UIvx7rpME=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 09/14] x86/svm: Deflake svm_tsc_scale_test
Date: Mon, 10 Nov 2025 23:26:37 +0000
Message-ID: <20251110232642.633672-10-yosry.ahmed@linux.dev>
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

On an AMT Turin (EPYC Zen 5), svm_tsc_scale_test flakes on the last test
case with 0.0001 TSC scaling ratio, even with the 24-bit shift for
stability. On failure, the actual value is 49 instead of the expected
50.

Use a higher scaling ratio, 0.001, which makes the test pass
consistently.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 61ab63db462dc..1e7556a37adec 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -943,7 +943,7 @@ static void svm_tsc_scale_test(void)
 	}
 
 	svm_tsc_scale_run_testcase(50, 255, rdrand());
-	svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
+	svm_tsc_scale_run_testcase(50, 0.001, rdrand());
 }
 
 static void latency_prepare(struct svm_test *test)
-- 
2.51.2.1041.gc1ab5b90ca-goog


