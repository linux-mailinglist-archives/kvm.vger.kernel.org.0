Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3397551C76A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383764AbiEESWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383250AbiEESTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123DC5DA5B;
        Thu,  5 May 2022 11:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774556; x=1683310556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ijQE85NEcnvtg6BiCR/pJrx1S15vRE4puZ8YRfcVbY0=;
  b=H4eP7Z/vrkfiQAxD+F/YWebAXiTWfZHHIXf8Hg3gQ3GIdaPrGIu3+wmQ
   ZPBgJXUM7Fpr87an0ydDde2Wsk5tQAGihFuw83EBUARyHVvMhLM+mcEBW
   mDus6sYY6jLz6KEJRFoaQ05UFHW8q/y/oDvPxBxFgnab5gTe2uDx/4t21
   bnz+usy6dXmpwtSEd0ILWzcgXTXY3cYpV2oMmWVl8GUsyVrFDq5aLqKn9
   RSqfgj+uYvGszWuV7buvGt+SRqoii7mVjy67kziOPWxXNdVZOulZ3PbcT
   XwdVqwJMvE/Kuc0WvyLcvkmDTSU62sq1SoiVJQgbK1eSlIVfhHq6znNux
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742026"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742026"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083279"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 041/104] KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot for private mmu
Date:   Thu,  5 May 2022 11:14:35 -0700
Message-Id: <17930cdb95783cf115239d50b5023e56b9a2b61f.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For kvm mmu that has shared bit mask, zap only leaf SPTEs when
deleting/moving a memslot.  The existing kvm_mmu_zap_memslot() depends on
role.invalid with read lock of mmu_lock so that other vcpu can operate on
kvm mmu concurrently. Mark the root page table invalid, unlink it from page
table pointer of CPU, process the page table.  It doesn't work for private
page table to unlink the root page table because it requires all SPTE entry
to be non-present.  Instead, with write-lock of mmu_lock and zap only leaf
SPTEs for kvm mmu with shared bit mask.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8a684a7b1883..96cdafae0468 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5841,11 +5841,44 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
+static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	bool flush = false;
+
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
+	 * case scenario we'll have unused shadow pages lying around until they
+	 * are recycled due to age or when the VM is destroyed.
+	 */
+	if (is_tdp_mmu_enabled(kvm)) {
+		struct kvm_gfn_range range = {
+		      .slot = slot,
+		      .start = slot->base_gfn,
+		      .end = slot->base_gfn + slot->npages,
+		      .may_block = false,
+		};
+
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
+	} else {
+		flush = slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
+					  KVM_MAX_HUGEPAGE_LEVEL, true);
+	}
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	write_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all_fast(kvm);
+	if (kvm_gfn_shared_mask(kvm))
+		kvm_mmu_zap_memslot(kvm, slot);
+	else
+		kvm_mmu_zap_all_fast(kvm);
 }
 
 int kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.25.1

