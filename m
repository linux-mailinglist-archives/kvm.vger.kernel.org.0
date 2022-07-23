Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E102D57EB0F
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiGWBXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbiGWBXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:46 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173CC9363F
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h12-20020a170902748c00b0016d29671bf7so3446989pll.9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DD45tdz+67fPg0YVSIsI0VzRQuV5XEPNFSGc6mpSxYY=;
        b=MIl+pl8arhntJ6H2Ci4YqdD9KPn26WE5ebMG+KJKfISmR/8qlOn+IIAm4tCQ69uBrc
         Q6xmdsYlS8ULYWFwHuaBhr1pR5sUNcKQsrPXZ5wxav1d790E/IRsOQXzwNnp+64GIBKk
         guAqf6XiHwSCdmSbcvNoJVsJOtyJx54YQkMBb98qsOrwuDJxBI2iAh4mOcM0quJ7voYI
         uXoAwV71SWkBqHmc9TbaEvI7o6RJ87ehFIeT3HbPBR6BMKzuAXvbkw/NNK61iIH5BHv9
         PvZQ0ukcihKmnQUQUYBGAd3vKMZxLbRvodMCvAO29DqAnay77s61HkoXxCxsXp3pRHwz
         QVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DD45tdz+67fPg0YVSIsI0VzRQuV5XEPNFSGc6mpSxYY=;
        b=UJz6Ni1eJvAy0GVJs0K9+SK/QBwjewymgQUfKrAnag5YvS7XM/Y0KHJeCYxZjgt+mh
         t505Yl5qGHMpT/C83djw411iBuQZjIWntIGkmV+vNOpZ5Y2HhzyMt/rvGY8q8yiUpHQ1
         m5xg1Vv556oS1n6l1sintR+y8V4QLGOBywEd8e6YNhV6/+e7y4JCc/MNytvvsM4meDn5
         b2eNAmmoSxaOvhd+nEwzzGWMPm3GtSoubdAIjy6HqlDquLdQFJLOhosX0ncnuHgAdoh2
         KdEH/sPIBqJAy4aExugVe09c6Ha3sjD+YXvMIav81nK83ZP68rja986V2Xg9aEVPS4Am
         T/Gg==
X-Gm-Message-State: AJIora+AzqRr/LGuFUt1IJIbw5mSfLHaXiAgDni3o9PhcpW6mUhHwxbN
        cTQEh0kEFqDEGha2J3r3SlzXC2CxhQY=
X-Google-Smtp-Source: AGRyM1vgPiFJ/+Ix2fHf+lADkdehhCP0kkq+lfMjf12fmfBjq6H5DgnbDnt70OU4JQBgICgbqGozeczLw7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:150e:b0:52a:ee55:4806 with SMTP id
 q14-20020a056a00150e00b0052aee554806mr2581383pfu.37.1658539419501; Fri, 22
 Jul 2022 18:23:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:24 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 5/6] KVM: x86/mmu: Add helper to convert SPTE value to its
 shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to convert a SPTE to its shadow page to deduplicate a
variety of flows and hopefully avoid future bugs, e.g. if KVM attempts to
get the shadow page for a SPTE without dropping high bits.

Opportunistically add a comment in mmu_free_root_page() documenting why
it treats the root HPA as a SPTE.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 17 ++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h | 12 ------------
 arch/x86/kvm/mmu/spte.h         | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 ++
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e9252e7cd5a2..ed3cfb31853b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1798,7 +1798,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
+		child = spte_to_sp(ent);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2357,7 +2357,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
+		child = spte_to_sp(*sptep);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2378,7 +2378,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_sp(pte);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2817,7 +2817,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_sp(pte);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3429,7 +3429,11 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & SPTE_BASE_ADDR_MASK);
+	/*
+	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
+	 * SPTE to ensure any non-PA bits are dropped.
+	 */
+	sp = spte_to_sp(*root_hpa);
 	if (WARN_ON(!sp))
 		return;
 
@@ -3914,8 +3918,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 		if (IS_VALID_PAE_ROOT(root)) {
-			root &= SPTE_BASE_ADDR_MASK;
-			sp = to_shadow_page(root);
+			sp = spte_to_sp(root);
 			mmu_sync_children(vcpu, sp, true);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2a887d08b722..04457b5ec968 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -133,18 +133,6 @@ struct kvm_mmu_page {
 
 extern struct kmem_cache *mmu_page_header_cache;
 
-static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
-{
-	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
-
-	return (struct kvm_mmu_page *)page_private(page);
-}
-
-static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
-{
-	return to_shadow_page(__pa(sptep));
-}
-
 static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
 {
 	return role.smm ? 1 : 0;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cabe3fbb4f39..a240b7eca54f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -207,6 +207,23 @@ static inline int spte_index(u64 *sptep)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
+static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
+static inline struct kvm_mmu_page *spte_to_sp(u64 spte)
+{
+	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
+}
+
+static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
+{
+	return to_shadow_page(__pa(sptep));
+}
+
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c163f7cc23ca..d3714200b932 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,6 +5,8 @@
 
 #include <linux/kvm_host.h>
 
+#include "spte.h"
+
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
-- 
2.37.1.359.gd136c6c3e2-goog

