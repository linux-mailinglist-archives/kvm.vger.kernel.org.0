Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A204A7D2B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348696AbiBCBBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348697AbiBCBBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:37 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65119C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:37 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id e7-20020a17090ac20700b001b586e65885so5620041pjt.1
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4swT+J8ld9uECCywNjrn0CGH0iBu0/rxiDB3j6YxIS0=;
        b=kfNqUaNs01ebgU8QLWrYhMQRA/AvWFWeCTqp5ANPgZ/RXtJJAfsu2pgCQopjAyVBcZ
         TE8vYvM1sUcUItdVQN7Mpkdo0Z1vs1Sahb/+D3SjP965XKegSiCpGtGGgSOYFqGQmgK8
         PuWbRHX5h22dVJZPd/odXFtpOTeyxjROCIBwzwoJYSaGE0GnolxmXjUyfNPGbCON/1XR
         HC1zLnQzuKSh+bLKGTzVGNpoRAYLgmq21cQ1vpgYUDLFDx5oqIoz2reW3CFO9IErhr2a
         MUD8IRahRtaQlvTUhxVBZkN7kWZW1hGQTBNP6AbpqHWY8EVACqpPgWqFOUthII+ADSWI
         uLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4swT+J8ld9uECCywNjrn0CGH0iBu0/rxiDB3j6YxIS0=;
        b=WQx1TG+9tDCjhVVMm9ias6/wFEqo7YeLIctk67FP6h792/JamC0S1fdL3w4f17r0JE
         fMqC4ULjFqZUO6vYfzsRSAfNeXztXUJeTIyuAkDZ2TRdZ2RB4rN3s3ZEnAu12McMUu0c
         W9dKU4rbZbiZJhn/C5Hv8DerMDunxUwHeumXTfWhJBgK7WoS/UNHAePgx+CYaOtMNZRP
         09twuqLyPxNTsNQnTTrq95WOs0Fj3jH1ZiKk2psCJdmCO+Q28wi5NxdGVfjqeoyplPzu
         yH9ucnFpH3JjiJ+MTJ08FnIFy5zzexSdrtT38ljU8mvL96yCRZ3xohkXOAgZ/5lmAylo
         0NSQ==
X-Gm-Message-State: AOAM532Ocw+H+d2AljuGddyEck7VMFIMolikX3FRsghW48e3ef6jJpAv
        IXA8Rr8S6++Y1KwMGHnAV231SZEcNUE07A==
X-Google-Smtp-Source: ABdhPJx03leHb2o6bWu+D9mBJEXVE5KqKiQXhRKd7gQXpvE94sUCp1IsPetMT7WDyP+Bg6HLUQsfr94gphwo2g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr1189912pjb.0.1643850096420; Wed, 02 Feb 2022 17:01:36 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:50 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-23-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 22/23] KVM: x86/mmu: Split huge pages aliased by multiple SPTEs
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

The existing huge page splitting code bails if it encounters a huge page
that is aliased by another SPTE that has already been split (either due
to NX huge pages or eager page splitting). Extend the huge page
splitting code to also handle such aliases.

The thing we have to be careful about is dealing with what's already in
the lower level page table. If eager page splitting was the only
operation that split huge pages, this would be fine. However huge pages
can also be split by NX huge pages. This means the lower level page
table may only be partially filled in and may point to even lower level
page tables that are partially filled in. We can fill in the rest of the
page table but dealing with the lower level page tables would be too
complex.

To handle this we flush TLBs after dropping the huge SPTE whenever we
are about to install a lower level page table that was partially filled
in (*). We can skip the TLB flush if the lower level page table was
empty (no aliasing) or identical to what we were already going to
populate it with (aliased huge page that was just eagerly split).

(*) This TLB flush could probably be delayed until we're about to drop
the MMU lock, which would also let us batch flushes for multiple splits.
However such scenarios should be rare in practice (a huge page must be
aliased in multiple SPTEs and have been split for NX Huge Pages in only
some of them). Flushing immediately is simpler to plumb and also reduces
the chances of tripping over a CPU bug (e.g. see iTLB multi-hit).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++-
 arch/x86/kvm/mmu/mmu.c          | 77 +++++++++++++++------------------
 2 files changed, 38 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a0f7578f7a26..c11f27f38981 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1237,9 +1237,10 @@ struct kvm_arch {
 	 * Memory cache used to allocate pte_list_desc structs while splitting
 	 * huge pages. In the worst case, to split one huge page we need 512
 	 * pte_list_desc structs to add each new lower level leaf sptep to the
-	 * memslot rmap.
+	 * memslot rmap plus 1 to extend the parent_ptes rmap of the new lower
+	 * level page table.
 	 */
-#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 512
+#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 513
 	__DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
 				      HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c7981a934237..62fbff8979ba 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6056,7 +6056,8 @@ static int min_descs_for_split(const struct kvm_memory_slot *slot, u64 *huge_spt
 		gfn += KVM_PAGES_PER_HPAGE(split_level);
 	}
 
-	return min;
+	/* Plus 1 to extend the parent_ptes rmap of the lower level SP. */
+	return min + 1;
 }
 
 static int topup_huge_page_split_desc_cache(struct kvm *kvm, int min, gfp_t gfp)
@@ -6126,6 +6127,7 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
 	struct kvm_mmu_page *split_sp;
 	union kvm_mmu_page_role role;
+	bool created = false;
 	unsigned int access;
 	gfn_t gfn;
 
@@ -6138,25 +6140,21 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 	 */
 	role = kvm_mmu_child_role(huge_sp, true, access);
 	split_sp = kvm_mmu_get_existing_direct_sp(kvm, gfn, role);
-
-	/*
-	 * Opt not to split if the lower-level SP already exists. This requires
-	 * more complex handling as the SP may be already partially filled in
-	 * and may need extra pte_list_desc structs to update parent_ptes.
-	 */
 	if (split_sp)
-		return NULL;
+		goto out;
 
+	created = true;
 	swap(split_sp, *spp);
 	kvm_mmu_init_sp(kvm, split_sp, slot, gfn, role);
-	trace_kvm_mmu_get_page(split_sp, true);
 
+out:
+	trace_kvm_mmu_get_page(split_sp, created);
 	return split_sp;
 }
 
-static int kvm_mmu_split_huge_page(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot,
-				   u64 *huge_sptep, struct kvm_mmu_page **spp)
+static void kvm_mmu_split_huge_page(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot,
+				    u64 *huge_sptep, struct kvm_mmu_page **spp)
 
 {
 	struct kvm_mmu_memory_cache *cache;
@@ -6164,22 +6162,11 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 	u64 huge_spte, split_spte;
 	int split_level, index;
 	unsigned int access;
+	bool flush = false;
 	u64 *split_sptep;
 	gfn_t split_gfn;
 
 	split_sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
-	if (!split_sp)
-		return -EOPNOTSUPP;
-
-	/*
-	 * We did not allocate an extra pte_list_desc struct to add huge_sptep
-	 * to split_sp->parent_ptes. An extra pte_list_desc struct should never
-	 * be necessary in practice though since split_sp is brand new.
-	 *
-	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
-	 */
-	if (WARN_ON_ONCE(pte_list_need_new_desc(&split_sp->parent_ptes)))
-		return -EINVAL;
 
 	huge_spte = READ_ONCE(*huge_sptep);
 
@@ -6191,7 +6178,20 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 		split_sptep = &split_sp->spt[index];
 		split_gfn = kvm_mmu_page_get_gfn(split_sp, index);
 
-		BUG_ON(is_shadow_present_pte(*split_sptep));
+		/*
+		 * split_sp may have populated page table entries if this huge
+		 * page is aliased in multiple shadow page table entries. We
+		 * know the existing SP will be mapping the same GFN->PFN
+		 * translation since this is a direct SP. However, the SPTE may
+		 * point to an even lower level page table that may only be
+		 * partially filled in (e.g. for NX huge pages). In other words,
+		 * we may be unmapping a portion of the huge page, which
+		 * requires a TLB flush.
+		 */
+		if (is_shadow_present_pte(*split_sptep)) {
+			flush |= !is_last_spte(*split_sptep, split_level);
+			continue;
+		}
 
 		split_spte = make_huge_page_split_spte(
 				huge_spte, split_level + 1, index, access);
@@ -6202,16 +6202,12 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-	 * page table. Since we are making this change without a TLB flush vCPUs
-	 * will see a mix of the split mappings and the original huge mapping,
-	 * depending on what's currently in their TLB. This is fine from a
-	 * correctness standpoint since the translation will be the same either
-	 * way.
+	 * page table. If the lower-level page table indentically maps the huge
+	 * page, there's no need for a TLB flush. Otherwise, flush TLBs after
+	 * dropping the huge page and before installing the shadow page table.
 	 */
-	drop_large_spte(kvm, huge_sptep, false);
-	__link_shadow_page(NULL, huge_sptep, split_sp);
-
-	return 0;
+	drop_large_spte(kvm, huge_sptep, flush);
+	__link_shadow_page(cache, huge_sptep, split_sp);
 }
 
 static bool should_split_huge_page(u64 *huge_sptep)
@@ -6266,16 +6262,13 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		if (dropped_lock)
 			goto restart;
 
-		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
-
-		trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
-
 		/*
-		 * If splitting is successful we must restart the iterator
-		 * because huge_sptep has just been removed from it.
+		 * After splitting we must restart the iterator because
+		 * huge_sptep has just been removed from it.
 		 */
-		if (!r)
-			goto restart;
+		kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
+		trace_kvm_mmu_split_huge_page(gfn, spte, level, 0);
+		goto restart;
 	}
 
 	if (sp)
-- 
2.35.0.rc2.247.g8bbb082509-goog

