Return-Path: <kvm+bounces-67822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BD4D14BF9
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7966D30CC033
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D0F387599;
	Mon, 12 Jan 2026 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cCYuBOlc"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37FD38759C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242068; cv=none; b=NiF+biKSkpgTuxdJWti5WjbXX+/iIgYf2fWcCosCF2Ov1O96RKuGhKwsdgqEUr+/PmuYjxvQA62XbScfDrJZCl1zVwqgNYq/A75nubQx3Bae2WqgPun/LjzAQqZ2g51kZC0h2CuNurXsa9udcmkFc6rYNOh427oAmJTpzs/mvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242068; c=relaxed/simple;
	bh=pF8M4RT/DIu46geDcka5K3ZjbFoyrgDYMIKPrjTCBFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btcmzwYr4mXuzX0qTP9fQtyuLPyh5k5oYak9tpW0m+lgf7s6wDQbfU9ZeabSNK2/r9Cd58BM0KjIr07ObaqHm4bss7KSh46yGeG5hWcP4lqLAPlMkOvHaY4i4dSd7bu2Htikl9p+KG0NKlVo+zFrF+1FpLEoLzQnSFGIeEK/Qco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cCYuBOlc; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768242064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uf866YKszpbrYKhbWeW6pYpVeLDu+l46yUOT9cuMBtM=;
	b=cCYuBOlc2OFpub1UUuj4T1DeUwCbu8sdKMmFvBsBoOur68uHNOBZoqf6Td0SD9XL4Kt1Tj
	F/CJ2Wut+IiqgvCcfxcNuFhoJhCdxE6Z+3nU06meBAbUujjfL9dujHeuKvWQikzVCL8BgJ
	45NVmE7xH8VzhBS3gHIvoAaRBLr4HCo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 3/3] KVM: nSVM: Use vmcb12_is_intercept() in nested_sync_control_from_vmcb02()
Date: Mon, 12 Jan 2026 18:20:22 +0000
Message-ID: <20260112182022.771276-4-yosry.ahmed@linux.dev>
In-Reply-To: <20260112182022.771276-1-yosry.ahmed@linux.dev>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use vmcb12_is_intercept() instead of open-coding the intercept check.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bacb2ac4c59e..1c18928369f2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -534,7 +534,7 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 	 * int_ctl (because it was never recognized while L2 was running).
 	 */
 	if (svm_is_intercept(svm, INTERCEPT_VINTR) &&
-	    !test_bit(INTERCEPT_VINTR, (unsigned long *)svm->nested.ctl.intercepts))
+	    !vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_VINTR))
 		mask &= ~V_IRQ_MASK;
 
 	if (nested_vgif_enabled(svm))
-- 
2.52.0.457.g6b5491de43-goog


