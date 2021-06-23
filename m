Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA53B23CB
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 01:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFWXIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 19:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhFWXIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 19:08:34 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662EFC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:15 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z5-20020ac86c450000b029024e9a87714dso4321850qtu.2
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 16:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=l9aUZrrzGLgepJinEz3O0tk6pl4pmaaVEKJ+sq+iUN0=;
        b=pmsPDc5hXdnA6yKgqqTSnoOMXjRgXzeAos39T6ctNGKcHpWPf7Alees6O7nfCeQsNW
         /dHyXaMxgREaFX2ycxlV8Dq3JyBW3bmjee6bjX1aMtJ+FN13ou5ju56cx7xOQXbl8Aj4
         +/qWvBC3UdJe8AgSqH5Ag9gYkiWxiVL5sSO++/YTtv7duDUwn7tnV3H62jZc3v1bH/Md
         UNuIPU876HO90Bt9c9vBJdtAk439UEgm1cwx5ma6J+NL60QVfdc4k6R4BG5QpPCQRtVs
         A464WPCkdNCCL4IuDZDpXO0H1TXIyUffBWgH0YJT6yM10Ywyl4fxXEcUv+C/O/68OwqI
         OA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=l9aUZrrzGLgepJinEz3O0tk6pl4pmaaVEKJ+sq+iUN0=;
        b=HJufIOgnu4zZvxg+TWpZ5Saw1HzxVXYO4ibr2K8c/KjnMx5nFhY4JJs2hJoqMZeau7
         9irOfhAuhRoGIV4XCboxmI/GAH7oQFGM7abQwIgjCUgzbDvITHqRm4MeUNWI1/xIr31T
         fcD12cECRUphYCys6R2uhl6SLyUUesf3qEuYyPzySIqR390WxsugOE+Tttr7XwUzbpXQ
         ODky1TBPZ9CLCr0xh3mmaCMoOh5B2TXO6gQeQcLGn60JfpLf8Lz39bvRnjZJ4QywxCe4
         nVvqge07CMrub0sstUkjFv9bonoyLgi22GFf3sCbhF8V886K7NllkoJGs6n0/7RSj1bT
         NqkQ==
X-Gm-Message-State: AOAM530DjFtl3r/9ExDxaKsqodhH1y0HI9i6jIjBBSP4T2UX9NKZK0JJ
        RMo1f9BFFIZJG2YCLB6Y8UD3+tG90kg=
X-Google-Smtp-Source: ABdhPJxpoyVkWTGtRZmaBZHSEw7M2IBz0+/aAH7SHg6Z4kChqFyLVaKo9txpCm+74+Sb/tCcuYn9/qpiyAs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e9e:5b86:b4f2:e3c9])
 (user=seanjc job=sendgmr) by 2002:a25:bd84:: with SMTP id f4mr741765ybh.143.1624489574547;
 Wed, 23 Jun 2021 16:06:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 23 Jun 2021 16:05:52 -0700
In-Reply-To: <20210623230552.4027702-1-seanjc@google.com>
Message-Id: <20210623230552.4027702-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210623230552.4027702-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 7/7] KVM: x86/mmu: Use separate namespaces for guest PTEs and
 shadow PTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the macros for KVM's shadow PTEs (SPTE) from guest 64-bit PTEs
(PT64).  SPTE and PT64 are _mostly_ the same, but the few differences are
quite critical, e.g. *_BASE_ADDR_MASK must differentiate between host and
guest physical address spaces, and SPTE_PERM_MASK (was PT64_PERM_MASK) is
very much specific to SPTEs.

Add helper macros to deduplicate the 32-bit vs. 64-bit code, and to avoid
additional duplication for SPTEs.

Opportunistically move most guest macros into paging_tmpl.h to clearly
associate them with shadow paging, and to make it more difficult to
unintentionally use a guest macro in the MMU.  Sadly, PT32_LEVEL_BITS is
left behind in mmu.h because it's need for the quadrant calculation in
kvm_mmu_get_page(), which is hot enough that adding a per-context helper
is undesirable, and burying the computation in paging_tmpl.h with a
forward declaration isn't exactly an improvement.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h              |  8 ++----
 arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++-----------------------
 arch/x86/kvm/mmu/mmu_audit.c    |  6 ++--
 arch/x86/kvm/mmu/mmu_internal.h | 14 +++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  | 35 +++++++++++++++++------
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/spte.h         | 28 ++++++++----------
 arch/x86/kvm/mmu/tdp_iter.c     |  6 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 9 files changed, 79 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2b9d08b080cc..0199c8c2222d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -6,11 +6,6 @@
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
 
-#define PT64_PT_BITS 9
-#define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
-#define PT32_PT_BITS 10
-#define PT32_ENT_PER_PAGE (1 << PT32_PT_BITS)
-
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
 
@@ -34,6 +29,9 @@
 #define PT_DIR_PAT_SHIFT 12
 #define PT_DIR_PAT_MASK (1ULL << PT_DIR_PAT_SHIFT)
 
+/* The number of bits for 32-bit PTEs is to compute the quandrant. :-( */
+#define PT32_LEVEL_BITS 10
+
 #define PT64_ROOT_5LEVEL 5
 #define PT64_ROOT_4LEVEL 4
 #define PT32_ROOT_LEVEL 2
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef92717bff86..cc93649f41cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -113,26 +113,6 @@ module_param(dbg, bool, 0644);
 
 #define PTE_PREFETCH_NUM		8
 
-#define PT32_LEVEL_BITS 10
-
-#define PT32_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT32_LEVEL_BITS)
-
-#define PT32_LVL_OFFSET_MASK(level) \
-	(PT32_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT32_LEVEL_BITS))) - 1))
-
-#define PT32_INDEX(address, level)\
-	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
-
-
-#define PT32_BASE_ADDR_MASK PAGE_MASK
-#define PT32_DIR_BASE_ADDR_MASK \
-	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
-#define PT32_LVL_ADDR_MASK(level) \
-	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-					    * PT32_LEVEL_BITS))) - 1))
-
 #include <trace/events/kvm.h>
 
 /* make pte_list_desc fit well in cache line */
@@ -675,7 +655,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 	if (!sp->role.direct)
 		return sp->gfns[index];
 
-	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
+	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
 }
 
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
@@ -1706,7 +1686,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -1989,8 +1969,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.gpte_is_8_bytes = true;
 	role.access = access;
 	if (!direct_mmu && vcpu->arch.mmu->root_level <= PT32_ROOT_LEVEL) {
-		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
+		quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
+		quadrant &= (1 << ((PT32_LEVEL_BITS - SPTE_LEVEL_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
 
@@ -2082,7 +2062,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 		iterator->shadow_addr
 			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
-		iterator->shadow_addr &= PT64_BASE_ADDR_MASK;
+		iterator->shadow_addr &= SPTE_BASE_ADDR_MASK;
 		--iterator->level;
 		if (!iterator->shadow_addr)
 			iterator->level = 0;
@@ -2101,7 +2081,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 	if (iterator->level < PG_LEVEL_4K)
 		return false;
 
-	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
+	iterator->index = SPTE_INDEX(iterator->addr, iterator->level);
 	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
 	return true;
 }
@@ -2114,7 +2094,7 @@ static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 		return;
 	}
 
-	iterator->shadow_addr = spte & PT64_BASE_ADDR_MASK;
+	iterator->shadow_addr = spte & SPTE_BASE_ADDR_MASK;
 	--iterator->level;
 }
 
@@ -2153,7 +2133,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2176,7 +2156,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			if (is_large_pte(pte))
 				--kvm->stat.lpages;
 		} else {
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2202,7 +2182,7 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 	int zapped = 0;
 	unsigned i;
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
+	for (i = 0; i < SPTE_ENT_PER_PAGE; ++i)
 		zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
 
 	return zapped;
@@ -2580,7 +2560,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3134,7 +3114,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	sp = to_shadow_page(*root_hpa & SPTE_BASE_ADDR_MASK);
 
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
@@ -3494,7 +3474,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
+			root &= SPTE_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			mmu_sync_children(vcpu, sp);
 		}
@@ -4927,11 +4907,11 @@ static bool need_remote_flush(u64 old, u64 new)
 		return false;
 	if (!is_shadow_present_pte(new))
 		return true;
-	if ((old ^ new) & PT64_BASE_ADDR_MASK)
+	if ((old ^ new) & SPTE_BASE_ADDR_MASK)
 		return true;
 	old ^= shadow_nx_mask;
 	new ^= shadow_nx_mask;
-	return (old & ~new & PT64_PERM_MASK) != 0;
+	return (old & ~new & SPTE_PERM_MASK) != 0;
 }
 
 static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index cedc17b2f60e..4b5335188d01 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -45,7 +45,7 @@ static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		      !is_last_spte(ent[i], level)) {
 			struct kvm_mmu_page *child;
 
-			child = to_shadow_page(ent[i] & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(ent[i] & SPTE_BASE_ADDR_MASK);
 			__mmu_spte_walk(vcpu, child, fn, level - 1);
 		}
 	}
@@ -71,7 +71,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
+			root &= SPTE_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			__mmu_spte_walk(vcpu, sp, fn, 2);
 		}
@@ -117,7 +117,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 		return;
 
 	hpa =  pfn << PAGE_SHIFT;
-	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
+	if ((*sptep & SPTE_BASE_ADDR_MASK) != hpa)
 		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
 			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
 			     hpa, *sptep);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 18be103df9d5..b9ef013a2202 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,6 +20,20 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
+/* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_LEVEL_SHIFT(level, bits_per_level)	\
+	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
+#define __PT_INDEX(address, level, bits_per_level) \
+	(((address) >> __PT_LEVEL_SHIFT(level, bits_per_level)) & ((1 << (bits_per_level)) - 1))
+
+#define __PT_LVL_ADDR_MASK(base_addr_mask, level, bits_per_level) \
+	((base_addr_mask) & ~((1ULL << (PAGE_SHIFT + (((level) - 1) * (bits_per_level)))) - 1))
+
+#define __PT_LVL_OFFSET_MASK(base_addr_mask, level, bits_per_level) \
+	((base_addr_mask) & ((1ULL << (PAGE_SHIFT + (((level) - 1) * (bits_per_level)))) - 1))
+
+#define __PT_ENT_PER_PAGE(bits_per_level)  (1 << (bits_per_level))
+
 /*
  * Unlike regular MMU roots, PAE "roots", a.k.a. PDPTEs/PDPTRs, have a PRESENT
  * bit, and thus are guaranteed to be non-zero when valid.  And, when a guest
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a2dbea70ffda..caaeec848b12 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -24,13 +24,32 @@
 #ifndef __KVM_X86_PAGING_TMPL_COMMON_H
 #define __KVM_X86_PAGING_TMPL_COMMON_H
 
-#define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+/* 64-bit guest PTEs, i.e. PAE paging and EPT. */
+#define PT64_LEVEL_BITS 9
+#define PT64_LEVEL_SHIFT		__PT_LEVEL_SHIFT(level, PT64_LEVEL_BITS)
+#define PT64_INDEX(address, level)	__PT_INDEX(address, level, PT64_LEVEL_BITS)
+#define PT64_ENT_PER_PAGE		__PT_ENT_PER_PAGE(PT64_LEVEL_BITS)
+
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define PT64_LVL_ADDR_MASK(level) \
-	(GUEST_PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
+	__PT_LVL_ADDR_MASK(PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
+
 #define PT64_LVL_OFFSET_MASK(level) \
-	(GUEST_PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
+	__PT_LVL_OFFSET_MASK(PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
+
+/* 32-bit guest PTEs, i.e. non-PAE IA32 paging. */
+#define PT32_LEVEL_SHIFT(level)		__PT_LEVEL_SHIFT(level, PT32_LEVEL_BITS)
+#define PT32_INDEX(address, level)	__PT_INDEX(address, level, PT32_LEVEL_BITS)
+#define PT32_ENT_PER_PAGE		__PT_ENT_PER_PAGE(PT32_LEVEL_BITS)
+
+#define PT32_BASE_ADDR_MASK PAGE_MASK
+#define PT32_DIR_BASE_ADDR_MASK \
+	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
+#define PT32_LVL_ADDR_MASK(level) \
+	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
+
+#define PT32_LVL_OFFSET_MASK(level) \
+	__PT_LVL_OFFSET_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
 
 #define PT32_DIR_PSE36_SIZE 4
 #define PT32_DIR_PSE36_SHIFT 13
@@ -55,7 +74,7 @@ static inline gfn_t pse36_gfn_delta(u32 gpte)
 	#define pt_element_t u64
 	#define guest_walker guest_walker64
 	#define FNAME(name) paging##64_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
@@ -88,7 +107,7 @@ static inline gfn_t pse36_gfn_delta(u32 gpte)
 	#define pt_element_t u64
 	#define guest_walker guest_walkerEPT
 	#define FNAME(name) ept_##name
-	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
+	#define PT_BASE_ADDR_MASK PT64_BASE_ADDR_MASK
 	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
 	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
 	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
@@ -1072,7 +1091,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 66d43cec0c31..cc7feac12e26 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -200,7 +200,7 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 {
 	u64 new_spte;
 
-	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte = old_spte & ~SPTE_BASE_ADDR_MASK;
 	new_spte |= (u64)new_pfn << PAGE_SHIFT;
 
 	new_spte &= ~PT_WRITABLE_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 6925dfc38981..719785eea2fe 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -34,12 +34,12 @@
 static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
-#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
 #else
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
 
-#define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
+#define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
 			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
 
 #define ACC_EXEC_MASK    1
@@ -48,17 +48,13 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
 /* The mask for the R/X bits in EPT PTEs */
-#define PT64_EPT_READABLE_MASK			0x1ull
-#define PT64_EPT_EXECUTABLE_MASK		0x4ull
+#define SPTE_EPT_READABLE_MASK			0x1ull
+#define SPTE_EPT_EXECUTABLE_MASK		0x4ull
 
-#define PT64_LEVEL_BITS 9
-
-#define PT64_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
-
-#define PT64_INDEX(address, level)\
-	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+#define SPTE_LEVEL_BITS			9
+#define SPTE_LEVEL_SHIFT(level)		__PT_LEVEL_SHIFT(level, SPTE_LEVEL_BITS)
+#define SPTE_INDEX(address, level)	__PT_INDEX(address, level, SPTE_LEVEL_BITS)
+#define SPTE_ENT_PER_PAGE		__PT_ENT_PER_PAGE(SPTE_LEVEL_BITS)
 
 /* Bits 9 and 10 are ignored by all non-EPT PTEs. */
 #define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
@@ -71,8 +67,8 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
  * restored only when a write is attempted to the page.  This mask obviously
  * must not overlap the A/D type mask.
  */
-#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
-					  PT64_EPT_EXECUTABLE_MASK)
+#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (SPTE_EPT_READABLE_MASK | \
+					  SPTE_EPT_EXECUTABLE_MASK)
 #define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT 54
 #define SHADOW_ACC_TRACK_SAVED_MASK	(SHADOW_ACC_TRACK_SAVED_BITS_MASK << \
 					 SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
@@ -269,7 +265,7 @@ static inline bool is_executable_pte(u64 spte)
 
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
 {
-	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	return (pte & SPTE_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
 static inline bool is_accessed_spte(u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b3ed302c1a35..5c002c43cb3c 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -11,7 +11,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
 	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
 }
 
@@ -113,8 +113,8 @@ static bool try_step_side(struct tdp_iter *iter)
 	 * Check if the iterator is already at the end of the current page
 	 * table.
 	 */
-	if (SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
-            (PT64_ENT_PER_PAGE - 1))
+	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
+	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..3720d244e5a2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 
 	tdp_mmu_unlink_page(kvm, sp, shared);
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		sptep = rcu_dereference(pt) + i;
 		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
 
-- 
2.32.0.288.g62a8d224e6-goog

