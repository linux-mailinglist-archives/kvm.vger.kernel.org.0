Return-Path: <kvm+bounces-62827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B9EC5036E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 02:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 477BC3B1B7D
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 01:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AC82E403;
	Wed, 12 Nov 2025 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFf+EOmV"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF1D241695;
	Wed, 12 Nov 2025 01:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762911046; cv=none; b=m+iGVXqMgxPlOo/0CfA+Ry+glZb5j4CJvOcGPi9/jI6+yZRV3Y39w7tF5Tc43UTBpaEvdt/Pge4nN3W6eLiqnJe8NwNqHhUZqoBJ3vigdser3ckFCy2CKenB0hXwC+0XmTD2iNASorzq+B8SeGFEYN8N5xph58Z1bpM17DKtdhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762911046; c=relaxed/simple;
	bh=xhfGb6ZycktLx6DtRtGPeWPXRKJb3uLgZoLIbraIZjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kEQ9Ce67pVcjoVWEw/rDUN1RzBaKBuglNQHPhzZ7Jos3xmT+nDtTFkUBrv6KayhLEpS0TGj2ZjuZXF7Y9EFAukcKwxg2iJEs1wxJeA6B23ZcfNoYVW8qQv+2kFD9US860vZKcLnhT+tV4Tc8Beh0ytez9WM8zkYVk1EjuDu4bqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFf+EOmV; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762911042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tESTeWnloD3F0ybR0jqLCnFnlk32UlwI6uI9VspQVOg=;
	b=kFf+EOmVstthelOt+ZjpHloeenyojPkMLFg09AVDN6fh1quxJCWu3i84tByqPuEJ9s6xwD
	etQgT2PN54g1T2Cow383hG+Cz58ERuZPSJ2u97smFIXafbqX4o0Xx4gBsCg9SCTC7e1LaG
	FPVehE99blTxlEtltWFSfu3wiKcCPAU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Date: Wed, 12 Nov 2025 01:30:17 +0000
Message-ID: <20251112013017.1836863-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
already set correctly. This results in force_msr_bitmap_recalc always
being set to true on every nested transition, essentially undoing the
hyperv optimization in nested_svm_merge_msrpm().

Fix it by keeping track of whether LBR MSRs are intercepted or not and
only doing the update if needed, similar to x2avic_msrs_intercepted.

Avoid using svm_test_msr_bitmap_*() to check the status of the
intercepts, as an arbitrary MSR will need to be chosen as a
representative of all LBR MSRs, and this could theoretically break if
some of the MSRs intercepts are handled differently from the rest.

Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
only recently introduced with no direct alternatives in older kernels.

Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 9 ++++++++-
 arch/x86/kvm/svm/svm.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 10c21e4c5406f..9d29b2e7e855d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -705,7 +705,11 @@ void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 {
-	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	bool intercept = !(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+
+	if (intercept == svm->lbr_msrs_intercepted)
+		return;
 
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
@@ -714,6 +718,8 @@ static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 
 	if (sev_es_guest(vcpu->kvm))
 		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
+
+	svm->lbr_msrs_intercepted = intercept;
 }
 
 void svm_vcpu_free_msrpm(void *msrpm)
@@ -1221,6 +1227,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	}
 
 	svm->x2avic_msrs_intercepted = true;
+	svm->lbr_msrs_intercepted = true;
 
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c856d8e0f95e7..dd78e64023450 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -336,6 +336,7 @@ struct vcpu_svm {
 	bool guest_state_loaded;
 
 	bool x2avic_msrs_intercepted;
+	bool lbr_msrs_intercepted;
 
 	/* Guest GIF value, used when vGIF is not enabled */
 	bool guest_gif;

base-commit: 8a4821412cf2c1429fffa07c012dd150f2edf78c
-- 
2.51.2.1041.gc1ab5b90ca-goog


