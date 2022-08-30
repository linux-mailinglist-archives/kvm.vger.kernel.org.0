Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352A55A720C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiH3X4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiH3Xz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:55:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFC86FA37
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t13-20020a170902e84d00b00174b03be629so5080824plg.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=1t4LRP5kAW8XRqpj1wJe7nP5AI7g+bKmcPU7nOyMrf8=;
        b=P2q0Mo8lxezffgZkWNz/cJGfzYrkhJsiVF4lxTC20833HawT9KSi57N35KCei492Mf
         R8PuhpkKkW0NfzWLri9iSdQvEu4/9tve/4YNoq3RXSIe+6wwCtvXIpAszq2PLErBCf3S
         Bs+VWZK8vB+VU25wwtcOOwGWS/BrofxdldwT96sZIp34HeRbvNl1bf508TfCnEoH6I1t
         rVwm4usJvlriahOIy8EXueYjMWN/8bVUwD3UrO7MKH0pQkoDh5F+DIMM1QKE95WnmXep
         bBRwSBT78xOuC4WMUP+uPKUBtGeYMID60ar0EZjunNkWegWhMIxASSeFrv+Y8BFygQcH
         V7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=1t4LRP5kAW8XRqpj1wJe7nP5AI7g+bKmcPU7nOyMrf8=;
        b=usb4UP1+HFimaAyS4FG7GLiEG7WrA0qZZUh5AimP+JehD/Pewi/zTZ0XnSvK5QjzWL
         c8SjLLARefEfnKsEb4fbGSnXXc3zM2LkywMaEDmK5CLh6PC0U6AZhifD9DvcbKkkpvY6
         qNk8jdBQ/lfoAB0ThG0NU+53ECoGoBzeNahI5HaR0BNp9CZjV4XJIB5y6t5ertmBPW3w
         C/SQAbGcKpxjtabeCxcZPM/CeCCkmnnEHUjTM1C5l8Pwrcy46H6kS/8uen6EcIPfcUHN
         RD4MBPQ0qwj/j1Ibrgsl3s9aHyOakJ7CFTMWE09TlLK7db/zyujGHqoxHfJhBSOxlQ/e
         KDIg==
X-Gm-Message-State: ACgBeo2+m0VLxKzlcdBZLdJH0XT8uTYvYhInWXXI0nU1PsGbWrR8Tag0
        7qNz3bVMqd4Q2oo8AabkDoBrqnXHdAE=
X-Google-Smtp-Source: AA6agR4e7pm/YjX4nNdaGaNNAHx9YKfykLv7oIdGbw7GzAdJrsvShZEBKqqGO3VU0JJRnB29t31ujpWlURU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa01:b0:172:b0dc:ba40 with SMTP id
 be1-20020a170902aa0100b00172b0dcba40mr23639626plb.101.1661903751484; Tue, 30
 Aug 2022 16:55:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:55:35 +0000
In-Reply-To: <20220830235537.4004585-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830235537.4004585-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830235537.4004585-8-seanjc@google.com>
Subject: [PATCH v4 7/9] KVM: x86/mmu: Track the number of TDP MMU pages, but
 not the actual pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 48e51600f1be..6c2113e6d19c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1282,6 +1282,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1302,18 +1305,10 @@ struct kvm_arch {
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
index fd38465aee9e..92ad533f4f25 100644
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
@@ -1145,9 +1146,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
-- 
2.37.2.672.g94769d06f0-goog

