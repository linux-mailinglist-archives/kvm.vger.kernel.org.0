Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E080279337
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgIYVX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729072AbgIYVXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:25 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003A0C0613DA
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 135so3437240pfu.9
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=jlWnK0UatliDnGlUAK2d+RzZSNRxAzvcnq5xv9zblSM=;
        b=hUkuJGcGGOWXCuh3cgUdpzlmwWsVSOt/fpbdCKnS3R+E2rmbHpsFzpSNxlPgdkIv8q
         saKo1DDwM6Gw+SxtWWqGIo+9kwLa/eJc/yR4DKBw0tsuwriRlUz7OPgJO++uvlQtEDsG
         Lam4xfAZf6CqFaEsTaGSAmqVMgAuPmEr6kl4aYUIsqtnPM7cn6zDxKu6S1z/fJ7zgQPI
         QbpGj0sef5b15xuSxFDmID4GG4W7J9XbYip+GMGZGrEyG9kb2pFqWA50eSPeqziO8iD0
         /4hHeaUrcUi7lYesG6oPInO4ne9seHVstyE4gBV+SlJKAtoj+oEoEm36KETaZ2G3HvwY
         wzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jlWnK0UatliDnGlUAK2d+RzZSNRxAzvcnq5xv9zblSM=;
        b=YpLyWLG2v1A22wHxMWOmAyCxa/oaWpVIhIfgOGwAbxTBQygZNYEszvERSbmuQBpgiJ
         0IRId1ZK/xs21jJhFkL6U5ynPbbl4w+TIsFrSZb1BcbOtE6iaKtVNrWhjMJFIc7S6oDw
         U3jZ3qevvR7Yqu9RlYhqF51K1QMQ7OPn8EcXUiZI1QxZHGGYVqHyudZcCvK+ybxy7oEl
         kwDZMhNB8UcIfm1/SHBtVZnxog41ZK/sgf+SYcEvVaj86FL4RnQGf+XIFhhC9j56c+aU
         8mg0JVna6A313lUubbNuy5igcE62wDA91D4G6YRpnlqpPnWD6XTaQL0JyPnH2gAb8LBT
         4RJg==
X-Gm-Message-State: AOAM531hRmZCSb9MSUZUMZJhnQTFhfCrIEZxXMkxeAe0xjZP9ja8gVjX
        xhhbelbFMjfkf/8+PjsswZg80dNP5JOH
X-Google-Smtp-Source: ABdhPJxfPYyWGh6qxdLaDoqeK4fs5yqHKNRSUhi7+OavHqU4nQQy1q4RoM9BrE2CIUO80pEUH4i8c63S349B
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:bc8a:b029:d2:2a0b:f09e with SMTP
 id bb10-20020a170902bc8ab02900d22a0bf09emr1305261plb.33.1601069004450; Fri,
 25 Sep 2020 14:23:24 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:49 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-10-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 09/22] kvm: mmu: Remove disallowed_hugepage_adjust
 shadow_walk_iterator arg
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to avoid creating executable hugepages in the TDP MMU PF
handler, remove the dependency between disallowed_hugepage_adjust and
the shadow_walk_iterator. This will open the function up to being used
by the TDP MMU PF handler in a future patch.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 +++++++++--------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6344e7863a0f5..f6e6fc9959c04 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3295,13 +3295,12 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
-				       gfn_t gfn, kvm_pfn_t *pfnp, int *levelp)
+static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+					kvm_pfn_t *pfnp, int *goal_levelp)
 {
-	int level = *levelp;
-	u64 spte = *it.sptep;
+	int goal_level = *goal_levelp;
 
-	if (it.level == level && level > PG_LEVEL_4K &&
+	if (cur_level == goal_level && goal_level > PG_LEVEL_4K &&
 	    is_nx_huge_page_enabled() &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
@@ -3312,9 +3311,10 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(level) - KVM_PAGES_PER_HPAGE(level - 1);
+		u64 page_mask = KVM_PAGES_PER_HPAGE(goal_level) -
+				KVM_PAGES_PER_HPAGE(goal_level - 1);
 		*pfnp |= gfn & page_mask;
-		(*levelp)--;
+		(*goal_levelp)--;
 	}
 }
 
@@ -3339,7 +3339,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gfn, &pfn, &level);
+		disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
+					   &pfn, &level);
 
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4dd6b1e5b8cf7..6a8666cb0d24b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -690,7 +690,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &hlevel);
+		disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
+					   &pfn, &hlevel);
 
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == hlevel)
-- 
2.28.0.709.gb0816b6eb0-goog

