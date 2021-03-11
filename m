Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61AE338150
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 00:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCKXRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 18:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhCKXR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 18:17:26 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07351C061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:26 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id u17so16348051qvq.23
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nVhAIt5VREXOLgbcbWfBMhCi9SRRPCjtnqZMSRmixNI=;
        b=qaP2XqovDlAUs0DzgGGp+lLIkzUk6IF44/j1LRwLkgKp8GwCLjAEdyBwoB1a7rHiVk
         V13xfo+YEeBoRTlpuxTGpryM4Cno45siFKYVCjytxck5FD+TV8sMfryv+0DM4fhB+0G/
         vDtmCATkTSlit0JfLKCruP7W+D8Ce2t71vDcY60Lyc5AWNzMuQbxoKVP+SXxVPbOoY6X
         9ZGcMY2uQmQOC0hO+S0Cx5U5VoNRguUMwHh5eE97otEo+D0D+JSpf+I/KNU7Ov4kqY88
         THsDkutN4A72Y54hKXLVxLOYFlFbBJgTE9sMLZT/HpS6MOsH3wx8HbuaYdRvVMsFdD8Y
         UyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nVhAIt5VREXOLgbcbWfBMhCi9SRRPCjtnqZMSRmixNI=;
        b=Gqw7ebNb6pnppN44GJQ55wwgLdKRagTuEPQUAH62fg+cG1VmfnJK+CdN3mUX7rQI0/
         K50OxeeoPRjKjf7MFD2+5QLuvu+eZJgRcML7L2dwwl4qt32P+HN1nWV2YIzgb5C8Jn6z
         zP5QTtSOOcjXOtyu4ulB7ZifrQ/HDgxkzBLRXQk5JFAfP/TXrycSz7mVCaYup912zWAw
         TgPIDVNkRPsYn3S7g2m9fPwUc5CesfR8IWujpShhyLKqzh4j+KCV5iF3B3hMY2wU+hhW
         LhvSzSMneMixZKOU3GbS87NFkcVP24g+dYGyW5jEDmz6elZPd1ejySl1nbvZvjw0l7mM
         778Q==
X-Gm-Message-State: AOAM533hwF+yrx+Zv/jI0xh+1Qhsx5LKpV6fbYz0Z6WJyoQlNY1ElDwX
        psO4MpkfWdV7BwK9PrRvlsYSjHgnja6L
X-Google-Smtp-Source: ABdhPJyud+Anzi0dLD+vZhAklD+994rvg7BLyxQt7Qx2vCqzkZRj/TkyJHEIwzonvah7XILrc+z2D4y4UrxL
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b4d4:7253:76fa:9c42])
 (user=bgardon job=sendgmr) by 2002:a0c:b59f:: with SMTP id
 g31mr9990587qve.28.1615504645150; Thu, 11 Mar 2021 15:17:25 -0800 (PST)
Date:   Thu, 11 Mar 2021 15:16:55 -0800
In-Reply-To: <20210311231658.1243953-1-bgardon@google.com>
Message-Id: <20210311231658.1243953-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210311231658.1243953-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 1/4] KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
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
Reported-by: kernel test robot <lkp@xxxxxxxxx>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c926c6b899a1..5387ac040f66 100644
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

