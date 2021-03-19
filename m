Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245C434291C
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 00:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhCSXU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 19:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCSXUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 19:20:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350FDC061761
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:14 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u17so53829183ybi.10
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uevn87Pv71vAHsLA8sEmHJbxFzL55foju3lqBq/Tdz0=;
        b=pIfaTxKK9qfTJHolePPDEnkfaVQ2UiK7abdoXt2KyIbgfIEyPpeTraTeT7elGt3eLN
         3xpHkNwtNfS00VbpOiEYo3zjsx+3+3GKMiU6bXvQrvB1Vjif53jAySjo4q696UVb8UtQ
         bkCABuJHWahi+EsYuJxXDG/MZWEgN4hGqadJtQ4w/eapMnBJ+v0MS1/Xc2i4YCZm7MUw
         Y/FGK3PwSDTmUogUH8hxcW3iL40fo/CFpKP7kbKTNco7ZsOKEjhERxQ7tyu5uzGXLQaZ
         NAu5l1tyTyRIzb44xTvlTIFizInm2maD+wRkb31oyTmS/y8ro/gO6OgcxiIbsgak90Or
         J0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uevn87Pv71vAHsLA8sEmHJbxFzL55foju3lqBq/Tdz0=;
        b=W0O8LM9tb6A6wiUVfQzF1GZpid2a2mYiukif4hX7ZCuh+ZFlJK9cmmwhkPh7H1wovv
         69EBS69t8+SaQTfK98VBSkNyRkzoAKq16XSi28Kv1r9DMdV6l/ulUXmCsqCRL7HEB0Rg
         ay/dlWlHHlsKso73Kf475jFoNDEqOArnENwUKjYKT/VW6XtRgyaUKBgcmDTqTSL7Uitg
         wgdnBZjOuogzZb2lXSigYYTN7+l4XvfN4kzCsEuT/6nDDIFEIYZcgJo6WQ2/vwvOmfAZ
         OOWDeKO43cnLIysUKO7fFzpUvC9+9nGgsFyFWycbWeMuhJ/7HAml9DrntDKvAvZ3ler8
         ZgPA==
X-Gm-Message-State: AOAM530dmZVBeCMF74guowgak/wrZkMnAEhyRlYPwR948Bb+EhDz8dXy
        giKSVuk2vfT2KXG3JX00WdtLJ28ySJs=
X-Google-Smtp-Source: ABdhPJyh2/iZ1TrtSEuUbyTus519ry6wuAyLAZMiJUykWEfMw7axv6kMUwgAm1cT9PmRWK2yOPSizBgqSZo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:115a:eb6e:42f6:f9d5])
 (user=seanjc job=sendgmr) by 2002:a25:880c:: with SMTP id c12mr9709753ybl.399.1616196013487;
 Fri, 19 Mar 2021 16:20:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 19 Mar 2021 16:20:05 -0700
In-Reply-To: <20210319232006.3468382-1-seanjc@google.com>
Message-Id: <20210319232006.3468382-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210319232006.3468382-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Ensure TLBs are flushed when yielding
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

Note, kvm_tdp_mmu_zap_gfn_range() now intentionally overwrites it local
"flush" with the result to avoid redundant flushes.  zap_gfn_range()
preserves and return the incoming "flush", unless of course the flush was
performed prior to yielding and no new flush was triggered.

Fixes: 1af4a96025b3 ("KVM: x86/mmu: Yield in TDU MMU iter even if no SPTES changed")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
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
2.31.0.rc2.261.g7f71774620-goog

