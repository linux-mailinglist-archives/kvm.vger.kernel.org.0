Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CAC2203E9
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGOE13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:59540 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgGOE11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:27 -0400
IronPort-SDR: LG9/xqolDxs6T2wgjRBSwOCtXb6s7a/btCgWNS6/NlDa2194u5VQI0WwHJygYQmLwJIfJMvTzT
 JtQRMSKLFwvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936295"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:26 -0700
IronPort-SDR: XG45825FcRk1uS6H+/j/TMlWjpS9BTUauZtMIS3M1GzE3c522iNOCo/BtTS22KqOhjz6agcSoK
 VeesXwip3Pzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118778"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2020 21:27:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH 2/8] KVM: x86/mmu: Refactor the zap loop for recovering NX lpages
Date:   Tue, 14 Jul 2020 21:27:19 -0700
Message-Id: <20200715042725.10961-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the zap loop in kvm_recover_nx_lpages() to be a for loop that
iterates on to_zap and drop the !to_zap check that leads to the in-loop
calling of kvm_mmu_commit_zap_page().  The in-loop commit when to_zap
hits zero is superfluous now that there's an unconditional commit after
the loop to handle the case where lpage_disallowed_mmu_pages is emptied.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 48be51027af64..9cd3d2a23f8a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6321,7 +6321,10 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
-	while (to_zap && !list_empty(&kvm->arch.lpage_disallowed_mmu_pages)) {
+	for ( ; to_zap; --to_zap) {
+		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
+			break;
+
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
 		 * because the number of lpage_disallowed pages is expected to
@@ -6334,10 +6337,9 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 		WARN_ON_ONCE(sp->lpage_disallowed);
 
-		if (!--to_zap || need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			if (to_zap)
-				cond_resched_lock(&kvm->mmu_lock);
+			cond_resched_lock(&kvm->mmu_lock);
 		}
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-- 
2.26.0

