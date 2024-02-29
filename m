Return-Path: <kvm+bounces-10345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3969D86BF35
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550781C20627
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0FCE446D3;
	Thu, 29 Feb 2024 02:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OSJZ1f5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C8446AC
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175522; cv=none; b=og48cPdG6VBV9klOQ9AX8UwMBAHBcPYqBygyj0GoX0q2WNE/AYHTghXdpyJXo+12gdqogL7jcq+Ew4zN4z+c0RHiaMxWqUgys9+3f/kbmiSTNOnPPpgVA0dPCunm1MnInEdM4MZlUqEWT43mQ4+kLSFYXDu6E/DEq/t5mbX+tV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175522; c=relaxed/simple;
	bh=mx4ftk9A2eIm9XAiiyU38OIODZ8JYeMn5dt8m6qb2xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlBv0OFvQjbYVS/8XndpBUrMP2wbYIr57zoxN2jztVebWM1BXLN0Q1ma+xg3Ah0ODMc3Oi8lvNHpIMNpV+LRnkyRN4AiYjtl2AWGO6+KNjYkj5iRHgyCwCkxW6NVLoWaILp24mTTdUwDCN+C/TIvoJj8Gk9PtyLIEyyuOP5bU8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=OSJZ1f5M; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-214def5da12so218030fac.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175519; x=1709780319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkoJpJo0GmazuamQk6RjcdpeI7xXFyOUp8sC9NxHbRI=;
        b=OSJZ1f5MVL/wYvFWJSp5mZ9WtNfkduU/eKx0FTVD/QunRr+FZRNvWTq2zQzQouwyd1
         KSIsxDkRZ0/TpAWFeBQpcKPHn++cMNm0WNjM4+wNb8AnoS76o5SPDXPmfnpjurLdnXP4
         1IbSyyIJkQpdQe1UhUfu6brQN7F4EPP5SKV7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175519; x=1709780319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkoJpJo0GmazuamQk6RjcdpeI7xXFyOUp8sC9NxHbRI=;
        b=iZiGHatW+xTpwE1jhMtXnw+um9oTM29UbI7q4dB9AReDUbSb8flmjWxRRZDtmwbohC
         36ffbBjvNPvwUs343rUZYtY42rV+C/IUBMZUSFI++L0sSPARIOKE4Lmxt/rUwTMta6mG
         Fr0cZeFPvoVNZEaUJezF91RHLHq6sTNIL7nlrcg3cZ7ad+ehqmyb2p4gqtj7b83XURl/
         ynxX/hXFETDGHtw1GhTNsWBGutY4t67tgKyxQT6RH9a44w+NleD1eMC7EJZKJJrJ9rmq
         oei3laPNeItJu8BzJi6DJcMr2NZq3XSuoZc3V/dL1hhRGccTbFt6ajpZR7IpORr3ZhQ3
         NUaA==
X-Forwarded-Encrypted: i=1; AJvYcCVXD9vO9ICE82WV9r5LfwIrWyrKnkk+5qyD88fCeBKiq/hmuBL4PIbtpI8qpjPp8cHc0kAjHXh7rlMlqXIKGUT4GtwI
X-Gm-Message-State: AOJu0YxECU+H5WMMAW9ENY3XUc2zr9aoTZnXFI95YZJKEQHfD/Ba1fu7
	chQ9i+zVupmv4pZftjQTciE+vz++a6aPSpiNYRFbFJqROXywupcVYvuB7jMgsQ==
X-Google-Smtp-Source: AGHT+IHgSlYOUqHE4Ztt8RlztYFhsUc43C3tIJE3BmbRfEvMcUwAl07lFXU547r4/LOxkwdG5eTJ8Q==
X-Received: by 2002:a05:6870:a79e:b0:21f:cd31:f051 with SMTP id x30-20020a056870a79e00b0021fcd31f051mr796695oao.11.1709175519257;
        Wed, 28 Feb 2024 18:58:39 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id z12-20020aa785cc000000b006e56e5c09absm166699pfn.14.2024.02.28.18.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:38 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
Date: Thu, 29 Feb 2024 11:57:58 +0900
Message-ID: <20240229025759.1187910-8-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Use one of the unused bits in EPT sptes to track whether or not an spte
refers to a struct page that has a valid refcount, in preparation for
adding support for mapping such pages into guests. The new bit is used
to avoid triggering a page_count() == 0 warning and to avoid touching
A/D bits of unknown usage.

Non-EPT sptes don't have any free bits to use, so this tracking is not
possible when TDP is disabled or on 32-bit x86.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c         | 47 ++++++++++++++++++++--------------
 arch/x86/kvm/mmu/paging_tmpl.h |  5 ++--
 arch/x86/kvm/mmu/spte.c        |  5 +++-
 arch/x86/kvm/mmu/spte.h        | 16 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c     | 21 ++++++++-------
 include/linux/kvm_host.h       |  3 +++
 virt/kvm/kvm_main.c            |  6 +++--
 7 files changed, 69 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bbeb0f6783d7..4936a8c5829b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -541,12 +541,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 
 	if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		if (is_refcounted_page_spte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
 		flush = true;
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		if (is_refcounted_page_spte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 	}
 
 	return flush;
@@ -578,20 +580,23 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 
 	pfn = spte_to_pfn(old_spte);
 
-	/*
-	 * KVM doesn't hold a reference to any pages mapped into the guest, and
-	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
-	 * before they are reclaimed.  Sanity check that, if the pfn is backed
-	 * by a refcounted page, the refcount is elevated.
-	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	WARN_ON_ONCE(page && !page_count(page));
+	if (is_refcounted_page_spte(old_spte)) {
+		/*
+		 * KVM doesn't hold a reference to any pages mapped into the
+		 * guest, and instead uses the mmu_notifier to ensure that KVM
+		 * unmaps any pages before they are reclaimed. Sanity check
+		 * that, if the pfn is backed by a refcounted page, the
+		 * refcount is elevated.
+		 */
+		page = kvm_pfn_to_refcounted_page(pfn);
+		WARN_ON_ONCE(!page || !page_count(page));
 
-	if (is_accessed_spte(old_spte))
-		kvm_set_pfn_accessed(pfn);
+		if (is_accessed_spte(old_spte))
+			kvm_set_page_accessed(pfn_to_page(pfn));
 
-	if (is_dirty_spte(old_spte))
-		kvm_set_pfn_dirty(pfn);
+		if (is_dirty_spte(old_spte))
+			kvm_set_page_dirty(pfn_to_page(pfn));
+	}
 
 	return old_spte;
 }
@@ -627,8 +632,8 @@ static bool mmu_spte_age(u64 *sptep)
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(spte))
-			kvm_set_pfn_dirty(spte_to_pfn(spte));
+		if (is_writable_pte(spte) && is_refcounted_page_spte(spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(spte)));
 
 		spte = mark_spte_for_access_track(spte);
 		mmu_spte_update_no_track(sptep, spte);
@@ -1267,8 +1272,8 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
+	if (was_writable && !spte_ad_enabled(*sptep) && is_refcounted_page_spte(*sptep))
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(*sptep)));
 
 	return was_writable;
 }
@@ -2946,7 +2951,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, &spte);
+			   true, host_writable, true, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -5999,6 +6004,10 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 #ifdef CONFIG_X86_64
 	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+
+	/* The SPTE_MMU_PAGE_REFCOUNTED bit is only available with EPT. */
+	if (enable_tdp)
+		shadow_refcounted_mask = SPTE_MMU_PAGE_REFCOUNTED;
 #endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..c965f77ac4d5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -902,7 +902,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	bool host_writable;
+	bool host_writable, is_refcounted;
 	gpa_t first_pte_gpa;
 	u64 *sptep, spte;
 	struct kvm_memory_slot *slot;
@@ -959,10 +959,11 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
 	sptep = &sp->spt[i];
 	spte = *sptep;
 	host_writable = spte & shadow_host_writable_mask;
+	is_refcounted = is_refcounted_page_spte(spte);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	make_spte(vcpu, sp, slot, pte_access, gfn,
 		  spte_to_pfn(spte), spte, true, false,
-		  host_writable, &spte);
+		  host_writable, is_refcounted, &spte);
 
 	return mmu_spte_update(sptep, spte);
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..e4a458b7e185 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -39,6 +39,7 @@ u64 __read_mostly shadow_memtype_mask;
 u64 __read_mostly shadow_me_value;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
+u64 __read_mostly shadow_refcounted_mask;
 
 u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
@@ -138,7 +139,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+	       bool host_writable, bool is_refcounted, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -188,6 +189,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
+	if (is_refcounted)
+		spte |= shadow_refcounted_mask;
 
 	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a88..6bf0069d8db6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -96,6 +96,13 @@ static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 /* Defined only to keep the above static asserts readable. */
 #undef SHADOW_ACC_TRACK_SAVED_MASK
 
+/*
+ * Indicates that the SPTE refers to a page with a valid refcount. Only
+ * available for TDP SPTEs, since bits 62:52 are reserved for PAE paging,
+ * including NPT PAE.
+ */
+#define SPTE_MMU_PAGE_REFCOUNTED        BIT_ULL(59)
+
 /*
  * Due to limited space in PTEs, the MMIO generation is a 19 bit subset of
  * the memslots generation and is derived as follows:
@@ -345,6 +352,13 @@ static inline bool is_dirty_spte(u64 spte)
 	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
 }
 
+extern u64 __read_mostly shadow_refcounted_mask;
+
+static inline bool is_refcounted_page_spte(u64 spte)
+{
+	return !shadow_refcounted_mask || (spte & shadow_refcounted_mask);
+}
+
 static inline u64 get_rsvd_bits(struct rsvd_bits_validate *rsvd_check, u64 pte,
 				int level)
 {
@@ -475,7 +489,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte);
+	       bool host_writable, bool is_refcounted, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6ae19b4ee5b1..ee497fb78d90 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -414,6 +414,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool is_refcounted = is_refcounted_page_spte(old_spte);
 
 	WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON_ONCE(level < PG_LEVEL_4K);
@@ -478,9 +479,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (is_leaf != was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
-	if (was_leaf && is_dirty_spte(old_spte) &&
+	if (was_leaf && is_dirty_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_page_dirty(pfn_to_page(spte_to_pfn(old_spte)));
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -492,9 +493,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 
-	if (was_leaf && is_accessed_spte(old_spte) &&
+	if (was_leaf && is_accessed_spte(old_spte) && is_refcounted &&
 	    (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+		kvm_set_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
 }
 
 /*
@@ -956,8 +957,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+				   fault->pfn, iter->old_spte, fault->prefetch, true,
+				   fault->map_writable, true, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1178,8 +1179,9 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 		 * Capture the dirty status of the page, so that it doesn't get
 		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (is_writable_pte(iter->old_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
+		if (is_writable_pte(iter->old_spte) &&
+		    is_refcounted_page_spte(iter->old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter->old_spte)));
 
 		new_spte = mark_spte_for_access_track(iter->old_spte);
 		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
@@ -1602,7 +1604,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
+		if (is_refcounted_page_spte(iter.old_spte))
+			kvm_set_page_dirty(pfn_to_page(spte_to_pfn(iter.old_spte)));
 	}
 
 	rcu_read_unlock();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 59dc9fbafc08..d19a418df04b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1211,6 +1211,9 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 
+void kvm_set_page_accessed(struct page *page);
+void kvm_set_page_dirty(struct page *page);
+
 struct kvm_follow_pfn {
 	const struct kvm_memory_slot *slot;
 	gfn_t gfn;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 24e2269339cb..235c92830cdc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3277,17 +3277,19 @@ static bool kvm_is_ad_tracked_page(struct page *page)
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
2.44.0.rc1.240.g4c46232300-goog


