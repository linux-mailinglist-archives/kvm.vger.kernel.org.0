Return-Path: <kvm+bounces-20470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 472C7916885
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF1701F21A4C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D3015EFAA;
	Tue, 25 Jun 2024 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4Q62MQi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FF18F6B;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320449; cv=none; b=BZxADzu239F51sxCpdyQiaNgcTnQnvk06A/GnVI7ttAEoKx1iYy4zl+HRW7V/a+o5zeQHQqmL2/tYi/ZHSvm1azwiOvcNhWebhbWBNxwmG3o35H36apHEbISRpwtxbt65nWrZM2oyT3WZYMK/jswV9c627/6wP56fRE5/YnTD2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320449; c=relaxed/simple;
	bh=4L2qjshBAJ8Xn0ViF7yBdUjCB8QfzLSP6WUvqwbQNkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gTPiPFKmjHZfkK84uPLu0QeNBWAjEL2KzT37/Sj25P28mJcIDiDKVgUY+gcWVbTeOoKCqmTWCFhnjWD1Qs4j15DSfaqDEb10sSqFlK1Ctt5y00gAREnGVHnwmF4EXvNcyX7ZfxCe5SR9ZPSZSs7+1uKUCaLi1F/p7dN6v3MsB9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4Q62MQi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F6DC32781;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=4L2qjshBAJ8Xn0ViF7yBdUjCB8QfzLSP6WUvqwbQNkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4Q62MQiXvN+mL6o1X1hb+nvtixvHK78iR0E7GtLnDHaXd+kzQDH+YstotzHfKP2j
	 dRGFdBIXmeokOsckrxM9UqoFD0aZ2w0vmAGFbaJ6KLSHs+NvioPZBcoyhXzR8fYDtk
	 UpwCr6EgGHnbmZe3XOMCUj1ST4HB1sSb1RDcSBChFEW00FeMNJFCgs0ucmDdfQ1mbD
	 663PNtdtToXA+ABRMmevNKQFLPvqupUkqgHU1ngpemu5X/50mlvLB+MdQsX+NBp3tU
	 5F3UD33U3unrMcQwV56dwpIJfrZBaSiX7qU7m8vnN3+JGuAoEABYmjNe3j3WRtU11D
	 TCKz5bDHKognA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mx-0079X4-8Z;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 1/5] KVM: arm64: Correctly honor the presence of FEAT_TCRX
Date: Tue, 25 Jun 2024 14:00:37 +0100
Message-Id: <20240625130042.259175-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
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

We currently blindly enable TCR2_EL1 use in a guest, irrespective
of the feature set. This is obviously wrong, and we should actually
honor the guest configuration and handle the possible trap resulting
from the guest being buggy.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 arch/arm64/kvm/sys_regs.c        | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b2adc2c6c82a5..e6682a3ace5af 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -102,7 +102,7 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
+#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d0688..71996d36f3751 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -383,6 +383,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
+	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
+	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
 	BUG_ON(!p->is_write);
 
 	get_access_mask(r, &mask, &shift);
@@ -4060,6 +4066,9 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+
+		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 	}
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-- 
2.39.2


