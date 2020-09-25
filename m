Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A29127934B
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgIYVXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729196AbgIYVXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:35 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAF6C0613DC
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:32 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id r184so3018175qka.21
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=uYos/4sZVdvJsXvHVNRoyrmDbfs5jzElVh9jP80i41w=;
        b=G9grlhxj+HtyqbvctWFd6D2comHM/DsEHcFELG3q5sdigAtI3zUKLWOn6EPcnzKlY+
         MbJucJB/NCCXzNuOGISYHjVQ29ELJr9K0EKdt67k3mhsyHJzgLR08VirBiYVx1lJhWOT
         ssVD0KX1jNo6gi+nQnbg8x6FMJvoA+/ZG6l3Sij0i2b8RtpdMkAbojY7PCHaSHqWqZCS
         ipO8vM7vlh1K6W/QCQF9+GtqWWoSv0XV0aNNksMFW19m1gWNbCo9gsze4SVQ2XpQwcNa
         KbnMKaOtO8yBkvwjMa968daGRcJqhlH1fR+K+au1d4f2uVTo97iUYbiAuUHz4eXXgLo2
         sxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uYos/4sZVdvJsXvHVNRoyrmDbfs5jzElVh9jP80i41w=;
        b=rYGLi/oU8vyp7fZnZWtoTCHxlXOrRafzjS0q+JS2RcdnhBremgkYBOWnzQULxjUJOR
         dUsNHwjH5H89Swd1lGPmsZIn4I+JQtXROTHq3UlRYCiCd4CoUiFlpJH1MT4MtG+41AFu
         vNgMorwIdstOExobxLdir1aZxC3ESwlChR/CL9rlUVuPPPar4nSJzHkQsXEOYWohOqrd
         qnvwLPbTBD3A5sj2hecQjq/BqiS6ex/95TXjB0+Lidk9Psy3vW013Dwvr3pAHmDyoqoy
         q+7TjiptHvOdeduoXzuemlngnKawMd2h3Kc7As8RYwAMjhRJ6khiKiXZ8WHUP2o3WxJJ
         /8hw==
X-Gm-Message-State: AOAM532JRg+x2ZiRA/gXjlrTGBnq4euDBXjU15dr4qHsUg2V1kFF+RIN
        pDG0c+8W1ghBX5BAHBtanGZaWnv9d43J
X-Google-Smtp-Source: ABdhPJxtFOw51sQanwNBWDZItA0R4Pb9VRTruYEcKh3jRqvwaWSYsTKOwn6fiXFmj2WGPoYa9ilpwbnw0YrQ
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:4594:: with SMTP id
 x20mr716275qvu.4.1601069011627; Fri, 25 Sep 2020 14:23:31 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:53 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-14-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 13/22] kvm: mmu: Support invalidate range MMU notifier for TDP MMU
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

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
hooks to handle the invalidate range family of MMU notifiers.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 3 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52d661a758585..0ddfdab942554 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1884,7 +1884,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	int r;
+
+	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
+
+	return r;
 }
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 557e780bdf9f9..1cea58db78a13 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -60,7 +60,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end);
+			  gfn_t start, gfn_t end, bool can_yield);
 
 static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -73,7 +73,7 @@ static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn);
+	zap_gfn_range(kvm, root, 0, max_gfn, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -361,9 +361,14 @@ static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ * If can_yield is true, will release the MMU lock and reschedule if the
+ * scheduler needs the CPU or there is contention on the MMU lock. If this
+ * function cannot yield, it will not release the MMU lock or reschedule and
+ * the caller must ensure it does not supply too large a GFN range, or the
+ * operation can cause a soft lockup.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end)
+			  gfn_t start, gfn_t end, bool can_yield)
 {
 	struct tdp_iter iter;
 	bool flush_needed = false;
@@ -387,7 +392,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte, 0,
 				    iter.level);
 
-		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+		if (can_yield)
+			flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+		else
+			flush_needed = true;
 	}
 	return flush_needed;
 }
@@ -410,7 +418,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 		 */
 		get_tdp_mmu_root(kvm, root);
 
-		flush = zap_gfn_range(kvm, root, start, end) || flush;
+		flush = zap_gfn_range(kvm, root, start, end, true) || flush;
 
 		put_tdp_mmu_root(kvm, root);
 	}
@@ -551,3 +559,65 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 
 	return ret;
 }
+
+static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
+		unsigned long end, unsigned long data,
+		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
+			       struct kvm_mmu_page *root, gfn_t start,
+			       gfn_t end, unsigned long data))
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	struct kvm_mmu_page *root;
+	int ret = 0;
+	int as_id;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		as_id = kvm_mmu_page_as_id(root);
+		slots = __kvm_memslots(kvm, as_id);
+		kvm_for_each_memslot(memslot, slots) {
+			unsigned long hva_start, hva_end;
+			gfn_t gfn_start, gfn_end;
+
+			hva_start = max(start, memslot->userspace_addr);
+			hva_end = min(end, memslot->userspace_addr +
+				      (memslot->npages << PAGE_SHIFT));
+			if (hva_start >= hva_end)
+				continue;
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
+			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
+
+			ret |= handler(kvm, memslot, root, gfn_start,
+				       gfn_end, data);
+		}
+
+		put_tdp_mmu_root(kvm, root);
+	}
+
+	return ret;
+}
+
+static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
+				     struct kvm_memory_slot *slot,
+				     struct kvm_mmu_page *root, gfn_t start,
+				     gfn_t end, unsigned long unused)
+{
+	return zap_gfn_range(kvm, root, start, end, false);
+}
+
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
+					    zap_gfn_range_hva_wrapper);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index abf23dc0ab7ad..ce804a97bfa1d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -18,4 +18,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
 			   int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
 			   bool lpage_disallowed);
+
+int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

