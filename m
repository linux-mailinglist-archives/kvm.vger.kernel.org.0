Return-Path: <kvm+bounces-66005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0D8CBF8C1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB2BE304DA2E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D6633373D;
	Mon, 15 Dec 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h3u/BkYX"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723F3321C7
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826878; cv=none; b=ME5iKy0jEKJp0VujDzZ3KFGIvih3JdaIEltWG7XZSiRz3AXqB82dFDjWv+6sGYu5E+uFIoWxAcsRVuuXrrJ+vba+jf/R5JD0VAWHmvXNp6eDLbxRTqToWL7xLdhnonFwkA81eLrIi+TbZg81Uw8Ss4xvWEzXCFfa1GGH/a+Ml3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826878; c=relaxed/simple;
	bh=NGHrmOF8yFpm0L4uizjQh/M5VuoPY7ravOo2U7Kf+mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN+aCSJcHeUynrrPbc/fcL75nm4KH9Xx/GkwZr4eTjKx9o4EeOl//hlAZmCidmjS0p2hC0P74FOW+I/Pqx+nmkLVZSto7SOjKi06svy/wIZ9Yf9kN0ifuthGuBOmQZraNkBKAv+LAgSL6+bo0xmIvjZ5GGsWm7fvH5gZM8RGZuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h3u/BkYX; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W01yE1XUVHFJjvT19V74JaE/KzEZ45eC2p6bPSeAEX8=;
	b=h3u/BkYXWNQfiDZJp97JJp6qtIuZezLCjxtmzupmrbZq9sSEBNOKzMUgWc+Ju6i8l+4zBP
	iZSk8dX9zsfAixvxgBk59XOQnDnXK1IFxjyeug+6e5FyfAkxQ/bRUCPFuEtPLqSwgT8j4V
	Vh8w8cL0baEfyLzod+RKKUI9bhje118=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 01/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
Date: Mon, 15 Dec 2025 19:26:56 +0000
Message-ID: <20251215192722.3654335-3-yosry.ahmed@linux.dev>
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

In preparation for using svm_copy_lbrs() with 'struct vmcb_save_area'
without a containing 'struct vmcb', and later even 'struct
vmcb_save_area_cached', make it a macro. Pull the call to
vmcb_mark_dirty() out to the callers.

Macros are generally not preferred compared to functions, mainly due to
type-safety. However, in this case it seems like having a simple macro
copying a few fields is better than copy-pasting the same 5 lines of
code in different places.

On the bright side, pulling vmcb_mark_dirty() calls to the callers makes
it clear that in one case, vmcb_mark_dirty() was being called on VMCB12.
It is not architecturally defined for the CPU to clear arbitrary clean
bits, and it is not needed, so drop that one call.

Technically fixes the non-architectural behavior of setting the dirty
bit on VMCB12.

Fixes: d20c796ca370 ("KVM: x86: nSVM: implement nested LBR virtualization")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 16 ++++++++++------
 arch/x86/kvm/svm/svm.c    | 11 -----------
 arch/x86/kvm/svm/svm.h    | 10 +++++++++-
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372..8e157ffbf4b1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -676,10 +676,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
 		 */
-		svm_copy_lbrs(vmcb02, vmcb12);
+		svm_copy_lbrs(&vmcb02->save, &vmcb12->save);
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 	} else {
-		svm_copy_lbrs(vmcb02, vmcb01);
+		svm_copy_lbrs(&vmcb02->save, &vmcb01->save);
+		vmcb_mark_dirty(vmcb02, VMCB_LBR);
 	}
 	svm_update_lbrv(&svm->vcpu);
 }
@@ -1186,10 +1188,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK)))
-		svm_copy_lbrs(vmcb12, vmcb02);
-	else
-		svm_copy_lbrs(vmcb01, vmcb02);
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
+	} else {
+		svm_copy_lbrs(&vmcb01->save, &vmcb02->save);
+		vmcb_mark_dirty(vmcb01, VMCB_LBR);
+	}
 
 	svm_update_lbrv(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..2428b772546f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -804,17 +804,6 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
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
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..8a642ab2936a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -685,8 +685,16 @@ static inline void *svm_vcpu_alloc_msrpm(void)
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
2.52.0.239.gd5f0c6e74e-goog


