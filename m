Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228FC205BDA
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgFWTfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:11007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733309AbgFWTfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:45 -0400
IronPort-SDR: H10Jgg2UxxfeaY7xUaV/Mt4DpUyYVYice8NxIgp1SwXQRN2xZr7gPxhvWqnEGhZ5BYZBSCvGnI
 VLxyoFUAusfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="142430976"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="142430976"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:35:44 -0700
IronPort-SDR: KzHXMSfU2DHmk3eYK1ZX/Merfa9fzMuYT/5+BSbiITlLZIHTdodU9dUWHih0nr0PmCsIhgUX30
 9j6C8skSuTmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="263428296"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 12:35:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: x86/mmu: Batch zap MMU pages when shrinking the slab
Date:   Tue, 23 Jun 2020 12:35:41 -0700
Message-Id: <20200623193542.7554-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623193542.7554-1-sean.j.christopherson@intel.com>
References: <20200623193542.7554-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced kvm_mmu_zap_oldest_mmu_pages() to batch zap
MMU pages when shrinking a slab.  This fixes a long standing issue where
KVM's shrinker implementation is completely ineffective due to zapping
only a single page.  E.g. without batch zapping, forcing a scan via
drop_caches basically has no impact on a VM with ~2k shadow pages.  With
batch zapping, the number of shadow pages can be reduced to a few
hundred pages in one or two runs of drop_caches.

Note, if the default batch size (currently 128) is problematic, e.g.
zapping 128 pages holds mmu_lock for too long, KVM can bound the batch
size by setting @batch in mmu_shrinker.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c85a3a178f4..4d40b21a67bd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2825,19 +2825,6 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	}
 }
 
-static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
-					struct list_head *invalid_list)
-{
-	struct kvm_mmu_page *sp;
-
-	if (list_empty(&kvm->arch.active_mmu_pages))
-		return false;
-
-	sp = list_last_entry(&kvm->arch.active_mmu_pages,
-			     struct kvm_mmu_page, link);
-	return kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
-}
-
 static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
 						  unsigned long nr_to_zap)
 {
@@ -6125,9 +6112,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			goto unlock;
 		}
 
-		if (prepare_zap_oldest_mmu_page(kvm, &invalid_list))
-			freed++;
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
+		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
 
 unlock:
 		spin_unlock(&kvm->mmu_lock);
-- 
2.26.0

