Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805E62B4FA4
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbgKPS2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:20644 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388240AbgKPS2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:11 -0500
IronPort-SDR: qey2MVox6uZ9UYG4tY+HuK/5jCLzhPB5cyVy5rGQ6SfSB3aM+MoWyikS9hnFnoNHunB35mfC1q
 uvvuU9x8I4zw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410056"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410056"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:11 -0800
IronPort-SDR: WASFe6mo2FhvYxh/F0b5Ofn9gfH7w3BAu3djvU3vyP+KrH7KJt5Lfg0x+wet4fnioi+/z+EjN1
 TjJr7SCiz6gA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528162"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:10 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 40/67] KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
Date:   Mon, 16 Nov 2020 10:26:25 -0800
Message-Id: <4bdb2c587d917a67eecbae6f02926c31c32e3e39.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Return the old SPTE when clearing a SPTE and push the "old SPTE present"
check to the caller.  Private shadow page support will use the old SPTE
in rmap_remove() to determine whether or not there is a linked private
shadow page.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 25aafac9b5de..8d847c3abf1d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -552,9 +552,9 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
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
@@ -565,7 +565,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);
 
 	if (!is_shadow_present_pte(old_spte))
-		return 0;
+		return old_spte;
 
 	pfn = spte_to_pfn(old_spte);
 
@@ -582,7 +582,7 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
 	if (is_dirty_spte(old_spte))
 		kvm_set_pfn_dirty(pfn);
 
-	return 1;
+	return old_spte;
 }
 
 /*
@@ -1113,7 +1113,9 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (mmu_spte_clear_track_bits(sptep))
+	u64 old_spte = mmu_spte_clear_track_bits(sptep);
+
+	if (is_shadow_present_pte(old_spte))
 		rmap_remove(kvm, sptep);
 }
 
-- 
2.17.1

