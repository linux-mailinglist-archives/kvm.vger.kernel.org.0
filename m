Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5444A7D16
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348698AbiBCBBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348682AbiBCBBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D7DC06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:23 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f35-20020a631f23000000b0035ec54b3bbcso600948pgf.0
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7i2xHlLNvbgpmgwj6zOsmV+bBljQ8N869Z7/+3akjow=;
        b=e5yDU2i7oo0aPLzbtIWfvKcYXNa8Wis5VQ1ZuaH9yXXH4eaW1pWi7Nv1qrPVjFKNC4
         NuAP8hYAchLKoKiYmciQ43Qwl+SjfV3DkfPWuP/IybjqTbyE5Ltui56IqKmHcMDgEPcr
         Zwa/bHwd6WDP6Q3vVnuMo/SOOF0bFPExz6cKgjh5Snv9ZXJfjUPEuqAu5Z+0g5Rl1c2t
         siHfqO1cyAFl5EfNRJMHdCAhb5mdQzkS+HblGw+R/tmHcLbwC66NZ8WqLZloaGoAky5f
         +x+K7gr+lA/fVdwZ+N3A/1B3oS+31jy5ksKW9J9dx2SPMhAoGhDsTsDz8ak1WBIfz+up
         aEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7i2xHlLNvbgpmgwj6zOsmV+bBljQ8N869Z7/+3akjow=;
        b=rtfazsfxrE4nTMVR5zftibau/zx4YVWUoCW1tpOmVPfVGRKOFeJeDX9k0pd/VndoFq
         O0u0+6mr3cDCdwt1VG99wIQGmlW1+acP0HhyYMpj0QXFzaV1uz4XMHXj1mOmPVZIONrr
         FNDbPLEAQm6qpZeK8i/+WlM5i2Ka57T7Jn9VKMh4+wMhrr70drC6v61Yg5D2L6V99rQC
         x6WM10cmalm6ab/AOTvJUuxWzPfgdhYqUJEfwzs0UZJb9xGTTTVnTKalCN6LpB3VAfjC
         EgTLB/qnEoqtzRS+pIDbRDWfNxAWJg/OMsk3c1eFWtEPCi5JPcrg1ZaMCCrcb4gVEvy+
         s4Jg==
X-Gm-Message-State: AOAM532FvApbfCbT1EmqdSsUt1PViVsFemMS9HWiRUnyOiJgPu7b88b6
        IQSu83gbU+/stTvKlkvUSkK1wseX25/C+g==
X-Google-Smtp-Source: ABdhPJwmGwymhrQh27IG1a7PzT4ff65krYYHzVi3gmHxg0bR7ciYI/vHfNfGWaJLtL/d03ozRAXYghJ9wNY3aw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:23ce:: with SMTP id
 g14mr32017877pfc.13.1643850083386; Wed, 02 Feb 2022 17:01:23 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:42 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 14/23] KVM: x86/mmu: Cache the access bits of shadowed translations
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

In order to split a huge page we need to know what access bits to assign
to the role of the new child page table. This can't be easily derived
from the huge page SPTE itself since KVM applies its own access policies
on top, such as for HugePage NX.

We could walk the guest page tables to determine the correct access
bits, but that is difficult to plumb outside of a vCPU fault context.
Instead, we can store the original access bits for each leaf SPTE
alongside the GFN in the gfns array. The access bits only take up 3
bits, which leaves 61 bits left over for gfns, which is more than
enough. So this change does not require any additional memory.

In order to keep the access bit cache in sync with the guest, we have to
extend FNAME(sync_page) to also update the access bits.

Now that the gfns array caches more information than just GFNs, rename
it to shadowed_translation.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
 4 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c371ee7e45f7..f00004c13ccf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -686,7 +686,7 @@ struct kvm_vcpu_arch {
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
+	struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ae1564e67e49..e2306a39526a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -719,7 +719,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_translation_cache,
 					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
@@ -732,7 +732,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_translation_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
@@ -749,15 +749,17 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
 	if (!sp->role.direct)
-		return sp->gfns[index];
+		return sp->shadowed_translation[index].gfn;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
 
-static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
+static void kvm_mmu_page_set_gfn_access(struct kvm_mmu_page *sp, int index,
+					gfn_t gfn, u32 access)
 {
 	if (!sp->role.direct) {
-		sp->gfns[index] = gfn;
+		sp->shadowed_translation[index].gfn = gfn;
+		sp->shadowed_translation[index].access = access;
 		return;
 	}
 
@@ -1610,14 +1612,14 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 static void __rmap_add(struct kvm *kvm,
 		       struct kvm_mmu_memory_cache *cache,
 		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn)
+		       u64 *spte, gfn_t gfn, u32 access)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	kvm_mmu_page_set_gfn_access(sp, spte - sp->spt, gfn, access);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
@@ -1631,9 +1633,9 @@ static void __rmap_add(struct kvm *kvm,
 }
 
 static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+		     u64 *spte, gfn_t gfn, u32 access)
 {
-	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn, access);
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1694,7 +1696,7 @@ void kvm_mmu_free_sp(struct kvm_mmu_page *sp)
 {
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
-		free_page((unsigned long)sp->gfns);
+		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -1731,8 +1733,12 @@ struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+
+	BUILD_BUG_ON(sizeof(sp->shadowed_translation[0]) != sizeof(u64));
+
 	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->shadowed_translation =
+			kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadowed_translation_cache);
 
 	return sp;
 }
@@ -1742,7 +1748,7 @@ struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
  *
  * Huge page splitting always uses direct shadow pages since the huge page is
  * being mapped directly with a lower level page table. Thus there's no need to
- * allocate the gfns array.
+ * allocate the shadowed_translation array.
  */
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp)
 {
@@ -2833,7 +2839,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
-		rmap_add(vcpu, slot, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn, pte_access);
 	}
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e6bcea5a0aa9..9ee175adcc12 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -30,6 +30,11 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
+struct shadowed_translation_entry {
+	u64 access:3;
+	u64 gfn:56;
+};
+
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
@@ -51,8 +56,14 @@ struct kvm_mmu_page {
 	gfn_t gfn;
 
 	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
+	/*
+	 * For indirect shadow pages, caches the result of the intermediate
+	 * guest translation being shadowed by each SPTE.
+	 *
+	 * NULL for direct shadow pages.
+	 */
+	struct shadowed_translation_entry *shadowed_translation;
+
 	/* Currently serving as active root */
 	union {
 		int root_count;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c533c191925e..703dfb062bf0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1016,7 +1016,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 
 /*
- * Using the cached information from sp->gfns is safe because:
+ * Using the information in sp->shadowed_translation is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
  *   can't change unless all sptes pointing to it are nuked first.
  *
@@ -1090,12 +1090,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		if (gfn != sp->shadowed_translation[i].gfn) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
 		}
 
+		if (pte_access != sp->shadowed_translation[i].access)
+			sp->shadowed_translation[i].access = pte_access;
+
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-- 
2.35.0.rc2.247.g8bbb082509-goog

