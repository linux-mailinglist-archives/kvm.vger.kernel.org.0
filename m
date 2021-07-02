Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060393BA578
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhGBWIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:50201 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233220AbhGBWIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472759"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472759"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:27 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814825"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:27 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 45/69] KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
Date:   Fri,  2 Jul 2021 15:04:51 -0700
Message-Id: <b16bac1fd1357aaf39e425aab2177d3f89ee8318.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Return the old SPTE when clearing a SPTE and push the "old SPTE present"
check to the caller.  Private shadow page support will use the old SPTE
in rmap_remove() to determine whether or not there is a linked private
shadow page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0259781cee6a..6b0c8c84aabe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -542,9 +542,9 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
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
@@ -555,7 +555,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
-		return 0;
+		return old_spte;
 
 	pfn = spte_to_pfn(old_spte);
 
@@ -572,7 +572,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	if (is_dirty_spte(old_spte))
 		kvm_set_pfn_dirty(pfn);
 
-	return 1;
+	return old_spte;
 }
 
 /*
@@ -1104,7 +1104,9 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (mmu_spte_clear_track_bits(sptep))
+	u64 old_spte = mmu_spte_clear_track_bits(sptep);
+
+	if (is_shadow_present_pte(old_spte))
 		rmap_remove(kvm, sptep);
 }
 
-- 
2.25.1

