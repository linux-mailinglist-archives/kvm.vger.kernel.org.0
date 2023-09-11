Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3879A136
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 04:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjIKCSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Sep 2023 22:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjIKCSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Sep 2023 22:18:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E434E40
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:46 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68fb7fb537dso558663b3a.2
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694398631; x=1695003431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91mLy+G3O/xIpYQLZgTXP1iR98nXkRw1gYxVierAmLM=;
        b=BdvIMiTzDzYzyJroOoBF07UgFHQQAzzho3wIGtRbxNIw9ELXFKX66rc8aMI7Ki8dxl
         x/XrOAo6XWDKksTOeXN9LR6eZrkqpAy+aggAVP4Ru3IHK0rHIIlyalUhrvnrJ1+G4Xia
         4XIWitulOhyNwIg3oN3Ec+3AyIdkLOwEauKTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694398631; x=1695003431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91mLy+G3O/xIpYQLZgTXP1iR98nXkRw1gYxVierAmLM=;
        b=dSFbmCNavhqEWMjJXPI/Ws70mcCjT6DSdLLpmuHzRORIzEgkl9az7PoB+J6i9w7lbU
         DXzs6nvmgX6/0/H33Ghay4o8X7KBbo1M8h4ZfgHIA9bswHdGK8yME5ti8wCsCoDgZnLf
         9jEwQwcWU/Pft9A7gneMo8CA1Qx/XBdq2XwCczhHkSxDKi2948kvzYqIJrltkigpioIV
         yLQcKcMI2DNhkD6qYG7ne+J6Qw77POCl0/aDJgsLjuDOdgqOkoSmha0W6J0+yVEwzoV1
         x/ahsPBNZbUJcTiWasT5cuRipmogvZG0sdNbGJLmVGu75ty443fo5+tonlNQLAkI1Lh9
         /KrA==
X-Gm-Message-State: AOJu0YynsefhGAzRZC8Gj2IRP0WXmJefxKL01SBZ5szcliJ9nHmeIqh6
        SWGyZBufV8ly5VWY+yqw7UYd+jbtQeyqNNInQCM=
X-Google-Smtp-Source: AGHT+IEF78He+7+PkQmYAuwbgimpofpg6YfXs4vDl0ZW8a5/SBfT4Pu8o+FolgBcnBH93tJqiem73Q==
X-Received: by 2002:a05:6a00:1989:b0:68c:705d:78b3 with SMTP id d9-20020a056a00198900b0068c705d78b3mr7505251pfl.28.1694398631461;
        Sun, 10 Sep 2023 19:17:11 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:282a:59c8:cc3a:2d6])
        by smtp.gmail.com with UTF8SMTPSA id m2-20020aa79002000000b0068702b66ab1sm4596005pfo.174.2023.09.10.19.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 19:17:11 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
Date:   Mon, 11 Sep 2023 11:16:36 +0900
Message-ID: <20230911021637.1941096-7-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
to map memory into the guest that is backed by non-refcounted struct
pages - for example, the tail pages of higher order non-compound pages
allocated by the amdgpu driver via ttm_pool_alloc_page.

The bulk of this change is tracking the is_refcounted_page flag so that
non-refcounted pages don't trigger page_count() == 0 warnings. This is
done by storing the flag in an unused bit in the sptes. There are no
bits available in PAE SPTEs, so non-refcounted pages can only be handled
on TDP and x86-64.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
 arch/x86/kvm/mmu/spte.c         |  4 ++-
 arch/x86/kvm/mmu/spte.h         | 12 +++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
 include/linux/kvm_host.h        |  3 ++
 virt/kvm/kvm_main.c             |  6 ++--
 8 files changed, 76 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1eca26215e2..b8168cc4cc96 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -545,12 +545,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 
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
@@ -588,14 +590,18 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	 * before they are reclaimed.  Sanity check that, if the pfn is backed
 	 * by a refcounted page, the refcount is elevated.
 	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON_ONCE(page && !page_count(page));
+	if (is_refcounted_page_pte(old_spte)) {
+		page = kvm_pfn_to_refcounted_page(pfn);
+		WARN_ON_ONCE(!page || !page_count(page));
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
@@ -631,8 +637,8 @@ static bool mmu_spte_age(u64 *sptep)
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(spte))
-			kvm_set_pfn_dirty(spte_to_pfn(spte));
+		if (is_writable_pte(spte) && is_refcounted_page_pte(spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
 
 		spte = mark_spte_for_access_track(spte);
 		mmu_spte_update_no_track(sptep, spte);
@@ -1261,8 +1267,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
+	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_pte(*sptep))
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
 
 	return was_writable;
 }
@@ -2913,6 +2919,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool host_writable = !fault || fault->map_writable;
 	bool prefetch = !fault || fault->prefetch;
 	bool write_fault = fault && fault->write;
+	/*
+	 * Prefetching uses gfn_to_page_many_atomic, which never gets
+	 * non-refcounted pages.
+	 */
+	bool is_refcounted = !fault || fault->is_refcounted_page;
 
 	if (unlikely(is_noslot_pfn(pfn))) {
 		vcpu->stat.pf_mmio_spte_created++;
@@ -2940,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   true, host_writable, is_refcounted, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -4254,13 +4265,18 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
+	/*
+	 * There are no extra bits for tracking non-refcounted pages in
+	 * PAE SPTEs, so reject non-refcounted struct pages in that case.
+	 */
+	bool has_spte_refcount_bit = tdp_enabled && IS_ENABLED(CONFIG_X86_64);
 	struct kvm_follow_pfn foll = {
 		.slot = slot,
 		.gfn = fault->gfn,
 		.flags = fault->write ? FOLL_WRITE : 0,
 		.try_map_writable = true,
 		.guarded_by_mmu_notifier = true,
-		.allow_non_refcounted_struct_page = false,
+		.allow_non_refcounted_struct_page = has_spte_refcount_bit,
 	};
 
 	/*
@@ -4277,6 +4293,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
+			fault->is_refcounted_page = false;
 			return RET_PF_CONTINUE;
 		}
 		/*
@@ -4332,6 +4349,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 success:
 	fault->hva = foll.hva;
 	fault->map_writable = foll.writable;
+	fault->is_refcounted_page = foll.is_refcounted_page;
 	return RET_PF_CONTINUE;
 }
 
@@ -4420,8 +4438,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = direct_map(vcpu, fault);
 
 out_unlock:
+	if (fault->is_refcounted_page)
+		kvm_set_page_accessed(pfn_to_page(fault->pfn));
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
@@ -4496,8 +4515,9 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
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
index b102014e2c60..7f73bc2a552e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -239,6 +239,7 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+	bool is_refcounted_page;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f67..0ac4a4e5870c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -848,7 +848,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	if (fault->is_refcounted_page)
+		kvm_set_page_accessed(pfn_to_page(fault->pfn));
 	return r;
 }
 
@@ -902,7 +903,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	bool host_writable;
+	bool host_writable, is_refcounted;
 	gpa_t first_pte_gpa;
 	u64 *sptep, spte;
 	struct kvm_memory_slot *slot;
@@ -959,10 +960,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
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
index 4a599130e9c9..ce495819061f 100644
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
index a129951c9a88..4bf4a535c23d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -96,6 +96,11 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
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
@@ -345,6 +350,11 @@ static inline bool is_dirty_spte(u64 spte)
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
@@ -475,7 +485,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte);
+	       bool host_writable, bool is_refcounted, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c63f2d1675f..185f3c666c2b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -474,6 +474,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool is_refcounted = is_refcounted_page_pte(old_spte);
 
 	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON_ONCE(level < PG_LEVEL_4K);
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
@@ -1628,7 +1631,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
+		if (is_refcounted_page_pte(iter.old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b95c79b7833b..6696925f01f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1179,6 +1179,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+void kvm_set_page_accessed(struct page *page);
+void kvm_set_page_dirty(struct page *page);
+
 struct kvm_follow_pfn {
 	const struct kvm_memory_slot *slot;
 	gfn_t gfn;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 913de4e86d9d..4d8538cdb690 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2979,17 +2979,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
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
2.42.0.283.g2d96d420d3-goog

