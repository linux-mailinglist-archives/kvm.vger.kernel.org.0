Return-Path: <kvm+bounces-2097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8687F140E
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C5E728307F
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724EA1EB5D;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sa8wkeX4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96D71DDFF;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1811FC433C8;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485857;
	bh=+fJWInffnlxoplmfuifc4eL+Mpp4vZgZ51n2qUkDze8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa8wkeX4vy8Jm6/2clgxAB6rqWsPMLmfQUjZM5k1ZI7gg1iOFYHGLP6X1yby8Ynmc
	 B3DaI4OWu5DMV9X6ERAM8zKFcb06aOu1rTSuEfA/ay9sVbktowRI8NyrmHdLLeD37C
	 rlc/UvIpK9p2xUisq5sOsMvbaDgBbtXB2lMKIb0G/VptLjL2+IVoiuahyVDvFdHuhf
	 0YdW/rNOM6rbI+nCKLkKG4cWhfX+tD54lbQ6AZp0QIOfJZXVkfb3cOCnNHRVRDRcUL
	 wu6AWqTLFUmiTpZbb5UvU19Ok5Kbs43DfUjyuCxLGthIpGCg822zQUsujYnV/6pmZH
	 RsBsogTMzbdCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543D-00EjnU-6v;
	Mon, 20 Nov 2023 13:10:55 +0000
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
Subject: [PATCH v11 24/43] KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
Date: Mon, 20 Nov 2023 13:10:08 +0000
Message-Id: <20231120131027.854038-25-maz@kernel.org>
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

From: Jintack Lim <jintack.lim@linaro.org>

When supporting nested virtualization a guest hypervisor executing TLBI
instructions must be trapped and emulated by the host hypervisor,
because the guest hypervisor can only affect physical TLB entries
relating to its own execution environment (virtual EL2 in EL1) but not
to the nested guests as required by the semantics of the instructions
and TLBI instructions might also result in updates (invalidations) to
shadow page tables.

This patch does several things.

1. Emulate TLBI ALLE2(IS) instruction executed in the virtual EL2. Since
we emulate the virtual EL2 in the EL1, we invalidate EL1&0 regime stage
1 TLB entries with setting vttbr_el2 having the VMID of the virtual EL2.

2. Emulate TLBI VAE2* instruction executed in the virtual EL2. Based on the
same principle as TLBI ALLE2 instruction, we can simply emulate those
instructions by executing corresponding VAE1* instructions with the
virtual EL2's VMID assigned by the host hypervisor.

Note that we are able to emulate TLBI ALLE2IS precisely by only
invalidating stage 1 TLB entries via TLBI VMALL1IS instruction, but to
make it simeple, we reuse the existing function, __kvm_tlb_flush_vmid(),
which invalidates both of stage 1 and 2 TLB entries.

3. TLBI ALLE1(IS) instruction invalidates all EL1&0 regime stage 1 and 2
TLB entries (on all PEs in the same Inner Shareable domain). To emulate
these instructions, we first need to clear all the mappings in the
shadow page tables since executing those instructions implies the change
of mappings in the stage 2 page tables maintained by the guest
hypervisor.  We then need to invalidate all EL1&0 regime stage 1 and 2
TLB entries of all VMIDs, which are assigned by the host hypervisor, for
this VM.

4. Based on the same principle as TLBI ALLE1(IS) emulation, we clear the
mappings in the shadow stage-2 page tables and invalidate TLB entries.
But this time we do it only for the current VMID from the guest
hypervisor's perspective, not for all VMIDs.

5. Based on the same principle as TLBI ALLE1(IS) and TLBI VMALLS12E1(IS)
emulation, we clear the mappings in the shadow stage-2 page tables and
invalidate TLB entries. We do it only for one mapping for the current
VMID from the guest hypervisor's view.

6. Even though a guest hypervisor can execute TLBI instructions that are
accesible at EL1 without trap, it's wrong; All those TLBI instructions
work based on current VMID, and when running a guest hypervisor current
VMID is the one for itself, not the one from the virtual vttbr_el2. So
letting a guest hypervisor execute those TLBI instructions results in
invalidating its own TLB entries and leaving invalid TLB entries
unhandled.

Therefore we trap and emulate those TLBI instructions. The emulation is
simple; we find a shadow VMID mapped to the virtual vttbr_el2, set it in
the physical vttbr_el2, then execute the same instruction in EL2.

We don't set HCR_EL2.TTLB bit yet.

  [ Changes performed by Marc Zynger:

    The TLBI handling code more or less directly execute the same
    instruction that has been trapped (with an EL2->EL1 conversion
    in the case of an EL2 TLBI), but that's unfortunately not enough:

    - TLBIs must be upgraded to the Inner Shareable domain to account
      for vcpu migration, just like we already have with HCR_EL2.FB.

    - The DSB instruction that synchronises these must thus be on
      the Inner Shareable domain as well.

    - Prior to executing the TLBI, we need another DSB ISHST to make
      sure that the update to the page tables is now visible.

      Ordering of system instructions fixed

    - The current TLB invalidation code is pretty buggy, as it assume a
      page mapping. On the contrary, it is likely that TLB invalidation
      will cover more than a single page, and the size should be decided
      by the guests configuration (and not the host's).

      Since we don't cache the guest mapping sizes in the shadow PT yet,
      let's assume the worse case (a block mapping) and invalidate that.

      Take this opportunity to fix the decoding of the parameter (it
      isn't a straight IPA).

    - In general, we always emulate local TBL invalidations as being
      as upgraded to the Inner Shareable domain so that we can easily
      deal with vcpu migration. This is consistent with the fact that
      we set HCR_EL2.FB when running non-nested VMs.

      So let's emulate TLBI ALLE2 as ALLE2IS.
  ]

  [ Changes performed by Christoffer Dall:

    Sometimes when we are invalidating the TLB for a certain S2 MMU
    context, this context can also have EL2 context associated with it
    and we have to invalidate this too.
  ]

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h    |   2 +
 arch/arm64/include/asm/kvm_nested.h |   7 +
 arch/arm64/include/asm/sysreg.h     |   4 +
 arch/arm64/kvm/hyp/vhe/tlb.c        |  81 ++++++++++
 arch/arm64/kvm/mmu.c                |  21 ++-
 arch/arm64/kvm/nested.c             |  35 ++++
 arch/arm64/kvm/sys_regs.c           | 238 ++++++++++++++++++++++++++++
 7 files changed, 385 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ee50ed8a2a47..5719fd64e64d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -233,6 +233,8 @@ extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 					phys_addr_t start, unsigned long pages);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_vae2is(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
+extern void __kvm_tlb_el1_instr(struct kvm_s2_mmu *mmu, u64 val, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 0b3f764f44e8..2f427348506a 100644
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
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a54464c415fc..30952f1ac997 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -654,6 +654,10 @@
 #define OP_AT_S12E0W	sys_insn(AT_Op0, 4, AT_CRn, 8, 7)
 
 /* TLBI instructions */
+#define TLBI_Op0	1
+#define TLBI_Op1_EL1	0	/* Accessible from EL1 or higher */
+#define TLBI_Op1_EL2	4	/* Accessible from EL2 or higher */
+
 #define OP_TLBI_VMALLE1OS		sys_insn(1, 0, 8, 1, 0)
 #define OP_TLBI_VAE1OS			sys_insn(1, 0, 8, 1, 1)
 #define OP_TLBI_ASIDE1OS		sys_insn(1, 0, 8, 1, 2)
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index b636b4111dbf..737ea0591b54 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -231,3 +231,84 @@ void __kvm_flush_vm_context(void)
 
 	dsb(ish);
 }
+
+void __kvm_tlb_vae2is(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * Execute the EL1 version of TLBI VAE2* instruction, forcing
+	 * an upgrade to the Inner Shareable domain in order to
+	 * perform the invalidation on all CPUs.
+	 */
+	switch (sys_encoding) {
+	case OP_TLBI_VAE2:
+	case OP_TLBI_VAE2IS:
+		__tlbi(vae1is, va);
+		break;
+	case OP_TLBI_VALE2:
+	case OP_TLBI_VALE2IS:
+		__tlbi(vale1is, va);
+		break;
+	default:
+		break;
+	}
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
+
+void __kvm_tlb_el1_instr(struct kvm_s2_mmu *mmu, u64 val, u64 sys_encoding)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(mmu, &cxt);
+
+	/*
+	 * Execute the same instruction as the guest hypervisor did,
+	 * expanding the scope of local TLB invalidations to the Inner
+	 * Shareable domain so that it takes place on all CPUs. This
+	 * is equivalent to having HCR_EL2.FB set.
+	 */
+	switch (sys_encoding) {
+	case OP_TLBI_VMALLE1:
+	case OP_TLBI_VMALLE1IS:
+		__tlbi(vmalle1is);
+		break;
+	case OP_TLBI_VAE1:
+	case OP_TLBI_VAE1IS:
+		__tlbi(vae1is, val);
+		break;
+	case OP_TLBI_ASIDE1:
+	case OP_TLBI_ASIDE1IS:
+		__tlbi(aside1is, val);
+		break;
+	case OP_TLBI_VAAE1:
+	case OP_TLBI_VAAE1IS:
+		__tlbi(vaae1is, val);
+		break;
+	case OP_TLBI_VALE1:
+	case OP_TLBI_VALE1IS:
+		__tlbi(vale1is, val);
+		break;
+	case OP_TLBI_VAALE1:
+	case OP_TLBI_VAALE1IS:
+		__tlbi(vaale1is, val);
+		break;
+	default:
+		break;
+	}
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(&cxt);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 35c196a69e3b..8c77547f5582 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -173,10 +173,25 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
-				      gfn_t gfn, u64 nr_pages)
+				     gfn_t gfn, u64 nr_pages)
 {
-	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
-				gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	if (!kvm->arch.nested_mmus) {
+		/*
+		 * For a normal (i.e. non-nested) guest, flush entries for the
+		 * given VMID.
+		 */
+		kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
+					 gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
+	} else {
+		/*
+		 * When supporting nested virtualization, we can have multiple
+		 * VMIDs in play for each VCPU in the VM, so it's really not
+		 * worth it to try to quiesce the system and flush all the
+		 * VMIDs that may be in use, instead just nuke the whole thing.
+		 */
+		kvm_call_hyp(__kvm_flush_vm_context);
+	}
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 58e8a3dc5fef..61af8a42389d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -351,6 +351,41 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
 /* Must be called with kvm->mmu_lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 475e245cd653..4c5bb883773d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2906,6 +2906,216 @@ static bool handle_s12w(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return handle_s12(vcpu, p, r, true);
 }
 
+static bool handle_alle2is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	/*
+	 * To emulate invalidating all EL2 regime stage 1 TLB entries for all
+	 * PEs, executing TLBI VMALLE1IS is enough. But reuse the existing
+	 * interface for the simplicity; invalidating stage 2 entries doesn't
+	 * affect the correctness.
+	 */
+	__kvm_tlb_flush_vmid(&vcpu->kvm->arch.mmu);
+	return true;
+}
+
+static bool handle_vae2is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	int sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	/*
+	 * Based on the same principle as TLBI ALLE2 instruction
+	 * emulation, we emulate TLBI VAE2* instructions by executing
+	 * corresponding TLBI VAE1* instructions with the virtual
+	 * EL2's VMID assigned by the host hypervisor.
+	 */
+	__kvm_tlb_vae2is(&vcpu->kvm->arch.mmu, p->regval, sys_encoding);
+	return true;
+}
+
+static bool handle_alle1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	/*
+	 * Clear all mappings in the shadow page tables and invalidate the stage
+	 * 1 and 2 TLB entries via kvm_tlb_flush_vmid_ipa().
+	 */
+	kvm_nested_s2_unmap(vcpu->kvm);
+
+	if (atomic64_read(&mmu->vmid.id)) {
+		/*
+		 * Invalidate the stage 1 and 2 TLB entries for the host OS
+		 * in a VM only if there is one.
+		 */
+		__kvm_tlb_flush_vmid(mmu);
+	}
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
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
+static void s2_mmu_unmap_stage2_range(struct kvm_s2_mmu *mmu,
+				      const union tlbi_info *info)
+{
+	kvm_unmap_stage2_range(mmu, info->range.start, info->range.size);
+}
+
+static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+				const struct sys_reg_desc *r)
+{
+	u64 limit, vttbr;
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
+static void s2_mmu_unmap_stage2_ipa(struct kvm_s2_mmu *mmu,
+				    const union tlbi_info *info)
+{
+	unsigned long max_size;
+	u64 base_addr;
+
+	/*
+	 * We drop a number of things from the supplied value:
+	 *
+	 * - NS bit: we're non-secure only.
+	 *
+	 * - TTL field: We already have the granule size from the
+	 *   VTCR_EL2.TG0 field, and the level is only relevant to the
+	 *   guest's S2PT.
+	 *
+	 * - IPA[51:48]: We don't support 52bit IPA just yet...
+	 *
+	 * And of course, adjust the IPA to be on an actual address.
+	 */
+	base_addr = (info->ipa.addr & GENMASK_ULL(35, 0)) << 12;
+
+	/* Compute the maximum extent of the invalidation */
+	switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		max_size = SZ_1G;
+		break;
+	case VTCR_EL2_TG0_16K:
+		max_size = SZ_32M;
+		break;
+	case VTCR_EL2_TG0_64K:
+		/*
+		 * No, we do not support 52bit IPA in nested yet. Once
+		 * we do, this should be 4TB.
+		 */
+		/* FIXME: remove the 52bit PA support from the IDregs */
+		max_size = SZ_512M;
+		break;
+	default:
+		BUG();
+	}
+
+	base_addr &= ~(max_size - 1);
+
+	kvm_unmap_stage2_range(mmu, base_addr, max_size);
+}
+
+static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .ipa = {
+						   .addr = p->regval,
+					   },
+				   },
+				   s2_mmu_unmap_stage2_ipa);
+
+	return true;
+}
+
+static void s2_mmu_unmap_stage2_va(struct kvm_s2_mmu *mmu,
+				   const union tlbi_info *info)
+{
+	__kvm_tlb_el1_instr(mmu, info->va.addr, info->va.encoding);
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
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_E2H | HCR_TGE)) == (HCR_E2H | HCR_TGE)) {
+		mutex_lock(&vcpu->kvm->lock);
+		/*
+		 * ARMv8.4-NV allows the guest to change TGE behind
+		 * our back, so we always trap EL1 TLBIs from vEL2...
+		 */
+		__kvm_tlb_el1_instr(&vcpu->kvm->arch.mmu, p->regval, sys_encoding);
+		mutex_unlock(&vcpu->kvm->lock);
+
+		return true;
+	}
+
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
+				   &(union tlbi_info) {
+					   .va = {
+						   .addr = p->regval,
+						   .encoding = sys_encoding,
+					   },
+				   },
+				   s2_mmu_unmap_stage2_va);
+
+	return true;
+}
+
 /*
  * AT instruction emulation
  *
@@ -2997,12 +3207,40 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
 
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
+
 	SYS_INSN(AT_S1E2R, handle_s1e2),
 	SYS_INSN(AT_S1E2W, handle_s1e2),
 	SYS_INSN(AT_S12E1R, handle_s12r),
 	SYS_INSN(AT_S12E1W, handle_s12w),
 	SYS_INSN(AT_S12E0R, handle_s12r),
 	SYS_INSN(AT_S12E0W, handle_s12w),
+
+	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
+	SYS_INSN(TLBI_ALLE2IS, handle_alle2is),
+	SYS_INSN(TLBI_VAE2IS, handle_vae2is),
+	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
+	SYS_INSN(TLBI_VALE2IS, handle_vae2is),
+	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_IPAS2E1, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
+	SYS_INSN(TLBI_ALLE2, handle_alle2is),
+	SYS_INSN(TLBI_VAE2, handle_vae2is),
+	SYS_INSN(TLBI_ALLE1, handle_alle1is),
+	SYS_INSN(TLBI_VALE2, handle_vae2is),
+	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.39.2


