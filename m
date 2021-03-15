Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C942533CA09
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbhCOXiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhCOXiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:38:18 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEE1C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:18 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id l7so4634895qvz.19
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EKob6tlP8lBjDbv9XP0X/EBXxf5qoM5NvDApjzhDeLw=;
        b=sfwzFNMfZj1M0pRVHjCNpZruP1XeXS/Aqo5imtnIYZ4t2H3I1D8pTBE2Adlm+oUgGP
         SvL0WaMc0xh5pGTqxkB8IzOmCIJjsGvxjgIXOCDhfNIq34k/m2SmlJSQGq5x0GNRCAkP
         6AYwjXjhIHSB9wpMmSn9NmAMqxMHI5Psu2arOhaKanAP08+Yh+Ir0lzMzHsbKOVoKs+A
         ne2Ir1tgusgsj2bIadvDr1054Ju+pBiXgrWTqVkFOpFEmjl85m0WGcbetqcpSL91QVVJ
         dul/k2myZ8QOSmkEKyfD2/9z82w8Y/+SVPTmqlA4CcQX8ryKacxPFuOfeFOP/qe0w0xa
         vc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EKob6tlP8lBjDbv9XP0X/EBXxf5qoM5NvDApjzhDeLw=;
        b=h+dt0+SucMTuDHQcqOTxjy4Y0N9FdavyGsHwBawNE8XEhTwhZOG8/SMMxFd/np7J9e
         03bzgZo5oLMV6bIOOj05B5KjdYEkNjf7thqknB+FdocVk2cv3q1Z0e5nvcqf5M2hil6J
         dMxaM9UX2AcSnP4sTpz5DOJE56wG4/WoLFKzNypXyjOWUq+OfR3G9ivgDB1gfh/YDmhS
         Nlqnxp0K76jswiJ/jjkQO7GolYExkAZhmoIEfJ6B2pCiPt6Uhgrt4GMLorXwcqqTFFYr
         T9vVknhPhr8bjiVlMzdKL/ycm7cRuJrA+24b51yHLo8MULRGSHpkTWHCwbOphMotFLFk
         LYzA==
X-Gm-Message-State: AOAM530YGfMAAgPjspWekpaWDm2BBU5CEOd/X34fKhjjofQYDH4yBZoT
        LANgOg3/dz51V/8nNPUlZmXr9fUw4nLj
X-Google-Smtp-Source: ABdhPJwlTVQpLrRMyCITzXCRmt1G+SDI9IyzKARtZfhU1x85Ggu9SGcr+gl2zv3mEp8vr13HwX7NEtMNayHy
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:ad4:5c4f:: with SMTP id
 a15mr13176294qva.41.1615851497419; Mon, 15 Mar 2021 16:38:17 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:38:02 -0700
In-Reply-To: <20210315233803.2706477-1-bgardon@google.com>
Message-Id: <20210315233803.2706477-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210315233803.2706477-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 3/4] KVM: x86/mmu: Factor out tdp_iter_return_to_root
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

In tdp_mmu_iter_cond_resched there is a call to tdp_iter_start which
causes the iterator to continue its walk over the paging structure from
the root. This is needed after a yield as paging structure could have
been freed in the interim.

The tdp_iter_start call is not very clear and something of a hack. It
requires exposing tdp_iter fields not used elsewhere in tdp_mmu.c and
the effect is not obvious from the function name. Factor a more aptly
named function out of tdp_iter_start and call it from
tdp_mmu_iter_cond_resched and tdp_iter_start.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 24 +++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_iter.h |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c  |  4 +---
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index e5f148106e20..f7f94ea65243 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -20,6 +20,21 @@ static gfn_t round_gfn_for_level(gfn_t gfn, int level)
 	return gfn & -KVM_PAGES_PER_HPAGE(level);
 }
 
+/*
+ * Return the TDP iterator to the root PT and allow it to continue its
+ * traversal over the paging structure from there.
+ */
+void tdp_iter_restart(struct tdp_iter *iter)
+{
+	iter->yielded_gfn = iter->next_last_level_gfn;
+	iter->level = iter->root_level;
+
+	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+
+	iter->valid = true;
+}
+
 /*
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
@@ -31,16 +46,11 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
 	iter->next_last_level_gfn = next_last_level_gfn;
-	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->root_level = root_level;
 	iter->min_level = min_level;
-	iter->level = root_level;
-	iter->pt_path[iter->level - 1] = (tdp_ptep_t)root_pt;
+	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root_pt;
 
-	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
-	tdp_iter_refresh_sptep(iter);
-
-	iter->valid = true;
+	tdp_iter_restart(iter);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 4cc177d75c4a..8eb424d17c91 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -63,5 +63,6 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
+void tdp_iter_restart(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 946da74e069c..38b6b6936171 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -664,9 +664,7 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
 
-		tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
-			       iter->root_level, iter->min_level,
-			       iter->next_last_level_gfn);
+		tdp_iter_restart(iter);
 
 		return true;
 	}
-- 
2.31.0.rc2.261.g7f71774620-goog

