Return-Path: <kvm+bounces-25756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C117B96A2F6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35D81C238C8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8735C18BC0C;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDPvAKSo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3AF189BB8;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377922; cv=none; b=GSHur7DkSJhGfJ6hi71AvxMH4wp0ZO8UJNIcenAUp0h0cZ85FqLkt4H/sfUbgxx4rl46ZqgcdoArHEen+FDgTdFB1OF6F7CaRlxrfvppLEthZks4lC8sQq6q+zJiv9TV52EKU/Md5rNmAyGLvB/BIvnOInG+liNXGgyYcxEerSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377922; c=relaxed/simple;
	bh=tDRpVJnKSGbTp94sIqdZHe3gw4UqLUNpMQRM+CvB4Uk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iwWn+edLvLr4hTxAPN/IVs7ABApWyK0rcz50abPmrROxh5h2KAAtUICFzoU4kJLL/uIct2bc3FVSIBAQH0wk5jyu2KwHX/1KwUH9AWgOcIhF+dBeLAsQSHDIX7B0TeNBHzrnko0iwJjfjE0wwuAgPobWJAuZ1Ys3qR4eJaXopNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDPvAKSo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6EFC4CECB;
	Tue,  3 Sep 2024 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377922;
	bh=tDRpVJnKSGbTp94sIqdZHe3gw4UqLUNpMQRM+CvB4Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDPvAKSoXM3Bvtyd2H6sJNSxD1IfhjRR84ng6deBf2QIR4wTUmyLjmtpUhkaOq6bp
	 YD0BaycWYrv9n51LVM0eyrDQwG+skGpKpHjm6Pv0PlG804c8ru56lin3mZejhds8Sl
	 3uv1qPzbiOA6jho6hsIeUdx7UiaaCMqNDd/AaLJvjQ3BqoKgqjLayIEobeSH4Ol0mt
	 iqw+r9UmS31OG48YsgNkPbJQlyx6+5r+OssU4WUj9dQdvCaPajuEzub7wHJ+kDnGa9
	 Nswj1bWz6ZTk4WiNtjIuo8GFywPtvJePFriXiKZH1/dIcmlED9OO8nQRB4X6EU1Yyc
	 bqDbEuf9dH7LQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc8-009Hr9-Fb;
	Tue, 03 Sep 2024 16:38:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 09/16] KVM: arm64: Handle  PIR{,E0}_EL2 traps
Date: Tue,  3 Sep 2024 16:38:27 +0100
Message-Id: <20240903153834.1909472-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the FEAT_S1PIE EL2 registers the sysreg descriptor array so that
they can be handled as a trap.

Access to these registers is conditional based on ID_AA64MMFR3_EL1.S1PIE
being advertised.

Similarly to other other changes, PIRE0_EL2 is guaranteed to trap
thanks to the D22677 update to the architecture.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0510e96f732a..a6bc20c238bf 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -346,6 +346,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
+				  struct sys_reg_params *p,
+				  const struct sys_reg_desc *r)
+{
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	return access_rw(vcpu, p, r);
+}
+
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -2827,6 +2839,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
+	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


