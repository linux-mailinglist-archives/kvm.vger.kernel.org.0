Return-Path: <kvm+bounces-61060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 408E5C07E9E
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3E65400902
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431912C0293;
	Fri, 24 Oct 2025 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OXApD2RS"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7F22BE03E
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761334198; cv=none; b=XUIU7hteku2Ec6QTSrWaz7CofXPtlA0AE3P/7fK68fDo3qabMU16M9amoxUJTS7Rx/AvJlHwSwDYE1nN8dpPeOpbT56oQQeFtRbMT09BwSpam52v+n969L7sF+SIiLkPkqUHGahROZCsAbeuC3T3Z3x5ROgX2oMxzbvedxAWYZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761334198; c=relaxed/simple;
	bh=Rbouwn/Fe2w8MIJjhC34nR8g2gP/sC74mPrcleYapB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aa43lQ9/2RnpB9hHZDBqubaQ6wvLtkg2n7o4/l8uQ6UWuXxvZimVq2tX42eSI4FMnu5ZBGz05Nta+qP+W8045sjRehJ/KSBwFPxSVErUSAo6PdKBlnZnpdqToGISQBDFpqzp4itSLkzu97my6ahP+LXfZYA3jm1ifxcK13naKHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OXApD2RS; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761334194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c57tg/C/NUSYzi8pno9yKYmODzHakA7S21mwRLPVsP8=;
	b=OXApD2RSixprRjxTR+xY5rWGXrnujrl/zMgOloCvivOyq6iCwUqGVKjuyrQylniBTh8lrv
	kICCm5heYnBSMyA1sM5it4nkBl9usClqLkJxTAERU3kJRZu7DOUpDuhSrZn2QJhqmJMJnc
	XlAaxDE4xcLmjSRU+khppHIWgr9/e00=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel
Subject: [PATCH 3/3] KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE
Date: Fri, 24 Oct 2025 19:29:18 +0000
Message-ID: <20251024192918.3191141-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When emulating L2 instructions, svm_check_intercept() checks whether a
write to CR0 should trigger a synthesized #VMEXIT with
SVM_EXIT_CR0_SEL_WRITE. However, it does not check whether L1 enabled
the intercept for SVM_EXIT_WRITE_CR0, which has higher priority
according to the APM (24593—Rev.  3.42—March 2024, Table 15-7):

  When both selective and non-selective CR0-write
  intercepts are active at the same time, the non-selective
  intercept takes priority. With respect to exceptions, the
  priority of this inter

Make sure L1 does NOT intercept SVM_EXIT_WRITE_CR0 before checking if
SVM_EXIT_CR0_SEL_WRITE needs to be injected.

Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr accesses")
Cc: stable@vger.kernel
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ea0ff136e299..4f79c4d837535 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4533,12 +4533,22 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		if (info->intercept == x86_intercept_cr_write)
 			icpt_info.exit_code += info->modrm_reg;
 
+		/*
+		 * If the write is indeed to CR0, check whether the exit_code
+		 * needs to be converted to SVM_EXIT_CR0_SEL_WRITE. Intercepting
+		 * SVM_EXIT_WRITE_CR0 has higher priority than
+		 * SVM_EXIT_CR0_SEL_WRITE, so this is only relevant if L1 sets
+		 * INTERCEPT_SELECTIVE_CR0 but not INTERCEPT_CR0_WRITE.
+		 */
 		if (icpt_info.exit_code != SVM_EXIT_WRITE_CR0 ||
-		    info->intercept == x86_intercept_clts)
+		    vmcb12_is_intercept(&svm->nested.ctl,
+					INTERCEPT_CR0_WRITE) ||
+		    !(vmcb12_is_intercept(&svm->nested.ctl,
+					  INTERCEPT_SELECTIVE_CR0)))
 			break;
 
-		if (!(vmcb12_is_intercept(&svm->nested.ctl,
-					INTERCEPT_SELECTIVE_CR0)))
+		/* CLTS never triggers INTERCEPT_SELECTIVE_CR0 */
+		if (info->intercept == x86_intercept_clts)
 			break;
 
 		/* LMSW always triggers INTERCEPT_SELECTIVE_CR0 */
-- 
2.51.1.821.gb6fe4d2222-goog


