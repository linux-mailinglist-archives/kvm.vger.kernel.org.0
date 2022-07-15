Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B88576A95
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiGOXVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiGOXVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:21:13 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230CB9285B
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:12 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 31-20020a63125f000000b00419a2da53bdso3361051pgs.8
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uK6YWJT3dAvxH+WRuQoDcyKd/pbfKdISor+ayvyAclQ=;
        b=b7bZXNx8GXbQB7y8gNHiTNWMeIITH2Rj/dqBiwVDN8m1KxdnHKA0UHgZgdKqUarWBo
         0O79s3/wI0TxkEsbWtqrTC+EfNbmhq8B20WWTK0MHtIlpf42aUls4RPQdZUnrx/sVsvW
         y3CpfX8pj3COUw/jO4JzxN8OdgznGVGGVv3JWCs7FUWaEv0Yzb+5hEXQDtlVKl5MiLvP
         QKYLEBcoJcoTDWqh805wgOP8TcjTkaXnEJ9yGM8BShSeABoGjUMcu/LSdUQXKdvNCpbz
         XyHGGXsEQzk77fmfJK7Iw1cyMrJDaEF/nagwEQ8Z+b5mDOqWmbS+EclYGUwNkfE3qA1R
         xOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uK6YWJT3dAvxH+WRuQoDcyKd/pbfKdISor+ayvyAclQ=;
        b=lUKdIDtwxN6VCCa5o/tF/V9UM+ASbfnsPDRbxkVIj4aG4am6JLzMfLU+A2hipgXWwf
         ysffwr/DYu21hlJJ1yE+JjnaFY+mJ8o83pQRTRgPr3YyudoAmAT3TJLeRgAIqd6f/ivO
         q24VPMmy56soQhWHWl7YGJd8UoGRvfikJAcq4p+YeH47OASuHMTaZXK0P/8MOencLBey
         sAWyzFHn5keguH0w38jXLBv1T3itIHD1CpOlbZQJppHaDMm/WW/xUysGZ2BH6sPu/cub
         tO0+OAf56OEyNQUR5B3IfWZkPef12jbEZDIX1sFz7YS4WdwIH/95I+D7DY+zukxQi7Cm
         OoTg==
X-Gm-Message-State: AJIora+qZpFmvZnC5QDImy5GN5nUNnIFp7qfDS8XIj/CVoCcU88Mwm6Z
        uhgmvUFZTBFnGbrlI1Tg4u0kBL2fJqk=
X-Google-Smtp-Source: AGRyM1tgEmxQb78qcbICr1DeJgxQpHrFx7PCcmc098gc8S9zuMS8B2YgdedOkxCPFmxhMwVCXPrzdxoI3Q0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1d02:b0:1f0:1c2c:cc64 with SMTP id
 on2-20020a17090b1d0200b001f01c2ccc64mr18619142pjb.52.1657927271683; Fri, 15
 Jul 2022 16:21:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:21:04 +0000
In-Reply-To: <20220715232107.3775620-1-seanjc@google.com>
Message-Id: <20220715232107.3775620-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220715232107.3775620-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 1/4] KVM: x86/mmu: Don't require refcounted "struct page" to
 create huge SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the requirement that a pfn be backed by a refcounted, compound or
or ZONE_DEVICE, struct page, and instead rely solely on the host page
tables to identify huge pages.  The PageCompound() check is a remnant of
an old implementation that identified (well, attempt to identify) huge
pages without walking the host page tables.  The ZONE_DEVICE check was
added as an exception to the PageCompound() requirement.  In other words,
neither check is actually a hard requirement, if the primary has a pfn
backed with a huge page, then KVM can back the pfn with a huge page
regardless of the backing store.

Dropping the @pfn parameter will also allow KVM to query the max host
mapping level without having to first get the pfn, which is advantageous
for use outside of the page fault path where KVM wants to take action if
and only if a page can be mapped huge, i.e. avoids the pfn lookup for
gfns that can't be backed with a huge page.

Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 23 +++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 +-------
 3 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52664c3caaab..bebff1d5acd4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2919,11 +2919,10 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 				  const struct kvm_memory_slot *slot)
 {
 	int level = PG_LEVEL_4K;
-	struct page *page;
 	unsigned long hva;
 	unsigned long flags;
 	pgd_t pgd;
@@ -2931,17 +2930,6 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	pud_t pud;
 	pmd_t pmd;
 
-	/*
-	 * Note, @slot must be non-NULL, i.e. the caller is responsible for
-	 * ensuring @pfn isn't garbage and is backed by a memslot.
-	 */
-	page = kvm_pfn_to_refcounted_page(pfn);
-	if (!page)
-		return PG_LEVEL_4K;
-
-	if (!PageCompound(page) && !kvm_is_zone_device_page(page))
-		return PG_LEVEL_4K;
-
 	/*
 	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
 	 * is not solely for performance, it's also necessary to avoid the
@@ -2994,7 +2982,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      kvm_pfn_t pfn, int max_level)
+			      int max_level)
 {
 	struct kvm_lpage_info *linfo;
 	int host_level;
@@ -3009,7 +2997,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
+	host_level = host_pfn_mapping_level(kvm, gfn, slot);
 	return min(host_level, max_level);
 }
 
@@ -3034,8 +3022,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * level, which will be used to do precise, accurate accounting.
 	 */
 	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
-						     fault->gfn, fault->pfn,
-						     fault->max_level);
+						     fault->gfn, fault->max_level);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -6406,7 +6393,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 */
 		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
-							       pfn, PG_LEVEL_NUM)) {
+							       PG_LEVEL_NUM)) {
 			pte_list_remove(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ae2d660e2dab..582def531d4d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -309,7 +309,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      kvm_pfn_t pfn, int max_level);
+			      int max_level);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3a430d64975..d75d93edc40a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1733,7 +1733,6 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	int max_mapping_level;
-	kvm_pfn_t pfn;
 
 	rcu_read_lock();
 
@@ -1745,13 +1744,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		/*
-		 * This is a leaf SPTE. Check if the PFN it maps can
-		 * be mapped at a higher level.
-		 */
-		pfn = spte_to_pfn(iter.old_spte);
 		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-				iter.gfn, pfn, PG_LEVEL_NUM);
+							      iter.gfn, PG_LEVEL_NUM);
 
 		WARN_ON(max_mapping_level < iter.level);
 
-- 
2.37.0.170.g444d1eabd0-goog

