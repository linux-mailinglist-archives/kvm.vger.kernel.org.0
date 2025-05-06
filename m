Return-Path: <kvm+bounces-45642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F505AACB61
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5421520EE3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB1B3288519;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ot+HIsGC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00512882C1;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549855; cv=none; b=aEvCNcC3gVXQRDsKo7fWBL2uz0lM1g4SoW2/75P7kXWWUsm/KqFAH0lApffJhcdZFJlNoc8ZnxnvBS0iOCaWhYn8AOqqNXrJdy5MDMp1Kvv1a4Sf+R9tupIGl++DZYssxUHPRDr5DhoCBxSWB72Qch+AytrSCmQzkZ1ufwsj3P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549855; c=relaxed/simple;
	bh=qSCGnd7gUFEfMtIaMS0kY7EpuHV9TIOvcF3r3MaR5m0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FPkTSOU1UTj6/ETF+pKOqT/ezxJhTf/JloN0uuIpnbwoIM2VTpvu+CRbTZrjCEnLchRP4QDZZx7tfenkAnc3vGq445kJDdDtVzwV2kDK7lFSJzS4Szg780yApJmZW6XPdlEhTHWQQXPG25RdK5jD7xMSCrxUlPIwR420W42YU3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ot+HIsGC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE796C4CEF0;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549854;
	bh=qSCGnd7gUFEfMtIaMS0kY7EpuHV9TIOvcF3r3MaR5m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ot+HIsGC1DGLOw8jr3040esT6Vr8cjCQRzqWQSC5zfLxSWTtvSfuSQhh57WqnYRe6
	 jlr1EXp8Jx7PxehPXJ3QOrLDmgp3Om/8Abwg6M30eCYOCJyN4O8bQ/5RodoXB0Fu89
	 KhRX4QXkptPoOmMzUwHxDVGcYd3nye4xDP0ZXbVC1Mxi5PufOOvb3MRExQZxpUO4cZ
	 YYt7eW3pf2Hu5mE21Bt0RNmq6iwf0G5QmbqaDrEx4JXuBlST4+HHA9zTQ7hlqQm1pT
	 Ra/Q6mRy0psVIzb3eS2vxniMo4e8K9Kt0jULAovW9jKrQ7sgyoPtSzCnFX7lxbDwZX
	 cPvxKcMs/77gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOv-00CJkN-1D;
	Tue, 06 May 2025 17:44:13 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 30/43] KVM: arm64: Handle PSB CSYNC traps
Date: Tue,  6 May 2025 17:43:35 +0100
Message-Id: <20250506164348.346001-31-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The architecture introduces a trap for PSB CSYNC that fits in
 the same EC as LS64. Let's deal with it in a similar way as
LS64.

It's not that we expect this to be useful any time soon anyway.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h    | 3 ++-
 arch/arm64/kvm/emulate-nested.c | 1 +
 arch/arm64/kvm/handle_exit.c    | 5 +++++
 arch/arm64/tools/sysreg         | 2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index a0ae66dd65da9..ef5a14276ce15 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -182,10 +182,11 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
-/* ISS definitions for LD64B/ST64B instructions */
+/* ISS definitions for LD64B/ST64B/PSBCSYNC instructions */
 #define ESR_ELx_ISS_OTHER_ST64BV	(0)
 #define ESR_ELx_ISS_OTHER_ST64BV0	(1)
 #define ESR_ELx_ISS_OTHER_LDST64B	(2)
+#define ESR_ELx_ISS_OTHER_PSBCSYNC	(4)
 
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c581cf29bc59e..0b033d3a3d7a4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2000,6 +2000,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
  * trap is handled somewhere else.
  */
 static const union trap_config non_0x18_fgt[] __initconst = {
+	FGT(HFGITR, PSBCSYNC, 1),
 	FGT(HFGITR, nGCSSTR_EL1, 0),
 	FGT(HFGITR, SVC_EL1, 1),
 	FGT(HFGITR, SVC_EL0, 1),
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cc5c2eeebab32..cc44ee56e512b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -347,6 +347,11 @@ static int handle_other(struct kvm_vcpu *vcpu)
 		if (is_l2)
 			fwd = !(hcrx & HCRX_EL2_EnALS);
 		break;
+	case ESR_ELx_ISS_OTHER_PSBCSYNC:
+		allowed = kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P5);
+		if (is_l2)
+			fwd = (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_PSBCSYNC);
+		break;
 	default:
 		/* Clearly, we're missing something. */
 		WARN_ON_ONCE(1);
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 44bc4defebf56..b69b30dcacf32 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3406,7 +3406,7 @@ Field	0	AFSR0_EL1
 EndSysreg
 
 Sysreg HFGITR_EL2	3	4	1	1	6
-Res0	63
+Field   63	PSBCSYNC
 Field	62	ATS1E1A
 Res0	61
 Field	60	COSPRCTX
-- 
2.39.2


