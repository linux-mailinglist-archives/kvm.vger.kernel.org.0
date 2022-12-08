Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DEC6476A8
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiLHTkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiLHTkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:10 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A96389F9
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:55 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-40306a5a42cso24931137b3.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kZ8qvn0xSGEDmN1BULNYrOl9BfWlHWgwc5Hcokigkg=;
        b=EZdYCeKRzwTZI0V7uIlvSkGrs4qHYIezoRhReYtQLA0czf3gVL/1TNq7yKqDrl8GTn
         oQz0Z7XBBQH/yEQMO1SGLwncbAgZKGbmAOjFD34HdUxLfAxVVglbdugT3hkL39u2KBaC
         zXXOHY89LcKvSnZnJXUb8dDzrzFe4X7e3xR+WnsmfduMxTHD82PxDk3bNR9/eVBZSZCJ
         9KSr/LExzaCvHBnmGNmO5FnVmhBkHRZqq/6nuGCySvf95RTgk84Zq8NxZx5p92YocoN3
         edBU29eHd/xnGcG9xhXPifzW3E7yu6pOK5Yi9gnxeJFRaCY91DpX/jIM8sH3OWbKiQbv
         X7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kZ8qvn0xSGEDmN1BULNYrOl9BfWlHWgwc5Hcokigkg=;
        b=7sMKKFoWk1bryR99Yeu1154iLrZxqhzeWApVrjJEX+Ly6hpyOHZRH2ZM/2RoWnUW+4
         0JES6kGsy/t+xVLeaXtK5tO+DaaXq6ZAs9vw2icTgcsTGeL5qm6zNXZ7+k3je9OMhlDt
         V064+rdpcsryQOeQkx3fSCcHrCOypIaf2nrf8U+UvBQnvCOqa9kGbvWGYil9yvAtv5XJ
         bResRcbVYqh/3iVilyYwO1LCq1Xw1NBqAWoPigy9c37/TeMVjlNRi38oYLMU/v9yLu7R
         LFAxBnr3hjczT1cP6N+ZwQ5rncP5sQdEIAT3cJYr6yrOwJExcj+cWPIyi86vUAQyEYmZ
         wHxA==
X-Gm-Message-State: ANoB5pkPtRsL8Jb6VGP7CMSGZsFW4BRL+XIGDDIrfxETFOoDLIX0N76j
        XG4z/YEwPuC3693qqWngVBjHDsNSSbKKSQ==
X-Google-Smtp-Source: AA0mqf7VJDwYeOhSUwL8eiN/HYDWJI0TjJovtybda2o797oyUV7aBV39Tw6SLnFjKIqdIxSPeuhwuLTwG1fExA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:dfc3:0:b0:6f3:2748:7469 with SMTP id
 w186-20020a25dfc3000000b006f327487469mr53271438ybg.564.1670528390734; Thu, 08
 Dec 2022 11:39:50 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:46 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-27-dmatlack@google.com>
Subject: [RFC PATCH 26/37] KVM: Move page table cache to struct kvm_vcpu
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a kvm_mmu_memory_cache to struct kvm_vcpu for allocating pages for
page tables, replacing existing architecture-specific page table caches.

Purposely do not make management of this cache architecture-neutral
though to reduce churn and since not all architectures configure it the
same way (MIPS does not set __GFP_ZERO.)

This eliminates a dependency of the TDP MMU on an architecture-specific
field, which will be used in a future commit to move the TDP MMU to
common code.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 4 ++--
 arch/arm64/kvm/mmu.c              | 2 +-
 arch/mips/include/asm/kvm_host.h  | 3 ---
 arch/mips/kvm/mmu.c               | 4 ++--
 arch/riscv/include/asm/kvm_host.h | 3 ---
 arch/riscv/kvm/mmu.c              | 2 +-
 arch/riscv/kvm/vcpu.c             | 4 ++--
 arch/x86/include/asm/kvm_host.h   | 1 -
 arch/x86/kvm/mmu/mmu.c            | 8 ++++----
 arch/x86/kvm/mmu/tdp_mmu.c        | 2 +-
 include/linux/kvm_host.h          | 5 +++++
 12 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 001c8abe87fc..da519d6c09a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -473,9 +473,6 @@ struct kvm_vcpu_arch {
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
 
-	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
-
 	/* Target CPU and feature flags */
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..0e0d4c4f79a2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -340,7 +340,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
 
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->mmu_page_table_cache.gfp_zero = __GFP_ZERO;
 
 	/*
 	 * Default value for the FP state, will be overloaded at load
@@ -375,7 +375,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 31d7fa4c7c14..d431c5cdb26a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1196,7 +1196,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memory_cache *memcache = &vcpu->mmu_page_table_cache;
 	struct vm_area_struct *vma;
 	short vma_shift;
 	gfn_t gfn;
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 5cedb28e8a40..b7f276331583 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -344,9 +344,6 @@ struct kvm_vcpu_arch {
 	/* Bitmask of pending exceptions to be cleared */
 	unsigned long pending_exceptions_clr;
 
-	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
-
 	/* vcpu's vzguestid is different on each host cpu in an smp system */
 	u32 vzguestid[NR_CPUS];
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 74cd64a24d05..638f728d0bbe 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -27,7 +27,7 @@
 
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 }
 
 /**
@@ -589,7 +589,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 			     pte_t *out_entry, pte_t *out_buddy)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memory_cache *memcache = &vcpu->mmu_page_table_cache;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int srcu_idx, err;
 	kvm_pfn_t pfn;
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index dbbf43d52623..82e5d80347cc 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -219,9 +219,6 @@ struct kvm_vcpu_arch {
 	/* SBI context */
 	struct kvm_sbi_context sbi_context;
 
-	/* Cache pages needed to program page tables with spinlock held */
-	struct kvm_mmu_memory_cache mmu_page_cache;
-
 	/* VCPU power-off state */
 	bool power_off;
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3620ecac2fa1..a8281a65cb3d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -625,7 +625,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct vm_area_struct *vma;
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_mmu_memory_cache *pcache = &vcpu->arch.mmu_page_cache;
+	struct kvm_mmu_memory_cache *pcache = &vcpu->mmu_page_table_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
 	unsigned long vma_pagesize, mmu_seq;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 71ebbc4821f0..9a1001ada936 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -160,7 +160,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
-	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->mmu_page_table_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
 	/* Setup ISA features available to VCPU */
@@ -211,7 +211,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_timer_deinit(vcpu);
 
 	/* Free unused pages pre-allocated for G-stage page table mappings */
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 95c731028452..8cac8ec29324 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -714,7 +714,6 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu *walk_mmu;
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index aea7df3c2dcb..a845e9141ad4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -664,7 +664,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+	r = kvm_mmu_topup_memory_cache(&vcpu->mmu_page_table_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
@@ -681,7 +681,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->mmu_page_table_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -2218,7 +2218,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 {
 	struct shadow_page_caches caches = {
 		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
-		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
+		.shadow_page_cache = &vcpu->mmu_page_table_cache,
 		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
 	};
 
@@ -5920,7 +5920,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	vcpu->mmu_page_table_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5d1c9010d21..922815407b7e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -264,7 +264,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->mmu_page_table_cache);
 
 	return sp;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 242eaed55320..0a9baa493760 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -387,6 +387,11 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+	/* Cache used to allocate pages for use as page tables. */
+	struct kvm_mmu_memory_cache mmu_page_table_cache;
+#endif
 };
 
 /*
-- 
2.39.0.rc1.256.g54fd8350bd-goog

