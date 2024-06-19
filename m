Return-Path: <kvm+bounces-20007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C228B90F554
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 690881F213D3
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99ED0155C8E;
	Wed, 19 Jun 2024 17:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qmsbDRpv"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E601156F55
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818859; cv=none; b=piseTBhmOXa1BE+NnjEzxqZNDjuJfBlmYOUQjXu2KrMYeedkpPkKatFe+dOCeBndfj/LCaQrsrPlMy5b5jGBIJM2gPYoeyGfXdAB4dVxsJGXanPcNVmBiCZGY54+l78q1Kv6BsUCeidp3eGBIIuk0O62SDUvAOf0+YNqS3wkvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818859; c=relaxed/simple;
	bh=9q0Hl2J0QJ7aGuq+7I0xclpnrDmKQ1tSGRVCCoolACw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AImpV4SD2s1+N/5tkzPcLSiDMgS+vw5Sz2yKwKDoC41sYLbDm0iB6S13DsHSfcnWP4nwfEYwV4NFMTu9du25Egzk5YwzFUD91wA+R1zHpeUpKM4InlN9BMEXyj7/yHegzJcoNgzkeHmfW9CxjrNQism++i+k17EblJdplR8y8jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qmsbDRpv; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JxTXzn1MEU74wa+Ug4zYGrklWNzPb8lp6MCQ1t0qiJQ=;
	b=qmsbDRpv/+oZ04LIP3ncJMoyyVVLc4dTHWZDG/Q/fDNVKD0Sc6/yzMBNuVOVVFmacu2qi/
	dZ94ND1Wbxx2gF2FurzG1sOfJilHDuT54rU+vxEPGzV621S8rTxdX+xFg0Cvw+2GMO9zRZ
	1hHqnACIQtpqa72myq470Md69u8aP9s=
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
Subject: [PATCH v5 04/10] KVM: arm64: Add helper for writing ID regs
Date: Wed, 19 Jun 2024 17:40:30 +0000
Message-ID: <20240619174036.483943-5-oliver.upton@linux.dev>
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

Replace the remaining usage of IDREG() with a new helper for setting the
value of a feature ID register, with the benefit of cramming in some
extra sanity checks.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/nested.c           |  4 ++--
 arch/arm64/kvm/sys_regs.c         | 17 ++++++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1201af636551..74e7c29364ee 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -327,7 +327,6 @@ struct kvm_arch {
 	 */
 #define IDREG_IDX(id)		(((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
 #define IDX_IDREG(idx)		sys_reg(3, 0, 0, ((idx) >> 3) + 1, (idx) & Op2_mask)
-#define IDREG(kvm, id)		((kvm)->arch.id_regs[IDREG_IDX(id)])
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
@@ -1346,6 +1345,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 #define kvm_read_vm_id_reg(kvm, reg)					\
 	({ u64 __val = *__vm_id_reg(&(kvm)->arch, reg); __val; })
 
+void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
+
 #define __expand_field_sign_unsigned(id, fld, val)			\
 	((u64)SYS_FIELD_VALUE(id, fld, val))
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6813c7c7f00a..5db5bc9dd290 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -203,8 +203,8 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 	}
 
 	for (int i = 0; i < KVM_ARM_ID_REG_NUM; i++)
-		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
-						       kvm->arch.id_regs[i]);
+		kvm_set_vm_id_reg(kvm, IDX_IDREG(i), limit_nv_id_reg(IDX_IDREG(i),
+								     kvm->arch.id_regs[i]));
 
 	/* VTTBR_EL2 */
 	res0 = res1 = 0;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0692a109fd4d..8e3358905371 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1851,7 +1851,7 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 
 	ret = arm64_check_features(vcpu, rd, val);
 	if (!ret)
-		IDREG(vcpu->kvm, id) = val;
+		kvm_set_vm_id_reg(vcpu->kvm, id, val);
 
 	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
@@ -1867,6 +1867,18 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return ret;
 }
 
+void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val)
+{
+	u64 *p = __vm_id_reg(&kvm->arch, reg);
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (KVM_BUG_ON(kvm_vm_has_ran_once(kvm) || !p, kvm))
+		return;
+
+	*p = val;
+}
+
 static int get_raz_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		       u64 *val)
 {
@@ -3549,8 +3561,7 @@ static void reset_vm_ftr_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc
 	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
 		return;
 
-	lockdep_assert_held(&kvm->arch.config_lock);
-	IDREG(kvm, id) = reg->reset(vcpu, reg);
+	kvm_set_vm_id_reg(kvm, id, reg->reset(vcpu, reg));
 }
 
 static void reset_vcpu_ftr_id_reg(struct kvm_vcpu *vcpu,
-- 
2.45.2.627.g7a2c4fd464-goog


