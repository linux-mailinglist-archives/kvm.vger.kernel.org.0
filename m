Return-Path: <kvm+bounces-21103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1D092A5FE
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD3BB21C4D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D095146A77;
	Mon,  8 Jul 2024 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bu/8PvUP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99F6144D29;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=M2bbT4D694OSIGVKo8FYhmCCLXhtSfP5B62ccccBiZO6+u2LXOBFNuM6ugtnu27aRLCuwyqeqnyfEIke3LaeY55ZnpglVeJKL0ll59MQdW2b7w5IsUQ6PkJW6epJehn5F3EhsqeCcu0/IxrRELBm+1NSAeJWYFSHuPpGrxE6e68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=JsX6GaTs7Vi33NMLLUOYXeMXmeUqBGTgNLnsPE11cdk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T7xWtJ5adeoaE+3tUWW9j0B3YILxLWbS+EG3yRRLoH+Z2NSrlzzXB0G4M0vuEFIBAAS3qNBsopMC+vpnwa9rGEScTbMTDzcIBH9oKWWh+6RuXHIEmnPuCR1gSORk4Br/PRakt8XO5jXbbymaQQJvds/z626SabKm99rLV/qsxpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bu/8PvUP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784E2C4AF0C;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453495;
	bh=JsX6GaTs7Vi33NMLLUOYXeMXmeUqBGTgNLnsPE11cdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu/8PvUPlZ22Q8ni+39V+88hKotMKO8bpsopdo9VWOJ6cRSEWTu+Ek8TaMlSlgKoL
	 bBcm6a43DAmETjnZ7lRXve8My8WCE1d2vXG7tvcGoaCM2RVTBCYgYQjO+q1vYnADJB
	 JRdcrqSWO5dBPE7F3/7VlrZ/Vr5wrGLb/tIHs3zYMfSVnFbjgW3+GktLzC/LWPW5p7
	 aCxmqiCEokHMD8U1+b9HPKwyyivQyEHfsnsXuQYMFo9eJDx7NcbJe3gk6SDL3EB6Xw
	 adRzC3XDdmzef+8v81ZDEPhN5/bzaSJ9c9n3UHA3IGgRhSQ+LUw7ABklA58Bblqns8
	 789UgnzLOYMEw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXt-00Ae1P-NS;
	Mon, 08 Jul 2024 16:44:53 +0100
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
Subject: [PATCH 6/7] KVM: arm64: Enable FP8 support when available and configured
Date: Mon,  8 Jul 2024 16:44:37 +0100
Message-Id: <20240708154438.1218186-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
References: <20240708154438.1218186-1-maz@kernel.org>
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

If userspace has enabled FP8 support (by setting ID_AA64PFR2_EL1.FPMR
to 1), let's enable the feature by setting HCRX_EL2.EnFPM for the vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1157c38568e22..8b5caad651512 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4579,6 +4579,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
 	}
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-- 
2.39.2


