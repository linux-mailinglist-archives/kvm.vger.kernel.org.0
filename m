Return-Path: <kvm+bounces-20010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FE590F559
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A72FA1F217A1
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B398157A74;
	Wed, 19 Jun 2024 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UHYxaX3b"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C623A15749E
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818868; cv=none; b=Jzd8ecYsu5cY+EVOkUBhe4rthRHcUeA3WWSrvtTjJOjZoLyrKWJNv8b32xXxw1HkSLduw9GRoEitoumeZwAsaO/CS/qfy66HzkvvfGeYaiXv6icY6i5/koBfh6+pf3WcR5mp4+8qLUrDwAc55ELWmFu3TlxAsBHkRKaHz0EaKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818868; c=relaxed/simple;
	bh=zOqxcZFmHJGpOGhcGGZoWFGb540H7cmo5WXxVc/vqKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaumNJtM7axzYDf07+qfZO23HwXV0A75githbKWNUS9pMkitpbv/oCk+ZctU4yOAuvv2kc45XFAaeihwYtiumMcbyvFAH40+dL15wUHbNlpQA5CQC8gX0ZTrcJ5v8J9yIxByKNtAzx05TBxB7bcBPTtQ+rQUr0aLPrr1L0gaysU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UHYxaX3b; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPZ0x6Ubna/kLUCCemSwfEP2cYkCcPNTFZJJq7A7Wo4=;
	b=UHYxaX3bDW/lrwnMU1SkooVVc+MPRGRxQjkfNFbBhifG692n55uCNqE+yLEJkFZHRoJH/F
	TZ/Q7LpVbo7zlSSipZMTaMJ0Gg8WXt4BQg2A04YHYd4rA60K/IJfnFfIaq9cBh0mnrKcWq
	04QgrDRN9xWekXoxvoPJNpqNH4Wj9VQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID register
Date: Wed, 19 Jun 2024 17:40:33 +0000
Message-ID: <20240619174036.483943-8-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Sebastian Ott <sebott@redhat.com>

CTR_EL0 is currently handled as an invariant register, thus
guests will be presented with the host value of that register.

Add emulation for CTR_EL0 based on a per VM value. Userspace can
switch off DIC and IDC bits and reduce DminLine and IminLine sizes.
Naturally, ensure CTR_EL0 is trapped (HCR_EL2.TID2=1) any time that a
VM's CTR_EL0 differs from hardware.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/sys_regs.c         | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 26042875d6fc..f6de08e81d49 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -329,6 +329,8 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 ctr_el0;
+
 	/* Masks for VNCR-baked sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
@@ -1335,6 +1337,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 	switch (reg) {
 	case sys_reg(3, 0, 0, 1, 0) ... sys_reg(3, 0, 0, 7, 7):
 		return &ka->id_regs[IDREG_IDX(reg)];
+	case SYS_CTR_EL0:
+		return &ka->ctr_el0;
 	default:
 		WARN_ON_ONCE(1);
 		return NULL;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a467ff4290a7..a12f3bdfb43d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1583,6 +1583,9 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
+	if (id == SYS_CTR_EL0)
+		return true;
+
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
 		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
 		sys_reg_CRm(id) < 8);
@@ -1898,7 +1901,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write)
 		return write_to_read_only(vcpu, p, r);
 
-	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
+	p->regval = kvm_read_vm_id_reg(vcpu->kvm, SYS_CTR_EL0);
 	return true;
 }
 
@@ -2487,7 +2490,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
+	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
+			     CTR_EL0_IDC_MASK |
+			     CTR_EL0_DminLine_MASK |
+			     CTR_EL0_IminLine_MASK),
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
@@ -3725,18 +3731,11 @@ FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *r)
-{
-	((struct sys_reg_desc *)r)->val = read_sanitised_ftr_reg(SYS_CTR_EL0);
-	return ((struct sys_reg_desc *)r)->val;
-}
-
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
 	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
-	{ SYS_DESC(SYS_CTR_EL0), NULL, get_ctr_el0 },
 };
 
 static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
@@ -4086,7 +4085,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_FWB;
 
 	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE) &&
+	    kvm_read_vm_id_reg(kvm, SYS_CTR_EL0) == read_sanitised_ftr_reg(SYS_CTR_EL0))
 		vcpu->arch.hcr_el2 |= HCR_TID4;
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-- 
2.45.2.627.g7a2c4fd464-goog


