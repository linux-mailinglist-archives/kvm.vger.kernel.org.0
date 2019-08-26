Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5B9C943
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfHZGVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46382 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbfHZGVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id q139so11085755pfc.13;
        Sun, 25 Aug 2019 23:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5hEp6WXNWIZb4gRP3rCXn6tfMz3bcWa5NODAHhj43HU=;
        b=Q5/5PIXRafRDQCt5bPW7DjRkPriTJkjemDYNhQYfkdJs1owHPO8EDZzUuAOC3DQajt
         ddv2x9Fo4nM2OfhLcjQZnVJWfY8+3BZOmB5y+ulL6U1gW99AyOU2zj0668NSb+PcKWTQ
         maoscHEF+WDInVWpwTfF+b2X2x5eL0efGeTB9MiVm+s0/b83E1E6SqzaTYYHaCvq9eL4
         mbESmXGVz7/l9E2aKYgaxu4e7I1B5kgR7m6xRsOfJSYEL87nLm4IFGP5qBxXxGbcd0Ae
         HQt+tZVdhBMbAwGa9cb3uMhW9iuqkpPZ+lKYtpIDmgg0DR/XboaczsPl+lNgUFwDctON
         2C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5hEp6WXNWIZb4gRP3rCXn6tfMz3bcWa5NODAHhj43HU=;
        b=TlBCHTR6BeCEwRmtZNHMCruKGbnxQOhodh92wA+R8wh8qMd75N7KLN0ROdjC+LuYj7
         T33Vw6AzfYRKGgLTmnBpFJddMtDnfaykohyrfTgME24Y2brJDihZcnx7NRtqwsLEC6TR
         siYh4p6ShtIV0uoRjAzq+98s6vkPAB3F+4aYrWEiRgHY82mkU6xGFEXvCP8ZlAb9ky/B
         FV3MPyH+FxaouQYp2z1/klF5/Y3adWuzz2SHY9jdJDNyMIfBslPdEMEHL0M5fNpI4I6T
         pRASnOwYAqxp5JamnUp278F1zqfIc7v6LdgT/5n4V3sS0DZwomLIJbx9IdPS8HlAhNvi
         7+dw==
X-Gm-Message-State: APjAAAXjtImgIoHbKp4ULCMdetfB9vWRurNPXMRMp8ikVn5pW70CVD2s
        W3B2ChqSHt4tNBEj96M3HgEeJGd5CLM=
X-Google-Smtp-Source: APXvYqzCoUISCTlHYKN8jxPMizmsZnC+1gVQ1zKhEc1ltth4m01vV7kX3ZcODvoZ51fjD+lB5PhkYw==
X-Received: by 2002:a63:20a:: with SMTP id 10mr14793930pgc.226.1566800507465;
        Sun, 25 Aug 2019 23:21:47 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:47 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 13/23] KVM: PPC: Book3S HV: Nested: Infrastructure for nested hpt guest setup
Date:   Mon, 26 Aug 2019 16:20:59 +1000
Message-Id: <20190826062109.7573-14-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the infrastructure to book3s_hv_nested.c to allow a nested hpt (hash
page table) guest to be setup. As this patch doesn't add the capability
of creating or removing mmu translations return H_PARAMETER when an
attempt to actually run a nested hpt guest is made.

Add fields to the nested guest struct to store the hpt and the vrma slb
entry.

Update kvmhv_update_ptbl_cache() to determine when a nested guest is
switching from radix to hpt or hpt to radix and perform the required
setup. A page table (radix) or hpt (hash) must be allocated with any
existing table being freed and the radix field in the nested guest
struct being updated under the mmu_lock (this means that when holding
the mmu_lock the radix field can be tested and the existance of the
correct type of page table guaranteed). Also remove all of the nest rmap
entries which belong to this nested guest since a nested rmap entry is
specific to whether the nested guest is hash or radix.

When a nested guest is initially created or when the partition table
entry is empty we assume a radix guest since it is much less expensive
to allocate a radix page table compared to a hpt.

The hpt which is allocated in the hypervisor for the nested guest
(called the shadow hpt) is identical in size to the one allocated in the
guest hypervisor to ensure a 1-to-1 mapping between page table entries.
This simplifies handling of the entries however this requirement could
be relaxed in future if support was added.

Introduce a hash nested_page_fault function to be envoked when the
nested guest which experiences a page fault is hash, returns -EINVAL for
now. Also return -EINVAL when handling the H_TLB_INVALIDATE hcall. Also
lacking support for the hypervisor paging out a guest page which has
been mapped through to a nested guest. These 3 portions of functionality
added in proceeding patches.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/mmu-hash.h |   2 +
 arch/powerpc/include/asm/book3s/64/mmu.h      |   9 +
 arch/powerpc/include/asm/kvm_book3s_64.h      |   4 +-
 arch/powerpc/kvm/book3s_hv_nested.c           | 255 ++++++++++++++++++++++----
 4 files changed, 235 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu-hash.h b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
index 15b75005bc34..c04e37b2c30d 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -45,12 +45,14 @@
 #define SLB_VSID_KP		ASM_CONST(0x0000000000000400)
 #define SLB_VSID_N		ASM_CONST(0x0000000000000200) /* no-execute */
 #define SLB_VSID_L		ASM_CONST(0x0000000000000100)
+#define SLB_VSID_L_SHIFT	8
 #define SLB_VSID_C		ASM_CONST(0x0000000000000080) /* class */
 #define SLB_VSID_LP		ASM_CONST(0x0000000000000030)
 #define SLB_VSID_LP_00		ASM_CONST(0x0000000000000000)
 #define SLB_VSID_LP_01		ASM_CONST(0x0000000000000010)
 #define SLB_VSID_LP_10		ASM_CONST(0x0000000000000020)
 #define SLB_VSID_LP_11		ASM_CONST(0x0000000000000030)
+#define SLB_VSID_LP_SHIFT	4
 #define SLB_VSID_LLP		(SLB_VSID_L|SLB_VSID_LP)
 
 #define SLB_VSID_KERNEL		(SLB_VSID_KP)
diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/include/asm/book3s/64/mmu.h
index 23b83d3593e2..8c02e40f1125 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu.h
@@ -62,6 +62,7 @@ struct patb_entry {
 extern struct patb_entry *partition_tb;
 
 /* Bits in patb0 field */
+/* Radix */
 #define PATB_HR		(1UL << 63)
 #define RPDB_MASK	0x0fffffffffffff00UL
 #define RPDB_SHIFT	(1UL << 8)
@@ -70,6 +71,14 @@ extern struct patb_entry *partition_tb;
 #define RTS2_SHIFT	5		/* bottom 3 bits of radix tree size */
 #define RTS2_MASK	(7UL << RTS2_SHIFT)
 #define RPDS_MASK	0x1f		/* root page dir. size field */
+/* Hash */
+#define PATB_HTABORG	0x0ffffffffffc0000UL	/* hpt base */
+#define PATB_PS		0xe0			/* page size */
+#define PATB_PS_L	0x80
+#define PATB_PS_L_SHIFT	7
+#define PATB_PS_LP	0x60
+#define PATB_PS_LP_SHIFT	5
+#define PATB_HTABSIZE	0x1f			/* hpt size */
 
 /* Bits in patb1 field */
 #define PATB_GR		(1UL << 63)	/* guest uses radix; must match HR */
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 410e609efd37..c874ab3a037e 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -35,7 +35,9 @@ struct kvm_nested_guest {
 	struct kvm *l1_host;		/* L1 VM that owns this nested guest */
 	int l1_lpid;			/* lpid L1 guest thinks this guest is */
 	int shadow_lpid;		/* real lpid of this nested guest */
-	pgd_t *shadow_pgtable;		/* our page table for this guest */
+	pgd_t *shadow_pgtable;		/* page table for this guest if radix */
+	struct kvm_hpt_info shadow_hpt;	/* hpt for this guest if hash */
+	u64 vrma_slb_v;			/* vrma slb for this guest if hash */
 	u64 l1_gr_to_hr;		/* L1's addr of part'n-scoped table */
 	u64 process_table;		/* process table entry for this guest */
 	long refcnt;			/* number of pointers to this struct */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 58a5de2aa2af..82690eafee77 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -23,6 +23,7 @@
 static struct patb_entry *pseries_partition_tb;
 
 static void kvmhv_update_ptbl_cache(struct kvm_nested_guest *gp);
+static void kvmhv_remove_all_nested_rmap_lpid(struct kvm *kvm, int lpid);
 static void kvmhv_free_memslot_nest_rmap(struct kvm_memory_slot *free);
 
 void kvmhv_save_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
@@ -247,6 +248,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
 	u64 mask;
 	unsigned long lpcr;
+	u8 radix;
 
 	if (vcpu->kvm->arch.l1_ptcr == 0)
 		return H_NOT_AVAILABLE;
@@ -282,6 +284,25 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		mutex_unlock(&l2->tlb_lock);
 	}
 
+	mutex_lock(&l2->tlb_lock);
+	radix = l2->radix;
+	mutex_unlock(&l2->tlb_lock);
+	/* some lpcr sanity checking */
+	if (radix) {
+		/* radix requires gtse and uprt */
+		if ((~l2_hv.lpcr & LPCR_HR) || (~l2_hv.lpcr & LPCR_GTSE) ||
+					       (~l2_hv.lpcr & LPCR_UPRT) ||
+					       (l2_hv.lpcr & LPCR_VPM1))
+			return H_PARAMETER;
+	} else {
+		return H_PARAMETER;
+		/* hpt doesn't support gtse or uprt and required vpm */
+		if ((l2_hv.lpcr & LPCR_HR) || (l2_hv.lpcr & LPCR_GTSE) ||
+					      (l2_hv.lpcr & LPCR_UPRT) ||
+					      (~l2_hv.lpcr & LPCR_VPM1))
+			return H_PARAMETER;
+	}
+
 	/* save l1 values of things */
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
 	saved_l1_regs = vcpu->arch.regs;
@@ -297,7 +318,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs = l2_regs;
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
+		LPCR_LPES | LPCR_MER | LPCR_HR | LPCR_GTSE | LPCR_UPRT |
+		LPCR_VPM1;
 	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
@@ -413,16 +435,26 @@ void kvmhv_nested_exit(void)
 	}
 }
 
-static void kvmhv_flush_lpid(unsigned int lpid)
+/*
+ * Flushes the partition scoped translations of a given lpid.
+ */
+static void kvmhv_flush_lpid(unsigned int lpid, bool radix)
 {
 	long rc;
 
 	if (!kvmhv_on_pseries()) {
-		radix__flush_tlb_lpid(lpid);
+		if (radix) {
+			radix__flush_tlb_lpid(lpid);
+		} else {
+			asm volatile("ptesync": : :"memory");
+			asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
+				     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
+			asm volatile("eieio; tlbsync; ptesync": : :"memory");
+		}
 		return;
 	}
 
-	rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(2, 0, 1),
+	rc = plpar_hcall_norets(H_TLB_INVALIDATE, H_TLBIE_P1_ENC(2, 0, radix),
 				lpid, TLBIEL_INVAL_SET_LPID);
 	if (rc)
 		pr_err("KVM: TLB LPID invalidation hcall failed, rc=%ld\n", rc);
@@ -430,23 +462,43 @@ static void kvmhv_flush_lpid(unsigned int lpid)
 
 void kvmhv_set_ptbl_entry(unsigned int lpid, u64 dw0, u64 dw1)
 {
+	bool radix;
+
 	if (!kvmhv_on_pseries()) {
 		mmu_partition_table_set_entry(lpid, dw0, dw1);
 		return;
 	}
 
+	/* radix flag based on old entry */
+	radix = !!(be64_to_cpu(pseries_partition_tb[lpid].patb0) & PATB_HR);
 	pseries_partition_tb[lpid].patb0 = cpu_to_be64(dw0);
 	pseries_partition_tb[lpid].patb1 = cpu_to_be64(dw1);
 	/* L0 will do the necessary barriers */
-	kvmhv_flush_lpid(lpid);
+	kvmhv_flush_lpid(lpid, radix);
+}
+
+static inline int kvmhv_patb_get_hpt_order(u64 patb0)
+{
+	return (patb0 & PATB_HTABSIZE) + 18;
+}
+
+static inline u64 kvmhv_patb_get_htab_size(int order)
+{
+	return (order - 18) & PATB_HTABSIZE;
 }
 
 static void kvmhv_set_nested_ptbl(struct kvm_nested_guest *gp)
 {
 	unsigned long dw0;
 
-	dw0 = PATB_HR | radix__get_tree_size() |
-		__pa(gp->shadow_pgtable) | RADIX_PGD_INDEX_SIZE;
+	if (gp->radix) {
+		dw0 = PATB_HR | radix__get_tree_size() |
+			__pa(gp->shadow_pgtable) | RADIX_PGD_INDEX_SIZE;
+	} else {
+		dw0 = (PATB_HTABORG & __pa(gp->shadow_hpt.virt)) |
+			(PATB_PS & gp->l1_gr_to_hr) |
+			kvmhv_patb_get_htab_size(gp->shadow_hpt.order);
+	}
 	kvmhv_set_ptbl_entry(gp->shadow_lpid, dw0, gp->process_table);
 }
 
@@ -521,6 +573,15 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&gp->tlb_lock);
 
+	if (!gp->radix) {
+		/*
+		 * Currently quadrants are the only way to read nested guest
+		 * memory, which is only valid for a radix guest.
+		 */
+		rc = H_PARAMETER;
+		goto out_unlock;
+	}
+
 	if (is_load) {
 		/* Load from the nested guest into our buffer */
 		rc = __kvmhv_copy_tofrom_guest_radix(gp->shadow_lpid, pid,
@@ -556,6 +617,69 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 	goto out_unlock;
 }
 
+/* Caller must hold gp->tlb_lock */
+static int kvmhv_switch_to_radix_nested(struct kvm_nested_guest *gp)
+{
+	struct kvm *kvm = gp->l1_host;
+	pgd_t *pgtable;
+
+	/* try to allocate a radix tree */
+	pgtable = pgd_alloc(kvm->mm);
+	if (!pgtable) {
+		pr_err_ratelimited("KVM: Couldn't alloc nested radix tree\n");
+		return -ENOMEM;
+	}
+
+	/* mmu_lock protects shadow_hpt & radix in nested guest struct */
+	spin_lock(&kvm->mmu_lock);
+	kvmppc_free_hpt(&gp->shadow_hpt);
+	gp->radix = 1;
+	gp->shadow_pgtable = pgtable;
+	spin_unlock(&kvm->mmu_lock);
+
+	/* remove all nested rmap entries and perform global invalidation */
+	kvmhv_remove_all_nested_rmap_lpid(kvm, gp->l1_lpid);
+	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
+
+	return 0;
+}
+
+/* Caller must hold gp->tlb_lock */
+static int kvmhv_switch_to_hpt_nested(struct kvm_nested_guest *gp, int order)
+{
+	struct kvm *kvm = gp->l1_host;
+	struct kvm_hpt_info info;
+	int rc;
+
+	/* try to allocate an hpt */
+	rc = kvmppc_allocate_hpt(&info, order);
+	if (rc) {
+		pr_err_ratelimited("KVM: Couldn't alloc nested hpt\n");
+		return rc;
+	}
+
+	/* mmu_lock protects shadow_pgtable & radix in nested guest struct */
+	spin_lock(&kvm->mmu_lock);
+	kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable, gp->shadow_lpid);
+	pgd_free(kvm->mm, gp->shadow_pgtable);
+	gp->shadow_pgtable = NULL;
+	gp->radix = 0;
+	gp->shadow_hpt = info;
+	spin_unlock(&kvm->mmu_lock);
+
+	/* remove all nested rmap entries and perform global invalidation */
+	kvmhv_remove_all_nested_rmap_lpid(kvm, gp->l1_lpid);
+	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
+
+	return 0;
+}
+
+static inline u64 kvmhv_patb_ps_to_slb_llp(u64 patb)
+{
+	return (((patb & PATB_PS_L) >> PATB_PS_L_SHIFT) << SLB_VSID_L_SHIFT) |
+	       (((patb & PATB_PS_LP) >> PATB_PS_LP_SHIFT) << SLB_VSID_LP_SHIFT);
+}
+
 /*
  * Reload the partition table entry for a guest.
  * Caller must hold gp->tlb_lock.
@@ -567,23 +691,48 @@ static void kvmhv_update_ptbl_cache(struct kvm_nested_guest *gp)
 	unsigned long ptbl_addr;
 	struct kvm *kvm = gp->l1_host;
 
+	gp->l1_gr_to_hr = 0;
+	gp->process_table = 0;
 	ret = -EFAULT;
 	ptbl_addr = (kvm->arch.l1_ptcr & PRTB_MASK) + (gp->l1_lpid << 4);
 	if (gp->l1_lpid < (1ul << ((kvm->arch.l1_ptcr & PRTS_MASK) + 8)))
 		ret = kvm_read_guest(kvm, ptbl_addr,
 				     &ptbl_entry, sizeof(ptbl_entry));
-	if (ret) {
-		gp->l1_gr_to_hr = 0;
-		gp->process_table = 0;
-	} else {
-		gp->l1_gr_to_hr = be64_to_cpu(ptbl_entry.patb0);
-		gp->process_table = be64_to_cpu(ptbl_entry.patb1);
+	if (!ret) {
+		u64 patb0 = be64_to_cpu(ptbl_entry.patb0);
+		u64 process_table = be64_to_cpu(ptbl_entry.patb1);
+
+		if (patb0) {
+			bool radix = !!(patb0 & PATB_HR);
+
+			if (radix && !gp->radix)
+				ret = kvmhv_switch_to_radix_nested(gp);
+			else if (!radix && gp->radix)
+				ret = kvmhv_switch_to_hpt_nested(gp,
+					kvmhv_patb_get_hpt_order(patb0));
+			if (!ret) {
+				gp->l1_gr_to_hr = patb0;
+				gp->process_table = process_table;
+				if (!radix) { /* update vrma slb_v */
+					u64 senc;
+
+					senc = kvmhv_patb_ps_to_slb_llp(patb0);
+					gp->vrma_slb_v = senc | SLB_VSID_B_1T |
+						(VRMA_VSID << SLB_VSID_SHIFT_1T);
+				}
+			}
+		}
 	}
 	kvmhv_set_nested_ptbl(gp);
 }
 
 struct kvm_nested_guest *kvmhv_alloc_nested(struct kvm *kvm, unsigned int lpid)
 {
+	/*
+	 * Allocate the state for a nested guest.
+	 * Note: assume radix to avoid allocating a hpt when not necessary as
+	 * this can consume a large amount of contiguous memory in the host.
+	 */
 	struct kvm_nested_guest *gp;
 	long shadow_lpid;
 
@@ -620,15 +769,17 @@ static void kvmhv_release_nested(struct kvm_nested_guest *gp)
 {
 	struct kvm *kvm = gp->l1_host;
 
-	if (gp->shadow_pgtable) {
-		/*
-		 * No vcpu is using this struct and no call to
-		 * kvmhv_get_nested can find this struct,
-		 * so we don't need to hold kvm->mmu_lock.
-		 */
+	/*
+	 * No vcpu is using this struct and no call to
+	 * kvmhv_get_nested can find this struct,
+	 * so we don't need to hold kvm->mmu_lock.
+	 */
+	if (gp->radix && gp->shadow_pgtable) {
 		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
 					  gp->shadow_lpid);
 		pgd_free(kvm->mm, gp->shadow_pgtable);
+	} else if ((!gp->radix) && gp->shadow_hpt.virt) {
+		kvmppc_free_hpt(&gp->shadow_hpt);
 	}
 	kvmhv_set_ptbl_entry(gp->shadow_lpid, 0, 0);
 	kvmppc_free_lpid(gp->shadow_lpid);
@@ -701,9 +852,18 @@ static void kvmhv_flush_nested(struct kvm_nested_guest *gp)
 	struct kvm *kvm = gp->l1_host;
 
 	spin_lock(&kvm->mmu_lock);
-	kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable, gp->shadow_lpid);
+	if (gp->radix) {
+		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
+					  gp->shadow_lpid);
+	} else {
+		memset((void *) gp->shadow_hpt.virt, 0,
+			1UL << gp->shadow_hpt.order);
+		memset((void *) gp->shadow_hpt.rev, 0,
+			(1UL << (gp->shadow_hpt.order - 4)) *
+			sizeof(struct revmap_entry));
+	}
 	spin_unlock(&kvm->mmu_lock);
-	kvmhv_flush_lpid(gp->shadow_lpid);
+	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
 	kvmhv_update_ptbl_cache(gp);
 	if (gp->l1_gr_to_hr == 0)
 		kvmhv_remove_nested(gp);
@@ -887,7 +1047,10 @@ static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 		return;
 
 	/* Find the pte */
-	ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	if (gp->radix)
+		ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	else
+		ptep = NULL;	/* XXX TODO */
 	/*
 	 * If the pte is present and the pfn is still the same, update the pte.
 	 * If the pfn has changed then this is a stale rmap entry, the nested
@@ -944,7 +1107,10 @@ static void kvmhv_invalidate_nest_rmap(struct kvm *kvm, u64 n_rmap,
 		return;
 
 	/* Find and invalidate the pte */
-	ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	if (gp->radix)
+		ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	else
+		ptep = NULL;	/* XXX TODO */
 	/* Don't spuriously invalidate ptes if the pfn has changed */
 	if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) == hpa))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL, gp->shadow_lpid);
@@ -1012,9 +1178,9 @@ static void kvmhv_free_memslot_nest_rmap(struct kvm_memory_slot *free)
 	}
 }
 
-static bool kvmhv_invalidate_shadow_pte(struct kvm_vcpu *vcpu,
-					struct kvm_nested_guest *gp,
-					long gpa, int *shift_ret)
+static bool kvmhv_invalidate_shadow_pte_radix(struct kvm_vcpu *vcpu,
+					      struct kvm_nested_guest *gp,
+					      long gpa, int *shift_ret)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool ret = false;
@@ -1079,6 +1245,7 @@ static int kvmhv_emulate_tlbie_tlb_addr(struct kvm_vcpu *vcpu, int lpid,
 	long npages;
 	int shift, shadow_shift;
 	unsigned long addr;
+	int rc = 0;
 
 	shift = ap_to_shift(ap);
 	addr = epn << 12;
@@ -1094,17 +1261,25 @@ static int kvmhv_emulate_tlbie_tlb_addr(struct kvm_vcpu *vcpu, int lpid,
 		return 0;
 	mutex_lock(&gp->tlb_lock);
 
+	/* XXX TODO hpt */
+	if (!gp->radix) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
 	/* There may be more than one host page backing this single guest pte */
 	do {
-		kvmhv_invalidate_shadow_pte(vcpu, gp, addr, &shadow_shift);
+		kvmhv_invalidate_shadow_pte_radix(vcpu, gp, addr,
+						  &shadow_shift);
 
 		npages -= 1UL << (shadow_shift - PAGE_SHIFT);
 		addr += 1UL << shadow_shift;
 	} while (npages > 0);
 
+out_unlock:
 	mutex_unlock(&gp->tlb_lock);
 	kvmhv_put_nested(gp);
-	return 0;
+	return rc;
 }
 
 static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
@@ -1112,6 +1287,7 @@ static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
 {
 	struct kvm *kvm = vcpu->kvm;
 
+	/* XXX TODO hpt */
 	mutex_lock(&gp->tlb_lock);
 	switch (ric) {
 	case 0:
@@ -1119,8 +1295,8 @@ static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
 		spin_lock(&kvm->mmu_lock);
 		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
 					  gp->shadow_lpid);
-		kvmhv_flush_lpid(gp->shadow_lpid);
 		spin_unlock(&kvm->mmu_lock);
+		kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
 		break;
 	case 1:
 		/*
@@ -1358,9 +1534,9 @@ static inline int kvmppc_radix_shift_to_level(int shift)
 }
 
 /* called with gp->tlb_lock held */
-static long int __kvmhv_nested_page_fault(struct kvm_run *run,
-					  struct kvm_vcpu *vcpu,
-					  struct kvm_nested_guest *gp)
+static long int __kvmhv_nested_page_fault_radix(struct kvm_run *run,
+						struct kvm_vcpu *vcpu,
+						struct kvm_nested_guest *gp)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memory_slot *memslot;
@@ -1524,17 +1700,28 @@ static long int __kvmhv_nested_page_fault(struct kvm_run *run,
 	return ret;
 
  inval:
-	kvmhv_invalidate_shadow_pte(vcpu, gp, n_gpa, NULL);
+	kvmhv_invalidate_shadow_pte_radix(vcpu, gp, n_gpa, NULL);
 	return RESUME_GUEST;
 }
 
+/* called with gp->tlb_lock held */
+static long int __kvmhv_nested_page_fault_hash(struct kvm_run *run,
+					       struct kvm_vcpu *vcpu,
+					       struct kvm_nested_guest *gp)
+{
+	return -EINVAL;
+}
+
 long int kvmhv_nested_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	struct kvm_nested_guest *gp = vcpu->arch.nested;
 	long int ret;
 
 	mutex_lock(&gp->tlb_lock);
-	ret = __kvmhv_nested_page_fault(run, vcpu, gp);
+	if (gp->radix)
+		ret = __kvmhv_nested_page_fault_radix(run, vcpu, gp);
+	else
+		ret = __kvmhv_nested_page_fault_hash(run, vcpu, gp);
 	mutex_unlock(&gp->tlb_lock);
 	return ret;
 }
-- 
2.13.6

