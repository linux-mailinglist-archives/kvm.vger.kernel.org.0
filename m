Return-Path: <kvm+bounces-44428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87113A9DA9D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D18A21BA74D5
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4B02528EB;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds9qg2MK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E825025179D;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670535; cv=none; b=kt7RJtYkFkn3HAISoXEVp7pCgTdpaVMi5i1Vnbfn7KW9fPQzei8+ujDXeLfgQtjWanw1l1ObB8rAZB+yYW6LW8ZC/iprZGXB0bSKENAmhvQbfmevRymAdSAvYgiIp5kTaluPII/qc54aHf30eccmbDPE0unsvRo9N6Y8yBRxM5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670535; c=relaxed/simple;
	bh=vjXbDrwewvSPOtQWRUXGG3NnR/e5HfNw/ic9Gwvm87Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HD3/NS4FX72R9jFnOp2HbN1ne7rVJvfbvzbI3PtCeAQmElygXP+LBFd3Aag4q+7xiYCn/k0w03C6BMn1COiOi4yyTMTOMi1PdyalKrPTBItEayOSna1dRhthl8gMKk4ZWUFijDICJIEqq20a9YjlPoiW3Jlfl00IHS8ueGAGPzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds9qg2MK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A01C4CEEB;
	Sat, 26 Apr 2025 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670534;
	bh=vjXbDrwewvSPOtQWRUXGG3NnR/e5HfNw/ic9Gwvm87Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ds9qg2MK2v+YonRamaBxkYB9M5FwNcttcSk6jDiWTRHqPEL8ZWWZrTeO+cxAT+Pz6
	 9dWIam4AtpAU41OTGrnUKlf032zwvQBNMTiebfM7y9NqR9PZyr0KmGFys7O+aZdp7d
	 r09fSY4llzRxA9KnuCSdB00xj/RAk1VbP+UvsLbiQbD5rJz5s2I9ReVbnRqcA1LgNQ
	 i6oIemZirFH4uBhUlpliuOIzGQ08UgqlDHWuWtYK1LM8i4QqqioJSBsVbzy/NgKF0+
	 bD5isQFN5dP+uocGNjNyYPDMgG3cmceikZkbJPN/8WBi2U/KfoCY7JH+hgWQ5EJ5z0
	 JxES0W3BJ0gjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeK-0092VH-T8;
	Sat, 26 Apr 2025 13:28:53 +0100
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
Subject: [PATCH v3 16/42] KVM: arm64: Simplify handling of negative FGT bits
Date: Sat, 26 Apr 2025 13:28:10 +0100
Message-Id: <20250426122836.3341523-17-maz@kernel.org>
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

check_fgt_bit() and triage_sysreg_trap() implement the same thing
twice for no good reason. We have to lookup the FGT register twice,
as we don't communucate it. Similarly, we extract the register value
at the wrong spot.

Reorganise the code in a more logical way so that things are done
at the correct location, removing a lot of duplication.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 49 ++++++++-------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1bcbddc88a9b7..52a2d63a667c9 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2215,11 +2215,11 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 	return masks->mask[sr - __VNCR_START__].res0;
 }
 
-static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
-			  u64 val, const union trap_config tc)
+static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
+			  const union trap_config tc)
 {
 	struct kvm *kvm = vcpu->kvm;
-	enum vcpu_sysreg sr;
+	u64 val;
 
 	/*
 	 * KVM doesn't know about any FGTs that apply to the host, and hopefully
@@ -2228,6 +2228,8 @@ static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
 	if (is_hyp_ctxt(vcpu))
 		return false;
 
+	val = __vcpu_sys_reg(vcpu, sr);
+
 	if (tc.pol)
 		return (val & BIT(tc.bit));
 
@@ -2242,38 +2244,17 @@ static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
 	if (val & BIT(tc.bit))
 		return false;
 
-	switch ((enum fgt_group_id)tc.fgt) {
-	case HFGRTR_GROUP:
-		sr = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
-		break;
-
-	case HDFGRTR_GROUP:
-		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
-		break;
-
-	case HAFGRTR_GROUP:
-		sr = HAFGRTR_EL2;
-		break;
-
-	case HFGITR_GROUP:
-		sr = HFGITR_EL2;
-		break;
-
-	default:
-		WARN_ONCE(1, "Unhandled FGT group");
-		return false;
-	}
-
 	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
 }
 
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 {
+	enum vcpu_sysreg fgtreg;
 	union trap_config tc;
 	enum trap_behaviour b;
 	bool is_read;
 	u32 sysreg;
-	u64 esr, val;
+	u64 esr;
 
 	esr = kvm_vcpu_get_esr(vcpu);
 	sysreg = esr_sys64_to_sysreg(esr);
@@ -2320,25 +2301,19 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		break;
 
 	case HFGRTR_GROUP:
-		if (is_read)
-			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
-		else
-			val = __vcpu_sys_reg(vcpu, HFGWTR_EL2);
+		fgtreg = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
 		break;
 
 	case HDFGRTR_GROUP:
-		if (is_read)
-			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
-		else
-			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
+		fgtreg = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
 		break;
 
 	case HAFGRTR_GROUP:
-		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
+		fgtreg = HAFGRTR_EL2;
 		break;
 
 	case HFGITR_GROUP:
-		val = __vcpu_sys_reg(vcpu, HFGITR_EL2);
+		fgtreg = HFGITR_EL2;
 		switch (tc.fgf) {
 			u64 tmp;
 
@@ -2359,7 +2334,7 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		goto local;
 	}
 
-	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu, is_read, val, tc))
+	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu, fgtreg, tc))
 		goto inject;
 
 	b = compute_trap_behaviour(vcpu, tc);
-- 
2.39.2


