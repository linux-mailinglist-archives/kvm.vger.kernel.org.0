Return-Path: <kvm+bounces-23984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C68D9502B7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03B1E1F22807
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E49C19B3D7;
	Tue, 13 Aug 2024 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWG6gU2z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B77919AD56;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545851; cv=none; b=q7BbvenDL7CGMCkwYKXkRkzxt2/K2Po1t/gFROvO2cthB9VApNMU/X2hmVUXZ8ZBqBgs2GpDn4kWLiv4xa5DtlTWbqP8kFmA3lSX2QwYeWYKIq2bbVjcguWYfC3DCOIlJ1fFkcsW5YZiRVE0tFV2rII/6OIC/QX2Y+GCeaWRyw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545851; c=relaxed/simple;
	bh=Xu/A5wRo87cCV/14kvsmL7JZiq2gS7qhR9OHy9H2AHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fBEJg8iOys45z3Pg/yZWJwlcLK8CaJ88Iw6fgWtTKqHugFrJqN+WBEoNbQ3xZesFzESwJjWoYuTuiSZp7mgs+sUtYW2jvrxuLzQ6gmVdmxKaFGkCmPdTS9wHGRS2W1WYB7xA6NvJqG+De/FMLpzZw9v+Kp5IAPUPbw3Nlplftso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWG6gU2z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB21C4AF15;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545851;
	bh=Xu/A5wRo87cCV/14kvsmL7JZiq2gS7qhR9OHy9H2AHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWG6gU2zu+S/dmU9/enI3mJ6kre1VSoect6wCQCTt067yL/3m5rGPh0TPk1kd6Gs4
	 irvs3eoKYyjufG+LYdWO1SzEzVgWdf+ceZKeH5OMNo6bTqxYR8Z3999e2P4Mp+g2vT
	 L5W3z0FT/XP1c2QKmzd+Ng1AbJ9c3YcJalV+hT7bkMA9lEDnwkvzIPMbXXj/5P/eFP
	 LPqPeJyy0LZy9a+aljbANIMnNpRRtwU1606hAk4BfODSAOAbbZaM5/ulcdtzTRmroi
	 4wuPDzoZsx1D+Mj4Fo6tv7nUBLfdhswDMG7I42sUWSyIizi5xSHITywoYTc9kozsWa
	 y56NeyK5R6DCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0b-003JD1-GB;
	Tue, 13 Aug 2024 11:44:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace and guests
Date: Tue, 13 Aug 2024 11:44:00 +0100
Message-Id: <20240813104400.1956132-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Everything is now in place for a guest to "enjoy" FP8 support.
Expose ID_AA64PFR2_EL1 to both userspace and guests, with the
explicit restriction of only being able to clear FPMR.

All other features (MTE* at the time of writing) are hidden
and not writable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51627add0a72..da6d017f24a1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1722,6 +1722,15 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static u64 read_sanitised_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+					  const struct sys_reg_desc *rd)
+{
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
+
+	/* We only expose FPMR */
+	return val & ID_AA64PFR2_EL1_FPMR;
+}
+
 #define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
 ({									       \
 	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
@@ -2381,7 +2390,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_UNALLOCATED(4,2),
+	{ SYS_DESC(SYS_ID_AA64PFR2_EL1),
+	  .access	= access_id_reg,
+	  .get_user	= get_id_reg,
+	  .set_user	= set_id_reg,
+	  .reset	= read_sanitised_id_aa64pfr2_el1,
+	  .val		= ID_AA64PFR2_EL1_FPMR, },
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
-- 
2.39.2


