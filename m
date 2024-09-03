Return-Path: <kvm+bounces-25765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E74F96A300
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D92928426F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626BC18DF7B;
	Tue,  3 Sep 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPuvPB8Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8208518BC08;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377923; cv=none; b=It/YzixtpQ4KcTpBIR1cZ3F0wewVHrgymSx0g92MvBGk/YueaLDtGcrQRq/oK8h67R/y7O02ekfOSF1DYFwLangJwfIO6Xfz5y4fDfKE/bK3SiQJxwvU/zJCTXjlsYvHDqsgzAavhyQDjykkb2+85AslOLYJllAppr8drVNOXJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377923; c=relaxed/simple;
	bh=cvsJSaOQztrKorbF8dvn6frRB/FAYHOzlhuxLFMGYKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vEFj0GuyTfw/jQ36fb/DOxTcJA6V86KUJwGBzWCjfDdei3zB6p0Ax/KOYpZII7VBrZIuV99WQKT0Swd+CM+uYfjlCoOoSwBLHYFpysccXym6pr0sp9iVgtrC4NBaJtWzQC6D5m/7MYT+4Y/PjM1ZGdiszyKMxdmpWh9RoibMTrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPuvPB8Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10570C4CECB;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377923;
	bh=cvsJSaOQztrKorbF8dvn6frRB/FAYHOzlhuxLFMGYKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPuvPB8ZEwozeSUgzkYOTQkFH1acCcLHgqDHow21a+CdFXOEWfJrsTgGJxLmrKBsE
	 Jce/WaJArumL7XEO5O/1nlNBdiiTSnl7E3HYGvd+rBixZeBfc7E6UP+cc5VsL79xYt
	 z760+nNqCA3hzc1NPreiibeuj1M62wVqPTC/U30QcJzirdiGPY7hjrfp4FNGMJ3rN+
	 5c4BnZVgvYOIpbDxyyPVuTVrIHaTtPsbCfRobE8uJZ+ZipgkckYE5pV8YgMV1OaVOM
	 Kk87tWJ+erIaxUGGiZB/KomurQwnLYgroOo711kgY/FJvKvB5eb+f7JLln859JdN1q
	 uHkPpGA8TygiQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc9-009Hr9-A1;
	Tue, 03 Sep 2024 16:38:41 +0100
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
Subject: [PATCH v2 13/16] KVM: arm64: Define helper for EL2 registers with custom visibility
Date: Tue,  3 Sep 2024 16:38:31 +0100
Message-Id: <20240903153834.1909472-14-maz@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

In preparation for adding more visibility filtering for EL2 registers add
a helper macro like EL2_REG() which allows specification of a custom
visibility operation.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-1-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7f4f69351e89..4ee74e2d4f08 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2136,6 +2136,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
+	SYS_DESC(SYS_##name),			\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name,				\
+	.visibility = filter,			\
+	.val = v,				\
+}
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2803,8 +2812,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
-	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
-	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+	EL2_REG_FILTERED(ZCR_EL2, access_zcr_el2, reset_val, 0,
+			 sve_el2_visibility),
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
-- 
2.39.2


