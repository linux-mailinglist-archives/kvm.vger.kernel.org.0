Return-Path: <kvm+bounces-20474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F6591688A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FA5EB22D10
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30991607B0;
	Tue, 25 Jun 2024 13:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFNN+Mr6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADA4158D75;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320450; cv=none; b=kIJGOm8UzAbcAtetAinDZAUT7Zro5mFQAPjxuinemfgYZERL/847eHReo6GmwdYvEqXUV/cje1CKJYzLCIlgj2RR6kxhgMb3C6NJyWFd+7fvT4Hrz2vdqDh1jt5kYFIV4N8LVmXr11E6nlsxS7MHlxdgDY0Am/wMvP3zAGcjemY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320450; c=relaxed/simple;
	bh=ADorFG0VRvlOjHCobfWLs0ZsG4Mia8Zf6GgI3pzbQLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rpJ48iX2D1vXcjE4gdKb8dM/UDMOT4H0lz4/YXsaPuxRDSOGjCJL3COuDJD9xlBF86oNisZ/rTQhjKSvgVKhZCIa8xXZFLp9hM/n4EaANsp4xdrpwam2mxt5zEwS8CH1IrXD81nW1RTp5lFR2leuxQZGoFBzYZWMGDPSA3ceaI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFNN+Mr6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FF0C4AF0C;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=ADorFG0VRvlOjHCobfWLs0ZsG4Mia8Zf6GgI3pzbQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFNN+Mr6to0YXIDLuypSKUrr6IJbAkbp+Zo/YFbY6Vni1l1tvRQ/dOxmOEm+hWkrL
	 OnXt0K8EcI2YGwpYwBUo554wn/kk7wRTjodcJNDUi+QOxfXy/2EKbZXR61BR0XcV1a
	 AIwN31InUjMYAwixWf2NTIAxblqWfjBpMy0YO+498O/KVzVqkqRaSI5tXdO03P8uV2
	 xftjatGfl87jhtgyXJsYP/ugfuxn9MFc/PmcXiBNCIMFFW+Fyq/3SBpZ87IZGseK9d
	 JACbYS+dwxKiTCJN0Emye7trqZHxmoD1vGAeIYfE4eIXsFPHlFP3UrLaPxLvxcAcVQ
	 LO49pfVVlnOXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mx-0079X4-Ow;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 4/4] KVM: arm64: Honor trap routing for TCR2_EL1
Date: Tue, 25 Jun 2024 14:00:40 +0100
Message-Id: <20240625130042.259175-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TCR2_EL1 handling is missing the handling of its trap configuration:

- HCRX_EL2.TCR2En must be handled in conjunction with HCR_EL2.{TVM,TRVM}

- HFG{R,W}TR_EL2.TCR_EL1 does apply to TCR2_EL1 as well

Without these two controls being implemented, it is impossible to
correctly route TCR2_EL1 traps.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 54090967a3356..2fa2d5fc37d60 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -79,6 +79,8 @@ enum cgt_group_id {
 	CGT_MDCR_E2TB,
 	CGT_MDCR_TDCC,
 
+	CGT_HCRX_TCR2En,
+
 	/*
 	 * Anything after this point is a combination of coarse trap
 	 * controls, which must all be evaluated to decide what to do.
@@ -89,6 +91,7 @@ enum cgt_group_id {
 	CGT_HCR_TTLB_TTLBIS,
 	CGT_HCR_TTLB_TTLBOS,
 	CGT_HCR_TVM_TRVM,
+	CGT_HCR_TVM_TRVM_HCRX_TCR2En,
 	CGT_HCR_TPU_TICAB,
 	CGT_HCR_TPU_TOCU,
 	CGT_HCR_NV1_nNV2_ENSCXT,
@@ -345,6 +348,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= MDCR_EL2_TDCC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_HCRX_TCR2En] = {
+		.index		= HCRX_EL2,
+		.value 		= 0,
+		.mask		= HCRX_EL2_TCR2En,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 };
 
 #define MCB(id, ...)						\
@@ -359,6 +368,8 @@ static const enum cgt_group_id *coarse_control_combo[] = {
 	MCB(CGT_HCR_TTLB_TTLBIS,	CGT_HCR_TTLB, CGT_HCR_TTLBIS),
 	MCB(CGT_HCR_TTLB_TTLBOS,	CGT_HCR_TTLB, CGT_HCR_TTLBOS),
 	MCB(CGT_HCR_TVM_TRVM,		CGT_HCR_TVM, CGT_HCR_TRVM),
+	MCB(CGT_HCR_TVM_TRVM_HCRX_TCR2En,
+					CGT_HCR_TVM, CGT_HCR_TRVM, CGT_HCRX_TCR2En),
 	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
 	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
@@ -622,6 +633,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_MAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_AMAIR_EL1,		CGT_HCR_TVM_TRVM),
 	SR_TRAP(SYS_CONTEXTIDR_EL1,	CGT_HCR_TVM_TRVM),
+	SR_TRAP(SYS_TCR2_EL1,		CGT_HCR_TVM_TRVM_HCRX_TCR2En),
 	SR_TRAP(SYS_DC_ZVA,		CGT_HCR_TDZ),
 	SR_TRAP(SYS_DC_GVA,		CGT_HCR_TDZ),
 	SR_TRAP(SYS_DC_GZVA,		CGT_HCR_TDZ),
@@ -1071,6 +1083,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_TPIDRRO_EL0,		HFGxTR, TPIDRRO_EL0, 1),
 	SR_FGT(SYS_TPIDR_EL1,		HFGxTR, TPIDR_EL1, 1),
 	SR_FGT(SYS_TCR_EL1,		HFGxTR, TCR_EL1, 1),
+	SR_FGT(SYS_TCR2_EL1,		HFGxTR, TCR_EL1, 1),
 	SR_FGT(SYS_SCXTNUM_EL0,		HFGxTR, SCXTNUM_EL0, 1),
 	SR_FGT(SYS_SCXTNUM_EL1, 	HFGxTR, SCXTNUM_EL1, 1),
 	SR_FGT(SYS_SCTLR_EL1, 		HFGxTR, SCTLR_EL1, 1),
-- 
2.39.2


