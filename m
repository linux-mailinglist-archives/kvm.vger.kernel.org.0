Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82279234CEB
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgGaVX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgGaVX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:27 -0400
IronPort-SDR: HijNdAYRtKmE9g3tcHzpEd+Rjq9M0BkBonaN4mVbjeCGUmjmX8APcbxKDtoxXg9nAiOI4uwndI
 s/umPP1CZZug==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075127"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:26 -0700
IronPort-SDR: oTBERTbqHkpkNNTA9L4r9QbNT7cLdo4vviEhrdixBuUuB1suq+jhUh48eJQdDkxK/zcCQOuEC1
 JgHtVsq6+8cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191296"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 1/8] KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
Date:   Fri, 31 Jul 2020 14:23:16 -0700
Message-Id: <20200731212323.21746-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return the old SPTE when clearing a SPTE and push the "old SPTE present"
check to the caller.  Tracking pinned SPTEs will use the old SPTE
in rmap_remove() to determine whether or not the SPTE is pinned.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 289dddff2615f..d737042fea55e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -930,9 +930,9 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
  * Rules for using mmu_spte_clear_track_bits:
  * It sets the sptep from present to nonpresent, and track the
  * state bits, it is used to clear the last level sptep.
- * Returns non-zero if the PTE was previously valid.
+ * Returns the old PTE.
  */
-static int mmu_spte_clear_track_bits(u64 *sptep)
+static u64 mmu_spte_clear_track_bits(u64 *sptep)
 {
 	kvm_pfn_t pfn;
 	u64 old_spte = *sptep;
@@ -943,7 +943,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 		old_spte = __update_clear_spte_slow(sptep, 0ull);
 
 	if (!is_shadow_present_pte(old_spte))
-		return 0;
+		return old_spte;
 
 	pfn = spte_to_pfn(old_spte);
 
@@ -960,7 +960,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	if (is_dirty_spte(old_spte))
 		kvm_set_pfn_dirty(pfn);
 
-	return 1;
+	return old_spte;
 }
 
 /*
@@ -1484,7 +1484,9 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (mmu_spte_clear_track_bits(sptep))
+	u64 old_spte = mmu_spte_clear_track_bits(sptep);
+
+	if (is_shadow_present_pte(old_spte))
 		rmap_remove(kvm, sptep);
 }
 
-- 
2.28.0

