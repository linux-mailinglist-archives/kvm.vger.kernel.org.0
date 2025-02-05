Return-Path: <kvm+bounces-37376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 014D7A298DA
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FE51881555
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76331FDA9B;
	Wed,  5 Feb 2025 18:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ktlYzEGk"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9C9193436
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779863; cv=none; b=jd4pZDy+a9yTKJCWPPyAq1ggSgbCuCYulvi37yWWbxL3a/oCZDUuT1XYNWREVdVWCMBf8s8Y8I4sJg8ZILbWgMp+C2O+DnRM//77zqovLroYsiGjQAB5Mt5/pRhC2DImhTObL6jkbi7fzATtxgRnq8nXJRctj9MWKczuqmzSvlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779863; c=relaxed/simple;
	bh=1rJz09m5d3GNK9R8RloegGPmL0GypyAT2cL3qxMRJ7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOo7jZpT0H7XVsDnxjS+yUfYgEw/lhteJYUI0QUJ3o/1Gpg0HJoiPJJoxFuJzyKSAntihP40C1ehGCXFjD1nxhQ9dAk2k9r6z1uNsH4Qiq63tbG8VP9dOSFi9NWmiRCMZz50q2U3NfcBoHlgtFk7oLg9OxZ+vH2sEnF+cBBsV6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ktlYzEGk; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6BJ3Tmh6YFKL8BG0vfP0eplTWJclNBXEO176k3JDmdA=;
	b=ktlYzEGkyGOtoo6Qo9pwF0NojdVFk1dWuEK/8+Vi/qOpTqNI+RuNmMvuW4lUM88aeSJmtV
	/bSe1EIM7zyZPgQJeGRE1Pe/3biGH3+ub3oFSUZgH9Zxky+3DEcS9KEPB+sZO6Fqz+xujl
	LpZHs9tqf2CNGZ3gmX9kHUvfFWK3iug=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
Date: Wed,  5 Feb 2025 18:23:50 +0000
Message-ID: <20250205182402.2147495-2-yosry.ahmed@linux.dev>
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

The ASID is currently tracked per-vCPU, because the same ASID is used by
L1 and L2. That ASID is flushed on every transition between L1 and L2.

Track the ASID separately for each VMCB (similar to the
asid_generation), giving L2 a separate ASID. This is in preparation for
doing fine-grained TLB flushes on nested transitions instead of
unconditional full flushes.

The ASIDs are still not fully maintained (e.g. a remote flush will only
flush the current ASID), so keep the TLB flush on every transition until
this is sorted out.

L1's ASID will be flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the
active context, so remove the TODO in nested_svm_transition_tlb_flush()
about it.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  1 -
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    | 12 +++++++-----
 arch/x86/kvm/svm/svm.h    |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 04c375bf1ac2a..bbe4f3ac9f250 100644
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
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 799f8494b599c..b0adfd0537d00 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3468,7 +3468,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
-	svm->asid = asid;
+	svm->current_vmcb->asid = asid;
 
 	/*
 	 * Flush guest TLB:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a6..08340ae57777b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1335,8 +1335,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		save->g_pat = vcpu->arch.pat;
 		save->cr3 = 0;
 	}
-	svm->current_vmcb->asid_generation = 0;
-	svm->asid = 0;
+	svm->vmcb01.asid_generation = 0;
+	svm->vmcb01.asid = 0;
+	svm->nested.vmcb02.asid_generation = 0;
+	svm->nested.vmcb02.asid = 0;
 
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
@@ -1988,7 +1990,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 	}
 
 	svm->current_vmcb->asid_generation = sd->asid_generation;
-	svm->asid = sd->next_asid++;
+	svm->current_vmcb->asid = sd->next_asid++;
 }
 
 static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
@@ -4235,8 +4237,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	sync_lapic_to_cr8(vcpu);
 
-	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
-		svm->vmcb->control.asid = svm->asid;
+	if (unlikely(svm->current_vmcb->asid != svm->vmcb->control.asid)) {
+		svm->vmcb->control.asid = svm->current_vmcb->asid;
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d7cdb8fbf872..ebbb0b1a64676 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -133,6 +133,7 @@ struct kvm_vmcb_info {
 	unsigned long pa;
 	int cpu;
 	uint64_t asid_generation;
+	u32 asid;
 };
 
 struct vmcb_save_area_cached {
@@ -247,7 +248,6 @@ struct vcpu_svm {
 	struct vmcb *vmcb;
 	struct kvm_vmcb_info vmcb01;
 	struct kvm_vmcb_info *current_vmcb;
-	u32 asid;
 	u32 sysenter_esp_hi;
 	u32 sysenter_eip_hi;
 	uint64_t tsc_aux;
-- 
2.48.1.362.g079036d154-goog


