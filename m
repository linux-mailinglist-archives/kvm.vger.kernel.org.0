Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A8C37ACE4
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhEKRRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhEKRRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:31 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D3C061761
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:24 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d16-20020ac811900000b02901bbebf64663so13419912qtj.14
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vif4ChP6To9MWPr0GWQdazmHQ6h3mcBFCGbXkm6wl94=;
        b=P/9QDdCt1kHWngOw1na6Leu2JD7lekSdtGS7VAKUvXhmzY9JyF+b20NH7WSINqjtY9
         TVgyzyuMtSqoZuS2N0QU8d8wK1wW+eRtmwMPCQPR6cRllkjzF2UAXY/EkKKXbzxMYf6Q
         yqzL9wOyPj6AoF5thN1a/FveVoDQIAFnA6kkUED7+aZvNwn++Yv5Kzp0qCAli/OFoMN/
         Fj5IaZKVYkrTwW5/SVayGF5zZDZXIecK89NpPRjEui1GpmU/BionmPZyNqcH1t9dAS2d
         46FzS8hsuleBN/9yoFR+8OotcHAR04y4AMJoI3pRyzNOy9qkgxtJqzjTqGxfzf2tRwc/
         AkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vif4ChP6To9MWPr0GWQdazmHQ6h3mcBFCGbXkm6wl94=;
        b=mCM+K3GqcRS2niFJH9XEqGnn4XaGgKbMzZmw1NM/jSQ6VcFzDNB8piEeqHW4D3hN+u
         R2LkBeJ6jXXEHIiz7GYogGwmzIATuiD1HcbJZjReL/Jj2tx0QL4neM4SrG8NTDzbeyM6
         sX8K03DIuIb/RHzYd2qSMpMfxzcjsfRpS5XLQ1xeeMSbR/cI7G/c/yqAgFjYiuQPpO2P
         3rjkEbLihVAcODdCSbC/YwwrEinFa718B+8K1M7VvY44tuIIucPpvKcYefD09RVago9z
         ajJkBp84LYaSU6lio1p9r4Xlc3G4x/sK83oUtiLY7kfSqNlzwDnj1RSbujkeqnyN5vHG
         laEw==
X-Gm-Message-State: AOAM531+O+lSjHHXKRr8YWwym2pMkqcfOz55sSitsnZ9WKzQ61Jlap/M
        LyOM5nzbVWr1UbYvFts26MowXXMlhOq4
X-Google-Smtp-Source: ABdhPJwF0MHjjGkQgiXGGKjAOLsCjfCFkwMayfPENgVt1BXQ00ZLJTllQOHuDP2+BN97CyKPmMQUaMzi9FMk
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:ad4:4dc8:: with SMTP id
 cw8mr29820482qvb.16.1620753383411; Tue, 11 May 2021 10:16:23 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:06 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 3/7] KVM: mmu: Refactor memslot copy
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

Factor out copying kvm_memslots from allocating the memory for new ones
in preparation for adding a new lock to protect the arch-specific fields
of the memslots.

No functional change intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 virt/kvm/kvm_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..9e106742b388 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1306,6 +1306,18 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	return old_memslots;
 }
 
+static size_t kvm_memslots_size(int slots)
+{
+	return sizeof(struct kvm_memslots) +
+	       (sizeof(struct kvm_memory_slot) * slots);
+}
+
+static void kvm_copy_memslots(struct kvm_memslots *from,
+			      struct kvm_memslots *to)
+{
+	memcpy(to, from, kvm_memslots_size(from->used_slots));
+}
+
 /*
  * Note, at a minimum, the current number of used slots must be allocated, even
  * when deleting a memslot, as we need a complete duplicate of the memslots for
@@ -1315,19 +1327,16 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 					     enum kvm_mr_change change)
 {
 	struct kvm_memslots *slots;
-	size_t old_size, new_size;
-
-	old_size = sizeof(struct kvm_memslots) +
-		   (sizeof(struct kvm_memory_slot) * old->used_slots);
+	size_t new_size;
 
 	if (change == KVM_MR_CREATE)
-		new_size = old_size + sizeof(struct kvm_memory_slot);
+		new_size = kvm_memslots_size(old->used_slots + 1);
 	else
-		new_size = old_size;
+		new_size = kvm_memslots_size(old->used_slots);
 
 	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
 	if (likely(slots))
-		memcpy(slots, old, old_size);
+		kvm_copy_memslots(old, slots);
 
 	return slots;
 }
-- 
2.31.1.607.g51e8a6a459-goog

