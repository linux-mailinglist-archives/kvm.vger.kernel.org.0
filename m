Return-Path: <kvm+bounces-37500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27437A2AD00
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FFB53A9512
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5189A2500D0;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmLFNkj7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483CB246323;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856983; cv=none; b=HJcx6IWA483Om33LCE0zGWGZvfYDDm9Ih4YJJGI0sqhXWCD6GaozXnRCTyoY+kZL9E3BoioxYxyPmeT2nVbBNOdOSJsQWPW+nisoODwu76ajozIos101+54v+CUp20GJeUszUtYhmxXVMfiEGZA5Kl/ukEsjBV8UflMrWtWgFXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856983; c=relaxed/simple;
	bh=759YsdfsJcw2cqGhCi/rdhEHxXsqXffMe/i/ke2uCwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bVLYtUEETnm7xPmjVr6mbE3ji1y5fVdIH2G3VdG3q7E+6lcuEOEGs//3CeAIkVV9fcl5cnaNeuAIMkEZSCDIGyEsJh9tFc7ZIs9IhBD1QEqzKoNGWUInJiNQIAtydDXJ3sgfZiONfijPFaIN1weMt5z2IVInkfOJk41oKBBcGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmLFNkj7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D8CC4CEDD;
	Thu,  6 Feb 2025 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856982;
	bh=759YsdfsJcw2cqGhCi/rdhEHxXsqXffMe/i/ke2uCwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmLFNkj7fmXAC/csfSbZSe4RW8YBzr1jJ8ZkcAvvGI3fYCUKJJahYH+LQmsYYlrIT
	 qcBEUSgxJzS+e52s587dRZjsDi3PHb6dRShR1KKsMtPQp1Cf8nIXGnE1pn6u2WuQ/b
	 Lzlxm88jzaJxMmH1y5YmOcES5O5KnpMzniI4v/1muqDghZdkB6HG84XXMY14H8/p8R
	 74zVUMu3bvmbWpXM0WDbZmOMJco0YpK6A2babAC64KKltIlnZ4x8rP9XoEaoSvt5EA
	 ZwabSBD9oFdLPwUDHIEGrKqxAsCgs139FgednhbgYo4QdmBvtx2rbxwidsZGnltgNS
	 Jp0PXUIW2HYqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48K-001BOX-L9;
	Thu, 06 Feb 2025 15:49:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 07/16] KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
Date: Thu,  6 Feb 2025 15:49:16 +0000
Message-Id: <20250206154925.1109065-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As ICH_HCR_EL2 is a VNCR accessor when runnintg NV, add some
sanitising to what gets written. Crucially, mark TDIR as RES0
if the HW doesn't support it (unlikely, but hey...), as well
as anything GICv4 related, since we only expose a GICv3 to the
uest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 33d2ace686658..1cb113ee1e17a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1289,6 +1289,15 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= GENMASK(11, 8);
 	set_sysreg_masks(kvm, CNTHCTL_EL2, res0, res1);
 
+	/* ICH_HCR_EL2 */
+	res0 = ICH_HCR_EL2_RES0;
+	res1 = ICH_HCR_EL2_RES1;
+	if (!(kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_TDS))
+		res0 |= ICH_HCR_EL2_TDIR;
+	/* No GICv4 is presented to the guest */
+	res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
+	set_sysreg_masks(kvm, ICH_HCR_EL2, res0, res1);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		(void)__vcpu_sys_reg(vcpu, sr);
-- 
2.39.2


