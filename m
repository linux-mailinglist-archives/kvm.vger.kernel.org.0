Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16787B174C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfIMCqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfIMCqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159518"
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
Subject: [PATCH 06/11] KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""
Date:   Thu, 12 Sep 2019 19:46:07 -0700
Message-Id: <20190913024612.28392-7-sean.j.christopherson@intel.com>
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

  Zap at least 10 shadow pages before releasing mmu_lock to reduce the
  overhead associated with re-acquiring the lock.

  Note: "10" is an arbitrary number, speculated to be high enough so
  that a vCPU isn't stuck zapping obsolete pages for an extended period,
  but small enough so that other vCPUs aren't starved waiting for
  mmu_lock.

This reverts commit 43d2b14b105fb00b8864c7b0ee7043cc1cc4a969.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0bf20afc3e73..827414b12dbd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5670,12 +5670,12 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	return alloc_mmu_pages(vcpu);
 }
 
-
+#define BATCH_ZAP_PAGES	10
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
-	int ign;
+	int nr_zapped, batch = 0;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
@@ -5688,28 +5688,6 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 			break;
 
 		/*
-		 * Do not repeatedly zap a root page to avoid unnecessary
-		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
-		 * progress:
-		 *    vcpu 0                        vcpu 1
-		 *                         call vcpu_enter_guest():
-		 *                            1): handle KVM_REQ_MMU_RELOAD
-		 *                                and require mmu-lock to
-		 *                                load mmu
-		 * repeat:
-		 *    1): zap root page and
-		 *        send KVM_REQ_MMU_RELOAD
-		 *
-		 *    2): if (cond_resched_lock(mmu-lock))
-		 *
-		 *                            2): hold mmu-lock and load mmu
-		 *
-		 *                            3): see KVM_REQ_MMU_RELOAD bit
-		 *                                on vcpu->requests is set
-		 *                                then return 1 to call
-		 *                                vcpu_enter_guest() again.
-		 *            goto repeat;
-		 *
 		 * Since we are reversely walking the list and the invalid
 		 * list will be moved to the head, skip the invalid page
 		 * can help us to avoid the infinity list walking.
@@ -5717,14 +5695,19 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		if (sp->role.invalid)
 			continue;
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (batch >= BATCH_ZAP_PAGES &&
+		    (need_resched() || spin_needbreak(&kvm->mmu_lock))) {
+			batch = 0;
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
 			cond_resched_lock(&kvm->mmu_lock);
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
+		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list,
+					       &nr_zapped)) {
+			batch += nr_zapped;
 			goto restart;
+		}
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-- 
2.22.0

