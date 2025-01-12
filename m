Return-Path: <kvm+bounces-35231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DC0A0AB0B
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B5AE7A33EC
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 16:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04221BF33F;
	Sun, 12 Jan 2025 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTUCD+1E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D101BD9D2;
	Sun, 12 Jan 2025 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736700637; cv=none; b=LGpIZLWfJSWh00d1XnCHcErT5t+CNYbDfZfhGxbyG3ZO3pEaqTy9zsPWu8D0freedgv+DksYxvPc/I2b4rJi1jZP+XxQvZx831zlTY9/+llvuvwjpLUDe6JKSpN4fTxzU+pGyGEG5OzcpOyNxoTCRnAacD2sQOO5K62x9fnP5N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736700637; c=relaxed/simple;
	bh=61n9bky/zprPROXms9U/GF9BXN2TtQW4JY28YmSGENA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hc2vElTURyE7Elgm7Vj8CYJXQs/O5i2ihhQPZqCiPE5quA8Xn/Mh1mcojMvkkvqK7hNJYQTgwnHHubQXFQ691tBe3bJv4n944+AZt7SuNR09x3TspjKAQo920YEUZ0A95yYcyamE78QCN3lVK0k81p13LFUAJ1osIgke2tPPSuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTUCD+1E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F22C4CEE4;
	Sun, 12 Jan 2025 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736700637;
	bh=61n9bky/zprPROXms9U/GF9BXN2TtQW4JY28YmSGENA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTUCD+1Ed8vRzPOUlYqhhTYPw9OUDHILIJOYAQ7eEz/lUAH7/VsxPLqbOlOXasPDZ
	 ZyOwC+RzXUdu4+yjb1/yemKtn+qZCoZeoDgSrHo8Un2gL89Sc19F0vSsMas3XBNUJU
	 RAqaDZA8Pnr9gJVUCfCTYC6uUjqxZlAvEG8YK0gUL3neYMYc+3G6iTAylUdTmzhDbA
	 hbPaLGDG8q8HxslvTFxPF6u1Jh+iHjo5t1ETZdBq4Zwf1Ixwxar3G7jcs6XaTl+wx+
	 F2+qaV5QBD3Tt1oejlb0qtD+1IIasF/oE4LPz3w+26Ftpz1vhkfUIAz3Ec/IrilTzR
	 esT/WwbSwXQAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1AZ-00BNnv-J7;
	Sun, 12 Jan 2025 16:50:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: nv: Apply RESx settings to sysreg reset values
Date: Sun, 12 Jan 2025 16:50:29 +0000
Message-Id: <20250112165029.1181056-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112165029.1181056-1-maz@kernel.org>
References: <20250112165029.1181056-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While we have sanitisation in place for the guest sysregs, we lack
that sanitisation out of reset. So some of the fields could be
evaluated and not reflect their RESx status, which sounds like
a very bad idea.

Apply the RESx masks to the the sysreg file in two situations:

- when going via a reset of the sysregs

- after having computed the RESx masks

Having this separate reset phase from the actual reset handling is
a bit grotty, but we need to apply this after the ID registers are
final.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 +-
 arch/arm64/kvm/nested.c             | 9 +++++++--
 arch/arm64/kvm/sys_regs.c           | 5 ++++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4792a3f1f4841..e3cd89ed94924 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -187,7 +187,7 @@ static inline bool kvm_supported_tlbi_s1e2_op(struct kvm_vcpu *vpcu, u32 instr)
 	return true;
 }
 
-int kvm_init_nv_sysregs(struct kvm *kvm);
+int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 071198e1ba264..169c548f72d1a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1568,14 +1568,15 @@ static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0,
 	kvm->arch.sysreg_masks->mask[i].res1 = res1;
 }
 
-int kvm_init_nv_sysregs(struct kvm *kvm)
+int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	u64 res0, res1;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (kvm->arch.sysreg_masks)
-		return 0;
+		goto out;
 
 	kvm->arch.sysreg_masks = kzalloc(sizeof(*(kvm->arch.sysreg_masks)),
 					 GFP_KERNEL_ACCOUNT);
@@ -1906,6 +1907,10 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	/* VNCR_EL2 */
 	set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
 
+out:
+	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
+		(void)__vcpu_sys_reg(vcpu, sr);
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4a09b6ef94bb9..18bb81291c7ce 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4576,6 +4576,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 			reset_vcpu_ftr_id_reg(vcpu, r);
 		else
 			r->reset(vcpu, r);
+
+		if (r->reg >= __SANITISED_REG_START__ && r->reg < NR_SYS_REGS)
+			(void)__vcpu_sys_reg(vcpu, r->reg);
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
@@ -5179,7 +5182,7 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu_has_nv(vcpu)) {
-		int ret = kvm_init_nv_sysregs(kvm);
+		int ret = kvm_init_nv_sysregs(vcpu);
 		if (ret)
 			return ret;
 	}
-- 
2.39.2


