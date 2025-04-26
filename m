Return-Path: <kvm+bounces-44441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16161A9DAAA
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1735D7B7CA8
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFEA7254844;
	Sat, 26 Apr 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9NVdo/p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9945253B77;
	Sat, 26 Apr 2025 12:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670538; cv=none; b=oUPs+4YG5wOtDm3jFSxskDYUdHRbYH5wxpbn1e+to+ChGKCzQSAfZgVJsIWamd7RT3momqzjft7qwWqbE80v0detI4v42IdtDZKrAB7mZQzhZASq3vJhQ1iJ4wqHUQ8yiIN1453j9AnSbN12cgRooWsUzSpm5kbsL9oCoazu2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670538; c=relaxed/simple;
	bh=/3dQSChHd0Vniu9W4Vkjo4IWPzgko9NV9tkThD6gliQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZtpXIAqYpGJrfiYpzJFiZQWJCHvla8Le0UtZJwo/eodieUdAvgfCab1eZL+DXTVK9e8SVZfi+XBZ9eObndb52EBvnZ/AHzmU+wPBJBpNAY/kWJ5FE/xuHmWXhybP5sErA70/unYOzhgRekp7gv8agXcC+HsY4Vtj9vvep1ORIH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9NVdo/p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B679FC4CEEB;
	Sat, 26 Apr 2025 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670538;
	bh=/3dQSChHd0Vniu9W4Vkjo4IWPzgko9NV9tkThD6gliQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9NVdo/pivGdZxvsh0RYzB+YBpcnZWwkcWk0upNiaWOjTx8Sp7syar7YHhl9c/9mZ
	 gtjHlx8/L+zRp9Ob9/5G3oLMrPjQgm0XJoEQdPSXBucTEbnChFvUGV3vAtgZHxprdL
	 neoIh5IwJZQor2Hy/Q9v+a9M9HycOJx+dqVO+9O3s8elqcj0Khgys5Y19nsl5bfkLz
	 +19N/3UOge/OP3fiWUNF6V3T+1BH1+lTMi0QEn+6hYabwE1dpDatNR18oOjK5QnSht
	 Wszkl5zDlJ77i2J2AzqAgQ53fo5XWJyh6h1gs9jIPGaffJWOviWxxd3Dl9jAaH1kIU
	 9CTq3ZyyV1nOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeO-0092VH-Sb;
	Sat, 26 Apr 2025 13:28:56 +0100
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
Subject: [PATCH v3 29/42] KVM: arm64: Handle PSB CSYNC traps
Date: Sat, 26 Apr 2025 13:28:23 +0100
Message-Id: <20250426122836.3341523-30-maz@kernel.org>
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
index eafbd2a243afd..2c07754c11a45 100644
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
index 5695b12b8b4b2..f1fdd31409df4 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3404,7 +3404,7 @@ Field	0	AFSR0_EL1
 EndSysreg
 
 Sysreg HFGITR_EL2	3	4	1	1	6
-Res0	63
+Field   63	PSBCSYNC
 Field	62	ATS1E1A
 Res0	61
 Field	60	COSPRCTX
-- 
2.39.2


