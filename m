Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334C733C593
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhCOS1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhCOS0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 14:26:55 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA738C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:26:54 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v136so25131360qkb.9
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kl2EVOBmn7oQV8DsVZaFdaHri6MWqYz7gtsahKZb1Es=;
        b=Rv6NWFBPwKRKkg6EwJMIts8fimw72c/OGbtenC6IXqCfA3n83O8Dkd5ROm6ba/dSPE
         SnZXXtvDLj0FCJzCP1AgccjPahos19OWax8j+79Erkty7snq8AbSnIlgukX6CQto5i1+
         EJIBv03ENC4fvoUMfBBR+bJTrOdakjsyxpp/E8bqr3RMeN9AjDZh/ERObS6wI8GpK6JZ
         eRMaWMyO2eBSnGh5pcQxmbbgvkB9DTs2g7BndSD3Se6Q56x3Hovz4VXDw9q2YdGr6cfb
         6UAMlHtgyWtYknHs4MaQ0gvnRy0CPwmd8jKGa0px/OwowLIYOEz+B2oguy6vWGdIzwB/
         LecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kl2EVOBmn7oQV8DsVZaFdaHri6MWqYz7gtsahKZb1Es=;
        b=uN8Y5if8lWmDTAJlR2UlsqWgBUzoPSCokGZTQLUlFd5dnUj9x3yZltZqOQAa4FTALI
         HYXLkDgXJHGDobgZ9X9MW1RkhSRuozKsBhvc9r3uXmXLczKyOdU0OxUA0Ty+EPKQrL6T
         mC/rdaMoffn0bpoP9wPKyTq381bK5hiqF7+LqH2Qob0nCx04ptgs/JhYbTEkjuHVJ/cQ
         3v6DRE2E/SXPA6M45R49lGMdzkfZrUsUFo+ugsO3SRyoh1pIaIoZ9pGCzA9YO6sYYNKh
         dcvOakKzJG6YIyzsTNhbRDpqLQKeXuSQV1zkfpWTAcSgTURoxp+LSuHg4KZpDO0PWw3u
         2k7w==
X-Gm-Message-State: AOAM531e4ymVgoQ0kikgoQx/PHoTR5ucJHxWvlI3u7lJMJhcrwVP0T0N
        BkhzlGLwr0lxsYcZnyjZVCbjacEkdQ2n
X-Google-Smtp-Source: ABdhPJyz4NSvQIXVCAJ7bB7UPsQH3hv1JaZPjv7eMUgMv/o/R6Al3q67ItDwhcs0ZfqoPuTTjMqaimXw8NZ2
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a05:6214:aa6:: with SMTP id
 ew6mr12058104qvb.2.1615832814124; Mon, 15 Mar 2021 11:26:54 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:26:40 -0700
In-Reply-To: <20210315182643.2437374-1-bgardon@google.com>
Message-Id: <20210315182643.2437374-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210315182643.2437374-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 1/4] KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
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

