Return-Path: <kvm+bounces-37492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06DEAA2ACFA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A37A16A8A3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFD52451E3;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKHgdf14"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45331E5B8E;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856982; cv=none; b=ctqWxgxJBzAOT1e4+fKqCAPrHBFgDa/nBWZKqgcV9VtctcFjg17qm3KDbZj6QzQtEXDfbU/NgzpCwHaT5wK4WyjHur1/j2njkltn4WrZJcwZTNMXMSec/SN/TsTGDZ2YDmtohToCgY+hHzc0DT8qC4DMwjdEjeQREJKpX3PXxD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856982; c=relaxed/simple;
	bh=KqTJJJlKyqMVc2PH2Cuiz0NayHv0pDB4bXBKnTulMnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y56sth9CKD/pCsDRu8qef48oWTCVOGmoaoQGTGyGJAY9PpffGo7Q19Oh4UoIM5CkliE1YuhsLuds5QjLY5N4UNIpaOGKAA/oHFd0DnpqkOvqoe5RHYGJo0K/k+Ed0MFXtY/fKHHWgvqoiGugE0JuedIy9cMWIWU9XLmHHNsTgjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKHgdf14; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58277C4CEE2;
	Thu,  6 Feb 2025 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856981;
	bh=KqTJJJlKyqMVc2PH2Cuiz0NayHv0pDB4bXBKnTulMnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKHgdf14Ipisv38fommf66EG/+DN6ljWknxx5BLnOOE6SYiMYbephsoHP1IueeL6c
	 jLvD4c5n2NYuweMY8ahN78JFtNGSJSRaUFIDZFXp7HvoEI5ASBxok24Hf2RYRYPkbY
	 UqaaG6raUw9vG0gq5t/QxJ87NZFh22A1nGKeL5z0RV53ZBBbxV8Chuu0nClOSch4Ly
	 cdUilwBkOg/WEGmm/1Mk5Q2KrEH38S5hwnxAu584iEPiWcOZAQvkcWpx4rdKi4AJe0
	 4kxLFTw3v01IxSLseRMmdmygEacGMvozf0xH+YeytFSom5TCZl/bD+NKtf42t7ewSR
	 Nyvaz7MEimV0Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48J-001BOX-C8;
	Thu, 06 Feb 2025 15:49:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 02/16] arm64: sysreg: Add layout for ICH_VTR_EL2
Date: Thu,  6 Feb 2025 15:49:11 +0000
Message-Id: <20250206154925.1109065-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The ICH_VTR_EL2-related macros are missing a number of config
bits that we are about to handle. Take this opportunity to fully
describe the layout of that register as part of the automatic
generation infrastructure.

This results in a bit of churn to repaint constants that are now
generated with a different format.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h       | 13 -------------
 arch/arm64/kvm/vgic-sys-reg-v3.c      |  8 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c         | 16 +++++++---------
 arch/arm64/tools/sysreg               | 14 ++++++++++++++
 tools/arch/arm64/include/asm/sysreg.h | 13 -------------
 5 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 76a88042390f3..b59b2c680e977 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -562,7 +562,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
 #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
@@ -1022,18 +1021,6 @@
 #define ICH_VMCR_ENG1_SHIFT	1
 #define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
 
-/* ICH_VTR_EL2 bit definitions */
-#define ICH_VTR_PRI_BITS_SHIFT	29
-#define ICH_VTR_PRI_BITS_MASK	(7 << ICH_VTR_PRI_BITS_SHIFT)
-#define ICH_VTR_ID_BITS_SHIFT	23
-#define ICH_VTR_ID_BITS_MASK	(7 << ICH_VTR_ID_BITS_SHIFT)
-#define ICH_VTR_SEIS_SHIFT	22
-#define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
-#define ICH_VTR_A3V_SHIFT	21
-#define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
-#define ICH_VTR_TDS_SHIFT	19
-#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 9e7c486b48c2e..5eacb4b3250a1 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -35,12 +35,12 @@ static int set_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 
 	vgic_v3_cpu->num_id_bits = host_id_bits;
 
-	host_seis = FIELD_GET(ICH_VTR_SEIS_MASK, kvm_vgic_global_state.ich_vtr_el2);
+	host_seis = FIELD_GET(ICH_VTR_EL2_SEIS, kvm_vgic_global_state.ich_vtr_el2);
 	seis = FIELD_GET(ICC_CTLR_EL1_SEIS_MASK, val);
 	if (host_seis != seis)
 		return -EINVAL;
 
-	host_a3v = FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2);
+	host_a3v = FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2);
 	a3v = FIELD_GET(ICC_CTLR_EL1_A3V_MASK, val);
 	if (host_a3v != a3v)
 		return -EINVAL;
@@ -68,10 +68,10 @@ static int get_gic_ctlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	val |= FIELD_PREP(ICC_CTLR_EL1_PRI_BITS_MASK, vgic_v3_cpu->num_pri_bits - 1);
 	val |= FIELD_PREP(ICC_CTLR_EL1_ID_BITS_MASK, vgic_v3_cpu->num_id_bits);
 	val |= FIELD_PREP(ICC_CTLR_EL1_SEIS_MASK,
-			  FIELD_GET(ICH_VTR_SEIS_MASK,
+			  FIELD_GET(ICH_VTR_EL2_SEIS,
 				    kvm_vgic_global_state.ich_vtr_el2));
 	val |= FIELD_PREP(ICC_CTLR_EL1_A3V_MASK,
-			  FIELD_GET(ICH_VTR_A3V_MASK, kvm_vgic_global_state.ich_vtr_el2));
+			  FIELD_GET(ICH_VTR_EL2_A3V, kvm_vgic_global_state.ich_vtr_el2));
 	/*
 	 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
 	 * Extract it directly using ICC_CTLR_EL1 reg definitions.
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 5e9682a550460..51f0c7451817d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -284,12 +284,10 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 		vgic_v3->vgic_sre = 0;
 	}
 
-	vcpu->arch.vgic_cpu.num_id_bits = (kvm_vgic_global_state.ich_vtr_el2 &
-					   ICH_VTR_ID_BITS_MASK) >>
-					   ICH_VTR_ID_BITS_SHIFT;
-	vcpu->arch.vgic_cpu.num_pri_bits = ((kvm_vgic_global_state.ich_vtr_el2 &
-					    ICH_VTR_PRI_BITS_MASK) >>
-					    ICH_VTR_PRI_BITS_SHIFT) + 1;
+	vcpu->arch.vgic_cpu.num_id_bits = FIELD_GET(ICH_VTR_EL2_IDbits,
+						    kvm_vgic_global_state.ich_vtr_el2);
+	vcpu->arch.vgic_cpu.num_pri_bits = FIELD_GET(ICH_VTR_EL2_PRIbits,
+						     kvm_vgic_global_state.ich_vtr_el2) + 1;
 
 	/* Get the show on the road... */
 	vgic_v3->vgic_hcr = ICH_HCR_EL2_En;
@@ -633,7 +631,7 @@ static const struct midr_range broken_seis[] = {
 
 static bool vgic_v3_broken_seis(void)
 {
-	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK) &&
+	return ((kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_SEIS) &&
 		is_midr_in_range_list(read_cpuid_id(), broken_seis));
 }
 
@@ -707,10 +705,10 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (vgic_v3_broken_seis()) {
 		kvm_info("GICv3 with broken locally generated SEI\n");
 
-		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_SEIS_MASK;
+		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
 		group0_trap = true;
 		group1_trap = true;
-		if (ich_vtr_el2 & ICH_VTR_TDS_MASK)
+		if (ich_vtr_el2 & ICH_VTR_EL2_TDS)
 			dir_trap = true;
 		else
 			common_trap = true;
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index fa77621aba1a3..3e82a072eb493 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3057,6 +3057,20 @@ Field	1	UIE
 Field	0	En
 EndSysreg
 
+Sysreg	ICH_VTR_EL2	3	4	12	11	1
+Res0	63:32
+Field	31:29	PRIbits
+Field	28:26	PREbits
+Field	25:23	IDbits
+Field	22	SEIS
+Field	21	A3V
+Field	20	nV4
+Field	19	TDS
+Field	18	DVIM
+Res0	17:5
+Field	4:0	ListRegs
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 0ce8fc540fe22..5d9d7e394b254 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -558,7 +558,6 @@
 
 #define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-#define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
 #define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
@@ -1018,18 +1017,6 @@
 #define ICH_VMCR_ENG1_SHIFT	1
 #define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
 
-/* ICH_VTR_EL2 bit definitions */
-#define ICH_VTR_PRI_BITS_SHIFT	29
-#define ICH_VTR_PRI_BITS_MASK	(7 << ICH_VTR_PRI_BITS_SHIFT)
-#define ICH_VTR_ID_BITS_SHIFT	23
-#define ICH_VTR_ID_BITS_MASK	(7 << ICH_VTR_ID_BITS_SHIFT)
-#define ICH_VTR_SEIS_SHIFT	22
-#define ICH_VTR_SEIS_MASK	(1 << ICH_VTR_SEIS_SHIFT)
-#define ICH_VTR_A3V_SHIFT	21
-#define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
-#define ICH_VTR_TDS_SHIFT	19
-#define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
-- 
2.39.2


