Return-Path: <kvm+bounces-38293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B191A36EF8
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1629A7A4E9A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CB91F890D;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCDqlphX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A771EA7DB;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631724; cv=none; b=CV0O+Z09nvdkxY7M8NzKRx/f8GG4FoQU6pXrzpB13x056XAiLCm5+gnwJnVX0eWBlCPVpogGsLFwjlaogDYHIVPPiwbcrq6OF0Cm1wHldqpHO4si5cD3AfGXjB+QgvlJMJXQWIElvyzBCeFxtzdhcBPJwoPui556hRxAAYEXU7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631724; c=relaxed/simple;
	bh=cJ99Zf5zcbhtJ6WUPcASvz5XTwglKTZO0e/0QqcEcyg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BfW/A8YfT0NI53VyF2DnkCJxUFGK5uXFR7FmVXd3mK7OVCLv2Y5Fu7tNqFh2h4z08DnHBVOxHc14M6T4xIoBwy7+2Zoa9jBJXCoaDgm2TrO/vHrS3CR+Ioq0NOijWf6Pkey5k/VhKSbU7X3SfKY38ESI0MnEaUizfq0AlQt/FIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCDqlphX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7917BC4CEE7;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631724;
	bh=cJ99Zf5zcbhtJ6WUPcASvz5XTwglKTZO0e/0QqcEcyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCDqlphXGn7ZVbsY0+Ab2Cflf+MLsnvy8cXVoUNh2wXYJQA6235fhjRcxq4dcGuWQ
	 nnLP/zodzt18SfYT/Rmvi31Z6PA0QidV05E++h1aK7w95dgIPLXXLD6hqkYk+8sgY1
	 dMYygra6T9cu5fbxunglIWeIAbLCnY6GKc02DmCathly3oSfAK8HWWWPeES3iZJ9i+
	 O2XzsfBQh2uzGuaOrOWdPCHoyDigPtmPiVIE4ahExIFwKgi+sEJcdzqdN+HGxag/2h
	 yHMCZcJlMmAbYiUg6WvkgyrczJDzgjAZkRInXrHZ6M0ePj3wGl1XyDsplDA9pajOGA
	 s7HY3vyrhGbkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJgA-004Nz6-OA;
	Sat, 15 Feb 2025 15:02:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 13/14] KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
Date: Sat, 15 Feb 2025 15:01:33 +0000
Message-Id: <20250215150134.3765791-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A TLBI by VA for S1 must take effect on our pseudo-TLB for VNCR
and potentially knock the fixmap mapping. Even worse, that TLBI
must be able to work cross-vcpu.

For that, we track on a per-VM basis if any VNCR is mapped, using
an atomic counter. Whenever a TLBI S1E2 occurs and that this counter
is non-zero, we take the long road all the way back to the core code.

There, we iterate over all vcpus and check whether this particular
invalidation has any damaging effect. If it does, we nuke the pseudo
TLB and the corresponding fixmap.

Yes, this is costly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |   3 +
 arch/arm64/include/asm/kvm_nested.h |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c     |   8 ++
 arch/arm64/kvm/nested.c             | 193 ++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e95f4adb72ba..628c299e6744c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -379,6 +379,9 @@ struct kvm_arch {
 	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
+	/* Count the number of VNCR_EL2 currently mapped */
+	atomic_t vncr_map_count;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 284bedee742ec..e3cd89ed94924 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -335,6 +335,7 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 /* VNCR management */
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
+void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val);
 
 #define vncr_fixmap(c)						\
 	({							\
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6242ab037bfdf..9ba7208df9324 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -482,6 +482,14 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (ret)
 		return false;
 
+	/*
+	 * If we have to check for any VNCR mapping being invalidated,
+	 * go back to the slow path for further processing.
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
+	    atomic_read(&vcpu->kvm->arch.vncr_map_count))
+		return false;
+
 	__kvm_skip_instr(vcpu);
 
 	return true;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 32d2640313ab6..3ce96786a0c81 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -50,6 +50,7 @@ void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
+	atomic_set(&kvm->arch.vncr_map_count, 0);
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
@@ -754,6 +755,7 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 		clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
 		vcpu->arch.vncr_tlb->cpu = -1;
 		host_data_clear_flag(L1_VNCR_MAPPED);
+		atomic_dec(&vcpu->kvm->arch.vncr_map_count);
 	}
 
 	/*
@@ -853,6 +855,196 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
 	}
 }
 
+struct s1e2_tlbi_scope {
+	enum {
+		TLBI_ALL,
+		TLBI_VA,
+		TLBI_VAA,
+		TLBI_ASID,
+	} type;
+
+	u16 asid;
+	u64 va;
+	u64 size;
+};
+
+static void invalidate_vncr_va(struct kvm *kvm,
+			       struct s1e2_tlbi_scope *scope)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+		u64 va_start, va_end, va_size;
+
+		if (!vt->valid)
+			continue;
+
+		va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
+							   vt->wr.level));
+		va_start = vt->gva & (va_size - 1);
+		va_end = va_start + va_size;
+
+		switch (scope->type) {
+		case TLBI_ALL:
+			break;
+
+		case TLBI_VA:
+			if (va_end <= scope->va ||
+			    va_start >= (scope->va + scope->size))
+				continue;
+			if (vt->wr.nG && vt->wr.asid != scope->asid)
+				continue;
+			break;
+
+		case TLBI_VAA:
+			if (va_end <= scope->va ||
+			    va_start >= (scope->va + scope->size))
+				continue;
+			break;
+
+		case TLBI_ASID:
+			if (!vt->wr.nG || vt->wr.asid != scope->asid)
+				continue;
+			break;
+		}
+
+		invalidate_vncr(vt);
+	}
+}
+
+static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
+				  struct s1e2_tlbi_scope *scope)
+{
+	switch (inst) {
+	case OP_TLBI_ALLE2:
+	case OP_TLBI_ALLE2IS:
+	case OP_TLBI_ALLE2OS:
+	case OP_TLBI_VMALLE1:
+	case OP_TLBI_VMALLE1IS:
+	case OP_TLBI_VMALLE1OS:
+	case OP_TLBI_ALLE2NXS:
+	case OP_TLBI_ALLE2ISNXS:
+	case OP_TLBI_ALLE2OSNXS:
+	case OP_TLBI_VMALLE1NXS:
+	case OP_TLBI_VMALLE1ISNXS:
+	case OP_TLBI_VMALLE1OSNXS:
+		scope->type = TLBI_ALL;
+		break;
+	case OP_TLBI_VAE2:
+	case OP_TLBI_VAE2IS:
+	case OP_TLBI_VAE2OS:
+	case OP_TLBI_VAE1:
+	case OP_TLBI_VAE1IS:
+	case OP_TLBI_VAE1OS:
+	case OP_TLBI_VAE2NXS:
+	case OP_TLBI_VAE2ISNXS:
+	case OP_TLBI_VAE2OSNXS:
+	case OP_TLBI_VAE1NXS:
+	case OP_TLBI_VAE1ISNXS:
+	case OP_TLBI_VAE1OSNXS:
+	case OP_TLBI_VALE2:
+	case OP_TLBI_VALE2IS:
+	case OP_TLBI_VALE2OS:
+	case OP_TLBI_VALE1:
+	case OP_TLBI_VALE1IS:
+	case OP_TLBI_VALE1OS:
+	case OP_TLBI_VALE2NXS:
+	case OP_TLBI_VALE2ISNXS:
+	case OP_TLBI_VALE2OSNXS:
+	case OP_TLBI_VALE1NXS:
+	case OP_TLBI_VALE1ISNXS:
+	case OP_TLBI_VALE1OSNXS:
+		scope->type = TLBI_VA;
+		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
+		if (!scope->size)
+			scope->size = SZ_1G;
+		scope->va = (val << 12) & ~(scope->size - 1);
+		scope->asid = FIELD_GET(TLBIR_ASID_MASK, val);
+		break;
+	case OP_TLBI_ASIDE1:
+	case OP_TLBI_ASIDE1IS:
+	case OP_TLBI_ASIDE1OS:
+	case OP_TLBI_ASIDE1NXS:
+	case OP_TLBI_ASIDE1ISNXS:
+	case OP_TLBI_ASIDE1OSNXS:
+		scope->type = TLBI_ASID;
+		scope->asid = FIELD_GET(TLBIR_ASID_MASK, val);
+		break;
+	case OP_TLBI_VAAE1:
+	case OP_TLBI_VAAE1IS:
+	case OP_TLBI_VAAE1OS:
+	case OP_TLBI_VAAE1NXS:
+	case OP_TLBI_VAAE1ISNXS:
+	case OP_TLBI_VAAE1OSNXS:
+	case OP_TLBI_VAALE1:
+	case OP_TLBI_VAALE1IS:
+	case OP_TLBI_VAALE1OS:
+	case OP_TLBI_VAALE1NXS:
+	case OP_TLBI_VAALE1ISNXS:
+	case OP_TLBI_VAALE1OSNXS:
+		scope->type = TLBI_VAA;
+		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
+		if (!scope->size)
+			scope->size = SZ_1G;
+		scope->va = (val << 12) & ~(scope->size - 1);
+		break;
+	case OP_TLBI_RVAE2:
+	case OP_TLBI_RVAE2IS:
+	case OP_TLBI_RVAE2OS:
+	case OP_TLBI_RVAE1:
+	case OP_TLBI_RVAE1IS:
+	case OP_TLBI_RVAE1OS:
+	case OP_TLBI_RVAE2NXS:
+	case OP_TLBI_RVAE2ISNXS:
+	case OP_TLBI_RVAE2OSNXS:
+	case OP_TLBI_RVAE1NXS:
+	case OP_TLBI_RVAE1ISNXS:
+	case OP_TLBI_RVAE1OSNXS:
+	case OP_TLBI_RVALE2:
+	case OP_TLBI_RVALE2IS:
+	case OP_TLBI_RVALE2OS:
+	case OP_TLBI_RVALE1:
+	case OP_TLBI_RVALE1IS:
+	case OP_TLBI_RVALE1OS:
+	case OP_TLBI_RVALE2NXS:
+	case OP_TLBI_RVALE2ISNXS:
+	case OP_TLBI_RVALE2OSNXS:
+	case OP_TLBI_RVALE1NXS:
+	case OP_TLBI_RVALE1ISNXS:
+	case OP_TLBI_RVALE1OSNXS:
+		scope->type = TLBI_VA;
+		scope->va = decode_range_tlbi(val, &scope->size, &scope->asid);
+		break;
+	case OP_TLBI_RVAAE1:
+	case OP_TLBI_RVAAE1IS:
+	case OP_TLBI_RVAAE1OS:
+	case OP_TLBI_RVAAE1NXS:
+	case OP_TLBI_RVAAE1ISNXS:
+	case OP_TLBI_RVAAE1OSNXS:
+	case OP_TLBI_RVAALE1:
+	case OP_TLBI_RVAALE1IS:
+	case OP_TLBI_RVAALE1OS:
+	case OP_TLBI_RVAALE1NXS:
+	case OP_TLBI_RVAALE1ISNXS:
+	case OP_TLBI_RVAALE1OSNXS:
+		scope->type = TLBI_VAA;
+		scope->va = decode_range_tlbi(val, &scope->size, NULL);
+		break;
+	}
+}
+
+void kvm_handle_s1e2_tlbi(struct kvm_vcpu *vcpu, u32 inst, u64 val)
+{
+	struct s1e2_tlbi_scope scope = {};
+
+	compute_s1_tlbi_range(vcpu, inst, val, &scope);
+	invalidate_vncr_va(vcpu->kvm, &scope);
+}
+
 void kvm_nested_s2_wp(struct kvm *kvm)
 {
 	int i;
@@ -1188,6 +1380,7 @@ static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
 	if (pgprot_val(prot) != pgprot_val(PAGE_NONE)) {
 		__set_fixmap(vncr_fixmap(vt->cpu), vt->hpa, prot);
 		host_data_set_flag(L1_VNCR_MAPPED);
+		atomic_inc(&vcpu->kvm->arch.vncr_map_count);
 	}
 }
 
-- 
2.39.2


