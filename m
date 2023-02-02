Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AEB68866F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjBBS3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjBBS3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:00 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB4279F0E
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:29 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 201-20020a6300d2000000b004ccf545f44fso1373279pga.12
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZ1HEwEMVxqlhDuM7XEGMF2OMxJrvw5/FJ7SR+T/ad8=;
        b=OHVXVGpCVzM0EbGrsrKhehaH5ULWml3IrlfPY6Jo4UAMn5inCsOWXYB1cvUeJNtXdA
         UfS9yb/fZXTG28yX9xD6JZmcXLur/xzJBjrs0e+fhd2ilyDa9RMkIxY603RVrBtLV+81
         CsRlC2gYChVYF0Rqbx2LMh2dByZ2Vg8SwasajDI69Dnpd6uStiFbqZlheIBgT4E+ySl7
         MrK2/2OBoUebq36L17SJcVofmFayxKfwx/AfF7nLa+/xgF5xEMAUQShZnSLGSXWYBkAX
         5RSISurkxzM20nJtaIAZEre9jUzF7lIW6r8H8Ywn7Ssy8Q6SJQpAgYvlorPdxrE/1VeT
         N6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZ1HEwEMVxqlhDuM7XEGMF2OMxJrvw5/FJ7SR+T/ad8=;
        b=IvSfBl3BtQnwbWXNV+ttv76b2xMh+TDGkd5OBgJnsE9L05JZzhGdoI2cvDMzndQz9y
         d+ZCQttguhtzPUUHsQ8jmoC2Ai477aEU76fsTgpbwy7/CpiiZsCNCU5swOYHvnUqxW6R
         P4DvT/tFMpn0buLVkgsN1jOolIIIGsFcXAblZWpewYNKWZZCU5hjQbV/QiyUytuIZfMX
         UB0iMX8qjHs+qpzykaoJEGMXVett7YoUWLKmvIHS23kzTNyeHuVdF86IVAL0QCg02E/O
         cwqnqinFPHjjZUfgpVSsq8SjGhTSzRBunwp/XgZxuAfL912baN67Jnw29aK90bcNWINe
         mGJw==
X-Gm-Message-State: AO0yUKVIXegRx7Md0jl7XJUU8LfnvBd86UXrQp+vCGZJ58D6R15o4D14
        CqnFQXvdQ/kwLnzD2Ed/+vPV8zLT9ZNX
X-Google-Smtp-Source: AK7set98uKIqN2Hk+6lI7wYw+OpAkAWiYJxKMAA+N+OzbNo7G+3bU3XnV7ia07hwl2XQS8SNeomS+ZaFO9uD
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90b:946:b0:22c:1bd6:77d5 with SMTP id
 dw6-20020a17090b094600b0022c1bd677d5mr815107pjb.18.1675362509401; Thu, 02 Feb
 2023 10:28:29 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:59 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-12-bgardon@google.com>
Subject: [PATCH 11/21] KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
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

The MMU shrinker currently only operates on the Shadow MMU, but having
the entire implemenatation in shadow_mmu.c is awkward since much of the
function isn't Shadow MMU specific. There has also been talk of changing
the target of the shrinker to the MMU caches rather than already allocated
page tables. As a result, it makes sense to move some of the implementation
back to mmu.c.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 43 ++++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.c | 62 ++++++++---------------------------
 arch/x86/kvm/mmu/shadow_mmu.h |  3 +-
 3 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cef481a17a519..3ea54b08239aa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3145,6 +3145,49 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
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
index 1be680bce15a6..76c50aca3c487 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -3160,7 +3160,7 @@ void kvm_zap_obsolete_pages(struct kvm *kvm)
 	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
+bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
 {
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
@@ -3429,60 +3429,24 @@ void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
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
index 9f16c4782bfbf..9e27d03fbe368 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -112,7 +112,8 @@ void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 				    const struct kvm_memory_slot *slot);
 
-unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
+bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
+unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
 
 /* Exports from paging_tmpl.h */
 gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-- 
2.39.1.519.gcb327c4b5f-goog

