Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA14B688675
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjBBS35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjBBS3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA71E289
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:39 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y20-20020a170902cad400b001962668ef33so1316107pld.22
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qC/QhOftpR+PdNazZD7MOW3k7jLGZsIPHB5S26OPowU=;
        b=r1a9O5Vve17d01xB8zezcTdgAlg0zf+sD9UAz4qcAMUw6GmPEg9i6PFdfS0Qo2hbZz
         dmH62gkel4+bp++gx3KsQzO9hkJ3PfXwqOeVcG04pAA4INKjcm9IZXfVmvFdX0ZFdX7q
         RRbS8huuFX/aPZzBu6FQ6BSGfdggwGarEUFvGhMUKKP3QTZ7/d9dVCLgqFGkLPM45bSm
         mT4caN6RZDes88eDM/TIXJvSsg3HneHoRGMup7f44fn4YiqtA7NlyZxR2pRDtEXaLSIs
         1wB2aQR7pBWHFsNLVz6Idp3Czx1UYu5T4aH1YZJ3kO8MiOmDKPARWd1CmaGiacbUZFoE
         0Pvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qC/QhOftpR+PdNazZD7MOW3k7jLGZsIPHB5S26OPowU=;
        b=US7rwkjtccQegbXjJAj5i7ZO/tsribmiRP08+qxvCsr5bvK76I5P482FRTllzWizp5
         NXg/d5s4aYrVjTlR9VLOlSSwZmij5GCc0p1MOt/67koSSizlaF2Cl5kgd6fDJszQonrY
         J5BGXeTRELY5nih+13po867EeOGzZbok+djsXiseT+YC/JTE6+KWOH3ZD+BbhWD+QTF8
         2EtWFHEqdRgZJiD6G6E9+M/1s7PTB3Bw3mGbW2uv0t/PwT21L5LImLU5nmEzXoClzTr8
         T1JTVTUJP0NoFgvhtLZjbF4hbLNI1/ejAYE/vkuiuEmRmxCXa5mzmt8b5PjYjHCRnuNf
         NxIQ==
X-Gm-Message-State: AO0yUKWNqKxYygtJOl+Pxyy1fdzYPptQq72xQXj0uGPqfgaECjDyLxGu
        0xlAAVvMcFurU/FvAjELrdU+l+VrN1q6
X-Google-Smtp-Source: AK7set/jAQ1NfZlHaF5Qn0lnyCSHZuevPjSeGtv9HE76kB68dAGDKM6AVCKk8h+Y4dHAuXyCK0hrACvqz9rJ
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:8104:0:b0:592:591c:f6dd with SMTP id
 b4-20020aa78104000000b00592591cf6ddmr1613722pfi.7.1675362519372; Thu, 02 Feb
 2023 10:28:39 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:05 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-18-bgardon@google.com>
Subject: [PATCH 17/21] KVM: x86/MMU: Add kvm_shadow_mmu_ to the last few
 functions in shadow_mmu.h
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

Fix up the names of the last few Shadow MMU functions in shadow_mmu.h.
This gives a clean and obvious interface between the shared x86 MMU
code and the Shadow MMU. There are still a few functions exported from
paging_tmpl.h that are left as-is, but changing those will need to be
done separately, if at all.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 19 ++++++++-------
 arch/x86/kvm/mmu/shadow_mmu.c | 44 +++++++++++++++++++----------------
 arch/x86/kvm/mmu/shadow_mmu.h | 16 +++++++------
 3 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 156ab2e4cd811..f5b9db00eff99 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -884,7 +884,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (tdp_mmu_enabled)
 			sptep = kvm_tdp_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 		else
-			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
+			sptep = kvm_shadow_mmu_fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
 		if (!is_shadow_present_pte(spte))
 			break;
@@ -1073,7 +1073,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
+		root = kvm_shadow_mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		if (WARN_ON_ONCE(!mmu->pae_root)) {
@@ -1084,8 +1084,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
 
-			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
-					      PT32_ROOT_LEVEL);
+			root = kvm_shadow_mmu_alloc_root(vcpu,
+					i << (30 - PAGE_SHIFT), 0, PT32_ROOT_LEVEL);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
 					   shadow_me_value;
 		}
@@ -1663,7 +1663,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * count. Otherwise, clear the write flooding count.
 	 */
 	if (!new_role.direct)
-		__clear_sp_write_flooding_count(
+		kvm_shadow_mmu_clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root.hpa));
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
@@ -2439,13 +2439,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
-	r = mmu_alloc_special_roots(vcpu);
+	r = kvm_shadow_mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
 	if (vcpu->arch.mmu->root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
-		r = mmu_alloc_shadow_roots(vcpu);
+		r = kvm_shadow_mmu_alloc_shadow_roots(vcpu);
 	if (r)
 		goto out;
 
@@ -2674,7 +2674,8 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * generally doesn't use PAE paging and can skip allocating the PDP
 	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
 	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
-	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
+	 * KVM; that horror is handled on-demand by
+	 * kvm_shadow_mmu_alloc_special_roots().
 	 */
 	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
@@ -2817,7 +2818,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 			return r;
 	}
 
-	node->track_write = kvm_mmu_pte_write;
+	node->track_write = kvm_shadow_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index dfff65db97c3b..eb4424fedd73a 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1404,14 +1404,14 @@ static int mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *parent,
 	return 0;
 }
 
-void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
+void kvm_shadow_mmu_clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
 {
 	atomic_set(&sp->write_flooding_count,  0);
 }
 
 static void clear_sp_write_flooding_count(u64 *spte)
 {
-	__clear_sp_write_flooding_count(sptep_to_sp(spte));
+	kvm_shadow_mmu_clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
 /*
@@ -1482,7 +1482,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 				kvm_flush_remote_tlbs(kvm);
 		}
 
-		__clear_sp_write_flooding_count(sp);
+		kvm_shadow_mmu_clear_sp_write_flooding_count(sp);
 
 		goto out;
 	}
@@ -1607,12 +1607,13 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
 	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
 	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
 	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
-	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
-	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
-	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
-	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
-	 * covers bit 21 (see above), thus the quadrant is calculated from the
-	 * _least_ significant bit of the PDE index.
+	 * quadrant is assigned in kvm_shadow_mmu_alloc_root().
+	 * A 4-byte PTE consumes bits 21:12, while an 8-byte PTE consumes
+	 * bits 20:12.  To consume bit 21 in the PTE (the child here), KVM
+	 * propagates that bit to the quadrant, i.e. sets quadrant to
+	 * '0' or '1'.  The parent 8-byte PDE covers bit 21 (see above), thus
+	 * the quadrant is calculated from the _least_ significant bit of the
+	 * PDE index.
 	 */
 	if (role.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
@@ -2389,7 +2390,8 @@ int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *faul
  *  - Must be called between walk_shadow_page_lockless_{begin,end}.
  *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
  */
-u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
+u64 *kvm_shadow_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa,
+					   u64 *spte)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	u64 old_spte;
@@ -2442,7 +2444,8 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
-hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level)
+hpa_t kvm_shadow_mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
+				u8 level)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm_mmu_page *sp;
@@ -2459,7 +2462,7 @@ hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level)
 	return __pa(sp->spt);
 }
 
-static int mmu_first_shadow_root_alloc(struct kvm *kvm)
+static int kvm_shadow_mmu_first_shadow_root_alloc(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *slot;
@@ -2520,7 +2523,7 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	return r;
 }
 
-int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptrs[4], pm_mask;
@@ -2549,7 +2552,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	r = mmu_first_shadow_root_alloc(vcpu->kvm);
+	r = kvm_shadow_mmu_first_shadow_root_alloc(vcpu->kvm);
 	if (r)
 		return r;
 
@@ -2563,8 +2566,8 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      mmu->root_role.level);
+		root = kvm_shadow_mmu_alloc_root(vcpu, root_gfn, 0,
+						 mmu->root_role.level);
 		mmu->root.hpa = root;
 		goto set_root_pgd;
 	}
@@ -2617,7 +2620,8 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		 */
 		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
 
-		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL);
+		root = kvm_shadow_mmu_alloc_root(vcpu, root_gfn, quadrant,
+						 PT32_ROOT_LEVEL);
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
@@ -2636,7 +2640,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
-int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	bool need_pml5 = mmu->root_role.level > PT64_ROOT_4LEVEL;
@@ -3009,8 +3013,8 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	return spte;
 }
 
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-		       int bytes, struct kvm_page_track_notifier_node *node)
+void kvm_shadow_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
+			      int bytes, struct kvm_page_track_notifier_node *node)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index e4fbc842f524e..4d39017873aa6 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -39,7 +39,7 @@ struct pte_list_desc {
 /* Only exported for debugfs.c. */
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
-void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
+void kvm_shadow_mmu_clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
 
 bool __kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				       struct list_head *invalid_list,
@@ -54,17 +54,19 @@ int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu);
 int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
 int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte);
+u64 *kvm_shadow_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa,
+					   u64 *spte);
 
-hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level);
-int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
-int mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
+hpa_t kvm_shadow_mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
+				u8 level);
+int kvm_shadow_mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
+int kvm_shadow_mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
 
 int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			    int *root_level);
 
-void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
-		       int bytes, struct kvm_page_track_notifier_node *node);
+void kvm_shadow_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
+			      int bytes, struct kvm_page_track_notifier_node *node);
 
 void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm);
 bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
-- 
2.39.1.519.gcb327c4b5f-goog

