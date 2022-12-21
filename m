Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4E65388E
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiLUWZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiLUWYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:42 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5508275D6
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:34 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id f132-20020a636a8a000000b00473d0b600ebso99341pgc.14
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y1uFW2wjlbXMFly7tpXboV7VZ3E/dcx8Q2Gfsts8Tk=;
        b=j6BY0U68byYLgySr44DngXyEm134/1hFKLFShEVTVJ/IuhmuHUhPj2IFs5+alWpjes
         FnmgU/a+mWQ9lDW3CaNzgmNQp5HsZoHpHcyV/b1il72r6Xzaj9qXk5NXsYY0j+JXwNjk
         FZejHNVrbE5LJsqGqrP4ZPA/zp5q0qfmZqF/ezW2x9qxFl5GNHdMhzaOZVSwWHoYKYqH
         08xYqohGPLH5zNwDVBBmvSSBKQHJMlkqT5i+Wtxx9V3Dvv+kdODLKmik7SKFpsmBhFQW
         cfjubSaMmD3KdtMWQs+eq26B7yPez7mGSsQDiVaiRL+/oXIuPIBq7yXEg4mMa1UUUuq9
         /2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y1uFW2wjlbXMFly7tpXboV7VZ3E/dcx8Q2Gfsts8Tk=;
        b=BQudgkn5h3umfvef9xFlTotCqNiWV4VvWBSebwd1U5BIhpKA8jLpmhEtKwMFvGHQSS
         HrejaNe78gllFg4BWxG40S83C5VgG+qcM0AgoL+DZ0tkNPhHT0zbSqZYLfrC6qBKJ1eZ
         ONmdatrUlA7aBBrUxAbEoyWE/ysCteBsqq9MdXRd+gtMnwOrWNTDoK1bFn4jWGYDLcGC
         t/gb2O4KwWYR7X04NlNEBrDxWy3S872g9tM+tQlFwsVFa7b3xlx9a0rt7JL2Tp1ThxRb
         y+oKL9l+eW38k+OFWOu4eqJ7oz8MzAFqra5/wKfSfUrG3NqA6wnBO/8rIZeACv7Ht3os
         HMxA==
X-Gm-Message-State: AFqh2kplDVod0zdOCPBUWSKSk/TJDchXrKJp0FgFbY+Zkrr8s12JyX1W
        J6COLdVR6twykSqMslJDHsyABJSvlBfz
X-Google-Smtp-Source: AMrXdXvazExc/WwGrAE0aK1dWeGFS+8c0Y9JCSXflaOtoGh5jJfoK8tAFLTB0ITsB+joVbHqUcbCzmpTgbnp
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8183:b0:219:9874:c7d3 with SMTP id
 e3-20020a17090a818300b002199874c7d3mr320888pjn.221.1671661474119; Wed, 21 Dec
 2022 14:24:34 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:11 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-8-bgardon@google.com>
Subject: [RFC 07/14] KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MMU shrinker currently only operates on the Shadow MMU, but having
the entire implemenatation in shadow_mmu.c is awkward since much of the
function isn't Shadow MMU specific. There has also been talk of changing the
target of the shrinker to the MMU caches rather than already allocated page
tables. As a result, it makes sense to move some of the implementation back
to mmu.c.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 43 ++++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.c | 62 ++++++++---------------------------
 arch/x86/kvm/mmu/shadow_mmu.h |  3 +-
 3 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd97e346c786..4c45a5b63356 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3147,6 +3147,49 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
+unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	struct kvm *kvm;
+	int nr_to_scan = sc->nr_to_scan;
+	unsigned long freed = 0;
+
+	mutex_lock(&kvm_lock);
+
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		/*
+		 * Never scan more than sc->nr_to_scan VM instances.
+		 * Will not hit this condition practically since we do not try
+		 * to shrink more than one VM and it is very unlikely to see
+		 * !n_used_mmu_pages so many times.
+		 */
+		if (!nr_to_scan--)
+			break;
+
+		/*
+		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
+		 * here. We may skip a VM instance errorneosly, but we do not
+		 * want to shrink a VM that only started to populate its MMU
+		 * anyway.
+		 */
+		if (!kvm->arch.n_used_mmu_pages &&
+		    !kvm_shadow_mmu_has_zapped_obsolete_pages(kvm))
+			continue;
+
+		freed = kvm_shadow_mmu_shrink_scan(kvm, sc->nr_to_scan);
+
+		/*
+		 * unfair on small ones
+		 * per-vm shrinkers cry out
+		 * sadness comes quickly
+		 */
+		list_move_tail(&kvm->vm_list, &vm_list);
+		break;
+	}
+
+	mutex_unlock(&kvm_lock);
+	return freed;
+}
+
 static struct shrinker mmu_shrinker = {
 	.count_objects = mmu_shrink_count,
 	.scan_objects = mmu_shrink_scan,
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 090b4788f7de..1259c4a3b140 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -3147,7 +3147,7 @@ void kvm_zap_obsolete_pages(struct kvm *kvm)
 	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
+bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
 {
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
@@ -3416,60 +3416,24 @@ void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 }
 
-unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
+unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
 {
-	struct kvm *kvm;
-	int nr_to_scan = sc->nr_to_scan;
 	unsigned long freed = 0;
+	int idx;
 
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
+	idx = srcu_read_lock(&kvm->srcu);
+	write_lock(&kvm->mmu_lock);
 
-		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
+	if (kvm_shadow_mmu_has_zapped_obsolete_pages(kvm)) {
+		kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
+		goto out;
+	}
 
-unlock:
-		write_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
+	freed = kvm_mmu_zap_oldest_mmu_pages(kvm, pages_to_free);
 
-		/*
-		 * unfair on small ones
-		 * per-vm shrinkers cry out
-		 * sadness comes quickly
-		 */
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
-	}
+out:
+	write_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 
-	mutex_unlock(&kvm_lock);
 	return freed;
 }
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 20c65a0ea52c..9952aa1e86cf 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -99,7 +99,8 @@ void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 				    const struct kvm_memory_slot *slot);
 
-unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
+bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
+unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
 
 /* Exports from paging_tmpl.h */
 gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-- 
2.39.0.314.g84b9a713c41-goog

