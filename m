Return-Path: <kvm+bounces-54128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 86928B1CA28
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 856C54E3337
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FF229DB80;
	Wed,  6 Aug 2025 16:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9V9Einp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4172229B799;
	Wed,  6 Aug 2025 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499393; cv=none; b=NmWyZv3EOVDcbmc7TtgloDKi67S23/d3Pj6QgV3USBKKG/DDdfkE7BqhGMES13r+KaicgxyOnjrrWc2op3R/2PxNSDc35zujLwg6kzBBrRtjU5lluPigLhE/nSmDCKFk97whHnjAmQbeZeXAckqOtTIK/0RPiUEobhTkVjJ47O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499393; c=relaxed/simple;
	bh=zAGAbsELpollOdT/eTW6SPvyl/e20p98489YUkFL0Rg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jhrx2xhH8ripqKKCoBcEdr8hltPJ71PthhM5McywRuN6RjGUzsVcbxg3Q+s53OFvOTsEU5Qnp0lG43A4Pwp9jALwusT69NXsLWdzA22pXannqG2DsYdnDkHuWLqysR8UOWrmit0VpQXUuvJWXUWWlr8b87Wjh06R6GfPVZyFWak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9V9Einp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0770C4CEE7;
	Wed,  6 Aug 2025 16:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754499392;
	bh=zAGAbsELpollOdT/eTW6SPvyl/e20p98489YUkFL0Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9V9EinprHiKzCbTb5mFCy5cqHsyiK9BXScCXegKPXYR0tkMsC3eiwHGo4pKCR9JZ
	 2KkYsh8avrTzkE8+1GlbQefmuif6J+j3GIiibP1Av9BE45DJJ+fhPxWq+D+djSqnK2
	 eicOadzeXamTMgkbyKAjxpXE1Hf46jBV2u1gQ8X5Uc4AG49NlDMzQ5oMh4Obj/J8OB
	 EJSuSbeeBwkdfG6PbdXR+TEIYSMi7ecxIhPOYVZ99PcVd0oUt5trigPa/5oD19TRkG
	 Fp2CNgQ6AvjZ3RrA3VhIkZZncCIXyGoArsHc3bs++s1Upgcmkrq9FmZhxL1/RSkVUI
	 Q0ErQ0CvINNSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ujhRE-004ZQV-3S;
	Wed, 06 Aug 2025 17:56:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 2/5] KVM: arm64: Handle RASv1p1 registers
Date: Wed,  6 Aug 2025 17:56:12 +0100
Message-Id: <20250806165615.1513164-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806165615.1513164-1-maz@kernel.org>
References: <20250806165615.1513164-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_RASv1p1 system registeres are not handled at all so far.
KVM will give an embarassed warning on the console and inject
an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.

Handle these registers similarly to FEAT_RAS, with the added fun
that there are *two* way to indicate the presence of FEAT_RASv1p1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad25484772574..1b4114790024e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2695,6 +2695,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
 	struct kvm *kvm = vcpu->kvm;
 
 	switch(reg_to_encoding(r)) {
+	case SYS_ERXPFGCDN_EL1:
+	case SYS_ERXPFGCTL_EL1:
+	case SYS_ERXPFGF_EL1:
+	case SYS_ERXMISC2_EL1:
+	case SYS_ERXMISC3_EL1:
+		if (!(kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
+		      (kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
+		       kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)))) {
+			kvm_inject_undefined(vcpu);
+			return false;
+		}
+		break;
 	default:
 		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 			kvm_inject_undefined(vcpu);
@@ -3058,8 +3070,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC2_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC3_EL1), access_ras },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.39.2


