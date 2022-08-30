Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BB05A720F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiH3Xzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiH3Xzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:55:45 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4EB4A10B
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q128-20020a632a86000000b0042fadb61e4aso1261866pgq.3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=ZrmzY1nFE2+1TW1+wwiyIQ98bGSDZdyPkbZYanZN6ck=;
        b=mjIC5FT80dn+5a+gFVNuQk85fp5UWouRUcw+yNEZG8nZW8jM5VzonJshEPuRh3jYcG
         YcHYe0R2njhkVA+Fv/6DD5y1IOZSTrVWM7b4hbDb7I/Z0V2I5MEzpMRJqc2w0EhP1Akq
         NmdA0jOBFpDeESsasqjKl7mkk8xCG3xiyCYg5W5TvK4NyQaC8RFWX8uSS0Mx08G5vZWj
         dueYf8cpOo6qjPrKmy17ucK0wcQx3U+/aewNeNRLwKAN/+7rqkNfvtZDM8qnwVQX/9hH
         yKqlQNJnsRItcliBEBBIKJh5b1MTa42JtnCJlKIB3F7QwTdzNHpsMDaWHHjw7oEYrSKf
         FvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=ZrmzY1nFE2+1TW1+wwiyIQ98bGSDZdyPkbZYanZN6ck=;
        b=ojhpmF+Tekrh2yHWw2YETRUWD4rBH9KtljJjycYHoDPxFE2N4p4E3waeTx4A53FFTe
         ieVKI2Kg/43g9JlJQv9rfc6QFhOblKr3LtjRFpr9BvQOnMMc+0z6fBEIpug1/fJuxxy5
         2X8PBEvQp7O2Zs7C7E8JYn3D3eOnhyyHIaFAgxWYxpvbcjlIi4/YEbkNLy0ssFCUmOvM
         Xgi2uhpjOaCrYG7LVmvMwu/8n2EhVdrLoiJf2qhYisJimOLbJhpqwc1dyBASenbagddm
         S5NKbhv3XZVRziHZHwpmhk1+2C9KKeko6JLy8ISqcwO9zv1LzN2tOfMwhxcDS5Zxe0cV
         IwPA==
X-Gm-Message-State: ACgBeo22yfxaWOP5EPcsAu5/r0iOJQcU523Mj+tU6QI6rmLh3DIQXflM
        uujcbM/80jo5YVFDEcOLlddHAtWkuEQ=
X-Google-Smtp-Source: AA6agR4cxamvFPgNyhog7zx9BhleRmPCfOkJAtQKks21qozTSu7QccOb9bHTbqtUmOV9R+FiVVeHjlxUHlk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3911:b0:1fb:1f53:fa5 with SMTP id
 ob17-20020a17090b391100b001fb1f530fa5mr469698pjb.233.1661903742870; Tue, 30
 Aug 2022 16:55:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:55:30 +0000
In-Reply-To: <20220830235537.4004585-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830235537.4004585-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830235537.4004585-3-seanjc@google.com>
Subject: [PATCH v4 2/9] KVM: x86/mmu: Tag disallowed NX huge pages even if
 they're not tracked
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag shadow pages that cannot be replaced with an NX huge page regardless
of whether or not zapping the page would allow KVM to immediately create
a huge page, e.g. because something else prevents creating a huge page.

I.e. track pages that are disallowed from being NX huge pages regardless
of whether or not the page could have been huge at the time of fault.
KVM currently tracks pages that were disallowed from being huge due to
the NX workaround if and only if the page could otherwise be huge.  But
that fails to handled the scenario where whatever restriction prevented
KVM from installing a huge page goes away, e.g. if dirty logging is
disabled, the host mapping level changes, etc...

Failure to tag shadow pages appropriately could theoretically lead to
false negatives, e.g. if a fetch fault requests a small page and thus
isn't tracked, and a read/write fault later requests a huge page, KVM
will not reject the huge page as it should.

To avoid yet another flag, initialize the list_head and use list_empty()
to determine whether or not a page is on the list of NX huge pages that
should be recovered.

Note, the TDP MMU accounting is still flawed as fixing the TDP MMU is
more involved due to mmu_lock being held for read.  This will be
addressed in a future commit.

Fixes: 5bcaf3e1715f ("KVM: x86/mmu: Account NX huge page disallowed iff huge page was requested")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 +++-
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74afee3f2476..564a80a86984 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,15 +802,20 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible)
 {
-	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
+	if (KVM_BUG_ON(!list_empty(&sp->lpage_disallowed_link), kvm))
+		return;
+
+	sp->lpage_disallowed = true;
+
+	if (!nx_huge_page_possible)
 		return;
 
 	++kvm->stat.nx_lpage_splits;
 	list_add_tail(&sp->lpage_disallowed_link,
 		      &kvm->arch.lpage_disallowed_mmu_pages);
-	sp->lpage_disallowed = true;
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -832,9 +837,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	--kvm->stat.nx_lpage_splits;
 	sp->lpage_disallowed = false;
-	list_del(&sp->lpage_disallowed_link);
+
+	if (list_empty(&sp->lpage_disallowed_link))
+		return;
+
+	--kvm->stat.nx_lpage_splits;
+	list_del_init(&sp->lpage_disallowed_link);
 }
 
 static struct kvm_memory_slot *
@@ -2127,6 +2136,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
+	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
+
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
 	 * depends on valid pages being added to the head of the list.  See
@@ -3124,9 +3135,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed &&
-		    fault->req_level >= it.level)
-			account_huge_nx_page(vcpu->kvm, sp);
+		if (fault->is_tdp && fault->huge_page_disallowed)
+			account_huge_nx_page(vcpu->kvm, sp,
+					     fault->req_level >= it.level);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..cca1ad75d096 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -100,6 +100,13 @@ struct kvm_mmu_page {
 		};
 	};
 
+	/*
+	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
+	 * huge page.  A shadow page will have lpage_disallowed set but not be
+	 * on the list if a huge page is disallowed for other reasons, e.g.
+	 * because KVM is shadowing a PTE at the same gfn, the memslot isn't
+	 * properly aligned, etc...
+	 */
 	struct list_head lpage_disallowed_link;
 #ifdef CONFIG_X86_32
 	/*
@@ -315,7 +322,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 39e0205e7300..260dc8bc3d4f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -713,9 +713,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->huge_page_disallowed &&
-		    fault->req_level >= it.level)
-			account_huge_nx_page(vcpu->kvm, sp);
+		if (fault->huge_page_disallowed)
+			account_huge_nx_page(vcpu->kvm, sp,
+					     fault->req_level >= it.level);
 	}
 
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 672f0432d777..80a4a1a09131 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -284,6 +284,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
+	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
+
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
@@ -1141,7 +1143,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
-		account_huge_nx_page(kvm, sp);
+		account_huge_nx_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	tdp_account_mmu_page(kvm, sp);
 
-- 
2.37.2.672.g94769d06f0-goog

