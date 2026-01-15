Return-Path: <kvm+bounces-68123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9DAD21F92
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AC273085693
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B6529B200;
	Thu, 15 Jan 2026 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R7tjGHDz"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E9423B63C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439639; cv=none; b=C1j/D/YwtuPGdF84Tgh965ilZUy357LdWdEJuL+DWKGmF5L2tnNQgFA2d3c4Cr7u/r4iRIvH8bIyPm2L+JJEk9+4Aec17l51EKrsfLP1KIH75VdB6tu1qZNTxv0Om1vFRKqjEkWO/peiB5PR4frd6LZtnhShIt8Z943Eon1SThg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439639; c=relaxed/simple;
	bh=QJkGO6buZj2FN76R5TlJ5b0ubRqJ+gXCFYiyaYYmb0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvmqirGx1zJY5S646o9eAZf6r/7gMnOD4fdS2pKdzcSnLGZ9A8qrtwx6K42JQEVQ5G8qegPHJANkU8zf9oQW+NJ+ldCSDz3pNQT/wqirFwsbzaY6GMK3GnrNwqpxYpyKjeRNL6e9li91IGqzlBwi/CTW/TAXzZrcKtxJHvdsWeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R7tjGHDz; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HgQ/8xsqXO4D4VmyqO8Kbk6TDo6HNO5HxtqHdsr2+Ow=;
	b=R7tjGHDzeEb1FJMQpguFh0YBIhTVbIlJruRu2QVg8rN6EhUMbQr+GuauFfhx9aiMIvOHkh
	8q+hvp/ggx0uQFF61n6r5aPuq7sSjvh1dx98KpskmMZV42GCcdb8w2k4XER+kgaY90CPX3
	kLcvYmhv97UMJa+u2QeO7eHP4GvsXWo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 09/26] KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
Date: Thu, 15 Jan 2026 01:12:55 +0000
Message-ID: <20260115011312.3675857-10-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
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
index 536ca8e1d29f..0915785f7770 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -277,7 +277,7 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
  * is optimized in that it only merges the parts where KVM MSR permission bitmap
  * may contain zero bits.
  */
-static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
+static int nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	nsvm_msrpm_merge_t *msrpm02 = svm->nested.msrpm;
@@ -304,17 +304,19 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
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
@@ -326,7 +328,7 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 #endif
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
-	return true;
+	return 0;
 }
 
 /*
@@ -1040,7 +1042,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
-	if (nested_svm_merge_msrpm(vcpu))
+	if (!nested_svm_merge_msrpm(vcpu))
 		goto out;
 
 out_exit_err:
@@ -1941,7 +1943,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
-	if (!nested_svm_merge_msrpm(vcpu)) {
+	if (nested_svm_merge_msrpm(vcpu)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
-- 
2.52.0.457.g6b5491de43-goog


