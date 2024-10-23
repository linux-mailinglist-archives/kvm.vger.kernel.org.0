Return-Path: <kvm+bounces-29540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 526409ACDEF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06F911F2288C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C18205AD7;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rRjMENCZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E969201273;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695235; cv=none; b=HpV9QtX+dHanVmDf/4xYsOR6aZlwlFQLb1t0zCmSmCFLwmQPfGn0u3YMk2q3mEdkn+tmCeJnHa7VEPAo1xhr+jHUoYGw6Vsna7RHvC6odb4Kfbtv53AxH3CljkwTUnvt/4ZHFRLTUJeWIVr2KdTOUYp9DWq/Os43d3Oar/r6ycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695235; c=relaxed/simple;
	bh=d6p7T4WRkNApCV6Q360fXnI8f7C1hPplv3nhiDj/5AI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lUmsLZy4/vEJPZ4FZGQ2uDcoBpODxoAUvCFPVMIrb7CQeGKT8PYzDNcRYNEv56sih+7qy/XIujpKNHNBSPhmK+FjlzFFLwvYBNWQYHImNrshLP/eXIHo+PwQODbxnw3jZojivyEfF2w4qMPq/hmZGwU9RBIA26ctl+bo2L7EsO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rRjMENCZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF4EC4CEE9;
	Wed, 23 Oct 2024 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695235;
	bh=d6p7T4WRkNApCV6Q360fXnI8f7C1hPplv3nhiDj/5AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRjMENCZMZl1iKtZdlIvWAPMttmi3cCJxO97XwB3P/TiQeNJcIN3dEuJoG9fxlzLx
	 UiagKS++RJgQa9IcIMefmpBp6nQuNB7K8f1aIHGcEDLo6sxIz6a/a25cn/bdLxsRZl
	 88oSsLneNsyZYuM+LXDrTlKO8sELRm4r/DZ5h1yXEZC19eQTsSkz+mgEZXmB1NMw4D
	 7zXW2UtTHVuFghNthxsP5e5dqrozYfeBZU3bABW2Ar+ybuBczlV8D7v1NP5FgOdOac
	 BIFPNZol7jUgbIWC7n9MYwjOtiPDwjRjPYC8o9xwkIif6qZ3kFZaBe+q7N3UKJJDLk
	 5DoKBEJau15Yw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckC-0068vz-5D;
	Wed, 23 Oct 2024 15:53:52 +0100
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
Subject: [PATCH v5 13/37] KVM: arm64: Add save/restore for TCR2_EL2
Date: Wed, 23 Oct 2024 15:53:21 +0100
Message-Id: <20241023145345.1613824-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
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

Like its EL1 equivalent, TCR2_EL2 gets context-switched.
This is made conditional on FEAT_TCRX being adversised.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 922aac39b021b..cdbf52bfc4833 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -51,6 +51,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		__vcpu_sys_reg(vcpu, TTBR1_EL2)	= read_sysreg_el1(SYS_TTBR1);
 		__vcpu_sys_reg(vcpu, TCR_EL2)	= read_sysreg_el1(SYS_TCR);
 
+		if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+			__vcpu_sys_reg(vcpu, TCR2_EL2) = read_sysreg_el1(SYS_TCR2);
+
 		/*
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
@@ -107,6 +110,10 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 		write_sysreg_el1(val, SYS_TCR);
 	}
 
+	if (ctxt_has_tcrx(&vcpu->arch.ctxt))
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, TCR2_EL2), SYS_TCR2);
+
+
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR0_EL2),	SYS_AFSR0);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, AFSR1_EL2),	SYS_AFSR1);
-- 
2.39.2


