Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83385B174F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfIMCqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfIMCqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159521"
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
Subject: [PATCH 07/11] KVM: x86/mmu: Revert "Revert "KVM: MMU: collapse TLB flushes when zap all pages""
Date:   Thu, 12 Sep 2019 19:46:08 -0700
Message-Id: <20190913024612.28392-8-sean.j.christopherson@intel.com>
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

  Reload the mmu on all vCPUs after updating the generation number so
  that obsolete pages are not used by any vCPUs.  This allows collapsing
  all TLB flushes during obsolete page zapping into a single flush, as
  there is no need to flush when dropping mmu_lock (to reschedule).

  Note: a remote TLB flush is still needed before freeing the pages as
  other vCPUs may be doing a lockless shadow page walk.

Opportunstically improve the comments restored by the revert (the
code itself is a true revert).

This reverts commit f34d251d66ba263c077ed9d2bbd1874339a4c887.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 827414b12dbd..8c0648bbc7c1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5695,11 +5695,15 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		if (sp->role.invalid)
 			continue;
 
+		/*
+		 * No need to flush the TLB since we're only zapping shadow
+		 * pages with an obsolete generation number and all vCPUS have
+		 * loaded a new root, i.e. the shadow pages being zapped cannot
+		 * be in active use by the guest.
+		 */
 		if (batch >= BATCH_ZAP_PAGES &&
-		    (need_resched() || spin_needbreak(&kvm->mmu_lock))) {
+		    cond_resched_lock(&kvm->mmu_lock)) {
 			batch = 0;
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			cond_resched_lock(&kvm->mmu_lock);
 			goto restart;
 		}
 
@@ -5710,6 +5714,11 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		}
 	}
 
+	/*
+	 * Trigger a remote TLB flush before freeing the page tables to ensure
+	 * KVM is not in the middle of a lockless shadow page table walk, which
+	 * may reference the pages.
+	 */
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
 
@@ -5728,6 +5737,16 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	trace_kvm_mmu_zap_all_fast(kvm);
 	kvm->arch.mmu_valid_gen++;
 
+	/*
+	 * Notify all vcpus to reload its shadow page table and flush TLB.
+	 * Then all vcpus will switch to new shadow page table with the new
+	 * mmu_valid_gen.
+	 *
+	 * Note: we need to do this under the protection of mmu_lock,
+	 * otherwise, vcpu would purge shadow page but miss tlb flush.
+	 */
+	kvm_reload_remote_mmus(kvm);
+
 	kvm_zap_obsolete_pages(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
-- 
2.22.0

