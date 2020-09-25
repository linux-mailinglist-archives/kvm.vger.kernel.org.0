Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6152279358
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgIYVYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729018AbgIYVXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5EAC0613D7
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y7so284011pjt.1
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ef4AIuZeb4s5cy019ZEPLkLaZqhCMC47Todu9wHoSxM=;
        b=FojbvIec/7pxWbOTa2bolog20/DFD50uqk2zpDc237fvki3tjTgMOPwmWU0ogx9E8u
         dJnYbU93k/nYnLjDSJuApQrffWNitNCBap0NRMMZ8ZzO6xLd9ReQIuQjMbu7f6E5BeUJ
         +Cdd16WUgsWOqJHy4qTsBczm+ACXL0bi5LcdQm5m0KExZmFEIPibPw2/qBEtqmuGrIsk
         EUIHjjA+H2DIvXYujIV4mMxJjfVWbDywL59qhl0YSos/Q8K/utJJfINqwWV7zNM55upX
         9d4tFZPqgElsybxx9Snz/Pzoz8TkM5+me78i2YhE2AuyAAL+C4D3BJBpAbCRarbvJGjv
         bcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ef4AIuZeb4s5cy019ZEPLkLaZqhCMC47Todu9wHoSxM=;
        b=iUB0AfI5GbGnhXs6c68id80QVz5UGwR2Bo2g4MCvRYr2uoyaF3UPWPBhnb1O5/9tqc
         pVrlzCQ+AeaH3SwW7c66q/AUbdePqdH1gIVSgOUthiAvD2UNJCW7ycr/vOG0Xt+Y8eGs
         5RciZ5TT3701dFuXUN8p8NSj6xb87Id9NNhP7G4GSpDYJ9NlYEH1cxzUXPAzryFhiF52
         vuQB7eBfjbEPcPiTEJGqHORT+n4FlHGAtQTG7Uf/hCLmGBjvmQ9FgnxcUEAP8A+dK5jH
         1XBSNkY2b17y782dxue3oq385E3bdeq/kMosCXY1JC2RLrRo25dMsU6hsJfZZxX9KLdC
         ceoQ==
X-Gm-Message-State: AOAM531JwtnrS4xngCuP44T7oko3v6WeCKQhARe0HkgGTVevXpR8uiAE
        B4VDcCZrm/ExmJOoHaqlTvIUBRBlr3jY
X-Google-Smtp-Source: ABdhPJxsYfhwAkNKqclJ88sk/OUcrg9MNbwQXHLfdFz7XI+Krkf1m/AZcFQ+krwqDaoc2peP3f5vtsok44uG
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:b713:b029:d2:6153:fb62 with SMTP
 id d19-20020a170902b713b02900d26153fb62mr1280963pls.28.1601069000829; Fri, 25
 Sep 2020 14:23:20 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:47 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-8-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 07/22] kvm: mmu: Support zapping SPTEs in the TDP MMU
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

Add functions to zap SPTEs to the TDP MMU. These are needed to tear down
TDP MMU roots properly and implement other MMU functions which require
tearing down mappings. Future patches will add functions to populate the
page tables, but as for this patch there will not be any work for these
functions to do.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c      |  15 +++++
 arch/x86/kvm/mmu/tdp_iter.c |  17 ++++++
 arch/x86/kvm/mmu/tdp_iter.h |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c  | 106 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h  |   2 +
 5 files changed, 141 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f09081f9137b0..7a17cca19b0c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5852,6 +5852,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_reload_remote_mmus(kvm);
 
 	kvm_zap_obsolete_pages(kvm);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -5892,6 +5896,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
+	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -5911,6 +5916,12 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
+	if (kvm->arch.tdp_mmu_enabled) {
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+	}
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -6077,6 +6088,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index ee90d62d2a9b1..6c1a38429c81a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -161,3 +161,20 @@ void tdp_iter_next(struct tdp_iter *iter)
 		done = try_step_side(iter);
 	}
 }
+
+/*
+ * Restart the walk over the paging structure from the root, starting from the
+ * highest gfn the iterator had previously reached. Assumes that the entire
+ * paging structure, except the root page, may have been completely torn down
+ * and rebuilt.
+ */
+void tdp_iter_refresh_walk(struct tdp_iter *iter)
+{
+	gfn_t goal_gfn = iter->goal_gfn;
+
+	if (iter->gfn > goal_gfn)
+		goal_gfn = iter->gfn;
+
+	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
+		       iter->root_level, goal_gfn);
+}
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b102109778eac..34da3bdada436 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -49,5 +49,6 @@ u64 *spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    gfn_t goal_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
+void tdp_iter_refresh_walk(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 653507773b42c..d96fc182c8497 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,6 +2,7 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "tdp_iter.h"
 #include "tdp_mmu.h"
 
 static bool __read_mostly tdp_mmu_enabled = true;
@@ -57,8 +58,13 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 	return root->tdp_mmu_page;
 }
 
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end);
+
 static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	WARN_ON(root->root_count);
@@ -66,6 +72,8 @@ static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
+	zap_gfn_range(kvm, root, 0, max_gfn);
+
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
 }
@@ -193,6 +201,11 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level);
 
+static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -294,3 +307,96 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		free_page((unsigned long)pt);
 	}
 }
+
+#define for_each_tdp_pte_root(_iter, _root, _start, _end) \
+	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+
+/*
+ * If the MMU lock is contended or this thread needs to yield, flushes
+ * the TLBs, releases, the MMU lock, yields, reacquires the MMU lock,
+ * restarts the tdp_iter's walk from the root, and returns true.
+ * If no yield is needed, returns false.
+ */
+static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		kvm_flush_remote_tlbs(kvm);
+		cond_resched_lock(&kvm->mmu_lock);
+		tdp_iter_refresh_walk(iter);
+		return true;
+	} else {
+		return false;
+	}
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	bool flush_needed = false;
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If this is a non-last-level SPTE that covers a larger range
+		 * than should be zapped, continue, and zap the mappings at a
+		 * lower level.
+		 */
+		if ((iter.gfn < start ||
+		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		*iter.sptep = 0;
+		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte, 0,
+				    iter.level);
+
+		flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+	return flush_needed;
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_mmu_page *root;
+	bool flush = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		flush = zap_gfn_range(kvm, root, start, end) || flush;
+
+		put_tdp_mmu_root(kvm, root);
+	}
+
+	return flush;
+}
+
+void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+{
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+	bool flush;
+
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9274debffeaa1..cb86f9fe69017 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -12,4 +12,6 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
 
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

