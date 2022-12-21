Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A301653889
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiLUWZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbiLUWYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:33 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65342275C6
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:31 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso1849pfi.7
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8kZrCNGBjg1WS7ODt19uiL6/LMaIleV0jy9dXg5qXsU=;
        b=gm4wVDeMjNDC25vIMLZJDuIuxtNrgMkW/U8DzY9/JjzdiZzvFqg5Z9nrrcuVrdI+Cr
         mlp9FAy3A+XDVeEZyHG8Xc52Dea5StINuVBgplWUrUUWZ69CNhfzLT4HzTN4LN1TEk0D
         IpYExoj/5fAFNK6+d1bgopQ28Zgn7SVezYfuMlI3pItzNuDAxxrhAWNTk67M+IKLP4c2
         n+qybJS7g4bTiF/kDELV1VGdQmRTOxAQSwONIrFtaMW76yMhZ3d0Kp39BOtqavNeur3r
         Auhjsa2ghpUls+QQDvUrWngcD+RIh8YLSET0PWut8cdrrGwgVsH0f/PqQl4TB9PEBsIV
         uuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8kZrCNGBjg1WS7ODt19uiL6/LMaIleV0jy9dXg5qXsU=;
        b=my9+ZGlkppHM0/5jmu7u7EMNUaNYzHpnM0ERdQeAX6T930N4xSTA7YVi9TxwbYTOzl
         KorRwPJtSyDAqUpVEU/L0G9m8Ec5IwoynggJ10dbkjkID9LVnYHeMwxe+jKizYqZYPch
         +L/PwR6mDDZ+uZwFTrP8PsKCAVbgAR/KvmSvwapznVl9UZPDCq49b9MMJ3mU5cWKWYPS
         wcjPvkMMwiL1Ksb7CFiVUj5RLLYVVEgDY1wZX4Z8z1hlRMYv+pyVRFH7sAIyg2ZUyYAc
         GEQYFH+ZBt9CKrFXDMGIQ2V5gOtIQIQ1xua4hGtihMXkTXkZ3Ek1S/vAc9JjXv2ByaII
         5snA==
X-Gm-Message-State: AFqh2kqFf4q3ib7r9YksdTTu0h2xnprd8vTn9sEWKhj+PF401odaqIVT
        SkIC/m6n+a5V0HJ92xquLnbgCOY4pk5u
X-Google-Smtp-Source: AMrXdXv30EHXL+5DK+Y+8Ijs4U9jsgv9W+gn+nLjMgEdO1gBmY8O8wHR5Scv0SFd17HJN2nRWWz7fI2pi91H
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:d510:b0:189:ced9:c9e7 with SMTP id
 b16-20020a170902d51000b00189ced9c9e7mr251984plg.108.1671661470555; Wed, 21
 Dec 2022 14:24:30 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:09 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-6-bgardon@google.com>
Subject: [RFC 05/14] KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
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

Move the integration point for paging_tmpl.h to shadow_mmu.c since
paging_tmpl.h is ostensibly part of the Shadow MMU. This requires
modifying some of the definitions to be non-static and then exporting
the pre-processed function names through shadow_mmu.h since they are
needed for mmu context callbacks in mmu.c. This will facilitate cleanups
in following commits because many of the functions being exposed by
shadow_mmu.h are only needed by paging_tmpl.h. Those functions will no
longer need to be exported.

sync_mmio_spte() is only used by paging_tmpl.h, so move it along with
the includes.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 29 -----------------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 11 +++++------
 arch/x86/kvm/mmu/shadow_mmu.c  | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h  | 25 ++++++++++++++++++++++++-
 4 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a17e8a79e4df..dd97e346c786 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1699,35 +1699,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 	return kvm_read_cr3(vcpu);
 }
 
-static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
-			   unsigned int access)
-{
-	if (unlikely(is_mmio_spte(*sptep))) {
-		if (gfn != get_mmio_spte_gfn(*sptep)) {
-			mmu_spte_clear_no_track(sptep);
-			return true;
-		}
-
-		mark_mmio_spte(vcpu, sptep, gfn, access);
-		return true;
-	}
-
-	return false;
-}
-
-#define PTTYPE_EPT 18 /* arbitrary */
-#define PTTYPE PTTYPE_EPT
-#include "paging_tmpl.h"
-#undef PTTYPE
-
-#define PTTYPE 64
-#include "paging_tmpl.h"
-#undef PTTYPE
-
-#define PTTYPE 32
-#include "paging_tmpl.h"
-#undef PTTYPE
-
 static void
 __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 			u64 pa_bits_rsvd, int level, bool nx, bool gbpages,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0f6455072055..2e3b2aca64ad 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -787,7 +787,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
  *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
  *           a negative value on error.
  */
-static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct guest_walker walker;
 	int r;
@@ -897,7 +897,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
+void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -957,9 +957,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 }
 
 /* Note, @addr is a GPA when gva_to_gpa() translates an L2 GPA to an L1 GPA. */
-static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			       gpa_t addr, u64 access,
-			       struct x86_exception *exception)
+gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, gpa_t addr,
+			u64 access, struct x86_exception *exception)
 {
 	struct guest_walker walker;
 	gpa_t gpa = INVALID_GPA;
@@ -992,7 +991,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  *   0: the sp is synced and no tlb flushing is required
  * > 0: the sp is synced and tlb flushing is required
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
 	int i;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 05d8f5be559d..86b5fb75d50a 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -10,6 +10,7 @@
  * Shadow MMU also supports TDP, it's just less scalable. The Shadow and TDP
  * MMUs can cooperate to support nested virtualization on hardware with TDP.
  */
+#include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "mmutrace.h"
@@ -2798,6 +2799,35 @@ void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	walk_shadow_page_lockless_end(vcpu);
 }
 
+static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
+			   unsigned int access)
+{
+	if (unlikely(is_mmio_spte(*sptep))) {
+		if (gfn != get_mmio_spte_gfn(*sptep)) {
+			mmu_spte_clear_no_track(sptep);
+			return true;
+		}
+
+		mark_mmio_spte(vcpu, sptep, gfn, access);
+		return true;
+	}
+
+	return false;
+}
+
+#define PTTYPE_EPT 18 /* arbitrary */
+#define PTTYPE PTTYPE_EPT
+#include "paging_tmpl.h"
+#undef PTTYPE
+
+#define PTTYPE 64
+#include "paging_tmpl.h"
+#undef PTTYPE
+
+#define PTTYPE 32
+#include "paging_tmpl.h"
+#undef PTTYPE
+
 static bool is_obsolete_root(struct kvm *kvm, hpa_t root_hpa)
 {
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 83876047c1f5..00d2f9abecf0 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -73,7 +73,6 @@ bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		       int level, pte_t unused);
 
 void drop_parent_pte(struct kvm_mmu_page *sp, u64 *parent_pte);
-int nonpaging_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
 int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
 		      bool can_yield);
 void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
@@ -150,4 +149,28 @@ void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 				    const struct kvm_memory_slot *slot);
 
 unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
+
+/* Exports from paging_tmpl.h */
+gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			  gpa_t vaddr, u64 access,
+			  struct x86_exception *exception);
+gpa_t paging64_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			  gpa_t vaddr, u64 access,
+			  struct x86_exception *exception);
+gpa_t ept_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, gpa_t vaddr,
+		     u64 access, struct x86_exception *exception);
+
+int paging32_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int paging64_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int ept_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+
+int paging32_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+int paging64_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+int ept_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+/* Defined in shadow_mmu.c. */
+int nonpaging_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
+
+void paging32_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root);
+void paging64_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root);
+void ept_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root);
 #endif /* __KVM_X86_MMU_SHADOW_MMU_H */
-- 
2.39.0.314.g84b9a713c41-goog

