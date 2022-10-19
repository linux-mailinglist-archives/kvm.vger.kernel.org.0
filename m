Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B2F604DEC
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJSQ4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJSQ4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2151D0644
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u8-20020a170902e5c800b00185483ee4f5so8501888plf.10
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=waroNZFBJLQwvUgcfZIcey5TzJEOeoUZhGZO7shkmD4=;
        b=e3P08m4q0X038sMHBa7OpQBM91n7Ix99ZqQp7w8a4ngY84stpxKOpAS0LH0DxkudXa
         SxRdayNSOHpNA1a6MRDLHSkqmPNogQcLiNzgVsg6mOkE/3gKwKLWSmfQJtFEgFvtxswj
         QI49YQrjbyRhGIbq1OBl7DsSgaKWLLNUDYRpL3FFV6KpsUMoOTuVUyTHFSCylEFqyOY4
         OPNVJXAB/Jda/Jki2rwzILN54htLopyJjnhCT5gxOeCD4EVWmHB0Y3E32Xoq7AXsww3E
         Em1WA8pdw+VaaObOsGKceZcu+YLwjkM+VT31zVYPy/KQ+CaBQ1SHrNZo9t1Gok+7mTjo
         dkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=waroNZFBJLQwvUgcfZIcey5TzJEOeoUZhGZO7shkmD4=;
        b=JBmf8z77tZqSXIlIaUpQSlKZH0NwDck8UUv/DwPUoBOj27j4P/RCyjsKHrdjRX0c+q
         Jjg6rYX2lkLHVFF+oM6XUUxvZsz+RXXfy94dFIT4hKm3QTh/QJFsOS3lhkazfiwGFU/5
         LzvpTURMWtQ3FzBnBHaxAKm0mdv4GREJ91+7VEclZ9PWkmLNyZ3rQX4kin/BXz5VZM1D
         bgYuxRjH9viY418QRhh6VWiS+VpFifoOlNy7I+5+Otm1jr28sA0S1GzaAbN/ve/msMV7
         cYl5hQ15Pp/D6VVTIefY+ceEwKB9wkZllfkFNVRMWOKyaCa7SV5b4Y1KcA/n5Ry2DeO1
         Xb4g==
X-Gm-Message-State: ACrzQf1BA+nyTuRj3N4iviYly8fuFCM43tJDwkh09zxZXPdcPzzLvFeZ
        oVwgwf5fXQokeCtiXBRficLDXF+0y1g=
X-Google-Smtp-Source: AMsMyM6g04kjthjAd7frHf2YuwZeMdkgn2+dC+hM4ueJalzyegUJuqTcsVM6AEmYS+SjhhcWbjRa8B1oVUM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c986:b0:205:f08c:a82b with SMTP id
 w6-20020a17090ac98600b00205f08ca82bmr2823094pjt.1.1666198592333; Wed, 19 Oct
 2022 09:56:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:16 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-7-seanjc@google.com>
Subject: [PATCH v6 6/8] KVM: x86/mmu: Add helper to convert SPTE value to its
 shadow page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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
index 57c7c52d137a..f4f1b1591a02 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1818,7 +1818,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
+		child = spte_to_child_sp(ent);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2377,7 +2377,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
+		child = spte_to_child_sp(*sptep);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2398,7 +2398,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_child_sp(pte);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2837,7 +2837,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
+			child = spte_to_child_sp(pte);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3449,7 +3449,11 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
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
 
@@ -3934,8 +3938,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
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
index 7670c13ce251..7e5343339b90 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -219,6 +219,23 @@ static inline int spte_index(u64 *sptep)
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
2.38.0.413.g74048e4d9e-goog

