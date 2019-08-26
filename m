Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933209C94F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfHZGWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:04 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46020 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbfHZGWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id w26so11085907pfq.12;
        Sun, 25 Aug 2019 23:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0DATG+ESdIgIylqNlYCYOgcqn+Te4S9qCutaSgfzPWw=;
        b=OPeieG3ruI0W0oNJnp0jOcHJAKjGAWVMTaJuKNKE5f3yk1NDNc3LPmYGy2YKPTM3y0
         8/WCyrBN+uYQQkiIXVYHwCc7FaAEyFwI70yYN9/Kp8QvmCMYvX/zfkxX0coicehr0VgA
         4Th6786JOa+QIN0QN05INkbYcu+qC8yuecg4petciChomk+mCDcXzBGERUU9RduW+dS2
         BFXQhyHqw1d2fvozoyXhSI1T+kvOS64FmjUvirirhCCIFoQqG16gsh/x4ocVZr1B3Yz3
         fCdushj2u4r5vvpP1yEIf6hHni5/NJ8ArAPoRLZtzcwm1hHcUSxbo2y6n752JjQreVS7
         NfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0DATG+ESdIgIylqNlYCYOgcqn+Te4S9qCutaSgfzPWw=;
        b=ZdyQMo5pjFVjNbGy6jRC9jB7bSlG3SEyNSDYeRM6kuMF1nkaV0j9V2zNiyP9+3RdvH
         n/lU0bAHvDYG0ZemYZY1A2d9xn+lOCqwMVzUxUEPluIkX6p0y/baAJbfIYSAgjmHiGFw
         uT/OMrFU/GoI/6SdCpyhFmSa/Gg8E31itDGfj9IbmMc2sZPVzkg1qolyW/uqK0nCwluq
         THpmBOVv7XHjUT6Beu4Ow+Ksd87TdrZcZ57KVk6r0A/ub/gl5PLu0o8sBdejtFnhUcBR
         rgSnPiBUaDOAfePC2HRS4f6LjTTwzaUDbPXyzJerVqEZZSjG/c6d1NFz/19MAd3zGwPw
         klPg==
X-Gm-Message-State: APjAAAWEALPyvi/Cq/wW8psLtcILL+I7ZnycJ1/f5sk4SnNsJG72rxrC
        0tmV75svYtwFjRvCAGSslVwGQJDcBJQ=
X-Google-Smtp-Source: APXvYqyRx3quUWBIx5MHpUtnPpCCwgBsXHzZkOSEYzpCWbwx8YPaIMcXy53hTWfc3iRbaechYXU5dA==
X-Received: by 2002:a63:9d8a:: with SMTP id i132mr4773224pgd.410.1566800521969;
        Sun, 25 Aug 2019 23:22:01 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:22:01 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 19/23] KVM: PPC: Book3S HV: Nested: Implement nested hpt mmu translation
Date:   Mon, 26 Aug 2019 16:21:05 +1000
Message-Id: <20190826062109.7573-20-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the insertion of nested hpt (hash page table) translations in
to the shadow hpt. The shadow hpt is used to store ptes (page table
entries) which provide the translation from nested guest virtual address
to host real address. The translation from nested guest effective
address to virtual address is provided by the slb which the nested guest
can manage itself directly.

In order to construct this translation the hash page table in L1 memory
must first be searched to provide a translation from nested guest
virtual address to L1 guest real address. If no such entry is found then
an interrupt is provided to the L1 guest hypervisor so that it can
insert an entry.

The L1 guest real address is then translated to a host real address
through the radix page tables for the L1 guest, with an entry created
if one doesn't already exist.

The rc bits are then set for the pte in the L1 guest memory and the host
radix pte for the L1 guest since these will be set by the hardware in
the shadow pte automatically and so no interrupt will be provided to
ensure these can be kept in sync. In fact the rc bits in the shadow hpt
are set by software here. The c (change) bit is only set if the nested
guest is writing, otherwise the page is mapped read only so that we can
fault on a write to set the change bit and upgrade the write
permissions.

The combination of the pte permissions is applied to the entry inserted
and a nest rmap entry inserted.

Since we may come in with an existing entry when we just need to upgrade
the write permissions on a page (in which case the index was found and
stored in kvmppc_hpte_hv_fault()) we check for this case and just load
the guest rpte entry from the rev map rather than having to look it up
in L1 guest memory again.

This doesn't support the invalidation of translations by either the L0
or L1 hypervisors, this functionality is added in proceeding patches.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/mmu-hash.h |   2 +
 arch/powerpc/include/asm/kvm_book3s.h         |   4 +
 arch/powerpc/include/asm/kvm_book3s_64.h      |   9 +
 arch/powerpc/kvm/book3s_hv_nested.c           | 385 +++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |   6 +-
 5 files changed, 404 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu-hash.h b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
index c04e37b2c30d..f33dcb84a0bf 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -90,6 +90,8 @@
 #define HPTE_R_KEY_HI		ASM_CONST(0x3000000000000000)
 #define HPTE_R_KEY_BIT0		ASM_CONST(0x2000000000000000)
 #define HPTE_R_KEY_BIT1		ASM_CONST(0x1000000000000000)
+#define HPTE_R_B		ASM_CONST(0x0c00000000000000)
+#define HPTE_R_B_1T		ASM_CONST(0x0400000000000000)
 #define HPTE_R_RPN_SHIFT	12
 #define HPTE_R_RPN		ASM_CONST(0x0ffffffffffff000)
 #define HPTE_R_RPN_3_0		ASM_CONST(0x01fffffffffff000)
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index f13dab096dad..b43d7f348712 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -158,6 +158,10 @@ extern void kvmppc_mmu_flush_segments(struct kvm_vcpu *vcpu);
 extern int kvmppc_book3s_hv_page_fault(struct kvm_run *run,
 			struct kvm_vcpu *vcpu, unsigned long addr,
 			unsigned long status);
+extern unsigned long kvmppc_hv_get_hash_value(struct kvm_hpt_info *hpt,
+					      gva_t eaddr, unsigned long slb_v,
+					      unsigned long *avpn,
+					      unsigned int *pshift_p);
 extern long kvmppc_hv_find_lock_hpte(struct kvm_hpt_info *hpt, gva_t eaddr,
 			unsigned long slb_v, unsigned long valid);
 extern int kvmppc_hv_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index c874ab3a037e..0db673501110 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -369,6 +369,15 @@ static inline unsigned long hpte_make_readonly(unsigned long ptel)
 	return ptel;
 }
 
+static inline unsigned long hpte_make_writable(unsigned long ptel)
+{
+	if ((ptel & HPTE_R_PP0) || (ptel & HPTE_R_PP) == PP_RWXX)
+		ptel = (ptel & ~HPTE_R_PPP) | PP_RWXX;
+	else
+		ptel = (ptel & ~HPTE_R_PP) | PP_RWRW;
+	return ptel;
+}
+
 static inline bool hpte_cache_flags_ok(unsigned long hptel, bool is_ci)
 {
 	unsigned int wimg = hptel & HPTE_R_WIMG;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 8ed50d4bd9a6..463745e535c5 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1026,6 +1026,16 @@ static inline u64 gpa_to_n_rmap(u64 gpa)
 		RMAP_NESTED_GPA_MASK;
 }
 
+static inline u64 n_rmap_to_index(u64 rmap)
+{
+	return (rmap & RMAP_NESTED_GPA_MASK) >> RMAP_NESTED_GPA_SHIFT;
+}
+
+static inline u64 index_to_n_rmap(u64 index)
+{
+	return (index << RMAP_NESTED_GPA_SHIFT) & RMAP_NESTED_GPA_MASK;
+}
+
 static inline int n_rmap_to_lpid(u64 rmap)
 {
 	return (int) ((rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT);
@@ -1817,12 +1827,385 @@ static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
 	return RESUME_GUEST;
 }
 
+/*
+ * Used to convert a hash nested guest virtual addr to a L1 guest real addr
+ * Returns pte index of pte which provided the translation
+ */
+static long kvmhv_xlate_addr_nested_hash(struct kvm_vcpu *vcpu,
+					 struct kvm_nested_guest *gp,
+					 u64 eaddr, u64 slb_v, bool data,
+					 bool writing, u64 *v_p, u64 *r_p)
+{
+	unsigned long v, v_mask, v_match, r, r_mask, r_match;
+	u64 flags = writing ? DSISR_ISSTORE : 0ULL;
+	int pshift, i, ret;
+	u64 hash, pp, key;
+	u64 pteg[16];
+
+	/* NOTE: All handling done in new ISA V3.0 hpte format */
+
+	/* Compute the hash */
+	hash = kvmppc_hv_get_hash_value(&gp->shadow_hpt, eaddr, slb_v, &v_match,
+					&pshift);
+	/* Bits which must match */
+	v_mask = HPTE_V_AVPN_3_0 | HPTE_V_SECONDARY | HPTE_V_VALID;
+	v_match |= HPTE_V_VALID;
+	if (slb_v & SLB_VSID_L) {
+		v_mask |= HPTE_V_LARGE;
+		v_match |= HPTE_V_LARGE;
+	}
+	r_mask = HPTE_R_B;
+	r_match = (slb_v & SLB_VSID_B_1T) ? HPTE_R_B_1T : 0ULL;
+
+	/*
+	 * Read the pteg from L1 guest memory and search for a matching pte.
+	 * Note: No need to lock the pte since we hold the tlb_lock meaning
+	 * that L1 can't complete a tlbie and change the pte out from under us.
+	 */
+	while (true) {
+		u64 pteg_addr = (gp->l1_gr_to_hr & PATB_HTABORG) + (hash << 7);
+
+		ret = kvm_vcpu_read_guest(vcpu, pteg_addr, pteg, sizeof(pteg));
+		if (ret) {
+			flags |= DSISR_NOHPTE;
+			goto forward_to_l1;
+		}
+
+		for (i = 0; i < 16; i += 2) {
+			v = be64_to_cpu(pteg[i]) & ~HPTE_V_HVLOCK;
+			r = be64_to_cpu(pteg[i + 1]);
+
+			if (!((v ^ v_match) & v_mask) &&
+					!((r ^ r_match) & r_mask) &&
+					(kvmppc_hpte_base_page_shift(v, r) ==
+					 pshift))
+				goto match_found;
+		}
+
+		if (v_match & HPTE_V_SECONDARY) {
+			flags |= DSISR_NOHPTE;
+			goto forward_to_l1;
+		}
+		/* Try the secondary hash */
+		v_match |= HPTE_V_SECONDARY;
+		hash = hash ^ kvmppc_hpt_mask(&gp->shadow_hpt);
+	}
+
+match_found:
+	/* Match found - check the permissions */
+	pp = r & HPTE_R_PPP;
+	key = slb_v & (vcpu->arch.shregs.msr & MSR_PR ? SLB_VSID_KP :
+							SLB_VSID_KS);
+	if (!data) {		/* check execute permissions */
+		if (r & (HPTE_R_N | HPTE_R_G)) {
+			flags |= SRR1_ISI_N_OR_G;
+			goto forward_to_l1;
+		}
+		if (!hpte_read_permission(pp, key)) {
+			flags |= SRR1_ISI_PROT;
+			goto forward_to_l1;
+		}
+	} else if (writing) {	/* check write permissions */
+		if (!hpte_write_permission(pp, key)) {
+			flags |= DSISR_PROTFAULT;
+			goto forward_to_l1;
+		}
+	} else {		/* check read permissions */
+		if (!hpte_read_permission(pp, key)) {
+			flags |= DSISR_PROTFAULT;
+			goto forward_to_l1;
+		}
+	}
+
+	*v_p = v & ~HPTE_V_HVLOCK;
+	*r_p = r;
+	return (hash << 3) + (i >> 1);
+
+forward_to_l1:
+	vcpu->arch.fault_dsisr = flags;
+	if (!data) {
+		vcpu->arch.shregs.msr &= ~0x783f0000ul;
+		vcpu->arch.shregs.msr |= (flags & 0x783f0000ul);
+	}
+	return -1;
+}
+
+static long kvmhv_handle_nested_set_rc_hash(struct kvm_vcpu *vcpu,
+					    struct kvm_nested_guest *gp,
+					    unsigned long gpa, u64 index,
+					    u64 *gr, u64 *hr, bool writing)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 pgflags;
+	long ret;
+
+	pgflags = _PAGE_ACCESSED;
+	if (writing)
+		pgflags |= _PAGE_DIRTY;
+
+	/* Are the rc bits set in the L1 hash pte? */
+	if (pgflags & ~(*gr)) {
+		__be64 gr_be;
+		u64 addr = (gp->l1_gr_to_hr & PATB_HTABORG) + (index << 4);
+		addr += sizeof(*gr);	/* Writing second doubleword */
+
+		/* Update rc in the L1 guest pte */
+		(*gr) |= pgflags;
+		gr_be = cpu_to_be64(*gr);
+		ret = kvm_write_guest(kvm, addr, &gr_be, sizeof(gr_be));
+		if (ret)	/* Let the guest try again */
+			return -EINVAL;
+	}
+
+	/* Set the rc bit in the pte of our (L0) pgtable for the L1 guest */
+	spin_lock(&kvm->mmu_lock);
+	ret = kvmppc_hv_handle_set_rc(kvm, kvm->arch.pgtable, writing,
+				      gpa, kvm->arch.lpid);
+	spin_unlock(&kvm->mmu_lock);
+	if (!ret)		/* Let the guest try again */
+		return -EINVAL;
+
+	/* Set the rc bit in the pte of the shadow_hpt for the nest guest */
+	(*hr) |= pgflags;
+
+	return 0;
+}
+
 /* called with gp->tlb_lock held */
 static long int __kvmhv_nested_page_fault_hash(struct kvm_run *run,
 					       struct kvm_vcpu *vcpu,
 					       struct kvm_nested_guest *gp)
 {
-	return -EINVAL;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memory_slot *memslot;
+	struct rmap_nested *n_rmap;
+	unsigned long hpte[3] = { 0UL };
+	unsigned long mmu_seq;
+	unsigned long dsisr = vcpu->arch.fault_dsisr;
+	unsigned long ea = vcpu->arch.fault_dar;
+	long index = vcpu->arch.pgfault_index;
+	unsigned long psize, *rmapp;
+	bool data = vcpu->arch.trap == BOOK3S_INTERRUPT_H_DATA_STORAGE;
+	bool writing = data && (dsisr & DSISR_ISSTORE);
+	bool kvm_ro = false;
+	u64 gv = 0ULL, gr = 0ULL, hr = 0ULL;
+	u64 gpa, gfn, hpa;
+	int l1_shift, shift, req_perm, h_perm;
+	pte_t pte, *pte_p;
+	__be64 *hptep;
+	long int ret;
+
+	/*
+	 * 1. Translate to a L1 Guest Real Addr
+	 * If there was no existing entry (pgfault_index < 0) then we need to
+	 * search for the guest hpte in l1 memory.
+	 * If we found an entry in kvmppc_hpte_hv_fault() (pgfault_index >= 0)
+	 * then lock the hpte and check it hasn't changed. If it has (because
+	 * a tlbie has completed between then and now) let the guest try again.
+	 * If the entry is valid then we are coming in here to upgrade the write
+	 * permissions on an existing hpte which we mapped read only to avoid
+	 * setting the change bit, and now the guest is writing to it.
+	 * If the entry isn't valid (which means it's absent) then the
+	 * guest_rpte is still valid, we just made it absent when the host
+	 * paged out the underlying page which was used to back the guest memory
+	 * NOTE: Since the shadow_hpt was allocated the same size as the l1 hpt
+	 * the index is preserved giving a 1-to-1 mapping between the hash page
+	 * tables, this could be changed in future.
+	 */
+	if (index >= 0) {
+		hptep = (__be64 *)(gp->shadow_hpt.virt + (index << 4));
+
+		preempt_disable();
+		while (!try_lock_hpte(hptep, HPTE_V_HVLOCK))
+			cpu_relax();
+		hpte[0] = gv = be64_to_cpu(hptep[0]) & ~HPTE_V_HVLOCK;
+		hpte[1] = hr = be64_to_cpu(hptep[1]);
+		hpte[2] = gr = gp->shadow_hpt.rev[index].guest_rpte;
+		unlock_hpte(hptep, hpte[0]);
+		preempt_enable();
+
+		/* hpt modified under us? */
+		if (hpte[0] != hpte_old_to_new_v(vcpu->arch.pgfault_hpte[0]) ||
+		    hpte[1] != hpte_old_to_new_r(vcpu->arch.pgfault_hpte[0],
+						 vcpu->arch.pgfault_hpte[1]))
+			return RESUME_GUEST;	/* Let the guest try again */
+	} else {
+		/* Note: fault_gpa was used to store the slb_v entry */
+		index = kvmhv_xlate_addr_nested_hash(vcpu, gp, ea,
+						     vcpu->arch.fault_gpa, data,
+						     writing, &gv, &gr);
+		if (index < 0)
+			return RESUME_HOST;
+		hptep = (__be64 *)(gp->shadow_hpt.virt + (index << 4));
+	}
+	l1_shift = kvmppc_hpte_actual_page_shift(gv, gr);
+	psize = (1UL << l1_shift);
+	gfn = (gr & HPTE_R_RPN_3_0 & ~(psize - 1)) >> PAGE_SHIFT;
+	gpa = (gfn << PAGE_SHIFT) | (ea & (psize - 1));
+
+	/* 2. Find the host memslot */
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot || (memslot->flags & KVM_MEMSLOT_INVALID)) {
+		/* passthrough of emulated MMIO case */
+		pr_err("emulated MMIO passthrough?\n");
+		return -EINVAL;
+	}
+	if (memslot->flags & KVM_MEM_READONLY) {
+		if (writing) {
+			/* Give the guest a DSI */
+			kvmhv_inject_nested_storage_int(vcpu, data, ea, writing,
+							DSISR_PROTFAULT);
+			return RESUME_GUEST;
+		}
+		kvm_ro = true;
+	}
+
+	/* 3. Translate to a L0 Host Real Address through the L0 page table */
+
+	/* Used to check for invalidations in progress */
+	mmu_seq = kvm->mmu_notifier_seq;
+	smp_rmb();
+
+	/* See if can find translation in our partition scoped tables for L1 */
+	if (!kvm->arch.radix) {
+		/* only support nested hpt guest under radix l1 guest */
+		pr_err("nested hpt guest only supported under radix guest\n");
+		return -EINVAL;
+	}
+	pte = __pte(0);
+	spin_lock(&kvm->mmu_lock);
+	pte_p = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	spin_unlock(&kvm->mmu_lock);
+
+	if (!shift)
+		shift = PAGE_SHIFT;
+	if (pte_p)
+		pte = *pte_p;
+
+	if (!pte_present(pte) || (writing && !(pte_val(pte) & _PAGE_WRITE))) {
+		int level;
+		/* No suitable pte found -> try to insert a mapping */
+		ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot,
+						writing, kvm_ro, &pte, &level);
+		if (ret == -EAGAIN)
+			return RESUME_GUEST;
+		else if (ret)
+			return ret;
+		shift = kvmppc_radix_level_to_shift(level);
+	}
+
+	if (shift < l1_shift)	/* Don't support L1 using larger page than us */
+		return -EINVAL;
+	if (!hpte_cache_flags_ok(gr, pte_ci(pte)))
+		return -EINVAL;
+	hpa = pte_pfn(pte) << PAGE_SHIFT;
+	/* Align gfn to the start of the page */
+	gfn = (gpa & ~((1UL << shift) - 1)) >> PAGE_SHIFT;
+
+	/* 4. Compute the PTE we're going to insert */
+
+	if (!hr) {	/* Not an existing entry */
+		hr = gr & ~HPTE_R_RPN_3_0;	/* Copy everything except rpn */
+		hr |= ((psize - HPTE_R_KEY_BIT2) & gr);	/* psize encoding */
+		hr |= (hpa & HPTE_R_RPN_3_0 & ~((1UL << shift) - 1));
+		if (shift > l1_shift)	/* take some bits from the gpa */
+			hr |= (gpa & ((1UL << shift) - psize));
+	}
+
+	/* Limit permissions based on the L0 pte */
+	req_perm = data ? (writing ? (_PAGE_READ | _PAGE_WRITE) : _PAGE_READ)
+			: _PAGE_EXEC;
+	h_perm = (pte_val(pte) & _PAGE_READ) ? _PAGE_READ : 0;
+	h_perm |= (pte_val(pte) & _PAGE_WRITE) ? (_PAGE_READ |
+						 (kvm_ro ? 0 : _PAGE_WRITE))
+					       : 0;
+	h_perm |= (pte_val(pte) & _PAGE_EXEC) ? _PAGE_EXEC : 0;
+	if (req_perm & ~h_perm) {
+		/* host doesn't provide a required permission -> dsi to guest */
+		kvmhv_inject_nested_storage_int(vcpu, data, ea, writing,
+						DSISR_PROTFAULT);
+		return RESUME_GUEST;
+	}
+	if (!(h_perm & _PAGE_EXEC))	/* Make page no execute */
+		hr |= HPTE_R_N;
+	if (!(h_perm & _PAGE_WRITE)) {	/* Make page no write */
+		hr = hpte_make_readonly(hr);
+		writing = 0;
+	} else if (!writing) {
+		/*
+		 * Make page no write so we can defer setting the change bit.
+		 * If the guest writes to the page we'll come back in to
+		 * upgrade the permissions and set the change bit then.
+		 */
+		hr = hpte_make_readonly(hr);
+	} else {	/* _PAGE_WRITE && writing */
+		hr = hpte_make_writable(hr);
+	}
+
+	/* 5. Update rc bits if required */
+
+	ret = kvmhv_handle_nested_set_rc_hash(vcpu, gp, gpa, index, &gr, &hr,
+					      writing);
+	if (ret)
+		return RESUME_GUEST;		/* Let the guest try again */
+
+	/* 6. Generate the nest rmap */
+
+	n_rmap = kzalloc(sizeof(*n_rmap), GFP_KERNEL);
+	if (!n_rmap)				/* Let the guest try again */
+		return RESUME_GUEST;
+	n_rmap->rmap = index_to_n_rmap(index) | lpid_to_n_rmap(gp->l1_lpid);
+	rmapp = &memslot->arch.rmap[gfn - memslot->base_gfn];
+
+	/* 7. Insert the PTE */
+
+	/* Check if we might have been invalidated; let the guest retry if so */
+	spin_lock(&kvm->mmu_lock);
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_free;
+
+	/* Lock the hpte */
+	preempt_disable();
+	while (!try_lock_hpte(hptep, HPTE_V_HVLOCK))
+		cpu_relax();
+
+	/* Check that the entry hasn't been changed out from under us */
+	if ((be64_to_cpu(hptep[0]) & ~HPTE_V_HVLOCK) != hpte[0] ||
+	     be64_to_cpu(hptep[1]) != hpte[1] ||
+	     gp->shadow_hpt.rev[index].guest_rpte != hpte[2])
+		goto out_unlock;		/* Let the guest try again */
+
+	/* Ensure valid bit set in hpte */
+	gv = (gv & ~HPTE_V_ABSENT) | HPTE_V_VALID;
+
+	if (be64_to_cpu(hptep[0]) & HPTE_V_VALID) {
+		/* HPTE was previously valid, so we need to invalidate it */
+		hptep[0] |= cpu_to_be64(HPTE_V_ABSENT);
+		kvmppc_invalidate_hpte(gp->shadow_lpid, hptep, index);
+	}
+
+	/* Insert the rmap entry */
+	kvmhv_insert_nest_rmap(rmapp, &n_rmap);
+
+	/* Always update guest_rpte in case we updated rc bits */
+	gp->shadow_hpt.rev[index].guest_rpte = gr;
+
+	hptep[1] = cpu_to_be64(hr);
+	eieio();
+	__unlock_hpte(hptep, gv);
+	preempt_enable();
+
+out_free:
+	spin_unlock(&kvm->mmu_lock);
+	if (n_rmap)
+		kfree(n_rmap);
+	return RESUME_GUEST;
+
+out_unlock:
+	__unlock_hpte(hptep, be64_to_cpu(hptep[0]));
+	preempt_enable();
+	goto out_free;
 }
 
 long int kvmhv_nested_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index c8a379a6f533..3c01957acb0e 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -1195,6 +1195,7 @@ unsigned long kvmppc_hv_get_hash_value(struct kvm_hpt_info *hpt, gva_t eaddr,
 
 	return hash;
 }
+EXPORT_SYMBOL_GPL(kvmppc_hv_get_hash_value);
 
 /* When called from virtmode, this func should be protected by
  * preempt_disable(), otherwise, the holding of HPTE_V_HVLOCK
@@ -1291,8 +1292,11 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 
 	hpt = &kvm->arch.hpt;
 	nested = vcpu->arch.nested;
-	if (nested)
+	if (nested) {
 		hpt = &nested->shadow_hpt;
+		/* reuse fault_gpa field to save slb for nested pgfault funcn */
+		vcpu->arch.fault_gpa = slb_v;
+	}
 
 	/* For protection fault, expect to find a valid HPTE */
 	valid = HPTE_V_VALID;
-- 
2.13.6

