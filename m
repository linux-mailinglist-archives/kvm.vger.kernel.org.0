Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7FD352417
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhDAXi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbhDAXiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:21 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6406C06178C
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:19 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e10so4275821qvr.17
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x7Mvbj3iAstsLSOHB4o6ZE5LRtLU1ZJPyMZ93FFvwYE=;
        b=AiL7v12vhE9FQqqdQYzgzWFxSeNqmXOgD7oGXV9+9TOtuBXgU2cIhrQ8XWf/zPm/8P
         OMH6rqACuPgVHLvGhqSCpXzezfbTFzkCNpIqoQcecmJC/JTsrPJ4/4gmgrAvTyzkLH39
         hlQPXGY5c3ZgkLCXcIvHnFvUwJk+rFVl+xTDoJDSeKdNbNMPxWkHnbDHK1kvzVjq7HCo
         tk+Ll1M+BAzU9t7JunIwn1wwCmFVUpvFS910ieU4LhuVTR7fLOsC/hGn53qB7wZyOL8A
         DLUR+LZwDx0BVqkN0zkxjFnyaiTio/1+ke9fnfFWFjE8J2pNns2V2U0JNEwd5MKlzGi6
         z9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x7Mvbj3iAstsLSOHB4o6ZE5LRtLU1ZJPyMZ93FFvwYE=;
        b=IsZOlckMAr+qSj3y1buJBYQorHuFBHkvrn8yCMwFgX9snDE0CEu613I82cAFckM2D4
         1eXgOpaKVGLJDuA/lvLdnO4CvXoNWag3OF9p7y/OdfjEIVLGYeEr+VJZRO7pi7r4+775
         /oGvj85kfd+oCVw0n4eAtwytABe8fNPmA7EBZ0EouWtK/PY1ba3WJno4P6u0a2GLQAk/
         g79O69lbPh2hncYHdPMPzHeCmfjiybRu8BzmnHgoj0krF/8kDqxkwKPah4VW/yqV0LR/
         ANkhjt2oyltI0axVIfSbSof5MLjudnjRp3LMQtSEav4lwkECBC3kW9iUq0Tsv4kTkhQ8
         JXXQ==
X-Gm-Message-State: AOAM532YbabBBkvsYxryZWxA6thMv+Mc6D+K0AqI5r7mlv2xZLrY4V4v
        /5eRCWvNBsYMEksij7KNZRE4jrTFCBsL
X-Google-Smtp-Source: ABdhPJz1/6IkY7EkLvN8g6YPULn4xPOH++QPoiTvtYX5/4Pi2+H9UzmVvpaj30ZPesn7sxfj0HRsiIHgjxze
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:ad4:5614:: with SMTP id
 ca20mr10393824qvb.37.1617320299115; Thu, 01 Apr 2021 16:38:19 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:33 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-11-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 10/13] KVM: x86/mmu: Allow zapping collapsible SPTEs to use
 MMU read lock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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

To speed the process of disabling dirty logging, change the TDP MMU
function which zaps collapsible SPTEs to run under the MMU read lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 ++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c | 17 +++++++++++++----
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d03a7a8b7ea2..5939813e3043 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5612,13 +5612,19 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
 
-	if (is_tdp_mmu_enabled(kvm))
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
-
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-
 	write_unlock(&kvm->mmu_lock);
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		flush = false;
+
+		read_lock(&kvm->mmu_lock);
+		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
+		if (flush)
+			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		read_unlock(&kvm->mmu_lock);
+	}
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6917403484ce..0e6ffa04e5e1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1323,7 +1323,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
 			flush = false;
 			continue;
 		}
@@ -1338,8 +1339,14 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 							    pfn, PG_LEVEL_NUM))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
-
+		if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 		flush = true;
 	}
 
@@ -1358,7 +1365,9 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
 
 	return flush;
-- 
2.31.0.208.g409f899ff0-goog

