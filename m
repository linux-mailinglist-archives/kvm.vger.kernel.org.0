Return-Path: <kvm+bounces-66024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4867CCBFAA4
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19EB43033D61
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04CF33C530;
	Mon, 15 Dec 2025 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kiF+wlC6"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579C6333443;
	Mon, 15 Dec 2025 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826984; cv=none; b=dKk+ekhwQP8SOhHvMY9iXhn/kPUkGKHaPyHyRLLfKYNjVxWrMydfKjc0v4tBwC6IUjJklRj59KZRlRFgZSu9KCaoGw/SGX3unJmSRblcvUiJDlNMC9H4r12866IIrjsLph51asomnedMdgm3JVzlz/dzCgLojzeBKrel/BgpZ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826984; c=relaxed/simple;
	bh=VArsy5o076aMKwJm/5njXI/zvbCDN7ca2ZZkciGEe78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=luThC6Buzp18Z/bkm8EXTuRSS7nR71co2YA3j/pqMYuDZcFYDQSqiyJJpZ3bXZ3J2QAJW5vdULOZYpJD0Ls5OaWfKKjJErI1OWF/gu6lG/pYqooKO13w85tpdPRu8ZnqjMYplJ5i9NHE7bXXg2n7YIX4373LnYM1KjlPFihzv+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kiF+wlC6; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l7zScTR1o0gExk7JzozEx+BVqCR7gtfJ5p90v27YDmY=;
	b=kiF+wlC60Y4SdMPB6yREIynfbjJs0fIhc4K+4F7/bFX/2ZkrUdF7aEsHCVULCajFFvAMIl
	lb+Lz32s3Eu3D0QNgLuDI+0Z71X4Y2YVZEqV9dlY7t00Y8UAaizziPRKmHyDrK2BFv0idA
	FfzJg3Z7aC3UBTT/6j4SUz4xrT7VdJ4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 18/26] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Mon, 15 Dec 2025 19:27:13 +0000
Message-ID: <20251215192722.3654335-20-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM Volume #2, 15.5, Canonicalization and Consistency
Checks (24593—Rev. 3.42—March 2024), the following condition (among
others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):

  EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.

Add the missing consistency check. This is functionally a nop because
the nested VMRUN results in SVM_EXIT_ERR in HW, which is forwarded to
L1, but KVM makes all consistency checks before a VMRUN is actually
attempted.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 7 +++++++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5184e5ae8ccf..47d4316b126d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -382,6 +382,11 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cr4 & X86_CR4_PAE) &&
+		       (save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -458,6 +463,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 	 * Copy only fields that are validated, as we need them
 	 * to avoid TOC/TOU races.
 	 */
+	to->cs = from->cs;
+
 	to->efer = from->efer;
 	to->cr0 = from->cr0;
 	to->cr3 = from->cr3;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9aa60924623f..d0de7d390889 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -139,6 +139,7 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg cs;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;
-- 
2.52.0.239.gd5f0c6e74e-goog


