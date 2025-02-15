Return-Path: <kvm+bounces-38288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA47A36EF9
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF6763ADB76
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664EA1F3D45;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW6bEWVh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCBA1DF73D;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=b87y6zWxOnB5wsecp/9TXzaucJCgGkTcqXr/QH8tG0Bw5Yjrp4zEMzEz/IXXBXI0H0oQpbb57gQYSUiTqL8lnq/GImYMs88pS9HyLOCzZzxRyubT422kbsM6Z2VfN7cMtxtOVqFbO6xpks7/JIteAZqF7u8qREOwNXaGxxSpopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=PpoF2F+1+wn+5ob8I5NtW1ySbrqpV7c5zsFC4HILuKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hTJ1UFwiezXhKJHNz6yUPC9E6vFL6wqu1PPVZlDQgzA8+L6p7KzE4ftWKSaDw/FjyQMD/N9OUqcQRT+gEVvmNbAnZFEW9kdgjOKv8YjRHZiEfCeQHftDxUkbCQvgRwhwPLGh+jLMUrtBKt8w3XDwtS/f/C4/tR7CcqzwuWi5klg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW6bEWVh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323BBC4CEDF;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=PpoF2F+1+wn+5ob8I5NtW1ySbrqpV7c5zsFC4HILuKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VW6bEWVhseSajhayzaAGS7lxFOgbpxRKhYnzuy6LNN2/KwoiLKl67/RWj46YH2WWk
	 1JpRW4ZtqPVIE2U45QRcPexbeZFPrtu6wKHe5tq1b6O35UcaWc3IWIQ8IYJPioLi3K
	 TZ0hCiJUAUHQf6Nql2TE9PC35e4QEylPSHLheXCgY1LDsu7hcBhxAEUeIQuLTYIwQB
	 TM4b25Z9BhRT0R3eejKudxMq6P+5zyg3ElMug5RxziE3CkXewLQCZk8B4kNEAKRjt+
	 j3h0/Y8qfJ1IprSiuDABskclpBHx1Pi3mlF0YMTMBtPW8xGeKBWSOq6tjiFARUyKGc
	 OFxGxpw1B05aA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg9-004Nz6-Bw;
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
Subject: [PATCH 06/14] KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
Date: Sat, 15 Feb 2025 15:01:26 +0000
Message-Id: <20250215150134.3765791-7-maz@kernel.org>
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
 arch/arm64/kvm/hyp/vhe/switch.c   | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e34..519023dad3b47 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -619,6 +619,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HOST_SME_ENABLED		3
 #define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
 #define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
+#define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		6
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b5b9dbaf1fdd6..3453fb76cf0e3 100644
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
@@ -545,11 +555,16 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
 
 static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	if (!vcpu_has_nv(vcpu))
+		return;
+
 	/*
 	 * If we were in HYP context on entry, adjust the PSTATE view
-	 * so that the usual helpers work correctly.
+	 * so that the usual helpers work correctly. This enforces our
+	 * invariant that the guest's HYP context status is preserved
+	 * across a run.
 	 */
-	if (vcpu_has_nv(vcpu) && (read_sysreg(hcr_el2) & HCR_NV)) {
+	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
 		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 		switch (mode) {
@@ -564,6 +579,9 @@ static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)
 		*vcpu_cpsr(vcpu) &= ~(PSR_MODE_MASK | PSR_MODE32_BIT);
 		*vcpu_cpsr(vcpu) |= mode;
 	}
+
+	/* Apply extreme paranoia! */
+	BUG_ON(!!host_data_test_flag(VCPU_IN_HYP_CONTEXT) != is_hyp_ctxt(vcpu));
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
-- 
2.39.2


