Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A9C4FA0C6
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240252AbiDIAlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbiDIAlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:41:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845C0C748C
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:38:59 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p187-20020a6229c4000000b004fb57adf76fso5994994pfp.2
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2SzKHtyKCq5Irk3bhcAX/x/kdJ+2+hL79/QeSqxrdXE=;
        b=F3emy64Cr5PgJT6yiaVC8uyT27yIU2FJVacYLWX5IZLobwDfbN/g7qteYjbCCnPH1G
         GCSSyXHMCug1JOCVxQMJIszQjXvtrtnApmdbr/+5Wf9WqSCZawrZqdYRqgmvA8jpdAIh
         HMubElJwL94l66p7xCa4kNl6b/b1523JFTwsbgsZRT9RpswFBUOA1yjGfDkAY/2XaiZw
         aP/L8Q8O7V8NUKHo89mtpCm2Dmv7H34hynVna8Sxt4EQ2nO4HyisOWRyBH7/A0A70GNp
         Ptz50ttkiZDXXNWP/gcv5ZuNWSeQ9PE5csdvVkpIq4ycn+CnScrR0Ue8OVZE/3OZbIsG
         NzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2SzKHtyKCq5Irk3bhcAX/x/kdJ+2+hL79/QeSqxrdXE=;
        b=G4ooAq+V2RLPioGjZe8/eN72Hz5c1c8bbvSd9S09EiKNqJIwYb76cyQzjx0RfUoPuo
         rO3BScwyb3+8xuvzpSb1k1fOdvdCrU0Qn6/dZYLWQygkzCCgljNfKq88X/L0gUmT+Gm8
         /0HOrfYJFMRbsLGnMO4Rk1DLePqrwo4vUkMslFCR7ZjDyWGQyqWyNXrmEG9jqZ7ZW04E
         TlqXxfdIXBzH4LtBvDksfT99fEQsYpaNkJfg4uWySeIaPuEiHPKySPFCsUkVAopzwjN1
         5sorp6Yz9ggw1+6ahEWEzpDvFts2Z+5RTTVZHtIiyypwgfMfze9ofNrPe9iGhLkyawja
         NdWA==
X-Gm-Message-State: AOAM533JLDBaVapX0U79KB/Gr3VYMKzKy1qeW9exoQt5QxfvUyVQQwop
        aLEp0x9xtyM2DJCLH/gkPBZn9MWcmw8=
X-Google-Smtp-Source: ABdhPJwuAy0R35WPnrFnfKlncfg91Jgy4oA66qufdBIM2rRGaMT+MFnDROLBhZEdu5vJpBdWi1G/BtAxcBc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce81:b0:156:ad26:78b1 with SMTP id
 f1-20020a170902ce8100b00156ad2678b1mr22068188plg.144.1649464738950; Fri, 08
 Apr 2022 17:38:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  9 Apr 2022 00:38:46 +0000
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
Message-Id: <20220409003847.819686-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 5/6] KVM: x86/mmu: Add helper to convert SPTE value to its
 shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h | 12 ------------
 arch/x86/kvm/mmu/spte.h         | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 ++
 4 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bc86997f9339..8b4f3550710a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1823,7 +1823,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
+		child = spte_to_sp(ent);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2237,7 +2237,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
+		child = spte_to_sp(*sptep);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2258,7 +2258,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = spte_to_sp(pte);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2696,7 +2696,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = spte_to_sp(pte);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3227,7 +3227,11 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	/*
+	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
+	 * SPTE to ensure any non-PA bits are dropped.
+	 */
+	sp = spte_to_sp(*root_hpa);
 	if (WARN_ON(!sp))
 		return;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 75e830c648da..891ef217b877 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -106,18 +106,6 @@ struct kvm_mmu_page {
 
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
index 73f12615416f..149a23c6e981 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -207,6 +207,23 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
  */
 extern u8 __read_mostly shadow_phys_bits;
 
+static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
+static inline struct kvm_mmu_page *spte_to_sp(u64 spte)
+{
+	return to_shadow_page(spte & PT64_BASE_ADDR_MASK);
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
2.35.1.1178.g4f1659d476-goog

