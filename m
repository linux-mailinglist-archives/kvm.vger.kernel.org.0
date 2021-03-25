Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C226349AC5
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 21:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCYUBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 16:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhCYUB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 16:01:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FC3C06175F
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o129so7225476ybg.23
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bMcMos9BxmswAdcj9I5H8fXsWRSXs/EVwTiHiGHOsOY=;
        b=PFM/CnLJfGE9dt84Qkxqh66Uem2KZM0cP8UlgtzjuZzda5Wsr8aIN/ldVweNiq9uD8
         qqnt6Qr3sT7znhbTP/skOFI4yeCtfdoe6jA8/zHhIJtcg2cZVkTf3bGz8r7T4glF2rWB
         3nZjbgVUufzgyX6RRI4Y8DpoN1Ao9VMRbdzRLO+8OxW2OtTBahxr2ogVs+pmGRo1Xo2G
         aOPV1+WCUSGxSewOLEyroXdq2n9t3BVmnPZYEXn58IgWLGfMXEtOOpiIEGHbmJdl/rfn
         sLBhweTJaxZmUE0ASGME+gv39+WJsL0GrHdKB5SRgoLmesMHqlnjy7LyqPiWqPalp8pL
         zEHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bMcMos9BxmswAdcj9I5H8fXsWRSXs/EVwTiHiGHOsOY=;
        b=TQMG7krBSu542ayr1zyO/Big3FQb8+dZJO64Wyi2ik/Yt40feqZtMsosWkhqXnbZ72
         tPP88s5KFDbTrvzBtLc7dKRa9JczHLg8AwSpE4tP5EZx+w2DGrS+12soIFCgRnZcXBCN
         HlnjWgcjRcfSLtiPMGQriBS7Is5PoSm/cQkki8txOYTVSy1g8eYDW6of6J9al9PxuHvw
         WFucuFTk1DFQ1GJQ13Nrpq+BsP6/qBta4XRw/h4NmiC/4Qq02EaGQoXeEIcsQ12h9YSx
         nqGpTcRazU6hedfYRyuQJb0ndl/5Nnvk1a0tArwBPHsfff9bWmXtLujc40X6UoxEjLKX
         4cXw==
X-Gm-Message-State: AOAM532qxI++k4vhRFNkzntlt9M5SnfYd4LHpG7uaP2W3R0MANPRBPji
        qQCqSx3nBeZZKQMI5aIDf6HXp04j/oo=
X-Google-Smtp-Source: ABdhPJwGQWNqRREIxqh6uPBp5V55wXs3SH7jUkm8iK1STOk7n7m/ZX9Hs1cFqPdAv1zSYhlzook0fe3o6oQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:4444:: with SMTP id r65mr15099364yba.84.1616702485021;
 Thu, 25 Mar 2021 13:01:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 13:01:17 -0700
In-Reply-To: <20210325200119.1359384-1-seanjc@google.com>
Message-Id: <20210325200119.1359384-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210325200119.1359384-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2 1/3] KVM: x86/mmu: Ensure TLBs are flushed when yielding
 during GFN range zap
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When flushing a range of GFNs across multiple roots, ensure any pending
flush from a previous root is honored before yielding while walking the
tables of the current root.

Note, kvm_tdp_mmu_zap_gfn_range() now intentionally overwrites its local
"flush" with the result to avoid redundant flushes.  zap_gfn_range()
preserves and return the incoming "flush", unless of course the flush was
performed prior to yielding and no new flush was triggered.

Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
Cc: stable@vger.kernel.org
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f0c99fa04ef2..6cf08c3c537f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -86,7 +86,7 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -99,7 +99,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -664,20 +664,21 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
- * operation can cause a soft lockup.
+ * operation can cause a soft lockup.  Note, in some use cases a flush may be
+ * required by prior actions.  Ensure the pending flush is performed prior to
+ * yielding.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield)
+			  gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
 	struct tdp_iter iter;
-	bool flush_needed = false;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
-			flush_needed = false;
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -695,11 +696,11 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush_needed = true;
+		flush = true;
 	}
 
 	rcu_read_unlock();
-	return flush_needed;
+	return flush;
 }
 
 /*
@@ -714,7 +715,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	bool flush = false;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush |= zap_gfn_range(kvm, root, start, end, true);
+		flush = zap_gfn_range(kvm, root, start, end, true, flush);
 
 	return flush;
 }
@@ -931,7 +932,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-- 
2.31.0.291.g576ba9dcdaf-goog

