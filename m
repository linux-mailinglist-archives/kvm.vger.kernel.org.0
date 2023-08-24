Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0731786984
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbjHXIGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240480AbjHXIGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:06:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5931BDB
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:37 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-68a41035828so3289684b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864314; x=1693469114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3N2qLIV1dOCTfZGrxfezfZCNqk3aw3I6ITB122p148=;
        b=KmMnpYLR9IuJ5tdXymssdKkrVpHH6nCmiyCa3qQW4Rilr0JQFELA5m87ZWYfut3pmA
         fysrOxyV+ru/71qrasjIWXzkfsAP2+sXyOGC5ezD+7SC7LGvnaruJNY8kw15hsYmQHfX
         8IQzokZvhpXo049qUnE0rm8sLA2ng20KMTZBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864314; x=1693469114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R3N2qLIV1dOCTfZGrxfezfZCNqk3aw3I6ITB122p148=;
        b=gyrMx+0Q8Ibshehwbgh7fQRrh+7AYcHkhm90KoXj3ApNqpT9WfdFnw1OIXoRnlQZlG
         3usw9/1qBVTgRqnKykDdVvuJkpSSrnaDPK0/nU9qk8E6sw3XWmjn+KaGpyqwUTY8MR7/
         8l1P7zXxSQc7i3c8yOEXB1caEwOd53E4gFvGTZS9lcyL4jXcXk1GYdr5bmca/HERz2gD
         d/pW+yPBtZdPEgvafyQpbz5sw1acA0E9wMYpg1W0oUQv2bosWwU4U5sHWM4rtTXDCpGs
         g/O45kVhCNbygmsIF1wu0UrpJCLoxVgFpFntfhiknsUlwA1efgHGw+ab+jppniKhRRfl
         tvVQ==
X-Gm-Message-State: AOJu0Yzxj0K0Z3trYe60SMT2mXy9iWnglmRUdoj5C6naVgMcM18oNlHB
        psAxdwDgx+BYKhqwOikjQSMFsQ==
X-Google-Smtp-Source: AGHT+IFQuzhiw+VNrMdIrBf0Ryoivf1q43SH2TuxYQh6Y66LpJ63BZQmwO6ZvOpnuBz8ux1MkDgcBA==
X-Received: by 2002:a05:6a21:778a:b0:14b:83f7:ef4f with SMTP id bd10-20020a056a21778a00b0014b83f7ef4fmr3998192pzc.34.1692864313823;
        Thu, 24 Aug 2023 01:05:13 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id m14-20020aa7900e000000b0068a3f861b24sm7002699pfo.195.2023.08.24.01.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:05:13 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: [PATCH v8 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
Date:   Thu, 24 Aug 2023 17:04:05 +0900
Message-ID: <20230824080408.2933205-6-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to map
memory into the guest that is backed by un-refcounted struct pages - for
example, the tail pages of higher order non-compound pages allocated by
the amdgpu driver via ttm_pool_alloc_page.

The bulk of this change is tracking the is_refcounted_page flag so that
non-refcounted pages don't trigger page_count() == 0 warnings. This is
done by storing the flag in an unused bit in the sptes. This only bit is
not available in PAE SPTEs, so FOLL_GET is only omitted for TDP on
x86-64.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c          | 55 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
 arch/x86/kvm/mmu/spte.c         |  4 ++-
 arch/x86/kvm/mmu/spte.h         | 12 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 22 +++++++------
 include/linux/kvm_host.h        |  3 ++
 virt/kvm/kvm_main.c             |  6 ++--
 8 files changed, 79 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dabae67f198b..4f5d33e95c6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -553,12 +553,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 
 	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		if (is_refcounted_page_pte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		if (is_refcounted_page_pte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	return flush;
@@ -596,14 +598,18 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	 * before they are reclaimed.  Sanity check that, if the pfn is backed
 	 * by a refcounted page, the refcount is elevated.
 	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON(page && !page_count(page));
+	if (is_refcounted_page_pte(old_spte)) {
+		page = kvm_pfn_to_refcounted_page(pfn);
+		WARN_ON(!page || !page_count(page));
+	}
 
-	if (is_accessed_spte(old_spte))
-		kvm_set_pfn_accessed(pfn);
+	if (is_refcounted_page_pte(old_spte)) {
+		if (is_accessed_spte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(pfn));
 
-	if (is_dirty_spte(old_spte))
-		kvm_set_pfn_dirty(pfn);
+		if (is_dirty_spte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(pfn));
+	}
 
 	return old_spte;
 }
@@ -639,8 +645,8 @@ static bool mmu_spte_age(u64 *sptep)
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(spte))
-			kvm_set_pfn_dirty(spte_to_pfn(spte));
+		if (is_writable_pte(spte) && is_refcounted_page_pte(spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
 
 		spte = mark_spte_for_access_track(spte);
 		mmu_spte_update_no_track(sptep, spte);
@@ -1278,8 +1284,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
+	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_pte(*sptep))
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
 
 	return was_writable;
 }
@@ -2937,6 +2943,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool host_writable = !fault || fault->map_writable;
 	bool prefetch = !fault || fault->prefetch;
 	bool write_fault = fault && fault->write;
+	/*
+	 * Prefetching uses gfn_to_page_many_atomic, which never gets
+	 * non-refcounted pages.
+	 */
+	bool is_refcounted = !fault || fault->is_refcounted_page;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
@@ -2969,7 +2980,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   true, host_writable, is_refcounted, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -4296,11 +4307,19 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	/*
+	 * We only allow non-refcounted pages if we can track whether or not
+	 * pages are refcounted via an SPTE bit. This bit is not available
+	 * in PAE SPTEs, so pass FOLL_GET if we may have to deal with those.
+	 */
+	unsigned int get_flag = (tdp_enabled && IS_ENABLED(CONFIG_X86_64)) ?
+		0 : FOLL_GET;
 	struct kvm_follow_pfn foll = {
 		.slot = slot,
 		.gfn = fault->gfn,
-		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
+		.flags = (fault->write ? FOLL_WRITE : 0) | get_flag,
 		.try_map_writable = true,
+		.guarded_by_mmu_notifier = true,
 	};
 
 	/*
@@ -4317,6 +4336,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
+			fault->is_refcounted_page = false;
 			return RET_PF_CONTINUE;
 		}
 		/*
@@ -4372,6 +4392,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 success:
 	fault->hva = foll.hva;
 	fault->map_writable = foll.writable;
+	fault->is_refcounted_page = foll.is_refcounted_page;
 	return RET_PF_CONTINUE;
 }
 
@@ -4456,8 +4477,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = direct_map(vcpu, fault);
 
 out_unlock:
+	if (fault->is_refcounted_page)
+		kvm_set_page_accessed(pfn_to_page(fault->pfn));
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
@@ -4534,8 +4556,9 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
+	if (fault->is_refcounted_page)
+		kvm_set_page_accessed(pfn_to_page(fault->pfn));
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce9..55790085884f 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -240,6 +240,7 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+	bool is_refcounted_page;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..4ffcebc0c3ce 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -828,8 +828,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
 out_unlock:
+	if (fault->is_refcounted_page)
+		kvm_set_page_accessed(pfn_to_page(fault->pfn));
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
@@ -883,7 +884,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	bool host_writable;
+	bool host_writable, is_refcounted;
 	gpa_t first_pte_gpa;
 	u64 *sptep, spte;
 	struct kvm_memory_slot *slot;
@@ -940,10 +941,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	sptep = &sp->spt[i];
 	spte = *sptep;
 	host_writable = spte & shadow_host_writable_mask;
+	is_refcounted = spte & SPTE_MMU_PAGE_REFCOUNTED;
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	make_spte(vcpu, sp, slot, pte_access, gfn,
 		  spte_to_pfn(spte), spte, true, false,
-		  host_writable, &spte);
+		  host_writable, is_refcounted, &spte);
 
 	return mmu_spte_update(sptep, spte);
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cf2c6426a6fc..5b13d9143d56 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+	       bool host_writable, bool is_refcounted, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
+	if (is_refcounted)
+		spte |= SPTE_MMU_PAGE_REFCOUNTED;
 
 	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1279db2eab44..be93dd061ae3 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -95,6 +95,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 /* Defined only to keep the above static asserts readable. */
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
+/*
+ * Indicates that the SPTE refers to a page with a valid refcount.
+ */
+#define SPTE_MMU_PAGE_REFCOUNTED        BIT_ULL(59)
+
 /*
  * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
@@ -332,6 +337,11 @@ static inline bool is_dirty_spte(u64 spte)
 	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
 }
 
+static inline bool is_refcounted_page_pte(u64 spte)
+{
+	return spte & SPTE_MMU_PAGE_REFCOUNTED;
+}
+
 static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
 				int level)
 {
@@ -462,7 +472,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte);
+	       bool host_writable, bool is_refcounted, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..a9b1b14d2e26 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -474,6 +474,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool is_refcounted = is_refcounted_page_pte(old_spte);
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -538,9 +539,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (is_leaf != was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
-	if (was_leaf && is_dirty_spte(old_spte) &&
+	if (was_leaf && is_dirty_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -552,9 +553,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 
-	if (was_leaf && is_accessed_spte(old_spte) &&
+	if (was_leaf && is_accessed_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 }
 
 /*
@@ -988,8 +989,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+				   fault->pfn, iter->old_spte, fault->prefetch, true,
+				   fault->map_writable, fault->is_refcounted_page,
+				   &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1205,8 +1207,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(iter->old_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
+		if (is_writable_pte(iter->old_spte) &&
+		    is_refcounted_page_pte(iter->old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter->old_spte)));
 
 		new_spte = mark_spte_for_access_track(iter->old_spte);
 		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
@@ -1626,7 +1629,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
+		if (is_refcounted_page_pte(iter.old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 713fc2d91f95..292701339198 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1157,6 +1157,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+void kvm_set_page_accessed(struct page *page);
+void kvm_set_page_dirty(struct page *page);
+
 struct kvm_follow_pfn {
 	const struct kvm_memory_slot *slot;
 	gfn_t gfn;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 963b96cd8ff9..fa1848c6c84f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2949,17 +2949,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
 	return !PageReserved(page);
 }
 
-static void kvm_set_page_dirty(struct page *page)
+void kvm_set_page_dirty(struct page *page)
 {
 	if (kvm_is_ad_tracked_page(page))
 		SetPageDirty(page);
 }
+EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
 
-static void kvm_set_page_accessed(struct page *page)
+void kvm_set_page_accessed(struct page *page)
 {
 	if (kvm_is_ad_tracked_page(page))
 		mark_page_accessed(page);
 }
+EXPORT_SYMBOL_GPL(kvm_set_page_accessed);
 
 void kvm_release_page_clean(struct page *page)
 {
-- 
2.42.0.rc1.204.g551eb34607-goog

