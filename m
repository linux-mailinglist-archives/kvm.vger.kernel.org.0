Return-Path: <kvm+bounces-37378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CF8A298DD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F687188052B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185991FECBC;
	Wed,  5 Feb 2025 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IDCcqaR/"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AEB1FCF5B
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779866; cv=none; b=bmBvADyD6eaerQ3rUJfHA4xZjtgwyJ4iUhxozJ8l2etIb9vCb91mSuvu6GFIiocnws/S2BCIdRJnnY7tJPDoO6pH/+NX7F4AKNeryGSBiPRfmn4aTjMw+S195JEjwq6A3m8PiMPy7GC2W8Ck8jhqplHNOxpVLKMLmv3y0mJKw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779866; c=relaxed/simple;
	bh=R5/nFuCIKeEoK+vhrKdLcHFTynpfcJCswTg526aSFEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPZ/RSU2eY2/FKJBEKYgaEPjJoh8Gr0PWOCSaUvW3p4lWpeCsFlXWI4KPLNi0ILGUrsVht6HvT/jtutRxQvce4ELhJqR3E8/QtJ4/JmHb3SJigwLJyO+qDvFFjCl5Z8njlN+SafrxRn29zGzncVM9phxHbMrMYaueeDKwNQJMYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IDCcqaR/; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuU9TX0aBbgsPkUOX8eud2LZOZtDW9gXXMR6We2Iqqk=;
	b=IDCcqaR/8eyZ1PioXmRiXNValHTSJufnBPh6l5uHNkCtl8HlsxgtqD8UOvGvKSQk8vvziQ
	iA2rn4XBucndA/NEdMP3Z7pCVHzsGp2HFCdr2FF03J9MFvHeRFkeKS/QQt85GgF7O59Joi
	Lo4BaDXpSLefu+FdGOZqGPpomtwUulo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 02/13] KVM: nSVM: Rework svm_flush_tlb_asid() to operate on a given VMCB
Date: Wed,  5 Feb 2025 18:23:51 +0000
Message-ID: <20250205182402.2147495-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

svm_flush_tlb_asid() currently operates on the current VMCB. In
preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
refactor it to work on a given VMCB. All existing callers pass the
current VMCB.

Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
callback.

kvm_hv_vcpu_purge_flush_tlb() is only called when the current VMCB is
passed to maintain current behavior.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 08340ae57777b..2108b48ba4959 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3954,7 +3954,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, struct kvm_vmcb_info *vmcb)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3963,7 +3963,8 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
 	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
 	 */
-	kvm_hv_vcpu_purge_flush_tlb(vcpu);
+	if (vmcb == svm->current_vmcb)
+		kvm_hv_vcpu_purge_flush_tlb(vcpu);
 
 	/*
 	 * Flush only the current ASID even if the TLB flush was invoked via
@@ -3973,14 +3974,15 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * VM-Exit (via kvm_mmu_reset_context()).
 	 */
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
-		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+		vmcb->ptr->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	else
-		svm->current_vmcb->asid_generation--;
+		vmcb->asid_generation--;
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
 	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
@@ -3991,11 +3993,13 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
 		hyperv_flush_guest_mapping(root_tdp);
 
-	svm_flush_tlb_asid(vcpu);
+	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
 }
 
 static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/*
 	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
 	 * flushes should be routed to hv_flush_remote_tlbs() without requesting
@@ -4006,7 +4010,7 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
 		hv_flush_remote_tlbs(vcpu->kvm);
 
-	svm_flush_tlb_asid(vcpu);
+	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
@@ -4016,6 +4020,13 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 	invlpga(gva, svm->vmcb->control.asid);
 }
 
+static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
+}
+
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5055,7 +5066,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_asid,
+	.flush_tlb_guest = svm_flush_tlb_guest,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
-- 
2.48.1.362.g079036d154-goog


