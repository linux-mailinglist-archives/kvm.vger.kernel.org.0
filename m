Return-Path: <kvm+bounces-16453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F076B8BA410
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 234D1280F85
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBFF48CCC;
	Thu,  2 May 2024 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WFwTotVG"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEADD1CD1B
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692948; cv=none; b=cLf8qUrjvtZSbxZ6VqLuYbtbEtxueARLHrt5c9+MIsRPv99HQIZYw95UXqlhszPsVX7JENzuP8IBr+JBssimE+BaKLzWf5WxvX1eR86huFRMQEVA1uQsmEih9lSiwQ5jTkWUg9uIvfjmz0ibT/IFwlIpI2lTKrCJriwJo0lrQxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692948; c=relaxed/simple;
	bh=N+17yPcs0vAAXxumaj+8qVKBy0rGKGupuTw4MwR/pMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeFgFy1T0y4cqADVQbU91Sg9DsQ7tjTDKRH/peeOXZ+LSLRosEwSANOjK4l5m4oK3vMa1k7tmIXi8lqShqDY5pTO4j05iXgaXKzdJ/oZIgUVKBdgE1TPmBgfyY+/Mwkydeenq9VCG/G2AGlBCLImFD1TOW5LSubs9uc9de8E2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WFwTotVG; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRTRv6yaTJ0W1aWVNO18ZgvjH7lSvQoz7VsognsnCzs=;
	b=WFwTotVGkTDuGSgEg+atLxPconjQNfU8fg+M+Ad8ehgQzsWxJ5ZixGDbu2llHqSnaoM1k4
	LwlJTN1N69ZXbiRyd1Sg2JlE4zhndNUpCU2rROsu4sFaYTyvaof7gQpQVm/jPm0ZQDbHk8
	yL3ZKTSQ0thJ+KY52W6z0xErvQ5k92k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/7] KVM: arm64: Only reset vCPU-scoped feature ID regs once
Date: Thu,  2 May 2024 23:35:25 +0000
Message-ID: <20240502233529.1958459-4-oliver.upton@linux.dev>
In-Reply-To: <20240502233529.1958459-1-oliver.upton@linux.dev>
References: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The general expecation with feature ID registers is that they're 'reset'
exactly once by KVM for the lifetime of a vCPU/VM, such that any
userspace changes to the CPU features / identity are honored after a
vCPU gets reset (e.g. PSCI_ON).

KVM handles what it calls VM-scoped feature ID registers correctly, but
feature ID registers local to a vCPU (CLIDR_EL1, MPIDR_EL1) get wiped
after every reset. What's especially concerning is that a
potentially-changing MPIDR_EL1 breaks MPIDR compression for indexing
mpidr_data, as the mask of useful bits to build the index could change.

This is absolutely no good. Avoid resetting vCPU feature ID registers
more than once.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  5 -----
 arch/arm64/kvm/sys_regs.c         | 32 +++++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..78830318c946 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1275,6 +1275,8 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
 
 #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
 
+#define kvm_vcpu_initialized(v) vcpu_get_flag(vcpu, VCPU_INITIALIZED)
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35e02c7..2116181e2315 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -580,11 +580,6 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 }
 #endif
 
-static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
-{
-	return vcpu_get_flag(vcpu, VCPU_INITIALIZED);
-}
-
 static void kvm_init_mpidr_data(struct kvm *kvm)
 {
 	struct kvm_mpidr_data *data = NULL;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bb09ce4bce45..99a485062a62 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1568,6 +1568,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	return IDREG(vcpu->kvm, reg_to_encoding(r));
 }
 
+static bool is_feature_id_reg(u32 encoding)
+{
+	return (sys_reg_Op0(encoding) == 3 &&
+		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
+		sys_reg_CRn(encoding) == 0 &&
+		sys_reg_CRm(encoding) <= 7);
+}
+
 /*
  * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
  * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8, which is the range of ID
@@ -1580,6 +1588,11 @@ static inline bool is_vm_ftr_id_reg(u32 id)
 		sys_reg_CRm(id) < 8);
 }
 
+static inline bool is_vcpu_ftr_id_reg(u32 id)
+{
+	return is_feature_id_reg(id) && !is_vm_ftr_id_reg(id);
+}
+
 static inline bool is_aa32_id_reg(u32 id)
 {
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -3522,6 +3535,15 @@ static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc
 	IDREG(kvm, id) = reg->reset(vcpu, reg);
 }
 
+static void reset_vcpu_ftr_id_reg(struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *reg)
+{
+	if (kvm_vcpu_initialized(vcpu))
+		return;
+
+	reg->reset(vcpu, reg);
+}
+
 /**
  * kvm_reset_sys_regs - sets system registers to reset value
  * @vcpu: The VCPU pointer
@@ -3542,6 +3564,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 
 		if (is_vm_ftr_id_reg(reg_to_encoding(r)))
 			reset_vm_ftr_id_reg(vcpu, r);
+		else if (is_vcpu_ftr_id_reg(reg_to_encoding(r)))
+			reset_vcpu_ftr_id_reg(vcpu, r);
 		else
 			r->reset(vcpu, r);
 	}
@@ -3972,14 +3996,6 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		sys_reg_CRm(r),					\
 		sys_reg_Op2(r))
 
-static bool is_feature_id_reg(u32 encoding)
-{
-	return (sys_reg_Op0(encoding) == 3 &&
-		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
-		sys_reg_CRn(encoding) == 0 &&
-		sys_reg_CRm(encoding) <= 7);
-}
-
 int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *range)
 {
 	const void *zero_page = page_to_virt(ZERO_PAGE(0));
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


