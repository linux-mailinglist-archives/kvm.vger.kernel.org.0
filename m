Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98153EBD76
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhHMUfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhHMUfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:35:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C2CC061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n20-20020a2540140000b0290593b8e64cd5so10311303yba.3
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 13:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NDhJpouFdG89AEfajp8ak9xJOpY2ec2CIW475HaRdgk=;
        b=m1oizn6VFNYZbKSZsYD36pdm8nm1bHGfOkVr3VGLBdVyjyr7XUZv1onPVFcSTNu8DB
         m6ZQmhJdJ4y5G1i5IvWWC9WMYHOC92xWWu3Eeeh1DRnpWwRmiURH44DpjKpSfIX6j2Rd
         Zr9zyHz3xjtuj8xoMjo2LynYC9GCMJvIJd+4/AVYJ4NXPvgfPB6ZTV5OnR9V4l/cflKx
         lhFGh8GUVdUc25CiYhURwiFN6cUfOYMfTBNiRqNR16IIcjVAdxvxbA6eq8jJAyS5L2rj
         3+by8Raj6aTuHYUXfPawAgpInw5NdFXbQLR+F8EjdBaIQn3nmJPCDeyGqiRgBjsC+JTT
         lrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NDhJpouFdG89AEfajp8ak9xJOpY2ec2CIW475HaRdgk=;
        b=e3A/DM/67xX+YmcOowG/3ae6DcQkT7Hdx2wPEtwWyWBOkFuUGT7VautM96gFdPE2a1
         2UHbu+ARdy6xQaOl6yxMe3I2QzlsBtw7SUIEPnzOlsalh8SI8PPJtJm/AQjl2ocYjyIW
         lIMf+nSrFTBkv1M6vw1cW01lh/PT2lTYbybw9gs8uN6TAqzn0Bo8PmSDiQv3GtKMboad
         pbtro7gDoaqin3pwasU9XylsGUyxfU6X+IGVmjGLpl8rCGqiwQylMqWqSe88+GznONaR
         LT33Bx1L9Jwf2Ofevk82uZ7AV/tKxbXrepQPnW36S+WMrPRwgoAtCYnnsSQvGf4SbSPe
         JJ1Q==
X-Gm-Message-State: AOAM531Imf82P1eRHUh7sIJ6OXM3AuHo0J73CZn/WmmGQrBEEFCzTK+i
        5gFOTD6a7vsqlWEg+hgaPkrSL7Z7t03r+w==
X-Google-Smtp-Source: ABdhPJy8dDyZsPEILPPirhhSJin4HY3mQ8PMSKqAurGCjFkhQhHgvE+nNSD2XUqpX2Sw3ifsgrG2tWsZ6Y9Urw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:c752:: with SMTP id
 w79mr5370703ybe.348.1628886914267; Fri, 13 Aug 2021 13:35:14 -0700 (PDT)
Date:   Fri, 13 Aug 2021 20:35:03 +0000
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Message-Id: <20210813203504.2742757-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [RFC PATCH 5/6] KVM: x86/mmu: Avoid memslot lookup in rmap_add
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid the memslot lookup in rmap_add by passing it down from the fault
handling code to mmu_set_spte and then to rmap_add.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 29 ++++++++---------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++---
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c148d481e9b5..41e2ef8ad09b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1630,16 +1630,15 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+		     u64 *spte, gfn_t gfn)
 {
-	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
@@ -2679,9 +2678,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	return ret;
 }
 
-static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			unsigned int pte_access, bool write_fault, int level,
-			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
+static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			u64 *sptep, unsigned int pte_access, bool write_fault,
+			int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
 			bool host_writable)
 {
 	int was_rmapped = 0;
@@ -2744,24 +2743,12 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (!was_rmapped) {
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_add(vcpu, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
 	return ret;
 }
 
-static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
-				     bool no_dirty_log)
-{
-	struct kvm_memory_slot *slot;
-
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
-	if (!slot)
-		return KVM_PFN_ERR_FAULT;
-
-	return gfn_to_pfn_memslot_atomic(slot, gfn);
-}
-
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
@@ -2782,7 +2769,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, false, sp->role.level, gfn,
+		mmu_set_spte(vcpu, slot, start, access, false, sp->role.level, gfn,
 			     page_to_pfn(pages[i]), true, true);
 		put_page(pages[i]);
 	}
@@ -2979,7 +2966,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   fault->write, fault->goal_level, base_gfn, fault->pfn,
 			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..653ca44afa58 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -561,6 +561,7 @@ static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
 {
+	struct kvm_memory_slot *slot;
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
@@ -573,8 +574,13 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
-	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
+
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
 			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	if (!slot)
+		return false;
+
+	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
 	if (is_error_pfn(pfn))
 		return false;
 
@@ -582,7 +588,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	 * we call mmu_set_spte() with host_writable = true because
 	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
 	 */
-	mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
+	mmu_set_spte(vcpu, slot, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
 		     true, true);
 
 	kvm_release_pfn_clean(pfn);
@@ -749,7 +755,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		}
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access, fault->write,
 			   it.level, base_gfn, fault->pfn, fault->prefault,
 			   fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

