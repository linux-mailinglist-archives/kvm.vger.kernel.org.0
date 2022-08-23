Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8AA59CD5B
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiHWArA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbiHWAqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:46:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3FB4D14B
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3328a211611so212124927b3.5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=EkLRIi4h0Nka6IiKfSdPW+K8F+Olc1nYU6DQetBSKaQ=;
        b=MF5ReNPAwURHrNEDfeKCk+7IaZ9Gmt39gi9bYrinX/Ip0s0YD3aZDdn4PpiGJ1pZU8
         FoPm++7XgrvgTqT2111fxtgAXSmookyffVeQGq0LHtOdu1H+679O6wSUeUaz+uLXJ+r1
         AyA4jySXIN+jNxqamKM/C4/GMtwPiRd4rZf2eQVxjgKSXU2E2hNs8VnJBiOmahSF5YYX
         uOEylJcHlFgo+qDjtmiT1nbmHt4Wls5XZmDouDNWz/vlK4yru3xi3WEr7Dgv5Lgsw2DB
         VvhDfd90eUPxTTSNVqXb6x7NHlkMTeM74jhAUmX+s40jj7Ng9ENUqX0vVeuVOxz2l5gX
         Hqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=EkLRIi4h0Nka6IiKfSdPW+K8F+Olc1nYU6DQetBSKaQ=;
        b=48d8oOXzmdwv18L9QxEoaG4mQkKoBKB6xuhF5PY6Ydno3ToNq2mfaIzJruN7MBiJGv
         UGmH7znW2B6UvzPE5NYXZImVVgaNoXLlE31MMpWt5x+d7W/mRuVfuI0hVdop+xm2snGI
         az4rfdeGT4QmFxtaYZE5aI92U2/nz6FmzR9ieZPksDSgaVFovsWGxlkL3HsFrgu7+V+K
         EGra7Hf0VKI3V6r2E9ufsCwclcg0Pd1wEzi8DYkloz/nKsOkK9iq783fjd5hN2XnPUrF
         RMnX18QwDXzJ5GMZ2qqfTlk2kAL4Z7xJFpPUzS197kMu5e3ykJxOLBLo0HvL4gcI35k7
         aClQ==
X-Gm-Message-State: ACgBeo3gXvMSkFlyinL1EMC/ofrdZczGI9PR/U0E+wAjcyRTc1iV5wQ7
        /0kP/XbgM0VUXOKzPCmYon7anhq6iEkP9DJ1
X-Google-Smtp-Source: AA6agR4RNyS8SSFUY5vXG85d9HMLmmlrlOYpiSRxOw3mUkVuK6mcRLwM+M2e39f63bOYdysZ6qhsl4+hV/Zq9a0j
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a81:a551:0:b0:336:d825:1b5d with SMTP
 id v17-20020a81a551000000b00336d8251b5dmr21742340ywg.4.1661215608464; Mon, 22
 Aug 2022 17:46:48 -0700 (PDT)
Date:   Tue, 23 Aug 2022 00:46:38 +0000
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
Message-Id: <20220823004639.2387269-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..4d38e4eba772 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1665,6 +1665,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
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
@@ -2122,7 +2134,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	 */
 	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
 	list_add(&sp->link, &kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm_account_mmu_page(kvm, sp);
 
 	sp->gfn = gfn;
 	sp->role = role;
@@ -2456,7 +2468,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 			list_add(&sp->link, invalid_list);
 		else
 			list_move(&sp->link, invalid_list);
-		kvm_mod_used_mmu_pages(kvm, -1);
+		kvm_unaccount_mmu_page(kvm, sp);
 	} else {
 		/*
 		 * Remove the active root from the active page list, the root
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..672f0432d777 100644
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
@@ -1132,6 +1143,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	if (account_nx)
 		account_huge_nx_page(kvm, sp);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	tdp_account_mmu_page(kvm, sp);
 
 	return 0;
 }
-- 
2.37.1.595.g718a3a8f04-goog

