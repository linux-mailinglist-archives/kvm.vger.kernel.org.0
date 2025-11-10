Return-Path: <kvm+bounces-62645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 585AAC49BE8
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 05BA234B9B5
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21480306B39;
	Mon, 10 Nov 2025 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wJ1vlVba"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EEC2E62D8
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817230; cv=none; b=Rb8bnO/VGCagM00wXfnoNK19NBPaZRV6h3roTmtrq5Qgvv5UWd4Qdr05+jc4DUrytEHpzlpc5bG/QLnFfPwebHUxWW0A3kSKddXSftLwm3XG7fCqoJzcBf7k7Tvhkxav2cyLOOzgJmq44HTZICvTHdr5F+0NY0PIwJJ9+NQ/lao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817230; c=relaxed/simple;
	bh=WrgPfzyyb/jE9uQS/HLYwnkLtnXNRt0RBtDv5xhqIVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3JWBbsC67OF3GeaXv1bxxHy/csvf/DpDO5UHjnYjpxVDomxNiRi/mxNN+3T3nvyNmZ8UwftT3awqdOEB6G91jHLvTbyqWgx9L0NaLzeeIQ4JISFhByM4DFy134k+ZJ3A7JWeQZWMAnsJlRL1WLmlqiMN2AjAwffs4tZBYJ+dxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wJ1vlVba; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2+2lG7hu9KlvT0KTN68rDvTTKs1ubRL9Fu8DwYe6/Oc=;
	b=wJ1vlVbazmoSgF+uhn8+wox7Z8BybdpC4UrtnnMmnm6eikuDigHD8GjNe23KDPfEN+AQ1G
	e0hLVdJHAeqgoJs6R2Z4p9yhFh8Hhjw76FdVREAsH3+VZa7bBRjPnvX7oH1wP37ulemIUL
	JlfHaS92P0q7iVtNycn8Lj6hct6Hh2Y=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 02/14] x86/vmx: Skip vmx_pf_exception_test_fep early if FEP is not available
Date: Mon, 10 Nov 2025 23:26:30 +0000
Message-ID: <20251110232642.633672-3-yosry.ahmed@linux.dev>
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

The check to skip the test is currently performed in the guest code.
There a few TEST_ASSERTs that happen before the guest is run, which
internally call report_passed(). The latter increases the number of
passed tests.

Hence, when vmx_pf_exception_test_fep is run, report_summary() does not
return a "skip" error code because the total number of tests is larger
than the number of skipped tests.

Skip early if FEP is not available, before any assertions, such that
report_summary() finds exactly 1 skipped test and returns the
appropriate error code.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/vmx_tests.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 0b3cfe50c6142..4f214ebdbe1d9 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -10644,7 +10644,10 @@ static void vmx_pf_exception_test(void)
 
 static void vmx_pf_exception_forced_emulation_test(void)
 {
-	__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);
+	if (is_fep_available)
+		__vmx_pf_exception_test(NULL, NULL, vmx_pf_exception_forced_emulation_test_guest);
+	else
+		report_skip("Forced emulation prefix (FEP) not available\n");
 }
 
 static void invalidate_tlb_no_vpid(void *data)
-- 
2.51.2.1041.gc1ab5b90ca-goog


