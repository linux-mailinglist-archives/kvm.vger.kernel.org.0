Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E2A9C937
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfHZGVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33911 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfHZGVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so9513284plr.1;
        Sun, 25 Aug 2019 23:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XMt2rEUJv8rzzYIz/79ZHqbdb3hhBD7mqvJNo/GL7EM=;
        b=slVF1clzDCzCUWNKPpZwY3r6FyfLJ17rARX3A88WrFHWJQgdYcp5oWinPGLi712NED
         TrVTEbXtHvOIA+EwF+mLA3aIo44E3S/CzusxJo/5aM3AIHcC212s1aDCsUEdPRX3UDQU
         W7NMt0bJNuhnPn5gwsf/p/FHU0YtgJaSV54PPQIfW8zyKwbcshFkvqRvL4q+Uxbw2Vg7
         +/Hxao5azBa19ulmpf8MrGuwodu9F7ljB+Vu1qRgrX9gC0W+3Vb2hs6DzVGq7POhi1CF
         15NDkmGgmg8YnTPl5Jjbj5/Muy/8Eb0Uvz5jxZ9A056Fa/1oxy9osqJmzKd7xp1HA+dQ
         S9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XMt2rEUJv8rzzYIz/79ZHqbdb3hhBD7mqvJNo/GL7EM=;
        b=Hs2GPf2PiSlkcr23TP5kVyFUKua6EbCnamIRTqjRj7O2LJJ7afIP/5yfoNyCbdYRoW
         0QT032dZURO15bximpvt0aHLZc/Bdaeqqp1lgLjGjh3cQtNRzLGThkNNcpr/PYgjqlo1
         O80litoC/jUAkGcYMSPZLQeSm7v8wpU2r1wrO/BO5M6dTWj+Uc+CczSdfrvFT3x+ofmS
         JnRbIhLBhMrmgW63+3irS/lmCTIfHWhtSktG/N9ww/INiipGkUWQIUO9zSEejR5SWk90
         URGsd/atJGuINDWA8LNfyJTw4AgWAdXPK/E9px332w4BJ/VdSrX2+ypKaejYxbutLqJO
         Amlw==
X-Gm-Message-State: APjAAAVnz4mMFMWfvC/+Z/L3GOAsi8VeE5yfApGit3TD9/b5hk+SO/lC
        Y5ZiGccLF+AJPlLdHW6t/V+I9i7vHw8=
X-Google-Smtp-Source: APXvYqwm6KDQsNO19D3NgyWHxn6hKuItBeYyzDyxtyiqnPJc19qo9Zi+MJy4s/8SwWycNOpjyYQnsg==
X-Received: by 2002:a17:902:bc48:: with SMTP id t8mr568590plz.261.1566800492996;
        Sun, 25 Aug 2019 23:21:32 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:32 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 07/23] KVM: PPC: Book3S HV: Make kvmppc_invalidate_hpte() take lpid not a kvm struct
Date:   Mon, 26 Aug 2019 16:20:53 +1000
Message-Id: <20190826062109.7573-8-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function kvmppc_invalidate_hpte() is used to invalidate and perform
the tlbies for a given pte in a hpt (hash page table). Currently the
function takes a kvm struct as an argument, however the only member
of this struct that it accesses in the lpid field. Modify this function
to take an lpid argument in place of the kvm struct.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c   |  6 +++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   | 22 ++++++++++++----------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 6d0bb22dc637..c69eeb4e176c 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -241,7 +241,7 @@ extern void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 			unsigned long *rmap, long pte_index, int realmode);
 extern void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
 			unsigned long gfn, unsigned long psize);
-extern void kvmppc_invalidate_hpte(struct kvm *kvm, __be64 *hptep,
+extern void kvmppc_invalidate_hpte(unsigned int lpid, __be64 *hptep,
 			unsigned long pte_index);
 void kvmppc_clear_ref_hpte(struct kvm *kvm, __be64 *hptep,
 			unsigned long pte_index);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index ab97b6bcf226..bbb23b3f8bb9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -701,7 +701,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		/* HPTE was previously valid, so we need to invalidate it */
 		unlock_rmap(rmap);
 		hptep[0] |= cpu_to_be64(HPTE_V_ABSENT);
-		kvmppc_invalidate_hpte(kvm, hptep, index);
+		kvmppc_invalidate_hpte(kvm->arch.lpid, hptep, index);
 		/* don't lose previous R and C bits */
 		r |= be64_to_cpu(hptep[1]) & (HPTE_R_R | HPTE_R_C);
 	} else {
@@ -829,7 +829,7 @@ static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
 	if ((be64_to_cpu(hptep[0]) & HPTE_V_VALID) &&
 	    hpte_rpn(ptel, psize) == gfn) {
 		hptep[0] |= cpu_to_be64(HPTE_V_ABSENT);
-		kvmppc_invalidate_hpte(kvm, hptep, i);
+		kvmppc_invalidate_hpte(kvm->arch.lpid, hptep, i);
 		hptep[1] &= ~cpu_to_be64(HPTE_R_KEY_HI | HPTE_R_KEY_LO);
 		/* Harvest R and C */
 		rcbits = be64_to_cpu(hptep[1]) & (HPTE_R_R | HPTE_R_C);
@@ -1094,7 +1094,7 @@ static int kvm_test_clear_dirty_npages(struct kvm *kvm, unsigned long *rmapp)
 
 		/* need to make it temporarily absent so C is stable */
 		hptep[0] |= cpu_to_be64(HPTE_V_ABSENT);
-		kvmppc_invalidate_hpte(kvm, hptep, i);
+		kvmppc_invalidate_hpte(kvm->arch.lpid, hptep, i);
 		v = be64_to_cpu(hptep[0]);
 		r = be64_to_cpu(hptep[1]);
 		if (r & HPTE_R_C) {
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index bd31d36332a8..1d26d509aaf6 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -440,7 +440,7 @@ static inline int is_mmio_hpte(unsigned long v, unsigned long r)
 		(HPTE_R_KEY_HI | HPTE_R_KEY_LO));
 }
 
-static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
+static void do_tlbies(unsigned int lpid, unsigned long *rbvalues,
 		      long npages, int global, bool need_sync)
 {
 	long i;
@@ -455,7 +455,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 			asm volatile("ptesync" : : : "memory");
 		for (i = 0; i < npages; ++i) {
 			asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
-				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
+				     "r" (rbvalues[i]), "r" (lpid));
 		}
 
 		if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
@@ -465,7 +465,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 			 */
 			asm volatile("ptesync": : :"memory");
 			asm volatile(PPC_TLBIE_5(%0,%1,0,0,0) : :
-				     "r" (rbvalues[0]), "r" (kvm->arch.lpid));
+				     "r" (rbvalues[0]), "r" (lpid));
 		}
 
 		asm volatile("eieio; tlbsync; ptesync" : : : "memory");
@@ -516,7 +516,8 @@ long kvmppc_do_h_remove(struct kvm *kvm, unsigned long flags,
 	if (v & HPTE_V_VALID) {
 		hpte[0] &= ~cpu_to_be64(HPTE_V_VALID);
 		rb = compute_tlbie_rb(v, pte_r, pte_index);
-		do_tlbies(kvm, &rb, 1, global_invalidates(kvm), true);
+		do_tlbies(kvm->arch.lpid, &rb, 1, global_invalidates(kvm),
+			  true);
 		/*
 		 * The reference (R) and change (C) bits in a HPT
 		 * entry can be set by hardware at any time up until
@@ -652,7 +653,7 @@ long kvmppc_do_h_bulk_remove(struct kvm_vcpu *vcpu, bool realmode)
 			break;
 
 		/* Now that we've collected a batch, do the tlbies */
-		do_tlbies(kvm, tlbrb, n, global, true);
+		do_tlbies(kvm->arch.lpid, tlbrb, n, global, true);
 
 		/* Read PTE low words after tlbie to get final R/C values */
 		for (k = 0; k < n; ++k) {
@@ -736,7 +737,8 @@ long kvmppc_do_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
 			rb = compute_tlbie_rb(v, r, pte_index);
 			hpte[0] = cpu_to_be64((pte_v & ~HPTE_V_VALID) |
 					      HPTE_V_ABSENT);
-			do_tlbies(kvm, &rb, 1, global_invalidates(kvm), true);
+			do_tlbies(kvm->arch.lpid, &rb, 1,
+				  global_invalidates(kvm), true);
 			/* Don't lose R/C bit updates done by hardware */
 			r |= be64_to_cpu(hpte[1]) & (HPTE_R_R | HPTE_R_C);
 			hpte[1] = cpu_to_be64(r);
@@ -898,7 +900,7 @@ long kvmppc_do_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 	if (v & HPTE_V_VALID) {
 		/* need to make it temporarily absent so C is stable */
 		hpte[0] |= cpu_to_be64(HPTE_V_ABSENT);
-		kvmppc_invalidate_hpte(kvm, hpte, pte_index);
+		kvmppc_invalidate_hpte(kvm->arch.lpid, hpte, pte_index);
 		r = be64_to_cpu(hpte[1]);
 		gr |= r & (HPTE_R_R | HPTE_R_C);
 		if (r & HPTE_R_C) {
@@ -1064,7 +1066,7 @@ long kvmppc_rm_h_page_init(struct kvm_vcpu *vcpu, unsigned long flags,
 	return ret;
 }
 
-void kvmppc_invalidate_hpte(struct kvm *kvm, __be64 *hptep,
+void kvmppc_invalidate_hpte(unsigned int lpid, __be64 *hptep,
 			unsigned long pte_index)
 {
 	unsigned long rb;
@@ -1078,7 +1080,7 @@ void kvmppc_invalidate_hpte(struct kvm *kvm, __be64 *hptep,
 		hp1 = hpte_new_to_old_r(hp1);
 	}
 	rb = compute_tlbie_rb(hp0, hp1, pte_index);
-	do_tlbies(kvm, &rb, 1, 1, true);
+	do_tlbies(lpid, &rb, 1, 1, true);
 }
 EXPORT_SYMBOL_GPL(kvmppc_invalidate_hpte);
 
@@ -1099,7 +1101,7 @@ void kvmppc_clear_ref_hpte(struct kvm *kvm, __be64 *hptep,
 	rbyte = (be64_to_cpu(hptep[1]) & ~HPTE_R_R) >> 8;
 	/* modify only the second-last byte, which contains the ref bit */
 	*((char *)hptep + 14) = rbyte;
-	do_tlbies(kvm, &rb, 1, 1, false);
+	do_tlbies(kvm->arch.lpid, &rb, 1, 1, false);
 }
 EXPORT_SYMBOL_GPL(kvmppc_clear_ref_hpte);
 
-- 
2.13.6

