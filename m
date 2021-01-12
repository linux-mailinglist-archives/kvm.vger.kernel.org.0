Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C512F381A
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406177AbhALSM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406150AbhALSMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8647C06138C
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:16 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g9so2265133ybe.7
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=piJt2JS5pTSM24ESUHevNSUit88Vm39hvm09WUBv428=;
        b=BAu9qJ6KcGwjE9OCzK9jx2XZ8YHUslIxtm1xHhRaYEQGv3wWeUkUxkJYwV0pKmembi
         XauVCsY6SBfEtjA1vMrB0IMjb/w2G77s1SmfBB8UBrDul993PffvF3rumJoq3jhbBN3a
         fZ+IxbCv15YLc9vlG7qdY2Zrf6KtD7PsuBcpTvMIPL465kF4wMg5OkxGxFsjGGiQzHnQ
         TaQ0qg5I3yDB73VFG0zcm49zCDCyVfm854YJbGSpmTmZG3iEpwG/d/VGgUH9cKzHEJwF
         phoj45QAdBdK3TbDkyOv3QliSL6rAFxFqj1Dpr/eZmxgnrK4P9ZWSUmz7/M4YMKetOBt
         ZHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=piJt2JS5pTSM24ESUHevNSUit88Vm39hvm09WUBv428=;
        b=GMgp6Dd7OTasc0QFOydPOvpby9k0A4jVaIUQrC++fjsRpzLMOAyYH1bpYWNTfgw3r1
         Wm+Re2AtiJa2RP/Op3ZaNFzugDepvftSSG4CJ7bplA2Xjq5jcMJrF7jXWEPwAU4+7T9T
         YHMfT07jwq87VWNKDSYK5+vQ1Fei7x/a3L7oSXkPqn+0bjkymPp4Dmd53c6yPshYuv3G
         pS/t9PakU/5y9P5N/auF5u5UJWZLZ07Zs/YWRJGMsh1wmpCR90PZelwlvDmEo8tMReL4
         WwBWDacMjpneeTRj/yv0FnirNzSlDaagCsdiSofgd9zkintcmwrxqIQoJLENlW2dcZZz
         3L3A==
X-Gm-Message-State: AOAM531UV+KWlyeCW7JeB6nMpWhVaFO/3lHJmQjQNQrRQkhRGxvRa2q5
        lnLBWGPp8a178D684lp0oC87Ff48/TbZ
X-Google-Smtp-Source: ABdhPJyLY977WjUPnJun9HkYOepTWmhCl5F5E+iAFfU57qbvcTW9YEOoOEszp67X+5GBIkF0P1v2ICMSlIch
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a5b:810:: with SMTP id x16mr1027014ybp.86.1610475075974;
 Tue, 12 Jan 2021 10:11:15 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:34 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-18-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 17/24] kvm: mmu: Move mmu_lock to struct kvm_arch
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the mmu_lock to struct kvm_arch so that it can be replaced with a
rwlock on x86 without affecting the performance of other archs.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 Documentation/virt/kvm/locking.rst     |  2 +-
 arch/arm64/include/asm/kvm_host.h      |  2 ++
 arch/arm64/kvm/arm.c                   |  2 ++
 arch/mips/include/asm/kvm_host.h       |  2 ++
 arch/mips/kvm/mips.c                   |  2 ++
 arch/mips/kvm/mmu.c                    |  6 +++---
 arch/powerpc/include/asm/kvm_host.h    |  2 ++
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 10 +++++-----
 arch/powerpc/kvm/book3s_64_vio_hv.c    |  4 ++--
 arch/powerpc/kvm/book3s_hv_nested.c    |  4 ++--
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    | 14 +++++++-------
 arch/powerpc/kvm/e500_mmu_host.c       |  2 +-
 arch/powerpc/kvm/powerpc.c             |  2 ++
 arch/s390/include/asm/kvm_host.h       |  2 ++
 arch/s390/kvm/kvm-s390.c               |  2 ++
 arch/x86/include/asm/kvm_host.h        |  2 ++
 arch/x86/kvm/mmu/mmu.c                 |  2 +-
 arch/x86/kvm/x86.c                     |  2 ++
 include/linux/kvm_host.h               |  1 -
 virt/kvm/kvm_main.c                    | 11 +++++------
 20 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index b21a34c34a21..06c006c73c4b 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -212,7 +212,7 @@ which time it will be set using the Dirty tracking mechanism described above.
 		- tsc offset in vmcb
 :Comment:	'raw' because updating the tsc offsets must not be preempted.
 
-:Name:		kvm->mmu_lock
+:Name:		kvm_arch::mmu_lock
 :Type:		spinlock_t
 :Arch:		any
 :Protects:	-shadow page/shadow tlb entry
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fcfab0c2567..6fd4d64eb202 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,6 +102,8 @@ struct kvm_arch_memory_slot {
 };
 
 struct kvm_arch {
+	spinlock_t mmu_lock;
+
 	struct kvm_s2_mmu mmu;
 
 	/* VTCR_EL2 value for this VM */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 04c44853b103..90f4fcd84bb5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -130,6 +130,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	spin_lock_init(&kvm->arch.mmu_lock);
+
 	ret = kvm_arm_setup_stage2(kvm, type);
 	if (ret)
 		return ret;
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 24f3d0f9996b..eb3caeffaf91 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -216,6 +216,8 @@ struct loongson_kvm_ipi {
 #endif
 
 struct kvm_arch {
+	spinlock_t mmu_lock;
+
 	/* Guest physical mm */
 	struct mm_struct gpa_mm;
 	/* Mask of CPUs needing GPA ASID flush */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 4e393d93c1aa..7b8d65d8c863 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -150,6 +150,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 	};
 
+	spin_lock_init(&kvm->arch.mmu_lock);
+
 	/* Allocate page table to map GPA -> RPA */
 	kvm->arch.gpa_mm.pgd = kvm_pgd_alloc();
 	if (!kvm->arch.gpa_mm.pgd)
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 449663152b3c..68fcda1e48f9 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -263,7 +263,7 @@ static bool kvm_mips_flush_gpa_pgd(pgd_t *pgd, unsigned long start_gpa,
  *
  * Flushes a range of GPA mappings from the GPA page tables.
  *
- * The caller must hold the @kvm->mmu_lock spinlock.
+ * The caller must hold the @kvm->arch.mmu_lock spinlock.
  *
  * Returns:	Whether its safe to remove the top level page directory because
  *		all lower levels have been removed.
@@ -388,7 +388,7 @@ BUILD_PTE_RANGE_OP(mkclean, pte_mkclean)
  * Make a range of GPA mappings clean so that guest writes will fault and
  * trigger dirty page logging.
  *
- * The caller must hold the @kvm->mmu_lock spinlock.
+ * The caller must hold the @kvm->arch.mmu_lock spinlock.
  *
  * Returns:	Whether any GPA mappings were modified, which would require
  *		derived mappings (GVA page tables & TLB enties) to be
@@ -410,7 +410,7 @@ int kvm_mips_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn)
  *		slot to be write protected
  *
  * Walks bits set in mask write protects the associated pte's. Caller must
- * acquire @kvm->mmu_lock.
+ * acquire @kvm->arch.mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index d67a470e95a3..7bb8e5847fb4 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -282,6 +282,8 @@ struct kvm_resize_hpt;
 #define KVMPPC_SECURE_INIT_ABORT 0x4 /* H_SVM_INIT_ABORT issued */
 
 struct kvm_arch {
+	spinlock_t mmu_lock;
+
 	unsigned int lpid;
 	unsigned int smt_mode;		/* # vcpus per virtual core */
 	unsigned int emul_smt_mode;	/* emualted SMT mode, on P9 */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index b628980c871b..522d19723512 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -388,7 +388,7 @@ static void kvmppc_pmd_free(pmd_t *pmdp)
 	kmem_cache_free(kvm_pmd_cache, pmdp);
 }
 
-/* Called with kvm->mmu_lock held */
+/* Called with kvm->arch.mmu_lock held */
 void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 		      unsigned int shift,
 		      const struct kvm_memory_slot *memslot,
@@ -992,7 +992,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-/* Called with kvm->mmu_lock held */
+/* Called with kvm->arch.mmu_lock held */
 int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		    unsigned long gfn)
 {
@@ -1012,7 +1012,7 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return 0;
 }
 
-/* Called with kvm->mmu_lock held */
+/* Called with kvm->arch.mmu_lock held */
 int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		  unsigned long gfn)
 {
@@ -1040,7 +1040,7 @@ int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return ref;
 }
 
-/* Called with kvm->mmu_lock held */
+/* Called with kvm->arch.mmu_lock held */
 int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		       unsigned long gfn)
 {
@@ -1073,7 +1073,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 		return ret;
 
 	/*
-	 * For performance reasons we don't hold kvm->mmu_lock while walking the
+	 * For performance reasons we don't hold kvm->arch.mmu_lock while walking the
 	 * partition scoped table.
 	 */
 	ptep = find_kvm_secondary_pte_unlocked(kvm, gpa, &shift);
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..adffa111ebe9 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -545,7 +545,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		if (kvmppc_rm_tce_to_ua(vcpu->kvm, tce_list, &ua))
 			return H_TOO_HARD;
 
-		arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+		arch_spin_lock(&kvm->arch.mmu_lock.rlock.raw_lock);
 		if (kvmppc_rm_ua_to_hpa(vcpu, mmu_seq, ua, &tces)) {
 			ret = H_TOO_HARD;
 			goto unlock_exit;
@@ -590,7 +590,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 
 unlock_exit:
 	if (!prereg)
-		arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
+		arch_spin_unlock(&kvm->arch.mmu_lock.rlock.raw_lock);
 	return ret;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 6d5987d1eee7..fe0a4e3fef1b 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -611,7 +611,7 @@ static void kvmhv_release_nested(struct kvm_nested_guest *gp)
 		/*
 		 * No vcpu is using this struct and no call to
 		 * kvmhv_get_nested can find this struct,
-		 * so we don't need to hold kvm->mmu_lock.
+		 * so we don't need to hold kvm->arch.mmu_lock.
 		 */
 		kvmppc_free_pgtable_radix(kvm, gp->shadow_pgtable,
 					  gp->shadow_lpid);
@@ -892,7 +892,7 @@ static void kvmhv_remove_nest_rmap_list(struct kvm *kvm, unsigned long *rmapp,
 	}
 }
 
-/* called with kvm->mmu_lock held */
+/* called with kvm->arch.mmu_lock held */
 void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
 				  const struct kvm_memory_slot *memslot,
 				  unsigned long gpa, unsigned long hpa,
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 88da2764c1bb..897baf210a2d 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -249,7 +249,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 	/* Translate to host virtual address */
 	hva = __gfn_to_hva_memslot(memslot, gfn);
 
-	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_lock(&kvm->arch.mmu_lock.rlock.raw_lock);
 	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &hpage_shift);
 	if (ptep) {
 		pte_t pte;
@@ -264,7 +264,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 		 * to <= host page size, if host is using hugepage
 		 */
 		if (host_pte_size < psize) {
-			arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
+			arch_spin_unlock(&kvm->arch.mmu_lock.rlock.raw_lock);
 			return H_PARAMETER;
 		}
 		pte = kvmppc_read_update_linux_pte(ptep, writing);
@@ -278,7 +278,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 			pa |= gpa & ~PAGE_MASK;
 		}
 	}
-	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_unlock(&kvm->arch.mmu_lock.rlock.raw_lock);
 
 	ptel &= HPTE_R_KEY | HPTE_R_PP0 | (psize-1);
 	ptel |= pa;
@@ -933,7 +933,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
 	mmu_seq = kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_lock(&kvm->arch.mmu_lock.rlock.raw_lock);
 
 	ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &pa, &memslot);
 	if (ret != H_SUCCESS)
@@ -945,7 +945,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
 	kvmppc_update_dirty_map(memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
 
 out_unlock:
-	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_unlock(&kvm->arch.mmu_lock.rlock.raw_lock);
 	return ret;
 }
 
@@ -961,7 +961,7 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
 	mmu_seq = kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_lock(&kvm->arch.mmu_lock.rlock.raw_lock);
 	ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &dest_pa, &dest_memslot);
 	if (ret != H_SUCCESS)
 		goto out_unlock;
@@ -976,7 +976,7 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
 	kvmppc_update_dirty_map(dest_memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
 
 out_unlock:
-	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
+	arch_spin_unlock(&kvm->arch.mmu_lock.rlock.raw_lock);
 	return ret;
 }
 
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 633ae418ba0e..fef60e614aaf 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -470,7 +470,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	/*
 	 * We are just looking at the wimg bits, so we don't
 	 * care much about the trans splitting bit.
-	 * We are holding kvm->mmu_lock so a notifier invalidate
+	 * We are holding kvm->arch.mmu_lock so a notifier invalidate
 	 * can't run hence pfn won't change.
 	 */
 	local_irq_save(flags);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index cf52d26f49cd..11e35ba0272e 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -452,6 +452,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	} else
 		goto err_out;
 
+	spin_lock_init(&kvm->arch.mmu_lock);
+
 	if (kvm_ops->owner && !try_module_get(kvm_ops->owner))
 		return -ENOENT;
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 74f9a036bab2..1299deef70b5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -926,6 +926,8 @@ struct kvm_s390_pv {
 };
 
 struct kvm_arch{
+	spinlock_t mmu_lock;
+
 	void *sca;
 	int use_esca;
 	rwlock_t sca_lock;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dbafd057ca6a..20c6ae7bc25b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2642,6 +2642,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		goto out_err;
 #endif
 
+	spin_lock_init(&kvm->arch.mmu_lock);
+
 	rc = s390_enable_sie();
 	if (rc)
 		goto out_err;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..3087de84fad3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -902,6 +902,8 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
+	spinlock_t mmu_lock;
+
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 659ed0a2875f..ba296ad051c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5747,7 +5747,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		if (!nr_to_scan--)
 			break;
 		/*
-		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
+		 * n_used_mmu_pages is accessed without holding kvm->arch.mmu_lock
 		 * here. We may skip a VM instance errorneosly, but we do not
 		 * want to shrink a VM that only started to populate its MMU
 		 * anyway.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 302042af87ee..a6cc34e8ccad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10366,6 +10366,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
+	spin_lock_init(&kvm->arch.mmu_lock);
+
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 022e3522788f..97e301b8cafd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -451,7 +451,6 @@ struct kvm_memslots {
 };
 
 struct kvm {
-	spinlock_t mmu_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c504f876176b..d168bd4517d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -434,27 +434,27 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
 
 void kvm_mmu_lock(struct kvm *kvm)
 {
-	spin_lock(&kvm->mmu_lock);
+	spin_lock(&kvm->arch.mmu_lock);
 }
 
 void kvm_mmu_unlock(struct kvm *kvm)
 {
-	spin_unlock(&kvm->mmu_lock);
+	spin_unlock(&kvm->arch.mmu_lock);
 }
 
 int kvm_mmu_lock_needbreak(struct kvm *kvm)
 {
-	return spin_needbreak(&kvm->mmu_lock);
+	return spin_needbreak(&kvm->arch.mmu_lock);
 }
 
 int kvm_mmu_lock_cond_resched(struct kvm *kvm)
 {
-	return cond_resched_lock(&kvm->mmu_lock);
+	return cond_resched_lock(&kvm->arch.mmu_lock);
 }
 
 void kvm_mmu_lock_assert_held(struct kvm *kvm)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held(&kvm->arch.mmu_lock);
 }
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
@@ -770,7 +770,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_init(&kvm->mmu_lock);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
 	kvm_eventfd_init(kvm);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

