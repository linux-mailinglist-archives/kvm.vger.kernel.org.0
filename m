Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB81975331D
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjGNHXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbjGNHXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:23:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3DB30E9;
        Fri, 14 Jul 2023 00:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319387; x=1720855387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=IHJc+z0SmVKAVyBpoFP/KQLvug9IHbTWEWnO52mZneQ=;
  b=RiGjdZwLFAAm8zo7LVTJL49npMPpVeiEDvf0i3OfD51MLdJsj0nBpGCF
   YXYu7530hu5ijYQE3WKwIHD3GQMAu9aZDcykRq9OxKqAEeB/Hw42Z+r2a
   WptAta0aBmfDVkKFCko2SdSFGEiYwUmYYteL4sAEII90wS5MQpGnjtlkX
   akaGsQ9gh4/wUshLHVawDzfL/oj9z6S41nTdNZ76SxovmRMxbEuoLF4pM
   A6oxUGRBtncmvA8b3Euiek5JLhEHHkVSAo4QAiyTH2jLTntqv7M2ermz0
   oCiMgf4uL7A5oHI1UOl+v3MkrWzCVhYbetfHRUTXKaOTqWB+bznOQC7X+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="345727983"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="345727983"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:23:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="896317519"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="896317519"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:23:04 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 12/12] KVM: x86/mmu: convert kvm_zap_gfn_range() to use shared mmu_lock in TDP MMU
Date:   Fri, 14 Jul 2023 14:56:31 +0800
Message-Id: <20230714065631.20869-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_zap_gfn_range() from holding mmu_lock for write to holding for
read in TDP MMU and allow zapping of non-leaf SPTEs of level <= 1G.
TLB flushes are executed/requested within tdp_mmu_zap_spte_atomic() guarded
by RCU lock.

GFN zap can be super slow if mmu_lock is held for write when there are
contentions. In worst cases, huge cpu cycles are spent on yielding GFN by
GFN, i.e. the loop of "check and flush tlb -> drop rcu lock ->
drop mmu_lock -> cpu_relax() -> take mmu_lock -> take rcu lock" are entered
for every GFN.
Contentions can either from concurrent zaps holding mmu_lock for write or
from tdp_mmu_map() holding mmu_lock for read.

After converting to hold mmu_lock for read, there will be less contentions
detected and retaking mmu_lock for read is also faster. There's no need to
flush TLB before dropping mmu_lock when there're contentions as SPTEs have
been zapped atomically and TLBs are flushed/flush requested immediately
within RCU lock.
In order to reduce TLB flush count, non-leaf SPTEs not greater than 1G
level are allowed to be zapped if their ranges are fully covered in the
gfn zap range.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 +++++++----
 arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  1 +
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7f52bbe013b3..1fa2a0a3fc9b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6310,15 +6310,19 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
+	if (flush)
+		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
+
 	if (tdp_mmu_enabled) {
+		write_unlock(&kvm->mmu_lock);
+		read_lock(&kvm->mmu_lock);
+
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+			kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start, gfn_end);
+		read_unlock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 	}
 
-	if (flush)
-		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
-
 	kvm_mmu_invalidate_end(kvm, 0, -1ul);
 
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..2ad18275b643 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -888,6 +888,56 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 	return flush;
 }
 
+static void zap_gfn_range_atomic(struct kvm *kvm, struct kvm_mmu_page *root,
+				 gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+
+	end = min(end, tdp_mmu_max_gfn_exclusive());
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	rcu_read_lock();
+
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * As also documented in tdp_mmu_zap_root(),
+		 * KVM must be able to zap a 1gb shadow page without
+		 * inducing a stall to allow in-place replacement with a 1gb hugepage.
+		 */
+		if (iter.gfn < start ||
+		    iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end ||
+		    iter.level > KVM_MAX_HUGEPAGE_LEVEL)
+			continue;
+
+		/* Note, a successful atomic zap also does a remote TLB flush. */
+		if (tdp_mmu_zap_spte_atomic(kvm, &iter))
+			goto retry;
+	}
+
+	rcu_read_unlock();
+}
+
+/*
+ * Zap all SPTEs for the range of gfns, [start, end), for all roots with
+ * shared mmu lock in atomic way.
+ * TLB flushs are performed within the rcu lock.
+ */
+void kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start, gfn_t end)
+{
+	struct kvm_mmu_page *root;
+
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, as_id, true)
+		zap_gfn_range_atomic(kvm, root, start, end);
+}
+
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 0a63b1afabd3..90856bd7a2fd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -22,6 +22,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
+void kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start, gfn_t end);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.17.1

