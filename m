Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4C19C953
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfHZGWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42190 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbfHZGWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id y1so9465993plp.9;
        Sun, 25 Aug 2019 23:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HUvk266kFnzOilMKwCLAapI0dXHSrJpztln/ktUFQZ8=;
        b=mWPS8YIF1vv9e1MW57XLXkdogy+FP/F24kADhnSEzCLMq/SJg1qKioEvhtGlF1A+xi
         86A6pO0Q2h/OwEgBmaiBlyBqIX75Mk7znTfCkHmXpG19LHGzVCmXTb6k8s57UEvzj5Kh
         ezWA0DdQUuVYqfgtQcnPQonNHvc2m3Jfwtplr+ZrH1DtRw7BUNab4dFvAwmmIYUlYLKp
         txIBCIlOQ/fqMzg8nBUfDfHn1WzydLMCL14TcxQgik40NIP6WH4J1C2WR5Z2DLx5g0tG
         0dolIhBGYyONBmdOxDxkLYnoHioRQaBfmXiPLraHvGXFLS9wj7xlrJ77Yc0Jfx0p7AVS
         FBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HUvk266kFnzOilMKwCLAapI0dXHSrJpztln/ktUFQZ8=;
        b=Mpu4p2uZrhbEyeWSqisG03DdPSDp5B8RXc8NdDBZNZCx039+H80n2PNX3UtXnTaCEV
         09HGuKxdtvAg9Zh8H+UphWUyApCnexwgEMneIbr3D7rsuMDQW67JBx7aLcaq2+2MFcgn
         Cmx/hvzZ2JqIA9dIP51hpjW/RpnrbO1//jIhW9HLgAZVehY21UyN3FzD36y18H8qhWBy
         IVc3a1GpvYFN/xGXz5SoC8BteAZZ1V7lGGMKfDfzcz0ZGl9IfHMIybFAYYVsTErqgq1m
         rYvVLAFE5OfM549GcnruteREr4+2xXwvwr/AMOnyC9CBpTBy4rl4Xin9LWEki8c5R+Xs
         5YYQ==
X-Gm-Message-State: APjAAAUgWijWooSPP5uTEkUcExU0vasGXOmFkcphVXLmECoC808tjcAu
        /szVDTO+HJxDWJDX9raT3gktTbq5Xu0=
X-Google-Smtp-Source: APXvYqztzo2Rmk0m51OdM4Y8u5MsbMiyn5N1x15Unfm14w0AhWQplLG6BHagUFxizdzr9JLp9Rg7bg==
X-Received: by 2002:a17:902:a507:: with SMTP id s7mr16712457plq.66.1566800524406;
        Sun, 25 Aug 2019 23:22:04 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.22.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:22:04 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 20/23] KVM: PPC: Book3S HV: Nested: Handle tlbie hcall for nested hpt guest
Date:   Mon, 26 Aug 2019 16:21:06 +1000
Message-Id: <20190826062109.7573-21-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The tlbie instruction is used to invalidate caching of translation
information derived from the partition and process scoped page tables.
This instruction is hypervisor privileged when specifying partition
scoped translations to be invalidated. Thus this interface is
paravirtualised with the H_TLB_INVALIDATE hcall which is used by a
pseries hypervisor to perform partition scoped invalidations. This is
then handled in the hypervisor in kvmhv_emulate_priv_tlbie().

When handling this hcall in the hypervisor it is necessary to invalidate
caching of partition scoped translations which are in the shadow page
table (radix) or shadow hpt (hash page table). This functionality
already exists for radix, so implement it for a hash guest.

LPID wide invalidations are already handled and don't differ from the
radix case. However the case where a single tlb entry corresponding to a
virtual address is being invalidated needs to be implemented here. The
information to find the entry is provided as an hcall argument and is
expected to match the layout of rb specified for the tlbie instruction.

The rb value provides an abbreviated virtual address, base and actual
page size and segment size to be used to search for the corresponding
tlb entry. A hash is computed and this is used to find the pteg which
needs to be searched. However since only 64 bits of the virtual address
are supplied and depending on the segment and hpt size up to all 78 bits
of the virtual address may be needed to compute the hash we have to mask
out the bits which can't be determined and iterate through all possible
combinations looking for a matching entry in all of the ptegs which are
addressed by all of the possible hash values. Although there is in theory a
1-to-1 relationship between ptes in the shadow hpt and the hpt
maintained by the guest hypervisor we need to invalidate all matches
since they can't be differentiated.

When a matching entry is found it is invalidated if it was valid and the
corresponding tlbie is issued by the hypervisor, irrespective the pte is
then zeroed. An optimisation here would be to just make the pte absent and
extend the rev map to store the host real doubleword since it is still
valid.

Note: ric == 3 (cluster bombs) are not supported even though the ISA
technically allows for them, their encoding is implemenatation dependant
and linux doesn't use them.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/book3s/64/mmu-hash.h |  11 +
 arch/powerpc/kvm/book3s_hv_nested.c           | 293 ++++++++++++++++++++++----
 2 files changed, 258 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/mmu-hash.h b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
index f33dcb84a0bf..70f4545fecbb 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -129,6 +129,17 @@
 #define TLBIEL_INVAL_SET_MASK	0xfff000	/* set number to inval. */
 #define TLBIEL_INVAL_SET_SHIFT	12
 
+/* Fields in the rb registers for the tlbie instruction */
+#define TLBIE_RB_AVA_4K		ASM_CONST(0xfffffffffffff000)
+#define TLBIE_RB_AVA_L		ASM_CONST(0xfffffffffff00000)
+#define TLBIE_RB_LP		ASM_CONST(0x00000000000ff000)
+#define TLBIE_RB_B		ASM_CONST(0x0000000000000300)
+#define TLBIE_RB_B_1T		ASM_CONST(0x0000000000000100)
+#define TLBIE_RB_B_SHIFT	50	/* Shift to match the pte location */
+#define TLBIE_RB_AVAL		ASM_CONST(0x00000000000000fe)
+#define TLBIE_RB_AVAL_SHIFT	12
+#define TLBIE_RB_L		ASM_CONST(0x0000000000000001)
+
 #define POWER7_TLB_SETS		128	/* # sets in POWER7 TLB */
 #define POWER8_TLB_SETS		512	/* # sets in POWER8 TLB */
 #define POWER9_TLB_SETS_HASH	256	/* # sets in POWER9 TLB Hash mode */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 463745e535c5..57add167115e 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -931,10 +931,10 @@ void kvmhv_release_all_nested(struct kvm *kvm)
 }
 
 /* caller must hold gp->tlb_lock */
-static void kvmhv_flush_nested(struct kvm_nested_guest *gp)
+static void kvmhv_flush_nested(struct kvm *kvm, struct kvm_nested_guest *gp,
+			       bool invalidate_ptbl)
 {
-	struct kvm *kvm = gp->l1_host;
-
+	/* Invalidate (zero) all entries in the shadow pgtable or shadow hpt */
 	spin_lock(&kvm->mmu_lock);
 	if (gp->radix) {
 		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
@@ -947,10 +947,15 @@ static void kvmhv_flush_nested(struct kvm_nested_guest *gp)
 			sizeof(struct revmap_entry));
 	}
 	spin_unlock(&kvm->mmu_lock);
+	/* remove all nested rmap entries and perform global invalidation */
+	kvmhv_remove_all_nested_rmap_lpid(kvm, gp->l1_lpid);
 	kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
-	kvmhv_update_ptbl_cache(gp);
-	if (gp->l1_gr_to_hr == 0)
-		kvmhv_remove_nested(gp);
+	/* was caching of the partition table entries also invalidated? */
+	if (invalidate_ptbl) {
+		kvmhv_update_ptbl_cache(gp);
+		if (gp->l1_gr_to_hr == 0)
+			kvmhv_remove_nested(gp);
+	}
 }
 
 struct kvm_nested_guest *kvmhv_get_nested(struct kvm *kvm, int l1_lpid,
@@ -1296,6 +1301,158 @@ static bool kvmhv_invalidate_shadow_pte_radix(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+/* Called with the hpte locked */
+static void kvmhv_invalidate_shadow_pte_hash(struct kvm_hpt_info *hpt,
+					     unsigned int lpid, __be64 *hptep,
+					     unsigned long index)
+{
+	hpt->rev[index].guest_rpte = 0UL;
+	if (hptep[0] & cpu_to_be64(HPTE_V_VALID)) {
+		/* HPTE was previously valid, so we need to invalidate it */
+		hptep[0] |= cpu_to_be64(HPTE_V_ABSENT);
+		kvmppc_invalidate_hpte(lpid, hptep, index);
+	}
+	hptep[1] = 0ULL;
+	eieio();
+	__unlock_hpte(hptep, 0UL);
+}
+
+/* Calculate hash given a virtual address, base page shift, and segment size */
+static unsigned long kvmppc_hv_get_hash_value_va(struct kvm_hpt_info *hpt,
+						 unsigned long va, int pshift,
+						 unsigned long b)
+{
+	unsigned long hash, somask;
+
+	if (b & HPTE_R_B_1T) {	/* 1T segment */
+		somask = (1UL << 40) - 1;
+		hash = va >> 40;
+		hash ^= hash << 25;
+	} else {		/* 256M segment */
+		somask = (1UL << 28) - 1;
+		hash = va >> 28;
+	}
+	hash ^= ((va & somask) >> pshift);
+	hash &= kvmppc_hpt_mask(hpt);
+
+	return hash;
+}
+
+/* called with gp->tlb_lock held */
+static void kvmhv_tlbie_hpt_addr(struct kvm_nested_guest *gp, unsigned long va,
+				 int base_pshift, int actual_pshift,
+				 unsigned long b)
+{
+	unsigned long mask, hash_incr, num, i;
+	struct kvm_hpt_info *hpt = &gp->shadow_hpt;
+	__be64 *hptep;
+	unsigned long hash, v, v_mask, v_match, r, r_mask, r_match;
+
+	hash = kvmppc_hv_get_hash_value_va(hpt, va, base_pshift, b);
+
+	/*
+	 * The virtual address provided to us in the rb register for tlbie is
+	 * bits 14:77 of the virtual address, however we support a 68 bit
+	 * virtual address on P9. This means that we actually need bits 10:77 of
+	 * the virtual address to calculate all possible hash values for a 68
+	 * bit virtual address space. This means that dependant on the size of
+	 * the hpt (and thus the number of hash bits we actually use to find
+	 * the pteg index) we might have to search up to 16 ptegs (1TB segs) or
+	 * 8 ptegs (256M segs) for a match.
+	 */
+	if (b & HPTE_R_B_1T) {	/* 1T segment */
+		/*
+		 * The hash when using 1T segments uses bits 0:37 of the VA.
+		 * Thus to cover the missing bits of the VA (bits 0:13) we need
+		 * to zero any of these bits being used (as determined by
+		 * kvmppc_hpt_mask()) and then search all possible values.
+		 */
+		hash_incr = 1UL << 24;
+		mask = (0x3ffUL << 24) & kvmppc_hpt_mask(hpt);
+		hash &= ~mask;
+		num = mask >> 24;
+	} else {		/* 256M segment */
+		/*
+		 * The hash when using 256M segments uses bits 11:49 of the VA.
+		 * Thus to cover the missing bits of the VA (bits 11:13) we need
+		 * to zero any of these bits being used (as determined by
+		 * kvmppc_hpt_mask()) and then search all possible values.
+		 */
+		hash_incr = 1UL << 36;
+		mask = (0x7UL << 36) & kvmppc_hpt_mask(hpt);
+		hash &= ~mask;
+		num = mask >> 36;
+	}
+
+	/* Calculate what we're going to match the hpte on */
+	v_match = va >> 16;	/* Align va to ava in the hpte */
+	if (base_pshift >= 24)
+		v_match &= ~((1UL << (base_pshift - 16)) - 1);
+	else
+		v_match &= ~0x7fUL;
+	if (actual_pshift > 12)
+		v_match |= HPTE_V_LARGE;
+	r_match = b;
+	/* We don't have the top 4 bits of the ava to match on */
+	v_mask = (TLBIE_RB_AVA_4K >> 16) & HPTE_V_AVPN_3_0;
+	v_mask |= HPTE_V_LARGE | HPTE_V_SECONDARY;
+	r_mask = HPTE_R_B;
+
+	/* Iterate through the ptegs which we have to search */
+	for (i = 0; i <= num; i++, hash += hash_incr) {
+		unsigned long pteg_addr = hash << 7;
+		v_match &= ~HPTE_V_SECONDARY;
+
+		/* Try both the primary and the secondary hash */
+		while (true) {
+			int j;
+			hptep = (__be64 *)(hpt->virt + pteg_addr);
+
+			/* There are 8 entries in the pteg to search */
+			for (j = 0; j < 16; j += 2) {
+				preempt_disable();
+				/* Lock the pte */
+				while (!try_lock_hpte(&hptep[j], HPTE_V_HVLOCK))
+					cpu_relax();
+				v = be64_to_cpu(hptep[j]) & ~HPTE_V_HVLOCK;
+				r = be64_to_cpu(hptep[j + 1]);
+
+				/*
+				 * Check for a match under the lock
+				 * NOTE: the entry might be valid or absent
+				 */
+				if ((v & (HPTE_V_VALID | HPTE_V_ABSENT)) &&
+				    !((v ^ v_match) & v_mask) &&
+				    !((r ^ r_match) & r_mask) &&
+				    (kvmppc_hpte_base_page_shift(v, r) ==
+				     base_pshift) &&
+				    (kvmppc_hpte_actual_page_shift(v, r) ==
+				     actual_pshift))
+					kvmhv_invalidate_shadow_pte_hash(hpt,
+						gp->shadow_lpid, &hptep[j],
+						(pteg_addr >> 4) + (j >> 1));
+				else
+					__unlock_hpte(&hptep[j], v);
+				preempt_enable();
+				/*
+				 * In theory there is a 1-to-1 mapping between
+				 * entries in the L1 hpt and our shadow hpt,
+				 * however since L1 can't exactly specify a
+				 * hpte (since we're missing some va bits) we
+				 * must invalidate any match which we find and
+				 * continue the search.
+				 */
+			}
+
+			if (v_match & HPTE_V_SECONDARY)
+				break;
+			/* try the secondary hash */
+			v_match |= HPTE_V_SECONDARY;
+			pteg_addr ^= (kvmppc_hpt_mask(hpt) << 7);
+		}
+	}
+}
+
 static inline int get_ric(unsigned int instr)
 {
 	return (instr >> 18) & 0x3;
@@ -1331,44 +1488,82 @@ static inline long get_epn(unsigned long r_val)
 	return r_val >> 12;
 }
 
+/* SLB[lp] encodings for base page shifts */
+static int slb_base_page_shift[4] = {
+	24,     /* 16M */
+	16,     /* 64k */
+	34,     /* 16G */
+	20,     /* 1M, unsupported */
+};
+
 static int kvmhv_emulate_tlbie_tlb_addr(struct kvm_vcpu *vcpu, int lpid,
-					int ap, long epn)
+					bool radix, unsigned long rbval)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *gp;
-	long npages;
-	int shift, shadow_shift;
-	unsigned long addr;
 	int rc = 0;
 
-	shift = ap_to_shift(ap);
-	addr = epn << 12;
-	if (shift < 0)
-		/* Invalid ap encoding */
-		return -EINVAL;
-
-	addr &= ~((1UL << shift) - 1);
-	npages = 1UL << (shift - PAGE_SHIFT);
-
 	gp = kvmhv_get_nested(kvm, lpid, false);
 	if (!gp) /* No such guest -> nothing to do */
 		return 0;
 	mutex_lock(&gp->tlb_lock);
 
-	/* XXX TODO hpt */
-	if (!gp->radix) {
-		rc = -EINVAL;
-		goto out_unlock;
-	}
+	if (radix) {	/* Radix Invalidation */
+		int shift, shadow_shift;
+		unsigned long addr;
+		long npages;
 
-	/* There may be more than one host page backing this single guest pte */
-	do {
-		kvmhv_invalidate_shadow_pte_radix(vcpu, gp, addr,
-						  &shadow_shift);
+		/* Radix invalidation but this is a hpt guest, nothing to do */
+		if (!gp->radix)
+			goto out_unlock;
+
+		shift = ap_to_shift(get_ap(rbval));
+		addr = get_epn(rbval) << 12;
+		if (shift < 0) {	/* Invalid ap encoding */
+			rc = -EINVAL;
+			goto out_unlock;
+		}
+
+		addr &= ~((1UL << shift) - 1);
+		npages = 1UL << (shift - PAGE_SHIFT);
+		/* There may be more than one host page backing this single guest pte */
+		do {
+			kvmhv_invalidate_shadow_pte_radix(vcpu, gp, addr,
+							  &shadow_shift);
+
+			npages -= 1UL << (shadow_shift - PAGE_SHIFT);
+			addr += 1UL << shadow_shift;
+		} while (npages > 0);
+	} else {	/* Hash Invalidation */
+		int base_pshift = 12, actual_pshift = 12;
+		unsigned long ava, b = (rbval & TLBIE_RB_B) << TLBIE_RB_B_SHIFT;
+
+		/* HPT invalidation but this is a radix guest, nothing to do */
+		if (gp->radix)
+			goto out_unlock;
+
+		/* Decode the rbval into ava, b, and base and actual pshifts */
+		if (rbval & TLBIE_RB_L) {	/* large base page size */
+			unsigned long lp = rbval & TLBIE_RB_LP;
+			ava = (rbval & TLBIE_RB_AVA_L) |
+			      ((rbval & TLBIE_RB_AVAL) << TLBIE_RB_AVAL_SHIFT);
+
+			/* base and actual page size encoded in lp field */
+			base_pshift = kvmppc_hpte_base_page_shift(HPTE_V_LARGE,
+								  lp);
+			actual_pshift = kvmppc_hpte_actual_page_shift(HPTE_V_LARGE,
+								      lp);
+		} else {			/* !large base page size */
+			int ap = get_ap(rbval);
+			ava = rbval & TLBIE_RB_AVA_4K;
+
+			/* actual page size encoded in ap field */
+			if (ap & 0x4)
+				actual_pshift = slb_base_page_shift[ap & 0x3];
+		}
 
-		npages -= 1UL << (shadow_shift - PAGE_SHIFT);
-		addr += 1UL << shadow_shift;
-	} while (npages > 0);
+		kvmhv_tlbie_hpt_addr(gp, ava, base_pshift, actual_pshift, b);
+	}
 
 out_unlock:
 	mutex_unlock(&gp->tlb_lock);
@@ -1381,16 +1576,11 @@ static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	/* XXX TODO hpt */
 	mutex_lock(&gp->tlb_lock);
 	switch (ric) {
 	case 0:
 		/* Invalidate TLB */
-		spin_lock(&kvm->mmu_lock);
-		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
-					  gp->shadow_lpid);
-		spin_unlock(&kvm->mmu_lock);
-		kvmhv_flush_lpid(gp->shadow_lpid, gp->radix);
+		kvmhv_flush_nested(kvm, gp, false);
 		break;
 	case 1:
 		/*
@@ -1400,7 +1590,7 @@ static void kvmhv_emulate_tlbie_lpid(struct kvm_vcpu *vcpu,
 		break;
 	case 2:
 		/* Invalidate TLB, PWC and caching of partition table entries */
-		kvmhv_flush_nested(gp);
+		kvmhv_flush_nested(kvm, gp, true);
 		break;
 	default:
 		break;
@@ -1431,9 +1621,8 @@ static int kvmhv_emulate_priv_tlbie(struct kvm_vcpu *vcpu, unsigned int instr,
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *gp;
-	int r, ric, prs, is, ap;
+	int r, ric, prs, is;
 	int lpid;
-	long epn;
 	int ret = 0;
 
 	ric = get_ric(instr);
@@ -1444,14 +1633,28 @@ static int kvmhv_emulate_priv_tlbie(struct kvm_vcpu *vcpu, unsigned int instr,
 
 	/*
 	 * These cases are invalid and are not handled:
-	 * r   != 1 -> Only radix supported
+	 *
+	 * Radix:
 	 * prs == 1 -> Not HV privileged
 	 * ric == 3 -> No cluster bombs for radix
 	 * is  == 1 -> Partition scoped translations not associated with pid
 	 * (!is) && (ric == 1 || ric == 2) -> Not supported by ISA
+	 *
+	 * HPT:
+	 * prs == 1 && ric != 2	-> Only process scoped caching is process table
+	 * ric == 1		-> No page walk cache for HPT
+	 * (!is) && ric == 2	-> Not supported by ISA
+	 * ric == 3		-> Although cluster bombs are technically
+	 * 			   supported for is == 0, their encoding is
+	 * 			   implementation specific and linux doesn't
+	 * 			   use them, so we don't handle them for now.
+	 * is == 1		-> HPT translations not associated with pid
 	 */
-	if ((!r) || (prs) || (ric == 3) || (is == 1) ||
-	    ((!is) && (ric == 1 || ric == 2)))
+	if (r && ((prs) || (ric == 3) || (is == 1) ||
+			   ((!is) && (ric == 1 || ric == 2))))
+		return -EINVAL;
+	else if (!r && ((prs && (ric != 2)) || (ric == 1) ||
+			(!is && (ric == 2)) || (is == 1) || (ric == 3)))
 		return -EINVAL;
 
 	switch (is) {
@@ -1460,9 +1663,7 @@ static int kvmhv_emulate_priv_tlbie(struct kvm_vcpu *vcpu, unsigned int instr,
 		 * We know ric == 0
 		 * Invalidate TLB for a given target address
 		 */
-		epn = get_epn(rbval);
-		ap = get_ap(rbval);
-		ret = kvmhv_emulate_tlbie_tlb_addr(vcpu, lpid, ap, epn);
+		ret = kvmhv_emulate_tlbie_tlb_addr(vcpu, lpid, r, rbval);
 		break;
 	case 2:
 		/* Invalidate matching LPID */
-- 
2.13.6

