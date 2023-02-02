Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8452B68866D
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBBS3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjBBS24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638636DFF9
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so2537605ybl.0
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SCjhftg1/DYUwFVT/w3C8ZdYHS1OzJkYD1GQMbpOnSA=;
        b=HlTm2yeT65x5qhKPD97fhROttSIpL9Llk0/tXW2MD0B7vVoGJR0wZXi5xs4h/ZxfyB
         j4hilZMTw3mXGQ+HHHXweXQWbfLQfK+j0/vL83Ot2YNxKpds9TyJsJ3JgO6z4MfXrmoW
         52cY6grV1ChIelYO+8TgHqJ0aAwpT3F2c1QGMp9sQ5T/j58R1TBMiBCiSrQvEOpawHH6
         sHT+Bmgis6Z/MrWkFRLcNM5URdTqokKKVf0FHug4c6yxqqrg5TkrIXIA6HTWiZ+o5I1z
         xE6VDaoDPgzJknJSm0KFuonUDaw8EkYEk1FwVHqzgXRDxqGkQNbgnNv8CvVzg5bPEIyq
         FNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SCjhftg1/DYUwFVT/w3C8ZdYHS1OzJkYD1GQMbpOnSA=;
        b=BAfuQjbt/edlvFw9WEOM7NZvIgDxDBgBIEih6YGgLgrWsJga3tnltI7OTcEUimEa+j
         OI/jo2PHV/ot6dlah2UiBGZWmuwNfwe4kUT40EWvaTyvRIy0uQFhvNrFdfcNnRiMvOc8
         F1P6Tc6ImLsb1EWoOeut4QEdkytFDerRAtBfdbNYFby2XOJv/a7T8vlNesiVzqMAHjXQ
         sAcRAosl5B6bTPhJA+u5dGbfr8vL7S60AO+9RrmRp76OYaoYbX/crfWat4Lu0vVl9Zbi
         ThyPS9nwj0rfAiTyB4gv3sK70uIySijHM2bijvkQ4t5SKPDfV3ng8ScP3DW5Jucmh+JT
         mmMA==
X-Gm-Message-State: AO0yUKVrAOW0ranZFVlfgHTbE7wz25uASB2mkc3w1O1G0I4hz5Mo/UuI
        zqPeISUMuFWDOjCJunwi01Dgbrq2pLKK
X-Google-Smtp-Source: AK7set+K9VPwwL2+87jhNxh3Q2jRojyZGxa7p6UqjeX+Oil0yLnwrqomMmmPNACeVs51/1aBGtsuVXLDCswU
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:690c:28c:b0:506:626d:f67d with SMTP id
 bf12-20020a05690c028c00b00506626df67dmr871738ywb.270.1675362506276; Thu, 02
 Feb 2023 10:28:26 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:57 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-10-bgardon@google.com>
Subject: [PATCH 09/21] KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
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
 arch/x86/kvm/mmu/shadow_mmu.c  | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h  | 25 ++++++++++++++++++++++++-
 4 files changed, 60 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da290bfca0137..cef481a17a519 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1697,35 +1697,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
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
 static void __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 				    u64 pa_bits_rsvd, int level, bool nx,
 				    bool gbpages, bool pse, bool amd)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 730b413eebfde..1251357794538 100644
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
@@ -889,7 +889,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
 
-static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
+void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -949,9 +949,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
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
@@ -984,7 +983,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  *   0: the sp is synced and no tlb flushing is required
  * > 0: the sp is synced and tlb flushing is required
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
 	union kvm_mmu_page_role root_role = vcpu->arch.mmu->root_role;
 	int i;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index f3e2ed5b675eb..c7cfdc6f51b53 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -12,6 +12,8 @@
  *   Yaniv Kamay  <yaniv@qumranet.com>
  *   Avi Kivity   <avi@qumranet.com>
  */
+
+#include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "mmutrace.h"
@@ -2809,6 +2811,35 @@ void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
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
index 4534eadc9a17c..7faf8b06e68f1 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -86,7 +86,6 @@ bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		       int level, pte_t unused);
 
 void drop_parent_pte(struct kvm_mmu_page *sp, u64 *parent_pte);
-int nonpaging_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp);
 int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
 		      bool can_yield);
 void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
@@ -163,4 +162,28 @@ void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
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
2.39.1.519.gcb327c4b5f-goog

