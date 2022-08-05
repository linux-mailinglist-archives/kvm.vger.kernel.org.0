Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6459A58B2A3
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbiHEXF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241548AbiHEXFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1328F79ECE
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3231401769dso32768807b3.10
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=TOisPftkQNAh306F8cmwV+0sj7RxsHKWkdSzODJuSsI=;
        b=o4fDSZPkxKiPaP1ZjpXoHjoxuDVjJi6t82FWq9ZUMChWvlbdqt1r4KMrBNsKn+J04e
         RIpJ3imoWYECPQOKGUEiGnvR+4DE/97Gky3qs18My5TZ+0Yl/0i2pnIaXJKr2+ZROX4C
         XVct4Y3FPGYGxfixOkB3WV1dHPSP8KNmn595p0E4nmIKokqXRlSi/R+ZlFVNLD9DQCb6
         XmP3lXZafcf1BEdriQR0k3yNLRHiTo/DSy9s3sLFeVmYdSHukGURlSD2wv/m3skoP8tl
         nIysYc+fPln12FolrNqIMa71j0lPEhKn+6JzUG3zWJdsziBsBCLLVJiIbwR/ZV5mcptT
         znsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=TOisPftkQNAh306F8cmwV+0sj7RxsHKWkdSzODJuSsI=;
        b=p80M1hnetOF98EFpwZklflFXh2KE+4+FzRfXpTB56t+vNYLR9CfBYGUyvcAja5k5lE
         w1Fdq7h43CAOQbJpT3gBKG4Wu0AaDlEP/Djgu7/PUo6G2yQVt17MjK8ern23Tcq+eEMl
         x7wY9hfRnnQu48MNctpPu+QnvddJO/Pr8hixbTMLD83LCP3t4hPGk8ND6ooEZukOpZgq
         HzetdMdicJ7KDFTdbRDokmAks1yKbsFpTE+8+xrfXiVi7AFN5GwgXoWsMJWT8mCRiHlm
         e8p3gPlzjWAMPLVtT78VYJC+x+fDKi/I1Dqy9gIpS3iwezQ5IFk30YqAPk98rtcIhuTp
         pkSA==
X-Gm-Message-State: ACgBeo2mC5DF8g8IjaEi+aYudmEsRnpCJqcjcqktLj7BBAaqHsqFD8PC
        +JRGjDYTnF3EzPQiydWNQdQ+uOHCb4k=
X-Google-Smtp-Source: AA6agR5OjFzv+RjZIhoUTpjo1vZT+nybdnZFF4zIb5tG0qrEsKeZ5pyISufHK9LXK3PkqZx6GpIdH026kTA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f309:0:b0:671:8725:7f22 with SMTP id
 c9-20020a25f309000000b0067187257f22mr7299925ybs.512.1659740732082; Fri, 05
 Aug 2022 16:05:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:12 +0000
In-Reply-To: <20220805230513.148869-1-seanjc@google.com>
Message-Id: <20220805230513.148869-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 7/8] KVM: x86/mmu: Add helper to convert SPTE value to its
 shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
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
 arch/x86/kvm/mmu/mmu.c          | 17 ++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h | 12 ------------
 arch/x86/kvm/mmu/spte.h         | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  2 ++
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f81ddedbe2f7..1442129c85e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1796,7 +1796,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
+		child = spte_to_child_sp(ent);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2355,7 +2355,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
+		child = spte_to_child_sp(*sptep);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2376,7 +2376,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_child_sp(pte);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2815,7 +2815,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_child_sp(pte);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3427,7 +3427,11 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & SPTE_BASE_ADDR_MASK);
+	/*
+	 * The "root" may be a special root, e.g. a PAE entry, treat it as a
+	 * SPTE to ensure any non-PA bits are dropped.
+	 */
+	sp = spte_to_child_sp(*root_hpa);
 	if (WARN_ON(!sp))
 		return;
 
@@ -3912,8 +3916,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 		if (IS_VALID_PAE_ROOT(root)) {
-			root &= SPTE_BASE_ADDR_MASK;
-			sp = to_shadow_page(root);
+			sp = spte_to_child_sp(root);
 			mmu_sync_children(vcpu, sp, true);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 22152241bd29..dbaf6755c5a7 100644
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
index cabe3fbb4f39..37aa4a9c3d75 100644
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
+static inline struct kvm_mmu_page *spte_to_child_sp(u64 spte)
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
2.37.1.559.g78731f0fdb-goog

