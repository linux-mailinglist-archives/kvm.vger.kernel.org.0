Return-Path: <kvm+bounces-42056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 131A0A71F59
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C025840656
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8677A25E45D;
	Wed, 26 Mar 2025 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DmlDrua9"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2D264F8E
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017834; cv=none; b=ZNuCZNfiOcT/TYJJm7SAFJU/i3VZPxJdYb+GgN7A3h/RsaAZkhc9EsjT8baf4puXDTOTUzdNkg/LdrdFHoLCegTI/fHwCpmRHI7NA0Q048H4pLRnLVfCQbDv190qHaLiyXJyBnrGXLZBIZK5nx+qfYRu4YWS/JIYSWK9cexD/D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017834; c=relaxed/simple;
	bh=utr1rvPn2qEMv1fOFMUG2Yxy7gAewwL4x/EIGr4m5e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2In/vcOAgX95rJnuWOWsC7OqGGJVJPuAW/WcmaXTf9QR81gDMEBatmN3ZFYFwPam+xGTMn3oSyBNI8E5FUo8nCN/R7Kxo4L7TpCR1hkJ5f5uFV/v0AkEAVT/PvETlEhhsaH7ndpU455Ue6+vmD32c0u0f03gUi2py9zYx5vVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DmlDrua9; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QASuUoDvpy6cgllhRp2uc/7Vu7QzmaAO+CI/JV5GK5w=;
	b=DmlDrua9gZpXshPNNNAH4hHBpvT+yGImc3BNWLAde4GXmbV2GGwhEkr9cSaArjzaj224ib
	+VEhONZiZ9mV5+tA3GS9dPzkQKUkcgjXKFzbqY9G/38Z5Z+Fs1wCw1qKr1TvXUAGOn3Qdl
	3V0bBO0iA6csoloMqNQEYQq9qPGKsgs=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 11/24] KVM: nSVM: Use a separate ASID for nested guests
Date: Wed, 26 Mar 2025 19:36:06 +0000
Message-ID: <20250326193619.3714986-12-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The per-VM ASID is currently shared by both L1 and L2 guests. That ASID
is currently flushed on every transition between L1 and L2.

Allocate and track a separate ASID per-VM for nested guests. This is in
preparation for doing fine-grained TLB flushes on nested transitions
instead of unconditional full flushes.

Nested ASIDs are still not fully maintained (e.g. a remote flush will
only flush the current ASID), so keep the TLB flush on every transition
until this is sorted out in following changes.

Add a helper to get the ASID associated with a specific VMCB and use it
instead of directly reading the VM's ASID. This transparently uses L2's
ASID when an L2 guest is being run.

L1's ASID is flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the active
context, so remove the TODO in nested_svm_transition_tlb_flush() about
it.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  8 ++++++--
 arch/x86/kvm/svm/svm.c    | 13 +++++++++++--
 arch/x86/kvm/svm/svm.h    |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 81184b2fb27fd..75223869aa8c6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -495,7 +495,6 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 	 *  - Honor L1's request to flush an ASID on nested VMRUN
 	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
 	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
-	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
 	 *
 	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
 	 *     NPT guest-physical mappings on VMRUN.
@@ -677,7 +676,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
-	vmcb02->control.asid = svm_asid(vcpu->kvm);
+	vmcb02->control.asid = svm_nested_asid(vcpu->kvm);
 
 	/* Also overwritten later if necessary.  */
 	vmcb_clr_flush_asid(vmcb02);
@@ -1179,6 +1178,7 @@ static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
 
 int svm_allocate_nested(struct vcpu_svm *svm)
 {
+	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
 	struct page *vmcb02_page;
 
 	if (svm->nested.initialized)
@@ -1196,6 +1196,10 @@ int svm_allocate_nested(struct vcpu_svm *svm)
 	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
 	svm->nested.initialized = true;
+
+	if (!kvm_svm->nested_asid)
+		kvm_svm->nested_asid = kvm_svm->asid;
+
 	return 0;
 
 err_free_vmcb02:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f028d006f69dc..e664d8428c792 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1225,17 +1225,26 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 }
 
-unsigned int svm_asid(struct kvm *kvm)
+unsigned int svm_nested_asid(struct kvm *kvm)
+{
+	return to_kvm_svm(kvm)->nested_asid;
+}
+
+static unsigned int svm_asid(struct kvm *kvm)
 {
 	return to_kvm_svm(kvm)->asid;
 }
 
 static unsigned int svm_get_current_asid(struct vcpu_svm *svm)
 {
-	struct kvm *kvm = svm->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
 
 	if (sev_guest(kvm))
 		return sev_get_asid(kvm);
+	if (is_guest_mode(vcpu))
+		return svm_nested_asid(kvm);
+	WARN_ON_ONCE(svm->current_vmcb != &svm->vmcb01);
 	return svm_asid(kvm);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 436b7e83141b9..e67e3a64e92f7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -118,6 +118,7 @@ struct kvm_svm {
 	struct kvm kvm;
 
 	unsigned int asid;
+	unsigned int nested_asid;
 
 	/* Struct members for AVIC */
 	u32 avic_vm_id;
@@ -651,7 +652,7 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
 bool svm_register_asid(unsigned int asid);
 void svm_unregister_asid(unsigned int asid);
-unsigned int svm_asid(struct kvm *kvm);
+unsigned int svm_nested_asid(struct kvm *kvm);
 
 /* nested.c */
 
-- 
2.49.0.395.g12beb8f557-goog


