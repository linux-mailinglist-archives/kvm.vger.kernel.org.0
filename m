Return-Path: <kvm+bounces-28328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB1AE997544
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE3B41C223B2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F621E4121;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7T4twSp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572B21E32D9;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500446; cv=none; b=fFpJ/oPUtl9gcgo3e4jhTa54wOuL1cqYSqfOgyAO8N/B7qs1e0ZThoOR1EIkacCT3qLyVCHRixbw/CVYt+fpchjJmkQoqQAOvH+MMH9GPHDLcySUzZZHXxBMSy6JMzyhKW+BHCYK2IBLDMhjy0fZCJn7+pUJSLr5yACK55natqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500446; c=relaxed/simple;
	bh=uJ4Rms5/TwwuLBnZE1CwoSIgCLvL2ISzaxDlkow7KA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r69n/xOVioW7OwJlMH/CgJ5GdjDoKrHLhQ2FFWv9KIVCf9Fk0VeGuDwuNM/pJt2EgPxKgJjCq5sN65s31BMvh5aNaNXLWu4zTMXuRRqIqH6tKh1L72jiQCYfHiMfxzVIW59x9HSY02YVikqNU2+ZHRgufnOA93kSS65a1ei21bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7T4twSp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D863FC4CECF;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500445;
	bh=uJ4Rms5/TwwuLBnZE1CwoSIgCLvL2ISzaxDlkow7KA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7T4twSpFiHhQvEOSyKR0/u+9gJ3fnkUX04jz5Sc2d4PNxfEFj+ZQ3GfCBH31WG07
	 AJVkmUqwM02dsSFKsSAN3I+erpUnqw4FhQd4YeReU+eZ+gDeeN7HczBkSlUEcI6hmJ
	 UD1n5x/Ifsbx0xm+gYAYGLINbfh1TuF/ZWERSOA8eTF9L3CyWGky76pdnMt8t0dBSK
	 Z/+YlwTJQWssWgSeQXM9EnO7doerZs4PeSt8Zf9Wr4tiCJj9msckgh5qO7PtskwRso
	 NuEQOYGHjEtCCjg55keeaM17WdAlwHxWMnvUFPQiVuV1GgQwkICBxBpZP71GzPIL88
	 +4u3Sc0xgYOwA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvP-001wcY-Tm;
	Wed, 09 Oct 2024 20:00:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 16/36] KVM: arm64: Handle PIR{,E0}_EL2 traps
Date: Wed,  9 Oct 2024 19:59:59 +0100
Message-Id: <20241009190019.3222687-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
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
index a85f62baebfba..c42f09a67a7c9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -369,6 +369,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
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
@@ -2873,6 +2885,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
+	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


