Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8D429CB64
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374280AbgJ0VnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:43:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:17169 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374256AbgJ0VnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:43:02 -0400
IronPort-SDR: G1BL6UqfP8e9w1uAw3pawX4/jIOer0mXCNhWKo3WWgghNBPUBZKfLEX3jzSbP6/bwEZ46M2iSN
 TfHBinkFOXIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="164667231"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="164667231"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:43:01 -0700
IronPort-SDR: xQnbAFZdcwU6l7YPlAUFUl22HWnmmfHRRxcXko/s2rlFVORmc34FIxI4Uz4/1gDt/33HytAuKQ
 VwoRw9ylPNRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="334537304"
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
Subject: [PATCH 1/3] KVM: x86/mmu: Add helper macro for computing hugepage GFN mask
Date:   Tue, 27 Oct 2020 14:42:58 -0700
Message-Id: <20201027214300.1342-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027214300.1342-1-sean.j.christopherson@intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to compute the GFN mask given a hugepage level, KVM is
accumulating quite a few users with the addition of the TDP MMU.

Note, gcc is clever enough to use a single NEG instruction instead of
SUB+NOT, i.e. use the more common "~(level -1)" pattern instead of
round_gfn_for_level()'s direct two's complement trickery.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
 arch/x86/kvm/mmu/tdp_iter.c     | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..6ea046415f29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -119,6 +119,7 @@
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
 #define KVM_PAGES_PER_HPAGE(x)	(KVM_HPAGE_SIZE(x) / PAGE_SIZE)
+#define KVM_HPAGE_GFN_MASK(x)	(~(KVM_PAGES_PER_HPAGE(x) - 1))
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17587f496ec7..3bfc7ee44e51 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2886,7 +2886,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
 						   &pfn, &level);
 
-		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = gfn & KVM_HPAGE_GFN_MASK(it.level);
 		if (it.level == level)
 			break;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..76ee36f2afd2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -698,7 +698,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
 						   &pfn, &level);
 
-		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = gw->gfn & KVM_HPAGE_GFN_MASK(it.level);
 		if (it.level == level)
 			break;
 
@@ -751,7 +751,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
 			      bool *write_fault_to_shadow_pgtable)
 {
 	int level;
-	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
+	gfn_t mask = KVM_HPAGE_GFN_MASK(walker->level);
 	bool self_changed = false;
 
 	if (!(walker->pte_access & ACC_WRITE_MASK ||
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 87b7e16911db..c6e914c96641 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -17,7 +17,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 
 static gfn_t round_gfn_for_level(gfn_t gfn, int level)
 {
-	return gfn & -KVM_PAGES_PER_HPAGE(level);
+	return gfn & KVM_HPAGE_GFN_MASK(level);
 }
 
 /*
-- 
2.28.0

