Return-Path: <kvm+bounces-18313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8826E8D3A08
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EC451F26D9A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E36181BAC;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1mITdJ1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AD717BB3A;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994595; cv=none; b=RuyNiq4P6eXYy2DRqswZbAmsexVR5lZFQvottXZtB+WcGRJQX2/kF0W5+of3nhziYAzkLYlu8FcAAae2cQnlVe1K9c4OWY8pqLn357hPvxX/6cbONuAILVBlLJ/ytyOnkF53ML1ijTNY+KubP6zlyNIz9E5N5QwOX5ewP9sTYlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994595; c=relaxed/simple;
	bh=zThmFMxqyRGTd2EyTdXNaJlwBgk404JIryLF4a688iA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hyUXwmFU9XJw/b43ilaeBTCthYjYlccfeuzq2kKoZYMG4FPk8HIb5+jqdSUi9QHDukGF00kAcrWcQODm+AaieT1dL8qfCZHVw6eEo76z158fBDgSvMEwfwVnxzj8S4EjIEpzgHjUkl/qREk9lWIVnnuMpz3mImQRuggiQoEDaxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1mITdJ1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D38BC116B1;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994595;
	bh=zThmFMxqyRGTd2EyTdXNaJlwBgk404JIryLF4a688iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1mITdJ1Qs3cjqHS0pMqbFkgh5L+hTy8Du8XGCiZ0uLytBxjstQhL2mZjAW2rMQuY
	 CJY6yCElUzXAl9tAS9Ch5eoAUqNtTrfFs6RHnCYt1ppZQMbMw9qoIExYJsGFiBKoeR
	 ATRHmQd4g6cmzTWV8FHHDr+eOmDjGLm3Lfmxma27z9A4V1DZAJE+0SWmkufIzq2sBp
	 4fSdJHi1Zz+pHZQ1CxAIxM5RymHUPLwv8fm8CUpMGDXR+19h229BwXNOVtiAqb806g
	 zzsBb8BVzICv4ONecWLBN0ld2Zod217myGEPjxS/YYxKWlPCSEmU0saADf/1t6GO7s
	 PiI13etMfxoWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjB-00GekF-JJ;
	Wed, 29 May 2024 15:56:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 08/16] KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
Date: Wed, 29 May 2024 15:56:20 +0100
Message-Id: <20240529145628.3272630-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Emulating TLBI VMALLS12E1* results in tearing down all the shadow
S2 PTs that match the current VMID, since our shadow S2s are just
some form of SW-managed TLBs. That teardown itself results in a
full TLB invalidation for both S1 and S2.

This can result in over-invalidation if two vcpus use the same VMID
to tag private S2 PTs, but this is still correct from an architecture
perspective.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b22309fca3a7..22a3691ce248 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2741,6 +2741,22 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
+{
+	struct kvm *kvm = vpcu->kvm;
+	u8 CRm = sys_reg_CRm(instr);
+
+	if (sys_reg_CRn(instr) == TLBI_CRn_nXS &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR1_EL1, XS, IMP))
+		return false;
+
+	if (CRm == TLBI_CRm_nROS &&
+	    !kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
+		return false;
+
+	return true;
+}
+
 /* Only defined here as this is an internal "abstraction" */
 union tlbi_info {
 	struct {
@@ -2758,6 +2774,38 @@ union tlbi_info {
 	} va;
 };
 
+static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
+			       const union tlbi_info *info)
+{
+	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size);
+}
+
+static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 limit, vttbr;
+
+	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	limit = BIT_ULL(kvm_get_pa_bits(vcpu->kvm));
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .range = {
+						   .start = 0,
+						   .size = limit,
+					   },
+				   },
+				   s2_mmu_unmap_range);
+
+	return true;
+}
+
 static void s2_mmu_tlbi_s1e1(struct kvm_s2_mmu *mmu,
 			     const union tlbi_info *info)
 {
@@ -2831,6 +2879,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VAAE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.39.2


