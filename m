Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D484FA0B7
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbiDIAlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiDIAlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:41:01 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C76C6F06
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:38:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i15-20020a17090a138f00b001cb64320375so146590pja.4
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JJ8+EAZcLP0IhGURS9E5DEEEdPamVlcyrs6/mYaAKeY=;
        b=MmyEt6GKp8Zghm+YSiKRQT2t3J2g00vdg15cu+mOIYj2ViSWyiash3iYqkQ1ApFnpD
         S1ZEVNE0ga7mdOo94bqHJJj04OTEV1Ymw0G3hczNQb51whxad5HqfkDGkE7wF4O4WiwZ
         D88Y5zIkDXS/DG4hVqcb6Q/D3ruLX+zaCplIofPuv2rp3pu/Xrad7Sl3WZRLXZszXn5G
         SvAjvKlGugKweRe4+riNlEqttGoOyJ0WqJBwPQf1TzUVPiqkunTtfQQZC3YhdSszFbQh
         O6Iyz7n+KKcE7g3Ynfk7w4liV6OKKCmY3H3aq0XwBmx0ZUvoBiYYaPeummgqg2vwvOgI
         qa2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JJ8+EAZcLP0IhGURS9E5DEEEdPamVlcyrs6/mYaAKeY=;
        b=kQi4cVP1v1G/+KmmJCZtas5fnfX5CpwCZvyshoU5hFWl2Lb55PTDnkZOvz7d4vP224
         krqcVqZjyc7lf8nxBuSTxWo1oxQqyW8vTa6oTOFOb8H7foZalKNZGphbL8lFqYxF+Xya
         cnZGaTMuIHC7/GR1TqxcB7LDZWRKoOXZcNmwWWtxSkpU6GyivwKBbfrdIFhGHKK0CtZU
         DJw1u6tZQ6VLNFj+2oHycZ7neXmE0loZZSFuOzMVSoqyzUdprI0QGlcK2UqmnnLZynEu
         zgDguZpfXXhcmHopRwn+nxIiVGv2+CwyZx0RPwFnv+wnNoF6YeJekfhT21rpARCoZhMS
         GnjA==
X-Gm-Message-State: AOAM5324ggMGBMvRboE916UDzb4GoN87+ZR2I5zb6TCPh44E4lyotUvG
        D8qeFHvTXzmxQSD3/AFmbWgWOFynJbE=
X-Google-Smtp-Source: ABdhPJzw0XWgdpHDT++V+w2BvrYhsxgvU32EUWXY8UOPJUMsN/c8iWC8oH1YhkUyxXzYc75E9l3ErQ0uRes=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8591:b0:1b9:da10:2127 with SMTP id
 m17-20020a17090a859100b001b9da102127mr24564586pjn.13.1649464735641; Fri, 08
 Apr 2022 17:38:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  9 Apr 2022 00:38:44 +0000
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
Message-Id: <20220409003847.819686-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 3/6] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU
 before setting SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

Set nx_huge_page_disallowed in TDP MMU shadow pages before making the SP
visible to other readers, i.e. before setting its SPTE.  This will allow
KVM to query the flag when determining if a shadow page can be replaced
by a NX huge page without violating the rules of the mitigation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 12 +++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  5 ++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 30 +++++++++++++++++-------------
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9416445afa3e..bc86997f9339 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -809,8 +809,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 }
 
-static void untrack_possible_nx_huge_page(struct kvm *kvm,
-					  struct kvm_mmu_page *sp)
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
@@ -819,15 +818,14 @@ static void untrack_possible_nx_huge_page(struct kvm *kvm,
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
 	untrack_possible_nx_huge_page(kvm, sp);
 }
 
-static void track_possible_nx_huge_page(struct kvm *kvm,
-					struct kvm_mmu_page *sp)
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (!list_empty(&sp->possible_nx_huge_page_link))
 		return;
@@ -837,8 +835,8 @@ static void track_possible_nx_huge_page(struct kvm *kvm,
 		      &kvm->arch.possible_nx_huge_pages);
 }
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible)
+static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				 bool nx_huge_page_possible)
 {
 	sp->nx_huge_page_disallowed = true;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5c460c727407..75e830c648da 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -181,8 +181,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-			  bool nx_huge_page_possible);
-void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f949d48724b..9966735601a6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -392,8 +392,10 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->nx_huge_page_disallowed)
-		unaccount_nx_huge_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed) {
+		sp->nx_huge_page_disallowed = false;
+		untrack_possible_nx_huge_page(kvm, sp);
+	}
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1102,16 +1104,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @sp: The new TDP page table to install.
- * @account_nx: True if this page table is being installed to split a
- *              non-executable huge page.
  * @shared: This operation is running under the MMU lock in read mode.
  *
  * Returns: 0 if the new page table was installed. Non-0 if the page table
  *          could not be installed (e.g. the atomic compare-exchange failed).
  */
 static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
-			   struct kvm_mmu_page *sp, bool account_nx,
-			   bool shared)
+			   struct kvm_mmu_page *sp, bool shared)
 {
 	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
 	int ret = 0;
@@ -1126,8 +1125,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
-	if (account_nx)
-		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	return 0;
@@ -1140,6 +1137,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1176,9 +1174,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			bool account_nx = fault->huge_page_disallowed &&
-					  fault->req_level >= iter.level;
-
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1190,10 +1185,19 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			sp = tdp_mmu_alloc_sp(vcpu);
 			tdp_mmu_init_child_sp(sp, &iter);
 
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
+			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+
+			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
+
+			if (fault->huge_page_disallowed &&
+			    fault->req_level >= iter.level) {
+				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+				track_possible_nx_huge_page(kvm, sp);
+				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+			}
 		}
 	}
 
@@ -1481,7 +1485,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
 	if (ret)
 		goto out;
 
-- 
2.35.1.1178.g4f1659d476-goog

