Return-Path: <kvm+bounces-42068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC562A71F72
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 258AD17C1EB
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B70D257AEC;
	Wed, 26 Mar 2025 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UD+UUtIW"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B515335C7
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018307; cv=none; b=bfXefm4m9wwV2x8LmCkYYxuo4X2UNC+WRkqm49cL+oLg/0UEV8VEALnTcZIUs2yp6BOW90jpvvXrn5AisIu4e8MiCiSgWT38hbSMhXE7Y/+LRTJXQz/pY1RBCqAxoxnHeO+UeMAmArjFV9209GyrLSxDUGgvm7lqMLPkYsQ0Tvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018307; c=relaxed/simple;
	bh=Q+u4MZuDKUNqegWFP2vQgLiAAQq8Sl2SpCPgZZN3GX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZM9vSIFY0cD9CCuyISvHGYkldICqPqaXGWzFJHOTl9CYLydoTCVDETMQgY8MyYYj86DycoZYuPCg+hdXF/kDLHP94pRoM8KTKy6JLv4yOyiw5+HpNjFae5Xn9AvjQD5Yz74/QGK0RaJhvYq/vE9OolZJAd09dxv5A8QM6Y9fvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UD+UUtIW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0ttQrYyxTXxPea/MErL3ctFGOlp5LmJRLSVUgf6cSc=;
	b=UD+UUtIWQ6E6kzaZGNUJP5OuSS2zSK1ztioh/MCvV8yo/KJ7ijB1QmtDoCCvW6CmihclMc
	Mq9MQaIcgvFC4iq1Mx1+XvCsAyHLVJ95wojzKbf2bn+2uAB3DtipJznSfqTSkIu1k2Q0gT
	JUFe5O6En8Dw22T9nUDDJ7UQQHBeKYw=
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
Subject: [RFC PATCH 22/24] KVM: nSVM: Handle INVLPGA interception correctly
Date: Wed, 26 Mar 2025 19:44:21 +0000
Message-ID: <20250326194423.3717668-3-yosry.ahmed@linux.dev>
In-Reply-To: <20250326194423.3717668-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
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

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  5 +++--
 arch/x86/kvm/svm/svm.c          | 36 +++++++++++++++++++++++++++++++--
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d881e7d276b12..a158d324168a0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2237,6 +2237,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
+void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			       u64 addr, unsigned long roots, bool gva_flush);
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2b1994f12753..d3baa12df84e7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6355,8 +6355,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
-static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				      u64 addr, unsigned long roots, bool gva_flush)
+void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			       u64 addr, unsigned long roots, bool gva_flush)
 {
 	int i;
 
@@ -6382,6 +6382,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
 			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
+EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
 
 void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			     u64 addr, unsigned long roots)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3649707c61d3e..4b95fd6b501e6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2505,6 +2505,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
 
 static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
@@ -2514,8 +2515,39 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
 
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
+	 * to the new ASID anyway.
+	 */
+	if (asid == svm->nested.last_asid)
+		invlpga(gva, svm_nested_asid(vcpu->kvm));
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
-- 
2.49.0.395.g12beb8f557-goog


