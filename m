Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E82729CB68
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374310AbgJ0VnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:43:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:17169 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374255AbgJ0VnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:43:03 -0400
IronPort-SDR: vtQe7S6OjxVTlOY4aLqW2sLhQ6cY55NleS3X5S3ygGmSOjWmtiFWoKoOFbM8sYYGyHjB/ER8DX
 He47KSNQauPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="164667233"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="164667233"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:43:02 -0700
IronPort-SDR: 4D3pTCaAbcbStBM3aXVM2yVSooLxxH7sGhqVMIlsTe1BGfAeRNMkRAkgnehf0hsedgP5dXIZc4
 C2V3Ka99vpbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="334537311"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2020 14:43:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Use hugepage GFN mask to compute GFN offset mask
Date:   Tue, 27 Oct 2020 14:43:00 -0700
Message-Id: <20201027214300.1342-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027214300.1342-1-sean.j.christopherson@intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the logical NOT of KVM_HPAGE_GFN_MASK() to compute the GFN offset
mask instead of open coding the equivalent in a variety of locations.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c      | 2 +-
 arch/x86/kvm/mmu/mmutrace.h | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c  | 2 +-
 arch/x86/kvm/x86.c          | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3bfc7ee44e51..9fb50c666ec5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2827,7 +2827,7 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
 	 * the pmd can't be split from under us.
 	 */
-	mask = KVM_PAGES_PER_HPAGE(level) - 1;
+	mask = ~KVM_HPAGE_GFN_MASK(level);
 	VM_BUG_ON((gfn & mask) != (pfn & mask));
 	*pfnp = pfn & ~mask;
 
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 213699b27b44..4432ca3c7e4e 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -372,7 +372,7 @@ TRACE_EVENT(
 
 	TP_fast_assign(
 		__entry->gfn = addr >> PAGE_SHIFT;
-		__entry->pfn = pfn | (__entry->gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
+		__entry->pfn = pfn | (__entry->gfn & ~KVM_HPAGE_GFN_MASK(level));
 		__entry->level = level;
 	),
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 27e381c9da6c..681686608c0b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -209,7 +209,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
-	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
+	WARN_ON(gfn & ~KVM_HPAGE_GFN_MASK(level));
 
 	/*
 	 * If this warning were to trigger it would indicate that there was a
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..faf4c4ddde94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10451,16 +10451,16 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 
 		slot->arch.lpage_info[i - 1] = linfo;
 
-		if (slot->base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
+		if (slot->base_gfn & ~KVM_HPAGE_GFN_MASK(level))
 			linfo[0].disallow_lpage = 1;
-		if ((slot->base_gfn + npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
+		if ((slot->base_gfn + npages) & ~KVM_HPAGE_GFN_MASK(level))
 			linfo[lpages - 1].disallow_lpage = 1;
 		ugfn = slot->userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
 		 * other, disable large page support for this slot.
 		 */
-		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
+		if ((slot->base_gfn ^ ugfn) & ~KVM_HPAGE_GFN_MASK(level)) {
 			unsigned long j;
 
 			for (j = 0; j < lpages; ++j)
-- 
2.28.0

