Return-Path: <kvm+bounces-42058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 291C7A71F5D
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6F92841029
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CF9266587;
	Wed, 26 Mar 2025 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qiqEtec+"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BAA265CA5
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017839; cv=none; b=A+Scni5RhLphWgWKdL4c9+t3FGGSLea3zOlX/R8DeK+OIVISoltPRdR1B8IaSKuBouwjNihS2PzgtZNzNliifZWMTFBAuh6Tw7zkj86VHoPcKnYnWFqWe4z5KMkRahUn2yuDSbu5Km95V2/56ByJG9ulkfl5UlEHEsTHAMLX4Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017839; c=relaxed/simple;
	bh=inrt2RQhCTXICr5L7W0H2T94rzQ5DenC1/vy2r9EURo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIZvPt6ORqw0c/C20U/xMwNFTbYdt10vWAosMYFAKcGBFEZ/HpwVhOE2FPzNpkExRLu/DzIFklYQoKkB/6C67/KOIxze4FAC06VtgqIesxtUVnC+K+hU+qWFiF1n4xA0GQHSOaL8IlCQGNUFx4VwfSI8GiYxvAf2NV0eofIAn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qiqEtec+; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4Ny+D118Z/ma8iLII6EKmL7Yrolv54MzkFm34HaCAU=;
	b=qiqEtec+fjQxlgD5z6o8kegVo3IY4eyafmltoe8ngOqjEh/oBPXHkeVdDyL4yfPZgRsOPc
	36oI0jVrCJFt2PtkUkJqK3VMtFiH9pEWnRJQg1hwhBb1jWNpt4G01BH0CNgAwEZWOEBK8W
	keQcceN5qvvY5Gs8wlTOEtvHl4ekQZA=
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
Subject: [RFC PATCH 13/24] KVM: nSVM: Parameterize svm_flush_tlb_asid() by is_guest_mode
Date: Wed, 26 Mar 2025 19:36:08 +0000
Message-ID: <20250326193619.3714986-14-yosry.ahmed@linux.dev>
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

svm_flush_tlb_asid() currently operates on the current VMCB. In
preparation for properly tracking TLB flushes for L1 and L2 ASIDs,
refactor it to take is_guest_mode and find the proper VMCB. All existing
callers pass is_guest_mode(vcpu) to maintain existing behavior for now.

Move the comment about only flushing the current ASID to
svm_flush_tlb_all(), where it probably should have been anyway, because
svm_flush_tlb_asid() now flushes a given ASID, not the current ASID.

Create a svm_flush_tlb_guest() wrapper to use as the flush_tlb_guest()
callback.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 865c5ce4fa473..fb6b9f88a1504 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4016,25 +4016,24 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
+static struct vmcb *svm_get_vmcb(struct vcpu_svm *svm, bool is_guest_mode)
+{
+	return is_guest_mode ? svm->nested.vmcb02.ptr : svm->vmcb01.ptr;
+}
+
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu, bool is_guest_mode)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm_get_vmcb(svm, is_guest_mode);
 
 	/*
 	 * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
 	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
 	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
 	 */
-	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode(vcpu));
-
-	/*
-	 * Flush only the current ASID even if the TLB flush was invoked via
-	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
-	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
-	 * unconditionally does a TLB flush on both nested VM-Enter and nested
-	 * VM-Exit (via kvm_mmu_reset_context()).
-	 */
-	vmcb_set_flush_asid(svm->vmcb);
+	kvm_hv_vcpu_purge_flush_tlb(vcpu, is_guest_mode);
+	if (vmcb)
+		vmcb_set_flush_asid(vmcb);
 }
 
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
@@ -4050,7 +4049,7 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
 		hyperv_flush_guest_mapping(root_tdp);
 
-	svm_flush_tlb_asid(vcpu);
+	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
 }
 
 static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
@@ -4065,7 +4064,14 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
 		hv_flush_remote_tlbs(vcpu->kvm);
 
-	svm_flush_tlb_asid(vcpu);
+	/*
+	 * Flush only the current ASID even if the TLB flush was invoked via
+	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
+	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
+	 * unconditionally does a TLB flush on both nested VM-Enter and nested
+	 * VM-Exit (via kvm_mmu_reset_context()).
+	 */
+	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
@@ -4075,6 +4081,11 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 	invlpga(gva, svm_get_current_asid(svm));
 }
 
+static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	svm_flush_tlb_asid(vcpu, is_guest_mode(vcpu));
+}
+
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5187,7 +5198,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_asid,
+	.flush_tlb_guest = svm_flush_tlb_guest,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
-- 
2.49.0.395.g12beb8f557-goog


