Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537DA604DEB
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiJSQ4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJSQ4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2AC1CFF3A
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q3-20020a17090311c300b0017898180dddso12146318plh.0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=X3MIYjg97/CMOF++gdgmdL3lkYNVJQ+hwakprJNa1vw=;
        b=El92XSKrFJmmBh4KfZzKzepItG1uCX4HbMX09QRxMZr1OWDatcXilIKUz56utPIpDH
         1OxZNpUR++MRrh0EyHFZLWpCqhbyhL0eCulj4zUbw2Qe49Ye/yusT/x52WKkMy4warlf
         SH+JnEvkqTCXBrMdUg4s4BJF/osU6WmXcuTAEA164VP4NPZESPf74orLZ9SxmZnTJ85V
         ek8g/yjRi5XzVFgCkydkvOQbo+w2pK9kwl80Rm4WZ1lwFZG60i8gNNXkw7dVF1UO+e7O
         lKcl0X+QatGHPr7WVCn7oiK1D7n8TPwEOUCmAENidE0ZvrYjqLDxQPwtfAKAHppONXmT
         llAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X3MIYjg97/CMOF++gdgmdL3lkYNVJQ+hwakprJNa1vw=;
        b=cG0DJuEwz1IHqN95/PL4KuuXQ1VDpAVHN+0TqfTPDTMQCQFAnvy2vPIX9uYR3QpVvv
         DAZTeQ9xUOKJ/3dTrlHHiRYD5KFcg1aZfxvUgfQrDrefe0awrGKtOaOaP1ykKmDCoNRB
         64iggsMU98/6T7ZRf0YxMuBqc1D4SvEwJXT+kz31lG+gcZSnZLVsqwggEQ6U5Uat6Vfx
         /ziYs7s0qkN19lHXbjtof6hv/K9Mq74SOiQMMkZ1FRLw0eF7oESyG26NDCi197KL23C+
         oXI9xuqq38MfiIvjAKjQznZk0xq8R0G4aC7RkVLpuhH2s0kK2hXQjNlTbTqTzCuPHEK/
         titQ==
X-Gm-Message-State: ACrzQf2iOxgIP/TAqnCGr9HyO8rEMxuTE6OGb1iJ781qrfoCIQ4XtN3s
        8EtQC1juVUH/Q0+OWJsjD1qnMLME4b0=
X-Google-Smtp-Source: AMsMyM5Wnc8RAWtDN80JeiLLjayPkRyUHSpOvmyMPw8avXMD/phGaVUx9XWM5YvSuQ4W9svjVd1/77bOxIw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6907:b0:179:c9bc:dd73 with SMTP id
 j7-20020a170902690700b00179c9bcdd73mr9515508plk.159.1666198590558; Wed, 19
 Oct 2022 09:56:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:15 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-6-seanjc@google.com>
Subject: [PATCH v6 5/8] KVM: x86/mmu: Track the number of TDP MMU pages, but
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
index 0333dbb8ec85..bbd2cecd34cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1290,6 +1290,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of kvm_mmu_page structs being used as roots.
 	 * All kvm_mmu_page structs in the list should have
@@ -1310,18 +1313,10 @@ struct kvm_arch {
 	 */
 	struct list_head tdp_mmu_roots;
 
-	/*
-	 * List of kvm_mmu_page structs not being used as roots.
-	 * All kvm_mmu_page structs in the list should have
-	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
-	 */
-	struct list_head tdp_mmu_pages;
-
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
 	 *  - tdp_mmu_roots (above)
-	 *  - tdp_mmu_pages (above)
 	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
 	 *  - possible_nx_huge_pages;
 	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
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
2.38.0.413.g74048e4d9e-goog

