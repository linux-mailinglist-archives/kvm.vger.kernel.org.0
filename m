Return-Path: <kvm+bounces-44432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F558A9DAA0
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F7F27B7751
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDEF25333D;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlWCnSt/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8EA252906;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670536; cv=none; b=ebQTn1WONwLjhnZQllC4A1D8ytHCiMRK7WAtFTB/9vpDIH0dboZMlkMi2W5VHQd7J5afQRJhGEPTolpRWvLMS8JtYTMZ22+ro8SlxSWjl+KeTC7I0B8+lDc2WGcXeuNQHzzRgOzRdaWSfVSmMc7tBQNFBPs7T5oOF8rZQdizvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670536; c=relaxed/simple;
	bh=az6H4zS7ATnhB2/Y37RrSzyGkoU47BWde5sQBxqx5Wo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M3uO3+fiLP2aZCtws5vuGAOjPPQBegBcwsmgTdvHkcDaxBSDAacgVP7cZTZUhepBGPvjq21yv9g2f9VUz2oaDSddjUkCcbvctrwAozqe0HWI/ZfWkKsUCTp6/0vGLTwaKer5fURMiMOTJvka+U3BOU7uE4e9vfc680JGWFmZsZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlWCnSt/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2112C4CEE2;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670536;
	bh=az6H4zS7ATnhB2/Y37RrSzyGkoU47BWde5sQBxqx5Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlWCnSt/blK9gmqvd5kiergQjCvBmOKA+/NLVb4MKyWlCdvAIde8HA1CysjFJD3qQ
	 ljqWtlWiehQY/utnH7LnYPpHyIe4yffVHoElUhbLLZqmINmgP8Nv/QF9k9Un+SvUhl
	 J3TRoq2ZqrauACOmWT87AI0w1+ZVT57izWdCpdUyC9KyafYkCDCcQs38idWXA9vfV3
	 /5IKxjDMBg6e+762alZyN6Yn498dmNukHGxjamxjXAkSm/Smg+qh2hr+pPKSld5Q4O
	 7nw0fHtULDvECrEQ5i9oJKhia7qKHGrkKE8x60jfil/IU/q6LcxFpDCp2woHrAsFAR
	 Tu3zSpNGTnHrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeM-0092VH-49;
	Sat, 26 Apr 2025 13:28:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 20/42] KVM: arm64: Plug FEAT_GCS handling
Date: Sat, 26 Apr 2025 13:28:14 +0100
Message-Id: <20250426122836.3341523-21-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We don't seem to be handling the GCS-specific exception class.
Handle it by delivering an UNDEF to the guest, and populate the
relevant trap bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 11 +++++++++++
 arch/arm64/kvm/sys_regs.c    |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 636c14ed2bb82..eafbd2a243afd 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -298,6 +298,16 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
+{
+	/* We don't expect GCS, so treat it with contempt */
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
+		WARN_ON_ONCE(1);
+
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static int handle_other(struct kvm_vcpu *vcpu)
 {
 	bool is_l2 = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
@@ -380,6 +390,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
+	[ESR_ELx_EC_GCS]	= kvm_handle_gcs,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ce347ddb6fae0..a9ecca4b2fa74 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5209,6 +5209,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_nBRBIALL);
 	}
 
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP)) {
+		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nGCS_EL0 |
+						HFGRTR_EL2_nGCS_EL1);
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nGCSPUSHM_EL1 |
+						HFGITR_EL2_nGCSSTR_EL1 |
+						HFGITR_EL2_nGCSEPP);
+	}
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2


