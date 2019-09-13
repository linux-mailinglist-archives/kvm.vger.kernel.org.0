Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B73B1754
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfIMCqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:58611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbfIMCqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159525"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 08/11] KVM: x86/mmu: Revert "Revert "KVM: MMU: reclaim the zapped-obsolete page first""
Date:   Thu, 12 Sep 2019 19:46:09 -0700
Message-Id: <20190913024612.28392-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the fast invalidate mechanism has been reintroduced, restore
the performance tweaks for fast invalidation that existed prior to its
removal.

Paraphrashing the original changelog:

  Introduce a per-VM list to track obsolete shadow pages, i.e. pages
  which have been deleted from the mmu cache but haven't yet been freed.
  When page reclaiming is needed, zap/free the deleted pages first.

This reverts commit 52d5dedc79bdcbac2976159a172069618cf31be5.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu.c              | 22 +++++++++++++++++-----
 arch/x86/kvm/x86.c              |  1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ef378abac00f..6e4fa75351fd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -862,6 +862,7 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head zapped_obsolete_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8c0648bbc7c1..84d916674529 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5674,7 +5674,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
-	LIST_HEAD(invalid_list);
 	int nr_zapped, batch = 0;
 
 restart:
@@ -5707,8 +5706,8 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list,
-					       &nr_zapped)) {
+		if (__kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
 			batch += nr_zapped;
 			goto restart;
 		}
@@ -5719,7 +5718,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	 * KVM is not in the middle of a lockless shadow page table walk, which
 	 * may reference the pages.
 	 */
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
 
 /*
@@ -5751,6 +5750,11 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 }
 
+static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
+{
+	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
@@ -6021,16 +6025,24 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		 * want to shrink a VM that only started to populate its MMU
 		 * anyway.
 		 */
-		if (!kvm->arch.n_used_mmu_pages)
+		if (!kvm->arch.n_used_mmu_pages &&
+		    !kvm_has_zapped_obsolete_pages(kvm))
 			continue;
 
 		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 
+		if (kvm_has_zapped_obsolete_pages(kvm)) {
+			kvm_mmu_commit_zap_page(kvm,
+			      &kvm->arch.zapped_obsolete_pages);
+			goto unlock;
+		}
+
 		if (prepare_zap_oldest_mmu_page(kvm, &invalid_list))
 			freed++;
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
+unlock:
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..3d092b0f6bcb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9306,6 +9306,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
-- 
2.22.0

