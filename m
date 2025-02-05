Return-Path: <kvm+bounces-37383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85059A298EF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFB9518853F7
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA10213E79;
	Wed,  5 Feb 2025 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E04eNAhV"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFB72116E1
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779877; cv=none; b=fdQZjHvTKuSzf0otR0eEzqlhNnmR3vyDxL/HYPyTpQXT/ky/3fZV0YyJz6ixRs7OOpeEvXqMNtX6XqHwwItP1QoRyQNL1ftpDONT8J2iR0lClYCs7PLBa/Bf0nmdQpDYzxFvZoF0mc2ezYPk6+siZYmeGiypIzr5CkdM6S60iZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779877; c=relaxed/simple;
	bh=zF9HTCv7mSgTL3YrGXtFVrB6+Y1fi2Pvd+FTWNRpeR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i22b3hJsGU83Ioyl1qYj2Z8fO+cIq20AFzYoCbTy32YDnOSPbDGv5pR3KlWbhJwMpHeLdPukW0FFZIggxQP/khioDqRGURUA5ulc9qhjOBI04MADPdO2PQ7yssPdNt7F5meWtrunhgstjo6/AbO6x+2o63WHgKNiY8N42VKlifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E04eNAhV; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz1utprcDIKkMo3Ywq+21FXOydI1N6MlW8m2PYuMMdM=;
	b=E04eNAhVibFslE0+RudNcvJg/LpVZFO+QtTaETUQgDnx+WlN2D3XHlAAxZtxIaZam+l+EB
	eDaNPIYUE+wnmz0G7wnSWJDXIdrJl5RvZ5Xgtk4Ktf02/laGUDP7tWmE0tGB9YNtr7CMIF
	VgxmH0hRH3v6ZcRwE+4jlr1uAViKs4U=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/13] KVM: nSVM: Handle INVLPGA interception correctly
Date: Wed,  5 Feb 2025 18:23:56 +0000
Message-ID: <20250205182402.2147495-8-yosry.ahmed@linux.dev>
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

Currently, INVPLGA interception handles it like INVLPG, which flushes
L1's TLB translations for the address. It was implemented in this way
because L1 and L2 shared an ASID. Now, L1 and L2 have separate ASIDs. It
is still harmless to flush L1's translations, but it's only correct
because all translations are flushed on nested transitions anyway.

In preparation for stopping unconditional flushes on nested transitions,
handle INVPLGA interception properly. If L1 specified zero as the ASID,
this is equivalent to INVLPG, so handle it as such. Otherwise, use
INVPLGA to flush the translations of the appropriate ASID tracked by
KVM, if any. Sync the shadow MMU as well, as L1 invalidated L2's
mappings.

Opportunistically update svm_flush_tlb_gva() to use
svm->current_vmcb->asid instead of svm->vmcb->control.asid for
consistency. The two should always be in sync except when KVM allocates
a new ASID in pre_svm_run(), and they are shortly brought back in sync
in svm_vcpu_run(). However, if future changes add more code paths where
KVM allocates a new ASID, flushing the potentially old ASID in
svm->vmcb->control.asid would be unnecessary overhead (although probably
not much different from flushing the newly allocated ASID).

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  5 +++--
 arch/x86/kvm/svm/svm.c          | 40 ++++++++++++++++++++++++++++++---
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce15..1e147bb2e560f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2213,6 +2213,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
+void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			       u64 addr, unsigned long roots, bool gva_flush);
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ac133abc9c173..f5e0d2c8f4bbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6158,8 +6158,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				      u64 addr, unsigned long roots, bool gva_flush)
+void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			       u64 addr, unsigned long roots, bool gva_flush)
 {
 	int i;
 
@@ -6185,6 +6185,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
 			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
+EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
 
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a2d601cd4c283..9e29f87d3bd93 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2483,6 +2483,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
 
 static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
@@ -2492,8 +2493,41 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
 
 	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
 
-	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
-	kvm_mmu_invlpg(vcpu, gva);
+	/*
+	 * APM is silent about using INVLPGA to flush the host ASID (i.e. 0).
+	 * Do the logical thing and handle it like INVLPG.
+	 */
+	if (asid == 0) {
+		kvm_mmu_invlpg(vcpu, gva);
+		return kvm_skip_emulated_instruction(vcpu);
+	}
+
+	/*
+	 * Check if L1 specified the L2 ASID we are currently tracking. If it
+	 * isn't, do nothing as we have to handle the TLB flush when switching
+	 * to the new ASID anyway. APM mentions that INVLPGA is typically only
+	 * meaningful with shadow paging, so also do nothing if L1 is using
+	 * nested NPT.
+	 */
+	if (!nested_npt_enabled(svm) && asid == svm->nested.last_asid)
+		invlpga(gva, svm->nested.vmcb02.asid);
+
+	/*
+	 * If NPT is disabled, sync the shadow page tables as L1 is invalidating
+	 * mappings for L2. Sync all roots as ASIDs are not tracked in the MMU
+	 * role.
+	 *
+	 * As we are not flushing the current context, skip the gva flush from
+	 * __kvm_mmu_invalidate_addr(), it would flush the wrong ASID anyway.
+	 * The correct TLB flush was done above (if needed).
+	 *
+	 * This always operates on root_mmu because L1 and L2 share an MMU when
+	 * NPT is disabled. This can be optimized by invalidating guest roots
+	 * only.
+	 */
+	if (!npt_enabled)
+		__kvm_mmu_invalidate_addr(vcpu, &vcpu->arch.root_mmu, gva,
+					  KVM_MMU_ROOTS_ALL, false);
 
 	return kvm_skip_emulated_instruction(vcpu);
 }
@@ -4017,7 +4051,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	invlpga(gva, svm->vmcb->control.asid);
+	invlpga(gva, svm->current_vmcb->asid);
 }
 
 static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
-- 
2.48.1.362.g079036d154-goog


