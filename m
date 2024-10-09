Return-Path: <kvm+bounces-28342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17247997552
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3040285C5D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149C51E882D;
	Wed,  9 Oct 2024 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mISyacbg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA001E7C08;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500449; cv=none; b=RkJppUMofhvpDDGc+Cv5ylGExRSambbgXRsataTkyytIhIgQ1FtFI41DbepMnFt43/s19DfOSne4C38RLuAeveg7G18qEqkP2CTGsNyztmk96wijsDYdKMBIPeeou+TjyOm8sf70HdjF5c0HEgZuzubXbRlf5MuqcpzDS5LNpXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500449; c=relaxed/simple;
	bh=EBML1UPI/XbYRfxzj0vXzXyo3UGhbMQqqUkLLxHimA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ssDIqy3Y6rj04tOyeWoNawFtIAE6s3q22DrfCDrNrLTHnDa/LLTpHIE5FLsF3w8ZcSTvh35GzznaATsRjFTqjRB5gC/+MKyLJ3ZJ4agCAsNw7nSn6RFNk4A4UFR8dOyOXnwNE32d65SVk/fvDVrSZORiGiNzojKaad/b59RkUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mISyacbg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04571C4CECE;
	Wed,  9 Oct 2024 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500449;
	bh=EBML1UPI/XbYRfxzj0vXzXyo3UGhbMQqqUkLLxHimA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mISyacbg0DxO9q7oP4Ht4u1Fm+cTGec9LkLZjUgfLggVYc/2crgrvx89Ssq7UgYIM
	 Fa/cYs+2/7hUIl/jUn3f9NftKtfoHbSOgEo/s+4jcmr1lo2Je4TprZdKuwHqloO654
	 kVEY2RpyzgoQMy6g1VcZRg6Xl0WKxhzfo1gKkUBY1rW+lphcv4EF/Ry/ah/vRYvNDc
	 jmE8loNZplwW0KMvu9XhZlWzkkjttHDTADcATDd1peOjJXhBeK1sqXmjZy0QzDJSUC
	 Op2N5bM6ndns9DYllNBWghEG+dIFAU8tS8H0ntS/7Ct7d6TWrYVSlRRM2eMn9X1XaM
	 qBCWalw1fqUIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvT-001wcY-78;
	Wed, 09 Oct 2024 20:00:47 +0100
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
Subject: [PATCH v4 31/36] KVM: arm64: Add save/retore support for POR_EL2
Date: Wed,  9 Oct 2024 20:00:14 +0100
Message-Id: <20241009190019.3222687-32-maz@kernel.org>
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

POR_EL2 needs saving when the guest is VHE, and restoring in
any case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 005175c10b4a9..86078bd37f8bb 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -58,6 +58,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 				__vcpu_sys_reg(vcpu, PIRE0_EL2) = read_sysreg_el1(SYS_PIRE0);
 				__vcpu_sys_reg(vcpu, PIR_EL2) = read_sysreg_el1(SYS_PIR);
 			}
+
+			if (ctxt_has_s1poe(&vcpu->arch.ctxt))
+				__vcpu_sys_reg(vcpu, POR_EL2) = read_sysreg_el1(SYS_POR);
 		}
 
 		/*
@@ -124,6 +127,9 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIR_EL2), SYS_PIR);
 			write_sysreg_el1(__vcpu_sys_reg(vcpu, PIRE0_EL2), SYS_PIRE0);
 		}
+
+		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
+			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
 	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ESR_EL2),		SYS_ESR);
-- 
2.39.2


