Return-Path: <kvm+bounces-66015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AC0CBFA50
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5F5B9301F3D1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97978338925;
	Mon, 15 Dec 2025 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wcl/hSTX"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8D338927
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826921; cv=none; b=oGdbtmfPDqqM3Fz9J2nGbBSPxG9eftvGtG5T70ITgCYxDC9MMqqsSyn0CAJS0HoJqruQuP0C/0EIcFW8UbynvPRgspT130YgKzwtpFQk8+OFtLrTlMJy+TTagRIy4LdkYCTLdTzmYs7XKZE6npExj1Oyo8crUEYpZat5spIaWlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826921; c=relaxed/simple;
	bh=4FkB4lc12Y9bhc6+anFlKn0ybD7yJXkGaWW5KQ61+l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emSRKMOLd7kKn8QMpVl8vaLrcVGQbm6juKun7O9L4STCbYIB7D9L2QuVkeCEXfucEzzhJWhTlRxUd+74Z+9zc58xjquvlTx1GoRPMOChMB9/S7lXMkjsabAV1ByZfXcnxXAuuhCQc3esQWPKCz39f+VOP2iMfNRCRKbVeDoqLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wcl/hSTX; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0SI0AGglN5yoODoa+Tk0uqComfOo2nIYP5aDzsI+7KA=;
	b=wcl/hSTXpaBhZMkVXL26mUIokuo77mWPxVy7ufZNvIBqY6whahgygKf+Q0ZPkz5QCXCCxf
	zQE9lidJzUSv7DxozNwKWBk9QjG/FPByIpkFwH/eA1/q8MqZbCUqtW6CvWPMg1q+a0y8Sv
	4N/4q1my2/Q55ux/BoW7G7KMnc8e55k=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 09/26] KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
Date: Mon, 15 Dec 2025 19:27:04 +0000
Message-ID: <20251215192722.3654335-11-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In preparation for moving nested_svm_merge_msrpm() within
enter_svm_guest_mode(), which returns an errno, return an errno from
nested_svm_merge_msrpm().

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 384352365310..f46e97008492 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -261,7 +261,7 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
  * is optimized in that it only merges the parts where KVM MSR permission bitmap
  * may contain zero bits.
  */
-static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
+static int nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	nsvm_msrpm_merge_t *msrpm02 = svm->nested.msrpm;
@@ -288,17 +288,19 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 #endif
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
-		return true;
+		return 0;
 
 	for (i = 0; i < nested_svm_nr_msrpm_merge_offsets; i++) {
 		const int p = nested_svm_msrpm_merge_offsets[i];
 		nsvm_msrpm_merge_t l1_val;
 		gpa_t gpa;
+		int r;
 
 		gpa = svm->nested.ctl.msrpm_base_pa + (p * sizeof(l1_val));
 
-		if (kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val)))
-			return false;
+		r = kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val));
+		if (r)
+			return r;
 
 		msrpm02[p] = msrpm01[p] | l1_val;
 	}
@@ -310,7 +312,7 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 #endif
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
-	return true;
+	return 0;
 }
 
 /*
@@ -991,7 +993,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
-	if (nested_svm_merge_msrpm(vcpu))
+	if (!nested_svm_merge_msrpm(vcpu))
 		goto out;
 
 out_exit_err:
@@ -1887,7 +1889,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
-	if (!nested_svm_merge_msrpm(vcpu)) {
+	if (nested_svm_merge_msrpm(vcpu)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
-- 
2.52.0.239.gd5f0c6e74e-goog


