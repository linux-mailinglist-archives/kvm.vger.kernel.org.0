Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA3C5F16DB
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiI3XtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiI3XtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:49:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACB71B0519
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:49:06 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h19-20020a63e153000000b00434dfee8dbaso3629112pgk.18
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=H6euU+4454q8CGbnq33+zFMbSuG2Rci2gYp38V1zcIU=;
        b=Be47tONdqBYfJJuQchT1XJ1Gya7gBThsKFxq2l9y4QmE0jGjrpo+oIJZgVkRcesfRe
         IqE47fWclavAFsm3U0HBhKC4y/rrG6Wch/dX7SAeQJwsIJb7q1KCwnlIAkTrvv0DLQOX
         bFrr2U7s9NNoPK0CBtyjMCWhwsMqI4EvGDSWRNXZSBaOWyyPGqsGRHam3ig+MA3FbQP4
         /9gmfDl9YDhzNh7/sOtiZxW6J7boMYCOZ4v6wlhi3GSjigGNWNqzrEXOeMwBJTTYx2o2
         WHeb73SBIJZkviX5E7tvXCpsnXBb3Am6ZE8akXprDmXTc3FuHJjZI4ZKxXyig8uZa/XE
         WEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=H6euU+4454q8CGbnq33+zFMbSuG2Rci2gYp38V1zcIU=;
        b=Ar5YyaKGb4VcnBNon0oC0BZRkwkoBBsf0y7rMTf5x15GXSWIGzGLG9ASY7NNtn1SyK
         NO/TQVw9EsR333weEt7CjyKViO6x5d0lFOOUgMJa8Xw545BAg3BQ2sRxY/rQBLjVohgE
         CkU4mvmWXbL2D3phmKC7qsk6aLpYWMPRfpA5op+VRTjJwQ5xKUxkCdW+2YvmhxnCRsal
         J3YsWm/uTvAx/S0exd2Kq+LlIrSmBVNSkZd6p70jgE9PG1NT0nltU89+HAy5twHc2g2V
         bM6J7xPVFhK3M85r/N/LcOismbt1dF83Zmb36kCZ2VXR77S+58MnkDLyVLMmByDrwROT
         T6pQ==
X-Gm-Message-State: ACrzQf2p/nL9cxFDSqIPZhQKNef89tigwa4wx+2uTADJa3WSbue7TmnH
        P+0RwdwEjZcmN4sPzUSrDRDDqODFKVA=
X-Google-Smtp-Source: AMsMyM4x5zIhbqXKMfRaMBIZjNOeVKDjjKX8QY2v1ejnkrC6aR5gYYMgt+VxGhLSewPgbXOOU1PhLqC21vU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1907:b0:557:e83b:1671 with SMTP id
 y7-20020a056a00190700b00557e83b1671mr11613591pfi.65.1664581745738; Fri, 30
 Sep 2022 16:49:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 30 Sep 2022 23:48:52 +0000
In-Reply-To: <20220930234854.1739690-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220930234854.1739690-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220930234854.1739690-6-seanjc@google.com>
Subject: [PATCH v5 5/7] KVM: x86/mmu: Track the number of TDP MMU pages, but
 not the actual pages
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

Track the number of TDP MMU "shadow" pages instead of tracking the pages
themselves. With the NX huge page list manipulation moved out of the common
linking flow, elminating the list-based tracking means the happy path of
adding a shadow page doesn't need to acquire a spinlock and can instead
inc/dec an atomic.

Keep the tracking as the WARN during TDP MMU teardown on leaked shadow
pages is very, very useful for detecting KVM bugs.

Tracking the number of pages will also make it trivial to expose the
counter to userspace as a stat in the future, which may or may not be
desirable.

Note, the TDP MMU needs to use a separate counter (and stat if that ever
comes to be) from the existing n_used_mmu_pages. The TDP MMU doesn't bother
supporting the shrinker nor does it honor KVM_SET_NR_MMU_PAGES (because the
TDP MMU consumes so few pages relative to shadow paging), and including TDP
MMU pages in that counter would break both the shrinker and shadow MMUs,
e.g. if a VM is using nested TDP.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      | 20 +++++++++-----------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 57714c24c004..c03590d1c5e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1289,6 +1289,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1309,18 +1312,10 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_roots;
 
-	/*
-	 * List of struct kvmp_mmu_pages not being used as roots.
-	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
-	 */
-	struct list_head tdp_mmu_pages;
-
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
-	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
 	 *  - possible_nx_huge_pages;
 	 *  - the possible_nx_huge_page_link field of struct kvm_mmu_pages used
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 059231c82345..4e5b3ae824c1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,7 +29,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 	kvm->arch.tdp_mmu_zap_wq = wq;
 	return 1;
 }
@@ -54,7 +53,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	/* Also waits for any queued work items.  */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -377,11 +376,13 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
 }
 
 static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
 }
 
 /**
@@ -397,17 +398,17 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
 	tdp_unaccount_mmu_page(kvm, sp);
+
+	if (!sp->nx_huge_page_disallowed)
+		return;
+
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	list_del(&sp->link);
-
-	if (sp->nx_huge_page_disallowed) {
-		sp->nx_huge_page_disallowed = false;
-		untrack_possible_nx_huge_page(kvm, sp);
-	}
+	sp->nx_huge_page_disallowed = false;
+	untrack_possible_nx_huge_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1140,9 +1141,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

