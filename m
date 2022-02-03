Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C984A7D13
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348716AbiBCBBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348694AbiBCBBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:32 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F047C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:32 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s9-20020a17090aad8900b001b82d1e4dc8so625315pjq.6
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z1NP3hwhOriDa3BDG7PiuvhtUnfRoAwi4K6Zz7Br1zg=;
        b=F3HSzYHHWzUMA5RvJ6GaJZPFElCy7JAP8kGrG5bhqnxBBdO3nK8W7xYvyNXhCcT0+0
         pgdlVGsaD6nWT9AKEyOJroLYneDdqLQB0uxCLKwayfy/UGvqnfRFSk9znVaXxynjsKGW
         EO6aLF1pFPtK63Ed1p0KGfFAP0b/KettJpUO/OKiJb0AixfXqoH1IPgHdJm1Gkx2xLww
         jhyydleV90ydaLYC+6GJ3VsSiu+7/8yNWMkqW8y9wRVZ77VtZq48551D9nmAmMYbg4nO
         +AaJt+ZMud1ad67CnQLaJ6nyrDMalYImWrdKfuE4p9TtvXDN44ypmG43k8a6D4LM+JTD
         0g6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z1NP3hwhOriDa3BDG7PiuvhtUnfRoAwi4K6Zz7Br1zg=;
        b=IH0sS+7dOIa1VLQb8um7gNK75urNdJ8jdWpwL7W/BOHuOkCi7Af+KScCfYFbtPwul3
         1rvxSWV3MVLHlxbWNkPMP4uHMJlGjW4yd1Z41yX6RNLsZ2pgxF5oPF0qdtOkVM4anL3k
         jm4yvC9kJRfLbJcwL35djryHiDUH6v9jgaGgBi4p4gBxTGC+I3m7o/bh1MofTEffibh7
         ++rQHVR9l11uTEe2K9PoG+EUPPHmXUq3AVVmc3gZVZfX6KjtaJpl1Dqhk7FiHBBEnmcd
         DX8jcicizKIVDYrqcN5jACVJDRl2z5/Vnl1ftXIWV1f7n4ERcqZOooLYt4eraYrg57Bl
         INqg==
X-Gm-Message-State: AOAM533vCh8Vz7ZalM7Po0BJR05TixvlFD6yn7R1rnj/W7R49ujRKTxH
        Vx63aZPg9xRP56fj/o0JN2adYUIAetuQew==
X-Google-Smtp-Source: ABdhPJwSbQ1cMCQWoR30BepRmmTyLOdyZYZTQTgqIaRgKahEhC6344L+GHCQfyOMTnWqsSqqGBRnRpQNgb0WSw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:1d4a:: with SMTP id
 d71mr31951117pfd.46.1643850091582; Wed, 02 Feb 2022 17:01:31 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:47 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-20-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 19/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
declaration time rather than being fixed for all declarations. This will
be used in a follow-up commit to declare an cache in x86 with a capacity
of 512+ objects without having to increase the capacity of all caches in
KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/mmu.c              | 12 ++++++------
 arch/mips/include/asm/kvm_host.h  |  2 +-
 arch/x86/include/asm/kvm_host.h   |  8 ++++----
 include/linux/kvm_types.h         | 24 ++++++++++++++++++++++--
 virt/kvm/kvm_main.c               |  8 +++++++-
 6 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b44ea17af88..a450b91cc2d9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -357,7 +357,7 @@ struct kvm_vcpu_arch {
 	bool pause;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
 
 	/* Target CPU and feature flags */
 	int target;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..9c853c529b49 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -765,7 +765,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 {
 	phys_addr_t addr;
 	int ret = 0;
-	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
+	DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {};
+	struct kvm_mmu_memory_cache *cache = &page_cache.cache;
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
 				     KVM_PGTABLE_PROT_R |
@@ -774,18 +775,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
+	cache->gfp_zero = __GFP_ZERO;
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
 	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
-		ret = kvm_mmu_topup_memory_cache(&cache,
-						 kvm_mmu_cache_min_pages(kvm));
+		ret = kvm_mmu_topup_memory_cache(cache, kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			break;
 
 		spin_lock(&kvm->mmu_lock);
-		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
-					     &cache);
+		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot, cache);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
@@ -793,7 +793,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		pa += PAGE_SIZE;
 	}
 
-	kvm_mmu_free_memory_cache(&cache);
+	kvm_mmu_free_memory_cache(cache);
 	return ret;
 }
 
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 72b90d45a46e..82bbcbc3ead6 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -346,7 +346,7 @@ struct kvm_vcpu_arch {
 	unsigned long pending_exceptions_clr;
 
 	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
 
 	/* vcpu's vzguestid is different on each host cpu in an smp system */
 	u32 vzguestid[NR_CPUS];
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f00004c13ccf..d0b12bfe5818 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -684,10 +684,10 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
-	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
-	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_pte_list_desc_cache);
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadow_page_cache);
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadowed_translation_cache);
+	DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_header_cache);
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index dceac12c1ce5..9575fb8d333f 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -78,14 +78,34 @@ struct gfn_to_pfn_cache {
  * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
  * holding MMU locks.  Note, these caches act more like prefetch buffers than
  * classical caches, i.e. objects are not returned to the cache on being freed.
+ *
+ * The storage for the cache objects is laid out after the struct to allow
+ * different declarations to choose different capacities. If the capacity field
+ * is 0, the capacity is assumed to be KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.
  */
 struct kvm_mmu_memory_cache {
 	int nobjs;
+	int capacity;
 	gfp_t gfp_zero;
 	struct kmem_cache *kmem_cache;
-	void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
+	void *objects[0];
 };
-#endif
+
+/*
+ * Note, if defining a memory cache with a non-default capacity, you must
+ * initialize the capacity field at runtime.
+ */
+#define __DEFINE_KVM_MMU_MEMORY_CACHE(_name, _capacity)	\
+	struct {						\
+		struct kvm_mmu_memory_cache _name;		\
+		void *_name##_objects[_capacity];		\
+	}
+
+/* Define a memory cache with the default capacity. */
+#define DEFINE_KVM_MMU_MEMORY_CACHE(_name) \
+	__DEFINE_KVM_MMU_MEMORY_CACHE(_name, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE)
+
+#endif /* KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE */
 
 #define HALT_POLL_HIST_COUNT			32
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 034c567a680c..afa4bdb6481e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -373,11 +373,17 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
+	int capacity;
 	void *obj;
 
+	if (mc->capacity)
+		capacity = mc->capacity;
+	else
+		capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
+
 	if (mc->nobjs >= min)
 		return 0;
-	while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
+	while (mc->nobjs < capacity) {
 		obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
 		if (!obj)
 			return mc->nobjs >= min ? 0 : -ENOMEM;
-- 
2.35.0.rc2.247.g8bbb082509-goog

