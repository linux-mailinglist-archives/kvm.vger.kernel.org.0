Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1B519126
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 00:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243558AbiECWRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 18:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243538AbiECWRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 18:17:38 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1790E2E6A9
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 15:14:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id u1-20020a17090a2b8100b001d9325a862fso7758241pjd.6
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 15:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VS+cZBe/F+V5XVdy41nyQYEcNSsK7oQL3Q7KYNlaZYY=;
        b=NB0cWlqq8l9J6viXcISkx6p1um2SBpCPPgM3hB/Xfxb0vebMy0IDNjk8LaC1PjdwmO
         xKZI1Ol6/kfTAaNvu+APTxnVSJ7fWeHqVYK2U6ljtE3yvgkCbfo27sBVqRN8gj35rUj5
         MeqUyjTKckVdHAcVc1UY0sL0W3eUnGygzLHGEm2vC29014Q2XVLKTKLojt2bpG0Ywcf6
         zaHKY77StU7GsHxEMCAq4dMLmD6eRQDQif/pcaPc0V5S/2NwlnI/COU2BgEWMT49FQpL
         wzXUR4AstcsuRhxeiFQkPhfSGWja5ZwjG5ywq0gldpXXSmSYloYAioDCikZkXp2dL52i
         9SfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VS+cZBe/F+V5XVdy41nyQYEcNSsK7oQL3Q7KYNlaZYY=;
        b=sIRQfMHjelGBo4npOndu5tp5vSm38eVfdNlGF9/skATQYnizYPGqnhjFGEGCi+gcAd
         OV1N5OoN+ZzFf3BuOkIE62hOw82WxiVT+vjfPOfWTXOuJ7P0vB7XK2jk3rmL5SXvsAdq
         RoX/NlJDv3d2Ce7Q3iRT3wJPFsF4t836CWv/4SkBQolJdD0UDEhXRNPtYMg1eHUGQtep
         EV66FQrmK6up1ioNpTlQrmZDjY5pjxAJycLma/fgqBONNAoTZjgMehX8XTTrwgrFxyya
         nQJzzmm5EhddlSzr+N6LtoCNRLSIpbE8AIcck/tnKNqIQgqrxSw/yRbb6VLPaoNgzNXR
         KySg==
X-Gm-Message-State: AOAM533bkJKjpp5j0y86LPk4z/emmlIxE3W5lQ4DJbTbu6t/RGjV1ln1
        KK9KI8OEXwducniCUoWVvZNDSKw+POb7
X-Google-Smtp-Source: ABdhPJwbYJ0pPCjgpDE1/BMvj2CtY+VLbYaKhkzHIiix4Z2nsbdSJXLWISM3RHg7iPF0w86JjlUmJWVD86OH
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:903:2310:b0:15e:bc9c:18b9 with SMTP id
 d16-20020a170903231000b0015ebc9c18b9mr3656980plh.58.1651616043565; Tue, 03
 May 2022 15:14:03 -0700 (PDT)
Date:   Tue,  3 May 2022 22:13:57 +0000
Message-Id: <20220503221357.943536-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH RFC] KVM: x86/mmu: Remove KVM memory shrinker
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, dmatlack@google.com
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

KVM memory shrinker is only used in the shadow paging. Most of the L1
guests are backed by TDP (Two Dimensional Paging) which do not use the
shrinker, only L2 guests are backed by shadow paging.

KVM memory shrinker can cause guests performance to degrade if any other
process (VM or non-VM) in the same or different cgroup in kernel causes
memory shrinker to run.

The KVM memory shrinker was introduced in 2008,
commit 3ee16c814511 ("KVM: MMU: allow the vm to shrink the kvm mmu
shadow caches"), each invocation of shrinker only released 1 shadow page
in 1 VM. This behavior was not effective until the batch zapping commit
was added in 2020, commit ebdb292dac79 ("KVM: x86/mmu: Batch zap MMU
pages when shrinking the slab"), which zaps multiple pages but still in
1 VM for each shrink invocation. Overall, this feature existed for many
years without providing meaningful benefit.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 99 ++----------------------------------------
 1 file changed, 3 insertions(+), 96 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e8d546431eb..80618c847ce2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -178,7 +178,6 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -1658,16 +1657,9 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
-/*
- * This value is the sum of all of the kvm instances's
- * kvm->arch.n_used_mmu_pages values.  We need a global,
- * aggregate version in order to make the slab shrinker
- * faster
- */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
+static inline void kvm_used_mmu_pages(struct kvm *kvm, long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
-	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
@@ -1725,7 +1717,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	 */
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	kvm_used_mmu_pages(vcpu->kvm, 1);
 	return sp;
 }
 
@@ -2341,7 +2333,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 			list_add(&sp->link, invalid_list);
 		else
 			list_move(&sp->link, invalid_list);
-		kvm_mod_used_mmu_pages(kvm, -1);
+		kvm_used_mmu_pages(kvm, -1);
 	} else {
 		/*
 		 * Remove the active root from the active page list, the root
@@ -5801,11 +5793,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
-{
-	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
-}
-
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
@@ -6159,77 +6146,6 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
-static unsigned long
-mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
-{
-	struct kvm *kvm;
-	int nr_to_scan = sc->nr_to_scan;
-	unsigned long freed = 0;
-
-	mutex_lock(&kvm_lock);
-
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int idx;
-		LIST_HEAD(invalid_list);
-
-		/*
-		 * Never scan more than sc->nr_to_scan VM instances.
-		 * Will not hit this condition practically since we do not try
-		 * to shrink more than one VM and it is very unlikely to see
-		 * !n_used_mmu_pages so many times.
-		 */
-		if (!nr_to_scan--)
-			break;
-		/*
-		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
-		 * here. We may skip a VM instance errorneosly, but we do not
-		 * want to shrink a VM that only started to populate its MMU
-		 * anyway.
-		 */
-		if (!kvm->arch.n_used_mmu_pages &&
-		    !kvm_has_zapped_obsolete_pages(kvm))
-			continue;
-
-		idx = srcu_read_lock(&kvm->srcu);
-		write_lock(&kvm->mmu_lock);
-
-		if (kvm_has_zapped_obsolete_pages(kvm)) {
-			kvm_mmu_commit_zap_page(kvm,
-			      &kvm->arch.zapped_obsolete_pages);
-			goto unlock;
-		}
-
-		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
-
-unlock:
-		write_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
-
-		/*
-		 * unfair on small ones
-		 * per-vm shrinkers cry out
-		 * sadness comes quickly
-		 */
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
-	}
-
-	mutex_unlock(&kvm_lock);
-	return freed;
-}
-
-static unsigned long
-mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
-{
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
-}
-
-static struct shrinker mmu_shrinker = {
-	.count_objects = mmu_shrink_count,
-	.scan_objects = mmu_shrink_scan,
-	.seeks = DEFAULT_SEEKS * 10,
-};
-
 static void mmu_destroy_caches(void)
 {
 	kmem_cache_destroy(pte_list_desc_cache);
@@ -6325,13 +6241,6 @@ int kvm_mmu_vendor_module_init(void)
 	if (!mmu_page_header_cache)
 		goto out;
 
-	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
-		goto out;
-
-	ret = register_shrinker(&mmu_shrinker);
-	if (ret)
-		goto out;
-
 	return 0;
 
 out:
@@ -6350,8 +6259,6 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
 }
 
 /*
-- 
2.36.0.464.gb9c8b46e94-goog

