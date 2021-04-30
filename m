Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4D36FE3A
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhD3QEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 12:04:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:17650 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3QEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 12:04:31 -0400
IronPort-SDR: UJnQsHN391zdL/zBJLtqcFkAFqhVvUUquOzYqfa6roFkNMhClvTkIRSPvzH/kufQ0zr4iwUvCo
 XyizDb7uy/gw==
X-IronPort-AV: E=McAfee;i="6200,9189,9970"; a="197354225"
X-IronPort-AV: E=Sophos;i="5.82,263,1613462400"; 
   d="scan'208";a="197354225"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 09:01:52 -0700
IronPort-SDR: MVaV2eEYVn773kkAXy/ucYO6x/eIC3XBGxzaqGXGrdNMj1EYCO2ZfPI+lOjr/p2IRqeZ3IB4mt
 Ms9CUDIGpgkQ==
X-IronPort-AV: E=Sophos;i="5.82,263,1613462400"; 
   d="scan'208";a="466864442"
Received: from rksparrx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.48.219])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2021 09:01:49 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: x86/mmu: Fix some return value error in kvm_tdp_mmu_map()
Date:   Sat,  1 May 2021 04:01:38 +1200
Message-Id: <20210430160138.100252-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are couple of issues in current tdp_mmu_map_handle_target_level()
regarding to return value which reflects page fault handler's behavior
-- whether it truely fixed page fault, or fault was suprious, or fault
requires emulation, etc:

1) Currently tdp_mmu_map_handle_target_level() return 0, which is
   RET_PF_RETRY, when page fault is actually fixed.  This makes
   kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
   RET_PF_FIXED.

2) When page fault is spurious, tdp_mmu_map_handle_target_level()
   currently doesn't return immediately.  This is not correct, since it
   may, for instance, lead to double emulation for a single instruction.

3) One case of spurious fault is missing: when iter->old_spte is not
   REMOVED_SPTE, but still tdp_mmu_set_spte_atomic() fails on atomic
   exchange. This case means the page fault has already been handled by
   another thread, and RET_PF_SPURIOUS should be returned. Currently
   this case is not distinguished with iter->old_spte == REMOVED_SPTE
   case, and RET_PF_RETRY is returned.

Fix 1) by initializing ret to RET_PF_FIXED at beginning. Fix 2) & 3) by
explicitly adding is_removed_spte() check at beginning, and return
RET_PF_RETRY when it is true.  For other two cases (old spte equals to
new spte, and tdp_mmu_set_spte_atomic() fails), return RET_PF_SPURIOUS
immediately.

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 84ee1a76a79d..a4dc7c9a4ebb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -905,9 +905,12 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					  kvm_pfn_t pfn, bool prefault)
 {
 	u64 new_spte;
-	int ret = 0;
+	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
+	if (is_removed_spte(iter->old_spte))
+		return RET_PF_RETRY;
+
 	if (unlikely(is_noslot_pfn(pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
@@ -916,10 +919,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
 
-	if (new_spte == iter->old_spte)
-		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
-		return RET_PF_RETRY;
+	if (new_spte == iter->old_spte ||
+			!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
+		return RET_PF_SPURIOUS;
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.30.2

