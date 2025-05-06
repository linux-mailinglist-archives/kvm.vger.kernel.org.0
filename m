Return-Path: <kvm+bounces-45655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 574C3AACB6B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08C097B6209
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D81E3289369;
	Tue,  6 May 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N06qUZo6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082E2288CAF;
	Tue,  6 May 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549858; cv=none; b=cFF7ZP3DrPleo2JkJT8JE7EvTuJug/Gd5jepah91tnNDwBq9/DIn086yWFiD/ctsWahqiVZ1FCynaeA8BnvIAQsJ4pMGVPXOC4PsWaJ2IMEHcCxphlDMh3G6aiaHVylfSfUwZz8KFC6uAhkxS42xUgsnkBoIniKUdgq7pm3m8zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549858; c=relaxed/simple;
	bh=1J0UUEGjyLshTxeVES279sPs7UWzaCpoTsW5ih0zPlo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JHu3zuMrYU19vnvzRRLsjUymWzUezlk/NpkV51RlDqjjLDBnRxLckKmgHteelV3V0MtLOi5HTJfH5vdWI1yQpX1GfMeCQ7zFySdHfuBJYIpLM2mRDLN9ktiibhvcN5VmpJwvhCsJHCP+sIwCkGWXbuuz5Zcea6gNWnJIiWFSzmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N06qUZo6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38CC4CEF2;
	Tue,  6 May 2025 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549857;
	bh=1J0UUEGjyLshTxeVES279sPs7UWzaCpoTsW5ih0zPlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N06qUZo6OOdwobnvepVtb8fp8DAF3zS0KBQwKhZ+zOULppoKqUQqFxNnbCSrnuita
	 0oK4WL06fgu5OTPjP2ayz28fJDi3doskXwaTeUoWsav8uGbtVWni7MLVTdQn2yYY3V
	 933o/DOP1BAgzf7i1uro3zKQ+pOsT+xgKYxICbNyTCkZyP2aEHOVbQEmohL+EmgAXF
	 CIGRm+sZtlb/flGA76Cknm1NJyJYEfZ2X+ZcU3pHnfQrtJ9Bd4HDhIftc4B50UKRxt
	 Yn+hU2WEjmJEnyRvL6ncBC96XhfowYtCOezua64MsGcZY2zPPDBThgUdzjv2kYf3/C
	 jcqgmh19VvWsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOy-00CJkN-5T;
	Tue, 06 May 2025 17:44:16 +0100
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
Subject: [PATCH v4 43/43] KVM: arm64: Handle TSB CSYNC traps
Date: Tue,  6 May 2025 17:43:48 +0100
Message-Id: <20250506164348.346001-44-maz@kernel.org>
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

The architecture introduces a trap for TSB CSYNC that fits in
the same EC as LS64 and PSB CSYNC. Let's deal with it in a similar
way.

It's not that we expect this to be useful any time soon anyway.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h    | 3 ++-
 arch/arm64/kvm/emulate-nested.c | 1 +
 arch/arm64/kvm/handle_exit.c    | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index ef5a14276ce15..6079e23608a23 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -182,10 +182,11 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
-/* ISS definitions for LD64B/ST64B/PSBCSYNC instructions */
+/* ISS definitions for LD64B/ST64B/{T,P}SBCSYNC instructions */
 #define ESR_ELx_ISS_OTHER_ST64BV	(0)
 #define ESR_ELx_ISS_OTHER_ST64BV0	(1)
 #define ESR_ELx_ISS_OTHER_LDST64B	(2)
+#define ESR_ELx_ISS_OTHER_TSBCSYNC	(3)
 #define ESR_ELx_ISS_OTHER_PSBCSYNC	(4)
 
 #define DISR_EL1_IDS		(UL(1) << 24)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 9b5a875ad2222..923c1edb7463d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2044,6 +2044,7 @@ static const union trap_config non_0x18_fgt[] __initconst = {
 	FGT(HFGITR, SVC_EL1, 1),
 	FGT(HFGITR, SVC_EL0, 1),
 	FGT(HFGITR, ERET, 1),
+	FGT(HFGITR2, TSBCSYNC, 1),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cc44ee56e512b..60507ad8b86f8 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -347,6 +347,11 @@ static int handle_other(struct kvm_vcpu *vcpu)
 		if (is_l2)
 			fwd = !(hcrx & HCRX_EL2_EnALS);
 		break;
+	case ESR_ELx_ISS_OTHER_TSBCSYNC:
+		allowed = kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, TRBE_V1P1);
+		if (is_l2)
+			fwd = (__vcpu_sys_reg(vcpu, HFGITR2_EL2) & HFGITR2_EL2_TSBCSYNC);
+		break;
 	case ESR_ELx_ISS_OTHER_PSBCSYNC:
 		allowed = kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P5);
 		if (is_l2)
-- 
2.39.2


