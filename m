Return-Path: <kvm+bounces-68118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 111D0D21FA2
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA23730CBA46
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6042741DF;
	Thu, 15 Jan 2026 01:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CgIIPoqN"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDE523D297
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439628; cv=none; b=NAOwefBQO2yjMLlw8O2t9Z1jnStHD26w/CmGsxpzZHAXLJo38IXoxjjtFNfxngQUyE0eAIvJn1H0Yvh9NfC8/V1uANBO3caJFioLRFc8TO5uAeZkgjIXjrgjngeix02h+dDifHZ5hFKv1iDuuihZ/CztpMKg4xsa+cfB6qyO+GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439628; c=relaxed/simple;
	bh=rbMyStpl5MpDWBCnUDj24XnmlND4e9wzzGo8/CGCaps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP8ciDQqdkEd/Hfq62nP6QysjtgSFlE2HHxIyN7Dkm+YaSMbX4DjkBYCgSsVKRQvUe+VQjO1CHWOAEZiR90YQaIo/VSwxR/DDF7POGhzZQRaJevLdmWki758lq8MWRcAcGVnhfjIZAqVhQNsUzesSzMOfPC5NDdUM42it1S2JB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CgIIPoqN; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D+nlw0TzzuQjQgM8JTprRz8C8eeo4gIPse+gpalZwME=;
	b=CgIIPoqNJzWEkRh4hHR6gvOSLeGnCeX3Ggbnl4difN/REVQuN7fHlBO4ERGNZ3khyeSCI3
	VYXYJ0lRhY+km5GffnWz6gA2+0gtCBO1imUa+0c4i3GIy6TVHp8Lbz7EAJwrdMGbIu6SYu
	LtynN/pNEY4WtYYi9uR1YE1zN8bSHa8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 07/26] KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
Date: Thu, 15 Jan 2026 01:12:53 +0000
Message-ID: <20260115011312.3675857-8-yosry.ahmed@linux.dev>
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

The wrappers provide little value and make it harder to see what KVM is
checking in the normal flow. Drop them.

Opportunistically fixup comments referring to the functions, adding '()'
to make it clear it's a reference to a function.

No functional change intended.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6c4c31d2b30f..8515ff81508a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -340,8 +340,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
-static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-					 struct vmcb_ctrl_area_cached *control)
+static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
+				       struct vmcb_ctrl_area_cached *control)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -368,8 +368,8 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 }
 
 /* Common checks that apply to both L1 and L2 state.  */
-static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				     struct vmcb_save_area_cached *save)
+static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
+				   struct vmcb_save_area_cached *save)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -403,22 +403,6 @@ static bool __nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb_save_area_cached *save = &svm->nested.save;
-
-	return __nested_vmcb_check_save(vcpu, save);
-}
-
-static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
-
-	return __nested_vmcb_check_controls(vcpu, ctl);
-}
-
 /*
  * If a feature is not advertised to L1, clear the corresponding vmcb12
  * intercept.
@@ -471,7 +455,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
-	/* Copy asid here because nested_vmcb_check_controls will check it.  */
+	/* Copy asid here because nested_vmcb_check_controls() will check it */
 	to->asid           = from->asid;
 	to->msrpm_base_pa &= ~0x0fffULL;
 	to->iopm_base_pa  &= ~0x0fffULL;
@@ -1030,8 +1014,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_code_hi = -1u;
 		vmcb12->control.exit_info_1  = 0;
@@ -1872,12 +1856,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
 		goto out_free;
 
 	/*
 	 * Processor state contains L2 state.  Check that it is
-	 * valid for guest mode (see nested_vmcb_check_save).
+	 * valid for guest mode (see nested_vmcb_check_save()).
 	 */
 	cr0 = kvm_read_cr0(vcpu);
         if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
@@ -1891,7 +1875,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !__nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &save_cached))
 		goto out_free;
 
 
-- 
2.52.0.457.g6b5491de43-goog


