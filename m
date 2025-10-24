Return-Path: <kvm+bounces-61059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CACE1C07EA4
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 21:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 750E11A68114
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044D329A9FA;
	Fri, 24 Oct 2025 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GlLPWgMK"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64429B78D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761334198; cv=none; b=R1JhN1jiaKh/LOkL4JGWrwPy/42FT47zHBf4ydt5v1cL/1hMRajwvA238u2IcdIRspTSZOh82Mzr/WXO+YD2kJUKWHNYYQYwhvKcUUuu6bVOEpKzau9Ma1/xC6BJ4Lzzvm35dI7s08rzeKeXQNzG1uIw6alKgORIcr3G3ANOwtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761334198; c=relaxed/simple;
	bh=SB5q6+0hwZ04VXp6V9khXsmBZaeHcCObNItM11WBnhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXLcSn/GTHPi9kPSuwZ1mw5jQqP9n0AlZhYjfdsLtFXf3AHNepcmN0aCErtSZYI57o8ymx61SnNDdqJTa7t83ucH7eap09fhmDcNcVxlr7lAXBJ+pK52YYHzIZ2Vez+zJq7VGSNxLkjmXCidJorWejLrX9cmL4asvw7CjGHMR9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GlLPWgMK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761334193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnV9hP8q4zoQm9zSknFS2vlFz4b3nNad1qMbHV1P/c8=;
	b=GlLPWgMKF6ORhryWoBp3kaBoDjowU94NZ+ATwkedc8YjWVcofwmR5HSCGq5tioSfnrdKnG
	/zWn3YaQVZ+5VhAHWa7YLLR5TV7L8f1QRJarfclbLTLuHv+MX+Df0HbgTO/HpRD87esgwM
	jD2ig7Jy+mHk5mwYcq4sR+iSNyrRaqM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel,
	Matteo Rizzo <matteorizzo@google.com>
Subject: [PATCH 2/3] KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation
Date: Fri, 24 Oct 2025 19:29:17 +0000
Message-ID: <20251024192918.3191141-3-yosry.ahmed@linux.dev>
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
SVM_EXIT_CR0_SEL_WRITE. For MOV-to-CR0, SVM_EXIT_CR0_SEL_WRITE is only
triggered if any bit other than CR0.MP and CR0.TS is updated. However,
according to the APM (24593—Rev.  3.42—March 2024, Table 15-7):

  The LMSW instruction treats the selective CR0-write
  intercept as a non-selective intercept (i.e., it intercepts
  regardless of the value being written).

Skip checking the changed bits for x86_intercept_lmsw and always inject
SVM_EXIT_CR0_SEL_WRITE.

Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr accesses")
Cc: stable@vger.kernel
Reported-by: Matteo Rizzo <matteorizzo@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb1..9ea0ff136e299 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4541,20 +4541,20 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 					INTERCEPT_SELECTIVE_CR0)))
 			break;
 
-		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
-		val = info->src_val  & ~SVM_CR0_SELECTIVE_MASK;
-
+		/* LMSW always triggers INTERCEPT_SELECTIVE_CR0 */
 		if (info->intercept == x86_intercept_lmsw) {
-			cr0 &= 0xfUL;
-			val &= 0xfUL;
-			/* lmsw can't clear PE - catch this here */
-			if (cr0 & X86_CR0_PE)
-				val |= X86_CR0_PE;
+			icpt_info.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+			break;
 		}
 
+		/*
+		 * MOV-to-CR0 only triggers INTERCEPT_SELECTIVE_CR0 if any bit
+		 * other than SVM_CR0_SELECTIVE_MASK is changed.
+		 */
+		cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
+		val = info->src_val  & ~SVM_CR0_SELECTIVE_MASK;
 		if (cr0 ^ val)
 			icpt_info.exit_code = SVM_EXIT_CR0_SEL_WRITE;
-
 		break;
 	}
 	case SVM_EXIT_READ_DR0:
-- 
2.51.1.821.gb6fe4d2222-goog


