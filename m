Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3857387E75
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351168AbhERRfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351146AbhERRfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 13:35:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41348C061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j19-20020a63fc130000b029020f623342e0so6803023pgi.10
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rAGxH7RBjxWI4eFtU4uy5sDnRTRUjNhxYK0eIVMGyVI=;
        b=cn9JrqjDkc1ruNg7PlqXWsUWgYudQBTGNMIOFUHAQXPJN5ofWlrtvcbSc+lhrBY5Hn
         GrowzrdOWmHfq2mco/UyT+uFkXSMGCKNk16WLuNzcVF1h/rP4i7bY7fGughzZedLMwuL
         qxFlWxwoEQGlmFnB9fWRKmYXLl/D7+LC5weN4zSg9zxCtQbAdFyNR6EbD6SXnlp+/uNV
         2E11ctl5Blh+RWIGm6W9EoO15M73VxHuvI0KUhG1bxI0PKSGRPm4mj/9AZIOWW+5X8CD
         Pbzu/7eyhAv3jkcZmjV1YxMbreaDFcS9609X60T/5HPAIlOvk47GYut7jH1zx9Lk73E3
         sYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rAGxH7RBjxWI4eFtU4uy5sDnRTRUjNhxYK0eIVMGyVI=;
        b=DCHvX93lTX/7LijWDbw9Xj8NsZuoPxLtDmyoLttYYOb7UExZbZtz9w6bZKTQR5W2OC
         aXCg0VijGnYsay86s+rwHgzx4wR7s4DndU3LQUPLTeDyTN8+waXVbphrp5Qaxud5hvCX
         /4HtOgPImUSbpT6JguYIP/2F5MlmDGOuIG1PRdCLmvj4q2D8O9RZDeXjezAJHmqCqzWd
         JnEayYjDPq7YCh5Y1xtXTy1mDa7JUs9YVWJtKZESLxKX/XkF0Le0GgZHZaGMjZGY8vke
         rHB/Ma5lJPy3a0PfKRcH2iahLb32c3zNhgi5i0sPxsjoz0+y2a+vKKM31qWQJBDAPv96
         QPVw==
X-Gm-Message-State: AOAM532+RcCKnruf8K50mqHDDnuedjMYHjdBglVs5/sUmg+sbEVJm/cA
        /wAIfd80K5PeCjtFLjvtB/nxRPxCRpW/
X-Google-Smtp-Source: ABdhPJzeBb7mX5Kx/y5D5/8VZv+eJfHZgnxz6Jy80W4SoseeeAPat3e1fuqNy8lhIk/yX49X6dKG2vg5LrWo
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2715:2de:868e:9db7])
 (user=bgardon job=sendgmr) by 2002:a17:902:ea10:b029:ef:d2:16c2 with SMTP id
 s16-20020a170902ea10b02900ef00d216c2mr5794298plg.9.1621359261715; Tue, 18 May
 2021 10:34:21 -0700 (PDT)
Date:   Tue, 18 May 2021 10:34:09 -0700
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Message-Id: <20210518173414.450044-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210518173414.450044-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v5 2/7] KVM: x86/mmu: Factor out allocating memslot rmap
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small refactor to facilitate allocating rmaps for all memslots at once.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11908beae58b..4b3d53c5fc76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10920,10 +10920,31 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
+static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
+			      unsigned long npages)
+{
+	const int sz = sizeof(*slot->arch.rmap[0]);
+	int i;
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		int level = i + 1;
+		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
+					  slot->base_gfn, level) + 1;
+
+		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
+		if (!slot->arch.rmap[i]) {
+			memslot_rmap_free(slot);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
-	int i;
+	int i, r;
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
@@ -10932,7 +10953,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+	r = memslot_rmap_alloc(slot, npages);
+	if (r)
+		return r;
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
 		unsigned long ugfn;
 		int lpages;
@@ -10941,14 +10966,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
-		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-				 GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.rmap[i])
-			goto out_free;
-		if (i == 0)
-			continue;
-
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
-- 
2.31.1.751.gd2f1c929bd-goog

