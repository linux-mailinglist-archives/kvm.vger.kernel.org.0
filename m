Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABA4EE847
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245514AbiDAGiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245456AbiDAGie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A1218D9AD
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:45 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id c6-20020a621c06000000b004fa7307e2e0so1107942pfc.6
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=79d9al9/Ox8ojgYPVafCO8rjr+Q8aeYemdUQb3D6s/c=;
        b=N3b6Yhe/1EBQnTkfpidMiqiMv9Vb0c2ONl+P0zVk+ldqlgRmqSNSMQzz6W5kdeqGiG
         5N2WnohG0La3eMJjqlEt/3fAoG0FKkeCcNZbs53PdEx+CCYJRIq4GDWaNN4awB4rzbS8
         beRw0rfxKpYYKnLouF0wkgn1rl0G6pTUde4p0fRb+Uz4rxrjqGOn4WdlcfElTdecYPvN
         MHTF3uzCRELJYPqahjhEgG+R2bBQpgMsZXZzdiauYrMLnVWuCIS0EDl1VSlcTykTG9iu
         1DuIBZKF/lDYPzhGhzXvyQKokiMKcVHqjG0BUPKFSBMhqXKkVHzcP4YkMG8UTy/6pxky
         yrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=79d9al9/Ox8ojgYPVafCO8rjr+Q8aeYemdUQb3D6s/c=;
        b=BNhXsFY2U6dnZH/+rC7Wo40pG7BQ7jy4xfykQuKd15+AE064dXbQESpqCKHmGovCJv
         QamCsBVsNHkdphUX8nSXodlw6OfYpvt8cF4bkhTOFr4S+/sTZSdJEyZr/Qss2d1W9/Vr
         ZhotVL3aKiM4wDTdJsu3fBDu4L6vTrV4H7vgmqLZSaiWuP+OhD27TA9d82kZBeyL+Pnr
         7YteuJe5jZiPaZ9jjHcgNtRiugR/scvAn7LZBAePWiqNtCBghZNKgODkcaTnHjMP1ESr
         2zsN7A6WiKorBm7S6Ot0Z7nT2u9XMdg2vh900gygqMBnmW3U/f3jtS5HH6kIce3pHIOf
         bLJA==
X-Gm-Message-State: AOAM531wwL9UNYok31d4w8xhKcztFqa+8NyY6F+0z7/XiWeKmrkYxKAa
        uxnyhtYpII5Vg8keLAp2QmueoMyvfrAP
X-Google-Smtp-Source: ABdhPJy3jxKjcEEonO+XJQJHQsbp/0IBv5UTK/0rCshy1zEI4VBGvkOvFuAhzl/cNBA6e0+bHVc8Bje4cTQi
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a63:1d62:0:b0:382:1421:c7 with SMTP id
 d34-20020a631d62000000b00382142100c7mr13700229pgm.416.1648795005383; Thu, 31
 Mar 2022 23:36:45 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:32 +0000
In-Reply-To: <20220401063636.2414200-1-mizhang@google.com>
Message-Id: <20220401063636.2414200-3-mizhang@google.com>
Mime-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 2/6] KVM: x86/mmu: Track the number of TDP MMU pages, but
 not the actual pages
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

From: Sean Christopherson <seanjc@google.com>

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

Cc: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++--------
 arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++--------
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9694dd5e6ccc..d0dd5ed2e209 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1192,6 +1192,9 @@ struct kvm_arch {
 	 */
 	bool tdp_mmu_enabled;
 
+	/* The number of TDP MMU pages across all roots. */
+	atomic64_t tdp_mmu_pages;
+
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
@@ -1212,18 +1215,10 @@ struct kvm_arch {
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
 	 *  - lpage_disallowed_mmu_pages
 	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f05423545e6d..5ca78a89d8ed 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -24,7 +24,6 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 	kvm->arch.tdp_mmu_zap_wq =
 		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 
@@ -51,7 +50,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
-	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
+	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -381,14 +380,17 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+
+	if (!sp->lpage_disallowed)
+		return;
+
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
-	list_del(&sp->link);
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	unaccount_huge_nx_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1141,9 +1143,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 		tdp_mmu_set_spte(kvm, iter, spte);
 	}
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	atomic64_inc(&kvm->arch.tdp_mmu_pages);
 
 	return 0;
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

