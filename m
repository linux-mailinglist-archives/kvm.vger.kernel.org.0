Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57CF2F3836
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406266AbhALSMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406171AbhALSMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:37 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA7CC061342
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id t16so1819847pfh.22
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KUOgmZwIC4q3950YAhNBlDyIxwgFqBqj60bM3H+2xtM=;
        b=Xz1vVSzHm5BnPtQ2DJVfdq/sJMiagonKCEkxyLa6fSeikTA91iBU6KGl4a5Xtf7ah8
         3sq2YwGuVfsR+i1liuuLvLOlgRJAlf1IopQnYrTA9NSRCnpfl3hJ3WS16mA+5AJDqiVT
         WK45OzJHZ+qe/zaxSFPGULbz2PNiiiI90NMzKjsvMJAxEd54bCVPFkK7GQ40Y6CZjsqW
         9PJ+CEwciNpOA4xYgSlmg+xmtOyarBPr0S4jR6cTqB+SGWrFJp/BWv41ZK4VyRltnBgH
         l746/djdGR0WI73HVQPo4RNp97EobJdYKnPBPj5NLjevBuTA9NROTtrd3LWAsF0pj8gk
         G9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KUOgmZwIC4q3950YAhNBlDyIxwgFqBqj60bM3H+2xtM=;
        b=GWExHeP5+ps/DlOfru8HQXUyTFrcdm2BrEwgMYLN54HvtKmuZA+veQ5RGWzDUF07+D
         /Pqdvy2Xq3UqMmx0LoWI0JRh4wS77z11fzY/EmmaiHbs8zHF2W5L0MFqHB3WrdeRNoDv
         tOdbv3zj2SHxX0E9Qv61Zjou9rU8shKhr/I/4AMFVKBeN83qtAnAnEjdaCZtJE4RYtvr
         6MUmheTVvRZMwtagZEbqWQEe/aEDwBoeRg1YYXfXwEM3QSxk2mCtCteio9crwweS6Y/N
         XhpI0HL1HbsWMfLJ5cOn+rwvwhksyTMge8H5LsBtbqPoir/Xclc3/yHvXlNmjdBlLecX
         xrJw==
X-Gm-Message-State: AOAM531ITlU8uYQ83hnf2nUD5QDxmc8E/jg5sSfcNiOXPLo1c7GGaeDo
        mA2dJjXLBdDTQ20grxllp7DJglplm2hV
X-Google-Smtp-Source: ABdhPJx7bl40gpvxBxKPrzmj9sNWpykE51nyXEQF+Lic8F/XxYhW4apaZpXou7KBKBZhY+O+oyGcv0lNMAiE
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a63:1c1d:: with SMTP id
 c29mr301844pgc.94.1610475079388; Tue, 12 Jan 2021 10:11:19 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:36 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-20-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
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

Add a lock to protect the data structures that track the page table
memory used by the TDP MMU. In order to handle multiple TDP MMU
operations in parallel, pages of PT memory must be added and removed
without the exclusive protection of the MMU lock. A new lock to protect
the list(s) of in-use pages will cause some serialization, but only on
non-leaf page table entries, so the lock is not expected to be very
contended.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 15 ++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++++++----
 2 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92d5340842c8..f8dccb27c722 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1034,6 +1034,21 @@ struct kvm_arch {
 	 * tdp_mmu_page set and a root_count of 0.
 	 */
 	struct list_head tdp_mmu_pages;
+
+	/*
+	 * Protects accesses to the following fields when the MMU lock is
+	 * not held exclusively:
+	 *  - tdp_mmu_pages (above)
+	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
+	 *    when they are part of tdp_mmu_pages (but not when they are part
+	 *    of the tdp_mmu_free_list or tdp_mmu_disconnected_list)
+	 *  - lpage_disallowed_mmu_pages
+	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
+	 *    by the TDP MMU
+	 *  May be acquired under the MMU lock in read mode or non-overlapping
+	 *  with the MMU lock.
+	 */
+	spinlock_t tdp_mmu_pages_lock;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8b61bdb391a0..264594947c3b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -33,6 +33,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
@@ -262,6 +263,58 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+/**
+ * tdp_mmu_link_page - Add a new page to the list of pages used by the TDP MMU
+ *
+ * @kvm: kvm instance
+ * @sp: the new page
+ * @atomic: This operation is not running under the exclusive use of the MMU
+ *	    lock and the operation must be atomic with respect to ther threads
+ *	    that might be adding or removing pages.
+ * @account_nx: This page replaces a NX large page and should be marked for
+ *		eventual reclaim.
+ */
+static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			      bool atomic, bool account_nx)
+{
+	if (atomic)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		kvm_mmu_lock_assert_held_exclusive(kvm);
+
+	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
+	if (account_nx)
+		account_huge_nx_page(kvm, sp);
+
+	if (atomic)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+}
+
+/**
+ * tdp_mmu_unlink_page - Remove page from the list of pages used by the TDP MMU
+ *
+ * @kvm: kvm instance
+ * @sp: the page to be removed
+ * @atomic: This operation is not running under the exclusive use of the MMU
+ *	    lock and the operation must be atomic with respect to ther threads
+ *	    that might be adding or removing pages.
+ */
+static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+				bool atomic)
+{
+	if (atomic)
+		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	else
+		kvm_mmu_lock_assert_held_exclusive(kvm);
+
+	list_del(&sp->link);
+	if (sp->lpage_disallowed)
+		unaccount_huge_nx_page(kvm, sp);
+
+	if (atomic)
+		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+}
+
 /**
  * handle_disconnected_tdp_mmu_page - handle a pt removed from the TDP structure
  *
@@ -285,10 +338,7 @@ static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	list_del(&sp->link);
-
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	tdp_mmu_unlink_page(kvm, sp, atomic);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		old_child_spte = READ_ONCE(*(pt + i));
@@ -719,15 +769,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
-			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
 			child_pt = sp->spt;
+
+			tdp_mmu_link_page(vcpu->kvm, sp, false,
+					  huge_page_disallowed &&
+					  req_level >= iter.level);
+
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
 			trace_kvm_mmu_get_page(sp, true);
-			if (huge_page_disallowed && req_level >= iter.level)
-				account_huge_nx_page(vcpu->kvm, sp);
-
 			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
 		}
 	}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

