Return-Path: <kvm+bounces-62023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 050B1C32DC1
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 674A61887D3F
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AD22FF178;
	Tue,  4 Nov 2025 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pFgpXVVy"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E7C2FDC31
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286420; cv=none; b=WL3zC6+HYxwdI4n0riMoEOSbrW3CPIREuGsRbVZB6WVYgs2E0spbzBaMFQYb773TksT1boXuw94m+but+RA0kb/a1RtCFEi0WD5rb0z7FeTs8Bejy2hZSO3aYEJg5t2BXKqxiFJtl+G9kPSwEV0mWQGOYolG1AW4cZqJeeTSYXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286420; c=relaxed/simple;
	bh=tRwloKga782EZzwiy7cnYxehGAHBhyyrBDx7CyPctRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Elu/4ss/8AspnpwUvq5tcNw3YRu++d7dPViaCzUvHyAz8+GHR0RbCM893Oc6EM7IhWRgtZ9mCgzuMF9RZB0H/FfT/cvuTwpUd2+lepAuRGqn4vT/sGdO5rcoiqdGLmmk0OvvRULrBaV9Ver7ipfYeZn4OTrW1dq/oHTjsxwvw5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pFgpXVVy; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8b9FrffI+8lK2iySO/Rkcv5bo0NwOgGuq3yQOfHl+rg=;
	b=pFgpXVVy0boDRrGqO1PbcXwMQzC6H2JmR5lXoxHr2NEnhQbubOlVUWM8C0xBDNDT8gJzFR
	HEEWIQo8FjVtIi5wPbz00VdSz5F66KIIa2VSPfnbxdj6+zvq8HbCbZ2X5ixkKcqJk5NkPA
	vTi4hu5go/atDtQnj9unf00HKVBdVpw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 06/11] KVM: SVM: switch svm_copy_lbrs() to a macro
Date: Tue,  4 Nov 2025 19:59:44 +0000
Message-ID: <20251104195949.3528411-7-yosry.ahmed@linux.dev>
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

In preparation for using svm_copy_lbrs() with instances of both 'struct
vmcb_save_area' and 'struct vmcb_save_area_cached', make it a macro
instead. Pull the call to vmcb_mark_dirty() out to the callers.

Macros are generally not preferred compared to functions, mainly due to
type-safety. However, in this case it seems like having a simple macro
copying a few fields is better than copy-pasting the same 5 lines of
code in 6 different places (soon to be 7), or creating 3 different
variants of the function.

On the bright side, pulling vmcb_mark_dirty() calls to the callers makes
it clear that in one case, vmcb_mark_dirty() was being called on VMCB12.
It is not architecturally defined for the CPU to clear arbitrary clean
bits, and it is not needed, so drop that one call.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 11 +++++++----
 arch/x86/kvm/svm/svm.c    | 23 ++++++++---------------
 arch/x86/kvm/svm/svm.h    | 10 +++++++++-
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 986e6382dc4fa..81d7a0ed71392 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -726,12 +726,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(vmcb02, vmcb12);
+		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 		svm_update_lbrv(&svm->vcpu);
 
 	} else if (unlikely(vmcb01->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE)) {
-		svm_copy_lbrs(vmcb02, vmcb01);
+		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	}
 }
 
@@ -1242,10 +1244,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 		     (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE))) {
-		svm_copy_lbrs(vmcb12, vmcb02);
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 		svm_update_lbrv(vcpu);
 	} else if (unlikely(vmcb01->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE)) {
-		svm_copy_lbrs(vmcb01, vmcb02);
+		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
+		vmcb_mark_dirty(vmcb01, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 185f17ff2170b..07958dc7c62ba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -795,17 +795,6 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	 */
 }
 
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
-{
-	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
-	to_vmcb->save.br_from		= from_vmcb->save.br_from;
-	to_vmcb->save.br_to		= from_vmcb->save.br_to;
-	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
-	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
-
-	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
-}
-
 void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -814,8 +803,10 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+	if (is_guest_mode(vcpu)) {
+		svm_copy_lbrs(&svm->vmcb->save, &svm->vmcb01.ptr->save);
+		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
+	}
 }
 
 static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
@@ -830,8 +821,10 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
 	 * on nested guest entries.
 	 */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
+	if (is_guest_mode(vcpu)) {
+		svm_copy_lbrs(&svm->vmcb01.ptr->save, &svm->vmcb->save);
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_LBR);
+	}
 }
 
 static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 26ba9472784eb..8577e35a7096a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -689,8 +689,16 @@ static inline void *svm_vcpu_alloc_msrpm(void)
 	return svm_alloc_permissions_map(MSRPM_SIZE, GFP_KERNEL_ACCOUNT);
 }
 
+#define svm_copy_lbrs(to, from)					\
+({								\
+	(to)->dbgctl		= (from)->dbgctl;		\
+	(to)->br_from		= (from)->br_from;		\
+	(to)->br_to		= (from)->br_to;		\
+	(to)->last_excp_from	= (from)->last_excp_from;	\
+	(to)->last_excp_to	= (from)->last_excp_to;		\
+})
+
 void svm_vcpu_free_msrpm(void *msrpm);
-void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
 void svm_enable_lbrv(struct kvm_vcpu *vcpu);
 void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
-- 
2.51.2.1026.g39e6a42477-goog


