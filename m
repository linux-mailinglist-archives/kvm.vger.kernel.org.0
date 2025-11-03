Return-Path: <kvm+bounces-61877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCBC7C2D5B4
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:08:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 057B23AE0C4
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9917E324B20;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVWAkiZy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4277B320CBB;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188931; cv=none; b=FO3/Q3B17zRByAqWh9ZYnCjxoXnvIW0wKNDV4iHJCDiImelLzZy9V8MlrYoBJu44RtlwkEBnqfzj2kB/NMo/KtUg5IdcCoyh1/LpOJCijaih8SKMuRPBityrawsGvxWemYovELfxxUcA71KMq/9AVPcY5lu5CJJoInXSuUBDbek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188931; c=relaxed/simple;
	bh=aQ7u70SG7WFJvTtI0RPPihLeSLpWJXoLDaE7OdfAJsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB7drgrhf10Dn95Ofa9Z958J/WP6Q0rQC8alCG1+0lfRwT4nBrVW40sQ//KwXEIXt/p/ak7nX5dLZJeVhO/evc6Xc2kHXPEOcPahLA2aQnFVIMMIILx8OZAEkkhvFQ/dmHHsvPJWbsY+qoUZq9q7OyT+ejnzbHK4kOkDcimWUTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVWAkiZy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06300C4CEE7;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188931;
	bh=aQ7u70SG7WFJvTtI0RPPihLeSLpWJXoLDaE7OdfAJsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVWAkiZy6GPAHGfO1Nxuc8vnC7R4C9UJdbb5HcPVA/ZogDt64H4UVFAOEgrx3RxlX
	 mqMacbrAewsDnUEeliAGqVcFxhEwYeMRjrcgRqZYkld7Q8+L5iU7iZWy3xiW/iPSwO
	 IRsUDfawyZGbz09+4fYQ0poNDId2IDXInl6fhg/B7I4dWcKDK1XX4ke6//+vAB3FVo
	 V06Narhx/v1qhO+YsdgrcOCX7EFlxXuddL2Kx73hgtfI1m9fMPj81RNDiC9+H/TC41
	 jlc4mkBmw7ya/MwNUwM25N/Dd8KQYMP+/aVAsYlwWG1j3T71dq7beAssahP8df2PNr
	 g4C9Kly+sfkpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq5-000000021VN-0miM;
	Mon, 03 Nov 2025 16:55:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 19/33] KVM: arm64: Eagerly save VMCR on exit
Date: Mon,  3 Nov 2025 16:55:03 +0000
Message-ID: <20251103165517.2960148-20-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently save/restore the VMCR register in a pretty lazy way
(on load/put, consistently with what we do with the APRs).

However, we are going to need the group-enable bits that are backed
by VMCR on each entry (so that we can avoid injecting interrupts for
disabled groups).

Move the synchronisation from put to sync, which results in some minor
churn in the nVHE hypercalls to simplify things.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h     |  2 +-
 arch/arm64/include/asm/kvm_hyp.h     |  2 +-
 arch/arm64/kvm/arm.c                 |  3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  7 ++++---
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 15 +++------------
 arch/arm64/kvm/vgic/vgic-v2.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |  2 +-
 8 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9da54d4ee49ee..f8adbd535b4ae 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,7 +79,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index e6be1f5d0967f..dbf16a9f67728 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -82,7 +82,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
-void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a74..733195ef183e1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -659,8 +659,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (is_protected_kvm_enabled()) {
-		kvm_call_hyp(__vgic_v3_save_vmcr_aprs,
-			     &vcpu->arch.vgic_cpu.vgic_v3);
+		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
 	}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 29430c031095a..a7c689152f686 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -157,6 +157,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
 	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
+	host_cpu_if->vgic_vmcr		= hyp_cpu_if->vgic_vmcr;
 	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
@@ -464,11 +465,11 @@ static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 	__vgic_v3_init_lrs();
 }
 
-static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
+static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
 
-	__vgic_v3_save_vmcr_aprs(kern_hyp_va(cpu_if));
+	__vgic_v3_save_aprs(kern_hyp_va(cpu_if));
 }
 
 static void handle___vgic_v3_restore_vmcr_aprs(struct kvm_cpu_context *host_ctxt)
@@ -616,7 +617,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
-	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index d001b26a21f16..1e5c1cf4b9144 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -235,6 +235,8 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 		}
 	}
 
+	cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
+
 	if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
 		u64 val = read_gicreg(ICH_HCR_EL2);
 		cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
@@ -332,10 +334,6 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 
-	if (!cpu_if->vgic_sre) {
-		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
-	}
-
 	/* Only restore SRE if the host implements the GICv2 interface */
 	if (static_branch_unlikely(&vgic_v3_has_v2_compat)) {
 		val = read_gicreg(ICC_SRE_EL2);
@@ -357,7 +355,7 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-static void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	u64 val;
 	u32 nr_pre_bits;
@@ -518,13 +516,6 @@ static void __vgic_v3_write_vmcr(u32 vmcr)
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
-void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
-{
-	__vgic_v3_save_aprs(cpu_if);
-	if (cpu_if->vgic_sre)
-		cpu_if->vgic_vmcr = __vgic_v3_read_vmcr();
-}
-
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
 	__vgic_v3_compat_mode_enable();
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 5a2165a8d22c0..07e93acafd04d 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -451,6 +451,7 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	if (!base)
 		return;
 
+	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
 
 	if (used_lrs)
 		save_lrs(vcpu, base);
@@ -495,6 +496,5 @@ void vgic_v2_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 
-	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
 	cpu_if->vgic_apr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 387557e20a272..17bceef83269e 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -341,7 +341,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	u64 val;
 	int i;
 
-	__vgic_v3_save_vmcr_aprs(s_cpu_if);
+	__vgic_v3_save_aprs(s_cpu_if);
 	__vgic_v3_deactivate_traps(s_cpu_if);
 	__vgic_v3_save_state(s_cpu_if);
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ad5c0dbae2dfe..15225cf353f91 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -815,7 +815,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 	}
 
 	if (likely(!is_protected_kvm_enabled()))
-		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
+		kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
 	if (has_vhe())
-- 
2.47.3


