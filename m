Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73D99C939
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfHZGVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36127 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfHZGVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so9946623pgm.3;
        Sun, 25 Aug 2019 23:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pz9EONDYyJODa9iiU4BPPVF2eYtrpChWeGXb35nLdG8=;
        b=b8OYQU2h9uhiJpK1VsZYAG+PpMJYRijnKQw2h5zm8RVCzFsbKFmsvirJ6TrAtRKD87
         wxn6j3nTSyRLYaqFN5Qypmg891Mq0quPunRyPo44fq5f2L0vGzHqk5pcDBYXSm3xIHXV
         dFHrtJJFf108Mu8eNAcYTnLSPGC3kdaCQWRyNbpVdL6XH8zsAMqFuwhafyWC4nUcXgKe
         bLmvoNEX8/pLOA9ZP1z0vhZePfnD7chwhpTFltFID76FCsp0aXyB2rLNowyqpn9Oq03U
         2qfEuGJjxuvrFOB+9DGryoaS9fELRlY25NRakEEgbTenj+7oA+H1kCbSN0JjfbxQ2B2B
         IPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pz9EONDYyJODa9iiU4BPPVF2eYtrpChWeGXb35nLdG8=;
        b=eYel+dKxD6W7AqogcRnzomxFTAtwl/SX0fsMqC2fVlatEeeJjHw4QXZRWPSTQL4hsT
         LORzXM4aix5XP3D7CU8PXKmaZriOB4NwpY+B7uy9x8NqJUn2cOP9Y5L5ySF+cg6Lk2W+
         VM5a2uvYzLDaGHST7roOOmwrsZIqGld3f9jXt4/UhvJqsIdv73iwCCDuue+h7w8jvm7N
         DEIUCrvGP3fhyyug26xvvBuaLJFtxFsP1bi7DotqKDJUnPUYrzkhahrwDciM271TD9u8
         gh2QDTSvC7a1XM8eAepbGUyLVj6mW671nBsbo3kKKLEITUell7eFTaihHwSywTAgY62n
         Qm9g==
X-Gm-Message-State: APjAAAX/kRnqMKt2d+QhMuct5H0vSyet9ernkKWqh8TbINE/BBmJXcQC
        K3qeQCM6czToOSoTCAJ/nqO2wWbzLFo=
X-Google-Smtp-Source: APXvYqzQzUd9gDlfOPkeAgmW+IEi4Dj1LAhVzdiPSWWkYim4c97p/a9MVVVkkpx2/xGuBCEyfoj0MQ==
X-Received: by 2002:a65:6096:: with SMTP id t22mr15454770pgu.204.1566800495428;
        Sun, 25 Aug 2019 23:21:35 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:35 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 08/23] KVM: PPC: Book3S HV: Nested: Allow pseries hypervisor to run hpt nested guest
Date:   Mon, 26 Aug 2019 16:20:54 +1000
Message-Id: <20190826062109.7573-9-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow a pseries guest hypervisor (must be a radix guest) to run a hpt
(hash page table) nested guest.

Modify the entry path such that a pseries hypervisor will always use the
kvmhv_run_single_vcpu() function to enter a guest which will result in
it calling H_ENTER_NESTED. Also modify the API to H_ENTER_NESTED to add
a version 2 which adds a slb pointer to the argument list which provides
the slb state to be used to run the nested guest.

Also modify the exit path such that a pseries hypervisor will call
kvmppc_hpte_hv_fault() when handling a page fault which would normally
be called from real mode in book3s_hv_rmhandlers.c on a powernv
hypervisor. This is required for subsequent functions which are invoked
to handle the page fault. Also save the slb state on guest exit and
don't zero slb_max.

Modify kvm_vm_ioctl_get_smmu_info_hv() such that only 4k and 64k page
size support is reported to the guest. This is to ensure that we can
maintain a 1-to-1 mapping between the guest hpt and the shadow hpt for
simplicity (this could be relaxed later with appropriate support) since
a 16M page would likely have to be broken into multiple smaller pages
since the radix guest is likely to at most be backed by 2M pages.

Modify do_tlbies() such that a pseries hypervisor will make the
H_TLB_INVALIDATE hcall to notify it's hypervisor of the invalidation of
partition scoped translation information which is required to keep the
shadow hpt in sync.

Finally allow a pseries hypervisor to run a nested hpt guest by reporting
the KVM_CAP_PPC_MMU_HASH_V3 capability and allowing handling of
kvmhv_configure_mmu().

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/hvcall.h     | 36 --------------
 arch/powerpc/include/asm/kvm_book3s.h |  2 +
 arch/powerpc/include/asm/kvm_host.h   | 55 +++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c          | 90 ++++++++++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_hv_nested.c   | 22 ++++++++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   | 20 ++++++++
 arch/powerpc/kvm/powerpc.c            |  3 +-
 7 files changed, 173 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 11112023e327..19afab30c7d0 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -481,42 +481,6 @@ struct h_cpu_char_result {
 	u64 behaviour;
 };
 
-/* Register state for entering a nested guest with H_ENTER_NESTED */
-struct hv_guest_state {
-	u64 version;		/* version of this structure layout */
-	u32 lpid;
-	u32 vcpu_token;
-	/* These registers are hypervisor privileged (at least for writing) */
-	u64 lpcr;
-	u64 pcr;
-	u64 amor;
-	u64 dpdes;
-	u64 hfscr;
-	s64 tb_offset;
-	u64 dawr0;
-	u64 dawrx0;
-	u64 ciabr;
-	u64 hdec_expiry;
-	u64 purr;
-	u64 spurr;
-	u64 ic;
-	u64 vtb;
-	u64 hdar;
-	u64 hdsisr;
-	u64 heir;
-	u64 asdr;
-	/* These are OS privileged but need to be set late in guest entry */
-	u64 srr0;
-	u64 srr1;
-	u64 sprg[4];
-	u64 pidr;
-	u64 cfar;
-	u64 ppr;
-};
-
-/* Latest version of hv_guest_state structure */
-#define HV_GUEST_STATE_VERSION	1
-
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_HVCALL_H */
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index c69eeb4e176c..40218e81b75f 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -317,6 +317,8 @@ long kvmhv_do_nested_tlbie(struct kvm_vcpu *vcpu);
 int kvmhv_run_single_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu,
 			  u64 time_limit, unsigned long lpcr);
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr);
+void kvmhv_save_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
+void kvmhv_restore_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp);
 void kvmhv_restore_hv_return_state(struct kvm_vcpu *vcpu,
 				   struct hv_guest_state *hr);
 long int kvmhv_nested_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index e6e5f59aaa97..bad09c213be6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -813,6 +813,61 @@ struct kvm_vcpu_arch {
 #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
 };
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+
+/* Following definitions used for the H_ENTER_NESTED hcall parameters */
+
+/* Following structure(s) added in Version 1 */
+
+/* Register state for entering a nested guest with H_ENTER_NESTED */
+struct hv_guest_state {
+	/* version 1 */
+	u64 version;		/* version of this structure layout */
+	u32 lpid;
+	u32 vcpu_token;
+	/* These registers are hypervisor privileged (at least for writing) */
+	u64 lpcr;
+	u64 pcr;
+	u64 amor;
+	u64 dpdes;
+	u64 hfscr;
+	s64 tb_offset;
+	u64 dawr0;
+	u64 dawrx0;
+	u64 ciabr;
+	u64 hdec_expiry;
+	u64 purr;
+	u64 spurr;
+	u64 ic;
+	u64 vtb;
+	u64 hdar;
+	u64 hdsisr;
+	u64 heir;
+	u64 asdr;
+	/* These are OS privileged but need to be set late in guest entry */
+	u64 srr0;
+	u64 srr1;
+	u64 sprg[4];
+	u64 pidr;
+	u64 cfar;
+	u64 ppr;
+};
+
+/* Following structure(s) added in Version 2 */
+
+/* SLB state for entering a nested guest with H_ENTER_NESTED */
+struct guest_slb {
+	struct kvmppc_slb slb[64];
+	int slb_max;		/* 1 + index of last valid entry in slb[] */
+	int slb_nr;		/* total number of entries in SLB */
+};
+
+/* Min and max supported versions of the above structure(s) */
+#define HV_GUEST_STATE_MIN_VERSION	1
+#define HV_GUEST_STATE_MAX_VERSION	2
+
+#endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
+
 #define VCPU_FPR(vcpu, i)	(vcpu)->arch.fp.fpr[i][TS_FPROFFSET]
 #define VCPU_VSX_FPR(vcpu, i, j)	((vcpu)->arch.fp.fpr[i][j])
 #define VCPU_VSX_VR(vcpu, i)		((vcpu)->arch.vr.vr[i])
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 67e242214191..be72bc6b4cd5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3434,16 +3434,28 @@ static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	/* call our hypervisor to load up HV regs and go */
 	struct hv_guest_state hvregs;
+	struct guest_slb *slbp = NULL;
 	/* we need to save/restore host & guest psscr since L0 doesn't for us */
 	unsigned long host_psscr;
 	int trap;
 
+	if (!kvmhv_vcpu_is_radix(vcpu)) {
+		slbp = kzalloc(sizeof(*slbp), GFP_KERNEL);
+		if (!slbp) {
+			pr_err_ratelimited("KVM: Couldn't alloc hv_guest_slb\n");
+			return 0;
+		}
+		kvmhv_save_guest_slb(vcpu, slbp);
+		hvregs.version = 2;	/* V2 required for hpt guest support */
+	} else {
+		hvregs.version = 1;	/* V1 sufficient for radix guest */
+	}
+
 	host_psscr = mfspr(SPRN_PSSCR_PR);
 	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
-	hvregs.version = HV_GUEST_STATE_VERSION;
 	if (vcpu->arch.nested) {
 		hvregs.lpid = vcpu->arch.nested->shadow_lpid;
 		hvregs.vcpu_token = vcpu->arch.nested_vcpu_id;
@@ -3453,8 +3465,12 @@ static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	hvregs.hdec_expiry = time_limit;
 	trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
-				  __pa(&vcpu->arch.regs));
+				  __pa(&vcpu->arch.regs), __pa(slbp));
 	kvmhv_restore_hv_return_state(vcpu, &hvregs);
+	if (!kvmhv_vcpu_is_radix(vcpu)) {
+		kvmhv_restore_guest_slb(vcpu, slbp);
+		kfree(slbp);
+	}
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
@@ -3466,6 +3482,49 @@ static int kvmhv_pseries_enter_guest(struct kvm_vcpu *vcpu, u64 time_limit,
 	    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
 		kvmppc_nested_cede(vcpu);
 		trap = 0;
+	} else if ((!kvmhv_vcpu_is_radix(vcpu)) &&
+				(trap == BOOK3S_INTERRUPT_H_DATA_STORAGE ||
+				 trap == BOOK3S_INTERRUPT_H_INST_STORAGE)) {
+		bool data = (trap == BOOK3S_INTERRUPT_H_DATA_STORAGE);
+		unsigned long addr, slb_v;
+		unsigned int dsisr;
+		long ret;
+
+		/* NOTE: fault_gpa was reused to store faulting slb entry. */
+		slb_v = vcpu->arch.fault_gpa;
+		if (data) {
+			addr = vcpu->arch.fault_dar;
+			dsisr = vcpu->arch.fault_dsisr;
+		} else {
+			addr = kvmppc_get_pc(vcpu);
+			dsisr = vcpu->arch.shregs.msr & DSISR_SRR1_MATCH_64S;
+			if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+				dsisr |= DSISR_ISSTORE;
+		}
+
+		/*
+		* kvmppc_hpte_hv_fault is normally called on the exit path in
+		* book3s_hv_rmhandlers.S, however here (for a pseries
+		* hypervisor) we used the H_ENTER_NESTED hcall and so missed
+		* calling it. Thus call is here, now.
+		*/
+		ret = kvmppc_hpte_hv_fault(vcpu, addr, slb_v, dsisr, data, 0);
+		if (!ret) { /* let the guest try again */
+			trap = 0;
+		} else if ((!vcpu->arch.nested) && (ret > 0)) {
+			/*
+			 * Synthesize a DSI or ISI for the guest
+			 * NOTE: don't need to worry about this being a segment
+			 * fault since if that was the case the L0 hypervisor
+			 * would have delivered this to the nested guest
+			 * directly already.
+			 */
+			if (data)
+				kvmppc_core_queue_data_storage(vcpu, addr, ret);
+			else
+				kvmppc_core_queue_inst_storage(vcpu, ret);
+			trap = 0;
+		}
 	}
 
 	return trap;
@@ -3682,7 +3741,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
 	}
 
-	vcpu->arch.slb_max = 0;
+	if (kvm_is_radix(vcpu->kvm))
+		vcpu->arch.slb_max = 0;
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -4346,9 +4406,12 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		 * for radix guests using the guest PIDR value and LPID 0.
 		 * The workaround is in the old path (kvmppc_run_vcpu())
 		 * but not the new path (kvmhv_run_single_vcpu()).
+		 * N.B. We need to use the kvmhv_run_single_vcpu() path on
+		 *      pseries to ensure we call H_ENTER_NESTED.
 		 */
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm) &&
-		    !no_mixing_hpt_and_radix)
+		if (kvmhv_on_pseries() || (kvm->arch.threads_indep &&
+					   kvm_is_radix(kvm) &&
+					   !no_mixing_hpt_and_radix))
 			r = kvmhv_run_single_vcpu(run, vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4396,9 +4459,10 @@ static void kvmppc_add_seg_page_size(struct kvm_ppc_one_seg_page_size **sps,
 	(*sps)->enc[0].page_shift = shift;
 	(*sps)->enc[0].pte_enc = kvmppc_pgsize_lp_encoding(shift, shift);
 	/*
-	 * Add 16MB MPSS support (may get filtered out by userspace)
+	 * Add 16MB MPSS support (may get filtered out by userspace) if we're
+	 * not running as a nested hypervisor (pseries)
 	 */
-	if (shift != 24) {
+	if (shift != 24 && !kvmhv_on_pseries()) {
 		int penc = kvmppc_pgsize_lp_encoding(shift, 24);
 		if (penc != -1) {
 			(*sps)->enc[1].page_shift = 24;
@@ -4429,11 +4493,9 @@ static int kvm_vm_ioctl_get_smmu_info_hv(struct kvm *kvm,
 	sps = &info->sps[0];
 	kvmppc_add_seg_page_size(&sps, 12, 0);
 	kvmppc_add_seg_page_size(&sps, 16, SLB_VSID_L | SLB_VSID_LP_01);
-	kvmppc_add_seg_page_size(&sps, 24, SLB_VSID_L);
-
-	/* If running as a nested hypervisor, we don't support HPT guests */
-	if (kvmhv_on_pseries())
-		info->flags |= KVM_PPC_NO_HASH;
+	if (!kvmhv_on_pseries()) {
+		kvmppc_add_seg_page_size(&sps, 24, SLB_VSID_L);
+	} /* else no 16M page size support */
 
 	return 0;
 }
@@ -5362,10 +5424,6 @@ static int kvmhv_configure_mmu(struct kvm *kvm, struct kvm_ppc_mmuv3_cfg *cfg)
 	if (radix && !radix_enabled())
 		return -EINVAL;
 
-	/* If we're a nested hypervisor, we currently only support radix */
-	if (kvmhv_on_pseries() && !radix)
-		return -EINVAL;
-
 	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (radix != kvm_is_radix(kvm)) {
 		if (kvm->arch.mmu_ready) {
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 735e0ac6f5b2..68d492e8861e 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -51,6 +51,16 @@ void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	hr->ppr = vcpu->arch.ppr;
 }
 
+void kvmhv_save_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp)
+{
+	int i;
+
+	for (i = 0; i < 64; i++)
+		slbp->slb[i] = vcpu->arch.slb[i];
+	slbp->slb_max = vcpu->arch.slb_max;
+	slbp->slb_nr = vcpu->arch.slb_nr;
+}
+
 static void byteswap_pt_regs(struct pt_regs *regs)
 {
 	unsigned long *addr = (unsigned long *) regs;
@@ -169,6 +179,16 @@ static void restore_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	vcpu->arch.ppr = hr->ppr;
 }
 
+void kvmhv_restore_guest_slb(struct kvm_vcpu *vcpu, struct guest_slb *slbp)
+{
+	int i;
+
+	for (i = 0; i < 64; i++)
+		vcpu->arch.slb[i] = slbp->slb[i];
+	vcpu->arch.slb_max = slbp->slb_max;
+	vcpu->arch.slb_nr = slbp->slb_nr;
+}
+
 void kvmhv_restore_hv_return_state(struct kvm_vcpu *vcpu,
 				   struct hv_guest_state *hr)
 {
@@ -239,7 +259,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		return H_PARAMETER;
 	if (kvmppc_need_byteswap(vcpu))
 		byteswap_hv_regs(&l2_hv);
-	if (l2_hv.version != HV_GUEST_STATE_VERSION)
+	if (l2_hv.version != 1)
 		return H_P2;
 
 	regs_ptr = kvmppc_get_gpr(vcpu, 5);
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 1d26d509aaf6..53fe51d04d78 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -446,6 +446,25 @@ static void do_tlbies(unsigned int lpid, unsigned long *rbvalues,
 	long i;
 
 	/*
+	 * Handle the case where we're running as a nested hypervisor and so
+	 * have to make an hcall to handle invalidations for us.
+	 */
+	if (kvmhv_on_pseries()) {
+		unsigned long rc, ric = 0, prs = 0, r = 0;
+
+		for (i = 0; i < npages; i++) {
+			rc = plpar_hcall_norets(H_TLB_INVALIDATE,
+						H_TLBIE_P1_ENC(ric, prs, r),
+						lpid, rbvalues[i]);
+			if (rc)
+				pr_err("KVM: HPT TLB page invalidation hcall failed"
+					", rc=%ld\n", rc);
+		}
+
+		return;
+	}
+
+	/*
 	 * We use the POWER9 5-operand versions of tlbie and tlbiel here.
 	 * Since we are using RIC=0 PRS=0 R=0, and P7/P8 tlbiel ignores
 	 * the RS field, this is backwards-compatible with P7 and P8.
@@ -1355,3 +1374,4 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 
 	return -1;		/* send fault up to host kernel mode */
 }
+EXPORT_SYMBOL_GPL(kvmppc_hpte_hv_fault);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3e566c2e6066..b74f794873cd 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -604,8 +604,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !!(hv_enabled && radix_enabled());
 		break;
 	case KVM_CAP_PPC_MMU_HASH_V3:
-		r = !!(hv_enabled && cpu_has_feature(CPU_FTR_ARCH_300) &&
-		       cpu_has_feature(CPU_FTR_HVMODE));
+		r = !!(hv_enabled && cpu_has_feature(CPU_FTR_ARCH_300));
 		break;
 	case KVM_CAP_PPC_NESTED_HV:
 		r = !!(hv_enabled && kvmppc_hv_ops->enable_nested &&
-- 
2.13.6

