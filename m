Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9B3BFBCC
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfIZXSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:50 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36010 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfIZXSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:49 -0400
Received: by mail-pg1-f201.google.com with SMTP id h36so2354599pgb.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FlkPCmyBxMafc7xPNdBrX6KkTlj7nxb6S27SSYwjwEc=;
        b=c+cGJoGgC2dOXIcRCQFrjIuxggFV83guIJW6qgAo97v92wA+CvCmDAs5eDSnZuGEKk
         k15C90v18WhD3T0baKjZ77x35RsqmWx3F9zLFv4AZn/435i44OnvnZSNqP5uYF6QXqNb
         myLfoxD4QK7krQhhL5Nq4ixBLlkFfh+fNscq/w5RAavmJ0KLBB+MAEMb8YM7u64vhyfN
         0QvyyAVUfTjqk7zxfFymmbXnk4phyg55UFVghVzTSnPUYiS5MEn4X1jd9JIpEDsogAn7
         HUN1GyQinfK5yR0lGfsrZRgl7FvAWhz9lOuJxjovtEpepfVJgGod9hLMtSP499fD9HHi
         +Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FlkPCmyBxMafc7xPNdBrX6KkTlj7nxb6S27SSYwjwEc=;
        b=nZHyvndvgB9dpP/xxGk3j2Og37N99ZLHp+xCxiKFpNzayRICu7h8CvXgHjFJ9ypV2F
         y1ouSHwzvtvpNaqXhFtw8nYUUwnHjIXJVEV4NJqqPlDg3OJ+wCi1EGeIm0dWd5FQ1NDU
         IXy7XXaz2hfcmfQs5JUWip2oYCw9sZwocPLJCz3rc9QK73zgNSf4OzmHCWP4Cela7umO
         2Y/TEQBOVwt/7h1Td63C4Hy9g023hrl/jRw9tYUsUOWzQ4pVlzMxJGjYqopXT/8dimoI
         Yu1oIiRdyZs2Sv23H23B/pOqR+E9hXnH71iu8dwYSfrd+eZjhk96Bquj2zCS2+ihFE1y
         uoGA==
X-Gm-Message-State: APjAAAVQpQd3aWyoLyjs9M6A8dpFCOi0EClnuwF0+5OaSB3g3kPtYuKI
        Rs0+t4UBn7d5vtD8UhLy5f/rLI4yz1C+fm6dRivY3WK4M+mk9+J3i675xmdlXNOVa4U81YN4RS4
        96mitPl/nscBFvvUQGZ293l3CmOj91ZnQLcAZzXKdX8xCgx8LCuu6/L654Py+
X-Google-Smtp-Source: APXvYqzRlf0AIBCSNJ8RIZfGoFaBxuKo3SRU4e5x+Rk1ompUil1TXLdH5M09pV6dQaK0yGMUYQNe/QK+rQpb
X-Received: by 2002:a63:2808:: with SMTP id o8mr6057944pgo.118.1569539928434;
 Thu, 26 Sep 2019 16:18:48 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:05 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-10-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 09/28] kvm: mmu: Free direct MMU page table memory in an
 RCU callback
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The direct walk iterator, introduced in a later commit in this series,
uses RCU to ensure that its concurrent access to paging structure memory
is safe. This requires that page table memory not be freed until an RCU
grace period has elapsed. In order to keep the threads removing page
table memory from the paging structure from blocking, free the disonnected
page table memory in an RCU callback.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 788edbda02f69..9fe57ef7baa29 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1685,6 +1685,21 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 	return flush;
 }
 
+/*
+ * This function is called through call_rcu in order to free direct page table
+ * memory safely, with resepct to other KVM MMU threads that might be operating
+ * on it. By only accessing direct page table memory in a RCU read critical
+ * section, and freeing it after a grace period, lockless access to that memory
+ * won't use it after it is freed.
+ */
+static void free_pt_rcu_callback(struct rcu_head *rp)
+{
+	struct page *req = container_of(rp, struct page, rcu_head);
+	u64 *disconnected_pt = page_address(req);
+
+	free_page((unsigned long)disconnected_pt);
+}
+
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 			       u64 old_pte, u64 new_pte, int level);
 
@@ -1720,6 +1735,11 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
  * Given a pointer to a page table that has been removed from the paging
  * structure and its level, recursively free child page tables and mark their
  * entries as disconnected.
+ *
+ * RCU dereferences are not necessary to protect access to the disconnected
+ * page table or its children because it has been atomically removed from the
+ * root of the paging structure, so no other thread will be trying to free the
+ * memory.
  */
 static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level)
@@ -1727,6 +1747,7 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 	int i;
 	gfn_t gfn = pt_base_gfn;
 	u64 *pt = pfn_to_kaddr(pfn);
+	struct page *page;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		/*
@@ -1739,7 +1760,12 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 		gfn += KVM_PAGES_PER_HPAGE(level);
 	}
 
-	free_page((unsigned long)pt);
+	/*
+	 * Free the pt page in an RCU callback, once it's safe to do
+	 * so.
+	 */
+	page = pfn_to_page(pfn);
+	call_rcu(&page->rcu_head, free_pt_rcu_callback);
 }
 
 /**
-- 
2.23.0.444.g18eeb5a265-goog

