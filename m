Return-Path: <kvm+bounces-66006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F01AACBF8C4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:30:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47AA2304E389
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8B2333743;
	Mon, 15 Dec 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i2g9Tky3"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757183242A5;
	Mon, 15 Dec 2025 19:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826878; cv=none; b=CQfYADiZvDCIugT3X6+fLONIB1mZoH58m/cYQKXU2XUfmcMCQ3oPJH7Dhw9Ntb6Hmq4Bx3tB3UqmJCvue8qEFTK90UtqoYmW84N/2nZLPG6UBzXdh996ST5NZ+UREkL9x+caBKYKB3rUJGLZSpq03gWmDkQgbO930re0l8cIEWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826878; c=relaxed/simple;
	bh=xhfGb6ZycktLx6DtRtGPeWPXRKJb3uLgZoLIbraIZjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Olpw54JY893nsVDZFSSHzG34PsfRnq+Hxd/3ubLhoqIn5XMmOD2i44UiYKQn7v0GvElHnsOfnkoQiNyYNtfPTtxzpXlbsFhmbQvRjPApdH8CCzr75BlU8SJRePPExCqgxYxFgpa0ERrZwzGDX3puRMsc/M1EzqWRQxIv4EgF8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i2g9Tky3; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tESTeWnloD3F0ybR0jqLCnFnlk32UlwI6uI9VspQVOg=;
	b=i2g9Tky3vAVzaamIP74QGyCrf28qHb+FUKZlTry9Fg2wDOPH1MxABw9ljI1dgbbSCTl9Fi
	SpUQzIE+pCZ1WPPV4vdkl54N8Zq4JqZixH5okk+mq/liLT64WG7QIKYAofy6fBOf2CYlWc
	fW9L0cr7+KXu6hAy7eqSUEw/oGFbaAc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Date: Mon, 15 Dec 2025 19:26:54 +0000
Message-ID: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
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


