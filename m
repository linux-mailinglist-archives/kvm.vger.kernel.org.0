Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBABB494397
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357732AbiASXJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343638AbiASXH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:07:58 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D667C06175C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:58 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q3-20020a638c43000000b0034c9c0fb2d2so2488969pgn.22
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YDqrNo/wldgkip0bjkyjtlYC24PWdJYaAJiVksfVa1s=;
        b=pI6o0jOUFXYEfIpTgP1sKyK34MbesDr4s9XQNKYpB5+6eeJuz9urLWcDbJWTbdBj3K
         EnYrWlVWHCJG43hl+szowXw7XKp6pBkR0QIGXGG3NAkdrxeeHj6Wp12m9/kPuz5kLmkM
         TuYlOS+R5Zfe0KcdiztQnlwnmZcBEm4U+u1pG4RFnTrfdOfHf+Lh9TuANno4tDR8RxBP
         EM0G/sRzNn9LjlWXxO1JJAvubiyWiD22PnUCc6pO/pjQ6caAODelxoTiUCScfK/yOH5i
         5ZIdq7LXbv9WA9I9Vqoztfdre8mNHyx0h3KfO2GJQ8T/PlC9LsGtFKJgp25cE0RF0t7d
         TXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YDqrNo/wldgkip0bjkyjtlYC24PWdJYaAJiVksfVa1s=;
        b=4Y7CW7Olfej87mu2qyqchIHBmGDguaDQ7yODjWufYk8bI6UxfTcXivQXyPeLGAZXXd
         04U55rVeqNX4pOwFXs4z7W5+t6plxcnka8njgZmXV4lj1C1xzztohxnWTJpLfNmzCxLE
         ODrFo5eHGOUYo9gOTmqn/nYArnF1taApNJERBhKXc9Yq5wjOMGD79iBzUV5rd9/f+Nq6
         5Dl5UJV4058ez/1gNzzIPPWVPGfv6cX5EODLTK+JR2XxNjID9aiMqlYnIpGLpgNfL9Ny
         Ku6Xy0CouFCR1wBNf297MZW5b9Gud0AnJQO4m1V2E/rCiyX+REhHGB6lwwsOFTzeBt6r
         n3eg==
X-Gm-Message-State: AOAM532qLTSmCF2quhDND8iA/yTlzZ2qaPrSmFZAh+1bZYqxIneptbXL
        qcOznmmriCWvwLJ0eGWdrHJx8Gx+87VCvw==
X-Google-Smtp-Source: ABdhPJxC3RGwtAncFp0wYVbbZ2N9aYR6GBFCFJtxe8PRZ2utdWX60ujqYUINh4yx92vGsYBiRKEg0vafeL1S+g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4d84:: with SMTP id
 oj4mr741490pjb.0.1642633677370; Wed, 19 Jan 2022 15:07:57 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:27 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 06/18] KVM: x86/mmu: Rename handle_removed_tdp_mmu_page()
 to handle_removed_pt()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First remove tdp_mmu_ from the name since it is redundant given that it
is a static function in tdp_mmu.c. There is a pattern of using tdp_mmu_
as a prefix in the names of static TDP MMU functions, but all of the
other handle_*() variants do not include such a prefix. So drop it
entirely.

Then change "page" to "pt" to convey that this is operating on a page
table rather than an struct page. Purposely use "pt" instead of "sp"
since this function takes the raw RCU-protected page table pointer as an
argument rather than  a pointer to the struct kvm_mmu_page.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 15cce503ffde..902dd6e49e50 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -295,7 +295,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 }
 
 /**
- * handle_removed_tdp_mmu_page - handle a pt removed from the TDP structure
+ * handle_removed_pt() - handle a page table removed from the TDP structure
  *
  * @kvm: kvm instance
  * @pt: the page removed from the paging structure
@@ -311,8 +311,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
  * this thread will be responsible for ensuring the page is freed. Hence the
  * early rcu_dereferences in the function.
  */
-static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
-					bool shared)
+static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
@@ -472,8 +471,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * the paging structure.
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
-		handle_removed_tdp_mmu_page(kvm,
-				spte_to_child_pt(old_spte, level), shared);
+		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-- 
2.35.0.rc0.227.g00780c9af4-goog

