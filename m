Return-Path: <kvm+bounces-2074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F6C7F13F7
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B192820C5
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E1D1B28B;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy0Ph1o3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005C81A594;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B93C433CB;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485851;
	bh=dgLUJlyMxUAKdqqdhpOmey8AMEeht7uotRS4onPBaRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy0Ph1o3emOIt4xRdo7VjBNdpYJyXJzvQPLCkqf70i0gh+5fJno3UGBsWx63tsUEy
	 nErmMKFFGxEJVCHf+xBa/8nnP4ehTIyRB2QwFVdIoZIfo5GPF4vdlVzqM3Hgn701In
	 Oly5Wz9dVfET6xD4yMJuke3s3EgYknzRXR5V+KZZwbeUlCFjkdJhhOQarZ4Q1bQeY1
	 Il8ns8oTMHJECwNuomwUbb6B+/OxwaZgRwvguqxf+B39HCnRKKOGftzAzVeOJ/v8vG
	 xYIxJPWqmr3dgyvZZ6W56DGDaLtympIOwhlmGqD/hbdthN1UeOMn5fSL3eNxrx1uv8
	 bTeyxIiynpnaA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5437-00EjnU-OL;
	Mon, 20 Nov 2023 13:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 03/43] KVM: arm64: nv: Compute NV view of idregs as a one-off
Date: Mon, 20 Nov 2023 13:09:47 +0000
Message-Id: <20231120131027.854038-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have a full copy of the idregs for each VM, there is
no point in repainting the sysregs on each access. Instead, we
can simply perform the transmation as a one-off and be done
with it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/arm64/include/asm/kvm_nested.h |  6 +-----
 arch/arm64/kvm/arm.c                |  6 ++++++
 arch/arm64/kvm/nested.c             | 22 +++++++++++++++-------
 arch/arm64/kvm/sys_regs.c           |  2 --
 5 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4103a12ecaaf..fce2e5f583a7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -306,6 +306,7 @@ struct kvm_arch {
 	 * Atomic access to multiple idregs are guarded by kvm_arch.config_lock.
 	 */
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
+#define IDX_IDREG(idx)		sys_reg(3, 0, 0, ((idx) >> 3) + 1, (idx) & Op2_mask)
 #define IDREG(kvm, id)		((kvm)->arch.id_regs[IDREG_IDX(id)])
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 6cec8e9c6c91..249b03fc2cce 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -14,10 +14,6 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
-struct sys_reg_params;
-struct sys_reg_desc;
-
-void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
-			  const struct sys_reg_desc *r);
+int kvm_init_nv_sysregs(struct kvm *kvm);
 
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..b65df612b41b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -669,6 +669,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	if (vcpu_has_nv(vcpu)) {
+		ret = kvm_init_nv_sysregs(vcpu->kvm);
+		if (ret)
+			return ret;
+	}
+
 	ret = kvm_timer_enable(vcpu);
 	if (ret)
 		return ret;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3885f1c93979..66d05f5d39a2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -23,13 +23,9 @@
  * This list should get updated as new features get added to the NV
  * support, and new extension to the architecture.
  */
-void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
-			  const struct sys_reg_desc *r)
+static u64 limit_nv_id_reg(u32 id, u64 val)
 {
-	u32 id = reg_to_encoding(r);
-	u64 val, tmp;
-
-	val = p->regval;
+	u64 tmp;
 
 	switch (id) {
 	case SYS_ID_AA64ISAR0_EL1:
@@ -162,5 +158,17 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 	}
 
-	p->regval = val;
+	return val;
+}
+int kvm_init_nv_sysregs(struct kvm *kvm)
+{
+	mutex_lock(&kvm->arch.config_lock);
+
+	for (int i = 0; i < KVM_ARM_ID_REG_NUM; i++)
+		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
+						       kvm->arch.id_regs[i]);
+
+	mutex_unlock(&kvm->arch.config_lock);
+
+	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e1e3da2ed4a..4aacce494ee2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1505,8 +1505,6 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 		return write_to_read_only(vcpu, p, r);
 
 	p->regval = read_id_reg(vcpu, r);
-	if (vcpu_has_nv(vcpu))
-		access_nested_id_reg(vcpu, p, r);
 
 	return true;
 }
-- 
2.39.2


