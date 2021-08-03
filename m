Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4B23DE5AB
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 06:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhHCEqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 00:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbhHCEqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 00:46:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19FFC06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 21:46:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l16-20020a170902f690b029012cb82f15afso4476954plg.10
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 21:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5UjpISDzrwGZMuhZ3ho5okX6MWp1EpQ+2CzL/sQfoi8=;
        b=KAelLFMnY3ptM3Vh51kl5Kr8w9a7XsV9tRFIdwinbxUio60eYEp5hINBI3by/dElW1
         Q9e7uScEWVbgKie9JhELJW0UZzob3a4ZeaLEx2H3CNA9tWMPdi+UokLIG7M7LdGrvLeB
         KY6d6zg/zb/TgOu6slVeR4P/21AtA1y5mUzlipkKjfYy+JuCrmtrVpy57WsnJc3UPQ76
         CeYkHbXOPu7u/7ulAF9mepbe+xvXZC/UmaegcjtiFa4LM6KjpnTjm56vD/qH0+jVAZgM
         yExJfe9SpCeCstE+VyjVPt4l2CnUqFdyhFqN8UPCkrSl7460UmwC02y2IOMpdW2V+qUy
         cebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5UjpISDzrwGZMuhZ3ho5okX6MWp1EpQ+2CzL/sQfoi8=;
        b=MIE1wruzGTbPBgsyzFnk+KvFbiJqMCbQczIU2IxkWDO0QNpr4/X7quOnqgkUV99slM
         kRsxm3H5h4sBxFuPtl9pHrxqUiD0RstjV/gxp9xLqOCSqx5We1q+yMyAOLeV2VGEaTm5
         jENXmURiZASJ5DItzEaCLMp2MkTcRu1Q4IRi6TowsoePf2HGiKRvoEr3Awkm2I3jrzFb
         BIxqh5WN+Z3D3mJ/W2/SRgBeDPBP0dtJjhRwblUqTfb64SBhDz5Xfs824np+iJ0JKftM
         n17TRb5igjrTOLtYQs+xzUhETMyslgkCWCVgytAbzgzLxsSbuBPO1KbKYpLIbHizHAPy
         XrEg==
X-Gm-Message-State: AOAM5338c+OuVGw7+8MEGStlP1J5m08DJ8z6xn1KiHlxnMG7yeb6V/ts
        CFVq7AKabE58xF4HzWFy/vUQPTZ9ssc4
X-Google-Smtp-Source: ABdhPJy6wPdqBkcDiUx8rIlq1qz8BE0dfJT1TMDKJF8oJTGoGFqpFh3fZMBXDya6ruyTJNb2jexEaMbuGool
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:4304:2e3e:d2f5:48c8])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:a88:b029:31a:c2ef:d347 with SMTP
 id b8-20020a056a000a88b029031ac2efd347mr20773323pfl.20.1627965991322; Mon, 02
 Aug 2021 21:46:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  2 Aug 2021 21:46:07 -0700
In-Reply-To: <20210803044607.599629-1-mizhang@google.com>
Message-Id: <20210803044607.599629-4-mizhang@google.com>
Mime-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 ++++++++-
 arch/x86/kvm/mmu.h              |  4 ++++
 arch/x86/kvm/mmu/mmu.c          | 38 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_mmu.c      | 15 ++-----------
 arch/x86/kvm/x86.c              |  5 ++++-
 5 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99f37781a6fc..c95bf4bbd2ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1206,7 +1206,15 @@ struct kvm_vm_stat {
 	u64 mmu_recycled;
 	u64 mmu_cache_miss;
 	u64 mmu_unsync;
-	u64 lpages;
+	union {
+		struct {
+			atomic64_t pages_4k;
+			atomic64_t pages_2m;
+			atomic64_t pages_1g;
+			atomic64_t pages_512g;
+		};
+		atomic64_t pages[4];
+	};
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
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
index f614e9df3c3b..8f46c1164f3f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -599,10 +599,11 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * state bits, it is used to clear the last level sptep.
  * Returns the old PTE.
  */
-static u64 mmu_spte_clear_track_bits(u64 *sptep)
+static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
+	int level = sptep_to_sp(sptep)->role.level;
 
 	if (!spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, 0ull);
@@ -612,6 +613,8 @@ static u64 mmu_spte_clear_track_bits(u64 *sptep)
 	if (!is_shadow_present_pte(old_spte))
 		return old_spte;
 
+	kvm_update_page_stats(kvm, level, -1);
+
 	pfn = spte_to_pfn(old_spte);
 
 	/*
@@ -996,15 +999,16 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
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
 
 /* Return true if rmap existed and callback called, false otherwise */
-static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
-			     void (*callback)(u64 *sptep))
+static bool pte_list_destroy(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			     void (*callback)(struct kvm *kvm, u64 *sptep))
 {
 	struct pte_list_desc *desc, *next;
 	int i;
@@ -1014,7 +1018,7 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
 
 	if (!(rmap_head->val & 1)) {
 		if (callback)
-			callback((u64 *)rmap_head->val);
+			callback(kvm, (u64 *)rmap_head->val);
 		goto out;
 	}
 
@@ -1023,7 +1027,7 @@ static bool pte_list_destroy(struct kvm_rmap_head *rmap_head,
 	while (desc) {
 		if (callback)
 			for (i = 0; i < desc->spte_count; i++)
-				callback(desc->sptes[i]);
+				callback(kvm, desc->sptes[i]);
 		next = desc->more;
 		mmu_free_pte_list_desc(desc);
 		desc = next;
@@ -1163,7 +1167,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	u64 old_spte = mmu_spte_clear_track_bits(sptep);
+	u64 old_spte = mmu_spte_clear_track_bits(kvm, sptep);
 
 	if (is_shadow_present_pte(old_spte))
 		rmap_remove(kvm, sptep);
@@ -1175,7 +1179,6 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
 	if (is_large_pte(*sptep)) {
 		WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
 		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
 		return true;
 	}
 
@@ -1422,15 +1425,15 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
-static void mmu_spte_clear_track_bits_cb(u64 *sptep)
+static void mmu_spte_clear_track_bits_cb(struct kvm *kvm, u64 *sptep)
 {
-	mmu_spte_clear_track_bits(sptep);
+	mmu_spte_clear_track_bits(kvm, sptep);
 }
 
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			  const struct kvm_memory_slot *slot)
 {
-	return pte_list_destroy(rmap_head, mmu_spte_clear_track_bits_cb);
+	return pte_list_destroy(kvm, rmap_head, mmu_spte_clear_track_bits_cb);
 }
 
 static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1461,13 +1464,13 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
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
@@ -2276,8 +2279,6 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	if (is_shadow_present_pte(pte)) {
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
-			if (is_large_pte(pte))
-				--kvm->stat.lpages;
 		} else {
 			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
@@ -2736,8 +2737,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
 
 	if (!was_rmapped) {
-		if (is_large_pte(*sptep))
-			++vcpu->kvm->stat.lpages;
+		kvm_update_page_stats(vcpu->kvm, level, 1);
 		rmap_count = rmap_add(vcpu, sptep, gfn);
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, sptep, gfn);
@@ -5740,7 +5740,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
-			pte_list_remove(rmap_head, sptep);
+			pte_list_remove(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
 				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4b0953fed12e..45a5c1f43433 100644
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
index 916c976e99ab..a0a1d70981a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -233,7 +233,10 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, mmu_recycled),
 	STATS_DESC_COUNTER(VM, mmu_cache_miss),
 	STATS_DESC_ICOUNTER(VM, mmu_unsync),
-	STATS_DESC_ICOUNTER(VM, lpages),
+	STATS_DESC_ICOUNTER(VM, pages_4k),
+	STATS_DESC_ICOUNTER(VM, pages_2m),
+	STATS_DESC_ICOUNTER(VM, pages_1g),
+	STATS_DESC_ICOUNTER(VM, pages_512g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
 	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
-- 
2.32.0.554.ge1b32706d8-goog

