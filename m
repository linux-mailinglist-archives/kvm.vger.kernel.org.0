Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76008205BE0
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgFWTf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:11008 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387502AbgFWTfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:45 -0400
IronPort-SDR: Q8lFbMZ7xy/EiJM7FIaf9pBZPtH7Qibg9eiEH/x0dP3ijrnUGLhZRKhUOPJoEXnqf0RfhrQocD
 7xW6KTslSi7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="142430971"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="142430971"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:35:44 -0700
IronPort-SDR: paQmTNzGnJBumOT+MUhvZ2x9BWmJndGmv2BbB6jitFmvWqLuje/y2u830LNVT9ST0JZj0z1O4/
 I5V00FXetfBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="263428292"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 12:35:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: x86/mmu: Batch zap MMU pages when recycling oldest pages
Date:   Tue, 23 Jun 2020 12:35:40 -0700
Message-Id: <20200623193542.7554-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623193542.7554-1-sean.j.christopherson@intel.com>
References: <20200623193542.7554-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Collect MMU pages for zapping in a loop when making MMU pages available,
and skip over active roots when doing so as zapping an active root can
never immediately free up a page.  Batching the zapping avoids multiple
remote TLB flushes and remedies the issue where the loop would bail
early if an active root was encountered.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e7df4ed4b55..8c85a3a178f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2838,20 +2838,51 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
 	return kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 }
 
+static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
+						  unsigned long nr_to_zap)
+{
+	unsigned long total_zapped = 0;
+	struct kvm_mmu_page *sp, *tmp;
+	LIST_HEAD(invalid_list);
+	bool unstable;
+	int nr_zapped;
+
+	if (list_empty(&kvm->arch.active_mmu_pages))
+		return 0;
+
+restart:
+	list_for_each_entry_safe(sp, tmp, &kvm->arch.active_mmu_pages, link) {
+		/*
+		 * Don't zap active root pages, the page itself can't be freed
+		 * and zapping it will just force vCPUs to realloc and reload.
+		 */
+		if (sp->root_count)
+			continue;
+
+		unstable = __kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list,
+						      &nr_zapped);
+		total_zapped += nr_zapped;
+		if (total_zapped >= nr_to_zap)
+			break;
+
+		if (unstable)
+			goto restart;
+	}
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+
+	kvm->stat.mmu_recycled += total_zapped;
+	return total_zapped;
+}
+
 static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 {
-	LIST_HEAD(invalid_list);
+	unsigned long avail = kvm_mmu_available_pages(vcpu->kvm);
 
-	if (likely(kvm_mmu_available_pages(vcpu->kvm) >= KVM_MIN_FREE_MMU_PAGES))
+	if (likely(avail >= KVM_MIN_FREE_MMU_PAGES))
 		return 0;
 
-	while (kvm_mmu_available_pages(vcpu->kvm) < KVM_REFILL_PAGES) {
-		if (!prepare_zap_oldest_mmu_page(vcpu->kvm, &invalid_list))
-			break;
-
-		++vcpu->kvm->stat.mmu_recycled;
-	}
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_zap_oldest_mmu_pages(vcpu->kvm, KVM_REFILL_PAGES - avail);
 
 	if (!kvm_mmu_available_pages(vcpu->kvm))
 		return -ENOSPC;
@@ -2864,17 +2895,12 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
  */
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
-	LIST_HEAD(invalid_list);
-
 	spin_lock(&kvm->mmu_lock);
 
 	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
-		/* Need to free some mmu pages to achieve the goal. */
-		while (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages)
-			if (!prepare_zap_oldest_mmu_page(kvm, &invalid_list))
-				break;
+		kvm_mmu_zap_oldest_mmu_pages(kvm, kvm->arch.n_used_mmu_pages -
+						  goal_nr_mmu_pages);
 
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
 	}
 
-- 
2.26.0

