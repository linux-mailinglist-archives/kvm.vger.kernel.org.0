Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE19514004
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353795AbiD2BH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 21:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353765AbiD2BHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 21:07:51 -0400
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE120BC87F
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:34 -0700 (PDT)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-e72e3aa904so2993035fac.3
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 18:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NHfyCHEJZYENeoLwqQFAfCF8L8X/o5WJjfhCbB2cHt4=;
        b=EfExUhXUiLrwyV7994PFB6YkzupgYDTk1fOzzD43sqWEIhnqz4VxlMsUs6rJYkL2c2
         UHkj4j+jJP1M82ORtLm3BFtNlJ+D5dTmiAvtsB2GhRYxsuuKq893xPiGwZ0ei23FWBQC
         ZjEt9zcYLlb7NuG2lE4aWW7MOU+hMnf2O0Jzjfx+IO9aT39X6aFXV4s9TaayfaIepy32
         p319sAP05bz7FbG9qej14u1NCj1cauMo/32ziEfPT2Tge0fn9wlyN8e85GdmJ2qI65TJ
         LWoGLOBjJe4LRnmIuXwxmbrw1JZOh6dG7deOIVf8eG7QSk7wiZq2R1iQbm9wgMDbuNzs
         SpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NHfyCHEJZYENeoLwqQFAfCF8L8X/o5WJjfhCbB2cHt4=;
        b=Rbz9KM5CCnG1FuyV8yAPerZ/X4KWW29oQ6UPpvbGsfzxg4nAtfNFDAFOCYQKH9sZ9r
         gUBUvd8pgLXFBehrrAafAut3yI4rkV4HUkJO+plkqN030ZSHJzTpIsZ7QYV91VX2stu7
         +mJfZwGVm3ipIfPZ/6S8mNOCpfuQSP3j1yhKKk6YYnx8aVUyFxi90LY1pSJeSvkxOJxP
         Wato0dynxXBmXQ2VRij/RGMqDBMZWSUIuCxL5HGvCIjwM2Zm50YQuG5hy+BO7b2mCfX/
         5YFrVgZFHHMsTGZT0rJM1x3nPouV5pMIWjESVvCIjoRutkLcDCZJ72VQoPwU5shY3Meo
         atNw==
X-Gm-Message-State: AOAM533/CZZvJbEHdyNFFCNajhEKTdIm8SxdYhyWKw4DbJXF73/phauD
        /qmFdojEalDomw9xGHXtYJZjv1HkGik=
X-Google-Smtp-Source: ABdhPJy9ZN6claN5bUS4Gx7s4Oh/ztbqa0ljq+2apJ+cSltsX6m1OwIlCwyVg4+xVNlXleEnqdXkgU/VZ1M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6808:e8c:b0:322:4b82:d33d with SMTP id
 k12-20020a0568080e8c00b003224b82d33dmr426226oil.21.1651194273924; Thu, 28 Apr
 2022 18:04:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 29 Apr 2022 01:04:15 +0000
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Message-Id: <20220429010416.2788472-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220429010416.2788472-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 09/10] KVM: Rename/refactor kvm_is_reserved_pfn() to kvm_pfn_to_refcounted_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename and refactor kvm_is_reserved_pfn() to kvm_pfn_to_refcounted_page()
to better reflect what KVM is actually checking, and to eliminate extra
pfn_to_page() lookups.  The kvm_release_pfn_*() an kvm_try_get_pfn()
helpers in particular benefit from "refouncted" nomenclature, as it's not
all that obvious why KVM needs to get/put refcounts for some PG_reserved
pages (ZERO_PAGE and ZONE_DEVICE).

Add a comment to call out that the list of exceptions to PG_reserved is
all but guaranteed to be incomplete.  The list has mostly been compiled
by people throwing noodles at KVM and finding out they stick a little too
well, e.g. the ZERO_PAGE's refcount overflowed and ZONE_DEVICE pages
didn't get freed.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 15 +++++----
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/kvm_main.c        | 66 ++++++++++++++++++++++++++++++--------
 4 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5cf1436adecd..7da6741d6ea7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -587,6 +587,7 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
 	int level = sptep_to_sp(sptep)->role.level;
+	struct page *page;
 
 	if (!spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, 0ull);
@@ -601,11 +602,13 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	pfn = spte_to_pfn(old_spte);
 
 	/*
-	 * KVM does not hold the refcount of the page used by
-	 * kvm mmu, before reclaiming the page, we should
-	 * unmap it from mmu first.
+	 * KVM doesn't hold a reference to any pages mapped into the guest, and
+	 * instead uses the mmu_notifier to ensure that KVM unmaps any pages
+	 * before they are reclaimed.  Sanity check that, if the pfn is backed
+	 * by a refcounted page, the refcount is elevated.
 	 */
-	WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
+	page = kvm_pfn_to_refcounted_page(pfn);
+	WARN_ON(page && !page_count(page));
 
 	if (is_accessed_spte(old_spte))
 		kvm_set_pfn_accessed(pfn);
@@ -2877,7 +2880,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (unlikely(fault->max_level == PG_LEVEL_4K))
 		return;
 
-	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
+	if (is_error_noslot_pfn(fault->pfn) || !kvm_pfn_to_refcounted_page(fault->pfn))
 		return;
 
 	if (kvm_slot_dirty_track_enabled(slot))
@@ -5947,7 +5950,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		if (sp->role.direct && kvm_pfn_to_refcounted_page(pfn) &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       pfn, PG_LEVEL_NUM)) {
 			pte_list_remove(kvm, rmap_head, sptep);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..de2cc963dbec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1737,7 +1737,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		pfn = spte_to_pfn(iter.old_spte);
-		if (kvm_is_reserved_pfn(pfn) ||
+		if (!kvm_pfn_to_refcounted_page(pfn) ||
 		    iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
 							    pfn, PG_LEVEL_NUM))
 			continue;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ccc309a43f2..9d5818b782f9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1547,7 +1547,7 @@ void kvm_arch_sync_events(struct kvm *kvm);
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
-bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
+struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
 bool kvm_is_zone_device_page(struct page *page);
 
 struct kvm_irq_ack_notifier {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cbc6d58081d4..656c47037eea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -178,19 +178,36 @@ bool kvm_is_zone_device_page(struct page *page)
 	return is_zone_device_page(page);
 }
 
-bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
+/*
+ * Returns a 'struct page' if the pfn is "valid" and backed by a refcounted
+ * page, NULL otherwise.  Note, the list of refcounted PG_reserved page types
+ * is likely incomplete, it has been compiled purely through people wanting to
+ * back guest with a certain type of memory and encountering issues.
+ */
+struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
 {
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return NULL;
+
+	page = pfn_to_page(pfn);
+	if (!PageReserved(page))
+		return page;
+
+	/* The ZERO_PAGE(s) is marked PG_reserved, but is refcounted. */
+	if (is_zero_pfn(pfn))
+		return page;
+
 	/*
 	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
 	 * perspective they are "normal" pages, albeit with slightly different
 	 * usage rules.
 	 */
-	if (pfn_valid(pfn))
-		return PageReserved(pfn_to_page(pfn)) &&
-		       !is_zero_pfn(pfn) &&
-		       !kvm_is_zone_device_page(pfn_to_page(pfn));
+	if (kvm_is_zone_device_page(page))
+		return page;
 
-	return true;
+	return NULL;
 }
 
 /*
@@ -2479,9 +2496,12 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 
 static int kvm_try_get_pfn(kvm_pfn_t pfn)
 {
-	if (kvm_is_reserved_pfn(pfn))
+	struct page *page = kvm_pfn_to_refcounted_page(pfn);
+
+	if (!page)
 		return 1;
-	return get_page_unless_zero(pfn_to_page(pfn));
+
+	return get_page_unless_zero(page);
 }
 
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
@@ -2706,6 +2726,7 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
  */
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
+	struct page *page;
 	kvm_pfn_t pfn;
 
 	pfn = gfn_to_pfn(kvm, gfn);
@@ -2713,10 +2734,11 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	if (is_error_noslot_pfn(pfn))
 		return KVM_ERR_PTR_BAD_PAGE;
 
-	if (kvm_is_reserved_pfn(pfn))
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page)
 		return KVM_ERR_PTR_BAD_PAGE;
 
-	return pfn_to_page(pfn);
+	return page;
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
@@ -2819,8 +2841,16 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		kvm_release_page_clean(pfn_to_page(pfn));
+	struct page *page;
+
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page)
+		return;
+
+	kvm_release_page_clean(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
@@ -2835,8 +2865,16 @@ EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
 
 void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		kvm_release_page_dirty(pfn_to_page(pfn));
+	struct page *page;
+
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+	if (!page)
+		return;
+
+	kvm_release_page_dirty(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
-- 
2.36.0.464.gb9c8b46e94-goog

