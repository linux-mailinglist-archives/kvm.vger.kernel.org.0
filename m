Return-Path: <kvm+bounces-14017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 107FB89E1EF
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBFF6284FA2
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16A915746C;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIbgUKNI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972FB156C60;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685323; cv=none; b=XzrN8OYOgd6HUXEyHSgUpyRRNUPrAnKFbrl0IgpsKd+yfXnb7DjuiRhWYFbCe/BFiHHs3XDAhLNYyOjFFYThVxA9QfiKXpLYQ1lz6nOdSJdnS/sJCzhgUjPaASEW01XAcqcE8PoOmx23CmmlYlAN6pGkEyXnEURtMTrG/PlixBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685323; c=relaxed/simple;
	bh=DtLBAgwPtWAKpf1EYrNmDi6hFVchmXk/wLqQRgI/s2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=scnxiM1peY7kwztbm8ObPRUB2w03MjI9czVk5Bd/PVjKdBhYTElVv8pM/AqrUD5f6+fucfQtgo45o79cGoyvGLSJFoEm+qpDviNo9tQR1IoE8CIat77YHlR9CP0ERIVJcGlVhjRNI2lN6WSDlvR9saW0vW6E/YNMWiBVGcdzc6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIbgUKNI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D08DC43394;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685323;
	bh=DtLBAgwPtWAKpf1EYrNmDi6hFVchmXk/wLqQRgI/s2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIbgUKNIQA+KGA10rpCp+/4ymvfgXBEybzXP5UNTUCWSioXEz5Z7cztk1ybeXfHMj
	 arioX/oGaKcZy/5m61rg1uH1jY/NKBIrk2IsNXJp37l/qJvFbN2uEp4sp/SARGJmXk
	 uKGKGscTwTilXiMMRZjK534p4s4RTIlI86PYFrfdYZQykjaPSUDdNiDP/1ZaMsahef
	 Iz4c+tlnUj/t/zeOts9yHLs/OtEAKwASlDGwRKaL3i9C137J3WSBr6pn+g9Y6dgLxe
	 OCCQgvUJS4y/RB0/vL9Wku+tx4iYDy0N439E+InRxyPlNSKiQcnlwjELl44euINlvW
	 /ft+HPZYXdzZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgn-002szC-Dt;
	Tue, 09 Apr 2024 18:55:21 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 08/16] KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
Date: Tue,  9 Apr 2024 18:54:40 +0100
Message-Id: <20240409175448.3507472-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
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
index 4a0317883cd0..4be090ceb2ba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2728,6 +2728,22 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -2745,6 +2761,38 @@ union tlbi_info {
 	} va;
 };
 
+static void s2_mmu_unmap_stage2_range(struct kvm_s2_mmu *mmu,
+				      const union tlbi_info *info)
+{
+	kvm_unmap_stage2_range(mmu, info->range.start, info->range.size);
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
+				   s2_mmu_unmap_stage2_range);
+
+	return true;
+}
+
 static void s2_mmu_tlbi_s1e1(struct kvm_s2_mmu *mmu,
 			     const union tlbi_info *info)
 {
@@ -2818,6 +2866,9 @@ static struct sys_reg_desc sys_insn_descs[] = {
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


