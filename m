Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3090B3DC167
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 01:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhG3W76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhG3W7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:59:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9259C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:49 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o23-20020a17090a4217b02901774c248202so851724pjg.9
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h3wR/inEshwcepNJ/0RKSZbSm/G4aslO5vxWa90kRF0=;
        b=nVvTNb4HFHJ3Sfs7k2PdcrbJM77NFSFEcNh9a0ZRiMyIBsIoK95ugVB/UqGCk2+kro
         yEbd2KGQw/6sAJbWdUPhQg6qkOXU20lj0fWbbrxm4QjZGMW/xIJc1G0F4wMfc7yhs3uQ
         3yCMTCuQLu2tU3t4y9eUVcursWBAPTkBFXYF8qTcArrDNkJJNt+ReM93mqHyGhbsHQfh
         5mQgfDlGzQjxRTI8ILkb7rxxRmkr8CZNFebPfJoFYhYeCNfypicwZ0gZIhTY4+NDkpnX
         HaZQC5uVfqbpSskuValdgNA/hHXHHfdP3xT6l/WeyITNDgCRzx7Tf1rWA3tDt/cmfL7z
         DsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h3wR/inEshwcepNJ/0RKSZbSm/G4aslO5vxWa90kRF0=;
        b=LsRYP2M+ul3cL6H6itKMxxKrQEGt1ABfuJw6SR7x09mGE55dVSj36rCVFLDaGwRbLv
         e2BnVaMBYAepDD5xcw58DIZy3MnWWBrEp0ZrXRTV7tgwGUuqQp0St+EGZUYGuY/gxvBD
         YvgSfy15InsdFVgetXSICIgi67Bfov1ODB1pHxzjA/9oaMB+mIU4TtDKYvTC+YzYjGy8
         ahQe4JSw/TgKP2q9MF4/cdMoeM1GzZoeg6N3YiJC8M4bNSpvh/OFNqCiUE8z7peHrKPq
         RaQicKBbVmas6bbdWA7P88AN4BM6eXY3P5+LNnMWsnWVp4IMqsgS1FINU8aChs+1mOdl
         ivaw==
X-Gm-Message-State: AOAM531AUSgA5okK5Ae2wxHwNm5k8mzFKHPlrZICwO5K+uVey/3PMBHL
        tgIDt2SLQ+z3xrhcmNLEQQQsTfbEegOf
X-Google-Smtp-Source: ABdhPJwdxli16B09pU9KfhARf6lWY2wP2fyrzdyyP1RhntfSq+I2SNI/DmdZogdrWsnU6g3Db46r2xdOnrx4
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:a198:4c3e:b951:58e3])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:91:b029:330:8ab3:d7d9 with SMTP
 id c17-20020a056a000091b02903308ab3d7d9mr4850465pfj.22.1627685989283; Fri, 30
 Jul 2021 15:59:49 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jul 2021 15:59:39 -0700
In-Reply-To: <20210730225939.3852712-1-mizhang@google.com>
Message-Id: <20210730225939.3852712-4-mizhang@google.com>
Mime-Version: 1.0
References: <20210730225939.3852712-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3 3/3] KVM: x86/mmu: Add detailed page size stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Existing KVM code tracks the number of large pages regardless of their
sizes. Therefore, when large page of 1GB (or larger) is adopted, the
information becomes less useful because lpages counts a mix of 1G and 2M
pages.

So remove the lpages since it is easy for user space to aggregate the info.
Instead, provide a comprehensive page stats of all sizes from 4K to 512G.

Suggested-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 +++++++++-
 arch/x86/kvm/mmu.h              |  4 ++++
 arch/x86/kvm/mmu/mmu.c          | 26 +++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.c      | 15 ++-------------
 arch/x86/kvm/x86.c              |  7 +++++--
 5 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..eb6edc36b3ed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1206,9 +1206,17 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	u64 lpages;
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
+	union {
+		struct {
+			atomic64_t pages_4k;
+			atomic64_t pages_2m;
+			atomic64_t pages_1g;
+			atomic64_t pages_512g;
+		};
+		atomic64_t pages[4];
+	};
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 83e6c6965f1e..2883789fb5fb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -240,4 +240,8 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 	return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
 }
 
+static inline void kvm_update_page_stats(struct kvm *kvm, int level, int count)
+{
+	atomic64_add(count, &kvm->stat.pages[level - 1]);
+}
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 442cc554ebd6..2308537b1807 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -594,10 +594,11 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns non-zero if the PTE was previously valid.
  */
-static int mmu_spte_clear_track_bits(u64 *sptep)
+static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
+	int level = sptep_to_sp(sptep)->role.level;
 
 	if (!spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, 0ull);
@@ -607,6 +608,8 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	if (!is_shadow_present_pte(old_spte))
 		return 0;
 
+	kvm_update_page_stats(kvm, level, -1);
+
 	pfn = spte_to_pfn(old_spte);
 
 	/*
@@ -984,9 +987,10 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 	}
 }
 
-static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
+static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			    u64 *sptep)
 {
-	mmu_spte_clear_track_bits(sptep);
+	mmu_spte_clear_track_bits(kvm, sptep);
 	__pte_list_remove(sptep, rmap_head);
 }
 
@@ -1119,7 +1123,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (mmu_spte_clear_track_bits(sptep))
+	if (mmu_spte_clear_track_bits(kvm, sptep))
 		rmap_remove(kvm, sptep);
 }
 
@@ -1129,7 +1133,6 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 	if (is_large_pte(*sptep)) {
 		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
 		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
 		return true;
 	}
 
@@ -1386,7 +1389,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	while ((sptep = rmap_get_first(rmap_head, &iter))) {
 		rmap_printk("spte %p %llx.\n", sptep, *sptep);
 
-		pte_list_remove(rmap_head, sptep);
+		pte_list_remove(kvm, rmap_head, sptep);
 		flush = true;
 	}
 
@@ -1421,13 +1424,13 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		need_flush = 1;
 
 		if (pte_write(pte)) {
-			pte_list_remove(rmap_head, sptep);
+			pte_list_remove(kvm, rmap_head, sptep);
 			goto restart;
 		} else {
 			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
 					*sptep, new_pfn);
 
-			mmu_spte_clear_track_bits(sptep);
+			mmu_spte_clear_track_bits(kvm, sptep);
 			mmu_spte_set(sptep, new_spte);
 		}
 	}
@@ -2232,8 +2235,6 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	if (is_shadow_present_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
-			if (is_large_pte(pte))
-				--kvm->stat.lpages;
 		} else {
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
@@ -2692,8 +2693,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
 
 	if (!was_rmapped) {
-		if (is_large_pte(*sptep))
-			++vcpu->kvm->stat.lpages;
+		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_count = rmap_add(vcpu, sptep, gfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, sptep, gfn);
@@ -5669,7 +5669,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
-			pte_list_remove(rmap_head, sptep);
+			pte_list_remove(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
 				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cba2ab5db2a0..eae404c15364 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -413,7 +413,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-	bool was_large, is_large;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -472,18 +471,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		return;
 	}
 
-	/*
-	 * Update large page stats if a large page is being zapped, created, or
-	 * is replacing an existing shadow page.
-	 */
-	was_large = was_leaf && is_large_pte(old_spte);
-	is_large = is_leaf && is_large_pte(new_spte);
-	if (was_large != is_large) {
-		if (was_large)
-			atomic64_sub(1, (atomic64_t *)&kvm->stat.lpages);
-		else
-			atomic64_add(1, (atomic64_t *)&kvm->stat.lpages);
-	}
+	if (is_leaf != was_leaf)
+		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8166ad113fb2..e4dfcd5d83ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -235,9 +235,12 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, mmu_recycled),
 	STATS_DESC_COUNTER(VM, mmu_cache_miss),
 	STATS_DESC_ICOUNTER(VM, mmu_unsync),
-	STATS_DESC_ICOUNTER(VM, lpages),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
+	STATS_DESC_ICOUNTER(VM, pages_4k),
+	STATS_DESC_ICOUNTER(VM, pages_2m),
+	STATS_DESC_ICOUNTER(VM, pages_1g),
+	STATS_DESC_ICOUNTER(VM, pages_512g)
 };
 static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
 		sizeof(struct kvm_vm_stat) / sizeof(u64));
-- 
2.32.0.554.ge1b32706d8-goog

