Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9823CED5
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgHETG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbgHES6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:58:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6CD822CAE;
        Wed,  5 Aug 2020 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651955;
        bh=HrLX06M6wTECV6EOA8uUREkgOt6d/jEJQV8nKpZYEJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVaxsWMCz2FUk627bd2+AdR4tORSvxbV6suD89tNbM7wvS7ezn3KJMutOVFKjbMuU
         1UeuChEoGhabRG2+iIsaBaN/fJu7RSWCVfMdPo7MLg31GdivdxYaBU6H8n4g0H8u/4
         TlcDIfur7qCO9EvX+tZjheczQlqyUBSBQLw5onnI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfk-0004w9-Qo; Wed, 05 Aug 2020 18:57:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 34/56] KVM: arm64: Factor out stage 2 page table data from struct kvm
Date:   Wed,  5 Aug 2020 18:56:38 +0100
Message-Id: <20200805175700.62775-35-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

As we are about to reuse our stage 2 page table manipulation code for
shadow stage 2 page tables in the context of nested virtualization, we
are going to manage multiple stage 2 page tables for a single VM.

This requires some pretty invasive changes to our data structures,
which moves the vmid and pgd pointers into a separate structure and
change pretty much all of our mmu code to operate on this structure
instead.

The new structure is called struct kvm_s2_mmu.

There is no intended functional change by this patch alone.

Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
[Designed data structure layout in collaboration]
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Co-developed-by: Marc Zyngier <maz@kernel.org>
[maz: Moved the last_vcpu_ran down to the S2 MMU structure as well]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h        |   7 +-
 arch/arm64/include/asm/kvm_host.h       |  32 ++-
 arch/arm64/include/asm/kvm_mmu.h        |  16 +-
 arch/arm64/kvm/arm.c                    |  36 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c           |  33 ++-
 arch/arm64/kvm/hyp/vhe/switch.c         |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c            |  26 +--
 arch/arm64/kvm/mmu.c                    | 280 +++++++++++++-----------
 10 files changed, 240 insertions(+), 198 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5a91aaae78d2..18d39b30d9c9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -77,6 +77,7 @@
 
 struct kvm;
 struct kvm_vcpu;
+struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
@@ -90,9 +91,9 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #endif
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e0920df1d0c1..85a529eeeae3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -66,19 +66,34 @@ struct kvm_vmid {
 	u32    vmid;
 };
 
-struct kvm_arch {
+struct kvm_s2_mmu {
 	struct kvm_vmid vmid;
 
-	/* stage2 entry level table */
-	pgd_t *pgd;
-	phys_addr_t pgd_phys;
-
-	/* VTCR_EL2 value for this VM */
-	u64    vtcr;
+	/*
+	 * stage2 entry level table
+	 *
+	 * Two kvm_s2_mmu structures in the same VM can point to the same
+	 * pgd here.  This happens when running a guest using a
+	 * translation regime that isn't affected by its own stage-2
+	 * translation, such as a non-VHE hypervisor running at vEL2, or
+	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
+	 * canonical stage-2 page tables.
+	 */
+	pgd_t		*pgd;
+	phys_addr_t	pgd_phys;
 
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+	struct kvm *kvm;
+};
+
+struct kvm_arch {
+	struct kvm_s2_mmu mmu;
+
+	/* VTCR_EL2 value for this VM */
+	u64    vtcr;
+
 	/* The maximum number of vCPUs depends on the used GIC model */
 	int max_vcpus;
 
@@ -254,6 +269,9 @@ struct kvm_vcpu_arch {
 	void *sve_state;
 	unsigned int sve_max_vl;
 
+	/* Stage 2 paging state used by the hardware on next switch */
+	struct kvm_s2_mmu *hw_mmu;
+
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b12bfc1f051a..22157ded04ca 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -134,8 +134,8 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
-int kvm_alloc_stage2_pgd(struct kvm *kvm);
-void kvm_free_stage2_pgd(struct kvm *kvm);
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
+void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
 
@@ -577,13 +577,13 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
 	return vttbr_baddr_mask(kvm_phys_shift(kvm), kvm_stage2_levels(kvm));
 }
 
-static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
+static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 {
-	struct kvm_vmid *vmid = &kvm->arch.vmid;
+	struct kvm_vmid *vmid = &mmu->vmid;
 	u64 vmid_field, baddr;
 	u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;
 
-	baddr = kvm->arch.pgd_phys;
+	baddr = mmu->pgd_phys;
 	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
 	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
 }
@@ -592,10 +592,10 @@ static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
  * Must be called from hyp code running at EL2 with an updated VTTBR
  * and interrupts disabled.
  */
-static __always_inline void __load_guest_stage2(struct kvm *kvm)
+static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 {
-	write_sysreg(kvm->arch.vtcr, vtcr_el2);
-	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
+	write_sysreg(kern_hyp_va(mmu->kvm)->arch.vtcr, vtcr_el2);
+	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
 	 * ARM errata 1165522 and 1530923 require the actual execution of the
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0bf2cf5614c6..beb0e68cccaa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -106,22 +106,15 @@ static int kvm_arm_default_max_vcpus(void)
  */
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	int ret, cpu;
+	int ret;
 
 	ret = kvm_arm_setup_stage2(kvm, type);
 	if (ret)
 		return ret;
 
-	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
-	if (!kvm->arch.last_vcpu_ran)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu)
-		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
-
-	ret = kvm_alloc_stage2_pgd(kvm);
+	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu);
 	if (ret)
-		goto out_fail_alloc;
+		return ret;
 
 	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
 	if (ret)
@@ -129,18 +122,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_vgic_early_init(kvm);
 
-	/* Mark the initial VMID generation invalid */
-	kvm->arch.vmid.vmid_gen = 0;
-
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	return ret;
 out_free_stage2_pgd:
-	kvm_free_stage2_pgd(kvm);
-out_fail_alloc:
-	free_percpu(kvm->arch.last_vcpu_ran);
-	kvm->arch.last_vcpu_ran = NULL;
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
 	return ret;
 }
 
@@ -160,9 +147,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_vgic_destroy(kvm);
 
-	free_percpu(kvm->arch.last_vcpu_ran);
-	kvm->arch.last_vcpu_ran = NULL;
-
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
 			kvm_vcpu_destroy(kvm->vcpus[i]);
@@ -279,6 +263,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
 
+	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
 		return err;
@@ -334,16 +320,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
-	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
+	mmu = vcpu->arch.hw_mmu;
+	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
+		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
@@ -680,7 +668,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->kvm->arch.vmid);
+		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
 		check_vcpu_requests(vcpu);
 
@@ -729,7 +717,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(&vcpu->kvm->arch.vmid) ||
+		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 8f622688fa64..5c03441b5b6c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -122,9 +122,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __activate_vm(struct kvm *kvm)
+static inline void __activate_vm(struct kvm_s2_mmu *mmu)
 {
-	__load_guest_stage2(kvm);
+	__load_guest_stage2(mmu);
 }
 
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a1dcf59bd45e..37321b2157d9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -194,7 +194,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
-	__activate_vm(kern_hyp_va(vcpu->kvm));
+	__activate_vm(kern_hyp_va(vcpu->arch.hw_mmu));
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d4475f8340c4..11dbe031f0ba 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -12,7 +12,8 @@ struct tlb_inv_context {
 	u64		tcr;
 };
 
-static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
+static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
+				  struct tlb_inv_context *cxt)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
@@ -30,12 +31,10 @@ static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
 		isb();
 	}
 
-	/* __load_guest_stage2() includes an ISB for the workaround. */
-	__load_guest_stage2(kvm);
-	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
+	__load_guest_stage2(mmu);
 }
 
-static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
+static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 {
 	write_sysreg(0, vttbr_el2);
 
@@ -47,15 +46,15 @@ static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
 	}
 }
 
-void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
 	struct tlb_inv_context cxt;
 
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest(kvm, &cxt);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -98,39 +97,39 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	if (icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	kvm = kern_hyp_va(kvm);
-	__tlb_switch_to_guest(kvm, &cxt);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(kvm, &cxt);
+	mmu = kern_hyp_va(mmu);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
 void __kvm_flush_vm_context(void)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c0d33deba77e..c52d714e0d75 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -125,7 +125,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * stage 2 translation, and __activate_traps clear HCR_EL2.TGE
 	 * (among other things).
 	 */
-	__activate_vm(vcpu->kvm);
+	__activate_vm(vcpu->arch.hw_mmu);
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index b275101e9c9c..ada1d56f0709 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -16,7 +16,8 @@ struct tlb_inv_context {
 	u64		sctlr;
 };
 
-static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
+static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
+				  struct tlb_inv_context *cxt)
 {
 	u64 val;
 
@@ -52,14 +53,14 @@ static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
 	 * place before clearing TGE. __load_guest_stage2() already
 	 * has an ISB in order to deal with this.
 	 */
-	__load_guest_stage2(kvm);
+	__load_guest_stage2(mmu);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg(val, hcr_el2);
 	isb();
 }
 
-static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
+static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
 {
 	/*
 	 * We're done with the TLB operation, let's restore the host's
@@ -78,14 +79,14 @@ static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
 	local_irq_restore(cxt->flags);
 }
 
-void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
 	struct tlb_inv_context cxt;
 
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(kvm, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -106,38 +107,37 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_vmid(struct kvm *kvm)
+void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(kvm, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = vcpu->kvm;
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(kvm, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(kvm, &cxt);
+	__tlb_switch_to_host(&cxt);
 }
 
 void __kvm_flush_vm_context(void)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c0035cab6b6..2c6d59b509a5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -55,12 +55,12 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
+	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
-static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
 }
 
 /*
@@ -90,37 +90,39 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 
 /**
  * stage2_dissolve_pmd() - clear and flush huge PMD entry
- * @kvm:	pointer to kvm structure.
+ * @mmu:	pointer to mmu structure to operate on
  * @addr:	IPA
  * @pmd:	pmd pointer for IPA
  *
  * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs.
  */
-static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
+static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t *pmd)
 {
 	if (!pmd_thp_or_huge(*pmd))
 		return;
 
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	put_page(virt_to_page(pmd));
 }
 
 /**
  * stage2_dissolve_pud() - clear and flush huge PUD entry
- * @kvm:	pointer to kvm structure.
+ * @mmu:	pointer to mmu structure to operate on
  * @addr:	IPA
  * @pud:	pud pointer for IPA
  *
  * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs.
  */
-static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
+static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t *pudp)
 {
+	struct kvm *kvm = mmu->kvm;
+
 	if (!stage2_pud_huge(kvm, *pudp))
 		return;
 
 	stage2_pud_clear(kvm, pudp);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	put_page(virt_to_page(pudp));
 }
 
@@ -156,40 +158,44 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 	return p;
 }
 
-static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
+static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	p4d_t *p4d_table __maybe_unused = stage2_p4d_offset(kvm, pgd, 0UL);
 	stage2_pgd_clear(kvm, pgd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	stage2_p4d_free(kvm, p4d_table);
 	put_page(virt_to_page(pgd));
 }
 
-static void clear_stage2_p4d_entry(struct kvm *kvm, p4d_t *p4d, phys_addr_t addr)
+static void clear_stage2_p4d_entry(struct kvm_s2_mmu *mmu, p4d_t *p4d, phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, p4d, 0);
 	stage2_p4d_clear(kvm, p4d);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	stage2_pud_free(kvm, pud_table);
 	put_page(virt_to_page(p4d));
 }
 
-static void clear_stage2_pud_entry(struct kvm *kvm, pud_t *pud, phys_addr_t addr)
+static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
+
 	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
 	stage2_pud_clear(kvm, pud);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	stage2_pmd_free(kvm, pmd_table);
 	put_page(virt_to_page(pud));
 }
 
-static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr)
+static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr_t addr)
 {
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(kvm, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr);
 	free_page((unsigned long)pte_table);
 	put_page(virt_to_page(pmd));
 }
@@ -255,7 +261,7 @@ static inline void kvm_pgd_populate(pgd_t *pgdp, p4d_t *p4dp)
  * we then fully enforce cacheability of RAM, no matter what the guest
  * does.
  */
-static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
+static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 		       phys_addr_t addr, phys_addr_t end)
 {
 	phys_addr_t start_addr = addr;
@@ -267,7 +273,7 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 			pte_t old_pte = *pte;
 
 			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(kvm, addr);
+			kvm_tlb_flush_vmid_ipa(mmu, addr);
 
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
@@ -277,13 +283,14 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
-	if (stage2_pte_table_empty(kvm, start_pte))
-		clear_stage2_pmd_entry(kvm, pmd, start_addr);
+	if (stage2_pte_table_empty(mmu->kvm, start_pte))
+		clear_stage2_pmd_entry(mmu, pmd, start_addr);
 }
 
-static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
+static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 		       phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	phys_addr_t next, start_addr = addr;
 	pmd_t *pmd, *start_pmd;
 
@@ -295,24 +302,25 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
-				kvm_tlb_flush_vmid_ipa(kvm, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr);
 
 				kvm_flush_dcache_pmd(old_pmd);
 
 				put_page(virt_to_page(pmd));
 			} else {
-				unmap_stage2_ptes(kvm, pmd, addr, next);
+				unmap_stage2_ptes(mmu, pmd, addr, next);
 			}
 		}
 	} while (pmd++, addr = next, addr != end);
 
 	if (stage2_pmd_table_empty(kvm, start_pmd))
-		clear_stage2_pud_entry(kvm, pud, start_addr);
+		clear_stage2_pud_entry(mmu, pud, start_addr);
 }
 
-static void unmap_stage2_puds(struct kvm *kvm, p4d_t *p4d,
+static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
 		       phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	phys_addr_t next, start_addr = addr;
 	pud_t *pud, *start_pud;
 
@@ -324,22 +332,23 @@ static void unmap_stage2_puds(struct kvm *kvm, p4d_t *p4d,
 				pud_t old_pud = *pud;
 
 				stage2_pud_clear(kvm, pud);
-				kvm_tlb_flush_vmid_ipa(kvm, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr);
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
-				unmap_stage2_pmds(kvm, pud, addr, next);
+				unmap_stage2_pmds(mmu, pud, addr, next);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
 
 	if (stage2_pud_table_empty(kvm, start_pud))
-		clear_stage2_p4d_entry(kvm, p4d, start_addr);
+		clear_stage2_p4d_entry(mmu, p4d, start_addr);
 }
 
-static void unmap_stage2_p4ds(struct kvm *kvm, pgd_t *pgd,
+static void unmap_stage2_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 		       phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	phys_addr_t next, start_addr = addr;
 	p4d_t *p4d, *start_p4d;
 
@@ -347,11 +356,11 @@ static void unmap_stage2_p4ds(struct kvm *kvm, pgd_t *pgd,
 	do {
 		next = stage2_p4d_addr_end(kvm, addr, end);
 		if (!stage2_p4d_none(kvm, *p4d))
-			unmap_stage2_puds(kvm, p4d, addr, next);
+			unmap_stage2_puds(mmu, p4d, addr, next);
 	} while (p4d++, addr = next, addr != end);
 
 	if (stage2_p4d_table_empty(kvm, start_p4d))
-		clear_stage2_pgd_entry(kvm, pgd, start_addr);
+		clear_stage2_pgd_entry(mmu, pgd, start_addr);
 }
 
 /**
@@ -365,8 +374,9 @@ static void unmap_stage2_p4ds(struct kvm *kvm, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
+	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
 	phys_addr_t next;
@@ -374,18 +384,18 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	assert_spin_locked(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * Make sure the page table is still active, as another thread
 		 * could have possibly freed the page table, while we released
 		 * the lock.
 		 */
-		if (!READ_ONCE(kvm->arch.pgd))
+		if (!READ_ONCE(mmu->pgd))
 			break;
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (!stage2_pgd_none(kvm, *pgd))
-			unmap_stage2_p4ds(kvm, pgd, addr, next);
+			unmap_stage2_p4ds(mmu, pgd, addr, next);
 		/*
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
@@ -395,7 +405,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 	} while (pgd++, addr = next, addr != end);
 }
 
-static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
+static void stage2_flush_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 			      phys_addr_t addr, phys_addr_t end)
 {
 	pte_t *pte;
@@ -407,9 +417,10 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
+static void stage2_flush_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 			      phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	pmd_t *pmd;
 	phys_addr_t next;
 
@@ -420,14 +431,15 @@ static void stage2_flush_pmds(struct kvm *kvm, pud_t *pud,
 			if (pmd_thp_or_huge(*pmd))
 				kvm_flush_dcache_pmd(*pmd);
 			else
-				stage2_flush_ptes(kvm, pmd, addr, next);
+				stage2_flush_ptes(mmu, pmd, addr, next);
 		}
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void stage2_flush_puds(struct kvm *kvm, p4d_t *p4d,
+static void stage2_flush_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
 			      phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pud;
 	phys_addr_t next;
 
@@ -438,14 +450,15 @@ static void stage2_flush_puds(struct kvm *kvm, p4d_t *p4d,
 			if (stage2_pud_huge(kvm, *pud))
 				kvm_flush_dcache_pud(*pud);
 			else
-				stage2_flush_pmds(kvm, pud, addr, next);
+				stage2_flush_pmds(mmu, pud, addr, next);
 		}
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_p4ds(struct kvm *kvm, pgd_t *pgd,
+static void stage2_flush_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 			      phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	p4d_t *p4d;
 	phys_addr_t next;
 
@@ -453,23 +466,24 @@ static void stage2_flush_p4ds(struct kvm *kvm, pgd_t *pgd,
 	do {
 		next = stage2_p4d_addr_end(kvm, addr, end);
 		if (!stage2_p4d_none(kvm, *p4d))
-			stage2_flush_puds(kvm, p4d, addr, next);
+			stage2_flush_puds(mmu, p4d, addr, next);
 	} while (p4d++, addr = next, addr != end);
 }
 
 static void stage2_flush_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 	phys_addr_t next;
 	pgd_t *pgd;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
 	do {
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (!stage2_pgd_none(kvm, *pgd))
-			stage2_flush_p4ds(kvm, pgd, addr, next);
+			stage2_flush_p4ds(mmu, pgd, addr, next);
 
 		if (next != end)
 			cond_resched_lock(&kvm->mmu_lock);
@@ -996,21 +1010,23 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 }
 
 /**
- * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
- * @kvm:	The KVM struct pointer for the VM.
+ * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
+ * @kvm:	The pointer to the KVM structure
+ * @mmu:	The pointer to the s2 MMU structure
  *
  * Allocates only the stage-2 HW PGD level table(s) of size defined by
- * stage2_pgd_size(kvm).
+ * stage2_pgd_size(mmu->kvm).
  *
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
  */
-int kvm_alloc_stage2_pgd(struct kvm *kvm)
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
 	phys_addr_t pgd_phys;
 	pgd_t *pgd;
+	int cpu;
 
-	if (kvm->arch.pgd != NULL) {
+	if (mmu->pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
@@ -1024,8 +1040,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
 		return -EINVAL;
 
-	kvm->arch.pgd = pgd;
-	kvm->arch.pgd_phys = pgd_phys;
+	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
+	if (!mmu->last_vcpu_ran) {
+		free_pages_exact(pgd, stage2_pgd_size(kvm));
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
+
+	mmu->kvm = kvm;
+	mmu->pgd = pgd;
+	mmu->pgd_phys = pgd_phys;
+	mmu->vmid.vmid_gen = 0;
+
 	return 0;
 }
 
@@ -1064,7 +1092,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(kvm, gpa, vm_end - vm_start);
+			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1096,39 +1124,34 @@ void stage2_unmap_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-/**
- * kvm_free_stage2_pgd - free all stage-2 tables
- * @kvm:	The KVM struct pointer for the VM.
- *
- * Walks the level-1 page table pointed to by kvm->arch.pgd and frees all
- * underlying level-2 and level-3 tables before freeing the actual level-1 table
- * and setting the struct pointer to NULL.
- */
-void kvm_free_stage2_pgd(struct kvm *kvm)
+void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
+	struct kvm *kvm = mmu->kvm;
 	void *pgd = NULL;
 
 	spin_lock(&kvm->mmu_lock);
-	if (kvm->arch.pgd) {
-		unmap_stage2_range(kvm, 0, kvm_phys_size(kvm));
-		pgd = READ_ONCE(kvm->arch.pgd);
-		kvm->arch.pgd = NULL;
-		kvm->arch.pgd_phys = 0;
+	if (mmu->pgd) {
+		unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
+		pgd = READ_ONCE(mmu->pgd);
+		mmu->pgd = NULL;
 	}
 	spin_unlock(&kvm->mmu_lock);
 
 	/* Free the HW pgd, one page at a time */
-	if (pgd)
+	if (pgd) {
 		free_pages_exact(pgd, stage2_pgd_size(kvm));
+		free_percpu(mmu->last_vcpu_ran);
+	}
 }
 
-static p4d_t *stage2_get_p4d(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static p4d_t *stage2_get_p4d(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
 	p4d_t *p4d;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
 	if (stage2_pgd_none(kvm, *pgd)) {
 		if (!cache)
 			return NULL;
@@ -1140,13 +1163,14 @@ static p4d_t *stage2_get_p4d(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_p4d_offset(kvm, pgd, addr);
 }
 
-static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	p4d_t *p4d;
 	pud_t *pud;
 
-	p4d = stage2_get_p4d(kvm, cache, addr);
+	p4d = stage2_get_p4d(mmu, cache, addr);
 	if (stage2_p4d_none(kvm, *p4d)) {
 		if (!cache)
 			return NULL;
@@ -1158,13 +1182,14 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pud_offset(kvm, p4d, addr);
 }
 
-static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static pmd_t *stage2_get_pmd(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
 			     phys_addr_t addr)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pud;
 	pmd_t *pmd;
 
-	pud = stage2_get_pud(kvm, cache, addr);
+	pud = stage2_get_pud(mmu, cache, addr);
 	if (!pud || stage2_pud_huge(kvm, *pud))
 		return NULL;
 
@@ -1179,13 +1204,14 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return stage2_pmd_offset(kvm, pud, addr);
 }
 
-static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
-			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
+static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
+			       struct kvm_mmu_memory_cache *cache,
+			       phys_addr_t addr, const pmd_t *new_pmd)
 {
 	pmd_t *pmd, old_pmd;
 
 retry:
-	pmd = stage2_get_pmd(kvm, cache, addr);
+	pmd = stage2_get_pmd(mmu, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	old_pmd = *pmd;
@@ -1218,7 +1244,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * get handled accordingly.
 		 */
 		if (!pmd_thp_or_huge(old_pmd)) {
-			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			unmap_stage2_range(mmu, addr & S2_PMD_MASK, S2_PMD_SIZE);
 			goto retry;
 		}
 		/*
@@ -1234,7 +1260,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 */
 		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -1243,13 +1269,15 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 	return 0;
 }
 
-static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
+			       struct kvm_mmu_memory_cache *cache,
 			       phys_addr_t addr, const pud_t *new_pudp)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pudp, old_pud;
 
 retry:
-	pudp = stage2_get_pud(kvm, cache, addr);
+	pudp = stage2_get_pud(mmu, cache, addr);
 	VM_BUG_ON(!pudp);
 
 	old_pud = *pudp;
@@ -1268,13 +1296,13 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 		 * the range for this block and retry.
 		 */
 		if (!stage2_pud_huge(kvm, old_pud)) {
-			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			unmap_stage2_range(mmu, addr & S2_PUD_MASK, S2_PUD_SIZE);
 			goto retry;
 		}
 
 		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pudp));
 	}
@@ -1289,9 +1317,10 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
  * leaf-entry is returned in the appropriate level variable - pudpp,
  * pmdpp, ptepp.
  */
-static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
+static bool stage2_get_leaf_entry(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 				  pud_t **pudpp, pmd_t **pmdpp, pte_t **ptepp)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
@@ -1300,7 +1329,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
 	*pmdpp = NULL;
 	*ptepp = NULL;
 
-	pudp = stage2_get_pud(kvm, NULL, addr);
+	pudp = stage2_get_pud(mmu, NULL, addr);
 	if (!pudp || stage2_pud_none(kvm, *pudp) || !stage2_pud_present(kvm, *pudp))
 		return false;
 
@@ -1326,14 +1355,14 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
 	return true;
 }
 
-static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr)
 {
 	pud_t *pudp;
 	pmd_t *pmdp;
 	pte_t *ptep;
 	bool found;
 
-	found = stage2_get_leaf_entry(kvm, addr, &pudp, &pmdp, &ptep);
+	found = stage2_get_leaf_entry(mmu, addr, &pudp, &pmdp, &ptep);
 	if (!found)
 		return false;
 
@@ -1345,10 +1374,12 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return kvm_s2pte_exec(ptep);
 }
 
-static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+static int stage2_set_pte(struct kvm_s2_mmu *mmu,
+			  struct kvm_mmu_memory_cache *cache,
 			  phys_addr_t addr, const pte_t *new_pte,
 			  unsigned long flags)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, old_pte;
@@ -1358,7 +1389,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	VM_BUG_ON(logging_active && !cache);
 
 	/* Create stage-2 page table mapping - Levels 0 and 1 */
-	pud = stage2_get_pud(kvm, cache, addr);
+	pud = stage2_get_pud(mmu, cache, addr);
 	if (!pud) {
 		/*
 		 * Ignore calls from kvm_set_spte_hva for unallocated
@@ -1372,7 +1403,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	 * on to allocate page.
 	 */
 	if (logging_active)
-		stage2_dissolve_pud(kvm, addr, pud);
+		stage2_dissolve_pud(mmu, addr, pud);
 
 	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
@@ -1396,7 +1427,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	 * allocate page.
 	 */
 	if (logging_active)
-		stage2_dissolve_pmd(kvm, addr, pmd);
+		stage2_dissolve_pmd(mmu, addr, pmd);
 
 	/* Create stage-2 page mappings - Level 2 */
 	if (pmd_none(*pmd)) {
@@ -1420,7 +1451,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 			return 0;
 
 		kvm_set_pte(pte, __pte(0));
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr);
 	} else {
 		get_page(virt_to_page(pte));
 	}
@@ -1486,8 +1517,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(kvm, &cache, addr, &pte,
-						KVM_S2PTE_FLAG_IS_IOMAP);
+		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
+				     KVM_S2PTE_FLAG_IS_IOMAP);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			goto out;
@@ -1526,9 +1557,10 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
  * @addr:	range start address
  * @end:	range end address
  */
-static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
+static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 			   phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	pmd_t *pmd;
 	phys_addr_t next;
 
@@ -1549,13 +1581,14 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
 
 /**
  * stage2_wp_puds - write protect P4D range
- * @pgd:	pointer to pgd entry
+ * @p4d:	pointer to p4d entry
  * @addr:	range start address
  * @end:	range end address
  */
-static void  stage2_wp_puds(struct kvm *kvm, p4d_t *p4d,
+static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
 			    phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	pud_t *pud;
 	phys_addr_t next;
 
@@ -1567,7 +1600,7 @@ static void  stage2_wp_puds(struct kvm *kvm, p4d_t *p4d,
 				if (!kvm_s2pud_readonly(pud))
 					kvm_set_s2pud_readonly(pud);
 			} else {
-				stage2_wp_pmds(kvm, pud, addr, next);
+				stage2_wp_pmds(mmu, pud, addr, next);
 			}
 		}
 	} while (pud++, addr = next, addr != end);
@@ -1579,9 +1612,10 @@ static void  stage2_wp_puds(struct kvm *kvm, p4d_t *p4d,
  * @addr:	range start address
  * @end:	range end address
  */
-static void  stage2_wp_p4ds(struct kvm *kvm, pgd_t *pgd,
+static void  stage2_wp_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 			    phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	p4d_t *p4d;
 	phys_addr_t next;
 
@@ -1589,7 +1623,7 @@ static void  stage2_wp_p4ds(struct kvm *kvm, pgd_t *pgd,
 	do {
 		next = stage2_p4d_addr_end(kvm, addr, end);
 		if (!stage2_p4d_none(kvm, *p4d))
-			stage2_wp_puds(kvm, p4d, addr, next);
+			stage2_wp_puds(mmu, p4d, addr, next);
 	} while (p4d++, addr = next, addr != end);
 }
 
@@ -1599,12 +1633,13 @@ static void  stage2_wp_p4ds(struct kvm *kvm, pgd_t *pgd,
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
+static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
+	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
 	phys_addr_t next;
 
-	pgd = kvm->arch.pgd + stage2_pgd_index(kvm, addr);
+	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
 	do {
 		/*
 		 * Release kvm_mmu_lock periodically if the memory region is
@@ -1616,11 +1651,11 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		 * the lock.
 		 */
 		cond_resched_lock(&kvm->mmu_lock);
-		if (!READ_ONCE(kvm->arch.pgd))
+		if (!READ_ONCE(mmu->pgd))
 			break;
 		next = stage2_pgd_addr_end(kvm, addr, end);
 		if (stage2_pgd_present(kvm, *pgd))
-			stage2_wp_p4ds(kvm, pgd, addr, next);
+			stage2_wp_p4ds(mmu, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
@@ -1650,7 +1685,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(&kvm->arch.mmu, start, end);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1674,7 +1709,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(kvm, start, end);
+	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1837,6 +1872,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	pgprot_t mem_type = PAGE_S2;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
+	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
@@ -1958,7 +1994,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * execute permissions, and we preserve whatever we have.
 	 */
 	needs_exec = exec_fault ||
-		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
+		(fault_status == FSC_PERM && stage2_is_exec(mmu, fault_ipa));
 
 	if (vma_pagesize == PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
@@ -1970,7 +2006,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (needs_exec)
 			new_pud = kvm_s2pud_mkexec(new_pud);
 
-		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
+		ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
 	} else if (vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
 
@@ -1982,7 +2018,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (needs_exec)
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
 
-		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
+		ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
 	} else {
 		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
 
@@ -1994,7 +2030,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (needs_exec)
 			new_pte = kvm_s2pte_mkexec(new_pte);
 
-		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
+		ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
 	}
 
 out_unlock:
@@ -2023,7 +2059,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
-	if (!stage2_get_leaf_entry(vcpu->kvm, fault_ipa, &pud, &pmd, &pte))
+	if (!stage2_get_leaf_entry(vcpu->arch.hw_mmu, fault_ipa, &pud, &pmd, &pte))
 		goto out;
 
 	if (pud) {		/* HugeTLB */
@@ -2197,14 +2233,14 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(kvm, gpa, size);
+	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	return 0;
 }
 
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_unmap_hva_range(start, end);
@@ -2224,7 +2260,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 * therefore stage2_set_pte() never needs to clear out a huge PMD
 	 * through this calling path.
 	 */
-	stage2_set_pte(kvm, NULL, gpa, pte, 0);
+	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
 	return 0;
 }
 
@@ -2235,7 +2271,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	kvm_pfn_t pfn = pte_pfn(pte);
 	pte_t stage2_pte;
 
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 
 	trace_kvm_set_spte_hva(hva);
@@ -2258,7 +2294,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 	pte_t *pte;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	if (!stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte))
+	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
 		return 0;
 
 	if (pud)
@@ -2276,7 +2312,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 	pte_t *pte;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
-	if (!stage2_get_leaf_entry(kvm, gpa, &pud, &pmd, &pte))
+	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
 		return 0;
 
 	if (pud)
@@ -2289,7 +2325,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 	trace_kvm_age_hva(start, end);
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
@@ -2297,7 +2333,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	if (!kvm->arch.pgd)
+	if (!kvm->arch.mmu.pgd)
 		return 0;
 	trace_kvm_test_age_hva(hva);
 	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
@@ -2510,7 +2546,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(kvm, mem->guest_phys_addr, mem->memory_size);
+		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
 	else
 		stage2_flush_memslot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
@@ -2529,7 +2565,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(kvm);
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -2539,7 +2575,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, gpa, size);
+	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.27.0

