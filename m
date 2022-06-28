Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4C55F0DD
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiF1WJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiF1WJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:09:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EE033EAD
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d6-20020a17090a2a4600b001ec9df410b1so8675233pjg.6
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zRmORXBXFMKlgEhh847L9wk5+Tkdrd0vAZmkSGVZYF4=;
        b=fbkb1mcL4JwMDC7INxQP/HLMkigu2+XSoRdqZvn/egsmloIZPHZzc0WSEqasztzAbL
         JwN3YXP4JXLtPXTjMdf06sqC/OcuK6YB7u7C1Abpg/vXJzO9+F6hCF6veT4GAIDg3QqM
         JegO43jEF/1XnMY80wr4LJhXCz7ZBPTSrQUveykF501sFMywVnbfqOBb7BI0No43zQ8K
         KQ3rZNWLlzxCPLtjWJnHHfIMuvBDD6O9R3L8/U0XL5Ab2yjBEZl1K/edqE7Ja4rCM9eN
         962IWdUD2dBtGNrdnbdxRl0Om9n610p8gV0CeWzQv3iJf4MHjG5sGmfEf7fqf3qwkQZH
         e8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zRmORXBXFMKlgEhh847L9wk5+Tkdrd0vAZmkSGVZYF4=;
        b=h77CEuljWGnQ8lhyq8070dGmhmbPVRO3iVqqwlu4C3eKMYonzGe1sP/EkSGxw6cKnL
         vv4hBi1qjjHkp7hazmoNG9fH5t2OSvWaCb0PvD6okLDrsVW2t2MjeG+oja0Bhpr/iZfq
         CqXf1Ji/iBEKJ8wdXjoKeaSfhtX+tEJsBXzRoFbF0WrTVt21a3keyjn9Dvk6PU6Uff05
         mU6EmJPh8vaXzsT/AMyVSeUUebxpoyrd7KmBCFey4Bh6x0qmrsBYVUoSd5h5+ZKm2II6
         FOA/FinVBlE4KKLXEXqGTzMJQecbubdpDCe/T2wisMlaWMk5dIJRT4WGPGzueEkjCD2x
         4Nfw==
X-Gm-Message-State: AJIora+tGjUdBZVEwBICrC06jFnKCoZ/TDKx2ULVkGKDIGFfwedoY1X/
        hyFnG0SVFexG7BefmdvdW2ZcyrJdhZDcGGt2
X-Google-Smtp-Source: AGRyM1ss2DxZWj3O/rCwIHqtJxWHxWZ6RY794INkrCuGfU6r6qOjUw/clYSA1x1cZBb8OX79GtlQTaOwA0Impkkt
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:180e:b0:1ec:d129:708 with SMTP
 id lw14-20020a17090b180e00b001ecd1290708mr53378pjb.235.1656454188475; Tue, 28
 Jun 2022 15:09:48 -0700 (PDT)
Date:   Tue, 28 Jun 2022 22:09:37 +0000
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
Message-Id: <20220628220938.3657876-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v6 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
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

Count the pages used by KVM mmu on x86 in memory stats under secondary
pagetable stats (e.g. "SecPageTables" in /proc/meminfo) to give better
visibility into the memory consumption of KVM mmu in a similar way to
how normal user page tables are accounted.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7fa4c31b7c52..b1645202658ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1664,6 +1664,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
 	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
@@ -2123,7 +2135,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	 */
 	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm_account_mmu_page(kvm, sp);
 
 	sp->gfn = gfn;
 	sp->role = role;
@@ -2450,7 +2462,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 			list_add(&sp->link, invalid_list);
 		else
 			list_move(&sp->link, invalid_list);
-		kvm_mod_used_mmu_pages(kvm, -1);
+		kvm_unaccount_mmu_page(kvm, sp);
 	} else {
 		/*
 		 * Remove the active root from the active page list, the root
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3a430d64975c..3c5cb6054819a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -372,6 +372,16 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_account_pgtable_pages((void *)sp->spt, +1);
+}
+
+static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	kvm_account_pgtable_pages((void *)sp->spt, -1);
+}
+
 /**
  * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
  *
@@ -384,6 +394,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      bool shared)
 {
+	tdp_unaccount_mmu_page(kvm, sp);
 	if (shared)
 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	else
@@ -1136,6 +1147,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

