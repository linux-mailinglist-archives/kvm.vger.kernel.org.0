Return-Path: <kvm+bounces-41010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 185DEA603C1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 22:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8030B7AEE43
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672691F8BDA;
	Thu, 13 Mar 2025 21:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FEjMtT3g"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1E91F8728
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741902964; cv=none; b=kmzSCcHZYw/yxSHs3CJbGTYqa9il8+ojuJvG6wwUzSBZzQ+yF7uvzL1fkWFwyZ77RECE4mlb0ZtFLWa3dWx/5Kb4i6qytKDHi7SiYBhXHjVkMOu0HnJng6TetK/KwRgxlsGtHxHcRln4RYd8b1Thb0DkUUg2XDEoxKBkuaoR5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741902964; c=relaxed/simple;
	bh=hurQQCC+/qgM2ttjbpMEz4DnkjDjk25e6iRgNLhdD30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etdSwH0So1E8H3xLPSGCznLkgMFvPjlqmQ1okrnKSG9LdvIhadtYnr2XLyQ1oOGwnVhSmF20B9y5doFwjhoceLe77dSMaL1M4Hr8faFlXwh6p5ywfP3dHQZU67V+3P1RUALOamccgokWxe6YHLcwai+pPkL4gsaIQ15IEcpiHNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FEjMtT3g; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741902961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bUxD6QRzJrIqWxcl0ag34BYxXxitzR3TXEhcC1owgE=;
	b=FEjMtT3gYSKmRfUz+g9jxHgt0JRf9SEPGgBg7xgoW+dNlDT5t4R1vdrt5no6wOylDjXHke
	+BoK1+o1TIPyPZUX0D6mffw6M2nbfMlPN1o4KeL9UoYzgf8afC/gqr8OmfHIYOVEgm6g8q
	6ebn/RcZEWGFQezjDUb8oi7S9tkKriM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 4/7] KVM: SVM: Flush everything if FLUSHBYASID is not available
Date: Thu, 13 Mar 2025 21:55:37 +0000
Message-ID: <20250313215540.4171762-5-yosry.ahmed@linux.dev>
In-Reply-To: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, if FLUSHBYASID is not available when performing a TLB flush,
the fallback is decrementing the ASID generation to trigger allocating a
new ASID. In preparation for using a static ASID per VM, just fallback
to flushing everything if FLUSHBYASID is not available. This is probably
worse from a performance perspective, but FLUSHBYASID has been around
for ~15 years and it's not worth carrying the complexity.

The fallback logic is moved within svm_vmcb_set_flush_asid(), as more
callers will be added and will need the fallback as well.

Suggested-by: Sean Christopherson <seanjc@google.com>

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 5 +----
 arch/x86/kvm/svm/svm.h | 5 ++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8c90686a33f44..e5064fbefb822 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4005,10 +4005,7 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * unconditionally does a TLB flush on both nested VM-Enter and nested
 	 * VM-Exit (via kvm_mmu_reset_context()).
 	 */
-	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
-		svm_vmcb_set_flush_asid(svm->vmcb);
-	else
-		svm->current_vmcb->asid_generation--;
+	svm_vmcb_set_flush_asid(svm->vmcb);
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9fd5b249b9c19..0f6426809e1b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -645,7 +645,10 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 
 static inline void svm_vmcb_set_flush_asid(struct vmcb *vmcb)
 {
-	vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	else
+		vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 }
 
 static inline void svm_vmcb_clear_flush_asid(struct vmcb *vmcb)
-- 
2.49.0.rc1.451.g8f38331e32-goog


