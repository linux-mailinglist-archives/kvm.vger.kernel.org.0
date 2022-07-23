Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385BF57EB10
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiGWBX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiGWBXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:46 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFD0972DF
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g67-20020a636b46000000b0040e64eee874so3036968pgc.4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=btEsTIYySxPVQ4hIglgkyTpjS/v7UG71CQDMcqqOrRE=;
        b=drLQt2LDSl7jNOcsHF3VkSAntBfgOcE3aoog0eZYYNxZW9kHPgZFN+oRzHmfyaACAk
         UrfxUyFA9DbBL14mdrQ+kuaJxOnT4gPmMCWin5z2MS9M06j8dkxe2BaekZrj5X1zFZqh
         BaV5P20RK38wOFTUh2q3D1r7Ac2RddSEJJyL17p6hvzPb6eGYo1CxKBQKJj9D0IfHv7s
         IeY8qOtkJtZFE3ukbxZgTu3600E/onAUSfzX85nah37URUu/xX+gHeFolVBvzqG6qft6
         iHWglqluCmhGRmMMfgs30X8YvQ260GV6ZmGftkJKgZdAbE22Ogl2fj1tUDJE+0KpgE6e
         XELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=btEsTIYySxPVQ4hIglgkyTpjS/v7UG71CQDMcqqOrRE=;
        b=36SriWuuqwsyE1iFNTfXYqDQiZiQn7hpBamCoswtb0xakjEqeIBcR2Sz7u8vc2XTpY
         YmbkPKkrQWEwH9b9YmYfchHyugqWnFwUeKK2ryqyMn1wGq+yn7nT1rAD8KQAuj0j/hH6
         z8FZNKll5vJJaLSSvaBWzLt1gA5AZ3tiP0M+F4HuiF5yA3dQcrezKUHNulpo+1TT/fGh
         p8U6pACFyFYaGO84nqyGvClUpABMdl8HY/nwo50M8v3rvQ8JOziZEncpX8I/jCNewCbk
         wBG4BVYNjUGFjn69bIRZ8NZqVKa+pSQ2hWbPwEnb6TtO1DvKGBXcf3Hyil58rQjOO+nN
         k9sw==
X-Gm-Message-State: AJIora8hurH76egO7nW5zUeT+OxqSQdm4Kr/NtotJQ8+jmwCJA5zy1G3
        m0dYIiQY4XD/c+fMgvwTxFtXYBIIs4k=
X-Google-Smtp-Source: AGRyM1sBRjjvfJHZxZleZVjvWlLUsAJbEr6jx32pYFSyaLvCmqP+8OZpoJ/fFI+Xp8ppSGRuP/12F0/BEJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b92:b0:52a:e60d:dfbb with SMTP id
 g18-20020a056a000b9200b0052ae60ddfbbmr2602461pfj.72.1658539420974; Fri, 22
 Jul 2022 18:23:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:25 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 6/6] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

From: Mingwei Zhang <mizhang@google.com>

Explicitly check if a NX huge page is disallowed when determining if a page
fault needs to be forced to use a smaller sized page. KVM incorrectly
assumes that the NX huge page mitigation is the only scenario where KVM
will create a shadow page instead of a huge page. Any scenario that causes
KVM to zap leaf SPTEs may result in having a SP that can be made huge
without violating the NX huge page mitigation. E.g. disabling of dirty
logging, zapping from mmu_notifier due to page migration, guest MTRR
changes that affect the viability of a huge page, etc...

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add barrier comments, use spte_to_sp()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 17 +++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c |  6 ++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ed3cfb31853b..97980528bf4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3092,6 +3092,19 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		u64 page_mask;
+
+		/*
+		 * Ensure nx_huge_page_disallowed is read after checking for a
+		 * present shadow page.  A different vCPU may be concurrently
+		 * installing the shadow page if mmu_lock is held for read.
+		 * Pairs with the smp_wmb() in kvm_tdp_mmu_map().
+		 */
+		smp_rmb();
+
+		if (!spte_to_sp(spte)->nx_huge_page_disallowed)
+			return;
+
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -3099,8 +3112,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
-				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+			    KVM_PAGES_PER_HPAGE(cur_level - 1);
 		fault->pfn |= fault->gfn & page_mask;
 		fault->goal_level--;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fea22dc481a0..313092d4931a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1194,6 +1194,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			tdp_mmu_init_child_sp(sp, &iter);
 
 			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+			/*
+			 * Ensure nx_huge_page_disallowed is visible before the
+			 * SP is marked present, as mmu_lock is held for read.
+			 * Pairs with the smp_rmb() in disallowed_hugepage_adjust().
+			 */
+			smp_wmb();
 
 			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
 				tdp_mmu_free_sp(sp);
-- 
2.37.1.359.gd136c6c3e2-goog

