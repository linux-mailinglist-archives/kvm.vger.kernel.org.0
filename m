Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BF369A4BD
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBQENF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjBQEMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:12:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D256F5BDA4
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:42 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a17-20020a256611000000b00889c54916f2so4294127ybc.14
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=amHoLle71o7p/XllEoZS3hif3UtpM0j0bW+cZG3KVdY=;
        b=tKKqOK/4v9Nsl+iZ5uj+QLwvBB9/MlZmEqfeAcO65vdFUXJ2neb8OCPtRfPOaWDyxP
         FkEFBCKiFG2TAlI4pbNOUhKBZytnLS1P7nr+a+PTPquwKNcmuXNGSPjkFUGmw29bW+Ah
         /Da997b9GFB7bCnPYHpg2jKoZ2Y/mB2zh9Hp5FwTJeHoexE5+GN1xeuXBJXsz8C8IX5S
         L7gcpavYRz3yYEoRWFaXHcNffqgqtABgaN3Ncgntbv/iUEBl68KG/tq6fbetIAu2dGSB
         ToUCeR9ccz+fO4AOL2Ch/Flg7o+hMxiFfDMOP9ByuijjtcQxaoorvyhl8x0v3P6WJKBQ
         RryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=amHoLle71o7p/XllEoZS3hif3UtpM0j0bW+cZG3KVdY=;
        b=EyyAazQhow7IonaVYwy8is+5pqDEaDSeFc8MS0b9xNtWsBr+i0W7dc5we9tPnqrXZi
         08bUr3V+R4WkHQV85s+/z1A1L9JlN+DCdpcpFruAYFEm6XpYYtwmEEjsqqigUU6l1mgd
         boOVhTs/00qFY6BsvR+iUA7JJHc1NMW1zF4jh0aCyDM6M781bEXxl7KelqNb2yrBAyyo
         gsoL01pV/ACYnp/LkPLK1CzyUGNnUA+iTsXh3mX11b5/TXAaYn0P+MEgNsdevYq4yOZp
         ogahWcxCKlPkgNTVZQ6s+rwbMnKRRfmSHHG40a2gbXbewgJkhvk1xle1ly/mEpUrYzif
         KwAA==
X-Gm-Message-State: AO0yUKVnOE1KHUJG2SbMyTUW/B3VJ6dtuozBs+BLaOFdPrBTcfn+yqV2
        dYdKiINn6lp+IfcjcBuI6lMIqQQBGi8=
X-Google-Smtp-Source: AK7set/zG1Ljp2MUiBWQb+jj+0ocG59LCXivAn6wr+nza0TKNrRHXUDRDhG90IH2RrsF7xFXRI6zxpp9jUg=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:6fb3:61e:d31f:1ad3])
 (user=yuzhao job=sendgmr) by 2002:a05:6902:3c7:b0:8dd:52a3:b3a5 with SMTP id
 g7-20020a05690203c700b008dd52a3b3a5mr70700ybs.5.1676607162038; Thu, 16 Feb
 2023 20:12:42 -0800 (PST)
Date:   Thu, 16 Feb 2023 21:12:29 -0700
In-Reply-To: <20230217041230.2417228-1-yuzhao@google.com>
Message-Id: <20230217041230.2417228-5-yuzhao@google.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH mm-unstable v1 4/5] kvm/powerpc: add kvm_arch_test_clear_young()
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kvm_arch_test_clear_young() for the vast majority of
VMs that are not nested and run on hardware with Radix MMU enabled.

It relies on two techniques, RCU and cmpxchg, to safely test and clear
the accessed bit without taking the MMU lock. The former protects KVM
page tables from being freed while the latter clears the accessed bit
atomically against both the hardware and other software page table
walkers.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/powerpc/include/asm/kvm_host.h    | 18 ++++++
 arch/powerpc/include/asm/kvm_ppc.h     | 14 +----
 arch/powerpc/kvm/book3s.c              |  7 +++
 arch/powerpc/kvm/book3s.h              |  2 +
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 78 +++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_hv.c           | 10 ++--
 6 files changed, 110 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index caea15dcb91d..996850029ce0 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -886,4 +886,22 @@ static inline void kvm_arch_exit(void) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
+static inline int kvmppc_radix_possible(void)
+{
+	return cpu_has_feature(CPU_FTR_ARCH_300) && radix_enabled();
+}
+
+static inline bool kvmhv_on_pseries(void)
+{
+	return IS_ENABLED(CONFIG_PPC_PSERIES) && !cpu_has_feature(CPU_FTR_HVMODE);
+}
+
+/* see the comments on the generic kvm_arch_has_test_clear_young() */
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return IS_ENABLED(CONFIG_KVM) && IS_ENABLED(CONFIG_KVM_BOOK3S_HV_POSSIBLE) &&
+	       kvmppc_radix_possible() && !kvmhv_on_pseries();
+}
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index eae9619b6190..0bb772fc12b1 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -277,6 +277,8 @@ struct kvmppc_ops {
 	bool (*unmap_gfn_range)(struct kvm *kvm, struct kvm_gfn_range *range);
 	bool (*age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
 	bool (*test_age_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
+	bool (*test_clear_young)(struct kvm *kvm, struct kvm_gfn_range *range,
+				 gfn_t lsb_gfn, unsigned long *bitmap);
 	bool (*set_spte_gfn)(struct kvm *kvm, struct kvm_gfn_range *range);
 	void (*free_memslot)(struct kvm_memory_slot *slot);
 	int (*init_vm)(struct kvm *kvm);
@@ -580,18 +582,6 @@ static inline bool kvm_hv_mode_active(void)		{ return false; }
 
 #endif
 
-#ifdef CONFIG_PPC_PSERIES
-static inline bool kvmhv_on_pseries(void)
-{
-	return !cpu_has_feature(CPU_FTR_HVMODE);
-}
-#else
-static inline bool kvmhv_on_pseries(void)
-{
-	return false;
-}
-#endif
-
 #ifdef CONFIG_KVM_XICS
 static inline int kvmppc_xics_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 6d525285dbe8..f4cf330e3e81 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -877,6 +877,13 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm->arch.kvm_ops->test_age_gfn(kvm, range);
 }
 
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
+			       gfn_t lsb_gfn, unsigned long *bitmap)
+{
+	return kvm->arch.kvm_ops->test_clear_young &&
+	       kvm->arch.kvm_ops->test_clear_young(kvm, range, lsb_gfn, bitmap);
+}
+
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm->arch.kvm_ops->set_spte_gfn(kvm, range);
diff --git a/arch/powerpc/kvm/book3s.h b/arch/powerpc/kvm/book3s.h
index 58391b4b32ed..fe9cac423817 100644
--- a/arch/powerpc/kvm/book3s.h
+++ b/arch/powerpc/kvm/book3s.h
@@ -12,6 +12,8 @@ extern void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
 extern bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range);
 extern bool kvm_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
 extern bool kvm_test_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
+extern bool kvmhv_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
+				   gfn_t lsb_gfn, unsigned long *bitmap);
 extern bool kvm_set_spte_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range);
 
 extern int kvmppc_mmu_init_pr(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 9d3743ca16d5..8476646c554c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -1083,6 +1083,78 @@ bool kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return ref;
 }
 
+bool kvmhv_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
+			    gfn_t lsb_gfn, unsigned long *bitmap)
+{
+	bool success;
+	gfn_t gfn = range->start;
+
+	if (WARN_ON_ONCE(!kvm_arch_has_test_clear_young()))
+		return false;
+
+	/*
+	 * This function relies on two techniques, RCU and cmpxchg, to safely
+	 * test and clear the accessed bit without taking the MMU lock. The
+	 * former protects KVM page tables from being freed while the latter
+	 * clears the accessed bit atomically against both the hardware and
+	 * other software page table walkers.
+	 */
+	rcu_read_lock();
+
+	success = kvm_is_radix(kvm);
+	if (!success)
+		goto unlock;
+
+	/*
+	 * case 1:  this function          kvmppc_switch_mmu_to_hpt()
+	 *
+	 *          rcu_read_lock()
+	 *          test kvm_is_radix()    kvm->arch.radix = 0
+	 *          use kvm->arch.pgtable
+	 *          rcu_read_unlock()
+	 *                                 synchronize_rcu()
+	 *                                 kvmppc_free_radix()
+	 *
+	 *
+	 * case 2:  this function          kvmppc_switch_mmu_to_radix()
+	 *
+	 *                                 kvmppc_init_vm_radix()
+	 *                                 smp_wmb()
+	 *          test kvm_is_radix()    kvm->arch.radix = 1
+	 *          smp_rmb()
+	 *          use kvm->arch.pgtable
+	 */
+	smp_rmb();
+
+	while (gfn < range->end) {
+		pte_t *ptep;
+		pte_t old, new;
+		unsigned int shift;
+
+		ptep = find_kvm_secondary_pte_unlocked(kvm, gfn * PAGE_SIZE, &shift);
+		if (!ptep)
+			goto next;
+
+		VM_WARN_ON_ONCE(!page_count(virt_to_page(ptep)));
+
+		old = READ_ONCE(*ptep);
+		if (!pte_present(old) || !pte_young(old))
+			goto next;
+
+		new = pte_mkold(old);
+
+		/* see the comments on the generic kvm_arch_has_test_clear_young() */
+		if (__test_and_change_bit(lsb_gfn - gfn, bitmap))
+			pte_xchg(ptep, old, new);
+next:
+		gfn += shift ? BIT(shift - PAGE_SHIFT) : 1;
+	}
+unlock:
+	rcu_read_unlock();
+
+	return success;
+}
+
 /* Returns the number of PAGE_SIZE pages that are dirty */
 static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 				struct kvm_memory_slot *memslot, int pagenum)
@@ -1464,13 +1536,15 @@ int kvmppc_radix_init(void)
 {
 	unsigned long size = sizeof(void *) << RADIX_PTE_INDEX_SIZE;
 
-	kvm_pte_cache = kmem_cache_create("kvm-pte", size, size, 0, pte_ctor);
+	kvm_pte_cache = kmem_cache_create("kvm-pte", size, size,
+					  SLAB_TYPESAFE_BY_RCU, pte_ctor);
 	if (!kvm_pte_cache)
 		return -ENOMEM;
 
 	size = sizeof(void *) << RADIX_PMD_INDEX_SIZE;
 
-	kvm_pmd_cache = kmem_cache_create("kvm-pmd", size, size, 0, pmd_ctor);
+	kvm_pmd_cache = kmem_cache_create("kvm-pmd", size, size,
+					  SLAB_TYPESAFE_BY_RCU, pmd_ctor);
 	if (!kvm_pmd_cache) {
 		kmem_cache_destroy(kvm_pte_cache);
 		return -ENOMEM;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6ba68dd6190b..17b415661282 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5242,6 +5242,8 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	spin_lock(&kvm->mmu_lock);
 	kvm->arch.radix = 0;
 	spin_unlock(&kvm->mmu_lock);
+	/* see the comments in kvmhv_test_clear_young() */
+	synchronize_rcu();
 	kvmppc_free_radix(kvm);
 
 	lpcr = LPCR_VPM1;
@@ -5266,6 +5268,8 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 	if (err)
 		return err;
 	kvmppc_rmap_reset(kvm);
+	/* see the comments in kvmhv_test_clear_young() */
+	smp_wmb();
 	/* Mutual exclusion with kvm_unmap_gfn_range etc. */
 	spin_lock(&kvm->mmu_lock);
 	kvm->arch.radix = 1;
@@ -6165,6 +6169,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.unmap_gfn_range = kvm_unmap_gfn_range_hv,
 	.age_gfn = kvm_age_gfn_hv,
 	.test_age_gfn = kvm_test_age_gfn_hv,
+	.test_clear_young = kvmhv_test_clear_young,
 	.set_spte_gfn = kvm_set_spte_gfn_hv,
 	.free_memslot = kvmppc_core_free_memslot_hv,
 	.init_vm =  kvmppc_core_init_vm_hv,
@@ -6225,11 +6230,6 @@ static int kvm_init_subcore_bitmap(void)
 	return 0;
 }
 
-static int kvmppc_radix_possible(void)
-{
-	return cpu_has_feature(CPU_FTR_ARCH_300) && radix_enabled();
-}
-
 static int kvmppc_book3s_init_hv(void)
 {
 	int r;
-- 
2.39.2.637.g21b0678d19-goog

