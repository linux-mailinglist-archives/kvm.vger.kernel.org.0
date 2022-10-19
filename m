Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D538604DE4
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJSQ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJSQ4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:25 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4E3159A22
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u8-20020a170902e5c800b00185483ee4f5so8501675plf.10
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tUi0BoiMqtO/M/WpUaQHGu1rzQiQ7c9np2BzoBF+UZg=;
        b=Wx1HWb2AcBMg7QFvDkkaYmzy/2Ol3jWSHV09YGjMZQhczMlcdYT0g571M8pTqkvscu
         07QFzJG1Epij+6OOw4tOL24/F6ieoj3UE/elZbukLXfCV7pKFjvpUEvBbSlhZvtps7Fe
         Z2+YkVZ7UIp0KaHuK6kiS4OWDbCRcnX5xh5nWLZ0eUPqAa7gX8C/YVd3EgRxFVrFA3RM
         jP4jPQ0tOydhJknuwYbF5Bg04SnkJuBC6kxbsFNepTozpVEZFHBgteXp1cj1oU+M8wKU
         1gKYnzFB3RQJ/tpJ0AArvkHq/wdxyJIUoeEQ2dHFSL6QtR9pqFG9JUD1yMYIqOFL0jCq
         k5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tUi0BoiMqtO/M/WpUaQHGu1rzQiQ7c9np2BzoBF+UZg=;
        b=X51xhTuoRyIA9p7vvLMwYt77jQcYh5IogB7U+u9YIHDeDKk9hWSq6JJrt/xeiHZAN1
         1Egt7Mo3tvVG6Nf5S/Be7M818Vc+40odjObNYBRsZRavnQMPJ8TE/hmH7zLipkblg02K
         6TS9AIGdRL3TGReJjBZt76SEosPiXKxxUKNWz9ecHfNWevNTRjyMDvKXqJXJ/NToqRZp
         GszQtLc8QmQSYuPk0kkstFCaY7zd+c7URR7BfmdIBn1HBV1rMeIhfAfXsEf51NVZVbYM
         4laU3pR2F5BTFzcu9OEOv9A/FOgIaccPFdDhSz5TlBo1n7Ia+9kloUAj0TzVcyDPFAOc
         SAcw==
X-Gm-Message-State: ACrzQf1FmyhFMhH9+bqx5dsb98CAks26MeL/gv43zCspIhruB8IyVhz6
        +j0eTBnOBmexpluWWH992M8N17EPMh4=
X-Google-Smtp-Source: AMsMyM5T5hC0RFvqL9v861YrNl0O+r6LYnfZUtEwhsBEiyFo5+Rev74O3Vtwk8iRJ280tm6VF2FBIllPUzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b794:b0:20a:eab5:cf39 with SMTP id
 m20-20020a17090ab79400b0020aeab5cf39mr2181968pjr.1.1666198583493; Wed, 19 Oct
 2022 09:56:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:11 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-2-seanjc@google.com>
Subject: [PATCH v6 1/8] KVM: x86/mmu: Tag disallowed NX huge pages even if
 they're not tracked
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
---
 arch/x86/kvm/mmu/mmu.c          | 32 ++++++++++++++++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h | 10 +++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 +++-
 4 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..f1e089dfdd22 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,15 +802,25 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible)
 {
-	if (sp->lpage_disallowed)
+	sp->lpage_disallowed = true;
+
+	/*
+	 * If it's possible to replace the shadow page with an NX huge page,
+	 * i.e. if the shadow page is the only thing currently preventing KVM
+	 * from using a huge page, add the shadow page to the list of "to be
+	 * zapped for NX recovery" pages.  Note, the shadow page can already be
+	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
+	 * links a shadow page at multiple points.
+	 */
+	if (!nx_huge_page_possible || !list_empty(&sp->lpage_disallowed_link))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
 	list_add_tail(&sp->lpage_disallowed_link,
 		      &kvm->arch.lpage_disallowed_mmu_pages);
-	sp->lpage_disallowed = true;
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -832,9 +842,13 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
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
@@ -2129,6 +2143,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
+	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
+
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
 	 * depends on valid pages being added to the head of the list.  See
@@ -3126,9 +3142,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
index 5ab5f94dcb6f..8fd0c4e1e575 100644
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
2.38.0.413.g74048e4d9e-goog

