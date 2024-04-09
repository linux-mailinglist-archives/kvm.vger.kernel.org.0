Return-Path: <kvm+bounces-14015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFD489E1EB
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E36651C22028
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F708156F46;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BhiEo1Kg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCE8156C44;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685323; cv=none; b=Up7II8KAEnhOh0iagExjkoOAjAghoJfe4YquxWQ4RSH/jL4v2UJ/UPOtgIj2eYB91fsFzYzXihV9ma7P2ukmXp/jmh2x/1i/sk+bbThaDGP1+3C8OhZ9vf+o9Q1pJYWzpADaWMXDk2N9TaxUlbF+Rd5uEPeDW9hSElmLLvE36zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685323; c=relaxed/simple;
	bh=T3pLSEJKUOLgseWkaFmAOg0LBqi50uLREXGR1gMMvCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h40/vH63qs+66dE/ycLHwRftq/z8DQgumk6XX7fQ/g1fqHnrwjaaOJ8wgR1M579MezUP0tv8TiXi6F24zt/SnimBsduXAFFrJLw9HVFAtxa+HOq+dZ6VNExIcmy1K8ATIw7B7JZZDGzXY5LSEGWg3Ho4uCrS3o0T4mzShCIKh1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BhiEo1Kg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFFC433B2;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685323;
	bh=T3pLSEJKUOLgseWkaFmAOg0LBqi50uLREXGR1gMMvCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhiEo1Kglz7glgUycMny3/3IeutpvWiav9C2ADb6htKXWgS+BSqnF96HcBh5NxnXg
	 VAq1TKuCXU8MPBG+NiBHBbYEqVJdmC4EWv3MMCA8npm8UENc6jCDKOZj8HlrNcnREm
	 nJpgqeDoHDgRHoA0F+uhNwOVcvbRc/48pZF3CDxreJAh4Kl7i//O6XbzdKMzcoYHHh
	 8iIVRE6V4i5MkTXBwK5gC6yGEienF8ArVpCgT0nqI0u27biCnn2cjd6fjoN14FNPNR
	 RrqKk7ec0eNqKoup4aG0b76+vlgRbCWSSorWbtbyTe5VD+OuwJ2a0FpYuq6Ia5L0v9
	 +6f2dpqSnBVmw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgn-002szC-51;
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
Subject: [PATCH 07/16] KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
Date: Tue,  9 Apr 2024 18:54:39 +0100
Message-Id: <20240409175448.3507472-8-maz@kernel.org>
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

While dealing with TLB invalidation targeting the guest hypervisor's
own stage-1 was easy, doing the same thing for its own guests is
a bit more involved.

Since such an invalidation is scoped by VMID, it needs to apply to
all s2_mmu contexts that have been tagged by that VMID, irrespective
of the value of VTTBR_EL2.BADDR.

So for each s2_mmu context matching that VMID, we invalidate the
corresponding TLBs, each context having its own "physical" VMID.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  7 +++
 arch/arm64/kvm/nested.c             | 35 +++++++++++++
 arch/arm64/kvm/sys_regs.c           | 80 +++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 136c878b742e..6b647a169f5d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -64,6 +64,13 @@ extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
+
+union tlbi_info;
+
+extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
+				       const union tlbi_info *info,
+				       void (*)(struct kvm_s2_mmu *,
+						const union tlbi_info *));
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3e95f815ad17..645c979a75e5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -349,6 +349,41 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+/*
+ * We can have multiple *different* MMU contexts with the same VMID:
+ *
+ * - S2 being enabled or not, hence differing by the HCR_EL2.VM bit
+ *
+ * - Multiple vcpus using private S2s (huh huh...), hence differing by the
+ *   VBBTR_EL2.BADDR address
+ *
+ * - A combination of the above...
+ *
+ * We can always identify which MMU context to pick at run-time.  However,
+ * TLB invalidation involving a VMID must take action on all the TLBs using
+ * this particular VMID. This translates into applying the same invalidation
+ * operation to all the contexts that are using this VMID. Moar phun!
+ */
+void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
+				const union tlbi_info *info,
+				void (*tlbi_callback)(struct kvm_s2_mmu *,
+						      const union tlbi_info *))
+{
+	write_lock(&kvm->mmu_lock);
+
+	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		if (vmid == get_vmid(mmu->tlb_vttbr))
+			tlbi_callback(mmu, info);
+	}
+
+	write_unlock(&kvm->mmu_lock);
+}
+
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 {
 	bool nested_stage2_enabled;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..4a0317883cd0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2728,6 +2728,73 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+/* Only defined here as this is an internal "abstraction" */
+union tlbi_info {
+	struct {
+		u64	start;
+		u64	size;
+	} range;
+
+	struct {
+		u64	addr;
+	} ipa;
+
+	struct {
+		u64	addr;
+		u32	encoding;
+	} va;
+};
+
+static void s2_mmu_tlbi_s1e1(struct kvm_s2_mmu *mmu,
+			     const union tlbi_info *info)
+{
+	WARN_ON(__kvm_tlbi_s1e2(mmu, info->va.addr, info->va.encoding));
+}
+
+static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+
+	/*
+	 * If we're here, this is because we've trapped on a EL1 TLBI
+	 * instruction that affects the EL1 translation regime while
+	 * we're running in a context that doesn't allow us to let the
+	 * HW do its thing (aka vEL2):
+	 *
+	 * - HCR_EL2.E2H == 0 : a non-VHE guest
+	 * - HCR_EL2.{E2H,TGE} == { 1, 0 } : a VHE guest in guest mode
+	 *
+	 * We don't expect these helpers to ever be called when running
+	 * in a vEL1 context.
+	 */
+
+	WARN_ON(!vcpu_is_el2(vcpu));
+
+	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .va = {
+						   .addr = p->regval,
+						   .encoding = sys_encoding,
+					   },
+				   },
+				   s2_mmu_tlbi_s1e1);
+
+	return true;
+}
+
+#define SYS_INSN(insn, access_fn)					\
+	{								\
+		SYS_DESC(OP_##insn),					\
+		.access = (access_fn),					\
+	}
+
 static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
@@ -2738,6 +2805,19 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+
+	SYS_INSN(TLBI_VMALLE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1IS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VMALLE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.39.2


