Return-Path: <kvm+bounces-20481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FE691690D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:36:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A46791C251A4
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4EC16D9B4;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxAVPM/q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3E4169AE4;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322524; cv=none; b=KmJasiE4uj2gNP7TVdi8K4aW74UArQLtzThMDXAcbsRToDPIHWxTNE1haCcOPboU0c4/45+5UkvWjp9Ylp2QEFp60LyPCYP0r7oG+b5rgbenE+cfa0YknKHinAmWbgTG2TOXTcYkAvIOgYM5ZbJ0wtOsxfOVA+WVPqU4R4HjMCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322524; c=relaxed/simple;
	bh=URJ463LZf+NhFwc+Irio0BcLleDjSg1ELTU95sX4nPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p/aEV3BNiw+8Wjo2R4OdMGXgyuFr2AdOQgzx5bIe2eYY9jCtEMTewOOAZ9AUMIBl46iJVQmTlZ9pY+N1ZraRwQUBYmKS8N6iAucsvApMOxd0WiaGMrWomvGKDR6sTbEvtrFWAlFi64OBJDd/F+EL0Mmq/gGgFXkdO/ijZxr4aEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxAVPM/q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7ABC4AF0A;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=URJ463LZf+NhFwc+Irio0BcLleDjSg1ELTU95sX4nPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxAVPM/qxi5uVu5SpiZE4GKIl22W7F9yzlC8UKeU3+9GUDwwI1cRwp2mtl0ptZLBW
	 /ypK+ROFNW6HB5RtPZqEDWw4MU89+32iGh2dmjb1nUSj8TgxfAwqVmkWtb0jVeLr86
	 v8YBtQiSdqbJHvJIosf5cnE7gRp+yCP2Op3L0zmI5tmpE557nmgPz7EwsCBUt3pLeD
	 hfwNCbrBRZbVnSb/EzmJypFu7wOBCJGPTxAuyGn8F5yQfrczUMRVmFwIv7FkNuAPmM
	 Bi8VT51e/m4/KqisgOKlu9G2xO7MeJpLlPD5QQc9ZV0ntQy62u5xabElwVdMHF1clY
	 zIv4OWQdxDV2Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-I8;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 04/12] KVM: arm64: nv: Honor absence of FEAT_PAN2
Date: Tue, 25 Jun 2024 14:35:03 +0100
Message-Id: <20240625133508.259829-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If our guest has been configured without PAN2, make sure that
AT S1E1{R,W}P will generate an UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 832c6733db307..06c39f191b5ec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4585,6 +4585,10 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_TLBIRVAAE1OS	|
 						HFGITR_EL2_TLBIRVAE1OS);
 
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
+						HFGITR_EL2_ATS1E1WP);
+
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
-- 
2.39.2


