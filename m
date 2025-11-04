Return-Path: <kvm+bounces-62027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B44ABC32DD6
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD80918846EF
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6303019D3;
	Tue,  4 Nov 2025 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vMEpTT2g"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CFD2FF154
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286424; cv=none; b=qnGKxcP8BxcnRi5F3NgQ51qTuQ5C5Kq8uj2LmW7VSQSOmlnRE+1uxZTPXq/wmJXUMvjm0/QWPRRUtbLFTsXqHRrb8y1UsfAkyyueJay1EVZ/Wa5P0V4wi7aQ1ED2GYCPmTBnaWDdnEP5MRNzJKM1Oo+jYax4+y4mvems2OV7hbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286424; c=relaxed/simple;
	bh=F2d4zJWmJQn8eRgN2rp7OuKccAIw/xuB2G4WdPyfXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ucvub+0YVK6mxHnobtCgrYaM9lMw2VuWieXOC1qyaL4NnuqKzMJ2poIPMz0ieuJd1ULTW03ezITgBm5q8B9FGdHMULK1fo56MRlBrGEyR70J0oXF5pC45yd+H1uybpbVLuzQhSDQM6CasdSPVQAdvZzKUJLm+WrDKo+189WOZmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vMEpTT2g; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xsWbejesb8AWWtsjpUDkTupID+opAoj51F+TZvPbnTY=;
	b=vMEpTT2g6mT0u59REaoXaRoGvwDuMJ2nTfuJtZqBVNy63xkwGajHS2zcv/oQNCqupOgJxL
	gnZV15uxU6DgeZ72NC13XQ/QHxYIIti6iq0UxhwZRYqOIE6N7hZI61vj7upCLd3Gzy4ISG
	kTbfbyiXFZwv0RpQ7/ZuRYYqU4xEDQw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 09/11] KVM: nSVM: Simplify nested_svm_vmrun()
Date: Tue,  4 Nov 2025 19:59:47 +0000
Message-ID: <20251104195949.3528411-10-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
the VMRUN path, instead of making the call in nested_svm_vmrun(). This
simplifies the flow of nested_svm_vmrun() and removes all jumps to
cleanup labels.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8d5165df52f57..3c0d8990ecd11 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1009,6 +1009,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 
 	nested_svm_hv_update_vm_vp_ids(vcpu);
 
+	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
+		return -1;
+
 	return 0;
 }
 
@@ -1094,23 +1097,18 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true))
-		goto out_exit_err;
-
-	if (nested_svm_merge_msrpm(vcpu))
-		return ret;
-
-out_exit_err:
-	svm->nested.nested_run_pending = 0;
-	svm->nmi_l1_to_l2 = false;
-	svm->soft_int_injected = false;
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, true)) {
+		svm->nested.nested_run_pending = 0;
+		svm->nmi_l1_to_l2 = false;
+		svm->soft_int_injected = false;
 
-	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_code_hi = 0;
-	svm->vmcb->control.exit_info_1  = 0;
-	svm->vmcb->control.exit_info_2  = 0;
+		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1  = 0;
+		svm->vmcb->control.exit_info_2  = 0;
 
-	nested_svm_vmexit(svm);
+		nested_svm_vmexit(svm);
+	}
 	return ret;
 }
 
-- 
2.51.2.1026.g39e6a42477-goog


