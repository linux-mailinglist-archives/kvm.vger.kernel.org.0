Return-Path: <kvm+bounces-42906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC11CA7FD5D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49E4B1895A39
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0212626FA4D;
	Tue,  8 Apr 2025 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STtPEmcl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20777269894;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109560; cv=none; b=YheMG89ZiMJrkY/9l0GzzXNS4yaJojAfPxY+tZCdqgN3cO/JvG/rnvtJvCVMeKt5Lt4o9zRJ1IobC807NqeYFVyV8Dk2UcQdXZ8+0zDgzH5+y81FmLAcBO2Y4GhtAiquoehfirsL0GvBDGYmpYbZjDfu2KrJyhFgIeAUNI9lNPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109560; c=relaxed/simple;
	bh=DMiRL11JjPSJeeXI/o7QWutOd3dtKmaSpTXC8NGHW0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LcWVVbL1VfZdHX5UULEJCfYtK3Hzs+zmVjyKVLsZ6w81nA/5MmUo6kNK0sTzVeqevceivXv+tH/m3poKh05jqqCoH9X6lBSfOkkhme/YZAPQ+UPKxaEhTLdq6o9PwTEw9HsifBpl3Ht3nBpWGlSNzJ/tAwv0fQzM/4vF8Ss2rLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STtPEmcl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018A2C4CEEB;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109560;
	bh=DMiRL11JjPSJeeXI/o7QWutOd3dtKmaSpTXC8NGHW0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STtPEmclauFnOFuFQXtOPbDyE+QuNRMw6kmc3NBMw/Q0GqSxYcmYGCVIqCI58nImq
	 r1VAAbYFi06Dp7iyjmjhM3rcp+EM+86nZ2PI2rszcEG5iXrNfk0I5uG8Zwo17eFAMF
	 u2XNTHkzFksNcVLNZUJHsqs+9kl7dlEtfoEJf1L3+Cu0b5Kz59/5UK309FeRlKXpX3
	 n4dRB2KpvneEjJtxSEinKRimmkyzF22PWVCTf33wKS2EQaCbHuNNVy8QZZBF960KlU
	 5uBl31BQdeh62kAOJclLE5LMfm+ErHHmc5HPZ32Tj8E7KRsGPsq2vggPQvXi4LpkR3
	 eMgDeN9vFbV9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZK-003QX2-5y;
	Tue, 08 Apr 2025 11:52:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 06/17] KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
Date: Tue,  8 Apr 2025 11:52:14 +0100
Message-Id: <20250408105225.4002637-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
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

We currently check for HCR_EL2.NV being set to decide whether we
need to repaint PSTATE.M to say EL2 instead of EL1 on exit.

However, this isn't correct when L2 is itself a hypervisor, and
that L1 as set its own HCR_EL2.NV. That's because we "flatten"
the state and inherit parts of the guest's own setup. In that case,
we shouldn't adjust PSTATE.M, as this is really EL1 for both us
and the guest.

Instead of trying to try and work out how we ended-up with HCR_EL2.NV
being set by introspecting both the host and guest states, use
a per-CPU flag to remember the context (HYP or not), and use that
information to decide whether PSTATE needs tweaking.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/hyp/vhe/switch.c   | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a62..12adab97e7f25 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -654,6 +654,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_TRBE			1
 #define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
 #define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
+#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		6
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 731a0378ed132..220dee8a45e0d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -53,13 +53,23 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_nv(vcpu))
 		return hcr;
 
+	/*
+	 * We rely on the invariant that a vcpu entered from HYP
+	 * context must also exit in the same context, as only an ERET
+	 * instruction can kick us out of it, and we obviously trap
+	 * that sucker. PSTATE.M will get fixed-up on exit.
+	 */
 	if (is_hyp_ctxt(vcpu)) {
+		host_data_set_flag(VCPU_IN_HYP_CONTEXT);
+
 		hcr |= HCR_NV | HCR_NV2 | HCR_AT | HCR_TTLB;
 
 		if (!vcpu_el2_e2h_is_set(vcpu))
 			hcr |= HCR_NV1;
 
 		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
+	} else {
+		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);
 	}
 
 	return hcr | (__vcpu_sys_reg(vcpu, HCR_EL2) & ~NV_HCR_GUEST_EXCLUDE);
@@ -568,9 +578,12 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/*
 	 * If we were in HYP context on entry, adjust the PSTATE view
-	 * so that the usual helpers work correctly.
+	 * so that the usual helpers work correctly. This enforces our
+	 * invariant that the guest's HYP context status is preserved
+	 * across a run.
 	 */
-	if (vcpu_has_nv(vcpu) && (read_sysreg(hcr_el2) & HCR_NV)) {
+	if (vcpu_has_nv(vcpu) &&
+	    unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
 		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 		switch (mode) {
@@ -586,6 +599,10 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		*vcpu_cpsr(vcpu) |= mode;
 	}
 
+	/* Apply extreme paranoia! */
+	BUG_ON(vcpu_has_nv(vcpu) &&
+	       !!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
+
 	return __fixup_guest_exit(vcpu, exit_code, hyp_exit_handlers);
 }
 
-- 
2.39.2


