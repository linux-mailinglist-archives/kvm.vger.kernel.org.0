Return-Path: <kvm+bounces-38290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25136A36EF6
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B989016F6AC
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B591F37D8;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTa9dAyU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1331D1E5B91;
	Sat, 15 Feb 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631724; cv=none; b=VAAOV70LDizWRnDbeI7ht0gmI4aHQxggClYXE7q6UAgyYPI9Uedc/j9mfha6cQWW05Uy5+Re0rMJ4wfofIzvbkC/OjCcP6ohfQDf19JnssUfg094S0fvqDVBb1UjWNb3uTa/tz0WkLuP8sBQ21hicTJtxk8VVOBNvkwUo44esi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631724; c=relaxed/simple;
	bh=ETCFz2m2tCISFG4XFboiCVnVh0mqC+xP6s7H9lTvvGE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jdvr6zdMOTyRmeQNfkGhhXVaFsHPb5pjjr1izSQ/ZIxd2dXwK0UqqVVhmN/H0CiVeWx8Eqg0sn1OcaP4UkYIMQx4l52b+5bJEj9bnIkixZIqrz5rMyblikMUfxZp3T/oWLL2FBYHUYaY0HtrKS/JV38Re+qoJReR8CN/t9sFzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTa9dAyU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7967C4CEDF;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=ETCFz2m2tCISFG4XFboiCVnVh0mqC+xP6s7H9lTvvGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTa9dAyUQ+r1WoWRLbzwMdhTcHHAaYahyN8lkrET2ERpYlCZMOBLOQjXDBhMVMCZK
	 ya49d1ciNIbjmkOttCW8MgoloxiTWhbAyWfHxf7byybzKCI00RqKN/IaXebvPucIxi
	 WUt0g7lYfb0JxpTO7bVL2cwZGwHUzeufTqJbaVQo2IvY4/rhVfdTTVHM8XuqMc+i7s
	 ErjzkcJ4bNwGDS6rEHqH2BrkTjaZkqRR23qeY9zOvwpvFYZDWFTfrlQWz31pj72EYe
	 Yanz5xt8wwOJXFQTygCWKNkzeXiOj1QOMOk9abU4ZwHTDDyQ4mPtsTiV0FEtzq4kzB
	 xPA7T7bq2NdWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJgA-004Nz6-4f;
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
Subject: [PATCH 10/14] KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
Date: Sat, 15 Feb 2025 15:01:30 +0000
Message-Id: <20250215150134.3765791-11-maz@kernel.org>
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

Now that we can handle faults triggered through VNCR_EL2, we need
to map the corresponding page at EL2. But where, you'll ask?

Since each CPU in the system can run a vcpu, we need a per-CPU
mapping. For that, we carve a NR_CPUS range in the fixmap, giving
us a per-CPU va at which to map the guest's VNCR's page.

The mapping occurs both on vcpu load and on the back of a fault,
both generating a request that will take care of the mapping.
That mapping will also get dropped on vcpu put.

Yes, this is a bit heavy handed, but it is simple. Eventually,
we may want to have a per-VM, per-CPU mapping, which would avoid
all the TLBI overhead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/fixmap.h     |  6 ++
 arch/arm64/include/asm/kvm_host.h   |  1 +
 arch/arm64/include/asm/kvm_nested.h |  7 +++
 arch/arm64/kvm/nested.c             | 98 ++++++++++++++++++++++++++---
 4 files changed, 103 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 87e307804b99c..635a43c4ec85b 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -48,6 +48,12 @@ enum fixed_addresses {
 	FIX_EARLYCON_MEM_BASE,
 	FIX_TEXT_POKE0,
 
+#ifdef CONFIG_KVM
+	/* One slot per CPU, mapping the guest's VNCR page at EL2. */
+	FIX_VNCR_END,
+	FIX_VNCR = FIX_VNCR_END + NR_CPUS,
+#endif
+
 #ifdef CONFIG_ACPI_APEI_GHES
 	/* Used for GHES mapping from assorted contexts */
 	FIX_APEI_GHES_IRQ,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3cccf6fca4dfa..0e95f4adb72ba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -623,6 +623,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
 #define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
 #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		6
+#define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		7
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 53ff314b9ecd1..284bedee742ec 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -336,4 +336,11 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
 int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu);
 
+#define vncr_fixmap(c)						\
+	({							\
+		u32 __c = (c);					\
+		BUG_ON(__c >= NR_CPUS);				\
+		(FIX_VNCR - __c);				\
+	})
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2c4991a84e003..51e1a3eba996a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -8,6 +8,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/fixmap.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
@@ -702,23 +703,35 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * The vCPU kept its reference on the MMU after the last put, keep
-	 * rolling with it.
+	 * If the vCPU kept its reference on the MMU after the last put,
+	 * keep rolling with it.
 	 */
-	if (vcpu->arch.hw_mmu)
-		return;
-
 	if (is_hyp_ctxt(vcpu)) {
-		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+		if (!vcpu->arch.hw_mmu)
+			vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 	} else {
-		write_lock(&vcpu->kvm->mmu_lock);
-		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
-		write_unlock(&vcpu->kvm->mmu_lock);
+		if (!vcpu->arch.hw_mmu) {
+			scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
+				vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
+		}
+
+		if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+			kvm_make_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu);
 	}
 }
 
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 {
+	/* Unconditionally drop the VNCR mapping if we have one */
+	if (host_data_test_flag(L1_VNCR_MAPPED)) {
+		BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
+		BUG_ON(is_hyp_ctxt(vcpu));
+
+		clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
+		vcpu->arch.vncr_tlb->cpu = -1;
+		host_data_clear_flag(L1_VNCR_MAPPED);
+	}
+
 	/*
 	 * Keep a reference on the associated stage-2 MMU if the vCPU is
 	 * scheduling out and not in WFI emulation, suggesting it is likely to
@@ -1039,6 +1052,70 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void kvm_map_l1_vncr(struct kvm_vcpu *vcpu)
+{
+	struct vncr_tlb *vt = vcpu->arch.vncr_tlb;
+	pgprot_t prot;
+
+	guard(preempt)();
+	guard(read_lock)(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * The request to map VNCR may have raced against some other
+	 * event, such as an interrupt, and may not be valid anymore.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		return;
+
+	/*
+	 * Check that the pseudo-TLB is valid and that VNCR_EL2 still
+	 * contains the expected value. If it doesn't, we simply bail out
+	 * without a mapping -- a transformed MSR/MRS will generate the
+	 * fault and allows us to populate the pseudo-TLB.
+	 */
+	if (!vt->valid)
+		return;
+
+	if (read_vncr_el2(vcpu) != vt->gva)
+		return;
+
+	if (vt->wr.nG) {
+		u64 tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+		u64 ttbr = ((tcr & TCR_A1) ?
+			    vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
+			    vcpu_read_sys_reg(vcpu, TTBR0_EL2));
+		u16 asid;
+
+		asid = FIELD_GET(TTBR_ASID_MASK, ttbr);
+		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+		    !(tcr & TCR_ASID16))
+			asid &= GENMASK(7, 0);
+
+		if (asid != vt->wr.asid)
+			return;
+	}
+
+	vt->cpu = smp_processor_id();
+
+	if (vt->wr.pw && vt->wr.pr)
+		prot = PAGE_KERNEL;
+	else if (vt->wr.pr)
+		prot = PAGE_KERNEL_RO;
+	else
+		prot = PAGE_NONE;
+
+	/*
+	 * We can't map write-only (or no permission at all) in the kernel,
+	 * but the guest can do it if using POE, so we'll have to turn a
+	 * translation fault into a permission fault at runtime.
+	 * FIXME: WO doesn't work at all, need POE support in the kernel.
+	 */
+	if (pgprot_val(prot) != pgprot_val(PAGE_NONE)) {
+		__set_fixmap(vncr_fixmap(vt->cpu), vt->hpa, prot);
+		host_data_set_flag(L1_VNCR_MAPPED);
+	}
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
@@ -1551,4 +1628,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
 	}
+
+	if (kvm_check_request(KVM_REQ_MAP_L1_VNCR_EL2, vcpu))
+		kvm_map_l1_vncr(vcpu);
 }
-- 
2.39.2


