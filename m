Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27E833CA04
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhCOXis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhCOXiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:38:14 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741ABC06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:14 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c20so10307697qtw.9
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kl2EVOBmn7oQV8DsVZaFdaHri6MWqYz7gtsahKZb1Es=;
        b=qidQHbG8ZfyIg9dIuIPHeZczbB4TDnrajiH+GpYI8NXv1vvJgbEjKGAQUbSuWQAPDq
         Da9we1AIBx4DUAZBSovJmYC+QFzyagc2byZzyBymdijQ0LKTuwE/ZlTIzW5a7CJTQ1pA
         5vMmqmqLgaY7U3H8sc2F2hB+9ugpj4BpedoK9e5J4SoEnp/3XcOyd5lexR6u4vmYogmL
         zqim66i37eOa16VeTLPmvBfcU9NnL8uWmA3m4BQaAgddIx1SmGFmMH1Hpae+DMdR34xr
         /mbpeWukRRhfn70l+JEJg0hWuMD7cpkIkA/Hv8XKX9E6FQWKNorgNAIbMTOQicdLVxF6
         TKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kl2EVOBmn7oQV8DsVZaFdaHri6MWqYz7gtsahKZb1Es=;
        b=ZDZFY+JqPvqxhE5xHOV04QwVf14nRU9UThPQgeAF+foB4OGuXj5lAEF0LQNs1TwGhA
         tH5PXnwxE5btYLiv4KVmm3iJySTkIuEfcAqGYmyk+JHkHFxy31FgSreaer4uWFA51nZc
         g4oLkDs3AN2IKPbcFdyg7xKDvSlHNqKfybB7zgYKytf+KDGFml5yfaHiAR5Tc+UHprAZ
         bd2suP2VtJmD1t70wpkUqZ3LGRCg76jxZFsq03g/AaguUj2gMnkIfyXHoBhHa/3TNksw
         iZLHRM/ikh3we+AR/vA1wtXLMCx39U6vjS+Sm8NHvdyxclSRWfla5SukNM47qx3Q4EMK
         AA8w==
X-Gm-Message-State: AOAM532EuP3fCPvIijH91nGfKNZGI30vFHtcB3XRX2jwcM8ZwLggNh68
        4j5F3sLD/l4ZrA5wxWLzvi2gFCN6pHOc
X-Google-Smtp-Source: ABdhPJzJXakUfv9mJ/Kx+ckRp9KsEOpMzFQFnjFYsAHrC3+thh4wfProYb5J7i58/Y5o8wnMW6ToVw0WS4Z7
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a0c:b218:: with SMTP id
 x24mr13495443qvd.55.1615851493599; Mon, 15 Mar 2021 16:38:13 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:38:00 -0700
In-Reply-To: <20210315233803.2706477-1-bgardon@google.com>
Message-Id: <20210315233803.2706477-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210315233803.2706477-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 1/4] KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pt passed into handle_removed_tdp_mmu_page does not need RCU
protection, as it is not at any risk of being freed by another thread at
that point. However, the implicit cast from tdp_sptep_t to u64 * dropped
the __rcu annotation without a proper rcu_derefrence. Fix this by
passing the pt as a tdp_ptep_t and then rcu_dereferencing it in
the function.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d78915019b08..db2936cca4bf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -301,11 +301,16 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  *
  * Given a page table that has been removed from the TDP paging structure,
  * iterates through the page table to clear SPTEs and free child page tables.
+ *
+ * Note that pt is passed in as a tdp_ptep_t, but it does not need RCU
+ * protection. Since this thread removed it from the paging structure,
+ * this thread will be responsible for ensuring the page is freed. Hence the
+ * early rcu_dereferences in the function.
  */
-static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 					bool shared)
 {
-	struct kvm_mmu_page *sp = sptep_to_sp(pt);
+	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
 	gfn_t base_gfn = sp->gfn;
 	u64 old_child_spte;
@@ -318,7 +323,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
 	tdp_mmu_unlink_page(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		sptep = pt + i;
+		sptep = rcu_dereference(pt) + i;
 		gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
 
 		if (shared) {
-- 
2.31.0.rc2.261.g7f71774620-goog

