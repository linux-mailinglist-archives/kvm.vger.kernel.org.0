Return-Path: <kvm+bounces-38701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E320CA3DBAF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2FF419C1605
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1651FE463;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiPw885a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486AC1FBCA4;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=RwA9+hHyewjkqGRteMTTVrJfqxYsu6BP5tOTWm45FEBadCyHBlu7fmDK3SFASM3PvnccZUfUH+LhK/jvt04LhkazhBn0A8U9ohAvLRqvNaJUnbdplUmDtPOU1mZq365G33slpnifAxOWWxWzzzYKDo/pdOu5zkd43scXjOwC9EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=+4IhGCZKSDv030X/F7zzYtvjqdN4RzFElZ+QA2y5AmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=myNOnoXnSwNTol3pSQiYJuUtyxTHGmib/EWUkmmuVRSRw8a+sFpzJ5dX0cGWyvLBqsS+GLMI7gwqMM1fWSqpmoFO8x2g/Ejhs93k2OtXN4PUHNppN7Sb4z7ys6JG/dYEMo4zSyb0VqnaQzE3s/aDnsnPwhtgPt6ubQIiLqkgf5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiPw885a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A80EC4CED1;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=+4IhGCZKSDv030X/F7zzYtvjqdN4RzFElZ+QA2y5AmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiPw885aAEnc8fsWzlHA7cfUsze7JA1k4qJlzkIx+Zk7BplPf/KIcTTIeWv+2RqGl
	 ypsugHCjdWvrq6VRLQ9hCoYWgd9qa6sqWUeAHj9YdMksI6/hv9JHZXFBOUCrm2IGbN
	 8nTbvi1rvALDuBmtUSyV2xbxe03foitCwPZZYZfc1YX5dWiokFcrDp2YMD+gFIcG58
	 id7OHrQy9JHDm5155TmEwpk8Z4DUBRcIg2wH72MZUvNwRyIG/mQVsomvJYkHQ5TPq5
	 YUWx33wO78vWO0oH5sKJI8R5JLJe4vNsknVj1xP96hIZt9cCL1SbSzq9lVVG5QvN4Z
	 /1IZqcvB3tfFQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-CP;
	Thu, 20 Feb 2025 13:49:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 09/14] KVM: arm64: Move NV-specific capping to idreg sanitisation
Date: Thu, 20 Feb 2025 13:49:02 +0000
Message-Id: <20250220134907.554085-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of applying the NV idreg limits at run time, switch to
doing it at the same time as the reset of the VM initialisation.

This will make things much simpler once we introduce vcpu-driven
variants of NV.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/nested.c             | 45 +----------------------------
 arch/arm64/kvm/sys_regs.c           |  3 ++
 3 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 56c4bcd35e2e5..692f403c1896e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -188,6 +188,7 @@ static inline bool kvm_supported_tlbi_s1e2_op(struct kvm_vcpu *vpcu, u32 instr)
 }
 
 int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu);
+u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val);
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2cc82e69ab523..96d1d300e79f9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -804,7 +804,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
  * This list should get updated as new features get added to the NV
  * support, and new extension to the architecture.
  */
-static u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
+u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 {
 	switch (reg) {
 	case SYS_ID_AA64ISAR0_EL1:
@@ -929,47 +929,6 @@ static u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 	return val;
 }
 
-static void limit_nv_id_regs(struct kvm *kvm)
-{
-	u64 val;
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR0_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64ISAR1_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR1_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR0_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR0_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR1_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR1_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR2_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR2_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64MMFR4_EL1, val);
-
-	val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
-	val = limit_nv_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
-}
-
 u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
 			     enum vcpu_sysreg sr, u64 v)
 {
@@ -1014,8 +973,6 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	if (!kvm->arch.sysreg_masks)
 		return -ENOMEM;
 
-	limit_nv_id_regs(kvm);
-
 	/* VTTBR_EL2 */
 	res0 = res1 = 0;
 	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d14daadb8a7c0..87f165289fb9f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1638,6 +1638,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		break;
 	}
 
+	if (vcpu_has_nv(vcpu))
+		val = limit_nv_id_reg(vcpu->kvm, id, val);
+
 	return val;
 }
 
-- 
2.39.2


