Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC80688678
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbjBBSaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjBBS30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:26 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDC91E292
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:42 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y9-20020a1709027c8900b00195e237dc8bso1313533pll.13
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TamQ7OunAE4JUpYasRsLdFf4L+G/oCkA7IYvB0Ze0GI=;
        b=Kd4q0HGp6rXEqYvuPFpu14ySATnUsyqeHtimcLiusOsHbo+XUUY11/D9w+KTWi32TN
         eitny6WUWUhqgnQqH0KcvvXlL/EezRN4RI+67mfbfnQxnYDh456aRbNvCBrN49NPBHUt
         q7WIMhCS8v9qymyctVGJerM42ANGqAz3pfNWH6UzSHhCf/Gy0rXHU28MHIGrAR8rp2j7
         8W6wmy6tZ74gfniRy27HLIYoNSkeQ/vJsE/HGRuMzhXwvsLVRf9ik8gDPFyZ32UfOFFD
         goJ2VcXA+GqEiETlVMOgd+HJT/WQI8V1VQ40S3eYYtEMU0Dy4cXZ8aPC9NVZxpeupxdO
         ke+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TamQ7OunAE4JUpYasRsLdFf4L+G/oCkA7IYvB0Ze0GI=;
        b=aUVfZj7cfkJKlcRzC99KyGIiFU3rJL/Hk68hvKaaTWLKOj1iZemm4iDyirjRwcE972
         mmTkbXPLGq9b7A9G/EMbn3X5qQT8bKaN4i5UoceBwsZiJhmhrQolXynDjqOOVJECXmez
         //Fmx66WulsYRK+8F9Upxq4Xbt6DdSV4qRxL2eJHlWixjdPQmXLi9hdhZ5yGSEP6JdlY
         BwLW2oHRrxu7h/JiIrZtYYSedaDbWmNU7sGghoruVEybp1Cv0UA67aMs1cSgkxbeRNwu
         jA5RQwth2rkQvNzHwLL0V9vMSAMPkr7U8RLRaddgAsl0/UFaf7ZrO7Q3xtMU/zzzpY2A
         LGjA==
X-Gm-Message-State: AO0yUKW8wOSRR1FyrvtsIju58qilvX+BOAPmmYQPUiWEvP/bk0tmHlB0
        CMafjPRIGeNmpZ4VSfy/KGwuxs+Dk/Bi
X-Google-Smtp-Source: AK7set8ZjdUMn8OosiXaHzdPzXHEVUwDqU5sA00SYdChOIl9SC9fnJ9/3lKhnb/qNcYCM1qpo12Cmfx07ze4
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:38e3:b0:230:815:ff39 with SMTP id
 x90-20020a17090a38e300b002300815ff39mr676156pjb.141.1675362512730; Thu, 02
 Feb 2023 10:28:32 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:01 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-14-bgardon@google.com>
Subject: [PATCH 13/21] KVM: x86/MMU: Fix naming on prepare / commit zap page functions
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
index 9308ab8102f9b..9b217e04cab0e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -230,8 +230,9 @@ void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
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
@@ -568,7 +569,7 @@ bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm, struct list_head *invalid_list
 		return false;
 
 	if (!list_empty(invalid_list))
-		kvm_mmu_commit_zap_page(kvm, invalid_list);
+		kvm_shadow_mmu_commit_zap_page(kvm, invalid_list);
 	else
 		kvm_flush_remote_tlbs(kvm);
 	return true;
@@ -1022,7 +1023,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (is_tdp_mmu_page(sp))
 		kvm_tdp_mmu_put_root(kvm, sp, false);
 	else if (!--sp->root_count && sp->role.invalid)
-		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+		kvm_shadow_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
 	*root_hpa = INVALID_PAGE;
 }
@@ -1075,7 +1076,7 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 		mmu->root.pgd = 0;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 	write_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
@@ -1397,8 +1398,8 @@ bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
@@ -3101,13 +3102,13 @@ void kvm_mmu_zap_all(struct kvm *kvm)
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
 
 	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
@@ -3457,7 +3458,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		else if (is_tdp_mmu_page(sp))
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		else
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 36b335d75aee2..32a24530cf19a 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1282,7 +1282,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
 
 	if (ret < 0)
-		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
+		kvm_shadow_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 	return ret;
 }
 
@@ -1444,8 +1444,8 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			 * upper-level page will be write-protected.
 			 */
 			if (role.level > PG_LEVEL_4K && sp->unsync)
-				kvm_mmu_prepare_zap_page(kvm, sp,
-							 &invalid_list);
+				kvm_shadow_mmu_prepare_zap_page(kvm, sp,
+								&invalid_list);
 			continue;
 		}
 
@@ -1487,7 +1487,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 	++kvm->stat.mmu_cache_miss;
 
 out:
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 
 	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
 		kvm->stat.max_mmu_page_hash_collisions = collisions;
@@ -1779,8 +1779,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *spte,
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
@@ -1825,7 +1825,7 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
 		struct kvm_mmu_page *sp;
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(kvm, sp, invalid_list);
 			mmu_pages_clear_parents(&parents);
 			zapped++;
 		}
@@ -1834,9 +1834,9 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
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
 
@@ -1898,16 +1898,17 @@ bool __kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
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
 
@@ -1952,8 +1953,8 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
 		if (sp->root_count)
 			continue;
 
-		unstable = __kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list,
-						      &nr_zapped);
+		unstable = __kvm_shadow_mmu_prepare_zap_page(kvm, sp,
+						&invalid_list, &nr_zapped);
 		total_zapped += nr_zapped;
 		if (total_zapped >= nr_to_zap)
 			break;
@@ -1962,7 +1963,7 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
 			goto restart;
 	}
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_shadow_mmu_commit_zap_page(kvm, &invalid_list);
 
 	kvm->stat.mmu_recycled += total_zapped;
 	return total_zapped;
@@ -2033,9 +2034,9 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
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
@@ -3032,7 +3033,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	for_each_gfn_valid_sp_with_gptes(vcpu->kvm, sp, gfn) {
 		if (detect_write_misaligned(sp, gpa, bytes) ||
 		      detect_write_flooding(sp)) {
-			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
+			kvm_shadow_mmu_prepare_zap_page(vcpu->kvm, sp,
+							&invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
@@ -3141,7 +3143,7 @@ void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+		unstable = __kvm_shadow_mmu_prepare_zap_page(kvm, sp,
 				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
 		batch += nr_zapped;
 
@@ -3158,7 +3160,7 @@ void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
 	 * running with an obsolete MMU.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+	kvm_shadow_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
 bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
@@ -3439,7 +3441,7 @@ unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
 	write_lock(&kvm->mmu_lock);
 
 	if (kvm_shadow_mmu_has_zapped_obsolete_pages(kvm)) {
-		kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+		kvm_shadow_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 		goto out;
 	}
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index cc28895d2a24f..82eed9bb9bc9a 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -66,12 +66,13 @@ bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
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
2.39.1.519.gcb327c4b5f-goog

