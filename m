Return-Path: <kvm+bounces-38289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D9FA36EF1
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8EC189477A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F0611EDA34;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZkMFKUq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFC1DFD89;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=O7/+KohDnEn9ah8WS4spXpP0O2xlQa9LrB/7E4vQgzoNGE5mLtoewqRHCGbdMhAXBVs0xp2R4y6glxRT6F6chcFB16CzMWQbAJyDcpC7h1cmnsWpN+fj95X8LSC/EsizKjiezpcvdiU1jDK0Hj4fopFQe90BGctfqhoEUZTrpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=SwzU8d3Rx/Sz7zhOT8ZS3cObd9aGG2nHVFLOm2bBxwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WjKRLL91XaZ8Ovt4n6DhRM0VzY3iAKTmcRb1zsuOn0IeelOTvvdtmBmxP1D5owbRcUFL/Uyej/PdpS3fBFyQYJ4b/02mLgyo0USpp/ZIxhx6Qn6V3xZMkEowu/BzBqjgEx7b9Yv7uWShrRTQL/F3IT0eaZaPeRSSB5EuF4EvmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZkMFKUq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FFEC4CEE6;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=SwzU8d3Rx/Sz7zhOT8ZS3cObd9aGG2nHVFLOm2bBxwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZkMFKUqq0Wft/nsdeJUY/msqPbh6oHirE+z/j/zqove3KAWajYDVpjB1wE8IIhU2
	 05hMzDNs47OBqTG8e//sVq5RRYQoJUk2ks+nVPYvGj8EfwzWXrpvWrOcdHt1dbdP85
	 cIAsePiC4VRPRXb4rAu+SjNjD4I38ARIpYo0VH0sjy3anQUA4n7fC3ewRkNIHP5QLX
	 8IQr3re8+zJvDeX+wjndBHfq5VLTYNq+NLYMBwUxlPGIe9nqZ3NY/9z6d09ShlVgAG
	 vcTaeiFhoV4o+400myP7UqgcJoavV+r+YeBNkxxkXwLkzkR1vLBezmbgghFdWqsNdX
	 c+3xF/AslvBdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg9-004Nz6-Hs;
	Sat, 15 Feb 2025 15:02:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 07/14] KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
Date: Sat, 15 Feb 2025 15:01:27 +0000
Message-Id: <20250215150134.3765791-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_NV2 introduces an interesting problem for NV, as VNCR_EL2.BADDR
is a virtual address in the EL2&0 (or EL2, but we thankfully ignore
this) translation regime.

As we need to replicate such mapping in the real EL2, it means that
we need to remember that there is such a translation, and that any
TLBI affecting EL2 can possibly affect this translation.

It also means that any invalidation driven by an MMU notifier must
be able to shoot down any such mapping.

All in all, we need a data structure that represents this mapping,
and that is extremely close to a TLB. Given that we can only use
one of those per vcpu at any given time, we only allocate one.

No effort is made to keep that structure small. If we need to
start caching multiple of them, we may want to revisit that design
point. But for now, it is kept simple so that we can reason about it.

Oh, and add a braindump of how things are supposed to work, because
I will definitely page this out at some point. Yes, pun intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |  5 ++
 arch/arm64/include/asm/kvm_nested.h |  3 ++
 arch/arm64/kvm/arm.c                |  6 +++
 arch/arm64/kvm/nested.c             | 72 +++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c              |  1 +
 5 files changed, 87 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 519023dad3b47..dd287ccaffdb7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -706,6 +706,8 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+struct vncr_tlb;
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
@@ -800,6 +802,9 @@ struct kvm_vcpu_arch {
 
 	/* Per-vcpu CCSIDR override or NULL */
 	u32 *ccsidr;
+
+	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
+	struct vncr_tlb	*vncr_tlb;
 };
 
 /*
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cc1302cb7929f..6a168ae95aef4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -332,4 +332,7 @@ struct s1_walk_result {
 int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		       struct s1_walk_result *wr, u64 va);
 
+/* VNCR management */
+int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 071a7d75be689..274883bf4dd4e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -815,6 +815,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (vcpu_has_nv(vcpu)) {
+		ret = kvm_vcpu_allocate_vncr_tlb(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * This needs to happen after any restriction has been applied
 	 * to the feature set.
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 952a1558f5214..6ae5ec43ddeaa 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -16,6 +16,24 @@
 
 #include "sys_regs.h"
 
+struct vncr_tlb {
+	/* The guest's VNCR_EL2 */
+	u64			gva;
+	struct s1_walk_info	wi;
+	struct s1_walk_result	wr;
+
+	u64			hpa;
+
+	/* -1 when not mapped on a CPU */
+	int			cpu;
+
+	/*
+	 * true if the TLB is valid. Can only be changed with the
+	 * mmu_lock held.
+	 */
+	bool			valid;
+};
+
 /* Protection against the sysreg repainting madness... */
 #define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
 
@@ -809,6 +827,60 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_uninit_stage2_mmu(kvm);
 }
 
+/*
+ * Dealing with VNCR_EL2 exposed by the *guest* is a complicated matter:
+ *
+ * - We introduce an internal representation of a vcpu-private TLB,
+ *   representing the mapping between the guest VA contained in VNCR_EL2,
+ *   the IPA the guest's EL2 PTs point to, and the actual PA this lives at.
+ *
+ * - On translation fault from a nested VNCR access, we create such a TLB.
+ *   If there is no mapping to describe, the guest inherits the fault.
+ *   Crucially, no actual mapping is done at this stage.
+ *
+ * - On vcpu_load() in a non-HYP context with HCR_EL2.NV==1, if the above
+ *   TLB exists, we map it in the fixmap for this CPU, and run with it. We
+ *   have to respect the permissions dictated by the guest, but not the
+ *   memory type (FWB is a must).
+ *
+ * - Note that we usually don't do a vcpu_load() on the back of a fault
+ *   (unless we are preempted), so the resolution of a translation fault
+ *   must go via a request that will map the VNCR page in the fixmap.
+ *   vcpu_load() might as well use the same mechanism.
+ *
+ * - On vcpu_put() in a non-HYP context with HCR_EL2.NV==1, if the TLB was
+ *   mapped, we unmap it. Yes it is that simple. The TLB still exists
+ *   though, and may be reused at a later load.
+ *
+ * - On permission fault, we simply forward the fault to the guest's EL2.
+ *   Get out of my way.
+ *
+ * - On any TLBI for the EL2&0 translation regime, we must find any TLB that
+ *   intersects with the TLBI request, invalidate it, and unmap the page
+ *   from the fixmap. Because we need to look at all the vcpu-private TLBs,
+ *   this requires some wide-ranging locking to ensure that nothing races
+ *   against it. This may require some refcounting to avoid the search when
+ *   no such TLB is present.
+ *
+ * - On MMU notifiers, we must invalidate our TLB in a similar way, but
+ *   looking at the IPA instead. The funny part is that there may not be a
+ *   stage-2 mapping for this page if L1 hasn't accessed it using LD/ST
+ *   instructions.
+ */
+
+int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
+		return 0;
+
+	vcpu->arch.vncr_tlb = kzalloc(sizeof(*vcpu->arch.vncr_tlb),
+				      GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.vncr_tlb)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3c48527aef360..0d95b512eec12 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -159,6 +159,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
 	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
 }
 
-- 
2.39.2


