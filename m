Return-Path: <kvm+bounces-40635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B15A59446
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7489416983F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F562227B9E;
	Mon, 10 Mar 2025 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMCocTBn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F91422A80A;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609516; cv=none; b=CwRzNBudtThlvDE5EYZBWIJ6v+XncWEpng0w2Rwu3AmeXlEAVmc8w9QdppaFxy/T5AvXkkctWZ1YJVWZkSZ2c05k1BVINO9MkbybRfxeZEC+jiHyaY4sdkMac/+YQQQy26bluVB9KBcLVmAFUmnXZFWx88zSDkoVE/Q5+1NTJNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609516; c=relaxed/simple;
	bh=n7xGkSaTu/32WDYmEBTHnzauO9ZcCrn2FDAI3A+1sSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pivNIZWR52ItiI7/XkxXVovlZnf43XSYNyOxLyfqCcXTOnguCSJJNczSidtsd2A8qjnjlCqac5Vr+XBZjhBJFtmVQhEyR6fi5aHoS/VHtV+w642DU//eK4TAqzs+S5IYP67MErXX7mP3AB1OuhgWh1WMXzaEGnd1bLCRla0RJLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMCocTBn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531BDC4CEEE;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609516;
	bh=n7xGkSaTu/32WDYmEBTHnzauO9ZcCrn2FDAI3A+1sSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMCocTBnnNtZ9tFCC8ODA7zW7ZlSBQWIn5Ybai5fWG1aBAezAMondCwImZkBKjQGu
	 BeImm7GCqhuJz4UsxPRxWGRKV3DVrYNnJvtFUjwRNgpVdNTDu6paHdlAE/omHqaHnr
	 wIFOCVcbp3syx6x/OA+Vb4quISaPSE2IAe7RNyIHqK396H4WKBpoKIVaX/bXLXgSIy
	 DUDZ4FNu0BvbdjMnA3apGH5bI5zKzgA34A51zDqxAjDah36EEJ3DSUvYd3RuOX1ZHR
	 xEHVwrlpU4uIiKIENokBVXwgMDNsYyT0oOs/+VBqHj9XnlPm7ryT/nqI+oGbccMwvs
	 3kiv5yI6ogEPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC2-00CAea-Fx;
	Mon, 10 Mar 2025 12:25:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 17/23] KVM: arm64: Handle PSB CSYNC traps
Date: Mon, 10 Mar 2025 12:24:59 +0000
Message-Id: <20250310122505.2857610-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
index 547b4e857a3e2..f340af79679d8 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -175,10 +175,11 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
 
-/* ISS definitions for LD64B/ST64B instructions */
+/* ISS definitions for LD64B/ST64B/PSBCSYNC instructions */
 #define ESR_ELx_ISS_OTHER_ST64BV	(0)
 #define ESR_ELx_ISS_OTHER_ST64BV0	(1)
 #define ESR_ELx_ISS_OTHER_LDST64B	(2)
+#define ESR_ELx_ISS_OTHER_PSBCSYNC	(3)
 
 #define DISR_EL1_IDS		(UL(1) << 24)
 /*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f6c7331c21ca4..ebfb2805f716b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1996,6 +1996,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 
 /* Additional FGTs that do not fire with ESR_EL2.EC==0x18 */
 static const union trap_config non_0x18_fgt[] __initconst = {
+	FGT(HFGITR, PSBCSYNC, 1),
 	FGT(HFGITR, nGCSSTR_EL1, 0),
 	FGT(HFGITR, SVC_EL1, 1),
 	FGT(HFGITR, SVC_EL0, 1),
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index bf08c44491b4a..0491eecd521b0 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -343,6 +343,11 @@ static int handle_other(struct kvm_vcpu *vcpu)
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
index 1cf9a07cce522..f680cd6b3bc75 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2641,7 +2641,7 @@ Fields	HFGxTR_EL2
 EndSysreg
 
 Sysreg HFGITR_EL2	3	4	1	1	6
-Res0	63
+Field   63	PSBCSYNC
 Field	62	ATS1E1A
 Res0	61
 Field	60	COSPRCTX
-- 
2.39.2


