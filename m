Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0242653892
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiLUWZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiLUWZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89B5275E0
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:39 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so7486088pjp.9
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jaams5HOGHGqoL3nWqw9y/u+ytv5a24WDfV/4t3+EM=;
        b=LDwwXjzscFBywLfN9uix9hm9llnv4amTnGjRnjZ8F1YoWJ+Sx8vfVGDC4kpHeC9EgO
         WEfcsu1baIScabXlw607E3i2788fHMyO1BW42G+5VcwQgeSz+v+pFd1u/ZvGxxcZewMy
         glCt5NEDvFxgZLf2WpUwBjGnB+61qLYoZe+yZIM+MdVv4lqAAJJSJ8No2FOJDwGC+2eo
         SShcXyTKuRFrZ6bHGPgKLETpTxyVlmx46vjGkcTyWPMWi+A6svFpJxcraGBV8jVYAheJ
         I/ZflFDXmfnhxn6uK6MeCWxfG0eYMFUoT0giUJZCSfsJHkNM5Axy8YtX7OUSRSnNuQ77
         hUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jaams5HOGHGqoL3nWqw9y/u+ytv5a24WDfV/4t3+EM=;
        b=Gl1cp3Snfi9lipwlTM26e3egkHiLrTjDRYdkWttcLAawMnezGPlgyOih8TDFRFNSn2
         CcQHypI1PPZpoUIYBWHA0SwuuMSvTUG5W3JvEGFyKGq6CBoFgarn1tVihavvnzYbFhAn
         3LDGQkTd0fIIkEW8eKTmPPguIp/c+sbXsXaG88Wm8dCOFfZ4qxjCp4+OWuenDMGdQQlI
         NFS1jsSSNslSXNBHf7IQcblGCsGSscTvk0rdVhlOUYvGa8G5wiDiBcY9hUCf7Z3ki53K
         ulsYFr8WfKLqlLzusJxkqGvIpjkGjia5hSGkj000THBDbFKoH2nttaZ2B8OV7t8v45ol
         LJ9g==
X-Gm-Message-State: AFqh2kq8dWAnuBPYrptyoS6EHWehwEwWYhdwGXhwcjc71s3NQ3Tv0b9t
        cG3Ktn2zD7Y4dbSwgsyeTo7SUfYwoeIo
X-Google-Smtp-Source: AMrXdXv3nPPSKzmL5MK8HgqmkhV+zzWahoEysQ0nKWMO9k5C3xkAafusuOpERZuBT6vSmNlvtCPFkPwx5seR
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a62:2f82:0:b0:576:670e:5de2 with SMTP id
 v124-20020a622f82000000b00576670e5de2mr274183pfv.70.1671661479091; Wed, 21
 Dec 2022 14:24:39 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:14 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-11-bgardon@google.com>
Subject: [RFC 10/14] KVM: x86/MMU: Fix naming on prepare / commit zap page functions
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

Since the various prepare / commit zap page functions are part of the
Shadow MMU and used all over both shadow_mmu.c and mmu.c, add _shadow_
to the function names to match the rest of the Shadow MMU interface.
Since there are so many uses of these functions, this rename gets its
own commit.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 21 +++++++--------
 arch/x86/kvm/mmu/shadow_mmu.c | 48 ++++++++++++++++++-----------------
 arch/x86/kvm/mmu/shadow_mmu.h | 13 +++++-----
 3 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 568b36de9eeb..160dd143a814 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -270,8 +270,9 @@ void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 		kvm_tdp_mmu_walk_lockless_end();
 	} else {
 		/*
-		 * Make sure the write to vcpu->mode is not reordered in front of
-		 * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
+		 * Make sure the write to vcpu->mode is not reordered in front
+		 * of reads to sptes.  If it does,
+		 * kvm_shadow_mmu_commit_zap_page() can see us
 		 * OUTSIDE_GUEST_MODE and proceed to free the shadow page table.
 		 */
 		smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
@@ -608,7 +609,7 @@ bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm, struct list_head *invalid_list
 		return false;
 
 	if (!list_empty(invalid_list))
-		kvm_mmu_commit_zap_page(kvm, invalid_list);
+		kvm_shadow_mmu_commit_zap_page(kvm, invalid_list);
 	else
 		kvm_flush_remote_tlbs(kvm);
 	return true;
@@ -1062,7 +1063,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
 	else if (!--sp->root_count && sp->role.invalid)
-		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+		kvm_shadow_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
 	*root_hpa = INVALID_PAGE;
 }
@@ -1115,7 +1116,7 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 		mmu->root.pgd = 0;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
@@ -1417,8 +1418,8 @@ bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	 * there is a pending request to free obsolete roots.  The request is
 	 * only a hint that the current root _may_ be obsolete and needs to be
 	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
-	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
-	 * to reload even if no vCPU is actively using the root.
+	 * previous root, then __kvm_shadow_mmu_prepare_zap_page() signals all
+	 * vCPUs to reload even if no vCPU is actively using the root.
 	 */
 	if (!sp && kvm_test_request(KVM_REQ_MMU_FREE_OBSOLETE_ROOTS, vcpu))
 		return true;
@@ -3103,13 +3104,13 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
 			continue;
-		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
+		if (__kvm_shadow_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
 		if (cond_resched_rwlock_write(&kvm->mmu_lock))
 			goto restart;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
@@ -3452,7 +3453,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		else if (is_tdp_mmu_page(sp))
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index e36b4d9c67f2..2d1a4026cf00 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1280,7 +1280,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
 
 	if (ret < 0)
-		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+		kvm_shadow_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 	return ret;
 }
 
@@ -1442,8 +1442,8 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			 * upper-level page will be write-protected.
 			 */
 			if (role.level > PG_LEVEL_4K && sp->unsync)
-				kvm_mmu_prepare_zap_page(kvm, sp,
-							 &invalid_list);
+				kvm_shadow_mmu_prepare_zap_page(kvm, sp,
+								&invalid_list);
 			continue;
 		}
 
@@ -1485,7 +1485,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 	++kvm->stat.mmu_cache_miss;
 
 out:
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
 		kvm->stat.max_mmu_page_hash_collisions = collisions;
@@ -1768,8 +1768,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *spte,
 			 */
 			if (tdp_enabled && invalid_list &&
 			    child->role.guest_mode && !child->parent_ptes.val)
-				return kvm_mmu_prepare_zap_page(kvm, child,
-								invalid_list);
+				return kvm_shadow_mmu_prepare_zap_page(kvm,
+							child, invalid_list);
 		}
 	} else if (is_mmio_spte(pte)) {
 		mmu_spte_clear_no_track(spte);
@@ -1814,7 +1814,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(kvm, sp, invalid_list);
 			mmu_pages_clear_parents(&parents);
 			zapped++;
 		}
@@ -1823,9 +1823,9 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 	return zapped;
 }
 
-bool __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				struct list_head *invalid_list,
-				int *nr_zapped)
+bool __kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				       struct list_head *invalid_list,
+				       int *nr_zapped)
 {
 	bool list_unstable, zapped_root = false;
 
@@ -1886,16 +1886,17 @@ bool __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return list_unstable;
 }
 
-bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      struct list_head *invalid_list)
+bool kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				     struct list_head *invalid_list)
 {
 	int nr_zapped;
 
-	__kvm_mmu_prepare_zap_page(kvm, sp, invalid_list, &nr_zapped);
+	__kvm_shadow_mmu_prepare_zap_page(kvm, sp, invalid_list, &nr_zapped);
 	return nr_zapped;
 }
 
-void kvm_mmu_commit_zap_page(struct kvm *kvm, struct list_head *invalid_list)
+void kvm_shadow_mmu_commit_zap_page(struct kvm *kvm,
+				    struct list_head *invalid_list)
 {
 	struct kvm_mmu_page *sp, *nsp;
 
@@ -1940,8 +1941,8 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
 		if (sp->root_count)
 			continue;
 
-		unstable = __kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list,
-						      &nr_zapped);
+		unstable = __kvm_shadow_mmu_prepare_zap_page(kvm, sp,
+						&invalid_list, &nr_zapped);
 		total_zapped += nr_zapped;
 		if (total_zapped >= nr_to_zap)
 			break;
@@ -1950,7 +1951,7 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
 			goto restart;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 
 	kvm->stat.mmu_recycled += total_zapped;
 	return total_zapped;
@@ -2021,9 +2022,9 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
-		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		kvm_shadow_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 
 	return r;
@@ -3020,7 +3021,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	for_each_gfn_valid_sp_with_gptes(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
-			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(vcpu->kvm, sp,
+							&invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
@@ -3128,7 +3130,7 @@ void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+		unstable = __kvm_shadow_mmu_prepare_zap_page(kvm, sp,
 				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
 		batch += nr_zapped;
 
@@ -3145,7 +3147,7 @@ void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
 	 * running with an obsolete MMU.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+	kvm_shadow_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
 bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
@@ -3426,7 +3428,7 @@ unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
 	write_lock(&kvm->mmu_lock);
 
 	if (kvm_shadow_mmu_has_zapped_obsolete_pages(kvm)) {
-		kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+		kvm_shadow_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 		goto out;
 	}
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 148cc3593d2b..af201d34d0b2 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -53,12 +53,13 @@ bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
 
-bool __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				struct list_head *invalid_list,
-				int *nr_zapped);
-bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      struct list_head *invalid_list);
-void kvm_mmu_commit_zap_page(struct kvm *kvm, struct list_head *invalid_list);
+bool __kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				       struct list_head *invalid_list,
+				       int *nr_zapped);
+bool kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				     struct list_head *invalid_list);
+void kvm_shadow_mmu_commit_zap_page(struct kvm *kvm,
+				    struct list_head *invalid_list);
 
 int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu);
 
-- 
2.39.0.314.g84b9a713c41-goog

